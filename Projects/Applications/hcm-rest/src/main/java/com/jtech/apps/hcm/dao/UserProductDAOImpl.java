package com.jtech.apps.hcm.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import com.jtech.apps.hcm.dao.interfaces.UserProductDAO;
import com.jtech.apps.hcm.dao.mapper.UserProductMapper;
import com.jtech.apps.hcm.model.UserProduct;
import com.jtech.apps.hcm.model.setting.InputSetting;
import com.jtech.apps.hcm.model.setting.ProductControlSetting;
import com.jtech.apps.hcm.model.setting.ProductTriggerSetting;
import com.jtech.apps.hcm.model.setting.ProductUser;
import com.jtech.apps.hcm.model.setting.RelaySetting;
import com.jtech.apps.hcm.model.setting.TimerSetting;
import com.jtech.apps.hcm.util.TimeUtil;

@Repository
public class UserProductDAOImpl implements UserProductDAO {

	@Autowired
	JdbcTemplate jdbcTemplate;

	UserProductMapper mapper = new UserProductMapper();

	private final Logger logger = Logger.getLogger(UserProductDAO.class);

	@Override
	public int addUserProduct(UserProduct userProduct) {

		String sql = "INSERT INTO USER_PRODUCTS ( SERIAL_NUMBER, NAME, PHONE_NUMBER, HOST1, "
				+ "PORT1, HOST2, PORT2, EDITED, CREATION_DATE, LAST_UPDATE_DATE) VALUES ( :SERIAL_NUMBER, :NAME,"
				+ ":PHONE_NUMBER, :HOST1, :PORT1, :HOST2, :PORT2, :EDITED, :CREATION_DATE, :LAST_UPDATE_DATE)";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", userProduct.getSerialNumber());
		parameters.put("NAME", userProduct.getName());
		parameters.put("PHONE_NUMBER", userProduct.getPhoneNumber());
		parameters.put("HOST1", userProduct.getPrimaryHost());
		parameters.put("PORT1", userProduct.getPrimaryPort());
		parameters.put("HOST2", userProduct.getSecondaryHost());
		parameters.put("PORT2", userProduct.getSecondaryPort());
		parameters.put("EDITED", "Y");
		parameters.put("CREATION_DATE", TimeUtil.getTimeStamp());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());

		for (RelaySetting relaySetting : userProduct.getRelaySettings()) {
			addUserProductRelaySetting(relaySetting, userProduct.getSerialNumber());
		}
		for (InputSetting inputSetting : userProduct.getInputSettings()) {
			addUserProductInputSetting(inputSetting, userProduct.getSerialNumber());
		}

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		int err = namedParameterJdbcTemplate.update(sql, namedParameters);

		for (ProductUser productUser : userProduct.getProductUsers()) {
			err = addProductUser(productUser, userProduct.getSerialNumber());
		}

		return err;
	}

	public int addProductUser(ProductUser productUser, String serialNumber) {

		String sql = "INSERT INTO USER_PRODUCT_GROUPS (GROUP_ID, USER_ID, PRIVILIGE_ID, SELECTED) VALUES ((SELECT GROUP_ID FROM USER_PRODUCTS WHERE SERIAL_NUMBER = :SERIAL_NUMBER), (SELECT USER_ID FROM USER_PROFILES WHERE USER_NAME = :USER_NAME), (SELECT PRIVILIGE_ID FROM USER_PRODUCT_PRIVILIGES WHERE PRIVILIGE_NAME = :PRIVILIGE_NAME), :SELECTED)";

		logger.info("USERNAME=" + productUser.getUserName() + " (" + productUser.getUserId() + ")");
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("USER_NAME", productUser.getUserName());
		parameters.put("PRIVILIGE_NAME", productUser.getPrivilige());
		parameters.put("SELECTED", productUser.isSelected() ? "Y" : "N");

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	public int deleteProductUsers(String serialNumber) {

		String sql = "DELETE FROM USER_PRODUCT_GROUPS WHERE GROUP_ID = "
				+ "(SELECT GROUP_ID FROM USER_PRODUCTS WHERE SERIAL_NUMBER = :SERIAL_NUMBER)";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	@Override
	public int addUserProductRelaySetting(RelaySetting relaySetting, String serialNumber) {

		String sql = "INSERT INTO USER_PRODUCT_RELAY_SETTINGS (" + "SERIAL_NUMBER," + "RELAY_ID, MODULE_ID,"
				+ "RELAY_NAME, RELAY_STATUS, DELAY, RELAY_ENABLED, DELAY_ENABLED, MODE, CREATION_DATE,"
				+ "LAST_UPDATE_DATE) VALUES (:SERIAL_NUMBER," + ":RELAY_ID, :MODULE_ID,"
				+ ":RELAY_NAME, :RELAY_STATUS, :DELAY, :RELAY_ENABLED, :DELAY_ENABLED, :MODE, :CREATION_DATE,"
				+ ":LAST_UPDATE_DATE)";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("RELAY_ID", relaySetting.getRelayId());
		parameters.put("MODULE_ID", relaySetting.getModuleId());
		parameters.put("RELAY_STATUS", relaySetting.getRelayStatus());
		parameters.put("RELAY_NAME", relaySetting.getRelayName());
		parameters.put("DELAY", relaySetting.getDelay());
		parameters.put("MODE", relaySetting.isImpulseMode() ? "Y" : "N");
		parameters.put("RELAY_ENABLED", relaySetting.isRelayEnabled() ? "Y" : "N");
		parameters.put("DELAY_ENABLED", relaySetting.isDelayEnabled() ? "Y" : "N");
		parameters.put("CREATION_DATE", TimeUtil.getTimeStamp());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());

		deleteUserProductControlSettings(serialNumber, relaySetting.getRelayId(), relaySetting.getModuleId());
		List<ProductControlSetting> productControlSettings = relaySetting.getProductControlSettings();
		if (productControlSettings != null) {
			for (ProductControlSetting productControlSetting : productControlSettings) {
				addUserProductControlSetting(productControlSetting, serialNumber, relaySetting.getRelayId(),
						relaySetting.getModuleId());
			}
		}
		deleteUserProductTimerSettings(serialNumber, relaySetting.getRelayId(), relaySetting.getModuleId());
		List<TimerSetting> timerSettings = relaySetting.getTimerSettings();
		if (timerSettings != null) {
			for (TimerSetting timerSetting : timerSettings) {
				addUserProductTimerSetting(timerSetting, serialNumber, relaySetting.getRelayId(),
						relaySetting.getModuleId(), timerSetting.getTimerId());
			}
		}

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	@Override
	public int addUserProductInputSetting(InputSetting inputSetting, String serialNumber) {

		String sql = "INSERT INTO USER_PRODUCT_INPUT_SETTINGS (" + "SERIAL_NUMBER," + "INPUT_ID," + "INPUT_NAME,"
				+ "START_TIMER," + "END_TIMER," + "TIMER_ENABLED," + "VALUE_POSTFIX," + "SAMPLE_RATE,"
				+ "CREATION_DATE," + "LAST_UPDATE_DATE) VALUES (" + ":SERIAL_NUMBER," + ":INPUT_ID," + ":INPUT_NAME,"
				+ ":START_TIMER," + ":END_TIMER," + ":TIMER_ENABLED," + ":VALUE_POSTFIX," + ":SAMPLE_RATE,"
				+ ":CREATION_DATE," + ":LAST_UPDATE_DATE)";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("INPUT_ID", inputSetting.getInputId());
		parameters.put("INPUT_NAME", inputSetting.getInputName());
		parameters.put("START_TIMER", inputSetting.getStartTimer());
		parameters.put("END_TIMER", inputSetting.getEndTimer());
		parameters.put("TIMER_ENABLED", inputSetting.isTimerEnabled() ? "Y" : "N");
		parameters.put("VALUE_POSTFIX", inputSetting.getValuePostfix());
		parameters.put("SAMPLE_RATE", inputSetting.getSampleRate());
		parameters.put("CREATION_DATE", TimeUtil.getTimeStamp());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	@Override
	public int addUserProductControlSetting(ProductControlSetting pcs, String serialNumber, Integer relayId,
			Integer moduleId) {

		String sql = "INSERT INTO USER_PRODUCT_CONTROL_SETTINGS (" + "SERIAL_NUMBER," + "RELAY_ID, MODULE_ID,"
				+ "USER_ID," + "HAS_ACCESS," + "CALL_ACCESS," + "CREATION_DATE," + "LAST_UPDATE_DATE) VALUES ("
				+ ":SERIAL_NUMBER," + ":RELAY_ID," + ":MODULE_ID, :USER_ID," + ":HAS_ACCESS," + ":CALL_ACCESS,"
				+ ":CREATION_DATE," + ":LAST_UPDATE_DATE)";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("RELAY_ID", relayId);
		parameters.put("MODULE_ID", moduleId);
		parameters.put("USER_ID", pcs.getUserId());
		parameters.put("HAS_ACCESS", pcs.isAccess() ? "Y" : "N");
		parameters.put("CALL_ACCESS", pcs.isCallAccess() ? "Y" : "N");
		parameters.put("CREATION_DATE", TimeUtil.getTimeStamp());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	public int addUserProductTimerSetting(TimerSetting timerSetting, String serialNumber, Integer relayId,
			Integer moduleId, Integer timerId) {

		String sql = "INSERT INTO USER_PRODUCT_TIMER_SETTINGS (SERIAL_NUMBER,"
				+ "MODULE_ID, RELAY_ID, TIMER_ID, START_WEEKDAYS, END_WEEKDAYS, START_TIMER, END_TIMER, TIMER_ENABLED, CREATION_DATE, LAST_UPDATE_DATE) VALUES (:SERIAL_NUMBER,"
				+ ":MODULE_ID, :RELAY_ID, :TIMER_ID, :START_WEEKDAYS, :END_WEEKDAYS, :START_TIMER, :END_TIMER, :TIMER_ENABLED, :CREATION_DATE, :LAST_UPDATE_DATE)";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("RELAY_ID", relayId);
		parameters.put("MODULE_ID", moduleId);
		parameters.put("TIMER_ID", timerId);
		parameters.put("START_WEEKDAYS", timerSetting.getStartWeekDays());
		parameters.put("END_WEEKDAYS", timerSetting.getEndWeekDays());
		parameters.put("START_TIMER", timerSetting.getStartTimer());
		parameters.put("END_TIMER", timerSetting.getEndTimer());
		parameters.put("TIMER_ENABLED", timerSetting.isTimerEnabled() ? "Y" : "N");
		parameters.put("CREATION_DATE", TimeUtil.getTimeStamp());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	@Override
	public int addUserProductTriggerSetting(ProductTriggerSetting pts, String serialNumber, Integer inputId) {

		String sql = "INSERT INTO USER_PRODUCT_TRIGGER_SETTINGS (" + "SERIAL_NUMBER," + "INPUT_ID," + "TRIGGER_ID,"
				+ "TRIGGER_RELAY_ID," + "TRIGGER_ENABLED," + "TRIGGER_VALUE," + "TRIGGER_STATE," + "TRIGGER_ACTION,"
				+ "LAST_UPDATE_DATE) VALUES (" + ":SERIAL_NUMBER," + ":INPUT_ID," + ":TRIGGER_ID,"
				+ ":TRIGGER_RELAY_ID," + ":TRIGGER_ENABLED," + ":TRIGGER_VALUE," + ":TRIGGER_STATE,"
				+ ":TRIGGER_ACTION," + ":LAST_UPDATE_DATE)";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("INPUT_ID", inputId);
		parameters.put("TRIGGER_ID", pts.getTriggerId());
		parameters.put("TRIGGER_RELAY_ID", pts.getTriggerRelayId());
		parameters.put("TRIGGER_ENABLED", pts.isTriggerEnabled() ? "Y" : "N");
		parameters.put("TRIGGER_VALUE", pts.getTriggerValue());
		parameters.put("TRIGGER_STATE", pts.getTriggerState());
		parameters.put("TRIGGER_ACTION", pts.getTriggerAction());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	@Override
	public List<UserProduct> getUserProducts() {

		String sql = "SELECT * FROM USER_PRODUCTS";
		List<UserProduct> userProducts = new LinkedList<UserProduct>();
		List<Map<String, Object>> rows = new LinkedList<Map<String, Object>>();

		rows = jdbcTemplate.queryForList(sql);

		if (rows != null && !rows.isEmpty()) {
			for (Map<String, Object> row : rows) {

				UserProduct userProduct = new UserProduct();
				userProduct = mapper.mapUserProduct(row);

				userProduct.setRelaySettings(getRelaySettings(userProduct.getSerialNumber()));
				userProduct.setInputSettings(getInputSettings(userProduct.getSerialNumber()));
				userProduct.setProductUsers(getProductUsers(userProduct.getSerialNumber()));

				userProducts.add(userProduct);
			}
		}

		return userProducts;
	}

	@Override
	public UserProduct getUserProductBySerialNumber(String serialNumber) {

		String sql = "SELECT * FROM USER_PRODUCTS WHERE SERIAL_NUMBER = ?";

		UserProduct userProduct = jdbcTemplate.queryForObject(sql, new Object[] { serialNumber },
				new RowMapper<UserProduct>() {

					@Override
					public UserProduct mapRow(ResultSet row, int arg1) throws SQLException {
						UserProduct userProduct = new UserProduct();
						userProduct.setSerialNumber(row.getString("SERIAL_NUMBER"));
						userProduct.setName(row.getString("NAME"));
						userProduct.setPhoneNumber(row.getString("PHONE_NUMBER"));
						userProduct.setPrimaryHost(row.getString("HOST1"));
						userProduct.setPrimaryPort(row.getString("PORT1"));
						userProduct.setSecondaryHost(row.getString("HOST2"));
						userProduct.setSecondaryPort(row.getString("PORT2"));
						userProduct.setEdited(row.getString("EDITED").equals("Y"));
						userProduct.setCreationDate(row.getString("CREATION_DATE"));
						userProduct.setLastUpdateDate(row.getString("LAST_UPDATE_DATE"));

						return userProduct;
					}
				});

		if (userProduct != null) {
			userProduct.setRelaySettings(getRelaySettings(userProduct.getSerialNumber()));
			userProduct.setInputSettings(getInputSettings(userProduct.getSerialNumber()));
			userProduct.setProductUsers(getProductUsers(userProduct.getSerialNumber()));
		}

		return userProduct;
	}

	@Override
	public List<UserProduct> getUserProductsByUserId(Integer userId) {

		String sql = "SELECT * FROM USER_PRODUCTS WHERE GROUP_ID IN (SELECT GROUP_ID FROM USER_PRODUCT_GROUPS WHERE USER_ID = ?);";
		List<UserProduct> userProducts = new LinkedList<UserProduct>();
		List<Map<String, Object>> rows = new LinkedList<Map<String, Object>>();

		rows = jdbcTemplate.queryForList(sql, userId);

		if (rows != null && !rows.isEmpty()) {
			for (Map<String, Object> row : rows) {

				UserProduct userProduct = new UserProduct();
				userProduct = mapper.mapUserProduct(row);

				userProduct.setRelaySettings(getRelaySettings(userProduct.getSerialNumber()));
				userProduct.setInputSettings(getInputSettings(userProduct.getSerialNumber()));
				userProduct.setProductUsers(getProductUsers(userProduct.getSerialNumber()));

				userProducts.add(userProduct);
			}
		}

		return userProducts;
	}

	public List<ProductUser> getProductUsers(String serialNumber) {

		String sql = "SELECT PR.USER_ID, PR.USER_NAME, UPP.PRIVILIGE_NAME, UPG.SELECTED "
				+ "FROM USER_PRODUCTS UP, USER_PRODUCT_GROUPS UPG, USER_PRODUCT_PRIVILIGES UPP, USER_PROFILES PR "
				+ "WHERE UP.SERIAL_NUMBER = ? " + "AND UPG.GROUP_ID = UP.GROUP_ID "
				+ "AND UPP.PRIVILIGE_ID = UPG.PRIVILIGE_ID " + "AND PR.USER_ID = UPG.USER_ID";

		List<ProductUser> productUsers = new LinkedList<ProductUser>();

		List<Map<String, Object>> rows = new LinkedList<Map<String, Object>>();

		rows = jdbcTemplate.queryForList(sql, serialNumber);

		if (rows != null && !rows.isEmpty()) {
			for (Map<String, Object> row : rows) {

				ProductUser productUser = new ProductUser();
				productUser.setPrivilige((String) row.get("PRIVILIGE_NAME"));
				productUser.setUserName((String) row.get("USER_NAME"));
				productUser.setUserId((Integer) row.get("USER_ID"));
				productUser.setSelected(row.get("SELECTED").equals("Y"));
				productUsers.add(productUser);
			}
		}

		return productUsers;
	}

	@Override
	public List<RelaySetting> getRelaySettings(String serialNumber) {

		List<RelaySetting> relaySettings = new LinkedList<RelaySetting>();
		String sql = "SELECT * FROM USER_PRODUCT_RELAY_SETTINGS WHERE SERIAL_NUMBER = ? ORDER BY MODULE_ID, RELAY_ID";

		List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, serialNumber);
		for (Map<String, Object> row : rows) {
			RelaySetting relaySetting = new RelaySetting();
			relaySetting = mapper.mapRelaySetting(row);
			relaySetting.setProductControlSettings(
					getUserProductControlSettings(serialNumber, relaySetting.getRelayId(), relaySetting.getModuleId()));
			relaySetting.setTimerSettings(
					getUserProductTimerSettings(serialNumber, relaySetting.getRelayId(), relaySetting.getModuleId()));
			relaySettings.add(relaySetting);
		}
		return relaySettings;
	}

	@Override
	public List<InputSetting> getInputSettings(String serialNumber) {

		List<InputSetting> inputSettings = new LinkedList<InputSetting>();
		String sql = "SELECT * FROM USER_PRODUCT_INPUT_SETTINGS WHERE SERIAL_NUMBER = ?";

		List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, serialNumber);
		for (Map<String, Object> row : rows) {
			InputSetting inputSetting = new InputSetting();
			inputSetting = mapper.mapInputSetting(row);
			inputSetting.setProductTriggerSettings(getProductTriggetSetting(serialNumber, inputSetting.getInputId()));

			inputSettings.add(inputSetting);
		}
		return inputSettings;

	}

	@Override
	public List<ProductControlSetting> getUserProductControlSettings(String serialNumber, Integer relayId,
			Integer moduleId) {

		List<ProductControlSetting> productControlSettings = new LinkedList<ProductControlSetting>();
		String sql = "SELECT * FROM USER_PRODUCT_CONTROL_SETTINGS WHERE SERIAL_NUMBER = ? AND RELAY_ID = ? AND MODULE_ID = ?";

		List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, serialNumber, relayId, moduleId);
		for (Map<String, Object> row : rows) {
			ProductControlSetting productControlSetting = new ProductControlSetting();
			productControlSetting = mapper.mapProductControlSetting(row);

			productControlSettings.add(productControlSetting);
		}
		return productControlSettings;
	}

	public List<TimerSetting> getUserProductTimerSettings(String serialNumber, Integer relayId, Integer moduleId) {

		List<TimerSetting> timerSettings = new LinkedList<TimerSetting>();
		String sql = "SELECT * FROM USER_PRODUCT_TIMER_SETTINGS WHERE SERIAL_NUMBER = ? AND RELAY_ID = ? AND MODULE_ID = ?";

		List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, serialNumber, relayId, moduleId);
		for (Map<String, Object> row : rows) {
			TimerSetting timerSetting = new TimerSetting();
			timerSetting = mapper.mapProductTimerSetting(row);

			timerSettings.add(timerSetting);
		}
		return timerSettings;
	}

	@Override
	public List<ProductTriggerSetting> getProductTriggetSetting(String serialNumber, Integer inputId) {

		List<ProductTriggerSetting> productTriggerSettings = new LinkedList<ProductTriggerSetting>();
		String sql = "SELECT * FROM USER_PRODUCT_TRIGGER_SETTINGS WHERE SERIAL_NUMBER = ? AND INPUT_ID = ?";

		List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, serialNumber, inputId);
		for (Map<String, Object> row : rows) {
			ProductTriggerSetting productTriggerSetting = new ProductTriggerSetting();
			productTriggerSetting = mapper.mapProductTriggerSetting(row);
			productTriggerSettings.add(productTriggerSetting);
		}
		return productTriggerSettings;
	}

	@Override
	public int updateUserProduct(UserProduct up) {

		String sql = "UPDATE USER_PRODUCTS SET NAME = :NAME, PHONE_NUMBER = :PHONE_NUMBER," + "HOST1 = :HOST1, "
				+ "PORT1 = :PORT1, HOST2 = :HOST2, PORT2 = :PORT2, EDITED = :EDITED, LAST_UPDATE_DATE = :LAST_UPDATE_DATE "
				+ "WHERE SERIAL_NUMBER = :SERIAL_NUMBER";
		logger.info("UPDATING USER PRODUCT [START]");
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("NAME", up.getName());
		parameters.put("PHONE_NUMBER", up.getPhoneNumber());
		parameters.put("HOST1", up.getPrimaryHost());
		parameters.put("PORT1", up.getPrimaryPort());
		parameters.put("HOST2", up.getSecondaryHost());
		parameters.put("PORT2", up.getSecondaryPort());
		parameters.put("EDITED", up.isEdited() ? "Y" : "N");
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());
		parameters.put("SERIAL_NUMBER", up.getSerialNumber());

		deleteProductUsers(up.getSerialNumber());
		for (ProductUser productUser : up.getProductUsers()) {
			addProductUser(productUser, up.getSerialNumber());
		}

		for (RelaySetting relaySetting : up.getRelaySettings()) {
			List<RelaySetting> currentRelaySettings = getRelaySettings(up.getSerialNumber());
			boolean found = false;
			for (RelaySetting crs : currentRelaySettings) {
				if (crs.getModuleId().equals(relaySetting.getModuleId())
						&& crs.getRelayId().equals(relaySetting.getRelayId())) {
					found = true;
					break;
				}
			}
			if (found) {
				updateUserProductRelaySetting(relaySetting, up.getSerialNumber());
			} else {
				addUserProductRelaySetting(relaySetting, up.getSerialNumber());
			}
		}
		for (InputSetting inputSetting : up.getInputSettings()) {
			updateUserProductInputSetting(inputSetting, up.getSerialNumber());
		}

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		Integer err = namedParameterJdbcTemplate.update(sql, namedParameters);
		logger.info("UPDATING USER PRODUCT [END]");
		return err;
	}

	@Override
	public int updateUserProductRelaySetting(RelaySetting rs, String serialNumber) {

		String sql = "UPDATE USER_PRODUCT_RELAY_SETTINGS SET "
				+ "RELAY_NAME = :RELAY_NAME, RELAY_STATUS = :RELAY_STATUS," + "DELAY = :DELAY, "
				+ "MODE = :MODE, RELAY_ENABLED = :RELAY_ENABLED, DELAY_ENABLED = :DELAY_ENABLED, LAST_UPDATE_DATE = :LAST_UPDATE_DATE "
				+ "WHERE SERIAL_NUMBER = :SERIAL_NUMBER " + "AND RELAY_ID = :RELAY_ID AND MODULE_ID = :MODULE_ID";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("RELAY_NAME", rs.getRelayName());
		parameters.put("RELAY_STATUS", rs.getRelayStatus());
		parameters.put("DELAY", rs.getDelay());
		parameters.put("MODE", rs.isImpulseMode() ? "Y" : "N");
		parameters.put("RELAY_ENABLED", rs.isRelayEnabled() ? "Y" : "N");
		parameters.put("DELAY_ENABLED", rs.isDelayEnabled() ? "Y" : "N");
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("RELAY_ID", rs.getRelayId());
		parameters.put("MODULE_ID", rs.getModuleId());

		deleteUserProductControlSettings(serialNumber, rs.getRelayId(), rs.getModuleId());
		for (ProductControlSetting productControlSetting : rs.getProductControlSettings()) {
			addUserProductControlSetting(productControlSetting, serialNumber, rs.getRelayId(), rs.getModuleId());
		}
		deleteUserProductTimerSettings(serialNumber, rs.getRelayId(), rs.getModuleId());
		for (TimerSetting timerSetting : rs.getTimerSettings()) {
			addUserProductTimerSetting(timerSetting, serialNumber, rs.getRelayId(), rs.getModuleId(),
					timerSetting.getTimerId());
		}

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);

	}

	@Override
	public int updateUserProductInputSetting(InputSetting is, String serialNumber) {

		String sql = "UPDATE USER_PRODUCT_INPUT_SETTINGS SET " + "INPUT_NAME = :INPUT_NAME, "
				+ "START_TIMER = :START_TIMER, " + "END_TIMER = :END_TIMER, " + "TIMER_ENABLED = :TIMER_ENABLED, "
				+ "VALUE_POSTFIX = :VALUE_POSTFIX, " + "SAMPLE_RATE = :SAMPLE_RATE, "
				+ "LAST_UPDATE_DATE = :LAST_UPDATE_DATE " + "WHERE SERIAL_NUMBER = :SERIAL_NUMBER "
				+ "AND INPUT_ID = :INPUT_ID";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("INPUT_NAME", is.getInputName());
		parameters.put("START_TIMER", is.getStartTimer());
		parameters.put("END_TIMER", is.getEndTimer());
		parameters.put("TIMER_ENABLED", is.isTimerEnabled() ? "Y" : "N");
		parameters.put("VALUE_POSTFIX", is.getValuePostfix());
		parameters.put("SAMPLE_RATE", is.getSampleRate());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("INPUT_ID", is.getInputId());

		List<ProductTriggerSetting> productTriggerSettings = is.getProductTriggerSettings();

		deleteUserProductTriggerSettings(serialNumber, is.getInputId());
		for (ProductTriggerSetting productTriggerSetting : productTriggerSettings) {
			addUserProductTriggerSetting(productTriggerSetting, serialNumber, is.getInputId());
		}

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	@Override
	public int deleteUserProductTriggerSettings(String serialNumber, Integer inputId) {

		String sql = "DELETE FROM USER_PRODUCT_TRIGGER_SETTINGS WHERE SERIAL_NUMBER = :SERIAL_NUMBER AND INPUT_ID = :INPUT_ID";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("INPUT_ID", inputId);

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	@Override
	public int deleteUserProductControlSettings(String serialNumber, Integer relayId, Integer moduleId) {

		String sql = "DELETE FROM USER_PRODUCT_CONTROL_SETTINGS WHERE SERIAL_NUMBER = :SERIAL_NUMBER AND RELAY_ID = :RELAY_ID AND MODULE_ID = :MODULE_ID";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("RELAY_ID", relayId);
		parameters.put("MODULE_ID", moduleId);

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	public int deleteUserProductTimerSettings(String serialNumber, Integer relayId, Integer moduleId) {

		String sql = "DELETE FROM USER_PRODUCT_TIMER_SETTINGS WHERE SERIAL_NUMBER = :SERIAL_NUMBER AND RELAY_ID = :RELAY_ID AND MODULE_ID = :MODULE_ID";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("RELAY_ID", relayId);
		parameters.put("MODULE_ID", moduleId);

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	@Override
	public int updateUserProductTriggerSetting(ProductTriggerSetting pts, String serialNumber, Integer inputId) {

		String sql = "UPDATE USER_PRODUCT_TRIGGER_SETTINGS SET " + "TRIGGER_RELAY_ID = :TRIGGER_RELAY_ID,"
				+ "TRIGGER_ENABLED = :TRIGGER_ENABLED," + "TRIGGER_VALUE = :TRIGGER_VALUE,"
				+ "TRIGGER_STATE = :TRIGGER_STATE," + "TRIGGER_ACTION = :TRIGGER_ACTION,"
				+ "LAST_UPDATE_DATE = :LAST_UPDATE_DATE " + "WHERE" + "SERIAL_NUMBER = :SERIAL_NUMBER"
				+ "AND INPUT_ID = :INPUT_ID AND" + "TRIGGER_ID = :TRIGGER_ID";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("TRIGGER_RELAY_ID", pts.getTriggerRelayId());
		parameters.put("TRIGGER_ENABLED", pts.isTriggerEnabled() ? "Y" : "N");
		parameters.put("TRIGGER_VALUE", pts.getTriggerValue());
		parameters.put("TRIGGER_STATE", pts.getTriggerState());
		parameters.put("TRIGGER_ACTION", pts.getTriggerAction());
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("INPUT_ID", inputId);
		parameters.put("TRIGGER_ID", pts.getTriggerId());

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	@Override
	public int updateUserProductControlSetting(ProductControlSetting pcs, String serialNumber, Integer relayId) {

		String sql = "UPDATE USER_PRODUCT_CONTROL_SETTINGS SET " + "HAS_ACCESS = :HAS_ACCESS,"
				+ "CALL_ACCESS = :CALL_ACCESS," + "LAST_UPDATE_DATE = :LAST_UPDATE_DATE" + "WHERE"
				+ "SERIAL_NUMBER = :SERIAL_NUMBER AND" + "RELAY_ID = :RELAY_ID AND" + "USER_ID = :USER_ID";

		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SMS_ACCESS", pcs.isAccess() ? "Y" : "N");
		parameters.put("CALL_ACCESS", pcs.isCallAccess() ? "Y" : "N");
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("RELAY_ID", relayId);
		parameters.put("USER_ID", pcs.getUserId());

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

	public int updateRelayStatus(String serialNumber, Integer moduleId, Integer relayId, Integer status) {

		String sql = "UPDATE USER_PRODUCT_RELAY_SETTINGS SET RELAY_STATUS = :RELAY_STATUS, LAST_UPDATE_DATE = :LAST_UPDATE_DATE WHERE SERIAL_NUMBER = :SERIAL_NUMBER "
				+ " AND MODULE_ID = :MODULE_ID AND RELAY_ID = :RELAY_ID";
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("SERIAL_NUMBER", serialNumber);
		parameters.put("MODULE_ID", moduleId);
		parameters.put("RELAY_ID", relayId);
		if (status.equals(1)) {
			parameters.put("RELAY_STATUS", "Y");
		} else {
			parameters.put("RELAY_STATUS", "N");
		}
		parameters.put("LAST_UPDATE_DATE", TimeUtil.getTimeStamp());

		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(
				jdbcTemplate.getDataSource());
		SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
		return namedParameterJdbcTemplate.update(sql, namedParameters);
	}

}
