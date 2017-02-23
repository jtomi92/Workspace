package com.jtech.apps.hcm.util;

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
import com.jtech.apps.hcm.model.Localization;
import com.jtech.apps.hcm.model.Notification;
import com.jtech.apps.hcm.model.UserProduct;
import com.jtech.apps.hcm.model.UserProfile;

public class RestUtils {
	
	private static final String REST_URL = getRestUrl();
	private final String REST_USER_PROFILE_GET_BY_NAME = REST_URL + "/userprofile/get/name/{username}/";
	private final String REST_USER_PROFILE_GET_BY_TOKEN = REST_URL + "/userprofile/get/token/{token}";
	private final String REST_UPDATE_USER_PROFILE = REST_URL + "/userprofile/update";
	private final String REST_USER_PRODUCT_GET_BY_ID = REST_URL + "/product/get/userid/{userid}";
	private final String REST_USER_PRODUCT_GET_BY_SERIAL_NUMBER = REST_URL + "/product/get/serial/{serial}";
	private final String REST_REGISTER_USER_PRODUCT = REST_URL + "/product/register/{userid}/{serial}";
	private final String REST_UPDATE_USER_PRODUCT = REST_URL + "/product/update";
	private final String REST_ADD_USER_PROFILE = REST_URL + "/userprofile/add";
	private final String REST_SWITCH_RELAY = REST_URL
			+ "/product/switch/{userid}/{serial}/{moduleid}/{relayid}/{state}";
	private final String REST_GET_CONNECTIONS = REST_URL + "/connection/get";
	private final String REST_UPDATE_DEVICE = REST_URL + "/device/update/{userid}/{serial}";
	private final String REST_RESTART_DEVICE = REST_URL + "/device/restart/{userid}/{serial}";
	private final String REST_NOTIFICATIONS_GET_BY_SERIAL = REST_URL + "/notifications/get/{userid}/";
	private final String REST_LOCALIZATIONS_GET = REST_URL + "/localization/{page}/{locale}";
	private final String REST_GET_PRODUCT_ITEM_SELECT = REST_URL + "/product/select/{serial}/{userid}/";
	
	private RestTemplate restTemplate = new RestTemplate();
	private String plainClientCredentials="jtechWebappHAXX:Psmc??.asdl123EW//";
	private String base64ClientCredentials = new String(Base64.encodeBase64(plainClientCredentials.getBytes()));
	
	private static String getRestUrl(){
		PropertiesUtil propertiesUtil = new PropertiesUtil();
		return propertiesUtil.getProperty("resturl");
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
		requestHeaders.setContentType(MediaType.APPLICATION_JSON);
		return requestHeaders;
	}
	
	public Localization getLocalizationByPage(String page, String locale) {

		ParameterizedTypeReference<Localization> typeRef = new ParameterizedTypeReference<Localization>() {
		};
		ResponseEntity<Localization> responseEntity = restTemplate.exchange(REST_LOCALIZATIONS_GET,
				HttpMethod.GET, getHttpEntity(), typeRef, page, locale); 
		Localization localization = responseEntity.getBody();

		return localization;
	}
	

	public List<UserProduct> getUserProductsByUserId(Integer userId) {

		ParameterizedTypeReference<List<UserProduct>> typeRef = new ParameterizedTypeReference<List<UserProduct>>() {
		};
		ResponseEntity<List<UserProduct>> responseEntity = restTemplate.exchange(REST_USER_PRODUCT_GET_BY_ID,
				HttpMethod.GET, getHttpEntity(), typeRef, userId);
		List<UserProduct> userProducts = responseEntity.getBody();

		return userProducts;
	}

	public UserProfile getUserProfileByUserName(String userName) {
		ResponseEntity<UserProfile> responseEntity = restTemplate.exchange(REST_USER_PROFILE_GET_BY_NAME, HttpMethod.GET, getHttpEntity(), UserProfile.class, userName);
		return responseEntity.getBody();
	}
	
	public List<Notification> getNotificationsBySerial(Integer userId) {
		ParameterizedTypeReference<List<Notification>> typeRef = new ParameterizedTypeReference<List<Notification>>() {
		};
		ResponseEntity<List<Notification>> responseEntity = restTemplate.exchange(REST_NOTIFICATIONS_GET_BY_SERIAL,
				HttpMethod.GET, getHttpEntity(), typeRef, userId);
		return responseEntity.getBody();
	}
	
	public UserProfile getUserProfileByToken(String token) {
		ResponseEntity<UserProfile> responseEntity = restTemplate.exchange(REST_USER_PROFILE_GET_BY_TOKEN, HttpMethod.GET, getHttpEntity(), UserProfile.class, token);
		return responseEntity.getBody();
	}
	
	public Integer updateUserProfile(UserProfile userProfile){
	
		HttpEntity<Object> httpEntity = new HttpEntity<Object>(userProfile, getRequestHeaders());
		ResponseEntity<Integer> response = restTemplate.exchange(REST_UPDATE_USER_PROFILE, HttpMethod.PUT,
				httpEntity, Integer.class);
		return response.getBody();
	}
	
	public Integer onProductItemSelect(String serialNumber, Integer userId){
		ResponseEntity<Integer> responseEntity = restTemplate.exchange(REST_GET_PRODUCT_ITEM_SELECT, HttpMethod.GET, getHttpEntity(), Integer.class, serialNumber, userId);
		return responseEntity.getBody();
	}

	public Integer addUserProfile(UserProfile userProfile) {
		HttpEntity<Object> httpEntity = new HttpEntity<Object>(userProfile, getRequestHeaders());
		ResponseEntity<Integer> response = restTemplate.exchange(REST_ADD_USER_PROFILE, HttpMethod.PUT,
				httpEntity, Integer.class);
		return response.getBody();
	}

	public Integer registerProduct(Integer userId, String serialNumber) {
		ResponseEntity<Integer> responseEntity = restTemplate.exchange(REST_REGISTER_USER_PRODUCT, HttpMethod.GET, getHttpEntity(), Integer.class, userId, serialNumber);
		return responseEntity.getBody();
	}

	public UserProduct getUserProductBySerialNumber(String serialNumber) {	
		ResponseEntity<UserProduct> responseEntity = restTemplate.exchange(REST_USER_PRODUCT_GET_BY_SERIAL_NUMBER, HttpMethod.GET, getHttpEntity(), UserProduct.class, serialNumber);
		return responseEntity.getBody();
	}

	public Integer updateUserProduct(UserProduct userProduct) {
		HttpEntity<Object> httpEntity = new HttpEntity<Object>(userProduct, getRequestHeaders());
		ResponseEntity<Integer> response = restTemplate.exchange(REST_UPDATE_USER_PRODUCT, HttpMethod.PUT,
				httpEntity, Integer.class);
		return response.getBody();
	}

	public String onSwitchRelay(Integer userId, String serialNumber, String moduleId, String relayId, String status) {
		ResponseEntity<String> responseEntity = restTemplate.exchange(REST_SWITCH_RELAY, HttpMethod.GET, getHttpEntity(), String.class, userId, serialNumber, moduleId, relayId, status);
		return responseEntity.getBody();
	}

	public String onUpdate(Integer userId, String serialNumber) {
		ResponseEntity<String> responseEntity = restTemplate.exchange(REST_UPDATE_DEVICE, HttpMethod.GET, getHttpEntity(), String.class, userId, serialNumber);
		return responseEntity.getBody();
	}

	public String onRestart(Integer userId, String serialNumber) {
		ResponseEntity<String> responseEntity = restTemplate.exchange(REST_RESTART_DEVICE, HttpMethod.GET, getHttpEntity(), String.class, userId, serialNumber);
		return responseEntity.getBody();
	}

	public List<Connection> getConnections() {
		ParameterizedTypeReference<List<Connection>> typeRef = new ParameterizedTypeReference<List<Connection>>() {
		};
		ResponseEntity<List<Connection>> responseEntity = restTemplate.exchange(REST_GET_CONNECTIONS,
				HttpMethod.GET, getHttpEntity(), typeRef);
		return responseEntity.getBody();
	}
}
