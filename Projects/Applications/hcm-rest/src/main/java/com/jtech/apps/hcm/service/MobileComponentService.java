package com.jtech.apps.hcm.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jtech.apps.hcm.dao.interfaces.MobileComponentsDAO;
import com.jtech.apps.hcm.model.mobile.Component;
import com.jtech.apps.hcm.model.mobile.ComponentWrapper;

@Service
public class MobileComponentService {
  
  @Autowired
  MobileComponentsDAO mobileComponentsDAO;
  
  @Transactional(readOnly=true)
  public List<Component> getComponents(Integer userId){
    return mobileComponentsDAO.getComponentsByUserId(userId);
  }
  @Transactional
  public int addComponent(Integer userId, Component component){
    return mobileComponentsDAO.addComponent(userId, component);
  }
  @Transactional
  public int updateComponent(Integer userId, Component component){
    return mobileComponentsDAO.updateComponent(userId, component);
  }
  @Transactional
  public int updateComponents(Integer userId, ComponentWrapper componentBundle){
    int err = 1;
    for (Component component : componentBundle.getComponents()) {
      err = mobileComponentsDAO.updateComponent(userId, component);
    }
    return err;
  }
  @Transactional
  public int deleteComponent(Integer userId, Integer componentId){
    return mobileComponentsDAO.deleteComponent(userId, componentId);
  }
}
