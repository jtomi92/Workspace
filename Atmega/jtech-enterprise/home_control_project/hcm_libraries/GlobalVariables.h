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

typedef struct {                  //SYS
	char serial_number[15];
	char admin_user[15];
	int  relay_modules[4];
	int  module_connected[4];
	int  module_flags[4];
	int detect_pins[4];
	char interface_;
	int timer0_overflow;
	int eeprom_position;
	
	int relay_states[5];
	int opto_states[3];
} SYSTEM_VARIABLES;

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
	
	int check_timer;
	int check_timer_buffer;
	int interrupt_flag;

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
	
	char network_available;
	char sms_income;
	char admin[13];
	char phone_buffer[13];

} NETWORK;
typedef struct {
	char module_id;
	char relay_id;
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

extern SYSTEM_VARIABLES __system_var;
extern NETWORK __network_data;
extern SYSTIME __system_time;

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

extern const int EEPROM_SERIAL_START;
extern const int EEPROM_DATA_START;
extern const int EEPROM_CFG_START;


extern const char REQUEST_RELAY_COUNT;
extern const char RECIEVE;
extern const char END_RECIEVE;
extern const char SWITCH_RELAY;

#endif /* TYPES_H_ */  