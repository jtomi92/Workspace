/*
 * SPI.cpp
 *
 * Created: 2016.10.06. 21:19:32
 *  Author: tjozsa
 */ 
#include <SPI.h>
#include <HCM.h>

void chipSelect(const int module, const int status){
 
}

void SPI_init_master(){
	unsigned char tmp;
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


