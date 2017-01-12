package com.jtech.apps.hcm.util;

import javax.mail.MessagingException;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

public class Email {

	public void send(String from, String to, String subject, String content){
		
		AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext();
		ctx.register(EmailConfiguration.class);
		ctx.refresh();
		JavaMailSenderImpl mailSender = ctx.getBean(JavaMailSenderImpl.class);
		ctx.close();
		MimeMessage message = mailSender.createMimeMessage();
		
		MimeMessageHelper mailMsg = new MimeMessageHelper(message);
		try {
			MimeBodyPart mimeBodyPart = new MimeBodyPart();
			mimeBodyPart.setContent(content, "text/html");
			MimeMultipart multipart = new MimeMultipart();
			multipart.addBodyPart(mimeBodyPart);
			
			mailMsg.setFrom(from);
			mailMsg.setTo(to);
			mailMsg.setSubject(subject);
			message.setContent(multipart);
			mailSender.send(message);
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
