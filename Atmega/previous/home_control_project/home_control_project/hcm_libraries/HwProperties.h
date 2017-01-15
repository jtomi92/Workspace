/*
 * HwProperties.h
 *
 * Created: 2016.09.30. 15:04:02
 *  Author: tjozsa
 */ 


#ifndef HWPROPERTIES_H_
#define HWPROPERTIES_H_

extern const char product_name[];

extern const char NETWORK_SSID[];
extern const char NETWORK_PASSW[];
extern const char NETWORK_HOST[];
extern const char NETWORK_PORT[];
extern const char NETWORK_APN[];
extern const int RECONNECT_TIMER;
extern const int CONNECTION;

extern const int HAS_ESP;
extern const int HAS_SIM;
extern const int SIM_PWR;
extern const int ESP_PWR;

extern const int EEPROM_SIZE; 

extern const int RELAY_1;
extern const int RELAY_2;
extern const int RELAY_3;
extern const int RELAY_4;
extern const int RELAY_5;
extern const int OPTO_1;
extern const int OPTO_2;
extern const int OPTO_3;


#endif /* HWPROPERTIES_H_ */