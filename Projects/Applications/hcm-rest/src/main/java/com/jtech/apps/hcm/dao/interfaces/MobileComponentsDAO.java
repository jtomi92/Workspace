package com.jtech.apps.hcm.dao.interfaces;

import java.util.List;

import com.jtech.apps.hcm.model.mobile.Component;

public interface MobileComponentsDAO {

  public List<Component> getComponentsByUserId(Integer userId);
  public int updateComponent(Integer userId, Component component);
  public int deleteComponent(Integer userId, Integer componentId);
  public int addComponent(Integer userId, Component component);
  
}
