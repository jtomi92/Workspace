package com.jtech.smartcontrol.model;

import java.util.List;

public class Notification {
	
	//serial number
	private String sn;
	// connection
	private Integer cn;
	// relaystates
	private List<RelayState> rs;
	// notification strings
	private List<String> ns;
	
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	 
	public Integer getCn() {
		return cn;
	}
	public void setCn(Integer cn) {
		this.cn = cn;
	}
	public List<RelayState> getRs() {
		return rs;
	}
	public void setRs(List<RelayState> rs) {
		this.rs = rs;
	}
	public List<String> getNs() {
		return ns;
	}
	public void setNs(List<String> ns) {
		this.ns = ns;
	}
	
	
	 
	
	
	
}
