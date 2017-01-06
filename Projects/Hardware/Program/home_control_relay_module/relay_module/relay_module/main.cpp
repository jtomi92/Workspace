/*
* relay_module.cpp
*
* Created: 2016.10.05. 21:14:06
* Author : tjozsa
*/

#include <HCM.h>
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <string.h>
#include <stdlib.h> 

const char REQUEST_RELAY_COUNT = 1;
const char SWITCH_RELAY = 4;
const char ON = 5;
const char OFF = 6;
const char OK = 7;

char relay_flag = 0;

void restoreRelayStates(){
	int i; int state;
	for (i=0;i<RELAY_COUNT;i++){
		while (!eeprom_is_ready());
		state = eeprom_read_byte((uint8_t*)i);
		if (state == 1){
			digitalWrite(pins[i],1);
		}	
	}
}

void switchRelay(const int relay, const int status){
	digitalWrite(pins[relay],status);
	while (!eeprom_is_ready());
	if (status == 1){
		eeprom_write_byte((uint8_t*)relay,1);
	} else {
		eeprom_write_byte((uint8_t*)relay,0);
	}
}

int main(void)
{
	int i; char read;
	unsigned char command, reply;
	setup();
	restoreRelayStates();
	SPDR = 0;
	
	SPI_Init_Slave();

	while (1)
	{
		
		if (digitalRead(CS) == 0){
			
			read = SPI_WriteRead(RELAY_COUNT);
			
			switch (read){
				
				case REQUEST_RELAY_COUNT:
					SPI_WriteRead(RELAY_COUNT);
					break;
				case SWITCH_RELAY:
					char relay,status;
					relay = SPI_WriteRead(OK);
					status = SPI_WriteRead(OK);
					switchRelay(relay,status);
					break;
				default:
					break;	
			}
		}
	}
}
