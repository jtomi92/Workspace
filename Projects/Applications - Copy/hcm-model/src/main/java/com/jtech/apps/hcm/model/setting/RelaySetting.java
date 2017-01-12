package com.jtech.apps.hcm.model.setting;

import java.util.LinkedList;
import java.util.List;

public class RelaySetting {
	
	private Integer relayId;
	private Integer moduleId;
	private String relayName;
	private String relayStatus;
	private String delay;
	private boolean impulseMode;
	private boolean relayEnabled;
	private boolean delayEnabled;
	
	private List<ProductControlSetting> productControlSettings;
	private List<TimerSetting> timerSettings;
	
	private String creationDate;
	private String lastUpdateDate;
	
	public void addProductControlSetting(ProductControlSetting productControlSetting){
		if (productControlSettings == null){
			productControlSettings = new LinkedList<ProductControlSetting>();
		}
		productControlSettings.add(productControlSetting);
	}
	public void addTimerSetting(TimerSetting timerSetting){
		if (timerSettings == null){
			timerSettings = new LinkedList<TimerSetting>();
		}
		timerSettings.add(timerSetting);
	}
	public Integer getRelayId() {
		return relayId;
	}
	public void setRelayId(Integer relayId) {
		this.relayId = relayId;
	}
	public Integer getModuleId() {
		return moduleId;
	}
	public void setModuleId(Integer moduleId) {
		this.moduleId = moduleId;
	}
	public String getRelayName() {
		return relayName;
	}
	public void setRelayName(String relayName) {
		this.relayName = relayName;
	}
	public String getRelayStatus() {
		return relayStatus;
	}
	public void setRelayStatus(String relayStatus) {
		this.relayStatus = relayStatus;
	}
	public String getDelay() {
		return delay;
	}
	public void setDelay(String delay) {
		this.delay = delay;
	}
	public boolean isImpulseMode() {
		return impulseMode;
	}
	public void setImpulseMode(boolean impulseMode) {
		this.impulseMode = impulseMode;
	}
	public boolean isRelayEnabled() {
		return relayEnabled;
	}
	public void setRelayEnabled(boolean relayEnabled) {
		this.relayEnabled = relayEnabled;
	}
	public boolean isDelayEnabled() {
		return delayEnabled;
	}
	public void setDelayEnabled(boolean delayEnabled) {
		this.delayEnabled = delayEnabled;
	}
	public List<ProductControlSetting> getProductControlSettings() {
		return productControlSettings;
	}
	public void setProductControlSettings(List<ProductControlSetting> productControlSettings) {
		this.productControlSettings = productControlSettings;
	}
	public List<TimerSetting> getTimerSettings() {
		return timerSettings;
	}
	public void setTimerSettings(List<TimerSetting> timerSettings) {
		this.timerSettings = timerSettings;
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
	
	 
	 
 

}
