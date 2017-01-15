/*
 * SPI.h
 *
 * Created: 2016.10.06. 21:19:21
 *  Author: tjozsa
 */ 


#ifndef SPI_H_
#define SPI_H_

void chipSelect(const int module, const int status);
unsigned char SPI_WriteRead(unsigned char toWrite);
const void SPI_Write(unsigned char toWrite);
void SPI_init_master();



#endif /* SPI_H_ */