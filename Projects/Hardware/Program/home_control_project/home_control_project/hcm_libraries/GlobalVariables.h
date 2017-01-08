/*
 * Types.h
 *
 * Created: 2016.09.30. 14:10:28
 *  Author: tjozsa
 */ 

#ifndef GLOBALVARIABLES_H_
#define GLOBALVARIABLES_H_

#ifndef F_CPU
#define F_CPU 10000000UL
#endif

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <string.h>
#include <stdlib.h>
#include <HCM.h>

typedef struct {                  //SYS
	char serial_number[15];
	char admin_user[15];
	int  relay_modules[MAX_MODULE_COUNT];
	int  module_connected[MAX_MODULE_COUNT];
	int  module_flags[MAX_MODULE_COUNT];
	int detect_pins[MAX_MODULE_COUNT];
	char interface_;
	int timer0_overflow;
	int eeprom_position;
	int update_flag;
	char enabled_flag;
} SYSTEM_VARIABLES;

typedef struct {                  //SYSTIME

	int _year;
	int _month;
	int _day;
	int _day_of_week;
	int _hour;
	int _min;
	int _sec;
	int _mils;
	
	int connection_timer;
	int connection_timer_buffer;
	
	int check_timer;
	int check_timer_buffer;
	
	int relay_module_check_timer;
	int relay_module_check_timer_buffer;
	
	int timer_check_timer;
	int timer_check_timer_buffer;
	
	int gsm_network_timer;
	int gsm_network_timer_buffer;

} SYSTIME;
typedef struct {                  //NETWORK
	char host[30];
	char port[5];
	char ssid[20];
	char password[20];
	char apn[10];

	char is_esp_connected;
	char is_sim_connected;
	char is_server_connected;

	char esp_buffer[300];
	char sim_buffer[200];
	char is_esp_read_line;
	char is_sim_read_line;
	unsigned int index_esp;
	unsigned int index_sim;

} NETWORK;
typedef struct {
	int module_id;
	int relay_id;
	int _delay;
	int impulse;
	int users[30];
} RELAY_SETTING;

typedef struct {
	int states[MAX_RELAY_COUNT];
} RELAY_STATES;

typedef struct  {
	int module_id;
	int relay_id;
	int timer_id;
	int start_timer;
	int start_week[8];
	int end_timer;
	int end_week[8];
} TIMER_SETTING;

typedef struct {
	int moduleId;
	int relays[MAX_RELAY_COUNT];
} TIMER_RECORDS;

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

extern SYSTEM_VARIABLES __system_var;
extern NETWORK __network_data;
extern SYSTIME __system_time;
extern RELAY_SETTING __relay_setting;
extern TIMER_SETTING __timer_setting;
extern TIMER_RECORDS __timer_records[MAX_MODULE_COUNT];
extern RELAY_STATES __relay_states[MAX_MODULE_COUNT];

extern const int USART_BAUDRATE; 
extern const int BAUD_PRESCALE; 
extern const int ESP; 
extern const int SIM; 
extern const int TRUE; 
extern const int FALSE;
extern const int OUTPUT;
extern const int INPUT; 

extern const int RECONNECT_TIMER;
extern const int SERVER_CONNECTED;
extern const int WIFI_CONNECTED;
extern const int GPRS_CONNECTED;
extern const int DAYS_OF_MONTH[12];

extern const char REQUEST_RELAY_COUNT;
extern const char RECIEVE;
extern const char END_RECIEVE;
extern const char SWITCH_RELAY;

#endif /* TYPES_H_ */  