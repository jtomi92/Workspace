package com.jtech.apps.hcm.hostprovider;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

import org.apache.log4j.Logger;

public class HostProvider implements Runnable {

	private Logger logger = Logger.getLogger(HostProvider.class);
	private Integer port;

	public HostProvider(Integer port) {
		this.port = port;
	}

	@Override
	public void run() {

		ServerSocket serverSocket = null;
		try {
			serverSocket = new ServerSocket(port);
			while (!Thread.interrupted()) {
				
				Socket socket = serverSocket.accept();
				Session session = new Session(socket);
				Thread thread = new Thread(session);
				thread.start();
			}

		} catch (IOException e) {
			try {
				serverSocket.close();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}

	}

}
