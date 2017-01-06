#line 1 "C:/Users/Nils/Desktop/PIC/home_control/home_control.c"
#line 16 "C:/Users/Nils/Desktop/PIC/home_control/home_control.c"
void setLedRed(char pos);
void setLedGreen(char pos);
void setLedOrange(char pos);

const char NETWORK_SSID[] = "Tardis";
const char NETWORK_PASSW[] = "77Ld7cr7dW";
const char NETWORK_HOST[] = "192.168.0.5";
const char NETWORK_PORT[] = "85";
const char NETWORK_APN[] = "online";


const char NETWORK_CONNECTED = 1;
const char NETWORK_NOT_CONNECTED = 0;
const char WIFI_CONNECTED = 1;
const char WIFI_NOT_CONNECTED = 0;
const char EEPROM_SIZE = 1024;
const char RELAY_SIZE = 9;

const char TRUE = 1;
const char FALSE = 0;
const char WIFI = 1;
const char GPRS = 0;
const int DAYS_OF_MONTH[12] = {31,28,31,30,31,30,31,31,30,31,30,31};

const int EEPROM_ADMIN_START = 0;
const int EEPROM_ADMIN_END = 20;
const int EEPROM_USER_START = 20;
const int EEPROM_USER_END = 840;
const int EEPROM_RELAY_START = 840;
const int EEPROM_RELAY_END = 1024;

typedef struct {
 char host[30];
 char port[5];
 char ssid[20];
 char password[20];

 char apn[10];

 char wifi_status;
 char network_status;

 char isWifiConnected;
 char isGprsConnected;
 char isServerConnected;

 char wifi_readLine[100];
 char gprs_readLine[200];
 char isWifiInputReady;
 char isGprsInputReady;
 int index_1;
 int index_2;

} NETWORK;

typedef struct {

 int connection_timer_buffer;
 int connection_timer;

} TIMERS;

typedef struct {
 char state;
 int start_timer;
 int end_timer;
 int delay;
} RELAY;

typedef struct {

 int year;
 int month;
 int day;
 int hour;
 int min;
 int sec;
 int mils;

} SYSTIME;

typedef struct {
 char manufacturer_number[10];
 char admin_user[12];
} SYS;

NETWORK Network_data;
TIMERS Timer;
SYS System;
SYSTIME SystemTime;
RELAY relays[9];


char read_single_byte(char interface){
 if (interface == WIFI){
 return UART1_Read();
 }
 if (interface == GPRS) {
 return UART2_Read();
 }
}

char is_data_ready(char interface){
 if (interface == WIFI){
 return Uart1_Data_Ready();
 }
 if (interface == GPRS){
 return Uart2_Data_Ready();
 }
}


void clear_read_line(char interface){
 int i;

 if (interface == WIFI){
 for (i=0;i<sizeof(network_data.wifi_readLine)-2;i++){
 network_data.wifi_readLine[i] = 'a';
 }
 strcpy(network_data.wifi_readLine,"");
 network_data.isWifiInputReady = 0;
 network_data.index_1 = 0;
 }
 if (interface == GPRS){
 for (i=0;i<sizeof(network_data.gprs_readLine)-2;i++){
 network_data.gprs_readLine[i] = 'a';
 }
 strcpy(network_data.gprs_readLine,"");
 network_data.isGprsInputReady = 0;
 network_data.index_2 = 0;
 }
}


int wait_for_input(char *input, int timeout, char interface){

int i = 0;int mils = 0;
char buffer[30];
memset(buffer,'\0',sizeof(buffer)-1);
INTCON.GIE = 0;

while (mils <= timeout*1000){
 if (is_data_ready(interface)){
 if (i == 30) i = 0;
 buffer[i++] = read_single_byte(interface);
 if (strstr(buffer,input) != 0){
 INTCON.GIE = 1;
 return 1;
 }
 } else {
 mils++;
 delay_ms(1);
 }
}
INTCON.GIE = 1;

return 0;
}


char * itoa(int i, char b[]){
 char const digit[] = "0123456789";
 char* p = b;
 int shifter;
 if(i<0){
 *p++ = '-';
 i *= -1;
 }
 shifter = i;
 do{
 ++p;
 shifter = shifter/10;
 }while(shifter);
 *p = '\0';
 do{
 *--p = digit[i%10];
 i = i/10;
 }while(i);
 return b;
}

void cipsend(char *p, char interface){
 char conv[5];

 if (interface == WIFI){
 int size=0;
 char *b = p;
 for (;*b++ != '\0';size++) ;

 UART1_Write_Text("AT+CIPSEND=0,");
 UART1_Write_Text(itoa(size,conv));
 UART1_Write_Text("\r\n");
 } else {
 UART2_Write_Text("AT+CIPSEND\r");
 }

 if (wait_for_input(">",2,interface) == 0){
 network_data.network_status = NETWORK_NOT_CONNECTED;
 network_data.isWifiConnected = FALSE;
 network_data.isGprsConnected = FALSE;
 }

 if (interface == WIFI){
 UART1_Write_Text(p);
 } else {
 UART2_Write_Text(p);
 UART2_Write(26);
 UART2_Write(0x0D);
 }


}





void set_admin(char *phone_number){
 int i;
 char to_write[15];
 strcpy(to_write,"#");
 strcat(to_write,phone_number);
 strcat(to_write,"#");

 for (i=0;i<strlen(to_write);i++){
 EEPROM_Write(i,to_write[i]);
 }
}

char *get_admin(char *phone_number){
 int i,j=0;
 char dat, flag = 0;
 char *p1 = phone_number;
 for (i=0;i<20;i++){

 if (dat == '#'){
 flag=!flag;
 }
 dat = EEPROM_READ(i);

 if (flag == 1){
 if (dat != '#'){
 *phone_number++ = dat;
 j++;
 }
 } else {
 if (j > 0){
 *phone_number = '\0';
 return p1;
 }
 }
 }
 return 0;
}
int verify_relay_access(char *phone_number, int relay, char isCall ){
 int i,j=0,flag=0;
 char read[27], dat;
 for (i=EEPROM_RELAY_START;i<EEPROM_RELAY_END;i++){

 dat = EEPROM_READ(i);
 if (dat == '#'){
 flag=!flag;
 }

 if (flag == 1){
 read[j++] = dat;
 } else {
 if (j > 0){
 read[j++] = '#';
 read[j] = '\0';

 if ( strstr(read,phone_number) != 0 ){
 char *p1, config[10];
 p1 = strtok(read,";");
 p1 = strtok(0,";");
 strcpy(config,p1);

 if (isCall){
 int rel = atoi(strtok(0,"#"));
 if (config[rel] == '1')
 return rel;
 else
 return 0;
 }
 return config[relay] - '0';
 } else {
 j = 0;
 memset(read," ",sizeof(read)-1);
 }
 }
 }
 }
 return FALSE;
}

void build_user_config_string(char *buffer, char *relay_access, char *relay_call){
 char *p1;
 int size = 0,i;
 p1 = relay_access;
 for (;*p1++ != '\0';size++);
 if (size > 9) size = 9;

 *buffer++ = ';';

 for (i=0;i<size;i++){
 char ch = *relay_access++;
 if (ch == '0' || ch == '1'){
 *buffer++ = ch;
 } else {
 *buffer++ = '0';
 }
 }
 for (i=size;i<9;i++){
 *buffer++ = '0';
 }
 *buffer++ = ';';
 if (atoi(relay_call) <= 9 && atoi(relay_call) != 0){
 *buffer++ = *relay_call;
 } else {
 *buffer++ = '0';
 }
 *buffer = '#';
}

char add_user(char *phone_number, char *relay_access, char *relay_call){
 int i,j=0,flag=0;
 char to_write[27];
 unsigned char dat;
 for (i=EEPROM_USER_START;i<EEPROM_USER_END;i++){

 dat = EEPROM_READ(i);
 if (dat == '#'){
 flag=!flag;
 }

 if (flag == 1){
 to_write[j++] = dat;
 } else {
 if (j > 0){
 if ( strstr(to_write,phone_number) != 0 ){
 return FALSE;
 } else {
 j = 0;
 memset(to_write," ",sizeof(to_write)-1);
 }
 }
 }

 if (dat == 254){
 char *cfg, buffer[14];
 int k;
 build_user_config_string(buffer, relay_access, relay_call);

 strcpy(to_write,"#");
 strcat(to_write,phone_number);
 strcat(to_write,buffer);

 if (i < EEPROM_USER_END-strlen(to_write)){
 for (k=0;k<strlen(to_write);k++){
 EEPROM_Write(i++,to_write[k]);
 }
 return TRUE;
 }

 }
 }
 return FALSE;
}

int remove_user(char *phone_number){
 int i,j=0,flag=0;
 char read[27];
 unsigned char dat;
 for (i=EEPROM_USER_START;i<EEPROM_USER_END;i++){

 dat = EEPROM_READ(i);
 if (dat == '#'){
 flag=!flag;
 }

 if (flag == 1){
 read[j++] = dat;
 } else {
 if (j > 0){
 read[j++] = '#';
 read[j] = '\0';

 if ( strstr(read,phone_number) != 0 ){
 int k;
 for (k=i-strlen(read)+1;k<=i;k++){
 EEPROM_Write(k,254);
 }
 return TRUE;
 } else {
 j = 0;
 memset(read," ",sizeof(read)-1);
 }
 }
 }

 if (dat == 254){
 return FALSE;
 }
 }
 return FALSE;
}


void read_relay_config(){
 int i,j=0,pos=0;
 char dat, flag = 0, buffer[20];
 for (i=EEPROM_RELAY_START;i<EEPROM_RELAY_END;i++){


 if (dat == '#'){
 flag=!flag;
 }
 dat = EEPROM_READ(i);

 if (flag == 1){
 if (dat != '#'){
 buffer[j++] = dat;
 }
 } else {
 if (j > 0){
 char *p1;
 buffer[j] = '\0';

 p1 = strtok(buffer,";");
 relays[pos].start_timer = atoi(p1);
 p1 = strtok(0,";");
 relays[pos].end_timer = atoi(p1);
 p1 = strtok(0,";");
 relays[pos].delay = atoi(p1);

 pos++;
 j=0;

 }
 }
 }
}

save_relay_config(){

int i,j=0,pos=0,index=EEPROM_RELAY_START;
 char dat, convert[5], buffer[20];
 for (i=EEPROM_RELAY_START;i<EEPROM_RELAY_END;i++){
 EEPROM_Write(i,254);
 }

 for (i=0;i<9;i++){
 strcpy(buffer,"#");
 itoa(relays[i].start_timer,convert);
 strcat(buffer,convert);
 strcat(buffer,";");
 itoa(relays[i].end_timer,convert);
 strcat(buffer,convert);
 strcat(buffer,";");
 itoa(relays[i].delay,convert);
 strcat(buffer,convert);
 strcat(buffer,"#");

 for (j=0;j<strlen(buffer);j++,index++){
 EEPROM_Write(index,buffer[j]);
 }
 }

}

void process_wifi_io(){

}

void process_gprs_io(){

}

void process_gsm_io(){

}

void process_io(){

 if (network_data.isServerConnected){

 if (network_data.isWifiConnected && network_data.isWifiInputReady){
 process_wifi_io();
 network_data.isWifiInputReady = FALSE;
 clear_read_line(WIFI);
 }

 if (network_data.isGprsConnected && network_data.isGPRSInputReady){
 process_gprs_io();
 network_data.isGprsInputReady = FALSE;
 clear_read_line(GPRS);
 }
 }
 process_gsm_io();
}



void set_identifier(char interface){

 if (strstr(network_data.wifi_readLine,"SETID") != 0){
 char *p;
 short i;
 p = strtok(network_data.wifi_readLine,";");
 p = strtok(0,";");

 strcpy(System.manufacturer_number,p);
 p=0;
#line 535 "C:/Users/Nils/Desktop/PIC/home_control/home_control.c"
 cipsend("ID OK\n", interface);
 wait_for_input("OK",2, interface);

 clear_read_line(interface);
 }
}

void get_system_time(char interface){
 char *p;
 short i = 0;
 clear_read_line(interface);


 cipsend("GETTIME\n",interface);
 wait_for_input("TIME",15, interface);
 delay_ms(300);


 p = strtok(network_data.wifi_readLine,";");
 while (p != 0){
 switch (i){
 case 1: SystemTime.year = atoi(p); break;
 case 2: SystemTime.month = atoi(p); break;
 case 3: SystemTime.day = atoi(p); break;
 case 4: SystemTime.hour = atoi(p); break;
 case 5: SystemTime.min = atoi(p); break;
 case 6: SystemTime.sec = atoi(p); break;
 }
 i++;
 p = strtok(0,";");
 }

 cipsend("TIME OK\n",interface);
 wait_for_input("OK",2, interface);

 clear_read_line(interface);
}

void get_identifier(char interface){

 if (strstr(System.manufacturer_number,"null") != 0){
 clear_read_line(interface);

 cipsend("GETID\n",interface);

 wait_for_input("IPD",15,interface);
 delay_ms(300);
 set_identifier(interface);

 }else {
 char buffer[15];
 strcpy(buffer,"ID;");
 strcat(buffer,System.manufacturer_number);
 strcat(buffer,";\n");

 cipsend(buffer,interface);
 wait_for_input("OK",2,interface);
 }
 get_system_time(interface);
}

char connect_to_wifi(){

 UART1_Write_Text("AT+SLEEP=2\r\n");
 wait_for_input("OK",3,WIFI);

 UART1_Write_Text("AT+CWMODE=1\r\n");
 wait_for_input("OK",3,WIFI);
 UART1_Write_Text("AT+CWJAP=\"");
 UART1_Write_Text(network_data.ssid);
 UART1_Write_Text("\",\"");
 UART1_Write_Text(network_data.password);
 UART1_Write_Text("\"\r\n");
 if (wait_for_input("OK",10,WIFI)){
 return TRUE;
 } else {
 return FALSE;
 }
}

char connect_to_gprs(){

 char conv[5];

 UART2_Write_Text("AT+CIPSHUT\r");
 wait_for_input("OK",10,GPRS);

 UART2_Write_Text("AT+CGATT=1\r");
 wait_for_input("OK",10,GPRS);

 UART2_Write_Text("AT+CGDCONT=1,\"IP\",\"");
 UART2_Write_Text(network_data.apn);
 UART2_Write_Text("\"\r");
 wait_for_input("OK",10,GPRS);

 UART2_Write_Text("AT+CSTT=\"");
 UART2_Write_Text(network_data.apn);
 UART2_Write_Text("\",\"\",\"\"\r");
 wait_for_input("OK",10,GPRS);

 UART2_Write_Text("AT+CIICR\r\n");

 if (wait_for_input("OK",10,GPRS)){
 return TRUE;
 } else {
 return FALSE;
 }



}

char connect_to_server(char interface){

 char conv[5];

 if (interface == WIFI){

 UART1_Write_Text("AT+CIPMUX=1\r\n");
 wait_for_input("OK",2,interface);
 }


 clear_read_line(interface);

 if (interface == WIFI){
 UART1_Write_Text("AT+CIPSTART=0,\"TCP\",\"");
 UART1_Write_Text(network_data.host);
 UART1_Write_Text("\",");
 UART1_Write_Text(itoa(network_data.port,conv));
 UART1_Write_Text("\r\n");
 }
 if (interface == GPRS){
 UART1_Write_Text("AT+CIPSTART=\"TCP\",\"");
 UART1_Write_Text(network_data.host);
 UART1_Write_Text("\",\"");
 UART1_Write_Text(itoa(network_data.port,conv));
 UART1_Write_Text("\"\r");
 }

 if (wait_for_input("OK",10,interface) == 1){

 network_data.isServerConnected = TRUE;

 get_identifier(interface);
 return TRUE;

 } else {

 network_data.isServerConnected = FALSE;
 return FALSE;
 }

}

void networking(){

 if (Timer.connection_timer_buffer >= Timer.connection_timer){

 if ( network_data.network_status != NETWORK_CONNECTED ){

 network_data.isWifiConnected = connect_to_wifi();

 if (!network_data.isWifiConnected){
 network_data.isGprsConnected = connect_to_gprs();
 }

 if (network_data.isWifiConnected){
 connect_to_server(WIFI);
 }
 if (network_data.isGprsConnected){
 connect_to_server(GPRS);
 }

 if (!network_data.isGprsConnected && !network_data.isWifiConnected){
 if (Timer.connection_timer <= 600) Timer.connection_timer += 20;
 }

 }
 Timer.connection_timer_buffer = 0;
 }
}

void wifi_serial_interrupt(){

 if (PIR1.RCIF ) {

 if (network_data.index_1 >= sizeof(network_data.wifi_readLine)-3){

 network_data.index_1 = 0;
 }

 network_data.wifi_readLine[network_data.index_1] = UART1_Read();

 if (network_data.wifi_readLine[network_data.index_1] == '\n' ||
 network_data.wifi_readLine[network_data.index_1] == '\0' ||
 network_data.wifi_readLine[network_data.index_1] == '\r' ) {

 network_data.isWifiInputReady = TRUE;
 network_data.wifi_readLine[network_data.index_1+1] = '\0';
 }

 network_data.index_1++;
 }
}

void gprs_serial_interrupt(){
 if (PIR2.RCIF){

 if (network_data.index_2 >= sizeof(network_data.gprs_readLine)-3){

 network_data.index_2 = 0;
 }

 network_data.gprs_readLine[network_data.index_2] = UART1_Read();

 if (network_data.gprs_readLine[network_data.index_2] == '\n' ||
 network_data.gprs_readLine[network_data.index_2] == '\0' ||
 network_data.gprs_readLine[network_data.index_2] == '\r' ) {

 network_data.isGprsInputReady = TRUE;
 network_data.gprs_readLine[network_data.index_2+1] = '\0';
 }

 network_data.index_2++;
 }
}

void system_clock(){

 SystemTime.mils++;



 if (SystemTime.mils == 1000){
 SystemTime.sec++;
 SystemTime.mils = 0;
 if (Timer.connection_timer_buffer <= Timer.connection_timer){
 Timer.connection_timer_buffer++;
 }
 }
 if (SystemTime.sec == 60){
 SystemTime.min++;
 SystemTime.sec = 0;
 }
 if (SystemTime.min == 60){
 SystemTime.hour++;
 SystemTime.min = 0;
 }
 if (SystemTime.hour == 24){
 SystemTime.day++;
 SystemTime.hour = 0;
 }
if (SystemTime.day == DAYS_OF_MONTH[SystemTime.month]){
 SystemTime.month++;
 SystemTime.day = 0;
 }
 if (SystemTime.month == 12){
 SystemTime.year++;
 SystemTime.month = 0;
 }

}

void Interrupt(){


 wifi_serial_interrupt();
 gprs_serial_interrupt();


 if (TMR0IF_bit){
 TMR0IF_bit = 0;
 TMR0H = 0xF6;
 TMR0L = 0x3C;

 system_clock();

 }
}



void init_timer(){
 T0CON = 0x88;
 TMR0H = 0xF6;
 TMR0L = 0x3C;
 GIE_bit = 1;
 TMR0IE_bit = 1;
}

void setup_pic(){
 TRISA = 0b00000001;
 TRISB = 0b00000000;
 TRISC = 0b00000000;
 TRISD = 0b00000000;

 PORTA = 0b00000000;
 PORTB = 0b00000000;
 PORTC = 0b00000000;
 PORTD = 0b00000000;


 ANCON0 = 0b00000000;
 ANCON1 = 0b00000000;

 delay_ms(1000);



 UART1_Init(9600);
 delay_ms(100);
 UART2_Init(9600);
 delay_ms(1000);
 UART1_Write_Text("AT\r\n");
 delay_ms(500);


 delay_ms(250);

 INTCON.GIE = 1;
 INTCON.PEIE = 1;
 PIE1.RCIE = 1;

}

void default_config(){
 int i;
 for (i=0;i<RELAY_SIZE;i++){
 relays[i].state = 0;
 relays[i].start_timer = 0;
 relays[i].end_timer = 0;
 relays[i].delay = 0;
 }

 SystemTime.year = 0;
 SystemTime.month = 0;
 SystemTime.day = 0;
 SystemTime.hour = 0;
 SystemTime.min = 0;
 SystemTime.sec = 0;
 SystemTime.mils = 0;

 Network_data.host[30] = NETWORK_HOST;
 Network_data.port[5] = NETWORK_PORT;
 Network_data.ssid[20] = NETWORK_SSID;
 Network_data.password[20] = NETWORK_PASSW;
 Network_data.apn[10] = NETWORK_APN;

 Network_data.wifi_status = WIFI_NOT_CONNECTED;
 Network_data.network_status = NETWORK_NOT_CONNECTED;

 Network_data.isWifiConnected = FALSE;
 Network_data.isGprsConnected = FALSE;
 Network_data.isServerConnected = FALSE;

 memset(Network_data.wifi_readLine,'\0',sizeof(Network_data.wifi_readline));
 memset(Network_data.gprs_readLine,'\0',sizeof(Network_data.gprs_readline));
 Network_data.isWifiInputReady = FALSE;
 Network_data.isGprsInputReady = FALSE;
 Network_data.index_1 = 0;
 Network_data.index_2 = 0;

 Timer.connection_timer_buffer = 0;;
 Timer.connection_timer = 0;

 memset(System.manufacturer_number,'\0',sizeof(System.manufacturer_number));
 memset(System.admin_user,'\0',sizeof(System.admin_user));

}

void read_config(){

}

void setup(){

 setup_pic();




}

void main() {

 setup();

 while (1){

 PORTB = 0b11111111;
 PORTC = 0b11111111;
 PORTD = 0b11111111;
 PORTA = 0b11111111;
 delay_ms(500);
 PORTB = 0;
 PORTC = 0;
 PORTD = 0;
 PORTA = 0;
 delay_ms(500);






 }

}
