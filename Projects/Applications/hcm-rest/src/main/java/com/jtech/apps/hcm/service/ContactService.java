package com.jtech.apps.hcm.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jtech.apps.hcm.dao.ContactDAOImpl;
import com.jtech.apps.hcm.model.Contact;

@Service
public class ContactService {
  
  @Autowired
  ContactDAOImpl contactDAOImpl;

  @Transactional
  public Integer addContactMessage(Contact contact){
    return contactDAOImpl.addContactMessage(contact);
  }
}
