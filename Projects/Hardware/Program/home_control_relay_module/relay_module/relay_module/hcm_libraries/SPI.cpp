/*
 * SPI.cpp
 *
 * Created: 2016.10.07. 11:27:37
 *  Author: tjozsa
 */ 
#include <SPI.h>
#include <HCM.h>

void SPI_Init_Slave(void)
{
	unsigned char tmp;
	
	//SPCR &= ~(1<<MSTR);                // Set as slave
	//SPCR |= (1<<SPR0)|(1<<SPR1);       // divide clock by 128
	SPCR |= (1<<SPE);
	SPDR = 0;
}

//Function to send and receive data for both master and slave
unsigned char SPI_WriteRead (unsigned char data)
{
	char unsigned tmp;
	// Load data into the buffer
	SPDR = data;
	//Wait until transmission complete
	while(!(SPSR & (1<<SPIF) ));
	// Return received data
	return(SPDR);
}

//Function to send and receive data for both master and slave
void SPI_Write (unsigned char data)
{
	char unsigned tmp;
	// Load data into the buffer
	SPDR = data;
	//Wait until transmission complete
	while(!(SPSR & (1<<SPIF) ));
}

//Function to send and receive data for both master and slave
unsigned char SPI_Read ()
{	
	//Wait until transmission complete
	while(!(SPSR & (1<<SPIF) ));
	
	// Return received data
	return(SPDR);
}


