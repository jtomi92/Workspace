/*
 * HwProperties.cpp
 *
 * Created: 2016.09.30. 15:44:15
 *  Author: tjozsa
 */ 
#include <HwProperties.h>
#define TRUE 1

const char PRODUCT_NAME[] = "test product 1";

/////////////// DEFAULT Network parameters
const char NETWORK_SSID[] = "Tardis";
const char NETWORK_PASSW[] = "77Ld7cr7dW";
const char NETWORK_HOST[] = "192.168.0.27";
const char NETWORK_PORT[] = "2086";
const char NETWORK_APN[] = "online";
const int RECONNECT_TIMER = 30;
// CONNECTION CHANNEL FOR SERVER/CLIENT COMMUNICATION
const int CONNECTION = 0;

/////////////// Hardware parameters 
const int HAS_WIFI = TRUE;
const int HAS_GSM = TRUE;
const int HAS_WS28 = TRUE;

/////////////// EEPROM Stuff
const int EEPROM_SIZE = 4096;
const int EEPROM_CFG_START = 80;
const int EEPROM_DATA_START = 20;
const int EEPROM_SERIAL_START = 0;

/////////////// pinout
const int SIM_PWR = 40;
const int ESP_PWR = 41;
const int WS28_DATA = 42;
const int VCC_DETECT = 43;
const int CS_1 = 13;
const int CS_2 = 14;
const int CS_3 = 15;
const int CS_4 = 16;
const int DETECT_0 = 21;
const int DETECT_1 = 22;
const int DETECT_2 = 23;
const int DETECT_3 = 24;
const int SCK = 3;
const int MOSI = 1;
const int MISO = 2;
const int SS = 44;