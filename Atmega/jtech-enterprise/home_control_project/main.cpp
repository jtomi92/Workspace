#include <HCM.h>



void decodeBuffer(char interface_){
	if (interface_ == ESP){

	}
	if (interface_ == SIM){

	}
}
void processIO(){
	
	if (__network_data.is_esp_read_line == 1){
		
		delay(300);
		SmsIncome();
		SmsCommands();
		
		
		clearReadLine();
		__network_data.is_esp_read_line = 0;
		
	}
	
}

void systemProcesses(){
	
	if (__system_time.interrupt_flag > 0){
		int read,i;
		char buffer[5];
		char message[40];
		
		/*strcpy(message,"OPTO[1]: ");
		read = digitalRead(OPTO_1);
		strcat(message,itoa(read,buffer,10));
		strcat(message," OPTO[2]:");
		
		read = digitalRead(OPTO_2);
		strcat(message,itoa(read,buffer,10));
		strcat(message," OPTO[3]:");
		
		read = digitalRead(OPTO_3);
		strcat(message,itoa(read,buffer,10));
		
		strcat(message,"\n\n\n");
		USART0_SendString(message);*/
		
		
		read = digitalRead(OPTO_1);
		read = digitalRead(OPTO_2);
		read = digitalRead(OPTO_3);
		
		for (i=0;i<3;i++){
			
			switch (i){
				case 0:
				read = digitalRead(OPTO_1);
				break;
				
				case 1:
				read = digitalRead(OPTO_2);
				break;
				
				case 2:
				read = digitalRead(OPTO_3);
				break;
			}
			
			if (read == 0 && __system_var.opto_states[i] == 0){
				char message[30];
				char buffer[5];
				
				strcpy(message,"BEMENET ");
				strcat(message,itoa(i+1,buffer,10));
				strcat(message," BEKAPCSOLT");
				//SendSms(__network_data.admin,message,"");
				
				__system_var.opto_states[i] = 1;
			} else if (read != 0 && __system_var.opto_states[i] == 1){
				strcpy(message,"BEMENET ");
				strcat(message,itoa(i+1,buffer,10));
				strcat(message," KIKAPCSOLT");
				SendSms(__network_data.admin,message,"");
				__system_var.opto_states[i] = 0;
		}
	}
	
	__system_time.interrupt_flag = 0;
}

checkConnectivity();
DelSms();
}


int main (void)
{
	setup();
	
	delay(2000);
	


	USART0_SendString("AT+CMGF=1\r\n");
	delay(300);
	USART0_SendString("AT+CLTS=1\r\n");
	delay(500);
	USART0_SendString("AT+CLIP=1\r\n");
	delay(500);

	while(1)
	{
		
		//networking();
		
		processIO();
		
		systemProcesses();
		
	}
}
