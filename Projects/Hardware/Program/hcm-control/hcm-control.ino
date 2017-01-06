#include <Hcm.h>

const char PRODUCT_NAME[] = "HCM-R9-I0";


#define ESP_PWR 10
#define SIM_PWR 11
#define VCC_DETECT 12
#define EEPROM_SIZE 4096



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

#define TRUE 1
#define FALSE 0

#define ESP_RX   2
#define ESP_TX   3
#define ESP_RST  4


const int DAYS_OF_MONTH[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

int relay_modules[4] = {0,0,0,0};


/*

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
          //printf("start sys_time:%s - %d\n",p1,relays[position].start_sys_time);

          p1 = strtok(0, ";");
          relays[position].end_timer = atoi(p1);
          //printf("end sys_time:%s - %d\n",p1,relays[position].end_sys_time);

          p1 = strtok(0, ";");
          relays[position]._delay = atoi(p1);
          //printf("delay:%s - %d\n",p1,relays[position]._delay);

          p1 = strtok(0, ";");
          relays[position].delay_enabled = (*p1 == 'Y');
          //printf("delay enabled:%s - %d\n",p1, relays[position].delay_enabled);

          p1 = strtok(0, ";");
          relays[position].timer_enabled = (*p1 == 'Y');
          //printf("sys_time enabled:%s - %d\n\n",p1,relays[position].sys_time_enabled);

        } else if (strstr(p1, "IS") != 0) {

          int position = *(p1 + 3) - 1;
          //printf("INPUT:%c\n",position);

          p1 = strtok(0, ";");
          inputs[position].start_timer = atoi(p1);
          //printf("start sys_time:%s - %d\n",p1,inputs[position].start_sys_time);

          p1 = strtok(0, ";");
          inputs[position].end_timer = atoi(p1);
          //printf("end sys_time:%s - %d\n",p1,inputs[position].end_sys_time);

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

  sys_time.mils_++;

  // Clock buffer for sensors

  if (sys_time.mils_ == 1000) {
    sys_time.sec_++;
    sys_time.mils_ = 0;
    if (sys_time.connection_timer_buffer <= sys_time.connection_timer) {
      sys_time.connection_timer++;
    }
  }
  if (sys_time.sec_ == 60) {
    sys_time.min_++;
    sys_time.sec_ = 0;
  }
  if (sys_time.min_ == 60) {
    sys_time.hour_++;
    sys_time.min_ = 0;
  }
  if (sys_time.hour_ == 24) {
    sys_time.day_++;
    sys_time.hour_ = 0;
  }
  if (sys_time.day_ == DAYS_OF_MONTH[sys_time.month_]) {
    sys_time.month_++;
    sys_time.day_ = 0;
  }
  if (sys_time.month_ == 12) {
    sys_time.year_++;
    sys_time.month_ = 0;
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


  sys_time.year_ = 0;
  sys_time.month_ = 0;
  sys_time.day_ = 0;
  sys_time.hour_ = 0;
  sys_time.min_ = 0;
  sys_time.sec_ = 0;
  sys_time.mils_ = 0;

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

  sys_time.connection_timer_buffer = 0;;
  sys_time.connection_timer = 0;

  memset(System.manufacturer_number, 0, sizeof(System.manufacturer_number));
  memset(System.admin_user, 0, sizeof(System.admin_user));

}

void read_config() {

}*/


void setup() {
  Hcm hcm = Hcm();
  hcm.discoverRelayModules(&relay_modules);
}

void loop() {


}
