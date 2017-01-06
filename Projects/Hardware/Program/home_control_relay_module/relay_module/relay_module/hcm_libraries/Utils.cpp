/*
* Utils.cpp
*
* Created: 2016.09.24. 13:42:31
*  Author: tjozsa
*/
#include <Utils.h>
#include <HCM.h>

const int INPUT = 0;
const int OUTPUT = 1;

void delay(int ms){
	while (0 < ms)
	{
		_delay_ms(1);
		--ms;
	}
}
void pinMode(const int pin, const char mode){
	switch (pin){
		case 1: if (mode==1){DDRB|=(1<<5);}else{DDRB&=~(1<<5);} break;
		case 2: if (mode==1){DDRB|=(1<<6);}else{DDRB&=~(1<<6);} break;
		case 3: if (mode==1){DDRB|=(1<<7);}else{DDRB&=~(1<<7);} break;
		case 12: if (mode==1){DDRD|=(1<<3);}else{DDRD&=~(1<<3);} break;
		case 13: if (mode==1){DDRD|=(1<<4);}else{DDRD&=~(1<<4);} break;
		case 14: if (mode==1){DDRD|=(1<<5);}else{DDRD&=~(1<<5);} break;
		case 15: if (mode==1){DDRD|=(1<<6);}else{DDRD&=~(1<<6);} break;
		case 16: if (mode==1){DDRD|=(1<<7);}else{DDRD&=~(1<<7);} break;
		case 19: if (mode==1){DDRC|=(1<<0);}else{DDRC&=~(1<<0);} break;
		case 23: if (mode==1){DDRC|=(1<<4);}else{DDRC&=~(1<<4);} break;
		case 24: if (mode==1){DDRC|=(1<<5);}else{DDRC&=~(1<<5);} break;
		case 25: if (mode==1){DDRC|=(1<<6);}else{DDRC&=~(1<<6);} break;
		case 26: if (mode==1){DDRC|=(1<<7);}else{DDRC&=~(1<<7);} break;
		case 30: if (mode==1){DDRA|=(1<<7);}else{DDRA&=~(1<<7);} break;
		case 31: if (mode==1){DDRA|=(1<<6);}else{DDRA&=~(1<<6);} break;
		case 44: if (mode==1){DDRB|=(1<<4);}else{DDRB&=~(1<<4);} break;
	}
}
void digitalWrite(const int pin, const char mode){
	switch (pin){
		case 12: if(mode==1){PORTD|=(1<<3);}else{PORTD&=~(1<<3);}break;
		case 13: if(mode==1){PORTD|=(1<<4);}else{PORTD&=~(1<<4);}break;
		case 14: if(mode==1){PORTD|=(1<<5);}else{PORTD&=~(1<<5);}break;
		case 15: if(mode==1){PORTD|=(1<<6);}else{PORTD&=~(1<<6);}break;
		case 16: if(mode==1){PORTD|=(1<<7);}else{PORTD&=~(1<<7);}break;
		case 19: if(mode==1){PORTC|=(1<<0);}else{PORTC&=~(1<<0);}break;
		case 23: if(mode==1){PORTC|=(1<<4);}else{PORTC&=~(1<<4);}break;
		case 24: if(mode==1){PORTC|=(1<<5);}else{PORTC&=~(1<<5);}break;
		case 25: if(mode==1){PORTC|=(1<<6);}else{PORTC&=~(1<<6);}break;
		case 26: if(mode==1){PORTC|=(1<<7);}else{PORTC&=~(1<<7);}break;
		case 30: if(mode==1){PORTA|=(1<<7);}else{PORTA&=~(1<<7);}break;
		case 31: if(mode==1){PORTA|=(1<<6);}else{PORTA&=~(1<<6);}break;
	}
}

char digitalRead(const int pin){
	switch (pin) {
		case 44: return PINB & (1<<4); break;
	}
	return 0;
}

void atmegaSetup(){
	unsigned int i;
	
	for (i=0; i<RELAY_COUNT; i++){
		pinMode(pins[i],1);
	}
	pinMode(SCK,INPUT);
	pinMode(MISO,OUTPUT);
	pinMode(MOSI,INPUT);
	pinMode(CS,INPUT);
}
void setup(){
	
	atmegaSetup();
	
}

