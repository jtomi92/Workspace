/*
 * ws2812b_controller.cpp
 *
 * Created: 1/14/2017 5:07:35 PM
 * Author : tjozsa
 */ 

#include <global_include.h>
#include <stdio.h>

int currentProgram = 5;
int repeat = 20;
int color1[3];
int color2[3];
int frame_speed;

void LedNum_parameter(char * msg){
	char *p1,*p2;
	int i=0;
	p1 = strstr(msg,"lednum");
	p2 = strtok(p1,";");
	
	while (p2 != 0){
		switch (i){
			case 0:
				break;
			case 1:
				setMaxLedCount(atoi(p2));
				break;
		}
		i++;
		p2 = strtok(0,";");
	}
}

void Fix_parameter(char * msg){
	char *p1,*p2;
	int i=0;
	p1 = strstr(msg,"fix");
	p2 = strtok(p1,";");
	
	while (p2 != 0){
		switch (i){
			case 0:
			break;	// p2 = REL
			case 1:
			color1[0] = atoi(p2);	// P2 = 1
			break;
			case 2:
			color1[1] = atoi(p2);	// P2 = 2
			break;
			case 3:
			color1[2] = atoi(p2);	// SATÖBBI
			break;
		}
		i++;
		p2 = strtok(0,";");
	}
}

void Flash1_parameter(char * msg){
	char *p1,*p2;
	int i=0;
	p1 = strstr(msg,"flash1");
	p2 = strtok(p1,";");
	
	while (p2 != 0){
		switch (i){
			case 0:
			break;	// p2 = REL
			case 1:
			color1[0] = atoi(p2);	// P2 = 1
			break;
			case 2:
			color1[1] = atoi(p2);	// P2 = 2
			break;
			case 3:
			color1[2] = atoi(p2);	// SATÖBBI
			break;
			case 4:
			frame_speed = atoi(p2);	// SATÖBBI
			break;
		}
		i++;
		p2 = strtok(0,";");
	}
}

void Carousel1_parameter(char * msg){
	char *p1,*p2;
	int i=0;
	p1 = strstr(msg,"carousel1");
	p2 = strtok(p1,";");
	
	while (p2 != 0){
		switch (i){
			case 0:
			break;	// p2 = REL
			case 1:
			color1[0] = atoi(p2);	// P2 = 1
			break;
			case 2:
			color1[1] = atoi(p2);	// P2 = 2
			break;
			case 3:
			color1[2] = atoi(p2);	// SATÖBBI
			break;
			case 4:
			frame_speed = atoi(p2);	// SATÖBBI
			break;
		}
		i++;
		p2 = strtok(0,";");
	}
}

void Flash2_parameter(char * msg){
	char *p1,*p2;
	int i=0;
	p1 = strstr(msg,"flash2");
	p2 = strtok(p1,";");
	
	while (p2 != 0){
		switch (i){
			case 0:
			break;	// p2 = REL
			case 1:
			color1[0] = atoi(p2);	// P2 = 1
			break;
			case 2:
			color1[1] = atoi(p2);	// P2 = 2
			break;
			case 3:
			color1[2] = atoi(p2);	// SATÖBBI
			break;
			case 4:
			color2[0] = atoi(p2);	// P2 = 1
			break;
			case 5:
			color2[1] = atoi(p2);	// P2 = 2
			break;
			case 6:
			color2[2] = atoi(p2);	// SATÖBBI
			break;
			case 7:
			frame_speed = atoi(p2);
			break;
		}
		i++;
		p2 = strtok(0,";");
	}
}

void Carousel2_parameter(char * msg){
	char *p1,*p2;
	int i=0;
	p1 = strstr(msg,"carousel2");
	p2 = strtok(p1,";");
	
	while (p2 != 0){
		switch (i){
			case 0:
			break;	// p2 = REL
			case 1:
			color1[0] = atoi(p2);	// P2 = 1
			break;
			case 2:
			color1[1] = atoi(p2);	// P2 = 2
			break;
			case 3:
			color1[2] = atoi(p2);	// SATÖBBI
			break;
			case 4:
			color2[0] = atoi(p2);	// P2 = 1
			break;
			case 5:
			color2[1] = atoi(p2);	// P2 = 2
			break;
			case 6:
			color2[2] = atoi(p2);	// SATÖBBI
			break;
			case 7:
			frame_speed = atoi(p2);
			break;
		}
		i++;
		p2 = strtok(0,";");
	}
}

void blueToothStuff(){
	
	// Flag is set when UART interface receives \n or \r or \0
	if (data_received){
		if (strstr(bluetooth_buffer,"off") != 0){
			currentProgram = 5;
		} else if (strstr(bluetooth_buffer,"fix") != 0){
			Fix_parameter(bluetooth_buffer);
			currentProgram = 7;
		} else if (strstr(bluetooth_buffer,"flash1") != 0){
			Flash1_parameter(bluetooth_buffer);
			currentProgram = 8;
		} else if (strstr(bluetooth_buffer,"flash2") != 0){
			Flash2_parameter(bluetooth_buffer);
			currentProgram = 9;
		} else if (strstr(bluetooth_buffer,"carousel1") != 0){
			Carousel1_parameter(bluetooth_buffer);
			currentProgram = 10;
		} else if (strstr(bluetooth_buffer,"carousel2") != 0){
			Carousel2_parameter(bluetooth_buffer);
			currentProgram = 6;
		} else if (strstr(bluetooth_buffer,"carousel2") != 0){
			Carousel2_parameter(bluetooth_buffer);
			currentProgram = 6;
		} else if (strstr(bluetooth_buffer,"lednum") != 0){
			LedNum_parameter(bluetooth_buffer);
			Clear_Strip();
		}else {
			currentProgram = 5; //off
		}
		
		// Clear data buffer
		clear();
	}
}

int main(void)
{
	
	setup();
	
	// Set bluetooth's device name
	// Further AT Commands at: https://www.olimex.com/Products/Components/RF/BLUETOOTH-SERIAL-HC-06/resources/hc06.pdf page 15
	USART0_SendString("AT+NAMEKutyacsecs");

	setMaxLedCount(20);
	// Max brightness = 1, lumen lowers when the value increases
	setBrightness(5);
	setSpeed(0);
	
	// Clear led strip
	//Solid_Strip(black);  
	
	while (1){
		
		blueToothStuff();
		 
		switch (currentProgram){
			case 1:
				Fade_Strip(black, orange, 0);
				if (data_received){break;};
				Fade_Strip(orange, blue, 0);
				if (data_received){break;};
				Fade_Strip(blue, red, 0);
				if (data_received){break;};
				Fade_Strip(red, green, 0);
				if (data_received){break;};
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
				if (data_received){break;};
				delay_ms(100);
				Fill_Any_PosL(lime, orange, pink, MAX_LED_COUNT - 1, 0);
				if (data_received){break;};
				delay_ms(100);
				Fill_Any_PosL(magenta, blue, yellow, MAX_LED_COUNT - 1, 0);
				if (data_received){break;};
				delay_ms(100);
				Fill_Any_PosL(grey, purple, grey, MAX_LED_COUNT - 1, 0);
				if (data_received){break;};
				delay_ms(100);
				Fill_Any_PosL(gold, cyan, crimson, MAX_LED_COUNT - 1, 0);
				if (data_received){break;};
				delay_ms(100);
				Fill_Any_PosL(red, green, red, MAX_LED_COUNT - 1, 0);
				break;
			case 0:
				Chase_3Color_Right(green, green, green, repeat);
				if (data_received){break;};
				Chase_3Color_Left(red, red, red, repeat);
				if (data_received){break;};
				Chase_3Color_Right(cyan, cyan, cyan, repeat);
				if (data_received){break;};
				Chase_3Color_Left(blue, blue, blue, repeat);
				if (data_received){break;};
				Chase_3Color_Right(magenta, magenta, magenta, repeat);
				if (data_received){break;};
				Chase_3Color_Left(gold, gold, gold, repeat);
				if (data_received){break;};
				Chase_3Color_Right(purple, purple, purple, repeat);
				if (data_received){break;};
				Chase_3Color_Left(lime, lime, lime, repeat);
				if (data_received){break;};
				Chase_3Color_Right(yellow, yellow, yellow, repeat);
				if (data_received){break;};
				Chase_3Color_Left(skyblue, skyblue, skyblue, repeat);
				break;
			case 5: //off
				Clear_Strip();
				break;
			case 6: //carousel2
				CometLeft_Speed_2c(color1[0],color1[1],color1[2],color2[0],color2[1],color2[2],frame_speed*500);
				break;
			case 7: //fix
				Solid_Strip(color1[0],color1[1],color1[2]);
				break;
			case 8: //flash1
				Solid_Strip(color1[0],color1[1],color1[2]);
				for(int i = 0; i < frame_speed; i++){
					delay_ms(500);
					if (data_received){break;}
				}
				Clear_Strip();
				for(int i = 0; i < frame_speed; i++){
					delay_ms(500);
					if (data_received){break;}
				}
				break;
			case 9: //flash2
				Solid_Strip(color1[0],color1[1],color1[2]);
				for(int i = 0; i < frame_speed; i++){
					delay_ms(500);
					if (data_received){break;}
				}
				Solid_Strip(color2[0],color2[1],color2[2]);
				for(int i = 0; i < frame_speed; i++){
					delay_ms(500);
					if (data_received){break;}
				}
				break;
			case 10: //carousel1
				CometLeft_Speed(color1[0],color1[1],color1[2],frame_speed*500);
				break;
		}
		//doTheBoogie();
	}
}

