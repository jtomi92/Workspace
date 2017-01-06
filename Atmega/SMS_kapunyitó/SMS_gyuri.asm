
_CopyConst2Ram:

;SMS_gyuri.c,76 :: 		char * CopyConst2Ram(char * dest, const char * src){
;SMS_gyuri.c,78 :: 		d = dest;
	MOVF        FARG_CopyConst2Ram_dest+0, 0 
	MOVWF       R5 
	MOVF        FARG_CopyConst2Ram_dest+1, 0 
	MOVWF       R6 
;SMS_gyuri.c,79 :: 		for(;*dest++ = *src++;)
L_CopyConst2Ram0:
	MOVF        FARG_CopyConst2Ram_dest+0, 0 
	MOVWF       R3 
	MOVF        FARG_CopyConst2Ram_dest+1, 0 
	MOVWF       R4 
	INFSNZ      FARG_CopyConst2Ram_dest+0, 1 
	INCF        FARG_CopyConst2Ram_dest+1, 1 
	MOVF        FARG_CopyConst2Ram_src+0, 0 
	MOVWF       R0 
	MOVF        FARG_CopyConst2Ram_src+1, 0 
	MOVWF       R1 
	MOVF        FARG_CopyConst2Ram_src+2, 0 
	MOVWF       R2 
	MOVLW       1
	ADDWF       FARG_CopyConst2Ram_src+0, 1 
	MOVLW       0
	ADDWFC      FARG_CopyConst2Ram_src+1, 1 
	ADDWFC      FARG_CopyConst2Ram_src+2, 1 
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
	GOTO        L_CopyConst2Ram1
;SMS_gyuri.c,80 :: 		;
	GOTO        L_CopyConst2Ram0
L_CopyConst2Ram1:
;SMS_gyuri.c,82 :: 		return d;
	MOVF        R5, 0 
	MOVWF       R0 
	MOVF        R6, 0 
	MOVWF       R1 
;SMS_gyuri.c,83 :: 		}
L_end_CopyConst2Ram:
	RETURN      0
; end of _CopyConst2Ram

_SendSms:

;SMS_gyuri.c,85 :: 		void SendSms(char *phonenumber, char *uzenet, char *info)
;SMS_gyuri.c,88 :: 		UART1_Write_Text(CopyConst2Ram(msg2,AT));
	MOVLW       _msg2+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg2+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,89 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_SendSms3:
	DECFSZ      R13, 1, 1
	BRA         L_SendSms3
	DECFSZ      R12, 1, 1
	BRA         L_SendSms3
	DECFSZ      R11, 1, 1
	BRA         L_SendSms3
	NOP
	NOP
;SMS_gyuri.c,90 :: 		UART1_Write_Text(CopyConst2Ram(msg2,AT_CMGF));
	MOVLW       _msg2+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg2+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT_CMGF+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT_CMGF+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT_CMGF+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,91 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_SendSms4:
	DECFSZ      R13, 1, 1
	BRA         L_SendSms4
	DECFSZ      R12, 1, 1
	BRA         L_SendSms4
	DECFSZ      R11, 1, 1
	BRA         L_SendSms4
	NOP
	NOP
;SMS_gyuri.c,92 :: 		UART1_Write_Text(CopyConst2Ram(msg2,AT_CMGS));
	MOVLW       _msg2+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg2+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT_CMGS+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT_CMGS+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT_CMGS+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,93 :: 		UART1_Write_Text(countryCode);
	MOVLW       _countryCode+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_countryCode+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,94 :: 		UART1_Write_Text(phonenumber);
	MOVF        FARG_SendSms_phonenumber+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        FARG_SendSms_phonenumber+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,95 :: 		UART1_Write(0x22);
	MOVLW       34
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;SMS_gyuri.c,96 :: 		UART1_Write(0x0D);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;SMS_gyuri.c,97 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_SendSms5:
	DECFSZ      R13, 1, 1
	BRA         L_SendSms5
	DECFSZ      R12, 1, 1
	BRA         L_SendSms5
	DECFSZ      R11, 1, 1
	BRA         L_SendSms5
	NOP
	NOP
;SMS_gyuri.c,98 :: 		UART1_Write_Text(uzenet);
	MOVF        FARG_SendSms_uzenet+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        FARG_SendSms_uzenet+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,99 :: 		UART1_Write_Text(info);
	MOVF        FARG_SendSms_info+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        FARG_SendSms_info+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,100 :: 		UART1_Write(26);
	MOVLW       26
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;SMS_gyuri.c,101 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_SendSms6:
	DECFSZ      R13, 1, 1
	BRA         L_SendSms6
	DECFSZ      R12, 1, 1
	BRA         L_SendSms6
	DECFSZ      R11, 1, 1
	BRA         L_SendSms6
	NOP
	NOP
;SMS_gyuri.c,102 :: 		UART1_Write(0x0D);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;SMS_gyuri.c,103 :: 		delay_ms(8000);
	MOVLW       102
	MOVWF       R11, 0
	MOVLW       118
	MOVWF       R12, 0
	MOVLW       193
	MOVWF       R13, 0
L_SendSms7:
	DECFSZ      R13, 1, 1
	BRA         L_SendSms7
	DECFSZ      R12, 1, 1
	BRA         L_SendSms7
	DECFSZ      R11, 1, 1
	BRA         L_SendSms7
;SMS_gyuri.c,104 :: 		}
L_end_SendSms:
	RETURN      0
; end of _SendSms

_InitTimer0:

;SMS_gyuri.c,109 :: 		void InitTimer0(){
;SMS_gyuri.c,110 :: 		T0CON         = 0x85;
	MOVLW       133
	MOVWF       T0CON+0 
;SMS_gyuri.c,111 :: 		TMR0H         = 0x67;
	MOVLW       103
	MOVWF       TMR0H+0 
;SMS_gyuri.c,112 :: 		TMR0L         = 0x69;
	MOVLW       105
	MOVWF       TMR0L+0 
;SMS_gyuri.c,113 :: 		GIE_bit         = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;SMS_gyuri.c,114 :: 		TMR0IE_bit         = 1;
	BSF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;SMS_gyuri.c,115 :: 		}
L_end_InitTimer0:
	RETURN      0
; end of _InitTimer0

_Interrupt:

;SMS_gyuri.c,119 :: 		void Interrupt(){
;SMS_gyuri.c,121 :: 		if (PIR1.RCIF) {          // test the interrupt for uart rx
	BTFSS       PIR1+0, 5 
	GOTO        L_Interrupt8
;SMS_gyuri.c,123 :: 		interruptStreamBuffer[k] = UART1_Read();
	MOVLW       _interruptStreamBuffer+0
	ADDWF       _k+0, 0 
	MOVWF       FLOC__Interrupt+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	ADDWFC      _k+1, 0 
	MOVWF       FLOC__Interrupt+1 
	CALL        _UART1_Read+0, 0
	MOVFF       FLOC__Interrupt+0, FSR1
	MOVFF       FLOC__Interrupt+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;SMS_gyuri.c,125 :: 		if (k >= 198){
	MOVLW       128
	XORWF       _k+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Interrupt250
	MOVLW       198
	SUBWF       _k+0, 0 
L__Interrupt250:
	BTFSS       STATUS+0, 0 
	GOTO        L_Interrupt9
;SMS_gyuri.c,126 :: 		interruptStreamBuffer[k+1] = '\0';
	MOVLW       1
	ADDWF       _k+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _k+1, 0 
	MOVWF       R1 
	MOVLW       _interruptStreamBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;SMS_gyuri.c,127 :: 		k = 0;
	CLRF        _k+0 
	CLRF        _k+1 
;SMS_gyuri.c,128 :: 		sms = 1;
	MOVLW       1
	MOVWF       _sms+0 
;SMS_gyuri.c,129 :: 		InputReaderFlag = 0;
	CLRF        _InputReaderFlag+0 
;SMS_gyuri.c,130 :: 		}
L_Interrupt9:
;SMS_gyuri.c,133 :: 		if (interruptStreamBuffer[k] == '\r' || interruptStreamBuffer[k] == '\0'){
	MOVLW       _interruptStreamBuffer+0
	ADDWF       _k+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	ADDWFC      _k+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       13
	BTFSC       STATUS+0, 2 
	GOTO        L__Interrupt240
	MOVLW       _interruptStreamBuffer+0
	ADDWF       _k+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	ADDWFC      _k+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__Interrupt240
	GOTO        L_Interrupt12
L__Interrupt240:
;SMS_gyuri.c,135 :: 		InputReaderFlag = 1;
	MOVLW       1
	MOVWF       _InputReaderFlag+0 
;SMS_gyuri.c,136 :: 		}
L_Interrupt12:
;SMS_gyuri.c,138 :: 		k++;
	INFSNZ      _k+0, 1 
	INCF        _k+1, 1 
;SMS_gyuri.c,140 :: 		}
L_Interrupt8:
;SMS_gyuri.c,143 :: 		if (TMR1IF_bit){
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_Interrupt13
;SMS_gyuri.c,144 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;SMS_gyuri.c,145 :: 		TMR1H         = 0x9E;
	MOVLW       158
	MOVWF       TMR1H+0 
;SMS_gyuri.c,146 :: 		TMR1L         = 0x58;
	MOVLW       88
	MOVWF       TMR1L+0 
;SMS_gyuri.c,149 :: 		}
L_Interrupt13:
;SMS_gyuri.c,153 :: 		if (TMR0IF_bit){
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_Interrupt14
;SMS_gyuri.c,154 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;SMS_gyuri.c,155 :: 		TMR0H         = 0x67;
	MOVLW       103
	MOVWF       TMR0H+0 
;SMS_gyuri.c,156 :: 		TMR0L         = 0x69;
	MOVLW       105
	MOVWF       TMR0L+0 
;SMS_gyuri.c,158 :: 		if (seconds <= 121){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _seconds+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Interrupt251
	MOVF        _seconds+0, 0 
	SUBLW       121
L__Interrupt251:
	BTFSS       STATUS+0, 0 
	GOTO        L_Interrupt15
;SMS_gyuri.c,159 :: 		seconds++;
	INFSNZ      _seconds+0, 1 
	INCF        _seconds+1, 1 
;SMS_gyuri.c,160 :: 		}
L_Interrupt15:
;SMS_gyuri.c,164 :: 		}
L_Interrupt14:
;SMS_gyuri.c,165 :: 		}
L_end_Interrupt:
L__Interrupt249:
	RETFIE      1
; end of _Interrupt

_ReadConfigFromEEPROM:

;SMS_gyuri.c,168 :: 		void ReadConfigFromEEPROM(){
;SMS_gyuri.c,170 :: 		char configString[60] = "";
	MOVLW       ?ICSReadConfigFromEEPROM_configString_L0+0
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(?ICSReadConfigFromEEPROM_configString_L0+0)
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(?ICSReadConfigFromEEPROM_configString_L0+0)
	MOVWF       TBLPTRU 
	MOVLW       ReadConfigFromEEPROM_configString_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(ReadConfigFromEEPROM_configString_L0+0)
	MOVWF       FSR1H 
	MOVLW       60
	MOVWF       R0 
	MOVLW       1
	MOVWF       R1 
	CALL        ___CC2DW+0, 0
;SMS_gyuri.c,174 :: 		for (i=0;i<sizeof(configString)-1;i++){
	CLRF        ReadConfigFromEEPROM_i_L0+0 
	CLRF        ReadConfigFromEEPROM_i_L0+1 
L_ReadConfigFromEEPROM16:
	MOVLW       128
	XORWF       ReadConfigFromEEPROM_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM253
	MOVLW       59
	SUBWF       ReadConfigFromEEPROM_i_L0+0, 0 
L__ReadConfigFromEEPROM253:
	BTFSC       STATUS+0, 0 
	GOTO        L_ReadConfigFromEEPROM17
;SMS_gyuri.c,175 :: 		configString[i] = EEPROM_Read(CONFIG_ADDR+i);
	MOVLW       ReadConfigFromEEPROM_configString_L0+0
	ADDWF       ReadConfigFromEEPROM_i_L0+0, 0 
	MOVWF       FLOC__ReadConfigFromEEPROM+0 
	MOVLW       hi_addr(ReadConfigFromEEPROM_configString_L0+0)
	ADDWFC      ReadConfigFromEEPROM_i_L0+1, 0 
	MOVWF       FLOC__ReadConfigFromEEPROM+1 
	MOVF        ReadConfigFromEEPROM_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__ReadConfigFromEEPROM+0, FSR1
	MOVFF       FLOC__ReadConfigFromEEPROM+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;SMS_gyuri.c,174 :: 		for (i=0;i<sizeof(configString)-1;i++){
	INFSNZ      ReadConfigFromEEPROM_i_L0+0, 1 
	INCF        ReadConfigFromEEPROM_i_L0+1, 1 
;SMS_gyuri.c,176 :: 		}
	GOTO        L_ReadConfigFromEEPROM16
L_ReadConfigFromEEPROM17:
;SMS_gyuri.c,177 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,178 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_ReadConfigFromEEPROM19:
	DECFSZ      R13, 1, 1
	BRA         L_ReadConfigFromEEPROM19
	DECFSZ      R12, 1, 1
	BRA         L_ReadConfigFromEEPROM19
	DECFSZ      R11, 1, 1
	BRA         L_ReadConfigFromEEPROM19
	NOP
	NOP
;SMS_gyuri.c,179 :: 		UART1_Write_Text(configString);
	MOVLW       ReadConfigFromEEPROM_configString_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(ReadConfigFromEEPROM_configString_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,180 :: 		UART1_Write_Text("\n\r");
	MOVLW       ?lstr1_SMS_gyuri+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_SMS_gyuri+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,182 :: 		p = strtok(configString,";");
	MOVLW       ReadConfigFromEEPROM_configString_L0+0
	MOVWF       FARG_strtok_s1+0 
	MOVLW       hi_addr(ReadConfigFromEEPROM_configString_L0+0)
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr2_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr2_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       ReadConfigFromEEPROM_p_L0+0 
	MOVF        R1, 0 
	MOVWF       ReadConfigFromEEPROM_p_L0+1 
;SMS_gyuri.c,184 :: 		i=0;
	CLRF        ReadConfigFromEEPROM_i_L0+0 
	CLRF        ReadConfigFromEEPROM_i_L0+1 
;SMS_gyuri.c,186 :: 		while (p!=0){
L_ReadConfigFromEEPROM20:
	MOVLW       0
	XORWF       ReadConfigFromEEPROM_p_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM254
	MOVLW       0
	XORWF       ReadConfigFromEEPROM_p_L0+0, 0 
L__ReadConfigFromEEPROM254:
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM21
;SMS_gyuri.c,188 :: 		switch (i){
	GOTO        L_ReadConfigFromEEPROM22
;SMS_gyuri.c,190 :: 		case 0:
L_ReadConfigFromEEPROM24:
;SMS_gyuri.c,191 :: 		impulses = atoi(p);
	MOVF        ReadConfigFromEEPROM_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        ReadConfigFromEEPROM_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _impulses+0 
	MOVF        R1, 0 
	MOVWF       _impulses+1 
;SMS_gyuri.c,192 :: 		break;
	GOTO        L_ReadConfigFromEEPROM23
;SMS_gyuri.c,194 :: 		case 1:
L_ReadConfigFromEEPROM25:
;SMS_gyuri.c,195 :: 		if (atoi(p) == 0) mode_1_delay = 500; else mode_1_delay = atoi(p);
	MOVF        ReadConfigFromEEPROM_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        ReadConfigFromEEPROM_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM255
	MOVLW       0
	XORWF       R0, 0 
L__ReadConfigFromEEPROM255:
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM26
	MOVLW       244
	MOVWF       _mode_1_delay+0 
	MOVLW       1
	MOVWF       _mode_1_delay+1 
	GOTO        L_ReadConfigFromEEPROM27
L_ReadConfigFromEEPROM26:
	MOVF        ReadConfigFromEEPROM_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        ReadConfigFromEEPROM_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _mode_1_delay+0 
	MOVF        R1, 0 
	MOVWF       _mode_1_delay+1 
L_ReadConfigFromEEPROM27:
;SMS_gyuri.c,196 :: 		break;
	GOTO        L_ReadConfigFromEEPROM23
;SMS_gyuri.c,198 :: 		case 2:
L_ReadConfigFromEEPROM28:
;SMS_gyuri.c,199 :: 		mode_2_delay = atoi(p);
	MOVF        ReadConfigFromEEPROM_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        ReadConfigFromEEPROM_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _mode_2_delay+0 
	MOVF        R1, 0 
	MOVWF       _mode_2_delay+1 
;SMS_gyuri.c,200 :: 		break;
	GOTO        L_ReadConfigFromEEPROM23
;SMS_gyuri.c,202 :: 		case 3:
L_ReadConfigFromEEPROM29:
;SMS_gyuri.c,203 :: 		repeat = atoi(p);
	MOVF        ReadConfigFromEEPROM_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        ReadConfigFromEEPROM_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _repeat+0 
	MOVF        R1, 0 
	MOVWF       _repeat+1 
;SMS_gyuri.c,204 :: 		break;
	GOTO        L_ReadConfigFromEEPROM23
;SMS_gyuri.c,206 :: 		case 4:
L_ReadConfigFromEEPROM30:
;SMS_gyuri.c,207 :: 		wait = atoi(p);
	MOVF        ReadConfigFromEEPROM_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        ReadConfigFromEEPROM_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _wait+0 
	MOVF        R1, 0 
	MOVWF       _wait+1 
;SMS_gyuri.c,208 :: 		break;
	GOTO        L_ReadConfigFromEEPROM23
;SMS_gyuri.c,210 :: 		case 5:
L_ReadConfigFromEEPROM31:
;SMS_gyuri.c,211 :: 		numberOfUsers = atoi(p);
	MOVF        ReadConfigFromEEPROM_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        ReadConfigFromEEPROM_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _numberOfUsers+0 
	MOVF        R1, 0 
	MOVWF       _numberOfUsers+1 
;SMS_gyuri.c,212 :: 		break;
	GOTO        L_ReadConfigFromEEPROM23
;SMS_gyuri.c,214 :: 		case 6:
L_ReadConfigFromEEPROM32:
;SMS_gyuri.c,215 :: 		if (atoi(p) == 0) mode = 1; else mode = atoi(p);
	MOVF        ReadConfigFromEEPROM_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        ReadConfigFromEEPROM_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM256
	MOVLW       0
	XORWF       R0, 0 
L__ReadConfigFromEEPROM256:
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM33
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
	GOTO        L_ReadConfigFromEEPROM34
L_ReadConfigFromEEPROM33:
	MOVF        ReadConfigFromEEPROM_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        ReadConfigFromEEPROM_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _mode+0 
	MOVF        R1, 0 
	MOVWF       _mode+1 
L_ReadConfigFromEEPROM34:
;SMS_gyuri.c,216 :: 		break;
	GOTO        L_ReadConfigFromEEPROM23
;SMS_gyuri.c,218 :: 		case 7:
L_ReadConfigFromEEPROM35:
;SMS_gyuri.c,219 :: 		if (strstr(p,"+") != 0)strcpy(countryCode,p);else strcpy(countryCode,CopyConst2Ram(msg,CC));
	MOVF        ReadConfigFromEEPROM_p_L0+0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVF        ReadConfigFromEEPROM_p_L0+1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr3_SMS_gyuri+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr3_SMS_gyuri+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM257
	MOVLW       0
	XORWF       R0, 0 
L__ReadConfigFromEEPROM257:
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM36
	MOVLW       _countryCode+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_countryCode+0)
	MOVWF       FARG_strcpy_to+1 
	MOVF        ReadConfigFromEEPROM_p_L0+0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        ReadConfigFromEEPROM_p_L0+1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
	GOTO        L_ReadConfigFromEEPROM37
L_ReadConfigFromEEPROM36:
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _CC+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_CC+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_CC+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_from+1 
	MOVLW       _countryCode+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_countryCode+0)
	MOVWF       FARG_strcpy_to+1 
	CALL        _strcpy+0, 0
L_ReadConfigFromEEPROM37:
;SMS_gyuri.c,220 :: 		break;
	GOTO        L_ReadConfigFromEEPROM23
;SMS_gyuri.c,221 :: 		}
L_ReadConfigFromEEPROM22:
	MOVLW       0
	XORWF       ReadConfigFromEEPROM_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM258
	MOVLW       0
	XORWF       ReadConfigFromEEPROM_i_L0+0, 0 
L__ReadConfigFromEEPROM258:
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM24
	MOVLW       0
	XORWF       ReadConfigFromEEPROM_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM259
	MOVLW       1
	XORWF       ReadConfigFromEEPROM_i_L0+0, 0 
L__ReadConfigFromEEPROM259:
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM25
	MOVLW       0
	XORWF       ReadConfigFromEEPROM_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM260
	MOVLW       2
	XORWF       ReadConfigFromEEPROM_i_L0+0, 0 
L__ReadConfigFromEEPROM260:
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM28
	MOVLW       0
	XORWF       ReadConfigFromEEPROM_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM261
	MOVLW       3
	XORWF       ReadConfigFromEEPROM_i_L0+0, 0 
L__ReadConfigFromEEPROM261:
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM29
	MOVLW       0
	XORWF       ReadConfigFromEEPROM_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM262
	MOVLW       4
	XORWF       ReadConfigFromEEPROM_i_L0+0, 0 
L__ReadConfigFromEEPROM262:
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM30
	MOVLW       0
	XORWF       ReadConfigFromEEPROM_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM263
	MOVLW       5
	XORWF       ReadConfigFromEEPROM_i_L0+0, 0 
L__ReadConfigFromEEPROM263:
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM31
	MOVLW       0
	XORWF       ReadConfigFromEEPROM_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM264
	MOVLW       6
	XORWF       ReadConfigFromEEPROM_i_L0+0, 0 
L__ReadConfigFromEEPROM264:
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM32
	MOVLW       0
	XORWF       ReadConfigFromEEPROM_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM265
	MOVLW       7
	XORWF       ReadConfigFromEEPROM_i_L0+0, 0 
L__ReadConfigFromEEPROM265:
	BTFSC       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM35
L_ReadConfigFromEEPROM23:
;SMS_gyuri.c,223 :: 		i++;
	INFSNZ      ReadConfigFromEEPROM_i_L0+0, 1 
	INCF        ReadConfigFromEEPROM_i_L0+1, 1 
;SMS_gyuri.c,224 :: 		p = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr4_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr4_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       ReadConfigFromEEPROM_p_L0+0 
	MOVF        R1, 0 
	MOVWF       ReadConfigFromEEPROM_p_L0+1 
;SMS_gyuri.c,225 :: 		}
	GOTO        L_ReadConfigFromEEPROM20
L_ReadConfigFromEEPROM21:
;SMS_gyuri.c,229 :: 		for (i=0;i<10;i++){
	CLRF        ReadConfigFromEEPROM_i_L0+0 
	CLRF        ReadConfigFromEEPROM_i_L0+1 
L_ReadConfigFromEEPROM38:
	MOVLW       128
	XORWF       ReadConfigFromEEPROM_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM266
	MOVLW       10
	SUBWF       ReadConfigFromEEPROM_i_L0+0, 0 
L__ReadConfigFromEEPROM266:
	BTFSC       STATUS+0, 0 
	GOTO        L_ReadConfigFromEEPROM39
;SMS_gyuri.c,230 :: 		admin[i] = EEPROM_Read(ADMIN_ADDRESS+i);
	MOVLW       _admin+0
	ADDWF       ReadConfigFromEEPROM_i_L0+0, 0 
	MOVWF       FLOC__ReadConfigFromEEPROM+0 
	MOVLW       hi_addr(_admin+0)
	ADDWFC      ReadConfigFromEEPROM_i_L0+1, 0 
	MOVWF       FLOC__ReadConfigFromEEPROM+1 
	MOVF        ReadConfigFromEEPROM_i_L0+0, 0 
	ADDLW       160
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__ReadConfigFromEEPROM+0, FSR1
	MOVFF       FLOC__ReadConfigFromEEPROM+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;SMS_gyuri.c,231 :: 		delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_ReadConfigFromEEPROM41:
	DECFSZ      R13, 1, 1
	BRA         L_ReadConfigFromEEPROM41
	DECFSZ      R12, 1, 1
	BRA         L_ReadConfigFromEEPROM41
	NOP
;SMS_gyuri.c,229 :: 		for (i=0;i<10;i++){
	INFSNZ      ReadConfigFromEEPROM_i_L0+0, 1 
	INCF        ReadConfigFromEEPROM_i_L0+1, 1 
;SMS_gyuri.c,232 :: 		}
	GOTO        L_ReadConfigFromEEPROM38
L_ReadConfigFromEEPROM39:
;SMS_gyuri.c,233 :: 		if (!isdigit(admin[2])) strcpy(admin,"309225427");
	MOVF        _admin+2, 0 
	MOVWF       FARG_isdigit_character+0 
	CALL        _isdigit+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_ReadConfigFromEEPROM42
	MOVLW       _admin+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr5_SMS_gyuri+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr5_SMS_gyuri+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
L_ReadConfigFromEEPROM42:
;SMS_gyuri.c,235 :: 		for (i=0;i<numberOfUsers;i++){
	CLRF        ReadConfigFromEEPROM_i_L0+0 
	CLRF        ReadConfigFromEEPROM_i_L0+1 
L_ReadConfigFromEEPROM43:
	MOVLW       128
	XORWF       ReadConfigFromEEPROM_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _numberOfUsers+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM267
	MOVF        _numberOfUsers+0, 0 
	SUBWF       ReadConfigFromEEPROM_i_L0+0, 0 
L__ReadConfigFromEEPROM267:
	BTFSC       STATUS+0, 0 
	GOTO        L_ReadConfigFromEEPROM44
;SMS_gyuri.c,236 :: 		for (j=0;j<10;j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_ReadConfigFromEEPROM46:
	MOVLW       128
	XORWF       _j+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ReadConfigFromEEPROM268
	MOVLW       10
	SUBWF       _j+0, 0 
L__ReadConfigFromEEPROM268:
	BTFSC       STATUS+0, 0 
	GOTO        L_ReadConfigFromEEPROM47
;SMS_gyuri.c,237 :: 		users[i][j] = EEPROM_Read(i * 10 + USERS_ADDRESS + j);
	MOVLW       10
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        ReadConfigFromEEPROM_i_L0+0, 0 
	MOVWF       R4 
	MOVF        ReadConfigFromEEPROM_i_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVF        _j+0, 0 
	ADDWF       R2, 0 
	MOVWF       FLOC__ReadConfigFromEEPROM+0 
	MOVF        _j+1, 0 
	ADDWFC      R3, 0 
	MOVWF       FLOC__ReadConfigFromEEPROM+1 
	MOVLW       176
	ADDWF       R0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        _j+0, 0 
	ADDWF       FARG_EEPROM_Read_address+0, 1 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__ReadConfigFromEEPROM+0, FSR1
	MOVFF       FLOC__ReadConfigFromEEPROM+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;SMS_gyuri.c,236 :: 		for (j=0;j<10;j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;SMS_gyuri.c,238 :: 		}
	GOTO        L_ReadConfigFromEEPROM46
L_ReadConfigFromEEPROM47:
;SMS_gyuri.c,235 :: 		for (i=0;i<numberOfUsers;i++){
	INFSNZ      ReadConfigFromEEPROM_i_L0+0, 1 
	INCF        ReadConfigFromEEPROM_i_L0+1, 1 
;SMS_gyuri.c,239 :: 		}
	GOTO        L_ReadConfigFromEEPROM43
L_ReadConfigFromEEPROM44:
;SMS_gyuri.c,241 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_ReadConfigFromEEPROM49:
	DECFSZ      R13, 1, 1
	BRA         L_ReadConfigFromEEPROM49
	DECFSZ      R12, 1, 1
	BRA         L_ReadConfigFromEEPROM49
	DECFSZ      R11, 1, 1
	BRA         L_ReadConfigFromEEPROM49
	NOP
	NOP
;SMS_gyuri.c,245 :: 		}
L_end_ReadConfigFromEEPROM:
	RETURN      0
; end of _ReadConfigFromEEPROM

_SaveConfigToEEPROM:

;SMS_gyuri.c,248 :: 		void SaveConfigToEEPROM(){
;SMS_gyuri.c,250 :: 		char buffer[7] = "";
	MOVLW       ?ICSSaveConfigToEEPROM_buffer_L0+0
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(?ICSSaveConfigToEEPROM_buffer_L0+0)
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(?ICSSaveConfigToEEPROM_buffer_L0+0)
	MOVWF       TBLPTRU 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FSR1H 
	MOVLW       67
	MOVWF       R0 
	MOVLW       1
	MOVWF       R1 
	CALL        ___CC2DW+0, 0
;SMS_gyuri.c,254 :: 		IntToStr(impulses,buffer);
	MOVF        _impulses+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _impulses+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;SMS_gyuri.c,255 :: 		strcpy(configString,buffer);
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;SMS_gyuri.c,256 :: 		strcat(configString,";");
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr6_SMS_gyuri+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr6_SMS_gyuri+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,258 :: 		IntToStr(mode_1_delay,buffer);
	MOVF        _mode_1_delay+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _mode_1_delay+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;SMS_gyuri.c,259 :: 		strcat(configString,buffer);
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,260 :: 		strcat(configString,";");
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr7_SMS_gyuri+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr7_SMS_gyuri+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,262 :: 		IntToStr(mode_2_delay,buffer);
	MOVF        _mode_2_delay+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _mode_2_delay+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;SMS_gyuri.c,263 :: 		strcat(configString,buffer);
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,264 :: 		strcat(configString,";");
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr8_SMS_gyuri+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr8_SMS_gyuri+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,266 :: 		IntToStr(repeat,buffer);
	MOVF        _repeat+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _repeat+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;SMS_gyuri.c,267 :: 		strcat(configString,buffer);
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,268 :: 		strcat(configString,";");
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr9_SMS_gyuri+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr9_SMS_gyuri+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,270 :: 		IntToStr(wait,buffer);
	MOVF        _wait+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _wait+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;SMS_gyuri.c,271 :: 		strcat(configString,buffer);
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,272 :: 		strcat(configString,";");
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr10_SMS_gyuri+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr10_SMS_gyuri+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,274 :: 		IntToStr(numberOfUsers,buffer);
	MOVF        _numberOfUsers+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _numberOfUsers+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;SMS_gyuri.c,275 :: 		strcat(configString,buffer);
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,276 :: 		strcat(configString,";");
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr11_SMS_gyuri+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr11_SMS_gyuri+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,278 :: 		IntToStr(mode,buffer);
	MOVF        _mode+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _mode+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;SMS_gyuri.c,279 :: 		strcat(configString,buffer);
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       SaveConfigToEEPROM_buffer_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_buffer_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,280 :: 		strcat(configString,";");
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr12_SMS_gyuri+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr12_SMS_gyuri+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,282 :: 		strcat(configString,countryCode);
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       _countryCode+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(_countryCode+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,283 :: 		strcat(configString,";");
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr13_SMS_gyuri+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr13_SMS_gyuri+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SMS_gyuri.c,284 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,285 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_SaveConfigToEEPROM50:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConfigToEEPROM50
	DECFSZ      R12, 1, 1
	BRA         L_SaveConfigToEEPROM50
	DECFSZ      R11, 1, 1
	BRA         L_SaveConfigToEEPROM50
	NOP
	NOP
;SMS_gyuri.c,286 :: 		UART1_Write_Text(configString);
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,288 :: 		for (i=0;i<sizeof(configString)-1;i++){
	CLRF        SaveConfigToEEPROM_i_L0+0 
	CLRF        SaveConfigToEEPROM_i_L0+1 
L_SaveConfigToEEPROM51:
	MOVLW       128
	XORWF       SaveConfigToEEPROM_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SaveConfigToEEPROM270
	MOVLW       59
	SUBWF       SaveConfigToEEPROM_i_L0+0, 0 
L__SaveConfigToEEPROM270:
	BTFSC       STATUS+0, 0 
	GOTO        L_SaveConfigToEEPROM52
;SMS_gyuri.c,289 :: 		EEPROM_Write(CONFIG_ADDR+i,configString[i]);
	MOVF        SaveConfigToEEPROM_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       SaveConfigToEEPROM_configString_L0+0
	ADDWF       SaveConfigToEEPROM_i_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(SaveConfigToEEPROM_configString_L0+0)
	ADDWFC      SaveConfigToEEPROM_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;SMS_gyuri.c,288 :: 		for (i=0;i<sizeof(configString)-1;i++){
	INFSNZ      SaveConfigToEEPROM_i_L0+0, 1 
	INCF        SaveConfigToEEPROM_i_L0+1, 1 
;SMS_gyuri.c,290 :: 		}
	GOTO        L_SaveConfigToEEPROM51
L_SaveConfigToEEPROM52:
;SMS_gyuri.c,292 :: 		}
L_end_SaveConfigToEEPROM:
	RETURN      0
; end of _SaveConfigToEEPROM

_SaveUserToEEPROM:

;SMS_gyuri.c,294 :: 		int SaveUserToEEPROM(char *number){
;SMS_gyuri.c,298 :: 		p = number;
	MOVF        FARG_SaveUserToEEPROM_number+0, 0 
	MOVWF       SaveUserToEEPROM_p_L0+0 
	MOVF        FARG_SaveUserToEEPROM_number+1, 0 
	MOVWF       SaveUserToEEPROM_p_L0+1 
;SMS_gyuri.c,300 :: 		for (i=0;i<10;i++)
	CLRF        SaveUserToEEPROM_i_L0+0 
	CLRF        SaveUserToEEPROM_i_L0+1 
L_SaveUserToEEPROM54:
	MOVLW       128
	XORWF       SaveUserToEEPROM_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SaveUserToEEPROM272
	MOVLW       10
	SUBWF       SaveUserToEEPROM_i_L0+0, 0 
L__SaveUserToEEPROM272:
	BTFSC       STATUS+0, 0 
	GOTO        L_SaveUserToEEPROM55
;SMS_gyuri.c,301 :: 		UART1_Write(*p++);
	MOVFF       SaveUserToEEPROM_p_L0+0, FSR0
	MOVFF       SaveUserToEEPROM_p_L0+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
	INFSNZ      SaveUserToEEPROM_p_L0+0, 1 
	INCF        SaveUserToEEPROM_p_L0+1, 1 
;SMS_gyuri.c,300 :: 		for (i=0;i<10;i++)
	INFSNZ      SaveUserToEEPROM_i_L0+0, 1 
	INCF        SaveUserToEEPROM_i_L0+1, 1 
;SMS_gyuri.c,301 :: 		UART1_Write(*p++);
	GOTO        L_SaveUserToEEPROM54
L_SaveUserToEEPROM55:
;SMS_gyuri.c,303 :: 		if (numberOfUsers == MAXUSERS) return 0;
	MOVLW       0
	XORWF       _numberOfUsers+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SaveUserToEEPROM273
	MOVLW       10
	XORWF       _numberOfUsers+0, 0 
L__SaveUserToEEPROM273:
	BTFSS       STATUS+0, 2 
	GOTO        L_SaveUserToEEPROM57
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_SaveUserToEEPROM
L_SaveUserToEEPROM57:
;SMS_gyuri.c,305 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;SMS_gyuri.c,308 :: 		for (i=0;i<10;i++){
	CLRF        SaveUserToEEPROM_i_L0+0 
	CLRF        SaveUserToEEPROM_i_L0+1 
L_SaveUserToEEPROM58:
	MOVLW       128
	XORWF       SaveUserToEEPROM_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SaveUserToEEPROM274
	MOVLW       10
	SUBWF       SaveUserToEEPROM_i_L0+0, 0 
L__SaveUserToEEPROM274:
	BTFSC       STATUS+0, 0 
	GOTO        L_SaveUserToEEPROM59
;SMS_gyuri.c,309 :: 		EEPROM_Write(numberOfUsers * 10 + USERS_ADDRESS + i,*number++);
	MOVLW       10
	MULWF       _numberOfUsers+0 
	MOVF        PRODL+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       176
	ADDWF       FARG_EEPROM_Write_address+0, 1 
	MOVF        SaveUserToEEPROM_i_L0+0, 0 
	ADDWF       FARG_EEPROM_Write_address+0, 1 
	MOVFF       FARG_SaveUserToEEPROM_number+0, FSR0
	MOVFF       FARG_SaveUserToEEPROM_number+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
	INFSNZ      FARG_SaveUserToEEPROM_number+0, 1 
	INCF        FARG_SaveUserToEEPROM_number+1, 1 
;SMS_gyuri.c,310 :: 		delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_SaveUserToEEPROM61:
	DECFSZ      R13, 1, 1
	BRA         L_SaveUserToEEPROM61
	DECFSZ      R12, 1, 1
	BRA         L_SaveUserToEEPROM61
	NOP
;SMS_gyuri.c,308 :: 		for (i=0;i<10;i++){
	INFSNZ      SaveUserToEEPROM_i_L0+0, 1 
	INCF        SaveUserToEEPROM_i_L0+1, 1 
;SMS_gyuri.c,311 :: 		}
	GOTO        L_SaveUserToEEPROM58
L_SaveUserToEEPROM59:
;SMS_gyuri.c,314 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;SMS_gyuri.c,316 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
;SMS_gyuri.c,317 :: 		}
L_end_SaveUserToEEPROM:
	RETURN      0
; end of _SaveUserToEEPROM

_RemoveUserFromPhoneBook:

;SMS_gyuri.c,324 :: 		int RemoveUserFromPhoneBook(char *number){
;SMS_gyuri.c,327 :: 		char num[10] = "";
	CLRF        RemoveUserFromPhoneBook_num_L0+0 
	CLRF        RemoveUserFromPhoneBook_num_L0+1 
	CLRF        RemoveUserFromPhoneBook_num_L0+2 
	CLRF        RemoveUserFromPhoneBook_num_L0+3 
	CLRF        RemoveUserFromPhoneBook_num_L0+4 
	CLRF        RemoveUserFromPhoneBook_num_L0+5 
	CLRF        RemoveUserFromPhoneBook_num_L0+6 
	CLRF        RemoveUserFromPhoneBook_num_L0+7 
	CLRF        RemoveUserFromPhoneBook_num_L0+8 
	CLRF        RemoveUserFromPhoneBook_num_L0+9 
;SMS_gyuri.c,329 :: 		for (i=0;i<10;i++){
	CLRF        RemoveUserFromPhoneBook_i_L0+0 
	CLRF        RemoveUserFromPhoneBook_i_L0+1 
L_RemoveUserFromPhoneBook62:
	MOVLW       128
	XORWF       RemoveUserFromPhoneBook_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__RemoveUserFromPhoneBook276
	MOVLW       10
	SUBWF       RemoveUserFromPhoneBook_i_L0+0, 0 
L__RemoveUserFromPhoneBook276:
	BTFSC       STATUS+0, 0 
	GOTO        L_RemoveUserFromPhoneBook63
;SMS_gyuri.c,330 :: 		num[i] = *number++;
	MOVLW       RemoveUserFromPhoneBook_num_L0+0
	ADDWF       RemoveUserFromPhoneBook_i_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(RemoveUserFromPhoneBook_num_L0+0)
	ADDWFC      RemoveUserFromPhoneBook_i_L0+1, 0 
	MOVWF       FSR1H 
	MOVFF       FARG_RemoveUserFromPhoneBook_number+0, FSR0
	MOVFF       FARG_RemoveUserFromPhoneBook_number+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      FARG_RemoveUserFromPhoneBook_number+0, 1 
	INCF        FARG_RemoveUserFromPhoneBook_number+1, 1 
;SMS_gyuri.c,329 :: 		for (i=0;i<10;i++){
	INFSNZ      RemoveUserFromPhoneBook_i_L0+0, 1 
	INCF        RemoveUserFromPhoneBook_i_L0+1, 1 
;SMS_gyuri.c,331 :: 		}
	GOTO        L_RemoveUserFromPhoneBook62
L_RemoveUserFromPhoneBook63:
;SMS_gyuri.c,333 :: 		if (numberOfUsers == 1){
	MOVLW       0
	XORWF       _numberOfUsers+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__RemoveUserFromPhoneBook277
	MOVLW       1
	XORWF       _numberOfUsers+0, 0 
L__RemoveUserFromPhoneBook277:
	BTFSS       STATUS+0, 2 
	GOTO        L_RemoveUserFromPhoneBook65
;SMS_gyuri.c,334 :: 		strcpy(users[0],"");
	MOVLW       _users+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_users+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr14_SMS_gyuri+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr14_SMS_gyuri+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;SMS_gyuri.c,335 :: 		for (j=0;j<10;j++){
	CLRF        RemoveUserFromPhoneBook_j_L0+0 
	CLRF        RemoveUserFromPhoneBook_j_L0+1 
L_RemoveUserFromPhoneBook66:
	MOVLW       128
	XORWF       RemoveUserFromPhoneBook_j_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__RemoveUserFromPhoneBook278
	MOVLW       10
	SUBWF       RemoveUserFromPhoneBook_j_L0+0, 0 
L__RemoveUserFromPhoneBook278:
	BTFSC       STATUS+0, 0 
	GOTO        L_RemoveUserFromPhoneBook67
;SMS_gyuri.c,336 :: 		EEPROM_Write(USERS_ADDRESS + j,0xFF);
	MOVF        RemoveUserFromPhoneBook_j_L0+0, 0 
	ADDLW       176
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       255
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;SMS_gyuri.c,337 :: 		delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_RemoveUserFromPhoneBook69:
	DECFSZ      R13, 1, 1
	BRA         L_RemoveUserFromPhoneBook69
	DECFSZ      R12, 1, 1
	BRA         L_RemoveUserFromPhoneBook69
	NOP
;SMS_gyuri.c,335 :: 		for (j=0;j<10;j++){
	INFSNZ      RemoveUserFromPhoneBook_j_L0+0, 1 
	INCF        RemoveUserFromPhoneBook_j_L0+1, 1 
;SMS_gyuri.c,338 :: 		}
	GOTO        L_RemoveUserFromPhoneBook66
L_RemoveUserFromPhoneBook67:
;SMS_gyuri.c,339 :: 		delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_RemoveUserFromPhoneBook70:
	DECFSZ      R13, 1, 1
	BRA         L_RemoveUserFromPhoneBook70
	DECFSZ      R12, 1, 1
	BRA         L_RemoveUserFromPhoneBook70
	NOP
;SMS_gyuri.c,340 :: 		}else
	GOTO        L_RemoveUserFromPhoneBook71
L_RemoveUserFromPhoneBook65:
;SMS_gyuri.c,341 :: 		if (strstr(users[numberOfUsers-1],num) != 0){
	MOVLW       1
	SUBWF       _numberOfUsers+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      _numberOfUsers+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       RemoveUserFromPhoneBook_num_L0+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(RemoveUserFromPhoneBook_num_L0+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__RemoveUserFromPhoneBook279
	MOVLW       0
	XORWF       R0, 0 
L__RemoveUserFromPhoneBook279:
	BTFSC       STATUS+0, 2 
	GOTO        L_RemoveUserFromPhoneBook72
;SMS_gyuri.c,342 :: 		strcpy(users[numberOfUsers-1],"");
	MOVLW       1
	SUBWF       _numberOfUsers+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      _numberOfUsers+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 0 
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr15_SMS_gyuri+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr15_SMS_gyuri+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;SMS_gyuri.c,343 :: 		for (j=0;j<10;j++){
	CLRF        RemoveUserFromPhoneBook_j_L0+0 
	CLRF        RemoveUserFromPhoneBook_j_L0+1 
L_RemoveUserFromPhoneBook73:
	MOVLW       128
	XORWF       RemoveUserFromPhoneBook_j_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__RemoveUserFromPhoneBook280
	MOVLW       10
	SUBWF       RemoveUserFromPhoneBook_j_L0+0, 0 
L__RemoveUserFromPhoneBook280:
	BTFSC       STATUS+0, 0 
	GOTO        L_RemoveUserFromPhoneBook74
;SMS_gyuri.c,344 :: 		EEPROM_Write(((numberOfUsers-1) * 10) + USERS_ADDRESS + j,0xFF);
	DECF        _numberOfUsers+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       10
	MULWF       FARG_EEPROM_Write_address+0 
	MOVF        PRODL+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       176
	ADDWF       FARG_EEPROM_Write_address+0, 1 
	MOVF        RemoveUserFromPhoneBook_j_L0+0, 0 
	ADDWF       FARG_EEPROM_Write_address+0, 1 
	MOVLW       255
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;SMS_gyuri.c,345 :: 		delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_RemoveUserFromPhoneBook76:
	DECFSZ      R13, 1, 1
	BRA         L_RemoveUserFromPhoneBook76
	DECFSZ      R12, 1, 1
	BRA         L_RemoveUserFromPhoneBook76
	NOP
;SMS_gyuri.c,343 :: 		for (j=0;j<10;j++){
	INFSNZ      RemoveUserFromPhoneBook_j_L0+0, 1 
	INCF        RemoveUserFromPhoneBook_j_L0+1, 1 
;SMS_gyuri.c,346 :: 		}
	GOTO        L_RemoveUserFromPhoneBook73
L_RemoveUserFromPhoneBook74:
;SMS_gyuri.c,347 :: 		}else{
	GOTO        L_RemoveUserFromPhoneBook77
L_RemoveUserFromPhoneBook72:
;SMS_gyuri.c,349 :: 		for (i=0;i<numberOfUsers;i++){
	CLRF        RemoveUserFromPhoneBook_i_L0+0 
	CLRF        RemoveUserFromPhoneBook_i_L0+1 
L_RemoveUserFromPhoneBook78:
	MOVLW       128
	XORWF       RemoveUserFromPhoneBook_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _numberOfUsers+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__RemoveUserFromPhoneBook281
	MOVF        _numberOfUsers+0, 0 
	SUBWF       RemoveUserFromPhoneBook_i_L0+0, 0 
L__RemoveUserFromPhoneBook281:
	BTFSC       STATUS+0, 0 
	GOTO        L_RemoveUserFromPhoneBook79
;SMS_gyuri.c,350 :: 		if (strstr(users[i],num) != 0){
	MOVLW       10
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        RemoveUserFromPhoneBook_i_L0+0, 0 
	MOVWF       R4 
	MOVF        RemoveUserFromPhoneBook_i_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVLW       RemoveUserFromPhoneBook_num_L0+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(RemoveUserFromPhoneBook_num_L0+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__RemoveUserFromPhoneBook282
	MOVLW       0
	XORWF       R0, 0 
L__RemoveUserFromPhoneBook282:
	BTFSC       STATUS+0, 2 
	GOTO        L_RemoveUserFromPhoneBook81
;SMS_gyuri.c,351 :: 		UART1_Write_Text(users[numberOfUsers-1]);
	MOVLW       1
	SUBWF       _numberOfUsers+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      _numberOfUsers+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,353 :: 		strcpy(users[i],users[numberOfUsers-1]);
	MOVLW       10
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        RemoveUserFromPhoneBook_i_L0+0, 0 
	MOVWF       R4 
	MOVF        RemoveUserFromPhoneBook_i_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 0 
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_strcpy_to+1 
	MOVLW       1
	SUBWF       _numberOfUsers+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      _numberOfUsers+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;SMS_gyuri.c,355 :: 		for (j=0;j<10;j++){
	CLRF        RemoveUserFromPhoneBook_j_L0+0 
	CLRF        RemoveUserFromPhoneBook_j_L0+1 
L_RemoveUserFromPhoneBook82:
	MOVLW       128
	XORWF       RemoveUserFromPhoneBook_j_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__RemoveUserFromPhoneBook283
	MOVLW       10
	SUBWF       RemoveUserFromPhoneBook_j_L0+0, 0 
L__RemoveUserFromPhoneBook283:
	BTFSC       STATUS+0, 0 
	GOTO        L_RemoveUserFromPhoneBook83
;SMS_gyuri.c,356 :: 		EEPROM_Write((i * 10) + USERS_ADDRESS + j,users[i][j]);
	MOVLW       10
	MULWF       RemoveUserFromPhoneBook_i_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       176
	ADDWF       FARG_EEPROM_Write_address+0, 1 
	MOVF        RemoveUserFromPhoneBook_j_L0+0, 0 
	ADDWF       FARG_EEPROM_Write_address+0, 1 
	MOVLW       10
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        RemoveUserFromPhoneBook_i_L0+0, 0 
	MOVWF       R4 
	MOVF        RemoveUserFromPhoneBook_i_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 1 
	MOVF        RemoveUserFromPhoneBook_j_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVF        RemoveUserFromPhoneBook_j_L0+1, 0 
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;SMS_gyuri.c,357 :: 		delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_RemoveUserFromPhoneBook85:
	DECFSZ      R13, 1, 1
	BRA         L_RemoveUserFromPhoneBook85
	DECFSZ      R12, 1, 1
	BRA         L_RemoveUserFromPhoneBook85
	NOP
;SMS_gyuri.c,355 :: 		for (j=0;j<10;j++){
	INFSNZ      RemoveUserFromPhoneBook_j_L0+0, 1 
	INCF        RemoveUserFromPhoneBook_j_L0+1, 1 
;SMS_gyuri.c,358 :: 		}
	GOTO        L_RemoveUserFromPhoneBook82
L_RemoveUserFromPhoneBook83:
;SMS_gyuri.c,360 :: 		}
L_RemoveUserFromPhoneBook81:
;SMS_gyuri.c,349 :: 		for (i=0;i<numberOfUsers;i++){
	INFSNZ      RemoveUserFromPhoneBook_i_L0+0, 1 
	INCF        RemoveUserFromPhoneBook_i_L0+1, 1 
;SMS_gyuri.c,361 :: 		}
	GOTO        L_RemoveUserFromPhoneBook78
L_RemoveUserFromPhoneBook79:
;SMS_gyuri.c,362 :: 		strcpy(users[numberOfUsers-1],"");
	MOVLW       1
	SUBWF       _numberOfUsers+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      _numberOfUsers+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 0 
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr16_SMS_gyuri+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr16_SMS_gyuri+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;SMS_gyuri.c,363 :: 		for (j=0;j<10;j++){
	CLRF        RemoveUserFromPhoneBook_j_L0+0 
	CLRF        RemoveUserFromPhoneBook_j_L0+1 
L_RemoveUserFromPhoneBook86:
	MOVLW       128
	XORWF       RemoveUserFromPhoneBook_j_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__RemoveUserFromPhoneBook284
	MOVLW       10
	SUBWF       RemoveUserFromPhoneBook_j_L0+0, 0 
L__RemoveUserFromPhoneBook284:
	BTFSC       STATUS+0, 0 
	GOTO        L_RemoveUserFromPhoneBook87
;SMS_gyuri.c,364 :: 		EEPROM_Write(((numberOfUsers-1) * 10) + USERS_ADDRESS + j,0xFF);
	DECF        _numberOfUsers+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       10
	MULWF       FARG_EEPROM_Write_address+0 
	MOVF        PRODL+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       176
	ADDWF       FARG_EEPROM_Write_address+0, 1 
	MOVF        RemoveUserFromPhoneBook_j_L0+0, 0 
	ADDWF       FARG_EEPROM_Write_address+0, 1 
	MOVLW       255
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;SMS_gyuri.c,365 :: 		delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_RemoveUserFromPhoneBook89:
	DECFSZ      R13, 1, 1
	BRA         L_RemoveUserFromPhoneBook89
	DECFSZ      R12, 1, 1
	BRA         L_RemoveUserFromPhoneBook89
	NOP
;SMS_gyuri.c,363 :: 		for (j=0;j<10;j++){
	INFSNZ      RemoveUserFromPhoneBook_j_L0+0, 1 
	INCF        RemoveUserFromPhoneBook_j_L0+1, 1 
;SMS_gyuri.c,366 :: 		}
	GOTO        L_RemoveUserFromPhoneBook86
L_RemoveUserFromPhoneBook87:
;SMS_gyuri.c,367 :: 		}
L_RemoveUserFromPhoneBook77:
L_RemoveUserFromPhoneBook71:
;SMS_gyuri.c,370 :: 		numberOfUsers = numberOfUsers - 1;
	MOVLW       1
	SUBWF       _numberOfUsers+0, 1 
	MOVLW       0
	SUBWFB      _numberOfUsers+1, 1 
;SMS_gyuri.c,372 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
;SMS_gyuri.c,373 :: 		}
L_end_RemoveUserFromPhoneBook:
	RETURN      0
; end of _RemoveUserFromPhoneBook

_SaveUserToPhoneBook:

;SMS_gyuri.c,375 :: 		int SaveUserToPhoneBook(char *number){
;SMS_gyuri.c,380 :: 		if (numberOfUsers <= MAXUSERS){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _numberOfUsers+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SaveUserToPhoneBook286
	MOVF        _numberOfUsers+0, 0 
	SUBLW       10
L__SaveUserToPhoneBook286:
	BTFSS       STATUS+0, 0 
	GOTO        L_SaveUserToPhoneBook90
;SMS_gyuri.c,382 :: 		SaveUserToEEPROM(number);
	MOVF        FARG_SaveUserToPhoneBook_number+0, 0 
	MOVWF       FARG_SaveUserToEEPROM_number+0 
	MOVF        FARG_SaveUserToPhoneBook_number+1, 0 
	MOVWF       FARG_SaveUserToEEPROM_number+1 
	CALL        _SaveUserToEEPROM+0, 0
;SMS_gyuri.c,384 :: 		for (i=0;i<10;i++){
	CLRF        SaveUserToPhoneBook_i_L0+0 
	CLRF        SaveUserToPhoneBook_i_L0+1 
L_SaveUserToPhoneBook91:
	MOVLW       128
	XORWF       SaveUserToPhoneBook_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SaveUserToPhoneBook287
	MOVLW       10
	SUBWF       SaveUserToPhoneBook_i_L0+0, 0 
L__SaveUserToPhoneBook287:
	BTFSC       STATUS+0, 0 
	GOTO        L_SaveUserToPhoneBook92
;SMS_gyuri.c,385 :: 		users[numberOfUsers][i] = *number++;
	MOVLW       10
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _numberOfUsers+0, 0 
	MOVWF       R4 
	MOVF        _numberOfUsers+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 1 
	MOVF        SaveUserToPhoneBook_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVF        SaveUserToPhoneBook_i_L0+1, 0 
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVFF       FARG_SaveUserToPhoneBook_number+0, FSR0
	MOVFF       FARG_SaveUserToPhoneBook_number+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      FARG_SaveUserToPhoneBook_number+0, 1 
	INCF        FARG_SaveUserToPhoneBook_number+1, 1 
;SMS_gyuri.c,384 :: 		for (i=0;i<10;i++){
	INFSNZ      SaveUserToPhoneBook_i_L0+0, 1 
	INCF        SaveUserToPhoneBook_i_L0+1, 1 
;SMS_gyuri.c,386 :: 		}
	GOTO        L_SaveUserToPhoneBook91
L_SaveUserToPhoneBook92:
;SMS_gyuri.c,389 :: 		numberOfUsers += 1;
	INFSNZ      _numberOfUsers+0, 1 
	INCF        _numberOfUsers+1, 1 
;SMS_gyuri.c,391 :: 		IntToStr(numberOfUsers,msg);
	MOVF        _numberOfUsers+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _numberOfUsers+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _msg+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;SMS_gyuri.c,392 :: 		SaveConfigToEEPROM();
	CALL        _SaveConfigToEEPROM+0, 0
;SMS_gyuri.c,394 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	GOTO        L_end_SaveUserToPhoneBook
;SMS_gyuri.c,395 :: 		}
L_SaveUserToPhoneBook90:
;SMS_gyuri.c,397 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;SMS_gyuri.c,398 :: 		}
L_end_SaveUserToPhoneBook:
	RETURN      0
; end of _SaveUserToPhoneBook

_SmsCommands:

;SMS_gyuri.c,400 :: 		void SmsCommands(){
;SMS_gyuri.c,404 :: 		if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,UNREAD)) != 0)
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _UNREAD+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_UNREAD+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_UNREAD+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands289
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands289:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands94
;SMS_gyuri.c,406 :: 		sms = 1;
	MOVLW       1
	MOVWF       _sms+0 
;SMS_gyuri.c,407 :: 		isDataProcessed = FALSE;
	CLRF        _isDataProcessed+0 
;SMS_gyuri.c,411 :: 		for (i=0;i<strlen(interruptStreamBuffer);i++)
	CLRF        _i+0 
	CLRF        _i+1 
L_SmsCommands95:
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R1, 0 
	SUBWF       _i+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands290
	MOVF        R0, 0 
	SUBWF       _i+0, 0 
L__SmsCommands290:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands96
;SMS_gyuri.c,413 :: 		if (interruptStreamBuffer[i] == '+' && interruptStreamBuffer[i+1] == '3' && interruptStreamBuffer[i+2] == '6')
	MOVLW       _interruptStreamBuffer+0
	ADDWF       _i+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	ADDWFC      _i+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       43
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands100
	MOVLW       1
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _interruptStreamBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands100
	MOVLW       2
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _interruptStreamBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       54
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands100
L__SmsCommands244:
;SMS_gyuri.c,415 :: 		for (j=0;j<9;j++)
	CLRF        _j+0 
	CLRF        _j+1 
L_SmsCommands101:
	MOVLW       128
	XORWF       _j+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands291
	MOVLW       9
	SUBWF       _j+0, 0 
L__SmsCommands291:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands102
;SMS_gyuri.c,416 :: 		phoneBuffer[j] = interruptStreamBuffer[i+3+j];
	MOVLW       _phoneBuffer+0
	ADDWF       _j+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_phoneBuffer+0)
	ADDWFC      _j+1, 0 
	MOVWF       FSR1H 
	MOVLW       3
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVF        _j+0, 0 
	ADDWF       R0, 1 
	MOVF        _j+1, 0 
	ADDWFC      R1, 1 
	MOVLW       _interruptStreamBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;SMS_gyuri.c,415 :: 		for (j=0;j<9;j++)
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;SMS_gyuri.c,416 :: 		phoneBuffer[j] = interruptStreamBuffer[i+3+j];
	GOTO        L_SmsCommands101
L_SmsCommands102:
;SMS_gyuri.c,417 :: 		}
L_SmsCommands100:
;SMS_gyuri.c,411 :: 		for (i=0;i<strlen(interruptStreamBuffer);i++)
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;SMS_gyuri.c,418 :: 		}
	GOTO        L_SmsCommands95
L_SmsCommands96:
;SMS_gyuri.c,421 :: 		delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_SmsCommands104:
	DECFSZ      R13, 1, 1
	BRA         L_SmsCommands104
	DECFSZ      R12, 1, 1
	BRA         L_SmsCommands104
	DECFSZ      R11, 1, 1
	BRA         L_SmsCommands104
	NOP
	NOP
;SMS_gyuri.c,423 :: 		if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,ADMINC)) != 0)
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ADMINC+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ADMINC+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ADMINC+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands292
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands292:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands105
;SMS_gyuri.c,425 :: 		if (strcmp(admin,phoneBuffer) == 0)
	MOVLW       _admin+0
	MOVWF       FARG_strcmp_s1+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_strcmp_s1+1 
	MOVLW       _phoneBuffer+0
	MOVWF       FARG_strcmp_s2+0 
	MOVLW       hi_addr(_phoneBuffer+0)
	MOVWF       FARG_strcmp_s2+1 
	CALL        _strcmp+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands293
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands293:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands106
;SMS_gyuri.c,427 :: 		SendSms(admin,CopyConst2Ram(msg,ERROR_), "");
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ERROR_+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr17_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr17_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,428 :: 		}else
	GOTO        L_SmsCommands107
L_SmsCommands106:
;SMS_gyuri.c,432 :: 		SendSms(admin,CopyConst2Ram(msg,PREVADMIN), phoneBuffer);
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _PREVADMIN+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_PREVADMIN+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_PREVADMIN+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       _phoneBuffer+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(_phoneBuffer+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,434 :: 		SendSms(phoneBuffer,CopyConst2Ram(msg,NEWADMIN), admin);
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _NEWADMIN+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_NEWADMIN+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_NEWADMIN+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _phoneBuffer+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_phoneBuffer+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,436 :: 		strcpy(admin,phoneBuffer);
	MOVLW       _admin+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       _phoneBuffer+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(_phoneBuffer+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;SMS_gyuri.c,438 :: 		for (i=0;i<10;i++){
	CLRF        SmsCommands_i_L3+0 
	CLRF        SmsCommands_i_L3+1 
L_SmsCommands108:
	MOVLW       128
	XORWF       SmsCommands_i_L3+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands294
	MOVLW       10
	SUBWF       SmsCommands_i_L3+0, 0 
L__SmsCommands294:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands109
;SMS_gyuri.c,439 :: 		EEPROM_Write(ADMIN_ADDRESS+i,admin[i]);
	MOVF        SmsCommands_i_L3+0, 0 
	ADDLW       160
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       _admin+0
	ADDWF       SmsCommands_i_L3+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_admin+0)
	ADDWFC      SmsCommands_i_L3+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;SMS_gyuri.c,440 :: 		delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_SmsCommands111:
	DECFSZ      R13, 1, 1
	BRA         L_SmsCommands111
	DECFSZ      R12, 1, 1
	BRA         L_SmsCommands111
	NOP
;SMS_gyuri.c,438 :: 		for (i=0;i<10;i++){
	INFSNZ      SmsCommands_i_L3+0, 1 
	INCF        SmsCommands_i_L3+1, 1 
;SMS_gyuri.c,441 :: 		}
	GOTO        L_SmsCommands108
L_SmsCommands109:
;SMS_gyuri.c,443 :: 		}
L_SmsCommands107:
;SMS_gyuri.c,444 :: 		isDataProcessed = TRUE;
	MOVLW       1
	MOVWF       _isDataProcessed+0 
;SMS_gyuri.c,446 :: 		}
L_SmsCommands105:
;SMS_gyuri.c,450 :: 		if ((strstr(admin,phoneBuffer) != 0) && isDataProcessed == FALSE)
	MOVLW       _admin+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       _phoneBuffer+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(_phoneBuffer+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands295
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands295:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands114
	MOVF        _isDataProcessed+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands114
L__SmsCommands243:
;SMS_gyuri.c,452 :: 		short isConfigChanged = 0;
	CLRF        SmsCommands_isConfigChanged_L2+0 
;SMS_gyuri.c,453 :: 		if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,CODE)) != 0 )
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _CODE+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_CODE+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_CODE+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands296
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands296:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands115
;SMS_gyuri.c,457 :: 		p1 = strstr(interruptStreamBuffer,CopyConst2Ram(msg,CODE));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _CODE+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_CODE+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_CODE+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
;SMS_gyuri.c,458 :: 		strtok(p1,";");
	MOVF        R0, 0 
	MOVWF       FARG_strtok_s1+0 
	MOVF        R1, 0 
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr18_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr18_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
;SMS_gyuri.c,459 :: 		p2 = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr19_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr19_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       SmsCommands_p2_L3+0 
	MOVF        R1, 0 
	MOVWF       SmsCommands_p2_L3+1 
;SMS_gyuri.c,461 :: 		if (strlen(p2)<6)
	MOVF        R0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        R1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       128
	XORWF       R1, 0 
	MOVWF       R2 
	MOVLW       128
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands297
	MOVLW       6
	SUBWF       R0, 0 
L__SmsCommands297:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands116
;SMS_gyuri.c,462 :: 		strcpy(countryCode,p2);
	MOVLW       _countryCode+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_countryCode+0)
	MOVWF       FARG_strcpy_to+1 
	MOVF        SmsCommands_p2_L3+0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        SmsCommands_p2_L3+1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
L_SmsCommands116:
;SMS_gyuri.c,464 :: 		SendSms(admin,CopyConst2Ram(msg,OK),"");
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _OK+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr20_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr20_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,466 :: 		isDataProcessed = TRUE;
	MOVLW       1
	MOVWF       _isDataProcessed+0 
;SMS_gyuri.c,467 :: 		isConfigChanged = TRUE;
	MOVLW       1
	MOVWF       SmsCommands_isConfigChanged_L2+0 
;SMS_gyuri.c,468 :: 		}
L_SmsCommands115:
;SMS_gyuri.c,471 :: 		if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,REPEAT_)) != 0 )
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _REPEAT_+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_REPEAT_+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_REPEAT_+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands298
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands298:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands117
;SMS_gyuri.c,474 :: 		p1 = strstr(interruptStreamBuffer,CopyConst2Ram(msg,REPEAT_));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _REPEAT_+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_REPEAT_+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_REPEAT_+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
;SMS_gyuri.c,476 :: 		strtok(p1,";");
	MOVF        R0, 0 
	MOVWF       FARG_strtok_s1+0 
	MOVF        R1, 0 
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr21_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr21_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
;SMS_gyuri.c,477 :: 		repeat = atoi(strtok(0,";"));
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr22_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr22_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        R1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _repeat+0 
	MOVF        R1, 0 
	MOVWF       _repeat+1 
;SMS_gyuri.c,478 :: 		if (!(repeat == 0 || repeat == 1)){
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands299
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands299:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands119
	MOVLW       0
	XORWF       _repeat+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands300
	MOVLW       1
	XORWF       _repeat+0, 0 
L__SmsCommands300:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands119
	CLRF        R0 
	GOTO        L_SmsCommands118
L_SmsCommands119:
	MOVLW       1
	MOVWF       R0 
L_SmsCommands118:
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands120
;SMS_gyuri.c,479 :: 		repeat = 0;
	CLRF        _repeat+0 
	CLRF        _repeat+1 
;SMS_gyuri.c,480 :: 		SendSms(admin,CopyConst2Ram(msg,ERROR_),"");
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ERROR_+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr23_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr23_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,481 :: 		}else{
	GOTO        L_SmsCommands121
L_SmsCommands120:
;SMS_gyuri.c,482 :: 		wait = atoi(strtok(0,";"));
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr24_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr24_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        R1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _wait+0 
	MOVF        R1, 0 
	MOVWF       _wait+1 
;SMS_gyuri.c,483 :: 		if (wait == 0){
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands301
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands301:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands122
;SMS_gyuri.c,484 :: 		repeat = 0;
	CLRF        _repeat+0 
	CLRF        _repeat+1 
;SMS_gyuri.c,485 :: 		SendSms(admin,CopyConst2Ram(msg,ERROR_),"");
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ERROR_+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr25_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr25_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,486 :: 		}else{
	GOTO        L_SmsCommands123
L_SmsCommands122:
;SMS_gyuri.c,487 :: 		SendSms(admin,CopyConst2Ram(msg,OK),"");
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _OK+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr26_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr26_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,488 :: 		}
L_SmsCommands123:
;SMS_gyuri.c,489 :: 		}
L_SmsCommands121:
;SMS_gyuri.c,491 :: 		isConfigChanged = TRUE;
	MOVLW       1
	MOVWF       SmsCommands_isConfigChanged_L2+0 
;SMS_gyuri.c,492 :: 		}
L_SmsCommands117:
;SMS_gyuri.c,494 :: 		if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,MODE_)) != 0 )
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _MODE_+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_MODE_+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_MODE_+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands302
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands302:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands124
;SMS_gyuri.c,500 :: 		p1 = strstr(interruptStreamBuffer,CopyConst2Ram(msg,MODE_));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _MODE_+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_MODE_+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_MODE_+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
;SMS_gyuri.c,501 :: 		p2 = strtok(p1,";");
	MOVF        R0, 0 
	MOVWF       FARG_strtok_s1+0 
	MOVF        R1, 0 
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr27_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr27_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
;SMS_gyuri.c,502 :: 		p2 = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr28_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr28_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
;SMS_gyuri.c,504 :: 		mod = atoi(p2);
	MOVF        R0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        R1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       SmsCommands_mod_L3+0 
	MOVF        R1, 0 
	MOVWF       SmsCommands_mod_L3+1 
;SMS_gyuri.c,506 :: 		if (mod == 1){
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands303
	MOVLW       1
	XORWF       R0, 0 
L__SmsCommands303:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands125
;SMS_gyuri.c,507 :: 		mode = mod;
	MOVF        SmsCommands_mod_L3+0, 0 
	MOVWF       _mode+0 
	MOVF        SmsCommands_mod_L3+1, 0 
	MOVWF       _mode+1 
;SMS_gyuri.c,508 :: 		mode_1_delay = atoi(strtok(0,";"));
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr29_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr29_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        R1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _mode_1_delay+0 
	MOVF        R1, 0 
	MOVWF       _mode_1_delay+1 
;SMS_gyuri.c,509 :: 		if (mode_1_delay == 0){
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands304
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands304:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands126
;SMS_gyuri.c,510 :: 		mode_1_delay = 1000;
	MOVLW       232
	MOVWF       _mode_1_delay+0 
	MOVLW       3
	MOVWF       _mode_1_delay+1 
;SMS_gyuri.c,511 :: 		SendSms(admin,CopyConst2Ram(msg,ERROR_),"");
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ERROR_+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr30_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr30_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,512 :: 		}else{
	GOTO        L_SmsCommands127
L_SmsCommands126:
;SMS_gyuri.c,513 :: 		SendSms(admin,CopyConst2Ram(msg,OK),"");
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _OK+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr31_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr31_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,514 :: 		}
L_SmsCommands127:
;SMS_gyuri.c,516 :: 		}else
	GOTO        L_SmsCommands128
L_SmsCommands125:
;SMS_gyuri.c,518 :: 		if (mod == 2){
	MOVLW       0
	XORWF       SmsCommands_mod_L3+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands305
	MOVLW       2
	XORWF       SmsCommands_mod_L3+0, 0 
L__SmsCommands305:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands129
;SMS_gyuri.c,519 :: 		mode = mod;
	MOVF        SmsCommands_mod_L3+0, 0 
	MOVWF       _mode+0 
	MOVF        SmsCommands_mod_L3+1, 0 
	MOVWF       _mode+1 
;SMS_gyuri.c,520 :: 		impulses = atoi(strtok(0,";"));
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr32_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr32_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        R1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _impulses+0 
	MOVF        R1, 0 
	MOVWF       _impulses+1 
;SMS_gyuri.c,521 :: 		if (impulses == 0){
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands306
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands306:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands130
;SMS_gyuri.c,522 :: 		impulses = 1;
	MOVLW       1
	MOVWF       _impulses+0 
	MOVLW       0
	MOVWF       _impulses+1 
;SMS_gyuri.c,523 :: 		}
L_SmsCommands130:
;SMS_gyuri.c,524 :: 		mode_2_delay = atoi(strtok(0,";"));
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr33_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr33_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        R1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _mode_2_delay+0 
	MOVF        R1, 0 
	MOVWF       _mode_2_delay+1 
;SMS_gyuri.c,525 :: 		if (mode_2_delay == 0){
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands307
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands307:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands131
;SMS_gyuri.c,526 :: 		mod = 1;
	MOVLW       1
	MOVWF       SmsCommands_mod_L3+0 
	MOVLW       0
	MOVWF       SmsCommands_mod_L3+1 
;SMS_gyuri.c,527 :: 		SendSms(admin,CopyConst2Ram(msg,ERROR_),"");
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ERROR_+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr34_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr34_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,528 :: 		}else SendSms(admin,CopyConst2Ram(msg,OK),"");
	GOTO        L_SmsCommands132
L_SmsCommands131:
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _OK+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr35_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr35_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
L_SmsCommands132:
;SMS_gyuri.c,531 :: 		}else
	GOTO        L_SmsCommands133
L_SmsCommands129:
;SMS_gyuri.c,533 :: 		if (mod == 3){
	MOVLW       0
	XORWF       SmsCommands_mod_L3+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands308
	MOVLW       3
	XORWF       SmsCommands_mod_L3+0, 0 
L__SmsCommands308:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands134
;SMS_gyuri.c,534 :: 		mode = mod;
	MOVF        SmsCommands_mod_L3+0, 0 
	MOVWF       _mode+0 
	MOVF        SmsCommands_mod_L3+1, 0 
	MOVWF       _mode+1 
;SMS_gyuri.c,535 :: 		SendSms(admin,CopyConst2Ram(msg,OK),"");
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _OK+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr36_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr36_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,536 :: 		}else SendSms(admin,CopyConst2Ram(msg,ERROR_),"");
	GOTO        L_SmsCommands135
L_SmsCommands134:
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ERROR_+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ERROR_+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr37_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr37_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
L_SmsCommands135:
L_SmsCommands133:
L_SmsCommands128:
;SMS_gyuri.c,538 :: 		isConfigChanged = TRUE;
	MOVLW       1
	MOVWF       SmsCommands_isConfigChanged_L2+0 
;SMS_gyuri.c,539 :: 		}
L_SmsCommands124:
;SMS_gyuri.c,541 :: 		if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,ADD)) != 0 )
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ADD+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ADD+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ADD+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands309
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands309:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands136
;SMS_gyuri.c,545 :: 		int error = 3,i=0;
	MOVLW       3
	MOVWF       SmsCommands_error_L3+0 
	MOVLW       0
	MOVWF       SmsCommands_error_L3+1 
;SMS_gyuri.c,547 :: 		p1 = strstr(interruptStreamBuffer,CopyConst2Ram(msg,ADD));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ADD+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ADD+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ADD+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       SmsCommands_p1_L3_L3_L3_L3+0 
	MOVF        R1, 0 
	MOVWF       SmsCommands_p1_L3_L3_L3_L3+1 
;SMS_gyuri.c,549 :: 		p2 = strtok(p1,";");
	MOVF        R0, 0 
	MOVWF       FARG_strtok_s1+0 
	MOVF        R1, 0 
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr38_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr38_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       SmsCommands_p2_L3_L3_L3+0 
	MOVF        R1, 0 
	MOVWF       SmsCommands_p2_L3_L3_L3+1 
;SMS_gyuri.c,553 :: 		while( p2 != 0 ){
L_SmsCommands137:
	MOVLW       0
	XORWF       SmsCommands_p2_L3_L3_L3+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands310
	MOVLW       0
	XORWF       SmsCommands_p2_L3_L3_L3+0, 0 
L__SmsCommands310:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands138
;SMS_gyuri.c,556 :: 		p1 = p2;
	MOVF        SmsCommands_p2_L3_L3_L3+0, 0 
	MOVWF       SmsCommands_p1_L3_L3_L3_L3+0 
	MOVF        SmsCommands_p2_L3_L3_L3+1, 0 
	MOVWF       SmsCommands_p1_L3_L3_L3_L3+1 
;SMS_gyuri.c,558 :: 		for (j=0; j<6; j++){
	CLRF        SmsCommands_j_L4+0 
	CLRF        SmsCommands_j_L4+1 
L_SmsCommands139:
	MOVLW       128
	XORWF       SmsCommands_j_L4+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands311
	MOVLW       6
	SUBWF       SmsCommands_j_L4+0, 0 
L__SmsCommands311:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands140
;SMS_gyuri.c,559 :: 		if (!isdigit(*p1++)){
	MOVF        SmsCommands_p1_L3_L3_L3_L3+0, 0 
	MOVWF       R0 
	MOVF        SmsCommands_p1_L3_L3_L3_L3+1, 0 
	MOVWF       R1 
	INFSNZ      SmsCommands_p1_L3_L3_L3_L3+0, 1 
	INCF        SmsCommands_p1_L3_L3_L3_L3+1, 1 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_isdigit_character+0 
	CALL        _isdigit+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands142
;SMS_gyuri.c,560 :: 		break;
	GOTO        L_SmsCommands140
;SMS_gyuri.c,561 :: 		}
L_SmsCommands142:
;SMS_gyuri.c,558 :: 		for (j=0; j<6; j++){
	INFSNZ      SmsCommands_j_L4+0, 1 
	INCF        SmsCommands_j_L4+1, 1 
;SMS_gyuri.c,562 :: 		}
	GOTO        L_SmsCommands139
L_SmsCommands140:
;SMS_gyuri.c,565 :: 		if (j >= 4 && strlen(p2) < 10){
	MOVLW       128
	XORWF       SmsCommands_j_L4+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands312
	MOVLW       4
	SUBWF       SmsCommands_j_L4+0, 0 
L__SmsCommands312:
	BTFSS       STATUS+0, 0 
	GOTO        L_SmsCommands145
	MOVF        SmsCommands_p2_L3_L3_L3+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        SmsCommands_p2_L3_L3_L3+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       128
	XORWF       R1, 0 
	MOVWF       R2 
	MOVLW       128
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands313
	MOVLW       10
	SUBWF       R0, 0 
L__SmsCommands313:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands145
L__SmsCommands242:
;SMS_gyuri.c,566 :: 		for (k=0;k<numberOfUsers;k++){
	CLRF        SmsCommands_k_L4+0 
	CLRF        SmsCommands_k_L4+1 
L_SmsCommands146:
	MOVLW       128
	XORWF       SmsCommands_k_L4+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _numberOfUsers+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands314
	MOVF        _numberOfUsers+0, 0 
	SUBWF       SmsCommands_k_L4+0, 0 
L__SmsCommands314:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands147
;SMS_gyuri.c,567 :: 		if (strstr(users[k],p2) != 0){
	MOVLW       10
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        SmsCommands_k_L4+0, 0 
	MOVWF       R4 
	MOVF        SmsCommands_k_L4+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVF        SmsCommands_p2_L3_L3_L3+0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        SmsCommands_p2_L3_L3_L3+1, 0 
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands315
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands315:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands149
;SMS_gyuri.c,568 :: 		error = 3;
	MOVLW       3
	MOVWF       SmsCommands_error_L3+0 
	MOVLW       0
	MOVWF       SmsCommands_error_L3+1 
;SMS_gyuri.c,569 :: 		break;
	GOTO        L_SmsCommands147
;SMS_gyuri.c,570 :: 		}
L_SmsCommands149:
;SMS_gyuri.c,566 :: 		for (k=0;k<numberOfUsers;k++){
	INFSNZ      SmsCommands_k_L4+0, 1 
	INCF        SmsCommands_k_L4+1, 1 
;SMS_gyuri.c,571 :: 		}
	GOTO        L_SmsCommands146
L_SmsCommands147:
;SMS_gyuri.c,572 :: 		if (strstr(admin,p2) != 0) error = 3;
	MOVLW       _admin+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_strstr_s1+1 
	MOVF        SmsCommands_p2_L3_L3_L3+0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        SmsCommands_p2_L3_L3_L3+1, 0 
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands316
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands316:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands150
	MOVLW       3
	MOVWF       SmsCommands_error_L3+0 
	MOVLW       0
	MOVWF       SmsCommands_error_L3+1 
L_SmsCommands150:
;SMS_gyuri.c,573 :: 		if (error == 0) break;
	MOVLW       0
	XORWF       SmsCommands_error_L3+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands317
	MOVLW       0
	XORWF       SmsCommands_error_L3+0, 0 
L__SmsCommands317:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands151
	GOTO        L_SmsCommands138
L_SmsCommands151:
;SMS_gyuri.c,574 :: 		error = SaveUserToPhoneBook(p2);
	MOVF        SmsCommands_p2_L3_L3_L3+0, 0 
	MOVWF       FARG_SaveUserToPhoneBook_number+0 
	MOVF        SmsCommands_p2_L3_L3_L3+1, 0 
	MOVWF       FARG_SaveUserToPhoneBook_number+1 
	CALL        _SaveUserToPhoneBook+0, 0
	MOVF        R0, 0 
	MOVWF       SmsCommands_error_L3+0 
	MOVF        R1, 0 
	MOVWF       SmsCommands_error_L3+1 
;SMS_gyuri.c,576 :: 		}
L_SmsCommands145:
;SMS_gyuri.c,578 :: 		p2 = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr39_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr39_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       SmsCommands_p2_L3_L3_L3+0 
	MOVF        R1, 0 
	MOVWF       SmsCommands_p2_L3_L3_L3+1 
;SMS_gyuri.c,581 :: 		}
	GOTO        L_SmsCommands137
L_SmsCommands138:
;SMS_gyuri.c,583 :: 		if (error == 0) SendSms(admin,CopyConst2Ram(msg,USERLIM),"");
	MOVLW       0
	XORWF       SmsCommands_error_L3+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands318
	MOVLW       0
	XORWF       SmsCommands_error_L3+0, 0 
L__SmsCommands318:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands152
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _USERLIM+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_USERLIM+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_USERLIM+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr40_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr40_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
L_SmsCommands152:
;SMS_gyuri.c,584 :: 		if (error == 1) SendSms(admin,CopyConst2Ram(msg,USERADD),"");
	MOVLW       0
	XORWF       SmsCommands_error_L3+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands319
	MOVLW       1
	XORWF       SmsCommands_error_L3+0, 0 
L__SmsCommands319:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands153
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _USERADD+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_USERADD+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_USERADD+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr41_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr41_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
L_SmsCommands153:
;SMS_gyuri.c,585 :: 		if (error == 3) SendSms(admin,CopyConst2Ram(msg,USERERR),"");
	MOVLW       0
	XORWF       SmsCommands_error_L3+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands320
	MOVLW       3
	XORWF       SmsCommands_error_L3+0, 0 
L__SmsCommands320:
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands154
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _USERERR+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_USERERR+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_USERERR+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr42_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr42_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
L_SmsCommands154:
;SMS_gyuri.c,587 :: 		isDataProcessed = TRUE;
	MOVLW       1
	MOVWF       _isDataProcessed+0 
;SMS_gyuri.c,589 :: 		}
L_SmsCommands136:
;SMS_gyuri.c,591 :: 		if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,DEL)) != 0 )
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _DEL+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_DEL+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_DEL+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands321
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands321:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands155
;SMS_gyuri.c,595 :: 		int i = 0;
;SMS_gyuri.c,597 :: 		p1 = strstr(interruptStreamBuffer,CopyConst2Ram(msg,DEL));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _DEL+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_DEL+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_DEL+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVF        R0, 0 
	MOVWF       SmsCommands_p1_L3_L3_L3_L3_L3+0 
	MOVF        R1, 0 
	MOVWF       SmsCommands_p1_L3_L3_L3_L3_L3+1 
;SMS_gyuri.c,599 :: 		p2 = strtok(p1,";");
	MOVF        R0, 0 
	MOVWF       FARG_strtok_s1+0 
	MOVF        R1, 0 
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr43_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr43_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       SmsCommands_p2_L3_L3_L3_L3+0 
	MOVF        R1, 0 
	MOVWF       SmsCommands_p2_L3_L3_L3_L3+1 
;SMS_gyuri.c,601 :: 		while( p2 != 0 ){
L_SmsCommands156:
	MOVLW       0
	XORWF       SmsCommands_p2_L3_L3_L3_L3+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands322
	MOVLW       0
	XORWF       SmsCommands_p2_L3_L3_L3_L3+0, 0 
L__SmsCommands322:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands157
;SMS_gyuri.c,604 :: 		p1 = p2;
	MOVF        SmsCommands_p2_L3_L3_L3_L3+0, 0 
	MOVWF       SmsCommands_p1_L3_L3_L3_L3_L3+0 
	MOVF        SmsCommands_p2_L3_L3_L3_L3+1, 0 
	MOVWF       SmsCommands_p1_L3_L3_L3_L3_L3+1 
;SMS_gyuri.c,606 :: 		for (j=0; j<6; j++){
	CLRF        SmsCommands_j_L4_L4+0 
	CLRF        SmsCommands_j_L4_L4+1 
L_SmsCommands158:
	MOVLW       128
	XORWF       SmsCommands_j_L4_L4+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands323
	MOVLW       6
	SUBWF       SmsCommands_j_L4_L4+0, 0 
L__SmsCommands323:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands159
;SMS_gyuri.c,607 :: 		if (!isdigit(*p1++)){
	MOVF        SmsCommands_p1_L3_L3_L3_L3_L3+0, 0 
	MOVWF       R0 
	MOVF        SmsCommands_p1_L3_L3_L3_L3_L3+1, 0 
	MOVWF       R1 
	INFSNZ      SmsCommands_p1_L3_L3_L3_L3_L3+0, 1 
	INCF        SmsCommands_p1_L3_L3_L3_L3_L3+1, 1 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_isdigit_character+0 
	CALL        _isdigit+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands161
;SMS_gyuri.c,608 :: 		break;
	GOTO        L_SmsCommands159
;SMS_gyuri.c,609 :: 		}
L_SmsCommands161:
;SMS_gyuri.c,606 :: 		for (j=0; j<6; j++){
	INFSNZ      SmsCommands_j_L4_L4+0, 1 
	INCF        SmsCommands_j_L4_L4+1, 1 
;SMS_gyuri.c,610 :: 		}
	GOTO        L_SmsCommands158
L_SmsCommands159:
;SMS_gyuri.c,612 :: 		if (j >= 4 && strlen(p2) < 10){
	MOVLW       128
	XORWF       SmsCommands_j_L4_L4+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands324
	MOVLW       4
	SUBWF       SmsCommands_j_L4_L4+0, 0 
L__SmsCommands324:
	BTFSS       STATUS+0, 0 
	GOTO        L_SmsCommands164
	MOVF        SmsCommands_p2_L3_L3_L3_L3+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        SmsCommands_p2_L3_L3_L3_L3+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       128
	XORWF       R1, 0 
	MOVWF       R2 
	MOVLW       128
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands325
	MOVLW       10
	SUBWF       R0, 0 
L__SmsCommands325:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands164
L__SmsCommands241:
;SMS_gyuri.c,613 :: 		for (i=0;i<numberOfUsers;i++){
	CLRF        SmsCommands_i_L4+0 
	CLRF        SmsCommands_i_L4+1 
L_SmsCommands165:
	MOVLW       128
	XORWF       SmsCommands_i_L4+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _numberOfUsers+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands326
	MOVF        _numberOfUsers+0, 0 
	SUBWF       SmsCommands_i_L4+0, 0 
L__SmsCommands326:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands166
;SMS_gyuri.c,614 :: 		if (strstr(users[i],p2) != 0){
	MOVLW       10
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        SmsCommands_i_L4+0, 0 
	MOVWF       R4 
	MOVF        SmsCommands_i_L4+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 0 
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_strstr_s1+1 
	MOVF        SmsCommands_p2_L3_L3_L3_L3+0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        SmsCommands_p2_L3_L3_L3_L3+1, 0 
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands327
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands327:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands168
;SMS_gyuri.c,615 :: 		RemoveUserFromPhoneBook(p2);
	MOVF        SmsCommands_p2_L3_L3_L3_L3+0, 0 
	MOVWF       FARG_RemoveUserFromPhoneBook_number+0 
	MOVF        SmsCommands_p2_L3_L3_L3_L3+1, 0 
	MOVWF       FARG_RemoveUserFromPhoneBook_number+1 
	CALL        _RemoveUserFromPhoneBook+0, 0
;SMS_gyuri.c,616 :: 		}
L_SmsCommands168:
;SMS_gyuri.c,613 :: 		for (i=0;i<numberOfUsers;i++){
	INFSNZ      SmsCommands_i_L4+0, 1 
	INCF        SmsCommands_i_L4+1, 1 
;SMS_gyuri.c,617 :: 		}
	GOTO        L_SmsCommands165
L_SmsCommands166:
;SMS_gyuri.c,619 :: 		}
L_SmsCommands164:
;SMS_gyuri.c,621 :: 		p2 = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr44_SMS_gyuri+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr44_SMS_gyuri+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       SmsCommands_p2_L3_L3_L3_L3+0 
	MOVF        R1, 0 
	MOVWF       SmsCommands_p2_L3_L3_L3_L3+1 
;SMS_gyuri.c,622 :: 		i++;
	INFSNZ      SmsCommands_i_L4+0, 1 
	INCF        SmsCommands_i_L4+1, 1 
;SMS_gyuri.c,623 :: 		}
	GOTO        L_SmsCommands156
L_SmsCommands157:
;SMS_gyuri.c,625 :: 		isDataProcessed = TRUE;
	MOVLW       1
	MOVWF       _isDataProcessed+0 
;SMS_gyuri.c,626 :: 		isConfigChanged = TRUE;
	MOVLW       1
	MOVWF       SmsCommands_isConfigChanged_L2+0 
;SMS_gyuri.c,627 :: 		SendSms(admin,CopyConst2Ram(msg,OK),"");
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _OK+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SendSms_uzenet+0 
	MOVF        R1, 0 
	MOVWF       FARG_SendSms_uzenet+1 
	MOVLW       _admin+0
	MOVWF       FARG_SendSms_phonenumber+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_SendSms_phonenumber+1 
	MOVLW       ?lstr45_SMS_gyuri+0
	MOVWF       FARG_SendSms_info+0 
	MOVLW       hi_addr(?lstr45_SMS_gyuri+0)
	MOVWF       FARG_SendSms_info+1 
	CALL        _SendSms+0, 0
;SMS_gyuri.c,628 :: 		}
L_SmsCommands155:
;SMS_gyuri.c,630 :: 		if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,RESET)) != 0 )
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _RESET+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_RESET+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_RESET+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands328
	MOVLW       0
	XORWF       R0, 0 
L__SmsCommands328:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsCommands169
;SMS_gyuri.c,633 :: 		for (i=0;i<numberOfUsers;i++){
	CLRF        SmsCommands_i_L3_L3_L3_L3+0 
	CLRF        SmsCommands_i_L3_L3_L3_L3+1 
L_SmsCommands170:
	MOVLW       128
	XORWF       SmsCommands_i_L3_L3_L3_L3+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _numberOfUsers+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands329
	MOVF        _numberOfUsers+0, 0 
	SUBWF       SmsCommands_i_L3_L3_L3_L3+0, 0 
L__SmsCommands329:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands171
;SMS_gyuri.c,634 :: 		for (j=0;j<10;j++){
	CLRF        SmsCommands_j_L3+0 
	CLRF        SmsCommands_j_L3+1 
L_SmsCommands173:
	MOVLW       128
	XORWF       SmsCommands_j_L3+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands330
	MOVLW       10
	SUBWF       SmsCommands_j_L3+0, 0 
L__SmsCommands330:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands174
;SMS_gyuri.c,635 :: 		EEPROM_Write((i*10) + USERS_ADDRESS + j,0xFF);
	MOVLW       10
	MULWF       SmsCommands_i_L3_L3_L3_L3+0 
	MOVF        PRODL+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       176
	ADDWF       FARG_EEPROM_Write_address+0, 1 
	MOVF        SmsCommands_j_L3+0, 0 
	ADDWF       FARG_EEPROM_Write_address+0, 1 
	MOVLW       255
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;SMS_gyuri.c,636 :: 		delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_SmsCommands176:
	DECFSZ      R13, 1, 1
	BRA         L_SmsCommands176
	DECFSZ      R12, 1, 1
	BRA         L_SmsCommands176
	NOP
;SMS_gyuri.c,634 :: 		for (j=0;j<10;j++){
	INFSNZ      SmsCommands_j_L3+0, 1 
	INCF        SmsCommands_j_L3+1, 1 
;SMS_gyuri.c,637 :: 		}
	GOTO        L_SmsCommands173
L_SmsCommands174:
;SMS_gyuri.c,633 :: 		for (i=0;i<numberOfUsers;i++){
	INFSNZ      SmsCommands_i_L3_L3_L3_L3+0, 1 
	INCF        SmsCommands_i_L3_L3_L3_L3+1, 1 
;SMS_gyuri.c,638 :: 		}
	GOTO        L_SmsCommands170
L_SmsCommands171:
;SMS_gyuri.c,639 :: 		for (j=0;j<10;j++){
	CLRF        SmsCommands_j_L3+0 
	CLRF        SmsCommands_j_L3+1 
L_SmsCommands177:
	MOVLW       128
	XORWF       SmsCommands_j_L3+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsCommands331
	MOVLW       10
	SUBWF       SmsCommands_j_L3+0, 0 
L__SmsCommands331:
	BTFSC       STATUS+0, 0 
	GOTO        L_SmsCommands178
;SMS_gyuri.c,640 :: 		EEPROM_Write(ADMIN_ADDRESS + j,0xFF);
	MOVF        SmsCommands_j_L3+0, 0 
	ADDLW       160
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       255
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;SMS_gyuri.c,641 :: 		delay_ms(20);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_SmsCommands180:
	DECFSZ      R13, 1, 1
	BRA         L_SmsCommands180
	DECFSZ      R12, 1, 1
	BRA         L_SmsCommands180
	NOP
;SMS_gyuri.c,639 :: 		for (j=0;j<10;j++){
	INFSNZ      SmsCommands_j_L3+0, 1 
	INCF        SmsCommands_j_L3+1, 1 
;SMS_gyuri.c,642 :: 		}
	GOTO        L_SmsCommands177
L_SmsCommands178:
;SMS_gyuri.c,643 :: 		impulses = 0;
	CLRF        _impulses+0 
	CLRF        _impulses+1 
;SMS_gyuri.c,644 :: 		mode_1_delay = 500;
	MOVLW       244
	MOVWF       _mode_1_delay+0 
	MOVLW       1
	MOVWF       _mode_1_delay+1 
;SMS_gyuri.c,645 :: 		mode_2_delay = 500;
	MOVLW       244
	MOVWF       _mode_2_delay+0 
	MOVLW       1
	MOVWF       _mode_2_delay+1 
;SMS_gyuri.c,646 :: 		repeat = 0;
	CLRF        _repeat+0 
	CLRF        _repeat+1 
;SMS_gyuri.c,647 :: 		wait = 5;
	MOVLW       5
	MOVWF       _wait+0 
	MOVLW       0
	MOVWF       _wait+1 
;SMS_gyuri.c,648 :: 		numberOfUsers = 0;
	CLRF        _numberOfUsers+0 
	CLRF        _numberOfUsers+1 
;SMS_gyuri.c,649 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
;SMS_gyuri.c,650 :: 		strcpy(countryCode,"+36");
	MOVLW       _countryCode+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_countryCode+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr46_SMS_gyuri+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr46_SMS_gyuri+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;SMS_gyuri.c,651 :: 		isConfigChanged = TRUE;
	MOVLW       1
	MOVWF       SmsCommands_isConfigChanged_L2+0 
;SMS_gyuri.c,652 :: 		}
L_SmsCommands169:
;SMS_gyuri.c,654 :: 		if (isConfigChanged == TRUE) SaveConfigToEEPROM();
	MOVF        SmsCommands_isConfigChanged_L2+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_SmsCommands181
	CALL        _SaveConfigToEEPROM+0, 0
L_SmsCommands181:
;SMS_gyuri.c,656 :: 		}
L_SmsCommands114:
;SMS_gyuri.c,661 :: 		}
L_SmsCommands94:
;SMS_gyuri.c,662 :: 		}
L_end_SmsCommands:
	RETURN      0
; end of _SmsCommands

_SmsIncome:

;SMS_gyuri.c,668 :: 		void SmsIncome()
;SMS_gyuri.c,671 :: 		if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,MTI)) != 0)
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _MTI+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_MTI+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_MTI+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SmsIncome333
	MOVLW       0
	XORWF       R0, 0 
L__SmsIncome333:
	BTFSC       STATUS+0, 2 
	GOTO        L_SmsIncome182
;SMS_gyuri.c,674 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       207
	MOVWF       R12, 0
	MOVLW       1
	MOVWF       R13, 0
L_SmsIncome183:
	DECFSZ      R13, 1, 1
	BRA         L_SmsIncome183
	DECFSZ      R12, 1, 1
	BRA         L_SmsIncome183
	DECFSZ      R11, 1, 1
	BRA         L_SmsIncome183
	NOP
	NOP
;SMS_gyuri.c,675 :: 		k=0;
	CLRF        _k+0 
	CLRF        _k+1 
;SMS_gyuri.c,676 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT_CMGR));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT_CMGR+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT_CMGR+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT_CMGR+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,678 :: 		delay_ms(2000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_SmsIncome184:
	DECFSZ      R13, 1, 1
	BRA         L_SmsIncome184
	DECFSZ      R12, 1, 1
	BRA         L_SmsIncome184
	DECFSZ      R11, 1, 1
	BRA         L_SmsIncome184
	NOP
;SMS_gyuri.c,681 :: 		}
L_SmsIncome182:
;SMS_gyuri.c,684 :: 		}
L_end_SmsIncome:
	RETURN      0
; end of _SmsIncome

_DelSms:

;SMS_gyuri.c,686 :: 		void DelSms()
;SMS_gyuri.c,689 :: 		if (sms >=1 )
	MOVLW       1
	SUBWF       _sms+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_DelSms185
;SMS_gyuri.c,691 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;SMS_gyuri.c,692 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,693 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_DelSms186:
	DECFSZ      R13, 1, 1
	BRA         L_DelSms186
	DECFSZ      R12, 1, 1
	BRA         L_DelSms186
	DECFSZ      R11, 1, 1
	BRA         L_DelSms186
	NOP
	NOP
;SMS_gyuri.c,694 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT_CMGDA));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT_CMGDA+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT_CMGDA+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT_CMGDA+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,695 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_DelSms187:
	DECFSZ      R13, 1, 1
	BRA         L_DelSms187
	DECFSZ      R12, 1, 1
	BRA         L_DelSms187
	DECFSZ      R11, 1, 1
	BRA         L_DelSms187
	NOP
	NOP
;SMS_gyuri.c,696 :: 		sms = 0;
	CLRF        _sms+0 
;SMS_gyuri.c,697 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;SMS_gyuri.c,698 :: 		}
L_DelSms185:
;SMS_gyuri.c,700 :: 		}
L_end_DelSms:
	RETURN      0
; end of _DelSms

_InitTimer1:

;SMS_gyuri.c,702 :: 		void InitTimer1(){
;SMS_gyuri.c,703 :: 		T1CON         = 0x01;
	MOVLW       1
	MOVWF       T1CON+0 
;SMS_gyuri.c,704 :: 		TMR1IF_bit         = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;SMS_gyuri.c,705 :: 		TMR1H         = 0x9E;
	MOVLW       158
	MOVWF       TMR1H+0 
;SMS_gyuri.c,706 :: 		TMR1L         = 0x58;
	MOVLW       88
	MOVWF       TMR1L+0 
;SMS_gyuri.c,707 :: 		TMR1IE_bit         = 1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;SMS_gyuri.c,708 :: 		INTCON         = 0xC0;
	MOVLW       192
	MOVWF       INTCON+0 
;SMS_gyuri.c,709 :: 		}
L_end_InitTimer1:
	RETURN      0
; end of _InitTimer1

_CheckSimOperating:

;SMS_gyuri.c,712 :: 		void CheckSimOperating() {
;SMS_gyuri.c,714 :: 		if (seconds >= 60 ){
	MOVLW       128
	XORWF       _seconds+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__CheckSimOperating337
	MOVLW       60
	SUBWF       _seconds+0, 0 
L__CheckSimOperating337:
	BTFSS       STATUS+0, 0 
	GOTO        L_CheckSimOperating188
;SMS_gyuri.c,715 :: 		seconds = 0;
	CLRF        _seconds+0 
	CLRF        _seconds+1 
;SMS_gyuri.c,717 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,718 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_CheckSimOperating189:
	DECFSZ      R13, 1, 1
	BRA         L_CheckSimOperating189
	DECFSZ      R12, 1, 1
	BRA         L_CheckSimOperating189
	DECFSZ      R11, 1, 1
	BRA         L_CheckSimOperating189
	NOP
	NOP
;SMS_gyuri.c,720 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,721 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_CheckSimOperating190:
	DECFSZ      R13, 1, 1
	BRA         L_CheckSimOperating190
	DECFSZ      R12, 1, 1
	BRA         L_CheckSimOperating190
	DECFSZ      R11, 1, 1
	BRA         L_CheckSimOperating190
	NOP
	NOP
;SMS_gyuri.c,723 :: 		if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,OK)) == 0){
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _OK+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_OK+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__CheckSimOperating338
	MOVLW       0
	XORWF       R0, 0 
L__CheckSimOperating338:
	BTFSS       STATUS+0, 2 
	GOTO        L_CheckSimOperating191
;SMS_gyuri.c,725 :: 		PWRKEY = 1;
	BSF         PORTC+0, 1 
;SMS_gyuri.c,726 :: 		delay_ms(1200);
	MOVLW       16
	MOVWF       R11, 0
	MOVLW       57
	MOVWF       R12, 0
	MOVLW       13
	MOVWF       R13, 0
L_CheckSimOperating192:
	DECFSZ      R13, 1, 1
	BRA         L_CheckSimOperating192
	DECFSZ      R12, 1, 1
	BRA         L_CheckSimOperating192
	DECFSZ      R11, 1, 1
	BRA         L_CheckSimOperating192
	NOP
	NOP
;SMS_gyuri.c,727 :: 		PWRKEY = 0;
	BCF         PORTC+0, 1 
;SMS_gyuri.c,728 :: 		delay_ms(5000);
	MOVLW       64
	MOVWF       R11, 0
	MOVLW       106
	MOVWF       R12, 0
	MOVLW       151
	MOVWF       R13, 0
L_CheckSimOperating193:
	DECFSZ      R13, 1, 1
	BRA         L_CheckSimOperating193
	DECFSZ      R12, 1, 1
	BRA         L_CheckSimOperating193
	DECFSZ      R11, 1, 1
	BRA         L_CheckSimOperating193
	NOP
	NOP
;SMS_gyuri.c,730 :: 		}
L_CheckSimOperating191:
;SMS_gyuri.c,732 :: 		}
L_CheckSimOperating188:
;SMS_gyuri.c,733 :: 		}
L_end_CheckSimOperating:
	RETURN      0
; end of _CheckSimOperating

_Setup:

;SMS_gyuri.c,735 :: 		void Setup()
;SMS_gyuri.c,737 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_Setup194:
	DECFSZ      R13, 1, 1
	BRA         L_Setup194
	DECFSZ      R12, 1, 1
	BRA         L_Setup194
	DECFSZ      R11, 1, 1
	BRA         L_Setup194
	NOP
	NOP
;SMS_gyuri.c,738 :: 		TRISA.B0 = 0;
	BCF         TRISA+0, 0 
;SMS_gyuri.c,739 :: 		PORTA = 0;
	CLRF        PORTA+0 
;SMS_gyuri.c,740 :: 		TRISB = 0b01011011;
	MOVLW       91
	MOVWF       TRISB+0 
;SMS_gyuri.c,741 :: 		TRISC = 0b00111001;
	MOVLW       57
	MOVWF       TRISC+0 
;SMS_gyuri.c,743 :: 		PORTB = 0b000000000;
	CLRF        PORTB+0 
;SMS_gyuri.c,744 :: 		PORTC = 0b000000000;
	CLRF        PORTC+0 
;SMS_gyuri.c,746 :: 		ADCON0 = 0x0f;
	MOVLW       15
	MOVWF       ADCON0+0 
;SMS_gyuri.c,747 :: 		ADCON1 = 0x0f;
	MOVLW       15
	MOVWF       ADCON1+0 
;SMS_gyuri.c,750 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_Setup195:
	DECFSZ      R13, 1, 1
	BRA         L_Setup195
	DECFSZ      R12, 1, 1
	BRA         L_Setup195
	DECFSZ      R11, 1, 1
	BRA         L_Setup195
	NOP
	NOP
;SMS_gyuri.c,754 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;SMS_gyuri.c,755 :: 		INTCON.PEIE = 1;
	BSF         INTCON+0, 6 
;SMS_gyuri.c,756 :: 		PIE1.RCIE = 1;
	BSF         PIE1+0, 5 
;SMS_gyuri.c,758 :: 		InitTimer0();
	CALL        _InitTimer0+0, 0
;SMS_gyuri.c,759 :: 		InitTimer1();
	CALL        _InitTimer1+0, 0
;SMS_gyuri.c,763 :: 		seconds = 60;
	MOVLW       60
	MOVWF       _seconds+0 
	MOVLW       0
	MOVWF       _seconds+1 
;SMS_gyuri.c,766 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       1
	MOVWF       SPBRGH+0 
	MOVLW       3
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;SMS_gyuri.c,767 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_Setup196:
	DECFSZ      R13, 1, 1
	BRA         L_Setup196
	DECFSZ      R12, 1, 1
	BRA         L_Setup196
	DECFSZ      R11, 1, 1
	BRA         L_Setup196
	NOP
	NOP
;SMS_gyuri.c,769 :: 		CheckSimOperating();
	CALL        _CheckSimOperating+0, 0
;SMS_gyuri.c,771 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;SMS_gyuri.c,772 :: 		ReadConfigFromEEPROM();
	CALL        _ReadConfigFromEEPROM+0, 0
;SMS_gyuri.c,773 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;SMS_gyuri.c,775 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,776 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_Setup197:
	DECFSZ      R13, 1, 1
	BRA         L_Setup197
	DECFSZ      R12, 1, 1
	BRA         L_Setup197
	DECFSZ      R11, 1, 1
	BRA         L_Setup197
	NOP
	NOP
;SMS_gyuri.c,777 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT_CMGF));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT_CMGF+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT_CMGF+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT_CMGF+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,778 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_Setup198:
	DECFSZ      R13, 1, 1
	BRA         L_Setup198
	DECFSZ      R12, 1, 1
	BRA         L_Setup198
	DECFSZ      R11, 1, 1
	BRA         L_Setup198
	NOP
	NOP
;SMS_gyuri.c,779 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT_CSCLK));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT_CSCLK+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT_CSCLK+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT_CSCLK+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,780 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_Setup199:
	DECFSZ      R13, 1, 1
	BRA         L_Setup199
	DECFSZ      R12, 1, 1
	BRA         L_Setup199
	DECFSZ      R11, 1, 1
	BRA         L_Setup199
	NOP
	NOP
;SMS_gyuri.c,781 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT_CLTS));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT_CLTS+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT_CLTS+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT_CLTS+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,782 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_Setup200:
	DECFSZ      R13, 1, 1
	BRA         L_Setup200
	DECFSZ      R12, 1, 1
	BRA         L_Setup200
	DECFSZ      R11, 1, 1
	BRA         L_Setup200
	NOP
	NOP
;SMS_gyuri.c,783 :: 		UART1_Write_Text(CopyConst2Ram(msg,AT_CLIP));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _AT_CLIP+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_AT_CLIP+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_AT_CLIP+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,784 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_Setup201:
	DECFSZ      R13, 1, 1
	BRA         L_Setup201
	DECFSZ      R12, 1, 1
	BRA         L_Setup201
	DECFSZ      R11, 1, 1
	BRA         L_Setup201
	NOP
	NOP
;SMS_gyuri.c,786 :: 		}
L_end_Setup:
	RETURN      0
; end of _Setup

_OpenGate:

;SMS_gyuri.c,788 :: 		void OpenGate(){
;SMS_gyuri.c,790 :: 		switch (mode){
	GOTO        L_OpenGate202
;SMS_gyuri.c,793 :: 		case 1:
L_OpenGate204:
;SMS_gyuri.c,794 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       207
	MOVWF       R12, 0
	MOVLW       1
	MOVWF       R13, 0
L_OpenGate205:
	DECFSZ      R13, 1, 1
	BRA         L_OpenGate205
	DECFSZ      R12, 1, 1
	BRA         L_OpenGate205
	DECFSZ      R11, 1, 1
	BRA         L_OpenGate205
	NOP
	NOP
;SMS_gyuri.c,795 :: 		UART1_Write_Text(CopyConst2Ram(msg,ATH));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ATH+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ATH+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ATH+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,796 :: 		delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_OpenGate206:
	DECFSZ      R13, 1, 1
	BRA         L_OpenGate206
	DECFSZ      R12, 1, 1
	BRA         L_OpenGate206
	DECFSZ      R11, 1, 1
	BRA         L_OpenGate206
	NOP
	NOP
;SMS_gyuri.c,798 :: 		RELAY = 1;
	BSF         PORTB+0, 2 
;SMS_gyuri.c,799 :: 		vdelay_ms(mode_1_delay);
	MOVF        _mode_1_delay+0, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+0 
	MOVF        _mode_1_delay+1, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+1 
	CALL        _VDelay_ms+0, 0
;SMS_gyuri.c,800 :: 		RELAY = 0;
	BCF         PORTB+0, 2 
;SMS_gyuri.c,802 :: 		if (repeat == 1){
	MOVLW       0
	XORWF       _repeat+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OpenGate341
	MOVLW       1
	XORWF       _repeat+0, 0 
L__OpenGate341:
	BTFSS       STATUS+0, 2 
	GOTO        L_OpenGate207
;SMS_gyuri.c,803 :: 		vdelay_ms(wait*1000);
	MOVF        _wait+0, 0 
	MOVWF       R0 
	MOVF        _wait+1, 0 
	MOVWF       R1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+0 
	MOVF        R1, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+1 
	CALL        _VDelay_ms+0, 0
;SMS_gyuri.c,804 :: 		RELAY = 1;
	BSF         PORTB+0, 2 
;SMS_gyuri.c,805 :: 		vdelay_ms(mode_1_delay);
	MOVF        _mode_1_delay+0, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+0 
	MOVF        _mode_1_delay+1, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+1 
	CALL        _VDelay_ms+0, 0
;SMS_gyuri.c,806 :: 		RELAY = 0;
	BCF         PORTB+0, 2 
;SMS_gyuri.c,807 :: 		}
L_OpenGate207:
;SMS_gyuri.c,811 :: 		break;
	GOTO        L_OpenGate203
;SMS_gyuri.c,813 :: 		case 2:        // MODE 2 OPEN GATE WITH *IMPULSES* *DELAY* between impulses.
L_OpenGate208:
;SMS_gyuri.c,815 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       207
	MOVWF       R12, 0
	MOVLW       1
	MOVWF       R13, 0
L_OpenGate209:
	DECFSZ      R13, 1, 1
	BRA         L_OpenGate209
	DECFSZ      R12, 1, 1
	BRA         L_OpenGate209
	DECFSZ      R11, 1, 1
	BRA         L_OpenGate209
	NOP
	NOP
;SMS_gyuri.c,816 :: 		UART1_Write_Text(CopyConst2Ram(msg,ATH));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ATH+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ATH+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ATH+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,817 :: 		delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_OpenGate210:
	DECFSZ      R13, 1, 1
	BRA         L_OpenGate210
	DECFSZ      R12, 1, 1
	BRA         L_OpenGate210
	DECFSZ      R11, 1, 1
	BRA         L_OpenGate210
	NOP
	NOP
;SMS_gyuri.c,819 :: 		for (i=0;i<impulses;i++){
	CLRF        OpenGate_i_L1+0 
	CLRF        OpenGate_i_L1+1 
L_OpenGate211:
	MOVLW       128
	XORWF       OpenGate_i_L1+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _impulses+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OpenGate342
	MOVF        _impulses+0, 0 
	SUBWF       OpenGate_i_L1+0, 0 
L__OpenGate342:
	BTFSC       STATUS+0, 0 
	GOTO        L_OpenGate212
;SMS_gyuri.c,820 :: 		RELAY = 1;
	BSF         PORTB+0, 2 
;SMS_gyuri.c,821 :: 		vdelay_ms(mode_2_delay/2);
	MOVF        _mode_2_delay+0, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+0 
	MOVF        _mode_2_delay+1, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+1 
	RRCF        FARG_VDelay_ms_Time_ms+1, 1 
	RRCF        FARG_VDelay_ms_Time_ms+0, 1 
	BCF         FARG_VDelay_ms_Time_ms+1, 7 
	BTFSC       FARG_VDelay_ms_Time_ms+1, 6 
	BSF         FARG_VDelay_ms_Time_ms+1, 7 
	CALL        _VDelay_ms+0, 0
;SMS_gyuri.c,822 :: 		RELAY = 0;
	BCF         PORTB+0, 2 
;SMS_gyuri.c,823 :: 		vdelay_ms(mode_2_delay/2);
	MOVF        _mode_2_delay+0, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+0 
	MOVF        _mode_2_delay+1, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+1 
	RRCF        FARG_VDelay_ms_Time_ms+1, 1 
	RRCF        FARG_VDelay_ms_Time_ms+0, 1 
	BCF         FARG_VDelay_ms_Time_ms+1, 7 
	BTFSC       FARG_VDelay_ms_Time_ms+1, 6 
	BSF         FARG_VDelay_ms_Time_ms+1, 7 
	CALL        _VDelay_ms+0, 0
;SMS_gyuri.c,819 :: 		for (i=0;i<impulses;i++){
	INFSNZ      OpenGate_i_L1+0, 1 
	INCF        OpenGate_i_L1+1, 1 
;SMS_gyuri.c,824 :: 		}
	GOTO        L_OpenGate211
L_OpenGate212:
;SMS_gyuri.c,825 :: 		if (repeat == 1){
	MOVLW       0
	XORWF       _repeat+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OpenGate343
	MOVLW       1
	XORWF       _repeat+0, 0 
L__OpenGate343:
	BTFSS       STATUS+0, 2 
	GOTO        L_OpenGate214
;SMS_gyuri.c,826 :: 		VDelay_ms(wait*1000);
	MOVF        _wait+0, 0 
	MOVWF       R0 
	MOVF        _wait+1, 0 
	MOVWF       R1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+0 
	MOVF        R1, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+1 
	CALL        _VDelay_ms+0, 0
;SMS_gyuri.c,828 :: 		for (i=0;i<impulses;i++){
	CLRF        OpenGate_i_L1+0 
	CLRF        OpenGate_i_L1+1 
L_OpenGate215:
	MOVLW       128
	XORWF       OpenGate_i_L1+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _impulses+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OpenGate344
	MOVF        _impulses+0, 0 
	SUBWF       OpenGate_i_L1+0, 0 
L__OpenGate344:
	BTFSC       STATUS+0, 0 
	GOTO        L_OpenGate216
;SMS_gyuri.c,829 :: 		RELAY = 1;
	BSF         PORTB+0, 2 
;SMS_gyuri.c,830 :: 		vdelay_ms(mode_2_delay/2);
	MOVF        _mode_2_delay+0, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+0 
	MOVF        _mode_2_delay+1, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+1 
	RRCF        FARG_VDelay_ms_Time_ms+1, 1 
	RRCF        FARG_VDelay_ms_Time_ms+0, 1 
	BCF         FARG_VDelay_ms_Time_ms+1, 7 
	BTFSC       FARG_VDelay_ms_Time_ms+1, 6 
	BSF         FARG_VDelay_ms_Time_ms+1, 7 
	CALL        _VDelay_ms+0, 0
;SMS_gyuri.c,831 :: 		RELAY = 0;
	BCF         PORTB+0, 2 
;SMS_gyuri.c,832 :: 		vdelay_ms(mode_2_delay/2);
	MOVF        _mode_2_delay+0, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+0 
	MOVF        _mode_2_delay+1, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+1 
	RRCF        FARG_VDelay_ms_Time_ms+1, 1 
	RRCF        FARG_VDelay_ms_Time_ms+0, 1 
	BCF         FARG_VDelay_ms_Time_ms+1, 7 
	BTFSC       FARG_VDelay_ms_Time_ms+1, 6 
	BSF         FARG_VDelay_ms_Time_ms+1, 7 
	CALL        _VDelay_ms+0, 0
;SMS_gyuri.c,828 :: 		for (i=0;i<impulses;i++){
	INFSNZ      OpenGate_i_L1+0, 1 
	INCF        OpenGate_i_L1+1, 1 
;SMS_gyuri.c,833 :: 		}
	GOTO        L_OpenGate215
L_OpenGate216:
;SMS_gyuri.c,835 :: 		}
L_OpenGate214:
;SMS_gyuri.c,837 :: 		break;
	GOTO        L_OpenGate203
;SMS_gyuri.c,839 :: 		case 3:      // MODE 3 OPEN GATE UNTIL RING
L_OpenGate218:
;SMS_gyuri.c,840 :: 		seconds = 0;
	CLRF        _seconds+0 
	CLRF        _seconds+1 
;SMS_gyuri.c,841 :: 		while (strstr(interruptStreamBuffer,CopyConst2Ram(msg,CARRIER)) == 0){
L_OpenGate219:
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _CARRIER+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_CARRIER+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_CARRIER+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OpenGate345
	MOVLW       0
	XORWF       R0, 0 
L__OpenGate345:
	BTFSS       STATUS+0, 2 
	GOTO        L_OpenGate220
;SMS_gyuri.c,842 :: 		RELAY = 1;
	BSF         PORTB+0, 2 
;SMS_gyuri.c,843 :: 		if (seconds == 300)break;
	MOVF        _seconds+1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__OpenGate346
	MOVLW       44
	XORWF       _seconds+0, 0 
L__OpenGate346:
	BTFSS       STATUS+0, 2 
	GOTO        L_OpenGate221
	GOTO        L_OpenGate220
L_OpenGate221:
;SMS_gyuri.c,844 :: 		}
	GOTO        L_OpenGate219
L_OpenGate220:
;SMS_gyuri.c,845 :: 		RELAY = 0;
	BCF         PORTB+0, 2 
;SMS_gyuri.c,846 :: 		if (repeat == 1){
	MOVLW       0
	XORWF       _repeat+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OpenGate347
	MOVLW       1
	XORWF       _repeat+0, 0 
L__OpenGate347:
	BTFSS       STATUS+0, 2 
	GOTO        L_OpenGate222
;SMS_gyuri.c,849 :: 		delay = seconds;
	MOVF        _seconds+0, 0 
	MOVWF       OpenGate_delay_L2+0 
	MOVF        _seconds+1, 0 
	MOVWF       OpenGate_delay_L2+1 
;SMS_gyuri.c,851 :: 		vdelay_ms(wait*1000);
	MOVF        _wait+0, 0 
	MOVWF       R0 
	MOVF        _wait+1, 0 
	MOVWF       R1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+0 
	MOVF        R1, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+1 
	CALL        _VDelay_ms+0, 0
;SMS_gyuri.c,852 :: 		RELAY = 1;
	BSF         PORTB+0, 2 
;SMS_gyuri.c,853 :: 		for (i=0;i<1000;i++) vdelay_ms(delay);
	CLRF        OpenGate_i_L2+0 
	CLRF        OpenGate_i_L2+1 
L_OpenGate223:
	MOVLW       128
	XORWF       OpenGate_i_L2+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OpenGate348
	MOVLW       232
	SUBWF       OpenGate_i_L2+0, 0 
L__OpenGate348:
	BTFSC       STATUS+0, 0 
	GOTO        L_OpenGate224
	MOVF        OpenGate_delay_L2+0, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+0 
	MOVF        OpenGate_delay_L2+1, 0 
	MOVWF       FARG_VDelay_ms_Time_ms+1 
	CALL        _VDelay_ms+0, 0
	INFSNZ      OpenGate_i_L2+0, 1 
	INCF        OpenGate_i_L2+1, 1 
	GOTO        L_OpenGate223
L_OpenGate224:
;SMS_gyuri.c,854 :: 		RELAY = 0;
	BCF         PORTB+0, 2 
;SMS_gyuri.c,855 :: 		}
L_OpenGate222:
;SMS_gyuri.c,857 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       207
	MOVWF       R12, 0
	MOVLW       1
	MOVWF       R13, 0
L_OpenGate226:
	DECFSZ      R13, 1, 1
	BRA         L_OpenGate226
	DECFSZ      R12, 1, 1
	BRA         L_OpenGate226
	DECFSZ      R11, 1, 1
	BRA         L_OpenGate226
	NOP
	NOP
;SMS_gyuri.c,858 :: 		UART1_Write_Text(CopyConst2Ram(msg,ATH));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ATH+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ATH+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ATH+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,859 :: 		delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_OpenGate227:
	DECFSZ      R13, 1, 1
	BRA         L_OpenGate227
	DECFSZ      R12, 1, 1
	BRA         L_OpenGate227
	DECFSZ      R11, 1, 1
	BRA         L_OpenGate227
	NOP
	NOP
;SMS_gyuri.c,861 :: 		break;
	GOTO        L_OpenGate203
;SMS_gyuri.c,864 :: 		}
L_OpenGate202:
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OpenGate349
	MOVLW       1
	XORWF       _mode+0, 0 
L__OpenGate349:
	BTFSC       STATUS+0, 2 
	GOTO        L_OpenGate204
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OpenGate350
	MOVLW       2
	XORWF       _mode+0, 0 
L__OpenGate350:
	BTFSC       STATUS+0, 2 
	GOTO        L_OpenGate208
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OpenGate351
	MOVLW       3
	XORWF       _mode+0, 0 
L__OpenGate351:
	BTFSC       STATUS+0, 2 
	GOTO        L_OpenGate218
L_OpenGate203:
;SMS_gyuri.c,866 :: 		}
L_end_OpenGate:
	RETURN      0
; end of _OpenGate

_OnRing:

;SMS_gyuri.c,868 :: 		void OnRing(){
;SMS_gyuri.c,870 :: 		if (strstr(interruptStreamBuffer,CopyConst2Ram(msg,RING)) != 0){
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _RING+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_RING+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_RING+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strstr_s2+1 
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OnRing353
	MOVLW       0
	XORWF       R0, 0 
L__OnRing353:
	BTFSC       STATUS+0, 2 
	GOTO        L_OnRing228
;SMS_gyuri.c,872 :: 		delay_ms(500);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       88
	MOVWF       R12, 0
	MOVLW       89
	MOVWF       R13, 0
L_OnRing229:
	DECFSZ      R13, 1, 1
	BRA         L_OnRing229
	DECFSZ      R12, 1, 1
	BRA         L_OnRing229
	DECFSZ      R11, 1, 1
	BRA         L_OnRing229
	NOP
	NOP
;SMS_gyuri.c,873 :: 		if (strstr(interruptStreamBuffer,admin) != 0){
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       _admin+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(_admin+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OnRing354
	MOVLW       0
	XORWF       R0, 0 
L__OnRing354:
	BTFSC       STATUS+0, 2 
	GOTO        L_OnRing230
;SMS_gyuri.c,875 :: 		OpenGate();
	CALL        _OpenGate+0, 0
;SMS_gyuri.c,877 :: 		}
L_OnRing230:
;SMS_gyuri.c,879 :: 		for (i=0;i<numberOfUsers;i++){
	CLRF        _i+0 
	CLRF        _i+1 
L_OnRing231:
	MOVF        _numberOfUsers+1, 0 
	SUBWF       _i+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OnRing355
	MOVF        _numberOfUsers+0, 0 
	SUBWF       _i+0, 0 
L__OnRing355:
	BTFSC       STATUS+0, 0 
	GOTO        L_OnRing232
;SMS_gyuri.c,880 :: 		if (strstr(interruptStreamBuffer,users[i]) != 0){
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       10
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _i+0, 0 
	MOVWF       R4 
	MOVF        _i+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _users+0
	ADDWF       R0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(_users+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__OnRing356
	MOVLW       0
	XORWF       R0, 0 
L__OnRing356:
	BTFSC       STATUS+0, 2 
	GOTO        L_OnRing234
;SMS_gyuri.c,881 :: 		OpenGate();
	CALL        _OpenGate+0, 0
;SMS_gyuri.c,883 :: 		}
L_OnRing234:
;SMS_gyuri.c,879 :: 		for (i=0;i<numberOfUsers;i++){
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;SMS_gyuri.c,884 :: 		}
	GOTO        L_OnRing231
L_OnRing232:
;SMS_gyuri.c,886 :: 		delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       207
	MOVWF       R12, 0
	MOVLW       1
	MOVWF       R13, 0
L_OnRing235:
	DECFSZ      R13, 1, 1
	BRA         L_OnRing235
	DECFSZ      R12, 1, 1
	BRA         L_OnRing235
	DECFSZ      R11, 1, 1
	BRA         L_OnRing235
	NOP
	NOP
;SMS_gyuri.c,887 :: 		UART1_Write_Text(CopyConst2Ram(msg,ATH));
	MOVLW       _msg+0
	MOVWF       FARG_CopyConst2Ram_dest+0 
	MOVLW       hi_addr(_msg+0)
	MOVWF       FARG_CopyConst2Ram_dest+1 
	MOVLW       _ATH+0
	MOVWF       FARG_CopyConst2Ram_src+0 
	MOVLW       hi_addr(_ATH+0)
	MOVWF       FARG_CopyConst2Ram_src+1 
	MOVLW       higher_addr(_ATH+0)
	MOVWF       FARG_CopyConst2Ram_src+2 
	CALL        _CopyConst2Ram+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;SMS_gyuri.c,888 :: 		delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_OnRing236:
	DECFSZ      R13, 1, 1
	BRA         L_OnRing236
	DECFSZ      R12, 1, 1
	BRA         L_OnRing236
	DECFSZ      R11, 1, 1
	BRA         L_OnRing236
	NOP
	NOP
;SMS_gyuri.c,890 :: 		}
L_OnRing228:
;SMS_gyuri.c,894 :: 		}
L_end_OnRing:
	RETURN      0
; end of _OnRing

_main:

;SMS_gyuri.c,897 :: 		void main() {
;SMS_gyuri.c,900 :: 		Setup();
	CALL        _Setup+0, 0
;SMS_gyuri.c,903 :: 		while(1)
L_main237:
;SMS_gyuri.c,906 :: 		CheckSimOperating();
	CALL        _CheckSimOperating+0, 0
;SMS_gyuri.c,908 :: 		DelSms();
	CALL        _DelSms+0, 0
;SMS_gyuri.c,910 :: 		if (InputReaderFlag == 1)
	MOVF        _InputReaderFlag+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main239
;SMS_gyuri.c,912 :: 		interruptStreamBuffer[k] = '\0';
	MOVLW       _interruptStreamBuffer+0
	ADDWF       _k+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	ADDWFC      _k+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;SMS_gyuri.c,914 :: 		OnRing();
	CALL        _OnRing+0, 0
;SMS_gyuri.c,916 :: 		SmsIncome();
	CALL        _SmsIncome+0, 0
;SMS_gyuri.c,918 :: 		SmsCommands();
	CALL        _SmsCommands+0, 0
;SMS_gyuri.c,920 :: 		k = 0;
	CLRF        _k+0 
	CLRF        _k+1 
;SMS_gyuri.c,921 :: 		InputReaderFlag = 0;
	CLRF        _InputReaderFlag+0 
;SMS_gyuri.c,923 :: 		memset(interruptStreamBuffer,0,sizeof(interruptStreamBuffer)-1);
	MOVLW       _interruptStreamBuffer+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_interruptStreamBuffer+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       199
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;SMS_gyuri.c,925 :: 		}
L_main239:
;SMS_gyuri.c,927 :: 		}
	GOTO        L_main237
;SMS_gyuri.c,928 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
