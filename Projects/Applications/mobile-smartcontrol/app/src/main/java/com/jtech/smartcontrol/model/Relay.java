package com.jtech.smartcontrol.model;

import java.io.Serializable;

public class Relay implements Serializable{

    private Integer connectionId;
    private String serialNumber;
    private Integer moduleId;
    private Integer relayId;
    private String action;
    private String state;


    public Integer getConnectionId() {
        return connectionId;
    }
    public void setConnectionId(Integer connectionId) {
        this.connectionId = connectionId;
    }
    public String getSerialNumber() {
        return serialNumber;
    }
    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }
    public Integer getModuleId() {
        return moduleId;
    }
    public void setModuleId(Integer moduleId) {
        this.moduleId = moduleId;
    }
    public Integer getRelayId() {
        return relayId;
    }
    public void setRelayId(Integer relayId) {
        this.relayId = relayId;
    }
    public String getAction() {
        return action;
    }
    public void setAction(String action) {
        this.action = action;
    }
    public String getState() {
        return state;
    }
    public void setState(String state) {
        this.state = state;
    }


}