package com.jtech.apps.hcm.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.jtech.apps.hcm.model.UserProfile;
import com.jtech.apps.hcm.util.LocalizationUtils;
import com.jtech.apps.hcm.util.RestUtils;

@Controller
public class LoginController {
	
	private LocalizationUtils localizationUtils = new LocalizationUtils();

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logoutPage(HttpServletRequest request, HttpServletResponse response) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			request.getSession().invalidate();
			new SecurityContextLogoutHandler().logout(request, response, auth);
		}
		return "redirect:/login?logout";// You can redirect wherever you want,
										// but generally it's a good practice to
										// show login screen again.
	}

	/**
	 * both "normal login" and "login for update" shared this form.
	 *
	 */
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public ModelAndView login(@RequestParam(value = "error", required = false) String error,
			@RequestParam(value = "logout", required = false) String logout, HttpServletRequest request, @CookieValue(value = "locale", required = false) String locale) {

		ModelAndView modelAndView = new ModelAndView();

		// login form for update page
		// if login error, get the targetUrl from session again.
		String targetUrl = getRememberMeTargetUrlFromSession(request);
		if (StringUtils.hasText(targetUrl)) {
			modelAndView.addObject("targetUrl", targetUrl);
			modelAndView.addObject("loginUpdate", true);
		}

		// GET username from context
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String userName = auth.getName();

		// GET userprofile of the username
		RestUtils restUtils = new RestUtils();
		UserProfile userProfile = restUtils.getUserProfileByUserName(userName);
		if (userProfile != null) {
			modelAndView.addObject("firstname", userProfile.getFirstName());
		}

		modelAndView.setViewName("login");
		modelAndView.addObject("localization", localizationUtils.getLocalization("login",locale).getLocalizations());
		return modelAndView;

	}


	/**
	 * get targetURL from session
	 */
	private String getRememberMeTargetUrlFromSession(HttpServletRequest request) {
		String targetUrl = "";
		HttpSession session = request.getSession(false);
		if (session != null) {
			targetUrl = session.getAttribute("targetUrl") == null ? "" : session.getAttribute("targetUrl").toString();
		}
		return targetUrl;
	}
}
