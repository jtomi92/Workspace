#include "Hcm.h" //include the declaration for this class

#define SIM_PWR 40
#define ESP_PWR 41
#define WS28_DATA 42
#define VCC_DETECT 43

#define CS1 13
#define CS2 14
#define CS3 15
#define CS4 16	

#define DETECT_0 21
#define DETECT_1 22
#define DETECT_2 23
#define DETECT_3 24

#define EEPROM_SIZE 4096

#define TRUE 1
#define FALSE 0


const char HAS_WIFI = 1;
const char HAS_GPRS = 1;
const char HAS_GSM = 1;

const char SERVER_CONNECTED = 1;
const char WIFI_CONNECTED = 1;
const char GPRS_CONNECTED = 1;
const char RECONNECT_TIMER = 30;

const char WIFI = 1;
const char GPRS = 0;

const int DAYS_OF_MONTH[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

char interface;	

NETWORK __network_data;
SYSTIME __system_time;
SYSTEM_VARIABLES __system_var;




void default_settings(const char *NETWORK_SSID,const  char *NETWORK_PASSW,const  char *NETWORK_HOST,const  char *NETWORK_PORT,const  char *NETWORK_APN) {

  __system_time._year = 0;
  __system_time._month = 0;
  __system_time._day = 0;
  __system_time._hour = 0;
  __system_time._min = 0;
  __system_time._sec = 0;
  __system_time._mils = 0;
  
  __system_var.relay_modules[0] = 0;
  __system_var.relay_modules[1] = 0;
  __system_var.relay_modules[2] = 0;
  __system_var.relay_modules[3] = 0;

  strcpy(__network_data.host, NETWORK_HOST);
  strcpy(__network_data.port, NETWORK_PORT);
  strcpy(__network_data.ssid, NETWORK_SSID);
  strcpy(__network_data.password, NETWORK_PASSW);
  strcpy(__network_data.apn, NETWORK_APN);

  __network_data.isWifiConnected = FALSE;
  __network_data.isGprsConnected = FALSE;
  __network_data.isServerConnected = FALSE;

  memset(__network_data.wifi_readLine, 0, sizeof(__network_data.wifi_readLine));
  memset(__network_data.gprs_readLine, 0, sizeof(__network_data.gprs_readLine));
  __network_data.is_wifi_input_ready = FALSE;
  __network_data.is_gprs_input_ready = FALSE;
  __network_data.index_wifi = 0;
  __network_data.index_gprs = 0;

  __system_time.connection_timer_buffer = 0;;
  __system_time.connection_timer = 0;

  memset(__system_var.serial_number, 0, sizeof(__system_var.serial_number));
  memset(__system_var.admin_user, 0, sizeof(__system_var.admin_user));

}



Hcm::Hcm(const char *NETWORK_SSID,const  char *NETWORK_PASSW,const  char *NETWORK_HOST,const  char *NETWORK_PORT,const  char *NETWORK_APN){
	default_settings(NETWORK_SSID, NETWORK_PASSW, NETWORK_HOST, NETWORK_PORT, NETWORK_APN);
	
	pinMode(SIM_PWR,OUTPUT);
	pinMode(ESP_PWR,OUTPUT);
	pinMode(WS28_DATA,OUTPUT);
	pinMode(VCC_DETECT,INPUT);
	pinMode(CS1,OUTPUT);
	pinMode(CS2,OUTPUT);
	pinMode(CS3,OUTPUT);
	pinMode(CS4,OUTPUT);
	pinMode(DETECT_0,INPUT);
	pinMode(DETECT_1,INPUT);
	pinMode(DETECT_2,INPUT);
	pinMode(DETECT_3,INPUT);
	
	digitalWrite(CS1,LOW);
	digitalWrite(CS2,LOW);
	digitalWrite(CS3,LOW);
	digitalWrite(CS4,LOW);
	
}


int get_module_relay_count(int module){
	
	digitalWrite(CS1,LOW);
	digitalWrite(CS2,LOW);
	digitalWrite(CS3,LOW);
	digitalWrite(CS4,LOW);
	
	switch (module){
		
		case 1:digitalWrite(CS1,HIGH);
		break;
		
		case 2:digitalWrite(CS1,HIGH);
		break;
		
		case 3:digitalWrite(CS1,HIGH);
		break;
		
		case 4:digitalWrite(CS1,HIGH);
		break;
	}
	
}

void Hcm::discover_relay_modules(){
	
	__system_var.module_connected[0] = digitalRead(DETECT_0);
	__system_var.module_connected[1] = digitalRead(DETECT_1);
	__system_var.module_connected[2] = digitalRead(DETECT_2);
	__system_var.module_connected[3] = digitalRead(DETECT_3);
		
	if (__system_var.module_connected[0] == 1){
		__system_var.relay_modules[0] = get_module_relay_count(0);	
	}
	if (__system_var.module_connected[1] == 1){
		__system_var.relay_modules[1] = get_module_relay_count(1);
	}
	if (__system_var.module_connected[2] == 1){
		__system_var.relay_modules[2] = get_module_relay_count(2);
	}
	if (__system_var.module_connected[3] == 1){
		__system_var.relay_modules[3] = get_module_relay_count(3);
	}
	
	
	
}


void system_clock(){

     __system_time._mils++;

     // Clock buffer for sensors

     if (__system_time._mils == 1000){
         __system_time._sec++;
         __system_time._mils = 0;
         if (__system_time.connection_timer_buffer <= __system_time.connection_timer){
             __system_time.connection_timer_buffer++;
         }
     }
     if (__system_time._sec == 60){
         __system_time._min++;
         __system_time._sec = 0;
     }
     if (__system_time._min == 60){
         __system_time._hour++;
         __system_time._min = 0;
     }
     if (__system_time._hour == 24){
         __system_time._day++;
         __system_time._hour = 0;
     }
	 if (__system_time._day == DAYS_OF_MONTH[__system_time._month]){
         __system_time._month++;
         __system_time._day = 0;
     }
     if (__system_time._month == 12){
         __system_time._year++;
         __system_time._month = 0;
     }

}


void Hcm::process_io(){
	
	if (strstr(__network_data.wifi_readLine, "") != 0){
		
	}
	
}
void Hcm::system_processes(){
	
	__system_var.module_connected[0] = digitalRead(DETECT_0);
	__system_var.module_connected[1] = digitalRead(DETECT_1);
	__system_var.module_connected[2] = digitalRead(DETECT_2);
	__system_var.module_connected[3] = digitalRead(DETECT_3);
}




void serialEvent1(){

    while(Serial.available()){          // test the interrupt for uart rx

            if (__network_data.index_wifi >= sizeof(__network_data.wifi_readLine)-3){
                // To stop buffer from overfloating
                __network_data.index_wifi = 0;
            }

            __network_data.wifi_readLine[__network_data.index_wifi] = Serial.read();

            if (__network_data.wifi_readLine[__network_data.index_wifi] == '\n' ||
                __network_data.wifi_readLine[__network_data.index_wifi] == '\0' ||
                __network_data.wifi_readLine[__network_data.index_wifi] == '\r' ) {
                // If \r or \0 is read, we got something, so process it, triggers process_io procedure
                __network_data.is_wifi_input_ready = TRUE;
                __network_data.wifi_readLine[__network_data.index_wifi+1] = '\0';
            }

            __network_data.index_wifi++;
    }
}

void serialEvent2(){
     while(Serial1.available()){

           if (__network_data.index_gprs >= sizeof(__network_data.gprs_readLine)-3){
                // To stop buffer from overfloating
                __network_data.index_gprs = 0;
            }

            __network_data.gprs_readLine[__network_data.index_gprs] = Serial1.read();

            if (__network_data.gprs_readLine[__network_data.index_gprs] == '\n' ||
                __network_data.gprs_readLine[__network_data.index_gprs] == '\0' ||
                __network_data.gprs_readLine[__network_data.index_gprs] == '\r' ) {
                // If \r or \0 is read, we got something, so process it, triggers process_io procedure
                __network_data.is_gprs_input_ready = TRUE;
                __network_data.gprs_readLine[__network_data.index_gprs+1] = '\0';
            }

            __network_data.index_gprs++;
    }
}



void Hcm::setup_interrupts(){
	
  Timer1.initialize(1000); // 1ms
  Timer1.attachInterrupt(system_clock);
}



void Hcm::read_network_settings() {
 
  int i, j = 0;
  char dat, flag = 0, buffer[100];
  for (i = 0; i < EEPROM_SIZE; i++) {

    if (dat == '#') {
      flag = !flag;
    }
    dat = EEPROM.read(i);

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


void clear_read_line() {
  int i;

  if (interface == WIFI) {
    memset(__network_data.wifi_readLine, 0, sizeof(__network_data.wifi_readLine) - 1);
    __network_data.is_wifi_input_ready = 0;
    __network_data.index_wifi = 0;
  }
  if (interface == GPRS) {
    memset(__network_data.gprs_readLine, 0, sizeof(__network_data.gprs_readLine) - 1);
    __network_data.is_gprs_input_ready = 0;
    __network_data.index_gprs = 0;
  }
}
 

char readSingleByte() {
  if (interface == WIFI) {
    return Serial.read();
  }
  if (interface == GPRS) {
    return Serial1.read();
  }
}

char isDataReady() {
  if (interface == WIFI) {
    return Serial.available();
  }
  if (interface == GPRS) {
    return Serial1.available();
  }
}


int readUntil(char *input, int timeout) {


  int i = 0; int mils = 0;
  char buffer[30];
  memset(buffer, '\0', sizeof(buffer) - 1);

  while (mils <= timeout * 1000) {
    if (isDataReady()) {
      if (i == 30) i = 0;
      buffer[i++] = readSingleByte();
      if (strstr(buffer, input) != 0) {
        return 1;
      }
    } else {
      mils++;
      delay(1);
    }
  }

  return 0;
}

void cipsend(char *p) {
  char conv[5];

  if (interface == WIFI) {
    int size = 0;
    char *b = p;
    for (; *b++ != '\0'; size++) ;

    Serial.write("AT+CIPSEND=0,");
    Serial.write(itoa(size, conv, 10));
    Serial.write("\r\n");
  } else {
    Serial1.write("AT+CIPSEND\r");
  }
	
  if (readUntil(">", 2) == 0) {
    __network_data.isServerConnected = !SERVER_CONNECTED;
    __network_data.isWifiConnected = FALSE;
    __network_data.isGprsConnected = FALSE;
  }

  if (interface == WIFI) {
    Serial.write(p);
  } else {
    Serial1.write(p);
    Serial1.write(26);
    Serial1.write(0x0D);
  }

}

void getSystemTime() {
  char *p;
  short i = 0;
  clear_read_line();
  

  cipsend("GETTIME\n");
  readUntil("TIME", 15);
  delay(300);

  //YY;MM;DD;HH;MM;SS;
  //p = strtok(__network_data.wifi_readLine, ";");
  while (p != 0) {
    switch (i) {
      case 1: __system_time._year = atoi(p); break;
      case 2: __system_time._month = atoi(p); break;
      case 3: __system_time._day = atoi(p); break;
      case 4: __system_time._hour = atoi(p); break;
      case 5: __system_time._min = atoi(p);  break;
      case 6: __system_time._sec = atoi(p); break;
    }
    i++;
    p = strtok(0, ";");
  }

  cipsend("TIME OK\n");
  readUntil("OK", 2);

  clear_read_line();
}


void setSerialNumber() {

	
  if (strstr(__network_data.wifi_readLine, "SERIAL_NUMBER") != 0) {
    char *p;
    short i;
    p = strtok(__network_data.wifi_readLine, ";");
    p = strtok(0, ";");

    strcpy(__system_var.serial_number, p);
    p = 0;

    cipsend("ID OK\n");
    readUntil("OK", 2);

    clear_read_line();
  }
}


void checkSerialNumber() {

  if (strstr(__system_var.serial_number, "null") != 0) {
    clear_read_line();
    cipsend("REQUEST_SERIAL_NUMBER\n");
    readUntil("SERIAL_NUMBER", 15);
    delay(100);
    setSerialNumber();
  } else {
    char buffer[15];
    strcpy(buffer, "ID;");
    strcat(buffer, __system_var.serial_number);
    strcat(buffer, ";\n");

    cipsend(buffer);
    readUntil("OK", 2);
  }
}


char connectToWifi(char *ssid, char *password) {

  Serial.write("AT+SLEEP=2\r\n");
  readUntil("OK", 3);

  Serial.write("AT+CWMODE=1\r\n");
  readUntil("OK", 3);
  Serial.write("AT+CWJAP=\"");
  Serial.write(ssid);
  Serial.write("\",\"");
  Serial.write(password);
  Serial.write("\"\r\n");
  if (readUntil("OK", 10)) {
    return TRUE;
  } else {
    return FALSE;
  }
}


char connectToGprs(char *apn) {

  char conv[5];

  Serial1.write("AT+CIPSHUT\r");
  readUntil("OK", 10);

  Serial1.write("AT+CGATT=1\r");
  readUntil("OK", 10);

  Serial1.write("AT+CGDCONT=1,\"IP\",\"");
  Serial1.write(apn);
  Serial1.write("\"\r");
  readUntil("OK", 10);

  Serial1.write("AT+CSTT=\"");
  Serial1.write(apn);
  Serial1.write("\",\"\",\"\"\r");
  readUntil("OK", 10);

  Serial1.write("AT+CIICR\r\n");

  if (readUntil("OK", 10)) {
    return TRUE;
  } else {
    return FALSE;
  }

  //UART2_Write_Text("AT+CIFSR\r");
  //readUntil("OK",10,GPRS);
}


char connectToServer(char *host, char *port) {

  char conv[5];

  if (interface == WIFI) {
    // Single IP connection
    Serial.write("AT+CIPMUX=1\r\n");
    readUntil("OK", 2);
  }

  // AT+CIPSTART    Connect to server , replace variables
  clear_read_line();

  if (interface == WIFI) {
    Serial.write("AT+CIPSTART=0,\"TCP\",\"");
    Serial.write(host);
    Serial.write("\",");
    Serial.write(port);
    Serial.write("\r\n");
  }
  if (interface == GPRS) {
    Serial1.write("AT+CIPSTART=\"TCP\",\"");
    Serial1.write(host);
    Serial1.write("\",\"");
    Serial1.write(port);
    Serial1.write("\"\r");
  }

  if (readUntil("OK", 10) == 1) {
    // Send HELLO to SERVER
    //__network_data.isServerConnected = TRUE;

    checkSerialNumber();
	getSystemTime();
    return TRUE;

  } else {

    //__network_data.isServerConnected = FALSE;
    return FALSE;
  }

}

 

void Hcm::networking() {
  

  if (__system_time.connection_timer_buffer <= __system_time.connection_timer) {

    if ( __network_data.isServerConnected != SERVER_CONNECTED ) {

      __network_data.isWifiConnected = connectToWifi(__network_data.ssid, __network_data.password);

      if (!__network_data.isWifiConnected) {
        __network_data.isGprsConnected = connectToGprs(__network_data.apn);
      }

      if (__network_data.isWifiConnected) {
		interface = WIFI;
        connectToServer(__network_data.host, __network_data.port);
      }
      if (__network_data.isGprsConnected) {
		interface = GPRS;
        connectToServer(__network_data.host, __network_data.port);
      }

      if (!__network_data.isGprsConnected && !__network_data.isWifiConnected) {
        if (__system_time.connection_timer <= 600) __system_time.connection_timer += 20;
      }

    }
    __system_time.connection_timer = 0;
  }
}