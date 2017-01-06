/*
 * SPI.h
 *
 * Created: 2016.10.07. 11:27:26
 *  Author: tjozsa
 */ 


#ifndef SPI_H_
#define SPI_H_

void SPI_Init_Slave(void);
unsigned char SPI_WriteRead (unsigned char data);
void SPI_Write (unsigned char data);
unsigned char SPI_Read();

#endif /* SPI_H_ */