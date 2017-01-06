package com.jtech.apps.hcm.model;

import java.util.HashMap;

public class Localization {
	
	private String page;
	private String locale;
	private HashMap<String,String> localizations;
	
	
	 
	public String getPage() {
		return page;
	}
	public void setPage(String page) {
		this.page = page;
	}
	public String getLocale() {
		return locale;
	}
	public void setLocale(String locale) {
		this.locale = locale;
	}
	public HashMap<String, String> getLocalizations() {
		return localizations;
	}
	public void setLocalizations(HashMap<String, String> localizations) {
		this.localizations = localizations;
	}
	public void addLocalization(String key, String value){
		if (localizations == null){
			localizations = new HashMap<String, String>();
		}
		localizations.put(key, value);
	}
	
	
}
