package com.jtech.apps.hcm.dao.interfaces;

import java.util.List;
import com.jtech.apps.hcm.model.ProductCategory;
import com.jtech.apps.hcm.model.setting.InputSetting;
import com.jtech.apps.hcm.model.setting.RelaySetting;

public interface ProductCategoryDAO {


	public ProductCategory getProductCategoryBy(String entity, String value);
	public List<ProductCategory> getProductCategories();
	public List<InputSetting> getInputSettings(Integer productId);
	public List<RelaySetting> getRelaySettings(Integer productId);
	
	public int updateProductCategory(ProductCategory pc);
	public int updateRelaySetting(RelaySetting rs, Integer productId);
	public int updateInputSetting(InputSetting is, Integer productId);
	
	public int addProductCategory(ProductCategory productCategory);
	public int addRelaySetting(RelaySetting relaySetting, Integer productId);
	public int addInputSetting(InputSetting inputSetting, Integer productId);
	public ProductCategory getTestData();
	
	
	
}
