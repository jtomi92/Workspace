package com.jtech.apps.hcm.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class TimeUtil {
	
	public static String getTimeStamp(){
		String timeStamp = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(Calendar.getInstance().getTime());
		return timeStamp;
	}
	
	public static String getTimeStampWithDifference(Integer difference){
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.SECOND, cal.get(Calendar.SECOND)-difference);

		String timeStamp = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(cal.getTime());
		return timeStamp;
	}

}
