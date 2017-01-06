#line 1 "C:/Users/Nils/Desktop/PIC/wifi module/SHT1X_driver.c"
#line 7 "C:/Users/Nils/Desktop/PIC/wifi module/SHT1X_driver.c"
char * itoa(int i, char b[]);

sbit Soft_I2C_Scl at RC1_bit;
sbit Soft_I2C_Sda at RC0_bit;
sbit Soft_I2C_Scl_Direction at TRISC1_bit;
sbit Soft_I2C_Sda_Direction at TRISC0_bit;


 const unsigned int C1 = 400;
 const unsigned int C2 = 405;
 const unsigned short C3 = 28;
 const unsigned int D1 = 4000;
 const unsigned short D2 = 1;

 unsigned short i, j;
 int temp, k, SOt, SOrh, Ta_res, Rh_res;

 void SHT_Reset() {
 Soft_I2C_Scl = 0;
 Soft_I2C_Sda_Direction = 1;
 for (i = 1; i <= 18; i++)
 Soft_I2C_Scl = ~Soft_I2C_Scl;
}

 void Transmission_Start() {
 Soft_I2C_Sda_Direction = 1;
 Soft_I2C_Scl = 1;
 Delay_1us();
 Soft_I2C_Sda_Direction = 0;
 Soft_I2C_Scl = 0;
 Delay_1us();
 Soft_I2C_Scl = 0;
 Delay_1us();
 Soft_I2C_Scl = 1;
 Delay_1us();
 Soft_I2C_Sda_Direction = 1;
 Delay_1us();
 Soft_I2C_Scl = 0;
}


 void MCU_ACK() {
 Soft_I2C_Sda_Direction = 0;
 Soft_I2C_Sda = 0;
 Soft_I2C_Scl = 1;
 Delay_1us();
 Soft_I2C_Scl = 0;
 Delay_1us();
 Soft_I2C_Sda_Direction = 1;
}


 int Measure(short num) {

 j = num;
 SHT_Reset();
 Transmission_Start();
 k = 0;
 Soft_I2C_Sda_Direction = 0;
 Soft_I2C_Scl = 0;
 for(i = 1; i <= 8; i++) {
 if (j.B7 == 1)
 Soft_I2C_Sda_Direction = 1;
 else {
 Soft_I2C_Sda_Direction = 0;
 Soft_I2C_Sda = 0;
 }
 Delay_1us();
 Soft_I2C_Scl = 1;
 Delay_1us();
 Soft_I2C_Scl = 0;
 j <<= 1;
 }

 Soft_I2C_Sda_Direction = 1;
 Soft_I2C_Scl = 1;
 Delay_1us();
 Soft_I2C_Scl = 0;
 Delay_1us();
 while (Soft_I2C_Sda == 1)
 Delay_1us();

 for (i = 1; i <=16; i++) {
 k <<= 1;
 Soft_I2C_Scl = 1;
 if (Soft_I2C_Sda == 1)
 k = k | 0x0001;
 Soft_I2C_Scl = 0;
 if (i == 8)
 MCU_ACK();
 }
 return k;
}

char* Read_SHT1X() {

 char converter[5];
 char buffer[12];

 char *p,*p1,*p2;
 Soft_I2C_Sda_Direction = 0;
 Soft_I2C_Scl_Direction = 0;


 RC1IE_bit = 0;

 SOt = Measure(0x03);

 SOrh = Measure(0x05);
 RC1IE_bit = 1;




 if(SOt > D1)
 Ta_res = SOt * D2 - D1;
 else
 Ta_res = D1 - SOt * D2;



 temp = SOrh * SOrh * C3 / 100000;
 Rh_res = SOrh * C2 / 100 - temp - C1;

 p1 = itoa(Ta_res,converter);
 p2 = itoa(Rh_res,converter);
 strcpy(buffer,p1);
 strcat(buffer,":");
 strcat(buffer,p2);
 strcat(buffer,":");

 return buffer;
}
