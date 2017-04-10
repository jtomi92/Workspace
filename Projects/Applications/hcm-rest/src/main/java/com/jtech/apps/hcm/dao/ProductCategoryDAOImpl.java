package com.jtech.apps.hcm.dao;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import com.jtech.apps.hcm.dao.mapper.ProductCategoryMapper;
import com.jtech.apps.hcm.model.ProductCategory;
import com.jtech.apps.hcm.model.setting.InputSetting;
import com.jtech.apps.hcm.model.setting.ProductControlSetting;
import com.jtech.apps.hcm.model.setting.ProductTriggerSetting;
import com.jtech.apps.hcm.model.setting.RelaySetting;
import com.jtech.apps.hcm.util.TimeUtil;

@Repository
public class ProductCategoryDAOImpl {

	@Autowired
	JdbcTemplate jdbcTemplate;

	ProductCategoryMapper mapper = new ProductCategoryMapper();
	private NamedParameterJdbcTemplate namedParameterJdbcTemplate;

	public ProductCategory getProductCategoryBy(String entity, String value) {

		List<ProductCategory> productCategories = getProductCategories();
		ProductCategory productCategory = new ProductCategory();

		for (int index = 0; index < productCategories.size(); index++) {
			switch (entity) {
			case "PRODUCT_NAME":
				if (productCategories.get(index).getProductName().equals(value))
					return productCategories.get(index);
				break;
			case "PRODUCT_ID":
				if (productCategories.get(index).getProductId() == Integer.parseInt(value))
					return productCategories.get(index);
				break;
			default:
				break;
			}
		}
		return productCategory;
	}

	public List<ProductCategory> getProductCategories() {

		List<ProductCategory> productCategories = new LinkedList<ProductCategory>();
		String sql = "SELECT * FROM PRODUCT_CATEGORIES";

		List<Map<String, Object>> rows = new LinkedList<Map<String, Object>>();

		rows = jdbcTemplate.queryForList(sql);

		if (rows != null && !rows.isEmpty()) {
			for (Map<String, Object> row : rows) {

				ProductCategory productCategory = new ProductCategory();
				productCategory = mapper.mapProductCategory(row);

				productCategory.setRelaySettings(getRelaySettings(productCategory.getProductId()));
				productCategory.setInputSettings(getInputSettings(productCategory.getProductId()));

				productCategories.add(productCategory);
			}
		}

		return productCategories;
	}

	public List<InputSetting> getInputSettings(Integer productId) {

		List<InputSetting> inputSettings = new LinkedList<InputSetting>();
		String sql = "SELECT * FROM PRODUCT_DEFAULT_INPUT_SETTINGS WHERE PRODUCT_ID = ?";

		List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, productId);
		for (Map<String, Object> row : rows) {
			InputSetting inputSetting = new InputSetting();
			inputSetting = mapper.mapInputSetting(row);
			inputSetting.setProductTriggerSettings(new LinkedList<ProductTriggerSetting>());

			inputSettings.add(inputSetting);
		}
		return inputSettings;
	}

	public List<RelaySetting> getRelaySettings(Integer productId) {

		List<RelaySetting> relaySettings = new LinkedList<RelaySetting>();
		String sql = "SELECT * FROM PRODUCT_DEFAULT_RELAY_SETTINGS WHERE PRODUCT_ID = ?";

		List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, productId);
		for (Map<String, Object> row : rows) {
			RelaySetting relaySetting = new RelaySetting();
			relaySetting = mapper.mapRelaySetting(row);
			relaySetting.setProductControlSettings(new LinkedList<ProductControlSetting>());

			relaySettings.add(relaySetting);
		}
		return relaySettings;
	}

	public int updateProductCategory(ProductCategory pc) {

		String sql = "UPDATE PRODUCT_CATEGORIES SET " + "PRODUCT_NAME = :PRODUCT_NAME, RELAY_COUNT = :RELAY_COUNT, "
				+ "INPUT_COUNT = :INPUT_COUNT, " + "HOST1 = :HOST1, "
				+ "PORT1 = :PORT1, HOST2 = :HOST2, PORT2 = :PORT2, LAST_UPDATE_DATE = :LAST_UPDATE_DATE "
				+ "WHERE PRODUCT_ID = :PRODUCT_ID";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("PRODUCT_NAME", pc.getProductName());
		parameters.put("RELAY_COUNT", pc.getRelayCount());
		parameters.put("INPUT_COUNT", pc.getInputCount());
		parameters.put("HOST1", pc.getPrimaryHost());
		parameters.put("PORT1", pc.getPrimaryPort());
		parameters.put("HOST2", pc.getSecondaryHost());
		parameters.put("PORT2", pc.getSecondaryPort());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());
		parameters.put("PRODUCT_ID", pc.getProductId());

		for (int index = 0; index < pc.getRelaySettings().size(); index++) {
			updateRelaySetting(pc.getRelaySettings().get(index), pc.getProductId());
		}
		for (int index = 0; index < pc.getInputSettings().size(); index++) {
			updateInputSetting(pc.getInputSettings().get(index), pc.getProductId());
		}

		namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	public int updateRelaySetting(RelaySetting rs, Integer productId) {

		String sql = "UPDATE PRODUCT_DEFAULT_RELAY_SETTINGS SET "
				+ "RELAY_NAME = :RELAY_NAME, RELAY_STATUS = :RELAY_STATUS,"
				+ "DELAY = :DELAY, RELAY_ENABLED = :RELAY_ENABLED, DELAY_ENABLED = :DELAY_ENABLED, "
				+ "MODE = :MODE, LAST_UPDATE_DATE = :LAST_UPDATE_DATE "
				+ "WHERE PRODUCT_ID = :PRODUCT_ID"
				+ "AND RELAY_ID = :RELAY_ID AND MODULE_ID = :MODULE_ID";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("RELAY_NAME", rs.getRelayName());
		parameters.put("RELAY_STATUS", rs.getRelayStatus());
		parameters.put("DELAY", rs.isRelayEnabled());
		parameters.put("RELAY_ENABLED", rs.isDelayEnabled() ? "Y" : "N");
		parameters.put("DELAY_ENABLED", rs.isDelayEnabled() ? "Y" : "N");
		parameters.put("MODE", rs.isImpulseMode() ? "Y" : "N");
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());
		parameters.put("PRODUCT_ID", productId);
		parameters.put("RELAY_ID", rs.getRelayId());
		parameters.put("MODULE_ID", rs.getModuleId());

		namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	public int updateInputSetting(InputSetting is, Integer productId) {

		String sql = "UPDATE PRODUCT_DEFAULT_INPUT_SETTINGS SET " + "INPUT_NAME = :INPUT_NAME, "
				+ "START_TIMER = :START_TIMER, " + "END_TIMER = :END_TIMER, " + "TIMER_ENABLED = :TIMER_ENABLED, "
				+ "VALUE_POSTFIX = :VALUE_POSTFIX, " + "SAMPLE_RATE = :SAMPLE_RATE, "
				+ "LAST_UPDATE_DATE = :LAST_UPDATE_DATE " + "WHERE PRODUCT_ID = :PRODUCT_ID "
				+ "AND INPUT_ID = :INPUT_ID";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("INPUT_NAME", is.getInputName());
		parameters.put("START_TIMER", is.getStartTimer());
		parameters.put("END_TIMER", is.getEndTimer());
		parameters.put("TIMER_ENABLED", is.isTimerEnabled() ? "Y" : "N");
		parameters.put("VALUE_POSTFIX", is.getValuePostfix());
		parameters.put("SAMPLE_RATE", is.getSampleRate());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());
		parameters.put("PRODUCT_ID", productId);
		parameters.put("INPUT_ID", is.getInputId());

		namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	public int addProductCategory(ProductCategory productCategory) {

		List<ProductCategory> productCategories = getProductCategories();

		for (int index = 0; index < productCategories.size(); index++) {
			if (productCategories.get(index).getProductId().equals(productCategory.getProductId()))
				return 0;
		}

		String sql = "INSERT INTO PRODUCT_CATEGORIES ( " + "PRODUCT_ID, " + "PRODUCT_NAME," + "RELAY_COUNT,"
				+ "INPUT_COUNT, " + "HOST1, " + "PORT1, HOST2, PORT2, CREATION_DATE, " + "LAST_UPDATE_DATE) "
				+ "VALUES (" + ":PRODUCT_ID," + ":PRODUCT_NAME," + ":RELAY_COUNT," + ":INPUT_COUNT," + ":HOST1, "
				+ ":PORT1, :HOST2, :PORT2," + ":CREATION_DATE," + ":LAST_UPDATE_DATE)";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("PRODUCT_ID", productCategory.getProductId());
		parameters.put("PRODUCT_NAME", productCategory.getProductName());
		parameters.put("RELAY_COUNT", productCategory.getRelayCount());
		parameters.put("INPUT_COUNT", productCategory.getInputCount());
		parameters.put("HOST1", productCategory.getPrimaryHost());
		parameters.put("PORT1", productCategory.getPrimaryPort());
		parameters.put("HOST2", productCategory.getSecondaryHost());
		parameters.put("PORT2", productCategory.getSecondaryPort());

		parameters.put("CREATION_DATE", TimeUtil.getTimeStamp());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());

		for (int index = 0; index < productCategory.getRelaySettings().size(); index++) {
			addRelaySetting(productCategory.getRelaySettings().get(index), productCategory.getProductId());
		}
		for (int index = 0; index < productCategory.getInputSettings().size(); index++) {
			addInputSetting(productCategory.getInputSettings().get(index), productCategory.getProductId());
		}

		namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);

	}

	public int addRelaySetting(RelaySetting relaySetting, Integer productId) {
		String sql = "INSERT INTO PRODUCT_DEFAULT_RELAY_SETTINGS (PRODUCT_ID,"
				+ "RELAY_ID, MODULE_ID, RELAY_NAME, RELAY_STATUS, DELAY, RELAY_ENABLED,"
				+ "DELAY_ENABLED, CREATION_DATE, LAST_UPDATE_DATE) VALUES (:PRODUCT_ID,"
				+ ":RELAY_ID, :MODULE_ID, :RELAY_NAME, :RELAY_STATUS,"
				+ ":DELAY, :RELAY_ENABLED, :DELAY_ENABLED, :CREATION_DATE, :LAST_UPDATE_DATE)";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("PRODUCT_ID", productId);
		parameters.put("MODULE_ID", relaySetting.getModuleId());
		parameters.put("RELAY_ID", relaySetting.getRelayId());
		parameters.put("RELAY_NAME", relaySetting.getRelayName());
		parameters.put("RELAY_STATUS", relaySetting.getRelayStatus());
		parameters.put("DELAY", relaySetting.getDelay());
		parameters.put("RELAY_ENABLED", relaySetting.isRelayEnabled() ? "Y" : "N");
		parameters.put("DELAY_ENABLED", relaySetting.isDelayEnabled() ? "Y" : "N");
		parameters.put("CREATION_DATE", TimeUtil.getTimeStamp());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());

		namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	public int addInputSetting(InputSetting inputSetting, Integer productId) {

		String sql = "INSERT INTO PRODUCT_DEFAULT_INPUT_SETTINGS (" + "PRODUCT_ID," + "INPUT_ID,"
				+ "INPUT_NAME," + "START_TIMER," + "END_TIMER," + "TIMER_ENABLED," + "VALUE_POSTFIX," + "SAMPLE_RATE,"
				+ "CREATION_DATE," + "LAST_UPDATE_DATE) VALUES (" + ":PRODUCT_ID," + ":INPUT_ID,"
				+ ":INPUT_NAME," + ":START_TIMER," + ":END_TIMER," + ":TIMER_ENABLED," + ":VALUE_POSTFIX,"
				+ ":SAMPLE_RATE," + ":CREATION_DATE," + ":LAST_UPDATE_DATE)";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("PRODUCT_ID", productId);
		parameters.put("INPUT_ID", inputSetting.getInputId());
		parameters.put("INPUT_NAME", inputSetting.getInputName());
		parameters.put("START_TIMER", inputSetting.getStartTimer());
		parameters.put("END_TIMER", inputSetting.getEndTimer());
		parameters.put("TIMER_ENABLED", inputSetting.isTimerEnabled() ? "Y" : "N");
		parameters.put("VALUE_POSTFIX", inputSetting.getValuePostfix());
		parameters.put("SAMPLE_RATE", inputSetting.getSampleRate());
		parameters.put("CREATION_DATE", TimeUtil.getTimeStamp());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());

		namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}
}
