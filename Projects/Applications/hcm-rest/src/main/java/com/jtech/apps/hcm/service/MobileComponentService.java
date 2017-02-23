package com.jtech.apps.hcm.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jtech.apps.hcm.dao.interfaces.MobileComponentsDAO;
import com.jtech.apps.hcm.model.mobile.Component;
import com.jtech.apps.hcm.model.mobile.ComponentBundle;

@Service
public class MobileComponentService {
  
  @Autowired
  MobileComponentsDAO mobileComponentsDAO;
  
  public List<Component> getComponents(Integer userId){
    return mobileComponentsDAO.getComponentsByUserId(userId);
  }
  public int addComponent(Integer userId, Component component){
    return mobileComponentsDAO.addComponent(userId, component);
  }
  public int updateComponent(Integer userId, Component component){
    return mobileComponentsDAO.updateComponent(userId, component);
  }
  public int updateComponents(Integer userId, ComponentBundle componentBundle){
    int err = 1;
    for (Component component : componentBundle.getComponents()) {
      err = mobileComponentsDAO.updateComponent(userId, component);
    }
    return err;
  }
  public int deleteComponent(Integer userId, Integer componentId){
    return mobileComponentsDAO.deleteComponent(userId, componentId);
  }
}
