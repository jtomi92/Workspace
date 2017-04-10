package com.jtech.apps.hcm.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jtech.apps.hcm.dao.ProductRegistrationDAOImpl;
import com.jtech.apps.hcm.model.RegisteredProduct;
import com.jtech.apps.hcm.util.TimeUtil;

@Service
public class ProductRegistrationService {

	@Autowired
	ProductRegistrationDAOImpl productRegistrationDAO;

	@Transactional
	public int registerProduct(String serial) {
		return productRegistrationDAO.registerProduct(serial);
	}
	@Transactional
	public int addRegisteredProduct(RegisteredProduct registeredProduct) {
		List<RegisteredProduct> registeredProducts = getRegisteredProducts();

		if (registeredProduct != null) {
			for (RegisteredProduct rp : registeredProducts) {
				if (rp.getSerialNumber().equals(registeredProduct.getSerialNumber())) {
					return 0;
				}
			}
		}
		return productRegistrationDAO.addRegisteredProduct(registeredProduct);
	}
	@Transactional
	public int updateRegisteredProduct(RegisteredProduct registeredProduct) {
		return productRegistrationDAO.updateRegisteredProduct(registeredProduct);
	}
	@Transactional(readOnly=true)
	public RegisteredProduct getRegisteredProductBySerialNumber(String serialNumber) {
		return productRegistrationDAO.getRegisteredProductBySerialNumber(serialNumber);
	}
	@Transactional(readOnly=true)
	public List<RegisteredProduct> getRegisteredProducts() {
		return productRegistrationDAO.getRegisteredProducts();
	}
	@Transactional(readOnly=true)
	public RegisteredProduct getTestData() {
		RegisteredProduct registeredProduct = new RegisteredProduct();
		registeredProduct.setSerialNumber("TEST_SERIAL");
		registeredProduct.setProductId(1);
		registeredProduct.setActivated(false);
		registeredProduct.setRegistered(true);
		registeredProduct.setLastUpdateDate(TimeUtil.getTimeStamp());
		registeredProduct.setCreationDate(TimeUtil.getTimeStamp());
		return registeredProduct;
	}
}
