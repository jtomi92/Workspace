package com.jtech.apps.hcm.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jtech.apps.hcm.dao.LocalizationDAOImpl;
import com.jtech.apps.hcm.model.Localization;

@Service
public class LocalizationService {

	@Autowired
	LocalizationDAOImpl localizationDAOImpl;

	@Transactional(readOnly=true)
	public Localization getLocalization(String page, String locale) {
		Localization wrapperLocales = localizationDAOImpl.getLocalization("wrapper", locale);
		Localization localization = localizationDAOImpl.getLocalization(page, locale);
		if (localization != null && localization.getLocalizations() != null) {
			localization.getLocalizations().putAll(wrapperLocales.getLocalizations());
		} else {
			return wrapperLocales;
		}

		return localization;
	}
}
