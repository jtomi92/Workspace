package com.jtech.apps.hcm.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jtech.apps.hcm.dao.interfaces.ProductCategoryDAO;
import com.jtech.apps.hcm.model.ProductCategory;

@Service
public class ProductCategoryService {

	@Autowired
	ProductCategoryDAO productCategoryDAO;
 
	@Transactional(readOnly=true)
	public ProductCategory getProductCategoryById(Integer productId) {
		return productCategoryDAO.getProductCategoryBy("PRODUCT_ID", productId.toString());
	}
	@Transactional(readOnly=true)
	public ProductCategory getProductCategoryByProductName(String productName) {
		return productCategoryDAO.getProductCategoryBy("PRODUCT_NAME", productName);
	}
	@Transactional(readOnly=true)
	public List<ProductCategory> getProductCategories() {
		return productCategoryDAO.getProductCategories();
	}
	@Transactional(readOnly=true)
	public ProductCategory getTestData() {
		return productCategoryDAO.getTestData();
	}
	@Transactional
	public int updateProductCategory(ProductCategory productCategory) {

		return productCategoryDAO.updateProductCategory(productCategory);
	}
	@Transactional
	public int addProductCategory(ProductCategory productCategory) {

		List<ProductCategory> productCategories = getProductCategories();

		for (ProductCategory pc : productCategories) {
			if (pc.getProductName().equals(productCategory.getProductName())) {
				return 0;
			}
		}
		return productCategoryDAO.addProductCategory(productCategory);
	}
}
