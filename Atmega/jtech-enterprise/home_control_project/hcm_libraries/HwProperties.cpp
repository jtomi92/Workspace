/*
 * HwProperties.cpp
 *
 * Created: 2016.09.30. 15:44:15
 *  Author: tjozsa
 */ 
#include <HwProperties.h>

const char product_name[] = "test product 1";

/////////////// Network parameters
const char NETWORK_SSID[] = "Tardis";
const char NETWORK_PASSW[] = "77Ld7cr7dW";
const char NETWORK_HOST[] = "jtech-session.eu-west-1.elasticbeanstalk.com";
const char NETWORK_PORT[] = "2088";
const char NETWORK_APN[] = "online";
const int RECONNECT_TIMER = 30;
const int CONNECTION = 0;

const int HAS_ESP = 1;
const int HAS_SIM = 1;

const int EEPROM_SIZE = 4096;

/////////////// Hardware parameters (pinout)
const int SIM_PWR = 40;
const int ESP_PWR = 40;
const int RELAY_1 = 16;
const int RELAY_2 = 20;
const int RELAY_3 = 26;
const int RELAY_4 = 19;
const int RELAY_5 = 25;
const int OPTO_1 = 33;
const int OPTO_2 = 34;
const int OPTO_3 = 37;
 
