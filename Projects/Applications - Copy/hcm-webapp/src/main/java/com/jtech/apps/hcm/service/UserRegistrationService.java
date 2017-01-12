package com.jtech.apps.hcm.service;

import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;
import org.springframework.web.servlet.ModelAndView;

import com.jtech.apps.hcm.form.UserForm;
import com.jtech.apps.hcm.model.UserProfile;
import com.jtech.apps.hcm.util.Email;
import com.jtech.apps.hcm.util.LocalizationUtils;
import com.jtech.apps.hcm.util.PropertiesUtil;
import com.jtech.apps.hcm.util.RestUtils;

@Service
public class UserRegistrationService {
	private static final Logger logger = Logger.getLogger(UserRegistrationService.class);
	PropertiesUtil propertiesUtil = new PropertiesUtil();

	private final String URL = propertiesUtil.getProperty("domain");
	private RestUtils restUtils = new RestUtils();
	private LocalizationUtils localizationUtils = new LocalizationUtils();
	/**
	 * Loads UserForm to /register page
	 * 
	 * @param model
	 * @return ModelAndView
	 */
	public ModelAndView onRegisterPageLoad(Map<String, Object> model, String locale) {
		ModelAndView modelAndView = new ModelAndView("register");
		UserForm userForm = new UserForm();
		modelAndView.addObject("userForm", userForm);
		modelAndView.addObject("localization", localizationUtils.getLocalization("register",locale).getLocalizations());
		return modelAndView;
	}

	/**
	 * Registers user, validates fields
	 * 
	 * @param userForm
	 * @param bindingResult
	 * @param model
	 * @return ModelAndView
	 */
	public ModelAndView onRegisterUser(UserForm userForm, BindingResult bindingResult, Map<String, Object> model, String locale) {

		HashMap<String, String> registrationLocalization = localizationUtils.getLocalization("register",locale).getLocalizations();
		HashMap<String, String> verificationLocalization = localizationUtils.getLocalization("verification",locale).getLocalizations();
		
		ModelAndView modelAndView = new ModelAndView("register");
		modelAndView.addObject("localization", registrationLocalization);
		
		modelAndView.addAllObjects(model);
		if (bindingResult.hasErrors()) { 
			return modelAndView;
		}
			
		modelAndView = new ModelAndView("verification");
		modelAndView.addObject("localization", verificationLocalization);
		
		UserProfile userProfile = new UserProfile();
		userProfile.setFirstName(userForm.getFirstName());
		userProfile.setLastName(userForm.getLastName());
		userProfile.setUserName(userForm.getEmail());
		userProfile.setPhoneNumber(userForm.getPhone());
		userProfile.setPassword(userForm.getPassword());
		userProfile.setGroupName("USER");
		userProfile.setEnabled(false);

		String token = generateToken(30);
		userProfile.setToken(token);
	

		int err = restUtils.addUserProfile(userProfile);

		if (err == 0) {
			ModelAndView mav = new ModelAndView("register");
			mav.addObject("localization", registrationLocalization);
			mav.addAllObjects(model);
			logger.error("Error registering user " + userForm.getEmail() + " already exists");
			mav.addObject("error", registrationLocalization.get("register-error"));
			return mav;
		}
		modelAndView.addObject("success", registrationLocalization.get("register-success"));
		
		String content = registrationLocalization.get("email-content") + " <a href=\""+URL+"/register/activate/"
				+ token + "\">"+URL+"/register/activate/" + token + "</a>";

		//Email email = new Email();
		//email.send("jtomi92@gmail.com", userForm.getEmail(), registrationLocalization.get("email-title"), content);

		return modelAndView;
	}
	
	public ModelAndView onEmailVerification(String token, String locale){
		ModelAndView modelAndView = new ModelAndView("verified");
		UserProfile userProfile = restUtils.getUserProfileByToken(token);
		
		if (userProfile != null){
			userProfile.setEnabled(true);	
			restUtils.updateUserProfile(userProfile);
		}
		modelAndView.addObject("localization", localizationUtils.getLocalization("verified",locale).getLocalizations());
		return modelAndView;
	}

	/**
	 * generateSerialNumber function we use 10 char long serialNumbers generated
	 * from numbers and alphabetic characters
	 * 
	 * @param len
	 * @return String
	 */
	private String generateToken(int len) {
		String AB = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		SecureRandom rnd = new SecureRandom();

		String serialNumber = "";

		StringBuilder sb = new StringBuilder(len);
		for (int i = 0; i < len; i++)
			sb.append(AB.charAt(rnd.nextInt(AB.length())));
		serialNumber = sb.toString();

		return serialNumber;
	}
	
	

}