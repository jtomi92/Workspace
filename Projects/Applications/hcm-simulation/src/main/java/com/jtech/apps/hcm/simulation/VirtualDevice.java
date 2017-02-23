package com.jtech.apps.hcm.simulation;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Scanner;

import org.apache.log4j.Logger;

public class VirtualDevice implements Runnable {

	private static final Logger logger = Logger.getLogger(VirtualDevice.class);

	private String serialNumber;
	private String host;
	private Integer port;
	private BufferedReader bufferedReader = null;
	private PrintWriter printWriter = null;
	private Socket socket = null;

	public VirtualDevice(String host, Integer port) {
		this.serialNumber = null;
		this.host = host;
		this.port = port;
	}

	public VirtualDevice(String serialNumber, String host, Integer port) {
		this.serialNumber = serialNumber;
		this.host = host;
		this.port = port;
	}

	public void run() {

		try {
			socket = new Socket(host, port);
			bufferedReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			printWriter = new PrintWriter(socket.getOutputStream());

			// GET TIME
			logger.info("RECIEVED=" + bufferedReader.readLine());

			// SEND / REQUEST SERIAL NUMBER
			if (serialNumber != null) {
				send("#SERIAL_NUMBER;" + serialNumber + ";\n");
			} else {
				send("#REQUEST_SERIAL_NUMBER\n");
			}

			// HEARTBEAT THREAD
			Thread heartBeatThread = heartBeatThread();
			heartBeatThread.start();
			// USERINTERFACE THREAD
			Thread userInterfaceThread = userInterfaceThread();
			userInterfaceThread.start();

			while (!Thread.interrupted()) {

				String readLine = bufferedReader.readLine();
				
				if (readLine == null) continue;
				logger.info("RECIEVED=" + readLine);

				if (readLine.contains("[CFG]") && readLine.contains("END")) {
					send("#OK\n");
					send("#NOTIFICATION;UPDATED;\n");
				}
				
				if (readLine.contains("[CFG]")) {
					send("#OK\n");
				}

				if (readLine.contains("SWITCHRELAY")) {
				  try {
            Thread.sleep(2400);
          } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
          }
					String[] args = readLine.split(";");
					send("#NOTIFICATION;SWITCH;" + args[1] + ";" + args[2]  + ";" + args[3] + ";\n");
				}
				
				if (readLine.contains("MULTI-SWITCH")){
				  try {
            Thread.sleep(2400);
          } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
          }
				  StringBuilder response = new StringBuilder("#NOTIFICATION;MULTI-SWITCH?");
				  
				  String[] line = readLine.split("\\?");
				  for (int i=1; i<line.length; i++){
				    String[] args = line[i].split(";");
				    Integer moduleId = Integer.parseInt(args[0]);
				    Integer relayId = Integer.parseInt(args[1]);
				    Integer state = Integer.parseInt(args[2]);
				    
				    response.append(moduleId + ";" + relayId + ";" + state + ";?");
				  }
				  response.append("\n");
				  send(response.toString());
				}
				// MULTI-SWITCH?1;1;1;?2;2;1;?
				 
				if (readLine.contains("UPDATE")) {
					try {
						Thread.sleep(5000);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					send("#REQUEST_UPDATE\n");
				}
			}
			logger.info("Closing VirtualDevice Thread");

		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
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

	private void send(String toSend) {
		logger.info("SENT=" + toSend);
		printWriter.write(toSend);
		printWriter.flush();
	}

	private Thread heartBeatThread() {
		Thread thread = new Thread(new Runnable() {

			public void run() {
				while (!Thread.interrupted()) {
					try {
						Thread.sleep(10000);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					send("#CHECK\n");
				}
			}
		});
		return thread;
	}

	private Thread userInterfaceThread() {
		Thread thread = new Thread(new Runnable() {

			public void run() {
				Scanner sc = new Scanner(System.in);
				while (!Thread.interrupted()) {
					String read = sc.nextLine();
					logger.info("UserInput=" + read);

					if (read.contains("1")){
						send("#RELAYCONNECTIONS;1:14;2:10;4:12\n");
					} else if (read.contains("2")){
						send("#RELAYCONNECTIONS;1:10;2:8;4:15\n");
					} else if (read.contains("3")){
						send("#RELAYCONNECTIONS;\n");
					}

				}
			}
		});
		return thread;
	}
	// RELAYCONNECTIONS;1:14;2:10;4:12

}
