package com.jtech.apps.hcm;
 

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.web.SpringBootServletInitializer;

import com.jtech.apps.hcm.hostprovider.HostProvider;

@SpringBootApplication
public class Application extends SpringBootServletInitializer {
 	 
	public static void main(String[] args) {
	
		HostProvider hostProvider = new HostProvider(2088);
		Thread thread = new Thread(hostProvider);
		thread.start();
		
 		SpringApplication.run(Application.class, args);	
	}
	
 
}
