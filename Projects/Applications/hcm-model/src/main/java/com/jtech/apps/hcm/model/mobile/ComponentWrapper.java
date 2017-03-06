package com.jtech.apps.hcm.model.mobile;

import java.util.LinkedList;
import java.util.List;

public class ComponentWrapper {
  
  List<Component> components;

  public List<Component> getComponents() {
    return components;
  }

  public void setComponents(List<Component> components) {
    this.components = components;
  }
  
  public boolean addComponent(Component component){
    if (components == null){
      components = new LinkedList<Component>();
    }
    return components.add(component);
  }
  
}
