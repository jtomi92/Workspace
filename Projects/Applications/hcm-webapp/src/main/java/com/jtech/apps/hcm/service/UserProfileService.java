package com.jtech.apps.hcm.service;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.servlet.ModelAndView;

import com.jtech.apps.hcm.form.UserForm;
import com.jtech.apps.hcm.model.UserProfile;
import com.jtech.apps.hcm.util.LocalizationUtils;
import com.jtech.apps.hcm.util.RestUtils;
import com.mysql.jdbc.StringUtils;

@Service
public class UserProfileService {

	private RestUtils restUtils = new RestUtils();
	private LocalizationUtils localizationUtils = new LocalizationUtils();
	private Logger logger = Logger.getLogger(UserProfileService.class);
	
	public ModelAndView onMyProfileOpen(ModelMap model, String locale) {

		// GET username from context
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String userName = auth.getName();

		// GET userprofile of the username
		UserProfile userProfile = restUtils.getUserProfileByUserName(userName);

		ModelAndView modelAndView = new ModelAndView("myaccount");
		modelAndView.addObject("localization", localizationUtils.getLocalization("myaccount",locale).getLocalizations());
		modelAndView.addObject("firstName", userProfile.getFirstName());
		modelAndView.addObject("lastName", userProfile.getLastName());
		modelAndView.addObject("email", userProfile.getUserName());
		modelAndView.addObject("phone", userProfile.getPhoneNumber());
		modelAndView.addObject("address", userProfile.getAddress());
		modelAndView.addObject("city", userProfile.getCity());

		return modelAndView;
	}

	public ModelAndView onSaveMyInformation(UserForm userForm, BindingResult bindingResult, Map<String, Object> model, String locale) {

		ModelAndView modelAndView = new ModelAndView("myaccount");
		HashMap<String, String> localizations = localizationUtils.getLocalization("myaccount",locale).getLocalizations();
		modelAndView.addObject("localization", localizations);
		modelAndView.addAllObjects(model);
			
		modelAndView.addObject("firstName", userForm.getFirstName());
		modelAndView.addObject("lastName", userForm.getLastName());
		modelAndView.addObject("email", userForm.getEmail());
		modelAndView.addObject("phone", userForm.getPhone());
		modelAndView.addObject("address", userForm.getAddress());
		modelAndView.addObject("city", userForm.getCity());
		
		if (StringUtils.isNullOrEmpty(userForm.getFirstName()) || userForm.getFirstName().length() >= 20){
			modelAndView.addObject("error", localizations.get("message-firstname-error"));
			return modelAndView;
		}
		if (StringUtils.isNullOrEmpty(userForm.getLastName()) || userForm.getLastName().length() >= 20){
			modelAndView.addObject("error", localizations.get("message-lastname-error"));
			return modelAndView;
		}
		if (StringUtils.isNullOrEmpty(userForm.getEmail()) || userForm.getEmail().length() >= 50){
			modelAndView.addObject("error", localizations.get("message-email-error"));
			return modelAndView;
		}
		if (StringUtils.isNullOrEmpty(userForm.getPhone()) || userForm.getPhone().length() >= 15){
			modelAndView.addObject("error", localizations.get("message-phone-error"));
			return modelAndView;
		}
		 
		// GET username from context
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String userName = auth.getName();

		// GET userprofile of the username
		UserProfile up = restUtils.getUserProfileByUserName(userName);

		UserProfile userProfile = new UserProfile();
		userProfile.setUserId(up.getUserId());
		userProfile.setFirstName(userForm.getFirstName());
		userProfile.setLastName(userForm.getLastName());
		userProfile.setUserName(userForm.getEmail());
		userProfile.setPhoneNumber(userForm.getPhone());
		userProfile.setAddress(userForm.getAddress());
		userProfile.setCity(userForm.getCity());
		userProfile.setGroupName(up.getGroupName());
		userProfile.setEnabled(true);

		if (!StringUtils.isNullOrEmpty(userForm.getOldPassword()) && userForm.getOldPassword().equals(up.getPassword())
				&& !StringUtils.isNullOrEmpty(userForm.getNewPassword())
				&& !StringUtils.isNullOrEmpty(userForm.getConfirmPassword())
				&& userForm.getNewPassword().equals(userForm.getConfirmPassword()) &&
				userForm.getNewPassword().length() >= 4) {
			userProfile.setPassword(userForm.getPassword());
			modelAndView.addObject("passwordsuccess", localizations.get("message-password-updated"));
		} else {
			userProfile.setPassword(up.getPassword());
			if (!StringUtils.isNullOrEmpty(userForm.getOldPassword())
					&& !userForm.getOldPassword().equals(up.getPassword())) {
				modelAndView.addObject("passworderror", localizations.get("message-old-password-incorrect"));
			} else if (!StringUtils.isNullOrEmpty(userForm.getOldPassword())
					&& userForm.getOldPassword().equals(up.getPassword())
					&& !userForm.getNewPassword().equals(userForm.getConfirmPassword())) {
				modelAndView.addObject("passworderror", localizations.get("message-password-not-match"));	
			} else if (!StringUtils.isNullOrEmpty(userForm.getOldPassword())){
				modelAndView.addObject("passworderror", localizations.get("message-new-password-incorrect"));	
			}
		}

		int err = restUtils.updateUserProfile(userProfile);

		if (err == 0) {
			// logger.error("Error registering user " + userForm.getEmail() + "
			// already exists");
			modelAndView.addObject("error", localizations.get("message-save-error"));
			return modelAndView;
		}
		modelAndView.addObject("success", localizations.get("message-save-success"));

		if (!up.getUserName().equals(userForm.getEmail())){
			ModelAndView mav = new ModelAndView("login");
			modelAndView.addObject("localization", localizationUtils.getLocalization("login",locale).getLocalizations());
			return mav;
		}
		return modelAndView;

	}

}
