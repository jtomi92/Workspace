/*
  Morse.h - Library for flashing Morse code.
  Created by David A. Mellis, November 2, 2007.
  Released into the public domain.
*/
#ifndef EEPROMUtil_h
#define EEPROMUtil_h

int isAdmin(const char *phone_number);
int verifyRelayAccess(const char *phone_number, int relay, int isCall);
void eepromClear();
char eepromReadAttribute(char container[], int length, char *attr, int clear);
void eepromSaveSerial(const char *toWrite);
void eepromSaveData(const char *toWrite);
int eepromSaveCfg(const char *toWrite, int position);
/*void buildUserString(char *buffer, char *relay_access, char *relay_call);
char addUser(char *phone_number, char* privilige, char *relay_access, char *relay_call);
int removeUser(char *phone_number, char *privilige);*/


#endif