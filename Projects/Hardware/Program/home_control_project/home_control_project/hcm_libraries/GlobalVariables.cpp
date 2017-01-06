/*
 * Types.cpp
 *
 * Created: 2016.09.30. 14:17:47
 *  Author: tjozsa
 */ 
#include <GlobalVariables.h>
#include <HCM.h>

SYSTEM_VARIABLES __system_var;
NETWORK __network_data;
SYSTIME __system_time;
RELAY_SETTING __relay_setting;
TIMER_SETTING __timer_setting;
TIMER_RECORDS __timer_records[MAX_MODULE_COUNT];
RELAY_STATES __relay_states[MAX_MODULE_COUNT];


const int USART_BAUDRATE = 9600;
const int BAUD_PRESCALE = (((F_CPU / (USART_BAUDRATE * 16UL))) - 1);
const int ESP = 1;
const int SIM = 0;
const int TRUE = 1;
const int FALSE = 0;
const int SERVER_CONNECTED = 1;
const int WIFI_CONNECTED = 1;
const int GPRS_CONNECTED = 1;
const int DAYS_OF_MONTH[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
	
const int INPUT = 0;
const int OUTPUT = 1;

const char REQUEST_RELAY_COUNT = 1;
const char RECIEVE = 2;
const char END_RECIEVE = 3;
const char SWITCH_RELAY = 4;