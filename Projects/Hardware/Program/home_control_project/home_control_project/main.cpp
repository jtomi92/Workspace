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
		char previousSource = __system_var.interface_;
		delay(100);

		ConfigurationThread();
		
		RelayControl();
		
		ReceiveSettings();			
		
		clearReadLine();
		
		__system_var.interface_ = previousSource;
		__network_data.is_esp_read_line = 0;	
	}
	
	// Processes gsm responses
	if (__network_data.is_sim_read_line == 1){
		char previousSource = __system_var.interface_;
		setSource(SIM);
		
		RelayControl();
		
		ReceiveSettings();
		
		IncomingCallHandler();
		
		IncomingSMSHandler();
		
		clearGSMBuffer();
		__network_data.is_sim_read_line = 0;
		__system_var.interface_ = previousSource;
	}
	
}
void systemProcesses(){
	
	// Detects when a module is connected or disconnected, notifies server of this event
	CheckModuleConnections();
	// Regularly sends heartbeats to the server to keep the connection alive
	HeartBeat(); 
	// Process Timers
	ProcessRelayTimers();
	
	checkGsmNetwork();
}
 

int main (void)
{
	int i=0;
	setup();
	
	// For debugging EEPROM
	/*for (i=0;i<1000;i++){
		 USART0_SendByte(eeprom_read_byte((uint8_t*)i));
	}*/
	 //209000782
	
	while(1)
	{
		
		networking();
		
		processIO();
		
		systemProcesses();	
		
	}
}
 