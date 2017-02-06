/*
* Processes.cpp
*
* Created: 2016.10.04. 16:46:46
*  Author: tjozsa
*/
#include <Processes.h>
#include <HCM.h>

void saveUserData(){
	char buffer[160];
	clearEEPROM(EEPROM_DATA_START,EEPROM_CFG_START);
	strcpy(buffer,"#SSID;");
	strcat(buffer,__network_data.ssid);
	strcat(buffer,"##PWD;");
	strcat(buffer,__network_data.password);
	strcat(buffer,"##APN;");
	strcat(buffer,__network_data.apn);
	strcat(buffer,"#");
	//USART0_SendString(buffer);
	//delay(500);
	__system_var.eeprom_position = EEPROM_DATA_START;
	eepromSaveCfg(buffer,__system_var.eeprom_position);
}


void postPage(char flag){
	char content[850];
	char page[1000];
	int contentLength;
	char converter[5];
	
	__network_data.ap_connection[0] = 9;
	
	if (strstr(__network_data.esp_buffer,"IPD,") != 0){
		char *p = strstr(__network_data.esp_buffer,"IPD,");
		__network_data.ap_connection[0] = *(p+4);
		__network_data.ap_connection[1] = '\0';
	}
	 
	
	delay(500);
	strcpy(content,"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0\"></head><body>");
	strcat(content,"<title>HCM Console</title>");
	strcat(content,"<div style=\"font-size: medium; text-align: center;\"><span>");
	strcat(content,"<form method=\"POST\">");
	strcat(content,"<p><strong>SERIAL: ");
	strcat(content,__system_var.serial_number);
	strcat(content,"</strong></p><p><strong>SSID</strong><br><input type=\"text\" name=\"ssid\" value=\"");
	strcat(content,__network_data.ssid);
	strcat(content,"\"></p>");
	strcat(content,"<p><strong>PASSWORD</strong><br><input type=\"text\" name=\"password\" value=\"");
	strcat(content,__network_data.password);
	strcat(content,"\"></p>");
	strcat(content,"<p><strong>APN</strong><br><input type=\"text\" name=\"apn\" value=\"");
	strcat(content,__network_data.apn);
	strcat(content,"\"></p>");
	if (flag == 1){
		strcat(content,"<br><p>SAVED</p>");
	} else {
		strcat(content,"<input type=\"submit\">");
	}
	strcat(content,"</form></span></div></body></html>");

	contentLength = strlen(content);

	strcpy(page,"HTTP/1.0 200 OK\r\nContent-Type: text/html; charset=UTF-8\r\nPragma: no-cache\r\nContent-Length: ");
	strcat(page,itoa(contentLength,converter,10));
	strcat(page,"\r\nConnection: close\r\n\r\n");
	strcat(page,content);
	
	if (__network_data.ap_connection[0] != 9){
		sendToAP(page, __network_data.ap_connection);
		//readUntil("OK",3);
		delay(1000);
	}
	
	clearReadLine();
	__system_time.connection_timer_buffer = 0;
	__system_time.connection_timer = 180;
}

void WebApp(){
	

	if (strstr(__network_data.esp_buffer, "GET / HTTP/") != 0){
		postPage(0);
	}
	
	if (strstr(__network_data.esp_buffer, "POST / HTTP/") != 0 ){
		int timeout=0;
		int flag = 0;
		
		__network_data.ap_connection[0] = 9;
		
		if (strstr(__network_data.esp_buffer,"IPD,") != 0){
			char *p = strstr(__network_data.esp_buffer,"IPD,");
			__network_data.ap_connection[0] = *(p+4);
			__network_data.ap_connection[1] = '\0';
		}

		delay(500);
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
		}
		
		/*if (strstr(__network_data.esp_buffer,"apn") != 0){
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
		}*/
		
		if (strstr(__network_data.esp_buffer,"apn") != 0){
			int pos=0;
			char *p1 = strstr(__network_data.esp_buffer,"apn");
			p1+=4;
			memset(__network_data.apn,0,sizeof(__network_data.apn)-1);
			while (1){
				if (pos == sizeof(__network_data.apn))break;
				if (*p1 == '\r' || *p1 == '\n') break;
				if (!isalpha(*p1) && !isdigit(*p1) && *p1 != '.' && *p1 != '-') break;
				__network_data.apn[pos++] = *p1++;
			}
			__network_data.apn[pos] = '\0';
			flag++;
		}
		
		/*if (strstr(__network_data.esp_buffer,"host") != 0){
			int pos=0;
			char *p1 = strstr(__network_data.esp_buffer,"host");
			p1+=5;
			memset(__network_data.host,' ',sizeof(__network_data.host)-1);
			while (1){
				if (pos == sizeof(__network_data.host))break;
				if (*p1 == '\r' || *p1 == '\n') break;
				if (!isalpha(*p1) && !isdigit(*p1) && *p1 != '.' && *p1 != '-') break;
				__network_data.host[pos++] = *p1++;
			}
			__network_data.host[pos] = '\0';
			flag++;
		}*/
		
		if (flag == 3 && __network_data.ap_connection[0] != 9){
			delay(500);
			postPage(1);
			saveUserData();
			__system_time.connection_timer_buffer = 0;
			__system_time.connection_timer = 0;
			__network_data.is_server_connected = false;
			__network_data.is_esp_connected = false;
			USART0_SendString("AT+CIPCLOSE=5\r\n");
			setSource(ESP);
		}
		delay(1000);
		clearReadLine();
	}
	
}

void switchRelay(char moduleId, char relayId, char state){
	
	char r1,r2;
	int i;
	int impulse = 0;
	int _delay = 0;
	char conv[5];
	char response[40];
	
	if (getRelaySetting(moduleId,relayId) == 1){
		impulse = __relay_setting.impulse;
		_delay = __relay_setting._delay;
	}

	for (i=0;i<10;i++){
		chipSelect(moduleId,0);
		SPI_WriteRead(SWITCH_RELAY);
		r1 = SPI_WriteRead(relayId);
		if (impulse == 1){
			r2 = SPI_WriteRead(1);
			} else {
			r2 = SPI_WriteRead(state);
		}
		chipSelect(moduleId,1);
		
		if (r1 + r2 == 14){
			break;
			} else {
			delay(50);
		}
	}
	if (impulse == 1){
		delay(_delay*1000);
		for (i=0;i<10;i++){
			chipSelect(moduleId,0);
			SPI_WriteRead(SWITCH_RELAY);
			r1 = SPI_WriteRead(relayId);
			r2 = SPI_WriteRead(0);
			chipSelect(moduleId,1);
			
			if (r1 + r2 == 14){
				break;
				} else {
				delay(50);
			}
		}
	}
	
	if (r1 + r2 == 14){
		strcpy(response,"NOTIFICATION;SWITCH;");
		strcat(response,itoa(moduleId,conv,10));
		strcat(response,";");
		strcat(response,itoa(relayId,conv,10));
		strcat(response,";");
		strcat(response,itoa(state,conv,10));
		strcat(response,";\n");

		sendToServer(response,CONNECTION);
	}
	
}

void RelayControl(){
	//&& __system_var.enabled_flag == 1
	if (strstr(__network_data.esp_buffer, "SWITCHRELAY") != 0){
		char *p1;
		int relayId, moduleId, state, index, i;
		
		p1 = strstr(__network_data.esp_buffer, "SWITCHRELAY");
		strtok(p1,";");
		moduleId = atoi(strtok(0,";"));
		relayId = atoi(strtok(0,";"));
		state = atoi(strtok(0,";"));
		
		switchRelay(moduleId,relayId,state);
		
		if (moduleId < MAX_MODULE_COUNT && relayId < MAX_RELAY_COUNT){
			char conv[5];
			if (state == 1){
				__relay_states[moduleId].states[relayId] = 1;
				} else {
				__relay_states[moduleId].states[relayId] = 0;
			}
		}

		clearReadLine();
	}
}

void ReceiveSettings(){
	
	if (strstr(__network_data.esp_buffer, "CFG") != 0){
		
		__system_time.check_timer_buffer = 0;
		
		if (strstr(__network_data.esp_buffer, "[CLEAR_EEPROM]") != 0){
			__system_var.enabled_flag = 0;
			USART0_SendString("CLEARING...");
			clearEEPROM(EEPROM_CFG_START,EEPROM_SIZE);
			__system_var.eeprom_position = EEPROM_CFG_START;
			sendToServer("OK\n",CONNECTION);
			return;
		}
		if (strstr(__network_data.esp_buffer, "[END]") != 0){
			__system_var.eeprom_position = EEPROM_CFG_START;
			__system_var.enabled_flag = 1;
			sendToServer("OK\n",CONNECTION);
			delay(500);
			sendToServer("NOTIFICATION;UPDATED;\n",CONNECTION);
			return;
		}
		char *p1;
		p1 = strtok(__network_data.esp_buffer,"$");
		p1 = strtok(0,"$");
		__system_var.eeprom_position = eepromSaveCfg(p1,__system_var.eeprom_position);
		delay(10);
		sendToServer("OK\n",CONNECTION);
		clearReadLine();
	}
	
	if (strstr(__network_data.esp_buffer, "UPDATE") != 0){
		sendToServer("REQUEST_UPDATE\n",CONNECTION);
		clearReadLine();
	}
}

void CheckModuleConnections(){
	
	if (__system_time.relay_module_check_timer_buffer >= __system_time.relay_module_check_timer){
		unsigned char relay_count;
		char conv[5];
		int i,j;

		itoa(__system_time.check_timer_buffer,conv,10);
		
		// CHECK RELAY MODULE CONNECTIONS
		for (i=0;i<4;i++){
			char conv[5];
			
			if (digitalRead(__system_var.detect_pins[i]) == 0 && __system_var.module_flags[i] == 0){
				delay(500);
				__system_var.module_connected[i] = 1;
				__system_var.module_flags[i] = 1;
				for (j=0;j<5;j++){
					chipSelect(i, 0);
					relay_count = SPI_WriteRead(REQUEST_RELAY_COUNT);
					relay_count = SPI_WriteRead(RECIEVE);
					chipSelect(i, 1);
					if (!(relay_count == 0 || relay_count == 1 || relay_count == 255 || relay_count == 254)){
						break;
					}
				}
				if (relay_count == 0 || relay_count == 1 || relay_count == 255 || relay_count == 254){
					relay_count = 0;
				}
				__system_var.relay_modules[i] = relay_count;
				__system_var.update_flag = 1;
				
				//delay(500);
			}
			if (digitalRead(__system_var.detect_pins[i]) != 0 && __system_var.module_flags[i] == 1){
				delay(500);
				__system_var.module_connected[i] = 0;
				__system_var.module_flags[i] = 0;
				__system_var.update_flag = 1;
				//delay(500);
			}
		}
		
		if (__system_var.update_flag == 1 && __network_data.is_server_connected){
			__system_var.update_flag = 0;
			char toSend[30] = "RELAYCONNECTIONS;";
			int i;
			for (i=0;i<4;i++){
				if (__system_var.module_connected[i] == 1) {
					strcat(toSend,itoa(i,conv,10));
					strcat(toSend,":");
					strcat(toSend,itoa(__system_var.relay_modules[i],conv,10));
					strcat(toSend,";");
				}
			}
			strcat(toSend,"\n");
			sendToServer(toSend,CONNECTION);
		}
		__system_time.relay_module_check_timer_buffer = 0;
	}
}

void HeartBeat(){
	// CHECK SERVER CONNECTION
	if (__system_time.check_timer_buffer >= __system_time.check_timer){
		
		if (__network_data.is_server_connected ){
			sendToServer("CHECK\n",CONNECTION);
			if (readUntil("LIVE",3) == 0){
				__network_data.is_server_connected = FALSE;
				__network_data.is_esp_connected = FALSE;
				__network_data.is_sim_connected = FALSE;
			}
		}
		__system_time.check_timer_buffer = 0;
	}
}

void ProcessRelayTimers(){
	if ((__system_time.timer_check_timer_buffer >= __system_time.timer_check_timer) && __system_var.enabled_flag == 1){
		int module_index;
		char conv[5];
		// this should be initialized after receiving updates from server and after module startup
		initializeTimerSettingIds();
		
		
		for (module_index=0;module_index<MAX_MODULE_COUNT;module_index++){
			int relay_index;

			for (relay_index=0;relay_index<MAX_RELAY_COUNT;relay_index++){
				if (__timer_records[module_index].relays[relay_index] != 254){
					char isTimerActive = FALSE;
					__system_var.eeprom_position = EEPROM_CFG_START;

					// Get all the timers associated with relays
					while (getTimerSetting(module_index,__timer_records[module_index].relays[relay_index]) != 0){
						if (isCurrentTimerActive() == TRUE){
							isTimerActive = TRUE;
						}
					}
					// check if module is connected as well
					if (isTimerActive){
						char conv[5];
						
						if (module_index < MAX_MODULE_COUNT && relay_index < MAX_RELAY_COUNT){
							if (__relay_states[module_index].states[__timer_records[module_index].relays[relay_index]] == 0){
								switchRelay(module_index,__timer_records[module_index].relays[relay_index],1);
								__relay_states[module_index].states[__timer_records[module_index].relays[relay_index]] = 1;
							}
						}
						
						/*USART0_SendString("RElAY (");
						itoa(module_index,conv,10);
						USART0_SendString(conv);
						USART0_SendString("/");
						itoa(__timer_records[module_index].relays[relay_index],conv,10);
						USART0_SendString(conv);
						USART0_SendString(") ON\n");*/
						
						
						} else {
						char conv[5];
						
						if (module_index < MAX_MODULE_COUNT && relay_index < MAX_RELAY_COUNT){
							if (__relay_states[module_index].states[__timer_records[module_index].relays[relay_index]] == 1){
								switchRelay(module_index,__timer_records[module_index].relays[relay_index],0);
								__relay_states[module_index].states[__timer_records[module_index].relays[relay_index]] = 0;
							}
						}
						
						/*USART0_SendString("RElAY (");
						itoa(module_index,conv,10);
						USART0_SendString(conv);
						USART0_SendString("/");
						itoa(__timer_records[module_index].relays[relay_index],conv,10);
						USART0_SendString(conv);
						USART0_SendString(") OFF\n");*/
						
					}
				}
			}
		}
		__system_time.timer_check_timer_buffer = 0;
	}
}

/*
*	If GSM network disconnects or SIM900 randomly shuts down, this'll turn it back on.
*/
void checkGsmNetwork(){
	
	if (HAS_GSM){
		if (__system_time.gsm_network_timer_buffer >= __system_time.gsm_network_timer){
			clearGSMBuffer();
			GSM_Write_String("AT+CREG?\r\n");
			delay(300);
			if (!(strstr(__network_data.sim_buffer,"+CREG: 0,1") != 0 || strstr(__network_data.sim_buffer,"+CREG: 0,5") != 0)){
				clearGSMBuffer();
				GSM_Write_String("AT\r\n");
				if (strstr(__network_data.sim_buffer,"OK") != 0){
					turnOnSim900();
				}
				turnOnSim900();
			}
			__system_time.gsm_network_timer_buffer = 0;
		}
	}
}




void SendSms(char *phonenumber, char *uzenet, char *info)
{

	GSM_Write_String("AT\r\n");
	readUntil("OK",2);
	GSM_Write_String("AT+CMGF=1\r\n");
	readUntil("OK",2);
	GSM_Write_String("AT+CMGS=\"");
	GSM_Write_String(phonenumber);
	GSM_Write_Byte(0x22);
	GSM_Write_Byte(0x0D);
	readUntil("OK",2);
	GSM_Write_String(uzenet);
	GSM_Write_String(info);
	GSM_Write_Byte(26);
	GSM_Write_Byte(0x0D);
	readUntil("OK",2);
}

void IncomingCallHandler(){
	
}

char *getSmsMessage(){
	//+CMT \"+36309225427\",\"\",\"15/02/03,23:12:23+30\"\nTest sms lol
	char *p1,*p2;
	
	if (strstr(__network_data.sim_buffer,"UNREAD") == 0) return 0;

	p1 = strstr(__network_data.sim_buffer,"UNREAD");
	p1 += 6;
	//printf("%s\n",p1);
	p2 = strtok(p1,"\",\"");

	strcpy(__system_var.phone_buffer, p2);

	p2 = strtok(0,"\n");
	p2 = strtok(0,"\r");

	return p2;
}

void IncomingSMSHandler(){
	
	if (strstr(__network_data.sim_buffer,"MTI:") != 0)
	{
		char *message;
		char privilege;
		clearGSMBuffer();
		__system_var.sms_flag = 1;
		GSM_Write_String("AT+CMGR=1\r\n");
		//readUntil();
		delay(1000);
		message = getSmsMessage();
		privilege = getPrivilege(__system_var.phone_buffer);
		if (privilege != 0){
			
			if (strstr(message,"INFO") != 0 )
			{
				char msg[200];
				int relayIndex,moduleIndex;
				strcpy(msg,"INFO:\n");
				GSM_Write_String("INFO SMS");
				for (moduleIndex=0;moduleIndex<MAX_MODULE_COUNT;moduleIndex++){
					for (relayIndex=0;relayIndex<MAX_MODULE_COUNT;relayIndex++){
						
					}
				}
				//SendSms(__network_data.admin,message,"");
			}
			
			if (strstr(message,"REL") != 0 )
			{
				char *p2 = strstr(message,"REL");

			}
			
		}
	}
	
	if (__system_var.sms_flag != 0 ){
		GSM_Write_String("AT\r\n");
		delay(500);
		GSM_Write_String("AT+CMGDA=\"DEL ALL\"\r\n");
		delay(500);
		__system_var.sms_flag = 0;
	}
	
	
}
