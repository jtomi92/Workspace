#line 1 "C:/Users/Nils/Desktop/PIC/wifi module/MS8607.c"

sbit Soft_I2C_Scl at RB4_bit;
sbit Soft_I2C_Sda at RB5_bit;
sbit Soft_I2C_Scl_Direction at TRISB4_bit;
sbit Soft_I2C_Sda_Direction at TRISB5_bit;



long double TEMP = 0.0;
long double PRES = 0.0;
long double FAR = 0.0;
long double RH = 0.0;

short isStarted = 0;

void Measure_MS8607(){


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
 Soft_I2C_Init();
 isStarted = 1;
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101100);
 Soft_I2C_Write(0x1E);
 Soft_I2C_Stop();
 }
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101100);
 Soft_I2C_Write(0xA2);
 Soft_I2C_Stop();
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101101);
 C1[1] = Soft_I2C_Read(1);
 C1[2] = Soft_I2C_Read(0);
 Soft_I2C_Stop();

 Soft_I2C_Start();
 Soft_I2C_Write(0b11101100);
 Soft_I2C_Write(0xA4);
 Soft_I2C_Stop();
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101101);
 C2[1] = Soft_I2C_Read(1);
 C2[2] = Soft_I2C_Read(0);
 Soft_I2C_Stop();

 Soft_I2C_Start();
 Soft_I2C_Write(0b11101100);
 Soft_I2C_Write(0xA6);
 Soft_I2C_Stop();
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101101);
 C3[1] = Soft_I2C_Read(1);
 C3[2] = Soft_I2C_Read(0);
 Soft_I2C_Stop();

 Soft_I2C_Start();
 Soft_I2C_Write(0b11101100);
 Soft_I2C_Write(0xA8);
 Soft_I2C_Stop();
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101101);
 C4[1] = Soft_I2C_Read(1);
 C4[2] = Soft_I2C_Read(0);
 Soft_I2C_Stop();

 Soft_I2C_Start();
 Soft_I2C_Write(0b11101100);
 Soft_I2C_Write(0xAA);
 Soft_I2C_Stop();
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101101);
 C5[1] = Soft_I2C_Read(1);
 C5[2] = Soft_I2C_Read(0);
 Soft_I2C_Stop();

 Soft_I2C_Start();
 Soft_I2C_Write(0b11101100);
 Soft_I2C_Write(0xAC);
 Soft_I2C_Stop();
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101101);
 C6[1] = Soft_I2C_Read(1);
 C6[2] = Soft_I2C_Read(0);
 Soft_I2C_Stop();

 C1[0] = C1[1] * 256 + C1[2];
 C2[0] = C2[1] * 256 + C2[2];
 C3[0] = C3[1] * 256 + C3[2];
 C4[0] = C4[1] * 256 + C4[2];
 C5[0] = C5[1] * 256 + C5[2];
 C6[0] = C6[1] * 256 + C6[2];


 Soft_I2C_Start();
 Soft_I2C_Write(0b11101100);
 Soft_I2C_Write(0x48);
 Soft_I2C_Stop();
 delay_ms(10);
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101100);
 Soft_I2C_Write(0x00);
 Soft_I2C_Stop();
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101101);
 D1[1] = Soft_I2C_Read(1);
 D1[2] = Soft_I2C_Read(1);
 D1[3] = Soft_I2C_Read(0);
 Soft_I2C_Stop();

 D1[0] = D1[1] * 65536 + D1[2] * 256 + D1[3];

 Soft_I2C_Start();
 Soft_I2C_Write(0b11101100);
 Soft_I2C_Write(0x58);
 Soft_I2C_Stop();
 delay_ms(10);
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101100);
 Soft_I2C_Write(0x00);
 Soft_I2C_Stop();
 Soft_I2C_Start();
 Soft_I2C_Write(0b11101101);

 D2[1] = Soft_I2C_Read(1);
 D2[2] = Soft_I2C_Read(1);
 D2[3] = Soft_I2C_Read(0);

 Soft_I2C_Stop();

 D2[0] = D2[1] * 65536 + D2[2] * 256 + D2[3];

 Soft_I2C_Start();
 Soft_I2C_Write(0b10000000);
 Soft_I2C_Write(0xE5);
 Soft_I2C_Start();
 Soft_I2C_Write(0b10000001);
 delay_ms(10);

 D3[1] = Soft_I2C_Read(1);
 D3[2] = Soft_I2C_Read(1) & 0b11111100;
 D3[3] = Soft_I2C_Read(0);

 Soft_I2C_Stop();

 D3[0] = D3[1] * 256.0 + D3[2];



 dT = D2[0] - (C5[0] * pow(2,8));

 TEMP = 2000 + (dT * C6[0] / pow(2,23));

 OFF = C2[0] * pow(2,17) + (C4[0] * dT) / pow(2,6);

 SENS = C1[0] * pow(2,16) + (C3[0] * dT) / pow(2,7);

 if (TEMP>= 2000){
 T2 = 0;
 OFF2 = 0;
 SENS2 = 0;

 } else if (TEMP< 2000){
 T2 = dT * dT / pow(2,31);
 OFF2 = 5 * (pow((TEMP- 2000),2)) / 2;
 SENS2 = OFF2 / 2;

 } else if (TEMP< -1500){

 OFF2 = OFF2 + 7 * (pow(TEMP+1500,20));
 SENS2 = SENS2 + 11 * (pow(TEMP+ 1500,2)) / 2;
 }

 TEMP= TEMP- T2;
 OFF = OFF - OFF2;
 SENS = SENS - SENS2;

 PRES= (D1[0] * SENS / pow(2,21) - OFF) / pow(2,15);

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
