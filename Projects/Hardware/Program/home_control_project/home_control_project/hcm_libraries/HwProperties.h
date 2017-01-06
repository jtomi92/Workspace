/*
 * HwProperties.h
 *
 * Created: 2016.09.30. 15:04:02
 *  Author: tjozsa
 */ 


#ifndef HWPROPERTIES_H_
#define HWPROPERTIES_H_
#endif
#ifndef MAX_MODULE_COUNT
#define MAX_MODULE_COUNT 4
#endif
#ifndef MAX_RELAY_COUNT
#define MAX_RELAY_COUNT 13 // use: max relay count + 1
#endif

extern const char PRODUCT_NAME[];

extern const char NETWORK_SSID[];
extern const char NETWORK_PASSW[];
extern const char NETWORK_HOST[];
extern const char NETWORK_PORT[];
extern const char NETWORK_APN[];
extern const int RECONNECT_TIMER;
extern const int CONNECTION;

extern const int EEPROM_SIZE; 
extern const int HAS_WIFI;
extern const int HAS_GSM;
extern const int HAS_WS28;

extern const int EEPROM_SIZE;
extern const int EEPROM_CFG_START;
extern const int EEPROM_DATA_START;
extern const int EEPROM_SERIAL_START;

extern const int SIM_PWR;
extern const int ESP_PWR;
extern const int WS28_DATA;
extern const int VCC_DETECT;
extern const int CS_1;
extern const int CS_2;
extern const int CS_3;
extern const int CS_4;
extern const int DETECT_0;
extern const int DETECT_1;
extern const int DETECT_2;
extern const int DETECT_3;
extern const int SCK;
extern const int MOSI;
extern const int MISO;
extern const int SS;
