package com.jtech.apps.hcm.hostprovider;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.List;
import java.util.Random;

import org.apache.log4j.Logger;

import com.jtech.apps.hcm.model.Connection;
import com.jtech.apps.hcm.util.RestUtils;

public class Session implements Runnable {

	private static final Logger logger = Logger.getLogger(Session.class);
	private Socket socket = null;
	private PrintWriter printWriter;
	private BufferedReader bufferedReader;
	private RestUtils restUtils = new RestUtils();

	public Session(Socket socket) {
		this.socket = socket;
	}

	@Override
	public void run() {

		try {
			bufferedReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			printWriter = new PrintWriter(socket.getOutputStream());
			
			String deviceName = bufferedReader.readLine();
			List<Connection> connections = restUtils.getConnections();
			
			Random rand = new Random();
			int n = rand.nextInt(10) + 1;
			int index = (n%connections.size());
			
			logger.info("conn size=" + connections.size() + " n=" + n + " index=" + index);
			
			printWriter.write("HOST=" + connections.get(index).getHost() + ";PORT=" + connections.get(index).getDevicePort() + ";\n");
			printWriter.flush();

		} catch (IOException e) {
			try {
				bufferedReader.close();
				printWriter.close();
				socket.close();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			e.printStackTrace();
		}
	}

}
