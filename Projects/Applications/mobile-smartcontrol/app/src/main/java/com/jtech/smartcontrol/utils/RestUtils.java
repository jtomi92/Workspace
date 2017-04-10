package com.jtech.smartcontrol.utils;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.util.support.Base64;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;

/**
 * Created by tjozsa on 3/2/2017.
 */

public class RestUtils {

    //private static String REST_URL = "http://10.95.99.4:8081";
    //private static String REST_URL = "http://192.168.0.27:8081";
    private static String REST_URL = "http://jtech-rest.eu-west-1.elasticbeanstalk.com";
    public static String REST_GET_USERPROFILE_BY_NAME = REST_URL + "/userprofile/get/name/{username}/";
    public static String REST_GET_COMPONENTS = REST_URL + "/mobile/components/get/{userid}/";
    public static String REST_ADD_COMPONENT = REST_URL + "/mobile/component/add/{userid}/";
    public static String REST_UPDATE_COMPONENT = REST_URL + "/mobile/component/update/{userid}/";
    public static String REST_UPDATE_COMPONENTS = REST_URL + "/mobile/components/update/{userid}/";
    public static String REST_DELETE_COMPONENT = REST_URL + "/mobile/component/delete/{userid}/{componentid}/";
    public static String REST_GET_USER_PRODUCTS = REST_URL + "/product/get/{userid}/";
    public static String REST_MULTI_SWITCH = REST_URL + "/product/switch/{userid}/{componentid}/{elementid}/{action}/";

    private static RestTemplate restTemplate = new RestTemplate();
    private static String plainClientCredentials;
    private static String base64ClientCredentials;

    public RestUtils(String username, String password) {
        restTemplate.getMessageConverters().add(new MappingJackson2HttpMessageConverter());
        plainClientCredentials = username + ":" + password;
        base64ClientCredentials = new String(Base64.encodeBytes(plainClientCredentials.getBytes()));
    }

    public static void initialize(String username, String password){
        restTemplate.getMessageConverters().add(new MappingJackson2HttpMessageConverter());
        plainClientCredentials = username + ":" + password;
        base64ClientCredentials = new String(Base64.encodeBytes(plainClientCredentials.getBytes()));
    }

    public static RestTemplate getRestTemplate(){
        return restTemplate;
    }

    public static HttpEntity<?> getHttpEntity() {
        HttpHeaders requestHeaders = getRequestHeaders();
        HttpEntity<String> httpEntity = new HttpEntity<String>(requestHeaders);
        return httpEntity;
    }

    public static HttpHeaders getRequestHeaders() {
        HttpHeaders requestHeaders = new HttpHeaders();
        requestHeaders.add("Authorization", "Basic " + base64ClientCredentials);
        requestHeaders.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));
        requestHeaders.setContentType(MediaType.APPLICATION_JSON);
        return requestHeaders;
    }
}
