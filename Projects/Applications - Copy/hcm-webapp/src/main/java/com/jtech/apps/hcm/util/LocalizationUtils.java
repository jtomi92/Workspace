package com.jtech.apps.hcm.util;

import com.jtech.apps.hcm.model.Localization;

public class LocalizationUtils {

	public Localization getLocalization(String page, String locale){
		RestUtils restUtils = new RestUtils();
		Localization localization = new Localization();
		if (locale == null){
			locale = "en";
		}
		if (locale.equalsIgnoreCase("en")){
			localization = restUtils.getLocalizationByPage(page, "en");
		} else if (locale.equalsIgnoreCase("hu")){
			localization = restUtils.getLocalizationByPage(page, "hu");
		} else {
			localization = restUtils.getLocalizationByPage(page, "en");
		}
		return localization;
	}
}
