package com.jtech.apps.hcm.service;

import java.util.LinkedList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

import com.jtech.apps.hcm.form.ProductSettingsForm;
import com.jtech.apps.hcm.form.RegisterForm;
import com.jtech.apps.hcm.model.Notification;
import com.jtech.apps.hcm.model.UserProduct;
import com.jtech.apps.hcm.model.UserProfile;
import com.jtech.apps.hcm.model.setting.ProductControlSetting;
import com.jtech.apps.hcm.model.setting.ProductUser;
import com.jtech.apps.hcm.model.setting.RelaySetting;
import com.jtech.apps.hcm.model.setting.TimerSetting;
import com.jtech.apps.hcm.util.LocalizationUtils;
import com.jtech.apps.hcm.util.RestUtils;
import com.mysql.jdbc.StringUtils;

@Service
public class ConsoleService {

	private static final Logger logger = Logger.getLogger(ConsoleService.class);
	private RestUtils restUtils = new RestUtils();
	LocalizationUtils localizationUtils = new LocalizationUtils();

	/**
	 * When /console is hit, we retrive userName from context, get UserProfile
	 * from the username, get UserProduct from the userid and populates the
	 * ModelAndView
	 * 
	 * @param model
	 * @return ModelAndView
	 */
	public ModelAndView onConsoleOpen(ModelMap model, String locale) {
		ModelAndView modelAndView = new ModelAndView("console");

		// GET username from context
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String userName = auth.getName();
		String productPrivilige = "";

		// GET userprofile of the username
		UserProfile userProfile = restUtils.getUserProfileByUserName(userName);

		// GET userproducts of the username by userid
		List<UserProduct> userProducts = restUtils.getUserProductsByUserId(userProfile.getUserId());

		for (UserProduct userProduct : userProducts) {

			List<RelaySetting> relaySettingsToRemove = new LinkedList<RelaySetting>();

			List<ProductUser> productusers = userProduct.getProductUsers();
			for (ProductUser productUser : productusers) {
				if (productUser.getUserId().equals(userProfile.getUserId())) {
					productPrivilige = productUser.getPrivilige();
				}
			}
			List<RelaySetting> relaySettings = userProduct.getRelaySettings();
			for (RelaySetting relaySetting : relaySettings) {

				if (!relaySetting.isRelayEnabled()) {
					relaySettingsToRemove.add(relaySetting);
				} else {
					List<ProductControlSetting> productControlSettings = relaySetting.getProductControlSettings();
					for (ProductControlSetting productControlSetting : productControlSettings) {
						if (productControlSetting.getUserId().equals(userProfile.getUserId())
								&& !productControlSetting.isAccess()) {
							// relaySettingsToRemove.add(relaySetting);
						}

						if (productControlSetting.getUserId().equals(userProfile.getUserId())) {
							// relaySettingsToRemove.add(relaySetting);
							// logger.info("RELAY=" +
							// relaySetting.getRelayName());
						}
					}
				}
			}
			relaySettings.removeAll(relaySettingsToRemove);
		}
		
		

		// populate modelAndView
		modelAndView.addObject("localization", localizationUtils.getLocalization("console",locale).getLocalizations());
		modelAndView.addObject("firstname", userProfile.getFirstName());
		modelAndView.addObject("userid", userProfile.getUserId());
		modelAndView.addObject("privilige", productPrivilige);
		modelAndView.addObject("userProducts", userProducts);

		RegisterForm registerForm = new RegisterForm();
		modelAndView.addObject("registerForm", registerForm);

		return modelAndView;
	}

	/**
	 * Registers UserProduct by serialNumber
	 * 
	 * @param userId
	 * @param serialNumber
	 * @return 1 onSuccess, 0 onFailure
	 */
	public Integer onRegisterProduct(Integer userId, String serialNumber) {
		
		Integer err = restUtils.registerProduct(userId, serialNumber);

		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				onUpdate(userId, serialNumber);
			}
		};
		Thread thread = new Thread(runnable);
		thread.start();

		return err;
	}

	/**
	 * GETS UserProduct by serialNumber, updates it's name, pushes it back
	 * through the rest service
	 * 
	 * @param userId
	 * @param serialNumber
	 * @param productName
	 * @return 1 onSuccess, 0 onFailure
	 */
	public Integer onUpdateProductName(String userId, String serialNumber, String productName) {
		
		UserProduct userProduct = restUtils.getUserProductBySerialNumber(serialNumber);
		userProduct.setName(productName); 
		return restUtils.updateUserProduct(userProduct);
	}

	/**
	 * GETS the userProfile we'd like to add by userName, creates ProductUser
	 * object from it. GETS the userProduct by serialNumber, add the ProductUser
	 * to it and generate ProductControlSettings as well. Finally it updates the
	 * userProduct through the rest service.
	 * 
	 * @param serialNumber
	 * @param userName
	 * @return 1 onSuccess, 0 onFailure
	 */
	public Integer onInsertProductUser(Integer userId, String serialNumber, String userName) {

		/* GET USERPROFILE */
		UserProfile userProfile = restUtils.getUserProfileByUserName(userName);

		if (userProfile == null) {
			logger.info("Error: onInserProductUser - no userprofile found for " + userName);
			return 0;
		}
		/* CREATE PRODUCT USER FROM UP */
		ProductUser productUser = new ProductUser();
		productUser.setPrivilige("USER");
		productUser.setUserId(userProfile.getUserId());
		productUser.setSelected(false);
		productUser.setUserName(userName);

		logger.debug("ID=" + userProfile.getUserId());

		/* GET USERPRODUCT */
		UserProduct userProduct = restUtils.getUserProductBySerialNumber(serialNumber);
		List<ProductUser> productUsers = userProduct.getProductUsers();
		for (ProductUser pu : productUsers) {
			if (pu.getUserName().equals(productUser.getUserName())) {
				logger.info("ALREADY ADDED");
				return -1;
			}
		}
		userProduct.addProductUser(productUser);

		/* ADD PRODUCT CONTROL SETTING */
		ProductControlSetting productControlSetting = new ProductControlSetting();
		productControlSetting.setUserId(userProfile.getUserId());
		productControlSetting.setAccess(true);
		productControlSetting.setCallAccess(false);

		List<RelaySetting> relaySettings = userProduct.getRelaySettings();
		for (RelaySetting relaySetting : relaySettings) {
			relaySetting.addProductControlSetting(productControlSetting);
		}

		userProduct.setEdited(true);
		
		Integer err = restUtils.updateUserProduct(userProduct);
		
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				onUpdate(userId, serialNumber);
			}
		};
		Thread thread = new Thread(runnable);
		thread.start();

		return err;
	}

	/**
	 * GET the UserProfile of the userName we want to remove from the
	 * UserProduct identified by serialNumber Updates UserProduct through the
	 * rest service
	 * 
	 * @param serialNumber
	 * @param userName
	 * @return 1 onSuccess, 0 onFailure
	 */
	public Integer onRemoveProductUser(Integer userId, String serialNumber, String userName) {

		/* GET USERPROFILE */
		UserProfile userProfile = restUtils.getUserProfileByUserName(userName);
		if (userProfile == null) {
			logger.info("NO PROFILE");
			return 0;
		}

		logger.info("ID=" + userProfile.getUserId());
		/* GET USERPRODUCT */
		UserProduct userProduct = restUtils.getUserProductBySerialNumber(serialNumber);

		ProductUser toRemove = null;
		for (ProductUser pu : userProduct.getProductUsers()) {
			if (pu.getUserName().equals(userName)) {
				toRemove = pu;
			}
		}
		if (toRemove != null) {
			userProduct.removeProductUser(toRemove);
		}

		/* REMOVE PRODUCT CONTROL SETTING */
		ProductControlSetting productControlSetting = new ProductControlSetting();

		List<RelaySetting> relaySettings = userProduct.getRelaySettings();
		for (RelaySetting relaySetting : relaySettings) {
			for (ProductControlSetting pcs : relaySetting.getProductControlSettings()) {
				if (pcs.getUserId().equals(userProfile.getUserId())) {
					productControlSetting = pcs;
					break;
				}
			}
			relaySetting.getProductControlSettings().remove(productControlSetting);
		}

		logger.info("OK");
		
		Integer err = restUtils.updateUserProduct(userProduct);
		
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				onUpdate(userId, serialNumber);
			}
		};
		Thread thread = new Thread(runnable);
		thread.start();

		return err;
	}

	/**
	 * GET the UserProfile of the userName we want to update in the UserProduct
	 * identified by serialNumber Updates UserProduct through the rest service
	 * 
	 * @param serialNumber
	 * @param userName
	 * @param relayAccess
	 * @param callAccess
	 * @return
	 */
	public Integer onUpdateProductUser(Integer userId, String serialNumber, String userName, List<String> relayAccess,
			List<String> callAccess, String privilige) {

		/* GET USERPROFILE */
		UserProfile userProfile = restUtils.getUserProfileByUserName(userName);
		if (userProfile == null) {
			logger.error("Profile does not exist");
			return 0;
		}

		logger.info("UserName=" + userProfile.getUserName() + " UserID=" + userProfile.getUserId());
		/* GET USERPRODUCT */
		UserProduct userProduct = restUtils.getUserProductBySerialNumber(serialNumber);

		List<RelaySetting> relaySettings = userProduct.getRelaySettings();
		for (RelaySetting relaySetting : relaySettings) {
			List<ProductControlSetting> pcs = relaySetting.getProductControlSettings();
			for (ProductControlSetting productControlSetting : pcs) {
				if (productControlSetting.getUserId().equals(userProfile.getUserId())) {
					logger.info("Disabling access for " + relaySetting.getRelayName());
					productControlSetting.setAccess(false);
					productControlSetting.setCallAccess(false);
					for (String ra : relayAccess) {
						if (ra.equals(relaySetting.getRelayName())) {
							logger.info("Enabling relay access for " + relaySetting.getRelayName());
							productControlSetting.setAccess(true);
						}
					}
					for (String ca : callAccess) {
						if (ca.equals(relaySetting.getRelayName())) {
							logger.info("Enabling call access for " + relaySetting.getRelayName());
							productControlSetting.setCallAccess(true);
						}
					}
				}
			}
		}

		if (!StringUtils.isNullOrEmpty(privilige) && (privilige.equals("USER") || privilige.equals("ADMIN"))) {
			for (ProductUser productUser : userProduct.getProductUsers()) {
				if (productUser.getUserName().equals(userName)) {
					productUser.setPrivilige(privilige);
				}
			}
		}

		userProduct.setEdited(true);
		
		Integer err = restUtils.updateUserProduct(userProduct);
		
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				onUpdate(userId, serialNumber);
			}
		};
		Thread thread = new Thread(runnable);
		thread.start();

		return err;
	}

	/**
	 * Get UserProduct by serialNumber, retrieves product information from
	 * ProductSettingsForm push data from form to UserProduct, updates DB
	 * through the rest service
	 * 
	 * @param serialNumber
	 * @param psf
	 * @return
	 */
	public Integer onUpdateProductSettings(Integer userId, String serialNumber, ProductSettingsForm psf) {

		UserProduct userProduct = restUtils.getUserProductBySerialNumber(serialNumber);

		logger.info("onUpdateProductSettings " + serialNumber);

		int timerIndex = 0;

		List<RelaySetting> relaySettings = userProduct.getRelaySettings();
		for (RelaySetting relaySetting : relaySettings) {
			relaySetting.getTimerSettings().clear();

			for (int index = 0; index < psf.getRelayIds().size(); index++) {
				if (relaySetting.getRelayId().equals(Integer.parseInt(psf.getRelayIds().get(index)))
						&& relaySetting.getModuleId().equals(Integer.parseInt(psf.getModuleIds().get(index)))) {

					// logger.info("RelaySetting=" + relaySetting.getRelayId() +
					// " psf=" + psf.getRelayIds().get(index));

					if (psf.getRelayNames().get(index) != null && psf.getRelayNames().get(index) != "") {
						relaySetting.setRelayName(psf.getRelayNames().get(index));
					}
					if (psf.getDelays().get(index) != null && psf.getDelays().get(index) != "") {
						relaySetting.setDelay(psf.getDelays().get(index));
					}
					if (psf.getImpulses().get(index) != null && psf.getImpulses().get(index) != "") {
						relaySetting.setImpulseMode(psf.getImpulses().get(index).equals("1"));
					}

					if (psf.getTimerIds().get(timerIndex) != null && psf.getTimerIds().get(timerIndex) != "") {
						boolean firstRun = true;
						while (!(timerIndex == psf.getTimerIds().size()
								|| (psf.getTimerIds().get(timerIndex).equals("1") && !firstRun))) {
							firstRun = false;
							// logger.info("INDEX=" + timerIndex);
							TimerSetting timerSetting = new TimerSetting();
							if (psf.getTimerIds().get(timerIndex) != null && psf.getTimerIds().get(timerIndex) != "") {
								timerSetting.setTimerId(Integer.parseInt(psf.getTimerIds().get(timerIndex)));
							}
							if (psf.getStartTimers().get(timerIndex) != null
									&& psf.getStartTimers().get(timerIndex) != "") {
								timerSetting.setStartTimer(psf.getStartTimers().get(timerIndex));
							}
							if (psf.getEndTimers().get(timerIndex) != null
									&& psf.getEndTimers().get(timerIndex) != "") {
								timerSetting.setEndTimer(psf.getEndTimers().get(timerIndex));
							}
							if (psf.getTimerEnabled().get(timerIndex) != null
									&& psf.getTimerEnabled().get(timerIndex) != "") {
								timerSetting.setTimerEnabled(psf.getTimerEnabled().get(timerIndex).equals("1"));
							}
							if (psf.getStartWeekDays().get(timerIndex) != null
									&& psf.getStartWeekDays().get(timerIndex).size() != 0) {
								StringBuffer sb = new StringBuffer();
								for (String weekday : psf.getStartWeekDays().get(timerIndex)) {
									sb.append(weekday + ",");
								}
								// logger.info("START WEEKDAYS=" +
								// sb.toString());
								timerSetting.setStartWeekDays(sb.toString());
							} else if (psf.getStartWeekDays().get(timerIndex) == null) {
								timerSetting.setStartWeekDays("");
							}
							if (psf.getEndWeekDays().get(timerIndex) != null
									&& psf.getEndWeekDays().get(timerIndex).size() != 0) {
								StringBuffer sb = new StringBuffer();
								for (String weekday : psf.getEndWeekDays().get(timerIndex)) {
									sb.append(weekday + ",");
								}
								// logger.info("END WEEKDAYS=" + sb.toString());
								timerSetting.setEndWeekDays(sb.toString());
							} else if (psf.getEndWeekDays().get(timerIndex) == null) {
								timerSetting.setEndWeekDays("");
							}
							relaySetting.addTimerSetting(timerSetting);
							timerIndex++;
						}
					}
				}
			}
		}
		userProduct.setEdited(true);

		StringBuilder sb = new StringBuilder();
		for (RelaySetting relaySetting : relaySettings) {
			sb.append("ModuleId=" + relaySetting.getModuleId() + "\n");
			sb.append("RelayId=" + relaySetting.getRelayId() + "\n");
			for (TimerSetting timerSetting : relaySetting.getTimerSettings()) {
				sb.append("TimerId=" + timerSetting.getTimerId() + "\n");
				sb.append("StartTimer=" + timerSetting.getStartTimer() + "\n");
				sb.append("EndTImer=" + timerSetting.getEndTimer() + "\n");
			}
			sb.append("\n");
		}
		// logger.info(sb.toString());

		Integer err = restUtils.updateUserProduct(userProduct);

		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				onUpdate(userId, serialNumber);
			}
		};
		Thread thread = new Thread(runnable);
		thread.start();

		return err;
	}

	public Integer onInsertTimerSetting(String serialNumber, Integer moduleId, Integer relayId) {

		TimerSetting timerSetting = new TimerSetting();
		timerSetting.setStartTimer("8:00");
		timerSetting.setEndTimer("17:00");
		timerSetting.setTimerEnabled(false);

		UserProduct userProduct = restUtils.getUserProductBySerialNumber(serialNumber);
		for (RelaySetting relaySetting : userProduct.getRelaySettings()) {
			if (relaySetting.getModuleId().equals(moduleId) && relaySetting.getRelayId().equals(relayId)) {
				Integer timerId = relaySetting.getTimerSettings().size() + 1;
				timerSetting.setTimerId(timerId);
				relaySetting.addTimerSetting(timerSetting);
			}

		}

		return restUtils.updateUserProduct(userProduct);
	}

	public Integer onRemoveTimerSetting(String serialNumber, Integer moduleId, Integer relayId, Integer timerId) {

		UserProduct userProduct = restUtils.getUserProductBySerialNumber(serialNumber);
		TimerSetting timerSettingToRemove = null;

		for (RelaySetting relaySetting : userProduct.getRelaySettings()) {
			if (relaySetting.getModuleId().equals(moduleId) && relaySetting.getRelayId().equals(relayId)) {
				for (TimerSetting timerSetting : relaySetting.getTimerSettings()) {
					if (timerSetting.getTimerId().equals(timerId)) {
						timerSettingToRemove = timerSetting;
					}
				}
				relaySetting.getTimerSettings().remove(timerSettingToRemove);
			}
		}

		return restUtils.updateUserProduct(userProduct);
	}

	public List<Notification> onReceiveNotification(Integer userId) {
		List<Notification> notifications = restUtils.getNotificationsBySerial(userId);
		return notifications;
	}

	/**
	 * Switch relay of a product identified by serialnumber. RelayID specifies
	 * which relay to switch into status which is 0 or 1
	 * 
	 * @param userId
	 * @param serialNumber
	 * @param relayId
	 * @param status
	 * @return
	 */
	public String onRelaySwitch(Integer userId, String serialNumber, String moduleId, String relayId, String status) {
		logger.info("SWITCHING " + serialNumber + " RelayId=" + relayId);
		String response = restUtils.onSwitchRelay(userId, serialNumber, moduleId, relayId, status);
		logger.info("RESPONSE=" + response);
		return response;
	}

	public String onUpdate(Integer userId, String serialNumber) {
		logger.info("UPDATING DEVICE " + serialNumber);
		return restUtils.onUpdate(userId, serialNumber);
	}

	public String onRestart(Integer userId, String serialNumber) {
		logger.info("RESTARTING DEVICE " + serialNumber);
		return restUtils.onRestart(userId, serialNumber);
	}

}