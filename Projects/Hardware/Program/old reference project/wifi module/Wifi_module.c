#define LED           PORTB.B5
#define DIPSW_1       PORTC.B2
#define DIPSW_2       PORTB.B2
#define isPowerOut    PORTC.B0

#define RELAY_1       PORTD.B0
#define RELAY_2       PORTD.B1
#define RELAY_3       PORTD.B2
#define RELAY_4       PORTD.B3
#define RELAY_5       PORTD.B4
#define RELAY_6       PORTD.B5

#define CO2_READ       PORTA.B3
#define CO2_HEAT       PORTA.B2
#define CO2_PULSE      PORTA.B1


sbit Soft_I2C_Scl           at RB4_bit;
sbit Soft_I2C_Sda           at RB5_bit;
sbit Soft_I2C_Scl_Direction at TRISB4_bit;
sbit Soft_I2C_Sda_Direction at TRISB5_bit;

// MMC module connections
sbit Mmc_Chip_Select           at LATB3_bit;  // for writing to output pin always use latch (PIC18 family)
sbit Mmc_Chip_Select_Direction at TRISB3_bit;

void Measure_MS8607();
float getTemperature();
float getHumidity();
float getPressure();

/************ Bootloader functions *************/

void Susart_Init(char Brg_reg);
void Susart_Write(char data_);
void Start_Bootload();
void Start_Program();
char Susart_Write_Loop(char send, char recieve);

/***********************************************/

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
        /*  BATTERY  */
        short g_index;
        short battery_voltage;
        short battery_voltage_buffer[10];

        /* NETWORK STUFF */
        char readLine[150];  // Capable to read config string from server
        char uart2_buffer[10];
        int index;
        int index_2;
        short wifi_status;
        short isInputReady;
        short isInput_2_Ready;
        short isCharging;
        char identifier[5];

        
        /* STATUS VARIABLES*/
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
        
        /* CONFIGS */
        short measure_type;
        short connection_type;
        char  ip_address[13];
        int   tcp_port;
        char  ssid[32];
        char  password[32];
        short protocol;
        char  host[64];

        
} CONFIG;

short index;

typedef struct {
      int    R_enabled;
      int    R_trig;
      int    R_val;
      int    R_relay;
      int    R_tresh;
      int    R_state;
      int    R_start;
      int    R_end;
      
      int    R_current_state;
      int    R_state_buffer;
      int    R_val_buffer;
      
      short    R_flag_1;
      short    R_flag_2;
      
      int   R_trs_1;
      int   R_trs_2;
} REL;



typedef struct {

      int   ADC_sec;         //  Every [20] min             frequency
      int   ADC_dur;         //  For  [12] sec              measuring intervall
      int   ADC_mil;         //  Measure every 200 mils     sampling rate
      
      double   ADC_value;
      
      int port;                        // Define AN port by schematic
                                         // Battery - 9
                                         // TMP36   - 8
                                         
      int ADC_isPortConnected;         // is in use
      
      int   ADC_start_time;
      int   ADC_end_time;
      
      int ADC_sec_buffer;
      int ADC_dur_buffer;
      int ADC_mil_buffer;

} ADC;

// NO_ENC       = "0";
// WPA_PSK      = "2";
// WPA2_PSK     = "3";
// WPA_WPA2_PSK = "4";

/********* USER CONSTANTS ***********/

const short RELAY_SIZE                = 6;
const short CHANNEL_COUNT             = 8;
const short DEFAULT_PORT              = 666;    // satan was here lol
const char DEFAULT_SSID[]             = "Tardis";
const char DEFAULT_AP[]               = "ESP-NETWORK";
const char DEFAULT_PW[]               = "77Ld7cr7dW";
const char DEFAULT_HOST[]             = "192.168.0.5";
const char DEFAULT_ENCRYPTION[]       = "0";
const short DEBUG                     = 1;
const short BATTERY_PORT              = 9;      // Analog port of battery measurement

/************************************/

/********* DO NOT CHANGE ***********/
const int DAYS_OF_MONTH[12] = {31,28,31,30,31,30,31,31,30,31,30,31};

// Values of System.protocol
const short TCP                     = 0;
const short UDP                     = 1;

// Values of System.wifi_status
const short WIFI_CONNECTED          = 0;
const short WIFI_NOT_CONNECTED      = 1;
const short WIFI_TURNED_OFF         = 2;

// Values of System.network_status
const short CONNECTED               = 0;
const short LISTENING               = 1;
const short IDLE                    = 2;

// Values of System.measure_type
const short BUFFERED                = 0;
const short UPDATING                = 1;

// Values of System.connection_type
const short SERVER                  = 0;
const short CLIENT                  = 1;

const short FALSE                   = 0;
const short TRUE                    = 1;

// Get config values
const short SYS                     = 0;
const short ADC                     = 1;

// Serial Write Delays
const char DELAY_SHORT              = 50;        // If we expect no response from serial port
const char DELAY_LONG               = 200;       // Otherwise

// Flash memory addresses
const int CONFIG_START_ADDRESS      = 0x00;
const int ADC_START_ADDRESS         = 0x00;
const int STATUS_START_ADDRESS      = 0x00;

// DIP SWITCH SECOND STATUSES
const short REBOOT_SYSTEM           = 2;
const short RESET_CONFIG            = 8;
const short PRESSED                 = 0;

// Server responses
const short R_OK                    = 1;
const short R_ERR                   = 0;


// Server Commands
const char GETCFG[]                  = "GETCFG";
const char CFG[]                     = "CFG";
const char BOOTLOAD[]                = "BOOTLOAD";
const char CHECK[]                   = "CHECK";
const char POWEROUT[]                = "POWEROUT";
const char GETID[]                   = "GETID";
const char SETID[]                   = "SETID";
const char READSD[]                  = "READSD";




/*****************************************/


// AT COMMAND GUIDE: http://rancidbacon.com/files/kiwicon8/ESP8266_WiFi_Module_Quick_Start_Guide_v_1.0.4.pdf

const char AT[] = "AT\r\n";                               //Test command                                                              RESPONSE:   OK                         ## NO NEED IF FIRMWARE > 00160901 ##                                         RESPONSE:  +CWLAP:(3,"WiFiArtThouRomeo",-80)

// AT+CWJAP="<access_point_name>","<password>"          //Join a suitable WiFi access point:                                        RESPONSE: OK
const char AT_CWJAP_JOIN[] = "AT+CWJAP=\"<AP_NAME>\",\"<PASSWORD>\"\r\n";

const char AT_CIFSR[] = "AT+CIFSR\r\n";                   //Module has been allocated a IP address with:                              RESPONSE: 192.168.1.2


// Connect to URL. Connection 1-4 Protocol: TCP/UDP                                                                                 RESPONSE: OK Linked
const char AT_CIPSTART[] = "AT+CIPSTART=1,\"<PROTOCOL>\",\"<URL>\",<PORT>\r\n";
const char AT_CIPSEND[] = "AT+CIPSEND=1,<BYTES>\r\n";    //Send data on channel <CONNECTION>                               RESONSE: >

// Create TCP Server
const char AT_CIPSERVER[] = "AT+CIPSERVER=1,<PORT>\r\n";          // SERVER LISTENS ON PORT                                           RESPONSE: Link if client connected                                                                                                                                 //  DATA RECEIVE: +IPD,0,13:KiwiconAte! \n OK                                                                                                                                //  0 - connection channel, 13 - bytes
const char AT_CWSAP[] = "AT+CWSAP=\"<SSID>\",\"<PASSWORD>\",1,<ENCRYPTION>\r\n";  // Wifi Access Point


const char RESPONSE_OK[] = "OK";
const char RESPONSE_ERR[] = "ERROR";
const char HELLO[] = "HELLO\r\n";

TIME   SystemTime;
CONFIG System;
ADC    ADC_channel[8];
REL    RELAY[6];




char * itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    int shifter;
    if(i<0){
        *p++ = '-';
        i *= -1;
    }
    shifter = i;
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
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
   if (!Mmc_Fat_Assign("MEM.TXT", 0)){             // only memory will be appended so no need for filename parameter
      Mmc_Fat_Assign("MEM.TXT", 0xA0);          // Find existing file or create a new one
      Mmc_Fat_Rewrite();
   } else {
      Mmc_Fat_Append();
   }                                  // Prepare file for append
   Mmc_Fat_Write(toWrite, System.size);             // Write data to assigned file
   INTCON.GIE = 1;
}

// Opens an existing file, reads data from it and puts it to UART


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
     // Turn off and on ESP
}

void save_config(char *what, int pos){
  int i;
  if (strstr(what,"A") != 0){       // ADC
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

  if (strstr(what,"R") != 0){        // Relay
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
    // sprintf(buffer,"%4f", RELAY[pos].R_val);
    // strcat(toWrite,buffer);
     strcat(toWrite,";");
     strcat(toWrite,itoa(RELAY[pos-1].R_relay,buffer));
     strcat(toWrite,";");
     strcat(toWrite,itoa(RELAY[pos-1].R_tresh,buffer));
     //sprintf(buffer,"%4f", RELAY[pos].R_tresh);
     //strcat(toWrite,buffer);
     strcat(toWrite,";");
     strcat(toWrite,itoa(RELAY[pos-1].R_state,buffer));
     strcat(toWrite,";");
     strcat(toWrite,itoa(RELAY[pos-1].R_start,buffer));
     strcat(toWrite,";");
     strcat(toWrite,itoa(RELAY[pos-1].R_end,buffer));
     strcat(toWrite,";?");

     //UART1_Write_Text("save");
     INTCON.GIE = 0;
     EEPROM_Write((pos-1)*50,strlen(toWrite));
     for (i=0;i<strlen(toWrite);i++){
         EEPROM_Write(((8 + (pos-1)) * 50) + (i+1),toWrite[i]);
     }
     INTCON.GIE = 1;
  }

  if (strstr(what,"S") != 0){       // System
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
     // Default configuration and setting status variables
     int index;

     // By default every channel is off
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
     System.connection_type = SERVER;       // CREATES SERVER BY DEFAULT
     System.tcp_port = DEFAULT_PORT;
     System.battery_voltage = 512;          // 50%
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
  Mmc_Fat_Assign("MEM.TXT", 0);          // File read from position 0
  Mmc_Fat_Reset(&size);              // To read file, procedure returns size of file
  size_buffer = size;
  if (size == 0){
     cipsend(11);
     UART1_Write_Text("No data...\n");

  } else {

  if (size >= 2048){                 // AT+CIPSEND sends maximum 2048 bytes in a packet
      buffer = 2048;                  // If size is greater than 2048, it should write 2048
  } else {
      buffer = size;                  // Else the remaining size
  }
  cipsend(buffer);

  for (i = 0; i < size_buffer; i++) {

     if (i != 0 && i % 2048 == 0){
         // UART1_Write_Text("e");
         size -= 2048;
         if (size >= 2048){           // Still can be more than 2048 so same story
             buffer = 2048;
         } else {
             buffer = size;
         }
         INTCON.GIE = 1;
         waitForInput("OK",10);               // Wait data to be sent
         cipsend(buffer);                     // send next packet
         INTCON.GIE = 0;
     }
     Mmc_Fat_Read(&character);
     UART1_Write(character);         // sends read char to wifi module
  }
  }
  INTCON.GIE = 1;
  waitForInput("OK",10);
  M_Delete_File();
  clearReadLine();

}
    /*
char * create_config_string(){

     // Create configuration string from memory

     char buffer[180];
     char converter[5];
     short index;

     strcpy(buffer,"CFG;");
     strcat(buffer,itoa(System.measure_type,converter));
     strcat(buffer,";");
     strcat(buffer,itoa(System.connection_type,converter));
     strcat(buffer,";");
     strcat(buffer,System.host);
     strcat(buffer,";");
     strcat(buffer,itoa(System.tcp_port,converter));
     strcat(buffer,";");
     strcat(buffer,System.ssid);
     strcat(buffer,";");
     strcat(buffer,System.password);
     strcat(buffer,";");
     strcat(buffer,itoa(System.protocol,converter));
     strcat(buffer,";");


     for (index = 0; index < CHANNEL_COUNT; index++){
         strcat(buffer,itoa(ADC_channel[index].ADC_sec,converter));
         strcat(buffer,";");
         strcat(buffer,itoa(ADC_channel[index].ADC_dur,converter));
         strcat(buffer,";");
         strcat(buffer,itoa(ADC_channel[index].ADC_mil,converter));
         strcat(buffer,";");

         strcat(buffer,itoa(ADC_channel[index].port,converter));
         strcat(buffer,";");
         strcat(buffer,itoa(ADC_channel[index].ADC_isPortConnected,converter));
         strcat(buffer,";");
      }
      System.size = strlen(buffer);

      return buffer;
}     */

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
                      read =  EEPROM_Read(i++);
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
                      read =  EEPROM_Read(i++);
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
                      read =  EEPROM_Read(i++);
                      toWrite[j++] = read;
                      if (j == sizeof(toWrite)-1) break;
                }
                toWrite[j] = '\0';
                process_config(toWrite, 0);

             }
          }
    
    }
    
    
    
    /*  for (pos = 0; pos < 14; pos++){
        size = (short)EEPROM_Read(pos*50);
        itoa(size,conv);
        UART1_Write_Text(" POSITION: ");
        UART1_Write_Text(conv);

        if (size != 0 && size != 255){
            char toWrite[50];
            for (i=1;i<=size;i++){
               toWrite[i-1] = EEPROM_Read((pos*50)+i);
            }
            strcat(toWrite," ");
            process_config(toWrite);
        }
    }
    
    size = (short)EEPROM_Read(800);
    if (size != 0 && size != 255){
       char toWrite[100];
       for (i=0;i<size;i++){
           toWrite[i] = EEPROM_Read(801+i);
       }
       strcat(toWrite," ");
       process_config(toWrite);
    } */

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

     //YY;MM;DD;HH;MM;SS;
     p = strtok(System.readLine,";");
     while (p != 0){
        switch (i){
           case 1: SystemTime.year = atoi(p); break;
           case 2: SystemTime.month = atoi(p); break;
           case 3: SystemTime.day = atoi(p); break;
           case 4: SystemTime.hour = atoi(p); break;
           case 5: SystemTime.min = atoi(p);  break;
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


if (System.isInputReady == TRUE){    // If System.readLine contains \0 or \n
   char converter[5];
   //delay_ms(300);
       /************  GET CONFIGURATION ************/
       
       if (System.connection_type == SERVER && strstr(System.readLine, "CONNECT") != 0 ){
          init_network_environment();
       }
       
       if (strstr(System.readLine, "CLOSED") != 0 ){
          System.network_status = IDLE;
          System.wifi_status = WIFI_NOT_CONNECTED;
       }

      /************  NEW CONFIGURATION ************/
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

         // Sends OK to server as acknowledgement
         cipsend(7);
         UART1_Write_Text("CFG OK\n");
         waitForInput("SEND OK",3);
         
         clearReadLine();
      }

      /************  BOOTLOAD ************/
      if (strstr(System.readLine,load(System.load_buffer,BOOTLOAD)) != 0){
                                               // Init USART at 9600   16MHZ
          //if (Susart_Write_Loop('g','r')) {   // Send 'g' for ~5 sec, if 'r'
             Start_Bootload();                 //   received start bootload
          //}
      }

      /************  SYSTEM DIAGNOSTICS ************/
      if (strstr(System.readLine,load(System.load_buffer,CHECK)) != 0){
          // Battery state
          // is Power CONNECTED
          clearReadLine();
      }


      if (strstr(System.readLine,load(System.load_buffer,READSD)) != 0){
          update_server_from_sd();
          delay_ms(500);
          clearReadLine();
      }

      clearReadLine();
      // GETID , UPDATE (reads measurements from SD)
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

          // EXAMPLE OUTPUT MAX LENGTH    | separator for reading this data later
          // 1503124320;9;227.5:720.2|
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
               

                    CO2_PULSE = 0;
                    CO2_HEAT = 1;
                    delay_ms(14);
                    CO2_HEAT = 0;
                    delay_ms(981);
                    CO2_PULSE = 1;
                    delay_us(2500);
                    CO2_PULSE = 0;

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
               case 96: // CO2

                    CO2_PULSE = 0;
                    CO2_HEAT = 1;
                    delay_ms(14);
                    CO2_HEAT = 0;
                    delay_ms(981);
                    CO2_PULSE = 1;
                    delay_us(2500);
                    CO2_PULSE = 0;


                    return (double)ADC_Get_Sample(3) / 4096 * 1000;
               default: return ADC_Get_Sample(ADC_channel[index].port);break;
        }
    }

}

short isStart(int position, int flag){      // time in min:  21:58 equals  1318

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
         // go through every analog channel
         int index;
         for (index = 0; index < CHANNEL_COUNT; index++){

               // if they are Connected (defined by config)
               // and if they reach their time buffers, measure
               if ((isStart(index,0) == TRUE &&
                    ADC_channel[index].ADC_isPortConnected == TRUE)                  &&
                   (ADC_channel[index].ADC_sec == ADC_channel[index].ADC_sec_buffer) &&
                   (ADC_channel[index].ADC_dur >= ADC_channel[index].ADC_dur_buffer) &&  // increase ADC_channel[i].buffer by second
                   (ADC_channel[index].ADC_mil == ADC_channel[index].ADC_mil_buffer)){

                    // get adc value at Analog port
                    ADC_channel[index].ADC_value = doMeasurement( index, 1);

                    // Reset timers if they reach their buffer
                    ADC_channel[index].ADC_mil_buffer = 0;

                    // If adc sec reaches it's buffer, then clear min as well
                    if (ADC_channel[index].ADC_dur == ADC_channel[index].ADC_dur_buffer ){
                        ADC_channel[index].ADC_dur_buffer = 0;
                        ADC_channel[index].ADC_sec_buffer = 0;
                    }

                    // update server or save to sd card, depends on configuration
                    if (System.network_status == CONNECTED && System.measure_type == UPDATING){
                        /*char buffer[5];
                        UART1_Write_Text(itoa(SystemTime.mils,buffer)); */

                        char *p = timeStampMeasurement(index);
                        cipsend(System.size);
                        UART1_Write_Text(p);
                        waitForInput("OK",3);
                        //UART1_Write_Text(itoa(SystemTime.mils,buffer));
                    }

                    // save to sd card only. Server has to request data
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


//Timer0
//Prescaler 1:1; TMR0 Preload = 63036; Actual Interrupt Time : 1 ms

void InitTimer0(){
  T0CON         = 0x88;
  TMR0H         = 0xF6;
  TMR0L         = 0x3C;
  GIE_bit         = 1;
  TMR0IE_bit         = 1;
}

void wifiSerialInterrupt(){

    if (PIR1.RCIF ) {          // test the interrupt for uart rx

        //if ( System.isIntEnabled == TRUE ){
            if (System.index >= sizeof(System.readLine)-3){
                // To stop buffer from overfloating
                System.index = 0;
            }

            System.readLine[System.index] = UART1_Read();

            if (System.readLine[System.index] == '\n' ||
                System.readLine[System.index] == '\0' ||
                System.readLine[System.index] == '\r' ) {
                // If \r or \0 is read, we got something, so process it, triggers process_io procedure
                System.isInputReady = TRUE;
                System.readLine[System.index+1] = '\0';
            }

            System.index++;
        //}

    } else if (PIR2.RCIF){
    
            if (System.index_2 >= sizeof(System.uart2_buffer)-3){
                // To stop buffer from overfloating
                System.index_2 = 0;
            }

            System.uart2_buffer[System.index_2] = UART1_Read();

            if (System.uart2_buffer[System.index_2] == '\n' ||
                System.uart2_buffer[System.index_2] == '\0' ||
                System.uart2_buffer[System.index_2] == '\r' ) {
                // If \r or \0 is read, we got something, so process it, triggers process_io procedure
                System.isInput_2_Ready = TRUE;
                System.uart2_buffer[System.index_2+1] = '\0';
            }

            System.index_2++;
    }
}

void sensor_Clock(){
    short i;
    SystemTime.mils_2++;
    // These buffers are responsible for the precise timing of measurements
    // Described by the Configuration


    for (i = 0; i < CHANNEL_COUNT; i++){

        if (ADC_channel[i].ADC_isPortConnected == TRUE){

            if (ADC_channel[i].ADC_mil_buffer < ADC_channel[i].ADC_mil){
                ADC_channel[i].ADC_mil_buffer++;
            }

            if (SystemTime.mils_2 == 1000){
                if (ADC_channel[i].ADC_dur_buffer < ADC_channel[i].ADC_dur){
                    ADC_channel[i].ADC_dur_buffer++;
                }
                if (ADC_channel[i].ADC_sec_buffer < ADC_channel[i].ADC_sec){    // this is at wrong place
                    ADC_channel[i].ADC_sec_buffer++;
                    
                    if (ADC_channel[i].ADC_sec_buffer == ADC_channel[i].ADC_sec){
                        ADC_channel[i].ADC_dur_buffer = 0;
                        ADC_channel[i].ADC_mil_buffer = 0;
                    }
                }

            }
            if (SystemTime.sec_2 == 60) {
                /*if (ADC_channel[i].ADC_sec_buffer < ADC_channel[i].ADC_sec){    // this is at wrong place
                    ADC_channel[i].ADC_sec_buffer++;
                } else {
                    if (ADC_channel[i].ADC_sec != 0){
                        ADC_channel[i].ADC_dur_buffer = 0;
                        ADC_channel[i].ADC_mil_buffer = 0;
                    }
                }
                if (ADC_channel[i].ADC_sec_buffer == ADC_channel[i].ADC_sec){
                    ADC_channel[i].ADC_dur_buffer = 0;
                    ADC_channel[i].ADC_mil_buffer = 0;
                }  */
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

     // Clock buffer for sensors

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

  // If serial data is detected on Uart
  wifiSerialInterrupt();

  // Interrupts every ms
  if (TMR0IF_bit){
    TMR0IF_bit = 0;
    TMR0H         = 0xF6;
    TMR0L         = 0x3C;

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
            // M_Open_File_Append(System.load_buffer);
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
            
            /*for (i=0; i < RELAY_SIZE; i++){
               if ( RELAY[i].R_relay == RELAY[position].R_relay ){
                  if ( RELAY[i].R_state == RELAY[position].R_state ){
                     RELAY[i].R_state_buffer = relay_state;
                  } else {
                     RELAY[i].R_state_buffer = !relay_state;
                  }
               }
            }*/
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
            
            /*for (i=0; i < RELAY_SIZE; i++){
               if ( RELAY[i].R_relay == RELAY[position].R_relay ){
                  if ( RELAY[i].R_state == RELAY[position].R_state ){
                     RELAY[i].R_state_buffer = !relay_state;
                  } else {
                     RELAY[i].R_state_buffer = relay_state;
                  }
               }
            } */
         }
     }

}


void system_processes(){

     if (DIPSW_1 == PRESSED){
        delay_ms(1000);
        if (DIPSW_1 == PRESSED){
            System.wifi_status = WIFI_NOT_CONNECTED;
            System.network_status = IDLE;
            System.connection_type = !System.connection_type;
            System.connection_timer = 0;
        }
     }

     // relay stuff here

    /* if (DIPSW_1 == PRESSED){
        char buffer[5];
        int i;

        delay_ms(500);

        for (i=0;i<8;i++){
          UART1_Write_Text("ADC:");
          UART1_Write_Text(itoa(i,buffer));
          UART1_Write_Text("  SEC:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_sec,buffer));
          UART1_Write_Text("  DUR:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_dur,buffer));
          UART1_Write_Text("  MIL:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_mil,buffer));
          UART1_Write_Text("  PORT:");
          UART1_Write_Text(itoa(ADC_channel[i].port,buffer));
          UART1_Write_Text("  CONNECTED:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_isPortConnected,buffer));
          UART1_Write_Text("  START:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_start_time,buffer));
          UART1_Write_Text("  END:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_end_time,buffer));
          UART1_Write_Text("\r\n");

        }
        

        for (i=0;i<6;i++){

          UART1_Write_Text("REL:");
          UART1_Write_Text(itoa(i,buffer));
          UART1_Write_Text("  ENA:");
          UART1_Write_Text(itoa(RELAY[i].R_enabled,buffer));
          UART1_Write_Text("  TRG:");
          UART1_Write_Text(itoa(RELAY[i].R_trig,buffer));
          UART1_Write_Text("  VAL:");
          UART1_Write_Text(itoa(RELAY[i].R_val,buffer));
          //sprintf(buffer,"%4f", RELAY[index].R_val);
          //UART1_Write_Text(buffer);

          UART1_Write_Text("  REL:");
          UART1_Write_Text(itoa(RELAY[i].R_relay,buffer));
          UART1_Write_Text("  TRH:");
          UART1_Write_Text(itoa(RELAY[i].R_tresh,buffer));
          //sprintf(buffer,"%4f", RELAY[index].R_tresh);
          //UART1_Write_Text(buffer);

          UART1_Write_Text("  STA:");
          UART1_Write_Text(itoa(RELAY[i].R_state,buffer));
          UART1_Write_Text("  S:");
          UART1_Write_Text(itoa(RELAY[i].R_start,buffer));
          UART1_Write_Text("  E:");
          UART1_Write_Text(itoa(RELAY[i].R_end,buffer));
          UART1_Write_Text("\r\n");
        }
        delay_ms(1000);
        clearReadLine();
        
        
        UART1_Write_Text("SYS");
        UART1_Write_Text(itoa(i,buffer));
        UART1_Write_Text("  MT:");
        UART1_Write_Text(itoa(System.measure_type,buffer));
        UART1_Write_Text("  CONN:");
        UART1_Write_Text(itoa(System.connection_type,buffer));
        UART1_Write_Text("  HOST:");
        UART1_Write_Text(System.host);
        UART1_Write_Text("  PORT:");
        UART1_Write_Text(itoa(System.tcp_port,buffer));
        UART1_Write_Text("  SSID:");
        UART1_Write_Text(System.ssid);
        UART1_Write_Text("  PW:");
        UART1_Write_Text(System.password);
        UART1_Write_Text("  PROT:");
        UART1_Write_Text(itoa(System.protocol,buffer));

     }
     
     
     if (DIPSW_2 == PRESSED){
        char buffer[5];
        int i;
        //while (DIPSW_1 == PRESSED);
        delay_ms(500);

        for (i=0;i<8;i++){
          UART1_Write_Text("ADC:");
          UART1_Write_Text(itoa(i,buffer));
          UART1_Write_Text("  SEC:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_sec,buffer));
          UART1_Write_Text("  DUR:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_dur,buffer));
          UART1_Write_Text("  MIL:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_mil,buffer));
          UART1_Write_Text("  SEC_B:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_sec_buffer,buffer));
          UART1_Write_Text("  DUR_B:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_dur_buffer,buffer));
          UART1_Write_Text("  MIL_B:");
          UART1_Write_Text(itoa(ADC_channel[i].ADC_mil_buffer,buffer));
          UART1_Write_Text("\r\n");

        }

        for (i=0;i<6;i++){

          UART1_Write_Text("REL:");
          UART1_Write_Text(itoa(i,buffer));
          UART1_Write_Text("  ENA:");
          UART1_Write_Text(itoa(RELAY[i].R_enabled,buffer));
          UART1_Write_Text("  TRG:");
          UART1_Write_Text(itoa(RELAY[i].R_trig,buffer));
          UART1_Write_Text("  VAL:");
          UART1_Write_Text(itoa(RELAY[i].R_val,buffer));
          //sprintf(buffer,"%4f", RELAY[index].R_val);
          //UART1_Write_Text(buffer);

          UART1_Write_Text("  REL:");
          UART1_Write_Text(itoa(RELAY[i].R_relay,buffer));
          UART1_Write_Text("  TRH:");
          UART1_Write_Text(itoa(RELAY[i].R_tresh,buffer));
          //sprintf(buffer,"%4f", RELAY[index].R_tresh);
          //UART1_Write_Text(buffer);

          UART1_Write_Text("  STA:");
          UART1_Write_Text(itoa(RELAY[i].R_state,buffer));
          UART1_Write_Text("  S:");
          UART1_Write_Text(itoa(RELAY[i].R_start,buffer));
          UART1_Write_Text("  E:");
          UART1_Write_Text(itoa(RELAY[i].R_end,buffer));
          UART1_Write_Text("\r\n");
        }
        delay_ms(1000);
        clearReadLine();

     }
              */
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

        // Run this procedure every minute
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
                                  //RELAY[pos].R_val_buffer = RELAY[pos].R_val - RELAY[pos].R_tresh;
                                  RELAY[pos].R_current_state = 0;
                                  switchRelay(pos, 1, measured_value);


                                  RELAY[pos].R_flag_1 = 0;
                                  
                              } else {
                                  if (RELAY[pos].R_flag_1 == 0){
                                      //RELAY[pos].R_current_state = 1;
                                      switchRelay(pos, 0, measured_value);
                                      //notify(pos,measured_value);
                                      RELAY[pos].R_flag_1 = 1;
                                  }
                              }
                          } else {

                              if ( RELAY[pos].R_val_buffer > measured_value){

                                  RELAY[pos].R_trs_2 = RELAY[pos].R_tresh;
                                  //RELAY[pos].R_val_buffer = RELAY[pos].R_val + RELAY[pos].R_tresh;
                                  RELAY[pos].R_current_state = 1;
                                  switchRelay(pos, 0, measured_value);

                                  
                                  RELAY[pos].R_flag_2 = 0;
                                  
                              } else {
                                  if (RELAY[pos].R_flag_2 == 0){
                                      switchRelay(pos, 1, measured_value);
                                      //RELAY[pos].R_current_state = 0;
                                      //notify(pos,measured_value);
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
                // Measure Battery charge
                //System.battery_voltage_buffer[System.g_index] = ADC_Read(BATTERY_PORT);

                // To get precise measurement, we have to count avrage
             /*   if (++System.g_index == sizeof(System.battery_voltage_buffer)){
                   int sum,i;
                   for (i=0;i<sizeof(System.battery_voltage_buffer);i++){
                       sum += System.battery_voltage_buffer[i];
                   }
                   System.battery_voltage = sum / sizeof(System.battery_voltage_buffer);
                }

                // Power out detect
                if (isPowerOut == TRUE){
                   if (System.network_status == CONNECTED){
                      // Send POWEROUT Command to Server

                   }
                }

                System.milisecondBuffer_2 = SystemTime.mils;    */


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

     // Single IP connection
     UART1_Write_Text("AT+CIPMUX=1\r\n");
     waitForInput("OK",2);

     // AT+CIPSTART    Connect to server , replace variables
     clearReadLine();

     UART1_Write_Text("AT+CIPSTART=0,\"");
     UART1_Write_Text("TCP");
     UART1_Write_Text("\",\"");
     UART1_Write_Text(System.host);
     UART1_Write_Text("\",");
     UART1_Write_Text(itoa(System.tcp_port,conv));
     UART1_Write_Text("\r\n");


     if (waitForInput("OK",10) == 1){
     // Send HELLO to SERVER
        System.network_status = CONNECTED;
        
        init_network_environment();
        /*if (strstr(System.identifier,"null") != 0){
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
        getSystemTime();  */

     } else {
        System.network_status = IDLE;
        return FALSE;
     }
     return TRUE;
}

short create_server(){

     UART1_Write_Text("AT+SLEEP=0\r\n");
     waitForInput("OK",3);
     // AT+CWMODE = 1  HOTSPOT Mode
     UART1_Write_Text("AT+CWMODE=2\r\n");
     waitForInput("OK",2);
     // Single IP connection
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

     // Create server on port 8080
     UART1_Write_Text("AT+CIPSERVER=1,8080\r\n");

     if (waitForInput("OK",2)) {
        // Server created
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

     setup_pic();        // Registers, interfaces

     default_config();   // Set the default config

     read_config();      // Rewrite default CONFIG with SD card cfg, if there is any

}

// Start main at address 64888 for bootloader
void main() org 64888{

setup();                        // Setup the whole environment

while (1) {

      networking();             // Setup wifi module, connect to SERVER/ create SERVER

      measure_sensors();        // Measure sensors

      process_io();             // TCP communication, commands

      system_processes();       // Battery, DIP switch, power out detect
      
      if (System.isInput_2_Ready == TRUE){
          System.isInput_2_Ready = FALSE;

          Susart_Init(51);                    // Init USART at 9600
          if (Susart_Write_Loop('g','r')) {   // Send 'g' for ~5 sec, if 'r'
            Start_Bootload();                 //   received start bootload
          }
          else {
            Start_Program();                  //   else start program
          }
      }

}

}