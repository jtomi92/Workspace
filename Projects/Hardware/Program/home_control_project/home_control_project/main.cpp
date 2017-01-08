#include <HCM.h>



void decodeBuffer(char interface_){
	if (interface_ == ESP){

	}
	if (interface_ == SIM){

	}
}
void processIO(){
	
	// Processes wifi responses
	if (__network_data.is_esp_read_line == 1){
		
		delay(100);
		
		decodeBuffer(ESP);
		
		RelayControl();
		
		ReceiveSettings();
		
		WebApp();	
		
		__network_data.is_esp_read_line = 0;	
	}
	
	// Processes gsm responses
	if (__network_data.is_sim_read_line == 1){
		
		__network_data.is_sim_read_line = 0;
	}
	
}
void systemProcesses(){
	
	// Detects when a module is connected or disconnected, notifies server of this event
	CheckModuleConnections();
	// Regularly sends heartbeats to the server to keep the connection alive
	HeartBeat(); 
	// Process Timers
	ProcessRelayTimers();
}
 

int main (void)
{
	int i=0;
	setup();
	
	/*for (i=0;i<1000;i++){
		 USART0_SendByte(eeprom_read_byte((uint8_t*)i));
	}*/
	 
	while(1)
	{
		
		networking();
		
		processIO();
		
		systemProcesses();	
		
	}
}
 