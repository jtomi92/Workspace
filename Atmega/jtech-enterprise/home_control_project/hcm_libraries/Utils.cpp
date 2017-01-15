/*
* Utils.cpp
*
* Created: 2016.09.24. 13:42:31
*  Author: tjozsa
*/
#include <Utils.h>
#include <HCM.h>

void USART_Init(void){
	UBRR0L = BAUD_PRESCALE;
	UBRR0H = (BAUD_PRESCALE >> 8);
	UCSR0B = ((1<<TXEN0)|(1<<RXEN0) | (1<<RXCIE0));
	UBRR1L = BAUD_PRESCALE;
	UBRR1H = (BAUD_PRESCALE >> 8);

	UCSR1B = ((1<<TXEN1)|(1<<RXEN1) | (1<<RXCIE1));
	
	sei();
}
void USART1_SendByte(const char c){
	while((UCSR1A &(1<<UDRE1)) == 0);
	UDR1 = c;
}
void USART1_SendString(const char s[]){
	int i =0;
	
	while (s[i] != 0x00)
	{
		USART1_SendByte(s[i]);
		i++;
	}
}
char USART1_ReceiveByte(){
	while((UCSR1A &(1<<RXC1)) == 0);
	return UDR1;
}
void USART0_SendByte(const char c){
	while((UCSR0A &(1<<UDRE0)) == 0);
	UDR0 = c;
}
void USART0_SendString(const char s[]){
	int i =0;
	
	while (s[i] != 0x00)
	{
		USART0_SendByte(s[i]);
		i++;
	}
}
char USART0_ReceiveByte(){
	while((UCSR0A &(1<<RXC0)) == 0);
	return UDR0;
}
void turnOnSim900(const char pin){
	digitalWrite(pin,1);
	_delay_ms(1000);
	digitalWrite(pin,0);
	_delay_ms(4000);

}
void espPower(const char pin, const char status){
	digitalWrite(pin,status);
}
void delay(int ms){
	while (0 < ms)
	{
		_delay_ms(1);
		--ms;
	}
}

 

void pinMode(const int pin, const char mode){
	switch (pin){
		case 12: if (mode==1){DDRD|=(1<<3);}else{DDRD&=~(1<<3);} break;
		case 14: if (mode==1){DDRD|=(1<<5);}else{DDRD&=~(1<<5);} break;
		case 16: if (mode==1){DDRD|=(1<<7);}else{DDRD&=~(1<<7);} break;
		case 19: if (mode==1){DDRC|=(1<<0);}else{DDRC&=~(1<<0);} break;
		case 20: if (mode==1){DDRC|=(1<<1);}else{DDRC&=~(1<<1);} break;
		case 22: if (mode==1){DDRC|=(1<<3);}else{DDRC&=~(1<<3);} break;
		case 24: if (mode==1){DDRC|=(1<<5);}else{DDRC&=~(1<<5);} break;
		case 25: if (mode==1){DDRC|=(1<<6);}else{DDRC&=~(1<<6);} break;
		case 26: if (mode==1){DDRC|=(1<<7);}else{DDRC&=~(1<<7);} break;
		case 33: if (mode==1){DDRA|=(1<<4);}else{DDRA&=~(1<<4);} break;
		case 34: if (mode==1){DDRA|=(1<<3);}else{DDRA&=~(1<<3);} break;
		case 37: if (mode==1){DDRA|=(1<<0);}else{DDRA&=~(1<<0);} break;
		case 40: if (mode==1){DDRB|=(1<<0);}else{DDRB&=~(1<<0);} break;
		case 41: if (mode==1){DDRB|=(1<<1);}else{DDRB&=~(1<<1);} break;
	}
}
void digitalWrite(const int pin, const char mode){
	switch (pin){
		case 12: if(mode==1){PORTD|=(1<<3);}else{PORTD&=~(1<<3);}break;
		case 14: if(mode==1){PORTD|=(1<<5);}else{PORTD&=~(1<<5);}break;
		case 16: if(mode==1){PORTD|=(1<<7);}else{PORTD&=~(1<<7);}break;
		case 19: if(mode==1){PORTC|=(1<<0);}else{PORTC&=~(1<<0);}break;
		case 20: if(mode==1){PORTC|=(1<<1);}else{PORTC&=~(1<<1);}break;
		case 22: if(mode==1){PORTC|=(1<<3);}else{PORTC&=~(1<<3);}break;
		case 24: if(mode==1){PORTC|=(1<<5);}else{PORTC&=~(1<<5);}break;
		case 25: if(mode==1){PORTC|=(1<<6);}else{PORTC&=~(1<<6);}break;
		case 26: if(mode==1){PORTC|=(1<<7);}else{PORTC&=~(1<<7);}break;
		case 33: if(mode==1){PORTA|=(1<<4);}else{PORTA&=~(1<<4);}break;
		case 40: if(mode==1){PORTB|=(1<<0);}else{PORTB&=~(1<<0);}break;
		case 41: if(mode==1){PORTB|=(1<<1);}else{PORTB&=~(1<<1);}break;
	}
}
char digitalRead(const int pin){
	switch (pin) {
		case 24: return PINC & (1<<5); break;
		case 26: return PINC & (1<<7); break;
		case 33: return PINA & (1<<4); break;
		case 34: return PINA & (1<<3); break;
		case 37: return PINA & (1<<0); break;
	}
	return 0;
}

void setSource(const int source){

	if (HAS_ESP && source == ESP){
		__system_var.interface_ = ESP;
		} else if (HAS_SIM && source == SIM){
		__system_var.interface_ = SIM;
		} else {
		__system_var.interface_ = -1;
	}
}
void defaultSettings() {

	int i;
	__system_time.interrupt_flag = 0;
	__system_time._year = 0;
	__system_time._month = 0;
	__system_time._day = 0;
	__system_time._hour = 0;
	__system_time._min = 0;
	__system_time._sec = 0;
	__system_time._mils = 0;
	
	for (i=0;i<4;i++){
		__system_var.relay_modules[i] = 0;
		__system_var.module_connected[i] = 0;
		__system_var.module_flags[i] = 0;
	}
	
	for (i=0;i<5;i++){
		__system_var.relay_states[i] = 0;
	}
	for (i=0;i<3;i++){
		__system_var.opto_states[i] = 0;
	}
	
	setSource(ESP);
	__system_var.timer0_overflow = 0;
	__system_var.eeprom_position = 0;

	strcpy(__network_data.host, NETWORK_HOST);
	strcpy(__network_data.port, NETWORK_PORT);
	strcpy(__network_data.ssid, NETWORK_SSID);
	strcpy(__network_data.password, NETWORK_PASSW);
	strcpy(__network_data.apn, NETWORK_APN);

	__network_data.is_esp_connected = FALSE;
	__network_data.is_sim_connected = FALSE;
	__network_data.is_server_connected = FALSE;
	__network_data.network_available = FALSE;
	__network_data.sms_income = 1;
	//strcpy(__network_data.admin,"+36309225427");
	//strcpy(__network_data.phone_buffer,"+36309225427");


	memset(__network_data.esp_buffer, 0, sizeof(__network_data.esp_buffer));
	memset(__network_data.sim_buffer, 0, sizeof(__network_data.sim_buffer));
	
	__network_data.is_esp_read_line = FALSE;
	__network_data.is_sim_read_line = FALSE;
	__network_data.index_esp = 0;
	__network_data.index_sim = 0;

	__system_time.connection_timer_buffer = 0;;
	__system_time.connection_timer = 180;
	__system_time.check_timer_buffer = 0;
	__system_time.check_timer = 30; 

	strcpy(__system_var.serial_number,"null");
	memset(__system_var.admin_user, 0, sizeof(__system_var.admin_user));
	
	if (eepromReadAttribute(__system_var.serial_number,sizeof(__system_var.serial_number),"SERIAL",1) == 0){
		strcpy(__system_var.serial_number,"null");	
	}

}
void readNetworkSettings() {
	
	int i, j = 0;
	char dat, flag = 0, buffer[100];
	for (i = 0; i < EEPROM_SIZE; i++) {
		
		while(!eeprom_is_ready());
		dat = eeprom_read_byte((uint8_t*)i);

		if (dat == '#') {
			flag = !flag;
		}

		if (flag == 1) {
			if (dat != '#') {
				buffer[j++] = dat;
			}
			} else {
			if (j > 0) {
				char *p1;
				buffer[j] = '\0';

				p1 = strtok(buffer, ":");

				if (strstr(p1, "NS") != 0) {

					p1 = strtok(0, ";");
					strcpy(__network_data.host, p1);
					//printf("host:%s\n",p1);

					p1 = strtok(0, ";");
					strcpy(__network_data.port, p1);
					//printf("port:%s\n",p1);

					p1 = strtok(0, ";");
					strcpy(__network_data.ssid, p1);
					//printf("ssid:%s\n",p1);

					p1 = strtok(0, ";");
					strcpy(__network_data.password, p1);
					//printf("password:%s\n",p1);

					p1 = strtok(0, ";");
					strcpy(__network_data.apn, p1);
					//printf("apn:%s\n\n",p1);
				}
				j = 0;

			}
		}
	}
}
void clearReadLine() {

	if (__system_var.interface_ == ESP) {
		memset(__network_data.esp_buffer, ' ', sizeof(__network_data.esp_buffer) - 1);
		__network_data.is_esp_read_line = 0;
		__network_data.index_esp = 0;
	}
	if (__system_var.interface_ == SIM) {
		memset(__network_data.sim_buffer, ' ', sizeof(__network_data.sim_buffer) - 1);
		__network_data.is_sim_read_line = 0;
		__network_data.index_sim = 0;
	}
}

void initTimer(){
	// Setting no prescaler
	TCCR0B |= (1 << CS00);
	// Initialize Timer0
	TCNT0 = 0;
	// Initialize the overflow interrupt for TIMER0
	TIMSK0 |= (1 << TOIE0);
}
void powerUpModules(){
	setSource(ESP);
	USART0_SendString("AT\r\n");
	
	//if (readUntil("OK",3) == 0){
		turnOnSim900(SIM_PWR);
	//}
}
void atmegaSetup(){
	pinMode(ESP_PWR,OUTPUT);
	pinMode(SIM_PWR,OUTPUT);
	pinMode(RELAY_1,OUTPUT);
	pinMode(RELAY_2,OUTPUT);
	pinMode(RELAY_3,OUTPUT);
	pinMode(RELAY_4,OUTPUT);
	pinMode(RELAY_5,OUTPUT);
	
	pinMode(OPTO_1,INPUT);
	pinMode(OPTO_2,INPUT);
	pinMode(OPTO_3,INPUT);
	
	

}

void getAdminFromEEPROM(){
	int i=0;
	char phoneBuffer[13];
	for (i=0;i<12;i++){
		phoneBuffer[i] = eeprom_read_byte((uint8_t*)i);
	}
	phoneBuffer[12] = '\0';
	if (phoneBuffer[0] == '+'){
		strcpy(__network_data.admin,phoneBuffer);
	}
	__network_data.admin[12] = '\0';
	
}

void processRelayStates(){
	
	
	if (eeprom_read_byte((uint8_t*)20) == 1){
		digitalWrite(RELAY_1,1);
		} else {
		digitalWrite(RELAY_1,0);
		__system_var.relay_states[0] = 0;
	}
	if (eeprom_read_byte((uint8_t*)21) == 1){
		digitalWrite(RELAY_2,1);
		} else {
		digitalWrite(RELAY_2,0);
		__system_var.relay_states[1] = 0;
	}
	if (eeprom_read_byte((uint8_t*)22) == 1){
		digitalWrite(RELAY_3,1);
		} else {
		digitalWrite(RELAY_3,0);
		__system_var.relay_states[2] = 0;
	}
	if (eeprom_read_byte((uint8_t*)23) == 1){
		digitalWrite(RELAY_4,1);
		} else {
		digitalWrite(RELAY_4,0);
		__system_var.relay_states[3] = 0;
	}
	if (eeprom_read_byte((uint8_t*)24) == 1){
		digitalWrite(RELAY_5,1);
		} else {
		digitalWrite(RELAY_5,0);
		__system_var.relay_states[4] = 0;
	}
}

void setup(){
	
	atmegaSetup();
	
	processRelayStates();
	
	powerUpModules();
	
	delay(500);
	
	USART_Init();
	delay(100);
	
	defaultSettings();
	
	getAdminFromEEPROM();
	
	initTimer();
	
}

