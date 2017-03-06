package com.jtech.smartcontrol.model;

import com.jtech.smartcontrol.model.setting.InputSetting;
import com.jtech.smartcontrol.model.setting.ProductUser;
import com.jtech.smartcontrol.model.setting.RelaySetting;

import java.util.List;

public class UserProduct {

	private String serialNumber;
	private String name;
	private Integer relayCount;
	private Integer inputCount;
	private String phoneNumber;
	private String primaryHost;
	private String primaryPort;
	private String secondaryHost;
	private String secondaryPort;
	private boolean isConnected;
	private boolean isEdited;
	private boolean isSelected;

	private String creationDate;
	private String lastUpdateDate;

	private List<RelaySetting> relaySettings;
	private List<InputSetting> inputSettings;
	private List<ProductUser> productUsers;

	public void addProductUser(ProductUser productUser) {
		productUsers.add(productUser);
	}

	public void removeProductUser(ProductUser productUser) {
		productUsers.remove(productUser);
	}

	public String getSerialNumber() {
		return serialNumber;
	}

	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getRelayCount() {
		return relayCount;
	}

	public void setRelayCount(Integer relayCount) {
		this.relayCount = relayCount;
	}

	public Integer getInputCount() {
		return inputCount;
	}

	public void setInputCount(Integer inputCount) {
		this.inputCount = inputCount;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public String getPrimaryHost() {
		return primaryHost;
	}

	public void setPrimaryHost(String primaryHost) {
		this.primaryHost = primaryHost;
	}

	public String getPrimaryPort() {
		return primaryPort;
	}

	public void setPrimaryPort(String primaryPort) {
		this.primaryPort = primaryPort;
	}

	public String getSecondaryHost() {
		return secondaryHost;
	}

	public void setSecondaryHost(String secondaryHost) {
		this.secondaryHost = secondaryHost;
	}

	public String getSecondaryPort() {
		return secondaryPort;
	}

	public void setSecondaryPort(String secondaryPort) {
		this.secondaryPort = secondaryPort;
	}

	public boolean isConnected() {
		return isConnected;
	}

	public void setConnected(boolean isConnected) {
		this.isConnected = isConnected;
	}

	public String getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(String creationDate) {
		this.creationDate = creationDate;
	}

	public String getLastUpdateDate() {
		return lastUpdateDate;
	}

	public void setLastUpdateDate(String lastUpdateDate) {
		this.lastUpdateDate = lastUpdateDate;
	}

	public List<RelaySetting> getRelaySettings() {
		return relaySettings;
	}

	public void setRelaySettings(List<RelaySetting> relaySettings) {
		this.relaySettings = relaySettings;
	}

	public List<InputSetting> getInputSettings() {
		return inputSettings;
	}

	public void setInputSettings(List<InputSetting> inputSettings) {
		this.inputSettings = inputSettings;
	}

	public List<ProductUser> getProductUsers() {
		return productUsers;
	}

	public void setProductUsers(List<ProductUser> productUsers) {
		this.productUsers = productUsers;
	}

	public boolean isEdited() {
		return isEdited;
	}

	public void setEdited(boolean isEdited) {
		this.isEdited = isEdited;
	}

	public boolean isSelected() {
		return isSelected;
	}

	public void setSelected(boolean isSelected) {
		this.isSelected = isSelected;
	}
	

}
