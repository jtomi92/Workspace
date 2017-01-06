/*
  Morse.h - Library for flashing Morse code.
  Created by David A. Mellis, November 2, 2007.
  Released into the public domain.
*/
#ifndef EEPROMUtil_h
#define EEPROMUtil_h

#include "Arduino.h"
#include "EEPROM.h"

class EEPROMUtil
{
  public:
	EEPROMUtil(int EEPROM_SIZE, int RELAY_SIZE, int INPUT_SIZE);
	int isAdmin(char *phone_number);
	int verifyRelayAccess(char *phone_number, char relay, char isCall);
	void buildUserString(char *buffer, char *relay_access, char *relay_call);
	char addUser(char *phone_number, char* privilige, char *relay_access, char *relay_call);
	int removeUser(char *phone_number, char *privilige);

};

#endif