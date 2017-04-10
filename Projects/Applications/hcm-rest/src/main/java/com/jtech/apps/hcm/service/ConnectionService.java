package com.jtech.apps.hcm.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jtech.apps.hcm.dao.ConnectionDAOImpl;
import com.jtech.apps.hcm.model.Connection;

@Service
public class ConnectionService {

	@Autowired
	ConnectionDAOImpl connectionDAO;

	@Transactional
	public int addConnection(Connection connection) {

		return connectionDAO.addConnection(connection);
	}

	@Transactional
	public int updateConnection(Connection connection) {

		Connection conn = getConnection(connection.getSerialNumber());
		if (conn == null) {
			return addConnection(connection);
		}
		return connectionDAO.updateConnection(connection);
	}

	@Transactional(readOnly=true)
	public Connection getConnection(String serialNumber) {

		return connectionDAO.getConnection(serialNumber);
	}

	@Transactional(readOnly=true)
	public List<Connection> getConnections() {
		
		return connectionDAO.getConnections();
	}
 
}
