package com.jtech.apps.hcm.simulation;


public class Application 
{
	
	//private static String targetHost = "jtech-session.eu-west-1.elasticbeanstalk.com";
	private static String targetHost = "localhost";
	private static Integer targetPort = 2086;
	
    public static void main( String[] args )
    {
        VirtualDevice virtualDevice_1 = new VirtualDevice("YBDNJ1EL32", targetHost, targetPort);
        Thread thread_1 = new Thread(virtualDevice_1);
        thread_1.start();
    }
}
