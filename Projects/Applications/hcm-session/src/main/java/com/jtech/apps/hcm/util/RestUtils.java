package com.jtech.apps.hcm.util;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.apache.tomcat.util.codec.binary.Base64;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import com.jtech.apps.hcm.model.Connection;
import com.jtech.apps.hcm.model.ProductCategory;
import com.jtech.apps.hcm.model.RegisteredProduct;
import com.jtech.apps.hcm.model.UserProduct;
import com.jtech.apps.hcm.model.UserProfile;

public class RestUtils {

	//private final String REST_URL = "http://localhost:8081";
	//private final String REST_URL = "http://jtech-rest-service.camayp3acx.eu-west-1.elasticbeanstalk.com";
	private final String REST_URL = getRestUrl();
			
	private final String REST_ADD_REGISTERED_PRODUCT = REST_URL + "/registeredproduct/add";
	private final String REST_GET_REGISTERED_PRODUCT_BY_SERIAL_NUMBER = REST_URL + "/registeredproduct/get/{serial}";
	private final String REST_GET_USER_PRODUCT_BY_SERIAL_NUMBER = REST_URL + "/product/get/serial/{serial}";
	private final String REST_GET_PRODUCT_CATEGORY_BY_ID = REST_URL + "/productcategory/get/id/{id}";
	private final String REST_GET_USER_PROFILE_BY_ID = REST_URL + "/userprofile/get/id/{userid}";
	private final String REST_GET_PRODUCT_CATEGORY_BY_NAME = REST_URL + "/productcategory/get/name/{id}";
	private final String REST_UPDATE_CONNECTION = REST_URL + "/connection/update";
	private final String REST_UPDATE_USER_PRODUCT = REST_URL + "/product/update";
	private final String REST_UPDATE_RELAY_STATE = REST_URL + "/product/status/update/{serial}/{moduleid}/{relayid}/{state}";
	private final String REST_ADD_PRODUCT_NOTIFICATION = REST_URL + "/notifications/add/{serial}";
	private final String REST_GET_CONNECTIONS = REST_URL + "/connection/get";
	
	RestTemplate restTemplate = new RestTemplate();	
	
	private String plainClientCredentials="jtechWebappHAXX:Psmc??.asdl123EW//";
	private String base64ClientCredentials = new String(Base64.encodeBase64(plainClientCredentials.getBytes()));
	
	private String getRestUrl(){
		PropertiesUtil propertiesUtil = new PropertiesUtil();
		try {
			return propertiesUtil.getProperty("resturl");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}
	
	public List<Connection> getConnections() {
		ParameterizedTypeReference<List<Connection>> typeRef = new ParameterizedTypeReference<List<Connection>>() {
		};
		ResponseEntity<List<Connection>> responseEntity = restTemplate.exchange(REST_GET_CONNECTIONS,
				HttpMethod.GET, getHttpEntity(), typeRef);
		return responseEntity.getBody();
	}
	
	private HttpEntity<?> getHttpEntity(){	 		
		HttpHeaders requestHeaders = getRequestHeaders();	
		HttpEntity<String> httpEntity = new HttpEntity<String>(requestHeaders);
		return httpEntity;
	}
	
	private HttpHeaders getRequestHeaders(){	 		
		HttpHeaders requestHeaders = new HttpHeaders();	
		requestHeaders.add("Authorization", "Basic " + base64ClientCredentials);
		requestHeaders.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));	
		return requestHeaders;
	}

	public Integer updateConnection(Connection connection) {

		HttpEntity<Object> httpEntity = new HttpEntity<Object>(connection, getRequestHeaders());
		ResponseEntity<Integer> response = restTemplate.exchange(REST_UPDATE_CONNECTION, HttpMethod.PUT, httpEntity,
				Integer.class);
		return response.getBody();
	}
	
	public Integer updateUserProduct(UserProduct userProduct){
		
		HttpEntity<Object> httpEntity = new HttpEntity<Object>(userProduct, getRequestHeaders());
		ResponseEntity<Integer> response = restTemplate.exchange(REST_UPDATE_USER_PRODUCT, HttpMethod.PUT, httpEntity,
				Integer.class);
		return response.getBody();
	}
	
	public Integer addRegisteredProduct(RegisteredProduct registeredProduct){
		
		HttpEntity<Object> httpEntity = new HttpEntity<Object>(registeredProduct, getRequestHeaders());
		ResponseEntity<Integer> response = restTemplate.exchange(REST_ADD_REGISTERED_PRODUCT, HttpMethod.PUT, httpEntity,
				Integer.class);
		return response.getBody();
	}
	
	public ProductCategory getProductCategoryByName(String productName) {
		ResponseEntity<ProductCategory> response = restTemplate.exchange(REST_GET_PRODUCT_CATEGORY_BY_NAME, HttpMethod.GET, getHttpEntity(),
				ProductCategory.class, productName);
		return response.getBody();
	}
	
	public Integer updateRelayState(String serialNumber, Integer moduleId, Integer relayId, Integer state){
		ResponseEntity<Integer> response = restTemplate.exchange(REST_UPDATE_RELAY_STATE, HttpMethod.GET, getHttpEntity(),
				Integer.class, serialNumber, moduleId, relayId, state);
		return response.getBody();
	}
	
	public Integer addProductNotification(String serialNumber, String notification){
		HttpEntity<Object> httpEntity = new HttpEntity<Object>(notification, getRequestHeaders());
		ResponseEntity<Integer> response = restTemplate.exchange(REST_ADD_PRODUCT_NOTIFICATION, HttpMethod.PUT, httpEntity,
				Integer.class, serialNumber);
		return response.getBody();
	}
	
	
	public RegisteredProduct getRegisteredProductBySerialNumber(String serialNumber){
		ResponseEntity<RegisteredProduct> response = restTemplate.exchange(REST_GET_REGISTERED_PRODUCT_BY_SERIAL_NUMBER, HttpMethod.GET, getHttpEntity(),
				RegisteredProduct.class, serialNumber);
		return response.getBody();
	}
	
	public UserProduct getUserProductBySerialNumber(String serialNumber){
		ResponseEntity<UserProduct> response = restTemplate.exchange(REST_GET_USER_PRODUCT_BY_SERIAL_NUMBER, HttpMethod.GET, getHttpEntity(),
				UserProduct.class, serialNumber);
		return response.getBody();
	}
	
	public UserProfile getUserProfileByUserId(Integer userId){
		ResponseEntity<UserProfile> response = restTemplate.exchange(REST_GET_USER_PROFILE_BY_ID, HttpMethod.GET, getHttpEntity(),
				UserProfile.class, userId);
		return response.getBody();
	}
	
	public ProductCategory getProductCategoryById(Integer productId){
		ResponseEntity<ProductCategory> response = restTemplate.exchange(REST_GET_PRODUCT_CATEGORY_BY_ID, HttpMethod.GET, getHttpEntity(),
				ProductCategory.class, productId);
		return response.getBody();
	}
	
	
}
