#ifndef Hcm_h
#define Hcm_h

#include "Arduino.h"
#include "EEPROM.h"
#include "TimerOne.h"
#include "EEPROMUtil.h"

typedef struct {                  //SYSTIME

  int _year;
  int _month;
  int _day;
  int _hour;
  int _min;
  int _sec;
  int _mils;
  
  int connection_timer;
  int connection_timer_buffer;

} SYSTIME;

typedef struct {                  //NETWORK
  char host[30];
  char port[5];
  char ssid[20];
  char password[20];
  char apn[10];

  char isWifiConnected;
  char isGprsConnected;
  char isServerConnected;

  char wifi_readLine[100];
  char gprs_readLine[200];
  char is_wifi_input_ready;
  char is_gprs_input_ready;
  int index_wifi;
  int index_gprs;

} NETWORK;


typedef struct {
  char pin;
  char state;
  int start_timer;
  int end_timer;
  int _delay;
  int delay_enabled;
  int timer_enabled;
} RELAY_SETTING;

typedef struct {
  char pin;
  int start_timer;
  int end_timer;
  int sample_rate;
  int timer_enabled;
} INPUT_SETTING;

typedef struct {
  char input_id; 
  char relay_id;
  char trigger_enabled;
  char trigger_value;
  char trigger_state;
  char* trigger_action;
} TRIGGER_SETTING;


typedef struct {                  //SYS
  char serial_number[10];
  char admin_user[15];
  int  relay_modules[4];
  int  module_connected[4];  
} SYSTEM_VARIABLES;





class Hcm
{
  public:
	Hcm(const char *NETWORK_SSID,const  char *NETWORK_PASSW,const  char *NETWORK_HOST,const  char *NETWORK_PORT,const  char *NETWORK_APN);
	void read_network_settings();
	void setup_interrupts();
	void networking();
	void process_io();
	void system_processes();
	void discover_relay_modules();
	
  private:
	
};


#endif