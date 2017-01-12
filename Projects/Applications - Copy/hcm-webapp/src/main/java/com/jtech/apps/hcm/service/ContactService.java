package com.jtech.apps.hcm.service;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;
import org.springframework.web.servlet.ModelAndView;

import com.jtech.apps.hcm.form.ContactForm;
import com.jtech.apps.hcm.model.UserProfile;
import com.jtech.apps.hcm.util.LocalizationUtils;
import com.jtech.apps.hcm.util.RestUtils;
import com.mysql.jdbc.StringUtils;

@Service
public class ContactService {

	private RestUtils restUtils = new RestUtils();
	private LocalizationUtils localizationUtils = new LocalizationUtils();
	private Logger logger = Logger.getLogger(ContactService.class);

	public ModelAndView onContactRequest(Map<String, Object> model, String locale) {
		ModelAndView modelAndView = new ModelAndView("contact");

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String userName = auth.getName();

		if (!StringUtils.isNullOrEmpty(userName)) {
			UserProfile userProfile = restUtils.getUserProfileByUserName(userName);

			if (userProfile != null) {
				modelAndView.addObject("firstname", userProfile.getFirstName());
			}
		}
		ContactForm contactForm = new ContactForm();
		modelAndView.addObject("localization", localizationUtils.getLocalization("contact", locale).getLocalizations());
		modelAndView.addObject("contactForm", contactForm);

		return modelAndView;
	}

	public ModelAndView onContactSubmit(ContactForm contactForm, String locale) {

		ModelAndView modelAndViewError = new ModelAndView("contact");
		HashMap<String, String> contactFormErrorMessages = localizationUtils.getLocalization("contact-error", locale)
				.getLocalizations();
		HashMap<String, String> contactFormLocalizations = localizationUtils.getLocalization("contact", locale).getLocalizations();
		boolean isInvalid = false;

		if (StringUtils.isNullOrEmpty(contactForm.getEmail()) || !isValidEmailAddress(contactForm.getEmail())) {
			contactFormLocalizations.put("invalid-email-message", contactFormErrorMessages.get("invalid-email-message"));
			isInvalid = true;
		}
		if (StringUtils.isNullOrEmpty(contactForm.getName())) {
			contactFormLocalizations.put("invalid-name-message", contactFormErrorMessages.get("invalid-name-message"));
			isInvalid = true;
		}
		if (StringUtils.isNullOrEmpty(contactForm.getMessage())) {
			contactFormLocalizations.put("invalid-content-message", contactFormErrorMessages.get("invalid-content-message"));
			isInvalid = true;
		}
		if (isInvalid){
			modelAndViewError.addObject("localization",contactFormLocalizations);
			return modelAndViewError;
		}

		ModelAndView modelAndView = new ModelAndView("contact-success");
		modelAndView.addObject("localization",contactFormLocalizations);

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String userName = auth.getName();

		if (!StringUtils.isNullOrEmpty(userName)) {
			UserProfile userProfile = restUtils.getUserProfileByUserName(userName);

			if (userProfile != null) {
				modelAndView.addObject("firstname", userProfile.getFirstName());
			}
		}
		
		return modelAndView;
	}

	private boolean isValidEmailAddress(String email) {
		String ePattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$";
		java.util.regex.Pattern p = java.util.regex.Pattern.compile(ePattern);
		java.util.regex.Matcher m = p.matcher(email);
		return m.matches();
	}
}
