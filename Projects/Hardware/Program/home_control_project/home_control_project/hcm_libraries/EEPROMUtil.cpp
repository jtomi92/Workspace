#include <EEPROMUtil.h> //include the declaration for this class
#include <HCM.h>
 
 

int eepromSaveCfg(const char *toWrite, int position){

	while(*toWrite != '\0'){
		while(!eeprom_is_ready());
		eeprom_write_byte((uint8_t*)position++,*toWrite++);
	}
	return position;
}

void clearEEPROM(int startPos, int endPos){
	int i;
	char c;
	for (i = startPos; i < endPos; i++){
		while(!eeprom_is_ready());
		c = eeprom_read_byte((uint8_t*)i);
		if (c == 0xFF) break;
		while(!eeprom_is_ready());
		eeprom_write_byte((uint8_t*)i,0xFF);
	}
}

char eepromReadAttribute(char container[],const int length, char *attr,const int clear){

	int index, j = 0, flag = 0;
	char dat,*p1, buffer[200];
	int attrLength=0;

	if (clear == 1) __system_var.eeprom_position = 0;
	p1 = attr;
	for(;*p1++!='\0';attrLength++);

	for (index = __system_var.eeprom_position; index < EEPROM_SIZE; index++) {

		while(!eeprom_is_ready());
		dat = eeprom_read_byte((uint8_t*)index);
		
		if (dat == '#') {
			flag = !flag;
		}

		if (flag == 1) {
			if (j==sizeof(buffer)-1){
				 return 0;
			}
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

int getRelaySetting(int moduleId, int relayId){
	char container[200];

	__system_var.eeprom_position = 0;
	

	while (eepromReadAttribute(container,sizeof(container)-1,"RS",0) != 0){
		char *save_ptr1, *p1;
		unsigned int i;

		p1 = strtok_r(container,";",&save_ptr1);

		while (p1!= 0){
			char *p2,*save_ptr2;

			p2 = strtok_r(p1,":",&save_ptr2);

			if (strstr(p2,"MI")){
				p2 = strtok_r(0,":",&save_ptr2);
				__relay_setting.module_id = atoi(p2);

				} else if (strstr(p2,"RI")){
				p2 = strtok_r(0,":",&save_ptr2);
				__relay_setting.relay_id = atoi(p2);

				} else if (strstr(p2,"D")){
				p2 = strtok_r(0,":",&save_ptr2);
				__relay_setting._delay = atoi(p2);

				} else if (strstr(p2,"IM")){
				p2 = strtok_r(0,":",&save_ptr2);
				__relay_setting.impulse = atoi(p2);

				} else if (strstr(p2,"UA")){
				char *p3, *save_ptr3; int i=0;
				p2 = strtok_r(0,":",&save_ptr2);
				p3 = strtok_r(p2,",",&save_ptr3);

				while (p3 != 0){
					if (i==sizeof(__relay_setting.users)-1) return 0;
					__relay_setting.users[i++] = atoi(p3);
					p3 = strtok_r(0,",",&save_ptr3);
				}
				__relay_setting.users[i] = 200;
			}
			p1 = strtok_r(NULL,";",&save_ptr1);
		}

		if (__relay_setting.module_id == moduleId && __relay_setting.relay_id == relayId){
			return 1;
		}
	}
	return 0;
}

int verifyRelayAccess(char *phoneNumber, char moduleId, char relayId){
	int userId = getUserId(phoneNumber);
	if (userId == -1) return 0;
	if (getRelaySetting(1,1) == 1){
		int i;
		for (i=0; __relay_setting.users[i] != 254; i++){
			if (__relay_setting.users[i] == userId){
				return 1;
			}
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
			char *p2;
			p2 = strtok(p1,":");
			p2 = strtok(0,":");
			strcpy(host,p2);
			success += 1;
			} else if (strstr(p1,"PORT1") != 0){
			char *p2;
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
			char *p2;
			p2 = strtok(p1,":");
			p2 = strtok(0,":");
			strcpy(host,p2);
			success += 1;
			} else if (strstr(p1,"PORT2") != 0){
			char *p2;
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

void getAccessPointSetting(){
	char container[100];
	__system_var.eeprom_position = 0;
	if (eepromReadAttribute(container,sizeof(container),"SSID",0) != 0){
		if (strlen(container) <= sizeof(__network_data.ssid)) strcpy(__network_data.ssid,container);
	} else {
		strcpy(__network_data.ssid,NETWORK_SSID);
	}
	__system_var.eeprom_position = 0;
	if (eepromReadAttribute(container,sizeof(container),"PWD",0) != 0){
		if (strlen(container) <= sizeof(__network_data.password)) strcpy(__network_data.password,container);
	} else {
		strcpy(__network_data.password,NETWORK_PASSW);
	}
	__system_var.eeprom_position = 0;
	if (eepromReadAttribute(container,sizeof(container),"APN",0) != 0){
		if (strlen(container) <= sizeof(__network_data.apn)) strcpy(__network_data.apn,container);
	} else {
		strcpy(__network_data.apn,NETWORK_APN);
	}

}

void initializeTimerSettingIds(){
	char container[200];
	int moduleId=0,relayId=0;
	int index = 0;

	for (index=0;index<MAX_MODULE_COUNT;index++){
		int j;
		for (j=0;j<MAX_RELAY_COUNT;j++){
			__timer_records[index].relays[j] = 254;
		}
	}

	__system_var.eeprom_position = 0;
	while (eepromReadAttribute(container,sizeof(container),"TS",0) != 0){
		char *save_ptr1,*p1,flag;
		int i,found = 0;

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
				if (__timer_records[moduleId].relays[i] == relayId){
					flag = 0;
				}
			}
			if (flag == 1){
				__timer_records[moduleId].relays[index++] = relayId;
			}
		}
	}
}

int getTimerSetting(int moduleId, int relayId){
	char container[100]; char *p1;

	while (eepromReadAttribute(container,sizeof(container),"TS",0) != 0){

		char *save_ptr1;
		unsigned int i;
		
		p1 = strtok_r(container,";",&save_ptr1);
		for (i=0;i<sizeof(__timer_setting.start_week);i++){
			__timer_setting.start_week[i] = 254;
		}
		for (i=0;i<sizeof(__timer_setting.end_week);i++){
			__timer_setting.end_week[i] = 254;
		}

		while (p1!= 0){
			char *p2,*save_ptr2;

			p2 = strtok_r(p1,":",&save_ptr2);
			if (strstr(p2,"MI")){
				p2 = strtok_r(0,":",&save_ptr2);
				__timer_setting.module_id = atoi(p2);

				} else if (strstr(p2,"RI")){
				p2 = strtok_r(0,":",&save_ptr2);
				__timer_setting.relay_id = atoi(p2);

				} else if (strstr(p2,"TI")){
				p2 = strtok_r(0,":",&save_ptr2);
				__timer_setting.timer_id = atoi(p2);

				} else if (strstr(p2,"ST")){
				p2 = strtok_r(0,":",&save_ptr2);
				__timer_setting.start_timer = atoi(p2);

				} else if (strstr(p2,"SW")){
				char *p3, *save_ptr3; int i=0;
				p2 = strtok_r(0,":",&save_ptr2);
				p3 = strtok_r(p2,",",&save_ptr3);
				while (p3 != 0){
					__timer_setting.start_week[i++] = atoi(p3);
					p3 = strtok_r(0,",",&save_ptr3);
				}
				} else if (strstr(p2,"ET")){
				p2 = strtok_r(0,":",&save_ptr2);
				__timer_setting.end_timer = atoi(p2);

				} else if (strstr(p2,"EW")){
				char *p3, *save_ptr3; int i=0;
				p2 = strtok_r(0,":",&save_ptr2);
				p3 = strtok_r(p2,",",&save_ptr3);

				while (p3 != 0){
					__timer_setting.end_week[i++] = atoi(p3);
					p3 = strtok_r(0,",",&save_ptr3);
				}
			}
			p1 = strtok_r(0,";",&save_ptr1);
		}	

		if (__timer_setting.module_id == moduleId && __timer_setting.relay_id == relayId){
			return 1;
		}
	}

	return 0;
}

int isCurrentTimerActive(){
	int currentMin = __system_time._hour * 60 + __system_time._min + (__system_time._day_of_week * 24 * 60);
	int i;
	/*char conv[5];
	
	USART0_SendString("Current time:");
	itoa(currentDay,conv,10);
	USART0_SendString(conv);
	USART0_SendString("/");
	itoa(currentMin,conv,10);
	USART0_SendString(conv);
	USART0_SendString("\n");
	
	USART0_SendString("Relay start time:");
	itoa(__timer_setting.start_timer,conv,10);
	USART0_SendString(conv);
	USART0_SendString(" end time:");
	itoa(__timer_setting.end_timer,conv,10);
	USART0_SendString(conv);
	USART0_SendString("\n");
	USART0_SendString("\n");*/
	
	for (i=0;i<7;i++){
		if (__timer_setting.start_week[i] != 254 && __timer_setting.end_week[i] != 254){
			int startTimer = (__timer_setting.start_week[i] * 24 * 60) + __timer_setting.start_timer;
			int endTimer = (__timer_setting.end_week[i] * 24 * 60) + __timer_setting.end_timer;

			if (currentMin >= startTimer && currentMin < endTimer){
				return TRUE;
			}
		}
	}
	return FALSE;
}



