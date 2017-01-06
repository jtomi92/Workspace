/*
 * SPI.cpp
 *
 * Created: 2016.10.06. 21:19:32
 *  Author: tjozsa
 */ 
#include <SPI.h>
#include <HCM.h>

void chipSelect(const int module, const int status){
	delay(100);
	switch (module){
		case 0: digitalWrite(CS_1,status);	break;
		case 1: digitalWrite(CS_2,status);	break;
		case 2: digitalWrite(CS_3,status);	break;
		case 3: digitalWrite(CS_4,status);	break;
	}
	delay(100);
}

void SPI_init_master(){
	SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPR0);
	SPDR = 0;
}

const void SPI_Write(unsigned char toWrite)
{	

	SPDR = toWrite;

	while(!(SPSR & (1<<SPIF)));

}

unsigned char SPI_WriteRead(unsigned char toWrite)
{
	unsigned char data;
												
	SPDR = toWrite;								
	
	while(!(SPSR & (1<<SPIF)));
	
	data = SPDR;
	
	return data;
}


