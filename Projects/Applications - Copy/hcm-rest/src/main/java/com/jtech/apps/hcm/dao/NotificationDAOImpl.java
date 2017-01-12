package com.jtech.apps.hcm.dao;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;
import com.jtech.apps.hcm.model.RelayState;
import com.jtech.apps.hcm.util.TimeUtil;

@Repository
public class NotificationDAOImpl {

	@Autowired
	JdbcTemplate jdbcTemplate;
	private NamedParameterJdbcTemplate namedParameterJdbcTemplate;
	private Logger logger = Logger.getLogger(NotificationDAOImpl.class);
	
	public List<RelayState> getRelayStates(String serialNumber, Integer settingId){
		
		String sql = "SELECT * FROM USER_PRODUCT_RELAY_SETTINGS WHERE SERIAL_NUMBER = ? AND SETTING_ID = ? AND LAST_UPDATE_DATE >= ?";
		List<RelayState> relayStates = new LinkedList<RelayState>();
		List<Map<String, Object>> rows = new LinkedList<Map<String, Object>>();
		rows = jdbcTemplate.queryForList(sql, serialNumber, settingId, TimeUtil.getTimeStampWithDifference(3));

		if (rows != null && !rows.isEmpty()) { 
			for (Map<String, Object> row : rows) {
				RelayState relayState = new RelayState();
				relayState.setMi((Integer)row.get("MODULE_ID"));
				relayState.setRi((Integer)row.get("RELAY_ID"));
				
				if (row.get("RELAY_STATUS") != null){
					relayState.setSw(row.get("RELAY_STATUS").equals("Y") ? 1 : 0);
				} else {
					relayState.setSw(0);
				}
				relayStates.add(relayState);
			}
		}
		return relayStates;
	}
	
	public Integer addNotification(String serialNumber, String notification){
		String sql = "INSERT INTO USER_PRODUCT_NOTIFICATIONS (SERIAL_NUMBER, NOTIFICATION, CREATION_DATE) VALUES (:SERIAL_NUMBER, :NOTIFICATION, :CREATION_DATE)";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("NOTIFICATION", notification);
		parameters.put("CREATION_DATE", TimeUtil.getTimeStamp());


		namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}
	
	public List<String> getNotification(String serialNumber){
		String sql = "SELECT * FROM USER_PRODUCT_NOTIFICATIONS WHERE SERIAL_NUMBER = ? AND CREATION_DATE >= ?";
		List<String> notifications = new LinkedList<>();
		List<Map<String, Object>> rows = new LinkedList<Map<String, Object>>();
		
		//logger.info("Current Time=" + TimeUtil.getTimeStamp() + "\n" + "TimeWithDifference=" + TimeUtil.getTimeStampWithDifference(3));
		rows = jdbcTemplate.queryForList(sql, serialNumber, TimeUtil.getTimeStampWithDifference(3));
		logger.info("getNotification SIZE=" + rows.size());
		if (rows != null && !rows.isEmpty()) { 
			for (Map<String, Object> row : rows) {
				String notification = ((String)row.get("NOTIFICATION"));
				notifications.add(notification);
				logger.info("Notification added:" + notification);
			}
		}
		return notifications;
	}
	
	public Integer deleteNotifications(String serialNumber){
		String sql = "DELETE FROM USER_PRODUCT_NOTIFICATIONS WHERE SERIAL_NUMBER = :SERIAL_NUMBER AND CREATION_DATE <= :CREATION_DATE";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("CREATION_DATE", TimeUtil.getTimeStampWithDifference(15));

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
		
		
		
		
	}
	
}
