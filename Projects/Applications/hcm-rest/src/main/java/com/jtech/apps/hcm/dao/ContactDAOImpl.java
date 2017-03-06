package com.jtech.apps.hcm.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import com.jtech.apps.hcm.model.Contact;
import com.jtech.apps.hcm.util.TimeUtil;

@Repository
public class ContactDAOImpl {

  @Autowired
  JdbcTemplate jdbcTemplate;

  private NamedParameterJdbcTemplate namedParameterJdbcTemplate;

  public Integer addContactMessage(Contact contact) {
    String sql = "INSERT INTO CONTACT_US_MESSAGES (EMAIL, NAME, MESSAGE, CREATION_DATE) VALUES (:EMAIL, :NAME, :MESSAGE, :CREATION_DATE)";

    Map<String, Object> parameters = new HashMap<String, Object>();
    parameters.put("EMAIL", contact.getEmail());
    parameters.put("NAME", contact.getName());
    parameters.put("MESSAGE", contact.getMessage());
    parameters.put("CREATION_DATE", TimeUtil.getTimeStamp());

    namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
    SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
    return namedParameterJdbcTemplate.update(sql, namedParameters);
  }
}
