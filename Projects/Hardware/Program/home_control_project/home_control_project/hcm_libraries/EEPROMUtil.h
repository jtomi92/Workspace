/*
  Morse.h - Library for flashing Morse code.
  Created by David A. Mellis, November 2, 2007.
  Released into the public domain.
*/
#ifndef EEPROMUtil_h
#define EEPROMUtil_h

int eepromSaveCfg(const char *toWrite, int position);
void clearEEPROM(int startPos, int endPos);
char eepromReadAttribute(char container[], int length, char *attr, int clear);
int getPrivilige(const char *phone_number);
int getUserId(const char *phone_number);
char getCallAccess(const char *phone_number, char container[]);
int getRelaySetting(int moduleId, int relayId);
int verifyRelayAccess(char *phoneNumber, char moduleId, char relayId);
int getPrimaryNetworkSetting(char host[], char port[]);
int getSecondaryNetworkSetting(char host[], char port[]);
int getDefaultNetworkSetting(char host[], char port[]);
void getAccessPointSetting();
void initializeTimerSettingIds();
int getTimerSetting(int moduleId, int relayId);
int isCurrentTimerActive();
void processRelayTimers();

#endif