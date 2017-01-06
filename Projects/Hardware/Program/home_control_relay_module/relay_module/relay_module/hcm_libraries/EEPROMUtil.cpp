#include <EEPROMUtil.h> //include the declaration for this class
#include <HCM.h>


int isAdmin(const char *phone_number) {
	int i, j = 0, flag = 0;
	char read[27], dat;

	for (i = 0; i < EEPROM_SIZE; i++) {

		while(!eeprom_is_ready());
		dat = eeprom_read_byte((uint8_t*)i);
		
		if (dat == '#') {
			flag = !flag;
		}

		if (flag == 1) {
			read[j++] = dat;
			} else {
			if (j > 0) {
				read[j++] = '#';
				read[j] = '\0';

				if ( strstr(read, phone_number) != 0 && strstr(read, "ADMIN") != 0 ) {
					return TRUE;
					} else {
					j = 0;
					memset(read, 0, sizeof(read) - 1);
				}
			}
		}
	}
	return FALSE;
}


int verifyRelayAccess(const char *phone_number, int relay, int isCall) {
	int i, j = 0, flag = 0;
	char read[27], dat;

	relay--;

	for (i = 0; i < EEPROM_SIZE; i++) {

		while(!eeprom_is_ready());
		dat = eeprom_read_byte((uint8_t*)i);
		
		if (dat == '#') {
			flag = !flag;
		}

		if (flag == 1) {
			read[j++] = dat;
			} else {
			if (j > 0) {
				read[j++] = '#';
				read[j] = '\0';

				if ( strstr(read, phone_number) != 0 ) {

					char *p1, config[10];
					p1 = strtok(read, ";");
					p1 = strtok(0, ";");
					strcpy(config, p1);

					if (isCall) {
						int rel = atoi(strtok(0, "#"));
						if (config[rel-1] == '1')
						return rel;
						else
						return 0;
					}
					
					if (config[relay] == '0' || config[relay] == '1'){
						return config[relay] - '0';
						} else {
						return 0;
					}
					} else {
					j = 0;
					memset(read, 0, sizeof(read) - 1);
				}
			}
		}
	}
	return FALSE;
}

void eepromClear(){
	int i;
	char c;
	for (i = 20; i < EEPROM_SIZE; i++){
		while(!eeprom_is_ready());
		c = eeprom_read_byte((uint8_t*)i);
		if (c == 0xFF) break;
		while(!eeprom_is_ready());
		eeprom_write_byte((uint8_t*)i,0xFF);
	}
}

char eepromReadAttribute(char container[], int length, char *attr, int clear){

	int index, j = 0, flag = 0;
	char dat,*p1, buffer[100];
	int attrLength=0;
	
	if (clear == 1) __system_var.eeprom_position = 0;
	p1 = attr;
	for(;*p1++!='\0';attrLength++);

	for (index = __system_var.eeprom_position; index < EEPROM_SIZE; index++) {

		//while(!eeprom_is_ready());
		dat = eeprom_read_byte((uint8_t*)index);

		if (dat == '#') {
			flag = !flag;
		}

		if (flag == 1) {
			buffer[j++] = dat;
			} else {
			if (j > 0) {
				buffer[j] = '\0';
				if ( strstr(buffer, attr) != 0 ) {
					int pos=0;
					char *p1 = strstr(buffer,attr)+(attrLength+1);
					while (*p1!='\0'){
						if (pos == length) return 0;
						container[pos++] = *p1++;
					}
					__system_var.eeprom_position = index+1;
					return 1;
					} else {
					j = 0;
					memset(buffer, 0, sizeof(buffer) - 1);
				}
			}
		}
	}
	return 0;
}

void eepromSaveSerial(const char *toWrite){
	int pos = EEPROM_SERIAL_START;

	while(*toWrite != '\0'){
		while(!eeprom_is_ready());
		eeprom_write_byte((uint8_t*)pos++,*toWrite++);
		
	}
}

void eepromSaveData(const char *toWrite){
	int pos = EEPROM_DATA_START;

	while(*toWrite != '\0'){
		while(!eeprom_is_ready());
		eeprom_write_byte((uint8_t*)pos++,*toWrite++);
		
	}
}
int eepromSaveCfg(const char *toWrite, int position){

	while(*toWrite != '\0'){
		eeprom_write_byte((uint8_t*)position++,*toWrite++);
	}
	return position;
}



/*
void buildUserString(char *buffer, char *relay_access, char *relay_call) {
char *p1;
int size = 0, i;
p1 = relay_access;
for (; *p1++ != '\0'; size++);
if (size > RELAY_SIZE) size = RELAY_SIZE;


*buffer++ = ';';

for (i = 0; i < size; i++) {
char ch = *relay_access++;
if (ch == '0' || ch == '1') {
*buffer++ = ch;
} else {
*buffer++ = '0';
}
}

for (i = size; i < RELAY_SIZE; i++) {
*buffer++ = '0';
}
*buffer++ = ';';
if (atoi(relay_call) <= RELAY_SIZE && atoi(relay_call) != 0) {
*buffer++ = *relay_call;
} else {
*buffer++ = '0';
}
*buffer++ = '#';
*buffer = '\0';
}

char addUser(char *phone_number, char* privilige, char *relay_access, char *relay_call) {
int i, j = 0, flag = 0;
char to_write[27];
unsigned char dat;


for (i = 0; i < EEPROM_SIZE; i++) {

while(!eeprom_is_ready());
dat = eeprom_read_byte((uint8_t*)i);
if (dat == '#') {
flag = !flag;
}

if (flag == 1) {
to_write[j++] = dat;
} else {
if (j > 0) {
if (  strstr(to_write, privilige) != 0 && strstr(to_write, phone_number) != 0 ) {
return FALSE;
} else {
j = 0;
memset(to_write, 0, sizeof(to_write) - 1);
}
}
}
}

char *cfg, buffer[14];
int k;
char enough_space = 0;

buildUserString(buffer, relay_access, relay_call);
strcpy(to_write, "#");
strcat(to_write, privilige);
strcat(to_write, ":");
strcat(to_write, phone_number);
strcat(to_write, buffer);

for (i = 0; i < EEPROM_SIZE; i++) {

while(!eeprom_is_ready());
dat = eeprom_read_byte((uint8_t*)i);

if (dat == 254) {
enough_space++;
} else {
enough_space = 0;
}
if (enough_space == strlen(to_write)) {
break;
}
}
if (i == EEPROM_SIZE) {
return FALSE;
}

i = i - strlen(to_write);
for (k = 0; k < strlen(to_write); k++) {
while(!eeprom_is_ready());
eeprom_write_byte((uint8_t*)i++, to_write[k]);
}
return TRUE;

}

int removeUser(char *phone_number, char *privilige) {
int i, j = 0, flag = 0;
char read[27];
unsigned char dat;
for (i = 0; i < EEPROM_SIZE; i++) {

while(!eeprom_is_ready());
dat = eeprom_read_byte((uint8_t*)i);
if (dat == '#') {
flag = !flag;
}

if (flag == 1) {
read[j++] = dat;
} else {
if (j > 0) {
read[j++] = '#';
read[j] = '\0';

if ( strstr(read, privilige) != 0 && strstr(read, phone_number) != 0 ) {
int k;
for (k = i - strlen(read) + 1; k <= i; k++) {
eeprom_write_byte((uint8_t*)k, 254);
}
return TRUE;
} else {
j = 0;
memset(read, 0, sizeof(read) - 1);
}
}
}

if (dat == 254) {
return FALSE;
}
}
return FALSE;
}
*/


