package com.jtech.apps.hcm.server;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.List;

import org.apache.log4j.Logger;

public class UserSession implements Runnable {

	private static final Logger logger = Logger.getLogger(UserSession.class);
	private Integer userId = 0;
	private Socket socket;
	private BufferedReader bufferedReader;
	private PrintWriter printWriter;
	private boolean isAlive = true;

	public UserSession(Socket socket) {
		this.socket = socket;
	}

	public Integer getUserId() {
		return userId;
	}

	/**
	 * HEARTBEAT every 3 seconds to NotificationService or to the REST
	 */
	@Override
	public void run() {

		try {

			bufferedReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));

			printWriter = new PrintWriter(socket.getOutputStream());
			
			socket.setSoTimeout(20000);

			while (!Thread.interrupted()) {

				String read = bufferedReader.readLine();

				logger.info("READ: " + read);

				processIO(read);

			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {

		} finally {
			logger.info("Closing User Session for userid " + userId);
			isAlive = false;
			UserSessionProvider.getInstance().removeDeadSessions();

			try {
				if (printWriter != null) {
					printWriter.close();
				}
				if (bufferedReader != null) {
					bufferedReader.close();
				}
				if (socket != null) {
					socket.close();
				}

			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}

	}

	/**
	 * Recieves SWITCH command is recieved through the rest service, also this
	 * function is part of the NotificationService to provide device updates for
	 * the user.
	 * 
	 * @param io
	 */
	private void processIO(String io) {
	  
	  List<DeviceSession> deviceSessions;
		String arguments[] = io.split(";");
		String serialNumber;
		Integer moduleId;
		Integer relayId;
		Integer state;
		Integer componentId;
		Integer elementId;
		String action;
		
		switch (arguments.length) {

		case 1:

			break;

		case 2:
			switch (arguments[0]) {
			case "USERID":
				userId = Integer.parseInt(arguments[1]);
				logger.info("USERID is=" + userId);
				break;

			case "UPDATE":
				deviceSessions = DeviceSessionProvider.getInstance().getDeviceSessionsBySerialNumber(arguments[1]);
				for (DeviceSession deviceSession : deviceSessions) {
					deviceSession.updateUserProduct();
					logger.info("UPDATE SerialNumber=" + arguments[1]);
				}
				break;
						
			case "RESTART":
				deviceSessions = DeviceSessionProvider.getInstance().getDeviceSessionsBySerialNumber(arguments[1]);
				for (DeviceSession deviceSession : deviceSessions) {
					deviceSession.restartUserProduct();
					logger.info("RESTART SerialNumber=" + arguments[1]);
				}			
				break;
			}
			break;

		case 5:
		  
		  
			switch (arguments[0]) {
	
			case "SWITCH":
				serialNumber = arguments[1];
				moduleId = Integer.parseInt(arguments[2]);
				relayId = Integer.parseInt(arguments[3]);
				state = Integer.parseInt(arguments[4]);
				
				deviceSessions = DeviceSessionProvider.getInstance().getDeviceSessionsBySerialNumber(serialNumber);

				for (DeviceSession deviceSession : deviceSessions) {
					deviceSession.switchRelay(moduleId,relayId, state);
					logger.info("Switching..." + io);
				}	
				
				break;
				
				// "MULTI-SWITCH;" + serialNumber + ";" + componentId + ";" + elementId + ";" + action + "\n";
			case "MULTI-SWITCH":
        serialNumber = arguments[1];
        componentId = Integer.parseInt(arguments[2]);
        elementId = Integer.parseInt(arguments[3]);
        action = arguments[4];
        
        deviceSessions = DeviceSessionProvider.getInstance().getDeviceSessionsBySerialNumber(serialNumber);
        for (DeviceSession deviceSession : deviceSessions) {
          deviceSession.switchRelays(userId, componentId,elementId, action);
        } 
        
        break;
			}
			break;
		}

	}

	/**
	 * Pushes notifications from backend to user interfaces
	 * 
	 * @param toWrite
	 */
	public void notifyUserSession(String toWrite) {
		logger.info("Notifying User with id=" + userId + " message:" + toWrite);
		printWriter.write(toWrite + "\n");
		printWriter.flush();
	}

	public boolean isAlive() {
		return isAlive;
	}

	public void setAlive(boolean isAlive) {
		this.isAlive = isAlive;
	}

}
