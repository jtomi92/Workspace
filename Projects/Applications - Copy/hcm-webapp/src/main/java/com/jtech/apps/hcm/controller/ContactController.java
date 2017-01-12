package com.jtech.apps.hcm.controller;

import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.jtech.apps.hcm.form.ContactForm;
import com.jtech.apps.hcm.service.ContactService;

@Controller
public class ContactController {
	
	@Autowired
	ContactService contactService;

	@RequestMapping(value = "/contact", method = RequestMethod.GET)
	public ModelAndView onContactRequest(Map<String, Object> model, @CookieValue(value = "locale", required = false) String locale) {
			
		return contactService.onContactRequest(model, locale);
	}
	
	@RequestMapping(value = "/contact", method = RequestMethod.POST)
	public ModelAndView onContactSubmit(@CookieValue(value = "locale", required = false) String locale, @ModelAttribute("contactForm") ContactForm contactForm, Map<String, Object> model) {
			
		return contactService.onContactSubmit(contactForm, locale);
	}
	
}
