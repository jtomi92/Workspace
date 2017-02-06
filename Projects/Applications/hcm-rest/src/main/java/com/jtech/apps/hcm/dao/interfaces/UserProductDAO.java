package com.jtech.apps.hcm.dao.interfaces;

import java.util.List;

import com.jtech.apps.hcm.model.UserProduct;
import com.jtech.apps.hcm.model.setting.InputSetting;
import com.jtech.apps.hcm.model.setting.ProductControlSetting;
import com.jtech.apps.hcm.model.setting.ProductTriggerSetting;
import com.jtech.apps.hcm.model.setting.ProductUser;
import com.jtech.apps.hcm.model.setting.RelaySetting;


public interface UserProductDAO {

	public int selectUserProduct(String serialNumber, Integer userId);
	
	public int addUserProduct(UserProduct userProduct);

	public int addProductUser(ProductUser productUser, String serialNumber);

	public int addUserProductRelaySetting(RelaySetting relaySettings, String serialNumber);

	public int addUserProductInputSetting(InputSetting inputSetting, String serialNumber);

	public int addUserProductControlSetting(ProductControlSetting productControlSetting, String serialNumber,
			Integer relayId, Integer moduleId);

	public int addUserProductTriggerSetting(ProductTriggerSetting productTriggerSetting, String serialNumber,
			Integer inputId);

	public List<UserProduct> getUserProducts();
	
	public UserProduct getUserProductBySerialNumber(String serialNumber);
	
	public List<UserProduct> getUserProductsByUserId(Integer userId);

	public List<RelaySetting> getRelaySettings(String serialNumber);

	public List<InputSetting> getInputSettings(String serialNumber);

	public List<ProductControlSetting> getUserProductControlSettings(String serialNumber, Integer relayId,
			Integer moduleId);

	public List<ProductTriggerSetting> getProductTriggetSetting(String serialNumber, Integer inputId);

	public int updateUserProduct(UserProduct userProduct);

	public int updateUserProductRelaySetting(RelaySetting relaySettings, String serialNumber);

	public int updateUserProductInputSetting(InputSetting inputSettings, String serialNumber);

	public int updateUserProductTriggerSetting(ProductTriggerSetting productTriggerSetting, String serialNumber,
			Integer inputId);

	public int updateUserProductControlSetting(ProductControlSetting productTriggerSetting, String serialNumber,
			Integer relayId);

	public int deleteUserProductControlSettings(String serialNumber, Integer relayId, Integer moduleId);

	public int deleteUserProductTriggerSettings(String serialNumber, Integer inputId);

	public int updateRelayStatus(String serialNumber, Integer moduleId, Integer relayId, Integer status);
}
