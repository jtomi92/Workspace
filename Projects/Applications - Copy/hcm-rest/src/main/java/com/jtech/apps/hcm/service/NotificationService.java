package com.jtech.apps.hcm.service;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jtech.apps.hcm.dao.NotificationDAOImpl;
import com.jtech.apps.hcm.dao.interfaces.ConnectionsDAO;
import com.jtech.apps.hcm.model.Connection;
import com.jtech.apps.hcm.model.Notification;
import com.jtech.apps.hcm.model.RelayState;
import com.jtech.apps.hcm.model.UserProduct;
import com.jtech.apps.hcm.util.TimeUtil;

@Service
public class NotificationService {

	@Autowired
	NotificationDAOImpl notificationDAOImpl;
	@Autowired
	ConnectionsDAO connectionsDAO;
	@Autowired
	UserProductService userProductService;

	private Logger logger = Logger.getLogger(NotificationService.class);

	public List<Notification> getNotifications(Integer userId) {

		List<UserProduct> userProducts = userProductService.getUserProductByUserId(userId);
		List<Notification> notificiations = new LinkedList<Notification>();

		for (UserProduct userProduct : userProducts) {

			Notification notification = new Notification(); 
			notification.setSn(userProduct.getSerialNumber());

			List<RelayState> relayStates = notificationDAOImpl.getRelayStates(userProduct.getSerialNumber(), userProduct.getProductSettings().get(0).getSettingId());
			
			DateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss", Locale.ENGLISH);
			String timeStamp = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(Calendar.getInstance().getTime());
			Date currentDate = new Date();
			try {
				currentDate = format.parse(timeStamp);
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			notification.setRs(relayStates);

			Connection connection = connectionsDAO.getConnection(userProduct.getSerialNumber());
			if (connection != null) {
				Date date = new Date();
				try {
					date = format.parse(connection.getLastUpdateDate());
					long diff = (currentDate.getTime() - date.getTime()) / 1000;

					if (diff < 3) {
						notification.setCn(connection.getStatus().equals("CONNECTED") ? 1 : 0);
					} else {
						notification.setCn(3);
					}
				} catch (ParseException e) {
					notification.setCn(3);
					e.printStackTrace();
				}
			} else {
				notification.setCn(3);
			}
			
			List<String> notificationStrings = notificationDAOImpl.getNotification(userProduct.getSerialNumber());
			if (notificationStrings != null && !notificationStrings.isEmpty()){
				notification.setNs(notificationStrings);
			}
			
			if (notification.getCn() != 3 || (notification.getRs() != null && !notification.getRs().isEmpty())){
				notificiations.add(notification);
				notificationDAOImpl.deleteNotifications(userProduct.getSerialNumber());
			}	
		}
		//if (notificiations.isEmpty()){
		//	return null;
		//}	
		
		return notificiations;
	}
	
	public Integer addNotification(String serialNumber, String notification){
		return notificationDAOImpl.addNotification(serialNumber, notification);
	}
}
