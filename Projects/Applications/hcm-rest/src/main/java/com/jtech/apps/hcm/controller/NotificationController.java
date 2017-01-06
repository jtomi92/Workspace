package com.jtech.apps.hcm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.jtech.apps.hcm.model.Notification;
import com.jtech.apps.hcm.service.NotificationService;


@Controller
public class NotificationController {

	@Autowired
	NotificationService notificationService;

	@RequestMapping(value = "/notifications/get/{userid}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<List<Notification>> getNotifications(@PathVariable("userid") Integer userId) {
		
		List<Notification> notifications = notificationService.getNotifications(userId);
		return new ResponseEntity<List<Notification>>(notifications, HttpStatus.OK);
	}
	
	@RequestMapping(value = "/notifications/add/{serial}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Integer> addNotification(@PathVariable("serial") String serialNumber, @RequestBody String notification) {
		
		Integer err = notificationService.addNotification(serialNumber, notification);
		return new ResponseEntity<Integer>(err, HttpStatus.OK);
	}
	
}
