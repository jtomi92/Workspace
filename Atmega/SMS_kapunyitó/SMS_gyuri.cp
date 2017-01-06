#line 1 "C:/Users/Nils/Desktop/PIC/SMS_kapunyitó/SMS_gyuri.c"
#line 14 "C:/Users/Nils/Desktop/PIC/SMS_kapunyitó/SMS_gyuri.c"
char interruptStreamBuffer[200] = "";
char phoneBuffer[10] = "";
char admin[10] = "";
char users[10][10];

short InputReaderFlag = 0;
int k = 0;


char msg[30] = "";
char msg2[15] = "";
int j = 0;
int credit = 0;
unsigned int i = 0;
unsigned short logicVar =  0 ;
unsigned short isDataProcessed =  0 ;
unsigned short sms = 1;
int seconds = 0;

int impulses = 0,
mode_1_delay = 500,
mode_2_delay = 500,
repeat = 0,
wait = 5,
numberOfUsers = 0,
mode = 1;
char countryCode[6] = "+36";


const char AT[] = "AT\r";
const char AT_CMGF[] = "AT+CMGF=1\r";
const char AT_CMGS[] = "AT+CMGS=\"";
const char AT_CCLK[] = "AT+CCLK?\r";
const char CCLK[] = "+CCLK:";
const char UNREAD[] = "UNREAD";
const char ADMINC[] = "ADMIN";
const char ERROR_[] = "ERROR";
const char PREVADMIN[] = "Previous admin: ";
const char NEWADMIN[] = "New admin: ";
const char CODE[] = "CODE";
const char OK[] = "OK";
const char LOG[] = "LOG";
const char REPEAT_[] = "REPEAT";
const char MODE_[] = "MODE";
const char ADD[] = "ADD";
const char USERLIM[] = "USER LIMIT ERROR";
const char USERERR[] = "ERROR NUMBER USED";
const char USERADD[] = "USER(S) ADDED";
const char DEL[] = "DEL";
const char USERREM[] = "USER(S) REMOVED";
const char MTI[] = "MTI:";
const char AT_CMGR[] = "AT+CMGR=1\r";
const char AT_CMGDA[] = "AT+CMGDA=\"DEL ALL\"\r";
const char CC[] = "+36";
const char AT_CSCLK[] = "AT+CSCLK=2\r";
const char AT_CLTS[] = "AT+CLTS=1\r";
const char AT_CLIP[] = "AT+CLIP=1\r";
const char CARRIER[] = "CARRIER";
const char RING[] = "RING";
const char ATH[] = "ATH\r";
const char RESET[] = "RESET\r";

char * CopyConst2Ram(char * dest, const char * src){
 char * d ;
 d = dest;
 for(;*dest++ = *src++;)
 ;

 return d;
}

void SendSms(char *phonenumber, char *uzenet, char *info)
{

 UART1_Write_Text(CopyConst2Ram(msg2,AT));
 delay_ms(500);
 UART1_Write_Text(CopyConst2Ram(msg2,AT_CMGF));
 delay_ms(500);
 UART1_Write_Text(CopyConst2Ram(msg2,AT_CMGS));
 UART1_Write_Text(countryCode);
 UART1_Write_Text(phonenumber);
 UART1_Write(0x22);
 UART1_Write(0x0D);
 delay_ms(500);
 UART1_Write_Text(uzenet);
 UART1_Write_Text(info);
 UART1_Write(26);
 delay_ms(500);
 UART1_Write(0x0D);
 delay_ms(8000);
}




void InitTimer0(){
 T0CON = 0x85;
 TMR0H = 0x67;
 TMR0L = 0x69;
 GIE_bit = 1;
 TMR0IE_bit = 1;
}



void Interrupt(){

 if (PIR1.RCIF) {

 interruptStreamBuffer[k] = UART1_Read();

 if (k >= 198){
 interruptStreamBuffer[k+1] = '\0';
 k = 0;
 sms = 1;
 InputReaderFlag = 0;
 }


 if (interruptStreamBuffer[k] == '\r' || interruptStreamBuffer[k] == '\0'){

 InputReaderFlag = 1;
 }

 k++;

 }


 if (TMR1IF_bit){
 TMR1IF_bit = 0;
 TMR1H = 0x9E;
 TMR1L = 0x58;


 }



 if (TMR0IF_bit){
 TMR0IF_bit = 0;
 TMR0H = 0x67;
 TMR0L = 0x69;

 if (seconds <= 121){
 seconds++;
 }



 }
}


void ReadConfigFromEEPROM(){

char configString[60] = "";
int i;
char *p;

for (i=0;i<sizeof(configString)-1;i++){
 configString[i] = EEPROM_Read( 0x0000 +i);
}
UART1_Write_Text(CopyConst2Ram(msg,AT));
delay_ms(500);
UART1_Write_Text(configString);
UART1_Write_Text("\n\r");

p = strtok(configString,";");

i=0;

while (p!=0){

 switch (i){

 case 0:
 impulses = atoi(p);
 break;

 case 1:
 if (atoi(p) == 0) mode_1_delay = 500; else mode_1_delay = atoi(p);
 break;

 case 2:
 mode_2_delay = atoi(p);
 break;

 case 3:
 repeat = atoi(p);
 break;

 case 4:
 wait = atoi(p);
 break;

 case 5:
 numberOfUsers = atoi(p);
 break;

 case 6:
 if (atoi(p) == 0) mode = 1; else mode = atoi(p);
 break;

 case 7:
 if (strstr(p,"+") != 0)strcpy(countryCode,p);else strcpy(countryCode,CopyConst2Ram(msg,CC));
 break;
 }

 i++;
 p = strtok(0,";");
}



for (i=0;i<10;i++){
admin[i] = EEPROM_Read( 0x00A0 +i);
delay_ms(20);
}
if (!isdigit(admin[2])) strcpy(admin,"309225427");

for (i=0;i<numberOfUsers;i++){
 for (j=0;j<10;j++){
 users[i][j] = EEPROM_Read(i * 10 +  0X00B0  + j);
 }
}

delay_ms(500);



}


void SaveConfigToEEPROM(){

char buffer[7] = "";
char configString[60] = "";
int i;

IntToStr(impulses,buffer);
strcpy(configString,buffer);
strcat(configString,";");

IntToStr(mode_1_delay,buffer);
strcat(configString,buffer);
strcat(configString,";");

IntToStr(mode_2_delay,buffer);
strcat(configString,buffer);
strcat(configString,";");

IntToStr(repeat,buffer);
strcat(configString,buffer);
strcat(configString,";");

IntToStr(wait,buffer);
strcat(configString,buffer);
strcat(configString,";");

IntToStr(numberOfUsers,buffer);
strcat(configString,buffer);
strcat(configString,";");

IntToStr(mode,buffer);
strcat(configString,buffer);
strcat(configString,";");

strcat(configString,countryCode);
strcat(configString,";");
UART1_Write_Text(CopyConst2Ram(msg,AT));
delay_ms(500);
UART1_Write_Text(configString);

for (i=0;i<sizeof(configString)-1;i++){
 EEPROM_Write( 0x0000 +i,configString[i]);
}

}

int SaveUserToEEPROM(char *number){
int i;
char *p;

p = number;

for (i=0;i<10;i++)
UART1_Write(*p++);

if (numberOfUsers ==  10 ) return 0;

INTCON.GIE = 0;


for (i=0;i<10;i++){
EEPROM_Write(numberOfUsers * 10 +  0X00B0  + i,*number++);
delay_ms(20);
}


INTCON.GIE = 1;

return 1;
}






int RemoveUserFromPhoneBook(char *number){

int i,j;
char num[10] = "";

for (i=0;i<10;i++){
num[i] = *number++;
}

 if (numberOfUsers == 1){
 strcpy(users[0],"");
 for (j=0;j<10;j++){
 EEPROM_Write( 0X00B0  + j,0xFF);
 delay_ms(20);
 }
 delay_ms(20);
 }else
 if (strstr(users[numberOfUsers-1],num) != 0){
 strcpy(users[numberOfUsers-1],"");
 for (j=0;j<10;j++){
 EEPROM_Write(((numberOfUsers-1) * 10) +  0X00B0  + j,0xFF);
 delay_ms(20);
 }
 }else{

 for (i=0;i<numberOfUsers;i++){
 if (strstr(users[i],num) != 0){
 UART1_Write_Text(users[numberOfUsers-1]);

 strcpy(users[i],users[numberOfUsers-1]);

 for (j=0;j<10;j++){
 EEPROM_Write((i * 10) +  0X00B0  + j,users[i][j]);
 delay_ms(20);
 }

 }
 }
 strcpy(users[numberOfUsers-1],"");
 for (j=0;j<10;j++){
 EEPROM_Write(((numberOfUsers-1) * 10) +  0X00B0  + j,0xFF);
 delay_ms(20);
 }
 }


 numberOfUsers = numberOfUsers - 1;

return 1;
}

int SaveUserToPhoneBook(char *number){

int i;


if (numberOfUsers <=  10 ){

 SaveUserToEEPROM(number);

 for (i=0;i<10;i++){
 users[numberOfUsers][i] = *number++;
 }


 numberOfUsers += 1;

 IntToStr(numberOfUsers,msg);
 SaveConfigToEEPROM();

 return 1;
}

return 0;
}

void SmsCommands(){



if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,UNREAD)) != 0)
{
 sms = 1;
 isDataProcessed =  0 ;



 for (i=0;i<strlen(interruptStreamBuffer);i++)
 {
 if (interruptStreamBuffer[i] == '+' && interruptStreamBuffer[i+1] == '3' && interruptStreamBuffer[i+2] == '6')
 {
 for (j=0;j<9;j++)
 phoneBuffer[j] = interruptStreamBuffer[i+3+j];
 }
 }


 delay_ms(100);

 if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,ADMINC)) != 0)
 {
 if (strcmp(admin,phoneBuffer) == 0)
 {
 SendSms(admin,CopyConst2Ram(msg,ERROR_), "");
 }else
 {
 int i;

 SendSms(admin,CopyConst2Ram(msg,PREVADMIN), phoneBuffer);

 SendSms(phoneBuffer,CopyConst2Ram(msg,NEWADMIN), admin);

 strcpy(admin,phoneBuffer);

 for (i=0;i<10;i++){
 EEPROM_Write( 0x00A0 +i,admin[i]);
 delay_ms(20);
 }

 }
 isDataProcessed =  1 ;

 }



 if ((strstr(admin,phoneBuffer) != 0) && isDataProcessed ==  0 )
 {
 short isConfigChanged = 0;
 if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,CODE)) != 0 )
 {
 char *p1,*p2;

 p1 = strstr(interruptStreamBuffer,CopyConst2Ram(msg,CODE));
 strtok(p1,";");
 p2 = strtok(0,";");

 if (strlen(p2)<6)
 strcpy(countryCode,p2);

 SendSms(admin,CopyConst2Ram(msg,OK),"");

 isDataProcessed =  1 ;
 isConfigChanged =  1 ;
 }


 if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,REPEAT_)) != 0 )
 {
 char *p1;
 p1 = strstr(interruptStreamBuffer,CopyConst2Ram(msg,REPEAT_));

 strtok(p1,";");
 repeat = atoi(strtok(0,";"));
 if (!(repeat == 0 || repeat == 1)){
 repeat = 0;
 SendSms(admin,CopyConst2Ram(msg,ERROR_),"");
 }else{
 wait = atoi(strtok(0,";"));
 if (wait == 0){
 repeat = 0;
 SendSms(admin,CopyConst2Ram(msg,ERROR_),"");
 }else{
 SendSms(admin,CopyConst2Ram(msg,OK),"");
 }
 }

 isConfigChanged =  1 ;
 }

 if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,MODE_)) != 0 )
 {

 char *p1,*p2;
 int mod;

 p1 = strstr(interruptStreamBuffer,CopyConst2Ram(msg,MODE_));
 p2 = strtok(p1,";");
 p2 = strtok(0,";");

 mod = atoi(p2);

 if (mod == 1){
 mode = mod;
 mode_1_delay = atoi(strtok(0,";"));
 if (mode_1_delay == 0){
 mode_1_delay = 1000;
 SendSms(admin,CopyConst2Ram(msg,ERROR_),"");
 }else{
 SendSms(admin,CopyConst2Ram(msg,OK),"");
 }

 }else

 if (mod == 2){
 mode = mod;
 impulses = atoi(strtok(0,";"));
 if (impulses == 0){
 impulses = 1;
 }
 mode_2_delay = atoi(strtok(0,";"));
 if (mode_2_delay == 0){
 mod = 1;
 SendSms(admin,CopyConst2Ram(msg,ERROR_),"");
 }else SendSms(admin,CopyConst2Ram(msg,OK),"");


 }else

 if (mod == 3){
 mode = mod;
 SendSms(admin,CopyConst2Ram(msg,OK),"");
 }else SendSms(admin,CopyConst2Ram(msg,ERROR_),"");

 isConfigChanged =  1 ;
 }

 if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,ADD)) != 0 )
 {

 char *p1,*p2;
 int error = 3,i=0;

 p1 = strstr(interruptStreamBuffer,CopyConst2Ram(msg,ADD));

 p2 = strtok(p1,";");



 while( p2 != 0 ){
 int j,k;

 p1 = p2;

 for (j=0; j<6; j++){
 if (!isdigit(*p1++)){
 break;
 }
 }


 if (j >= 4 && strlen(p2) < 10){
 for (k=0;k<numberOfUsers;k++){
 if (strstr(users[k],p2) != 0){
 error = 3;
 break;
 }
 }
 if (strstr(admin,p2) != 0) error = 3;
 if (error == 0) break;
 error = SaveUserToPhoneBook(p2);

 }

 p2 = strtok(0,";");

 i++;
 }

 if (error == 0) SendSms(admin,CopyConst2Ram(msg,USERLIM),"");
 if (error == 1) SendSms(admin,CopyConst2Ram(msg,USERADD),"");
 if (error == 3) SendSms(admin,CopyConst2Ram(msg,USERERR),"");

 isDataProcessed =  1 ;

 }

 if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,DEL)) != 0 )
 {

 char *p1,*p2;
 int i = 0;

 p1 = strstr(interruptStreamBuffer,CopyConst2Ram(msg,DEL));

 p2 = strtok(p1,";");

 while( p2 != 0 ){

 int j,i;
 p1 = p2;

 for (j=0; j<6; j++){
 if (!isdigit(*p1++)){
 break;
 }
 }

 if (j >= 4 && strlen(p2) < 10){
 for (i=0;i<numberOfUsers;i++){
 if (strstr(users[i],p2) != 0){
 RemoveUserFromPhoneBook(p2);
 }
 }

 }

 p2 = strtok(0,";");
 i++;
 }

 isDataProcessed =  1 ;
 isConfigChanged =  1 ;
 SendSms(admin,CopyConst2Ram(msg,OK),"");
 }

 if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,RESET)) != 0 )
 {
 int i,j;
 for (i=0;i<numberOfUsers;i++){
 for (j=0;j<10;j++){
 EEPROM_Write((i*10) +  0X00B0  + j,0xFF);
 delay_ms(20);
 }
 }
 for (j=0;j<10;j++){
 EEPROM_Write( 0x00A0  + j,0xFF);
 delay_ms(20);
 }
 impulses = 0;
 mode_1_delay = 500;
 mode_2_delay = 500;
 repeat = 0;
 wait = 5;
 numberOfUsers = 0;
 mode = 1;
 strcpy(countryCode,"+36");
 isConfigChanged =  1 ;
 }

 if (isConfigChanged ==  1 ) SaveConfigToEEPROM();

 }




}
}





void SmsIncome()
{

 if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,MTI)) != 0)
 {

 delay_ms(300);
 k=0;
 UART1_Write_Text(CopyConst2Ram(msg,AT_CMGR));

 delay_ms(2000);


 }


}

void DelSms()
{

 if (sms >=1 )
 {
 INTCON.GIE = 0;
 UART1_Write_Text(CopyConst2Ram(msg,AT));
 delay_ms(500);
 UART1_Write_Text(CopyConst2Ram(msg,AT_CMGDA));
 delay_ms(500);
 sms = 0;
 INTCON.GIE = 1;
 }

}

void InitTimer1(){
 T1CON = 0x01;
 TMR1IF_bit = 0;
 TMR1H = 0x9E;
 TMR1L = 0x58;
 TMR1IE_bit = 1;
 INTCON = 0xC0;
}


void CheckSimOperating() {

 if (seconds >= 60 ){
 seconds = 0;

 UART1_Write_Text(CopyConst2Ram(msg,AT));
 delay_ms(500);

 UART1_Write_Text(CopyConst2Ram(msg,AT));
 delay_ms(500);

 if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,OK)) == 0){

  PORTC.B1  = 1;
 delay_ms(1200);
  PORTC.B1  = 0;
 delay_ms(5000);

 }

 }
}

void Setup()
 {
 delay_ms(500);
 TRISA.B0 = 0;
 PORTA = 0;
 TRISB = 0b01011011;
 TRISC = 0b00111001;

 PORTB = 0b000000000;
 PORTC = 0b000000000;

 ADCON0 = 0x0f;
 ADCON1 = 0x0f;


 delay_ms(500);



 INTCON.GIE = 1;
 INTCON.PEIE = 1;
 PIE1.RCIE = 1;

 InitTimer0();
 InitTimer1();



 seconds = 60;


 UART1_Init(9600);
 delay_ms(500);

 CheckSimOperating();

 INTCON.GIE = 0;
 ReadConfigFromEEPROM();
 INTCON.GIE = 1;

 UART1_Write_Text(CopyConst2Ram(msg,AT));
 delay_ms(500);
 UART1_Write_Text(CopyConst2Ram(msg,AT_CMGF));
 delay_ms(500);
 UART1_Write_Text(CopyConst2Ram(msg,AT_CSCLK));
 delay_ms(500);
 UART1_Write_Text(CopyConst2Ram(msg,AT_CLTS));
 delay_ms(500);
 UART1_Write_Text(CopyConst2Ram(msg,AT_CLIP));
 delay_ms(500);

}

void OpenGate(){

 switch (mode){
 int i,j;

 case 1:
 delay_ms(300);
 UART1_Write_Text(CopyConst2Ram(msg,ATH));
 delay_ms(200);

  PORTB.B2  = 1;
 vdelay_ms(mode_1_delay);
  PORTB.B2  = 0;

 if (repeat == 1){
 vdelay_ms(wait*1000);
  PORTB.B2  = 1;
 vdelay_ms(mode_1_delay);
  PORTB.B2  = 0;
 }



 break;

 case 2:

 delay_ms(300);
 UART1_Write_Text(CopyConst2Ram(msg,ATH));
 delay_ms(200);

 for (i=0;i<impulses;i++){
  PORTB.B2  = 1;
 vdelay_ms(mode_2_delay/2);
  PORTB.B2  = 0;
 vdelay_ms(mode_2_delay/2);
 }
 if (repeat == 1){
 VDelay_ms(wait*1000);

 for (i=0;i<impulses;i++){
  PORTB.B2  = 1;
 vdelay_ms(mode_2_delay/2);
  PORTB.B2  = 0;
 vdelay_ms(mode_2_delay/2);
 }

 }

 break;

 case 3:
 seconds = 0;
 while (strstr(interruptStreamBuffer,CopyConst2Ram(msg,CARRIER)) == 0){
  PORTB.B2  = 1;
 if (seconds == 300)break;
 }
  PORTB.B2  = 0;
 if (repeat == 1){
 int i;
 int delay;
 delay = seconds;

 vdelay_ms(wait*1000);
  PORTB.B2  = 1;
 for (i=0;i<1000;i++) vdelay_ms(delay);
  PORTB.B2  = 0;
 }

 delay_ms(300);
 UART1_Write_Text(CopyConst2Ram(msg,ATH));
 delay_ms(200);

 break;


 }

}

void OnRing(){

 if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,RING)) != 0){

 delay_ms(500);
 if (strstr(interruptStreamBuffer,admin) != 0){

 OpenGate();

 }

 for (i=0;i<numberOfUsers;i++){
 if (strstr(interruptStreamBuffer,users[i]) != 0){
 OpenGate();

 }
 }

 delay_ms(300);
 UART1_Write_Text(CopyConst2Ram(msg,ATH));
 delay_ms(200);

 }



}


void main() {


 Setup();


 while(1)
 {

 CheckSimOperating();

 DelSms();

 if (InputReaderFlag == 1)
 {
 interruptStreamBuffer[k] = '\0';

 OnRing();

 SmsIncome();

 SmsCommands();

 k = 0;
 InputReaderFlag = 0;

 memset(interruptStreamBuffer,0,sizeof(interruptStreamBuffer)-1);

 }

 }
}
