package com.jtech.apps.hcm.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.jtech.apps.hcm.model.Localization;
import com.jtech.apps.hcm.service.LocalizationService;

@Controller
public class LocalizationController {

	@Autowired
	LocalizationService localizationService;
	
	@RequestMapping(value = "/localization/{page}/{locale}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Localization> getConnection(@PathVariable("page") String page, @PathVariable("locale") String locale) {
		Localization localization = localizationService.getLocalization(page, locale);
		return new ResponseEntity<Localization>(localization, HttpStatus.OK);
	}
}
