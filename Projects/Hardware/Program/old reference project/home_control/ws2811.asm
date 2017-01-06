
_WS2811_frame:

;ws2811.h,30 :: 		void WS2811_frame()
;ws2811.h,36 :: 		for(i = 0; i < MAX_LED_COUNT; i++)
	CLRF        WS2811_frame_i_L0+0 
	CLRF        WS2811_frame_i_L0+1 
L_WS2811_frame0:
	MOVLW       0
	SUBWF       WS2811_frame_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__WS2811_frame14
	MOVF        _MAX_LED_COUNT+0, 0 
	SUBWF       WS2811_frame_i_L0+0, 0 
L__WS2811_frame14:
	BTFSC       STATUS+0, 0 
	GOTO        L_WS2811_frame1
;ws2811.h,38 :: 		this_led = led_strip_colors[i];
	MOVF        WS2811_frame_i_L0+0, 0 
	MOVWF       R0 
	MOVF        WS2811_frame_i_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _led_strip_colors+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_led_strip_colors+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       WS2811_frame_this_led_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       WS2811_frame_this_led_L0+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       WS2811_frame_this_led_L0+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       WS2811_frame_this_led_L0+3 
;ws2811.h,39 :: 		for(loop = 0; loop < 24; loop++)
	CLRF        WS2811_frame_loop_L0+0 
	CLRF        WS2811_frame_loop_L0+1 
L_WS2811_frame3:
	MOVLW       0
	SUBWF       WS2811_frame_loop_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__WS2811_frame15
	MOVLW       24
	SUBWF       WS2811_frame_loop_L0+0, 0 
L__WS2811_frame15:
	BTFSC       STATUS+0, 0 
	GOTO        L_WS2811_frame4
;ws2811.h,41 :: 		if(testbit(this_led, 23))
	BTFSS       WS2811_frame_this_led_L0+2, 7 
	GOTO        L_WS2811_frame6
;ws2811.h,43 :: 		spi1_write(ws2811_one);
	MOVLW       240
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;ws2811.h,44 :: 		}
	GOTO        L_WS2811_frame7
L_WS2811_frame6:
;ws2811.h,47 :: 		spi1_write(ws2811_zero);
	MOVLW       128
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;ws2811.h,48 :: 		}
L_WS2811_frame7:
;ws2811.h,49 :: 		this_led *= 2;  // march all the bits one position to the left so
	RLCF        WS2811_frame_this_led_L0+0, 1 
	BCF         WS2811_frame_this_led_L0+0, 0 
	RLCF        WS2811_frame_this_led_L0+1, 1 
	RLCF        WS2811_frame_this_led_L0+2, 1 
	RLCF        WS2811_frame_this_led_L0+3, 1 
;ws2811.h,39 :: 		for(loop = 0; loop < 24; loop++)
	INFSNZ      WS2811_frame_loop_L0+0, 1 
	INCF        WS2811_frame_loop_L0+1, 1 
;ws2811.h,50 :: 		}
	GOTO        L_WS2811_frame3
L_WS2811_frame4:
;ws2811.h,36 :: 		for(i = 0; i < MAX_LED_COUNT; i++)
	INFSNZ      WS2811_frame_i_L0+0, 1 
	INCF        WS2811_frame_i_L0+1, 1 
;ws2811.h,51 :: 		}
	GOTO        L_WS2811_frame0
L_WS2811_frame1:
;ws2811.h,52 :: 		delay_us(75);
	MOVLW       99
	MOVWF       R13, 0
L_WS2811_frame8:
	DECFSZ      R13, 1, 1
	BRA         L_WS2811_frame8
	NOP
	NOP
;ws2811.h,54 :: 		}
L_end_WS2811_frame:
	RETURN      0
; end of _WS2811_frame

_WS2811_LEDCount:

;ws2811.h,58 :: 		void WS2811_LEDCount(char vari)
;ws2811.h,60 :: 		MAX_LED_COUNT = vari + 6;
	MOVLW       6
	ADDWF       FARG_WS2811_LEDCount_vari+0, 0 
	MOVWF       _MAX_LED_COUNT+0 
;ws2811.h,61 :: 		return;
;ws2811.h,62 :: 		}
L_end_WS2811_LEDCount:
	RETURN      0
; end of _WS2811_LEDCount

_Clear_Strip:

;ws2811.h,64 :: 		void Clear_Strip()
;ws2811.h,68 :: 		for(pos = 0; pos < MAX_LED_COUNT; pos++)
	CLRF        Clear_Strip_pos_L0+0 
L_Clear_Strip9:
	MOVF        _MAX_LED_COUNT+0, 0 
	SUBWF       Clear_Strip_pos_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Clear_Strip10
;ws2811.h,70 :: 		led_strip_colors[pos] = 0x000000;
	MOVF        Clear_Strip_pos_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _led_strip_colors+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_led_strip_colors+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;ws2811.h,68 :: 		for(pos = 0; pos < MAX_LED_COUNT; pos++)
	INCF        Clear_Strip_pos_L0+0, 1 
;ws2811.h,71 :: 		}
	GOTO        L_Clear_Strip9
L_Clear_Strip10:
;ws2811.h,72 :: 		WS2811_frame();
	CALL        _WS2811_frame+0, 0
;ws2811.h,73 :: 		}
L_end_Clear_Strip:
	RETURN      0
; end of _Clear_Strip

_Set_Color:

;ws2811.h,77 :: 		char position)
;ws2811.h,82 :: 		temp1 = 0;
	CLRF        Set_Color_temp1_L0+0 
	CLRF        Set_Color_temp1_L0+1 
	CLRF        Set_Color_temp1_L0+2 
	CLRF        Set_Color_temp1_L0+3 
;ws2811.h,83 :: 		temp1 = (rred / brightness) << 16;
	MOVF        _brightness+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_Set_Color_rred+0, 0 
	MOVWF       R0 
	MOVF        FARG_Set_Color_rred+1, 0 
	MOVWF       R1 
	MOVF        FARG_Set_Color_rred+2, 0 
	MOVWF       R2 
	MOVF        FARG_Set_Color_rred+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R1, 0 
	MOVWF       FLOC__Set_Color+3 
	MOVF        R0, 0 
	MOVWF       FLOC__Set_Color+2 
	CLRF        FLOC__Set_Color+0 
	CLRF        FLOC__Set_Color+1 
	MOVF        FLOC__Set_Color+0, 0 
	MOVWF       Set_Color_temp1_L0+0 
	MOVF        FLOC__Set_Color+1, 0 
	MOVWF       Set_Color_temp1_L0+1 
	MOVF        FLOC__Set_Color+2, 0 
	MOVWF       Set_Color_temp1_L0+2 
	MOVF        FLOC__Set_Color+3, 0 
	MOVWF       Set_Color_temp1_L0+3 
;ws2811.h,85 :: 		temp1 = 0;
	CLRF        Set_Color_temp1_L0+0 
	CLRF        Set_Color_temp1_L0+1 
	CLRF        Set_Color_temp1_L0+2 
	CLRF        Set_Color_temp1_L0+3 
;ws2811.h,86 :: 		temp1 = (ggreen / brightness) << 8;
	MOVF        _brightness+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_Set_Color_ggreen+0, 0 
	MOVWF       R0 
	MOVF        FARG_Set_Color_ggreen+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	CLRF        Set_Color_temp1_L0+3 
	MOVF        R1, 0 
	MOVWF       Set_Color_temp1_L0+2 
	MOVF        R0, 0 
	MOVWF       Set_Color_temp1_L0+1 
	CLRF        Set_Color_temp1_L0+0 
	MOVLW       0
	MOVWF       Set_Color_temp1_L0+2 
	MOVWF       Set_Color_temp1_L0+3 
;ws2811.h,87 :: 		temp = temp + temp1;
	MOVF        Set_Color_temp1_L0+0, 0 
	ADDWF       FLOC__Set_Color+0, 1 
	MOVF        Set_Color_temp1_L0+1, 0 
	ADDWFC      FLOC__Set_Color+1, 1 
	MOVF        Set_Color_temp1_L0+2, 0 
	ADDWFC      FLOC__Set_Color+2, 1 
	MOVF        Set_Color_temp1_L0+3, 0 
	ADDWFC      FLOC__Set_Color+3, 1 
;ws2811.h,88 :: 		temp1 = 0;
	CLRF        Set_Color_temp1_L0+0 
	CLRF        Set_Color_temp1_L0+1 
	CLRF        Set_Color_temp1_L0+2 
	CLRF        Set_Color_temp1_L0+3 
;ws2811.h,89 :: 		temp1 = (bblue / brightness);
	MOVF        _brightness+0, 0 
	MOVWF       R4 
	MOVF        FARG_Set_Color_bblue+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R0, 0 
	MOVWF       Set_Color_temp1_L0+0 
	MOVLW       0
	MOVWF       Set_Color_temp1_L0+1 
	MOVWF       Set_Color_temp1_L0+2 
	MOVWF       Set_Color_temp1_L0+3 
;ws2811.h,90 :: 		temp = temp + temp1;
	MOVF        Set_Color_temp1_L0+0, 0 
	ADDWF       FLOC__Set_Color+0, 0 
	MOVWF       R3 
	MOVF        Set_Color_temp1_L0+1, 0 
	ADDWFC      FLOC__Set_Color+1, 0 
	MOVWF       R4 
	MOVF        Set_Color_temp1_L0+2, 0 
	ADDWFC      FLOC__Set_Color+2, 0 
	MOVWF       R5 
	MOVF        Set_Color_temp1_L0+3, 0 
	ADDWFC      FLOC__Set_Color+3, 0 
	MOVWF       R6 
;ws2811.h,91 :: 		led_strip_colors[position] = temp;
	MOVF        FARG_Set_Color_position+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _led_strip_colors+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_led_strip_colors+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
	MOVF        R4, 0 
	MOVWF       POSTINC1+0 
	MOVF        R5, 0 
	MOVWF       POSTINC1+0 
	MOVF        R6, 0 
	MOVWF       POSTINC1+0 
;ws2811.h,92 :: 		}
L_end_Set_Color:
	RETURN      0
; end of _Set_Color

_Fill_Dot_PosR:

;ws2811.h,95 :: 		void Fill_Dot_PosR (char r1, char g1, char b1, char pos)
;ws2811.h,97 :: 		Set_Color(r1, g1, b1, pos);
	MOVF        FARG_Fill_Dot_PosR_r1+0, 0 
	MOVWF       FARG_Set_Color_rred+0 
	MOVLW       0
	MOVWF       FARG_Set_Color_rred+1 
	MOVWF       FARG_Set_Color_rred+2 
	MOVWF       FARG_Set_Color_rred+3 
	MOVF        FARG_Fill_Dot_PosR_g1+0, 0 
	MOVWF       FARG_Set_Color_ggreen+0 
	MOVLW       0
	MOVWF       FARG_Set_Color_ggreen+1 
	MOVF        FARG_Fill_Dot_PosR_b1+0, 0 
	MOVWF       FARG_Set_Color_bblue+0 
	MOVF        FARG_Fill_Dot_PosR_pos+0, 0 
	MOVWF       FARG_Set_Color_position+0 
	CALL        _Set_Color+0, 0
;ws2811.h,98 :: 		WS2811_frame();
	CALL        _WS2811_frame+0, 0
;ws2811.h,99 :: 		}// End Fill_Right3
L_end_Fill_Dot_PosR:
	RETURN      0
; end of _Fill_Dot_PosR

_ws2811_init:

;ws2811.c,3 :: 		void ws2811_init(char ledCount)
;ws2811.c,7 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE,
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
;ws2811.c,8 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;ws2811.c,9 :: 		delay_ms(250);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_ws2811_init12:
	DECFSZ      R13, 1, 1
	BRA         L_ws2811_init12
	DECFSZ      R12, 1, 1
	BRA         L_ws2811_init12
	DECFSZ      R11, 1, 1
	BRA         L_ws2811_init12
	NOP
	NOP
;ws2811.c,11 :: 		WS2811_LEDCount(ledCount);
	MOVF        FARG_ws2811_init_ledCount+0, 0 
	MOVWF       FARG_WS2811_LEDCount_vari+0 
	CALL        _WS2811_LEDCount+0, 0
;ws2811.c,13 :: 		Clear_Strip();
	CALL        _Clear_Strip+0, 0
;ws2811.c,14 :: 		}
L_end_ws2811_init:
	RETURN      0
; end of _ws2811_init

_setLedRed:

;ws2811.c,16 :: 		void setLedRed(char pos){
;ws2811.c,18 :: 		Fill_Dot_PosR(red, pos);
	CLRF        FARG_Fill_Dot_PosR_r1+0 
	MOVLW       255
	MOVWF       FARG_Fill_Dot_PosR_g1+0 
	CLRF        FARG_Fill_Dot_PosR_b1+0 
	MOVF        FARG_setLedRed_pos+0, 0 
	MOVWF       FARG_Fill_Dot_PosR_pos+0 
	CALL        _Fill_Dot_PosR+0, 0
;ws2811.c,19 :: 		}
L_end_setLedRed:
	RETURN      0
; end of _setLedRed

_setLedGreen:

;ws2811.c,21 :: 		void setLedGreen(char pos){
;ws2811.c,23 :: 		Fill_Dot_PosR(green, pos);
	MOVLW       255
	MOVWF       FARG_Fill_Dot_PosR_r1+0 
	CLRF        FARG_Fill_Dot_PosR_g1+0 
	CLRF        FARG_Fill_Dot_PosR_b1+0 
	MOVF        FARG_setLedGreen_pos+0, 0 
	MOVWF       FARG_Fill_Dot_PosR_pos+0 
	CALL        _Fill_Dot_PosR+0, 0
;ws2811.c,24 :: 		}
L_end_setLedGreen:
	RETURN      0
; end of _setLedGreen

_setLedOrange:

;ws2811.c,26 :: 		void setLedOrange(char pos){
;ws2811.c,28 :: 		Fill_Dot_PosR(orange, pos);
	MOVLW       20
	MOVWF       FARG_Fill_Dot_PosR_r1+0 
	MOVLW       255
	MOVWF       FARG_Fill_Dot_PosR_g1+0 
	CLRF        FARG_Fill_Dot_PosR_b1+0 
	MOVF        FARG_setLedOrange_pos+0, 0 
	MOVWF       FARG_Fill_Dot_PosR_pos+0 
	CALL        _Fill_Dot_PosR+0, 0
;ws2811.c,29 :: 		}
L_end_setLedOrange:
	RETURN      0
; end of _setLedOrange
