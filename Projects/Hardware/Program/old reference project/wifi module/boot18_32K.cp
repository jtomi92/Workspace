#line 1 "C:/Users/Nils/Desktop/PIC/wifi module/boot18_32K.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 15 "C:/Users/Nils/Desktop/PIC/wifi module/boot18_32K.c"
static char block[64];

void Susart_Init(unsigned short brg_reg) org 65136 {
 unsigned short i;

 RCSTA2 = 0x90;
 TXSTA2 = 0x26;
 TRISD.B7 = 1;
 TRISD.B6 = 0;

 while (PIR2.RCIF)
 i = RCREG2;

 SPBRG2 = brg_reg;
}


void Susart_Write(unsigned short data_) org 65080 {

 while (!TXSTA2.TRMT)
 ;
 TXREG2 = data_;
}

unsigned short Susart_Data_Ready() org 65120 {
 return (PIR2.RCIF);
}

unsigned short Susart_Read() org 65040 {
 unsigned short rslt;
 rslt = RCREG2;

 if (RCSTA2.OERR) {
 RCSTA2.CREN = 0;
 RCSTA2.CREN = 1;
 }
 return rslt;
}





void Start_Program() org 0xFFC0 {
}

void Flash_Write_Sector(long address, char *sdata) org 64020 {
 unsigned short saveintcon, i, j;

 saveintcon = INTCON;


 TBLPTRL =  ((char *)&address)[0] ;
 TBLPTRH =  ((char *)&address)[1] ;
 TBLPTRU =  ((char *)&address)[2] ;

 EECON1.EEPGD = 1;
 EECON1.CFGS = 0;
 EECON1.WREN = 1;
 EECON1.FREE = 1;
 INTCON.GIE = 0;
 EECON2 = 0x55;
 EECON2 = 0xAA;
 EECON1.WR = 1;
 INTCON.GIE = 1;
 asm TBLRD*- ;

 FSR0L =  ((char *)&sdata)[0] ;
 FSR0H =  ((char *)&sdata)[1] ;
 j = 0;
 while (j < _FLASH_ERASE/_FLASH_WRITE_LATCH) {
 i = 0;
 while (i < _FLASH_WRITE_LATCH) {
 TABLAT = POSTINC0;
 asm {
 TBLWT+*
 }
 i++;
 }
 EECON1.EEPGD = 1;
 EECON1.CFGS = 0;
 EECON1.WREN = 1;
 INTCON.GIE = 0;
 EECON2 = 0x55;
 EECON2 = 0xAA;
 EECON1.WR = 1;
 j++;
 }
 INTCON.GIE = 1;
 EECON1.WREN = 0;

 INTCON = saveintcon;
}

unsigned short Susart_Write_Loop(char send, char receive) org 63926 {
 unsigned short rslt = 0;

 LBL_BOOT18_64_01:
 ___Boot_Delay64k();
 Susart_Write(send);
 ___Boot_Delay64k();

 rslt++;
 if (rslt == 255u)
 return 0;
 if (Susart_Read() == receive)
 return 1;
 goto LBL_BOOT18_64_01;
}





void Write_Begin() org 64774 {

 Flash_Write_Sector(0xFFC0, block);

 block[0] = 0xBC;
 block[1] = 0xEF;
 block[2] = 0x7E;
 block[3] = 0xF0;

}


void Start_Bootload() org 65186 {
 unsigned short i = 0, xx, yy;
 long j = 0;

 while (1) {
 if (i == 64u) {

 if (!j)
 Write_Begin();
 Flash_Write_Sector(j, block);

 i = 0;
 j += 0x40;
 }

 Susart_Write('y');
 while (!Susart_Data_Ready()) ;

 yy = Susart_Read();

 Susart_Write('x');
 while (!Susart_Data_Ready()) ;

 xx = Susart_Read();

 block[i++] = yy;
 block[i++] = xx;
 }
}
