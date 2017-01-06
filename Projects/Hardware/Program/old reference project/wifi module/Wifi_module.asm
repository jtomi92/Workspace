
_itoa:

;Wifi_module.c,272 :: 		char * itoa(int i, char b[]){
;Wifi_module.c,274 :: 		char* p = b;
	MOVF        FARG_itoa_b+0, 0 
	MOVWF       itoa_p_L0+0 
	MOVF        FARG_itoa_b+1, 0 
	MOVWF       itoa_p_L0+1 
;Wifi_module.c,276 :: 		if(i<0){
	MOVLW       128
	XORWF       FARG_itoa_i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__itoa370
	MOVLW       0
	SUBWF       FARG_itoa_i+0, 0 
L__itoa370:
	BTFSC       STATUS+0, 0 
	GOTO        L_itoa0
;Wifi_module.c,277 :: 		*p++ = '-';
	MOVFF       itoa_p_L0+0, FSR1
	MOVFF       itoa_p_L0+1, FSR1H
	MOVLW       45
	MOVWF       POSTINC1+0 
	INFSNZ      itoa_p_L0+0, 1 
	INCF        itoa_p_L0+1, 1 
;Wifi_module.c,278 :: 		i *= -1;
	MOVF        FARG_itoa_i+0, 0 
	MOVWF       R0 
	MOVF        FARG_itoa_i+1, 0 
	MOVWF       R1 
	MOVLW       255
	MOVWF       R4 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        R1, 0 
	MOVWF       FARG_itoa_i+1 
;Wifi_module.c,279 :: 		}
L_itoa0:
;Wifi_module.c,280 :: 		shifter = i;
	MOVF        FARG_itoa_i+0, 0 
	MOVWF       itoa_shifter_L0+0 
	MOVF        FARG_itoa_i+1, 0 
	MOVWF       itoa_shifter_L0+1 
;Wifi_module.c,281 :: 		do{ //Move to where representation ends
L_itoa1:
;Wifi_module.c,282 :: 		++p;
	INFSNZ      itoa_p_L0+0, 1 
	INCF        itoa_p_L0+1, 1 
;Wifi_module.c,283 :: 		shifter = shifter/10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        itoa_shifter_L0+0, 0 
	MOVWF       R0 
	MOVF        itoa_shifter_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       itoa_shifter_L0+0 
	MOVF        R1, 0 
	MOVWF       itoa_shifter_L0+1 
;Wifi_module.c,284 :: 		}while(shifter);
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_itoa1
;Wifi_module.c,285 :: 		*p = '\0';
	MOVFF       itoa_p_L0+0, FSR1
	MOVFF       itoa_p_L0+1, FSR1H
	CLRF        POSTINC1+0 
;Wifi_module.c,286 :: 		do{ //Move back, inserting digits as u go
L_itoa4:
;Wifi_module.c,287 :: 		*--p = digit[i%10];
	MOVLW       1
	SUBWF       itoa_p_L0+0, 1 
	MOVLW       0
	SUBWFB      itoa_p_L0+1, 1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_itoa_i+0, 0 
	MOVWF       R0 
	MOVF        FARG_itoa_i+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       itoa_digit_L0+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(itoa_digit_L0+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(itoa_digit_L0+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVFF       itoa_p_L0+0, FSR1
	MOVFF       itoa_p_L0+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,288 :: 		i = i/10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_itoa_i+0, 0 
	MOVWF       R0 
	MOVF        FARG_itoa_i+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        R1, 0 
	MOVWF       FARG_itoa_i+1 
;Wifi_module.c,289 :: 		}while(i);
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_itoa4
;Wifi_module.c,290 :: 		return b;
	MOVF        FARG_itoa_b+0, 0 
	MOVWF       R0 
	MOVF        FARG_itoa_b+1, 0 
	MOVWF       R1 
;Wifi_module.c,291 :: 		}
L_end_itoa:
	RETURN      0
; end of _itoa

_M_Delete_File:

;Wifi_module.c,294 :: 		void M_Delete_File() {
;Wifi_module.c,295 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;Wifi_module.c,296 :: 		Mmc_Fat_Assign("MEM.TXT", 0);
	MOVLW       ?lstr1_Wifi_module+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(?lstr1_Wifi_module+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	CLRF        FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
;Wifi_module.c,297 :: 		Mmc_Fat_Delete();
	CALL        _Mmc_Fat_Delete+0, 0
;Wifi_module.c,298 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,299 :: 		}
L_end_M_Delete_File:
	RETURN      0
; end of _M_Delete_File

_M_Open_File_Append:

;Wifi_module.c,301 :: 		void M_Open_File_Append(char *toWrite) {
;Wifi_module.c,303 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;Wifi_module.c,304 :: 		if (!Mmc_Fat_Assign("MEM.TXT", 0)){             // only memory will be appended so no need for filename parameter
	MOVLW       ?lstr2_Wifi_module+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(?lstr2_Wifi_module+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	CLRF        FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_M_Open_File_Append7
;Wifi_module.c,305 :: 		Mmc_Fat_Assign("MEM.TXT", 0xA0);          // Find existing file or create a new one
	MOVLW       ?lstr3_Wifi_module+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(?lstr3_Wifi_module+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	MOVLW       160
	MOVWF       FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
;Wifi_module.c,306 :: 		Mmc_Fat_Rewrite();
	CALL        _Mmc_Fat_Rewrite+0, 0
;Wifi_module.c,307 :: 		} else {
	GOTO        L_M_Open_File_Append8
L_M_Open_File_Append7:
;Wifi_module.c,308 :: 		Mmc_Fat_Append();
	CALL        _Mmc_Fat_Append+0, 0
;Wifi_module.c,309 :: 		}                                  // Prepare file for append
L_M_Open_File_Append8:
;Wifi_module.c,310 :: 		Mmc_Fat_Write(toWrite, System.size);             // Write data to assigned file
	MOVF        FARG_M_Open_File_Append_toWrite+0, 0 
	MOVWF       FARG_Mmc_Fat_Write_fdata+0 
	MOVF        FARG_M_Open_File_Append_toWrite+1, 0 
	MOVWF       FARG_Mmc_Fat_Write_fdata+1 
	MOVF        _System+263, 0 
	MOVWF       FARG_Mmc_Fat_Write_len+0 
	MOVLW       0
	MOVWF       FARG_Mmc_Fat_Write_len+1 
	CALL        _Mmc_Fat_Write+0, 0
;Wifi_module.c,311 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,312 :: 		}
L_end_M_Open_File_Append:
	RETURN      0
; end of _M_Open_File_Append

_clearReadLine:

;Wifi_module.c,317 :: 		void clearReadLine(){
;Wifi_module.c,319 :: 		for (i=0;i<sizeof(System.readLine)-2;i++){
	CLRF        clearReadLine_i_L0+0 
	CLRF        clearReadLine_i_L0+1 
L_clearReadLine9:
	MOVLW       128
	XORWF       clearReadLine_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clearReadLine374
	MOVLW       148
	SUBWF       clearReadLine_i_L0+0, 0 
L__clearReadLine374:
	BTFSC       STATUS+0, 0 
	GOTO        L_clearReadLine10
;Wifi_module.c,320 :: 		System.readLine[i] = 'a';
	MOVLW       _System+12
	ADDWF       clearReadLine_i_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_System+12)
	ADDWFC      clearReadLine_i_L0+1, 0 
	MOVWF       FSR1H 
	MOVLW       97
	MOVWF       POSTINC1+0 
;Wifi_module.c,319 :: 		for (i=0;i<sizeof(System.readLine)-2;i++){
	INFSNZ      clearReadLine_i_L0+0, 1 
	INCF        clearReadLine_i_L0+1, 1 
;Wifi_module.c,321 :: 		}
	GOTO        L_clearReadLine9
L_clearReadLine10:
;Wifi_module.c,322 :: 		strcpy(System.readLine,"");
	MOVLW       _System+12
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+12)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr4_Wifi_module+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr4_Wifi_module+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,323 :: 		System.isInputReady = 0;
	CLRF        _System+177 
;Wifi_module.c,324 :: 		System.index = 0;
	CLRF        _System+172 
	CLRF        _System+173 
;Wifi_module.c,325 :: 		}
L_end_clearReadLine:
	RETURN      0
; end of _clearReadLine

_waitForInput:

;Wifi_module.c,327 :: 		int waitForInput(char *input, int timeout){
;Wifi_module.c,328 :: 		int i = 0;int mils = 0;
	CLRF        waitForInput_i_L0+0 
	CLRF        waitForInput_i_L0+1 
	CLRF        waitForInput_mils_L0+0 
	CLRF        waitForInput_mils_L0+1 
;Wifi_module.c,330 :: 		memset(buffer,'\0',sizeof(buffer)-1);
	MOVLW       waitForInput_buffer_L0+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(waitForInput_buffer_L0+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       29
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;Wifi_module.c,331 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;Wifi_module.c,332 :: 		while (mils <= timeout*1000){
L_waitForInput12:
	MOVF        FARG_waitForInput_timeout+0, 0 
	MOVWF       R0 
	MOVF        FARG_waitForInput_timeout+1, 0 
	MOVWF       R1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       128
	XORWF       R1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       waitForInput_mils_L0+1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__waitForInput376
	MOVF        waitForInput_mils_L0+0, 0 
	SUBWF       R0, 0 
L__waitForInput376:
	BTFSS       STATUS+0, 0 
	GOTO        L_waitForInput13
;Wifi_module.c,333 :: 		if (UART1_Data_Ready()){
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_waitForInput14
;Wifi_module.c,334 :: 		if (i == 30) i = 0;
	MOVLW       0
	XORWF       waitForInput_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__waitForInput377
	MOVLW       30
	XORWF       waitForInput_i_L0+0, 0 
L__waitForInput377:
	BTFSS       STATUS+0, 2 
	GOTO        L_waitForInput15
	CLRF        waitForInput_i_L0+0 
	CLRF        waitForInput_i_L0+1 
L_waitForInput15:
;Wifi_module.c,335 :: 		buffer[i++] = UART1_Read();
	MOVLW       waitForInput_buffer_L0+0
	ADDWF       waitForInput_i_L0+0, 0 
	MOVWF       FLOC__waitForInput+0 
	MOVLW       hi_addr(waitForInput_buffer_L0+0)
	ADDWFC      waitForInput_i_L0+1, 0 
	MOVWF       FLOC__waitForInput+1 
	CALL        _UART1_Read+0, 0
	MOVFF       FLOC__waitForInput+0, FSR1
	MOVFF       FLOC__waitForInput+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      waitForInput_i_L0+0, 1 
	INCF        waitForInput_i_L0+1, 1 
;Wifi_module.c,336 :: 		if (strstr(buffer,input) != 0){
	MOVLW       waitForInput_buffer_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(waitForInput_buffer_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVF        FARG_waitForInput_input+0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        FARG_waitForInput_input+1, 0 
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__waitForInput378
	MOVLW       0
	XORWF       R0, 0 
L__waitForInput378:
	BTFSC       STATUS+0, 2 
	GOTO        L_waitForInput16
;Wifi_module.c,337 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,338 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	GOTO        L_end_waitForInput
;Wifi_module.c,339 :: 		}
L_waitForInput16:
;Wifi_module.c,340 :: 		} else {
	GOTO        L_waitForInput17
L_waitForInput14:
;Wifi_module.c,341 :: 		mils++;
	INFSNZ      waitForInput_mils_L0+0, 1 
	INCF        waitForInput_mils_L0+1, 1 
;Wifi_module.c,342 :: 		delay_ms(1);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_waitForInput18:
	DECFSZ      R13, 1, 1
	BRA         L_waitForInput18
	DECFSZ      R12, 1, 1
	BRA         L_waitForInput18
	NOP
;Wifi_module.c,343 :: 		}
L_waitForInput17:
;Wifi_module.c,344 :: 		}
	GOTO        L_waitForInput12
L_waitForInput13:
;Wifi_module.c,345 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,347 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;Wifi_module.c,348 :: 		}
L_end_waitForInput:
	RETURN      0
; end of _waitForInput

_wait:

;Wifi_module.c,351 :: 		char * wait(char* input, int timeout){
;Wifi_module.c,352 :: 		int i = 0;int mils = 0;
	CLRF        wait_i_L0+0 
	CLRF        wait_i_L0+1 
	CLRF        wait_mils_L0+0 
	CLRF        wait_mils_L0+1 
;Wifi_module.c,354 :: 		memset(buffer,'\0',sizeof(buffer)-1);
	MOVLW       wait_buffer_L0+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(wait_buffer_L0+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       69
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;Wifi_module.c,355 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;Wifi_module.c,356 :: 		while (mils <= timeout*1000){
L_wait19:
	MOVF        FARG_wait_timeout+0, 0 
	MOVWF       R0 
	MOVF        FARG_wait_timeout+1, 0 
	MOVWF       R1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       128
	XORWF       R1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       wait_mils_L0+1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__wait380
	MOVF        wait_mils_L0+0, 0 
	SUBWF       R0, 0 
L__wait380:
	BTFSS       STATUS+0, 0 
	GOTO        L_wait20
;Wifi_module.c,357 :: 		if (UART1_Data_Ready()){
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_wait21
;Wifi_module.c,358 :: 		if (i == 69) i = 0;
	MOVLW       0
	XORWF       wait_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__wait381
	MOVLW       69
	XORWF       wait_i_L0+0, 0 
L__wait381:
	BTFSS       STATUS+0, 2 
	GOTO        L_wait22
	CLRF        wait_i_L0+0 
	CLRF        wait_i_L0+1 
L_wait22:
;Wifi_module.c,359 :: 		buffer[i++] = UART1_Read();
	MOVLW       wait_buffer_L0+0
	ADDWF       wait_i_L0+0, 0 
	MOVWF       FLOC__wait+0 
	MOVLW       hi_addr(wait_buffer_L0+0)
	ADDWFC      wait_i_L0+1, 0 
	MOVWF       FLOC__wait+1 
	CALL        _UART1_Read+0, 0
	MOVFF       FLOC__wait+0, FSR1
	MOVFF       FLOC__wait+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      wait_i_L0+0, 1 
	INCF        wait_i_L0+1, 1 
;Wifi_module.c,360 :: 		if (strstr(buffer,input) != 0){
	MOVLW       wait_buffer_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(wait_buffer_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVF        FARG_wait_input+0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        FARG_wait_input+1, 0 
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__wait382
	MOVLW       0
	XORWF       R0, 0 
L__wait382:
	BTFSC       STATUS+0, 2 
	GOTO        L_wait23
;Wifi_module.c,361 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,362 :: 		return buffer;
	MOVLW       wait_buffer_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(wait_buffer_L0+0)
	MOVWF       R1 
	GOTO        L_end_wait
;Wifi_module.c,363 :: 		}
L_wait23:
;Wifi_module.c,364 :: 		if (strstr(buffer,"END") != 0){
	MOVLW       wait_buffer_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(wait_buffer_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr5_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr5_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__wait383
	MOVLW       0
	XORWF       R0, 0 
L__wait383:
	BTFSC       STATUS+0, 2 
	GOTO        L_wait24
;Wifi_module.c,365 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,366 :: 		return "null";
	MOVLW       ?lstr6_Wifi_module+0
	MOVWF       R0 
	MOVLW       hi_addr(?lstr6_Wifi_module+0)
	MOVWF       R1 
	GOTO        L_end_wait
;Wifi_module.c,367 :: 		}
L_wait24:
;Wifi_module.c,368 :: 		} else {
	GOTO        L_wait25
L_wait21:
;Wifi_module.c,369 :: 		mils++;
	INFSNZ      wait_mils_L0+0, 1 
	INCF        wait_mils_L0+1, 1 
;Wifi_module.c,370 :: 		delay_ms(1);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_wait26:
	DECFSZ      R13, 1, 1
	BRA         L_wait26
	DECFSZ      R12, 1, 1
	BRA         L_wait26
	NOP
;Wifi_module.c,371 :: 		}
L_wait25:
;Wifi_module.c,372 :: 		}
	GOTO        L_wait19
L_wait20:
;Wifi_module.c,373 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,375 :: 		return "null";
	MOVLW       ?lstr7_Wifi_module+0
	MOVWF       R0 
	MOVLW       hi_addr(?lstr7_Wifi_module+0)
	MOVWF       R1 
;Wifi_module.c,376 :: 		}
L_end_wait:
	RETURN      0
; end of _wait

_load:

;Wifi_module.c,378 :: 		char * load(char * dest, const char * src){
;Wifi_module.c,380 :: 		d = dest;
	MOVF        FARG_load_dest+0, 0 
	MOVWF       R5 
	MOVF        FARG_load_dest+1, 0 
	MOVWF       R6 
;Wifi_module.c,381 :: 		for(;*dest++ = *src++;)
L_load27:
	MOVF        FARG_load_dest+0, 0 
	MOVWF       R3 
	MOVF        FARG_load_dest+1, 0 
	MOVWF       R4 
	INFSNZ      FARG_load_dest+0, 1 
	INCF        FARG_load_dest+1, 1 
	MOVF        FARG_load_src+0, 0 
	MOVWF       R0 
	MOVF        FARG_load_src+1, 0 
	MOVWF       R1 
	MOVF        FARG_load_src+2, 0 
	MOVWF       R2 
	MOVLW       1
	ADDWF       FARG_load_src+0, 1 
	MOVLW       0
	ADDWFC      FARG_load_src+1, 1 
	ADDWFC      FARG_load_src+2, 1 
	MOVF        R0, 0 
	MOVWF       TBLPTRL 
	MOVF        R1, 0 
	MOVWF       TBLPTRH 
	MOVF        R2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVFF       R3, FSR1
	MOVFF       R4, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R3, FSR0
	MOVFF       R4, FSR0H
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_load28
;Wifi_module.c,382 :: 		;
	GOTO        L_load27
L_load28:
;Wifi_module.c,383 :: 		return d;
	MOVF        R5, 0 
	MOVWF       R0 
	MOVF        R6, 0 
	MOVWF       R1 
;Wifi_module.c,384 :: 		}
L_end_load:
	RETURN      0
; end of _load

_resetModule:

;Wifi_module.c,387 :: 		void resetModule(){
;Wifi_module.c,388 :: 		System.wifi_status = WIFI_NOT_CONNECTED;
	MOVLW       1
	MOVWF       _System+176 
;Wifi_module.c,389 :: 		System.network_status = IDLE;
	MOVLW       2
	MOVWF       _System+185 
;Wifi_module.c,391 :: 		}
L_end_resetModule:
	RETURN      0
; end of _resetModule

_save_config:

;Wifi_module.c,393 :: 		void save_config(char *what, int pos){
;Wifi_module.c,395 :: 		if (strstr(what,"A") != 0){       // ADC
	MOVF        FARG_save_config_what+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_save_config_what+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr8_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr8_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__save_config387
	MOVLW       0
	XORWF       R0, 0 
L__save_config387:
	BTFSC       STATUS+0, 2 
	GOTO        L_save_config30
;Wifi_module.c,401 :: 		itoa(pos,position);
	MOVF        FARG_save_config_pos+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        FARG_save_config_pos+1, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_position_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_position_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
;Wifi_module.c,403 :: 		strcpy(toWrite,"ADC_");
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr9_Wifi_module+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr9_Wifi_module+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,404 :: 		strcat(toWrite,position);
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       save_config_position_L1+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(save_config_position_L1+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,405 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr10_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr10_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,406 :: 		strcat(toWrite,itoa(ADC_channel[pos-1].ADC_sec,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       24
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,407 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr11_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr11_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,408 :: 		strcat(toWrite,itoa(ADC_channel[pos-1].ADC_dur,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       24
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,409 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr12_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr12_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,410 :: 		strcat(toWrite,itoa(ADC_channel[pos-1].ADC_mil,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       24
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,411 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr13_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr13_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,412 :: 		strcat(toWrite,itoa(ADC_channel[pos-1].port,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       24
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       10
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,413 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr14_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr14_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,414 :: 		strcat(toWrite,itoa(ADC_channel[pos-1].ADC_isPortConnected,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       24
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,415 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr15_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr15_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,416 :: 		strcat(toWrite,itoa(ADC_channel[pos-1].ADC_start_time,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       24
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       14
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,417 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr16_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr16_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,418 :: 		strcat(toWrite,itoa(ADC_channel[pos-1].ADC_end_time,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       24
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,419 :: 		strcat(toWrite,";?");
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr17_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr17_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,422 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;Wifi_module.c,423 :: 		EEPROM_Write((pos-1)*50,strlen(toWrite));
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       50
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        R1, 0 
	MOVWF       FARG_EEPROM_Write_address+1 
	CALL        _EEPROM_Write+0, 0
;Wifi_module.c,424 :: 		for (i=0;i<strlen(toWrite);i++){
	CLRF        save_config_i_L0+0 
	CLRF        save_config_i_L0+1 
L_save_config31:
	MOVLW       save_config_toWrite_L1+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       128
	XORWF       save_config_i_L0+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__save_config388
	MOVF        R0, 0 
	SUBWF       save_config_i_L0+0, 0 
L__save_config388:
	BTFSC       STATUS+0, 0 
	GOTO        L_save_config32
;Wifi_module.c,425 :: 		EEPROM_Write(((pos-1) * 50)+(i+1),toWrite[i]);
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       50
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       1
	ADDWF       save_config_i_L0+0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      save_config_i_L0+1, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       FARG_EEPROM_Write_address+1 
	MOVLW       save_config_toWrite_L1+0
	ADDWF       save_config_i_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(save_config_toWrite_L1+0)
	ADDWFC      save_config_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Wifi_module.c,424 :: 		for (i=0;i<strlen(toWrite);i++){
	INFSNZ      save_config_i_L0+0, 1 
	INCF        save_config_i_L0+1, 1 
;Wifi_module.c,426 :: 		}
	GOTO        L_save_config31
L_save_config32:
;Wifi_module.c,427 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,428 :: 		}
L_save_config30:
;Wifi_module.c,430 :: 		if (strstr(what,"R") != 0){        // Relay
	MOVF        FARG_save_config_what+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_save_config_what+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr18_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr18_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__save_config389
	MOVLW       0
	XORWF       R0, 0 
L__save_config389:
	BTFSC       STATUS+0, 2 
	GOTO        L_save_config34
;Wifi_module.c,435 :: 		itoa(pos,position);
	MOVF        FARG_save_config_pos+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        FARG_save_config_pos+1, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_position_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_position_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
;Wifi_module.c,437 :: 		strcpy(toWrite,"REL_");
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr19_Wifi_module+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr19_Wifi_module+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,438 :: 		strcat(toWrite,position);
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       save_config_position_L1_L1+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(save_config_position_L1_L1+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,439 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr20_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr20_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,440 :: 		strcat(toWrite,itoa(RELAY[pos-1].R_enabled,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       28
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,441 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr21_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr21_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,442 :: 		strcat(toWrite,itoa(RELAY[pos-1].R_trig,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       28
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,443 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr22_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr22_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,444 :: 		strcat(toWrite,itoa(RELAY[pos-1].R_val,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       28
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,447 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr23_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr23_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,448 :: 		strcat(toWrite,itoa(RELAY[pos-1].R_relay,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       28
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       6
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,449 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr24_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr24_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,450 :: 		strcat(toWrite,itoa(RELAY[pos-1].R_tresh,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       28
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,453 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr25_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr25_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,454 :: 		strcat(toWrite,itoa(RELAY[pos-1].R_state,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       28
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       10
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,455 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr26_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr26_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,456 :: 		strcat(toWrite,itoa(RELAY[pos-1].R_start,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       28
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,457 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr27_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr27_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,458 :: 		strcat(toWrite,itoa(RELAY[pos-1].R_end,buffer));
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       28
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       14
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,459 :: 		strcat(toWrite,";?");
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr28_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr28_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,462 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;Wifi_module.c,463 :: 		EEPROM_Write((pos-1)*50,strlen(toWrite));
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       50
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        R1, 0 
	MOVWF       FARG_EEPROM_Write_address+1 
	CALL        _EEPROM_Write+0, 0
;Wifi_module.c,464 :: 		for (i=0;i<strlen(toWrite);i++){
	CLRF        save_config_i_L0+0 
	CLRF        save_config_i_L0+1 
L_save_config35:
	MOVLW       save_config_toWrite_L1_L1+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       128
	XORWF       save_config_i_L0+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__save_config390
	MOVF        R0, 0 
	SUBWF       save_config_i_L0+0, 0 
L__save_config390:
	BTFSC       STATUS+0, 0 
	GOTO        L_save_config36
;Wifi_module.c,465 :: 		EEPROM_Write(((8 + (pos-1)) * 50) + (i+1),toWrite[i]);
	MOVLW       1
	SUBWF       FARG_save_config_pos+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_save_config_pos+1, 0 
	MOVWF       R1 
	MOVLW       8
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       50
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       1
	ADDWF       save_config_i_L0+0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      save_config_i_L0+1, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       FARG_EEPROM_Write_address+1 
	MOVLW       save_config_toWrite_L1_L1+0
	ADDWF       save_config_i_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1+0)
	ADDWFC      save_config_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Wifi_module.c,464 :: 		for (i=0;i<strlen(toWrite);i++){
	INFSNZ      save_config_i_L0+0, 1 
	INCF        save_config_i_L0+1, 1 
;Wifi_module.c,466 :: 		}
	GOTO        L_save_config35
L_save_config36:
;Wifi_module.c,467 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,468 :: 		}
L_save_config34:
;Wifi_module.c,470 :: 		if (strstr(what,"S") != 0){       // System
	MOVF        FARG_save_config_what+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_save_config_what+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr29_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr29_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__save_config391
	MOVLW       0
	XORWF       R0, 0 
L__save_config391:
	BTFSC       STATUS+0, 2 
	GOTO        L_save_config38
;Wifi_module.c,474 :: 		strcpy(toWrite,"SYS;");
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr30_Wifi_module+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr30_Wifi_module+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,475 :: 		strcat(toWrite,itoa(System.measure_type,buffer));
	MOVF        _System+270, 0 
	MOVWF       FARG_itoa_i+0 
	MOVLW       0
	BTFSC       _System+270, 7 
	MOVLW       255
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,476 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr31_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr31_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,477 :: 		strcat(toWrite,itoa(System.connection_type,buffer));
	MOVF        _System+271, 0 
	MOVWF       FARG_itoa_i+0 
	MOVLW       0
	BTFSC       _System+271, 7 
	MOVLW       255
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,478 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr32_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr32_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,479 :: 		strcat(toWrite,System.host);
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       _System+352
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(_System+352)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,480 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr33_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr33_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,481 :: 		strcat(toWrite,itoa(System.tcp_port,buffer));
	MOVF        _System+285, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _System+286, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,482 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr34_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr34_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,483 :: 		strcat(toWrite,System.ssid);
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       _System+287
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(_System+287)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,484 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr35_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr35_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,485 :: 		strcat(toWrite,System.password);
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       _System+319
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(_System+319)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,486 :: 		strcat(toWrite,";");
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr36_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr36_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,487 :: 		strcat(toWrite,itoa(System.protocol,buffer));
	MOVF        _System+351, 0 
	MOVWF       FARG_itoa_i+0 
	MOVLW       0
	BTFSC       _System+351, 7 
	MOVLW       255
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_config_buffer_L1_L1_L1+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_config_buffer_L1_L1_L1+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,488 :: 		strcat(toWrite,";?");
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr37_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr37_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,490 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;Wifi_module.c,491 :: 		EEPROM_Write(800,strlen(toWrite));
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	MOVLW       32
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       3
	MOVWF       FARG_EEPROM_Write_address+1 
	CALL        _EEPROM_Write+0, 0
;Wifi_module.c,492 :: 		for (i=0;i<strlen(toWrite);i++){
	CLRF        save_config_i_L0+0 
	CLRF        save_config_i_L0+1 
L_save_config39:
	MOVLW       save_config_toWrite_L1_L1_L1+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       128
	XORWF       save_config_i_L0+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__save_config392
	MOVF        R0, 0 
	SUBWF       save_config_i_L0+0, 0 
L__save_config392:
	BTFSC       STATUS+0, 0 
	GOTO        L_save_config40
;Wifi_module.c,493 :: 		EEPROM_Write(801+i,toWrite[i]);
	MOVLW       33
	ADDWF       save_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       3
	ADDWFC      save_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Write_address+1 
	MOVLW       save_config_toWrite_L1_L1_L1+0
	ADDWF       save_config_i_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(save_config_toWrite_L1_L1_L1+0)
	ADDWFC      save_config_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Wifi_module.c,492 :: 		for (i=0;i<strlen(toWrite);i++){
	INFSNZ      save_config_i_L0+0, 1 
	INCF        save_config_i_L0+1, 1 
;Wifi_module.c,494 :: 		}
	GOTO        L_save_config39
L_save_config40:
;Wifi_module.c,495 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,496 :: 		}
L_save_config38:
;Wifi_module.c,498 :: 		}
L_end_save_config:
	RETURN      0
; end of _save_config

_process_config:

;Wifi_module.c,501 :: 		void process_config(char *buffer, short flag){
;Wifi_module.c,503 :: 		if (strstr(buffer,"REL_")){
	MOVF        FARG_process_config_buffer+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_process_config_buffer+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr38_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr38_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_process_config42
;Wifi_module.c,504 :: 		char *p = strstr(buffer,"REL_");
	MOVF        FARG_process_config_buffer+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_process_config_buffer+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr39_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr39_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       process_config_p_L1+0 
	MOVF        R1, 0 
	MOVWF       process_config_p_L1+1 
;Wifi_module.c,506 :: 		int i = 0;
	CLRF        process_config_i_L1+0 
	CLRF        process_config_i_L1+1 
;Wifi_module.c,507 :: 		int pos = atoi(p+4)-1;
	MOVLW       4
	ADDWF       process_config_p_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVLW       0
	ADDWFC      process_config_p_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVLW       1
	SUBWF       R0, 0 
	MOVWF       process_config_pos_L1+0 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       process_config_pos_L1+1 
;Wifi_module.c,509 :: 		p = strtok(buffer,";");
	MOVF        FARG_process_config_buffer+0, 0 
	MOVWF       FARG_strtok_s1+0 
	MOVF        FARG_process_config_buffer+1, 0 
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr40_Wifi_module+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr40_Wifi_module+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       process_config_p_L1+0 
	MOVF        R1, 0 
	MOVWF       process_config_p_L1+1 
;Wifi_module.c,511 :: 		while (p!=0){
L_process_config43:
	MOVLW       0
	XORWF       process_config_p_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config394
	MOVLW       0
	XORWF       process_config_p_L1+0, 0 
L__process_config394:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_config44
;Wifi_module.c,513 :: 		if (i==2) RELAY[pos].R_enabled = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config395
	MOVLW       2
	XORWF       process_config_i_L1+0, 0 
L__process_config395:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config45
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVF        R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config45:
;Wifi_module.c,514 :: 		if (i==3) RELAY[pos].R_trig = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config396
	MOVLW       3
	XORWF       process_config_i_L1+0, 0 
L__process_config396:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config46
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config46:
;Wifi_module.c,515 :: 		if (i==4) { RELAY[pos].R_val = atoi(p); RELAY[pos].R_val_buffer = atoi(p); }
	MOVLW       0
	XORWF       process_config_i_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config397
	MOVLW       4
	XORWF       process_config_i_L1+0, 0 
L__process_config397:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config47
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       20
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config47:
;Wifi_module.c,516 :: 		if (i==5) RELAY[pos].R_relay = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config398
	MOVLW       5
	XORWF       process_config_i_L1+0, 0 
L__process_config398:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config48
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       6
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config48:
;Wifi_module.c,517 :: 		if (i==6) RELAY[pos].R_tresh = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config399
	MOVLW       6
	XORWF       process_config_i_L1+0, 0 
L__process_config399:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config49
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config49:
;Wifi_module.c,518 :: 		if (i==7){
	MOVLW       0
	XORWF       process_config_i_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config400
	MOVLW       7
	XORWF       process_config_i_L1+0, 0 
L__process_config400:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config50
;Wifi_module.c,519 :: 		if (RELAY[pos].R_state != atoi(p)){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       10
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FLOC__process_config+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        FLOC__process_config+1, 0 
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config401
	MOVF        R0, 0 
	XORWF       FLOC__process_config+0, 0 
L__process_config401:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_config51
;Wifi_module.c,520 :: 		RELAY[pos].R_flag_1 = 0;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       22
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Wifi_module.c,521 :: 		RELAY[pos].R_flag_2 = 0;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       23
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Wifi_module.c,522 :: 		}
L_process_config51:
;Wifi_module.c,523 :: 		RELAY[pos].R_state = atoi(p);
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       10
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,524 :: 		}
L_process_config50:
;Wifi_module.c,525 :: 		if (i==8) RELAY[pos].R_start = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config402
	MOVLW       8
	XORWF       process_config_i_L1+0, 0 
L__process_config402:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config52
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config52:
;Wifi_module.c,526 :: 		if (i==9) RELAY[pos].R_end = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config403
	MOVLW       9
	XORWF       process_config_i_L1+0, 0 
L__process_config403:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config53
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       14
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config53:
;Wifi_module.c,528 :: 		i++;
	INFSNZ      process_config_i_L1+0, 1 
	INCF        process_config_i_L1+1, 1 
;Wifi_module.c,529 :: 		p = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr41_Wifi_module+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr41_Wifi_module+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       process_config_p_L1+0 
	MOVF        R1, 0 
	MOVWF       process_config_p_L1+1 
;Wifi_module.c,530 :: 		}
	GOTO        L_process_config43
L_process_config44:
;Wifi_module.c,533 :: 		if (flag == 1)
	MOVF        FARG_process_config_flag+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config54
;Wifi_module.c,534 :: 		save_config("R",++pos);
	MOVLW       ?lstr42_Wifi_module+0
	MOVWF       FARG_save_config_what+0 
	MOVLW       hi_addr(?lstr42_Wifi_module+0)
	MOVWF       FARG_save_config_what+1 
	INFSNZ      process_config_pos_L1+0, 1 
	INCF        process_config_pos_L1+1, 1 
	MOVF        process_config_pos_L1+0, 0 
	MOVWF       FARG_save_config_pos+0 
	MOVF        process_config_pos_L1+1, 0 
	MOVWF       FARG_save_config_pos+1 
	CALL        _save_config+0, 0
L_process_config54:
;Wifi_module.c,535 :: 		}
L_process_config42:
;Wifi_module.c,537 :: 		if (strstr(buffer,"ADC_")){
	MOVF        FARG_process_config_buffer+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_process_config_buffer+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr43_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr43_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_process_config55
;Wifi_module.c,538 :: 		char *p = strstr(buffer,"ADC_");
	MOVF        FARG_process_config_buffer+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_process_config_buffer+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr44_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr44_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       process_config_p_L1_L1+0 
	MOVF        R1, 0 
	MOVWF       process_config_p_L1_L1+1 
;Wifi_module.c,540 :: 		int pos = atoi(p+4)-1;
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVLW       1
	SUBWF       R0, 0 
	MOVWF       process_config_pos_L1_L1+0 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       process_config_pos_L1_L1+1 
;Wifi_module.c,541 :: 		int i = 0;
	CLRF        process_config_i_L1_L1+0 
	CLRF        process_config_i_L1_L1+1 
;Wifi_module.c,544 :: 		p = strtok(buffer,";");
	MOVF        FARG_process_config_buffer+0, 0 
	MOVWF       FARG_strtok_s1+0 
	MOVF        FARG_process_config_buffer+1, 0 
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr45_Wifi_module+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr45_Wifi_module+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       process_config_p_L1_L1+0 
	MOVF        R1, 0 
	MOVWF       process_config_p_L1_L1+1 
;Wifi_module.c,546 :: 		while (p!=0){
L_process_config56:
	MOVLW       0
	XORWF       process_config_p_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config404
	MOVLW       0
	XORWF       process_config_p_L1_L1+0, 0 
L__process_config404:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_config57
;Wifi_module.c,548 :: 		if (i==2) ADC_channel[pos].ADC_SEC = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config405
	MOVLW       2
	XORWF       process_config_i_L1_L1+0, 0 
L__process_config405:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config58
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVF        R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config58:
;Wifi_module.c,549 :: 		if (i==3) ADC_channel[pos].ADC_DUR = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config406
	MOVLW       3
	XORWF       process_config_i_L1_L1+0, 0 
L__process_config406:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config59
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config59:
;Wifi_module.c,550 :: 		if (i==4) ADC_channel[pos].ADC_MIL = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config407
	MOVLW       4
	XORWF       process_config_i_L1_L1+0, 0 
L__process_config407:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config60
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config60:
;Wifi_module.c,551 :: 		if (i==5) ADC_channel[pos].PORT = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config408
	MOVLW       5
	XORWF       process_config_i_L1_L1+0, 0 
L__process_config408:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config61
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       10
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config61:
;Wifi_module.c,552 :: 		if (i==6) ADC_channel[pos].ADC_ISPORTCONNECTED = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config409
	MOVLW       6
	XORWF       process_config_i_L1_L1+0, 0 
L__process_config409:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config62
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config62:
;Wifi_module.c,553 :: 		if (i==7) ADC_channel[pos].ADC_START_TIME = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config410
	MOVLW       7
	XORWF       process_config_i_L1_L1+0, 0 
L__process_config410:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config63
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       14
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config63:
;Wifi_module.c,554 :: 		if (i==8) ADC_channel[pos].ADC_END_TIME = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config411
	MOVLW       8
	XORWF       process_config_i_L1_L1+0, 0 
L__process_config411:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config64
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        process_config_pos_L1_L1+0, 0 
	MOVWF       R4 
	MOVF        process_config_pos_L1_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FLOC__process_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__process_config+1 
	MOVF        process_config_p_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__process_config+0, FSR1
	MOVFF       FLOC__process_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
L_process_config64:
;Wifi_module.c,556 :: 		i++;
	INFSNZ      process_config_i_L1_L1+0, 1 
	INCF        process_config_i_L1_L1+1, 1 
;Wifi_module.c,557 :: 		p = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr46_Wifi_module+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr46_Wifi_module+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       process_config_p_L1_L1+0 
	MOVF        R1, 0 
	MOVWF       process_config_p_L1_L1+1 
;Wifi_module.c,558 :: 		}
	GOTO        L_process_config56
L_process_config57:
;Wifi_module.c,559 :: 		if (flag == 1)
	MOVF        FARG_process_config_flag+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config65
;Wifi_module.c,560 :: 		save_config("A",++pos);
	MOVLW       ?lstr47_Wifi_module+0
	MOVWF       FARG_save_config_what+0 
	MOVLW       hi_addr(?lstr47_Wifi_module+0)
	MOVWF       FARG_save_config_what+1 
	INFSNZ      process_config_pos_L1_L1+0, 1 
	INCF        process_config_pos_L1_L1+1, 1 
	MOVF        process_config_pos_L1_L1+0, 0 
	MOVWF       FARG_save_config_pos+0 
	MOVF        process_config_pos_L1_L1+1, 0 
	MOVWF       FARG_save_config_pos+1 
	CALL        _save_config+0, 0
L_process_config65:
;Wifi_module.c,561 :: 		}
L_process_config55:
;Wifi_module.c,563 :: 		if (strstr(buffer,"SYS")){
	MOVF        FARG_process_config_buffer+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        FARG_process_config_buffer+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr48_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr48_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_process_config66
;Wifi_module.c,565 :: 		int i = 0;
	CLRF        process_config_i_L1_L1_L1+0 
	CLRF        process_config_i_L1_L1_L1+1 
;Wifi_module.c,566 :: 		char *p = strtok(buffer,";");
	MOVF        FARG_process_config_buffer+0, 0 
	MOVWF       FARG_strtok_s1+0 
	MOVF        FARG_process_config_buffer+1, 0 
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr49_Wifi_module+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr49_Wifi_module+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       process_config_p_L1_L1_L1+0 
	MOVF        R1, 0 
	MOVWF       process_config_p_L1_L1_L1+1 
;Wifi_module.c,569 :: 		while (p!=0){
L_process_config67:
	MOVLW       0
	XORWF       process_config_p_L1_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config412
	MOVLW       0
	XORWF       process_config_p_L1_L1_L1+0, 0 
L__process_config412:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_config68
;Wifi_module.c,571 :: 		if (i==2) System.measure_type = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config413
	MOVLW       2
	XORWF       process_config_i_L1_L1_L1+0, 0 
L__process_config413:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config69
	MOVF        process_config_p_L1_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _System+270 
L_process_config69:
;Wifi_module.c,572 :: 		if (i==3) {if (System.connection_type != atoi(p)){
	MOVLW       0
	XORWF       process_config_i_L1_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config414
	MOVLW       3
	XORWF       process_config_i_L1_L1_L1+0, 0 
L__process_config414:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config70
	MOVF        process_config_p_L1_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVLW       0
	BTFSC       _System+271, 7 
	MOVLW       255
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config415
	MOVF        R0, 0 
	XORWF       _System+271, 0 
L__process_config415:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_config71
;Wifi_module.c,573 :: 		System.connection_type = atoi(p);
	MOVF        process_config_p_L1_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _System+271 
;Wifi_module.c,574 :: 		resetModule();
	CALL        _resetModule+0, 0
;Wifi_module.c,575 :: 		}}
L_process_config71:
L_process_config70:
;Wifi_module.c,576 :: 		if (i==4) strcpy(System.host,p);
	MOVLW       0
	XORWF       process_config_i_L1_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config416
	MOVLW       4
	XORWF       process_config_i_L1_L1_L1+0, 0 
L__process_config416:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config72
	MOVLW       _System+352
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+352)
	MOVWF       FARG_strcpy_to+1 
	MOVF        process_config_p_L1_L1_L1+0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        process_config_p_L1_L1_L1+1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
L_process_config72:
;Wifi_module.c,577 :: 		if (i==5) System.tcp_port = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config417
	MOVLW       5
	XORWF       process_config_i_L1_L1_L1+0, 0 
L__process_config417:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config73
	MOVF        process_config_p_L1_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _System+285 
	MOVF        R1, 0 
	MOVWF       _System+286 
L_process_config73:
;Wifi_module.c,578 :: 		if (i==6) strcpy(System.ssid,p);
	MOVLW       0
	XORWF       process_config_i_L1_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config418
	MOVLW       6
	XORWF       process_config_i_L1_L1_L1+0, 0 
L__process_config418:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config74
	MOVLW       _System+287
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+287)
	MOVWF       FARG_strcpy_to+1 
	MOVF        process_config_p_L1_L1_L1+0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        process_config_p_L1_L1_L1+1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
L_process_config74:
;Wifi_module.c,579 :: 		if (i==7) strcpy(System.password,p);
	MOVLW       0
	XORWF       process_config_i_L1_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config419
	MOVLW       7
	XORWF       process_config_i_L1_L1_L1+0, 0 
L__process_config419:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config75
	MOVLW       _System+319
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+319)
	MOVWF       FARG_strcpy_to+1 
	MOVF        process_config_p_L1_L1_L1+0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        process_config_p_L1_L1_L1+1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
L_process_config75:
;Wifi_module.c,580 :: 		if (i==8) System.protocol = atoi(p);
	MOVLW       0
	XORWF       process_config_i_L1_L1_L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_config420
	MOVLW       8
	XORWF       process_config_i_L1_L1_L1+0, 0 
L__process_config420:
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config76
	MOVF        process_config_p_L1_L1_L1+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        process_config_p_L1_L1_L1+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _System+351 
L_process_config76:
;Wifi_module.c,582 :: 		i++;
	INFSNZ      process_config_i_L1_L1_L1+0, 1 
	INCF        process_config_i_L1_L1_L1+1, 1 
;Wifi_module.c,583 :: 		p = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr50_Wifi_module+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr50_Wifi_module+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       process_config_p_L1_L1_L1+0 
	MOVF        R1, 0 
	MOVWF       process_config_p_L1_L1_L1+1 
;Wifi_module.c,584 :: 		}
	GOTO        L_process_config67
L_process_config68:
;Wifi_module.c,585 :: 		if (flag == 1)
	MOVF        FARG_process_config_flag+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_process_config77
;Wifi_module.c,586 :: 		save_config("S",0);
	MOVLW       ?lstr51_Wifi_module+0
	MOVWF       FARG_save_config_what+0 
	MOVLW       hi_addr(?lstr51_Wifi_module+0)
	MOVWF       FARG_save_config_what+1 
	CLRF        FARG_save_config_pos+0 
	CLRF        FARG_save_config_pos+1 
	CALL        _save_config+0, 0
L_process_config77:
;Wifi_module.c,587 :: 		i=0;
	CLRF        process_config_i_L1_L1_L1+0 
	CLRF        process_config_i_L1_L1_L1+1 
;Wifi_module.c,588 :: 		}
L_process_config66:
;Wifi_module.c,590 :: 		}
L_end_process_config:
	RETURN      0
; end of _process_config

_default_config:

;Wifi_module.c,593 :: 		void default_config(){
;Wifi_module.c,598 :: 		for (index = 0; index < CHANNEL_COUNT; index++){
	CLRF        default_config_index_L0+0 
	CLRF        default_config_index_L0+1 
L_default_config78:
	MOVLW       128
	XORWF       default_config_index_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__default_config422
	MOVLW       8
	SUBWF       default_config_index_L0+0, 0 
L__default_config422:
	BTFSC       STATUS+0, 0 
	GOTO        L_default_config79
;Wifi_module.c,599 :: 		ADC_channel[index].ADC_isPortConnected = FALSE;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_index_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_index_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,600 :: 		ADC_channel[index].ADC_mil_buffer = 0;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_index_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_index_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       22
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,601 :: 		ADC_channel[index].ADC_sec_buffer = 0;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_index_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_index_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,602 :: 		ADC_channel[index].ADC_dur_buffer = 0;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_index_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_index_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       20
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,598 :: 		for (index = 0; index < CHANNEL_COUNT; index++){
	INFSNZ      default_config_index_L0+0, 1 
	INCF        default_config_index_L0+1, 1 
;Wifi_module.c,603 :: 		}
	GOTO        L_default_config78
L_default_config79:
;Wifi_module.c,605 :: 		for (index = 0; index < RELAY_SIZE; index++){
	CLRF        default_config_index_L0+0 
	CLRF        default_config_index_L0+1 
L_default_config81:
	MOVLW       128
	XORWF       default_config_index_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__default_config423
	MOVLW       6
	SUBWF       default_config_index_L0+0, 0 
L__default_config423:
	BTFSC       STATUS+0, 0 
	GOTO        L_default_config82
;Wifi_module.c,606 :: 		RELAY[index].R_enabled = FALSE;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_index_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_index_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,607 :: 		RELAY[index].R_flag_1 = 0;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_index_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_index_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       22
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Wifi_module.c,608 :: 		RELAY[index].R_flag_2 = 0;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_index_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_index_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       23
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Wifi_module.c,609 :: 		RELAY[index].R_trs_1 = 0;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_index_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_index_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       24
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,610 :: 		RELAY[index].R_trs_2 = 0;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_index_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_index_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       26
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,611 :: 		RELAY[index].R_current_state = 1;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_index_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_index_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       1
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
;Wifi_module.c,605 :: 		for (index = 0; index < RELAY_SIZE; index++){
	INFSNZ      default_config_index_L0+0, 1 
	INCF        default_config_index_L0+1, 1 
;Wifi_module.c,613 :: 		}
	GOTO        L_default_config81
L_default_config82:
;Wifi_module.c,615 :: 		SystemTime.year = 0;
	CLRF        _SystemTime+12 
	CLRF        _SystemTime+13 
;Wifi_module.c,616 :: 		SystemTime.month = 0;
	CLRF        _SystemTime+10 
	CLRF        _SystemTime+11 
;Wifi_module.c,617 :: 		SystemTime.day = 0;
	CLRF        _SystemTime+8 
	CLRF        _SystemTime+9 
;Wifi_module.c,618 :: 		SystemTime.hour = 0;
	CLRF        _SystemTime+6 
	CLRF        _SystemTime+7 
;Wifi_module.c,619 :: 		SystemTime.min = 0;
	CLRF        _SystemTime+4 
	CLRF        _SystemTime+5 
;Wifi_module.c,620 :: 		SystemTime.sec = 0;
	CLRF        _SystemTime+2 
	CLRF        _SystemTime+3 
;Wifi_module.c,621 :: 		SystemTime.mils = 0;
	CLRF        _SystemTime+0 
	CLRF        _SystemTime+1 
;Wifi_module.c,623 :: 		SystemTime.min_2 = 0;
	CLRF        _SystemTime+20 
	CLRF        _SystemTime+21 
;Wifi_module.c,624 :: 		SystemTime.sec_2 = 0;
	CLRF        _SystemTime+18 
	CLRF        _SystemTime+19 
;Wifi_module.c,625 :: 		SystemTime.sec_3 = 0;
	CLRF        _SystemTime+14 
	CLRF        _SystemTime+15 
;Wifi_module.c,626 :: 		SystemTime.mils_2 = 0;
	CLRF        _SystemTime+16 
	CLRF        _SystemTime+17 
;Wifi_module.c,628 :: 		memset(System.readLine,' ',sizeof(System.readLine)-1);
	MOVLW       _System+12
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_System+12)
	MOVWF       FARG_memset_p1+1 
	MOVLW       32
	MOVWF       FARG_memset_character+0 
	MOVLW       149
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;Wifi_module.c,629 :: 		memset(System.password,' ',sizeof(System.password)-1);
	MOVLW       _System+319
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_System+319)
	MOVWF       FARG_memset_p1+1 
	MOVLW       32
	MOVWF       FARG_memset_character+0 
	MOVLW       31
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;Wifi_module.c,630 :: 		memset(System.host,' ',sizeof(System.host)-1);
	MOVLW       _System+352
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_System+352)
	MOVWF       FARG_memset_p1+1 
	MOVLW       32
	MOVWF       FARG_memset_character+0 
	MOVLW       63
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;Wifi_module.c,631 :: 		memset(System.ssid,' ',sizeof(System.ssid)-1);
	MOVLW       _System+287
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_System+287)
	MOVWF       FARG_memset_p1+1 
	MOVLW       32
	MOVWF       FARG_memset_character+0 
	MOVLW       31
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;Wifi_module.c,632 :: 		memset(System.ip_address,' ',sizeof(System.ip_address)-1);
	MOVLW       _System+272
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_System+272)
	MOVWF       FARG_memset_p1+1 
	MOVLW       32
	MOVWF       FARG_memset_character+0 
	MOVLW       12
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;Wifi_module.c,634 :: 		System.readLine[sizeof(System.readLine)-1] = '\0';
	CLRF        _System+161 
;Wifi_module.c,635 :: 		System.PORTD_state = 0;
	CLRF        _System+269 
;Wifi_module.c,636 :: 		System.index = 0;
	CLRF        _System+172 
	CLRF        _System+173 
;Wifi_module.c,637 :: 		System.index_2 = 0;
	CLRF        _System+174 
	CLRF        _System+175 
;Wifi_module.c,638 :: 		System.sec_flag = 0;
	CLRF        _System+188 
	CLRF        _System+189 
;Wifi_module.c,639 :: 		System.min_flag = 0;
	CLRF        _System+190 
	CLRF        _System+191 
;Wifi_module.c,640 :: 		System.connection_timer = 5;
	MOVLW       5
	MOVWF       _System+264 
	MOVLW       0
	MOVWF       _System+265 
;Wifi_module.c,641 :: 		System.connection_timer_buffer = 0;
	CLRF        _System+266 
	CLRF        _System+267 
;Wifi_module.c,642 :: 		System.isInputReady = FALSE;
	CLRF        _System+177 
;Wifi_module.c,643 :: 		System.isInput_2_Ready = FALSE;
	CLRF        _System+178 
;Wifi_module.c,644 :: 		System.network_status = IDLE;
	MOVLW       2
	MOVWF       _System+185 
;Wifi_module.c,645 :: 		System.wifi_status = WIFI_TURNED_OFF;
	MOVLW       2
	MOVWF       _System+176 
;Wifi_module.c,646 :: 		System.measure_type = BUFFERED;
	CLRF        _System+270 
;Wifi_module.c,647 :: 		System.connection_type = SERVER;       // CREATES SERVER BY DEFAULT
	CLRF        _System+271 
;Wifi_module.c,648 :: 		System.tcp_port = DEFAULT_PORT;
	MOVLW       154
	MOVWF       _System+285 
	MOVLW       2
	MOVWF       _System+286 
;Wifi_module.c,649 :: 		System.battery_voltage = 512;          // 50%
	MOVLW       0
	MOVWF       _System+1 
;Wifi_module.c,650 :: 		System.isADCEnabled = TRUE;
	MOVLW       1
	MOVWF       _System+268 
;Wifi_module.c,652 :: 		strcpy(System.ssid, load(System.load_buffer,DEFAULT_SSID));
	MOVLW       _System+193
	MOVWF       FARG_load_dest+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_load_dest+1 
	MOVLW       _DEFAULT_SSID+0
	MOVWF       FARG_load_src+0 
	MOVLW       hi_addr(_DEFAULT_SSID+0)
	MOVWF       FARG_load_src+1 
	MOVLW       higher_addr(_DEFAULT_SSID+0)
	MOVWF       FARG_load_src+2 
	CALL        _load+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_from+1 
	MOVLW       _System+287
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+287)
	MOVWF       FARG_strcpy_to+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,653 :: 		strcpy(System.password, load(System.load_buffer,DEFAULT_PW));
	MOVLW       _System+193
	MOVWF       FARG_load_dest+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_load_dest+1 
	MOVLW       _DEFAULT_PW+0
	MOVWF       FARG_load_src+0 
	MOVLW       hi_addr(_DEFAULT_PW+0)
	MOVWF       FARG_load_src+1 
	MOVLW       higher_addr(_DEFAULT_PW+0)
	MOVWF       FARG_load_src+2 
	CALL        _load+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_from+1 
	MOVLW       _System+319
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+319)
	MOVWF       FARG_strcpy_to+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,654 :: 		strcpy(System.host,load(System.load_buffer,DEFAULT_HOST));
	MOVLW       _System+193
	MOVWF       FARG_load_dest+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_load_dest+1 
	MOVLW       _DEFAULT_HOST+0
	MOVWF       FARG_load_src+0 
	MOVLW       hi_addr(_DEFAULT_HOST+0)
	MOVWF       FARG_load_src+1 
	MOVLW       higher_addr(_DEFAULT_HOST+0)
	MOVWF       FARG_load_src+2 
	CALL        _load+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_from+1 
	MOVLW       _System+352
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+352)
	MOVWF       FARG_strcpy_to+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,655 :: 		strcpy(System.identifier,"null");
	MOVLW       _System+180
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+180)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr52_Wifi_module+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr52_Wifi_module+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,656 :: 		System.tcp_port = 85;
	MOVLW       85
	MOVWF       _System+285 
	MOVLW       0
	MOVWF       _System+286 
;Wifi_module.c,657 :: 		System.protocol = TCP;
	CLRF        _System+351 
;Wifi_module.c,659 :: 		}
L_end_default_config:
	RETURN      0
; end of _default_config

_cipsend:

;Wifi_module.c,661 :: 		void cipsend(int size){
;Wifi_module.c,663 :: 		UART1_Write_Text("AT+CIPSEND=0,");
	MOVLW       ?lstr53_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr53_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,664 :: 		UART1_Write_Text(itoa(size,conv));
	MOVF        FARG_cipsend_size+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        FARG_cipsend_size+1, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       cipsend_conv_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(cipsend_conv_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,665 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr54_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr54_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,666 :: 		if (waitForInput(">",2) == 0){
	MOVLW       ?lstr55_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr55_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       2
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__cipsend425
	MOVLW       0
	XORWF       R0, 0 
L__cipsend425:
	BTFSS       STATUS+0, 2 
	GOTO        L_cipsend84
;Wifi_module.c,667 :: 		System.network_status = IDLE;
	MOVLW       2
	MOVWF       _System+185 
;Wifi_module.c,668 :: 		System.wifi_status = WIFI_NOT_CONNECTED;
	MOVLW       1
	MOVWF       _System+176 
;Wifi_module.c,669 :: 		}
L_cipsend84:
;Wifi_module.c,670 :: 		}
L_end_cipsend:
	RETURN      0
; end of _cipsend

_update_server_from_sd:

;Wifi_module.c,672 :: 		void update_server_from_sd() {
;Wifi_module.c,681 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;Wifi_module.c,682 :: 		Mmc_Fat_Assign("MEM.TXT", 0);          // File read from position 0
	MOVLW       ?lstr56_Wifi_module+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(?lstr56_Wifi_module+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	CLRF        FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
;Wifi_module.c,683 :: 		Mmc_Fat_Reset(&size);              // To read file, procedure returns size of file
	MOVLW       update_server_from_sd_size_L0+0
	MOVWF       FARG_Mmc_Fat_Reset_size+0 
	MOVLW       hi_addr(update_server_from_sd_size_L0+0)
	MOVWF       FARG_Mmc_Fat_Reset_size+1 
	CALL        _Mmc_Fat_Reset+0, 0
;Wifi_module.c,684 :: 		size_buffer = size;
	MOVF        update_server_from_sd_size_L0+0, 0 
	MOVWF       update_server_from_sd_size_buffer_L0+0 
	MOVF        update_server_from_sd_size_L0+1, 0 
	MOVWF       update_server_from_sd_size_buffer_L0+1 
	MOVF        update_server_from_sd_size_L0+2, 0 
	MOVWF       update_server_from_sd_size_buffer_L0+2 
	MOVF        update_server_from_sd_size_L0+3, 0 
	MOVWF       update_server_from_sd_size_buffer_L0+3 
;Wifi_module.c,685 :: 		if (size == 0){
	MOVLW       0
	MOVWF       R0 
	XORWF       update_server_from_sd_size_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd427
	MOVF        R0, 0 
	XORWF       update_server_from_sd_size_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd427
	MOVF        R0, 0 
	XORWF       update_server_from_sd_size_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd427
	MOVF        update_server_from_sd_size_L0+0, 0 
	XORLW       0
L__update_server_from_sd427:
	BTFSS       STATUS+0, 2 
	GOTO        L_update_server_from_sd85
;Wifi_module.c,686 :: 		cipsend(11);
	MOVLW       11
	MOVWF       FARG_cipsend_size+0 
	MOVLW       0
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,687 :: 		UART1_Write_Text("No data...\n");
	MOVLW       ?lstr57_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr57_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,689 :: 		} else {
	GOTO        L_update_server_from_sd86
L_update_server_from_sd85:
;Wifi_module.c,691 :: 		if (size >= 2048){                 // AT+CIPSEND sends maximum 2048 bytes in a packet
	MOVLW       0
	SUBWF       update_server_from_sd_size_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd428
	MOVLW       0
	SUBWF       update_server_from_sd_size_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd428
	MOVLW       8
	SUBWF       update_server_from_sd_size_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd428
	MOVLW       0
	SUBWF       update_server_from_sd_size_L0+0, 0 
L__update_server_from_sd428:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_server_from_sd87
;Wifi_module.c,692 :: 		buffer = 2048;                  // If size is greater than 2048, it should write 2048
	MOVLW       0
	MOVWF       update_server_from_sd_buffer_L0+0 
	MOVLW       8
	MOVWF       update_server_from_sd_buffer_L0+1 
;Wifi_module.c,693 :: 		} else {
	GOTO        L_update_server_from_sd88
L_update_server_from_sd87:
;Wifi_module.c,694 :: 		buffer = size;                  // Else the remaining size
	MOVF        update_server_from_sd_size_L0+0, 0 
	MOVWF       update_server_from_sd_buffer_L0+0 
	MOVF        update_server_from_sd_size_L0+1, 0 
	MOVWF       update_server_from_sd_buffer_L0+1 
;Wifi_module.c,695 :: 		}
L_update_server_from_sd88:
;Wifi_module.c,696 :: 		cipsend(buffer);
	MOVF        update_server_from_sd_buffer_L0+0, 0 
	MOVWF       FARG_cipsend_size+0 
	MOVF        update_server_from_sd_buffer_L0+1, 0 
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,698 :: 		for (i = 0; i < size_buffer; i++) {
	CLRF        update_server_from_sd_i_L0+0 
	CLRF        update_server_from_sd_i_L0+1 
	CLRF        update_server_from_sd_i_L0+2 
	CLRF        update_server_from_sd_i_L0+3 
L_update_server_from_sd89:
	MOVF        update_server_from_sd_size_buffer_L0+3, 0 
	SUBWF       update_server_from_sd_i_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd429
	MOVF        update_server_from_sd_size_buffer_L0+2, 0 
	SUBWF       update_server_from_sd_i_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd429
	MOVF        update_server_from_sd_size_buffer_L0+1, 0 
	SUBWF       update_server_from_sd_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd429
	MOVF        update_server_from_sd_size_buffer_L0+0, 0 
	SUBWF       update_server_from_sd_i_L0+0, 0 
L__update_server_from_sd429:
	BTFSC       STATUS+0, 0 
	GOTO        L_update_server_from_sd90
;Wifi_module.c,700 :: 		if (i != 0 && i % 2048 == 0){
	MOVLW       0
	MOVWF       R0 
	XORWF       update_server_from_sd_i_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd430
	MOVF        R0, 0 
	XORWF       update_server_from_sd_i_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd430
	MOVF        R0, 0 
	XORWF       update_server_from_sd_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd430
	MOVF        update_server_from_sd_i_L0+0, 0 
	XORLW       0
L__update_server_from_sd430:
	BTFSC       STATUS+0, 2 
	GOTO        L_update_server_from_sd94
	MOVLW       255
	ANDWF       update_server_from_sd_i_L0+0, 0 
	MOVWF       R1 
	MOVLW       7
	ANDWF       update_server_from_sd_i_L0+1, 0 
	MOVWF       R2 
	MOVF        update_server_from_sd_i_L0+2, 0 
	MOVWF       R3 
	MOVF        update_server_from_sd_i_L0+3, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R3, 1 
	ANDWF       R4, 1 
	MOVLW       0
	MOVWF       R0 
	XORWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd431
	MOVF        R0, 0 
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd431
	MOVF        R0, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd431
	MOVF        R1, 0 
	XORLW       0
L__update_server_from_sd431:
	BTFSS       STATUS+0, 2 
	GOTO        L_update_server_from_sd94
L__update_server_from_sd354:
;Wifi_module.c,702 :: 		size -= 2048;
	MOVF        update_server_from_sd_size_L0+0, 0 
	MOVWF       R1 
	MOVF        update_server_from_sd_size_L0+1, 0 
	MOVWF       R2 
	MOVF        update_server_from_sd_size_L0+2, 0 
	MOVWF       R3 
	MOVF        update_server_from_sd_size_L0+3, 0 
	MOVWF       R4 
	MOVLW       0
	SUBWF       R1, 1 
	MOVLW       8
	SUBWFB      R2, 1 
	MOVLW       0
	SUBWFB      R3, 1 
	SUBWFB      R4, 1 
	MOVF        R1, 0 
	MOVWF       update_server_from_sd_size_L0+0 
	MOVF        R2, 0 
	MOVWF       update_server_from_sd_size_L0+1 
	MOVF        R3, 0 
	MOVWF       update_server_from_sd_size_L0+2 
	MOVF        R4, 0 
	MOVWF       update_server_from_sd_size_L0+3 
;Wifi_module.c,703 :: 		if (size >= 2048){           // Still can be more than 2048 so same story
	MOVLW       0
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd432
	MOVLW       0
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd432
	MOVLW       8
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__update_server_from_sd432
	MOVLW       0
	SUBWF       R1, 0 
L__update_server_from_sd432:
	BTFSS       STATUS+0, 0 
	GOTO        L_update_server_from_sd95
;Wifi_module.c,704 :: 		buffer = 2048;
	MOVLW       0
	MOVWF       update_server_from_sd_buffer_L0+0 
	MOVLW       8
	MOVWF       update_server_from_sd_buffer_L0+1 
;Wifi_module.c,705 :: 		} else {
	GOTO        L_update_server_from_sd96
L_update_server_from_sd95:
;Wifi_module.c,706 :: 		buffer = size;
	MOVF        update_server_from_sd_size_L0+0, 0 
	MOVWF       update_server_from_sd_buffer_L0+0 
	MOVF        update_server_from_sd_size_L0+1, 0 
	MOVWF       update_server_from_sd_buffer_L0+1 
;Wifi_module.c,707 :: 		}
L_update_server_from_sd96:
;Wifi_module.c,708 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,709 :: 		waitForInput("OK",10);               // Wait data to be sent
	MOVLW       ?lstr58_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr58_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       10
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,710 :: 		cipsend(buffer);                     // send next packet
	MOVF        update_server_from_sd_buffer_L0+0, 0 
	MOVWF       FARG_cipsend_size+0 
	MOVF        update_server_from_sd_buffer_L0+1, 0 
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,711 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;Wifi_module.c,712 :: 		}
L_update_server_from_sd94:
;Wifi_module.c,713 :: 		Mmc_Fat_Read(&character);
	MOVLW       update_server_from_sd_character_L0+0
	MOVWF       FARG_Mmc_Fat_Read_fdata+0 
	MOVLW       hi_addr(update_server_from_sd_character_L0+0)
	MOVWF       FARG_Mmc_Fat_Read_fdata+1 
	CALL        _Mmc_Fat_Read+0, 0
;Wifi_module.c,714 :: 		UART1_Write(character);         // sends read char to wifi module
	MOVF        update_server_from_sd_character_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;Wifi_module.c,698 :: 		for (i = 0; i < size_buffer; i++) {
	MOVLW       1
	ADDWF       update_server_from_sd_i_L0+0, 1 
	MOVLW       0
	ADDWFC      update_server_from_sd_i_L0+1, 1 
	ADDWFC      update_server_from_sd_i_L0+2, 1 
	ADDWFC      update_server_from_sd_i_L0+3, 1 
;Wifi_module.c,715 :: 		}
	GOTO        L_update_server_from_sd89
L_update_server_from_sd90:
;Wifi_module.c,716 :: 		}
L_update_server_from_sd86:
;Wifi_module.c,717 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,718 :: 		waitForInput("OK",10);
	MOVLW       ?lstr59_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr59_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       10
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,719 :: 		M_Delete_File();
	CALL        _M_Delete_File+0, 0
;Wifi_module.c,720 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,722 :: 		}
L_end_update_server_from_sd:
	RETURN      0
; end of _update_server_from_sd

_read_config:

;Wifi_module.c,767 :: 		void read_config(){
;Wifi_module.c,768 :: 		int i = 0,pos = 0;
	CLRF        read_config_i_L0+0 
	CLRF        read_config_i_L0+1 
;Wifi_module.c,773 :: 		for (i=0;i<1000;i++){
	CLRF        read_config_i_L0+0 
	CLRF        read_config_i_L0+1 
L_read_config97:
	MOVLW       128
	XORWF       read_config_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__read_config434
	MOVLW       232
	SUBWF       read_config_i_L0+0, 0 
L__read_config434:
	BTFSC       STATUS+0, 0 
	GOTO        L_read_config98
;Wifi_module.c,774 :: 		read = EEPROM_Read(i);
	MOVF        read_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        read_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       read_config_read_L0+0 
;Wifi_module.c,775 :: 		if (read != 0 || read != 255){
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__read_config358
	MOVF        read_config_read_L0+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L__read_config358
	GOTO        L_read_config102
L__read_config358:
;Wifi_module.c,776 :: 		if (read == 'A' && EEPROM_Read(++i) == 'D' && EEPROM_Read(++i) == 'C'){
	MOVF        read_config_read_L0+0, 0 
	XORLW       65
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config105
	INFSNZ      read_config_i_L0+0, 1 
	INCF        read_config_i_L0+1, 1 
	MOVF        read_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        read_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config105
	INFSNZ      read_config_i_L0+0, 1 
	INCF        read_config_i_L0+1, 1 
	MOVF        read_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        read_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	XORLW       67
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config105
L__read_config357:
;Wifi_module.c,777 :: 		int j = 4;
	MOVLW       4
	MOVWF       read_config_j_L3+0 
	MOVLW       0
	MOVWF       read_config_j_L3+1 
;Wifi_module.c,779 :: 		strcpy(toWrite," ;ADC");
	MOVLW       read_config_toWrite_L3+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(read_config_toWrite_L3+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr60_Wifi_module+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr60_Wifi_module+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,780 :: 		while (read != '?'){
L_read_config106:
	MOVF        read_config_read_L0+0, 0 
	XORLW       63
	BTFSC       STATUS+0, 2 
	GOTO        L_read_config107
;Wifi_module.c,781 :: 		read =  EEPROM_Read(i++);
	MOVF        read_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        read_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       read_config_read_L0+0 
	INFSNZ      read_config_i_L0+0, 1 
	INCF        read_config_i_L0+1, 1 
;Wifi_module.c,782 :: 		toWrite[j++] = read;
	MOVLW       read_config_toWrite_L3+0
	ADDWF       read_config_j_L3+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(read_config_toWrite_L3+0)
	ADDWFC      read_config_j_L3+1, 0 
	MOVWF       FSR1H 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      read_config_j_L3+0, 1 
	INCF        read_config_j_L3+1, 1 
;Wifi_module.c,783 :: 		if (j == sizeof(toWrite)-1) break;
	MOVLW       0
	XORWF       read_config_j_L3+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__read_config435
	MOVLW       49
	XORWF       read_config_j_L3+0, 0 
L__read_config435:
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config108
	GOTO        L_read_config107
L_read_config108:
;Wifi_module.c,784 :: 		}
	GOTO        L_read_config106
L_read_config107:
;Wifi_module.c,785 :: 		toWrite[j] = '\0';
	MOVLW       read_config_toWrite_L3+0
	ADDWF       read_config_j_L3+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(read_config_toWrite_L3+0)
	ADDWFC      read_config_j_L3+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Wifi_module.c,786 :: 		process_config(toWrite, 0);
	MOVLW       read_config_toWrite_L3+0
	MOVWF       FARG_process_config_buffer+0 
	MOVLW       hi_addr(read_config_toWrite_L3+0)
	MOVWF       FARG_process_config_buffer+1 
	CLRF        FARG_process_config_flag+0 
	CALL        _process_config+0, 0
;Wifi_module.c,788 :: 		} else
	GOTO        L_read_config109
L_read_config105:
;Wifi_module.c,789 :: 		if (read == 'R' && EEPROM_Read(++i) == 'E' && EEPROM_Read(++i) == 'L'){
	MOVF        read_config_read_L0+0, 0 
	XORLW       82
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config112
	INFSNZ      read_config_i_L0+0, 1 
	INCF        read_config_i_L0+1, 1 
	MOVF        read_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        read_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	XORLW       69
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config112
	INFSNZ      read_config_i_L0+0, 1 
	INCF        read_config_i_L0+1, 1 
	MOVF        read_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        read_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	XORLW       76
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config112
L__read_config356:
;Wifi_module.c,790 :: 		int j = 4;
	MOVLW       4
	MOVWF       read_config_j_L3_L3+0 
	MOVLW       0
	MOVWF       read_config_j_L3_L3+1 
;Wifi_module.c,792 :: 		strcpy(toWrite," ;REL");
	MOVLW       read_config_toWrite_L3_L3+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(read_config_toWrite_L3_L3+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr61_Wifi_module+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr61_Wifi_module+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,793 :: 		while (read != '?'){
L_read_config113:
	MOVF        read_config_read_L0+0, 0 
	XORLW       63
	BTFSC       STATUS+0, 2 
	GOTO        L_read_config114
;Wifi_module.c,794 :: 		read =  EEPROM_Read(i++);
	MOVF        read_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        read_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       read_config_read_L0+0 
	INFSNZ      read_config_i_L0+0, 1 
	INCF        read_config_i_L0+1, 1 
;Wifi_module.c,795 :: 		toWrite[j++] = read;
	MOVLW       read_config_toWrite_L3_L3+0
	ADDWF       read_config_j_L3_L3+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(read_config_toWrite_L3_L3+0)
	ADDWFC      read_config_j_L3_L3+1, 0 
	MOVWF       FSR1H 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      read_config_j_L3_L3+0, 1 
	INCF        read_config_j_L3_L3+1, 1 
;Wifi_module.c,796 :: 		if (j == sizeof(toWrite)-1) break;
	MOVLW       0
	XORWF       read_config_j_L3_L3+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__read_config436
	MOVLW       49
	XORWF       read_config_j_L3_L3+0, 0 
L__read_config436:
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config115
	GOTO        L_read_config114
L_read_config115:
;Wifi_module.c,797 :: 		}
	GOTO        L_read_config113
L_read_config114:
;Wifi_module.c,798 :: 		toWrite[j] = '\0';
	MOVLW       read_config_toWrite_L3_L3+0
	ADDWF       read_config_j_L3_L3+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(read_config_toWrite_L3_L3+0)
	ADDWFC      read_config_j_L3_L3+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Wifi_module.c,799 :: 		process_config(toWrite, 0);
	MOVLW       read_config_toWrite_L3_L3+0
	MOVWF       FARG_process_config_buffer+0 
	MOVLW       hi_addr(read_config_toWrite_L3_L3+0)
	MOVWF       FARG_process_config_buffer+1 
	CLRF        FARG_process_config_flag+0 
	CALL        _process_config+0, 0
;Wifi_module.c,801 :: 		} else
	GOTO        L_read_config116
L_read_config112:
;Wifi_module.c,802 :: 		if (read == 'S' && EEPROM_Read(++i) == 'Y' && EEPROM_Read(++i) == 'S'){
	MOVF        read_config_read_L0+0, 0 
	XORLW       83
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config119
	INFSNZ      read_config_i_L0+0, 1 
	INCF        read_config_i_L0+1, 1 
	MOVF        read_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        read_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	XORLW       89
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config119
	INFSNZ      read_config_i_L0+0, 1 
	INCF        read_config_i_L0+1, 1 
	MOVF        read_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        read_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	XORLW       83
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config119
L__read_config355:
;Wifi_module.c,803 :: 		int j = 4;
	MOVLW       4
	MOVWF       read_config_j_L3_L3_L3+0 
	MOVLW       0
	MOVWF       read_config_j_L3_L3_L3+1 
;Wifi_module.c,805 :: 		strcpy(toWrite," ;SYS");
	MOVLW       read_config_toWrite_L3_L3_L3+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(read_config_toWrite_L3_L3_L3+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr62_Wifi_module+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr62_Wifi_module+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,806 :: 		while (read != '?'){
L_read_config120:
	MOVF        read_config_read_L0+0, 0 
	XORLW       63
	BTFSC       STATUS+0, 2 
	GOTO        L_read_config121
;Wifi_module.c,807 :: 		read =  EEPROM_Read(i++);
	MOVF        read_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        read_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       read_config_read_L0+0 
	INFSNZ      read_config_i_L0+0, 1 
	INCF        read_config_i_L0+1, 1 
;Wifi_module.c,808 :: 		toWrite[j++] = read;
	MOVLW       read_config_toWrite_L3_L3_L3+0
	ADDWF       read_config_j_L3_L3_L3+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(read_config_toWrite_L3_L3_L3+0)
	ADDWFC      read_config_j_L3_L3_L3+1, 0 
	MOVWF       FSR1H 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      read_config_j_L3_L3_L3+0, 1 
	INCF        read_config_j_L3_L3_L3+1, 1 
;Wifi_module.c,809 :: 		if (j == sizeof(toWrite)-1) break;
	MOVLW       0
	XORWF       read_config_j_L3_L3_L3+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__read_config437
	MOVLW       99
	XORWF       read_config_j_L3_L3_L3+0, 0 
L__read_config437:
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config122
	GOTO        L_read_config121
L_read_config122:
;Wifi_module.c,810 :: 		}
	GOTO        L_read_config120
L_read_config121:
;Wifi_module.c,811 :: 		toWrite[j] = '\0';
	MOVLW       read_config_toWrite_L3_L3_L3+0
	ADDWF       read_config_j_L3_L3_L3+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(read_config_toWrite_L3_L3_L3+0)
	ADDWFC      read_config_j_L3_L3_L3+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Wifi_module.c,812 :: 		process_config(toWrite, 0);
	MOVLW       read_config_toWrite_L3_L3_L3+0
	MOVWF       FARG_process_config_buffer+0 
	MOVLW       hi_addr(read_config_toWrite_L3_L3_L3+0)
	MOVWF       FARG_process_config_buffer+1 
	CLRF        FARG_process_config_flag+0 
	CALL        _process_config+0, 0
;Wifi_module.c,814 :: 		}
L_read_config119:
L_read_config116:
L_read_config109:
;Wifi_module.c,815 :: 		}
L_read_config102:
;Wifi_module.c,773 :: 		for (i=0;i<1000;i++){
	INFSNZ      read_config_i_L0+0, 1 
	INCF        read_config_i_L0+1, 1 
;Wifi_module.c,817 :: 		}
	GOTO        L_read_config97
L_read_config98:
;Wifi_module.c,847 :: 		for (i=0;i<5;i++){
	CLRF        read_config_i_L0+0 
	CLRF        read_config_i_L0+1 
L_read_config123:
	MOVLW       128
	XORWF       read_config_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__read_config438
	MOVLW       5
	SUBWF       read_config_i_L0+0, 0 
L__read_config438:
	BTFSC       STATUS+0, 0 
	GOTO        L_read_config124
;Wifi_module.c,848 :: 		System.identifier[i] = EEPROM_Read(900+i);
	MOVLW       _System+180
	ADDWF       read_config_i_L0+0, 0 
	MOVWF       FLOC__read_config+0 
	MOVLW       hi_addr(_System+180)
	ADDWFC      read_config_i_L0+1, 0 
	MOVWF       FLOC__read_config+1 
	MOVLW       132
	ADDWF       read_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVLW       3
	ADDWFC      read_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__read_config+0, FSR1
	MOVFF       FLOC__read_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,847 :: 		for (i=0;i<5;i++){
	INFSNZ      read_config_i_L0+0, 1 
	INCF        read_config_i_L0+1, 1 
;Wifi_module.c,849 :: 		}
	GOTO        L_read_config123
L_read_config124:
;Wifi_module.c,850 :: 		if (atoi(System.identifier) == 0){
	MOVLW       _System+180
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_System+180)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__read_config439
	MOVLW       0
	XORWF       R0, 0 
L__read_config439:
	BTFSS       STATUS+0, 2 
	GOTO        L_read_config126
;Wifi_module.c,851 :: 		strcpy(System.identifier,"null");
	MOVLW       _System+180
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+180)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr63_Wifi_module+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr63_Wifi_module+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,852 :: 		}
L_read_config126:
;Wifi_module.c,854 :: 		}
L_end_read_config:
	RETURN      0
; end of _read_config

_setIdentifier:

;Wifi_module.c,858 :: 		void setIdentifier(){
;Wifi_module.c,860 :: 		if (strstr(System.readLine,"SETID") != 0){
	MOVLW       _System+12
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_System+12)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr64_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr64_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__setIdentifier441
	MOVLW       0
	XORWF       R0, 0 
L__setIdentifier441:
	BTFSC       STATUS+0, 2 
	GOTO        L_setIdentifier127
;Wifi_module.c,863 :: 		p = strtok(System.readLine,";");
	MOVLW       _System+12
	MOVWF       FARG_strtok_s1+0 
	MOVLW       hi_addr(_System+12)
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr65_Wifi_module+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr65_Wifi_module+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
;Wifi_module.c,864 :: 		p = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr66_Wifi_module+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr66_Wifi_module+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
;Wifi_module.c,866 :: 		strcpy(System.identifier,p);
	MOVLW       _System+180
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+180)
	MOVWF       FARG_strcpy_to+1 
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,869 :: 		for (i=0;i<5;i++){
	CLRF        setIdentifier_i_L1+0 
L_setIdentifier128:
	MOVLW       128
	XORWF       setIdentifier_i_L1+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       5
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_setIdentifier129
;Wifi_module.c,870 :: 		EEPROM_Write(900+i,System.identifier[i]);
	MOVLW       132
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       3
	MOVWF       FARG_EEPROM_Write_address+1 
	MOVF        setIdentifier_i_L1+0, 0 
	ADDWF       FARG_EEPROM_Write_address+0, 1 
	MOVLW       0
	BTFSC       setIdentifier_i_L1+0, 7 
	MOVLW       255
	ADDWFC      FARG_EEPROM_Write_address+1, 1 
	MOVLW       _System+180
	MOVWF       FSR0 
	MOVLW       hi_addr(_System+180)
	MOVWF       FSR0H 
	MOVF        setIdentifier_i_L1+0, 0 
	ADDWF       FSR0, 1 
	MOVLW       0
	BTFSC       setIdentifier_i_L1+0, 7 
	MOVLW       255
	ADDWFC      FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Wifi_module.c,871 :: 		delay_ms(25);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_setIdentifier131:
	DECFSZ      R13, 1, 1
	BRA         L_setIdentifier131
	DECFSZ      R12, 1, 1
	BRA         L_setIdentifier131
	NOP
	NOP
;Wifi_module.c,869 :: 		for (i=0;i<5;i++){
	INCF        setIdentifier_i_L1+0, 1 
;Wifi_module.c,872 :: 		}
	GOTO        L_setIdentifier128
L_setIdentifier129:
;Wifi_module.c,874 :: 		cipsend(6);
	MOVLW       6
	MOVWF       FARG_cipsend_size+0 
	MOVLW       0
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,875 :: 		UART1_Write_Text("ID OK\n");
	MOVLW       ?lstr67_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr67_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,876 :: 		waitForInput("OK",2);
	MOVLW       ?lstr68_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr68_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       2
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,877 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,878 :: 		}
L_setIdentifier127:
;Wifi_module.c,879 :: 		}
L_end_setIdentifier:
	RETURN      0
; end of _setIdentifier

_getSystemTime:

;Wifi_module.c,882 :: 		void getSystemTime(){
;Wifi_module.c,884 :: 		short i = 0;
	CLRF        getSystemTime_i_L0+0 
;Wifi_module.c,885 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,886 :: 		cipsend(8);
	MOVLW       8
	MOVWF       FARG_cipsend_size+0 
	MOVLW       0
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,887 :: 		UART1_Write_Text("GETTIME\n");
	MOVLW       ?lstr69_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr69_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,888 :: 		waitForInput("TIME",15);
	MOVLW       ?lstr70_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr70_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       15
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,889 :: 		delay_ms(300);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_getSystemTime132:
	DECFSZ      R13, 1, 1
	BRA         L_getSystemTime132
	DECFSZ      R12, 1, 1
	BRA         L_getSystemTime132
	DECFSZ      R11, 1, 1
	BRA         L_getSystemTime132
	NOP
;Wifi_module.c,892 :: 		p = strtok(System.readLine,";");
	MOVLW       _System+12
	MOVWF       FARG_strtok_s1+0 
	MOVLW       hi_addr(_System+12)
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr71_Wifi_module+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr71_Wifi_module+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       getSystemTime_p_L0+0 
	MOVF        R1, 0 
	MOVWF       getSystemTime_p_L0+1 
;Wifi_module.c,893 :: 		while (p != 0){
L_getSystemTime133:
	MOVLW       0
	XORWF       getSystemTime_p_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__getSystemTime443
	MOVLW       0
	XORWF       getSystemTime_p_L0+0, 0 
L__getSystemTime443:
	BTFSC       STATUS+0, 2 
	GOTO        L_getSystemTime134
;Wifi_module.c,894 :: 		switch (i){
	GOTO        L_getSystemTime135
;Wifi_module.c,895 :: 		case 1: SystemTime.year = atoi(p); break;
L_getSystemTime137:
	MOVF        getSystemTime_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        getSystemTime_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+12 
	MOVF        R1, 0 
	MOVWF       _SystemTime+13 
	GOTO        L_getSystemTime136
;Wifi_module.c,896 :: 		case 2: SystemTime.month = atoi(p); break;
L_getSystemTime138:
	MOVF        getSystemTime_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        getSystemTime_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+10 
	MOVF        R1, 0 
	MOVWF       _SystemTime+11 
	GOTO        L_getSystemTime136
;Wifi_module.c,897 :: 		case 3: SystemTime.day = atoi(p); break;
L_getSystemTime139:
	MOVF        getSystemTime_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        getSystemTime_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+8 
	MOVF        R1, 0 
	MOVWF       _SystemTime+9 
	GOTO        L_getSystemTime136
;Wifi_module.c,898 :: 		case 4: SystemTime.hour = atoi(p); break;
L_getSystemTime140:
	MOVF        getSystemTime_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        getSystemTime_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+6 
	MOVF        R1, 0 
	MOVWF       _SystemTime+7 
	GOTO        L_getSystemTime136
;Wifi_module.c,899 :: 		case 5: SystemTime.min = atoi(p);  break;
L_getSystemTime141:
	MOVF        getSystemTime_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        getSystemTime_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+4 
	MOVF        R1, 0 
	MOVWF       _SystemTime+5 
	GOTO        L_getSystemTime136
;Wifi_module.c,900 :: 		case 2: SystemTime.sec = atoi(p); break;
L_getSystemTime142:
	MOVF        getSystemTime_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        getSystemTime_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+2 
	MOVF        R1, 0 
	MOVWF       _SystemTime+3 
	GOTO        L_getSystemTime136
;Wifi_module.c,901 :: 		}
L_getSystemTime135:
	MOVF        getSystemTime_i_L0+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_getSystemTime137
	MOVF        getSystemTime_i_L0+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_getSystemTime138
	MOVF        getSystemTime_i_L0+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_getSystemTime139
	MOVF        getSystemTime_i_L0+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_getSystemTime140
	MOVF        getSystemTime_i_L0+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_getSystemTime141
	MOVF        getSystemTime_i_L0+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_getSystemTime142
L_getSystemTime136:
;Wifi_module.c,902 :: 		i++;
	INCF        getSystemTime_i_L0+0, 1 
;Wifi_module.c,903 :: 		p = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr72_Wifi_module+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr72_Wifi_module+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       getSystemTime_p_L0+0 
	MOVF        R1, 0 
	MOVWF       getSystemTime_p_L0+1 
;Wifi_module.c,904 :: 		}
	GOTO        L_getSystemTime133
L_getSystemTime134:
;Wifi_module.c,906 :: 		cipsend(8);
	MOVLW       8
	MOVWF       FARG_cipsend_size+0 
	MOVLW       0
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,907 :: 		UART1_Write_Text("TIME OK\n");
	MOVLW       ?lstr73_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr73_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,908 :: 		waitForInput("OK",2);
	MOVLW       ?lstr74_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr74_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       2
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,910 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,911 :: 		}
L_end_getSystemTime:
	RETURN      0
; end of _getSystemTime

_init_network_environment:

;Wifi_module.c,913 :: 		void init_network_environment(){
;Wifi_module.c,915 :: 		if (strstr(System.identifier,"null") != 0){
	MOVLW       _System+180
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_System+180)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr75_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr75_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__init_network_environment445
	MOVLW       0
	XORWF       R0, 0 
L__init_network_environment445:
	BTFSC       STATUS+0, 2 
	GOTO        L_init_network_environment143
;Wifi_module.c,916 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,917 :: 		cipsend(6);
	MOVLW       6
	MOVWF       FARG_cipsend_size+0 
	MOVLW       0
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,918 :: 		UART1_Write_Text("GETID\n");
	MOVLW       ?lstr76_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr76_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,919 :: 		waitForInput("IPD",15);
	MOVLW       ?lstr77_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr77_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       15
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,920 :: 		delay_ms(300);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_init_network_environment144:
	DECFSZ      R13, 1, 1
	BRA         L_init_network_environment144
	DECFSZ      R12, 1, 1
	BRA         L_init_network_environment144
	DECFSZ      R11, 1, 1
	BRA         L_init_network_environment144
	NOP
;Wifi_module.c,921 :: 		setIdentifier();
	CALL        _setIdentifier+0, 0
;Wifi_module.c,922 :: 		}else {
	GOTO        L_init_network_environment145
L_init_network_environment143:
;Wifi_module.c,924 :: 		int size = strlen(System.identifier) + 5;
	MOVLW       _System+180
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(_System+180)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       5
	ADDWF       R0, 0 
	MOVWF       FARG_cipsend_size+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FARG_cipsend_size+1 
;Wifi_module.c,925 :: 		cipsend(size);
	CALL        _cipsend+0, 0
;Wifi_module.c,926 :: 		UART1_Write_Text("ID;");
	MOVLW       ?lstr78_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr78_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,927 :: 		UART1_Write_Text(System.identifier);
	MOVLW       _System+180
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_System+180)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,928 :: 		UART1_Write_Text(";\n");
	MOVLW       ?lstr79_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr79_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,929 :: 		waitForInput("OK",2);
	MOVLW       ?lstr80_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr80_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       2
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,930 :: 		}
L_init_network_environment145:
;Wifi_module.c,931 :: 		getSystemTime();
	CALL        _getSystemTime+0, 0
;Wifi_module.c,932 :: 		}
L_end_init_network_environment:
	RETURN      0
; end of _init_network_environment

_process_io:

;Wifi_module.c,934 :: 		void process_io(){
;Wifi_module.c,937 :: 		if (System.isInputReady == TRUE){    // If System.readLine contains \0 or \n
	MOVF        _System+177, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_process_io146
;Wifi_module.c,942 :: 		if (System.connection_type == SERVER && strstr(System.readLine, "CONNECT") != 0 ){
	MOVF        _System+271, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_process_io149
	MOVLW       _System+12
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_System+12)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr81_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr81_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_io447
	MOVLW       0
	XORWF       R0, 0 
L__process_io447:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io149
L__process_io359:
;Wifi_module.c,943 :: 		init_network_environment();
	CALL        _init_network_environment+0, 0
;Wifi_module.c,944 :: 		}
L_process_io149:
;Wifi_module.c,946 :: 		if (strstr(System.readLine, "CLOSED") != 0 ){
	MOVLW       _System+12
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_System+12)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr82_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr82_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_io448
	MOVLW       0
	XORWF       R0, 0 
L__process_io448:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io150
;Wifi_module.c,947 :: 		System.network_status = IDLE;
	MOVLW       2
	MOVWF       _System+185 
;Wifi_module.c,948 :: 		System.wifi_status = WIFI_NOT_CONNECTED;
	MOVLW       1
	MOVWF       _System+176 
;Wifi_module.c,949 :: 		}
L_process_io150:
;Wifi_module.c,952 :: 		if (strstr(System.readLine,"NEWCONFIG") != 0){
	MOVLW       _System+12
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_System+12)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr83_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr83_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_io449
	MOVLW       0
	XORWF       R0, 0 
L__process_io449:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io151
;Wifi_module.c,954 :: 		short flag = 1;
	MOVLW       1
	MOVWF       process_io_flag_L2+0 
;Wifi_module.c,956 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;Wifi_module.c,957 :: 		cipsend(3);
	MOVLW       3
	MOVWF       FARG_cipsend_size+0 
	MOVLW       0
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,958 :: 		UART1_Write_Text("OK\n");
	MOVLW       ?lstr84_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr84_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,959 :: 		waitForInput("SEND OK",3);
	MOVLW       ?lstr85_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr85_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       3
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,960 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,962 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,964 :: 		while (flag){
L_process_io152:
	MOVF        process_io_flag_L2+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io153
;Wifi_module.c,966 :: 		char *p = wait("#",3);
	MOVLW       ?lstr86_Wifi_module+0
	MOVWF       FARG_wait_input+0 
	MOVLW       hi_addr(?lstr86_Wifi_module+0)
	MOVWF       FARG_wait_input+1 
	MOVLW       3
	MOVWF       FARG_wait_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_timeout+1 
	CALL        _wait+0, 0
	MOVF        R0, 0 
	MOVWF       process_io_p_L3+0 
	MOVF        R1, 0 
	MOVWF       process_io_p_L3+1 
;Wifi_module.c,967 :: 		if (strstr(p,"null") != 0){
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr87_Wifi_module+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr87_Wifi_module+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_io450
	MOVLW       0
	XORWF       R0, 0 
L__process_io450:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io154
;Wifi_module.c,968 :: 		break;
	GOTO        L_process_io153
;Wifi_module.c,969 :: 		}
L_process_io154:
;Wifi_module.c,971 :: 		process_config(p,1);
	MOVF        process_io_p_L3+0, 0 
	MOVWF       FARG_process_config_buffer+0 
	MOVF        process_io_p_L3+1, 0 
	MOVWF       FARG_process_config_buffer+1 
	MOVLW       1
	MOVWF       FARG_process_config_flag+0 
	CALL        _process_config+0, 0
;Wifi_module.c,973 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;Wifi_module.c,974 :: 		cipsend(3);
	MOVLW       3
	MOVWF       FARG_cipsend_size+0 
	MOVLW       0
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,975 :: 		UART1_Write_Text("OK\n");
	MOVLW       ?lstr88_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr88_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,976 :: 		waitForInput("SEND OK",3);
	MOVLW       ?lstr89_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr89_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       3
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,977 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,979 :: 		p=0;
	CLRF        process_io_p_L3+0 
	CLRF        process_io_p_L3+1 
;Wifi_module.c,980 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,981 :: 		}
	GOTO        L_process_io152
L_process_io153:
;Wifi_module.c,984 :: 		cipsend(7);
	MOVLW       7
	MOVWF       FARG_cipsend_size+0 
	MOVLW       0
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,985 :: 		UART1_Write_Text("CFG OK\n");
	MOVLW       ?lstr90_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr90_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,986 :: 		waitForInput("SEND OK",3);
	MOVLW       ?lstr91_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr91_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       3
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,988 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,989 :: 		}
L_process_io151:
;Wifi_module.c,992 :: 		if (strstr(System.readLine,load(System.load_buffer,BOOTLOAD)) != 0){
	MOVLW       _System+193
	MOVWF       FARG_load_dest+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_load_dest+1 
	MOVLW       _BOOTLOAD+0
	MOVWF       FARG_load_src+0 
	MOVLW       hi_addr(_BOOTLOAD+0)
	MOVWF       FARG_load_src+1 
	MOVLW       higher_addr(_BOOTLOAD+0)
	MOVWF       FARG_load_src+2 
	CALL        _load+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _System+12
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_System+12)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_io451
	MOVLW       0
	XORWF       R0, 0 
L__process_io451:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io155
;Wifi_module.c,995 :: 		Start_Bootload();                 //   received start bootload
	CALL        _Start_Bootload+0, 0
;Wifi_module.c,997 :: 		}
L_process_io155:
;Wifi_module.c,1000 :: 		if (strstr(System.readLine,load(System.load_buffer,CHECK)) != 0){
	MOVLW       _System+193
	MOVWF       FARG_load_dest+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_load_dest+1 
	MOVLW       _CHECK+0
	MOVWF       FARG_load_src+0 
	MOVLW       hi_addr(_CHECK+0)
	MOVWF       FARG_load_src+1 
	MOVLW       higher_addr(_CHECK+0)
	MOVWF       FARG_load_src+2 
	CALL        _load+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _System+12
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_System+12)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_io452
	MOVLW       0
	XORWF       R0, 0 
L__process_io452:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io156
;Wifi_module.c,1003 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,1004 :: 		}
L_process_io156:
;Wifi_module.c,1007 :: 		if (strstr(System.readLine,load(System.load_buffer,READSD)) != 0){
	MOVLW       _System+193
	MOVWF       FARG_load_dest+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_load_dest+1 
	MOVLW       _READSD+0
	MOVWF       FARG_load_src+0 
	MOVLW       hi_addr(_READSD+0)
	MOVWF       FARG_load_src+1 
	MOVLW       higher_addr(_READSD+0)
	MOVWF       FARG_load_src+2 
	CALL        _load+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _System+12
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_System+12)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__process_io453
	MOVLW       0
	XORWF       R0, 0 
L__process_io453:
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io157
;Wifi_module.c,1008 :: 		update_server_from_sd();
	CALL        _update_server_from_sd+0, 0
;Wifi_module.c,1009 :: 		delay_ms(500);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_process_io158:
	DECFSZ      R13, 1, 1
	BRA         L_process_io158
	DECFSZ      R12, 1, 1
	BRA         L_process_io158
	DECFSZ      R11, 1, 1
	BRA         L_process_io158
	NOP
	NOP
;Wifi_module.c,1010 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,1011 :: 		}
L_process_io157:
;Wifi_module.c,1013 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,1015 :: 		}
L_process_io146:
;Wifi_module.c,1016 :: 		}
L_end_process_io:
	RETURN      0
; end of _process_io

_getTimeStamp:

;Wifi_module.c,1020 :: 		void getTimeStamp(){
;Wifi_module.c,1024 :: 		if (SystemTime.year < 10){
	MOVLW       128
	XORWF       _SystemTime+13, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__getTimeStamp455
	MOVLW       10
	SUBWF       _SystemTime+12, 0 
L__getTimeStamp455:
	BTFSC       STATUS+0, 0 
	GOTO        L_getTimeStamp159
;Wifi_module.c,1025 :: 		strcpy(System.load_buffer,"0");
	MOVLW       _System+193
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr92_Wifi_module+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr92_Wifi_module+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,1026 :: 		strcat(System.load_buffer,itoa(SystemTime.year,buffer));
	MOVF        _SystemTime+12, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+13, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1027 :: 		} else {
	GOTO        L_getTimeStamp160
L_getTimeStamp159:
;Wifi_module.c,1028 :: 		strcpy(System.load_buffer,itoa(SystemTime.year,buffer));
	MOVF        _SystemTime+12, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+13, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcpy_to+1 
	CALL        _strcpy+0, 0
;Wifi_module.c,1029 :: 		}
L_getTimeStamp160:
;Wifi_module.c,1031 :: 		if (SystemTime.month < 10){
	MOVLW       128
	XORWF       _SystemTime+11, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__getTimeStamp456
	MOVLW       10
	SUBWF       _SystemTime+10, 0 
L__getTimeStamp456:
	BTFSC       STATUS+0, 0 
	GOTO        L_getTimeStamp161
;Wifi_module.c,1032 :: 		strcat(System.load_buffer,"0");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr93_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr93_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1033 :: 		strcat(System.load_buffer,itoa(SystemTime.month,buffer));
	MOVF        _SystemTime+10, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+11, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1034 :: 		} else {
	GOTO        L_getTimeStamp162
L_getTimeStamp161:
;Wifi_module.c,1035 :: 		strcat(System.load_buffer,itoa(SystemTime.month,buffer));
	MOVF        _SystemTime+10, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+11, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1036 :: 		}
L_getTimeStamp162:
;Wifi_module.c,1038 :: 		if (SystemTime.day < 10){
	MOVLW       128
	XORWF       _SystemTime+9, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__getTimeStamp457
	MOVLW       10
	SUBWF       _SystemTime+8, 0 
L__getTimeStamp457:
	BTFSC       STATUS+0, 0 
	GOTO        L_getTimeStamp163
;Wifi_module.c,1039 :: 		strcat(System.load_buffer,"0");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr94_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr94_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1040 :: 		strcat(System.load_buffer,itoa(SystemTime.day,buffer));
	MOVF        _SystemTime+8, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+9, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1041 :: 		} else {
	GOTO        L_getTimeStamp164
L_getTimeStamp163:
;Wifi_module.c,1042 :: 		strcat(System.load_buffer,itoa(SystemTime.day,buffer));
	MOVF        _SystemTime+8, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+9, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1043 :: 		}
L_getTimeStamp164:
;Wifi_module.c,1045 :: 		if (SystemTime.hour < 10){
	MOVLW       128
	XORWF       _SystemTime+7, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__getTimeStamp458
	MOVLW       10
	SUBWF       _SystemTime+6, 0 
L__getTimeStamp458:
	BTFSC       STATUS+0, 0 
	GOTO        L_getTimeStamp165
;Wifi_module.c,1046 :: 		strcat(System.load_buffer,"0");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr95_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr95_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1047 :: 		strcat(System.load_buffer,itoa(SystemTime.hour,buffer));
	MOVF        _SystemTime+6, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+7, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1048 :: 		} else {
	GOTO        L_getTimeStamp166
L_getTimeStamp165:
;Wifi_module.c,1049 :: 		strcat(System.load_buffer,itoa(SystemTime.hour,buffer));
	MOVF        _SystemTime+6, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+7, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1050 :: 		}
L_getTimeStamp166:
;Wifi_module.c,1052 :: 		if (SystemTime.min < 10){
	MOVLW       128
	XORWF       _SystemTime+5, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__getTimeStamp459
	MOVLW       10
	SUBWF       _SystemTime+4, 0 
L__getTimeStamp459:
	BTFSC       STATUS+0, 0 
	GOTO        L_getTimeStamp167
;Wifi_module.c,1053 :: 		strcat(System.load_buffer,"0");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr96_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr96_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1054 :: 		strcat(System.load_buffer,itoa(SystemTime.min,buffer));
	MOVF        _SystemTime+4, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+5, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1055 :: 		} else {
	GOTO        L_getTimeStamp168
L_getTimeStamp167:
;Wifi_module.c,1056 :: 		strcat(System.load_buffer,itoa(SystemTime.min,buffer));
	MOVF        _SystemTime+4, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+5, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1057 :: 		}
L_getTimeStamp168:
;Wifi_module.c,1059 :: 		if (SystemTime.sec < 10){
	MOVLW       128
	XORWF       _SystemTime+3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__getTimeStamp460
	MOVLW       10
	SUBWF       _SystemTime+2, 0 
L__getTimeStamp460:
	BTFSC       STATUS+0, 0 
	GOTO        L_getTimeStamp169
;Wifi_module.c,1060 :: 		strcat(System.load_buffer,"0");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr97_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr97_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1061 :: 		strcat(System.load_buffer,itoa(SystemTime.sec,buffer));
	MOVF        _SystemTime+2, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+3, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1062 :: 		} else {
	GOTO        L_getTimeStamp170
L_getTimeStamp169:
;Wifi_module.c,1063 :: 		strcat(System.load_buffer,itoa(SystemTime.sec,buffer));
	MOVF        _SystemTime+2, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _SystemTime+3, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       getTimeStamp_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(getTimeStamp_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1064 :: 		}
L_getTimeStamp170:
;Wifi_module.c,1065 :: 		}
L_end_getTimeStamp:
	RETURN      0
; end of _getTimeStamp

_timeStampMeasurement:

;Wifi_module.c,1067 :: 		char * timeStampMeasurement(int index){
;Wifi_module.c,1073 :: 		getTimeStamp();
	CALL        _getTimeStamp+0, 0
;Wifi_module.c,1075 :: 		strcat(System.load_buffer,";");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr98_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr98_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1077 :: 		strcat(System.load_buffer,itoa(index+1,buffer));
	MOVLW       1
	ADDWF       FARG_timeStampMeasurement_index+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVLW       0
	ADDWFC      FARG_timeStampMeasurement_index+1, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       timeStampMeasurement_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(timeStampMeasurement_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcat_from+1 
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1079 :: 		strcat(System.load_buffer,";");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr99_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr99_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1081 :: 		sprintf(buffer,"%4f", ADC_channel[index].ADC_value);
	MOVLW       timeStampMeasurement_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(timeStampMeasurement_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_100_Wifi_module+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_100_Wifi_module+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_100_Wifi_module+0)
	MOVWF       FARG_sprintf_f+2 
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_timeStampMeasurement_index+0, 0 
	MOVWF       R4 
	MOVF        FARG_timeStampMeasurement_index+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       6
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;Wifi_module.c,1083 :: 		strcat(System.load_buffer,buffer);
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       timeStampMeasurement_buffer_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(timeStampMeasurement_buffer_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1085 :: 		strcat(System.load_buffer,"\n");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr101_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr101_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1087 :: 		System.size = strlen(System.load_buffer);
	MOVLW       _System+193
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	MOVWF       _System+263 
;Wifi_module.c,1089 :: 		return System.load_buffer;
	MOVLW       _System+193
	MOVWF       R0 
	MOVLW       hi_addr(_System+193)
	MOVWF       R1 
;Wifi_module.c,1090 :: 		}
L_end_timeStampMeasurement:
	RETURN      0
; end of _timeStampMeasurement

_update_server:

;Wifi_module.c,1092 :: 		void update_server(short index){
;Wifi_module.c,1094 :: 		}
L_end_update_server:
	RETURN      0
; end of _update_server

_doMeasurement:

;Wifi_module.c,1096 :: 		double doMeasurement(int position, int flag){
;Wifi_module.c,1098 :: 		if (flag == 0){
	MOVLW       0
	XORWF       FARG_doMeasurement_flag+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__doMeasurement464
	MOVLW       0
	XORWF       FARG_doMeasurement_flag+0, 0 
L__doMeasurement464:
	BTFSS       STATUS+0, 2 
	GOTO        L_doMeasurement171
;Wifi_module.c,1100 :: 		switch (RELAY[position].R_trig){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_doMeasurement_position+0, 0 
	MOVWF       R4 
	MOVF        FARG_doMeasurement_position+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FLOC__doMeasurement+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__doMeasurement+1 
	GOTO        L_doMeasurement172
;Wifi_module.c,1101 :: 		case 99: Measure_MS8607();
L_doMeasurement174:
	CALL        _Measure_MS8607+0, 0
;Wifi_module.c,1102 :: 		return getTemperature(); break;
	CALL        _getTemperature+0, 0
	GOTO        L_end_doMeasurement
;Wifi_module.c,1103 :: 		case 98: Measure_MS8607();
L_doMeasurement175:
	CALL        _Measure_MS8607+0, 0
;Wifi_module.c,1104 :: 		return getHumidity(); break;
	CALL        _getHumidity+0, 0
	GOTO        L_end_doMeasurement
;Wifi_module.c,1105 :: 		case 97: Measure_MS8607();
L_doMeasurement176:
	CALL        _Measure_MS8607+0, 0
;Wifi_module.c,1106 :: 		return getPressure(); break;
	CALL        _getPressure+0, 0
	GOTO        L_end_doMeasurement
;Wifi_module.c,1107 :: 		case 96:
L_doMeasurement177:
;Wifi_module.c,1110 :: 		CO2_PULSE = 0;
	BCF         PORTA+0, 1 
;Wifi_module.c,1111 :: 		CO2_HEAT = 1;
	BSF         PORTA+0, 2 
;Wifi_module.c,1112 :: 		delay_ms(14);
	MOVLW       73
	MOVWF       R12, 0
	MOVLW       185
	MOVWF       R13, 0
L_doMeasurement178:
	DECFSZ      R13, 1, 1
	BRA         L_doMeasurement178
	DECFSZ      R12, 1, 1
	BRA         L_doMeasurement178
;Wifi_module.c,1113 :: 		CO2_HEAT = 0;
	BCF         PORTA+0, 2 
;Wifi_module.c,1114 :: 		delay_ms(981);
	MOVLW       20
	MOVWF       R11, 0
	MOVLW       233
	MOVWF       R12, 0
	MOVLW       11
	MOVWF       R13, 0
L_doMeasurement179:
	DECFSZ      R13, 1, 1
	BRA         L_doMeasurement179
	DECFSZ      R12, 1, 1
	BRA         L_doMeasurement179
	DECFSZ      R11, 1, 1
	BRA         L_doMeasurement179
;Wifi_module.c,1115 :: 		CO2_PULSE = 1;
	BSF         PORTA+0, 1 
;Wifi_module.c,1116 :: 		delay_us(2500);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_doMeasurement180:
	DECFSZ      R13, 1, 1
	BRA         L_doMeasurement180
	DECFSZ      R12, 1, 1
	BRA         L_doMeasurement180
	NOP
	NOP
;Wifi_module.c,1117 :: 		CO2_PULSE = 0;
	BCF         PORTA+0, 1 
;Wifi_module.c,1119 :: 		return (double)ADC_Get_Sample(3) / 4096 * 1000;
	MOVLW       3
	MOVWF       FARG_ADC_Get_Sample_channel+0 
	CALL        _ADC_Get_Sample+0, 0
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       139
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	GOTO        L_end_doMeasurement
;Wifi_module.c,1121 :: 		default: return ADC_Get_Sample(RELAY[position].R_trig); break;
L_doMeasurement181:
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_doMeasurement_position+0, 0 
	MOVWF       R4 
	MOVF        FARG_doMeasurement_position+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ADC_Get_Sample_channel+0 
	CALL        _ADC_Get_Sample+0, 0
	CALL        _word2double+0, 0
	GOTO        L_end_doMeasurement
;Wifi_module.c,1122 :: 		}
L_doMeasurement172:
	MOVFF       FLOC__doMeasurement+0, FSR0
	MOVFF       FLOC__doMeasurement+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__doMeasurement465
	MOVLW       99
	XORWF       R1, 0 
L__doMeasurement465:
	BTFSC       STATUS+0, 2 
	GOTO        L_doMeasurement174
	MOVFF       FLOC__doMeasurement+0, FSR0
	MOVFF       FLOC__doMeasurement+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__doMeasurement466
	MOVLW       98
	XORWF       R1, 0 
L__doMeasurement466:
	BTFSC       STATUS+0, 2 
	GOTO        L_doMeasurement175
	MOVFF       FLOC__doMeasurement+0, FSR0
	MOVFF       FLOC__doMeasurement+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__doMeasurement467
	MOVLW       97
	XORWF       R1, 0 
L__doMeasurement467:
	BTFSC       STATUS+0, 2 
	GOTO        L_doMeasurement176
	MOVFF       FLOC__doMeasurement+0, FSR0
	MOVFF       FLOC__doMeasurement+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__doMeasurement468
	MOVLW       96
	XORWF       R1, 0 
L__doMeasurement468:
	BTFSC       STATUS+0, 2 
	GOTO        L_doMeasurement177
	GOTO        L_doMeasurement181
;Wifi_module.c,1126 :: 		} else {
L_doMeasurement171:
;Wifi_module.c,1128 :: 		switch (ADC_channel[position].port){
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_doMeasurement_position+0, 0 
	MOVWF       R4 
	MOVF        FARG_doMeasurement_position+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       10
	ADDWF       R0, 0 
	MOVWF       FLOC__doMeasurement+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__doMeasurement+1 
	GOTO        L_doMeasurement183
;Wifi_module.c,1129 :: 		case 99: Measure_MS8607();
L_doMeasurement185:
	CALL        _Measure_MS8607+0, 0
;Wifi_module.c,1130 :: 		return getTemperature();
	CALL        _getTemperature+0, 0
	GOTO        L_end_doMeasurement
;Wifi_module.c,1132 :: 		case 98: Measure_MS8607();
L_doMeasurement186:
	CALL        _Measure_MS8607+0, 0
;Wifi_module.c,1133 :: 		return getHumidity();
	CALL        _getHumidity+0, 0
	GOTO        L_end_doMeasurement
;Wifi_module.c,1135 :: 		case 97: Measure_MS8607();
L_doMeasurement187:
	CALL        _Measure_MS8607+0, 0
;Wifi_module.c,1136 :: 		return getPressure();
	CALL        _getPressure+0, 0
	GOTO        L_end_doMeasurement
;Wifi_module.c,1138 :: 		case 96: // CO2
L_doMeasurement188:
;Wifi_module.c,1140 :: 		CO2_PULSE = 0;
	BCF         PORTA+0, 1 
;Wifi_module.c,1141 :: 		CO2_HEAT = 1;
	BSF         PORTA+0, 2 
;Wifi_module.c,1142 :: 		delay_ms(14);
	MOVLW       73
	MOVWF       R12, 0
	MOVLW       185
	MOVWF       R13, 0
L_doMeasurement189:
	DECFSZ      R13, 1, 1
	BRA         L_doMeasurement189
	DECFSZ      R12, 1, 1
	BRA         L_doMeasurement189
;Wifi_module.c,1143 :: 		CO2_HEAT = 0;
	BCF         PORTA+0, 2 
;Wifi_module.c,1144 :: 		delay_ms(981);
	MOVLW       20
	MOVWF       R11, 0
	MOVLW       233
	MOVWF       R12, 0
	MOVLW       11
	MOVWF       R13, 0
L_doMeasurement190:
	DECFSZ      R13, 1, 1
	BRA         L_doMeasurement190
	DECFSZ      R12, 1, 1
	BRA         L_doMeasurement190
	DECFSZ      R11, 1, 1
	BRA         L_doMeasurement190
;Wifi_module.c,1145 :: 		CO2_PULSE = 1;
	BSF         PORTA+0, 1 
;Wifi_module.c,1146 :: 		delay_us(2500);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_doMeasurement191:
	DECFSZ      R13, 1, 1
	BRA         L_doMeasurement191
	DECFSZ      R12, 1, 1
	BRA         L_doMeasurement191
	NOP
	NOP
;Wifi_module.c,1147 :: 		CO2_PULSE = 0;
	BCF         PORTA+0, 1 
;Wifi_module.c,1150 :: 		return (double)ADC_Get_Sample(3) / 4096 * 1000;
	MOVLW       3
	MOVWF       FARG_ADC_Get_Sample_channel+0 
	CALL        _ADC_Get_Sample+0, 0
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       139
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	GOTO        L_end_doMeasurement
;Wifi_module.c,1151 :: 		default: return ADC_Get_Sample(ADC_channel[index].port);break;
L_doMeasurement192:
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _index+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       _index+0, 7 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       10
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ADC_Get_Sample_channel+0 
	CALL        _ADC_Get_Sample+0, 0
	CALL        _word2double+0, 0
	GOTO        L_end_doMeasurement
;Wifi_module.c,1152 :: 		}
L_doMeasurement183:
	MOVFF       FLOC__doMeasurement+0, FSR0
	MOVFF       FLOC__doMeasurement+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__doMeasurement469
	MOVLW       99
	XORWF       R1, 0 
L__doMeasurement469:
	BTFSC       STATUS+0, 2 
	GOTO        L_doMeasurement185
	MOVFF       FLOC__doMeasurement+0, FSR0
	MOVFF       FLOC__doMeasurement+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__doMeasurement470
	MOVLW       98
	XORWF       R1, 0 
L__doMeasurement470:
	BTFSC       STATUS+0, 2 
	GOTO        L_doMeasurement186
	MOVFF       FLOC__doMeasurement+0, FSR0
	MOVFF       FLOC__doMeasurement+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__doMeasurement471
	MOVLW       97
	XORWF       R1, 0 
L__doMeasurement471:
	BTFSC       STATUS+0, 2 
	GOTO        L_doMeasurement187
	MOVFF       FLOC__doMeasurement+0, FSR0
	MOVFF       FLOC__doMeasurement+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__doMeasurement472
	MOVLW       96
	XORWF       R1, 0 
L__doMeasurement472:
	BTFSC       STATUS+0, 2 
	GOTO        L_doMeasurement188
	GOTO        L_doMeasurement192
;Wifi_module.c,1155 :: 		}
L_end_doMeasurement:
	RETURN      0
; end of _doMeasurement

_isStart:

;Wifi_module.c,1157 :: 		short isStart(int position, int flag){      // time in min:  21:58 equals  1318
;Wifi_module.c,1159 :: 		int startTime = 0;
	CLRF        isStart_startTime_L0+0 
	CLRF        isStart_startTime_L0+1 
	CLRF        isStart_endTime_L0+0 
	CLRF        isStart_endTime_L0+1 
	CLRF        isStart_sysTime_L0+0 
	CLRF        isStart_sysTime_L0+1 
;Wifi_module.c,1163 :: 		if (flag == 1){
	MOVLW       0
	XORWF       FARG_isStart_flag+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__isStart474
	MOVLW       1
	XORWF       FARG_isStart_flag+0, 0 
L__isStart474:
	BTFSS       STATUS+0, 2 
	GOTO        L_isStart193
;Wifi_module.c,1164 :: 		startTime = RELAY[position].R_start;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_isStart_position+0, 0 
	MOVWF       R4 
	MOVF        FARG_isStart_position+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       isStart_startTime_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       isStart_startTime_L0+1 
;Wifi_module.c,1165 :: 		endTime = RELAY[position].R_end;
	MOVLW       14
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       isStart_endTime_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       isStart_endTime_L0+1 
;Wifi_module.c,1166 :: 		} else {
	GOTO        L_isStart194
L_isStart193:
;Wifi_module.c,1167 :: 		startTime = ADC_CHANNEL[position].ADC_start_time;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_isStart_position+0, 0 
	MOVWF       R4 
	MOVF        FARG_isStart_position+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       14
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       isStart_startTime_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       isStart_startTime_L0+1 
;Wifi_module.c,1168 :: 		endTime = ADC_CHANNEL[position].ADC_end_time;
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       isStart_endTime_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       isStart_endTime_L0+1 
;Wifi_module.c,1169 :: 		}
L_isStart194:
;Wifi_module.c,1170 :: 		sysTime = SystemTime.hour * 60 + SystemTime.min;
	MOVF        _SystemTime+6, 0 
	MOVWF       R0 
	MOVF        _SystemTime+7, 0 
	MOVWF       R1 
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        _SystemTime+4, 0 
	ADDWF       R0, 0 
	MOVWF       isStart_sysTime_L0+0 
	MOVF        _SystemTime+5, 0 
	ADDWFC      R1, 0 
	MOVWF       isStart_sysTime_L0+1 
;Wifi_module.c,1172 :: 		if ( startTime == 99 && endTime == 99 ) return 1;
	MOVLW       0
	XORWF       isStart_startTime_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__isStart475
	MOVLW       99
	XORWF       isStart_startTime_L0+0, 0 
L__isStart475:
	BTFSS       STATUS+0, 2 
	GOTO        L_isStart197
	MOVLW       0
	XORWF       isStart_endTime_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__isStart476
	MOVLW       99
	XORWF       isStart_endTime_L0+0, 0 
L__isStart476:
	BTFSS       STATUS+0, 2 
	GOTO        L_isStart197
L__isStart362:
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_isStart
L_isStart197:
;Wifi_module.c,1174 :: 		if (endTime > startTime){
	MOVLW       128
	XORWF       isStart_startTime_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       isStart_endTime_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__isStart477
	MOVF        isStart_endTime_L0+0, 0 
	SUBWF       isStart_startTime_L0+0, 0 
L__isStart477:
	BTFSC       STATUS+0, 0 
	GOTO        L_isStart198
;Wifi_module.c,1175 :: 		if (sysTime >= startTime && sysTime < endTime){
	MOVLW       128
	XORWF       isStart_sysTime_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       isStart_startTime_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__isStart478
	MOVF        isStart_startTime_L0+0, 0 
	SUBWF       isStart_sysTime_L0+0, 0 
L__isStart478:
	BTFSS       STATUS+0, 0 
	GOTO        L_isStart201
	MOVLW       128
	XORWF       isStart_sysTime_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       isStart_endTime_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__isStart479
	MOVF        isStart_endTime_L0+0, 0 
	SUBWF       isStart_sysTime_L0+0, 0 
L__isStart479:
	BTFSC       STATUS+0, 0 
	GOTO        L_isStart201
L__isStart361:
;Wifi_module.c,1176 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_isStart
;Wifi_module.c,1177 :: 		}
L_isStart201:
;Wifi_module.c,1178 :: 		} else {
	GOTO        L_isStart202
L_isStart198:
;Wifi_module.c,1179 :: 		if (sysTime >= startTime || sysTime < endTime){
	MOVLW       128
	XORWF       isStart_sysTime_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       isStart_startTime_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__isStart480
	MOVF        isStart_startTime_L0+0, 0 
	SUBWF       isStart_sysTime_L0+0, 0 
L__isStart480:
	BTFSC       STATUS+0, 0 
	GOTO        L__isStart360
	MOVLW       128
	XORWF       isStart_sysTime_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       isStart_endTime_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__isStart481
	MOVF        isStart_endTime_L0+0, 0 
	SUBWF       isStart_sysTime_L0+0, 0 
L__isStart481:
	BTFSS       STATUS+0, 0 
	GOTO        L__isStart360
	GOTO        L_isStart205
L__isStart360:
;Wifi_module.c,1180 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_isStart
;Wifi_module.c,1181 :: 		}
L_isStart205:
;Wifi_module.c,1182 :: 		}
L_isStart202:
;Wifi_module.c,1183 :: 		return 0;
	CLRF        R0 
;Wifi_module.c,1185 :: 		}
L_end_isStart:
	RETURN      0
; end of _isStart

_measure_sensors:

;Wifi_module.c,1187 :: 		void measure_sensors(){
;Wifi_module.c,1189 :: 		if (System.isADCEnabled){
	MOVF        _System+268, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_measure_sensors206
;Wifi_module.c,1192 :: 		for (index = 0; index < CHANNEL_COUNT; index++){
	CLRF        measure_sensors_index_L1+0 
	CLRF        measure_sensors_index_L1+1 
L_measure_sensors207:
	MOVLW       128
	XORWF       measure_sensors_index_L1+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__measure_sensors483
	MOVLW       8
	SUBWF       measure_sensors_index_L1+0, 0 
L__measure_sensors483:
	BTFSC       STATUS+0, 0 
	GOTO        L_measure_sensors208
;Wifi_module.c,1196 :: 		if ((isStart(index,0) == TRUE &&
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       FARG_isStart_position+0 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       FARG_isStart_position+1 
	CLRF        FARG_isStart_flag+0 
	CLRF        FARG_isStart_flag+1 
	CALL        _isStart+0, 0
;Wifi_module.c,1197 :: 		ADC_channel[index].ADC_isPortConnected == TRUE)                  &&
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_measure_sensors214
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       R4 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__measure_sensors484
	MOVLW       1
	XORWF       R1, 0 
L__measure_sensors484:
	BTFSS       STATUS+0, 2 
	GOTO        L_measure_sensors214
;Wifi_module.c,1198 :: 		(ADC_channel[index].ADC_sec == ADC_channel[index].ADC_sec_buffer) &&
L__measure_sensors365:
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       R4 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R2 
	MOVF        R4, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__measure_sensors485
	MOVF        R1, 0 
	XORWF       R3, 0 
L__measure_sensors485:
	BTFSS       STATUS+0, 2 
	GOTO        L_measure_sensors214
;Wifi_module.c,1199 :: 		(ADC_channel[index].ADC_dur >= ADC_channel[index].ADC_dur_buffer) &&  // increase ADC_channel[i].buffer by second
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       R4 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVLW       20
	ADDWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R4, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__measure_sensors486
	MOVF        R1, 0 
	SUBWF       R3, 0 
L__measure_sensors486:
	BTFSS       STATUS+0, 0 
	GOTO        L_measure_sensors214
;Wifi_module.c,1200 :: 		(ADC_channel[index].ADC_mil == ADC_channel[index].ADC_mil_buffer)){
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       R4 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVLW       22
	ADDWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R2 
	MOVF        R4, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__measure_sensors487
	MOVF        R1, 0 
	XORWF       R3, 0 
L__measure_sensors487:
	BTFSS       STATUS+0, 2 
	GOTO        L_measure_sensors214
L__measure_sensors364:
;Wifi_module.c,1203 :: 		ADC_channel[index].ADC_value = doMeasurement( index, 1);
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       R4 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       6
	ADDWF       R0, 0 
	MOVWF       FLOC__measure_sensors+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__measure_sensors+1 
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       FARG_doMeasurement_position+0 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       FARG_doMeasurement_position+1 
	MOVLW       1
	MOVWF       FARG_doMeasurement_flag+0 
	MOVLW       0
	MOVWF       FARG_doMeasurement_flag+1 
	CALL        _doMeasurement+0, 0
	MOVFF       FLOC__measure_sensors+0, FSR1
	MOVFF       FLOC__measure_sensors+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,1206 :: 		ADC_channel[index].ADC_mil_buffer = 0;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       R4 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       22
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,1209 :: 		if (ADC_channel[index].ADC_dur == ADC_channel[index].ADC_dur_buffer ){
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       R4 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVLW       20
	ADDWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R2 
	MOVF        R4, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__measure_sensors488
	MOVF        R1, 0 
	XORWF       R3, 0 
L__measure_sensors488:
	BTFSS       STATUS+0, 2 
	GOTO        L_measure_sensors215
;Wifi_module.c,1210 :: 		ADC_channel[index].ADC_dur_buffer = 0;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       R4 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       20
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,1211 :: 		ADC_channel[index].ADC_sec_buffer = 0;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       R4 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,1212 :: 		}
L_measure_sensors215:
;Wifi_module.c,1215 :: 		if (System.network_status == CONNECTED && System.measure_type == UPDATING){
	MOVF        _System+185, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_measure_sensors218
	MOVF        _System+270, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_measure_sensors218
L__measure_sensors363:
;Wifi_module.c,1219 :: 		char *p = timeStampMeasurement(index);
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       FARG_timeStampMeasurement_index+0 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       FARG_timeStampMeasurement_index+1 
	CALL        _timeStampMeasurement+0, 0
	MOVF        R0, 0 
	MOVWF       measure_sensors_p_L4+0 
	MOVF        R1, 0 
	MOVWF       measure_sensors_p_L4+1 
;Wifi_module.c,1220 :: 		cipsend(System.size);
	MOVF        _System+263, 0 
	MOVWF       FARG_cipsend_size+0 
	MOVLW       0
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,1221 :: 		UART1_Write_Text(p);
	MOVF        measure_sensors_p_L4+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        measure_sensors_p_L4+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1222 :: 		waitForInput("OK",3);
	MOVLW       ?lstr102_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr102_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       3
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,1224 :: 		}
L_measure_sensors218:
;Wifi_module.c,1227 :: 		if (System.measure_type == BUFFERED){
	MOVF        _System+270, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_measure_sensors219
;Wifi_module.c,1229 :: 		if (System.isMicroSDConnected){
	MOVF        _System+192, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_measure_sensors220
;Wifi_module.c,1230 :: 		char *toWrite = timeStampMeasurement(index);
	MOVF        measure_sensors_index_L1+0, 0 
	MOVWF       FARG_timeStampMeasurement_index+0 
	MOVF        measure_sensors_index_L1+1, 0 
	MOVWF       FARG_timeStampMeasurement_index+1 
	CALL        _timeStampMeasurement+0, 0
;Wifi_module.c,1231 :: 		M_Open_File_Append(toWrite);
	MOVF        R0, 0 
	MOVWF       FARG_M_Open_File_Append_toWrite+0 
	MOVF        R1, 0 
	MOVWF       FARG_M_Open_File_Append_toWrite+1 
	CALL        _M_Open_File_Append+0, 0
;Wifi_module.c,1232 :: 		}
L_measure_sensors220:
;Wifi_module.c,1233 :: 		}
L_measure_sensors219:
;Wifi_module.c,1234 :: 		}
L_measure_sensors214:
;Wifi_module.c,1192 :: 		for (index = 0; index < CHANNEL_COUNT; index++){
	INFSNZ      measure_sensors_index_L1+0, 1 
	INCF        measure_sensors_index_L1+1, 1 
;Wifi_module.c,1236 :: 		}
	GOTO        L_measure_sensors207
L_measure_sensors208:
;Wifi_module.c,1237 :: 		}
L_measure_sensors206:
;Wifi_module.c,1238 :: 		}
L_end_measure_sensors:
	RETURN      0
; end of _measure_sensors

_InitTimer0:

;Wifi_module.c,1244 :: 		void InitTimer0(){
;Wifi_module.c,1245 :: 		T0CON         = 0x88;
	MOVLW       136
	MOVWF       T0CON+0 
;Wifi_module.c,1246 :: 		TMR0H         = 0xF6;
	MOVLW       246
	MOVWF       TMR0H+0 
;Wifi_module.c,1247 :: 		TMR0L         = 0x3C;
	MOVLW       60
	MOVWF       TMR0L+0 
;Wifi_module.c,1248 :: 		GIE_bit         = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Wifi_module.c,1249 :: 		TMR0IE_bit         = 1;
	BSF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;Wifi_module.c,1250 :: 		}
L_end_InitTimer0:
	RETURN      0
; end of _InitTimer0

_wifiSerialInterrupt:

;Wifi_module.c,1252 :: 		void wifiSerialInterrupt(){
;Wifi_module.c,1254 :: 		if (PIR1.RCIF ) {          // test the interrupt for uart rx
	BTFSS       PIR1+0, 5 
	GOTO        L_wifiSerialInterrupt221
;Wifi_module.c,1257 :: 		if (System.index >= sizeof(System.readLine)-3){
	MOVLW       128
	XORWF       _System+173, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__wifiSerialInterrupt491
	MOVLW       147
	SUBWF       _System+172, 0 
L__wifiSerialInterrupt491:
	BTFSS       STATUS+0, 0 
	GOTO        L_wifiSerialInterrupt222
;Wifi_module.c,1259 :: 		System.index = 0;
	CLRF        _System+172 
	CLRF        _System+173 
;Wifi_module.c,1260 :: 		}
L_wifiSerialInterrupt222:
;Wifi_module.c,1262 :: 		System.readLine[System.index] = UART1_Read();
	MOVLW       _System+12
	ADDWF       _System+172, 0 
	MOVWF       FLOC__wifiSerialInterrupt+0 
	MOVLW       hi_addr(_System+12)
	ADDWFC      _System+173, 0 
	MOVWF       FLOC__wifiSerialInterrupt+1 
	CALL        _UART1_Read+0, 0
	MOVFF       FLOC__wifiSerialInterrupt+0, FSR1
	MOVFF       FLOC__wifiSerialInterrupt+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,1264 :: 		if (System.readLine[System.index] == '\n' ||
	MOVLW       _System+12
	ADDWF       _System+172, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_System+12)
	ADDWFC      _System+173, 0 
	MOVWF       FSR0H 
;Wifi_module.c,1265 :: 		System.readLine[System.index] == '\0' ||
	MOVF        POSTINC0+0, 0 
	XORLW       10
	BTFSC       STATUS+0, 2 
	GOTO        L__wifiSerialInterrupt367
	MOVLW       _System+12
	ADDWF       _System+172, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_System+12)
	ADDWFC      _System+173, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__wifiSerialInterrupt367
;Wifi_module.c,1266 :: 		System.readLine[System.index] == '\r' ) {
	MOVLW       _System+12
	ADDWF       _System+172, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_System+12)
	ADDWFC      _System+173, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       13
	BTFSC       STATUS+0, 2 
	GOTO        L__wifiSerialInterrupt367
	GOTO        L_wifiSerialInterrupt225
L__wifiSerialInterrupt367:
;Wifi_module.c,1268 :: 		System.isInputReady = TRUE;
	MOVLW       1
	MOVWF       _System+177 
;Wifi_module.c,1269 :: 		System.readLine[System.index+1] = '\0';
	MOVLW       1
	ADDWF       _System+172, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _System+173, 0 
	MOVWF       R1 
	MOVLW       _System+12
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_System+12)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Wifi_module.c,1270 :: 		}
L_wifiSerialInterrupt225:
;Wifi_module.c,1272 :: 		System.index++;
	MOVLW       1
	ADDWF       _System+172, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _System+173, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _System+172 
	MOVF        R1, 0 
	MOVWF       _System+173 
;Wifi_module.c,1275 :: 		} else if (PIR2.RCIF){
	GOTO        L_wifiSerialInterrupt226
L_wifiSerialInterrupt221:
	BTFSS       PIR2+0, 5 
	GOTO        L_wifiSerialInterrupt227
;Wifi_module.c,1277 :: 		if (System.index_2 >= sizeof(System.uart2_buffer)-3){
	MOVLW       128
	XORWF       _System+175, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__wifiSerialInterrupt492
	MOVLW       7
	SUBWF       _System+174, 0 
L__wifiSerialInterrupt492:
	BTFSS       STATUS+0, 0 
	GOTO        L_wifiSerialInterrupt228
;Wifi_module.c,1279 :: 		System.index_2 = 0;
	CLRF        _System+174 
	CLRF        _System+175 
;Wifi_module.c,1280 :: 		}
L_wifiSerialInterrupt228:
;Wifi_module.c,1282 :: 		System.uart2_buffer[System.index_2] = UART1_Read();
	MOVLW       _System+162
	ADDWF       _System+174, 0 
	MOVWF       FLOC__wifiSerialInterrupt+0 
	MOVLW       hi_addr(_System+162)
	ADDWFC      _System+175, 0 
	MOVWF       FLOC__wifiSerialInterrupt+1 
	CALL        _UART1_Read+0, 0
	MOVFF       FLOC__wifiSerialInterrupt+0, FSR1
	MOVFF       FLOC__wifiSerialInterrupt+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,1284 :: 		if (System.uart2_buffer[System.index_2] == '\n' ||
	MOVLW       _System+162
	ADDWF       _System+174, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_System+162)
	ADDWFC      _System+175, 0 
	MOVWF       FSR0H 
;Wifi_module.c,1285 :: 		System.uart2_buffer[System.index_2] == '\0' ||
	MOVF        POSTINC0+0, 0 
	XORLW       10
	BTFSC       STATUS+0, 2 
	GOTO        L__wifiSerialInterrupt366
	MOVLW       _System+162
	ADDWF       _System+174, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_System+162)
	ADDWFC      _System+175, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__wifiSerialInterrupt366
;Wifi_module.c,1286 :: 		System.uart2_buffer[System.index_2] == '\r' ) {
	MOVLW       _System+162
	ADDWF       _System+174, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_System+162)
	ADDWFC      _System+175, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       13
	BTFSC       STATUS+0, 2 
	GOTO        L__wifiSerialInterrupt366
	GOTO        L_wifiSerialInterrupt231
L__wifiSerialInterrupt366:
;Wifi_module.c,1288 :: 		System.isInput_2_Ready = TRUE;
	MOVLW       1
	MOVWF       _System+178 
;Wifi_module.c,1289 :: 		System.uart2_buffer[System.index_2+1] = '\0';
	MOVLW       1
	ADDWF       _System+174, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _System+175, 0 
	MOVWF       R1 
	MOVLW       _System+162
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_System+162)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Wifi_module.c,1290 :: 		}
L_wifiSerialInterrupt231:
;Wifi_module.c,1292 :: 		System.index_2++;
	MOVLW       1
	ADDWF       _System+174, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _System+175, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _System+174 
	MOVF        R1, 0 
	MOVWF       _System+175 
;Wifi_module.c,1293 :: 		}
L_wifiSerialInterrupt227:
L_wifiSerialInterrupt226:
;Wifi_module.c,1294 :: 		}
L_end_wifiSerialInterrupt:
	RETURN      0
; end of _wifiSerialInterrupt

_sensor_Clock:

;Wifi_module.c,1296 :: 		void sensor_Clock(){
;Wifi_module.c,1298 :: 		SystemTime.mils_2++;
	MOVLW       1
	ADDWF       _SystemTime+16, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _SystemTime+17, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _SystemTime+16 
	MOVF        R1, 0 
	MOVWF       _SystemTime+17 
;Wifi_module.c,1303 :: 		for (i = 0; i < CHANNEL_COUNT; i++){
	CLRF        sensor_Clock_i_L0+0 
L_sensor_Clock232:
	MOVLW       128
	XORWF       sensor_Clock_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       8
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_sensor_Clock233
;Wifi_module.c,1305 :: 		if (ADC_channel[i].ADC_isPortConnected == TRUE){
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        sensor_Clock_i_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       sensor_Clock_i_L0+0, 7 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       12
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__sensor_Clock494
	MOVLW       1
	XORWF       R1, 0 
L__sensor_Clock494:
	BTFSS       STATUS+0, 2 
	GOTO        L_sensor_Clock235
;Wifi_module.c,1307 :: 		if (ADC_channel[i].ADC_mil_buffer < ADC_channel[i].ADC_mil){
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        sensor_Clock_i_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       sensor_Clock_i_L0+0, 7 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       22
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R4, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__sensor_Clock495
	MOVF        R1, 0 
	SUBWF       R3, 0 
L__sensor_Clock495:
	BTFSC       STATUS+0, 0 
	GOTO        L_sensor_Clock236
;Wifi_module.c,1308 :: 		ADC_channel[i].ADC_mil_buffer++;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        sensor_Clock_i_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       sensor_Clock_i_L0+0, 7 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       22
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	INFSNZ      R0, 1 
	INCF        R1, 1 
	MOVFF       R2, FSR1
	MOVFF       R3, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,1309 :: 		}
L_sensor_Clock236:
;Wifi_module.c,1311 :: 		if (SystemTime.mils_2 == 1000){
	MOVF        _SystemTime+17, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__sensor_Clock496
	MOVLW       232
	XORWF       _SystemTime+16, 0 
L__sensor_Clock496:
	BTFSS       STATUS+0, 2 
	GOTO        L_sensor_Clock237
;Wifi_module.c,1312 :: 		if (ADC_channel[i].ADC_dur_buffer < ADC_channel[i].ADC_dur){
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        sensor_Clock_i_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       sensor_Clock_i_L0+0, 7 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       20
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVLW       2
	ADDWF       R0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R4, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__sensor_Clock497
	MOVF        R1, 0 
	SUBWF       R3, 0 
L__sensor_Clock497:
	BTFSC       STATUS+0, 0 
	GOTO        L_sensor_Clock238
;Wifi_module.c,1313 :: 		ADC_channel[i].ADC_dur_buffer++;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        sensor_Clock_i_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       sensor_Clock_i_L0+0, 7 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       20
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	INFSNZ      R0, 1 
	INCF        R1, 1 
	MOVFF       R2, FSR1
	MOVFF       R3, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,1314 :: 		}
L_sensor_Clock238:
;Wifi_module.c,1315 :: 		if (ADC_channel[i].ADC_sec_buffer < ADC_channel[i].ADC_sec){    // this is at wrong place
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        sensor_Clock_i_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       sensor_Clock_i_L0+0, 7 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       128
	XORWF       R5, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__sensor_Clock498
	MOVF        R2, 0 
	SUBWF       R4, 0 
L__sensor_Clock498:
	BTFSC       STATUS+0, 0 
	GOTO        L_sensor_Clock239
;Wifi_module.c,1316 :: 		ADC_channel[i].ADC_sec_buffer++;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        sensor_Clock_i_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       sensor_Clock_i_L0+0, 7 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	INFSNZ      R0, 1 
	INCF        R1, 1 
	MOVFF       R2, FSR1
	MOVFF       R3, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,1318 :: 		if (ADC_channel[i].ADC_sec_buffer == ADC_channel[i].ADC_sec){
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        sensor_Clock_i_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       sensor_Clock_i_L0+0, 7 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        R5, 0 
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__sensor_Clock499
	MOVF        R2, 0 
	XORWF       R4, 0 
L__sensor_Clock499:
	BTFSS       STATUS+0, 2 
	GOTO        L_sensor_Clock240
;Wifi_module.c,1319 :: 		ADC_channel[i].ADC_dur_buffer = 0;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        sensor_Clock_i_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       sensor_Clock_i_L0+0, 7 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       20
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,1320 :: 		ADC_channel[i].ADC_mil_buffer = 0;
	MOVLW       24
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        sensor_Clock_i_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	BTFSC       sensor_Clock_i_L0+0, 7 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _ADC_channel+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_ADC_channel+0)
	ADDWFC      R1, 1 
	MOVLW       22
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,1321 :: 		}
L_sensor_Clock240:
;Wifi_module.c,1322 :: 		}
L_sensor_Clock239:
;Wifi_module.c,1324 :: 		}
L_sensor_Clock237:
;Wifi_module.c,1325 :: 		if (SystemTime.sec_2 == 60) {
	MOVLW       0
	XORWF       _SystemTime+19, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__sensor_Clock500
	MOVLW       60
	XORWF       _SystemTime+18, 0 
L__sensor_Clock500:
	BTFSS       STATUS+0, 2 
	GOTO        L_sensor_Clock241
;Wifi_module.c,1338 :: 		}
L_sensor_Clock241:
;Wifi_module.c,1339 :: 		}
L_sensor_Clock235:
;Wifi_module.c,1303 :: 		for (i = 0; i < CHANNEL_COUNT; i++){
	INCF        sensor_Clock_i_L0+0, 1 
;Wifi_module.c,1340 :: 		}
	GOTO        L_sensor_Clock232
L_sensor_Clock233:
;Wifi_module.c,1342 :: 		if (SystemTime.sec_2 == 60){
	MOVLW       0
	XORWF       _SystemTime+19, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__sensor_Clock501
	MOVLW       60
	XORWF       _SystemTime+18, 0 
L__sensor_Clock501:
	BTFSS       STATUS+0, 2 
	GOTO        L_sensor_Clock242
;Wifi_module.c,1343 :: 		SystemTime.sec_2 = 0;
	CLRF        _SystemTime+18 
	CLRF        _SystemTime+19 
;Wifi_module.c,1344 :: 		}
L_sensor_Clock242:
;Wifi_module.c,1345 :: 		if (SystemTime.mils_2 == 1000){
	MOVF        _SystemTime+17, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__sensor_Clock502
	MOVLW       232
	XORWF       _SystemTime+16, 0 
L__sensor_Clock502:
	BTFSS       STATUS+0, 2 
	GOTO        L_sensor_Clock243
;Wifi_module.c,1346 :: 		SystemTime.mils_2 = 0;
	CLRF        _SystemTime+16 
	CLRF        _SystemTime+17 
;Wifi_module.c,1347 :: 		SystemTime.sec_2++;
	MOVLW       1
	ADDWF       _SystemTime+18, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _SystemTime+19, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _SystemTime+18 
	MOVF        R1, 0 
	MOVWF       _SystemTime+19 
;Wifi_module.c,1348 :: 		}
L_sensor_Clock243:
;Wifi_module.c,1351 :: 		}
L_end_sensor_Clock:
	RETURN      0
; end of _sensor_Clock

_systemClock:

;Wifi_module.c,1353 :: 		void systemClock(){
;Wifi_module.c,1355 :: 		SystemTime.mils++;
	MOVLW       1
	ADDWF       _SystemTime+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _SystemTime+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _SystemTime+0 
	MOVF        R1, 0 
	MOVWF       _SystemTime+1 
;Wifi_module.c,1359 :: 		if (SystemTime.mils == 1000){
	MOVF        _SystemTime+1, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__systemClock504
	MOVLW       232
	XORWF       _SystemTime+0, 0 
L__systemClock504:
	BTFSS       STATUS+0, 2 
	GOTO        L_systemClock244
;Wifi_module.c,1360 :: 		SystemTime.sec++;
	MOVLW       1
	ADDWF       _SystemTime+2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _SystemTime+3, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _SystemTime+2 
	MOVF        R1, 0 
	MOVWF       _SystemTime+3 
;Wifi_module.c,1361 :: 		SystemTime.mils = 0;
	CLRF        _SystemTime+0 
	CLRF        _SystemTime+1 
;Wifi_module.c,1362 :: 		if (System.connection_timer_buffer <= System.connection_timer){
	MOVLW       128
	XORWF       _System+265, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _System+267, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__systemClock505
	MOVF        _System+266, 0 
	SUBWF       _System+264, 0 
L__systemClock505:
	BTFSS       STATUS+0, 0 
	GOTO        L_systemClock245
;Wifi_module.c,1363 :: 		System.connection_timer_buffer++;
	MOVLW       1
	ADDWF       _System+266, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _System+267, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _System+266 
	MOVF        R1, 0 
	MOVWF       _System+267 
;Wifi_module.c,1364 :: 		}
L_systemClock245:
;Wifi_module.c,1365 :: 		}
L_systemClock244:
;Wifi_module.c,1366 :: 		if (SystemTime.sec == 60){
	MOVLW       0
	XORWF       _SystemTime+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__systemClock506
	MOVLW       60
	XORWF       _SystemTime+2, 0 
L__systemClock506:
	BTFSS       STATUS+0, 2 
	GOTO        L_systemClock246
;Wifi_module.c,1367 :: 		SystemTime.min++;
	MOVLW       1
	ADDWF       _SystemTime+4, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _SystemTime+5, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _SystemTime+4 
	MOVF        R1, 0 
	MOVWF       _SystemTime+5 
;Wifi_module.c,1368 :: 		SystemTime.sec = 0;
	CLRF        _SystemTime+2 
	CLRF        _SystemTime+3 
;Wifi_module.c,1369 :: 		System.sec_flag = 0;
	CLRF        _System+188 
	CLRF        _System+189 
;Wifi_module.c,1370 :: 		}
L_systemClock246:
;Wifi_module.c,1371 :: 		if (SystemTime.min == 60){
	MOVLW       0
	XORWF       _SystemTime+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__systemClock507
	MOVLW       60
	XORWF       _SystemTime+4, 0 
L__systemClock507:
	BTFSS       STATUS+0, 2 
	GOTO        L_systemClock247
;Wifi_module.c,1372 :: 		SystemTime.hour++;
	MOVLW       1
	ADDWF       _SystemTime+6, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _SystemTime+7, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _SystemTime+6 
	MOVF        R1, 0 
	MOVWF       _SystemTime+7 
;Wifi_module.c,1373 :: 		SystemTime.min = 0;
	CLRF        _SystemTime+4 
	CLRF        _SystemTime+5 
;Wifi_module.c,1374 :: 		System.min_flag = 0;
	CLRF        _System+190 
	CLRF        _System+191 
;Wifi_module.c,1375 :: 		}
L_systemClock247:
;Wifi_module.c,1376 :: 		if (SystemTime.hour == 24){
	MOVLW       0
	XORWF       _SystemTime+7, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__systemClock508
	MOVLW       24
	XORWF       _SystemTime+6, 0 
L__systemClock508:
	BTFSS       STATUS+0, 2 
	GOTO        L_systemClock248
;Wifi_module.c,1377 :: 		SystemTime.day++;
	MOVLW       1
	ADDWF       _SystemTime+8, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _SystemTime+9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _SystemTime+8 
	MOVF        R1, 0 
	MOVWF       _SystemTime+9 
;Wifi_module.c,1378 :: 		SystemTime.hour = 0;
	CLRF        _SystemTime+6 
	CLRF        _SystemTime+7 
;Wifi_module.c,1379 :: 		}
L_systemClock248:
;Wifi_module.c,1380 :: 		if (SystemTime.day == DAYS_OF_MONTH[SystemTime.month]){
	MOVF        _SystemTime+10, 0 
	MOVWF       R0 
	MOVF        _SystemTime+11, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       _SystemTime+11, 7 
	MOVLW       255
	MOVWF       R2 
	MOVWF       R3 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R2, 1 
	RLCF        R3, 1 
	MOVLW       _DAYS_OF_MONTH+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_DAYS_OF_MONTH+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_DAYS_OF_MONTH+0)
	ADDWFC      R2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	TBLRD*+
	MOVFF       TABLAT+0, R2
	MOVF        _SystemTime+9, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__systemClock509
	MOVF        R1, 0 
	XORWF       _SystemTime+8, 0 
L__systemClock509:
	BTFSS       STATUS+0, 2 
	GOTO        L_systemClock249
;Wifi_module.c,1381 :: 		SystemTime.month++;
	MOVLW       1
	ADDWF       _SystemTime+10, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _SystemTime+11, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _SystemTime+10 
	MOVF        R1, 0 
	MOVWF       _SystemTime+11 
;Wifi_module.c,1382 :: 		SystemTime.day = 0;
	CLRF        _SystemTime+8 
	CLRF        _SystemTime+9 
;Wifi_module.c,1383 :: 		}
L_systemClock249:
;Wifi_module.c,1384 :: 		if (SystemTime.month == 12){
	MOVLW       0
	XORWF       _SystemTime+11, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__systemClock510
	MOVLW       12
	XORWF       _SystemTime+10, 0 
L__systemClock510:
	BTFSS       STATUS+0, 2 
	GOTO        L_systemClock250
;Wifi_module.c,1385 :: 		SystemTime.year++;
	MOVLW       1
	ADDWF       _SystemTime+12, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _SystemTime+13, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _SystemTime+12 
	MOVF        R1, 0 
	MOVWF       _SystemTime+13 
;Wifi_module.c,1386 :: 		SystemTime.month = 0;
	CLRF        _SystemTime+10 
	CLRF        _SystemTime+11 
;Wifi_module.c,1387 :: 		}
L_systemClock250:
;Wifi_module.c,1389 :: 		}
L_end_systemClock:
	RETURN      0
; end of _systemClock

_Interrupt:

;Wifi_module.c,1391 :: 		void Interrupt(){
;Wifi_module.c,1394 :: 		wifiSerialInterrupt();
	CALL        _wifiSerialInterrupt+0, 0
;Wifi_module.c,1397 :: 		if (TMR0IF_bit){
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_Interrupt251
;Wifi_module.c,1398 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;Wifi_module.c,1399 :: 		TMR0H         = 0xF6;
	MOVLW       246
	MOVWF       TMR0H+0 
;Wifi_module.c,1400 :: 		TMR0L         = 0x3C;
	MOVLW       60
	MOVWF       TMR0L+0 
;Wifi_module.c,1402 :: 		systemClock();
	CALL        _systemClock+0, 0
;Wifi_module.c,1403 :: 		sensor_Clock();
	CALL        _sensor_Clock+0, 0
;Wifi_module.c,1405 :: 		}
L_Interrupt251:
;Wifi_module.c,1406 :: 		}
L_end_Interrupt:
L__Interrupt512:
	RETFIE      1
; end of _Interrupt

_relay_status:

;Wifi_module.c,1409 :: 		void relay_status(int rel, int relay_state, int position, double measured_value){
;Wifi_module.c,1413 :: 		getTimeStamp();
	CALL        _getTimeStamp+0, 0
;Wifi_module.c,1415 :: 		strcat(System.load_buffer,";REL_");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr103_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr103_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1416 :: 		itoa(position,buffer);
	MOVF        FARG_relay_status_position+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        FARG_relay_status_position+1, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       relay_status_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(relay_status_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
;Wifi_module.c,1417 :: 		strcat(System.load_buffer,buffer);
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       relay_status_buffer_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(relay_status_buffer_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1418 :: 		strcat(System.load_buffer,";");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr104_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr104_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1419 :: 		if (relay_state == 1){
	MOVLW       0
	XORWF       FARG_relay_status_relay_state+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__relay_status514
	MOVLW       1
	XORWF       FARG_relay_status_relay_state+0, 0 
L__relay_status514:
	BTFSS       STATUS+0, 2 
	GOTO        L_relay_status252
;Wifi_module.c,1420 :: 		strcat(System.load_buffer,"ON;");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr105_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr105_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1421 :: 		} else {
	GOTO        L_relay_status253
L_relay_status252:
;Wifi_module.c,1422 :: 		strcat(System.load_buffer,"OFF;");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr106_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr106_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1423 :: 		}
L_relay_status253:
;Wifi_module.c,1424 :: 		itoa(rel,buffer);
	MOVF        FARG_relay_status_rel+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        FARG_relay_status_rel+1, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       relay_status_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(relay_status_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
;Wifi_module.c,1425 :: 		strcat(System.load_buffer,buffer);
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       relay_status_buffer_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(relay_status_buffer_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1426 :: 		strcat(System.load_buffer,";");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr107_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr107_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1428 :: 		itoa(RELAY[position].R_val,buffer);
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_relay_status_position+0, 0 
	MOVWF       R4 
	MOVF        FARG_relay_status_position+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       relay_status_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(relay_status_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
;Wifi_module.c,1429 :: 		strcat(System.load_buffer,buffer);
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       relay_status_buffer_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(relay_status_buffer_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1430 :: 		strcat(System.load_buffer,";");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr108_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr108_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1432 :: 		sprintf(buffer,"%4f",measured_value);
	MOVLW       relay_status_buffer_L0+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(relay_status_buffer_L0+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_109_Wifi_module+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_109_Wifi_module+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_109_Wifi_module+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        FARG_relay_status_measured_value+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        FARG_relay_status_measured_value+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        FARG_relay_status_measured_value+2, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        FARG_relay_status_measured_value+3, 0 
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;Wifi_module.c,1433 :: 		strcat(System.load_buffer,buffer);
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       relay_status_buffer_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(relay_status_buffer_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1434 :: 		strcat(System.load_buffer,";\n");
	MOVLW       _System+193
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr110_Wifi_module+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr110_Wifi_module+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;Wifi_module.c,1436 :: 		if (System.network_status == CONNECTED){
	MOVF        _System+185, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_relay_status254
;Wifi_module.c,1438 :: 		cipsend(strlen(System.load_buffer));
	MOVLW       _System+193
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_cipsend_size+0 
	MOVF        R1, 0 
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,1440 :: 		UART1_Write_Text(System.load_buffer);
	MOVLW       _System+193
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1442 :: 		waitForInput("SEND OK",3);
	MOVLW       ?lstr111_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr111_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       3
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,1443 :: 		} else {
	GOTO        L_relay_status255
L_relay_status254:
;Wifi_module.c,1444 :: 		if (System.isMicroSDConnected){
	MOVF        _System+192, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_relay_status256
;Wifi_module.c,1446 :: 		}
L_relay_status256:
;Wifi_module.c,1447 :: 		}
L_relay_status255:
;Wifi_module.c,1449 :: 		}
L_end_relay_status:
	RETURN      0
; end of _relay_status

_switchRelay:

;Wifi_module.c,1452 :: 		void switchRelay(int position, int status, double measured_value){
;Wifi_module.c,1455 :: 		int relay_state = RELAY[position].R_state;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_switchRelay_position+0, 0 
	MOVWF       R4 
	MOVF        FARG_switchRelay_position+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVLW       10
	ADDWF       R2, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       switchRelay_relay_state_L0+0 
	MOVF        R1, 0 
	MOVWF       switchRelay_relay_state_L0+1 
;Wifi_module.c,1456 :: 		int relay_number = RELAY[position].R_relay;
	MOVLW       6
	ADDWF       R2, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       switchRelay_relay_number_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       switchRelay_relay_number_L0+1 
;Wifi_module.c,1458 :: 		itoa(relay_state,buffer);
	MOVF        R0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        R1, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       switchRelay_buffer_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(switchRelay_buffer_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
;Wifi_module.c,1460 :: 		if (status == 1){
	MOVLW       0
	XORWF       FARG_switchRelay_status+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay516
	MOVLW       1
	XORWF       FARG_switchRelay_status+0, 0 
L__switchRelay516:
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay257
;Wifi_module.c,1461 :: 		switch (relay_number){
	GOTO        L_switchRelay258
;Wifi_module.c,1463 :: 		case 1:
L_switchRelay260:
;Wifi_module.c,1464 :: 		if (relay_state == 1){
	MOVLW       0
	XORWF       switchRelay_relay_state_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay517
	MOVLW       1
	XORWF       switchRelay_relay_state_L0+0, 0 
L__switchRelay517:
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay261
;Wifi_module.c,1465 :: 		System.PORTD_state = System.PORTD_state | 0b00000001;
	MOVLW       1
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1466 :: 		} else {
	GOTO        L_switchRelay262
L_switchRelay261:
;Wifi_module.c,1467 :: 		System.PORTD_state = System.PORTD_state & 0b00111110;
	MOVLW       62
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1468 :: 		}
L_switchRelay262:
;Wifi_module.c,1469 :: 		break;
	GOTO        L_switchRelay259
;Wifi_module.c,1470 :: 		case 2:
L_switchRelay263:
;Wifi_module.c,1471 :: 		if (relay_state == 1){
	MOVLW       0
	XORWF       switchRelay_relay_state_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay518
	MOVLW       1
	XORWF       switchRelay_relay_state_L0+0, 0 
L__switchRelay518:
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay264
;Wifi_module.c,1472 :: 		System.PORTD_state = System.PORTD_state | 0b00000010;
	MOVLW       2
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1473 :: 		} else {
	GOTO        L_switchRelay265
L_switchRelay264:
;Wifi_module.c,1474 :: 		System.PORTD_state = System.PORTD_state & 0b00111101;
	MOVLW       61
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1475 :: 		}
L_switchRelay265:
;Wifi_module.c,1476 :: 		break;
	GOTO        L_switchRelay259
;Wifi_module.c,1477 :: 		case 3:
L_switchRelay266:
;Wifi_module.c,1478 :: 		if (relay_state == 1){
	MOVLW       0
	XORWF       switchRelay_relay_state_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay519
	MOVLW       1
	XORWF       switchRelay_relay_state_L0+0, 0 
L__switchRelay519:
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay267
;Wifi_module.c,1479 :: 		System.PORTD_state = System.PORTD_state | 0b00000100;
	MOVLW       4
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1480 :: 		} else {
	GOTO        L_switchRelay268
L_switchRelay267:
;Wifi_module.c,1481 :: 		System.PORTD_state = System.PORTD_state & 0b00111011;
	MOVLW       59
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1482 :: 		}
L_switchRelay268:
;Wifi_module.c,1483 :: 		break;
	GOTO        L_switchRelay259
;Wifi_module.c,1484 :: 		case 4:
L_switchRelay269:
;Wifi_module.c,1485 :: 		if (relay_state == 1){
	MOVLW       0
	XORWF       switchRelay_relay_state_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay520
	MOVLW       1
	XORWF       switchRelay_relay_state_L0+0, 0 
L__switchRelay520:
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay270
;Wifi_module.c,1486 :: 		System.PORTD_state = System.PORTD_state | 0b00001000;
	MOVLW       8
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1487 :: 		} else {
	GOTO        L_switchRelay271
L_switchRelay270:
;Wifi_module.c,1488 :: 		System.PORTD_state = System.PORTD_state & 0b00110111;
	MOVLW       55
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1489 :: 		}
L_switchRelay271:
;Wifi_module.c,1490 :: 		break;
	GOTO        L_switchRelay259
;Wifi_module.c,1491 :: 		case 5:
L_switchRelay272:
;Wifi_module.c,1492 :: 		if (relay_state == 1){
	MOVLW       0
	XORWF       switchRelay_relay_state_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay521
	MOVLW       1
	XORWF       switchRelay_relay_state_L0+0, 0 
L__switchRelay521:
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay273
;Wifi_module.c,1493 :: 		System.PORTD_state = System.PORTD_state | 0b00010000;
	MOVLW       16
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1494 :: 		} else {
	GOTO        L_switchRelay274
L_switchRelay273:
;Wifi_module.c,1495 :: 		System.PORTD_state = System.PORTD_state & 0b00101111;
	MOVLW       47
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1496 :: 		}
L_switchRelay274:
;Wifi_module.c,1497 :: 		break;
	GOTO        L_switchRelay259
;Wifi_module.c,1498 :: 		case 6:
L_switchRelay275:
;Wifi_module.c,1499 :: 		if (relay_state == 1){
	MOVLW       0
	XORWF       switchRelay_relay_state_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay522
	MOVLW       1
	XORWF       switchRelay_relay_state_L0+0, 0 
L__switchRelay522:
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay276
;Wifi_module.c,1500 :: 		System.PORTD_state = System.PORTD_state | 0b00100000;
	MOVLW       32
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1501 :: 		} else {
	GOTO        L_switchRelay277
L_switchRelay276:
;Wifi_module.c,1502 :: 		System.PORTD_state = System.PORTD_state & 0b00011111;
	MOVLW       31
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1503 :: 		}
L_switchRelay277:
;Wifi_module.c,1504 :: 		break;
	GOTO        L_switchRelay259
;Wifi_module.c,1505 :: 		}
L_switchRelay258:
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay523
	MOVLW       1
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay523:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay260
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay524
	MOVLW       2
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay524:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay263
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay525
	MOVLW       3
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay525:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay266
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay526
	MOVLW       4
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay526:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay269
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay527
	MOVLW       5
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay527:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay272
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay528
	MOVLW       6
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay528:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay275
L_switchRelay259:
;Wifi_module.c,1506 :: 		PORTD = System.PORTD_state;
	MOVF        _System+269, 0 
	MOVWF       PORTD+0 
;Wifi_module.c,1508 :: 		if (RELAY[position].R_state_buffer != relay_state){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_switchRelay_position+0, 0 
	MOVWF       R4 
	MOVF        FARG_switchRelay_position+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	XORWF       switchRelay_relay_state_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay529
	MOVF        switchRelay_relay_state_L0+0, 0 
	XORWF       R1, 0 
L__switchRelay529:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay278
;Wifi_module.c,1509 :: 		relay_status(relay_number, relay_state, position, measured_value);
	MOVF        switchRelay_relay_number_L0+0, 0 
	MOVWF       FARG_relay_status_rel+0 
	MOVF        switchRelay_relay_number_L0+1, 0 
	MOVWF       FARG_relay_status_rel+1 
	MOVF        switchRelay_relay_state_L0+0, 0 
	MOVWF       FARG_relay_status_relay_state+0 
	MOVF        switchRelay_relay_state_L0+1, 0 
	MOVWF       FARG_relay_status_relay_state+1 
	MOVF        FARG_switchRelay_position+0, 0 
	MOVWF       FARG_relay_status_position+0 
	MOVF        FARG_switchRelay_position+1, 0 
	MOVWF       FARG_relay_status_position+1 
	MOVF        FARG_switchRelay_measured_value+0, 0 
	MOVWF       FARG_relay_status_measured_value+0 
	MOVF        FARG_switchRelay_measured_value+1, 0 
	MOVWF       FARG_relay_status_measured_value+1 
	MOVF        FARG_switchRelay_measured_value+2, 0 
	MOVWF       FARG_relay_status_measured_value+2 
	MOVF        FARG_switchRelay_measured_value+3, 0 
	MOVWF       FARG_relay_status_measured_value+3 
	CALL        _relay_status+0, 0
;Wifi_module.c,1510 :: 		RELAY[position].R_state_buffer = relay_state;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_switchRelay_position+0, 0 
	MOVWF       R4 
	MOVF        FARG_switchRelay_position+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        switchRelay_relay_state_L0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        switchRelay_relay_state_L0+1, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,1521 :: 		}
L_switchRelay278:
;Wifi_module.c,1522 :: 		} else {
	GOTO        L_switchRelay279
L_switchRelay257:
;Wifi_module.c,1523 :: 		switch (relay_number){
	GOTO        L_switchRelay280
;Wifi_module.c,1524 :: 		case 1:
L_switchRelay282:
;Wifi_module.c,1525 :: 		if (!relay_state == 1){
	MOVF        switchRelay_relay_state_L0+0, 0 
	IORWF       switchRelay_relay_state_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay283
;Wifi_module.c,1526 :: 		System.PORTD_state = System.PORTD_state | 0b00000001;
	MOVLW       1
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1527 :: 		} else {
	GOTO        L_switchRelay284
L_switchRelay283:
;Wifi_module.c,1528 :: 		System.PORTD_state = System.PORTD_state & 0b00111110;
	MOVLW       62
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1529 :: 		}
L_switchRelay284:
;Wifi_module.c,1530 :: 		break;
	GOTO        L_switchRelay281
;Wifi_module.c,1531 :: 		case 2:
L_switchRelay285:
;Wifi_module.c,1532 :: 		if (!relay_state == 1){
	MOVF        switchRelay_relay_state_L0+0, 0 
	IORWF       switchRelay_relay_state_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay286
;Wifi_module.c,1533 :: 		System.PORTD_state = System.PORTD_state | 0b00000010;
	MOVLW       2
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1534 :: 		} else {
	GOTO        L_switchRelay287
L_switchRelay286:
;Wifi_module.c,1535 :: 		System.PORTD_state = System.PORTD_state & 0b00111101;
	MOVLW       61
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1536 :: 		}
L_switchRelay287:
;Wifi_module.c,1537 :: 		break;
	GOTO        L_switchRelay281
;Wifi_module.c,1538 :: 		case 3:
L_switchRelay288:
;Wifi_module.c,1539 :: 		if (!relay_state == 1){
	MOVF        switchRelay_relay_state_L0+0, 0 
	IORWF       switchRelay_relay_state_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay289
;Wifi_module.c,1540 :: 		System.PORTD_state = System.PORTD_state | 0b00000100;
	MOVLW       4
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1541 :: 		} else {
	GOTO        L_switchRelay290
L_switchRelay289:
;Wifi_module.c,1542 :: 		System.PORTD_state = System.PORTD_state & 0b00111011;
	MOVLW       59
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1543 :: 		}
L_switchRelay290:
;Wifi_module.c,1544 :: 		break;
	GOTO        L_switchRelay281
;Wifi_module.c,1545 :: 		case 4:
L_switchRelay291:
;Wifi_module.c,1546 :: 		if (!relay_state == 1){
	MOVF        switchRelay_relay_state_L0+0, 0 
	IORWF       switchRelay_relay_state_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay292
;Wifi_module.c,1547 :: 		System.PORTD_state = System.PORTD_state | 0b00001000;
	MOVLW       8
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1548 :: 		} else {
	GOTO        L_switchRelay293
L_switchRelay292:
;Wifi_module.c,1549 :: 		System.PORTD_state = System.PORTD_state & 0b00110111;
	MOVLW       55
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1550 :: 		}
L_switchRelay293:
;Wifi_module.c,1551 :: 		break;
	GOTO        L_switchRelay281
;Wifi_module.c,1552 :: 		case 5:
L_switchRelay294:
;Wifi_module.c,1553 :: 		if (!relay_state == 1){
	MOVF        switchRelay_relay_state_L0+0, 0 
	IORWF       switchRelay_relay_state_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay295
;Wifi_module.c,1554 :: 		System.PORTD_state = System.PORTD_state | 0b00010000;
	MOVLW       16
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1555 :: 		} else {
	GOTO        L_switchRelay296
L_switchRelay295:
;Wifi_module.c,1556 :: 		System.PORTD_state = System.PORTD_state & 0b00101111;
	MOVLW       47
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1557 :: 		}
L_switchRelay296:
;Wifi_module.c,1558 :: 		break;
	GOTO        L_switchRelay281
;Wifi_module.c,1559 :: 		case 6:
L_switchRelay297:
;Wifi_module.c,1560 :: 		if (!relay_state == 1){
	MOVF        switchRelay_relay_state_L0+0, 0 
	IORWF       switchRelay_relay_state_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_switchRelay298
;Wifi_module.c,1561 :: 		System.PORTD_state = System.PORTD_state | 0b00100000;
	MOVLW       32
	IORWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1562 :: 		} else {
	GOTO        L_switchRelay299
L_switchRelay298:
;Wifi_module.c,1563 :: 		System.PORTD_state = System.PORTD_state & 0b00011111;
	MOVLW       31
	ANDWF       _System+269, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+269 
;Wifi_module.c,1564 :: 		}
L_switchRelay299:
;Wifi_module.c,1565 :: 		break;
	GOTO        L_switchRelay281
;Wifi_module.c,1566 :: 		}
L_switchRelay280:
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay530
	MOVLW       1
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay530:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay282
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay531
	MOVLW       2
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay531:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay285
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay532
	MOVLW       3
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay532:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay288
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay533
	MOVLW       4
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay533:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay291
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay534
	MOVLW       5
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay534:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay294
	MOVLW       0
	XORWF       switchRelay_relay_number_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay535
	MOVLW       6
	XORWF       switchRelay_relay_number_L0+0, 0 
L__switchRelay535:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay297
L_switchRelay281:
;Wifi_module.c,1567 :: 		PORTD = System.PORTD_state;
	MOVF        _System+269, 0 
	MOVWF       PORTD+0 
;Wifi_module.c,1568 :: 		if (RELAY[position].R_state_buffer != !relay_state){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_switchRelay_position+0, 0 
	MOVWF       R4 
	MOVF        FARG_switchRelay_position+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        switchRelay_relay_state_L0+0, 0 
	IORWF       switchRelay_relay_state_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__switchRelay536
	MOVF        R1, 0 
	XORWF       R2, 0 
L__switchRelay536:
	BTFSC       STATUS+0, 2 
	GOTO        L_switchRelay300
;Wifi_module.c,1569 :: 		relay_status(relay_number, !relay_state, position, measured_value);
	MOVF        switchRelay_relay_number_L0+0, 0 
	MOVWF       FARG_relay_status_rel+0 
	MOVF        switchRelay_relay_number_L0+1, 0 
	MOVWF       FARG_relay_status_rel+1 
	MOVF        switchRelay_relay_state_L0+0, 0 
	IORWF       switchRelay_relay_state_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       FARG_relay_status_relay_state+0 
	MOVLW       0
	MOVWF       FARG_relay_status_relay_state+1 
	MOVF        FARG_switchRelay_position+0, 0 
	MOVWF       FARG_relay_status_position+0 
	MOVF        FARG_switchRelay_position+1, 0 
	MOVWF       FARG_relay_status_position+1 
	MOVF        FARG_switchRelay_measured_value+0, 0 
	MOVWF       FARG_relay_status_measured_value+0 
	MOVF        FARG_switchRelay_measured_value+1, 0 
	MOVWF       FARG_relay_status_measured_value+1 
	MOVF        FARG_switchRelay_measured_value+2, 0 
	MOVWF       FARG_relay_status_measured_value+2 
	MOVF        FARG_switchRelay_measured_value+3, 0 
	MOVWF       FARG_relay_status_measured_value+3 
	CALL        _relay_status+0, 0
;Wifi_module.c,1570 :: 		RELAY[position].R_state_buffer = !relay_state;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_switchRelay_position+0, 0 
	MOVWF       R4 
	MOVF        FARG_switchRelay_position+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       18
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        switchRelay_relay_state_L0+0, 0 
	IORWF       switchRelay_relay_state_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
;Wifi_module.c,1581 :: 		}
L_switchRelay300:
;Wifi_module.c,1582 :: 		}
L_switchRelay279:
;Wifi_module.c,1584 :: 		}
L_end_switchRelay:
	RETURN      0
; end of _switchRelay

_system_processes:

;Wifi_module.c,1587 :: 		void system_processes(){
;Wifi_module.c,1589 :: 		if (DIPSW_1 == PRESSED){
	BTFSC       PORTC+0, 2 
	GOTO        L_system_processes301
;Wifi_module.c,1590 :: 		delay_ms(1000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_system_processes302:
	DECFSZ      R13, 1, 1
	BRA         L_system_processes302
	DECFSZ      R12, 1, 1
	BRA         L_system_processes302
	DECFSZ      R11, 1, 1
	BRA         L_system_processes302
	NOP
;Wifi_module.c,1591 :: 		if (DIPSW_1 == PRESSED){
	BTFSC       PORTC+0, 2 
	GOTO        L_system_processes303
;Wifi_module.c,1592 :: 		System.wifi_status = WIFI_NOT_CONNECTED;
	MOVLW       1
	MOVWF       _System+176 
;Wifi_module.c,1593 :: 		System.network_status = IDLE;
	MOVLW       2
	MOVWF       _System+185 
;Wifi_module.c,1594 :: 		System.connection_type = !System.connection_type;
	MOVF        _System+271, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _System+271 
;Wifi_module.c,1595 :: 		System.connection_timer = 0;
	CLRF        _System+264 
	CLRF        _System+265 
;Wifi_module.c,1596 :: 		}
L_system_processes303:
;Wifi_module.c,1597 :: 		}
L_system_processes301:
;Wifi_module.c,1739 :: 		if (System.min_flag < SystemTime.min){
	MOVLW       128
	XORWF       _System+191, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _SystemTime+5, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_processes538
	MOVF        _SystemTime+4, 0 
	SUBWF       _System+190, 0 
L__system_processes538:
	BTFSC       STATUS+0, 0 
	GOTO        L_system_processes304
;Wifi_module.c,1740 :: 		System.min_flag = SystemTime.min;
	MOVF        _SystemTime+4, 0 
	MOVWF       _System+190 
	MOVF        _SystemTime+5, 0 
	MOVWF       _System+191 
;Wifi_module.c,1741 :: 		if (System.network_status == CONNECTED){
	MOVF        _System+185, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_system_processes305
;Wifi_module.c,1742 :: 		cipsend(6);
	MOVLW       6
	MOVWF       FARG_cipsend_size+0 
	MOVLW       0
	MOVWF       FARG_cipsend_size+1 
	CALL        _cipsend+0, 0
;Wifi_module.c,1743 :: 		UART1_Write_Text("CHECK\n");
	MOVLW       ?lstr112_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr112_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1744 :: 		if (waitForInput("LIVE",10) == 0){
	MOVLW       ?lstr113_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr113_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       10
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_processes539
	MOVLW       0
	XORWF       R0, 0 
L__system_processes539:
	BTFSS       STATUS+0, 2 
	GOTO        L_system_processes306
;Wifi_module.c,1745 :: 		System.network_status = IDLE;
	MOVLW       2
	MOVWF       _System+185 
;Wifi_module.c,1746 :: 		System.wifi_status = WIFI_NOT_CONNECTED;
	MOVLW       1
	MOVWF       _System+176 
;Wifi_module.c,1747 :: 		}
L_system_processes306:
;Wifi_module.c,1748 :: 		}
L_system_processes305:
;Wifi_module.c,1749 :: 		}
L_system_processes304:
;Wifi_module.c,1752 :: 		if (System.sec_flag < SystemTime.sec){
	MOVLW       128
	XORWF       _System+189, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _SystemTime+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_processes540
	MOVF        _SystemTime+2, 0 
	SUBWF       _System+188, 0 
L__system_processes540:
	BTFSC       STATUS+0, 0 
	GOTO        L_system_processes307
;Wifi_module.c,1755 :: 		System.sec_flag = SystemTime.sec;
	MOVF        _SystemTime+2, 0 
	MOVWF       _System+188 
	MOVF        _SystemTime+3, 0 
	MOVWF       _System+189 
;Wifi_module.c,1757 :: 		for (pos=0;pos<RELAY_SIZE;pos++){
	CLRF        system_processes_pos_L1+0 
	CLRF        system_processes_pos_L1+1 
L_system_processes308:
	MOVLW       128
	XORWF       system_processes_pos_L1+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_processes541
	MOVLW       6
	SUBWF       system_processes_pos_L1+0, 0 
L__system_processes541:
	BTFSC       STATUS+0, 0 
	GOTO        L_system_processes309
;Wifi_module.c,1758 :: 		if (RELAY[pos].R_enabled ){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_system_processes311
;Wifi_module.c,1759 :: 		if ( isStart(pos, 1) ){
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       FARG_isStart_position+0 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       FARG_isStart_position+1 
	MOVLW       1
	MOVWF       FARG_isStart_flag+0 
	MOVLW       0
	MOVWF       FARG_isStart_flag+1 
	CALL        _isStart+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_system_processes312
;Wifi_module.c,1761 :: 		if ( RELAY[pos].R_val == 0){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       4
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_processes542
	MOVLW       0
	XORWF       R1, 0 
L__system_processes542:
	BTFSS       STATUS+0, 2 
	GOTO        L_system_processes313
;Wifi_module.c,1762 :: 		if (RELAY[pos].R_current_state == 0){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_processes543
	MOVLW       0
	XORWF       R1, 0 
L__system_processes543:
	BTFSS       STATUS+0, 2 
	GOTO        L_system_processes314
;Wifi_module.c,1765 :: 		switchRelay(pos, 1, 0);
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       FARG_switchRelay_position+0 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       FARG_switchRelay_position+1 
	MOVLW       1
	MOVWF       FARG_switchRelay_status+0 
	MOVLW       0
	MOVWF       FARG_switchRelay_status+1 
	CLRF        FARG_switchRelay_measured_value+0 
	CLRF        FARG_switchRelay_measured_value+1 
	CLRF        FARG_switchRelay_measured_value+2 
	CLRF        FARG_switchRelay_measured_value+3 
	CALL        _switchRelay+0, 0
;Wifi_module.c,1766 :: 		RELAY[pos].R_current_state = 1;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       1
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
;Wifi_module.c,1768 :: 		}
L_system_processes314:
;Wifi_module.c,1769 :: 		} else {
	GOTO        L_system_processes315
L_system_processes313:
;Wifi_module.c,1770 :: 		double measured_value = doMeasurement(pos, 0);
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       FARG_doMeasurement_position+0 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       FARG_doMeasurement_position+1 
	CLRF        FARG_doMeasurement_flag+0 
	CLRF        FARG_doMeasurement_flag+1 
	CALL        _doMeasurement+0, 0
	MOVF        R0, 0 
	MOVWF       system_processes_measured_value_L5+0 
	MOVF        R1, 0 
	MOVWF       system_processes_measured_value_L5+1 
	MOVF        R2, 0 
	MOVWF       system_processes_measured_value_L5+2 
	MOVF        R3, 0 
	MOVWF       system_processes_measured_value_L5+3 
;Wifi_module.c,1772 :: 		if ( RELAY[pos].R_current_state == 1 ){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_processes544
	MOVLW       1
	XORWF       R1, 0 
L__system_processes544:
	BTFSS       STATUS+0, 2 
	GOTO        L_system_processes316
;Wifi_module.c,1774 :: 		if ( RELAY[pos].R_val_buffer < measured_value){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       20
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        system_processes_measured_value_L5+0, 0 
	MOVWF       R4 
	MOVF        system_processes_measured_value_L5+1, 0 
	MOVWF       R5 
	MOVF        system_processes_measured_value_L5+2, 0 
	MOVWF       R6 
	MOVF        system_processes_measured_value_L5+3, 0 
	MOVWF       R7 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_system_processes317
;Wifi_module.c,1776 :: 		RELAY[pos].R_trs_1 = RELAY[pos].R_tresh;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       24
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,1778 :: 		RELAY[pos].R_current_state = 0;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;Wifi_module.c,1779 :: 		switchRelay(pos, 1, measured_value);
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       FARG_switchRelay_position+0 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       FARG_switchRelay_position+1 
	MOVLW       1
	MOVWF       FARG_switchRelay_status+0 
	MOVLW       0
	MOVWF       FARG_switchRelay_status+1 
	MOVF        system_processes_measured_value_L5+0, 0 
	MOVWF       FARG_switchRelay_measured_value+0 
	MOVF        system_processes_measured_value_L5+1, 0 
	MOVWF       FARG_switchRelay_measured_value+1 
	MOVF        system_processes_measured_value_L5+2, 0 
	MOVWF       FARG_switchRelay_measured_value+2 
	MOVF        system_processes_measured_value_L5+3, 0 
	MOVWF       FARG_switchRelay_measured_value+3 
	CALL        _switchRelay+0, 0
;Wifi_module.c,1782 :: 		RELAY[pos].R_flag_1 = 0;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       22
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Wifi_module.c,1784 :: 		} else {
	GOTO        L_system_processes318
L_system_processes317:
;Wifi_module.c,1785 :: 		if (RELAY[pos].R_flag_1 == 0){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       22
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_system_processes319
;Wifi_module.c,1787 :: 		switchRelay(pos, 0, measured_value);
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       FARG_switchRelay_position+0 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       FARG_switchRelay_position+1 
	CLRF        FARG_switchRelay_status+0 
	CLRF        FARG_switchRelay_status+1 
	MOVF        system_processes_measured_value_L5+0, 0 
	MOVWF       FARG_switchRelay_measured_value+0 
	MOVF        system_processes_measured_value_L5+1, 0 
	MOVWF       FARG_switchRelay_measured_value+1 
	MOVF        system_processes_measured_value_L5+2, 0 
	MOVWF       FARG_switchRelay_measured_value+2 
	MOVF        system_processes_measured_value_L5+3, 0 
	MOVWF       FARG_switchRelay_measured_value+3 
	CALL        _switchRelay+0, 0
;Wifi_module.c,1789 :: 		RELAY[pos].R_flag_1 = 1;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       22
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       1
	MOVWF       POSTINC1+0 
;Wifi_module.c,1790 :: 		}
L_system_processes319:
;Wifi_module.c,1791 :: 		}
L_system_processes318:
;Wifi_module.c,1792 :: 		} else {
	GOTO        L_system_processes320
L_system_processes316:
;Wifi_module.c,1794 :: 		if ( RELAY[pos].R_val_buffer > measured_value){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       20
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        system_processes_measured_value_L5+0, 0 
	MOVWF       R0 
	MOVF        system_processes_measured_value_L5+1, 0 
	MOVWF       R1 
	MOVF        system_processes_measured_value_L5+2, 0 
	MOVWF       R2 
	MOVF        system_processes_measured_value_L5+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_system_processes321
;Wifi_module.c,1796 :: 		RELAY[pos].R_trs_2 = RELAY[pos].R_tresh;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       26
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       8
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Wifi_module.c,1798 :: 		RELAY[pos].R_current_state = 1;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       1
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
;Wifi_module.c,1799 :: 		switchRelay(pos, 0, measured_value);
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       FARG_switchRelay_position+0 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       FARG_switchRelay_position+1 
	CLRF        FARG_switchRelay_status+0 
	CLRF        FARG_switchRelay_status+1 
	MOVF        system_processes_measured_value_L5+0, 0 
	MOVWF       FARG_switchRelay_measured_value+0 
	MOVF        system_processes_measured_value_L5+1, 0 
	MOVWF       FARG_switchRelay_measured_value+1 
	MOVF        system_processes_measured_value_L5+2, 0 
	MOVWF       FARG_switchRelay_measured_value+2 
	MOVF        system_processes_measured_value_L5+3, 0 
	MOVWF       FARG_switchRelay_measured_value+3 
	CALL        _switchRelay+0, 0
;Wifi_module.c,1802 :: 		RELAY[pos].R_flag_2 = 0;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       23
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Wifi_module.c,1804 :: 		} else {
	GOTO        L_system_processes322
L_system_processes321:
;Wifi_module.c,1805 :: 		if (RELAY[pos].R_flag_2 == 0){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       23
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_system_processes323
;Wifi_module.c,1806 :: 		switchRelay(pos, 1, measured_value);
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       FARG_switchRelay_position+0 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       FARG_switchRelay_position+1 
	MOVLW       1
	MOVWF       FARG_switchRelay_status+0 
	MOVLW       0
	MOVWF       FARG_switchRelay_status+1 
	MOVF        system_processes_measured_value_L5+0, 0 
	MOVWF       FARG_switchRelay_measured_value+0 
	MOVF        system_processes_measured_value_L5+1, 0 
	MOVWF       FARG_switchRelay_measured_value+1 
	MOVF        system_processes_measured_value_L5+2, 0 
	MOVWF       FARG_switchRelay_measured_value+2 
	MOVF        system_processes_measured_value_L5+3, 0 
	MOVWF       FARG_switchRelay_measured_value+3 
	CALL        _switchRelay+0, 0
;Wifi_module.c,1809 :: 		RELAY[pos].R_flag_2 = 1;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       23
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       1
	MOVWF       POSTINC1+0 
;Wifi_module.c,1810 :: 		}
L_system_processes323:
;Wifi_module.c,1811 :: 		}
L_system_processes322:
;Wifi_module.c,1812 :: 		}
L_system_processes320:
;Wifi_module.c,1813 :: 		}
L_system_processes315:
;Wifi_module.c,1814 :: 		} else {
	GOTO        L_system_processes324
L_system_processes312:
;Wifi_module.c,1815 :: 		if (RELAY[pos].R_current_state == 0){
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_processes545
	MOVLW       0
	XORWF       R1, 0 
L__system_processes545:
	BTFSS       STATUS+0, 2 
	GOTO        L_system_processes325
;Wifi_module.c,1818 :: 		switchRelay(pos, 0, 0);
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       FARG_switchRelay_position+0 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       FARG_switchRelay_position+1 
	CLRF        FARG_switchRelay_status+0 
	CLRF        FARG_switchRelay_status+1 
	CLRF        FARG_switchRelay_measured_value+0 
	CLRF        FARG_switchRelay_measured_value+1 
	CLRF        FARG_switchRelay_measured_value+2 
	CLRF        FARG_switchRelay_measured_value+3 
	CALL        _switchRelay+0, 0
;Wifi_module.c,1819 :: 		RELAY[pos].R_current_state = 1;
	MOVLW       28
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        system_processes_pos_L1+0, 0 
	MOVWF       R4 
	MOVF        system_processes_pos_L1+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _RELAY+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_RELAY+0)
	ADDWFC      R1, 1 
	MOVLW       16
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       1
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
;Wifi_module.c,1821 :: 		}
L_system_processes325:
;Wifi_module.c,1822 :: 		}
L_system_processes324:
;Wifi_module.c,1824 :: 		}
L_system_processes311:
;Wifi_module.c,1757 :: 		for (pos=0;pos<RELAY_SIZE;pos++){
	INFSNZ      system_processes_pos_L1+0, 1 
	INCF        system_processes_pos_L1+1, 1 
;Wifi_module.c,1825 :: 		}
	GOTO        L_system_processes308
L_system_processes309:
;Wifi_module.c,1826 :: 		}
L_system_processes307:
;Wifi_module.c,1850 :: 		}
L_end_system_processes:
	RETURN      0
; end of _system_processes

_SETUP_SYSTEM:

;Wifi_module.c,1852 :: 		void SETUP_SYSTEM(){}
L_end_SETUP_SYSTEM:
	RETURN      0
; end of _SETUP_SYSTEM

_setup_pic:

;Wifi_module.c,1854 :: 		void setup_pic(){
;Wifi_module.c,1856 :: 		TRISA = 0b00101001;
	MOVLW       41
	MOVWF       TRISA+0 
;Wifi_module.c,1857 :: 		TRISB = 0b00001111;
	MOVLW       15
	MOVWF       TRISB+0 
;Wifi_module.c,1858 :: 		TRISC = 0b10000100;
	MOVLW       132
	MOVWF       TRISC+0 
;Wifi_module.c,1859 :: 		TRISD = 0b00000000;
	CLRF        TRISD+0 
;Wifi_module.c,1861 :: 		PORTD = 0b00000000;
	CLRF        PORTD+0 
;Wifi_module.c,1862 :: 		PORTA = 0b00000000;
	CLRF        PORTA+0 
;Wifi_module.c,1864 :: 		ANCON0 = 0b11111001;
	MOVLW       249
	MOVWF       ANCON0+0 
;Wifi_module.c,1865 :: 		ANCON1 = 0b11111101;
	MOVLW       253
	MOVWF       ANCON1+0 
;Wifi_module.c,1867 :: 		delay_ms(1000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_setup_pic326:
	DECFSZ      R13, 1, 1
	BRA         L_setup_pic326
	DECFSZ      R12, 1, 1
	BRA         L_setup_pic326
	DECFSZ      R11, 1, 1
	BRA         L_setup_pic326
	NOP
;Wifi_module.c,1869 :: 		InitTimer0();
	CALL        _InitTimer0+0, 0
;Wifi_module.c,1871 :: 		UART1_Init(9600);
	MOVLW       103
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Wifi_module.c,1872 :: 		delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_setup_pic327:
	DECFSZ      R13, 1, 1
	BRA         L_setup_pic327
	DECFSZ      R12, 1, 1
	BRA         L_setup_pic327
	DECFSZ      R11, 1, 1
	BRA         L_setup_pic327
;Wifi_module.c,1873 :: 		UART2_Init(9600);
	BSF         BAUDCON2+0, 3, 0
	MOVLW       1
	MOVWF       SPBRGH2+0 
	MOVLW       160
	MOVWF       SPBRG2+0 
	BSF         TXSTA2+0, 2, 0
	CALL        _UART2_Init+0, 0
;Wifi_module.c,1874 :: 		delay_ms(1000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_setup_pic328:
	DECFSZ      R13, 1, 1
	BRA         L_setup_pic328
	DECFSZ      R12, 1, 1
	BRA         L_setup_pic328
	DECFSZ      R11, 1, 1
	BRA         L_setup_pic328
	NOP
;Wifi_module.c,1875 :: 		UART1_Write_Text("AT\r\n");
	MOVLW       ?lstr114_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr114_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1876 :: 		delay_ms(500);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_setup_pic329:
	DECFSZ      R13, 1, 1
	BRA         L_setup_pic329
	DECFSZ      R12, 1, 1
	BRA         L_setup_pic329
	DECFSZ      R11, 1, 1
	BRA         L_setup_pic329
	NOP
	NOP
;Wifi_module.c,1878 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;Wifi_module.c,1880 :: 		if ( Mmc_Fat_Init() == 0 ) {
	CALL        _Mmc_Fat_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_setup_pic330
;Wifi_module.c,1881 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;Wifi_module.c,1882 :: 		delay_ms(200);
	MOVLW       5
	MOVWF       R11, 0
	MOVLW       15
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_setup_pic331:
	DECFSZ      R13, 1, 1
	BRA         L_setup_pic331
	DECFSZ      R12, 1, 1
	BRA         L_setup_pic331
	DECFSZ      R11, 1, 1
	BRA         L_setup_pic331
;Wifi_module.c,1883 :: 		UART1_Write_Text("SD found\r\n");
	MOVLW       ?lstr115_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr115_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1884 :: 		System.isMicroSDConnected = TRUE;
	MOVLW       1
	MOVWF       _System+192 
;Wifi_module.c,1885 :: 		} else {
	GOTO        L_setup_pic332
L_setup_pic330:
;Wifi_module.c,1886 :: 		UART1_Write_Text("No SD");
	MOVLW       ?lstr116_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr116_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1887 :: 		System.isMicroSDConnected = FALSE;
	CLRF        _System+192 
;Wifi_module.c,1888 :: 		}
L_setup_pic332:
;Wifi_module.c,1891 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;Wifi_module.c,1892 :: 		INTCON.PEIE = 1;
	BSF         INTCON+0, 6 
;Wifi_module.c,1893 :: 		PIE1.RCIE = 1;
	BSF         PIE1+0, 5 
;Wifi_module.c,1895 :: 		ADC_Init();
	CALL        _ADC_Init+0, 0
;Wifi_module.c,1898 :: 		}
L_end_setup_pic:
	RETURN      0
; end of _setup_pic

_connect_to_server:

;Wifi_module.c,1902 :: 		short connect_to_server(){
;Wifi_module.c,1908 :: 		UART1_Write_Text("AT+SLEEP=2\r\n");
	MOVLW       ?lstr117_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr117_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1909 :: 		waitForInput("OK",3);
	MOVLW       ?lstr118_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr118_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       3
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,1911 :: 		UART1_Write_Text("AT+CWMODE=1\r\n");
	MOVLW       ?lstr119_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr119_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1912 :: 		waitForInput("OK",3);
	MOVLW       ?lstr120_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr120_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       3
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,1913 :: 		UART1_Write_Text("AT+CWJAP=\"");
	MOVLW       ?lstr121_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr121_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1914 :: 		UART1_Write_Text(System.ssid);
	MOVLW       _System+287
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_System+287)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1915 :: 		UART1_Write_Text("\",\"");
	MOVLW       ?lstr122_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr122_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1916 :: 		UART1_Write_Text(System.password);
	MOVLW       _System+319
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_System+319)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1917 :: 		UART1_Write_Text("\"\r\n");
	MOVLW       ?lstr123_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr123_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1918 :: 		if (waitForInput("OK",10)){
	MOVLW       ?lstr124_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr124_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       10
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_connect_to_server333
;Wifi_module.c,1919 :: 		System.wifi_status = CONNECTED;
	CLRF        _System+176 
;Wifi_module.c,1920 :: 		} else {
	GOTO        L_connect_to_server334
L_connect_to_server333:
;Wifi_module.c,1921 :: 		return FALSE;
	CLRF        R0 
	GOTO        L_end_connect_to_server
;Wifi_module.c,1922 :: 		}
L_connect_to_server334:
;Wifi_module.c,1925 :: 		UART1_Write_Text("AT+CIPMUX=1\r\n");
	MOVLW       ?lstr125_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr125_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1926 :: 		waitForInput("OK",2);
	MOVLW       ?lstr126_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr126_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       2
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,1929 :: 		clearReadLine();
	CALL        _clearReadLine+0, 0
;Wifi_module.c,1931 :: 		UART1_Write_Text("AT+CIPSTART=0,\"");
	MOVLW       ?lstr127_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr127_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1932 :: 		UART1_Write_Text("TCP");
	MOVLW       ?lstr128_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr128_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1933 :: 		UART1_Write_Text("\",\"");
	MOVLW       ?lstr129_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr129_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1934 :: 		UART1_Write_Text(System.host);
	MOVLW       _System+352
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_System+352)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1935 :: 		UART1_Write_Text("\",");
	MOVLW       ?lstr130_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr130_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1936 :: 		UART1_Write_Text(itoa(System.tcp_port,conv));
	MOVF        _System+285, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _System+286, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       connect_to_server_conv_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(connect_to_server_conv_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1937 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr131_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr131_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1940 :: 		if (waitForInput("OK",10) == 1){
	MOVLW       ?lstr132_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr132_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       10
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__connect_to_server549
	MOVLW       1
	XORWF       R0, 0 
L__connect_to_server549:
	BTFSS       STATUS+0, 2 
	GOTO        L_connect_to_server335
;Wifi_module.c,1942 :: 		System.network_status = CONNECTED;
	CLRF        _System+185 
;Wifi_module.c,1944 :: 		init_network_environment();
	CALL        _init_network_environment+0, 0
;Wifi_module.c,1963 :: 		} else {
	GOTO        L_connect_to_server336
L_connect_to_server335:
;Wifi_module.c,1964 :: 		System.network_status = IDLE;
	MOVLW       2
	MOVWF       _System+185 
;Wifi_module.c,1965 :: 		return FALSE;
	CLRF        R0 
	GOTO        L_end_connect_to_server
;Wifi_module.c,1966 :: 		}
L_connect_to_server336:
;Wifi_module.c,1967 :: 		return TRUE;
	MOVLW       1
	MOVWF       R0 
;Wifi_module.c,1968 :: 		}
L_end_connect_to_server:
	RETURN      0
; end of _connect_to_server

_create_server:

;Wifi_module.c,1970 :: 		short create_server(){
;Wifi_module.c,1972 :: 		UART1_Write_Text("AT+SLEEP=0\r\n");
	MOVLW       ?lstr133_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr133_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1973 :: 		waitForInput("OK",3);
	MOVLW       ?lstr134_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr134_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       3
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,1975 :: 		UART1_Write_Text("AT+CWMODE=2\r\n");
	MOVLW       ?lstr135_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr135_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1976 :: 		waitForInput("OK",2);
	MOVLW       ?lstr136_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr136_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       2
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,1978 :: 		UART1_Write_Text("AT+CIPMUX=1\r\n");
	MOVLW       ?lstr137_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr137_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1979 :: 		waitForInput("OK",2);
	MOVLW       ?lstr138_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr138_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       2
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
;Wifi_module.c,1981 :: 		UART1_Write_Text("AT+CWSAP=\"");
	MOVLW       ?lstr139_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr139_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1982 :: 		UART1_Write_Text(load(System.load_buffer,DEFAULT_AP));
	MOVLW       _System+193
	MOVWF       FARG_load_dest+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_load_dest+1 
	MOVLW       _DEFAULT_AP+0
	MOVWF       FARG_load_src+0 
	MOVLW       hi_addr(_DEFAULT_AP+0)
	MOVWF       FARG_load_src+1 
	MOVLW       higher_addr(_DEFAULT_AP+0)
	MOVWF       FARG_load_src+2 
	CALL        _load+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1983 :: 		UART1_Write_Text("\",\"");
	MOVLW       ?lstr140_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr140_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1984 :: 		UART1_Write_Text(load(System.load_buffer,DEFAULT_PW));
	MOVLW       _System+193
	MOVWF       FARG_load_dest+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_load_dest+1 
	MOVLW       _DEFAULT_PW+0
	MOVWF       FARG_load_src+0 
	MOVLW       hi_addr(_DEFAULT_PW+0)
	MOVWF       FARG_load_src+1 
	MOVLW       higher_addr(_DEFAULT_PW+0)
	MOVWF       FARG_load_src+2 
	CALL        _load+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1985 :: 		UART1_Write_Text("\",1,");
	MOVLW       ?lstr141_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr141_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1986 :: 		UART1_Write_Text(load(System.load_buffer,DEFAULT_ENCRYPTION));
	MOVLW       _System+193
	MOVWF       FARG_load_dest+0 
	MOVLW       hi_addr(_System+193)
	MOVWF       FARG_load_dest+1 
	MOVLW       _DEFAULT_ENCRYPTION+0
	MOVWF       FARG_load_src+0 
	MOVLW       hi_addr(_DEFAULT_ENCRYPTION+0)
	MOVWF       FARG_load_src+1 
	MOVLW       higher_addr(_DEFAULT_ENCRYPTION+0)
	MOVWF       FARG_load_src+2 
	CALL        _load+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1987 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr142_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr142_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1988 :: 		if (waitForInput("OK",5)){
	MOVLW       ?lstr143_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr143_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       5
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_create_server337
;Wifi_module.c,1989 :: 		System.wifi_status = CONNECTED;
	CLRF        _System+176 
;Wifi_module.c,1990 :: 		} else {
	GOTO        L_create_server338
L_create_server337:
;Wifi_module.c,1991 :: 		return FALSE;
	CLRF        R0 
	GOTO        L_end_create_server
;Wifi_module.c,1992 :: 		}
L_create_server338:
;Wifi_module.c,1995 :: 		UART1_Write_Text("AT+CIPSERVER=1,8080\r\n");
	MOVLW       ?lstr144_Wifi_module+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr144_Wifi_module+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Wifi_module.c,1997 :: 		if (waitForInput("OK",2)) {
	MOVLW       ?lstr145_Wifi_module+0
	MOVWF       FARG_waitForInput_input+0 
	MOVLW       hi_addr(?lstr145_Wifi_module+0)
	MOVWF       FARG_waitForInput_input+1 
	MOVLW       2
	MOVWF       FARG_waitForInput_timeout+0 
	MOVLW       0
	MOVWF       FARG_waitForInput_timeout+1 
	CALL        _waitForInput+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_create_server339
;Wifi_module.c,1999 :: 		System.network_status = LISTENING;
	MOVLW       1
	MOVWF       _System+185 
;Wifi_module.c,2000 :: 		} else {
	GOTO        L_create_server340
L_create_server339:
;Wifi_module.c,2001 :: 		System.network_status = IDLE;
	MOVLW       2
	MOVWF       _System+185 
;Wifi_module.c,2002 :: 		return FALSE;
	CLRF        R0 
	GOTO        L_end_create_server
;Wifi_module.c,2003 :: 		}
L_create_server340:
;Wifi_module.c,2005 :: 		return TRUE;
	MOVLW       1
	MOVWF       R0 
;Wifi_module.c,2006 :: 		}
L_end_create_server:
	RETURN      0
; end of _create_server

_networking:

;Wifi_module.c,2008 :: 		void networking(){
;Wifi_module.c,2010 :: 		if (System.connection_timer_buffer >= System.connection_timer){
	MOVLW       128
	XORWF       _System+267, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _System+265, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__networking552
	MOVF        _System+264, 0 
	SUBWF       _System+266, 0 
L__networking552:
	BTFSS       STATUS+0, 0 
	GOTO        L_networking341
;Wifi_module.c,2012 :: 		if (System.wifi_status != WIFI_CONNECTED || System.network_status == IDLE){
	MOVF        _System+176, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__networking368
	MOVF        _System+185, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L__networking368
	GOTO        L_networking344
L__networking368:
;Wifi_module.c,2014 :: 		if (System.connection_type == CLIENT){
	MOVF        _System+271, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_networking345
;Wifi_module.c,2015 :: 		isConnected = connect_to_server();
	CALL        _connect_to_server+0, 0
	MOVF        R0, 0 
	MOVWF       networking_isConnected_L2+0 
;Wifi_module.c,2016 :: 		} else {
	GOTO        L_networking346
L_networking345:
;Wifi_module.c,2017 :: 		isConnected = create_server();
	CALL        _create_server+0, 0
	MOVF        R0, 0 
	MOVWF       networking_isConnected_L2+0 
;Wifi_module.c,2018 :: 		}
L_networking346:
;Wifi_module.c,2019 :: 		if (isConnected == FALSE){
	MOVF        networking_isConnected_L2+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_networking347
;Wifi_module.c,2020 :: 		if (System.connection_timer <= 600) System.connection_timer += 20;
	MOVLW       128
	XORLW       2
	MOVWF       R0 
	MOVLW       128
	XORWF       _System+265, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__networking553
	MOVF        _System+264, 0 
	SUBLW       88
L__networking553:
	BTFSS       STATUS+0, 0 
	GOTO        L_networking348
	MOVLW       20
	ADDWF       _System+264, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _System+265, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _System+264 
	MOVF        R1, 0 
	MOVWF       _System+265 
L_networking348:
;Wifi_module.c,2021 :: 		}
L_networking347:
;Wifi_module.c,2023 :: 		}
L_networking344:
;Wifi_module.c,2024 :: 		System.connection_timer_buffer = 0;
	CLRF        _System+266 
	CLRF        _System+267 
;Wifi_module.c,2025 :: 		}
L_networking341:
;Wifi_module.c,2026 :: 		}
L_end_networking:
	RETURN      0
; end of _networking

_setup:

;Wifi_module.c,2029 :: 		void setup(){
;Wifi_module.c,2031 :: 		setup_pic();        // Registers, interfaces
	CALL        _setup_pic+0, 0
;Wifi_module.c,2033 :: 		default_config();   // Set the default config
	CALL        _default_config+0, 0
;Wifi_module.c,2035 :: 		read_config();      // Rewrite default CONFIG with SD card cfg, if there is any
	CALL        _read_config+0, 0
;Wifi_module.c,2037 :: 		}
L_end_setup:
	RETURN      0
; end of _setup

_main:

;Wifi_module.c,2040 :: 		void main() org 64888{
;Wifi_module.c,2042 :: 		setup();                        // Setup the whole environment
	CALL        _setup+0, 0
;Wifi_module.c,2044 :: 		while (1) {
L_main349:
;Wifi_module.c,2046 :: 		networking();             // Setup wifi module, connect to SERVER/ create SERVER
	CALL        _networking+0, 0
;Wifi_module.c,2048 :: 		measure_sensors();        // Measure sensors
	CALL        _measure_sensors+0, 0
;Wifi_module.c,2050 :: 		process_io();             // TCP communication, commands
	CALL        _process_io+0, 0
;Wifi_module.c,2052 :: 		system_processes();       // Battery, DIP switch, power out detect
	CALL        _system_processes+0, 0
;Wifi_module.c,2054 :: 		if (System.isInput_2_Ready == TRUE){
	MOVF        _System+178, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main351
;Wifi_module.c,2055 :: 		System.isInput_2_Ready = FALSE;
	CLRF        _System+178 
;Wifi_module.c,2057 :: 		Susart_Init(51);                    // Init USART at 9600
	MOVLW       51
	MOVWF       FARG_Susart_Init_Brg_reg+0 
	CALL        _Susart_Init+0, 0
;Wifi_module.c,2058 :: 		if (Susart_Write_Loop('g','r')) {   // Send 'g' for ~5 sec, if 'r'
	MOVLW       103
	MOVWF       FARG_Susart_Write_Loop_send+0 
	MOVLW       114
	MOVWF       FARG_Susart_Write_Loop_recieve+0 
	CALL        _Susart_Write_Loop+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main352
;Wifi_module.c,2059 :: 		Start_Bootload();                 //   received start bootload
	CALL        _Start_Bootload+0, 0
;Wifi_module.c,2060 :: 		}
	GOTO        L_main353
L_main352:
;Wifi_module.c,2062 :: 		Start_Program();                  //   else start program
	CALL        _Start_Program+0, 0
;Wifi_module.c,2063 :: 		}
L_main353:
;Wifi_module.c,2064 :: 		}
L_main351:
;Wifi_module.c,2066 :: 		}
	GOTO        L_main349
;Wifi_module.c,2068 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
