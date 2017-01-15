/*
 * hw_utils.h
 *
 * Created: 1/14/2017 8:46:50 PM
 *  Author: tjozsa
 */ 


#ifndef HW_UTILS_H_
#define HW_UTILS_H_

extern char bluetooth_buffer[100];
extern int bluetooth_buffer_index;
extern char data_received;

void clear();
void USART0_SendString(const char s[]);
void USART0_SendByte(const char c);
void USART_Init(void);
void delay_us(int us);
void delay_ms(int ms);

void setup();

#endif /* HW_UTILS_H_ */