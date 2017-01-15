/*
 * Processes.h
 *
 * Created: 2016.10.04. 16:46:29
 *  Author: tjozsa
 */ 


#ifndef PROCESSES_H_
#define PROCESSES_H_

void SmsIncome();
void checkConnectivity();
void DelSms();
void SmsCommands();
void WebApp();
void ReceiveSettings();
void RelayControl();
void SendSms(char *phonenumber, char *uzenet, char *info);


#endif /* PROCESSES_H_ */