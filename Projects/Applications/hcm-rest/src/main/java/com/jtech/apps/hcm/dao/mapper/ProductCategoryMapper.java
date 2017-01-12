package com.jtech.apps.hcm.dao.mapper;


import java.util.Map;

import com.jtech.apps.hcm.model.ProductCategory;
import com.jtech.apps.hcm.model.setting.InputSetting;
import com.jtech.apps.hcm.model.setting.RelaySetting;

public class ProductCategoryMapper{

	public ProductCategory mapProductCategory(Map<String, Object> row) {

		ProductCategory productCategory = new ProductCategory();
		productCategory.setProductId((Integer) row.get("PRODUCT_ID"));
		productCategory.setProductName((String) row.get("PRODUCT_NAME"));
		productCategory.setRelayCount((Integer) row.get("RELAY_COUNT"));
		productCategory.setInputCount((Integer) row.get("INPUT_COUNT"));
		productCategory.setPrimaryHost((String) row.get("HOST1"));
		productCategory.setPrimaryPort((String) row.get("PORT1"));
		productCategory.setSecondaryHost((String) row.get("HOST2"));
		productCategory.setSecondaryPort((String) row.get("PORT2"));
		productCategory.setCreationDate((String) row.get("CREATION_DATE"));
		productCategory.setLastUpdateDate((String) row.get("LAST_UPDATE_DATE"));

		return productCategory;
	}

	public InputSetting mapInputSetting(Map<String, Object> row) {

		InputSetting inputSetting = new InputSetting();
		inputSetting.setInputId((Integer)row.get("INPUT_ID"));
		inputSetting.setInputName((String)row.get("INPUT_NAME"));
		inputSetting.setStartTimer((String)row.get("START_TIMER"));
		inputSetting.setEndTimer((String)row.get("END_TIMER"));
		inputSetting.setTimerEnabled(row.get("TIMER_ENABLED").toString().equals("Y"));
		inputSetting.setValuePostfix((String)row.get("VALUE_POSTFIX"));
		inputSetting.setSampleRate((String)row.get("SAMPLE_RATE"));
		inputSetting.setCreationDate((String)row.get("CREATION_DATE"));
		inputSetting.setLastUpdateDate((String)row.get("LAST_UPDATE_DATE"));

		return inputSetting;
	}

	public RelaySetting mapRelaySetting(Map<String, Object> row) {

		RelaySetting relaySetting = new RelaySetting();
		relaySetting.setModuleId((Integer)row.get("MODULE_ID"));
		relaySetting.setRelayId((Integer)row.get("RELAY_ID"));
		relaySetting.setRelayName((String)row.get("RELAY_NAME"));
		relaySetting.setRelayStatus((String)row.get("RELAY_STATUS"));
		relaySetting.setDelay((String)row.get("DELAY"));
		relaySetting.setRelayEnabled(row.get("RELAY_ENABLED").toString().equals("Y"));
		relaySetting.setDelayEnabled(row.get("DELAY_ENABLED").toString().equals("Y"));
		relaySetting.setImpulseMode(row.get("MODE").toString().equals("Y"));
		relaySetting.setCreationDate((String)row.get("CREATION_DATE"));
		relaySetting.setLastUpdateDate((String)row.get("LAST_UPDATE_DATE"));
		
		return relaySetting;
	}

}
