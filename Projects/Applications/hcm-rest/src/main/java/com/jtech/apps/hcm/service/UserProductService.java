package com.jtech.apps.hcm.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.LinkedList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jtech.apps.hcm.dao.interfaces.UserProductDAO;
import com.jtech.apps.hcm.model.Connection;
import com.jtech.apps.hcm.model.ProductCategory;
import com.jtech.apps.hcm.model.RegisteredProduct;
import com.jtech.apps.hcm.model.UserProduct;
import com.jtech.apps.hcm.model.UserProfile;
import com.jtech.apps.hcm.model.mobile.Component;
import com.jtech.apps.hcm.model.mobile.Element;
import com.jtech.apps.hcm.model.mobile.Relay;
import com.jtech.apps.hcm.model.setting.ProductControlSetting;
import com.jtech.apps.hcm.model.setting.ProductUser;
import com.jtech.apps.hcm.model.setting.RelaySetting;
import com.jtech.apps.hcm.model.setting.TimerSetting;
import com.mysql.jdbc.StringUtils;

@Service
public class UserProductService {
  @Autowired
  UserProductDAO userProductDAO;
  @Autowired
  ProductRegistrationService productregistrationService;
  @Autowired
  ProductCategoryService productCategoryService;
  @Autowired
  UserProfileService userProfileService;
  @Autowired
  ConnectionService connectionService;
  @Autowired
  MobileComponentService mobileComponentService;

  private final Logger logger = Logger.getLogger(UserProductService.class);

  /**
   * getUserProducts function returns every userProducts
   * 
   * @return List<UserProduct>
   */
  @Transactional(readOnly=true)
  public List<UserProduct> getUserProducts() {

    logger.debug("Getting all UserProducts...");
    List<UserProduct> userProducts = userProductDAO.getUserProducts();

    if (userProducts != null) {
      for (UserProduct userProduct : userProducts) {
        Connection connection = connectionService.getConnection(userProduct.getSerialNumber());

        if (connection == null) {
          userProduct.setConnected(false);
        } else {
          userProduct.setConnected(connection.getStatus().equals("CONNECTED"));
        }
      }
    }
    return userProducts;
  }

  /**
   * switchRelay function
   * 
   * returns 0 if device is offline (connections table) opens socket on deviceSession console port,
   * that starts a userSession where it's able to execute commands on user's devices device's
   * response is recieved through the notificationService
   * 
   * @param userId
   * @param serialNumber
   * @param moduleId
   * @param relayId
   * @param state
   * @return Integer
   */
  
  public String switchRelay(Integer userId, String serialNumber, String moduleId, String relayId, String state) {
    String command = "SWITCH;" + serialNumber + ";" + moduleId + ";" + relayId + ";" + state + "\n";
    return sendToConsolePort(serialNumber, userId, command);
  }

  public String switchRelays(Integer userId, Integer componentId, Integer elementId, String action) {

    List<Component> components = mobileComponentService.getComponents(userId);
    List<Relay> relays = new LinkedList<>();
    String serialNumber = "";
    
    for (Component component : components) {
      if (component.getComponentId().equals(componentId)) {
        for (Element element : component.getElements()) {
          if (element.getElementId().equals(elementId)) {
            for (Relay relay : element.getRelays()) {
              if (relay.getAction().equals(action)) {
                relays.add(relay);
              }
            }
          }
        }
      }
    }
    
    StringBuilder response = new StringBuilder();
    for (Relay relay : relays) {
      if (!serialNumber.equals(relay.getSerialNumber())){
        serialNumber = relay.getSerialNumber();
        String command = "MULTI-SWITCH;" + serialNumber + ";" + componentId + ";" + elementId + ";" + action + "\n";
        response.append(sendToConsolePort(serialNumber, userId, command));
      }
    }
    return response.toString();
  }

  public String update(Integer userId, String serialNumber) {
    String message = "UPDATE;" + serialNumber + "\n";
    return sendToConsolePort(serialNumber, userId, message);
  }

  public String restart(Integer userId, String serialNumber) {
    String message = "RESTART;" + serialNumber + "\n";
    return sendToConsolePort(serialNumber, userId, message);
  }

  private String sendToConsolePort(String serialNumber, Integer userId, String message) {

    Connection connection = connectionService.getConnection(serialNumber);

    if (connection == null || connection.getStatus().equals("DISCONNECTED")) {
      logger.error("Module is offline... (" + serialNumber + ")");
      return "device offline";
    }

    Socket socket = null;
    BufferedReader bufferedReader = null;
    PrintWriter printWriter = null;
    try {
      logger.debug("Opening socket to " + connection.getHost() + ":" + connection.getConsolePort());
      socket = new Socket(connection.getHost(), connection.getConsolePort());
      socket.setSoTimeout(10000);
      printWriter = new PrintWriter(socket.getOutputStream());
      bufferedReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
      printWriter.write("USERID;" + userId + "\n");
      printWriter.flush();
      printWriter.write(message);
      printWriter.flush();
      String response = bufferedReader.readLine();
      logger.info("Recieved response from USERSESSION=" + response);

      if (!StringUtils.isNullOrEmpty(response)) {
        return response;
      }
      // do something with the response
    } catch (SocketException e) {
      logger.error("SocketException Serial=" + serialNumber + " Host:" + connection.getHost() + ":" + connection.getConsolePort());
    } catch (NumberFormatException e) {
      logger.error("NumberFormatException Serial=" + serialNumber + " Host:" + connection.getHost() + ":" + connection.getConsolePort());
    } catch (UnknownHostException e) {
      logger.error("UnknownHostException Serial=" + serialNumber + " Host:" + connection.getHost() + ":" + connection.getConsolePort());
    } catch (IOException e) {
      logger.error("IOException Serial=" + serialNumber + " Host:" + connection.getHost() + ":" + connection.getConsolePort());
    } finally {
      try {
        if (printWriter != null) {
          printWriter.close();
        }
        if (bufferedReader != null) {
          bufferedReader.close();
        }
        if (socket != null) {
          socket.close();
        }
      } catch (IOException e) {
        logger.error("IOException Serial=" + serialNumber + " Host:" + connection.getHost() + ":" + connection.getConsolePort());
      }
    }

    return "no response";
  }

  /**
   * getUserProductByUserId function
   * 
   * @param userId
   * @return List<UserProduct>
   */
  @Transactional(readOnly=true)
  public List<UserProduct> getUserProductByUserId(Integer userId) {
    logger.debug("getUserProductByUserId userid:" + userId);

    List<UserProduct> userProducts = userProductDAO.getUserProductsByUserId(userId);
    if (userProducts != null) {
      for (UserProduct userProduct : userProducts) {
        Connection connection = connectionService.getConnection(userProduct.getSerialNumber());

        if (connection == null) {
          userProduct.setConnected(false);
        } else {
          userProduct.setConnected(connection.getStatus().equals("CONNECTED"));
        }
      }
    }
    return userProducts;
  }

  /**
   * getUserProductBySerialNumber function
   * 
   * @param serialNumber
   * @return UserProduct
   */
  @Transactional(readOnly=true)
  public UserProduct getUserProductBySerialNumber(String serialNumber) {
    logger.debug("getUserProductBySerialNumber serialNumber:" + serialNumber);

    UserProduct userProduct = userProductDAO.getUserProductBySerialNumber(serialNumber);

    if (userProduct != null) {
      Connection connection = connectionService.getConnection(userProduct.getSerialNumber());
      if (connection == null) {
        userProduct.setConnected(false);
      } else {
        userProduct.setConnected(connection.getStatus().equals("CONNECTED"));
      }
    }
    return userProduct;
  }

  /**
   * updateUserProduct function
   * 
   * @param userProduct
   * @return Integer
   */
  @Transactional
  public Integer updateUserProduct(UserProduct userProduct) {

    String serialNumber = userProduct.getSerialNumber();

    logger.info("updateUserProduct serialNumber:" + serialNumber);

    // Not existing product
    if (getUserProductBySerialNumber(serialNumber) == null) {
      logger.error("updateUserProduct - serialNumber:" + serialNumber + " UserProduct not exist");
      return 0;
    }

    return userProductDAO.updateUserProduct(userProduct);
  }
  @Transactional
  public Integer selectUserProduct(String serialNumber, Integer userId) {
    return userProductDAO.selectUserProduct(serialNumber, userId);
  }
  @Transactional
  public Integer updateRelayStatus(String serialNumber, Integer moduleId, Integer relayId, Integer status) {

    return userProductDAO.updateRelayStatus(serialNumber, moduleId, relayId, status);
  }

  /**
   * addRelaySetting function
   * 
   * @param relaySetting
   * @param serialNumber
   * @param settingId
   * @return
   */
  @Transactional
  public Integer addRelaySetting(RelaySetting relaySetting, String serialNumber) {
    return userProductDAO.addUserProductRelaySetting(relaySetting, serialNumber);
  }

  /**
   * updateRelaySetting function
   * 
   * @param relaySetting
   * @param serialNumber
   * @param settingId
   * @return
   */
  @Transactional
  public Integer updateRelaySetting(RelaySetting relaySetting, String serialNumber) {
    return userProductDAO.updateUserProductRelaySetting(relaySetting, serialNumber);
  }

  /**
   * addUserProduct function
   * 
   * @param userProduct
   * @return
   */
  @Transactional
  public Integer addUserProduct(UserProduct userProduct) {

    List<UserProduct> userProducts = getUserProducts();

    for (UserProduct up : userProducts) {
      if (up.getSerialNumber().equals(userProduct.getSerialNumber())) {
        logger.info("addUserProduct serialNumber:" + userProduct.getSerialNumber() + " already exist...");
        return 0;
      }
    }

    return userProductDAO.addUserProduct(userProduct);
  }

  /**
   * registerProduct function
   * 
   * @param userId
   * @param serialNumber
   * @return
   */
  @Transactional
  public Integer registerProduct(Integer userId, String serialNumber) {

    boolean isValidUser = false;
    boolean isValidSerial = false;

    logger.debug("registerProduct userId:" + userId + " serialNumber:" + serialNumber);

    RegisteredProduct registeredProduct = productregistrationService.getRegisteredProductBySerialNumber(serialNumber);

    if (registeredProduct != null && registeredProduct.isRegistered() == true && registeredProduct.isActivated() == false) {
      isValidSerial = true;
      logger.debug("Valid serial number: " + serialNumber);
    }

    UserProfile userProfile = userProfileService.getUserProfileByUserId(userId);
    if (userProfile != null) {
      isValidUser = true;
      logger.debug("Valid userId: " + userId);
    }

    if (isValidUser && isValidSerial) {

      int err = productregistrationService.registerProduct(serialNumber);

      if (err == 0) {
        logger.error("Error during productRegistration. serialNumber:" + serialNumber + " userId:" + userId);
        return 0;
      }

      logger.info(serialNumber + " registered successfully.");

      ProductCategory pc = productCategoryService.getProductCategoryById(registeredProduct.getProductId());

      List<ProductUser> productUsers = new LinkedList<ProductUser>();
      ProductUser productUser = new ProductUser();
      productUser.setUserId(userProfile.getUserId());
      productUser.setUserName(userProfile.getUserName());
      productUser.setPrivilige("ADMIN");
      productUser.setSelected(false);
      productUsers.add(productUser);

      UserProduct userProduct = new UserProduct();
      userProduct.setSerialNumber(serialNumber);
      userProduct.setName(pc.getProductName());
      userProduct.setRelayCount(pc.getRelayCount());
      userProduct.setInputCount(pc.getInputCount());
      userProduct.setPhoneNumber("");
      userProduct.setPrimaryHost(pc.getPrimaryHost());
      userProduct.setPrimaryPort(pc.getPrimaryPort());
      userProduct.setSecondaryHost(pc.getSecondaryHost());
      userProduct.setSecondaryPort(pc.getSecondaryPort());
      userProduct.setEdited(true);

      ProductControlSetting productControlSetting = new ProductControlSetting();
      productControlSetting.setUserId(userProfile.getUserId());
      productControlSetting.setAccess(true);
      productControlSetting.setCallAccess(false);

      TimerSetting timerSetting = new TimerSetting();
      timerSetting.setTimerId(1);
      timerSetting.setStartTimer("8:00");
      timerSetting.setEndTimer("17:00");
      timerSetting.setStartWeekDays("");
      timerSetting.setEndWeekDays("");
      timerSetting.setTimerEnabled(false);

      for (RelaySetting relaySetting : pc.getRelaySettings()) {
        relaySetting.addProductControlSetting(productControlSetting);
        relaySetting.addTimerSetting(timerSetting);
        relaySetting.setRelayStatus("N");
      }
      userProduct.setRelaySettings(pc.getRelaySettings());
      userProduct.setInputSettings(pc.getInputSettings());

      userProduct.setProductUsers(productUsers);

      err = addUserProduct(userProduct);

      userProductDAO.selectUserProduct(serialNumber, userId);

      return err;
    }

    return 0;
  }
}
