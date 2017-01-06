#line 1 "C:/Users/Nils/Desktop/PIC/home_control/ws2811.c"
#line 1 "c:/users/nils/desktop/pic/home_control/ws2811.h"
#line 25 "c:/users/nils/desktop/pic/home_control/ws2811.h"
char MAX_LED_COUNT;
signed long led_strip_colors[256];
unsigned char brightness = 1;


void WS2811_frame()
{
 unsigned int i;
 unsigned long this_led;
 unsigned int loop;

 for(i = 0; i < MAX_LED_COUNT; i++)
 {
 this_led = led_strip_colors[i];
 for(loop = 0; loop < 24; loop++)
 {
 if( ((this_led) & (1 <<(23))) )
 {
 spi1_write( 0b11110000 );
 }
 else
 {
 spi1_write( 0b10000000 );
 }
 this_led *= 2;
 }
 }
 delay_us(75);

}



void WS2811_LEDCount(char vari)
{
 MAX_LED_COUNT = vari + 6;
 return;
}

void Clear_Strip()
{
char pos;

 for(pos = 0; pos < MAX_LED_COUNT; pos++)
 {
 led_strip_colors[pos] = 0x000000;
 }
 WS2811_frame();
}


void Set_Color(unsigned long rred, unsigned int ggreen, char bblue,
 char position)
{
 unsigned long temp, temp1;

 temp = 0;
 temp1 = 0;
 temp1 = (rred / brightness) << 16;
 temp = temp + temp1;
 temp1 = 0;
 temp1 = (ggreen / brightness) << 8;
 temp = temp + temp1;
 temp1 = 0;
 temp1 = (bblue / brightness);
 temp = temp + temp1;
 led_strip_colors[position] = temp;
}


void Fill_Dot_PosR (char r1, char g1, char b1, char pos)
{
 Set_Color(r1, g1, b1, pos);
 WS2811_frame();
}
#line 3 "C:/Users/Nils/Desktop/PIC/home_control/ws2811.c"
void ws2811_init(char ledCount)
{


 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE,
 _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
 delay_ms(250);

 WS2811_LEDCount(ledCount);

 Clear_Strip();
}

void setLedRed(char pos){

 Fill_Dot_PosR( 0,255,0 , pos);
}

void setLedGreen(char pos){

 Fill_Dot_PosR( 255,0,0 , pos);
}

void setLedOrange(char pos){

 Fill_Dot_PosR( 20,255,0 , pos);
}
