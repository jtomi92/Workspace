/*
 * Network.h
 *
 * Created: 2016.09.30. 13:50:52
 *  Author: tjozsa
 */ 


#ifndef NETWORK_H_
#define NETWORK_H_

int readUntil(const char *input, int timeout);
void sendToServer(char *toSend, int connection);
void sendToAP(char *toSend, char *connection);
void networking();

/*char getSystemTime();
char setSerialNumber();
char checkSerialNumber();
char connectToWifi(const char *ssid, const char *password);
char connectToGprs(const char *apn);
char connectToServer(const char *host, const char *port);*/

#endif /* NETWORK_H_ */