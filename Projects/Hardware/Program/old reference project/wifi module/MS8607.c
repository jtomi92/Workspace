// Software I2C connections
sbit Soft_I2C_Scl           at RB4_bit;
sbit Soft_I2C_Sda           at RB5_bit;
sbit Soft_I2C_Scl_Direction at TRISB4_bit;
sbit Soft_I2C_Sda_Direction at TRISB5_bit;
// End Software I2C connections


long double TEMP = 0.0;
long double PRES = 0.0;
long double FAR = 0.0;
long double RH = 0.0;

short isStarted = 0;

void Measure_MS8607(){

     //Initialising the coefficients
     unsigned int C1[3] = {0,0,0};
     unsigned int C2[3] = {0,0,0};
     unsigned int C3[3] = {0,0,0};
     unsigned int C4[3] = {0,0,0};
     unsigned int C5[3] = {0,0,0};
     unsigned int C6[3] = {0,0,0};
     unsigned long D1[4] = {0,0,0};
     unsigned long D2[4] = {0,0,0,0};
     unsigned long D3[4] = {0,0,0,0};

     long double dT = 0.0;
     long double OFF = 0.0;
     long double SENS = 0.0;
     long double T2 = 0.0;
     long double OFF2 = 0.0;
     long double SENS2 = 0.0;
     char buff[30];

     INTCON.GIE = 0;
     
     if (isStarted == 0){
        Soft_I2C_Init();                  // Init soft i2c module
        isStarted = 1;
        Soft_I2C_Start();                 // Issue start signal
        Soft_I2C_Write(0b11101100);       // 0x76 + WRITE
        Soft_I2C_Write(0x1E);             // RESET
        Soft_I2C_Stop();                  // Issue Stop Signal
     }
     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
     Soft_I2C_Write(0xA2);                // 0xA2   == C1
     Soft_I2C_Stop();                     // Issue Stop Signal
     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101101);          // 0X76 + READ
     C1[1] = Soft_I2C_Read(1);            // Read first byte
     C1[2] = Soft_I2C_Read(0);            // Read second byte
     Soft_I2C_Stop();                     // Issue Stop Signal

     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
     Soft_I2C_Write(0xA4);                // 0xA4   == C2
     Soft_I2C_Stop();                     // Issue Stop Signal
     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101101);          // 0X76 + READ
     C2[1] = Soft_I2C_Read(1);            // Read first byte
     C2[2] = Soft_I2C_Read(0);            // Read second byte
     Soft_I2C_Stop();                     // Issue Stop Signal
     
     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
     Soft_I2C_Write(0xA6);                // 0xA6   == C3
     Soft_I2C_Stop();                     // Issue Stop Signal
     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101101);          // 0X76 + READ
     C3[1] = Soft_I2C_Read(1);            // Read first byte
     C3[2] = Soft_I2C_Read(0);            // Read second byte
     Soft_I2C_Stop();                     // Issue Stop Signal
     
     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
     Soft_I2C_Write(0xA8);                // 0xA8   == C4
     Soft_I2C_Stop();                     // Issue Stop Signal
     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101101);          // 0X76 + READ
     C4[1] = Soft_I2C_Read(1);            // Read first byte
     C4[2] = Soft_I2C_Read(0);            // Read second byte
     Soft_I2C_Stop();                     // Issue Stop Signal

     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
     Soft_I2C_Write(0xAA);                // 0xAA   == C5
     Soft_I2C_Stop();                     // Issue Stop Signal
     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101101);          // 0X76 + READ
     C5[1] = Soft_I2C_Read(1);            // Read first byte
     C5[2] = Soft_I2C_Read(0);            // Read second byte
     Soft_I2C_Stop();                     // Issue Stop Signal

     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
     Soft_I2C_Write(0xAC);                // 0xA2   == C6
     Soft_I2C_Stop();                     // Issue Stop Signal
     Soft_I2C_Start();                    // Issue start signal
     Soft_I2C_Write(0b11101101);          // 0X76 + READ
     C6[1] = Soft_I2C_Read(1);            // Read first byte
     C6[2] = Soft_I2C_Read(0);            // Read second byte
     Soft_I2C_Stop();                     // Issue Stop Signal

     C1[0] = C1[1] * 256 + C1[2];
     C2[0] = C2[1] * 256 + C2[2];
     C3[0] = C3[1] * 256 + C3[2];
     C4[0] = C4[1] * 256 + C4[2];
     C5[0] = C5[1] * 256 + C5[2];
     C6[0] = C6[1] * 256 + C6[2];


     Soft_I2C_Start();                // Issue start signal
     Soft_I2C_Write(0b11101100);      // 0x76 + WRITE
     Soft_I2C_Write(0x48);            // 0x48   == OSR(4096)
     Soft_I2C_Stop();                 // Issue Stop Signal
     delay_ms(10);                    // Wait slave to measure
     Soft_I2C_Start();                // Issue start signal
     Soft_I2C_Write(0b11101100);      // 0X76 + WRITE
     Soft_I2C_Write(0x00);            // ADC READ
     Soft_I2C_Stop();                 // Issue Stop Signal
     Soft_I2C_Start();                // Issue start signal
     Soft_I2C_Write(0b11101101);      // 0x76 + READ
     D1[1] = Soft_I2C_Read(1);        // Read first byte
     D1[2] = Soft_I2C_Read(1);        // Read seconds byte
     D1[3] = Soft_I2C_Read(0);        // Read third byte
     Soft_I2C_Stop();                 // Issue Stop Signal

     D1[0] = D1[1] * 65536 + D1[2] * 256 + D1[3];

     Soft_I2C_Start();                // Issue start signal
     Soft_I2C_Write(0b11101100);      // 0x76 + WRITE
     Soft_I2C_Write(0x58);            // 0x58   == D2 OSR(4096)
     Soft_I2C_Stop();                 // Issue Stop Signal
     delay_ms(10);                    // Wait Slave to measure
     Soft_I2C_Start();                // Issue start signal
     Soft_I2C_Write(0b11101100);      // 0X76 + WRITE
     Soft_I2C_Write(0x00);            // ADC READ
     Soft_I2C_Stop();                 // Issue Stop Signal
     Soft_I2C_Start();                // Issue start signal
     Soft_I2C_Write(0b11101101);      // 0x76 + READ

     D2[1] = Soft_I2C_Read(1);        // Read first byte
     D2[2] = Soft_I2C_Read(1);        // Read seconds byte
     D2[3] = Soft_I2C_Read(0);        // Read third byte

     Soft_I2C_Stop();                 // Issue Stop Signal
     
     D2[0] = D2[1] * 65536 + D2[2] * 256 + D2[3];

     Soft_I2C_Start();                // Issue start signal
     Soft_I2C_Write(0b10000000);      // 0x76 + WRITE
     Soft_I2C_Write(0xE5);            // Measure RH (Hold Master)
     Soft_I2C_Start();                // Issue start signal
     Soft_I2C_Write(0b10000001);      // 0X76 + WRITE
     delay_ms(10);

     D3[1] = Soft_I2C_Read(1);        // Read first byte
     D3[2] = Soft_I2C_Read(1) & 0b11111100;  // Read second byte and set status bits to 0
     D3[3] = Soft_I2C_Read(0);               // Checksum
     
     Soft_I2C_Stop();                 // Issue Stop Signal
     
     D3[0] = D3[1] * 256.0 + D3[2];

     //Starting of the Pressure and Temperature Calculations
     //Difference between actual and reference temperature
     dT = D2[0] - (C5[0] * pow(2,8));
     //Actual temperature (-40 ...+85 degree C with 0.01 degree C resolution)
     TEMP = 2000 + (dT * C6[0] / pow(2,23));
     //Offset at actual temperature
     OFF = C2[0] * pow(2,17) + (C4[0] * dT) / pow(2,6);
     //Sensitivity at actual Temperature
     SENS = C1[0] * pow(2,16) + (C3[0] * dT) / pow(2,7);

     if (TEMP>= 2000){
        T2 = 0;
        OFF2 = 0;
        SENS2 = 0;
        //Low temperature(< 20 degree C)
     } else if (TEMP< 2000){
        T2 = dT * dT / pow(2,31);
        OFF2 = 5 * (pow((TEMP- 2000),2)) / 2;
        SENS2 = OFF2 / 2;
        //Very Low Temperature(< -15 degree C)
     } else if (TEMP< -1500){

        OFF2 = OFF2 + 7 * (pow(TEMP+1500,20));
        SENS2 = SENS2 + 11 * (pow(TEMP+ 1500,2)) / 2;
     }
     //Calculate Pressure and Temperature
     TEMP= TEMP- T2;
     OFF = OFF - OFF2;
     SENS = SENS - SENS2;
     //Temperature Compensated Pressure
     PRES= (D1[0] * SENS / pow(2,21) - OFF) / pow(2,15);
     //Actual Relative Humidity with (-6 %RH ...118 %RH  with 0.01 %RH resolution)
     RH = 100 * (-6 + (125.0 * D3[0] /pow(2,16)));
     RH = RH / 100.0;
     TEMP= TEMP/ 100;
     PRES= PRES/ 100;
     FAR = (TEMP * 9)/5 +32.0;
     
     INTCON.GIE = 1;
}

long double getTemperature(){
      return TEMP;
}
long double getHumidity(){
      return RH;
}
long double getPressure(){
      return PRES;
}
long double getFahrenheit(){
      return FAR;
}