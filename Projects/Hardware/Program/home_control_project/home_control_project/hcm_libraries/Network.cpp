/*
* Network.cpp
*
* Created: 2016.09.30. 13:50:39
*  Author: tjozsa
*/
#include <Network.h>
#include <HCM.h>


ISR(USART1_RX_vect){
	char value = UDR1;             //read UART register into value
	if (__network_data.index_sim >= sizeof(__network_data.sim_buffer)-3){
		// To stop buffer from overfloating
		__network_data.index_sim = 0;
	}
	__network_data.sim_buffer[__network_data.index_sim++] = value;
	if (value == '\r' || value == '\n' || value == '\0'){
		__network_data.is_sim_read_line = 1;
		__network_data.sim_buffer[__network_data.index_sim] = '\0';
		
	}
}
ISR(USART0_RX_vect){
	char value = UDR0;             //read UART register into value
	if (__network_data.index_esp >= sizeof(__network_data.esp_buffer)-3){
		// To stop buffer from overfloating
		__network_data.index_esp = 0;
	}
	__network_data.esp_buffer[__network_data.index_esp++] = value;
	if (value == '\r' || value == '\n' || value == '\0'){
		__network_data.is_esp_read_line = 1;
		__network_data.esp_buffer[__network_data.index_esp] = '\0';
		
	}
}
ISR(TIMER0_OVF_vect)
{
	if (++__system_var.timer0_overflow == 39){
		__system_var.timer0_overflow = 0;
		__system_time._mils++;

		// Clock buffer for sensors

		if (__system_time._mils == 1000){
			__system_time._sec++;
			__system_time._mils = 0;
			if (__system_time.connection_timer_buffer <= __system_time.connection_timer){
				__system_time.connection_timer_buffer++;
			}
			if (__system_time.check_timer_buffer <= __system_time.check_timer){
				__system_time.check_timer_buffer++;
			}
			if (__system_time.relay_module_check_timer_buffer <= __system_time.relay_module_check_timer){
				__system_time.relay_module_check_timer_buffer++;
			}
			if (__system_time.timer_check_timer_buffer <= __system_time.timer_check_timer){
				__system_time.timer_check_timer_buffer++;
			}
			if (__system_time.gsm_network_timer_buffer <= __system_time.gsm_network_timer){
				__system_time.gsm_network_timer_buffer++;
			}
		}
		if (__system_time._sec == 60){
			__system_time._min++;
			__system_time._sec = 0;
		}
		if (__system_time._min == 60){
			__system_time._hour++;
			__system_time._min = 0;
		}
		if (__system_time._hour == 24){
			__system_time._day++;
			__system_time._hour = 0;
		}
		if (__system_time._day == DAYS_OF_MONTH[__system_time._month]){
			__system_time._month++;
			__system_time._day = 0;
		}
		if (__system_time._month == 12){
			__system_time._year++;
			__system_time._month = 0;
		}
	}
}

int readUntil(const char *input, int timeout) {

	int mils = 0;
	clearReadLine();

	while(mils <= (timeout*1000)){
		if(__system_var.interface_ == ESP){
			if (strstr(__network_data.esp_buffer, input) != 0) {
				return 1;
			}
			if (strstr(__network_data.esp_buffer, "ERROR") != 0 || strstr(__network_data.esp_buffer, "Fail") != 0 || strstr(__network_data.esp_buffer, "FAIL") != 0) {
				return 0;
			}
		}
		if(__system_var.interface_ == SIM){
			
			if (strstr(__network_data.sim_buffer, input) != 0) {
				return 1;
			}
			if (strstr(__network_data.sim_buffer, "ERROR") != 0 || strstr(__network_data.sim_buffer, "Fail") != 0 || strstr(__network_data.sim_buffer, "FAIL") != 0) {
				return 0;
			}
		}
		mils++;
		_delay_ms(1);
	}

	return 0;
}
void cipsend(char *p, char *connection) {
	char conv[5];

	if (__system_var.interface_ == ESP) {
		int size = 0;
		char *b = p;
		for (; *b++ != '\0'; size++) ;

		WIFI_Write_String("AT+CIPSEND=");
		WIFI_Write_String(connection);
		WIFI_Write_String(",");
		WIFI_Write_String(itoa(size, conv, 10));
		WIFI_Write_String("\r\n");
		
	} else {
		GSM_Write_String("AT+CIPSEND\r\n");
	}
	
	if (readUntil(">", 3) == 0) {
		__network_data.is_server_connected = FALSE;
		__network_data.is_esp_connected = FALSE;
		__network_data.is_sim_connected = FALSE;
	}

	if (__system_var.interface_ == ESP) {
		WIFI_Write_String(p);
	} else {
		GSM_Write_String(p);
		GSM_Write_Byte(26);
		GSM_Write_Byte(0x0D);
	}
}
void sendToServer(char *toSend, int connection){
	int i,j;
	char *p1,*p2, conv[5];
	
	if (!__network_data.is_server_connected) return;
	
	p1 = toSend;
	for(i=0;*p1++!='\0';i++);
	p1 = (char*)malloc((sizeof(char)*i)+1);
	p2 = p1;
	*p2 = '#';p2++;
	for(j=0;j<=i;j++)*p2++=*toSend++;
	p2 = toSend;
	
	cipsend(p1,itoa(connection,conv,10));	
	readUntil("OK",3);
}
void sendToAP(char *toSend, char *connection){
	char conv[5];

	int size = 0;
	char *b = toSend;
	for (; *b++ != '\0'; size++) ;

	WIFI_Write_String("AT+CIPSEND=");
	WIFI_Write_String(connection);
	WIFI_Write_String(",");
	WIFI_Write_String(itoa(size, conv, 10));
	WIFI_Write_String("\r\n");
	
	if (readUntil(">", 2) == 0) {
		__network_data.is_server_connected = FALSE;
		__network_data.is_esp_connected = FALSE;
		__network_data.is_sim_connected = FALSE;
	}

	delay(300);
	WIFI_Write_String(toSend);
	readUntil("OK",3);
}
char getSystemTime() {
	char *p1,*p2;
	char testout[40];
	char buffer[5];
	short i = 0;

	if (readUntil("TIME", 15) == 0) return 0;
	delay(100);

	//YY;MM;DD;HH;MM;SS;
	p1 = strstr(__network_data.esp_buffer,"TIME");
	p2 = strtok(p1, ";");
	while (p2 != 0) {
		switch (i) {
			case 1: __system_time._year = atoi(p2); break;
			case 2: __system_time._month = atoi(p2); break;
			case 3: __system_time._day = atoi(p2); break;
			case 4: __system_time._hour = atoi(p2); break;
			case 5: __system_time._min = atoi(p2);  break;
			case 6: __system_time._sec = atoi(p2); break;
			case 7: __system_time._day_of_week = atoi(p2); break;
			break;
		}
		i++;
		p2 = strtok(0, ";");
	}
	/*strcpy(testout,"TIME:");
	strcat(testout,itoa(__system_time._year,buffer,10));
	strcat(testout,";");
	strcat(testout,itoa(__system_time._month,buffer,10));
	strcat(testout,";");
	strcat(testout,itoa(__system_time._day,buffer,10));
	strcat(testout,";");
	strcat(testout,itoa(__system_time._hour,buffer,10));
	strcat(testout,";");
	strcat(testout,itoa(__system_time._min,buffer,10));
	strcat(testout,";");
	strcat(testout,itoa(__system_time._sec,buffer,10));
	strcat(testout,";");
	strcat(testout,itoa(__system_time._day_of_week,buffer,10));
	strcat(testout,";");*/
	
	//USART0_SendString(testout);
	//delay(500);
	

	sendToServer("TIME OK\n",CONNECTION);
	//if (readUntil("OK", 2) == 0) return 0;
	
	clearReadLine();
	return 1;
}
char setSerialNumber() {
	
	if (strstr(__network_data.esp_buffer, "SERIAL_NUMBER") != 0) {
		char *p;
		char toWrite[50];
		p = strtok(__network_data.esp_buffer, "#");
		p = strtok(0, "#");

		strcpy(__system_var.serial_number, p);
		strcpy(toWrite,"#SERIAL;");
		strcat(toWrite,__system_var.serial_number);
		strcat(toWrite,"#");
		eepromSaveCfg(toWrite,EEPROM_SERIAL_START);
		p = 0;
		//sendToServer("OK\n",CONNECTION);
		//readUntil("OK",3);

		clearReadLine();
		return 1;
	}
	return 0;
}
char checkSerialNumber() {
	
	if (eepromReadAttribute(__system_var.serial_number,sizeof(__system_var.serial_number),"SERIAL",1) == 0) {
		char buffer[100];
		clearReadLine();
		strcpy(buffer,"REQUEST_SERIAL_NUMBER;");
		strcat(buffer,PRODUCT_NAME);
		strcat(buffer,"\n");
		delay(1000);
		sendToServer(buffer,CONNECTION);
		if (readUntil("SERIAL_NUMBER", 15) == 0);
		delay(100);
		if (setSerialNumber() == 0) return 0;
		
	} else { 
		char buffer[50];
		strcpy(buffer, "SERIAL_NUMBER;");
		strcat(buffer, __system_var.serial_number);
		strcat(buffer, ";\n");
		sendToServer(buffer,CONNECTION);
		//if (readUntil("OK", 2) == 0) return 0;
	}
	/*USART0_SendString("\nSERIALNUMBER=");
	USART0_SendString(__system_var.serial_number);
	USART0_SendString("\n");*/
	delay(100);
	return 1;
}
char connectToWifi(const char *ssid, const char *password) {

	WIFI_Write_String("AT+CIPDOMAIN=\"jtech-iot.com\"\r\n");
	readUntil("OK", 3);
	WIFI_Write_String("AT+CIFSR\r\n");
	readUntil("OK", 3);
	WIFI_Write_String("AT+CWJAP=\"");
	WIFI_Write_String(ssid);
	WIFI_Write_String("\",\"");
	WIFI_Write_String(password);
	WIFI_Write_String("\"\r\n");
	if (readUntil("OK", 10)) {
		return TRUE;
		} else {
		return FALSE;
	}
}
char connectToGprs(const char *apn) {
	
	char err = 0;

	GSM_Write_String("AT+CIPSHUT\r\n");
	readUntil("OK", 10);
	
	GSM_Write_String("AT+CIPMUX=0\r\n");
	readUntil("OK", 10);

	GSM_Write_String("AT+CGATT=1\r\n");
	readUntil("OK", 10);

	GSM_Write_String("AT+CGDCONT=1,\"IP\",\"");
	GSM_Write_String(apn);
	GSM_Write_String("\"\r\n");
	readUntil("OK", 10);

	GSM_Write_String("AT+CSTT=\"");
	GSM_Write_String(apn);
	GSM_Write_String("\",\"\",\"\"\r\n");
	readUntil("OK", 10);

	GSM_Write_String("AT+CIICR\r\n");

	if (readUntil("OK", 10)) {
		err = 1;
		} else {
		err = 0;
	}
	
	GSM_Write_String("AT+CIFSR\r\n");
	delay(500);

	return err;
}




char exchangeMandatoryInfo(){
	// Send HELLO to SERVER
	__network_data.is_server_connected = TRUE;
	if (getSystemTime() == 0){
		__network_data.is_server_connected = FALSE;
		return 0;
	}
	if (checkSerialNumber() == 0){
		__network_data.is_server_connected = FALSE;	
		return 0;
	}
	__network_data.is_server_connected = TRUE;
	clearReadLine();
	return 1;
}

char connectToServer(const char *host, const char *port) {
 
	if (__system_var.interface_ == ESP) {
		// Single IP connection
		//USART0_SendString("AT+CIPMUX=1\r\n");
		//if (readUntil("OK", 2) == 0) return 0;
	}

	// AT+CIPSTART    Connect to server , replace variables
	clearReadLine();

	if (__system_var.interface_ == ESP) {
		WIFI_Write_String("AT+CIPSTART=0,\"TCP\",\"");
		WIFI_Write_String(host);
		WIFI_Write_String("\",");
		WIFI_Write_String(port);
		WIFI_Write_String("\r\n");
	}
	if (__system_var.interface_ == SIM) {
		GSM_Write_String("AT+CIPCLOSE=0\r\n");
		readUntil("OK", 10);
		GSM_Write_String("AT+CIPSTART=\"TCP\",\"");
		GSM_Write_String(host);
		GSM_Write_String("\",\"");
		GSM_Write_String(port);
		GSM_Write_String("\"\r\n");
	}
	
	if (readUntil("OK",10) == 1){
		return 1;
	}
	return 0;

}

char getDefaultDevicePoolInformation(){
	getDefaultNetworkSetting(__network_data.host, __network_data.port);
	if (connectToServer(__network_data.host, __network_data.port) == 1){
		char productName[20];
		char success = 0;
		strcpy(productName,PRODUCT_NAME);
		strcat(productName,"\n");
		__network_data.is_server_connected = TRUE;
		delay(500);
		sendToServer(productName,CONNECTION);
		if (readUntil("HOST", 10) == 1) {
			char *p1,*p2,*p3,*save_ptr1,*save_ptr2;
			delay(100);
			
			if (__system_var.interface_ == ESP){
				p3 = strstr(__network_data.esp_buffer,"HOST");
			} else if (__system_var.interface_ == SIM){
				p3 = strstr(__network_data.sim_buffer,"HOST");
			}
			
			p2 = strstr(p3,"HOST");
			p1 = strtok_r(p2,";",&save_ptr1);
			while (p1 != 0){
				
				p2 = strtok_r(p1,"=",&save_ptr2);
				
				if (strstr(p2,"HOST") !=0 ){
					p2 = strtok_r(0,"=",&save_ptr2);
					strcpy(__network_data.host,p2);
					success++;
				}
				if (strstr(p2,"PORT") !=0 ){
					p2 = strtok_r(0,"=",&save_ptr2);
					strcpy(__network_data.port,p2);
					success++;
				}
				
				p1 = strtok_r(0,";",&save_ptr1);
			}
			if (success == 2){
				delay(300);
				if (__system_var.interface_ == ESP){
					WIFI_Write_String("AT+CIPCLOSE=0\r\n");
				} else if (__system_var.interface_ == SIM){
					GSM_Write_String("AT+CIPSHUT\r\n");
					readUntil("OK", 10);
				}
				return 1;
			}
			
		}
	}
	return 0;
}

void networking() {
	

	if (__system_time.connection_timer_buffer >= __system_time.connection_timer) {
		
		if ( __network_data.is_server_connected != TRUE ) {
			char connected = FALSE;
			
			if (HAS_WIFI == TRUE){
				setSource(ESP);
				__network_data.is_esp_connected = connectToWifi(__network_data.ssid, __network_data.password);
			}
			
			if (!__network_data.is_esp_connected) {
				setSource(SIM);
				__network_data.is_sim_connected = connectToGprs(__network_data.apn);
			}
			
			if (__network_data.is_esp_connected || __network_data.is_sim_connected){
				
				if (getPrimaryNetworkSetting(__network_data.host, __network_data.port) != 0){
					GSM_Write_String("getPrimaryNetworkSetting");
					delay(500);
					if (connectToServer(__network_data.host, __network_data.port) != 0){
						connected = exchangeMandatoryInfo();
					} else {
						connected = FALSE;
					}	
				}
				if (connected == FALSE && getSecondaryNetworkSetting(__network_data.host, __network_data.port) != 0){
					GSM_Write_String("getSecondaryNetworkSetting");
					delay(500);
					if (connectToServer(__network_data.host, __network_data.port) != 0){
						connected = exchangeMandatoryInfo();
					} else {
						connected = FALSE;
					}
				}
				if (connected == FALSE && getDefaultDevicePoolInformation() != 0){
					GSM_Write_String("getDefaultDevicePoolInformation");
					delay(500);
					if (connectToServer(__network_data.host, __network_data.port) != 0){
						connected = exchangeMandatoryInfo();
					} else {
						connected = FALSE;
					}
				}
			}

			if (!(__network_data.is_sim_connected || __network_data.is_esp_connected ) || !__network_data.is_server_connected) {
				if (__system_time.connection_timer <= 600) __system_time.connection_timer += 20;
			}
			__system_time.check_timer_buffer = 0;
			__system_time.relay_module_check_timer_buffer = 0;

		}
		__system_time.connection_timer_buffer = 0;
		
	}
}
