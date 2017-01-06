package com.jtech.apps.hcm.controller;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.jtech.apps.hcm.form.ProductForm;
import com.jtech.apps.hcm.form.ProductSettingsForm;
import com.jtech.apps.hcm.form.ProductUserForm;
import com.jtech.apps.hcm.form.RegisterForm;
import com.jtech.apps.hcm.model.Notification;
import com.jtech.apps.hcm.service.ConsoleService;

@Controller
public class ConsoleController {

	@Autowired
	ConsoleService consoleService;

	private static final Logger logger = Logger.getLogger(ConsoleController.class);
	
	@RequestMapping(value = "/console", method = RequestMethod.GET)
	public ModelAndView onConsoleOpen(@CookieValue(value = "locale", required = false) String locale, ModelMap model) {
		
		return consoleService.onConsoleOpen(model, locale);
	}	

	@RequestMapping(value = "/register", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer onRegisterProduct(@RequestBody RegisterForm registerForm) {
  
		return	consoleService.onRegisterProduct(Integer.parseInt(registerForm.getUserId()), registerForm.getSerialNumber());
	}
	
	@RequestMapping(value = "/update", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer onUpdateProductName(@RequestBody ProductForm productForm) {
		
		logger.info(productForm.getSerialNumber() + " " + productForm.getUserId() + " " + productForm.getProductName());
 	
		return consoleService.onUpdateProductName(productForm.getUserId(), productForm.getSerialNumber(), productForm.getProductName());
	}
	
	@RequestMapping(value = "/productuser/add/{userid}/{serial}/{username:.+}/", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer onInsertProductUser(@PathVariable("userid") Integer userId, @PathVariable("serial") String serialNumber, @PathVariable("username") String userName ) {
  
		logger.info(serialNumber + " " + userName);
		
		return consoleService.onInsertProductUser(userId, serialNumber, userName);
	}
	
	@RequestMapping(value = "/productuser/remove/{userid}/{serial}/{username:.+}/", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer onRemoveProductUser(@PathVariable("userid") Integer userId, @PathVariable("serial") String serialNumber, @PathVariable("username") String userName ) {
  
		logger.info(serialNumber + " " + userName);
		
		return consoleService.onRemoveProductUser(userId, serialNumber, userName);
	}
	
	@RequestMapping(value = "/productuser/update/{userid}/{serial}/{username:.+}/", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer onUpdateProductUser(@PathVariable("userid") Integer userId, @PathVariable("serial") String serialNumber, @PathVariable("username") String userName, @RequestBody ProductUserForm productUserForm  ) {
		
		return consoleService.onUpdateProductUser(userId, serialNumber, userName, productUserForm.getRelayAccess(), productUserForm.getCallAccess(), productUserForm.getPrivilige());
	}
	
	
	@RequestMapping(value = "/productsetting/update/{userid}/{serial}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer onUpdateProductSettings(@PathVariable("userid") Integer userId, @PathVariable("serial") String serialNumber,  @RequestBody ProductSettingsForm productSettingsForm) {
		 
		return consoleService.onUpdateProductSettings(userId, serialNumber, productSettingsForm);
	}
	
	@RequestMapping(value = "/productsetting/timer/add/{serial}/{moduleid}/{relayid}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer onInsertTimerSetting(@PathVariable("serial") String serialNumber, @PathVariable("moduleid") Integer moduleId, @PathVariable("relayid") Integer relayId ) {
		 
		return consoleService.onInsertTimerSetting(serialNumber, moduleId, relayId);
	}
	
	@RequestMapping(value = "/productsetting/timer/remove/{serial}/{moduleid}/{relayid}/{timerid}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer onRemoveTimerSetting(@PathVariable("serial") String serialNumber, @PathVariable("moduleid") Integer moduleId, @PathVariable("relayid") Integer relayId, @PathVariable("timerid") Integer timerId) {
		 
		return consoleService.onRemoveTimerSetting(serialNumber, moduleId, relayId, timerId);
	}
	
	@RequestMapping(value = "/relay/{userid}/{serial}/{moduleid}/{relayid}/{status}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE )
	public ResponseEntity<Map<String,String>> onRelaySwitch(@PathVariable("userid") Integer userId, @PathVariable("serial") String serialNumber,@PathVariable("moduleid") String moduleId, @PathVariable("relayid") String relayId, @PathVariable("status") String status) {
	
		String response =  consoleService.onRelaySwitch(userId, serialNumber,moduleId, relayId, status); 
		if (response == null){
			response = " ";
		}
		
		return new ResponseEntity<Map<String,String>>(Collections.singletonMap("response", response), HttpStatus.OK);
	}
	
	@RequestMapping(value = "/device/update/{userid}/{serial}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE )
	public ResponseEntity<Map<String,String>> onUpdate(@PathVariable("userid") Integer userId, @PathVariable("serial") String serialNumber) {
		logger.info("CONTROLLER. onUpdate ");
		
		String response = consoleService.onUpdate(userId, serialNumber); 
		logger.info("onUpdate response=" + response);
		if (response == null){
			response = " ";
		}
		
		return new ResponseEntity<Map<String,String>>(Collections.singletonMap("response", response), HttpStatus.OK);
	} 
	
	
	@RequestMapping(value = "/notifications/get/{userid}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<List<Notification>> onReceiveNotifications(@PathVariable("userid") Integer userId) {
		
		List<Notification> notifications = consoleService.onReceiveNotification(userId);
		return new ResponseEntity<List<Notification>>(notifications, HttpStatus.OK);
	}

	@RequestMapping(value = "/device/restart/{userid}/{serial}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE )
	@ResponseBody
	public String onRestart(@PathVariable("userid") Integer userId, @PathVariable("serial") String serialNumber){
	
		return consoleService.onRestart(userId, serialNumber); 
	}
	
}
