/*
* Utils.cpp
*
* Created: 2016.09.24. 13:42:31
*  Author: tjozsa
*/
#include <Utils.h>
#include <HCM.h>

#define UART0 0
#define UART1 1

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
	int i=0;
	
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
	int i=0;
	
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

void WIFI_Write_String(const char s[]){
	if (WIFI_DIRECTION == UART0){
		USART0_SendString(s);
	} 
	if (WIFI_DIRECTION == UART1){
		USART1_SendString(s);
	}
}

void GSM_Write_String(const char s[]){
	if (GSM_DIRECTION == UART0){
		USART0_SendString(s);
	}
	if (GSM_DIRECTION == UART1){
		USART1_SendString(s);
	}
}

void WIFI_Write_Byte(const char c){
	if (WIFI_DIRECTION == UART0){
		USART0_SendByte(c);
	}
	if (WIFI_DIRECTION == UART1){
		USART1_SendByte(c);
	}
}

void GSM_Write_Byte(const char c){
	if (GSM_DIRECTION == UART0){
		USART0_SendByte(c);
	}
	if (GSM_DIRECTION == UART1){
		USART1_SendByte(c);
	}
}

void turnOnSim900(){
	digitalWrite(SIM_PWR,1);
	_delay_ms(1000);
	digitalWrite(SIM_PWR,0);

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
		case 1: if (mode==1){DDRB|=(1<<5);}else{DDRB&=~(1<<5);} break;
		case 2: if (mode==1){DDRB|=(1<<6);}else{DDRB&=~(1<<6);} break;
		case 3: if (mode==1){DDRB|=(1<<7);}else{DDRB&=~(1<<7);} break;
		case 13: if (mode==1){DDRD|=(1<<4);}else{DDRD&=~(1<<4);} break;
		case 14: if (mode==1){DDRD|=(1<<5);}else{DDRD&=~(1<<5);} break;
		case 15: if (mode==1){DDRD|=(1<<6);}else{DDRD&=~(1<<6);} break;
		case 16: if (mode==1){DDRD|=(1<<7);}else{DDRD&=~(1<<7);} break;
		case 21: if (mode==1){DDRC|=(1<<2);}else{DDRC&=~(1<<2);} break;
		case 22: if (mode==1){DDRC|=(1<<3);}else{DDRC&=~(1<<3);} break;
		case 23: if (mode==1){DDRC|=(1<<4);}else{DDRC&=~(1<<4);} break;
		case 24: if (mode==1){DDRC|=(1<<5);}else{DDRC&=~(1<<5);} break;
		case 40: if (mode==1){DDRB|=(1<<0);}else{DDRB&=~(1<<0);} break;
		case 41: if (mode==1){DDRB|=(1<<1);}else{DDRB&=~(1<<1);} break;
		case 42: if (mode==1){DDRB|=(1<<2);}else{DDRB&=~(1<<2);} break;
		case 43: if (mode==1){DDRB|=(1<<3);}else{DDRB&=~(1<<3);} break;
		case 44: if (mode==1){DDRB|=(1<<4);}else{DDRB&=~(1<<4);} break;
	}
}
void digitalWrite(const int pin, const char mode){
	switch (pin){
		case 13: if(mode==1){PORTD|=(1<<4);}else{PORTD&=~(1<<4);}break;
		case 14: if(mode==1){PORTD|=(1<<5);}else{PORTD&=~(1<<5);}break;
		case 15: if(mode==1){PORTD|=(1<<6);}else{PORTD&=~(1<<6);}break;
		case 16: if(mode==1){PORTD|=(1<<7);}else{PORTD&=~(1<<7);}break;
		case 40: if(mode==1){PORTB|=(1<<0);}else{PORTB&=~(1<<0);}break;
		case 41: if(mode==1){PORTB|=(1<<1);}else{PORTB&=~(1<<1);}break;
		case 42: if(mode==1){PORTB|=(1<<2);}else{PORTB&=~(1<<2);}break;
	}
}
char digitalRead(const int pin){
	switch (pin) {
		case 21: return PINC & (1<<2); break;
		case 22: return PINC & (1<<3); break;
		case 23: return PINC & (1<<4); break;
		case 24: return PINC & (1<<5); break;
		case 43: return PINB & (1<<3); break;
	}
	return 0;
}

void setSource(const int source){

	if (HAS_WIFI && source == ESP){
		__system_var.interface_ = ESP;
		} else if (HAS_GSM && source == SIM){
		__system_var.interface_ = SIM;
		} else {
		__system_var.interface_ = -1;
	}
}
void defaultSettings() {

	int i,j;
	
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
	
	for (i=0;i<MAX_MODULE_COUNT;i++){
		for (j=0;j<MAX_RELAY_COUNT;j++){
			__relay_states[i].states[j] = 0;
		}
	}

	__system_var.update_flag = 0;
	__system_var.detect_pins[0] = DETECT_0;
	__system_var.detect_pins[1] = DETECT_1;
	__system_var.detect_pins[2] = DETECT_2;
	__system_var.detect_pins[3] = DETECT_3;
	
	__system_var.timer0_overflow = 0;
	__system_var.eeprom_position = 0;
	__system_var.enabled_flag = 1;

	strcpy(__network_data.host, NETWORK_HOST);
	strcpy(__network_data.port, NETWORK_PORT);

	__network_data.is_esp_connected = FALSE;
	__network_data.is_sim_connected = FALSE;
	__network_data.is_server_connected = FALSE;

	memset(__network_data.esp_buffer, 0, sizeof(__network_data.esp_buffer));
	memset(__network_data.sim_buffer, 0, sizeof(__network_data.sim_buffer));
	
	__network_data.is_esp_read_line = FALSE;
	__network_data.is_sim_read_line = FALSE;
	__network_data.index_esp = 0;
	__network_data.index_sim = 0;

	// For reconnecting to the server/network
	__system_time.connection_timer_buffer = 0;;
	__system_time.connection_timer = 10;
	
	// Check server availability
	__system_time.check_timer_buffer = 0;
	__system_time.check_timer = 30; 
	
	// Check relay module connections
	__system_time.relay_module_check_timer_buffer = 0;
	__system_time.relay_module_check_timer = 5;
	
	// For Timers
	__system_time.timer_check_timer_buffer = 0;
	__system_time.timer_check_timer = 30;
	
	// Check network/gsm availability
	__system_time.gsm_network_timer_buffer = 0;
	__system_time.gsm_network_timer = 180;
	

	strcpy(__system_var.serial_number,"null");
	memset(__system_var.admin_user, 0, sizeof(__system_var.admin_user));
	
	if (eepromReadAttribute(__system_var.serial_number,sizeof(__system_var.serial_number),"SERIAL",1) == 0){
		strcpy(__system_var.serial_number,"null");	
	}
	getAccessPointSetting();
	

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
		
	}
}
void clearWIFIBuffer(){
	memset(__network_data.esp_buffer, ' ', sizeof(__network_data.esp_buffer) - 1);
	__network_data.is_esp_read_line = 0;
	__network_data.index_esp = 0;
}
void clearGSMBuffer(){
	memset(__network_data.sim_buffer, ' ', sizeof(__network_data.sim_buffer) - 1);
	__network_data.is_sim_read_line = 0;
	__network_data.index_sim = 0;
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
	

	if (HAS_GSM){
		setSource(SIM);
		GSM_Write_String("AT\r\n");
		delay(500);
		if (strstr(__network_data.sim_buffer,"OK") == 0){
			//turnOnSim900();
			//delay(2000);
		}
		GSM_Write_String("AT+CMGF=1\r\n");
		delay(300);
		GSM_Write_String("AT+CLTS=1\r\n");
		delay(300);
		GSM_Write_String("AT+CLIP=1\r\n");
		delay(300);
	}
	
	if (HAS_WIFI){
		espPower(ESP_PWR,1);
		delay(500);
		espPower(ESP_PWR,0);
		delay(1000);
		setSource(ESP);
	}
	
}
void atmegaSetup(){
	if (HAS_WIFI){
		pinMode(ESP_PWR,OUTPUT);
	}
	if (HAS_GSM){
		pinMode(SIM_PWR,OUTPUT);
	}
		
	pinMode(CS_1,OUTPUT);
	pinMode(CS_2,OUTPUT);
	pinMode(CS_3,OUTPUT);
	pinMode(CS_4,OUTPUT);
	pinMode(DETECT_0,INPUT);
	pinMode(DETECT_1,INPUT);
	pinMode(DETECT_2,INPUT);
	pinMode(DETECT_3,INPUT);
	pinMode(SCK,OUTPUT);
	pinMode(MOSI,OUTPUT);
	pinMode(MISO,INPUT);
	pinMode(SS,OUTPUT);

	
	USART_Init();
	delay(100);	
	
	SPI_init_master();
}

void setup(){
	
	atmegaSetup();

	defaultSettings();

	initTimer();
	
	powerUpModules();
	
}

