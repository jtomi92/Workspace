/*
 * hw_utils.cpp
 *
 * Created: 1/14/2017 8:47:00 PM
 *  Author: tjozsa
 */ 
#include <hw_utils.h>
#include <global_include.h>

char bluetooth_buffer[100];
int bluetooth_buffer_index = 0;
char data_received = 0;

const int USART_BAUDRATE = 9600;
const int BAUD_PRESCALE = (((F_CPU / (USART_BAUDRATE * 16UL))) - 1);

const int INPUT = 0;
const int OUTPUT = 1;

void clear(){
	data_received = 0;
	memset(bluetooth_buffer,0,sizeof(bluetooth_buffer));
	bluetooth_buffer_index = 0;
}

ISR(USART0_RX_vect){
	char value = UDR0;             //read UART register into value
	if (bluetooth_buffer_index >= sizeof(bluetooth_buffer)-3){
		// To stop buffer from overfloating
		bluetooth_buffer_index = 0;
	}
	bluetooth_buffer[bluetooth_buffer_index++] = value;
	if (value == '\r' || value == '\n' || value == '\0'){
		data_received = 1;
		bluetooth_buffer[bluetooth_buffer_index] = '\0';
		
	}
}

void USART_Init(void){
	UBRR0L = BAUD_PRESCALE;
	UBRR0H = (BAUD_PRESCALE >> 8);
	UCSR0B = ((1<<TXEN0)|(1<<RXEN0) | (1<<RXCIE0));
	
	sei(); // enable global interrup flag
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

void setup(){
	DDRB|=_BV(ws2812_pin);
	USART_Init();
	_delay_ms(500);
}

void delay_ms(int ms){
	while (0 < ms)
	{
		_delay_ms(1);
		--ms;
	}
}

void delay_us(int us){
	while (0 < us)
	{
		_delay_us(1);
		--us;
	}
}