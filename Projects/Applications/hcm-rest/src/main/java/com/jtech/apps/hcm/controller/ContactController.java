package com.jtech.apps.hcm.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.jtech.apps.hcm.model.Contact;
import com.jtech.apps.hcm.service.ContactService;

@Controller
public class ContactController {
  
  @Autowired
  ContactService contactService;

  @RequestMapping(value = "/contact/add/", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<Integer> addContactMessage(@RequestBody Contact contact) {
    
    int err = contactService.addContactMessage(contact); 
    return new ResponseEntity<Integer>(err, HttpStatus.OK);
  }
  
}
