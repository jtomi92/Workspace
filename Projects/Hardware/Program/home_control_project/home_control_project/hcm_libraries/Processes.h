/*
 * Processes.h
 *
 * Created: 2016.10.04. 16:46:29
 *  Author: tjozsa
 */ 


#ifndef PROCESSES_H_
#define PROCESSES_H_

void ConfigurationThread();
void ReceiveSettings();
void RelayControl();
void CheckModuleConnections();
void HeartBeat();
void ProcessRelayTimers();
void checkGsmNetwork();
void IncomingCallHandler();
void IncomingSMSHandler();
void SendSms(char *phonenumber, char *uzenet, char *info);

#endif /* PROCESSES_H_ */