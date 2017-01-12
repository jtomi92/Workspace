package com.jtech.apps.hcm.util;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PropertiesUtil {
	
	private InputStream inputStream;
	private Properties properties;
	
	public String getProperty(String key){
		
		try {
		properties = new Properties();
		String propertiesFileName = "application.properties";
		
		inputStream = getClass().getClassLoader().getResourceAsStream(propertiesFileName);
		
		if (inputStream != null){
			properties.load(inputStream);
		} else {
			throw new FileNotFoundException("property file " + propertiesFileName + " not found.");
		}
		} catch (Exception e){
			
		} finally {
			if (inputStream != null){
				try {
					inputStream.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
		}
		
		return properties.getProperty(key);
	}
}
