/*
 * Utils.h
 *
 * Created: 2016.09.24. 13:41:22
 *  Author: tjozsa
 */ 


#ifndef UTILS_H_
#define UTILS_H_

void USART_Init(void);
void USART1_SendByte(const char c);
void USART1_SendString(const char s[]);
char USART1_ReceiveByte();
void USART0_SendByte(const char c);
void USART0_SendString(const char s[]);
char USART0_ReceiveByte();
void WIFI_Write_String(const char s[]);
void GSM_Write_String(const char s[]);
void WIFI_Write_Byte(const char c);
void GSM_Write_Byte(const char c);
void turnOnSim900();
void espPower(const char pin, const char status);
void delay(const int ms);
void pinMode(const int pin, const char mode);
void digitalWrite(const int pin, const char state);
char digitalRead(const int pin);

void clearWIFIBuffer();
void clearGSMBuffer();

void defaultSettings();
void readNetworkSettings();
void clearReadLine();
void initTimer();
void powerUpModules();
void atmegaSetup();
void setup();
void setSource(const int source);




#endif /* UTILS_H_ */