#include <stdio.h>
#include <stdlib.h>

#define TRUE 1
#define FALSE 0
#define MAX_RELAY_COUNT 13
#define MAX_MODULE_COUNT 4

char eeprom[4096];
int EEPROM_SIZE = 4096;
int EEPROM_CFG_START = 80;
int EEPROM_DATA_START = 20;
int EEPROM_SERIAL_START = 0;
const char NETWORK_SSID[] = "Tardis";
const char NETWORK_PASSW[] = "77Ld7cr7dW";
const char NETWORK_HOST[] = "192.168.0.27";
const char NETWORK_PORT[] = "86";
const char NETWORK_APN[] = "online";

typedef struct {
	int module_id;
	int relay_id;
	int _delay;
    int impulse;
    int users[30];
} __relay_setting;
__relay_setting relaySetting;

typedef struct {                  //NETWORK
	char host[30];
	char port[5];
	char ssid[20];
	char password[20];
	char apn[10];

	char is_esp_connected;
	char is_sim_connected;
	char is_server_connected;

	char esp_buffer[300];
	char sim_buffer[200];
	char is_esp_read_line;
	char is_sim_read_line;
	unsigned int index_esp;
	unsigned int index_sim;

} NETWORK;
NETWORK __network_data;

typedef struct {                  //SYSTIME

	int _year;
	int _month;
	int _day;
	int _day_of_week;
	int _hour;
	int _min;
	int _sec;
	int _mils;

} SYSTIME;
SYSTIME systemTime;

//pos = eepromSaveCfg("#TS;MI:1;RI:3;TI:1;ST:8:00;SW:1,2,3,4,5,6,7;ET:17:00;EW:1,2,3,4,5,6,7;#",pos);

typedef struct  {
    int module_id;
	int relay_id;
	int timer_id;
	int start_timer;
	int start_week[8];
	int end_timer;
	int end_week[8];
} __timer_setting;
__timer_setting timerSetting;

typedef struct {
    int moduleId;
    int relays[MAX_RELAY_COUNT];
} __timer_records;
__timer_records timerRecords[MAX_MODULE_COUNT];

struct {
    int eeprom_position;
} __system_var;


void eeprom_write_byte(int position, char toWrite){
    eeprom[position] = toWrite;
}
char eeprom_read_byte(int position){
    return eeprom[position];
}
char eeprom_is_ready(){
    return 1;
}

int eepromSaveCfg(const char *toWrite, int position){

	while(*toWrite != '\0'){
        while(!eeprom_is_ready());
		eeprom_write_byte(position++,*toWrite++);
	}
	return position;
}

void clearEEPROM(){
	int i;
	char c;
	for (i = EEPROM_CFG_START; i < EEPROM_SIZE; i++){
		while(!eeprom_is_ready());
		c = eeprom_read_byte(i);
		if (c == 0xFF) break;
		while(!eeprom_is_ready());
		eeprom_write_byte(i,0xFF);
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

		while(!eeprom_is_ready());
		dat = eeprom_read_byte(index);

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
						if (pos == length-1) return 0;
						container[pos++] = *p1++;
					}
					container[pos] = '\0';

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

int getPrivilige(const char *phone_number) {
	char container[100];

	__system_var.eeprom_position = 0;
	while (eepromReadAttribute(container, sizeof(container), "USR", 0) != 0){
        if (strstr(container,phone_number) != 0 && strstr(container,"ADMIN")) return 1;
        if (strstr(container,phone_number) != 0 && strstr(container,"USER")) return 2;
	}

	return 0;
}

// return userid, if user does not exist, it returns -1
int getUserId(const char *phone_number) {
	char container[100];

	__system_var.eeprom_position = 0;
	while (eepromReadAttribute(container, sizeof(container), "USR", 0) != 0){
        if (strstr(container,phone_number) != 0){
            char *save_ptr1, *save_ptr2, *p1, *p2;
            p1 = strtok_r(container,";",&save_ptr1);
            while (p1 != 0){
               if (strstr(p1,"UI")){
                    p2 = strtok_r(p1,":",&save_ptr2);
                    p2 = strtok_r(0,":",&save_ptr2);
                    return atoi(p2);
               }
               p1 = strtok_r(0,";",&save_ptr1);
            }
        }
	}

	return -1;
}

// pass char array to store moduleis/relayid,... priviliges, returns 0 if user not found
char getCallAccess(const char *phone_number, char container[]){
    char buffer[100];

	__system_var.eeprom_position = 0;
	while (eepromReadAttribute(buffer, sizeof(buffer), "USR", 0) != 0){
        if (strstr(buffer,phone_number) != 0){
            char *save_ptr1, *save_ptr2, *p1, *p2;
            p1 = strtok_r(buffer,";",&save_ptr1);
            while (p1 != 0){
               if (strstr(p1,"CA")){
                    p2 = strtok_r(p1,":",&save_ptr2);
                    p2 = strtok_r(0,":",&save_ptr2);
                    strcpy(container,p2);
                    return 1;
               }
               p1 = strtok_r(0,";",&save_ptr1);
            }
        }
	}

	return 0;
}

int verifyRelayAccess(char *phoneNumber, char moduleId, char relayId){
    int userId = getUserId(phoneNumber);
    if (userId == -1) return 0;
    if (getRelaySetting(1,1) == 1){
        int i;
        for (i=0; relaySetting.users[i] != 254; i++){
            if (relaySetting.users[i] == userId){
                return 1;
            }
        }
    }
    return 0;
}

int getRelaySetting(int moduleId, int relayId){
char container[100]; char *p1;

__system_var.eeprom_position = 0;
while (eepromReadAttribute(container,sizeof(container),"RS",0) != 0){

    char *save_ptr1;int i=0;

    p1 = strtok_r(container,";",&save_ptr1);
    for (i=0;i<sizeof(relaySetting.users);i++){
        relaySetting.users[i] = 254;
    }
    while (p1!= 0){
        char *p2,*save_ptr2;

        p2 = strtok_r(p1,":",&save_ptr2);

        if (strstr(p2,"MI")){
            p2 = strtok_r(0,":",&save_ptr2);
            relaySetting.module_id = atoi(p2);

        } else if (strstr(p2,"RI")){
            p2 = strtok_r(0,":",&save_ptr2);
            relaySetting.relay_id = atoi(p2);

        } else if (strstr(p2,"D")){
            p2 = strtok_r(0,":",&save_ptr2);
            relaySetting._delay = atoi(p2);

        } else if (strstr(p2,"IM")){
            p2 = strtok_r(0,":",&save_ptr2);
            relaySetting.impulse = atoi(p2);

        } else if (strstr(p2,"UA")){
            char *p3, *save_ptr3; int i=0;
            p2 = strtok_r(0,":",&save_ptr2);
            p3 = strtok(p2,",",&save_ptr3);

            while (p3 != 0){
                relaySetting.users[i++] = atoi(p3);
                p3 = strtok(0,",",&save_ptr3);
            }
        }
        p1 = strtok_r(0,";",&save_ptr1);
    }

    if (relaySetting.module_id == moduleId && relaySetting.relay_id == relayId){
        return 1;
    }
}
return 0;
}

int getPrimaryNetworkSetting(char host[], char port[]){
    char container[100], *p1, *save_ptr1, success = 0;
    __system_var.eeprom_position = 0;
    if (eepromReadAttribute(container,sizeof(container),"NS",0) == 0) return 0;

    p1 = strtok_r(container,";",&save_ptr1);
    while (p1 != 0){
        if (strstr(p1,"HOST1") != 0){
            char *p2,*save_ptr2;
            p2 = strtok(p1,":");
            p2 = strtok(0,":");
            strcpy(host,p2);
            success += 1;
        } else if (strstr(p1,"PORT1") != 0){
            char *p2,*save_ptr2;
            p2 = strtok(p1,":");
            p2 = strtok(0,":");
            strcpy(port,p2);
            success += 1;
        }
        p1 = strtok_r(0,";",&save_ptr1);
    }
    if (success == 2){
        return 1;
    } else {
        return 0;
    }
}

int getSecondaryNetworkSetting(char host[], char port[]){
    char container[100], *p1, *save_ptr1, success = 0;
    __system_var.eeprom_position = 0;
    if (eepromReadAttribute(container,sizeof(container),"NS",0) == 0) return 0;

    p1 = strtok_r(container,";",&save_ptr1);
    while (p1 != 0){
        if (strstr(p1,"HOST2") != 0){
            char *p2,*save_ptr2;
            p2 = strtok(p1,":");
            p2 = strtok(0,":");
            strcpy(host,p2);
            success += 1;
        } else if (strstr(p1,"PORT2") != 0){
            char *p2,*save_ptr2;
            p2 = strtok(p1,":");
            p2 = strtok(0,":");
            strcpy(port,p2);
            success += 1;
        }
        p1 = strtok_r(0,";",&save_ptr1);
    }
    if (success == 2){
        return 1;
    } else {
        return 0;
    }
}

int getDefaultNetworkSetting(char host[], char port[]){
    strcpy(host,NETWORK_HOST);
    strcpy(port,NETWORK_PORT);
    return 1;
}

void getAccessPointSetting(char ssid[], char password[], char apn[]){
    char container[100], *p1, *save_ptr1, success = 0;
    __system_var.eeprom_position = 0;
    if (eepromReadAttribute(container,sizeof(container),"SSID",0) != 0){
        strcpy(ssid,container);
    } else {
        strcpy(ssid,NETWORK_SSID);
    }
    __system_var.eeprom_position = 0;
    if (eepromReadAttribute(container,sizeof(container),"PWD",0) != 0){
        strcpy(password,container);
    } else {
        strcpy(password,NETWORK_PASSW);
    }
    __system_var.eeprom_position = 0;
    if (eepromReadAttribute(container,sizeof(container),"APN",0) != 0){
        strcpy(apn,container);
    } else {
        strcpy(apn,NETWORK_APN);
    }

}

void initializeTimerSettingIds(){
    char container[100];
    int moduleId,relayId;
    int index = 0;

    for (index=0;index<MAX_MODULE_COUNT;index++){
        int j;
        for (j=0;j<MAX_RELAY_COUNT;j++){
            timerRecords[index].relays[j] = 254;
        }
    }

    __system_var.eeprom_position = 0;
    while (eepromReadAttribute(container,sizeof(container),"TS",0) != 0){
        char *save_ptr1,*p1,i,flag;
        int found =0;

        p1 = strtok_r(container,";",&save_ptr1);
        while (p1!= 0){
            char *p2,*save_ptr2;

            p2 = strtok_r(p1,":",&save_ptr2);
            if (strstr(p2,"MI")){
                p2 = strtok_r(0,":",&save_ptr2);
                moduleId = atoi(p2);
                found += 1;
            } else if (strstr(p2,"RI")){
                p2 = strtok_r(0,":",&save_ptr2);
                relayId = atoi(p2);
                found += 1;
            }
            p1 = strtok_r(0,";",&save_ptr1);
        }
        if (found == 2){
            flag = 1;
            for (i=0;i<MAX_RELAY_COUNT;i++){
                if (timerRecords[moduleId-1].relays[i] == relayId){
                    flag = 0;
                }
            }
            if (flag == 1){
                timerRecords[moduleId-1].relays[index++] = relayId;
            }
        }
    }
}

int getTimerSetting(int moduleId, int relayId){
char container[100]; char *p1;

while (eepromReadAttribute(container,sizeof(container),"TS",0) != 0){

    char *save_ptr1;int i=0;

    p1 = strtok_r(container,";",&save_ptr1);
    for (i=0;i<sizeof(timerSetting.start_week);i++){
        timerSetting.start_week[i] = 254;
    }
    for (i=0;i<sizeof(timerSetting.end_week);i++){
        timerSetting.end_week[i] = 254;
    }

    while (p1!= 0){
        char *p2,*save_ptr2;

        p2 = strtok_r(p1,":",&save_ptr2);
        if (strstr(p2,"MI")){
            p2 = strtok_r(0,":",&save_ptr2);
            timerSetting.module_id = atoi(p2);

        } else if (strstr(p2,"RI")){
            p2 = strtok_r(0,":",&save_ptr2);
            timerSetting.relay_id = atoi(p2);

        } else if (strstr(p2,"TI")){
            p2 = strtok_r(0,":",&save_ptr2);
            timerSetting.timer_id = atoi(p2);

        } else if (strstr(p2,"ST")){
            p2 = strtok_r(0,":",&save_ptr2);
            timerSetting.start_timer = atoi(p2);

        } else if (strstr(p2,"SW")){
            char *p3, *save_ptr3; int i=0;
            p2 = strtok_r(0,":",&save_ptr2);
            p3 = strtok(p2,",",&save_ptr3);
            while (p3 != 0){
                timerSetting.start_week[i++] = atoi(p3);
                p3 = strtok(0,",",&save_ptr3);
            }
        } else if (strstr(p2,"ET")){
            p2 = strtok_r(0,":",&save_ptr2);
            timerSetting.end_timer = atoi(p2);

        } else if (strstr(p2,"EW")){
            char *p3, *save_ptr3; int i=0;
            p2 = strtok_r(0,":",&save_ptr2);
            p3 = strtok(p2,",",&save_ptr3);

            while (p3 != 0){
                timerSetting.end_week[i++] = atoi(p3);
                p3 = strtok(0,",",&save_ptr3);
            }
        }
        p1 = strtok_r(0,";",&save_ptr1);
    }

    if (timerSetting.module_id == moduleId && timerSetting.relay_id == relayId){
        return 1;
    }
}
return 0;
}

int isCurrentTimerActive(){
    int currentMin = systemTime._hour * 60 + systemTime._min + (systemTime._day_of_week * 24 * 60);
    int i;

    for (i=0;i<7;i++){
        if (timerSetting.start_week[i] != 254 && timerSetting.end_week[i] != 254){
            int startTimer = (timerSetting.start_week[i] * 24 * 60) + timerSetting.start_timer;
            int endTimer = (timerSetting.end_week[i] * 24 * 60) + timerSetting.end_timer;

            if (currentMin >= startTimer && currentMin < endTimer){
                return TRUE;
            }
        }
    }
    return FALSE;
}
// this is a process
void processRelayTimers(){
    int module_index,i;
    // this should be initialized after receiving updates from server and after module startup
    initializeTimerSettingIds();

    for (module_index=0;module_index<MAX_MODULE_COUNT;module_index++){
        int relay_index;
        for (relay_index=0;relay_index<MAX_RELAY_COUNT;relay_index++){
            if (timerRecords[module_index].relays[relay_index] != 254){
                char isTimerActive = FALSE;
                __system_var.eeprom_position = 0;

                while (getTimerSetting(module_index+1,timerRecords[module_index].relays[relay_index]) != 0){

                    if (isCurrentTimerActive() == TRUE){
                        isTimerActive = TRUE;
                    }
                }
                // check if module is connected as well
                if (isTimerActive){
                    printf("TIMER: Switch relay ON: %d/%d\n\n",module_index+1,timerRecords[module_index].relays[relay_index]);
                } else {
                    printf("TIMER: Switch relay OFF: %d/%d\n\n",module_index+1,timerRecords[module_index].relays[relay_index]);
                }
            }
        }
    }
}

void initEEPROM(){
    int i;
    for (i=0;i<EEPROM_SIZE;i++){
        eeprom[i] = 254;
    }
}

void setupSystemTime(){
systemTime._day = 19;
systemTime._day_of_week = 4;
systemTime._hour = 33;
systemTime._min = 0;
systemTime._month = 10;
systemTime._sec = 0;
}


void processReadLine(char readLine[], int size){
    if (strstr(readLine,"SWITCH")){
        char *p1;int index,i;
        p1 = strstr(readLine,"@");

        for (index=0;index<size;index++){
            if (&readLine[index] == &*p1){
                printf("address=%d at %d\n",&*p1,++index);
                break;
            }
        }
        for (i=0;i<size-index;i++){
            readLine[i] = readLine[i+index];
        }
        printf("%s\n",readLine);
    }
}

void processWebApp(){
    char flag = 0;
    char webapp[100] = "ssid=Tardis&password=77Ld7cr7dW&apn=online&host=192.168.0.27     \n\r";
    strcpy(__network_data.esp_buffer,webapp);

        if (strstr(__network_data.esp_buffer,"ssid") != 0){
			int pos=0;
			char *p1 = strstr(__network_data.esp_buffer,"ssid");
			p1+=5;
			memset(__network_data.ssid,' ',sizeof(__network_data.ssid)-1);
			while (1){
				if (pos == sizeof(__network_data.ssid))break;
				if (*p1=='&'||*p1=='\r'||*p1=='\n')break;
				__network_data.ssid[pos++] = *p1++;
			}
			__network_data.ssid[pos] = '\0';
			flag++;
			printf("SSID=%s\n", __network_data.ssid);
		}
		if (strstr(__network_data.esp_buffer,"password") != 0){
			int pos=0;
			char *p1 = strstr(__network_data.esp_buffer,"password");
			p1+=9;
			memset(__network_data.password,' ',sizeof(__network_data.password)-1);
			while (1){
				if (pos == sizeof(__network_data.password))break;
				if (*p1=='&'||*p1=='\r'||*p1=='\n')break;
				__network_data.password[pos++] = *p1++;
			}
			__network_data.password[pos] = '\0';
			flag++;
			printf("PASSWORD=%s\n", __network_data.password);
		}

		if (strstr(__network_data.esp_buffer,"apn") != 0){
			int pos=0;
			char *p1 = strstr(__network_data.esp_buffer,"apn");
			p1+=4;
			memset(__network_data.apn,' ',sizeof(__network_data.apn)-1);
			while (1){
				if (pos == sizeof(__network_data.apn))break;
				if (*p1=='&'||*p1=='\r'||*p1=='\n')break;
				__network_data.apn[pos++] = *p1++;
			}
			__network_data.apn[pos] = '\0';
			flag++;
			printf("APN=%s\n", __network_data.apn);
		}

		if (strstr(__network_data.esp_buffer,"host") != 0){
			int pos=0;
			char *p1 = strstr(__network_data.esp_buffer,"host");
			p1+=5;
			memset(__network_data.host,' ',sizeof(__network_data.host)-1);
			while (1){
				if (pos == sizeof(__network_data.host)-1)break;
				if (*p1 == '\r' || *p1 == '\n') break;
				if (!isalpha(*p1) && !isdigit(*p1) && *p1 != '.') break;
				__network_data.host[pos++] = *p1++;
			}
			__network_data.host[pos] = '\0';
			flag++;
			printf("HOST=%sasd\n", __network_data.host);
		}

		if (flag == 4){
			printf("LOL");
		}
}

int main()
{
    int pos = 0,i;
    char buffer[100];
    char host[50];
    char port[5];
    char ssid[50];
    char password[50];
    char apn[30];
    char readLine[200] = "AT OK BLABLABLBALBAAAA SWITCH;RELAY;1;1@ BLABLABLA BLA SWITCH;RELAY;2;1@ ASDASDASD";


    setupSystemTime();

    __system_var.eeprom_position = 0;

    initEEPROM();
    clearEEPROM();

    eepromSaveCfg("#SERIAL;ABCDEFR123#",EEPROM_SERIAL_START);

    pos = EEPROM_DATA_START;
    pos = eepromSaveCfg("#SSID;Tardis#",pos);
    pos = eepromSaveCfg("#PWD;77Ld7cr7dW#",pos);
    pos = eepromSaveCfg("#APN;online#",pos);

    pos = EEPROM_CFG_START;
    pos = eepromSaveCfg("#NS;HOST1:jozsa-electronics.com;PORT1:80;HOST2:jozsa-electronics2.com;PORT2:81;#",pos);
    pos = eepromSaveCfg("#RS;MI:1;RI:1;D:3;IM:1;UA:0,1#",pos);

    pos = eepromSaveCfg("#TS;MI:1;RI:1;TI:1;ST:1140;SW:3;ET:0;EW:3;#",pos);
    pos = eepromSaveCfg("#TS;MI:1;RI:1;TI:2;ST:1140;SW:1,2;ET:2000;EW:1,2;#",pos);

    pos = eepromSaveCfg("#RS;MI:1;RI:2;D:0;IM:1;UA:0,1#",pos);

    pos = eepromSaveCfg("#TS;MI:1;RI:2;TI:1;ST:1140;SW:1,2,3,4,5,6,7;ET:2000;EW:5,6,7;#",pos);

    pos = eepromSaveCfg("#RS;MI:1;RI:3;D:0;IM:1;UA:0,1#",pos);

    pos = eepromSaveCfg("#TS;MI:1;RI:3;TI:1;ST:1140;SW:1,2,3,4,5,6,7;ET:2000;EW:1,2,3,4,5,6,7;#",pos);

    pos = eepromSaveCfg("#RS;MI:1;RI:4;D:3;IM:0;UA:0,1#",pos);
    pos = eepromSaveCfg("#RS;MI:1;RI:5;D:0;IM:0;UA:0,1#",pos);
    pos = eepromSaveCfg("#RS;MI:1;RI:6;D:0;IM:1;UA:0,1#",pos);
    pos = eepromSaveCfg("#RS;MI:1;RI:7;D:0;IM:1;UA:0,1#",pos);
    pos = eepromSaveCfg("#RS;MI:1;RI:8;D:0;IM:0;UA:0,1#",pos);
    pos = eepromSaveCfg("#RS;MI:1;RI:9;D:0;IM:1;UA:0,1#",pos);
    pos = eepromSaveCfg("#RS;MI:1;RI:10;D:0;IM:0;UA:0,1#",pos);
    pos = eepromSaveCfg("#RS;MI:1;RI:11;D:0;IM:0;UA:0,1#",pos);
    pos = eepromSaveCfg("#RS;MI:1;RI:12;D:0;IM:1;UA:0,1#",pos);

    pos = eepromSaveCfg("#USR;PRIV:USER;NUM:+36309225421;UI:0;CA:1/1,1/2,1/3#",pos);
    pos = eepromSaveCfg("#USR;PRIV:ADMIN;NUM:+36309225427;UI:1;CA:1/1,1/4#",pos);

    printf("%s\n",eeprom);

    if (getRelaySetting(1,1) == 1){
        printf("RELAY SETTING\n");
        printf("MODULE ID=%d\n", relaySetting.module_id);
        printf("RELAY ID=%d\n", relaySetting.relay_id);
        printf("DELAY=%d\n", relaySetting._delay);
        printf("IMPULSE MODE=%d\n", relaySetting.impulse);
        printf("USERS=");
        for (i=0;relaySetting.users[i] != 254;i++){
            printf("%d,",relaySetting.users[i]);
        }
        printf("\n\n");
    }
    printf("\n\n");
    printf("\n\n");

    processRelayTimers();


    printf("Privilige:%d\n", getPrivilige("+36309225421"));
    printf("Privilige:%d\n", getPrivilige("+36309225427"));
    printf("Privilige:%d\n", getPrivilige("+36309225420"));

    printf("USERID:%d\n", getUserId("+36309225421"));
    printf("USERID:%d\n", getUserId("+36309225427"));
    printf("USERID:%d\n", getUserId("+36309225420"));

    printf("CALLACCESS:%d ", getCallAccess("+36309225421",buffer));
    printf("%s\n",buffer);
    printf("CALLACCESS:%d ", getCallAccess("+36309225427",buffer));
    printf("%s\n",buffer);
    printf("CALLACCESS:%d ", getCallAccess("+36309225420",buffer));
    printf("%s\n",buffer);

    printf("getPrimaryNetworkSetting: %d =",getPrimaryNetworkSetting(host,port));
    printf("%s:%s\n",host,port);
    printf("getSecondaryNetworkSetting: %d =",getSecondaryNetworkSetting(host,port));
    printf("%s:%s\n",host,port);
    printf("getDefaultNetworkSetting: %d =",getDefaultNetworkSetting(host,port));
    printf("%s:%s\n",host,port);
    getAccessPointSetting(ssid,password,apn);
    printf("getAccessPointSetting= %s %s %s\n",ssid,password,apn);
   // printf("USERID:%d\n", getUserId("+36309225421"));
    printf("\n\n");

    printf("verifyRelayAccess=%d\n",verifyRelayAccess("+36309225427",1,1));

    processReadLine(readLine, sizeof(readLine));
    processReadLine(readLine, sizeof(readLine));

    processWebApp();

    return 0;
}
