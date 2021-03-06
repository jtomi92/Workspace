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
		__network_data.esp_buffer[__network_data.index_sim] = '\0';
		
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
		}
		if(__system_var.interface_ == SIM){
			if (strstr(__network_data.sim_buffer, input) != 0) {
				return 1;
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

		USART0_SendString("AT+CIPSEND=");
		USART0_SendString(connection);
		USART0_SendString(",");
		USART0_SendString(itoa(size, conv, 10));
		USART0_SendString("\r\n");
		} else {
		USART0_SendString("AT+CIPSEND\r");
	}
	
	if (readUntil(">", 2) == 0) {
		__network_data.is_server_connected = !SERVER_CONNECTED;
		__network_data.is_esp_connected = FALSE;
		__network_data.is_sim_connected = FALSE;
	}

	if (__system_var.interface_ == ESP) {
		USART0_SendString(p);
		} else {
		USART1_SendString(p);
		USART1_SendByte(26);
		USART1_SendByte(0x0D);
	}

}
void sendToServer(char *toSend, char *connection){
	int i,j;
	char *p1,*p2;
	p1 = toSend;
	for(i=0;*p1++!='\0';i++);
	p1 = (char*)malloc((sizeof(char)*i)+1);
	p2 = p1;
	*p2 = '#';p2++;
	for(j=0;j<=i;j++)*p2++=*toSend++;
	p2 = toSend;
 
	cipsend(p1,connection);
}
void sendToAP(char *toSend, char *connection){
	char conv[5];

	int size = 0;
	char *b = toSend;
	for (; *b++ != '\0'; size++) ;

	USART0_SendString("AT+CIPSEND=");
	USART0_SendString(connection);
	USART0_SendString(",");
	USART0_SendString(itoa(size, conv, 10));
	USART0_SendString("\r\n");
	

	if (readUntil(">", 2) == 0) {
		__network_data.is_server_connected = !SERVER_CONNECTED;
		__network_data.is_esp_connected = FALSE;
		__network_data.is_sim_connected = FALSE;
	}
	USART0_SendString(toSend);
}
char getSystemTime() {
	char *p;
	short i = 0;

	if (readUntil("TIME", 15) == 0) return 0;
	delay(100);

	//YY;MM;DD;HH;MM;SS;
	//p = strtok(__network_data.esp_buffer, ";");
	/*while (p != 0) {
	switch (i) {
	case 1: __system_time._year = atoi(p); break;
	case 2: __system_time._month = atoi(p); break;
	case 3: __system_time._day = atoi(p); break;
	case 4: __system_time._hour = atoi(p); break;
	case 5: __system_time._min = atoi(p);  break;
	case 6: __system_time._sec = atoi(p); break;
	}
	i++;
	p = strtok(0, ";");
	}*/

	sendToServer("TIME OK\n","0");
	if (readUntil("OK", 2) == 0) return 0;

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
		eepromSaveSerial(toWrite);
		p = 0;
		sendToServer("OK\n","0");
		readUntil("OK",3);

		clearReadLine();
		return 1;
	}
	return 0;
}
char checkSerialNumber() {

	if (eepromReadAttribute(__system_var.serial_number,sizeof(__system_var.serial_number),"SERIAL",1) != 0) {
		char buffer[100];
		clearReadLine();
		strcpy(buffer,"REQUEST_SERIAL_NUMBER;");
		strcat(buffer,product_name);
		strcat(buffer,"\n");
		delay(1000);
		sendToServer(buffer,"0");
		if (readUntil("SERIAL_NUMBER", 15) == 0);
			delay(100);
		if (setSerialNumber() == 0) return 0;
	} else {
		char buffer[50];
		strcpy(buffer, "SERIAL_NUMBER;");
		strcat(buffer, __system_var.serial_number);
		strcat(buffer, ";\n");
		sendToServer(buffer,"0");
		if (readUntil("OK", 2) == 0) return 0;
	}
	USART0_SendString("\nSERIALNUMBER=");
	USART0_SendString(__system_var.serial_number);
	USART0_SendString("\n");
	delay(100);
	return 1;
}
char connectToWifi(const char *ssid, const char *password) {

	USART0_SendString("AT+SLEEP=2\r\n");
	readUntil("OK", 3);
	USART0_SendString("AT+CIPMUX=1\r\n");
	readUntil("OK", 3);
	USART0_SendString("AT+CWMODE=3\r\n");
	readUntil("OK", 3);
	USART0_SendString("AT+CWSAP=\"HCM-NETWORK\",\"admin1234\",5,3\r\n");
	readUntil("OK", 3);
	USART0_SendString("AT+CIPSERVER=1,80\r\n");
	readUntil("OK", 3);
	USART0_SendString("AT+CIFSR\r\n");
	readUntil("OK", 3);
	USART0_SendString("AT+CWJAP=\"");
	USART0_SendString(ssid);
	USART0_SendString("\",\"");
	USART0_SendString(password);
	USART0_SendString("\"\r\n");
	if (readUntil("OK", 10)) {
		return TRUE;
		} else {
		return FALSE;
	}
}
char connectToGprs(const char *apn) {

	USART1_SendString("AT+CIPSHUT\r");
	readUntil("OK", 10);

	USART1_SendString("AT+CGATT=1\r");
	readUntil("OK", 10);

	USART1_SendString("AT+CGDCONT=1,\"IP\",\"");
	USART1_SendString(apn);
	USART1_SendString("\"\r");
	readUntil("OK", 10);

	USART1_SendString("AT+CSTT=\"");
	USART1_SendString(apn);
	USART1_SendString("\",\"\",\"\"\r");
	readUntil("OK", 10);

	USART1_SendString("AT+CIICR\r\n");

	if (readUntil("OK", 10)) {
		return TRUE;
		} else {
		return FALSE;
	}

	//UART2_Write_Text("AT+CIFSR\r");
	//readUntil("OK",10,GPRS);
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
		USART0_SendString("AT+CIPSTART=0,\"TCP\",\"");
		USART0_SendString(host);
		USART0_SendString("\",");
		USART0_SendString(port);
		USART0_SendString("\r\n");
	}
	if (__system_var.interface_ == SIM) {
		USART0_SendString("AT+CIPSTART=\"TCP\",\"");
		USART0_SendString(host);
		USART0_SendString("\",\"");
		USART0_SendString(port);
		USART0_SendString("\"\r");
	}

	if (readUntil("OK", 10) == 1) {
		// Send HELLO to SERVER
		__network_data.is_server_connected = TRUE;
		if (getSystemTime() == 0) return 0;
		if (checkSerialNumber() == 0);

		} else {
		//__network_data.is_server_connected = FALSE;
		return 0;
	}
	
	return 1;

}
void networking() {
	

	if (__system_time.connection_timer_buffer <= __system_time.connection_timer) {
		
		if ( __network_data.is_server_connected != SERVER_CONNECTED ) {
			setSource(ESP);
			__network_data.is_esp_connected = connectToWifi(__network_data.ssid, __network_data.password);

			if (!__network_data.is_esp_connected) {
				setSource(SIM);
				//__network_data.is_sim_connected = connectToGprs(__network_data.apn);
			}

			if (__network_data.is_esp_connected) {
				setSource(ESP);
				if (connectToServer(__network_data.host, __network_data.port) == 1){
					__network_data.is_server_connected = SERVER_CONNECTED;
					clearReadLine();
				}
			}
			if (__network_data.is_sim_connected) {
				setSource(SIM);
				//connectToServer(__network_data.host, __network_data.port);
			}

			if (!(__network_data.is_sim_connected || __network_data.is_esp_connected)) {
				if (__system_time.connection_timer <= 600) __system_time.connection_timer += 20;
			}

		}
		__system_time.connection_timer_buffer = 0;
	}
}
