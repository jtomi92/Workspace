//****************************************************************************
//  WS2811.h
//  WS2811 LED Strip Driver with Patterns
//  by RCI
//  Thanks to Patrick Cantwell for the cool WS2811 Frame Routine!
//  Modified with RAO ADC_Read(0) for speed
//
//****************************************************************************
// Color Order for WS2811 LED is GRB
// User may need to Change orientation
//
// Color Definitions     Order G, R, B
#define        red            0,255,0
#define        green          255,0,0
#define        orange         20,255,0


#define  testbit(var, bit)  ((var) & (1 <<(bit)))
#define  ws2811_zero 0b10000000        // was 10000000
#define  ws2811_one  0b11110000        // was 11110000

//****************************************************************************
//Variable Declarations
//****************************************************************************
char MAX_LED_COUNT;
signed long led_strip_colors[256];
unsigned char brightness = 1;

//****************************************************************************
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
      if(testbit(this_led, 23))
          {          // test fixed bit 23
          spi1_write(ws2811_one);
          }
      else
          {
          spi1_write(ws2811_zero);
          }
      this_led *= 2;  // march all the bits one position to the left so
      }
  }
  delay_us(75);

}


//****************************************************************************
void WS2811_LEDCount(char vari)
{
  MAX_LED_COUNT = vari + 6;
  return;
}
//****************************************************************************
void Clear_Strip()
{
char pos;
    // Clear Strip
    for(pos = 0; pos < MAX_LED_COUNT; pos++)
       {
       led_strip_colors[pos] = 0x000000;
       }
       WS2811_frame();
}

//****************************************************************************
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

//****************************************************************************
void Fill_Dot_PosR (char r1, char g1, char b1, char pos)
{
  Set_Color(r1, g1, b1, pos);
  WS2811_frame();
}// End Fill_Right3
