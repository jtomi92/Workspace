/*
* Processes.cpp
*
* Created: 2016.10.04. 16:46:46
*  Author: tjozsa
*/
#include <Processes.h>
#include <HCM.h>

void SmsIncome()
{
	/* IF SMS INCOME, READ IT: AT+CMGR = 1 */
	if (strstr(__network_data.esp_buffer,"MTI:") != 0)
	{
		
		clearReadLine();

		USART0_SendString("AT+CMGR=1\r\n");
		delay(1000);
	}
}

void checkConnectivity(){
	
	if (__system_time.connection_timer_buffer >= 180){

		__system_time.connection_timer_buffer = 0;
		
		delay(500);
		clearReadLine();
		
		USART0_SendString("AT+CREG?\r\n");

		delay(500);
		if (!(strstr(__network_data.esp_buffer,"+CREG: 0,1") != 0 || strstr(__network_data.esp_buffer,"+CREG: 0,5") != 0)){

			if (__network_data.network_available == TRUE){
				//sec = 0;
				__network_data.network_available = FALSE;
			}

			clearReadLine();
			
			USART0_SendString("AT\r\n");
			delay(500);
			if (strstr(__network_data.esp_buffer,"OK") != 0){
				turnOnSim900(SIM_PWR);
			}
			turnOnSim900(SIM_PWR);
			} else {
			if (__network_data.network_available == FALSE){
				__network_data.network_available = TRUE;
			}
		}
	}
}


void DelSms(){
	if (__network_data.sms_income >=1 )
	{
		USART0_SendString("AT\r\n");
		delay(500);
		USART0_SendString("AT+CMGDA=\"DEL ALL\"\r\n");
		delay(500);
		__network_data.sms_income = 0;
		clearReadLine();
	}
}



void SendSms(char *phonenumber, char *uzenet, char *info)
{

	USART0_SendString("AT\r\n");
	//wait_for_input("OK",2);
	delay(500);
	USART0_SendString("AT+CMGF=1\r\n");
	delay(500);
	//wait_for_input("OK",2);
	USART0_SendString("AT+CMGS=\"");
	USART0_SendString(phonenumber);
	USART0_SendByte(0x22);
	USART0_SendByte(0x0D);
	delay(500);
	USART0_SendString(uzenet);
	USART0_SendString(info);
	USART0_SendByte(26);
	USART0_SendByte(0x0D);
	delay(10000);
	//wait_for_input("OK",10);

}

/*********************** SMS COMMANDS******************************************/
char *getSmsMessage(){
	//+CMT \"+36309225427\",\"\",\"15/02/03,23:12:23+30\"\nTest sms lol
	char *p1,*p2;

	if (strstr(__network_data.esp_buffer,"UNREAD") == 0) return 0;
	p1 = strstr(__network_data.esp_buffer,"UNREAD");
	p1 += 6;
	//printf("%s\n",p1);
	p2 = strtok(p1,"\",\"");


	strcpy(__network_data.phone_buffer, p2);

	p2 = strtok(0,"\n");
	p2 = strtok(0,"\r");

	return p2;
}


void SmsCommands(){

	if (strstr(__network_data.esp_buffer,"UNREAD") != 0 || strstr(__network_data.esp_buffer,"CMGR") != 0 || strstr(__network_data.esp_buffer,"READ") != 0 )
	{
		char *p;
		delay(500);

		/******************************* START **********************************/
		__network_data.sms_income = 1;

		/* Copy sender's phone number to buffer */
		p = getSmsMessage();
		if (p == 0) return;
		delay(300);
	

		if (strstr(p,"ADMIN") != 0)
		{
			delay(100);

			if (strcmp(__network_data.admin,__network_data.phone_buffer) == 0)
			{
				SendSms(__network_data.admin,"Hiba: Maga a felhasznalo", "");
				
			} else {
				int i;
				
				SendSms(__network_data.admin,"Uj felhasznalo: ", __network_data.phone_buffer);

				SendSms(__network_data.phone_buffer,"Regi felhasznalo: ", __network_data.admin);

				strcpy(__network_data.admin,__network_data.phone_buffer);

				eepromSaveCfg(__network_data.admin,0);
				
			}
			clearReadLine();
			return;
		}

		
		if (strstr(__network_data.admin,__network_data.phone_buffer) != 0)
		{
 
			if (strstr(p,"INFO") != 0 )
			{
				  char message[200];
				  int i=0;
				  strcpy(message,"INFO:\n");
				  
				  for (i=0;i<5;i++){
					  char rel[5];
					  itoa(i+1,rel,10);
					  
					  strcat(message,"RELAY ");
					  strcat(message,rel);
					  strcat(message," ");
					  if (__system_var.relay_states[i] == 1){
						  strcat(message,"ON\n");
					  } else {
						  strcat(message,"OFF\n");
					  }
					 
				  }
				  SendSms(__network_data.admin,message,"");
			}
			
			if (strstr(p,"REL") != 0 )
			{
				char *p2 = strstr(p,"REL");
				char relay = *(p2+3);
				char relstr[2];
				char state = 0;
				char message[30];
				
				relstr[0] = relay;
				relstr[1] = '\0';
				
				if (strstr(p,"ON")){
					state = 1;
				} else if (strstr(p,"OFF")){
					state = 0;
				} 
				
				switch (relay){
					
					case '1':
						digitalWrite(RELAY_1,state);
						__system_var.relay_states[0] = state;
						eeprom_write_byte((uint8_t*)20,state);
					break;
					
					case '2':
						digitalWrite(RELAY_2,state);
						__system_var.relay_states[1] = state;
						eeprom_write_byte((uint8_t*)21,state);
					break;
					
					case '3':
						digitalWrite(RELAY_3,state);
						__system_var.relay_states[2] = state;
						eeprom_write_byte((uint8_t*)22,state);
					break;
					
					case '4':
						digitalWrite(RELAY_4,state);
						__system_var.relay_states[3] = state;
						eeprom_write_byte((uint8_t*)23,state);
					break;
					
					case '5':
						digitalWrite(RELAY_5,state);
						__system_var.relay_states[4] = state;
						eeprom_write_byte((uint8_t*)24,state);
					break;
					case 'X':
						char buffer[6];
						int i;
						digitalWrite(RELAY_1,state);
						digitalWrite(RELAY_2,state);
						digitalWrite(RELAY_3,state);
						digitalWrite(RELAY_4,state);
						digitalWrite(RELAY_5,state);
						__system_var.relay_states[0] = state;
						__system_var.relay_states[1] = state;
						__system_var.relay_states[2] = state;
						__system_var.relay_states[3] = state;
						__system_var.relay_states[4] = state;
						for (i=0;i<5;i++){
							while(!eeprom_is_ready());
							eeprom_write_byte((uint8_t*)20+i,state);
						}
					break;
					
				}	
				strcpy(message,"RELAY ");
				strcat(message,relstr);
				strcat(message, (state == 1) ? " BEKAPCSOLVA" : " KIKAPCSOLVA");
				
				SendSms(__network_data.admin,message,"");			
			}			
		}
		

		delay(2000);
		clearReadLine();

	}
}

void WebApp(){
	
	if (strstr(__network_data.esp_buffer, "GET / HTTP/") != 0){
		char content[550];
		char page[700];
		int contentLength;
		char converter[5];
		char connection[2];
		char *p = strstr(__network_data.esp_buffer,"+IPD,");
		connection[0] = *(p+=5);
		connection[1] = '\0';
		delay(500);
		strcpy(content,"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0\"></head><body>");
		strcat(content,"<title>HCM Console</title>");
		strcat(content,"<div style=\"font-size: medium; text-align: center;\"><span>");
		strcat(content,"<form method=\"POST\">");
		strcat(content,"<p><strong>SERIAL: ");
		strcat(content,__system_var.serial_number);
		strcat(content,"</strong></p><p><strong>SSID</strong><br><input type=\"text\" name=\"ssid\" value=\"\"></p>");
		strcat(content,"<p><strong>PASSWORD</strong><br><input type=\"password\" name=\"password\" value=\"\"></p>");
		strcat(content,"<p><strong>APN</strong><br><input type=\"text\" name=\"apn\" value=\"\"></p>");
		strcat(content,"<input type=\"submit\"></form></span></div>");
		strcat(content,"</body></html>");

		contentLength = strlen(content);

		strcpy(page,"HTTP/1.0 200 OK\r\nContent-Type: text/html; charset=UTF-8\r\nPragma: no-cache\r\nContent-Length: ");
		strcat(page,itoa(contentLength,converter,10));
		strcat(page,"\r\nConnection: close\r\n\r\n");
		strcat(page,content);
		
		sendToAP(page, connection);
		readUntil("OK",3);
	}
	
	if (strstr(__network_data.esp_buffer, "POST / HTTP/") != 0){
		int timeout=0;
		int flag = 0;
		while (1){
			timeout++; delay(1);
			if (timeout == 1000) break;
			if (strstr(__network_data.esp_buffer,"password") != 0 || strstr(__network_data.esp_buffer,"ssid") != 0)break;
			if (strstr(__network_data.esp_buffer,"\r\n") != 0){
				memset(__network_data.esp_buffer,' ',sizeof(__network_data.esp_buffer)-1);
				__network_data.index_esp = 0;
			}
		}
		delay(200);
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
		
		if (strstr(__network_data.esp_buffer,"apn") != 0){
			int pos=0;
			char *p1 = strstr(__network_data.esp_buffer,"apn");
			p1+=9;
			memset(__network_data.apn,' ',sizeof(__network_data.apn)-1);
			while (1){
				if (pos == sizeof(__network_data.apn))break;
				if (!isalnum(*p1))break;
				__network_data.apn[pos++] = *p1++;
			}
			__network_data.apn[pos] = '\0';
		}
		
		if (flag == 2){
			__system_time.connection_timer_buffer = 0;
			__system_time.connection_timer = 0;
			__network_data.is_server_connected = false;
			__network_data.is_esp_connected = false;
			setSource(ESP);
		}
	}
	
}

void switchRelay(char moduleId, char relayId, char state){
	
	char r1,r2;
	int i;
	for (i=0;i<10;i++){
		chipSelect(moduleId,0);
		SPI_WriteRead(SWITCH_RELAY);
		r1 = SPI_WriteRead(relayId);
		r2 = SPI_WriteRead(state);
		chipSelect(moduleId,1);
		
		if (r1 + r2 == 14){
			break;
			} else {
			delay(200);
		}
	}
	
}

void RelayControl(){
	
	if (strstr(__network_data.esp_buffer, "SWITCHRELAY") != 0){
		char *p1;
		int relayId, moduleId, state;
		char conv[5];
		char response[40];
		
		p1 = strstr(__network_data.esp_buffer, "SWITCHRELAY");
		strtok(p1,";");
		moduleId = atoi(strtok(0,";"));
		relayId = atoi(strtok(0,";"));
		state = atoi(strtok(0,";"));
		
		switchRelay(moduleId,relayId,state);
		
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

void ReceiveSettings(){
	
	if (strstr(__network_data.esp_buffer, "CFG") != 0){

		if (strstr(__network_data.esp_buffer, "[CLEAR_EEPROM]") != 0){
			USART0_SendString("CLEARING...");
			eepromClear();
			__system_var.eeprom_position = 20;
			sendToServer("OK\n",CONNECTION);
			return;
		}
		if (strstr(__network_data.esp_buffer, "[END]") != 0){
			__system_var.eeprom_position = 20;
			sendToServer("OK\n",CONNECTION);
			return;
		}
		char *p1;
		p1 = strtok(__network_data.esp_buffer,"$");
		p1 = strtok(0,"$");
		__system_var.eeprom_position = eepromSaveCfg(p1,__system_var.eeprom_position);
		delay(10);
		sendToServer("OK\n",CONNECTION);
	}
}