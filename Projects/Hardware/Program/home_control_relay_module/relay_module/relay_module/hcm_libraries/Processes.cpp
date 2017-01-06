/*
* Processes.cpp
*
* Created: 2016.10.04. 16:46:46
*  Author: tjozsa
*/
#include <Processes.h>
#include <HCM.h>

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
		strcat(content,"<p><strong>SSID</strong><br><input type=\"text\" name=\"ssid\" value=\"\"></p>");
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

void ReceiveSettings(){
	
	if (strstr(__network_data.esp_buffer, "[CFG]") != 0){
		
		if (strstr(__network_data.esp_buffer, "[CLEAR_EEPROM]") != 0){
			USART0_SendString("CLEARING...");
			eepromClear();
			__system_var.eeprom_position = 20;
			sendToServer("OK\n","0");
			readUntil("OK",3);
		}
		if (strstr(__network_data.esp_buffer, "[END]") != 0){
			__system_var.eeprom_position = 20;
			sendToServer("OK\n","0");
			readUntil("OK",3);
		}
		char *p1;
		p1 = strtok(__network_data.esp_buffer,"$");
		p1 = strtok(0,"$");
		__system_var.eeprom_position = eepromSaveCfg(p1,__system_var.eeprom_position);
		delay(10);
		sendToServer("OK\n","0");
		readUntil("OK",3);
	}
}