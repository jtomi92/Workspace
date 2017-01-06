
_Susart_Init:

;boot18_32K.c,17 :: 		void Susart_Init(unsigned short brg_reg) org 65136 {
;boot18_32K.c,20 :: 		RCSTA2 = 0x90;
	MOVLW       144
	MOVWF       RCSTA2+0 
;boot18_32K.c,21 :: 		TXSTA2 = 0x26;
	MOVLW       38
	MOVWF       TXSTA2+0 
;boot18_32K.c,22 :: 		TRISD.B7 = 1;
	BSF         TRISD+0, 7 
;boot18_32K.c,23 :: 		TRISD.B6 = 0;
	BCF         TRISD+0, 6 
;boot18_32K.c,25 :: 		while (PIR2.RCIF)
L_Susart_Init0:
	BTFSS       PIR2+0, 5 
	GOTO        L_Susart_Init1
;boot18_32K.c,26 :: 		i = RCREG2;
	GOTO        L_Susart_Init0
L_Susart_Init1:
;boot18_32K.c,28 :: 		SPBRG2 = brg_reg;
	MOVF        FARG_Susart_Init_brg_reg+0, 0 
	MOVWF       SPBRG2+0 
;boot18_32K.c,29 :: 		}
L_end_Susart_Init:
	RETURN      0
; end of _Susart_Init

_Susart_Write:

;boot18_32K.c,32 :: 		void Susart_Write(unsigned short data_) org 65080 {
;boot18_32K.c,34 :: 		while (!TXSTA2.TRMT)
L_Susart_Write2:
	BTFSC       TXSTA2+0, 1 
	GOTO        L_Susart_Write3
;boot18_32K.c,35 :: 		;
	GOTO        L_Susart_Write2
L_Susart_Write3:
;boot18_32K.c,36 :: 		TXREG2 = data_;
	MOVF        FARG_Susart_Write_data_+0, 0 
	MOVWF       TXREG2+0 
;boot18_32K.c,37 :: 		}
L_end_Susart_Write:
	RETURN      0
; end of _Susart_Write

_Susart_Data_Ready:

;boot18_32K.c,39 :: 		unsigned short Susart_Data_Ready() org 65120 {
;boot18_32K.c,40 :: 		return (PIR2.RCIF);
	MOVLW       0
	BTFSC       PIR2+0, 5 
	MOVLW       1
	MOVWF       R0 
;boot18_32K.c,41 :: 		}
L_end_Susart_Data_Ready:
	RETURN      0
; end of _Susart_Data_Ready

_Susart_Read:

;boot18_32K.c,43 :: 		unsigned short Susart_Read() org 65040 {
;boot18_32K.c,45 :: 		rslt = RCREG2;
	MOVF        RCREG2+0, 0 
	MOVWF       R1 
;boot18_32K.c,47 :: 		if (RCSTA2.OERR) {
	BTFSS       RCSTA2+0, 1 
	GOTO        L_Susart_Read4
;boot18_32K.c,48 :: 		RCSTA2.CREN = 0;
	BCF         RCSTA2+0, 4 
;boot18_32K.c,49 :: 		RCSTA2.CREN = 1;
	BSF         RCSTA2+0, 4 
;boot18_32K.c,50 :: 		}
L_Susart_Read4:
;boot18_32K.c,51 :: 		return rslt;
	MOVF        R1, 0 
	MOVWF       R0 
;boot18_32K.c,52 :: 		}
L_end_Susart_Read:
	RETURN      0
; end of _Susart_Read

_Start_Program:

;boot18_32K.c,58 :: 		void Start_Program() org 0xFFC0 {
;boot18_32K.c,59 :: 		}
L_end_Start_Program:
	RETURN      0
; end of _Start_Program

_Flash_Write_Sector:

;boot18_32K.c,61 :: 		void Flash_Write_Sector(long address, char *sdata) org 64020 {
;boot18_32K.c,64 :: 		saveintcon = INTCON;
	MOVF        INTCON+0, 0 
	MOVWF       R1 
;boot18_32K.c,67 :: 		TBLPTRL = Lo(address);
	MOVF        FARG_Flash_Write_Sector_address+0, 0 
	MOVWF       TBLPTRL 
;boot18_32K.c,68 :: 		TBLPTRH = Hi(address);
	MOVF        FARG_Flash_Write_Sector_address+1, 0 
	MOVWF       TBLPTRH 
;boot18_32K.c,69 :: 		TBLPTRU = Higher(address);
	MOVF        FARG_Flash_Write_Sector_address+2, 0 
	MOVWF       TBLPTRU 
;boot18_32K.c,71 :: 		EECON1.EEPGD = 1;
	BSF         EECON1+0, 7 
;boot18_32K.c,72 :: 		EECON1.CFGS = 0;
	BCF         EECON1+0, 6 
;boot18_32K.c,73 :: 		EECON1.WREN = 1;
	BSF         EECON1+0, 2 
;boot18_32K.c,74 :: 		EECON1.FREE = 1;
	BSF         EECON1+0, 4 
;boot18_32K.c,75 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;boot18_32K.c,76 :: 		EECON2 = 0x55;
	MOVLW       85
	MOVWF       EECON2+0 
;boot18_32K.c,77 :: 		EECON2 = 0xAA;
	MOVLW       170
	MOVWF       EECON2+0 
;boot18_32K.c,78 :: 		EECON1.WR = 1;
	BSF         EECON1+0, 1 
;boot18_32K.c,79 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;boot18_32K.c,80 :: 		asm TBLRD*- ;
	TBLRD*-
;boot18_32K.c,82 :: 		FSR0L = Lo(sdata);
	MOVF        FARG_Flash_Write_Sector_sdata+0, 0 
	MOVWF       FSR0 
;boot18_32K.c,83 :: 		FSR0H = Hi(sdata);
	MOVF        FARG_Flash_Write_Sector_sdata+1, 0 
	MOVWF       FSR0H 
;boot18_32K.c,84 :: 		j = 0;
	CLRF        R3 
;boot18_32K.c,85 :: 		while (j < _FLASH_ERASE/_FLASH_WRITE_LATCH) {
L_Flash_Write_Sector5:
	MOVLW       1
	SUBWF       R3, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Flash_Write_Sector6
;boot18_32K.c,86 :: 		i = 0;
	CLRF        R2 
;boot18_32K.c,87 :: 		while (i < _FLASH_WRITE_LATCH) {
L_Flash_Write_Sector7:
	MOVLW       64
	SUBWF       R2, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Flash_Write_Sector8
;boot18_32K.c,88 :: 		TABLAT  = POSTINC0;
	MOVF        POSTINC0+0, 0 
	MOVWF       TABLAT+0 
;boot18_32K.c,90 :: 		TBLWT+*
	TBLWT+*
;boot18_32K.c,92 :: 		i++;
	INCF        R2, 1 
;boot18_32K.c,93 :: 		}
	GOTO        L_Flash_Write_Sector7
L_Flash_Write_Sector8:
;boot18_32K.c,94 :: 		EECON1.EEPGD = 1;
	BSF         EECON1+0, 7 
;boot18_32K.c,95 :: 		EECON1.CFGS = 0;
	BCF         EECON1+0, 6 
;boot18_32K.c,96 :: 		EECON1.WREN = 1;
	BSF         EECON1+0, 2 
;boot18_32K.c,97 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;boot18_32K.c,98 :: 		EECON2 = 0x55;
	MOVLW       85
	MOVWF       EECON2+0 
;boot18_32K.c,99 :: 		EECON2 = 0xAA;
	MOVLW       170
	MOVWF       EECON2+0 
;boot18_32K.c,100 :: 		EECON1.WR = 1;
	BSF         EECON1+0, 1 
;boot18_32K.c,101 :: 		j++;
	INCF        R3, 1 
;boot18_32K.c,102 :: 		}
	GOTO        L_Flash_Write_Sector5
L_Flash_Write_Sector6:
;boot18_32K.c,103 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;boot18_32K.c,104 :: 		EECON1.WREN = 0;
	BCF         EECON1+0, 2 
;boot18_32K.c,106 :: 		INTCON = saveintcon;
	MOVF        R1, 0 
	MOVWF       INTCON+0 
;boot18_32K.c,107 :: 		}
L_end_Flash_Write_Sector:
	RETURN      0
; end of _Flash_Write_Sector

_Susart_Write_Loop:

;boot18_32K.c,109 :: 		unsigned short Susart_Write_Loop(char send, char receive) org 63926 {
;boot18_32K.c,110 :: 		unsigned short rslt = 0;
	CLRF        Susart_Write_Loop_rslt_L0+0 
;boot18_32K.c,112 :: 		LBL_BOOT18_64_01:
___Susart_Write_Loop_LBL_BOOT18_64_01:
;boot18_32K.c,113 :: 		___Boot_Delay64k();
	CALL        64850, 0
;boot18_32K.c,114 :: 		Susart_Write(send);
	MOVF        FARG_Susart_Write_Loop_send+0, 0 
	MOVWF       FARG_Susart_Write_data_+0 
	CALL        65080, 0
;boot18_32K.c,115 :: 		___Boot_Delay64k();
	CALL        64850, 0
;boot18_32K.c,117 :: 		rslt++;
	INCF        Susart_Write_Loop_rslt_L0+0, 1 
;boot18_32K.c,118 :: 		if (rslt == 255u)
	MOVF        Susart_Write_Loop_rslt_L0+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_Susart_Write_Loop9
;boot18_32K.c,119 :: 		return 0;
	CLRF        R0 
	GOTO        L_end_Susart_Write_Loop
L_Susart_Write_Loop9:
;boot18_32K.c,120 :: 		if (Susart_Read() == receive)
	CALL        65040, 0
	MOVF        R0, 0 
	XORWF       FARG_Susart_Write_Loop_receive+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Susart_Write_Loop10
;boot18_32K.c,121 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_Susart_Write_Loop
L_Susart_Write_Loop10:
;boot18_32K.c,122 :: 		goto LBL_BOOT18_64_01;
	GOTO        ___Susart_Write_Loop_LBL_BOOT18_64_01
;boot18_32K.c,123 :: 		}
L_end_Susart_Write_Loop:
	RETURN      0
; end of _Susart_Write_Loop

_Write_Begin:

;boot18_32K.c,129 :: 		void Write_Begin() org 64774 {
;boot18_32K.c,131 :: 		Flash_Write_Sector(0xFFC0, block);
	MOVLW       192
	MOVWF       FARG_Flash_Write_Sector_address+0 
	MOVLW       255
	MOVWF       FARG_Flash_Write_Sector_address+1 
	MOVLW       0
	MOVWF       FARG_Flash_Write_Sector_address+2 
	MOVWF       FARG_Flash_Write_Sector_address+3 
	MOVLW       boot18_32K_block+0
	MOVWF       FARG_Flash_Write_Sector_sdata+0 
	MOVLW       hi_addr(boot18_32K_block+0)
	MOVWF       FARG_Flash_Write_Sector_sdata+1 
	CALL        64020, 0
;boot18_32K.c,133 :: 		block[0] = 0xBC;
	MOVLW       188
	MOVWF       boot18_32K_block+0 
;boot18_32K.c,134 :: 		block[1] = 0xEF;
	MOVLW       239
	MOVWF       boot18_32K_block+1 
;boot18_32K.c,135 :: 		block[2] = 0x7E;
	MOVLW       126
	MOVWF       boot18_32K_block+2 
;boot18_32K.c,136 :: 		block[3] = 0xF0;
	MOVLW       240
	MOVWF       boot18_32K_block+3 
;boot18_32K.c,138 :: 		}
L_end_Write_Begin:
	RETURN      0
; end of _Write_Begin

_Start_Bootload:

;boot18_32K.c,141 :: 		void Start_Bootload() org 65186 {
;boot18_32K.c,142 :: 		unsigned short i = 0, xx, yy;
	CLRF        Start_Bootload_i_L0+0 
	CLRF        Start_Bootload_j_L0+0 
	CLRF        Start_Bootload_j_L0+1 
	CLRF        Start_Bootload_j_L0+2 
	CLRF        Start_Bootload_j_L0+3 
;boot18_32K.c,145 :: 		while (1) {
L_Start_Bootload11:
;boot18_32K.c,146 :: 		if (i == 64u) {
	MOVF        Start_Bootload_i_L0+0, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_Start_Bootload13
;boot18_32K.c,148 :: 		if (!j)
	MOVF        Start_Bootload_j_L0+0, 0 
	IORWF       Start_Bootload_j_L0+1, 0 
	IORWF       Start_Bootload_j_L0+2, 0 
	IORWF       Start_Bootload_j_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Start_Bootload14
;boot18_32K.c,149 :: 		Write_Begin();
	CALL        64774, 0
L_Start_Bootload14:
;boot18_32K.c,150 :: 		Flash_Write_Sector(j, block);
	MOVF        Start_Bootload_j_L0+0, 0 
	MOVWF       FARG_Flash_Write_Sector_address+0 
	MOVF        Start_Bootload_j_L0+1, 0 
	MOVWF       FARG_Flash_Write_Sector_address+1 
	MOVF        Start_Bootload_j_L0+2, 0 
	MOVWF       FARG_Flash_Write_Sector_address+2 
	MOVF        Start_Bootload_j_L0+3, 0 
	MOVWF       FARG_Flash_Write_Sector_address+3 
	MOVLW       boot18_32K_block+0
	MOVWF       FARG_Flash_Write_Sector_sdata+0 
	MOVLW       hi_addr(boot18_32K_block+0)
	MOVWF       FARG_Flash_Write_Sector_sdata+1 
	CALL        64020, 0
;boot18_32K.c,152 :: 		i = 0;
	CLRF        Start_Bootload_i_L0+0 
;boot18_32K.c,153 :: 		j += 0x40;
	MOVLW       64
	ADDWF       Start_Bootload_j_L0+0, 1 
	MOVLW       0
	ADDWFC      Start_Bootload_j_L0+1, 1 
	ADDWFC      Start_Bootload_j_L0+2, 1 
	ADDWFC      Start_Bootload_j_L0+3, 1 
;boot18_32K.c,154 :: 		}
L_Start_Bootload13:
;boot18_32K.c,156 :: 		Susart_Write('y');
	MOVLW       121
	MOVWF       FARG_Susart_Write_data_+0 
	CALL        65080, 0
;boot18_32K.c,157 :: 		while (!Susart_Data_Ready()) ;
L_Start_Bootload15:
	CALL        65120, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Start_Bootload16
	GOTO        L_Start_Bootload15
L_Start_Bootload16:
;boot18_32K.c,159 :: 		yy = Susart_Read();
	CALL        65040, 0
	MOVF        R0, 0 
	MOVWF       Start_Bootload_yy_L0+0 
;boot18_32K.c,161 :: 		Susart_Write('x');
	MOVLW       120
	MOVWF       FARG_Susart_Write_data_+0 
	CALL        65080, 0
;boot18_32K.c,162 :: 		while (!Susart_Data_Ready()) ;
L_Start_Bootload17:
	CALL        65120, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Start_Bootload18
	GOTO        L_Start_Bootload17
L_Start_Bootload18:
;boot18_32K.c,164 :: 		xx = Susart_Read();
	CALL        65040, 0
	MOVF        R0, 0 
	MOVWF       Start_Bootload_xx_L0+0 
;boot18_32K.c,166 :: 		block[i++] = yy;
	MOVLW       boot18_32K_block+0
	MOVWF       FSR1 
	MOVLW       hi_addr(boot18_32K_block+0)
	MOVWF       FSR1H 
	MOVF        Start_Bootload_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        Start_Bootload_yy_L0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        Start_Bootload_i_L0+0, 1 
;boot18_32K.c,167 :: 		block[i++] = xx;
	MOVLW       boot18_32K_block+0
	MOVWF       FSR1 
	MOVLW       hi_addr(boot18_32K_block+0)
	MOVWF       FSR1H 
	MOVF        Start_Bootload_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        Start_Bootload_xx_L0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        Start_Bootload_i_L0+0, 1 
;boot18_32K.c,168 :: 		}
	GOTO        L_Start_Bootload11
;boot18_32K.c,169 :: 		}
L_end_Start_Bootload:
	RETURN      0
; end of _Start_Bootload
