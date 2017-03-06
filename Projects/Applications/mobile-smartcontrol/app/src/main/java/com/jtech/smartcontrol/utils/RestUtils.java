package com.jtech.smartcontrol.utils;

import android.os.AsyncTask;
import android.util.Log;

import com.jtech.smartcontrol.model.Component;
import com.jtech.smartcontrol.model.ComponentWrapper;
import com.jtech.smartcontrol.model.UserProduct;
import com.jtech.smartcontrol.model.UserProductWrapper;
import com.jtech.smartcontrol.model.UserProfile;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.http.converter.json.MappingJacksonHttpMessageConverter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.util.support.Base64;
import org.springframework.web.client.RestTemplate;


import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.logging.Logger;

/**
 * Created by tjozsa on 3/2/2017.
 */

public class RestUtils {

    //private String REST_URL = "http://10.95.99.5:8081";
    private String REST_URL = "http://192.168.0.27:8081";
    private String REST_GET_USERPROFILE_BY_NAME = REST_URL + "/userprofile/get/name/{username}/";
    private String REST_GET_COMPONENTS = REST_URL + "/mobile/components/get/{userid}/";
    private String REST_ADD_COMPONENT = REST_URL + "/mobile/component/add/{userid}/";
    private String REST_UPDATE_COMPONENT = REST_URL + "/mobile/component/update/{userid}/";
    private String REST_UPDATE_COMPONENTS = REST_URL + "/mobile/components/update/{userid}/";
    private String REST_DELETE_COMPONENT = REST_URL + "/mobile/component/delete/{userid}/{componentid}/";
    private String REST_GET_USER_PRODUCTS = REST_URL + "/product/get/{userid}/";

    private RestTemplate restTemplate = new RestTemplate();
    private String plainClientCredentials;
    private String base64ClientCredentials;

    public RestUtils(String username, String password) {
        restTemplate.getMessageConverters().add(new MappingJackson2HttpMessageConverter());
        plainClientCredentials = username + ":" + password;
        base64ClientCredentials = new String(Base64.encodeBytes(plainClientCredentials.getBytes()));
    }

    private HttpEntity<?> getHttpEntity() {
        HttpHeaders requestHeaders = getRequestHeaders();
        HttpEntity<String> httpEntity = new HttpEntity<String>(requestHeaders);
        return httpEntity;
    }

    private HttpHeaders getRequestHeaders() {
        HttpHeaders requestHeaders = new HttpHeaders();
        requestHeaders.add("Authorization", "Basic " + base64ClientCredentials);
        requestHeaders.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));
        requestHeaders.setContentType(MediaType.APPLICATION_JSON);
        return requestHeaders;
    }

    public List<UserProduct> getUserProducts(Integer userId){
        try {
            UserProductWrapper userProductWrapper = new GetUserProductsTask(userId).execute().get();
            if (userProductWrapper == null){
                return null;
            } else {
                return userProductWrapper.getUserProducts();
            }

        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Component> getComponents(Integer userId) {
        try {
            ComponentWrapper componentWrapper = new GetComponentsTask(userId).execute().get();
            if (componentWrapper == null){
                return null;
            } else {
                return componentWrapper.getComponents();
            }

        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Integer addComponent(Component component, Integer userId) {
        Integer response = 0;
        try {
            response = new AddComponentTask(component, userId).execute().get();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return response;
    }

    public Integer updateComponent(Component component, Integer userId) {
        Integer response = 0;
        try {
            response = new UpdateComponentTask(component, userId).execute().get();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return response;
    }

    public Integer updateComponents(ComponentWrapper componentWrapper, Integer userId) {
        Integer response = 0;
        try {
            response = new UpdateComponentsTask(componentWrapper, userId).execute().get();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return response;
    }

    public Integer deleteComponent(Integer componentId, Integer userId ) {
        Integer response = 0;
        try {
            response = new DeleteComponentTask(userId, componentId).execute().get();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return response;
    }

    public UserProfile getUserProfile(String userName) {
        UserProfile userProfile = null;
        try {
            userProfile = new GetUserProfileTask(userName).execute().get();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return userProfile;
    }

    private class GetUserProductsTask extends AsyncTask<Void, Void, UserProductWrapper> {

        private Integer userId;

        public GetUserProductsTask(Integer userId) {
            this.userId = userId;
        }

        @Override
        protected UserProductWrapper doInBackground(Void... params) {
            try {
                ResponseEntity<UserProductWrapper> responseEntity = restTemplate.exchange(REST_GET_USER_PRODUCTS,
                        HttpMethod.GET, getHttpEntity(), UserProductWrapper.class, userId);
                return responseEntity.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return null;
        }

        @Override
        protected void onPostExecute(UserProductWrapper componentWrapper) {
        }
    }

    private class GetComponentsTask extends AsyncTask<Void, Void, ComponentWrapper> {

        private Integer userId;

        public GetComponentsTask(Integer userId) {
            this.userId = userId;
        }

        @Override
        protected ComponentWrapper doInBackground(Void... params) {
            try {
                ResponseEntity<ComponentWrapper> responseEntity = restTemplate.exchange(REST_GET_COMPONENTS,
                        HttpMethod.GET, getHttpEntity(), ComponentWrapper.class, userId);
                return responseEntity.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return null;
        }

        @Override
        protected void onPostExecute(ComponentWrapper componentWrapper) {
        }
    }

    private class AddComponentTask extends AsyncTask<Void, Void, Integer> {

        private Component component;
        private Integer userId;

        public AddComponentTask(Component component, Integer userId) {
            this.component = component;
            this.userId = userId;
        }

        @Override
        protected Integer doInBackground(Void... params) {
            try {
                HttpEntity<Object> httpEntity = new HttpEntity<Object>(component, getRequestHeaders());
                ResponseEntity<Integer> response = restTemplate.exchange(REST_ADD_COMPONENT, HttpMethod.POST,
                        httpEntity, Integer.class, userId);
                return response.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return 0;
        }

        @Override
        protected void onPostExecute(Integer response) {
        }
    }

    private class UpdateComponentTask extends AsyncTask<Void, Void, Integer> {

        private Component component;
        private Integer userId;

        public UpdateComponentTask(Component component, Integer userId) {
            this.component = component;
            this.userId = userId;
        }

        @Override
        protected Integer doInBackground(Void... params) {
            try {
                HttpEntity<Object> httpEntity = new HttpEntity<Object>(component, getRequestHeaders());
                ResponseEntity<Integer> response = restTemplate.exchange(REST_UPDATE_COMPONENT, HttpMethod.PUT,
                        httpEntity, Integer.class, userId);
                return response.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return 0;
        }

        @Override
        protected void onPostExecute(Integer response) {
        }
    }

    private class UpdateComponentsTask extends AsyncTask<Void, Void, Integer> {

        private ComponentWrapper componentWrapper;
        private Integer userId;

        public UpdateComponentsTask(ComponentWrapper componentWrapper, Integer userId) {
            this.componentWrapper = componentWrapper;
            this.userId = userId;
        }

        @Override
        protected Integer doInBackground(Void... params) {
            try {
                HttpEntity<Object> httpEntity = new HttpEntity<Object>(componentWrapper, getRequestHeaders());
                ResponseEntity<Integer> response = restTemplate.exchange(REST_UPDATE_COMPONENTS, HttpMethod.PUT,
                        httpEntity, Integer.class, userId);
                return response.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return 0;
        }

        @Override
        protected void onPostExecute(Integer response) {
        }
    }

    private class DeleteComponentTask extends AsyncTask<Void, Void, Integer> {

        private Integer userId;
        private Integer componentId;

        public DeleteComponentTask(Integer userId, Integer componentId) {
            this.userId = userId;
            this.componentId = componentId;
        }

        @Override
        protected Integer doInBackground(Void... params) {
            try {
                ResponseEntity<Integer> responseEntity = restTemplate.exchange(REST_DELETE_COMPONENT, HttpMethod.GET, getHttpEntity(), Integer.class, userId, componentId);
                return responseEntity.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return 0;
        }

        @Override
        protected void onPostExecute(Integer response) {
        }
    }

    private class GetUserProfileTask extends AsyncTask<Void, Void, UserProfile> {

        private String userName = "";

        public GetUserProfileTask(String userName) {
            this.userName = userName;
        }

        @Override
        protected UserProfile doInBackground(Void... params) {
            try {
                ResponseEntity<UserProfile> response = restTemplate.exchange(REST_GET_USERPROFILE_BY_NAME, HttpMethod.GET, getHttpEntity(),
                        UserProfile.class, userName);
                return response.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return null;
        }

        @Override
        protected void onPostExecute(UserProfile userProfile) {
        }
    }
}
