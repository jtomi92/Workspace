#include <eeprom_utils.h>



#include <EEPROM.h>
#include <Adafruit_ESP8266.h>
#include <SoftwareSerial.h>

#define ESP_PWR 10
#define SIM_PWR 11
#define VCC_DETECT 12
#define RELAY_SIZE 1
#define INPUT_SIZE 2
#define EEPROM_SIZE 4096
#define TRUE 1
#define FALSE 0

#define ESP_RX   2
#define ESP_TX   3
#define ESP_RST  4

const char PRODUCT_NAME[] = "HCM-R9-I0";

const int  RELAY_PINS[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
const char INPUT_PINS[] = {};

const char HAS_WIFI = 1;
const char HAS_GPRS = 1;
const char HAS_GSM = 1;

const char NETWORK_SSID[] = "Tardis";
const char NETWORK_PASSW[] = "77Ld7cr7dW";
const char NETWORK_HOST[] = "192.168.0.5";
const char NETWORK_PORT[] = "85";
const char NETWORK_APN[] = "online";

const char SERVER_CONNECTED = 1;
const char WIFI_CONNECTED = 1;
const char GPRS_CONNECTED = 1;
const char RECONNECT_TIMER = 30;

const char WIFI = 1;
const char GPRS = 0;


const int DAYS_OF_MONTH[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

typedef struct {                  //NETWORK
  char host[30];
  char port[5];
  char ssid[20];
  char password[20];
  char apn[10];

  char isWifiConnected;
  char isGprsConnected;
  char isServerConnected;

  char wifi_readLine[100];
  char gprs_readLine[200];
  char is_wifi_input_ready;
  char is_gprs_input_ready;
  int index_wifi;
  int index_gprs;

} NETWORK_;


typedef struct {
  char pin;
  char state;
  int start_timer;
  int end_timer;
  int _delay;
  int delay_enabled;
  int timer_enabled;
} RELAY_;

typedef struct {
  char pin;
  int start_timer;
  int end_timer;
  int sample_rate;
  int timer_enabled;
} INPUT_;

typedef struct {
  char input_id;
  char relay_id;
  char trigger_enabled;
  char trigger_value;
  char trigger_state;
  char* trigger_action;
} TRIGGER_;


typedef struct {                  //SYSTIME

  int year_;
  int month_;
  int day_;
  int hour_;
  int min_;
  int sec_;
  int mils_;

} SYSTIME_;

typedef struct {                  //SYS
  char manufacturer_number[10];
  char admin_user[15];
} SYS_;

typedef struct {                  //TIMERS

  int connection_timer;
  int connection_timer_buffer;

} TIMER_;

RELAY_ relays[sizeof(RELAY_PINS)];
INPUT_ inputs[sizeof(INPUT_PINS)];
TRIGGER_ trigger;
NETWORK_ network_data;
SYS_ System;
SYSTIME_ SystemTime;
TIMER_ Timer;


char read_single_byte(char interface) {
  if (interface == WIFI_CONNECTED) {
    return Serial.read();
  }
  if (interface == GPRS_CONNECTED) {
    return Serial1.read();
  }
}

char is_data_ready(char interface) {
  if (interface == WIFI_CONNECTED) {
    return Serial.available();
  }
  if (interface == GPRS_CONNECTED) {
    return Serial1.available();
  }
}


void clear_read_line(char interface) {
  int i;

  if (interface == WIFI_CONNECTED) {
    memset(network_data.wifi_readLine, 0, sizeof(network_data.wifi_readLine) - 1);
    network_data.is_wifi_input_ready = 0;
    network_data.index_wifi = 0;
  }
  if (interface == GPRS_CONNECTED) {
    memset(network_data.gprs_readLine, 0, sizeof(network_data.gprs_readLine) - 1);
    network_data.is_gprs_input_ready = 0;
    network_data.index_gprs = 0;
  }
}


int wait_for_input(char *input, int timeout, char interface) {

  int i = 0; int mils = 0;
  char buffer[30];
  memset(buffer, '\0', sizeof(buffer) - 1);

  while (mils <= timeout * 1000) {
    if (is_data_ready(interface)) {
      if (i == 30) i = 0;
      buffer[i++] = read_single_byte(interface);
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

char * itoa(int i, char b[]) {
  char const digit[] = "0123456789";
  char* p = b;
  int shifter;
  if (i < 0) {
    *p++ = '-';
    i *= -1;
  }
  shifter = i;
  do { //Move to where representation ends
    ++p;
    shifter = shifter / 10;
  } while (shifter);
  *p = '\0';
  do { //Move back, inserting digits as u go
    *--p = digit[i % 10];
    i = i / 10;
  } while (i);
  return b;
}



void cipsend(char *p, char interface) {
  char conv[5];

  if (interface == WIFI_CONNECTED) {
    int size = 0;
    char *b = p;
    for (; *b++ != '\0'; size++) ;

    Serial.write("AT+CIPSEND=0,");
    Serial.write(itoa(size, conv));
    Serial.write("\r\n");
  } else {
    Serial1.write("AT+CIPSEND\r");
  }

  if (wait_for_input(">", 2, interface) == 0) {
    network_data.isServerConnected = !SERVER_CONNECTED;
    network_data.isWifiConnected = FALSE;
    network_data.isGprsConnected = FALSE;
  }

  if (interface == WIFI_CONNECTED) {
    Serial.write(p);
  } else {
    Serial1.write(p);
    Serial1.write(26);
    Serial1.write(0x0D);
  }
}


int is_admin(char *phone_number) {
  int i, j = 0, flag = 0;
  char read[27], dat;

  for (i = 0; i < EEPROM_SIZE; i++) {

    dat = EEPROM.read(i);
    if (dat == '#') {
      flag = !flag;
    }

    if (flag == 1) {
      read[j++] = dat;
    } else {
      if (j > 0) {
        read[j++] = '#';
        read[j] = '\0';

        if ( strstr(read, phone_number) != 0 && strstr(read, "ADMIN") != 0 ) {
            return TRUE;
        } else {
          j = 0;
          memset(read, 0, sizeof(read) - 1);
        }
      }
    }
  }
  return FALSE;
}


int verify_relay_access(char *phone_number, char relay, char isCall) {
  int i, j = 0, flag = 0;
  char read[27], dat;

  relay--;

  for (i = 0; i < EEPROM_SIZE; i++) {

    dat = EEPROM.read(i);
    if (dat == '#') {
      flag = !flag;
    }

    if (flag == 1) {
      read[j++] = dat;
    } else {
      if (j > 0) {
        read[j++] = '#';
        read[j] = '\0';

        if ( strstr(read, phone_number) != 0 ) {

          char *p1, config[10];
          p1 = strtok(read, ";");
          p1 = strtok(0, ";");
          strcpy(config, p1);

          if (isCall) {
            int rel = atoi(strtok(0, "#"));
            printf("%d %s\n",rel,config);
            if (config[rel-1] == '1')
              return rel;
            else
              return 0;
          }
          printf("%d %s\n",relay,config);

          if (config[relay] == '0' || config[relay] == '1'){
            return config[relay] - '0';
          } else {
            return 0;
          }
        } else {
          j = 0;
          memset(read, 0, sizeof(read) - 1);
        }
      }
    }
  }
  return FALSE;
}



void build_user_config_string(char *buffer, char *relay_access, char *relay_call) {
  char *p1;
  int size = 0, i;
  p1 = relay_access;
  for (; *p1++ != '\0'; size++);
  if (size > RELAY_SIZE) size = RELAY_SIZE;


  *buffer++ = ';';

  for (i = 0; i < size; i++) {
    char ch = *relay_access++;
    if (ch == '0' || ch == '1') {
      *buffer++ = ch;
    } else {
      *buffer++ = '0';
    }
  }

  for (i = size; i < RELAY_SIZE; i++) {
    *buffer++ = '0';
  }
  *buffer++ = ';';
  if (atoi(relay_call) <= RELAY_SIZE && atoi(relay_call) != 0) {
    *buffer++ = *relay_call;
  } else {
    *buffer++ = '0';
  }
  *buffer++ = '#';
  *buffer = '\0';
}

char add_user(char *phone_number, char* privilige, char *relay_access, char *relay_call) {
  int i, j = 0, flag = 0;
  char to_write[27];
  unsigned char dat;


  for (i = 0; i < EEPROM_SIZE; i++) {

    dat = EEPROM.read(i);
    if (dat == '#') {
      flag = !flag;
    }

    if (flag == 1) {
      to_write[j++] = dat;
    } else {
      if (j > 0) {
        if (  strstr(to_write, privilige) != 0 && strstr(to_write, phone_number) != 0 ) {
          return FALSE;
        } else {
          j = 0;
          memset(to_write, 0, sizeof(to_write) - 1);
        }
      }
    }
  }

  char *cfg, buffer[14];
  int k;
  char enough_space = 0;

  build_user_config_string(buffer, relay_access, relay_call);
  strcpy(to_write, "#");
  strcat(to_write, privilige);
  strcat(to_write, ":");
  strcat(to_write, phone_number);
  strcat(to_write, buffer);

  for (i = 0; i < EEPROM_SIZE; i++) {

    dat = EEPROM.read(i);

    if (dat == 254) {
      enough_space++;
    } else {
      enough_space = 0;
    }
    if (enough_space == strlen(to_write)) {
      break;
    }
  }
  if (i == EEPROM_SIZE) {
    return FALSE;
  }

  i = i - strlen(to_write);
  for (k = 0; k < strlen(to_write); k++) {
    EEPROM.write(i++, to_write[k]);
  }
  return TRUE;

}



int remove_user(char *phone_number, char *privilige) {
  int i, j = 0, flag = 0;
  char read[27];
  unsigned char dat;
  for (i = 0; i < EEPROM_SIZE; i++) {

    dat = EEPROM.read(i);
    if (dat == '#') {
      flag = !flag;
    }

    if (flag == 1) {
      read[j++] = dat;
    } else {
      if (j > 0) {
        read[j++] = '#';
        read[j] = '\0';

        if ( strstr(read, privilige) != 0 && strstr(read, phone_number) != 0 ) {
          int k;
          for (k = i - strlen(read) + 1; k <= i; k++) {
            EEPROM.write(k, 254);
          }
          return TRUE;
        } else {
          j = 0;
          memset(read, 0, sizeof(read) - 1);
        }
      }
    }

    if (dat == 254) {
      return FALSE;
    }
  }
  return FALSE;
}


void read_settings() {
  int i, j = 0, pos = 0;
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
          strcpy(network_data.host, p1);
          //printf("host:%s\n",p1);

          p1 = strtok(0, ";");
          strcpy(network_data.port, p1);
          //printf("port:%s\n",p1);

          p1 = strtok(0, ";");
          strcpy(network_data.ssid, p1);
          //printf("ssid:%s\n",p1);

          p1 = strtok(0, ";");
          strcpy(network_data.password, p1);
          //printf("password:%s\n",p1);

          p1 = strtok(0, ";");
          strcpy(network_data.apn, p1);
          //printf("apn:%s\n\n",p1);


        } else if (strstr(p1, "RS") != 0) {

          int position = *(p1 + 3) - 1;
          //printf("RELAY:%c\n",position);
          p1 = strtok(0, ";");
          relays[position].start_timer = atoi(p1);
          //printf("start timer:%s - %d\n",p1,relays[position].start_timer);

          p1 = strtok(0, ";");
          relays[position].end_timer = atoi(p1);
          //printf("end timer:%s - %d\n",p1,relays[position].end_timer);

          p1 = strtok(0, ";");
          relays[position]._delay = atoi(p1);
          //printf("delay:%s - %d\n",p1,relays[position]._delay);

          p1 = strtok(0, ";");
          relays[position].delay_enabled = (*p1 == 'Y');
          //printf("delay enabled:%s - %d\n",p1, relays[position].delay_enabled);

          p1 = strtok(0, ";");
          relays[position].timer_enabled = (*p1 == 'Y');
          //printf("timer enabled:%s - %d\n\n",p1,relays[position].timer_enabled);

        } else if (strstr(p1, "IS") != 0) {

          int position = *(p1 + 3) - 1;
          //printf("INPUT:%c\n",position);

          p1 = strtok(0, ";");
          inputs[position].start_timer = atoi(p1);
          //printf("start timer:%s - %d\n",p1,inputs[position].start_timer);

          p1 = strtok(0, ";");
          inputs[position].end_timer = atoi(p1);
          //printf("end timer:%s - %d\n",p1,inputs[position].end_timer);

          p1 = strtok(0, ";");
          inputs[position].sample_rate = atoi(p1);
          //printf("sample rate:%s - %d\n\n",p1,inputs[position].sample_rate);

        }

        pos++;
        j = 0;

      }
    }
  }
}


void process_wifi_io() {

}

void process_gprs_io() {

}

void process_gsm_io() {

}

void process_io() {

  if (network_data.isServerConnected) {

    if (network_data.isWifiConnected && network_data.is_wifi_input_ready) {
      process_wifi_io();
      network_data.is_wifi_input_ready = FALSE;
      clear_read_line(WIFI);
    }

    if (network_data.isGprsConnected && network_data.is_gprs_input_ready) {
      process_gprs_io();
      network_data.is_gprs_input_ready = FALSE;
      clear_read_line(GPRS);
    }
  }
  process_gsm_io();
}



void get_system_time(char interface) {
  char *p;
  short i = 0;
  clear_read_line(interface);


  cipsend("GETTIME\n", interface);
  wait_for_input("TIME", 15, interface);
  delay(300);

  //YY;MM;DD;HH;MM;SS;
  p = strtok(network_data.wifi_readLine, ";");
  while (p != 0) {
    switch (i) {
      case 1: SystemTime.year_ = atoi(p); break;
      case 2: SystemTime.month_ = atoi(p); break;
      case 3: SystemTime.day_ = atoi(p); break;
      case 4: SystemTime.hour_ = atoi(p); break;
      case 5: SystemTime.min_ = atoi(p);  break;
      case 6: SystemTime.sec_ = atoi(p); break;
    }
    i++;
    p = strtok(0, ";");
  }

  cipsend("TIME OK\n", interface);
  wait_for_input("OK", 2, interface);

  clear_read_line(interface);
}


void set_serial_number(char interface) {

  if (strstr(network_data.wifi_readLine, "SERIAL_NUMBER") != 0) {
    char *p;
    short i;
    p = strtok(network_data.wifi_readLine, ";");
    p = strtok(0, ";");

    strcpy(System.manufacturer_number, p);
    p = 0;

    cipsend("ID OK\n", interface);
    wait_for_input("OK", 2, interface);

    clear_read_line(interface);
  }
}


void get_serial_number(char interface) {

  if (strstr(System.manufacturer_number, "null") != 0) {
    clear_read_line(interface);

    cipsend("REQUEST_SERIAL_NUMBER\n", interface);

    wait_for_input("SERIAL_NUMBER", 15, interface);
    delay(100);
    set_serial_number(interface);

  } else {
    char buffer[15];
    strcpy(buffer, "ID;");
    strcat(buffer, System.manufacturer_number);
    strcat(buffer, ";\n");

    cipsend(buffer, interface);
    wait_for_input("OK", 2, interface);
  }
  get_system_time(interface);
}


char connect_to_wifi() {

  Serial.write("AT+SLEEP=2\r\n");
  wait_for_input("OK", 3, WIFI);

  Serial.write("AT+CWMODE=1\r\n");
  wait_for_input("OK", 3, WIFI);
  Serial.write("AT+CWJAP=\"");
  Serial.write(network_data.ssid);
  Serial.write("\",\"");
  Serial.write(network_data.password);
  Serial.write("\"\r\n");
  if (wait_for_input("OK", 10, WIFI)) {
    return TRUE;
  } else {
    return FALSE;
  }
}


char connect_to_gprs() {

  char conv[5];

  Serial1.write("AT+CIPSHUT\r");
  wait_for_input("OK", 10, GPRS);

  Serial1.write("AT+CGATT=1\r");
  wait_for_input("OK", 10, GPRS);

  Serial1.write("AT+CGDCONT=1,\"IP\",\"");
  Serial1.write(network_data.apn);
  Serial1.write("\"\r");
  wait_for_input("OK", 10, GPRS);

  Serial1.write("AT+CSTT=\"");
  Serial1.write(network_data.apn);
  Serial1.write("\",\"\",\"\"\r");
  wait_for_input("OK", 10, GPRS);

  Serial1.write("AT+CIICR\r\n");

  if (wait_for_input("OK", 10, GPRS)) {
    return TRUE;
  } else {
    return FALSE;
  }

  //UART2_Write_Text("AT+CIFSR\r");
  //wait_for_input("OK",10,GPRS);
}


char connect_to_server(char interface) {

  char conv[5];

  if (interface == WIFI) {
    // Single IP connection
    Serial.write("AT+CIPMUX=1\r\n");
    wait_for_input("OK", 2, interface);
  }

  // AT+CIPSTART    Connect to server , replace variables
  clear_read_line(interface);

  if (interface == WIFI) {
    Serial.write("AT+CIPSTART=0,\"TCP\",\"");
    Serial.write(network_data.host);
    Serial.write("\",");
    Serial.write(network_data.port);
    Serial.write("\r\n");
  }
  if (interface == GPRS) {
    Serial1.write("AT+CIPSTART=\"TCP\",\"");
    Serial1.write(network_data.host);
    Serial1.write("\",\"");
    Serial1.write(network_data.port);
    Serial1.write("\"\r");
  }

  if (wait_for_input("OK", 10, interface) == 1) {
    // Send HELLO to SERVER
    network_data.isServerConnected = TRUE;

    get_serial_number(interface);
    return TRUE;

  } else {

    network_data.isServerConnected = FALSE;
    return FALSE;
  }

}


void networking() {

  if (Timer.connection_timer_buffer <= Timer.connection_timer) {

    if ( network_data.isServerConnected != SERVER_CONNECTED ) {

      network_data.isWifiConnected = connect_to_wifi();

      if (!network_data.isWifiConnected) {
        network_data.isGprsConnected = connect_to_gprs();
      }

      if (network_data.isWifiConnected) {
        connect_to_server(WIFI);
      }
      if (network_data.isGprsConnected) {
        connect_to_server(GPRS);
      }

      if (!network_data.isGprsConnected && !network_data.isWifiConnected) {
        if (Timer.connection_timer <= 600) Timer.connection_timer += 20;
      }

    }
    Timer.connection_timer = 0;
  }
}



void wifi_serial_interrupt() {

  // if (PIR1.RCIF ) {          // test the interrupt for uart rx

  if (network_data.index_wifi >= sizeof(network_data.wifi_readLine) - 3) {
    // To stop buffer from overfloating
    network_data.index_wifi = 0;
  }

  network_data.wifi_readLine[network_data.index_wifi] = Serial.read();

  if (network_data.wifi_readLine[network_data.index_wifi] == '\n' ||
      network_data.wifi_readLine[network_data.index_wifi] == '\0' ||
      network_data.wifi_readLine[network_data.index_wifi] == '\r' ) {
    // If \r or \0 is read, we got something, so process it, triggers process_io procedure
    network_data.is_wifi_input_ready = TRUE;
    network_data.wifi_readLine[network_data.index_wifi + 1] = '\0';
  }

  network_data.index_wifi++;
  // }
}

void gprs_serial_interrupt() {
  //if (PIR2.RCIF){

  if (network_data.index_gprs >= sizeof(network_data.gprs_readLine) - 3) {
    // To stop buffer from overfloating
    network_data.index_gprs = 0;
  }

  network_data.gprs_readLine[network_data.index_gprs] = Serial1.read();

  if (network_data.gprs_readLine[network_data.index_gprs] == '\n' ||
      network_data.gprs_readLine[network_data.index_gprs] == '\0' ||
      network_data.gprs_readLine[network_data.index_gprs] == '\r' ) {
    // If \r or \0 is read, we got something, so process it, triggers process_io procedure
    network_data.is_gprs_input_ready = TRUE;
    network_data.gprs_readLine[network_data.index_gprs + 1] = '\0';
  }

  network_data.index_gprs++;
  // }
}


void system_clock() {

  SystemTime.mils_++;

  // Clock buffer for sensors

  if (SystemTime.mils_ == 1000) {
    SystemTime.sec_++;
    SystemTime.mils_ = 0;
    if (Timer.connection_timer_buffer <= Timer.connection_timer) {
      Timer.connection_timer++;
    }
  }
  if (SystemTime.sec_ == 60) {
    SystemTime.min_++;
    SystemTime.sec_ = 0;
  }
  if (SystemTime.min_ == 60) {
    SystemTime.hour_++;
    SystemTime.min_ = 0;
  }
  if (SystemTime.hour_ == 24) {
    SystemTime.day_++;
    SystemTime.hour_ = 0;
  }
  if (SystemTime.day_ == DAYS_OF_MONTH[SystemTime.month_]) {
    SystemTime.month_++;
    SystemTime.day_ = 0;
  }
  if (SystemTime.month_ == 12) {
    SystemTime.year_++;
    SystemTime.month_ = 0;
  }

}



void default_config() {
  int i;
  for (i = 0; i < sizeof(RELAY_PINS); i++) {
    relays[i].state = 0;
    relays[i].start_timer = 0;
    relays[i].end_timer = 0;
    relays[i]._delay = 0;
    relays[i].delay_enabled = 0;
    relays[i].timer_enabled = 0;
  }

  for (i = 0; i < sizeof(INPUT_PINS); i++) {
    inputs[i].start_timer = 0;
    inputs[i].end_timer = 0;
    inputs[i].sample_rate = 0;
    inputs[i].timer_enabled = 0;
    inputs[i].pin = 0;
  }
  

  SystemTime.year_ = 0;
  SystemTime.month_ = 0;
  SystemTime.day_ = 0;
  SystemTime.hour_ = 0;
  SystemTime.min_ = 0;
  SystemTime.sec_ = 0;
  SystemTime.mils_ = 0;

  strcpy(network_data.host, NETWORK_HOST);
  strcpy(network_data.port, NETWORK_PORT);
  strcpy(network_data.ssid, NETWORK_SSID);
  strcpy(network_data.password, NETWORK_PASSW);
  strcpy(network_data.apn, NETWORK_APN);

  network_data.isWifiConnected = FALSE;
  network_data.isGprsConnected = FALSE;
  network_data.isServerConnected = FALSE;

  memset(network_data.wifi_readLine, 0, sizeof(network_data.wifi_readLine));
  memset(network_data.gprs_readLine, 0, sizeof(network_data.gprs_readLine));
  network_data.is_wifi_input_ready = FALSE;
  network_data.is_gprs_input_ready = FALSE;
  network_data.index_wifi = 0;
  network_data.index_gprs = 0;

  Timer.connection_timer_buffer = 0;;
  Timer.connection_timer = 0;

  memset(System.manufacturer_number, 0, sizeof(System.manufacturer_number));
  memset(System.admin_user, 0, sizeof(System.admin_user));

}

void read_config() {

}


void setup() {

}

void loop() {
}
