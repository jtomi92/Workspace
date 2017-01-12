package com.jtech.apps.hcm;

import java.io.IOException;

import com.jtech.apps.hcm.server.DeviceSessionProvider;
import com.jtech.apps.hcm.server.UserSessionProvider;
import com.jtech.apps.hcm.util.PropertiesUtil;

public class Application {

	// TODO: get these info from property file
	public static void main(String[] args) {

		PropertiesUtil propertiesUtil = new PropertiesUtil();
		try {
			DeviceSessionProvider.setDevicePort(Integer.parseInt(propertiesUtil.getProperty("deviceport")));
			DeviceSessionProvider.setConsolePort(Integer.parseInt(propertiesUtil.getProperty("consoleport")));	
			DeviceSessionProvider.setHost(propertiesUtil.getProperty("host"));

			DeviceSessionProvider.getInstance().start();
			UserSessionProvider.setPort(Integer.parseInt(propertiesUtil.getProperty("consoleport")));
			
			UserSessionProvider.getInstance().start();
			
		} catch (NumberFormatException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
