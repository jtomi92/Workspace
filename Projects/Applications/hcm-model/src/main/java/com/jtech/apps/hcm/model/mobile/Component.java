package com.jtech.apps.hcm.model.mobile;

import java.util.LinkedList;
import java.util.List;

public class Component {

  private Integer componentId;
  private String componentName;
  private Integer sequence;
  private List<Element> elements;
  
  
  public Integer getComponentId() {
    return componentId;
  }

  public void setComponentId(Integer componentId) {
    this.componentId = componentId;
  }

  public String getComponentName() {
    return componentName;
  }

  public void setComponentName(String componentName) {
    this.componentName = componentName;
  }

  public Integer getSequence() {
    return sequence;
  }

  public void setSequence(Integer sequence) {
    this.sequence = sequence;
  }

  public List<Element> getElements() {
    return elements;
  }

  public void setElements(List<Element> elements) {
    this.elements = elements;
  }

  public boolean addElement(Element element) {
    if (elements == null) {
      elements = new LinkedList<Element>();
    }
    return elements.add(element);
  }

  public boolean removeElement(Element element) {
    if (elements == null) {
      return false;
    }
    return elements.remove(element);
  }

}
