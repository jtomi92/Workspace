package com.jtech.smartcontrol.model.setting;

public class TimerSetting {

	private Integer timerId;
	private String startWeekDays;
	private String endWeekDays;
	private String startTimer;
	private String endTimer;
	private boolean timerEnabled;
	
	
	public Integer getTimerId() {
		return timerId;
	}
	public void setTimerId(Integer timerId) {
		this.timerId = timerId;
	}
	public String getStartWeekDays() {
		return startWeekDays;
	}
	public void setStartWeekDays(String startWeekDays) {
		this.startWeekDays = startWeekDays;
	}
	public String getEndWeekDays() {
		return endWeekDays;
	}
	public void setEndWeekDays(String endWeekDays) {
		this.endWeekDays = endWeekDays;
	}
	public String getStartTimer() {
		return startTimer;
	}
	public void setStartTimer(String startTimer) {
		this.startTimer = startTimer;
	}
	public String getEndTimer() {
		return endTimer;
	}
	public void setEndTimer(String endTimer) {
		this.endTimer = endTimer;
	}
	public boolean isTimerEnabled() {
		return timerEnabled;
	}
	public void setTimerEnabled(boolean timerEnabled) {
		this.timerEnabled = timerEnabled;
	}
	
	
}
