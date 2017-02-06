/*
* magic.cpp
*
* Created: 1/14/2017 9:29:59 PM
*  Author: tjozsa
*/
#include <global_include.h>


#define COLORLENGTH MAX_LED_COUNT/2
#define FADE 256/COLORLENGTH
#define  tail 10 // Sets Tail Length for Comet Routine

char MAX_LED_COUNT;

struct cRGB led[256];
signed long led_strip_colors[256];

unsigned char brightness = 1;
int speed = 0;
unsigned char last_event;
signed int v;
int i,j,k;

int br = 0;

void setSpeed(const int sp){
	speed = sp;
}
void setMaxLedCount(const int size){
	MAX_LED_COUNT = size;
}

void setBrightness(const int brightness){
	if (brightness == 0){
		br = 1;
	} else {
		br = brightness;
	}
}


//****************************************************************************
void WS2811_frame()
{
	unsigned int i;
	unsigned long this_led;
	unsigned int loop;

	for(i = 0; i < MAX_LED_COUNT; i++) {
		
		this_led = led_strip_colors[i];
		
		for(loop = 24; loop > 16; loop--) {
			if ((this_led >> loop) & 1 == 1){
				led[i].r |= 1 << (loop-16);
				} else {
				led[i].r &= ~(1 << (loop-16));
			}
		}
		for(loop = 16; loop > 8; loop--) {
			if ((this_led >> loop) & 1){
				led[i].g |= 1 << (loop-8);
				} else {
				led[i].g &= ~(1 << (loop-8));
			}
		}
		for(loop = 8; loop > 0; loop--) {
			if ((this_led >> loop) & 1){
				led[i].b |= (1 << loop);
				} else {
				led[i].b &= ~(1 << loop);
			}
		}
		led[i].r /= br;
		led[i].g /= br;
		led[i].b /= br;
	}
	
	// Uncomment if bluetooth communication causes led freeze
	//cli();
	ws2812_sendarray((uint8_t *)led,MAX_LED_COUNT*3);
	//sei();
	
	delay_us(75);
	delay_ms(speed);
}


//****************************************************************************
void WS2811_fixed(int frame_speed)
{
  unsigned int i;
  unsigned long this_led;
  unsigned int loop;

  for(i = 0; i < MAX_LED_COUNT; i++) {
	  
	  this_led = led_strip_colors[i];
	  
	  for(loop = 24; loop > 16; loop--) {
		  if ((this_led >> loop) & 1 == 1){
			  led[i].r |= 1 << (loop-16);
			  } else {
			  led[i].r &= ~(1 << (loop-16));
		  }
	  }
	  for(loop = 16; loop > 8; loop--) {
		  if ((this_led >> loop) & 1){
			  led[i].g |= 1 << (loop-8);
			  } else {
			  led[i].g &= ~(1 << (loop-8));
		  }
	  }
	  for(loop = 8; loop > 0; loop--) {
		  if ((this_led >> loop) & 1){
			  led[i].b |= (1 << loop);
			  } else {
			  led[i].b &= ~(1 << loop);
		  }
	  }
	   led[i].r -= 20;
	   led[i].g -= 20;
	   led[i].b -= 20;
  }
 
  // Uncomment if bluetooth communication causes led freeze
  //cli();
  ws2812_sendarray((uint8_t *)led,MAX_LED_COUNT*3);
  //sei();
  
  delay_us(75);
  delay_ms(frame_speed);
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
//*********************************************************************************
// Convert separate R,G,B into packed 32-bit RGB color.
// Packed format is always RGB, regardless of LED strand color order.
unsigned long Strip_Color(char g, char r, char b)
   {
   return ((unsigned long)g << 16) | ((unsigned long)r <<  8) | b;
   }
//****************************************************************************
void Set_Color(unsigned long rred, unsigned int ggreen, char bblue, char position)
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
//*********************************************************************************
// Input a value 0 to 255 to get a color value.
// The colours are a transition r - g - b - back to r.
unsigned long Wheel(char WheelPos)
{
  if(WheelPos < 85)
      {
      return Strip_Color(WheelPos * 3, 255 - WheelPos * 3, 0);
      }
  else if(WheelPos < 170)
      {
      WheelPos -= 85;
      return Strip_Color(255 - WheelPos * 3, 0, WheelPos * 3);
      }
  else
      {
      WheelPos -= 170;
      return Strip_Color(0, WheelPos * 3, 255 - WheelPos * 3);
      }
}
//****************************************************************************
void RandomColor(int loops, int frame_speed)
{
unsigned char a, b, c, d;

for (j = 0; j < loops; j++)
    {
    srand(j);
    a = rand() % 255;
    b = rand() % 255;
    c = rand() % 255;
    d = rand() % MAX_LED_COUNT;
//    d = (rand() * (MAX_LED_COUNT + 1) & 127);
    Set_Color(a, b, c, d);
    WS2811_fixed(frame_speed);
    }
}
//****************************************************************************
void ChaseRandom(int loops)
{
  unsigned int x;
  unsigned long new_color = 0;
for (j = 0; j < loops; j++)
  {
  //First, shuffle all the current colors down one spot on the strip
  for(x = (MAX_LED_COUNT - 1); x > 0; x--)
    {
    led_strip_colors[x] = led_strip_colors[x - 1];
    }
  //Now generate a new RGB color
  for(x = 0; x < 3; x++)
    {
    new_color <<= 8;
    new_color |= rand();
    }
  led_strip_colors[0] = new_color; //Add the new random color to the strip
  WS2811_frame();
  }
}
//****************************************************************************
void Fade_Strip(char rrednext, char ggreennext, char bbluenext, char rredlast, char ggreenlast, char bbluelast, int pos)
{
// ***Declare Temp Variables****************************
   float rlast, glast, blast, rcurr, gcurr, bcurr, rcalc, gcalc, bcalc;
   float MaxTemp, MaxStep, rtemp, gtemp, btemp;
   unsigned long temp, temp1;
   unsigned char goFlag, nnn, count;
   unsigned long rred;
   unsigned int ggreen;
   unsigned char bblue;
   
   count = 0;
   goFlag = 1;
   while(goFlag == 1)
      {
      rcurr =  rredlast;
      gcurr =  ggreenlast;
      bcurr =  bbluelast;
      rlast =  rrednext;
      glast =  ggreennext;
      blast =  bbluenext;
	  if (abs(rcurr - rlast) > abs(gcurr - glast)){
		  MaxTemp = abs(rcurr - rlast);
	  } else {
		  MaxTemp = abs(gcurr - glast);
	  }
      if (abs(bcurr - blast) > MaxTemp){
		  MaxStep = abs(bcurr - blast);
	  } else {
		  MaxStep = MaxTemp;
	  }
  
      rcalc = rlast;
      gcalc = glast;
      bcalc = blast;
     //*******************************************************
     // Calculate proportional fade rates
      for (nnn = 0; nnn < MaxStep; nnn++)
        {
        rtemp = (rcurr - rlast) / MaxStep;
        gtemp = (gcurr - glast) / MaxStep;
        btemp = (bcurr - blast) / MaxStep;
        rcalc = rcalc + rtemp;
        gcalc = gcalc + gtemp;
        bcalc = bcalc + btemp;
        rred = rcalc;
        ggreen = gcalc;
        bblue = bcalc;
     //*******************************************************
     // Construct 24bit word
        temp = 0;
        temp1 = 0;
        temp1 = rred << 16;
        temp = temp + temp1;
        temp1 = 0;
        temp1 = ggreen << 8;
        temp = temp + temp1;
        temp1 = 0;
        temp1 = bblue;
        temp = temp + temp1;

     //*******************************************************
     // Populate Faded Colors
     if(pos == 0)
        {
        for (count = 0; count < MAX_LED_COUNT + 1; ++count)
            {
            led_strip_colors[count] = temp;
            }
        }
     else
        {
        led_strip_colors[pos] = temp;
        }
      if(last_event == 1)
      {
      last_event = 0;
      return;
      }
     //*******************************************************
     // Delay and Display Frame
        WS2811_frame();
        } // End For MaxStep
        goFlag = 0;
    } // End While
}
//****************************************************************************
void Solid_Strip(char r1, char g1, char b1)
{
char pos;

    for(pos = 0; pos < MAX_LED_COUNT; pos++)
       {
       if(last_event == 1)
       {
       last_event = 0;
       return;
       }
       Set_Color(r1, g1, b1, pos);
       }
       WS2811_frame();
}
//****************************************************************************
void InsertColor(char r1, char g1, char b1)
{
  unsigned int x;
  unsigned long new_color = 0;

  for(x = (MAX_LED_COUNT - 1); x > 0; x--)
    {
    led_strip_colors[x] = led_strip_colors[x - 1];
    }
  Set_Color(r1, g1, b1, 0);
    if(last_event == 1)
    {
    last_event = 0;
    return;
    }
  WS2811_frame();

}
//****************************************************************************
void FillLeft(char r1, char g1, char b1)
{
  unsigned char count;
    for(count = MAX_LED_COUNT; count > 0; count--)
      {
      if(last_event == 1)
      {
      last_event = 0;
      return;
      }
      Set_Color(r1, g1, b1, count - 1);
      WS2811_frame();
      }
}
//****************************************************************************
void FillRight(char r1, char g1, char b1)
{
  char count;
    for(count = 0; count < MAX_LED_COUNT; count++)
      {
      if(last_event == 1)
      {
      last_event = 0;
      return;
      }
      Set_Color(r1, g1, b1, count);
      WS2811_frame();
      }
}
//****************************************************************************
//  Fill Right Any Position
void Fill_Any_PosR(char r1, char g1, char b1, char r2, char g2, char b2, char r3, char g3, char b3, char start, char end)
{
char pos;
   for(pos = start; pos < end; pos++)
      {
      if(last_event == 1)
      {
      last_event = 0;
      return;
      }
      if((pos%3) == 0) {Set_Color(r3, g3, b3, pos);}
      if((pos%3) == 1) {Set_Color(r2, g2, b2, pos);}
      if((pos%3) == 2) {Set_Color(r1, g1, b1, pos);}

      WS2811_frame();
      }
}// End Fill_Right3
//****************************************************************************
//  Fill Left Any Position
void Fill_Any_PosL(char r1, char g1, char b1, char r2, char g2, char b2, char r3, char g3, char b3, char start, char end)
{
char pos;
   for(pos = start; pos > end; pos--)
      {
      if(last_event == 1)
      {
      last_event = 0;
      return;
      }
      if((pos%3) == 0) {Set_Color(r1, g1, b1, pos - 1);}
      if((pos%3) == 1) {Set_Color(r2, g2, b2, pos - 1);}
      if((pos%3) == 2) {Set_Color(r3, g3, b3, pos - 1);}

      WS2811_frame();
      }
}// End Fill_Left3
//****************************************************************************
void Chase_3Color_Left(char r1, char g1, char b1, char r2, char g2, char b2, char r3, char g3, char b3, int repeat)
{
char i, strt, pos, loopframe;

      pos = MAX_LED_COUNT;
      for(loopframe = 0; loopframe < repeat; loopframe++)
         {
         // Increments Led Position every ++pos
         Set_Color(r3, g3, b3, pos + 2);
         Set_Color(r2, g2, b2, pos + 1);
         Set_Color(r1, g1, b1, pos);
         pos--;
         if (pos == MAX_LED_COUNT - 3)
            {
            pos = MAX_LED_COUNT;
            }

         for(strt = 0; strt < MAX_LED_COUNT; strt++)
            {
            led_strip_colors[strt] = led_strip_colors[strt + 1];
            }
            WS2811_frame();
         }// End for loopframe

}// End Chase_3Color_Left
//****************************************************************************
void Chase_3Color_Right(char r1, char g1, char b1, char r2, char g2, char b2, char r3, char g3, char b3, int repeat)
{
char i, loopframe;
char pos;
signed int strt;

      pos = 0;
      // Increments loopframe MAX_LED_COUNT counts including zero
      for(loopframe = 0; loopframe < repeat; loopframe++)
         {
         if(last_event == 1)
         {
         last_event = 0;
         return;
         }
         // Increments Led Position every ++pos
         Set_Color(r1, g1, b1, pos - 0);
         Set_Color(r2, g2, b2, pos - 1);
         Set_Color(r3, g3, b3, pos - 2);
         pos++;
         if(pos == 3)
            {
            pos = 0;
            }
         // Counts down from MAX_LED_COUNT to 0
         for(strt = MAX_LED_COUNT; strt >= 0; strt--)
            {
            led_strip_colors[strt + 1] = led_strip_colors[strt];
            }
            WS2811_frame();
         }// End for loopframe

}// End Chase_Right3
//****************************************************************************
void MovLeft_Chase_and_Clear(char position)
{
char pos, loopframe;
      for(loopframe = 0; loopframe < position; loopframe++)
         {
         if(last_event == 1)
         {
         last_event = 0;
         return;
         }
         for(pos = 0; pos < MAX_LED_COUNT; pos++)
            {
            led_strip_colors[pos] = led_strip_colors[pos + 1];
            }
         WS2811_frame();
         led_strip_colors[MAX_LED_COUNT] = 0x000000;
         }
}
//****************************************************************************
void MovRight_Chase_and_Clear(char position)
{
char pos, loopframe;
      for(loopframe = 0; loopframe < position; loopframe++)
         {
         if(last_event == 1)
         {
         last_event = 0;
         return;
         }
         for(pos = (MAX_LED_COUNT - 1); pos > 0; pos--)
            {
            led_strip_colors[pos] = led_strip_colors[pos - 1];
            }
         WS2811_frame();
         led_strip_colors[0] = 0x000000;
         }
}
//****************************************************************************
void Fill_Dot (char r1, char g1, char b1, char pos)
{
      Set_Color(r1, g1, b1, pos);
      WS2811_frame();

}// End Fill_Right3
//****************************************************************************
void Fill_Dot_PosR (char r1, char g1, char b1, char start, char end)
{
unsigned char pos;
   for(pos = start; pos <= end; pos++)
      {
      Set_Color(r1, g1, b1, pos);
      }
      WS2811_frame();

}// End Fill_Right3
//****************************************************************************
void Fill_Dot_PosL(char r1, char g1, char b1, char start, char end)
{
char pos;
   for(pos = start; pos >= end; pos--)
      {
      Set_Color(r1, g1, b1, pos - 1);
      }
      WS2811_frame();

}// End Fill_Left3
//*********************************************************************************
// Slightly different, this makes the rainbow equally distributed throughout
void rainbowCycleLeft(unsigned char cycles, int frame_speed)
{
  for(j = 0; j < 256 * cycles; j++)
      {
      for(i = 0; i < MAX_LED_COUNT; i++)
          {
          led_strip_colors[i] = Wheel(((i * 256 / MAX_LED_COUNT) + j) & 255);
          }
          WS2811_frame();
          //WS2811_fixed(frame_speed);
      }
}
//*********************************************************************************
// Slightly different, this makes the rainbow equally distributed throughout
void rainbowCycleRight(unsigned char cycles, int frame_speed)
{
  for(j = 256 * cycles; j--;)
      {
      for(i = 0; i < MAX_LED_COUNT; i++)
          {
          led_strip_colors[i] = Wheel(((i * 256 / MAX_LED_COUNT) + j) & 255);
          }
          WS2811_frame();
          //WS2811_fixed(frame_speed);
      }
}
//***************************************************************************
void CometLeft(unsigned char rred, unsigned char ggreen, unsigned char bblue)
{

  for(v = 0; v < MAX_LED_COUNT + tail - 1; v++)
      {
      Set_Color(rred, ggreen, bblue, v);
      Set_Color(rred / 2, ggreen / 2, bblue / 2, v - 1);
      Set_Color(rred / 4, ggreen / 4, bblue / 4, v - 2);
      Set_Color(rred / 8, ggreen / 8, bblue / 8, v - 3);
      Set_Color(rred / 16, ggreen / 16, bblue / 16, v - 4);
      Set_Color(rred / 32, ggreen / 32, bblue / 32, v - 5);
      Set_Color(rred / 64, ggreen / 64, bblue / 64, v - 6);
      Set_Color(rred / 128, ggreen / 128, bblue / 128, v - 7);
      Set_Color(0, 0, 0, v - 8);
      WS2811_frame();
      }
      return;
}
//*****************************************************************************
void CometRight(unsigned char rred, unsigned char ggreen, unsigned char bblue)
{
  for(v = MAX_LED_COUNT; v--;)
      {
      Set_Color(rred, ggreen, bblue, v - 9);
      Set_Color(rred / 2, ggreen / 2, bblue / 2, v - 8);
      Set_Color(rred / 4, ggreen / 4, bblue / 4, v - 7);
      Set_Color(rred / 8, ggreen / 8, bblue / 8, v - 6);
      Set_Color(rred / 16, ggreen / 16, bblue / 16, v - 5);
      Set_Color(rred / 32, ggreen / 32, bblue / 32, v - 4);
      Set_Color(rred / 64, ggreen / 64, bblue / 64, v - 3);
      Set_Color(rred / 128, ggreen / 128, bblue / 128, v - 2 );
      Set_Color(0, 0, 0, v - 1);
      WS2811_frame();
      }
}
//*****************************************************************************

void doTheBoogie(){
char pos, noc, strt, repeat;
char m, n, b, o;
unsigned char old[5], count[5];
unsigned char step, counter;

for(counter = 0; counter < 5; ++counter){
   Chase_3Color_Right(green, green, green, repeat);
   Chase_3Color_Left(red, red, red, repeat);
   Chase_3Color_Right(cyan, cyan, cyan, repeat);
   Chase_3Color_Left(blue, blue, blue, repeat);
   Chase_3Color_Right(magenta, magenta, magenta, repeat);
   Chase_3Color_Left(gold, gold, gold, repeat);
   Chase_3Color_Right(purple, purple, purple, repeat);
   Chase_3Color_Left(lime, lime, lime, repeat);
   Chase_3Color_Right(yellow, yellow, yellow, repeat);
   Chase_3Color_Left(skyblue, skyblue, skyblue, repeat);  
   Fade_Strip(skyblue, blue, 0);
   Fade_Strip(blue, cyan, 0);
   Fade_Strip(cyan, red, 0);
   Fade_Strip(red, crimson, 0);
   Fade_Strip(crimson, turq, 0);
   Fade_Strip(turq, skyblue, 0);
}

// Test Color Patterns,  create your own,  See WS2811.h for Examples

   delay_ms(1000);
   CometRight(red);

   delay_ms(1000);
   CometLeft(green);

   delay_ms(1000);
   CometRight(blue);

   delay_ms(1000);
   rainbowCycleRight(1, 5);

   delay_ms(1000);
   RandomColor(1000, 5);

   delay_ms(1000);
   rainbowCycleRight(1, 5);

for(counter = 0; counter < 2; ++counter)
   {
   InsertColor(black );
   InsertColor(turq);
   InsertColor(magenta );
   InsertColor(yellow);
   InsertColor(pink );
   InsertColor(red);
   InsertColor(white );
   InsertColor(crimson);
   InsertColor(green );
   InsertColor(orange);
   InsertColor(blue );
   InsertColor(olive);
   InsertColor(purple );
   InsertColor(lime);
   InsertColor(skyblue );
   InsertColor(gold);
   }

   delay_ms(2000);
   Fill_Dot_PosR(red, 0, 15);
   delay_ms(100);
   Fill_Dot_PosR(green, 20, 35);
   delay_ms(100);
   Fill_Dot_PosR(blue, 40, 55);
   delay_ms(2000);

   delay_ms(2000);
   Solid_Strip(black);
   delay_ms(2000);
   Solid_Strip(gold);
   delay_ms(2000);
   Solid_Strip(pink);
   delay_ms(2000);
   Solid_Strip(lime);
   delay_ms(2000);

   delay_ms(2000);
   Solid_Strip(red);

   delay_ms(2000);
 for(counter = 0; counter < 45; counter ++) {
   pos = rand() % MAX_LED_COUNT;   //was 127
   m = rand() % 63;
   b = rand() % 63;
   o = rand() % 63;
   srand(o);
   Fill_Dot(m, n, o, pos);
   }
   delay_ms(1000);

   MovLeft_Chase_and_Clear(MAX_LED_COUNT);

   delay_ms(2000);
   MovRight_Chase_and_Clear(MAX_LED_COUNT);

   delay_ms(2000);
   Solid_Strip(red);
   delay_ms(100);
   Solid_Strip(green);
   delay_ms(100);
   Solid_Strip(blue);
   delay_ms(100);
   Solid_Strip(orange);
   delay_ms(100);

   delay_ms(2000);
   rainbowCycleRight(2, 5);

   delay_ms(2000);
   rainbowCycleLeft(2, 5);

   delay_ms(2000);

   FillLeft(red);
   FillRight(black);
   FillRight(green);
   FillRight(black);
   FillRight(crimson);
   FillLeft(black);
   FillRight(orange);
   FillRight(black);
   FillRight(lime);
   FillRight(black);
   FillRight(black);
   FillLeft(white);
   FillLeft(black);
   FillRight(cyan);
   FillRight(black);

   delay_ms(2000);
for(counter = 0; counter < 5; ++counter)
   {
   Solid_Strip(red);
   delay_ms(200);
   Solid_Strip(green);
   delay_ms(200);
   Solid_Strip(blue);
   delay_ms(200);
   Solid_Strip(orange);
   delay_ms(200);
   Solid_Strip(purple);
   delay_ms(200);
   Solid_Strip(lime);
   delay_ms(200);
   Solid_Strip(yellow);
   delay_ms(200);
   Solid_Strip(cyan);
   delay_ms(200);
   Solid_Strip(magenta);
   delay_ms(200);
   Solid_Strip(olive);
   delay_ms(200);
   Solid_Strip(turq);
   delay_ms(200);
   Solid_Strip(pink);
   delay_ms(200);
   Solid_Strip(white);
   delay_ms(200);
   Solid_Strip(gold);
   delay_ms(200);
   Solid_Strip(skyblue);
   delay_ms(200);
   }
   
   delay_ms(2000);
   Chase_3Color_Right(cyan, orange, lime, 150);

   delay_ms(2000);
   Fade_Strip(black, orange, 0);
   Fade_Strip(orange, blue, 0);
   Fade_Strip(blue, red, 0);
   Fade_Strip(red, green, 0);
   Fade_Strip(green, purple, 0);
   delay_ms(2000);

   delay_ms(2000);
for(counter = 0; counter < 5; ++counter)
   {
   Chase_3Color_Right(green, green, green, repeat);
   Chase_3Color_Left(red, red, red, repeat);
   Chase_3Color_Right(cyan, cyan, cyan, repeat);
   Chase_3Color_Left(blue, blue, blue, repeat);
   Chase_3Color_Right(magenta, magenta, magenta, repeat);
   Chase_3Color_Left(gold, gold, gold, repeat);
   Chase_3Color_Right(purple, purple, purple, repeat);
   Chase_3Color_Left(lime, lime, lime, repeat);
   Chase_3Color_Right(yellow, yellow, yellow, repeat);
   Chase_3Color_Left(skyblue, skyblue, skyblue, repeat);
   }
   
   delay_ms(2000);
   Fill_Any_PosR(red, blue, green, 0, MAX_LED_COUNT);
   MovLeft_Chase_and_Clear(MAX_LED_COUNT);
   Fill_Any_PosR(red, green, yellow, MAX_LED_COUNT, 0);
   delay_ms(10);
   MovRight_Chase_and_Clear(MAX_LED_COUNT);
   FillLeft(purple);
   Fill_Any_PosR(magenta, black, black, MAX_LED_COUNT, 0);
   MovRight_Chase_and_Clear(MAX_LED_COUNT);
   Fill_Any_PosR(gold, gold, gold, 0, MAX_LED_COUNT);
   delay_ms(10);
   MovLeft_Chase_and_Clear(MAX_LED_COUNT);
   FillRight(skyblue);

   delay_ms(2000);
   Fill_Any_PosL(blue, yellow, yellow, MAX_LED_COUNT - 1, 0);
   delay_ms(100);
   Fill_Any_PosL(lime, orange, pink, MAX_LED_COUNT - 1, 0);
   delay_ms(100);
   Fill_Any_PosL(magenta, blue, yellow, MAX_LED_COUNT - 1, 0);
   delay_ms(100);
   Fill_Any_PosL(grey, purple, grey, MAX_LED_COUNT - 1, 0);
   delay_ms(100);
   Fill_Any_PosL(gold, cyan, crimson, MAX_LED_COUNT - 1, 0);
   delay_ms(100);
   Fill_Any_PosL(red, green, red, MAX_LED_COUNT - 1, 0);
   delay_ms(100);
   FillRight(black);
}

