/*
 * Processes.h
 *
 * Created: 2016.10.04. 16:46:29
 *  Author: tjozsa
 */ 


#ifndef PROCESSES_H_
#define PROCESSES_H_

void WebApp();
void ReceiveSettings();
void RelayControl();
void CheckModuleConnections();
void HeartBeat();
void ProcessRelayTimers();
void checkGsmNetwork();
void IncomingCallHandler();
void IncomingSMSHandler();

#endif /* PROCESSES_H_ */