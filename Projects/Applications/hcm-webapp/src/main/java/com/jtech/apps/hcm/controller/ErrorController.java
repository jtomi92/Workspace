package com.jtech.apps.hcm.controller;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class ErrorController implements org.springframework.boot.autoconfigure.web.ErrorController {

	private static final String PATH = "/error";
	
	@RequestMapping(value = PATH, method = RequestMethod.GET)
	public ModelAndView onErrorPage(@CookieValue(value = "locale", required = false) String locale, ModelMap model) {
		
		return new ModelAndView("error");
	}

	@Override
	public String getErrorPath() {
		return PATH;
	}	
	
}
