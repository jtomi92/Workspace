package com.jtech.apps.hcm.dao;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.jtech.apps.hcm.model.Localization;
import com.mysql.jdbc.StringUtils;

@Repository
public class LocalizationDAOImpl {

	@Autowired
	JdbcTemplate jdbcTemplate;
	private Logger logger = Logger.getLogger(NotificationDAOImpl.class);
	
	public Localization getLocalization(String page, String locale){
		
		String sql = "";
		logger.info("LOCALE IS=" + locale.toUpperCase());
		switch (locale.toUpperCase()){
		case "EN":
			sql = "SELECT STRING_KEY, EN FROM LOCALIZATIONS WHERE PAGE_NAME = ?";
			break;
		case "HU":
			sql = "SELECT STRING_KEY, HU FROM LOCALIZATIONS WHERE PAGE_NAME = ?";
			break;
		default:
			sql = "SELECT STRING_KEY, EN FROM LOCALIZATIONS WHERE PAGE_NAME = ?";
			break;
		}
		
		List<Map<String, Object>> rows = new LinkedList<Map<String, Object>>();
		
		logger.info("SQL QUERY=" + sql);
		rows = jdbcTemplate.queryForList(sql, page);
		
		Localization localization = new Localization();
		localization.setPage(page);
		localization.setLocale(locale);

		if (rows != null && !rows.isEmpty()) { 
			for (Map<String, Object> row : rows) {

				String key = (String)row.get("STRING_KEY");
				String value = "";
				switch (locale.toUpperCase()){
				case "EN":
					value = (String)row.get("EN");
					break;
				case "HU":
					value = (String)row.get("HU");
					break;
				default:
					value = (String)row.get("EN");
					break;
				}
				
				logger.info("KEY=" + key + " VALUE=" + value);

				if (!StringUtils.isNullOrEmpty(key) && !StringUtils.isNullOrEmpty(value)){
					localization.addLocalization(key, value);
				}
			}
		}
		return localization;
	}
}
