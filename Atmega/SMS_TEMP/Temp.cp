#line 1 "C:/Users/Nils/Desktop/PIC/SMS_TEMP/Temp.c"









char interruptStreamBuffer[200] = "";
char output[60] = "";
char phoneBuffer[13] = "+36309225427";
char phone[13] = "+36309225427";
char kezelo[13] = "+36309225427";
char * verifierCode = "1234";
int index = 0;
short InputReaderFlag = 0;


char msg[50] = "";
unsigned short logicVar =  0 ;
unsigned short isDataProcessed =  0 ;
unsigned short sms = 1;
unsigned int rebootTimer = 0;
short flag = 1;
int secondCounter = 0;
short isHeaterActive =  0 ;
short heaterFlag = 1;
short flag2 = 1;

int sec = 0;
char networkFlag = 1;
char notificationFlag = 0;



char * CopyConst2Ram(char * dest, const char * src){
 char * d ;
 d = dest;
 for(;*dest++ = *src++;)
 ;

 return d;
}

int wait_for_input(char *input, int timeout){

int i = 0;int mils = 0;
char buffer[30];
memset(buffer,'\0',sizeof(buffer)-1);
INTCON.GIE = 0;

while (mils <= timeout*1000){
 if (UART1_Data_Ready){
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





void SendSms(char *phonenumber, char *uzenet, char *info)
{

 UART1_Write_Text("AT\r\n");

 delay_ms(500);
 UART1_Write_Text("AT+CMGF=1\r\n");
 delay_ms(500);

 UART1_Write_Text("AT+CMGS=\"");
 UART1_Write_Text(phonenumber);
 UART1_Write(0x22);
 UART1_Write(0x0D);
 delay_ms(500);
 UART1_Write_Text(uzenet);
 UART1_Write_Text(info);
 UART1_Write(26);
 UART1_Write(0x0D);
 delay_ms(6000);


}




void InitTimer0(){
 T0CON = 0x85;
 TMR0H = 0x67;
 TMR0L = 0x69;
 GIE_bit = 1;
 TMR0IE_bit = 1;
}


void Interrupt(){

 if (PIR1.RCIF ) {

 if (index >= sizeof(interruptStreamBuffer)-2){

 index = 0;
 sms = 1;
 InputReaderFlag = 0;
 }

 interruptStreamBuffer[index] = UART1_Read();

 if (interruptStreamBuffer[index] == '\n' ||
 interruptStreamBuffer[index] == '\0' ||
 interruptStreamBuffer[index] == '\r' ) {

 InputReaderFlag =  1 ;
 interruptStreamBuffer[index+1] = '\0';
 }

 index++;
 }

 if (TMR0IF_bit){
 TMR0IF_bit = 0;
 TMR0H = 0x67;
 TMR0L = 0x69;

 if (secondCounter <= 400){
 secondCounter++;
 }
 if (sec <= 3600){
 sec++;
 }
 }

}






char *getSmsMessage(){

 char *p1,*p2;

 p1 = strstr(interruptStreamBuffer,"UNREAD");
 p1 += 6;

 p2 = strtok(p1,"\",\"");


 strcpy(phoneBuffer, p2);

 p2 = strtok(0,"\n");
 p2 = strtok(0,"\r");

 return p2;
}


void SmsCommands(){



if (strstr(interruptStreamBuffer,"UNREAD") != 0 )
 {
 char *p;
 delay_ms(500);



 sms = 1;
 isDataProcessed =  0 ;




 p = getSmsMessage();


 delay_ms(300);



 if (strstr(p,"ADMIN") != 0)
 {

 INTCON.GIE = 0;

 delay_ms(100);
 logicVar =  0 ;

 if (strcmp(kezelo,phoneBuffer) == 0)
 {
 SendSms(kezelo,"Hiba: Maga a felhasznalo", "");
 logicVar =  1 ;
 }

 if (logicVar ==  0 )
 {
 int i;

 SendSms(kezelo,"Uj felhasznalo: ", phoneBuffer);

 SendSms(phoneBuffer,"Regi felhasznalo: ", kezelo);

 strcpy(kezelo,phoneBuffer);



 for (i=0;i<12;i++){

 EEPROM_Write(i+4,kezelo[i]);
 delay_ms(20);
 }


 }
 memset(interruptStreamBuffer,0,sizeof(interruptStreamBuffer)-1);
 isDataProcessed =  1 ;
 INTCON.GIE = 1;

 }


 if ((strstr(kezelo,phoneBuffer) != 0) && isDataProcessed ==  0 )
 {

 strcpy(output," ");
 strcpy(msg," ");


 if (strstr(p,"INFO") != 0 )
 {
 sms++;

 if (isHeaterActive ==  1 )
 if (heaterFlag == 1){
 strcpy(output,"BEKAPCSOLVA");
 } else {
 strcpy(output,"LEKAPCSOLVA");
 }
 else
 strcpy(output,"LEKAPCSOLVA");

 SendSms(kezelo,output,"");

 isDataProcessed =  1 ;
 }


 }

 delay_ms(2000);

 memset(interruptStreamBuffer,0,sizeof(interruptStreamBuffer)-1);
 memset(output,0,sizeof(output)-1);
 }
}





void SmsIncome()
{

 if (strstr(interruptStreamBuffer,"MTI:") != 0)
 {
 INTCON.GIE = 0;
 delay_ms(1500);
 memset(interruptStreamBuffer,0,sizeof(interruptStreamBuffer)-1);

 index=0;
 INTCON.GIE = 1;

 UART1_Write_Text("AT+CMGR=1\r\n");


 }


}

void DelSms()
{

 if (sms >=1 )
 {
 INTCON.GIE = 0;
 UART1_Write_Text("AT\r\n");
 delay_ms(500);
 UART1_Write_Text("AT+CMGDA=\"DEL ALL\"\r\n");
 delay_ms(500);
 sms = 0;
 memset(interruptStreamBuffer,0,sizeof(interruptStreamBuffer)-1);
 INTCON.GIE = 1;
 }

}




void IntSetup()
 {
 int i=0;

 TRISB = 0b00011000;
 TRISC = 0b00000000;

 PORTB = 0b00000000;
 PORTC = 0b00000000;


 ADCON0 = 0b00000000;
 ADCON1 = 0b00000000;


 delay_ms(500);
 UART1_Init(9600);

 INTCON.GIE = 1;
 INTCON.PEIE = 1;
 PIE1.RCIE = 1;

 InitTimer0();


 memset(interruptStreamBuffer,0,sizeof(interruptStreamBuffer)-1);
 UART1_Write_Text("AT\r\n");
 delay_ms(500);

 if (strstr(interruptStreamBuffer,"OK") == 0){
  PORTC.B2  = 1;
 delay_ms(1000);
  PORTC.B2  = 0;
 delay_ms(4000);
 }





 INTCON.GIE = 0;

 for (i=0;i<12;i++){
 kezelo[i] = EEPROM_Read(i+4);
 delay_ms(20);
 }

 isHeaterActive = EEPROM_Read(20);

 if (isHeaterActive ==  1 ){
  PORTB.B5  = 1;
 } else {
  PORTB.B5  = 0;
 }

 INTCON.GIE = 1;

 delay_ms(10000);

 UART1_Write_Text("AT+CMGF=1\r\n");
 delay_ms(300);
 UART1_Write_Text("AT+CLTS=1\r\n");
 delay_ms(500);
 UART1_Write_Text("AT+CLIP=1\r\n");
 delay_ms(500);

 secondCounter = 0;


}

void WatchEnvironment(){
#line 429 "C:/Users/Nils/Desktop/PIC/SMS_TEMP/Temp.c"
 if (secondCounter >= 180){

 secondCounter = 0;
 INTCON.GIE = 1;
 delay_ms(500);
 memset(interruptStreamBuffer,0,sizeof(interruptStreamBuffer)-1);
 index = 0;
 UART1_Write_Text("AT+CREG?\r\n");

 delay_ms(500);
 if (!(strstr(interruptStreamBuffer,"+CREG: 0,1") != 0 || strstr(interruptStreamBuffer,"+CREG: 0,5") != 0)){

 if (networkFlag == 1){
 sec = 0;
 networkFlag = 0;

}

 memset(interruptStreamBuffer,0,sizeof(interruptStreamBuffer)-1);
 index = 0;
 UART1_Write_Text("AT\r\n");
 delay_ms(500);
 if (strstr(interruptStreamBuffer,"OK") != 0){
  PORTC.B2  = 1;
 delay_ms(1000);
  PORTC.B2  = 0;
 delay_ms(7000);
 }
  PORTC.B2  = 1;
 delay_ms(1000);
  PORTC.B2  = 0;
 delay_ms(5000);
 } else {
 if (networkFlag == 0){
 networkFlag = 1;
}}
 }


 if (networkFlag == 0 && sec >= 3600){
 notificationFlag = 1;
  PORTB.B5  = 0;
 isHeaterActive =  0 ;
 EEPROM_WRITE(20,0);
}

if (networkFlag == 1 && notificationFlag == 1){
 notificationFlag = 0;
 SendSms(kezelo,"LEKAPCSOLVA","");
}

}

void onCall(){

 if (strstr(interruptStreamBuffer,"CLIP") != 0){
 delay_ms(500);
 if (strstr(interruptStreamBuffer,kezelo) != 0){
 INTCON.GIE = 0;
 UART1_Write_Text("ATH\r\n");

 memset(interruptStreamBuffer,0,sizeof(interruptStreamBuffer)-1);


 if (isHeaterActive ==  1 ){
 isHeaterActive =  0 ;
  PORTB.B5  = 0;
 SendSms(kezelo,"LEKAPCSOLVA","");
 heaterFlag = 0;
 EEPROM_WRITE(20,0);

 }else{
 isHeaterActive =  1 ;
  PORTB.B5  = 1;
 SendSms(kezelo,"BEKAPCSOLVA","");
 heaterFlag = 1;
 EEPROM_WRITE(20,1);
 }


 INTCON.GIE = 1;
 }
 }
}

void main() {

 IntSetup();

 while(1)
 {

 WatchEnvironment();

 DelSms();


 if (InputReaderFlag == 1)
 {
 interruptStreamBuffer[index] = '\0';

 onCall();

 SmsIncome();

 SmsCommands();

 index = 0;
 InputReaderFlag = 0;
 memset(interruptStreamBuffer,0,sizeof(interruptStreamBuffer)-1);
 }

 }
}
