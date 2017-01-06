/*
 * Utils.h
 *
 * Created: 2016.09.24. 13:41:22
 *  Author: tjozsa
 */ 


#ifndef UTILS_H_
#define UTILS_H_

void delay(const int ms);
void pinMode(const int pin, const char mode);
void digitalWrite(const int pin, const char state);
char digitalRead(const int pin);
void atmegaSetup();
void setup();

#endif /* UTILS_H_ */