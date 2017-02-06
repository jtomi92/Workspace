/*
 * ws2812b_controller.cpp
 *
 * Created: 1/14/2017 5:07:35 PM
 * Author : tjozsa
 */ 

#include <global_include.h>

int currentProgram = 3;
int repeat = 20;

void blueToothStuff(){
	
	// Flag is set when UART interface receives \n or \r or \0
	if (data_received){
		if (strstr(bluetooth_buffer,"1") != 0){
			currentProgram = 1;
		} else if (strstr(bluetooth_buffer,"2") != 0){
			currentProgram = 2;
		} else if (strstr(bluetooth_buffer,"3") != 0){
			currentProgram = 3;
		} else if (strstr(bluetooth_buffer,"4") != 0){
			currentProgram = 4;
		} else {
			currentProgram = 0;
		}
		 
		clear();
	}
}

int main(void)
{
	
	setup();
	
	// Set bluetooth's device name
	// Further AT Commands at: https://www.olimex.com/Products/Components/RF/BLUETOOTH-SERIAL-HC-06/resources/hc06.pdf page 15
	USART0_SendString("AT+NAMEKutyacsecs\r\n");

	setMaxLedCount(20);
	// Max brightness = 1, lumen lowers when the value increases
	setBrightness(5);
	setSpeed(0);
	
	// Clear led strip
	Solid_Strip(black);  
	
	while (1){
		
		blueToothStuff();
		 
		switch (currentProgram){
			case 1:
				Fade_Strip(black, orange, 0);
				Fade_Strip(orange, blue, 0);
				Fade_Strip(blue, red, 0);
				Fade_Strip(red, green, 0);
				Fade_Strip(green, purple, 0);
				break;
			case 2:
				rainbowCycleRight(1, 5);
				break;
			case 3:
				rainbowCycleLeft(1, 5);
				break;
			case 4:
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
				break;
			case 0:
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
				break;
		}
		//doTheBoogie();
	}
}

