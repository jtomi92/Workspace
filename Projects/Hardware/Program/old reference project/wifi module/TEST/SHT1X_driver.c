/* Two-wire communication with temperature and humidity sensor SHT11.
   Measurement resolution of temperature is 14bit while for humidity it is 12bit.
   More information about the sensor can be found here:
   http://www.sensirion.com/en/pdf/product_information/Datasheet-humidity-sensor-SHT1x.pdf
   In order to have valid readings, pull-up the SDA pin.
*/
char * itoa(int i, char b[]);
// SHT11 connections
sbit Soft_I2C_Scl           at RC1_bit;
sbit Soft_I2C_Sda           at RC0_bit;
sbit Soft_I2C_Scl_Direction at TRISC1_bit;
sbit Soft_I2C_Sda_Direction at TRISC0_bit;

// constants for calculating temperature and humidity
 const unsigned int C1 = 400;             // -4
 const unsigned int C2 = 405;             // 0.0405  (405 * 10^-4)
 const unsigned short C3 = 28;            // -2.8 * 10^-6  (28 * 10^-7)
 const unsigned int D1 = 4000;            // -40
 const unsigned short D2 = 1;             // 0.01

 unsigned short i, j;
 int temp, k, SOt, SOrh, Ta_res, Rh_res;

 void SHT_Reset() {
  Soft_I2C_Scl = 0;                              // SCL low
  Soft_I2C_Sda_Direction = 1;                     // define SDA as input
  for (i = 1; i <= 18; i++)              // repeat 18 times
    Soft_I2C_Scl = ~Soft_I2C_Scl;                        // invert SCL
}

 void Transmission_Start() {
  Soft_I2C_Sda_Direction = 1;                     // define SDA as input
  Soft_I2C_Scl = 1;                              // SCL high
  Delay_1us();                           // 1us delay
  Soft_I2C_Sda_Direction = 0;                     // define SDA as output
  Soft_I2C_Scl = 0;                              // SDA low
  Delay_1us();                           // 1us delay
  Soft_I2C_Scl = 0;                              // SCL low
  Delay_1us();                           // 1us delay
  Soft_I2C_Scl = 1;                              // SCL high
  Delay_1us();                           // 1us delay
  Soft_I2C_Sda_Direction = 1;                     // define SDA as input
  Delay_1us();                           // 1us delay
  Soft_I2C_Scl = 0;                              // SCL low
}

// MCU ACK
 void MCU_ACK() {
  Soft_I2C_Sda_Direction = 0;     // define SDA as output
  Soft_I2C_Sda = 0;              // SDA low
  Soft_I2C_Scl = 1;              // SCL high
  Delay_1us();           // 1us delay
  Soft_I2C_Scl = 0;              // SCL low
  Delay_1us();           // 1us delay
  Soft_I2C_Sda_Direction = 1;     // define SDA as input
}

// this function returns temperature or humidity, depends on command
 int Measure(short num) {

  j = num;                           // j = command (0x03 or 0x05)
  SHT_Reset();                       // procedure for reseting SHT11
  Transmission_Start();              // procedure for starting transmission
  k = 0;                             // k = 0
  Soft_I2C_Sda_Direction = 0;                 // define SDA as output
  Soft_I2C_Scl = 0;                          // SCL low
  for(i = 1; i <= 8; i++) {          // repeat 8 times
    if (j.B7 == 1)                   // if bit 7 = 1
     Soft_I2C_Sda_Direction = 1;              // define SDA as input
    else {                           // else (if bit 7 = 0)
     Soft_I2C_Sda_Direction = 0;              // define SDA as output
     Soft_I2C_Sda = 0;                       // SDA low
   }
    Delay_1us();                     // 1us delay
    Soft_I2C_Scl = 1;                        // SCL high
    Delay_1us();                     // 1us delay
    Soft_I2C_Scl = 0;                        // SCL low
    j <<= 1;                         // move contents of j one place left
  }

  Soft_I2C_Sda_Direction = 1;                 // define SDA as input
  Soft_I2C_Scl = 1;                          // SCL high
  Delay_1us();                       // 1us delay
  Soft_I2C_Scl = 0;                          // SCL low
  Delay_1us();                       // 1us delay
  while (Soft_I2C_Sda == 1)                  // while SDA is high, do nothing
    Delay_1us();                     // 1us delay

  for (i = 1; i <=16; i++) {         // repeat 16 times
    k <<= 1;                         // move contents of k one place left
    Soft_I2C_Scl = 1;                        // SCL high
    if (Soft_I2C_Sda == 1)                   // if SDA is high
    k = k | 0x0001;
    Soft_I2C_Scl = 0;
    if (i == 8)                      // if counter i = 8 then
      MCU_ACK();                     // MCU acknowledge
  }
  return k;                          // returns contents of k
}

char* Read_SHT1X() {
//  INTCON = 0;                      // disable all interrupts
  char converter[5];
  char buffer[12];
  
  char *p,*p1,*p2;
  Soft_I2C_Sda_Direction = 0;
  Soft_I2C_Scl_Direction = 0;                 // SCL is output

// disable all interrupts untill measuerements are over
  RC1IE_bit = 0;                // disable Rx1 intterupts
  // measuring temperature
  SOt = Measure(0x03);        // function for measuring (command 0x03 is for temperature)
  // measuring humidity
  SOrh = Measure(0x05);       // function for measuring (command 0x05 is for humidity)
  RC1IE_bit = 1;                // enable Rx1 intterupts
//

// calculating temperature
// Ta_res = D1 + D2 * SOt
    if(SOt > D1)                     // if temperature is positive
      Ta_res = SOt * D2 - D1;        // calculate temperature
    else                             // else (if temperature is negative)
      Ta_res = D1 - SOt * D2;        // calculate temperature

// calculating humidity
// Rh_res = C1 + C2 * SOrh + C3 * SOrh^2
    temp = SOrh * SOrh * C3 / 100000;             // calculate humidity
    Rh_res = SOrh * C2 / 100 - temp - C1;         // calculate humidity
    
    p1 = itoa(Ta_res,converter);
    p2 = itoa(Rh_res,converter);
    strcpy(buffer,p1);
    strcat(buffer,":");
    strcat(buffer,p2);
    strcat(buffer,":");
    
    return buffer;
}