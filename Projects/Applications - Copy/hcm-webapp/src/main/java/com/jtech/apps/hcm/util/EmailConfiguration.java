package com.jtech.apps.hcm.util;

import java.util.Properties;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSenderImpl;

@Configuration
public class EmailConfiguration {
	
	@Bean
	public JavaMailSenderImpl javaMailSenderImpl(){
		JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
		mailSender.setHost("email-smtp.eu-west-1.amazonaws.com");
		mailSender.setPort(25);
		//Set gmail email id
		mailSender.setUsername("AKIAJNALMJFL3UEBUS2A");
		//Set gmail email password
		mailSender.setPassword("Ar+3UC4wbN4p40pAecyw+d8tWE7HCFeLefOS0aUblqLW");
		Properties prop = mailSender.getJavaMailProperties();
		prop.put("mail.transport.protocol", "smtp");
		prop.put("mail.smtp.auth", "true");
		prop.put("mail.smtp.starttls.required", "true");
		prop.put("mail.smtp.starttls.enable", "true");
		prop.put("mail.debug", "true");
		prop.put("mail.smtp.socketFactory.fallback", "true");
		return mailSender;
	}
}
