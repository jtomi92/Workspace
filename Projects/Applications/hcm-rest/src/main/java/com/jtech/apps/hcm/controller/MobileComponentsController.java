package com.jtech.apps.hcm.controller;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.jtech.apps.hcm.model.mobile.Component;
import com.jtech.apps.hcm.model.mobile.ComponentWrapper;
import com.jtech.apps.hcm.model.mobile.Element;
import com.jtech.apps.hcm.model.mobile.Relay;
import com.jtech.apps.hcm.service.MobileComponentService;


@RestController
public class MobileComponentsController {

  @Autowired
  MobileComponentService mobileComponentService;
  
  private Logger logger = Logger.getLogger(MobileComponentsController.class);

  @RequestMapping(value = "/mobile/components/get/{userid}/", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<ComponentWrapper> getComponentsByUserId(@PathVariable("userid") Integer userId) {
    List<Component> componentList = mobileComponentService.getComponents(userId);
    ComponentWrapper componentWrapper = new ComponentWrapper();
    componentWrapper.setComponents(componentList);
    return new ResponseEntity<ComponentWrapper>(componentWrapper, HttpStatus.OK);
  }
  
  @RequestMapping(value = "/mobile/component/add/{userid}/", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<Integer> addComponent(@PathVariable("userid") Integer userId, @RequestBody Component component) {
    int err = mobileComponentService.addComponent(userId, component);
    logger.info("Add component...");
    return new ResponseEntity<Integer>(err, HttpStatus.OK);
  }
  
  @RequestMapping(value = "/mobile/component/update/{userid}/", method = RequestMethod.PUT, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<Integer> updateComponent(@PathVariable("userid") Integer userId, @RequestBody Component component) {
    int err = mobileComponentService.updateComponent(userId, component);
    return new ResponseEntity<Integer>(err, HttpStatus.OK);
  }
  
  @RequestMapping(value = "/mobile/components/update/{userid}/", method = RequestMethod.PUT, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<Integer> updateComponents(@PathVariable("userid") Integer userId, @RequestBody ComponentWrapper componentBundle) {
    int err = mobileComponentService.updateComponents(userId, componentBundle);
    return new ResponseEntity<Integer>(err, HttpStatus.OK);
  }
  
  @RequestMapping(value = "/mobile/component/delete/{userid}/{componentid}/", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<Integer> deleteComponent(@PathVariable("userid") Integer userId, @PathVariable("componentid") Integer componentId) {
    int err = mobileComponentService.deleteComponent(userId, componentId);
    return new ResponseEntity<Integer>(err, HttpStatus.OK);
  }
  
  @RequestMapping(value = "/mobile/component/test/", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<Component> getTest() {
    Component component = new Component();
    component.setComponentId(1);
    component.setComponentName("Test Component");
    component.setSequence(1);
    
    Element e1 = new Element();
    e1.setElementId(1);
    e1.setElementIcon("icon 1");
    e1.setElementName("test element 1");
    e1.setElementType("element type 1");
    e1.setSequence(1);
    
    Relay r1 = new Relay();
    r1.setConnectionId(1);
    r1.setSerialNumber("Test serial 1");
    r1.setModuleId(1);
    r1.setRelayId(1);
    r1.setAction("Test action 1");
    r1.setState("test state 1");
    
    Relay r2 = new Relay();
    r2.setConnectionId(2);
    r2.setSerialNumber("Test serial 2");
    r2.setModuleId(2);
    r2.setRelayId(2);
    r2.setAction("Test action 2");
    r2.setState("test state 2");
    
    e1.addRelay(r1);
    e1.addRelay(r2);
    
    
    Element e2 = new Element();
    e2.setElementId(2);
    e2.setElementIcon("icon 2");
    e2.setElementName("test element 2");
    e2.setElementType("element type 2");
    e2.setSequence(2);
    
    e2.addRelay(r1);
    
    component.addElement(e1);
    component.addElement(e2);
    
    return new ResponseEntity<Component>(component, HttpStatus.OK);
  }
  

}
