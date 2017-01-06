
_read_single_byte:

;home_control.c,109 :: 		char read_single_byte(char interface){
;home_control.c,110 :: 		if (interface == WIFI){
	MOVF        FARG_read_single_byte_interface+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_read_single_byte0
;home_control.c,111 :: 		return UART1_Read();
	CALL        _UART1_Read+0, 0
	GOTO        L_end_read_single_byte
;home_control.c,112 :: 		}
L_read_single_byte0:
;home_control.c,113 :: 		if (interface == GPRS) {
	MOVF        FARG_read_single_byte_interface+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_read_single_byte1
;home_control.c,114 :: 		return UART2_Read();
	CALL        _UART2_Read+0, 0
	GOTO        L_end_read_single_byte
;home_control.c,115 :: 		}
L_read_single_byte1:
;home_control.c,116 :: 		}
L_end_read_single_byte:
	RETURN      0
; end of _read_single_byte

_is_data_ready:

;home_control.c,118 :: 		char is_data_ready(char interface){
;home_control.c,119 :: 		if (interface == WIFI){
	MOVF        FARG_is_data_ready_interface+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_is_data_ready2
;home_control.c,120 :: 		return Uart1_Data_Ready();
	CALL        _UART1_Data_Ready+0, 0
	GOTO        L_end_is_data_ready
;home_control.c,121 :: 		}
L_is_data_ready2:
;home_control.c,122 :: 		if (interface == GPRS){
	MOVF        FARG_is_data_ready_interface+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_is_data_ready3
;home_control.c,123 :: 		return Uart2_Data_Ready();
	CALL        _UART2_Data_Ready+0, 0
	GOTO        L_end_is_data_ready
;home_control.c,124 :: 		}
L_is_data_ready3:
;home_control.c,125 :: 		}
L_end_is_data_ready:
	RETURN      0
; end of _is_data_ready

_clear_read_line:

;home_control.c,128 :: 		void clear_read_line(char interface){
;home_control.c,131 :: 		if (interface == WIFI){
	MOVF        FARG_clear_read_line_interface+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_clear_read_line4
;home_control.c,132 :: 		for (i=0;i<sizeof(network_data.wifi_readLine)-2;i++){
	CLRF        clear_read_line_i_L0+0 
	CLRF        clear_read_line_i_L0+1 
L_clear_read_line5:
	MOVLW       128
	XORWF       clear_read_line_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clear_read_line199
	MOVLW       98
	SUBWF       clear_read_line_i_L0+0, 0 
L__clear_read_line199:
	BTFSC       STATUS+0, 0 
	GOTO        L_clear_read_line6
;home_control.c,133 :: 		network_data.wifi_readLine[i] = 'a';
	MOVLW       _Network_data+90
	ADDWF       clear_read_line_i_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_Network_data+90)
	ADDWFC      clear_read_line_i_L0+1, 0 
	MOVWF       FSR1H 
	MOVLW       97
	MOVWF       POSTINC1+0 
;home_control.c,132 :: 		for (i=0;i<sizeof(network_data.wifi_readLine)-2;i++){
	INFSNZ      clear_read_line_i_L0+0, 1 
	INCF        clear_read_line_i_L0+1, 1 
;home_control.c,134 :: 		}
	GOTO        L_clear_read_line5
L_clear_read_line6:
;home_control.c,135 :: 		strcpy(network_data.wifi_readLine,"");
	MOVLW       _Network_data+90
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_Network_data+90)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr1_home_control+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr1_home_control+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;home_control.c,136 :: 		network_data.isWifiInputReady = 0;
	CLRF        _Network_data+390 
;home_control.c,137 :: 		network_data.index_1 = 0;
	CLRF        _Network_data+392 
	CLRF        _Network_data+393 
;home_control.c,138 :: 		}
L_clear_read_line4:
;home_control.c,139 :: 		if (interface == GPRS){
	MOVF        FARG_clear_read_line_interface+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_clear_read_line8
;home_control.c,140 :: 		for (i=0;i<sizeof(network_data.gprs_readLine)-2;i++){
	CLRF        clear_read_line_i_L0+0 
	CLRF        clear_read_line_i_L0+1 
L_clear_read_line9:
	MOVLW       128
	XORWF       clear_read_line_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clear_read_line200
	MOVLW       198
	SUBWF       clear_read_line_i_L0+0, 0 
L__clear_read_line200:
	BTFSC       STATUS+0, 0 
	GOTO        L_clear_read_line10
;home_control.c,141 :: 		network_data.gprs_readLine[i] = 'a';
	MOVLW       _Network_data+190
	ADDWF       clear_read_line_i_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_Network_data+190)
	ADDWFC      clear_read_line_i_L0+1, 0 
	MOVWF       FSR1H 
	MOVLW       97
	MOVWF       POSTINC1+0 
;home_control.c,140 :: 		for (i=0;i<sizeof(network_data.gprs_readLine)-2;i++){
	INFSNZ      clear_read_line_i_L0+0, 1 
	INCF        clear_read_line_i_L0+1, 1 
;home_control.c,142 :: 		}
	GOTO        L_clear_read_line9
L_clear_read_line10:
;home_control.c,143 :: 		strcpy(network_data.gprs_readLine,"");
	MOVLW       _Network_data+190
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_Network_data+190)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr2_home_control+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr2_home_control+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;home_control.c,144 :: 		network_data.isGprsInputReady = 0;
	CLRF        _Network_data+391 
;home_control.c,145 :: 		network_data.index_2 = 0;
	CLRF        _Network_data+394 
	CLRF        _Network_data+395 
;home_control.c,146 :: 		}
L_clear_read_line8:
;home_control.c,147 :: 		}
L_end_clear_read_line:
	RETURN      0
; end of _clear_read_line

_wait_for_input:

;home_control.c,150 :: 		int wait_for_input(char *input, int timeout, char interface){
;home_control.c,152 :: 		int i = 0;int mils = 0;
	CLRF        wait_for_input_i_L0+0 
	CLRF        wait_for_input_i_L0+1 
	CLRF        wait_for_input_mils_L0+0 
	CLRF        wait_for_input_mils_L0+1 
;home_control.c,154 :: 		memset(buffer,'\0',sizeof(buffer)-1);
	MOVLW       wait_for_input_buffer_L0+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(wait_for_input_buffer_L0+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       29
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;home_control.c,155 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;home_control.c,157 :: 		while (mils <= timeout*1000){
L_wait_for_input12:
	MOVF        FARG_wait_for_input_timeout+0, 0 
	MOVWF       R0 
	MOVF        FARG_wait_for_input_timeout+1, 0 
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
	XORWF       wait_for_input_mils_L0+1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__wait_for_input202
	MOVF        wait_for_input_mils_L0+0, 0 
	SUBWF       R0, 0 
L__wait_for_input202:
	BTFSS       STATUS+0, 0 
	GOTO        L_wait_for_input13
;home_control.c,158 :: 		if (is_data_ready(interface)){
	MOVF        FARG_wait_for_input_interface+0, 0 
	MOVWF       FARG_is_data_ready_interface+0 
	CALL        _is_data_ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_wait_for_input14
;home_control.c,159 :: 		if (i == 30) i = 0;
	MOVLW       0
	XORWF       wait_for_input_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__wait_for_input203
	MOVLW       30
	XORWF       wait_for_input_i_L0+0, 0 
L__wait_for_input203:
	BTFSS       STATUS+0, 2 
	GOTO        L_wait_for_input15
	CLRF        wait_for_input_i_L0+0 
	CLRF        wait_for_input_i_L0+1 
L_wait_for_input15:
;home_control.c,160 :: 		buffer[i++] = read_single_byte(interface);
	MOVLW       wait_for_input_buffer_L0+0
	ADDWF       wait_for_input_i_L0+0, 0 
	MOVWF       FLOC__wait_for_input+0 
	MOVLW       hi_addr(wait_for_input_buffer_L0+0)
	ADDWFC      wait_for_input_i_L0+1, 0 
	MOVWF       FLOC__wait_for_input+1 
	MOVF        FARG_wait_for_input_interface+0, 0 
	MOVWF       FARG_read_single_byte_interface+0 
	CALL        _read_single_byte+0, 0
	MOVFF       FLOC__wait_for_input+0, FSR1
	MOVFF       FLOC__wait_for_input+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      wait_for_input_i_L0+0, 1 
	INCF        wait_for_input_i_L0+1, 1 
;home_control.c,161 :: 		if (strstr(buffer,input) != 0){
	MOVLW       wait_for_input_buffer_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(wait_for_input_buffer_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVF        FARG_wait_for_input_input+0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        FARG_wait_for_input_input+1, 0 
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__wait_for_input204
	MOVLW       0
	XORWF       R0, 0 
L__wait_for_input204:
	BTFSC       STATUS+0, 2 
	GOTO        L_wait_for_input16
;home_control.c,162 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;home_control.c,163 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	GOTO        L_end_wait_for_input
;home_control.c,164 :: 		}
L_wait_for_input16:
;home_control.c,165 :: 		} else {
	GOTO        L_wait_for_input17
L_wait_for_input14:
;home_control.c,166 :: 		mils++;
	INFSNZ      wait_for_input_mils_L0+0, 1 
	INCF        wait_for_input_mils_L0+1, 1 
;home_control.c,167 :: 		delay_ms(1);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_wait_for_input18:
	DECFSZ      R13, 1, 1
	BRA         L_wait_for_input18
	DECFSZ      R12, 1, 1
	BRA         L_wait_for_input18
	NOP
;home_control.c,168 :: 		}
L_wait_for_input17:
;home_control.c,169 :: 		}
	GOTO        L_wait_for_input12
L_wait_for_input13:
;home_control.c,170 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;home_control.c,172 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;home_control.c,173 :: 		}
L_end_wait_for_input:
	RETURN      0
; end of _wait_for_input

_itoa:

;home_control.c,176 :: 		char * itoa(int i, char b[]){
;home_control.c,178 :: 		char* p = b;
	MOVF        FARG_itoa_b+0, 0 
	MOVWF       itoa_p_L0+0 
	MOVF        FARG_itoa_b+1, 0 
	MOVWF       itoa_p_L0+1 
;home_control.c,180 :: 		if(i<0){
	MOVLW       128
	XORWF       FARG_itoa_i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__itoa206
	MOVLW       0
	SUBWF       FARG_itoa_i+0, 0 
L__itoa206:
	BTFSC       STATUS+0, 0 
	GOTO        L_itoa19
;home_control.c,181 :: 		*p++ = '-';
	MOVFF       itoa_p_L0+0, FSR1
	MOVFF       itoa_p_L0+1, FSR1H
	MOVLW       45
	MOVWF       POSTINC1+0 
	INFSNZ      itoa_p_L0+0, 1 
	INCF        itoa_p_L0+1, 1 
;home_control.c,182 :: 		i *= -1;
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
;home_control.c,183 :: 		}
L_itoa19:
;home_control.c,184 :: 		shifter = i;
	MOVF        FARG_itoa_i+0, 0 
	MOVWF       itoa_shifter_L0+0 
	MOVF        FARG_itoa_i+1, 0 
	MOVWF       itoa_shifter_L0+1 
;home_control.c,185 :: 		do{ //Move to where representation ends
L_itoa20:
;home_control.c,186 :: 		++p;
	INFSNZ      itoa_p_L0+0, 1 
	INCF        itoa_p_L0+1, 1 
;home_control.c,187 :: 		shifter = shifter/10;
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
;home_control.c,188 :: 		}while(shifter);
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_itoa20
;home_control.c,189 :: 		*p = '\0';
	MOVFF       itoa_p_L0+0, FSR1
	MOVFF       itoa_p_L0+1, FSR1H
	CLRF        POSTINC1+0 
;home_control.c,190 :: 		do{ //Move back, inserting digits as u go
L_itoa23:
;home_control.c,191 :: 		*--p = digit[i%10];
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
;home_control.c,192 :: 		i = i/10;
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
;home_control.c,193 :: 		}while(i);
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_itoa23
;home_control.c,194 :: 		return b;
	MOVF        FARG_itoa_b+0, 0 
	MOVWF       R0 
	MOVF        FARG_itoa_b+1, 0 
	MOVWF       R1 
;home_control.c,195 :: 		}
L_end_itoa:
	RETURN      0
; end of _itoa

_cipsend:

;home_control.c,197 :: 		void cipsend(char *p, char interface){
;home_control.c,200 :: 		if (interface == WIFI){
	MOVF        FARG_cipsend_interface+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_cipsend26
;home_control.c,201 :: 		int size=0;
	CLRF        cipsend_size_L1+0 
	CLRF        cipsend_size_L1+1 
;home_control.c,202 :: 		char *b = p;
	MOVF        FARG_cipsend_p+0, 0 
	MOVWF       cipsend_b_L1+0 
	MOVF        FARG_cipsend_p+1, 0 
	MOVWF       cipsend_b_L1+1 
;home_control.c,203 :: 		for (;*b++ != '\0';size++) ;
L_cipsend27:
	MOVF        cipsend_b_L1+0, 0 
	MOVWF       R1 
	MOVF        cipsend_b_L1+1, 0 
	MOVWF       R2 
	INFSNZ      cipsend_b_L1+0, 1 
	INCF        cipsend_b_L1+1, 1 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_cipsend28
	INFSNZ      cipsend_size_L1+0, 1 
	INCF        cipsend_size_L1+1, 1 
	GOTO        L_cipsend27
L_cipsend28:
;home_control.c,205 :: 		UART1_Write_Text("AT+CIPSEND=0,");
	MOVLW       ?lstr3_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,206 :: 		UART1_Write_Text(itoa(size,conv));
	MOVF        cipsend_size_L1+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        cipsend_size_L1+1, 0 
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
;home_control.c,207 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr4_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,208 :: 		} else {
	GOTO        L_cipsend30
L_cipsend26:
;home_control.c,209 :: 		UART2_Write_Text("AT+CIPSEND\r");
	MOVLW       ?lstr5_home_control+0
	MOVWF       FARG_UART2_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_home_control+0)
	MOVWF       FARG_UART2_Write_Text_uart_text+1 
	CALL        _UART2_Write_Text+0, 0
;home_control.c,210 :: 		}
L_cipsend30:
;home_control.c,212 :: 		if (wait_for_input(">",2,interface) == 0){
	MOVLW       ?lstr6_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr6_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       2
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	MOVF        FARG_cipsend_interface+0, 0 
	MOVWF       FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__cipsend208
	MOVLW       0
	XORWF       R0, 0 
L__cipsend208:
	BTFSS       STATUS+0, 2 
	GOTO        L_cipsend31
;home_control.c,213 :: 		network_data.network_status = NETWORK_NOT_CONNECTED;
	CLRF        _Network_data+86 
;home_control.c,214 :: 		network_data.isWifiConnected = FALSE;
	CLRF        _Network_data+87 
;home_control.c,215 :: 		network_data.isGprsConnected = FALSE;
	CLRF        _Network_data+88 
;home_control.c,216 :: 		}
L_cipsend31:
;home_control.c,218 :: 		if (interface == WIFI){
	MOVF        FARG_cipsend_interface+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_cipsend32
;home_control.c,219 :: 		UART1_Write_Text(p);
	MOVF        FARG_cipsend_p+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        FARG_cipsend_p+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,220 :: 		} else {
	GOTO        L_cipsend33
L_cipsend32:
;home_control.c,221 :: 		UART2_Write_Text(p);
	MOVF        FARG_cipsend_p+0, 0 
	MOVWF       FARG_UART2_Write_Text_uart_text+0 
	MOVF        FARG_cipsend_p+1, 0 
	MOVWF       FARG_UART2_Write_Text_uart_text+1 
	CALL        _UART2_Write_Text+0, 0
;home_control.c,222 :: 		UART2_Write(26);
	MOVLW       26
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;home_control.c,223 :: 		UART2_Write(0x0D);
	MOVLW       13
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;home_control.c,224 :: 		}
L_cipsend33:
;home_control.c,227 :: 		}
L_end_cipsend:
	RETURN      0
; end of _cipsend

_set_admin:

;home_control.c,233 :: 		void set_admin(char *phone_number){
;home_control.c,236 :: 		strcpy(to_write,"#");
	MOVLW       set_admin_to_write_L0+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(set_admin_to_write_L0+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr7_home_control+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr7_home_control+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;home_control.c,237 :: 		strcat(to_write,phone_number);
	MOVLW       set_admin_to_write_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(set_admin_to_write_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVF        FARG_set_admin_phone_number+0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        FARG_set_admin_phone_number+1, 0 
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,238 :: 		strcat(to_write,"#");
	MOVLW       set_admin_to_write_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(set_admin_to_write_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr8_home_control+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr8_home_control+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,240 :: 		for (i=0;i<strlen(to_write);i++){
	CLRF        set_admin_i_L0+0 
	CLRF        set_admin_i_L0+1 
L_set_admin34:
	MOVLW       set_admin_to_write_L0+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(set_admin_to_write_L0+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       128
	XORWF       set_admin_i_L0+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__set_admin210
	MOVF        R0, 0 
	SUBWF       set_admin_i_L0+0, 0 
L__set_admin210:
	BTFSC       STATUS+0, 0 
	GOTO        L_set_admin35
;home_control.c,241 :: 		EEPROM_Write(i,to_write[i]);
	MOVF        set_admin_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        set_admin_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Write_address+1 
	MOVLW       set_admin_to_write_L0+0
	ADDWF       set_admin_i_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(set_admin_to_write_L0+0)
	ADDWFC      set_admin_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;home_control.c,240 :: 		for (i=0;i<strlen(to_write);i++){
	INFSNZ      set_admin_i_L0+0, 1 
	INCF        set_admin_i_L0+1, 1 
;home_control.c,242 :: 		}
	GOTO        L_set_admin34
L_set_admin35:
;home_control.c,243 :: 		}
L_end_set_admin:
	RETURN      0
; end of _set_admin

_get_admin:

;home_control.c,245 :: 		char *get_admin(char *phone_number){
;home_control.c,246 :: 		int i,j=0;
	CLRF        get_admin_j_L0+0 
	CLRF        get_admin_j_L0+1 
	CLRF        get_admin_flag_L0+0 
;home_control.c,248 :: 		char *p1 = phone_number;
	MOVF        FARG_get_admin_phone_number+0, 0 
	MOVWF       get_admin_p1_L0+0 
	MOVF        FARG_get_admin_phone_number+1, 0 
	MOVWF       get_admin_p1_L0+1 
;home_control.c,249 :: 		for (i=0;i<20;i++){
	CLRF        get_admin_i_L0+0 
	CLRF        get_admin_i_L0+1 
L_get_admin37:
	MOVLW       128
	XORWF       get_admin_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_admin212
	MOVLW       20
	SUBWF       get_admin_i_L0+0, 0 
L__get_admin212:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_admin38
;home_control.c,251 :: 		if (dat == '#'){
	MOVF        get_admin_dat_L0+0, 0 
	XORLW       35
	BTFSS       STATUS+0, 2 
	GOTO        L_get_admin40
;home_control.c,252 :: 		flag=!flag;
	MOVF        get_admin_flag_L0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       get_admin_flag_L0+0 
;home_control.c,253 :: 		}
L_get_admin40:
;home_control.c,254 :: 		dat = EEPROM_READ(i);
	MOVF        get_admin_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        get_admin_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       get_admin_dat_L0+0 
;home_control.c,256 :: 		if (flag == 1){
	MOVF        get_admin_flag_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_get_admin41
;home_control.c,257 :: 		if (dat != '#'){
	MOVF        get_admin_dat_L0+0, 0 
	XORLW       35
	BTFSC       STATUS+0, 2 
	GOTO        L_get_admin42
;home_control.c,258 :: 		*phone_number++ = dat;
	MOVFF       FARG_get_admin_phone_number+0, FSR1
	MOVFF       FARG_get_admin_phone_number+1, FSR1H
	MOVF        get_admin_dat_L0+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      FARG_get_admin_phone_number+0, 1 
	INCF        FARG_get_admin_phone_number+1, 1 
;home_control.c,259 :: 		j++;
	INFSNZ      get_admin_j_L0+0, 1 
	INCF        get_admin_j_L0+1, 1 
;home_control.c,260 :: 		}
L_get_admin42:
;home_control.c,261 :: 		} else {
	GOTO        L_get_admin43
L_get_admin41:
;home_control.c,262 :: 		if (j > 0){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       get_admin_j_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_admin213
	MOVF        get_admin_j_L0+0, 0 
	SUBLW       0
L__get_admin213:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_admin44
;home_control.c,263 :: 		*phone_number = '\0';
	MOVFF       FARG_get_admin_phone_number+0, FSR1
	MOVFF       FARG_get_admin_phone_number+1, FSR1H
	CLRF        POSTINC1+0 
;home_control.c,264 :: 		return p1;
	MOVF        get_admin_p1_L0+0, 0 
	MOVWF       R0 
	MOVF        get_admin_p1_L0+1, 0 
	MOVWF       R1 
	GOTO        L_end_get_admin
;home_control.c,265 :: 		}
L_get_admin44:
;home_control.c,266 :: 		}
L_get_admin43:
;home_control.c,249 :: 		for (i=0;i<20;i++){
	INFSNZ      get_admin_i_L0+0, 1 
	INCF        get_admin_i_L0+1, 1 
;home_control.c,267 :: 		}
	GOTO        L_get_admin37
L_get_admin38:
;home_control.c,268 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;home_control.c,269 :: 		}
L_end_get_admin:
	RETURN      0
; end of _get_admin

_verify_relay_access:

;home_control.c,270 :: 		int verify_relay_access(char *phone_number, int relay, char isCall ){
;home_control.c,271 :: 		int i,j=0,flag=0;
	CLRF        verify_relay_access_j_L0+0 
	CLRF        verify_relay_access_j_L0+1 
	CLRF        verify_relay_access_flag_L0+0 
	CLRF        verify_relay_access_flag_L0+1 
;home_control.c,273 :: 		for (i=EEPROM_RELAY_START;i<EEPROM_RELAY_END;i++){
	MOVLW       72
	MOVWF       verify_relay_access_i_L0+0 
	MOVLW       3
	MOVWF       verify_relay_access_i_L0+1 
L_verify_relay_access45:
	MOVLW       128
	XORWF       verify_relay_access_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       4
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__verify_relay_access215
	MOVLW       0
	SUBWF       verify_relay_access_i_L0+0, 0 
L__verify_relay_access215:
	BTFSC       STATUS+0, 0 
	GOTO        L_verify_relay_access46
;home_control.c,275 :: 		dat = EEPROM_READ(i);
	MOVF        verify_relay_access_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        verify_relay_access_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       verify_relay_access_dat_L0+0 
;home_control.c,276 :: 		if (dat == '#'){
	MOVF        R0, 0 
	XORLW       35
	BTFSS       STATUS+0, 2 
	GOTO        L_verify_relay_access48
;home_control.c,277 :: 		flag=!flag;
	MOVF        verify_relay_access_flag_L0+0, 0 
	IORWF       verify_relay_access_flag_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       verify_relay_access_flag_L0+0 
	MOVLW       0
	MOVWF       verify_relay_access_flag_L0+1 
;home_control.c,278 :: 		}
L_verify_relay_access48:
;home_control.c,280 :: 		if (flag == 1){
	MOVLW       0
	XORWF       verify_relay_access_flag_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__verify_relay_access216
	MOVLW       1
	XORWF       verify_relay_access_flag_L0+0, 0 
L__verify_relay_access216:
	BTFSS       STATUS+0, 2 
	GOTO        L_verify_relay_access49
;home_control.c,281 :: 		read[j++] = dat;
	MOVLW       verify_relay_access_read_L0+0
	ADDWF       verify_relay_access_j_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(verify_relay_access_read_L0+0)
	ADDWFC      verify_relay_access_j_L0+1, 0 
	MOVWF       FSR1H 
	MOVF        verify_relay_access_dat_L0+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      verify_relay_access_j_L0+0, 1 
	INCF        verify_relay_access_j_L0+1, 1 
;home_control.c,282 :: 		} else {
	GOTO        L_verify_relay_access50
L_verify_relay_access49:
;home_control.c,283 :: 		if (j > 0){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       verify_relay_access_j_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__verify_relay_access217
	MOVF        verify_relay_access_j_L0+0, 0 
	SUBLW       0
L__verify_relay_access217:
	BTFSC       STATUS+0, 0 
	GOTO        L_verify_relay_access51
;home_control.c,284 :: 		read[j++] = '#';
	MOVLW       verify_relay_access_read_L0+0
	ADDWF       verify_relay_access_j_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(verify_relay_access_read_L0+0)
	ADDWFC      verify_relay_access_j_L0+1, 0 
	MOVWF       FSR1H 
	MOVLW       35
	MOVWF       POSTINC1+0 
	INFSNZ      verify_relay_access_j_L0+0, 1 
	INCF        verify_relay_access_j_L0+1, 1 
;home_control.c,285 :: 		read[j] = '\0';
	MOVLW       verify_relay_access_read_L0+0
	ADDWF       verify_relay_access_j_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(verify_relay_access_read_L0+0)
	ADDWFC      verify_relay_access_j_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;home_control.c,287 :: 		if ( strstr(read,phone_number) != 0 ){
	MOVLW       verify_relay_access_read_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(verify_relay_access_read_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVF        FARG_verify_relay_access_phone_number+0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        FARG_verify_relay_access_phone_number+1, 0 
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__verify_relay_access218
	MOVLW       0
	XORWF       R0, 0 
L__verify_relay_access218:
	BTFSC       STATUS+0, 2 
	GOTO        L_verify_relay_access52
;home_control.c,289 :: 		p1 = strtok(read,";");
	MOVLW       verify_relay_access_read_L0+0
	MOVWF       FARG_strtok_s1+0 
	MOVLW       hi_addr(verify_relay_access_read_L0+0)
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr9_home_control+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr9_home_control+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
;home_control.c,290 :: 		p1 = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr10_home_control+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr10_home_control+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
;home_control.c,291 :: 		strcpy(config,p1);
	MOVLW       verify_relay_access_config_L4+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(verify_relay_access_config_L4+0)
	MOVWF       FARG_strcpy_to+1 
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;home_control.c,293 :: 		if (isCall){
	MOVF        FARG_verify_relay_access_isCall+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_verify_relay_access53
;home_control.c,294 :: 		int rel = atoi(strtok(0,"#"));
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr11_home_control+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr11_home_control+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        R1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       verify_relay_access_rel_L5+0 
	MOVF        R1, 0 
	MOVWF       verify_relay_access_rel_L5+1 
;home_control.c,295 :: 		if (config[rel] == '1')
	MOVLW       verify_relay_access_config_L4+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(verify_relay_access_config_L4+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_verify_relay_access54
;home_control.c,296 :: 		return rel;
	MOVF        verify_relay_access_rel_L5+0, 0 
	MOVWF       R0 
	MOVF        verify_relay_access_rel_L5+1, 0 
	MOVWF       R1 
	GOTO        L_end_verify_relay_access
L_verify_relay_access54:
;home_control.c,298 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_verify_relay_access
;home_control.c,299 :: 		}
L_verify_relay_access53:
;home_control.c,300 :: 		return config[relay] - '0';
	MOVLW       verify_relay_access_config_L4+0
	ADDWF       FARG_verify_relay_access_relay+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(verify_relay_access_config_L4+0)
	ADDWFC      FARG_verify_relay_access_relay+1, 0 
	MOVWF       FSR0H 
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	GOTO        L_end_verify_relay_access
;home_control.c,301 :: 		} else {
L_verify_relay_access52:
;home_control.c,302 :: 		j = 0;
	CLRF        verify_relay_access_j_L0+0 
	CLRF        verify_relay_access_j_L0+1 
;home_control.c,303 :: 		memset(read," ",sizeof(read)-1);
	MOVLW       verify_relay_access_read_L0+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(verify_relay_access_read_L0+0)
	MOVWF       FARG_memset_p1+1 
	MOVLW       ?lstr_12_home_control+0
	MOVWF       FARG_memset_character+0 
	MOVLW       26
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;home_control.c,305 :: 		}
L_verify_relay_access51:
;home_control.c,306 :: 		}
L_verify_relay_access50:
;home_control.c,273 :: 		for (i=EEPROM_RELAY_START;i<EEPROM_RELAY_END;i++){
	INFSNZ      verify_relay_access_i_L0+0, 1 
	INCF        verify_relay_access_i_L0+1, 1 
;home_control.c,307 :: 		}
	GOTO        L_verify_relay_access45
L_verify_relay_access46:
;home_control.c,308 :: 		return FALSE;
	CLRF        R0 
	CLRF        R1 
;home_control.c,309 :: 		}
L_end_verify_relay_access:
	RETURN      0
; end of _verify_relay_access

_build_user_config_string:

;home_control.c,311 :: 		void build_user_config_string(char *buffer, char *relay_access, char *relay_call){
;home_control.c,313 :: 		int size = 0,i;
	CLRF        build_user_config_string_size_L0+0 
	CLRF        build_user_config_string_size_L0+1 
;home_control.c,314 :: 		p1 = relay_access;
	MOVF        FARG_build_user_config_string_relay_access+0, 0 
	MOVWF       build_user_config_string_p1_L0+0 
	MOVF        FARG_build_user_config_string_relay_access+1, 0 
	MOVWF       build_user_config_string_p1_L0+1 
;home_control.c,315 :: 		for (;*p1++ != '\0';size++);
L_build_user_config_string57:
	MOVF        build_user_config_string_p1_L0+0, 0 
	MOVWF       R1 
	MOVF        build_user_config_string_p1_L0+1, 0 
	MOVWF       R2 
	INFSNZ      build_user_config_string_p1_L0+0, 1 
	INCF        build_user_config_string_p1_L0+1, 1 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_build_user_config_string58
	INFSNZ      build_user_config_string_size_L0+0, 1 
	INCF        build_user_config_string_size_L0+1, 1 
	GOTO        L_build_user_config_string57
L_build_user_config_string58:
;home_control.c,316 :: 		if (size > 9) size = 9;
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       build_user_config_string_size_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__build_user_config_string220
	MOVF        build_user_config_string_size_L0+0, 0 
	SUBLW       9
L__build_user_config_string220:
	BTFSC       STATUS+0, 0 
	GOTO        L_build_user_config_string60
	MOVLW       9
	MOVWF       build_user_config_string_size_L0+0 
	MOVLW       0
	MOVWF       build_user_config_string_size_L0+1 
L_build_user_config_string60:
;home_control.c,318 :: 		*buffer++ = ';';
	MOVFF       FARG_build_user_config_string_buffer+0, FSR1
	MOVFF       FARG_build_user_config_string_buffer+1, FSR1H
	MOVLW       59
	MOVWF       POSTINC1+0 
	INFSNZ      FARG_build_user_config_string_buffer+0, 1 
	INCF        FARG_build_user_config_string_buffer+1, 1 
;home_control.c,320 :: 		for (i=0;i<size;i++){
	CLRF        build_user_config_string_i_L0+0 
	CLRF        build_user_config_string_i_L0+1 
L_build_user_config_string61:
	MOVLW       128
	XORWF       build_user_config_string_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       build_user_config_string_size_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__build_user_config_string221
	MOVF        build_user_config_string_size_L0+0, 0 
	SUBWF       build_user_config_string_i_L0+0, 0 
L__build_user_config_string221:
	BTFSC       STATUS+0, 0 
	GOTO        L_build_user_config_string62
;home_control.c,321 :: 		char ch = *relay_access++;
	MOVFF       FARG_build_user_config_string_relay_access+0, FSR0
	MOVFF       FARG_build_user_config_string_relay_access+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       build_user_config_string_ch_L1+0 
	INFSNZ      FARG_build_user_config_string_relay_access+0, 1 
	INCF        FARG_build_user_config_string_relay_access+1, 1 
;home_control.c,322 :: 		if (ch == '0' || ch == '1'){
	MOVF        R1, 0 
	XORLW       48
	BTFSC       STATUS+0, 2 
	GOTO        L__build_user_config_string190
	MOVF        build_user_config_string_ch_L1+0, 0 
	XORLW       49
	BTFSC       STATUS+0, 2 
	GOTO        L__build_user_config_string190
	GOTO        L_build_user_config_string66
L__build_user_config_string190:
;home_control.c,323 :: 		*buffer++ = ch;
	MOVFF       FARG_build_user_config_string_buffer+0, FSR1
	MOVFF       FARG_build_user_config_string_buffer+1, FSR1H
	MOVF        build_user_config_string_ch_L1+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      FARG_build_user_config_string_buffer+0, 1 
	INCF        FARG_build_user_config_string_buffer+1, 1 
;home_control.c,324 :: 		} else {
	GOTO        L_build_user_config_string67
L_build_user_config_string66:
;home_control.c,325 :: 		*buffer++ = '0';
	MOVFF       FARG_build_user_config_string_buffer+0, FSR1
	MOVFF       FARG_build_user_config_string_buffer+1, FSR1H
	MOVLW       48
	MOVWF       POSTINC1+0 
	INFSNZ      FARG_build_user_config_string_buffer+0, 1 
	INCF        FARG_build_user_config_string_buffer+1, 1 
;home_control.c,326 :: 		}
L_build_user_config_string67:
;home_control.c,320 :: 		for (i=0;i<size;i++){
	INFSNZ      build_user_config_string_i_L0+0, 1 
	INCF        build_user_config_string_i_L0+1, 1 
;home_control.c,327 :: 		}
	GOTO        L_build_user_config_string61
L_build_user_config_string62:
;home_control.c,328 :: 		for (i=size;i<9;i++){
	MOVF        build_user_config_string_size_L0+0, 0 
	MOVWF       build_user_config_string_i_L0+0 
	MOVF        build_user_config_string_size_L0+1, 0 
	MOVWF       build_user_config_string_i_L0+1 
L_build_user_config_string68:
	MOVLW       128
	XORWF       build_user_config_string_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__build_user_config_string222
	MOVLW       9
	SUBWF       build_user_config_string_i_L0+0, 0 
L__build_user_config_string222:
	BTFSC       STATUS+0, 0 
	GOTO        L_build_user_config_string69
;home_control.c,329 :: 		*buffer++ = '0';
	MOVFF       FARG_build_user_config_string_buffer+0, FSR1
	MOVFF       FARG_build_user_config_string_buffer+1, FSR1H
	MOVLW       48
	MOVWF       POSTINC1+0 
	INFSNZ      FARG_build_user_config_string_buffer+0, 1 
	INCF        FARG_build_user_config_string_buffer+1, 1 
;home_control.c,328 :: 		for (i=size;i<9;i++){
	INFSNZ      build_user_config_string_i_L0+0, 1 
	INCF        build_user_config_string_i_L0+1, 1 
;home_control.c,330 :: 		}
	GOTO        L_build_user_config_string68
L_build_user_config_string69:
;home_control.c,331 :: 		*buffer++ = ';';
	MOVFF       FARG_build_user_config_string_buffer+0, FSR1
	MOVFF       FARG_build_user_config_string_buffer+1, FSR1H
	MOVLW       59
	MOVWF       POSTINC1+0 
	INFSNZ      FARG_build_user_config_string_buffer+0, 1 
	INCF        FARG_build_user_config_string_buffer+1, 1 
;home_control.c,332 :: 		if (atoi(relay_call) <= 9 && atoi(relay_call) != 0){
	MOVF        FARG_build_user_config_string_relay_call+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        FARG_build_user_config_string_relay_call+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVLW       128
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__build_user_config_string223
	MOVF        R0, 0 
	SUBLW       9
L__build_user_config_string223:
	BTFSS       STATUS+0, 0 
	GOTO        L_build_user_config_string73
	MOVF        FARG_build_user_config_string_relay_call+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        FARG_build_user_config_string_relay_call+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__build_user_config_string224
	MOVLW       0
	XORWF       R0, 0 
L__build_user_config_string224:
	BTFSC       STATUS+0, 2 
	GOTO        L_build_user_config_string73
L__build_user_config_string189:
;home_control.c,333 :: 		*buffer++ = *relay_call;
	MOVFF       FARG_build_user_config_string_relay_call+0, FSR0
	MOVFF       FARG_build_user_config_string_relay_call+1, FSR0H
	MOVFF       FARG_build_user_config_string_buffer+0, FSR1
	MOVFF       FARG_build_user_config_string_buffer+1, FSR1H
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      FARG_build_user_config_string_buffer+0, 1 
	INCF        FARG_build_user_config_string_buffer+1, 1 
;home_control.c,334 :: 		} else {
	GOTO        L_build_user_config_string74
L_build_user_config_string73:
;home_control.c,335 :: 		*buffer++ = '0';
	MOVFF       FARG_build_user_config_string_buffer+0, FSR1
	MOVFF       FARG_build_user_config_string_buffer+1, FSR1H
	MOVLW       48
	MOVWF       POSTINC1+0 
	INFSNZ      FARG_build_user_config_string_buffer+0, 1 
	INCF        FARG_build_user_config_string_buffer+1, 1 
;home_control.c,336 :: 		}
L_build_user_config_string74:
;home_control.c,337 :: 		*buffer = '#';
	MOVFF       FARG_build_user_config_string_buffer+0, FSR1
	MOVFF       FARG_build_user_config_string_buffer+1, FSR1H
	MOVLW       35
	MOVWF       POSTINC1+0 
;home_control.c,338 :: 		}
L_end_build_user_config_string:
	RETURN      0
; end of _build_user_config_string

_add_user:

;home_control.c,340 :: 		char add_user(char *phone_number, char *relay_access, char *relay_call){
;home_control.c,341 :: 		int i,j=0,flag=0;
	CLRF        add_user_j_L0+0 
	CLRF        add_user_j_L0+1 
	CLRF        add_user_flag_L0+0 
	CLRF        add_user_flag_L0+1 
;home_control.c,344 :: 		for (i=EEPROM_USER_START;i<EEPROM_USER_END;i++){
	MOVLW       20
	MOVWF       add_user_i_L0+0 
	MOVLW       0
	MOVWF       add_user_i_L0+1 
L_add_user75:
	MOVLW       128
	XORWF       add_user_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__add_user226
	MOVLW       72
	SUBWF       add_user_i_L0+0, 0 
L__add_user226:
	BTFSC       STATUS+0, 0 
	GOTO        L_add_user76
;home_control.c,346 :: 		dat = EEPROM_READ(i);
	MOVF        add_user_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        add_user_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       add_user_dat_L0+0 
;home_control.c,347 :: 		if (dat == '#'){
	MOVF        R0, 0 
	XORLW       35
	BTFSS       STATUS+0, 2 
	GOTO        L_add_user78
;home_control.c,348 :: 		flag=!flag;
	MOVF        add_user_flag_L0+0, 0 
	IORWF       add_user_flag_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       add_user_flag_L0+0 
	MOVLW       0
	MOVWF       add_user_flag_L0+1 
;home_control.c,349 :: 		}
L_add_user78:
;home_control.c,351 :: 		if (flag == 1){
	MOVLW       0
	XORWF       add_user_flag_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__add_user227
	MOVLW       1
	XORWF       add_user_flag_L0+0, 0 
L__add_user227:
	BTFSS       STATUS+0, 2 
	GOTO        L_add_user79
;home_control.c,352 :: 		to_write[j++] = dat;
	MOVLW       add_user_to_write_L0+0
	ADDWF       add_user_j_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(add_user_to_write_L0+0)
	ADDWFC      add_user_j_L0+1, 0 
	MOVWF       FSR1H 
	MOVF        add_user_dat_L0+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      add_user_j_L0+0, 1 
	INCF        add_user_j_L0+1, 1 
;home_control.c,353 :: 		} else {
	GOTO        L_add_user80
L_add_user79:
;home_control.c,354 :: 		if (j > 0){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       add_user_j_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__add_user228
	MOVF        add_user_j_L0+0, 0 
	SUBLW       0
L__add_user228:
	BTFSC       STATUS+0, 0 
	GOTO        L_add_user81
;home_control.c,355 :: 		if ( strstr(to_write,phone_number) != 0 ){
	MOVLW       add_user_to_write_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(add_user_to_write_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVF        FARG_add_user_phone_number+0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        FARG_add_user_phone_number+1, 0 
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__add_user229
	MOVLW       0
	XORWF       R0, 0 
L__add_user229:
	BTFSC       STATUS+0, 2 
	GOTO        L_add_user82
;home_control.c,356 :: 		return FALSE;
	CLRF        R0 
	GOTO        L_end_add_user
;home_control.c,357 :: 		} else {
L_add_user82:
;home_control.c,358 :: 		j = 0;
	CLRF        add_user_j_L0+0 
	CLRF        add_user_j_L0+1 
;home_control.c,359 :: 		memset(to_write," ",sizeof(to_write)-1);
	MOVLW       add_user_to_write_L0+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(add_user_to_write_L0+0)
	MOVWF       FARG_memset_p1+1 
	MOVLW       ?lstr_13_home_control+0
	MOVWF       FARG_memset_character+0 
	MOVLW       26
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;home_control.c,361 :: 		}
L_add_user81:
;home_control.c,362 :: 		}
L_add_user80:
;home_control.c,364 :: 		if (dat == 254){
	MOVF        add_user_dat_L0+0, 0 
	XORLW       254
	BTFSS       STATUS+0, 2 
	GOTO        L_add_user84
;home_control.c,367 :: 		build_user_config_string(buffer, relay_access, relay_call);
	MOVLW       add_user_buffer_L2+0
	MOVWF       FARG_build_user_config_string_buffer+0 
	MOVLW       hi_addr(add_user_buffer_L2+0)
	MOVWF       FARG_build_user_config_string_buffer+1 
	MOVF        FARG_add_user_relay_access+0, 0 
	MOVWF       FARG_build_user_config_string_relay_access+0 
	MOVF        FARG_add_user_relay_access+1, 0 
	MOVWF       FARG_build_user_config_string_relay_access+1 
	MOVF        FARG_add_user_relay_call+0, 0 
	MOVWF       FARG_build_user_config_string_relay_call+0 
	MOVF        FARG_add_user_relay_call+1, 0 
	MOVWF       FARG_build_user_config_string_relay_call+1 
	CALL        _build_user_config_string+0, 0
;home_control.c,369 :: 		strcpy(to_write,"#");
	MOVLW       add_user_to_write_L0+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(add_user_to_write_L0+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr14_home_control+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr14_home_control+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;home_control.c,370 :: 		strcat(to_write,phone_number);
	MOVLW       add_user_to_write_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(add_user_to_write_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVF        FARG_add_user_phone_number+0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        FARG_add_user_phone_number+1, 0 
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,371 :: 		strcat(to_write,buffer);
	MOVLW       add_user_to_write_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(add_user_to_write_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       add_user_buffer_L2+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(add_user_buffer_L2+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,373 :: 		if (i < EEPROM_USER_END-strlen(to_write)){
	MOVLW       add_user_to_write_L0+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(add_user_to_write_L0+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	SUBLW       72
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVLW       3
	SUBFWB      R3, 1 
	MOVLW       128
	XORWF       add_user_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__add_user230
	MOVF        R2, 0 
	SUBWF       add_user_i_L0+0, 0 
L__add_user230:
	BTFSC       STATUS+0, 0 
	GOTO        L_add_user85
;home_control.c,374 :: 		for (k=0;k<strlen(to_write);k++){
	CLRF        add_user_k_L2+0 
	CLRF        add_user_k_L2+1 
L_add_user86:
	MOVLW       add_user_to_write_L0+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(add_user_to_write_L0+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       128
	XORWF       add_user_k_L2+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__add_user231
	MOVF        R0, 0 
	SUBWF       add_user_k_L2+0, 0 
L__add_user231:
	BTFSC       STATUS+0, 0 
	GOTO        L_add_user87
;home_control.c,375 :: 		EEPROM_Write(i++,to_write[k]);
	MOVF        add_user_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        add_user_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Write_address+1 
	MOVLW       add_user_to_write_L0+0
	ADDWF       add_user_k_L2+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(add_user_to_write_L0+0)
	ADDWFC      add_user_k_L2+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
	INFSNZ      add_user_i_L0+0, 1 
	INCF        add_user_i_L0+1, 1 
;home_control.c,374 :: 		for (k=0;k<strlen(to_write);k++){
	INFSNZ      add_user_k_L2+0, 1 
	INCF        add_user_k_L2+1, 1 
;home_control.c,376 :: 		}
	GOTO        L_add_user86
L_add_user87:
;home_control.c,377 :: 		return TRUE;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_add_user
;home_control.c,378 :: 		}
L_add_user85:
;home_control.c,380 :: 		}
L_add_user84:
;home_control.c,344 :: 		for (i=EEPROM_USER_START;i<EEPROM_USER_END;i++){
	INFSNZ      add_user_i_L0+0, 1 
	INCF        add_user_i_L0+1, 1 
;home_control.c,381 :: 		}
	GOTO        L_add_user75
L_add_user76:
;home_control.c,382 :: 		return FALSE;
	CLRF        R0 
;home_control.c,383 :: 		}
L_end_add_user:
	RETURN      0
; end of _add_user

_remove_user:

;home_control.c,385 :: 		int remove_user(char *phone_number){
;home_control.c,386 :: 		int i,j=0,flag=0;
	CLRF        remove_user_j_L0+0 
	CLRF        remove_user_j_L0+1 
	CLRF        remove_user_flag_L0+0 
	CLRF        remove_user_flag_L0+1 
;home_control.c,389 :: 		for (i=EEPROM_USER_START;i<EEPROM_USER_END;i++){
	MOVLW       20
	MOVWF       remove_user_i_L0+0 
	MOVLW       0
	MOVWF       remove_user_i_L0+1 
L_remove_user89:
	MOVLW       128
	XORWF       remove_user_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__remove_user233
	MOVLW       72
	SUBWF       remove_user_i_L0+0, 0 
L__remove_user233:
	BTFSC       STATUS+0, 0 
	GOTO        L_remove_user90
;home_control.c,391 :: 		dat = EEPROM_READ(i);
	MOVF        remove_user_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        remove_user_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       remove_user_dat_L0+0 
;home_control.c,392 :: 		if (dat == '#'){
	MOVF        R0, 0 
	XORLW       35
	BTFSS       STATUS+0, 2 
	GOTO        L_remove_user92
;home_control.c,393 :: 		flag=!flag;
	MOVF        remove_user_flag_L0+0, 0 
	IORWF       remove_user_flag_L0+1, 0 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       remove_user_flag_L0+0 
	MOVLW       0
	MOVWF       remove_user_flag_L0+1 
;home_control.c,394 :: 		}
L_remove_user92:
;home_control.c,396 :: 		if (flag == 1){
	MOVLW       0
	XORWF       remove_user_flag_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__remove_user234
	MOVLW       1
	XORWF       remove_user_flag_L0+0, 0 
L__remove_user234:
	BTFSS       STATUS+0, 2 
	GOTO        L_remove_user93
;home_control.c,397 :: 		read[j++] = dat;
	MOVLW       remove_user_read_L0+0
	ADDWF       remove_user_j_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(remove_user_read_L0+0)
	ADDWFC      remove_user_j_L0+1, 0 
	MOVWF       FSR1H 
	MOVF        remove_user_dat_L0+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      remove_user_j_L0+0, 1 
	INCF        remove_user_j_L0+1, 1 
;home_control.c,398 :: 		} else {
	GOTO        L_remove_user94
L_remove_user93:
;home_control.c,399 :: 		if (j > 0){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       remove_user_j_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__remove_user235
	MOVF        remove_user_j_L0+0, 0 
	SUBLW       0
L__remove_user235:
	BTFSC       STATUS+0, 0 
	GOTO        L_remove_user95
;home_control.c,400 :: 		read[j++] = '#';
	MOVLW       remove_user_read_L0+0
	ADDWF       remove_user_j_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(remove_user_read_L0+0)
	ADDWFC      remove_user_j_L0+1, 0 
	MOVWF       FSR1H 
	MOVLW       35
	MOVWF       POSTINC1+0 
	INFSNZ      remove_user_j_L0+0, 1 
	INCF        remove_user_j_L0+1, 1 
;home_control.c,401 :: 		read[j] = '\0';
	MOVLW       remove_user_read_L0+0
	ADDWF       remove_user_j_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(remove_user_read_L0+0)
	ADDWFC      remove_user_j_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;home_control.c,403 :: 		if ( strstr(read,phone_number) != 0 ){
	MOVLW       remove_user_read_L0+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(remove_user_read_L0+0)
	MOVWF       FARG_strstr_s1+1 
	MOVF        FARG_remove_user_phone_number+0, 0 
	MOVWF       FARG_strstr_s2+0 
	MOVF        FARG_remove_user_phone_number+1, 0 
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__remove_user236
	MOVLW       0
	XORWF       R0, 0 
L__remove_user236:
	BTFSC       STATUS+0, 2 
	GOTO        L_remove_user96
;home_control.c,405 :: 		for (k=i-strlen(read)+1;k<=i;k++){
	MOVLW       remove_user_read_L0+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(remove_user_read_L0+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	SUBWF       remove_user_i_L0+0, 0 
	MOVWF       remove_user_k_L4+0 
	MOVF        R1, 0 
	SUBWFB      remove_user_i_L0+1, 0 
	MOVWF       remove_user_k_L4+1 
	INFSNZ      remove_user_k_L4+0, 1 
	INCF        remove_user_k_L4+1, 1 
L_remove_user97:
	MOVLW       128
	XORWF       remove_user_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       remove_user_k_L4+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__remove_user237
	MOVF        remove_user_k_L4+0, 0 
	SUBWF       remove_user_i_L0+0, 0 
L__remove_user237:
	BTFSS       STATUS+0, 0 
	GOTO        L_remove_user98
;home_control.c,406 :: 		EEPROM_Write(k,254);
	MOVF        remove_user_k_L4+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        remove_user_k_L4+1, 0 
	MOVWF       FARG_EEPROM_Write_address+1 
	MOVLW       254
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;home_control.c,405 :: 		for (k=i-strlen(read)+1;k<=i;k++){
	INFSNZ      remove_user_k_L4+0, 1 
	INCF        remove_user_k_L4+1, 1 
;home_control.c,407 :: 		}
	GOTO        L_remove_user97
L_remove_user98:
;home_control.c,408 :: 		return TRUE;
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	GOTO        L_end_remove_user
;home_control.c,409 :: 		} else {
L_remove_user96:
;home_control.c,410 :: 		j = 0;
	CLRF        remove_user_j_L0+0 
	CLRF        remove_user_j_L0+1 
;home_control.c,411 :: 		memset(read," ",sizeof(read)-1);
	MOVLW       remove_user_read_L0+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(remove_user_read_L0+0)
	MOVWF       FARG_memset_p1+1 
	MOVLW       ?lstr_15_home_control+0
	MOVWF       FARG_memset_character+0 
	MOVLW       26
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;home_control.c,413 :: 		}
L_remove_user95:
;home_control.c,414 :: 		}
L_remove_user94:
;home_control.c,416 :: 		if (dat == 254){
	MOVF        remove_user_dat_L0+0, 0 
	XORLW       254
	BTFSS       STATUS+0, 2 
	GOTO        L_remove_user101
;home_control.c,417 :: 		return FALSE;
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_remove_user
;home_control.c,418 :: 		}
L_remove_user101:
;home_control.c,389 :: 		for (i=EEPROM_USER_START;i<EEPROM_USER_END;i++){
	INFSNZ      remove_user_i_L0+0, 1 
	INCF        remove_user_i_L0+1, 1 
;home_control.c,419 :: 		}
	GOTO        L_remove_user89
L_remove_user90:
;home_control.c,420 :: 		return FALSE;
	CLRF        R0 
	CLRF        R1 
;home_control.c,421 :: 		}
L_end_remove_user:
	RETURN      0
; end of _remove_user

_read_relay_config:

;home_control.c,424 :: 		void read_relay_config(){
;home_control.c,425 :: 		int i,j=0,pos=0;
	CLRF        read_relay_config_j_L0+0 
	CLRF        read_relay_config_j_L0+1 
	CLRF        read_relay_config_pos_L0+0 
	CLRF        read_relay_config_pos_L0+1 
	CLRF        read_relay_config_flag_L0+0 
;home_control.c,427 :: 		for (i=EEPROM_RELAY_START;i<EEPROM_RELAY_END;i++){
	MOVLW       72
	MOVWF       read_relay_config_i_L0+0 
	MOVLW       3
	MOVWF       read_relay_config_i_L0+1 
L_read_relay_config102:
	MOVLW       128
	XORWF       read_relay_config_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       4
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__read_relay_config239
	MOVLW       0
	SUBWF       read_relay_config_i_L0+0, 0 
L__read_relay_config239:
	BTFSC       STATUS+0, 0 
	GOTO        L_read_relay_config103
;home_control.c,430 :: 		if (dat == '#'){
	MOVF        read_relay_config_dat_L0+0, 0 
	XORLW       35
	BTFSS       STATUS+0, 2 
	GOTO        L_read_relay_config105
;home_control.c,431 :: 		flag=!flag;
	MOVF        read_relay_config_flag_L0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       read_relay_config_flag_L0+0 
;home_control.c,432 :: 		}
L_read_relay_config105:
;home_control.c,433 :: 		dat = EEPROM_READ(i);
	MOVF        read_relay_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	MOVF        read_relay_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       read_relay_config_dat_L0+0 
;home_control.c,435 :: 		if (flag == 1){
	MOVF        read_relay_config_flag_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_read_relay_config106
;home_control.c,436 :: 		if (dat != '#'){
	MOVF        read_relay_config_dat_L0+0, 0 
	XORLW       35
	BTFSC       STATUS+0, 2 
	GOTO        L_read_relay_config107
;home_control.c,437 :: 		buffer[j++] = dat;
	MOVLW       read_relay_config_buffer_L0+0
	ADDWF       read_relay_config_j_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(read_relay_config_buffer_L0+0)
	ADDWFC      read_relay_config_j_L0+1, 0 
	MOVWF       FSR1H 
	MOVF        read_relay_config_dat_L0+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      read_relay_config_j_L0+0, 1 
	INCF        read_relay_config_j_L0+1, 1 
;home_control.c,438 :: 		}
L_read_relay_config107:
;home_control.c,439 :: 		} else {
	GOTO        L_read_relay_config108
L_read_relay_config106:
;home_control.c,440 :: 		if (j > 0){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       read_relay_config_j_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__read_relay_config240
	MOVF        read_relay_config_j_L0+0, 0 
	SUBLW       0
L__read_relay_config240:
	BTFSC       STATUS+0, 0 
	GOTO        L_read_relay_config109
;home_control.c,442 :: 		buffer[j] = '\0';
	MOVLW       read_relay_config_buffer_L0+0
	ADDWF       read_relay_config_j_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(read_relay_config_buffer_L0+0)
	ADDWFC      read_relay_config_j_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;home_control.c,444 :: 		p1 = strtok(buffer,";");
	MOVLW       read_relay_config_buffer_L0+0
	MOVWF       FARG_strtok_s1+0 
	MOVLW       hi_addr(read_relay_config_buffer_L0+0)
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr16_home_control+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr16_home_control+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__read_relay_config+2 
	MOVF        R1, 0 
	MOVWF       FLOC__read_relay_config+3 
	MOVLW       7
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        read_relay_config_pos_L0+0, 0 
	MOVWF       R4 
	MOVF        read_relay_config_pos_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
;home_control.c,445 :: 		relays[pos].start_timer = atoi(p1);
	MOVLW       _relays+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_relays+0)
	ADDWFC      R1, 1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FLOC__read_relay_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__read_relay_config+1 
	MOVF        FLOC__read_relay_config+2, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        FLOC__read_relay_config+3, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__read_relay_config+0, FSR1
	MOVFF       FLOC__read_relay_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;home_control.c,446 :: 		p1 = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr17_home_control+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr17_home_control+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__read_relay_config+2 
	MOVF        R1, 0 
	MOVWF       FLOC__read_relay_config+3 
	MOVLW       7
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        read_relay_config_pos_L0+0, 0 
	MOVWF       R4 
	MOVF        read_relay_config_pos_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
;home_control.c,447 :: 		relays[pos].end_timer = atoi(p1);
	MOVLW       _relays+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_relays+0)
	ADDWFC      R1, 1 
	MOVLW       3
	ADDWF       R0, 0 
	MOVWF       FLOC__read_relay_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__read_relay_config+1 
	MOVF        FLOC__read_relay_config+2, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        FLOC__read_relay_config+3, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__read_relay_config+0, FSR1
	MOVFF       FLOC__read_relay_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;home_control.c,448 :: 		p1 = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr18_home_control+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr18_home_control+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__read_relay_config+2 
	MOVF        R1, 0 
	MOVWF       FLOC__read_relay_config+3 
	MOVLW       7
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        read_relay_config_pos_L0+0, 0 
	MOVWF       R4 
	MOVF        read_relay_config_pos_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
;home_control.c,449 :: 		relays[pos].delay = atoi(p1);
	MOVLW       _relays+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_relays+0)
	ADDWFC      R1, 1 
	MOVLW       5
	ADDWF       R0, 0 
	MOVWF       FLOC__read_relay_config+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FLOC__read_relay_config+1 
	MOVF        FLOC__read_relay_config+2, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        FLOC__read_relay_config+3, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVFF       FLOC__read_relay_config+0, FSR1
	MOVFF       FLOC__read_relay_config+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;home_control.c,451 :: 		pos++;
	INFSNZ      read_relay_config_pos_L0+0, 1 
	INCF        read_relay_config_pos_L0+1, 1 
;home_control.c,452 :: 		j=0;
	CLRF        read_relay_config_j_L0+0 
	CLRF        read_relay_config_j_L0+1 
;home_control.c,454 :: 		}
L_read_relay_config109:
;home_control.c,455 :: 		}
L_read_relay_config108:
;home_control.c,427 :: 		for (i=EEPROM_RELAY_START;i<EEPROM_RELAY_END;i++){
	INFSNZ      read_relay_config_i_L0+0, 1 
	INCF        read_relay_config_i_L0+1, 1 
;home_control.c,456 :: 		}
	GOTO        L_read_relay_config102
L_read_relay_config103:
;home_control.c,457 :: 		}
L_end_read_relay_config:
	RETURN      0
; end of _read_relay_config

_save_relay_config:

;home_control.c,459 :: 		save_relay_config(){
;home_control.c,461 :: 		int i,j=0,pos=0,index=EEPROM_RELAY_START;
	CLRF        save_relay_config_j_L0+0 
	CLRF        save_relay_config_j_L0+1 
	MOVLW       72
	MOVWF       save_relay_config_index_L0+0 
	MOVLW       3
	MOVWF       save_relay_config_index_L0+1 
;home_control.c,463 :: 		for (i=EEPROM_RELAY_START;i<EEPROM_RELAY_END;i++){
	MOVLW       72
	MOVWF       save_relay_config_i_L0+0 
	MOVLW       3
	MOVWF       save_relay_config_i_L0+1 
L_save_relay_config110:
	MOVLW       128
	XORWF       save_relay_config_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       4
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__save_relay_config242
	MOVLW       0
	SUBWF       save_relay_config_i_L0+0, 0 
L__save_relay_config242:
	BTFSC       STATUS+0, 0 
	GOTO        L_save_relay_config111
;home_control.c,464 :: 		EEPROM_Write(i,254);
	MOVF        save_relay_config_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        save_relay_config_i_L0+1, 0 
	MOVWF       FARG_EEPROM_Write_address+1 
	MOVLW       254
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;home_control.c,463 :: 		for (i=EEPROM_RELAY_START;i<EEPROM_RELAY_END;i++){
	INFSNZ      save_relay_config_i_L0+0, 1 
	INCF        save_relay_config_i_L0+1, 1 
;home_control.c,465 :: 		}
	GOTO        L_save_relay_config110
L_save_relay_config111:
;home_control.c,467 :: 		for (i=0;i<9;i++){
	CLRF        save_relay_config_i_L0+0 
	CLRF        save_relay_config_i_L0+1 
L_save_relay_config113:
	MOVLW       128
	XORWF       save_relay_config_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__save_relay_config243
	MOVLW       9
	SUBWF       save_relay_config_i_L0+0, 0 
L__save_relay_config243:
	BTFSC       STATUS+0, 0 
	GOTO        L_save_relay_config114
;home_control.c,468 :: 		strcpy(buffer,"#");
	MOVLW       save_relay_config_buffer_L0+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(save_relay_config_buffer_L0+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr19_home_control+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr19_home_control+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;home_control.c,469 :: 		itoa(relays[i].start_timer,convert);
	MOVLW       7
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        save_relay_config_i_L0+0, 0 
	MOVWF       R4 
	MOVF        save_relay_config_i_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _relays+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_relays+0)
	ADDWFC      R1, 1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_relay_config_convert_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_relay_config_convert_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
;home_control.c,470 :: 		strcat(buffer,convert);
	MOVLW       save_relay_config_buffer_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_relay_config_buffer_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       save_relay_config_convert_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(save_relay_config_convert_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,471 :: 		strcat(buffer,";");
	MOVLW       save_relay_config_buffer_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_relay_config_buffer_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr20_home_control+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr20_home_control+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,472 :: 		itoa(relays[i].end_timer,convert);
	MOVLW       7
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        save_relay_config_i_L0+0, 0 
	MOVWF       R4 
	MOVF        save_relay_config_i_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _relays+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_relays+0)
	ADDWFC      R1, 1 
	MOVLW       3
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_relay_config_convert_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_relay_config_convert_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
;home_control.c,473 :: 		strcat(buffer,convert);
	MOVLW       save_relay_config_buffer_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_relay_config_buffer_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       save_relay_config_convert_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(save_relay_config_convert_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,474 :: 		strcat(buffer,";");
	MOVLW       save_relay_config_buffer_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_relay_config_buffer_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr21_home_control+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr21_home_control+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,475 :: 		itoa(relays[i].delay,convert);
	MOVLW       7
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        save_relay_config_i_L0+0, 0 
	MOVWF       R4 
	MOVF        save_relay_config_i_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _relays+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_relays+0)
	ADDWFC      R1, 1 
	MOVLW       5
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       save_relay_config_convert_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(save_relay_config_convert_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
;home_control.c,476 :: 		strcat(buffer,convert);
	MOVLW       save_relay_config_buffer_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_relay_config_buffer_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       save_relay_config_convert_L0+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(save_relay_config_convert_L0+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,477 :: 		strcat(buffer,"#");
	MOVLW       save_relay_config_buffer_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(save_relay_config_buffer_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr22_home_control+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr22_home_control+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,479 :: 		for (j=0;j<strlen(buffer);j++,index++){
	CLRF        save_relay_config_j_L0+0 
	CLRF        save_relay_config_j_L0+1 
L_save_relay_config116:
	MOVLW       save_relay_config_buffer_L0+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(save_relay_config_buffer_L0+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       128
	XORWF       save_relay_config_j_L0+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__save_relay_config244
	MOVF        R0, 0 
	SUBWF       save_relay_config_j_L0+0, 0 
L__save_relay_config244:
	BTFSC       STATUS+0, 0 
	GOTO        L_save_relay_config117
;home_control.c,480 :: 		EEPROM_Write(index,buffer[j]);
	MOVF        save_relay_config_index_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        save_relay_config_index_L0+1, 0 
	MOVWF       FARG_EEPROM_Write_address+1 
	MOVLW       save_relay_config_buffer_L0+0
	ADDWF       save_relay_config_j_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(save_relay_config_buffer_L0+0)
	ADDWFC      save_relay_config_j_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;home_control.c,479 :: 		for (j=0;j<strlen(buffer);j++,index++){
	INFSNZ      save_relay_config_j_L0+0, 1 
	INCF        save_relay_config_j_L0+1, 1 
	INFSNZ      save_relay_config_index_L0+0, 1 
	INCF        save_relay_config_index_L0+1, 1 
;home_control.c,481 :: 		}
	GOTO        L_save_relay_config116
L_save_relay_config117:
;home_control.c,467 :: 		for (i=0;i<9;i++){
	INFSNZ      save_relay_config_i_L0+0, 1 
	INCF        save_relay_config_i_L0+1, 1 
;home_control.c,482 :: 		}
	GOTO        L_save_relay_config113
L_save_relay_config114:
;home_control.c,484 :: 		}
L_end_save_relay_config:
	RETURN      0
; end of _save_relay_config

_process_wifi_io:

;home_control.c,486 :: 		void process_wifi_io(){
;home_control.c,488 :: 		}
L_end_process_wifi_io:
	RETURN      0
; end of _process_wifi_io

_process_gprs_io:

;home_control.c,490 :: 		void process_gprs_io(){
;home_control.c,492 :: 		}
L_end_process_gprs_io:
	RETURN      0
; end of _process_gprs_io

_process_gsm_io:

;home_control.c,494 :: 		void process_gsm_io(){
;home_control.c,496 :: 		}
L_end_process_gsm_io:
	RETURN      0
; end of _process_gsm_io

_process_io:

;home_control.c,498 :: 		void process_io(){
;home_control.c,500 :: 		if (network_data.isServerConnected){
	MOVF        _Network_data+89, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io119
;home_control.c,502 :: 		if (network_data.isWifiConnected && network_data.isWifiInputReady){
	MOVF        _Network_data+87, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io122
	MOVF        _Network_data+390, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io122
L__process_io192:
;home_control.c,503 :: 		process_wifi_io();
	CALL        _process_wifi_io+0, 0
;home_control.c,504 :: 		network_data.isWifiInputReady = FALSE;
	CLRF        _Network_data+390 
;home_control.c,505 :: 		clear_read_line(WIFI);
	MOVLW       1
	MOVWF       FARG_clear_read_line_interface+0 
	CALL        _clear_read_line+0, 0
;home_control.c,506 :: 		}
L_process_io122:
;home_control.c,508 :: 		if (network_data.isGprsConnected && network_data.isGPRSInputReady){
	MOVF        _Network_data+88, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io125
	MOVF        _Network_data+391, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_process_io125
L__process_io191:
;home_control.c,509 :: 		process_gprs_io();
	CALL        _process_gprs_io+0, 0
;home_control.c,510 :: 		network_data.isGprsInputReady = FALSE;
	CLRF        _Network_data+391 
;home_control.c,511 :: 		clear_read_line(GPRS);
	CLRF        FARG_clear_read_line_interface+0 
	CALL        _clear_read_line+0, 0
;home_control.c,512 :: 		}
L_process_io125:
;home_control.c,513 :: 		}
L_process_io119:
;home_control.c,514 :: 		process_gsm_io();
	CALL        _process_gsm_io+0, 0
;home_control.c,515 :: 		}
L_end_process_io:
	RETURN      0
; end of _process_io

_set_identifier:

;home_control.c,519 :: 		void set_identifier(char interface){
;home_control.c,521 :: 		if (strstr(network_data.wifi_readLine,"SETID") != 0){
	MOVLW       _Network_data+90
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_Network_data+90)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr23_home_control+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr23_home_control+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__set_identifier250
	MOVLW       0
	XORWF       R0, 0 
L__set_identifier250:
	BTFSC       STATUS+0, 2 
	GOTO        L_set_identifier126
;home_control.c,524 :: 		p = strtok(network_data.wifi_readLine,";");
	MOVLW       _Network_data+90
	MOVWF       FARG_strtok_s1+0 
	MOVLW       hi_addr(_Network_data+90)
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr24_home_control+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr24_home_control+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
;home_control.c,525 :: 		p = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr25_home_control+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr25_home_control+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
;home_control.c,527 :: 		strcpy(System.manufacturer_number,p);
	MOVLW       _System+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(_System+0)
	MOVWF       FARG_strcpy_to+1 
	MOVF        R0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        R1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;home_control.c,535 :: 		cipsend("ID OK\n", interface);
	MOVLW       ?lstr26_home_control+0
	MOVWF       FARG_cipsend_p+0 
	MOVLW       hi_addr(?lstr26_home_control+0)
	MOVWF       FARG_cipsend_p+1 
	MOVF        FARG_set_identifier_interface+0, 0 
	MOVWF       FARG_cipsend_interface+0 
	CALL        _cipsend+0, 0
;home_control.c,536 :: 		wait_for_input("OK",2, interface);
	MOVLW       ?lstr27_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr27_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       2
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	MOVF        FARG_set_identifier_interface+0, 0 
	MOVWF       FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,538 :: 		clear_read_line(interface);
	MOVF        FARG_set_identifier_interface+0, 0 
	MOVWF       FARG_clear_read_line_interface+0 
	CALL        _clear_read_line+0, 0
;home_control.c,539 :: 		}
L_set_identifier126:
;home_control.c,540 :: 		}
L_end_set_identifier:
	RETURN      0
; end of _set_identifier

_get_system_time:

;home_control.c,542 :: 		void get_system_time(char interface){
;home_control.c,544 :: 		short i = 0;
	CLRF        get_system_time_i_L0+0 
;home_control.c,545 :: 		clear_read_line(interface);
	MOVF        FARG_get_system_time_interface+0, 0 
	MOVWF       FARG_clear_read_line_interface+0 
	CALL        _clear_read_line+0, 0
;home_control.c,548 :: 		cipsend("GETTIME\n",interface);
	MOVLW       ?lstr28_home_control+0
	MOVWF       FARG_cipsend_p+0 
	MOVLW       hi_addr(?lstr28_home_control+0)
	MOVWF       FARG_cipsend_p+1 
	MOVF        FARG_get_system_time_interface+0, 0 
	MOVWF       FARG_cipsend_interface+0 
	CALL        _cipsend+0, 0
;home_control.c,549 :: 		wait_for_input("TIME",15, interface);
	MOVLW       ?lstr29_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr29_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       15
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	MOVF        FARG_get_system_time_interface+0, 0 
	MOVWF       FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,550 :: 		delay_ms(300);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_get_system_time127:
	DECFSZ      R13, 1, 1
	BRA         L_get_system_time127
	DECFSZ      R12, 1, 1
	BRA         L_get_system_time127
	DECFSZ      R11, 1, 1
	BRA         L_get_system_time127
	NOP
;home_control.c,553 :: 		p = strtok(network_data.wifi_readLine,";");
	MOVLW       _Network_data+90
	MOVWF       FARG_strtok_s1+0 
	MOVLW       hi_addr(_Network_data+90)
	MOVWF       FARG_strtok_s1+1 
	MOVLW       ?lstr30_home_control+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr30_home_control+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       get_system_time_p_L0+0 
	MOVF        R1, 0 
	MOVWF       get_system_time_p_L0+1 
;home_control.c,554 :: 		while (p != 0){
L_get_system_time128:
	MOVLW       0
	XORWF       get_system_time_p_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_system_time252
	MOVLW       0
	XORWF       get_system_time_p_L0+0, 0 
L__get_system_time252:
	BTFSC       STATUS+0, 2 
	GOTO        L_get_system_time129
;home_control.c,555 :: 		switch (i){
	GOTO        L_get_system_time130
;home_control.c,556 :: 		case 1: SystemTime.year = atoi(p); break;
L_get_system_time132:
	MOVF        get_system_time_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        get_system_time_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+0 
	MOVF        R1, 0 
	MOVWF       _SystemTime+1 
	GOTO        L_get_system_time131
;home_control.c,557 :: 		case 2: SystemTime.month = atoi(p); break;
L_get_system_time133:
	MOVF        get_system_time_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        get_system_time_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+2 
	MOVF        R1, 0 
	MOVWF       _SystemTime+3 
	GOTO        L_get_system_time131
;home_control.c,558 :: 		case 3: SystemTime.day = atoi(p); break;
L_get_system_time134:
	MOVF        get_system_time_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        get_system_time_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+4 
	MOVF        R1, 0 
	MOVWF       _SystemTime+5 
	GOTO        L_get_system_time131
;home_control.c,559 :: 		case 4: SystemTime.hour = atoi(p); break;
L_get_system_time135:
	MOVF        get_system_time_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        get_system_time_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+6 
	MOVF        R1, 0 
	MOVWF       _SystemTime+7 
	GOTO        L_get_system_time131
;home_control.c,560 :: 		case 5: SystemTime.min = atoi(p);  break;
L_get_system_time136:
	MOVF        get_system_time_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        get_system_time_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+8 
	MOVF        R1, 0 
	MOVWF       _SystemTime+9 
	GOTO        L_get_system_time131
;home_control.c,561 :: 		case 6: SystemTime.sec = atoi(p); break;
L_get_system_time137:
	MOVF        get_system_time_p_L0+0, 0 
	MOVWF       FARG_atoi_s+0 
	MOVF        get_system_time_p_L0+1, 0 
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _SystemTime+10 
	MOVF        R1, 0 
	MOVWF       _SystemTime+11 
	GOTO        L_get_system_time131
;home_control.c,562 :: 		}
L_get_system_time130:
	MOVF        get_system_time_i_L0+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_get_system_time132
	MOVF        get_system_time_i_L0+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_get_system_time133
	MOVF        get_system_time_i_L0+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_get_system_time134
	MOVF        get_system_time_i_L0+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_get_system_time135
	MOVF        get_system_time_i_L0+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_get_system_time136
	MOVF        get_system_time_i_L0+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L_get_system_time137
L_get_system_time131:
;home_control.c,563 :: 		i++;
	INCF        get_system_time_i_L0+0, 1 
;home_control.c,564 :: 		p = strtok(0,";");
	CLRF        FARG_strtok_s1+0 
	CLRF        FARG_strtok_s1+1 
	MOVLW       ?lstr31_home_control+0
	MOVWF       FARG_strtok_s2+0 
	MOVLW       hi_addr(?lstr31_home_control+0)
	MOVWF       FARG_strtok_s2+1 
	CALL        _strtok+0, 0
	MOVF        R0, 0 
	MOVWF       get_system_time_p_L0+0 
	MOVF        R1, 0 
	MOVWF       get_system_time_p_L0+1 
;home_control.c,565 :: 		}
	GOTO        L_get_system_time128
L_get_system_time129:
;home_control.c,567 :: 		cipsend("TIME OK\n",interface);
	MOVLW       ?lstr32_home_control+0
	MOVWF       FARG_cipsend_p+0 
	MOVLW       hi_addr(?lstr32_home_control+0)
	MOVWF       FARG_cipsend_p+1 
	MOVF        FARG_get_system_time_interface+0, 0 
	MOVWF       FARG_cipsend_interface+0 
	CALL        _cipsend+0, 0
;home_control.c,568 :: 		wait_for_input("OK",2, interface);
	MOVLW       ?lstr33_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr33_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       2
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	MOVF        FARG_get_system_time_interface+0, 0 
	MOVWF       FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,570 :: 		clear_read_line(interface);
	MOVF        FARG_get_system_time_interface+0, 0 
	MOVWF       FARG_clear_read_line_interface+0 
	CALL        _clear_read_line+0, 0
;home_control.c,571 :: 		}
L_end_get_system_time:
	RETURN      0
; end of _get_system_time

_get_identifier:

;home_control.c,573 :: 		void get_identifier(char interface){
;home_control.c,575 :: 		if (strstr(System.manufacturer_number,"null") != 0){
	MOVLW       _System+0
	MOVWF       FARG_strstr_s1+0 
	MOVLW       hi_addr(_System+0)
	MOVWF       FARG_strstr_s1+1 
	MOVLW       ?lstr34_home_control+0
	MOVWF       FARG_strstr_s2+0 
	MOVLW       hi_addr(?lstr34_home_control+0)
	MOVWF       FARG_strstr_s2+1 
	CALL        _strstr+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_identifier254
	MOVLW       0
	XORWF       R0, 0 
L__get_identifier254:
	BTFSC       STATUS+0, 2 
	GOTO        L_get_identifier138
;home_control.c,576 :: 		clear_read_line(interface);
	MOVF        FARG_get_identifier_interface+0, 0 
	MOVWF       FARG_clear_read_line_interface+0 
	CALL        _clear_read_line+0, 0
;home_control.c,578 :: 		cipsend("GETID\n",interface);
	MOVLW       ?lstr35_home_control+0
	MOVWF       FARG_cipsend_p+0 
	MOVLW       hi_addr(?lstr35_home_control+0)
	MOVWF       FARG_cipsend_p+1 
	MOVF        FARG_get_identifier_interface+0, 0 
	MOVWF       FARG_cipsend_interface+0 
	CALL        _cipsend+0, 0
;home_control.c,580 :: 		wait_for_input("IPD",15,interface);
	MOVLW       ?lstr36_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr36_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       15
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	MOVF        FARG_get_identifier_interface+0, 0 
	MOVWF       FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,581 :: 		delay_ms(300);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_get_identifier139:
	DECFSZ      R13, 1, 1
	BRA         L_get_identifier139
	DECFSZ      R12, 1, 1
	BRA         L_get_identifier139
	DECFSZ      R11, 1, 1
	BRA         L_get_identifier139
	NOP
;home_control.c,582 :: 		set_identifier(interface);
	MOVF        FARG_get_identifier_interface+0, 0 
	MOVWF       FARG_set_identifier_interface+0 
	CALL        _set_identifier+0, 0
;home_control.c,584 :: 		}else {
	GOTO        L_get_identifier140
L_get_identifier138:
;home_control.c,586 :: 		strcpy(buffer,"ID;");
	MOVLW       get_identifier_buffer_L1+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(get_identifier_buffer_L1+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr37_home_control+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr37_home_control+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;home_control.c,587 :: 		strcat(buffer,System.manufacturer_number);
	MOVLW       get_identifier_buffer_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(get_identifier_buffer_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       _System+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(_System+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,588 :: 		strcat(buffer,";\n");
	MOVLW       get_identifier_buffer_L1+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(get_identifier_buffer_L1+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr38_home_control+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr38_home_control+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;home_control.c,590 :: 		cipsend(buffer,interface);
	MOVLW       get_identifier_buffer_L1+0
	MOVWF       FARG_cipsend_p+0 
	MOVLW       hi_addr(get_identifier_buffer_L1+0)
	MOVWF       FARG_cipsend_p+1 
	MOVF        FARG_get_identifier_interface+0, 0 
	MOVWF       FARG_cipsend_interface+0 
	CALL        _cipsend+0, 0
;home_control.c,591 :: 		wait_for_input("OK",2,interface);
	MOVLW       ?lstr39_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr39_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       2
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	MOVF        FARG_get_identifier_interface+0, 0 
	MOVWF       FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,592 :: 		}
L_get_identifier140:
;home_control.c,593 :: 		get_system_time(interface);
	MOVF        FARG_get_identifier_interface+0, 0 
	MOVWF       FARG_get_system_time_interface+0 
	CALL        _get_system_time+0, 0
;home_control.c,594 :: 		}
L_end_get_identifier:
	RETURN      0
; end of _get_identifier

_connect_to_wifi:

;home_control.c,596 :: 		char connect_to_wifi(){
;home_control.c,598 :: 		UART1_Write_Text("AT+SLEEP=2\r\n");
	MOVLW       ?lstr40_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr40_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,599 :: 		wait_for_input("OK",3,WIFI);
	MOVLW       ?lstr41_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr41_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       3
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	MOVLW       1
	MOVWF       FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,601 :: 		UART1_Write_Text("AT+CWMODE=1\r\n");
	MOVLW       ?lstr42_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr42_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,602 :: 		wait_for_input("OK",3,WIFI);
	MOVLW       ?lstr43_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr43_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       3
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	MOVLW       1
	MOVWF       FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,603 :: 		UART1_Write_Text("AT+CWJAP=\"");
	MOVLW       ?lstr44_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr44_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,604 :: 		UART1_Write_Text(network_data.ssid);
	MOVLW       _Network_data+35
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_Network_data+35)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,605 :: 		UART1_Write_Text("\",\"");
	MOVLW       ?lstr45_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr45_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,606 :: 		UART1_Write_Text(network_data.password);
	MOVLW       _Network_data+55
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_Network_data+55)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,607 :: 		UART1_Write_Text("\"\r\n");
	MOVLW       ?lstr46_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr46_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,608 :: 		if (wait_for_input("OK",10,WIFI)){
	MOVLW       ?lstr47_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr47_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       10
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	MOVLW       1
	MOVWF       FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_connect_to_wifi141
;home_control.c,609 :: 		return TRUE;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_connect_to_wifi
;home_control.c,610 :: 		} else {
L_connect_to_wifi141:
;home_control.c,611 :: 		return FALSE;
	CLRF        R0 
;home_control.c,613 :: 		}
L_end_connect_to_wifi:
	RETURN      0
; end of _connect_to_wifi

_connect_to_gprs:

;home_control.c,615 :: 		char connect_to_gprs(){
;home_control.c,619 :: 		UART2_Write_Text("AT+CIPSHUT\r");
	MOVLW       ?lstr48_home_control+0
	MOVWF       FARG_UART2_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr48_home_control+0)
	MOVWF       FARG_UART2_Write_Text_uart_text+1 
	CALL        _UART2_Write_Text+0, 0
;home_control.c,620 :: 		wait_for_input("OK",10,GPRS);
	MOVLW       ?lstr49_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr49_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       10
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	CLRF        FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,622 :: 		UART2_Write_Text("AT+CGATT=1\r");
	MOVLW       ?lstr50_home_control+0
	MOVWF       FARG_UART2_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr50_home_control+0)
	MOVWF       FARG_UART2_Write_Text_uart_text+1 
	CALL        _UART2_Write_Text+0, 0
;home_control.c,623 :: 		wait_for_input("OK",10,GPRS);
	MOVLW       ?lstr51_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr51_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       10
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	CLRF        FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,625 :: 		UART2_Write_Text("AT+CGDCONT=1,\"IP\",\"");
	MOVLW       ?lstr52_home_control+0
	MOVWF       FARG_UART2_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr52_home_control+0)
	MOVWF       FARG_UART2_Write_Text_uart_text+1 
	CALL        _UART2_Write_Text+0, 0
;home_control.c,626 :: 		UART2_Write_Text(network_data.apn);
	MOVLW       _Network_data+75
	MOVWF       FARG_UART2_Write_Text_uart_text+0 
	MOVLW       hi_addr(_Network_data+75)
	MOVWF       FARG_UART2_Write_Text_uart_text+1 
	CALL        _UART2_Write_Text+0, 0
;home_control.c,627 :: 		UART2_Write_Text("\"\r");
	MOVLW       ?lstr53_home_control+0
	MOVWF       FARG_UART2_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr53_home_control+0)
	MOVWF       FARG_UART2_Write_Text_uart_text+1 
	CALL        _UART2_Write_Text+0, 0
;home_control.c,628 :: 		wait_for_input("OK",10,GPRS);
	MOVLW       ?lstr54_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr54_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       10
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	CLRF        FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,630 :: 		UART2_Write_Text("AT+CSTT=\"");
	MOVLW       ?lstr55_home_control+0
	MOVWF       FARG_UART2_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr55_home_control+0)
	MOVWF       FARG_UART2_Write_Text_uart_text+1 
	CALL        _UART2_Write_Text+0, 0
;home_control.c,631 :: 		UART2_Write_Text(network_data.apn);
	MOVLW       _Network_data+75
	MOVWF       FARG_UART2_Write_Text_uart_text+0 
	MOVLW       hi_addr(_Network_data+75)
	MOVWF       FARG_UART2_Write_Text_uart_text+1 
	CALL        _UART2_Write_Text+0, 0
;home_control.c,632 :: 		UART2_Write_Text("\",\"\",\"\"\r");
	MOVLW       ?lstr56_home_control+0
	MOVWF       FARG_UART2_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr56_home_control+0)
	MOVWF       FARG_UART2_Write_Text_uart_text+1 
	CALL        _UART2_Write_Text+0, 0
;home_control.c,633 :: 		wait_for_input("OK",10,GPRS);
	MOVLW       ?lstr57_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr57_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       10
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	CLRF        FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,635 :: 		UART2_Write_Text("AT+CIICR\r\n");
	MOVLW       ?lstr58_home_control+0
	MOVWF       FARG_UART2_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr58_home_control+0)
	MOVWF       FARG_UART2_Write_Text_uart_text+1 
	CALL        _UART2_Write_Text+0, 0
;home_control.c,637 :: 		if (wait_for_input("OK",10,GPRS)){
	MOVLW       ?lstr59_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr59_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       10
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	CLRF        FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_connect_to_gprs143
;home_control.c,638 :: 		return TRUE;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_connect_to_gprs
;home_control.c,639 :: 		} else {
L_connect_to_gprs143:
;home_control.c,640 :: 		return FALSE;
	CLRF        R0 
;home_control.c,645 :: 		}
L_end_connect_to_gprs:
	RETURN      0
; end of _connect_to_gprs

_connect_to_server:

;home_control.c,647 :: 		char connect_to_server(char interface){
;home_control.c,651 :: 		if (interface == WIFI){
	MOVF        FARG_connect_to_server_interface+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_connect_to_server145
;home_control.c,653 :: 		UART1_Write_Text("AT+CIPMUX=1\r\n");
	MOVLW       ?lstr60_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr60_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,654 :: 		wait_for_input("OK",2,interface);
	MOVLW       ?lstr61_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr61_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       2
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	MOVF        FARG_connect_to_server_interface+0, 0 
	MOVWF       FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
;home_control.c,655 :: 		}
L_connect_to_server145:
;home_control.c,658 :: 		clear_read_line(interface);
	MOVF        FARG_connect_to_server_interface+0, 0 
	MOVWF       FARG_clear_read_line_interface+0 
	CALL        _clear_read_line+0, 0
;home_control.c,660 :: 		if (interface == WIFI){
	MOVF        FARG_connect_to_server_interface+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_connect_to_server146
;home_control.c,661 :: 		UART1_Write_Text("AT+CIPSTART=0,\"TCP\",\"");
	MOVLW       ?lstr62_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr62_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,662 :: 		UART1_Write_Text(network_data.host);
	MOVLW       _Network_data+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_Network_data+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,663 :: 		UART1_Write_Text("\",");
	MOVLW       ?lstr63_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr63_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,664 :: 		UART1_Write_Text(itoa(network_data.port,conv));
	MOVLW       _Network_data+30
	MOVWF       FARG_itoa_i+0 
	MOVLW       hi_addr(_Network_data+30)
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
;home_control.c,665 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr64_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr64_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,666 :: 		}
L_connect_to_server146:
;home_control.c,667 :: 		if (interface == GPRS){
	MOVF        FARG_connect_to_server_interface+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_connect_to_server147
;home_control.c,668 :: 		UART1_Write_Text("AT+CIPSTART=\"TCP\",\"");
	MOVLW       ?lstr65_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr65_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,669 :: 		UART1_Write_Text(network_data.host);
	MOVLW       _Network_data+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_Network_data+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,670 :: 		UART1_Write_Text("\",\"");
	MOVLW       ?lstr66_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr66_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,671 :: 		UART1_Write_Text(itoa(network_data.port,conv));
	MOVLW       _Network_data+30
	MOVWF       FARG_itoa_i+0 
	MOVLW       hi_addr(_Network_data+30)
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
;home_control.c,672 :: 		UART1_Write_Text("\"\r");
	MOVLW       ?lstr67_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr67_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,673 :: 		}
L_connect_to_server147:
;home_control.c,675 :: 		if (wait_for_input("OK",10,interface) == 1){
	MOVLW       ?lstr68_home_control+0
	MOVWF       FARG_wait_for_input_input+0 
	MOVLW       hi_addr(?lstr68_home_control+0)
	MOVWF       FARG_wait_for_input_input+1 
	MOVLW       10
	MOVWF       FARG_wait_for_input_timeout+0 
	MOVLW       0
	MOVWF       FARG_wait_for_input_timeout+1 
	MOVF        FARG_connect_to_server_interface+0, 0 
	MOVWF       FARG_wait_for_input_interface+0 
	CALL        _wait_for_input+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__connect_to_server258
	MOVLW       1
	XORWF       R0, 0 
L__connect_to_server258:
	BTFSS       STATUS+0, 2 
	GOTO        L_connect_to_server148
;home_control.c,677 :: 		network_data.isServerConnected = TRUE;
	MOVLW       1
	MOVWF       _Network_data+89 
;home_control.c,679 :: 		get_identifier(interface);
	MOVF        FARG_connect_to_server_interface+0, 0 
	MOVWF       FARG_get_identifier_interface+0 
	CALL        _get_identifier+0, 0
;home_control.c,680 :: 		return TRUE;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_connect_to_server
;home_control.c,682 :: 		} else {
L_connect_to_server148:
;home_control.c,684 :: 		network_data.isServerConnected = FALSE;
	CLRF        _Network_data+89 
;home_control.c,685 :: 		return FALSE;
	CLRF        R0 
;home_control.c,688 :: 		}
L_end_connect_to_server:
	RETURN      0
; end of _connect_to_server

_networking:

;home_control.c,690 :: 		void networking(){
;home_control.c,692 :: 		if (Timer.connection_timer_buffer >= Timer.connection_timer){
	MOVLW       128
	XORWF       _Timer+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _Timer+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__networking260
	MOVF        _Timer+2, 0 
	SUBWF       _Timer+0, 0 
L__networking260:
	BTFSS       STATUS+0, 0 
	GOTO        L_networking150
;home_control.c,694 :: 		if ( network_data.network_status != NETWORK_CONNECTED ){
	MOVF        _Network_data+86, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_networking151
;home_control.c,696 :: 		network_data.isWifiConnected = connect_to_wifi();
	CALL        _connect_to_wifi+0, 0
	MOVF        R0, 0 
	MOVWF       _Network_data+87 
;home_control.c,698 :: 		if (!network_data.isWifiConnected){
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_networking152
;home_control.c,699 :: 		network_data.isGprsConnected = connect_to_gprs();
	CALL        _connect_to_gprs+0, 0
	MOVF        R0, 0 
	MOVWF       _Network_data+88 
;home_control.c,700 :: 		}
L_networking152:
;home_control.c,702 :: 		if (network_data.isWifiConnected){
	MOVF        _Network_data+87, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_networking153
;home_control.c,703 :: 		connect_to_server(WIFI);
	MOVLW       1
	MOVWF       FARG_connect_to_server_interface+0 
	CALL        _connect_to_server+0, 0
;home_control.c,704 :: 		}
L_networking153:
;home_control.c,705 :: 		if (network_data.isGprsConnected){
	MOVF        _Network_data+88, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_networking154
;home_control.c,706 :: 		connect_to_server(GPRS);
	CLRF        FARG_connect_to_server_interface+0 
	CALL        _connect_to_server+0, 0
;home_control.c,707 :: 		}
L_networking154:
;home_control.c,709 :: 		if (!network_data.isGprsConnected && !network_data.isWifiConnected){
	MOVF        _Network_data+88, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_networking157
	MOVF        _Network_data+87, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_networking157
L__networking193:
;home_control.c,710 :: 		if (Timer.connection_timer <= 600) Timer.connection_timer += 20;
	MOVLW       128
	XORLW       2
	MOVWF       R0 
	MOVLW       128
	XORWF       _Timer+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__networking261
	MOVF        _Timer+2, 0 
	SUBLW       88
L__networking261:
	BTFSS       STATUS+0, 0 
	GOTO        L_networking158
	MOVLW       20
	ADDWF       _Timer+2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _Timer+3, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _Timer+2 
	MOVF        R1, 0 
	MOVWF       _Timer+3 
L_networking158:
;home_control.c,711 :: 		}
L_networking157:
;home_control.c,713 :: 		}
L_networking151:
;home_control.c,714 :: 		Timer.connection_timer_buffer = 0;
	CLRF        _Timer+0 
	CLRF        _Timer+1 
;home_control.c,715 :: 		}
L_networking150:
;home_control.c,716 :: 		}
L_end_networking:
	RETURN      0
; end of _networking

_wifi_serial_interrupt:

;home_control.c,718 :: 		void wifi_serial_interrupt(){
;home_control.c,720 :: 		if (PIR1.RCIF ) {          // test the interrupt for uart rx
	BTFSS       PIR1+0, 5 
	GOTO        L_wifi_serial_interrupt159
;home_control.c,722 :: 		if (network_data.index_1 >= sizeof(network_data.wifi_readLine)-3){
	MOVLW       128
	XORWF       _Network_data+393, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__wifi_serial_interrupt263
	MOVLW       97
	SUBWF       _Network_data+392, 0 
L__wifi_serial_interrupt263:
	BTFSS       STATUS+0, 0 
	GOTO        L_wifi_serial_interrupt160
;home_control.c,724 :: 		network_data.index_1 = 0;
	CLRF        _Network_data+392 
	CLRF        _Network_data+393 
;home_control.c,725 :: 		}
L_wifi_serial_interrupt160:
;home_control.c,727 :: 		network_data.wifi_readLine[network_data.index_1] = UART1_Read();
	MOVLW       _Network_data+90
	ADDWF       _Network_data+392, 0 
	MOVWF       FLOC__wifi_serial_interrupt+0 
	MOVLW       hi_addr(_Network_data+90)
	ADDWFC      _Network_data+393, 0 
	MOVWF       FLOC__wifi_serial_interrupt+1 
	CALL        _UART1_Read+0, 0
	MOVFF       FLOC__wifi_serial_interrupt+0, FSR1
	MOVFF       FLOC__wifi_serial_interrupt+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;home_control.c,729 :: 		if (network_data.wifi_readLine[network_data.index_1] == '\n' ||
	MOVLW       _Network_data+90
	ADDWF       _Network_data+392, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_Network_data+90)
	ADDWFC      _Network_data+393, 0 
	MOVWF       FSR0H 
;home_control.c,730 :: 		network_data.wifi_readLine[network_data.index_1] == '\0' ||
	MOVF        POSTINC0+0, 0 
	XORLW       10
	BTFSC       STATUS+0, 2 
	GOTO        L__wifi_serial_interrupt194
	MOVLW       _Network_data+90
	ADDWF       _Network_data+392, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_Network_data+90)
	ADDWFC      _Network_data+393, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__wifi_serial_interrupt194
;home_control.c,731 :: 		network_data.wifi_readLine[network_data.index_1] == '\r' ) {
	MOVLW       _Network_data+90
	ADDWF       _Network_data+392, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_Network_data+90)
	ADDWFC      _Network_data+393, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       13
	BTFSC       STATUS+0, 2 
	GOTO        L__wifi_serial_interrupt194
	GOTO        L_wifi_serial_interrupt163
L__wifi_serial_interrupt194:
;home_control.c,733 :: 		network_data.isWifiInputReady = TRUE;
	MOVLW       1
	MOVWF       _Network_data+390 
;home_control.c,734 :: 		network_data.wifi_readLine[network_data.index_1+1] = '\0';
	MOVLW       1
	ADDWF       _Network_data+392, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _Network_data+393, 0 
	MOVWF       R1 
	MOVLW       _Network_data+90
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_Network_data+90)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;home_control.c,735 :: 		}
L_wifi_serial_interrupt163:
;home_control.c,737 :: 		network_data.index_1++;
	MOVLW       1
	ADDWF       _Network_data+392, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _Network_data+393, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _Network_data+392 
	MOVF        R1, 0 
	MOVWF       _Network_data+393 
;home_control.c,738 :: 		}
L_wifi_serial_interrupt159:
;home_control.c,739 :: 		}
L_end_wifi_serial_interrupt:
	RETURN      0
; end of _wifi_serial_interrupt

_gprs_serial_interrupt:

;home_control.c,741 :: 		void gprs_serial_interrupt(){
;home_control.c,742 :: 		if (PIR2.RCIF){
	BTFSS       PIR2+0, 5 
	GOTO        L_gprs_serial_interrupt164
;home_control.c,744 :: 		if (network_data.index_2 >= sizeof(network_data.gprs_readLine)-3){
	MOVLW       128
	XORWF       _Network_data+395, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__gprs_serial_interrupt265
	MOVLW       197
	SUBWF       _Network_data+394, 0 
L__gprs_serial_interrupt265:
	BTFSS       STATUS+0, 0 
	GOTO        L_gprs_serial_interrupt165
;home_control.c,746 :: 		network_data.index_2 = 0;
	CLRF        _Network_data+394 
	CLRF        _Network_data+395 
;home_control.c,747 :: 		}
L_gprs_serial_interrupt165:
;home_control.c,749 :: 		network_data.gprs_readLine[network_data.index_2] = UART1_Read();
	MOVLW       _Network_data+190
	ADDWF       _Network_data+394, 0 
	MOVWF       FLOC__gprs_serial_interrupt+0 
	MOVLW       hi_addr(_Network_data+190)
	ADDWFC      _Network_data+395, 0 
	MOVWF       FLOC__gprs_serial_interrupt+1 
	CALL        _UART1_Read+0, 0
	MOVFF       FLOC__gprs_serial_interrupt+0, FSR1
	MOVFF       FLOC__gprs_serial_interrupt+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;home_control.c,751 :: 		if (network_data.gprs_readLine[network_data.index_2] == '\n' ||
	MOVLW       _Network_data+190
	ADDWF       _Network_data+394, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_Network_data+190)
	ADDWFC      _Network_data+395, 0 
	MOVWF       FSR0H 
;home_control.c,752 :: 		network_data.gprs_readLine[network_data.index_2] == '\0' ||
	MOVF        POSTINC0+0, 0 
	XORLW       10
	BTFSC       STATUS+0, 2 
	GOTO        L__gprs_serial_interrupt195
	MOVLW       _Network_data+190
	ADDWF       _Network_data+394, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_Network_data+190)
	ADDWFC      _Network_data+395, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__gprs_serial_interrupt195
;home_control.c,753 :: 		network_data.gprs_readLine[network_data.index_2] == '\r' ) {
	MOVLW       _Network_data+190
	ADDWF       _Network_data+394, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_Network_data+190)
	ADDWFC      _Network_data+395, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       13
	BTFSC       STATUS+0, 2 
	GOTO        L__gprs_serial_interrupt195
	GOTO        L_gprs_serial_interrupt168
L__gprs_serial_interrupt195:
;home_control.c,755 :: 		network_data.isGprsInputReady = TRUE;
	MOVLW       1
	MOVWF       _Network_data+391 
;home_control.c,756 :: 		network_data.gprs_readLine[network_data.index_2+1] = '\0';
	MOVLW       1
	ADDWF       _Network_data+394, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _Network_data+395, 0 
	MOVWF       R1 
	MOVLW       _Network_data+190
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_Network_data+190)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;home_control.c,757 :: 		}
L_gprs_serial_interrupt168:
;home_control.c,759 :: 		network_data.index_2++;
	MOVLW       1
	ADDWF       _Network_data+394, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _Network_data+395, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _Network_data+394 
	MOVF        R1, 0 
	MOVWF       _Network_data+395 
;home_control.c,760 :: 		}
L_gprs_serial_interrupt164:
;home_control.c,761 :: 		}
L_end_gprs_serial_interrupt:
	RETURN      0
; end of _gprs_serial_interrupt

_system_clock:

;home_control.c,763 :: 		void system_clock(){
;home_control.c,765 :: 		SystemTime.mils++;
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
;home_control.c,769 :: 		if (SystemTime.mils == 1000){
	MOVF        _SystemTime+13, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L__system_clock267
	MOVLW       232
	XORWF       _SystemTime+12, 0 
L__system_clock267:
	BTFSS       STATUS+0, 2 
	GOTO        L_system_clock169
;home_control.c,770 :: 		SystemTime.sec++;
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
;home_control.c,771 :: 		SystemTime.mils = 0;
	CLRF        _SystemTime+12 
	CLRF        _SystemTime+13 
;home_control.c,772 :: 		if (Timer.connection_timer_buffer <= Timer.connection_timer){
	MOVLW       128
	XORWF       _Timer+3, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _Timer+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_clock268
	MOVF        _Timer+0, 0 
	SUBWF       _Timer+2, 0 
L__system_clock268:
	BTFSS       STATUS+0, 0 
	GOTO        L_system_clock170
;home_control.c,773 :: 		Timer.connection_timer_buffer++;
	MOVLW       1
	ADDWF       _Timer+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _Timer+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _Timer+0 
	MOVF        R1, 0 
	MOVWF       _Timer+1 
;home_control.c,774 :: 		}
L_system_clock170:
;home_control.c,775 :: 		}
L_system_clock169:
;home_control.c,776 :: 		if (SystemTime.sec == 60){
	MOVLW       0
	XORWF       _SystemTime+11, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_clock269
	MOVLW       60
	XORWF       _SystemTime+10, 0 
L__system_clock269:
	BTFSS       STATUS+0, 2 
	GOTO        L_system_clock171
;home_control.c,777 :: 		SystemTime.min++;
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
;home_control.c,778 :: 		SystemTime.sec = 0;
	CLRF        _SystemTime+10 
	CLRF        _SystemTime+11 
;home_control.c,779 :: 		}
L_system_clock171:
;home_control.c,780 :: 		if (SystemTime.min == 60){
	MOVLW       0
	XORWF       _SystemTime+9, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_clock270
	MOVLW       60
	XORWF       _SystemTime+8, 0 
L__system_clock270:
	BTFSS       STATUS+0, 2 
	GOTO        L_system_clock172
;home_control.c,781 :: 		SystemTime.hour++;
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
;home_control.c,782 :: 		SystemTime.min = 0;
	CLRF        _SystemTime+8 
	CLRF        _SystemTime+9 
;home_control.c,783 :: 		}
L_system_clock172:
;home_control.c,784 :: 		if (SystemTime.hour == 24){
	MOVLW       0
	XORWF       _SystemTime+7, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_clock271
	MOVLW       24
	XORWF       _SystemTime+6, 0 
L__system_clock271:
	BTFSS       STATUS+0, 2 
	GOTO        L_system_clock173
;home_control.c,785 :: 		SystemTime.day++;
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
;home_control.c,786 :: 		SystemTime.hour = 0;
	CLRF        _SystemTime+6 
	CLRF        _SystemTime+7 
;home_control.c,787 :: 		}
L_system_clock173:
;home_control.c,788 :: 		if (SystemTime.day == DAYS_OF_MONTH[SystemTime.month]){
	MOVF        _SystemTime+2, 0 
	MOVWF       R0 
	MOVF        _SystemTime+3, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       _SystemTime+3, 7 
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
	MOVF        _SystemTime+5, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_clock272
	MOVF        R1, 0 
	XORWF       _SystemTime+4, 0 
L__system_clock272:
	BTFSS       STATUS+0, 2 
	GOTO        L_system_clock174
;home_control.c,789 :: 		SystemTime.month++;
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
;home_control.c,790 :: 		SystemTime.day = 0;
	CLRF        _SystemTime+4 
	CLRF        _SystemTime+5 
;home_control.c,791 :: 		}
L_system_clock174:
;home_control.c,792 :: 		if (SystemTime.month == 12){
	MOVLW       0
	XORWF       _SystemTime+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__system_clock273
	MOVLW       12
	XORWF       _SystemTime+2, 0 
L__system_clock273:
	BTFSS       STATUS+0, 2 
	GOTO        L_system_clock175
;home_control.c,793 :: 		SystemTime.year++;
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
;home_control.c,794 :: 		SystemTime.month = 0;
	CLRF        _SystemTime+2 
	CLRF        _SystemTime+3 
;home_control.c,795 :: 		}
L_system_clock175:
;home_control.c,797 :: 		}
L_end_system_clock:
	RETURN      0
; end of _system_clock

_Interrupt:

;home_control.c,799 :: 		void Interrupt(){
;home_control.c,802 :: 		wifi_serial_interrupt();
	CALL        _wifi_serial_interrupt+0, 0
;home_control.c,803 :: 		gprs_serial_interrupt();
	CALL        _gprs_serial_interrupt+0, 0
;home_control.c,806 :: 		if (TMR0IF_bit){
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_Interrupt176
;home_control.c,807 :: 		TMR0IF_bit = 0;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;home_control.c,808 :: 		TMR0H         = 0xF6;
	MOVLW       246
	MOVWF       TMR0H+0 
;home_control.c,809 :: 		TMR0L         = 0x3C;
	MOVLW       60
	MOVWF       TMR0L+0 
;home_control.c,811 :: 		system_clock();
	CALL        _system_clock+0, 0
;home_control.c,813 :: 		}
L_Interrupt176:
;home_control.c,814 :: 		}
L_end_Interrupt:
L__Interrupt275:
	RETFIE      1
; end of _Interrupt

_init_timer:

;home_control.c,818 :: 		void init_timer(){
;home_control.c,819 :: 		T0CON         = 0x88;
	MOVLW       136
	MOVWF       T0CON+0 
;home_control.c,820 :: 		TMR0H         = 0xF6;
	MOVLW       246
	MOVWF       TMR0H+0 
;home_control.c,821 :: 		TMR0L         = 0x3C;
	MOVLW       60
	MOVWF       TMR0L+0 
;home_control.c,822 :: 		GIE_bit         = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;home_control.c,823 :: 		TMR0IE_bit         = 1;
	BSF         TMR0IE_bit+0, BitPos(TMR0IE_bit+0) 
;home_control.c,824 :: 		}
L_end_init_timer:
	RETURN      0
; end of _init_timer

_setup_pic:

;home_control.c,826 :: 		void setup_pic(){
;home_control.c,827 :: 		TRISA = 0b00000001;
	MOVLW       1
	MOVWF       TRISA+0 
;home_control.c,828 :: 		TRISB = 0b00000000;
	CLRF        TRISB+0 
;home_control.c,829 :: 		TRISC = 0b00000000;
	CLRF        TRISC+0 
;home_control.c,830 :: 		TRISD = 0b00000000;
	CLRF        TRISD+0 
;home_control.c,832 :: 		PORTA = 0b00000000;
	CLRF        PORTA+0 
;home_control.c,833 :: 		PORTB = 0b00000000;
	CLRF        PORTB+0 
;home_control.c,834 :: 		PORTC = 0b00000000;
	CLRF        PORTC+0 
;home_control.c,835 :: 		PORTD = 0b00000000;
	CLRF        PORTD+0 
;home_control.c,838 :: 		ANCON0 = 0b00000000;
	CLRF        ANCON0+0 
;home_control.c,839 :: 		ANCON1 = 0b00000000;
	CLRF        ANCON1+0 
;home_control.c,841 :: 		delay_ms(1000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_setup_pic177:
	DECFSZ      R13, 1, 1
	BRA         L_setup_pic177
	DECFSZ      R12, 1, 1
	BRA         L_setup_pic177
	DECFSZ      R11, 1, 1
	BRA         L_setup_pic177
	NOP
;home_control.c,845 :: 		UART1_Init(9600);
	MOVLW       103
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;home_control.c,846 :: 		delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_setup_pic178:
	DECFSZ      R13, 1, 1
	BRA         L_setup_pic178
	DECFSZ      R12, 1, 1
	BRA         L_setup_pic178
	DECFSZ      R11, 1, 1
	BRA         L_setup_pic178
;home_control.c,847 :: 		UART2_Init(9600);
	BSF         BAUDCON2+0, 3, 0
	MOVLW       1
	MOVWF       SPBRGH2+0 
	MOVLW       160
	MOVWF       SPBRG2+0 
	BSF         TXSTA2+0, 2, 0
	CALL        _UART2_Init+0, 0
;home_control.c,848 :: 		delay_ms(1000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_setup_pic179:
	DECFSZ      R13, 1, 1
	BRA         L_setup_pic179
	DECFSZ      R12, 1, 1
	BRA         L_setup_pic179
	DECFSZ      R11, 1, 1
	BRA         L_setup_pic179
	NOP
;home_control.c,849 :: 		UART1_Write_Text("AT\r\n");
	MOVLW       ?lstr69_home_control+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr69_home_control+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;home_control.c,850 :: 		delay_ms(500);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_setup_pic180:
	DECFSZ      R13, 1, 1
	BRA         L_setup_pic180
	DECFSZ      R12, 1, 1
	BRA         L_setup_pic180
	DECFSZ      R11, 1, 1
	BRA         L_setup_pic180
	NOP
	NOP
;home_control.c,853 :: 		delay_ms(250);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_setup_pic181:
	DECFSZ      R13, 1, 1
	BRA         L_setup_pic181
	DECFSZ      R12, 1, 1
	BRA         L_setup_pic181
	DECFSZ      R11, 1, 1
	BRA         L_setup_pic181
	NOP
	NOP
;home_control.c,855 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;home_control.c,856 :: 		INTCON.PEIE = 1;
	BSF         INTCON+0, 6 
;home_control.c,857 :: 		PIE1.RCIE = 1;
	BSF         PIE1+0, 5 
;home_control.c,859 :: 		}
L_end_setup_pic:
	RETURN      0
; end of _setup_pic

_default_config:

;home_control.c,861 :: 		void default_config(){
;home_control.c,863 :: 		for (i=0;i<RELAY_SIZE;i++){
	CLRF        default_config_i_L0+0 
	CLRF        default_config_i_L0+1 
L_default_config182:
	MOVLW       128
	XORWF       default_config_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__default_config279
	MOVLW       9
	SUBWF       default_config_i_L0+0, 0 
L__default_config279:
	BTFSC       STATUS+0, 0 
	GOTO        L_default_config183
;home_control.c,864 :: 		relays[i].state = 0;
	MOVLW       7
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_i_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_i_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _relays+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_relays+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;home_control.c,865 :: 		relays[i].start_timer = 0;
	MOVLW       7
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_i_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_i_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _relays+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_relays+0)
	ADDWFC      R1, 1 
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;home_control.c,866 :: 		relays[i].end_timer = 0;
	MOVLW       7
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_i_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_i_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _relays+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_relays+0)
	ADDWFC      R1, 1 
	MOVLW       3
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;home_control.c,867 :: 		relays[i].delay = 0;
	MOVLW       7
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        default_config_i_L0+0, 0 
	MOVWF       R4 
	MOVF        default_config_i_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       _relays+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(_relays+0)
	ADDWFC      R1, 1 
	MOVLW       5
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;home_control.c,863 :: 		for (i=0;i<RELAY_SIZE;i++){
	INFSNZ      default_config_i_L0+0, 1 
	INCF        default_config_i_L0+1, 1 
;home_control.c,868 :: 		}
	GOTO        L_default_config182
L_default_config183:
;home_control.c,870 :: 		SystemTime.year = 0;
	CLRF        _SystemTime+0 
	CLRF        _SystemTime+1 
;home_control.c,871 :: 		SystemTime.month = 0;
	CLRF        _SystemTime+2 
	CLRF        _SystemTime+3 
;home_control.c,872 :: 		SystemTime.day = 0;
	CLRF        _SystemTime+4 
	CLRF        _SystemTime+5 
;home_control.c,873 :: 		SystemTime.hour = 0;
	CLRF        _SystemTime+6 
	CLRF        _SystemTime+7 
;home_control.c,874 :: 		SystemTime.min = 0;
	CLRF        _SystemTime+8 
	CLRF        _SystemTime+9 
;home_control.c,875 :: 		SystemTime.sec = 0;
	CLRF        _SystemTime+10 
	CLRF        _SystemTime+11 
;home_control.c,876 :: 		SystemTime.mils = 0;
	CLRF        _SystemTime+12 
	CLRF        _SystemTime+13 
;home_control.c,878 :: 		Network_data.host[30] = NETWORK_HOST;
	MOVLW       _NETWORK_HOST+0
	MOVWF       _Network_data+30 
;home_control.c,879 :: 		Network_data.port[5] = NETWORK_PORT;
	MOVLW       _NETWORK_PORT+0
	MOVWF       _Network_data+35 
;home_control.c,880 :: 		Network_data.ssid[20] = NETWORK_SSID;
	MOVLW       _NETWORK_SSID+0
	MOVWF       _Network_data+55 
;home_control.c,881 :: 		Network_data.password[20] = NETWORK_PASSW;
	MOVLW       _NETWORK_PASSW+0
	MOVWF       _Network_data+75 
;home_control.c,882 :: 		Network_data.apn[10] = NETWORK_APN;
	MOVLW       _NETWORK_APN+0
	MOVWF       _Network_data+85 
;home_control.c,884 :: 		Network_data.wifi_status = WIFI_NOT_CONNECTED;
	CLRF        _Network_data+85 
;home_control.c,885 :: 		Network_data.network_status = NETWORK_NOT_CONNECTED;
	CLRF        _Network_data+86 
;home_control.c,887 :: 		Network_data.isWifiConnected = FALSE;
	CLRF        _Network_data+87 
;home_control.c,888 :: 		Network_data.isGprsConnected = FALSE;
	CLRF        _Network_data+88 
;home_control.c,889 :: 		Network_data.isServerConnected = FALSE;
	CLRF        _Network_data+89 
;home_control.c,891 :: 		memset(Network_data.wifi_readLine,'\0',sizeof(Network_data.wifi_readline));
	MOVLW       _Network_data+90
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_Network_data+90)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       100
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;home_control.c,892 :: 		memset(Network_data.gprs_readLine,'\0',sizeof(Network_data.gprs_readline));
	MOVLW       _Network_data+190
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_Network_data+190)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       200
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;home_control.c,893 :: 		Network_data.isWifiInputReady = FALSE;
	CLRF        _Network_data+390 
;home_control.c,894 :: 		Network_data.isGprsInputReady = FALSE;
	CLRF        _Network_data+391 
;home_control.c,895 :: 		Network_data.index_1 = 0;
	CLRF        _Network_data+392 
	CLRF        _Network_data+393 
;home_control.c,896 :: 		Network_data.index_2 = 0;
	CLRF        _Network_data+394 
	CLRF        _Network_data+395 
;home_control.c,898 :: 		Timer.connection_timer_buffer = 0;;
	CLRF        _Timer+0 
	CLRF        _Timer+1 
;home_control.c,899 :: 		Timer.connection_timer = 0;
	CLRF        _Timer+2 
	CLRF        _Timer+3 
;home_control.c,901 :: 		memset(System.manufacturer_number,'\0',sizeof(System.manufacturer_number));
	MOVLW       _System+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_System+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       10
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;home_control.c,902 :: 		memset(System.admin_user,'\0',sizeof(System.admin_user));
	MOVLW       _System+10
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_System+10)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       12
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;home_control.c,904 :: 		}
L_end_default_config:
	RETURN      0
; end of _default_config

_read_config:

;home_control.c,906 :: 		void read_config(){
;home_control.c,908 :: 		}
L_end_read_config:
	RETURN      0
; end of _read_config

_setup:

;home_control.c,910 :: 		void setup(){
;home_control.c,912 :: 		setup_pic();        // Registers, interfaces
	CALL        _setup_pic+0, 0
;home_control.c,917 :: 		}
L_end_setup:
	RETURN      0
; end of _setup

_main:

;home_control.c,919 :: 		void main() {
;home_control.c,921 :: 		setup();
	CALL        _setup+0, 0
;home_control.c,923 :: 		while (1){
L_main185:
;home_control.c,925 :: 		PORTB = 0b11111111;
	MOVLW       255
	MOVWF       PORTB+0 
;home_control.c,926 :: 		PORTC = 0b11111111;
	MOVLW       255
	MOVWF       PORTC+0 
;home_control.c,927 :: 		PORTD = 0b11111111;
	MOVLW       255
	MOVWF       PORTD+0 
;home_control.c,928 :: 		PORTA = 0b11111111;
	MOVLW       255
	MOVWF       PORTA+0 
;home_control.c,929 :: 		delay_ms(500);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main187:
	DECFSZ      R13, 1, 1
	BRA         L_main187
	DECFSZ      R12, 1, 1
	BRA         L_main187
	DECFSZ      R11, 1, 1
	BRA         L_main187
	NOP
	NOP
;home_control.c,930 :: 		PORTB = 0;
	CLRF        PORTB+0 
;home_control.c,931 :: 		PORTC = 0;
	CLRF        PORTC+0 
;home_control.c,932 :: 		PORTD = 0;
	CLRF        PORTD+0 
;home_control.c,933 :: 		PORTA = 0;
	CLRF        PORTA+0 
;home_control.c,934 :: 		delay_ms(500);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main188:
	DECFSZ      R13, 1, 1
	BRA         L_main188
	DECFSZ      R12, 1, 1
	BRA         L_main188
	DECFSZ      R11, 1, 1
	BRA         L_main188
	NOP
	NOP
;home_control.c,941 :: 		}
	GOTO        L_main185
;home_control.c,943 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
