package com.jtech.apps.hcm.server;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;

import com.jtech.apps.hcm.model.Connection;
import com.jtech.apps.hcm.model.ProductCategory;
import com.jtech.apps.hcm.model.RegisteredProduct;
import com.jtech.apps.hcm.model.UserProduct;
import com.jtech.apps.hcm.model.setting.InputSetting;
import com.jtech.apps.hcm.model.setting.ProductControlSetting;
import com.jtech.apps.hcm.model.setting.ProductTriggerSetting;
import com.jtech.apps.hcm.model.setting.ProductUser;
import com.jtech.apps.hcm.model.setting.RelaySetting;
import com.jtech.apps.hcm.model.setting.TimerSetting;
import com.jtech.apps.hcm.util.RestUtils;
import com.jtech.apps.hcm.util.TimeUtil;

/*
 * TODO:
 * - Use property file for device commands
 * - Encode/Decode communication with device (HW Updates required)
 * - Change delays to waitForOKResponse (HW Updates required)
 * - Rethink the process we communicate towards the device (switchRelay procedure)
 */

public class DeviceSession extends Thread implements Runnable {

	private static final Logger logger = Logger.getLogger(DeviceSession.class);

	private String serialNumber;
	private Socket socket;
	private BufferedReader bufferedReader;
	private PrintWriter printWriter;
	private Connection connection;

	private boolean isValidConnection = true;

	private ProductCategory productCategory;
	private UserProduct userProduct;

	private RestUtils restUtils = new RestUtils();

	/**
	 * 
	 * @param socket
	 * @param host
	 * @param devicePort
	 * @param consolePort
	 */
	public DeviceSession(Socket socket, String host, Integer devicePort, Integer consolePort) {
		this.socket = socket;

		connection = new Connection();
		connection.setHost(host);
		connection.setDevicePort(devicePort);
		connection.setConsolePort(consolePort);
	}

	@Override
	public void run() {

		try {

			socket.setSoTimeout(35000);
			bufferedReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			printWriter = new PrintWriter(socket.getOutputStream());

			updateDeviceTime();

			while (!Thread.interrupted() && isValidConnection) {

				String read = readLine();

				logger.info("Recieved data:" + read);

				processIO(read);

			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {

			if (serialNumber != null) {
				Integer sessionCount = 0;
				List<DeviceSession> deviceSessions = DeviceSessionProvider.getInstance().getDeviceSessions();
				for (DeviceSession deviceSession : deviceSessions) {
					if (deviceSession.getSerialNumber().equals(serialNumber)) {
						sessionCount++;
					}
				}
				// When a device is restarted, it connects to the server in less
				// time, than it's previous session is dumped.
				if (sessionCount == 1) {
					connection.setStatus("DISCONNECTED");
					connection.setSerialNumber(serialNumber);
					restUtils.updateConnection(connection);
					notifyUserSessions("NOTIFICATION;CONNECTION;OFFLINE");
				}
			}

			logger.error("Closing device session with serialnumber: " + serialNumber);

			// TODO: This maybe not working
			DeviceSessionProvider.getInstance().getDeviceSessions().remove(this);
			try {
				printWriter.close();
				bufferedReader.close();
				socket.close();

			} catch (IOException e) {
				e.printStackTrace();
			}

		}

	}

	/**
	 * Send device the current time in format: yy;mm;dd;hh;mm;ss;day;
	 */
	private void updateDeviceTime() {
		Calendar calendar = Calendar.getInstance();
		Date date = calendar.getTime();
		String time = new SimpleDateFormat("yy;MM;dd;HH;mm;ss;").format(Calendar.getInstance().getTime());
		int day = 1;
		switch (new SimpleDateFormat("EE", Locale.ENGLISH).format(date.getTime()).toLowerCase()) {
		case "mon":
			day = 1;
			break;
		case "tue":
			day = 2;
			break;
		case "wed":
			day = 3;
			break;
		case "thu":
			day = 4;
			break;
		case "fri":
			day = 5;
			break;
		case "sat":
			day = 6;
			break;
		case "sun":
			day = 7;
			break;
		}
		write("TIME;" + time + day + ";");
	}

	/**
	 * Process recieved data from device Input String must start with #
	 * character
	 * 
	 * @param readLine
	 */
	private void processIO(String readLine) {

		if (readLine == null) {
			logger.error("Error with incoming data: " + readLine);
			isValidConnection = false;
			return;
		}
		String[] read = readLine.split("#");
		if (read.length == 1 || read.length == 0) {
			logger.error("Error with incoming data: " + readLine);
			isValidConnection = false;
			return;
		}
		// TODO: Implement decoding procedures
		// decode(read[1])
		String[] arguments = read[1].split(";");

		String command = arguments[0];

		switch (command) {

		// DEVICES FIRST SEND PRODUCT_NAME IF NO SERIAL_NUMBER SET
		case DeviceConstants.REQUEST_SERIAL_NUMBER:

			if (arguments.length == 2) {
				String productName = arguments[1];
				logger.info("Requesting serialNumber...");
				requestSerialNumber(productName);
				notifyUserSessions("NOTIFICATION;CONNECTION;ONLINE");
			} else {
				logger.error("Not enough parameters for REQUEST_SERIAL_NUMBER command: " + readLine);
				isValidConnection = false;
			}
			break;

		// If device have serialnumber it'll only send it.
		case DeviceConstants.SERIAL_NUMBER:

			if (arguments.length == 2) {
				String serialNumber = arguments[1];
				logger.info("Device's serialNumber is " + serialNumber + " uploading settings...");
				updateDevice(serialNumber);
				notifyUserSessions("NOTIFICATION;CONNECTION;ONLINE");
			} else {
				isValidConnection = false;
				logger.error("Not enough parameters for SERIAL_NUMBER command: " + readLine);
			}
			break;

		case "NOTIFICATION":// NOTIFICATION;SWITCH;module_id;relay_id;state
			notifyUserSessions(readLine);
			break;

		case "RELAYCONNECTIONS": // RELAYCONNECTIONS;1:14;2:10;4:12

			logger.info("Updating relay connections...");
			processRelayConnections(readLine);
			notifyUserSessions("NOTIFICATION;REFRESH;");
			break;

		case "CHECK":// INPUT;input_id;value
			// problem statement: turn off and on the device, session needs 40
			// sec to time out,
			// but device reconnects sooner, upon timing out, connection will be
			// updated to disconnected
			// this should be done in a better way
			write("LIVE");
			break;

		case "REQUEST_UPDATE":
			uploadProductSettings(userProduct);
			break;

		default:
			break;
		}
	}

	/**
	 * processRelayConnections procedure
	 * 
	 * A device's relay interfaces can dynamically change with time. We can
	 * connect/disconnect relaymodules Upon these events, device will update the
	 * server with it's connected relayIds. This function will set current
	 * relays to enabled/disabled accordingly or add new RelaySetting(s).
	 * Database is update with the new configuration along with the device
	 * itself.
	 * 
	 * @param relayIds
	 */
	// RELAYCONNECTIONS;1:14;2:10;4:12
	private void processRelayConnections(String readLine) {

		if (userProduct == null)
			return;

		Map<Integer, List<Integer>> relayConnections = new HashMap<Integer, List<Integer>>();

		String[] args = readLine.split(";");
		for (int i = 1; i < args.length; i++) {
			String[] data = args[i].split(":");
			if (data.length == 2) {
				Integer moduleId = Integer.parseInt(data[0]);
				Integer relayCount = Integer.parseInt(data[1]);

				List<Integer> relayIds = new LinkedList<Integer>();
				for (int relayId = 0; relayId < relayCount; relayId++) {
					relayIds.add(relayId);
				}
				relayConnections.put(moduleId, relayIds);
			}
		}

		StringBuilder sb = new StringBuilder();

		for (Map.Entry<Integer, List<Integer>> entry : relayConnections.entrySet()) {
			Integer moduleId = entry.getKey();
			List<Integer> relayIds = entry.getValue();

			sb.append("(module=" + moduleId + ", relayids=");
			for (Integer relayId : relayIds) {
				sb.append(relayId + ",");
			}
			sb.append(")");
		}

		// logger.debug("Connected relayIds for " +
		// userProduct.getSerialNumber() + ":" + sb.toString());

		List<RelaySetting> relaySettings = userProduct.getRelaySettings();
		List<ProductControlSetting> productControlSettings = relaySettings.get(0).getProductControlSettings();
		List<RelaySetting> generatedRelaySettings = new LinkedList<RelaySetting>();

		// set all relays to disabled
		for (RelaySetting relaySetting : relaySettings) {
			relaySetting.setRelayEnabled(false);
		}

		// enable connected relays, generate new relays
		for (Map.Entry<Integer, List<Integer>> entry : relayConnections.entrySet()) {
			Integer moduleId = entry.getKey();
			List<Integer> relayIds = entry.getValue();

			for (int i = 0; i < relayIds.size(); i++) {
				boolean found = false;
				for (RelaySetting relaySetting : relaySettings) {
					if (relaySetting.getRelayId().equals(relayIds.get(i))
							&& relaySetting.getModuleId().equals(moduleId)) {
						relaySetting.setRelayEnabled(true); // enables relay
						found = true; // mark it as found
						break;
					}
				}
				if (!found) { // relay was recently added and not present in db
					logger.debug(
							"Relay ID not found:" + moduleId + "/" + relayIds.get(i) + " generating new setting...");
					RelaySetting relaySetting = generateRelaySetting(moduleId, relayIds.get(i), productControlSettings);
					generatedRelaySettings.add(relaySetting);
				}
			}
		}

		if (generatedRelaySettings.size() != 0) {
			userProduct.getRelaySettings().addAll(generatedRelaySettings);
		}

		StringBuilder sb2 = new StringBuilder("Current RelaySettings\n");
		for (RelaySetting relaySetting : userProduct.getRelaySettings()) {
			sb2.append("(" + relaySetting.getModuleId() + "/" + relaySetting.getRelayId() + ") ["
					+ relaySetting.isRelayEnabled() + "]\n");
		}
		logger.info(sb2.toString());

		int err = restUtils.updateUserProduct(userProduct);

		logger.error("Response=" + err);

	}

	/**
	 * notifyUserSessions procedure
	 * 
	 * Finds ProductUser's UserSessions and notify them about stuff Problem
	 * Statement: if I add a new ProductUser to the device, UserProduct should
	 * be updated somehow
	 * 
	 * @param readLine
	 */
	private void notifyUserSessions(String readLine) {

		if (userProduct == null)
			return;

		String[] args = readLine.split(";");

		if (args.length == 5 && args[1].equals("SWITCH")) {
			logger.info("REST: UPDATING SWITCH STATE MODULE " + args[2] + " RELAY " + args[3] + " STATE " + args[4]);
			restUtils.updateRelayState(serialNumber, Integer.parseInt(args[2]), Integer.parseInt(args[3]),
					Integer.parseInt(args[4]));
		}

		if (args.length == 2 && args[1].contains("UPDATED")) {
			String notification = "UPDATED";
			restUtils.addProductNotification(serialNumber, notification);
			logger.info("REST: UPDATING NOTIFICATION FOR" + serialNumber);
		}

		if (args.length == 2 && args[1].contains("REFRESH")) {
			String notification = "REFRESH";
			restUtils.addProductNotification(serialNumber, notification);
			logger.info("REST: UPDATING NOTIFICATION FOR" + serialNumber);
		}

		logger.info("Pushing device notification to UserSessions...");

		List<ProductUser> productUsers = userProduct.getProductUsers();
		if (productUsers == null || productUsers.isEmpty()) {
			logger.error("No ProductUser found for " + userProduct.getSerialNumber());
			return;
		}

		for (ProductUser productUser : productUsers) {

			logger.debug("PRODUCTUSER=" + productUser.getUserName() + " (" + productUser.getUserId() + ")");
			List<UserSession> userSessions = UserSessionProvider.getInstance()
					.getUserSessionById(productUser.getUserId());

			for (UserSession userSession : userSessions) {

				// here we list all kinds of notifications

				if (args.length == 5 && args[1].equals("SWITCH")) {
					String notification = "SWITCH;" + serialNumber + ";" + args[2] + ";" + args[3] + ";" + args[4]
							+ "\n";
					userSession.notifySession(notification);

					logger.debug("USERID in Session: " + userSession.getUserId() + " Notification:" + notification);
				}
				/*
				 * if (args.length == 3 && args[1].equals("CONNECTION")) {
				 * String notification = "CONNECTION;" + serialNumber + ";" +
				 * args[2] + "\n"; userSession.notifySession(notification);
				 * logger.debug("USERID in Session: " + userSession.getUserId()
				 * + " Notification:" + notification); } if (args.length == 2 &&
				 * args[1].equals("REFRESH")) { String notification = "REFRESH;"
				 * + serialNumber + "\n";
				 * userSession.notifySession(notification);
				 * logger.debug("USERID in Session: " + userSession.getUserId()
				 * + " Notification:" + notification); }
				 */

				break;
			}
		}
	}

	/**
	 * requestSerialNumber procedure When device connects for the first time,
	 * they do not have serial number, so they request one. SerialNumber 10 char
	 * long, is randomly generated from numbers and characters
	 * 
	 * @param productName
	 */
	private void requestSerialNumber(String productName) {

		ProductCategory productCategory = restUtils.getProductCategoryByName(productName);

		if (productCategory != null) {

			String serialNumber = generateSerialNumber(10);

			RegisteredProduct registeredProduct = new RegisteredProduct();
			registeredProduct.setSerialNumber(serialNumber);
			registeredProduct.setProductId(productCategory.getProductId());
			registeredProduct.setRegistered(true);
			registeredProduct.setActivated(false);
			registeredProduct.setCreationDate(TimeUtil.getTimeStamp());
			registeredProduct.setLastUpdateDate(TimeUtil.getTimeStamp());

			logger.info("Adding new registered product with serialnumber: " + serialNumber);

			if (((Integer) restUtils.addRegisteredProduct(registeredProduct)) == 1) {
				write("SERIAL_NUMBER#" + serialNumber + "#");
				this.serialNumber = serialNumber;

				connection.setStatus("CONNECTED");
				connection.setSerialNumber(serialNumber);
				restUtils.updateConnection(connection);

			} else {
				logger.error("Error during adding new registered product with serialnumber:" + serialNumber);
				isValidConnection = false;
			}
			// TODO: change delay to wait for OK response
			delay(1000);
			uploadProductSettings(productCategory);

		} else {
			logger.error("Error during getting productCategory for :" + productName);
			isValidConnection = false;
		}
	}

	/**
	 * updateDevice procedure Updates device's Settings if they have changed.
	 * Load ProductCategory settings if product is not registered Load
	 * UserProductSetting if product is registered
	 * 
	 * @param serialNumber
	 */
	private void updateDevice(String serialNumber) {

		connection.setStatus("CONNECTED");
		connection.setSerialNumber(serialNumber);
		restUtils.updateConnection(connection);

		RegisteredProduct registeredProduct = restUtils.getRegisteredProductBySerialNumber(serialNumber);

		if (registeredProduct == null) {
			logger.error("Registered product does not exist for serialnumber: " + serialNumber);
			isValidConnection = false;
		} else {
			if (registeredProduct.isActivated() && registeredProduct.isRegistered()) {

				logger.info("Registered product is ACTIVATED and REGISTERED, getting user product...");
				userProduct = restUtils.getUserProductBySerialNumber(serialNumber);

				// TODO: wait for OK response instead of delay
				if (userProduct != null) {

					restUtils.updateUserProduct(userProduct);
					delay(1000);
					uploadProductSettings(userProduct);
				}
			} else {

				logger.info("Registered product is NOT ACTIVATED, getting product category...");
				productCategory = restUtils.getProductCategoryById(registeredProduct.getProductId());

				// TODO: wait for OK response instead of delay
				if (productCategory != null) {
					delay(1000);
					uploadProductSettings(productCategory);
				}
			}
			this.serialNumber = serialNumber;
		}
	}

	/**
	 * generateRelaySetting function
	 * 
	 * @param relayId
	 * @param productControlSettings
	 * @return RelaySetting
	 */
	private RelaySetting generateRelaySetting(Integer moduleId, Integer relayId,
			List<ProductControlSetting> productControlSettings) {
		RelaySetting relaySetting = new RelaySetting();
		relaySetting.setModuleId(moduleId);
		relaySetting.setRelayId(relayId);
		relaySetting.setRelayName("Relay " + moduleId + "/" + relayId);
		relaySetting.setImpulseMode(false);
		relaySetting.setRelayStatus("N");
		relaySetting.setDelay("0");
		relaySetting.setRelayEnabled(true);
		relaySetting.setDelayEnabled(false);
		relaySetting.setProductControlSettings(productControlSettings);

		TimerSetting timerSetting = new TimerSetting();
		timerSetting.setTimerId(1);
		timerSetting.setStartTimer("8:00");
		timerSetting.setEndTimer("17:00");
		timerSetting.setStartWeekDays("mon,tue,wed,thu,fri,sat,sun");
		timerSetting.setEndWeekDays("mon,tue,wed,thu,fri,sat,sun");
		timerSetting.setTimerEnabled(false);

		relaySetting.addTimerSetting(timerSetting);

		return relaySetting;
	}

	/**
	 * uploadProductSettings procedure uploads settings in chunks, waits for
	 * response after each chunk
	 * 
	 * @param productCategory
	 * @return boolean
	 */
	private boolean uploadProductSettings(ProductCategory productCategory) {

		List<String> settingStrings = new LinkedList<String>();

		settingStrings.add("[CLEAR_EEPROM]");

		logger.info("Uploading product category settings...");
		StringBuilder settingString = new StringBuilder("#NS;");
		settingString.append("HOST1:" + productCategory.getPrimaryHost() + ";");
		settingString.append("PORT1:" + productCategory.getPrimaryPort() + ";");
		settingString.append("HOST2:" + productCategory.getSecondaryHost() + ";");
		settingString.append("PORT2:" + productCategory.getSecondaryPort() + ";");

		settingStrings.add(settingString.toString());

		settingStrings.addAll(generateSettingString(null, productCategory.getRelaySettings(),
				productCategory.getInputSettings(), null));

		settingStrings.add("[END]");
		for (String str : settingStrings) {
			System.out.println(str);
			write("[CFG]$" + str + "$");
			readLine();
		}
		return true;

	}

	/**
	 * uploadProductSettings procedure uploads settings in chunks, waits for
	 * response after each chunk
	 * 
	 * @param userProduct
	 * @return
	 */
	private boolean uploadProductSettings(UserProduct userProduct) {

		if (!userProduct.isEdited()) {
			logger.info("UserProduct Setting is not edited... Not uploading settings...");
			return false;
		}

		List<String> settingStrings = new LinkedList<String>();

		settingStrings.add("[CLEAR_EEPROM]");

		logger.info("Uploading user product settings...");
		StringBuilder settingString = new StringBuilder("#NS;");
		settingString.append("HOST1:" + userProduct.getPrimaryHost() + ";");
		settingString.append("PORT1:" + userProduct.getPrimaryPort() + ";");
		settingString.append("HOST2:" + userProduct.getSecondaryHost() + ";");
		settingString.append("PORT2:" + userProduct.getSecondaryPort() + ";#");

		settingStrings.add(settingString.toString());

		settingStrings.addAll(generateSettingString(userProduct.getSerialNumber(), userProduct.getRelaySettings(),
				userProduct.getInputSettings(), userProduct.getProductUsers()));

		settingStrings.add("[END]");
		for (String str : settingStrings) {
			System.out.println(str);
			write("[CFG]$" + str + "$");
			readLine();
		}
		// setting isEdited flag so next time it won't be updated (unless
		// settings change)
		userProduct.setEdited(false);
		restUtils.updateUserProduct(userProduct);
		return true;

	}

	/**
	 * generateSettingString function
	 * 
	 * @param serialNumber
	 * @param setting
	 * @param productUsers
	 * @return List<String>
	 */
	private List<String> generateSettingString(String serialNumber, List<RelaySetting> relaySettings,
			List<InputSetting> inputSettings, List<ProductUser> productUsers) {

		List<String> settingStrings = new LinkedList<String>();

		for (RelaySetting relaySetting : relaySettings) {
			if (relaySetting.isRelayEnabled()) {
				StringBuilder relayString = new StringBuilder();
				relayString.append("#RS;");
				relayString.append("MI:" + relaySetting.getModuleId() + ";"); // Module
				relayString.append("RI:" + relaySetting.getRelayId() + ";");
				relayString.append("D:" + relaySetting.getDelay() + ";");
				relayString.append("IM:" + (relaySetting.isImpulseMode() ? "1;" : "0;"));

				relayString.append("UA:");

				boolean first = true;
				for (int i = 0; i < relaySetting.getProductControlSettings().size(); i++) {
					ProductControlSetting pcs = relaySetting.getProductControlSettings().get(i);
					if (pcs.isAccess()) {
						if (!first) {
							relayString.append(",");
						}
						first = false;
						relayString.append(i);
					}
				}
				relayString.append("#");
				settingStrings.add(relayString.toString());
			}

			if (relaySetting.getTimerSettings() != null) {
				for (TimerSetting timerSetting : relaySetting.getTimerSettings()) {
					if (timerSetting.isTimerEnabled()) {
						StringBuilder timerString = new StringBuilder();
						timerString.append("#TS;");
						timerString.append("MI:" + relaySetting.getModuleId() + ";"); // ModuleID
						timerString.append("RI:" + relaySetting.getRelayId() + ";"); // RelayID
						timerString.append("TI:" + timerSetting.getTimerId() + ";"); // RelayID
						timerString.append("ST:" + convertToMinutes(timerSetting.getStartTimer()) + ";");
						timerString.append("SW:" + convertWeekDays(timerSetting.getStartWeekDays()) + ";");
						timerString.append("ET:" + convertToMinutes(timerSetting.getEndTimer()) + ";");
						timerString.append("EW:" + convertWeekDays(timerSetting.getEndWeekDays()) + ";");
						timerString.append("#");
						settingStrings.add(timerString.toString());
					}
				}
			}

		}

		for (InputSetting inputSetting : inputSettings) {
			StringBuilder inputString = new StringBuilder("#IS;");
			inputString.append("II:" + inputSetting.getInputId() + ";");
			inputString.append("ST:" + inputSetting.getStartTimer() + ";");
			inputString.append("ET:" + inputSetting.getEndTimer() + ";");
			inputString.append("TE:" + (inputSetting.isTimerEnabled() ? "1;" : "0;"));
			inputString.append("SR:" + inputSetting.getSampleRate() + "#");
			settingStrings.add(inputString.toString());
		}

		if (productUsers != null) {

			for (int i = 0; i < productUsers.size(); i++) {

				ProductUser productUser = productUsers.get(i);
				String privilige = "USER";
				if (productUser.getPrivilige().equals("ADMIN")) {
					privilige = "ADMIN";
				}

				String phoneNumber = restUtils.getUserProfileByUserId(productUser.getUserId()).getPhoneNumber();
				if (phoneNumber != null) {

					StringBuilder controlSetting = new StringBuilder(
							"#USR;PRIV:" + privilige + ";NUM:" + phoneNumber + ";UI:" + i + ";CA:");

					boolean first = true;
					for (RelaySetting relaySetting : relaySettings) {
						if (relaySetting.isRelayEnabled()) {
							for (ProductControlSetting productControlSetting : relaySetting
									.getProductControlSettings()) {
								if (productControlSetting.getUserId() == productUser.getUserId()) {
									if (productControlSetting.isCallAccess()) {
										if (!first) {
											controlSetting.append(",");
										}
										first = false;
										controlSetting
												.append(relaySetting.getModuleId() + "/" + relaySetting.getRelayId());
									}
								}
							}
						}
					}
					controlSetting.append("#");

					logger.info(controlSetting);
					settingStrings.add(controlSetting.toString());
				}
			}
		}

		for (InputSetting inputSetting : inputSettings) {
			for (ProductTriggerSetting pts : inputSetting.getProductTriggerSettings()) {
				StringBuilder sb = new StringBuilder("#TRIGGER;");
				sb.append("TI:" + pts.getTriggerId() + ";");
				sb.append("TE:" + (pts.isTriggerEnabled() ? "1" : "0") + ";");
				sb.append("TR:" + pts.getTriggerRelayId() + ";");
				sb.append("TV:" + pts.getTriggerValue() + ";");
				sb.append("TS:" + pts.getTriggerState() + ";");
				settingStrings.add(sb.toString());
			}
		}
		// 309225427;111101111;5
		return settingStrings;
	}

	/**
	 * Converting weekdays to numbers.
	 * 
	 * @param weekDays
	 * @return
	 */
	private String convertWeekDays(String weekDays) {
		String[] days = weekDays.split(",");
		StringBuilder sb = new StringBuilder();
		int day = 1;
		for (int i = 0; i < days.length; i++) {
			if (i != 0) {
				sb.append(",");
			}
			switch (days[i]) {
			case "mon":
				day = 1;
				break;
			case "tue":
				day = 2;
				break;
			case "wed":
				day = 3;
				break;
			case "thu":
				day = 4;
				break;
			case "fri":
				day = 5;
				break;
			case "sat":
				day = 6;
				break;
			case "sun":
				day = 7;
				break;
			}
			sb.append(day);
		}
		return sb.toString();
	}

	/**
	 * Convert hour to minutes, used in generating setting strings.
	 * 
	 * @param hour
	 * @return
	 */
	private String convertToMinutes(String hour) {
		String[] parts = hour.split(":");
		int minutes = 0;
		if (parts.length == 2) {
			minutes = Integer.parseInt(parts[0]) * 60 + Integer.parseInt(parts[1]);
		}
		return Integer.toString(minutes);
	}

	/**
	 * switchRelay function
	 * 
	 * @param moduleId
	 * @param relayId
	 * @param state
	 * @return
	 */
	// TODO: should only use write in a generic manner
	public void switchRelay(Integer moduleId, Integer relayId, Integer state) {
		logger.info("DeviceSession switchRelay");
		String toWrite = "SWITCHRELAY;" + moduleId + ";" + relayId + ";" + state + ";@";
		write(toWrite);
	}

	/**
	 * refresh userProduct data
	 */
	public void updateUserProduct() {
		logger.info("DeviceSession updateUserProduct");
		userProduct = restUtils.getUserProductBySerialNumber(serialNumber);
		write("UPDATE");
	}

	public void restartUserProduct() {
		write("RESTART");
	}

	/**
	 * Writes to device
	 * 
	 * @param toWrite
	 */
	private void write(String toWrite) {
		printWriter.write(toWrite + "\n");
		printWriter.flush();
	}

	private String readLine() {
		try {
			return bufferedReader.readLine();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * generateSerialNumber function we use 10 char long serialNumbers generated
	 * from numbers and alphabetic characters
	 * 
	 * @param len
	 * @return String
	 */
	private String generateSerialNumber(int len) {
		String AB = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		SecureRandom rnd = new SecureRandom();
		boolean isValidSerial = false;

		String serialNumber = "";

		while (isValidSerial == false) {
			StringBuilder sb = new StringBuilder(len);
			for (int i = 0; i < len; i++)
				sb.append(AB.charAt(rnd.nextInt(AB.length())));
			serialNumber = sb.toString();

			if (restUtils.getRegisteredProductBySerialNumber(serialNumber) == null) {
				isValidSerial = true;
			}
		}

		return serialNumber;
	}

	/**
	 * getSerialNumber function
	 * 
	 * @return String
	 */
	public String getSerialNumber() {
		return serialNumber;
	}

	private void delay(Integer ms) {

		try {
			Thread.sleep(ms);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
