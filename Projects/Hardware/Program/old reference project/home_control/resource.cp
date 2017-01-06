#line 1 "C:/Users/Nils/Desktop/PIC/home_control/resource.c"
#line 18 "C:/Users/Nils/Desktop/PIC/home_control/resource.c"
sbit Soft_I2C_Scl at RB4_bit;
sbit Soft_I2C_Sda at RB5_bit;
sbit Soft_I2C_Scl_Direction at TRISB4_bit;
sbit Soft_I2C_Sda_Direction at TRISB5_bit;


sbit Mmc_Chip_Select at LATB3_bit;
sbit Mmc_Chip_Select_Direction at TRISB3_bit;

void Measure_MS8607();
float getTemperature();
float getHumidity();
float getPressure();



void Susart_Init(char Brg_reg);
void Susart_Write(char data_);
void Start_Bootload();
void Start_Program();
char Susart_Write_Loop(char send, char recieve);



short startBootLoad = 0;

typedef struct {
 int mils;
 int sec;
 int min;
 int hour;
 int day;
 int month;
 int year;
 int sec_3;
 int mils_2;
 int sec_2;
 int min_2;

 int dip_sw_mils;
 int dip_sw_sec;

} TIME;

typedef struct {

 short g_index;
 short battery_voltage;
 short battery_voltage_buffer[10];


 char readLine[150];
 char uart2_buffer[10];
 int index;
 int index_2;
 short wifi_status;
 short isInputReady;
 short isInput_2_Ready;
 short isCharging;
 char identifier[5];



 short network_status;
 int milisecondBuffer_2;
 int sec_flag;
 int min_flag;
 short isMicroSDConnected;
 char load_buffer[70];
 unsigned short size;
 int connection_timer;
 int connection_timer_buffer;
 short isADCEnabled;
 short PORTD_state;


 short measure_type;
 short connection_type;
 char ip_address[13];
 int tcp_port;
 char ssid[32];
 char password[32];
 short protocol;
 char host[64];


} CONFIG;

short index;

typedef struct {
 int R_enabled;
 int R_trig;
 int R_val;
 int R_relay;
 int R_tresh;
 int R_state;
 int R_start;
 int R_end;

 int R_current_state;
 int R_state_buffer;
 int R_val_buffer;

 short R_flag_1;
 short R_flag_2;

 int R_trs_1;
 int R_trs_2;
} REL;



typedef struct {

 int ADC_sec;
 int ADC_dur;
 int ADC_mil;

 double ADC_value;

 int port;



 int ADC_isPortConnected;

 int ADC_start_time;
 int ADC_end_time;

 int ADC_sec_buffer;
 int ADC_dur_buffer;
 int ADC_mil_buffer;

} ADC;








const short RELAY_SIZE = 6;
const short CHANNEL_COUNT = 8;
const short DEFAULT_PORT = 666;
const char DEFAULT_SSID[] = "Tardis";
const char DEFAULT_AP[] = "ESP-NETWORK";
const char DEFAULT_PW[] = "77Ld7cr7dW";
const char DEFAULT_HOST[] = "192.168.0.5";
const char DEFAULT_ENCRYPTION[] = "0";
const short DEBUG = 1;
const short BATTERY_PORT = 9;




const int DAYS_OF_MONTH[12] = {31,28,31,30,31,30,31,31,30,31,30,31};


const short TCP = 0;
const short UDP = 1;


const short WIFI_CONNECTED = 0;
const short WIFI_NOT_CONNECTED = 1;
const short WIFI_TURNED_OFF = 2;


const short CONNECTED = 0;
const short LISTENING = 1;
const short IDLE = 2;


const short BUFFERED = 0;
const short UPDATING = 1;


const short SERVER = 0;
const short CLIENT = 1;

const short FALSE = 0;
const short TRUE = 1;


const short SYS = 0;
const short ADC = 1;


const char DELAY_SHORT = 50;
const char DELAY_LONG = 200;


const int CONFIG_START_ADDRESS = 0x00;
const int ADC_START_ADDRESS = 0x00;
const int STATUS_START_ADDRESS = 0x00;


const short REBOOT_SYSTEM = 2;
const short RESET_CONFIG = 8;
const short PRESSED = 0;


const short R_OK = 1;
const short R_ERR = 0;



const char GETCFG[] = "GETCFG";
const char CFG[] = "CFG";
const char BOOTLOAD[] = "BOOTLOAD";
const char CHECK[] = "CHECK";
const char POWEROUT[] = "POWEROUT";
const char GETID[] = "GETID";
const char SETID[] = "SETID";
const char READSD[] = "READSD";









const char AT[] = "AT\r\n";


const char AT_CWJAP_JOIN[] = "AT+CWJAP=\"<AP_NAME>\",\"<PASSWORD>\"\r\n";

const char AT_CIFSR[] = "AT+CIFSR\r\n";



const char AT_CIPSTART[] = "AT+CIPSTART=1,\"<PROTOCOL>\",\"<URL>\",<PORT>\r\n";
const char AT_CIPSEND[] = "AT+CIPSEND=1,<BYTES>\r\n";


const char AT_CIPSERVER[] = "AT+CIPSERVER=1,<PORT>\r\n";
const char AT_CWSAP[] = "AT+CWSAP=\"<SSID>\",\"<PASSWORD>\",1,<ENCRYPTION>\r\n";


const char RESPONSE_OK[] = "OK";
const char RESPONSE_ERR[] = "ERROR";
const char HELLO[] = "HELLO\r\n";

TIME SystemTime;
CONFIG System;
ADC ADC_channel[8];
REL RELAY[6];




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


void M_Delete_File() {
 INTCON.GIE = 0;
 Mmc_Fat_Assign("MEM.TXT", 0);
 Mmc_Fat_Delete();
 INTCON.GIE = 1;
}

void M_Open_File_Append(char *toWrite) {
 char buffer[5];
 INTCON.GIE = 0;
 if (!Mmc_Fat_Assign("MEM.TXT", 0)){
 Mmc_Fat_Assign("MEM.TXT", 0xA0);
 Mmc_Fat_Rewrite();
 } else {
 Mmc_Fat_Append();
 }
 Mmc_Fat_Write(toWrite, System.size);
 INTCON.GIE = 1;
}




void clearReadLine(){
 int i;
 for (i=0;i<sizeof(System.readLine)-2;i++){
 System.readLine[i] = 'a';
 }
 strcpy(System.readLine,"");
 System.isInputReady = 0;
 System.index = 0;
}

int waitForInput(char *input, int timeout){
int i = 0;int mils = 0;
char buffer[30];
memset(buffer,'\0',sizeof(buffer)-1);
INTCON.GIE = 0;
while (mils <= timeout*1000){
 if (UART1_Data_Ready()){
 if (i == 30) i = 0;
 buffer[i++] = UART1_Read();
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


char * wait(char* input, int timeout){
int i = 0;int mils = 0;
char buffer[70];
memset(buffer,'\0',sizeof(buffer)-1);
INTCON.GIE = 0;
while (mils <= timeout*1000){
 if (UART1_Data_Ready()){
 if (i == 69) i = 0;
 buffer[i++] = UART1_Read();
 if (strstr(buffer,input) != 0){
 INTCON.GIE = 1;
 return buffer;
 }
 if (strstr(buffer,"END") != 0){
 INTCON.GIE = 1;
 return "null";
 }
 } else {
 mils++;
 delay_ms(1);
 }
}
INTCON.GIE = 1;

return "null";
}

char * load(char * dest, const char * src){
 char * d ;
 d = dest;
 for(;*dest++ = *src++;)
 ;
 return d;
}


void resetModule(){
 System.wifi_status = WIFI_NOT_CONNECTED;
 System.network_status = IDLE;

}

void save_config(char *what, int pos){
 int i;
 if (strstr(what,"A") != 0){
 char toWrite[50];
 char buffer[5];
 short size;
 char position[5];

 itoa(pos,position);

 strcpy(toWrite,"ADC_");
 strcat(toWrite,position);
 strcat(toWrite,";");
 strcat(toWrite,itoa(ADC_channel[pos-1].ADC_sec,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(ADC_channel[pos-1].ADC_dur,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(ADC_channel[pos-1].ADC_mil,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(ADC_channel[pos-1].port,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(ADC_channel[pos-1].ADC_isPortConnected,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(ADC_channel[pos-1].ADC_start_time,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(ADC_channel[pos-1].ADC_end_time,buffer));
 strcat(toWrite,";?");


 INTCON.GIE = 0;
 EEPROM_Write((pos-1)*50,strlen(toWrite));
 for (i=0;i<strlen(toWrite);i++){
 EEPROM_Write(((pos-1) * 50)+(i+1),toWrite[i]);
 }
 INTCON.GIE = 1;
 }

 if (strstr(what,"R") != 0){
 char toWrite[50];
 char buffer[10];
 char position[5];

 itoa(pos,position);

 strcpy(toWrite,"REL_");
 strcat(toWrite,position);
 strcat(toWrite,";");
 strcat(toWrite,itoa(RELAY[pos-1].R_enabled,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(RELAY[pos-1].R_trig,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(RELAY[pos-1].R_val,buffer));


 strcat(toWrite,";");
 strcat(toWrite,itoa(RELAY[pos-1].R_relay,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(RELAY[pos-1].R_tresh,buffer));


 strcat(toWrite,";");
 strcat(toWrite,itoa(RELAY[pos-1].R_state,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(RELAY[pos-1].R_start,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(RELAY[pos-1].R_end,buffer));
 strcat(toWrite,";?");


 INTCON.GIE = 0;
 EEPROM_Write((pos-1)*50,strlen(toWrite));
 for (i=0;i<strlen(toWrite);i++){
 EEPROM_Write(((8 + (pos-1)) * 50) + (i+1),toWrite[i]);
 }
 INTCON.GIE = 1;
 }

 if (strstr(what,"S") != 0){
 char toWrite[100];
 char buffer[10];

 strcpy(toWrite,"SYS;");
 strcat(toWrite,itoa(System.measure_type,buffer));
 strcat(toWrite,";");
 strcat(toWrite,itoa(System.connection_type,buffer));
 strcat(toWrite,";");
 strcat(toWrite,System.host);
 strcat(toWrite,";");
 strcat(toWrite,itoa(System.tcp_port,buffer));
 strcat(toWrite,";");
 strcat(toWrite,System.ssid);
 strcat(toWrite,";");
 strcat(toWrite,System.password);
 strcat(toWrite,";");
 strcat(toWrite,itoa(System.protocol,buffer));
 strcat(toWrite,";?");

 INTCON.GIE = 0;
 EEPROM_Write(800,strlen(toWrite));
 for (i=0;i<strlen(toWrite);i++){
 EEPROM_Write(801+i,toWrite[i]);
 }
 INTCON.GIE = 1;
 }

}


void process_config(char *buffer, short flag){

 if (strstr(buffer,"REL_")){
 char *p = strstr(buffer,"REL_");
 char buff[5];
 int i = 0;
 int pos = atoi(p+4)-1;

 p = strtok(buffer,";");

 while (p!=0){

 if (i==2) RELAY[pos].R_enabled = atoi(p);
 if (i==3) RELAY[pos].R_trig = atoi(p);
 if (i==4) { RELAY[pos].R_val = atoi(p); RELAY[pos].R_val_buffer = atoi(p); }
 if (i==5) RELAY[pos].R_relay = atoi(p);
 if (i==6) RELAY[pos].R_tresh = atoi(p);
 if (i==7){
 if (RELAY[pos].R_state != atoi(p)){
 RELAY[pos].R_flag_1 = 0;
 RELAY[pos].R_flag_2 = 0;
 }
 RELAY[pos].R_state = atoi(p);
 }
 if (i==8) RELAY[pos].R_start = atoi(p);
 if (i==9) RELAY[pos].R_end = atoi(p);

 i++;
 p = strtok(0,";");
 }


 if (flag == 1)
 save_config("R",++pos);
 }

 if (strstr(buffer,"ADC_")){
 char *p = strstr(buffer,"ADC_");
 char buff[5];
 int pos = atoi(p+4)-1;
 int i = 0;


 p = strtok(buffer,";");

 while (p!=0){

 if (i==2) ADC_channel[pos].ADC_SEC = atoi(p);
 if (i==3) ADC_channel[pos].ADC_DUR = atoi(p);
 if (i==4) ADC_channel[pos].ADC_MIL = atoi(p);
 if (i==5) ADC_channel[pos].PORT = atoi(p);
 if (i==6) ADC_channel[pos].ADC_ISPORTCONNECTED = atoi(p);
 if (i==7) ADC_channel[pos].ADC_START_TIME = atoi(p);
 if (i==8) ADC_channel[pos].ADC_END_TIME = atoi(p);

 i++;
 p = strtok(0,";");
 }
 if (flag == 1)
 save_config("A",++pos);
 }

 if (strstr(buffer,"SYS")){

 int i = 0;
 char *p = strtok(buffer,";");


 while (p!=0){

 if (i==2) System.measure_type = atoi(p);
 if (i==3) {if (System.connection_type != atoi(p)){
 System.connection_type = atoi(p);
 resetModule();
 }}
 if (i==4) strcpy(System.host,p);
 if (i==5) System.tcp_port = atoi(p);
 if (i==6) strcpy(System.ssid,p);
 if (i==7) strcpy(System.password,p);
 if (i==8) System.protocol = atoi(p);

 i++;
 p = strtok(0,";");
 }
 if (flag == 1)
 save_config("S",0);
 i=0;
 }

}


void default_config(){

 int index;


 for (index = 0; index < CHANNEL_COUNT; index++){
 ADC_channel[index].ADC_isPortConnected = FALSE;
 ADC_channel[index].ADC_mil_buffer = 0;
 ADC_channel[index].ADC_sec_buffer = 0;
 ADC_channel[index].ADC_dur_buffer = 0;
 }

 for (index = 0; index < RELAY_SIZE; index++){
 RELAY[index].R_enabled = FALSE;
 RELAY[index].R_flag_1 = 0;
 RELAY[index].R_flag_2 = 0;
 RELAY[index].R_trs_1 = 0;
 RELAY[index].R_trs_2 = 0;
 RELAY[index].R_current_state = 1;

 }

 SystemTime.year = 0;
 SystemTime.month = 0;
 SystemTime.day = 0;
 SystemTime.hour = 0;
 SystemTime.min = 0;
 SystemTime.sec = 0;
 SystemTime.mils = 0;

 SystemTime.min_2 = 0;
 SystemTime.sec_2 = 0;
 SystemTime.sec_3 = 0;
 SystemTime.mils_2 = 0;

 memset(System.readLine,' ',sizeof(System.readLine)-1);
 memset(System.password,' ',sizeof(System.password)-1);
 memset(System.host,' ',sizeof(System.host)-1);
 memset(System.ssid,' ',sizeof(System.ssid)-1);
 memset(System.ip_address,' ',sizeof(System.ip_address)-1);

 System.readLine[sizeof(System.readLine)-1] = '\0';
 System.PORTD_state = 0;
 System.index = 0;
 System.index_2 = 0;
 System.sec_flag = 0;
 System.min_flag = 0;
 System.connection_timer = 5;
 System.connection_timer_buffer = 0;
 System.isInputReady = FALSE;
 System.isInput_2_Ready = FALSE;
 System.network_status = IDLE;
 System.wifi_status = WIFI_TURNED_OFF;
 System.measure_type = BUFFERED;
 System.connection_type = SERVER;
 System.tcp_port = DEFAULT_PORT;
 System.battery_voltage = 512;
 System.isADCEnabled = TRUE;

 strcpy(System.ssid, load(System.load_buffer,DEFAULT_SSID));
 strcpy(System.password, load(System.load_buffer,DEFAULT_PW));
 strcpy(System.host,load(System.load_buffer,DEFAULT_HOST));
 strcpy(System.identifier,"null");
 System.tcp_port = 85;
 System.protocol = TCP;

}

void cipsend(int size){
 char conv[5];
 UART1_Write_Text("AT+CIPSEND=0,");
 UART1_Write_Text(itoa(size,conv));
 UART1_Write_Text("\r\n");
 if (waitForInput(">",2) == 0){
 System.network_status = IDLE;
 System.wifi_status = WIFI_NOT_CONNECTED;
 }
}

void update_server_from_sd() {
 char character;
 unsigned long size;
 unsigned long size_buffer;
 unsigned long i;
 char *read,*p;
 char converter[5];
 int buffer;

 INTCON.GIE = 0;
 Mmc_Fat_Assign("MEM.TXT", 0);
 Mmc_Fat_Reset(&size);
 size_buffer = size;
 if (size == 0){
 cipsend(11);
 UART1_Write_Text("No data...\n");

 } else {

 if (size >= 2048){
 buffer = 2048;
 } else {
 buffer = size;
 }
 cipsend(buffer);

 for (i = 0; i < size_buffer; i++) {

 if (i != 0 && i % 2048 == 0){

 size -= 2048;
 if (size >= 2048){
 buffer = 2048;
 } else {
 buffer = size;
 }
 INTCON.GIE = 1;
 waitForInput("OK",10);
 cipsend(buffer);
 INTCON.GIE = 0;
 }
 Mmc_Fat_Read(&character);
 UART1_Write(character);
 }
 }
 INTCON.GIE = 1;
 waitForInput("OK",10);
 M_Delete_File();
 clearReadLine();

}
#line 767 "C:/Users/Nils/Desktop/PIC/home_control/resource.c"
void read_config(){
 int i = 0,pos = 0;
 char conv[5];
 unsigned short size = 0;
 char read;

 for (i=0;i<1000;i++){
 read = EEPROM_Read(i);
 if (read != 0 || read != 255){
 if (read == 'A' && EEPROM_Read(++i) == 'D' && EEPROM_Read(++i) == 'C'){
 int j = 4;
 char toWrite[50];
 strcpy(toWrite," ;ADC");
 while (read != '?'){
 read = EEPROM_Read(i++);
 toWrite[j++] = read;
 if (j == sizeof(toWrite)-1) break;
 }
 toWrite[j] = '\0';
 process_config(toWrite, 0);

 } else
 if (read == 'R' && EEPROM_Read(++i) == 'E' && EEPROM_Read(++i) == 'L'){
 int j = 4;
 char toWrite[50];
 strcpy(toWrite," ;REL");
 while (read != '?'){
 read = EEPROM_Read(i++);
 toWrite[j++] = read;
 if (j == sizeof(toWrite)-1) break;
 }
 toWrite[j] = '\0';
 process_config(toWrite, 0);

 } else
 if (read == 'S' && EEPROM_Read(++i) == 'Y' && EEPROM_Read(++i) == 'S'){
 int j = 4;
 char toWrite[100];
 strcpy(toWrite," ;SYS");
 while (read != '?'){
 read = EEPROM_Read(i++);
 toWrite[j++] = read;
 if (j == sizeof(toWrite)-1) break;
 }
 toWrite[j] = '\0';
 process_config(toWrite, 0);

 }
 }

 }
#line 847 "C:/Users/Nils/Desktop/PIC/home_control/resource.c"
 for (i=0;i<5;i++){
 System.identifier[i] = EEPROM_Read(900+i);
 }
 if (atoi(System.identifier) == 0){
 strcpy(System.identifier,"null");
 }

}



void setIdentifier(){

 if (strstr(System.readLine,"SETID") != 0){
 char *p;
 short i;
 p = strtok(System.readLine,";");
 p = strtok(0,";");

 strcpy(System.identifier,p);
 p=0;

 for (i=0;i<5;i++){
 EEPROM_Write(900+i,System.identifier[i]);
 delay_ms(25);
 }

 cipsend(6);
 UART1_Write_Text("ID OK\n");
 waitForInput("OK",2);
 clearReadLine();
 }
}


void getSystemTime(){
 char *p;
 short i = 0;
 clearReadLine();
 cipsend(8);
 UART1_Write_Text("GETTIME\n");
 waitForInput("TIME",15);
 delay_ms(300);


 p = strtok(System.readLine,";");
 while (p != 0){
 switch (i){
 case 1: SystemTime.year = atoi(p); break;
 case 2: SystemTime.month = atoi(p); break;
 case 3: SystemTime.day = atoi(p); break;
 case 4: SystemTime.hour = atoi(p); break;
 case 5: SystemTime.min = atoi(p); break;
 case 2: SystemTime.sec = atoi(p); break;
 }
 i++;
 p = strtok(0,";");
 }

 cipsend(8);
 UART1_Write_Text("TIME OK\n");
 waitForInput("OK",2);

 clearReadLine();
}

void init_network_environment(){

 if (strstr(System.identifier,"null") != 0){
 clearReadLine();
 cipsend(6);
 UART1_Write_Text("GETID\n");
 waitForInput("IPD",15);
 delay_ms(300);
 setIdentifier();
 }else {
 char conv[5];
 int size = strlen(System.identifier) + 5;
 cipsend(size);
 UART1_Write_Text("ID;");
 UART1_Write_Text(System.identifier);
 UART1_Write_Text(";\n");
 waitForInput("OK",2);
 }
 getSystemTime();
}

void process_io(){


if (System.isInputReady == TRUE){
 char converter[5];



 if (System.connection_type == SERVER && strstr(System.readLine, "CONNECT") != 0 ){
 init_network_environment();
 }

 if (strstr(System.readLine, "CLOSED") != 0 ){
 System.network_status = IDLE;
 System.wifi_status = WIFI_NOT_CONNECTED;
 }


 if (strstr(System.readLine,"NEWCONFIG") != 0){
 int delay;
 short flag = 1;

 INTCON.GIE = 0;
 cipsend(3);
 UART1_Write_Text("OK\n");
 waitForInput("SEND OK",3);
 INTCON.GIE = 1;

 clearReadLine();

 while (flag){

 char *p = wait("#",3);
 if (strstr(p,"null") != 0){
 break;
 }

 process_config(p,1);

 INTCON.GIE = 0;
 cipsend(3);
 UART1_Write_Text("OK\n");
 waitForInput("SEND OK",3);
 INTCON.GIE = 1;

 p=0;
 clearReadLine();
 }


 cipsend(7);
 UART1_Write_Text("CFG OK\n");
 waitForInput("SEND OK",3);

 clearReadLine();
 }


 if (strstr(System.readLine,load(System.load_buffer,BOOTLOAD)) != 0){


 Start_Bootload();

 }


 if (strstr(System.readLine,load(System.load_buffer,CHECK)) != 0){


 clearReadLine();
 }


 if (strstr(System.readLine,load(System.load_buffer,READSD)) != 0){
 update_server_from_sd();
 delay_ms(500);
 clearReadLine();
 }

 clearReadLine();

 }
}



void getTimeStamp(){

 char buffer[5];

 if (SystemTime.year < 10){
 strcpy(System.load_buffer,"0");
 strcat(System.load_buffer,itoa(SystemTime.year,buffer));
 } else {
 strcpy(System.load_buffer,itoa(SystemTime.year,buffer));
 }

 if (SystemTime.month < 10){
 strcat(System.load_buffer,"0");
 strcat(System.load_buffer,itoa(SystemTime.month,buffer));
 } else {
 strcat(System.load_buffer,itoa(SystemTime.month,buffer));
 }

 if (SystemTime.day < 10){
 strcat(System.load_buffer,"0");
 strcat(System.load_buffer,itoa(SystemTime.day,buffer));
 } else {
 strcat(System.load_buffer,itoa(SystemTime.day,buffer));
 }

 if (SystemTime.hour < 10){
 strcat(System.load_buffer,"0");
 strcat(System.load_buffer,itoa(SystemTime.hour,buffer));
 } else {
 strcat(System.load_buffer,itoa(SystemTime.hour,buffer));
 }

 if (SystemTime.min < 10){
 strcat(System.load_buffer,"0");
 strcat(System.load_buffer,itoa(SystemTime.min,buffer));
 } else {
 strcat(System.load_buffer,itoa(SystemTime.min,buffer));
 }

 if (SystemTime.sec < 10){
 strcat(System.load_buffer,"0");
 strcat(System.load_buffer,itoa(SystemTime.sec,buffer));
 } else {
 strcat(System.load_buffer,itoa(SystemTime.sec,buffer));
 }
}

char * timeStampMeasurement(int index){



 char buffer[10];

 getTimeStamp();

 strcat(System.load_buffer,";");

 strcat(System.load_buffer,itoa(index+1,buffer));

 strcat(System.load_buffer,";");

 sprintf(buffer,"%4f", ADC_channel[index].ADC_value);

 strcat(System.load_buffer,buffer);

 strcat(System.load_buffer,"\n");

 System.size = strlen(System.load_buffer);

 return System.load_buffer;
}

void update_server(short index){

}

double doMeasurement(int position, int flag){

 if (flag == 0){

 switch (RELAY[position].R_trig){
 case 99: Measure_MS8607();
 return getTemperature(); break;
 case 98: Measure_MS8607();
 return getHumidity(); break;
 case 97: Measure_MS8607();
 return getPressure(); break;
 case 96:


  PORTA.B1  = 0;
  PORTA.B2  = 1;
 delay_ms(14);
  PORTA.B2  = 0;
 delay_ms(981);
  PORTA.B1  = 1;
 delay_us(2500);
  PORTA.B1  = 0;

 return (double)ADC_Get_Sample(3) / 4096 * 1000;

 default: return ADC_Get_Sample(RELAY[position].R_trig); break;
 }



 } else {

 switch (ADC_channel[position].port){
 case 99: Measure_MS8607();
 return getTemperature();
 break;
 case 98: Measure_MS8607();
 return getHumidity();
 break;
 case 97: Measure_MS8607();
 return getPressure();
 break;
 case 96:

  PORTA.B1  = 0;
  PORTA.B2  = 1;
 delay_ms(14);
  PORTA.B2  = 0;
 delay_ms(981);
  PORTA.B1  = 1;
 delay_us(2500);
  PORTA.B1  = 0;


 return (double)ADC_Get_Sample(3) / 4096 * 1000;
 default: return ADC_Get_Sample(ADC_channel[index].port);break;
 }
 }

}

short isStart(int position, int flag){

 int startTime = 0;
 int endTime = 0;
 int sysTime = 0;

 if (flag == 1){
 startTime = RELAY[position].R_start;
 endTime = RELAY[position].R_end;
 } else {
 startTime = ADC_CHANNEL[position].ADC_start_time;
 endTime = ADC_CHANNEL[position].ADC_end_time;
 }
 sysTime = SystemTime.hour * 60 + SystemTime.min;

 if ( startTime == 99 && endTime == 99 ) return 1;

 if (endTime > startTime){
 if (sysTime >= startTime && sysTime < endTime){
 return 1;
 }
 } else {
 if (sysTime >= startTime || sysTime < endTime){
 return 1;
 }
 }
 return 0;

}

void measure_sensors(){

 if (System.isADCEnabled){

 int index;
 for (index = 0; index < CHANNEL_COUNT; index++){



 if ((isStart(index,0) == TRUE &&
 ADC_channel[index].ADC_isPortConnected == TRUE) &&
 (ADC_channel[index].ADC_sec == ADC_channel[index].ADC_sec_buffer) &&
 (ADC_channel[index].ADC_dur >= ADC_channel[index].ADC_dur_buffer) &&
 (ADC_channel[index].ADC_mil == ADC_channel[index].ADC_mil_buffer)){


 ADC_channel[index].ADC_value = doMeasurement( index, 1);


 ADC_channel[index].ADC_mil_buffer = 0;


 if (ADC_channel[index].ADC_dur == ADC_channel[index].ADC_dur_buffer ){
 ADC_channel[index].ADC_dur_buffer = 0;
 ADC_channel[index].ADC_sec_buffer = 0;
 }


 if (System.network_status == CONNECTED && System.measure_type == UPDATING){
#line 1219 "C:/Users/Nils/Desktop/PIC/home_control/resource.c"
 char *p = timeStampMeasurement(index);
 cipsend(System.size);
 UART1_Write_Text(p);
 waitForInput("OK",3);

 }


 if (System.measure_type == BUFFERED){

 if (System.isMicroSDConnected){
 char *toWrite = timeStampMeasurement(index);
 M_Open_File_Append(toWrite);
 }
 }
 }

 }
 }
}





void InitTimer0(){
 T0CON = 0x88;
 TMR0H = 0xF6;
 TMR0L = 0x3C;
 GIE_bit = 1;
 TMR0IE_bit = 1;
}

void wifiSerialInterrupt(){

 if (PIR1.RCIF ) {


 if (System.index >= sizeof(System.readLine)-3){

 System.index = 0;
 }

 System.readLine[System.index] = UART1_Read();

 if (System.readLine[System.index] == '\n' ||
 System.readLine[System.index] == '\0' ||
 System.readLine[System.index] == '\r' ) {

 System.isInputReady = TRUE;
 System.readLine[System.index+1] = '\0';
 }

 System.index++;


 } else if (PIR2.RCIF){

 if (System.index_2 >= sizeof(System.uart2_buffer)-3){

 System.index_2 = 0;
 }

 System.uart2_buffer[System.index_2] = UART1_Read();

 if (System.uart2_buffer[System.index_2] == '\n' ||
 System.uart2_buffer[System.index_2] == '\0' ||
 System.uart2_buffer[System.index_2] == '\r' ) {

 System.isInput_2_Ready = TRUE;
 System.uart2_buffer[System.index_2+1] = '\0';
 }

 System.index_2++;
 }
}

void sensor_Clock(){
 short i;
 SystemTime.mils_2++;




 for (i = 0; i < CHANNEL_COUNT; i++){

 if (ADC_channel[i].ADC_isPortConnected == TRUE){

 if (ADC_channel[i].ADC_mil_buffer < ADC_channel[i].ADC_mil){
 ADC_channel[i].ADC_mil_buffer++;
 }

 if (SystemTime.mils_2 == 1000){
 if (ADC_channel[i].ADC_dur_buffer < ADC_channel[i].ADC_dur){
 ADC_channel[i].ADC_dur_buffer++;
 }
 if (ADC_channel[i].ADC_sec_buffer < ADC_channel[i].ADC_sec){
 ADC_channel[i].ADC_sec_buffer++;

 if (ADC_channel[i].ADC_sec_buffer == ADC_channel[i].ADC_sec){
 ADC_channel[i].ADC_dur_buffer = 0;
 ADC_channel[i].ADC_mil_buffer = 0;
 }
 }

 }
 if (SystemTime.sec_2 == 60) {
#line 1338 "C:/Users/Nils/Desktop/PIC/home_control/resource.c"
 }
 }
 }

 if (SystemTime.sec_2 == 60){
 SystemTime.sec_2 = 0;
 }
 if (SystemTime.mils_2 == 1000){
 SystemTime.mils_2 = 0;
 SystemTime.sec_2++;
 }


}

void systemClock(){

 SystemTime.mils++;



 if (SystemTime.mils == 1000){
 SystemTime.sec++;
 SystemTime.mils = 0;
 if (System.connection_timer_buffer <= System.connection_timer){
 System.connection_timer_buffer++;
 }
 }
 if (SystemTime.sec == 60){
 SystemTime.min++;
 SystemTime.sec = 0;
 System.sec_flag = 0;
 }
 if (SystemTime.min == 60){
 SystemTime.hour++;
 SystemTime.min = 0;
 System.min_flag = 0;
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


 wifiSerialInterrupt();


 if (TMR0IF_bit){
 TMR0IF_bit = 0;
 TMR0H = 0xF6;
 TMR0L = 0x3C;

 systemClock();
 sensor_Clock();

 }
}


void relay_status(int rel, int relay_state, int position, double measured_value){

 char buffer[5];

 getTimeStamp();

 strcat(System.load_buffer,";REL_");
 itoa(position,buffer);
 strcat(System.load_buffer,buffer);
 strcat(System.load_buffer,";");
 if (relay_state == 1){
 strcat(System.load_buffer,"ON;");
 } else {
 strcat(System.load_buffer,"OFF;");
 }
 itoa(rel,buffer);
 strcat(System.load_buffer,buffer);
 strcat(System.load_buffer,";");

 itoa(RELAY[position].R_val,buffer);
 strcat(System.load_buffer,buffer);
 strcat(System.load_buffer,";");

 sprintf(buffer,"%4f",measured_value);
 strcat(System.load_buffer,buffer);
 strcat(System.load_buffer,";\n");

 if (System.network_status == CONNECTED){

 cipsend(strlen(System.load_buffer));

 UART1_Write_Text(System.load_buffer);

 waitForInput("SEND OK",3);
 } else {
 if (System.isMicroSDConnected){

 }
 }

}


void switchRelay(int position, int status, double measured_value){

 char buffer[5];
 int relay_state = RELAY[position].R_state;
 int relay_number = RELAY[position].R_relay;
 int i;
 itoa(relay_state,buffer);

 if (status == 1){
 switch (relay_number){

 case 1:
 if (relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00000001;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00111110;
 }
 break;
 case 2:
 if (relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00000010;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00111101;
 }
 break;
 case 3:
 if (relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00000100;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00111011;
 }
 break;
 case 4:
 if (relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00001000;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00110111;
 }
 break;
 case 5:
 if (relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00010000;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00101111;
 }
 break;
 case 6:
 if (relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00100000;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00011111;
 }
 break;
 }
 PORTD = System.PORTD_state;

 if (RELAY[position].R_state_buffer != relay_state){
 relay_status(relay_number, relay_state, position, measured_value);
 RELAY[position].R_state_buffer = relay_state;
#line 1521 "C:/Users/Nils/Desktop/PIC/home_control/resource.c"
 }
 } else {
 switch (relay_number){
 case 1:
 if (!relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00000001;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00111110;
 }
 break;
 case 2:
 if (!relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00000010;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00111101;
 }
 break;
 case 3:
 if (!relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00000100;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00111011;
 }
 break;
 case 4:
 if (!relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00001000;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00110111;
 }
 break;
 case 5:
 if (!relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00010000;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00101111;
 }
 break;
 case 6:
 if (!relay_state == 1){
 System.PORTD_state = System.PORTD_state | 0b00100000;
 } else {
 System.PORTD_state = System.PORTD_state & 0b00011111;
 }
 break;
 }
 PORTD = System.PORTD_state;
 if (RELAY[position].R_state_buffer != !relay_state){
 relay_status(relay_number, !relay_state, position, measured_value);
 RELAY[position].R_state_buffer = !relay_state;
#line 1581 "C:/Users/Nils/Desktop/PIC/home_control/resource.c"
 }
 }

}


void system_processes(){

 if ( PORTC.B2  == PRESSED){
 delay_ms(1000);
 if ( PORTC.B2  == PRESSED){
 System.wifi_status = WIFI_NOT_CONNECTED;
 System.network_status = IDLE;
 System.connection_type = !System.connection_type;
 System.connection_timer = 0;
 }
 }
#line 1739 "C:/Users/Nils/Desktop/PIC/home_control/resource.c"
 if (System.min_flag < SystemTime.min){
 System.min_flag = SystemTime.min;
 if (System.network_status == CONNECTED){
 cipsend(6);
 UART1_Write_Text("CHECK\n");
 if (waitForInput("LIVE",10) == 0){
 System.network_status = IDLE;
 System.wifi_status = WIFI_NOT_CONNECTED;
 }
 }
 }


 if (System.sec_flag < SystemTime.sec){
 int pos;

 System.sec_flag = SystemTime.sec;

 for (pos=0;pos<RELAY_SIZE;pos++){
 if (RELAY[pos].R_enabled ){
 if ( isStart(pos, 1) ){

 if ( RELAY[pos].R_val == 0){
 if (RELAY[pos].R_current_state == 0){
 char buffer[5];

 switchRelay(pos, 1, 0);
 RELAY[pos].R_current_state = 1;

 }
 } else {
 double measured_value = doMeasurement(pos, 0);

 if ( RELAY[pos].R_current_state == 1 ){

 if ( RELAY[pos].R_val_buffer < measured_value){

 RELAY[pos].R_trs_1 = RELAY[pos].R_tresh;

 RELAY[pos].R_current_state = 0;
 switchRelay(pos, 1, measured_value);


 RELAY[pos].R_flag_1 = 0;

 } else {
 if (RELAY[pos].R_flag_1 == 0){

 switchRelay(pos, 0, measured_value);

 RELAY[pos].R_flag_1 = 1;
 }
 }
 } else {

 if ( RELAY[pos].R_val_buffer > measured_value){

 RELAY[pos].R_trs_2 = RELAY[pos].R_tresh;

 RELAY[pos].R_current_state = 1;
 switchRelay(pos, 0, measured_value);


 RELAY[pos].R_flag_2 = 0;

 } else {
 if (RELAY[pos].R_flag_2 == 0){
 switchRelay(pos, 1, measured_value);


 RELAY[pos].R_flag_2 = 1;
 }
 }
 }
 }
 } else {
 if (RELAY[pos].R_current_state == 0){
 char buffer[5];

 switchRelay(pos, 0, 0);
 RELAY[pos].R_current_state = 1;

 }
 }

 }
 }
 }
#line 1850 "C:/Users/Nils/Desktop/PIC/home_control/resource.c"
}

void SETUP_SYSTEM(){}

void setup_pic(){

 TRISA = 0b00101001;
 TRISB = 0b00001111;
 TRISC = 0b10000100;
 TRISD = 0b00000000;

 PORTD = 0b00000000;
 PORTA = 0b00000000;

 ANCON0 = 0b11111001;
 ANCON1 = 0b11111101;

 delay_ms(1000);

 InitTimer0();

 UART1_Init(9600);
 delay_ms(100);
 UART2_Init(9600);
 delay_ms(1000);
 UART1_Write_Text("AT\r\n");
 delay_ms(500);

 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);

 if ( Mmc_Fat_Init() == 0 ) {
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
 delay_ms(200);
 UART1_Write_Text("SD found\r\n");
 System.isMicroSDConnected = TRUE;
 } else {
 UART1_Write_Text("No SD");
 System.isMicroSDConnected = FALSE;
 }


 INTCON.GIE = 1;
 INTCON.PEIE = 1;
 PIE1.RCIE = 1;

 ADC_Init();


}



short connect_to_server(){
 char *p1;
 char *p2;
 char *response;
 char conv[5];

 UART1_Write_Text("AT+SLEEP=2\r\n");
 waitForInput("OK",3);

 UART1_Write_Text("AT+CWMODE=1\r\n");
 waitForInput("OK",3);
 UART1_Write_Text("AT+CWJAP=\"");
 UART1_Write_Text(System.ssid);
 UART1_Write_Text("\",\"");
 UART1_Write_Text(System.password);
 UART1_Write_Text("\"\r\n");
 if (waitForInput("OK",10)){
 System.wifi_status = CONNECTED;
 } else {
 return FALSE;
 }


 UART1_Write_Text("AT+CIPMUX=1\r\n");
 waitForInput("OK",2);


 clearReadLine();

 UART1_Write_Text("AT+CIPSTART=0,\"");
 UART1_Write_Text("TCP");
 UART1_Write_Text("\",\"");
 UART1_Write_Text(System.host);
 UART1_Write_Text("\",");
 UART1_Write_Text(itoa(System.tcp_port,conv));
 UART1_Write_Text("\r\n");


 if (waitForInput("OK",10) == 1){

 System.network_status = CONNECTED;

 init_network_environment();
#line 1963 "C:/Users/Nils/Desktop/PIC/home_control/resource.c"
 } else {
 System.network_status = IDLE;
 return FALSE;
 }
 return TRUE;
}

short create_server(){

 UART1_Write_Text("AT+SLEEP=0\r\n");
 waitForInput("OK",3);

 UART1_Write_Text("AT+CWMODE=2\r\n");
 waitForInput("OK",2);

 UART1_Write_Text("AT+CIPMUX=1\r\n");
 waitForInput("OK",2);

 UART1_Write_Text("AT+CWSAP=\"");
 UART1_Write_Text(load(System.load_buffer,DEFAULT_AP));
 UART1_Write_Text("\",\"");
 UART1_Write_Text(load(System.load_buffer,DEFAULT_PW));
 UART1_Write_Text("\",1,");
 UART1_Write_Text(load(System.load_buffer,DEFAULT_ENCRYPTION));
 UART1_Write_Text("\r\n");
 if (waitForInput("OK",5)){
 System.wifi_status = CONNECTED;
 } else {
 return FALSE;
 }


 UART1_Write_Text("AT+CIPSERVER=1,8080\r\n");

 if (waitForInput("OK",2)) {

 System.network_status = LISTENING;
 } else {
 System.network_status = IDLE;
 return FALSE;
 }

 return TRUE;
}

void networking(){

 if (System.connection_timer_buffer >= System.connection_timer){

 if (System.wifi_status != WIFI_CONNECTED || System.network_status == IDLE){
 short isConnected;
 if (System.connection_type == CLIENT){
 isConnected = connect_to_server();
 } else {
 isConnected = create_server();
 }
 if (isConnected == FALSE){
 if (System.connection_timer <= 600) System.connection_timer += 20;
 }

 }
 System.connection_timer_buffer = 0;
 }
}


void setup(){

 setup_pic();

 default_config();

 read_config();

}


void main() org 64888{

setup();

while (1) {

 networking();

 measure_sensors();

 process_io();

 system_processes();

 if (System.isInput_2_Ready == TRUE){
 System.isInput_2_Ready = FALSE;

 Susart_Init(51);
 if (Susart_Write_Loop('g','r')) {
 Start_Bootload();
 }
 else {
 Start_Program();
 }
 }

}

}
