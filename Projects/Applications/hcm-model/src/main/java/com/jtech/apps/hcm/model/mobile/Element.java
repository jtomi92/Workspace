package com.jtech.apps.hcm.model.mobile;

import java.util.LinkedList;
import java.util.List;

public class Element {

  private Integer elementId;
  private String elementName;
  private String elementIcon;
  private String elementType;
  private Integer sequence;

  private List<Relay> relays;
  private List<Input> inputs;
  

  public Integer getElementId() {
    return elementId;
  }

  public void setElementId(Integer elementId) {
    this.elementId = elementId;
  }

  public String getElementName() {
    return elementName;
  }

  public void setElementName(String elementName) {
    this.elementName = elementName;
  }

  public String getElementIcon() {
    return elementIcon;
  }

  public void setElementIcon(String elementIcon) {
    this.elementIcon = elementIcon;
  }

  public String getElementType() {
    return elementType;
  }

  public void setElementType(String elementType) {
    this.elementType = elementType;
  }

  public Integer getSequence() {
    return sequence;
  }

  public void setSequence(Integer sequence) {
    this.sequence = sequence;
  }

  public List<Relay> getRelays() {
    return relays;
  }

  public void setRelays(List<Relay> relays) {
    this.relays = relays;
  }

  public List<Input> getInputs() {
    return inputs;
  }

  public void setInputs(List<Input> inputs) {
    this.inputs = inputs;
  }

  public boolean addRelay(Relay relay) {
    if (relays == null) {
      relays = new LinkedList<Relay>();
    }
    return relays.add(relay);
  }

  public boolean removeRelay(Relay relay) {
    if (relays == null) {
      return false;
    }
    return relays.remove(relay);
  }

  public boolean addInput(Input input) {
    if (inputs == null) {
      inputs = new LinkedList<Input>();
    }
    return inputs.add(input);
  }

  public boolean removeInput(Input input) {
    if (inputs == null) {
      return false;
    }
    return inputs.remove(input);
  }

}
