package com.jtech.apps.hcm.dao;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import com.jtech.apps.hcm.dao.mapper.ProductCategoryMapper;
import com.jtech.apps.hcm.model.mobile.Component;
import com.jtech.apps.hcm.model.mobile.Element;
import com.jtech.apps.hcm.model.mobile.Input;
import com.jtech.apps.hcm.model.mobile.Relay;

@Repository
public class MobileComponentsDAOImpl {

  @Autowired
  JdbcTemplate jdbcTemplate;
  ProductCategoryMapper mapper = new ProductCategoryMapper();
  private NamedParameterJdbcTemplate namedParameterJdbcTemplate;

  public List<Component> getComponentsByUserId(Integer userId) {

    List<Component> components = new LinkedList<Component>();

    String sql = "SELECT * FROM MOBILE_COMPONENTS WHERE USER_ID = ?";

    List<Map<String, Object>> rows = new LinkedList<Map<String, Object>>();

    rows = jdbcTemplate.queryForList(sql, userId);

    if (rows != null && !rows.isEmpty()) {
      for (Map<String, Object> row : rows) {
        Component component = new Component();
        component.setComponentId((Integer) row.get("COMPONENT_ID"));
        component.setComponentName((String) row.get("COMPONENT_NAME"));
        component.setSequence((Integer) row.get("SEQUENCE"));
        component.setElements(getElementsByComponent(userId, component.getComponentId()));

        components.add(component);
      }
    }

    return components;
  }

  private List<Element> getElementsByComponent(Integer userId, Integer componentId) {

    List<Element> elements = new LinkedList<Element>();

    String sql = "SELECT * FROM MOBILE_COMPONENT_ELEMENTS WHERE USER_ID = ? AND COMPONENT_ID = ?";

    List<Map<String, Object>> rows = new LinkedList<Map<String, Object>>();

    rows = jdbcTemplate.queryForList(sql, userId, componentId);

    if (rows != null && !rows.isEmpty()) {
      for (Map<String, Object> row : rows) {
        Element element = new Element();
        element.setElementId((Integer) row.get("ELEMENT_ID"));
        element.setElementName((String) row.get("ELEMENT_NAME"));
        element.setElementIcon((String) row.get("ELEMENT_ICON"));
        element.setElementType((String) row.get("ELEMENT_TYPE"));
        element.setSequence((Integer) row.get("SEQUENCE"));
        element.setRelays(getRelaysByElement(userId, componentId, element.getElementId()));
        element.setInputs(getInputsByElement(userId, componentId, element.getElementId()));
        elements.add(element);
      }
    }

    return elements;
  }

  private List<Relay> getRelaysByElement(Integer userId, Integer componentId, Integer elementId) {

    List<Relay> relays = new LinkedList<Relay>();

    String sql = "SELECT * FROM MOBILE_ELEMENT_RELAYS WHERE USER_ID = ? AND COMPONENT_ID = ? AND ELEMENT_ID = ?";

    List<Map<String, Object>> rows = new LinkedList<Map<String, Object>>();

    rows = jdbcTemplate.queryForList(sql, userId, componentId, elementId);

    if (rows != null && !rows.isEmpty()) {
      for (Map<String, Object> row : rows) {
        Relay relay = new Relay();
        relay.setConnectionId((Integer) row.get("CONNECTION_ID"));
        relay.setSerialNumber((String) row.get("SERIAL_NUMBER"));
        relay.setModuleId((Integer) row.get("MODULE_ID"));
        relay.setRelayId((Integer) row.get("RELAY_ID"));
        relay.setAction((String) row.get("ACTION"));
        relay.setState((String)row.get("STATE"));

        relays.add(relay);
      }
    }

    return relays;
  }

  private List<Input> getInputsByElement(Integer userId, Integer componentId, Integer elementId) {
    return null;
  }

  public int updateComponent(Integer userId, Component component) {

    String sql = "UPDATE MOBILE_COMPONENTS SET COMPONENT_NAME = :COMPONENT_NAME, SEQUENCE = :SEQUENCE WHERE USER_ID = :USER_ID AND COMPONENT_ID = :COMPONENT_ID";

    Map<String, Object> parameters = new HashMap<String, Object>();
    parameters.put("COMPONENT_NAME", component.getComponentName());
    parameters.put("SEQUENCE", component.getSequence());
    parameters.put("USER_ID", userId);
    parameters.put("COMPONENT_ID", component.getComponentId());

    deleteElements(userId, component.getComponentId());
    if (component.getElements() != null && component.getElements().size() != 0) {
      for (Element element : component.getElements()) {
        addElement(userId, component.getComponentId(), element);
      }
    }

    namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
    SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
    return namedParameterJdbcTemplate.update(sql, namedParameters);
  }

  public int deleteElements(Integer userId, Integer componentId) {

    String sql = "DELETE FROM MOBILE_COMPONENT_ELEMENTS WHERE USER_ID = ? AND COMPONENT_ID = ?";
    return jdbcTemplate.update(sql, userId, componentId);
  }

  public int addElement(Integer userId, Integer componentId, Element element) {

    String sql = "INSERT INTO MOBILE_COMPONENT_ELEMENTS (USER_ID, COMPONENT_ID, ELEMENT_ID, ELEMENT_NAME, ELEMENT_ICON, ELEMENT_TYPE, SEQUENCE)"
            + " VALUES (:USER_ID, :COMPONENT_ID, :ELEMENT_ID, :ELEMENT_NAME, :ELEMENT_ICON, :ELEMENT_TYPE, :SEQUENCE)";

    Map<String, Object> parameters = new HashMap<String, Object>();
    parameters.put("USER_ID", userId);
    parameters.put("COMPONENT_ID", componentId);
    parameters.put("ELEMENT_ID", element.getElementId());
    parameters.put("ELEMENT_NAME", element.getElementName());
    parameters.put("ELEMENT_ICON", element.getElementIcon());
    parameters.put("ELEMENT_TYPE", element.getElementType());
    parameters.put("SEQUENCE", element.getSequence());

    deleteElementRelays(userId, componentId, element.getElementId());
    if (element.getRelays() != null && element.getRelays().size() != 0) {
      for (Relay relay : element.getRelays()) {
        addElementRelay(userId, componentId, element.getElementId(), relay);
      }
    }

    namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
    SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
    return namedParameterJdbcTemplate.update(sql, namedParameters);
  }

  public int deleteElementRelays(Integer userId, Integer componentId, Integer elementId) {
    String sql = "DELETE FROM MOBILE_ELEMENT_RELAYS WHERE USER_ID = ? AND COMPONENT_ID = ? AND ELEMENT_ID = ?";
    return jdbcTemplate.update(sql, userId, componentId, elementId);
  }

  public int addElementRelay(Integer userId, Integer componentId, Integer elementId, Relay relay) {
    String sql = "INSERT INTO MOBILE_ELEMENT_RELAYS (USER_ID, COMPONENT_ID, ELEMENT_ID, CONNECTION_ID, SERIAL_NUMBER, MODULE_ID, RELAY_ID, ACTION, STATE)"
            + " VALUES (:USER_ID, :COMPONENT_ID, :ELEMENT_ID, :CONNECTION_ID, :SERIAL_NUMBER, :MODULE_ID, :RELAY_ID, :ACTION, :STATE)";

    Map<String, Object> parameters = new HashMap<String, Object>();
    parameters.put("USER_ID", userId);
    parameters.put("COMPONENT_ID", componentId);
    parameters.put("ELEMENT_ID", elementId);
    parameters.put("CONNECTION_ID", relay.getConnectionId());
    parameters.put("SERIAL_NUMBER", relay.getSerialNumber());
    parameters.put("MODULE_ID", relay.getModuleId());
    parameters.put("RELAY_ID", relay.getRelayId());
    parameters.put("ACTION", relay.getAction());
    parameters.put("STATE", relay.getState());

    namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
    SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
    return namedParameterJdbcTemplate.update(sql, namedParameters);
  }

  public int deleteComponent(Integer userId, Integer componentId) {

    deleteElements(userId, componentId);
    String sql = "DELETE FROM MOBILE_COMPONENTS WHERE USER_ID = ? AND COMPONENT_ID = ?";
    return jdbcTemplate.update(sql, userId, componentId);
  }

  public int addComponent(Integer userId, Component component) {

    String sql = "INSERT INTO MOBILE_COMPONENTS (USER_ID, COMPONENT_ID, COMPONENT_NAME, SEQUENCE) VALUES (:USER_ID, :COMPONENT_ID, :COMPONENT_NAME, :SEQUENCE)";

    Map<String, Object> parameters = new HashMap<String, Object>();
    parameters.put("USER_ID", userId);
    parameters.put("COMPONENT_ID", component.getComponentId());
    parameters.put("COMPONENT_NAME", component.getComponentName());
    parameters.put("SEQUENCE", component.getSequence());

    if (component.getElements() != null && component.getElements().size() != 0) {
      for (Element element : component.getElements()) {
        addElement(userId, component.getComponentId(), element);
      }
    }

    namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate.getDataSource());
    SqlParameterSource namedParameters = new MapSqlParameterSource(parameters);
    return namedParameterJdbcTemplate.update(sql, namedParameters);
  }
}
