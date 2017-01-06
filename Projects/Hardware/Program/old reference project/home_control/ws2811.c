#include "WS2811.h"

void ws2811_init(char ledCount)
{

// Set up MCU for proper bit rate for WS2811 LED
  SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE,
  _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
  delay_ms(250);

  WS2811_LEDCount(ledCount);

  Clear_Strip();
}

void setLedRed(char pos){

   Fill_Dot_PosR(red, pos);
}

void setLedGreen(char pos){

    Fill_Dot_PosR(green, pos);
}

void setLedOrange(char pos){

    Fill_Dot_PosR(orange, pos);
}