package com.jtech.apps.hcm.controller;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.jtech.apps.hcm.model.NotificationWrapper;
import com.jtech.apps.hcm.model.UserProduct;
import com.jtech.apps.hcm.model.UserProductWrapper;
import com.jtech.apps.hcm.service.UserProductService;


@RestController
public class UserProductController {
	
	@Autowired
	UserProductService userProductService;
	
	private static final Logger logger = Logger.getLogger(UserProductController.class);
	
	@RequestMapping(value = "/product/select/{serial}/{userid}/", method = RequestMethod.GET, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Integer> selectUserProduct(@PathVariable("serial") String serialNumber, @PathVariable("userid") Integer userId) {

		int err = userProductService.selectUserProduct(serialNumber, userId);
		return new ResponseEntity<Integer>(err, HttpStatus.OK);
	} 

	@RequestMapping(value = "/product/update", method = RequestMethod.PUT, consumes = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Integer> updateUserProduct(@RequestBody UserProduct userProduct) {

		int err = userProductService.updateUserProduct(userProduct);
		return new ResponseEntity<Integer>(err, HttpStatus.OK);
	}

	@RequestMapping(value = "/product/register/{userid}/{serial}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Integer> registerProduct(@PathVariable("userid") String userId,
			@PathVariable("serial") String serialNumber) {

		int err = userProductService.registerProduct(Integer.parseInt(userId), serialNumber);		
		return new ResponseEntity<Integer>(err, HttpStatus.OK);
	}

	@RequestMapping(value = "/product/get/serial/{serial}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<UserProduct> getProductBySerialNumber(@PathVariable("serial") String serial) {

		UserProduct userProduct = userProductService.getUserProductBySerialNumber(serial);

		if (userProduct == null) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		return new ResponseEntity<UserProduct>(userProduct, HttpStatus.OK);

	}

	@RequestMapping(value = "/product/get/userid/{userid}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<List<UserProduct>> getProductByUserId(@PathVariable("userid") Integer userId) {

		List<UserProduct> userProducts = userProductService.getUserProductByUserId(userId);

		if (userProducts == null) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		return new ResponseEntity<List<UserProduct>>(userProducts, HttpStatus.OK);

	}
	
	@RequestMapping(value = "/product/get/{userid}/", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<UserProductWrapper> getProductByUserId2(@PathVariable("userid") Integer userId) {

    List<UserProduct> userProducts = userProductService.getUserProductByUserId(userId);

    if (userProducts == null) {
      return new ResponseEntity<>(HttpStatus.OK);
    }
    UserProductWrapper userProductWrapper = new UserProductWrapper();
    userProductWrapper.setUserProducts(userProducts);
    
    return new ResponseEntity<UserProductWrapper>(userProductWrapper, HttpStatus.OK);

  }

	@RequestMapping(value = "/product/get", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<List<UserProduct>> getProducts() {

		List<UserProduct> userProducts = userProductService.getUserProducts();

		if (userProducts == null) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		return new ResponseEntity<List<UserProduct>>(userProducts, HttpStatus.OK);

	}
	
	
	@RequestMapping(value = "/product/switch/{userid}/{serial}/{moduleid}/{relayid}/{state}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> switchRelay(@PathVariable("userid") Integer userId, @PathVariable("serial") String serialNumber, @PathVariable("moduleid") String moduleId, @PathVariable("relayid") String relayId, @PathVariable("state") String state) {

		String response = userProductService.switchRelay(userId,serialNumber,moduleId,relayId,state);
		return new ResponseEntity<String>(response, HttpStatus.OK);
	}
	
	@RequestMapping(value = "/product/switch/{userid}/{componentid}/{elementid}/{action}/", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<NotificationWrapper> switchRelays(@PathVariable("userid") Integer userId, @PathVariable("componentid") Integer componentId, @PathVariable("elementid") Integer elementId, @PathVariable("action") String action) {

	  NotificationWrapper notificationWrapper = userProductService.switchRelays(userId,componentId,elementId,action);
    return new ResponseEntity<NotificationWrapper>(notificationWrapper, HttpStatus.OK);
  }
	
	@RequestMapping(value = "/device/update/{userid}/{serial}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> updateUserProduct(@PathVariable("userid") Integer userId, @PathVariable("serial") String serialNumber) {
		logger.info("updateUserProduct CONTROLLER");
		String response = userProductService.update(userId, serialNumber);
		return new ResponseEntity<String>(response, HttpStatus.OK);
	} 
	
	@RequestMapping(value = "/device/restart/{userid}/{serial}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<String> restartDevice(@PathVariable("userid") Integer userId, @PathVariable("serial") String serialNumber) {
		String response = userProductService.restart(userId, serialNumber);
		return new ResponseEntity<String>(response, HttpStatus.OK);
	}
	
	@RequestMapping(value = "/product/status/get/{serial}/{relayid}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public Integer getRelayStatus(){
		
		return 1;
	}
	
	@RequestMapping(value = "/product/status/update/{serial}/{moduleid}/{relayid}/{status}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Integer> updateRelayStatus(@PathVariable("serial") String serialNumber, @PathVariable("moduleid") Integer moduleId, @PathVariable("relayid") Integer relayId, @PathVariable("status") Integer status){
		Integer err = userProductService.updateRelayStatus(serialNumber, moduleId, relayId, status);
		return new ResponseEntity<Integer>(err, HttpStatus.OK); 
	}
 
	

}
