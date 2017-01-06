
_Measure_MS8607:

;MS8607.c,16 :: 		void Measure_MS8607(){
;MS8607.c,19 :: 		unsigned int C1[3] = {0,0,0};
	MOVLW       ?ICSMeasure_MS8607_C1_L0+0
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(?ICSMeasure_MS8607_C1_L0+0)
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(?ICSMeasure_MS8607_C1_L0+0)
	MOVWF       TBLPTRU 
	MOVLW       Measure_MS8607_C1_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(Measure_MS8607_C1_L0+0)
	MOVWF       FSR1H 
	MOVLW       108
	MOVWF       R0 
	MOVLW       1
	MOVWF       R1 
	CALL        ___CC2DW+0, 0
;MS8607.c,37 :: 		INTCON.GIE = 0;
	BCF         INTCON+0, 7 
;MS8607.c,39 :: 		if (isStarted == 0){
	MOVF        _isStarted+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Measure_MS86070
;MS8607.c,40 :: 		Soft_I2C_Init();                  // Init soft i2c module
	CALL        _Soft_I2C_Init+0, 0
;MS8607.c,41 :: 		isStarted = 1;
	MOVLW       1
	MOVWF       _isStarted+0 
;MS8607.c,42 :: 		Soft_I2C_Start();                 // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,43 :: 		Soft_I2C_Write(0b11101100);       // 0x76 + WRITE
	MOVLW       236
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,44 :: 		Soft_I2C_Write(0x1E);             // RESET
	MOVLW       30
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,45 :: 		Soft_I2C_Stop();                  // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,46 :: 		}
L_Measure_MS86070:
;MS8607.c,47 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,48 :: 		Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
	MOVLW       236
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,49 :: 		Soft_I2C_Write(0xA2);                // 0xA2   == C1
	MOVLW       162
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,50 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,51 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,52 :: 		Soft_I2C_Write(0b11101101);          // 0X76 + READ
	MOVLW       237
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,53 :: 		C1[1] = Soft_I2C_Read(1);            // Read first byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C1_L0+2 
	MOVLW       0
	MOVWF       Measure_MS8607_C1_L0+3 
;MS8607.c,54 :: 		C1[2] = Soft_I2C_Read(0);            // Read second byte
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C1_L0+4 
	MOVLW       0
	MOVWF       Measure_MS8607_C1_L0+5 
;MS8607.c,55 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,57 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,58 :: 		Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
	MOVLW       236
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,59 :: 		Soft_I2C_Write(0xA4);                // 0xA4   == C2
	MOVLW       164
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,60 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,61 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,62 :: 		Soft_I2C_Write(0b11101101);          // 0X76 + READ
	MOVLW       237
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,63 :: 		C2[1] = Soft_I2C_Read(1);            // Read first byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C2_L0+2 
	MOVLW       0
	MOVWF       Measure_MS8607_C2_L0+3 
;MS8607.c,64 :: 		C2[2] = Soft_I2C_Read(0);            // Read second byte
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C2_L0+4 
	MOVLW       0
	MOVWF       Measure_MS8607_C2_L0+5 
;MS8607.c,65 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,67 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,68 :: 		Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
	MOVLW       236
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,69 :: 		Soft_I2C_Write(0xA6);                // 0xA6   == C3
	MOVLW       166
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,70 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,71 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,72 :: 		Soft_I2C_Write(0b11101101);          // 0X76 + READ
	MOVLW       237
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,73 :: 		C3[1] = Soft_I2C_Read(1);            // Read first byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C3_L0+2 
	MOVLW       0
	MOVWF       Measure_MS8607_C3_L0+3 
;MS8607.c,74 :: 		C3[2] = Soft_I2C_Read(0);            // Read second byte
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C3_L0+4 
	MOVLW       0
	MOVWF       Measure_MS8607_C3_L0+5 
;MS8607.c,75 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,77 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,78 :: 		Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
	MOVLW       236
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,79 :: 		Soft_I2C_Write(0xA8);                // 0xA8   == C4
	MOVLW       168
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,80 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,81 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,82 :: 		Soft_I2C_Write(0b11101101);          // 0X76 + READ
	MOVLW       237
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,83 :: 		C4[1] = Soft_I2C_Read(1);            // Read first byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C4_L0+2 
	MOVLW       0
	MOVWF       Measure_MS8607_C4_L0+3 
;MS8607.c,84 :: 		C4[2] = Soft_I2C_Read(0);            // Read second byte
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C4_L0+4 
	MOVLW       0
	MOVWF       Measure_MS8607_C4_L0+5 
;MS8607.c,85 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,87 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,88 :: 		Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
	MOVLW       236
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,89 :: 		Soft_I2C_Write(0xAA);                // 0xAA   == C5
	MOVLW       170
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,90 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,91 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,92 :: 		Soft_I2C_Write(0b11101101);          // 0X76 + READ
	MOVLW       237
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,93 :: 		C5[1] = Soft_I2C_Read(1);            // Read first byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C5_L0+2 
	MOVLW       0
	MOVWF       Measure_MS8607_C5_L0+3 
;MS8607.c,94 :: 		C5[2] = Soft_I2C_Read(0);            // Read second byte
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C5_L0+4 
	MOVLW       0
	MOVWF       Measure_MS8607_C5_L0+5 
;MS8607.c,95 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,97 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,98 :: 		Soft_I2C_Write(0b11101100);          // 0x76 + WRITE
	MOVLW       236
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,99 :: 		Soft_I2C_Write(0xAC);                // 0xA2   == C6
	MOVLW       172
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,100 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,101 :: 		Soft_I2C_Start();                    // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,102 :: 		Soft_I2C_Write(0b11101101);          // 0X76 + READ
	MOVLW       237
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,103 :: 		C6[1] = Soft_I2C_Read(1);            // Read first byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C6_L0+2 
	MOVLW       0
	MOVWF       Measure_MS8607_C6_L0+3 
;MS8607.c,104 :: 		C6[2] = Soft_I2C_Read(0);            // Read second byte
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_C6_L0+4 
	MOVLW       0
	MOVWF       Measure_MS8607_C6_L0+5 
;MS8607.c,105 :: 		Soft_I2C_Stop();                     // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,107 :: 		C1[0] = C1[1] * 256 + C1[2];
	MOVF        Measure_MS8607_C1_L0+2, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        Measure_MS8607_C1_L0+4, 0 
	ADDWF       R0, 0 
	MOVWF       Measure_MS8607_C1_L0+0 
	MOVF        Measure_MS8607_C1_L0+5, 0 
	ADDWFC      R1, 0 
	MOVWF       Measure_MS8607_C1_L0+1 
;MS8607.c,108 :: 		C2[0] = C2[1] * 256 + C2[2];
	MOVF        Measure_MS8607_C2_L0+2, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        Measure_MS8607_C2_L0+4, 0 
	ADDWF       R0, 0 
	MOVWF       Measure_MS8607_C2_L0+0 
	MOVF        Measure_MS8607_C2_L0+5, 0 
	ADDWFC      R1, 0 
	MOVWF       Measure_MS8607_C2_L0+1 
;MS8607.c,109 :: 		C3[0] = C3[1] * 256 + C3[2];
	MOVF        Measure_MS8607_C3_L0+2, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        Measure_MS8607_C3_L0+4, 0 
	ADDWF       R0, 0 
	MOVWF       Measure_MS8607_C3_L0+0 
	MOVF        Measure_MS8607_C3_L0+5, 0 
	ADDWFC      R1, 0 
	MOVWF       Measure_MS8607_C3_L0+1 
;MS8607.c,110 :: 		C4[0] = C4[1] * 256 + C4[2];
	MOVF        Measure_MS8607_C4_L0+2, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        Measure_MS8607_C4_L0+4, 0 
	ADDWF       R0, 0 
	MOVWF       Measure_MS8607_C4_L0+0 
	MOVF        Measure_MS8607_C4_L0+5, 0 
	ADDWFC      R1, 0 
	MOVWF       Measure_MS8607_C4_L0+1 
;MS8607.c,111 :: 		C5[0] = C5[1] * 256 + C5[2];
	MOVF        Measure_MS8607_C5_L0+2, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        Measure_MS8607_C5_L0+4, 0 
	ADDWF       R0, 0 
	MOVWF       Measure_MS8607_C5_L0+0 
	MOVF        Measure_MS8607_C5_L0+5, 0 
	ADDWFC      R1, 0 
	MOVWF       Measure_MS8607_C5_L0+1 
;MS8607.c,112 :: 		C6[0] = C6[1] * 256 + C6[2];
	MOVF        Measure_MS8607_C6_L0+2, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        Measure_MS8607_C6_L0+4, 0 
	ADDWF       R0, 0 
	MOVWF       Measure_MS8607_C6_L0+0 
	MOVF        Measure_MS8607_C6_L0+5, 0 
	ADDWFC      R1, 0 
	MOVWF       Measure_MS8607_C6_L0+1 
;MS8607.c,115 :: 		Soft_I2C_Start();                // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,116 :: 		Soft_I2C_Write(0b11101100);      // 0x76 + WRITE
	MOVLW       236
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,117 :: 		Soft_I2C_Write(0x48);            // 0x48   == OSR(4096)
	MOVLW       72
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,118 :: 		Soft_I2C_Stop();                 // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,119 :: 		delay_ms(10);                    // Wait slave to measure
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_Measure_MS86071:
	DECFSZ      R13, 1, 1
	BRA         L_Measure_MS86071
	DECFSZ      R12, 1, 1
	BRA         L_Measure_MS86071
	NOP
	NOP
;MS8607.c,120 :: 		Soft_I2C_Start();                // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,121 :: 		Soft_I2C_Write(0b11101100);      // 0X76 + WRITE
	MOVLW       236
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,122 :: 		Soft_I2C_Write(0x00);            // ADC READ
	CLRF        FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,123 :: 		Soft_I2C_Stop();                 // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,124 :: 		Soft_I2C_Start();                // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,125 :: 		Soft_I2C_Write(0b11101101);      // 0x76 + READ
	MOVLW       237
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,126 :: 		D1[1] = Soft_I2C_Read(1);        // Read first byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_D1_L0+4 
	MOVLW       0
	MOVWF       Measure_MS8607_D1_L0+5 
	MOVWF       Measure_MS8607_D1_L0+6 
	MOVWF       Measure_MS8607_D1_L0+7 
;MS8607.c,127 :: 		D1[2] = Soft_I2C_Read(1);        // Read seconds byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_D1_L0+8 
	MOVLW       0
	MOVWF       Measure_MS8607_D1_L0+9 
	MOVWF       Measure_MS8607_D1_L0+10 
	MOVWF       Measure_MS8607_D1_L0+11 
;MS8607.c,128 :: 		D1[3] = Soft_I2C_Read(0);        // Read third byte
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_D1_L0+12 
	MOVLW       0
	MOVWF       Measure_MS8607_D1_L0+13 
	MOVWF       Measure_MS8607_D1_L0+14 
	MOVWF       Measure_MS8607_D1_L0+15 
;MS8607.c,129 :: 		Soft_I2C_Stop();                 // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,131 :: 		D1[0] = D1[1] * 65536 + D1[2] * 256 + D1[3];
	MOVF        Measure_MS8607_D1_L0+5, 0 
	MOVWF       R8 
	MOVF        Measure_MS8607_D1_L0+4, 0 
	MOVWF       R7 
	CLRF        R5 
	CLRF        R6 
	MOVF        Measure_MS8607_D1_L0+10, 0 
	MOVWF       R3 
	MOVF        Measure_MS8607_D1_L0+9, 0 
	MOVWF       R2 
	MOVF        Measure_MS8607_D1_L0+8, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R5, 0 
	ADDWF       R0, 1 
	MOVF        R6, 0 
	ADDWFC      R1, 1 
	MOVF        R7, 0 
	ADDWFC      R2, 1 
	MOVF        R8, 0 
	ADDWFC      R3, 1 
	MOVF        Measure_MS8607_D1_L0+12, 0 
	ADDWF       R0, 0 
	MOVWF       Measure_MS8607_D1_L0+0 
	MOVF        Measure_MS8607_D1_L0+13, 0 
	ADDWFC      R1, 0 
	MOVWF       Measure_MS8607_D1_L0+1 
	MOVF        Measure_MS8607_D1_L0+14, 0 
	ADDWFC      R2, 0 
	MOVWF       Measure_MS8607_D1_L0+2 
	MOVF        Measure_MS8607_D1_L0+15, 0 
	ADDWFC      R3, 0 
	MOVWF       Measure_MS8607_D1_L0+3 
;MS8607.c,133 :: 		Soft_I2C_Start();                // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,134 :: 		Soft_I2C_Write(0b11101100);      // 0x76 + WRITE
	MOVLW       236
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,135 :: 		Soft_I2C_Write(0x58);            // 0x58   == D2 OSR(4096)
	MOVLW       88
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,136 :: 		Soft_I2C_Stop();                 // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,137 :: 		delay_ms(10);                    // Wait Slave to measure
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_Measure_MS86072:
	DECFSZ      R13, 1, 1
	BRA         L_Measure_MS86072
	DECFSZ      R12, 1, 1
	BRA         L_Measure_MS86072
	NOP
	NOP
;MS8607.c,138 :: 		Soft_I2C_Start();                // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,139 :: 		Soft_I2C_Write(0b11101100);      // 0X76 + WRITE
	MOVLW       236
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,140 :: 		Soft_I2C_Write(0x00);            // ADC READ
	CLRF        FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,141 :: 		Soft_I2C_Stop();                 // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,142 :: 		Soft_I2C_Start();                // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,143 :: 		Soft_I2C_Write(0b11101101);      // 0x76 + READ
	MOVLW       237
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,145 :: 		D2[1] = Soft_I2C_Read(1);        // Read first byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_D2_L0+4 
	MOVLW       0
	MOVWF       Measure_MS8607_D2_L0+5 
	MOVWF       Measure_MS8607_D2_L0+6 
	MOVWF       Measure_MS8607_D2_L0+7 
;MS8607.c,146 :: 		D2[2] = Soft_I2C_Read(1);        // Read seconds byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_D2_L0+8 
	MOVLW       0
	MOVWF       Measure_MS8607_D2_L0+9 
	MOVWF       Measure_MS8607_D2_L0+10 
	MOVWF       Measure_MS8607_D2_L0+11 
;MS8607.c,147 :: 		D2[3] = Soft_I2C_Read(0);        // Read third byte
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_D2_L0+12 
	MOVLW       0
	MOVWF       Measure_MS8607_D2_L0+13 
	MOVWF       Measure_MS8607_D2_L0+14 
	MOVWF       Measure_MS8607_D2_L0+15 
;MS8607.c,149 :: 		Soft_I2C_Stop();                 // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,151 :: 		D2[0] = D2[1] * 65536 + D2[2] * 256 + D2[3];
	MOVF        Measure_MS8607_D2_L0+5, 0 
	MOVWF       R8 
	MOVF        Measure_MS8607_D2_L0+4, 0 
	MOVWF       R7 
	CLRF        R5 
	CLRF        R6 
	MOVF        Measure_MS8607_D2_L0+10, 0 
	MOVWF       R3 
	MOVF        Measure_MS8607_D2_L0+9, 0 
	MOVWF       R2 
	MOVF        Measure_MS8607_D2_L0+8, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R5, 0 
	ADDWF       R0, 1 
	MOVF        R6, 0 
	ADDWFC      R1, 1 
	MOVF        R7, 0 
	ADDWFC      R2, 1 
	MOVF        R8, 0 
	ADDWFC      R3, 1 
	MOVF        Measure_MS8607_D2_L0+12, 0 
	ADDWF       R0, 0 
	MOVWF       Measure_MS8607_D2_L0+0 
	MOVF        Measure_MS8607_D2_L0+13, 0 
	ADDWFC      R1, 0 
	MOVWF       Measure_MS8607_D2_L0+1 
	MOVF        Measure_MS8607_D2_L0+14, 0 
	ADDWFC      R2, 0 
	MOVWF       Measure_MS8607_D2_L0+2 
	MOVF        Measure_MS8607_D2_L0+15, 0 
	ADDWFC      R3, 0 
	MOVWF       Measure_MS8607_D2_L0+3 
;MS8607.c,153 :: 		Soft_I2C_Start();                // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,154 :: 		Soft_I2C_Write(0b10000000);      // 0x76 + WRITE
	MOVLW       128
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,155 :: 		Soft_I2C_Write(0xE5);            // Measure RH (Hold Master)
	MOVLW       229
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,156 :: 		Soft_I2C_Start();                // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;MS8607.c,157 :: 		Soft_I2C_Write(0b10000001);      // 0X76 + WRITE
	MOVLW       129
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;MS8607.c,158 :: 		delay_ms(10);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_Measure_MS86073:
	DECFSZ      R13, 1, 1
	BRA         L_Measure_MS86073
	DECFSZ      R12, 1, 1
	BRA         L_Measure_MS86073
	NOP
	NOP
;MS8607.c,160 :: 		D3[1] = Soft_I2C_Read(1);        // Read first byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_D3_L0+4 
	MOVLW       0
	MOVWF       Measure_MS8607_D3_L0+5 
	MOVWF       Measure_MS8607_D3_L0+6 
	MOVWF       Measure_MS8607_D3_L0+7 
;MS8607.c,161 :: 		D3[2] = Soft_I2C_Read(1) & 0b11111100;  // Read second byte and set status bits to 0
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVLW       252
	ANDWF       R0, 0 
	MOVWF       Measure_MS8607_D3_L0+8 
	CLRF        Measure_MS8607_D3_L0+9 
	MOVLW       0
	ANDWF       Measure_MS8607_D3_L0+9, 1 
	MOVLW       0
	MOVWF       Measure_MS8607_D3_L0+10 
	MOVWF       Measure_MS8607_D3_L0+11 
	MOVLW       0
	MOVWF       Measure_MS8607_D3_L0+9 
	MOVWF       Measure_MS8607_D3_L0+10 
	MOVWF       Measure_MS8607_D3_L0+11 
;MS8607.c,162 :: 		D3[3] = Soft_I2C_Read(0);               // Checksum
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_D3_L0+12 
	MOVLW       0
	MOVWF       Measure_MS8607_D3_L0+13 
	MOVWF       Measure_MS8607_D3_L0+14 
	MOVWF       Measure_MS8607_D3_L0+15 
;MS8607.c,164 :: 		Soft_I2C_Stop();                 // Issue Stop Signal
	CALL        _Soft_I2C_Stop+0, 0
;MS8607.c,166 :: 		D3[0] = D3[1] * 256.0 + D3[2];
	MOVF        Measure_MS8607_D3_L0+4, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_D3_L0+5, 0 
	MOVWF       R1 
	MOVF        Measure_MS8607_D3_L0+6, 0 
	MOVWF       R2 
	MOVF        Measure_MS8607_D3_L0+7, 0 
	MOVWF       R3 
	CALL        _longword2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       135
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVF        Measure_MS8607_D3_L0+8, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_D3_L0+9, 0 
	MOVWF       R1 
	MOVF        Measure_MS8607_D3_L0+10, 0 
	MOVWF       R2 
	MOVF        Measure_MS8607_D3_L0+11, 0 
	MOVWF       R3 
	CALL        _longword2double+0, 0
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R4 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R5 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R6 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	CALL        _double2longword+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_D3_L0+0 
	MOVF        R1, 0 
	MOVWF       Measure_MS8607_D3_L0+1 
	MOVF        R2, 0 
	MOVWF       Measure_MS8607_D3_L0+2 
	MOVF        R3, 0 
	MOVWF       Measure_MS8607_D3_L0+3 
;MS8607.c,170 :: 		dT = D2[0] - (C5[0] * pow(2,8));
	MOVLW       0
	MOVWF       FARG_pow_x+0 
	MOVLW       0
	MOVWF       FARG_pow_x+1 
	MOVLW       0
	MOVWF       FARG_pow_x+2 
	MOVLW       128
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       0
	MOVWF       FARG_pow_y+2 
	MOVLW       130
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVF        Measure_MS8607_C5_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_C5_L0+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R4 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R5 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R6 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVF        Measure_MS8607_D2_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_D2_L0+1, 0 
	MOVWF       R1 
	MOVF        Measure_MS8607_D2_L0+2, 0 
	MOVWF       R2 
	MOVF        Measure_MS8607_D2_L0+3, 0 
	MOVWF       R3 
	CALL        _longword2double+0, 0
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R4 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R5 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R6 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       Measure_MS8607_dT_L0+0 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       Measure_MS8607_dT_L0+1 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       Measure_MS8607_dT_L0+2 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       Measure_MS8607_dT_L0+3 
;MS8607.c,172 :: 		TEMP = 2000 + (dT * C6[0] / pow(2,23));
	MOVF        Measure_MS8607_C6_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_C6_L0+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R4 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R5 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R6 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVLW       0
	MOVWF       FARG_pow_x+0 
	MOVLW       0
	MOVWF       FARG_pow_x+1 
	MOVLW       0
	MOVWF       FARG_pow_x+2 
	MOVLW       128
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       56
	MOVWF       FARG_pow_y+2 
	MOVLW       131
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R0 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R1 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R2 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       137
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _TEMP+0 
	MOVF        R1, 0 
	MOVWF       _TEMP+1 
	MOVF        R2, 0 
	MOVWF       _TEMP+2 
	MOVF        R3, 0 
	MOVWF       _TEMP+3 
;MS8607.c,174 :: 		OFF = C2[0] * pow(2,17) + (C4[0] * dT) / pow(2,6);
	MOVLW       0
	MOVWF       FARG_pow_x+0 
	MOVLW       0
	MOVWF       FARG_pow_x+1 
	MOVLW       0
	MOVWF       FARG_pow_x+2 
	MOVLW       128
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       8
	MOVWF       FARG_pow_y+2 
	MOVLW       131
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVF        Measure_MS8607_C2_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_C2_L0+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R4 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R5 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R6 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+4 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+5 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+6 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+7 
	MOVF        Measure_MS8607_C4_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_C4_L0+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVF        Measure_MS8607_dT_L0+0, 0 
	MOVWF       R4 
	MOVF        Measure_MS8607_dT_L0+1, 0 
	MOVWF       R5 
	MOVF        Measure_MS8607_dT_L0+2, 0 
	MOVWF       R6 
	MOVF        Measure_MS8607_dT_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVLW       0
	MOVWF       FARG_pow_x+0 
	MOVLW       0
	MOVWF       FARG_pow_x+1 
	MOVLW       0
	MOVWF       FARG_pow_x+2 
	MOVLW       128
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       64
	MOVWF       FARG_pow_y+2 
	MOVLW       129
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R0 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R1 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R2 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        FLOC__Measure_MS8607+4, 0 
	MOVWF       R4 
	MOVF        FLOC__Measure_MS8607+5, 0 
	MOVWF       R5 
	MOVF        FLOC__Measure_MS8607+6, 0 
	MOVWF       R6 
	MOVF        FLOC__Measure_MS8607+7, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_OFF_L0+0 
	MOVF        R1, 0 
	MOVWF       Measure_MS8607_OFF_L0+1 
	MOVF        R2, 0 
	MOVWF       Measure_MS8607_OFF_L0+2 
	MOVF        R3, 0 
	MOVWF       Measure_MS8607_OFF_L0+3 
;MS8607.c,176 :: 		SENS = C1[0] * pow(2,16) + (C3[0] * dT) / pow(2,7);
	MOVLW       0
	MOVWF       FARG_pow_x+0 
	MOVLW       0
	MOVWF       FARG_pow_x+1 
	MOVLW       0
	MOVWF       FARG_pow_x+2 
	MOVLW       128
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       0
	MOVWF       FARG_pow_y+2 
	MOVLW       131
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVF        Measure_MS8607_C1_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_C1_L0+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R4 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R5 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R6 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+4 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+5 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+6 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+7 
	MOVF        Measure_MS8607_C3_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_C3_L0+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVF        Measure_MS8607_dT_L0+0, 0 
	MOVWF       R4 
	MOVF        Measure_MS8607_dT_L0+1, 0 
	MOVWF       R5 
	MOVF        Measure_MS8607_dT_L0+2, 0 
	MOVWF       R6 
	MOVF        Measure_MS8607_dT_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVLW       0
	MOVWF       FARG_pow_x+0 
	MOVLW       0
	MOVWF       FARG_pow_x+1 
	MOVLW       0
	MOVWF       FARG_pow_x+2 
	MOVLW       128
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       96
	MOVWF       FARG_pow_y+2 
	MOVLW       129
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R0 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R1 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R2 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        FLOC__Measure_MS8607+4, 0 
	MOVWF       R4 
	MOVF        FLOC__Measure_MS8607+5, 0 
	MOVWF       R5 
	MOVF        FLOC__Measure_MS8607+6, 0 
	MOVWF       R6 
	MOVF        FLOC__Measure_MS8607+7, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_SENS_L0+0 
	MOVF        R1, 0 
	MOVWF       Measure_MS8607_SENS_L0+1 
	MOVF        R2, 0 
	MOVWF       Measure_MS8607_SENS_L0+2 
	MOVF        R3, 0 
	MOVWF       Measure_MS8607_SENS_L0+3 
;MS8607.c,178 :: 		if (TEMP>= 2000){
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       137
	MOVWF       R7 
	MOVF        _TEMP+0, 0 
	MOVWF       R0 
	MOVF        _TEMP+1, 0 
	MOVWF       R1 
	MOVF        _TEMP+2, 0 
	MOVWF       R2 
	MOVF        _TEMP+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Measure_MS86074
;MS8607.c,179 :: 		T2 = 0;
	CLRF        Measure_MS8607_T2_L0+0 
	CLRF        Measure_MS8607_T2_L0+1 
	CLRF        Measure_MS8607_T2_L0+2 
	CLRF        Measure_MS8607_T2_L0+3 
;MS8607.c,180 :: 		OFF2 = 0;
	CLRF        Measure_MS8607_OFF2_L0+0 
	CLRF        Measure_MS8607_OFF2_L0+1 
	CLRF        Measure_MS8607_OFF2_L0+2 
	CLRF        Measure_MS8607_OFF2_L0+3 
;MS8607.c,181 :: 		SENS2 = 0;
	CLRF        Measure_MS8607_SENS2_L0+0 
	CLRF        Measure_MS8607_SENS2_L0+1 
	CLRF        Measure_MS8607_SENS2_L0+2 
	CLRF        Measure_MS8607_SENS2_L0+3 
;MS8607.c,183 :: 		} else if (TEMP< 2000){
	GOTO        L_Measure_MS86075
L_Measure_MS86074:
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       137
	MOVWF       R7 
	MOVF        _TEMP+0, 0 
	MOVWF       R0 
	MOVF        _TEMP+1, 0 
	MOVWF       R1 
	MOVF        _TEMP+2, 0 
	MOVWF       R2 
	MOVF        _TEMP+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Measure_MS86076
;MS8607.c,184 :: 		T2 = dT * dT / pow(2,31);
	MOVF        Measure_MS8607_dT_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_dT_L0+1, 0 
	MOVWF       R1 
	MOVF        Measure_MS8607_dT_L0+2, 0 
	MOVWF       R2 
	MOVF        Measure_MS8607_dT_L0+3, 0 
	MOVWF       R3 
	MOVF        Measure_MS8607_dT_L0+0, 0 
	MOVWF       R4 
	MOVF        Measure_MS8607_dT_L0+1, 0 
	MOVWF       R5 
	MOVF        Measure_MS8607_dT_L0+2, 0 
	MOVWF       R6 
	MOVF        Measure_MS8607_dT_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVLW       0
	MOVWF       FARG_pow_x+0 
	MOVLW       0
	MOVWF       FARG_pow_x+1 
	MOVLW       0
	MOVWF       FARG_pow_x+2 
	MOVLW       128
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       120
	MOVWF       FARG_pow_y+2 
	MOVLW       131
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R0 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R1 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R2 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_T2_L0+0 
	MOVF        R1, 0 
	MOVWF       Measure_MS8607_T2_L0+1 
	MOVF        R2, 0 
	MOVWF       Measure_MS8607_T2_L0+2 
	MOVF        R3, 0 
	MOVWF       Measure_MS8607_T2_L0+3 
;MS8607.c,185 :: 		OFF2 = 5 * (pow((TEMP- 2000),2)) / 2;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       137
	MOVWF       R7 
	MOVF        _TEMP+0, 0 
	MOVWF       R0 
	MOVF        _TEMP+1, 0 
	MOVWF       R1 
	MOVF        _TEMP+2, 0 
	MOVWF       R2 
	MOVF        _TEMP+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_pow_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_pow_x+1 
	MOVF        R2, 0 
	MOVWF       FARG_pow_x+2 
	MOVF        R3, 0 
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       0
	MOVWF       FARG_pow_y+2 
	MOVLW       128
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_OFF2_L0+0 
	MOVF        R1, 0 
	MOVWF       Measure_MS8607_OFF2_L0+1 
	MOVF        R2, 0 
	MOVWF       Measure_MS8607_OFF2_L0+2 
	MOVF        R3, 0 
	MOVWF       Measure_MS8607_OFF2_L0+3 
;MS8607.c,186 :: 		SENS2 = OFF2 / 2;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_SENS2_L0+0 
	MOVF        R1, 0 
	MOVWF       Measure_MS8607_SENS2_L0+1 
	MOVF        R2, 0 
	MOVWF       Measure_MS8607_SENS2_L0+2 
	MOVF        R3, 0 
	MOVWF       Measure_MS8607_SENS2_L0+3 
;MS8607.c,188 :: 		} else if (TEMP< -1500){
	GOTO        L_Measure_MS86077
L_Measure_MS86076:
	MOVLW       0
	MOVWF       R4 
	MOVLW       128
	MOVWF       R5 
	MOVLW       187
	MOVWF       R6 
	MOVLW       137
	MOVWF       R7 
	MOVF        _TEMP+0, 0 
	MOVWF       R0 
	MOVF        _TEMP+1, 0 
	MOVWF       R1 
	MOVF        _TEMP+2, 0 
	MOVWF       R2 
	MOVF        _TEMP+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Measure_MS86078
;MS8607.c,190 :: 		OFF2 = OFF2 + 7 * (pow(TEMP+1500,20));
	MOVF        _TEMP+0, 0 
	MOVWF       R0 
	MOVF        _TEMP+1, 0 
	MOVWF       R1 
	MOVF        _TEMP+2, 0 
	MOVWF       R2 
	MOVF        _TEMP+3, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	MOVLW       128
	MOVWF       R5 
	MOVLW       59
	MOVWF       R6 
	MOVLW       137
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_pow_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_pow_x+1 
	MOVF        R2, 0 
	MOVWF       FARG_pow_x+2 
	MOVF        R3, 0 
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       32
	MOVWF       FARG_pow_y+2 
	MOVLW       131
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       96
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        Measure_MS8607_OFF2_L0+0, 0 
	MOVWF       R4 
	MOVF        Measure_MS8607_OFF2_L0+1, 0 
	MOVWF       R5 
	MOVF        Measure_MS8607_OFF2_L0+2, 0 
	MOVWF       R6 
	MOVF        Measure_MS8607_OFF2_L0+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_OFF2_L0+0 
	MOVF        R1, 0 
	MOVWF       Measure_MS8607_OFF2_L0+1 
	MOVF        R2, 0 
	MOVWF       Measure_MS8607_OFF2_L0+2 
	MOVF        R3, 0 
	MOVWF       Measure_MS8607_OFF2_L0+3 
;MS8607.c,191 :: 		SENS2 = SENS2 + 11 * (pow(TEMP+ 1500,2)) / 2;
	MOVF        _TEMP+0, 0 
	MOVWF       R0 
	MOVF        _TEMP+1, 0 
	MOVWF       R1 
	MOVF        _TEMP+2, 0 
	MOVWF       R2 
	MOVF        _TEMP+3, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	MOVLW       128
	MOVWF       R5 
	MOVLW       59
	MOVWF       R6 
	MOVLW       137
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_pow_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_pow_x+1 
	MOVF        R2, 0 
	MOVWF       FARG_pow_x+2 
	MOVF        R3, 0 
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       0
	MOVWF       FARG_pow_y+2 
	MOVLW       128
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       48
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        Measure_MS8607_SENS2_L0+0, 0 
	MOVWF       R4 
	MOVF        Measure_MS8607_SENS2_L0+1, 0 
	MOVWF       R5 
	MOVF        Measure_MS8607_SENS2_L0+2, 0 
	MOVWF       R6 
	MOVF        Measure_MS8607_SENS2_L0+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_SENS2_L0+0 
	MOVF        R1, 0 
	MOVWF       Measure_MS8607_SENS2_L0+1 
	MOVF        R2, 0 
	MOVWF       Measure_MS8607_SENS2_L0+2 
	MOVF        R3, 0 
	MOVWF       Measure_MS8607_SENS2_L0+3 
;MS8607.c,192 :: 		}
L_Measure_MS86078:
L_Measure_MS86077:
L_Measure_MS86075:
;MS8607.c,194 :: 		TEMP= TEMP- T2;
	MOVF        Measure_MS8607_T2_L0+0, 0 
	MOVWF       R4 
	MOVF        Measure_MS8607_T2_L0+1, 0 
	MOVWF       R5 
	MOVF        Measure_MS8607_T2_L0+2, 0 
	MOVWF       R6 
	MOVF        Measure_MS8607_T2_L0+3, 0 
	MOVWF       R7 
	MOVF        _TEMP+0, 0 
	MOVWF       R0 
	MOVF        _TEMP+1, 0 
	MOVWF       R1 
	MOVF        _TEMP+2, 0 
	MOVWF       R2 
	MOVF        _TEMP+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _TEMP+0 
	MOVF        R1, 0 
	MOVWF       _TEMP+1 
	MOVF        R2, 0 
	MOVWF       _TEMP+2 
	MOVF        R3, 0 
	MOVWF       _TEMP+3 
;MS8607.c,195 :: 		OFF = OFF - OFF2;
	MOVF        Measure_MS8607_OFF2_L0+0, 0 
	MOVWF       R4 
	MOVF        Measure_MS8607_OFF2_L0+1, 0 
	MOVWF       R5 
	MOVF        Measure_MS8607_OFF2_L0+2, 0 
	MOVWF       R6 
	MOVF        Measure_MS8607_OFF2_L0+3, 0 
	MOVWF       R7 
	MOVF        Measure_MS8607_OFF_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_OFF_L0+1, 0 
	MOVWF       R1 
	MOVF        Measure_MS8607_OFF_L0+2, 0 
	MOVWF       R2 
	MOVF        Measure_MS8607_OFF_L0+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Measure_MS8607_OFF_L0+0 
	MOVF        R1, 0 
	MOVWF       Measure_MS8607_OFF_L0+1 
	MOVF        R2, 0 
	MOVWF       Measure_MS8607_OFF_L0+2 
	MOVF        R3, 0 
	MOVWF       Measure_MS8607_OFF_L0+3 
;MS8607.c,196 :: 		SENS = SENS - SENS2;
	MOVF        Measure_MS8607_SENS2_L0+0, 0 
	MOVWF       R4 
	MOVF        Measure_MS8607_SENS2_L0+1, 0 
	MOVWF       R5 
	MOVF        Measure_MS8607_SENS2_L0+2, 0 
	MOVWF       R6 
	MOVF        Measure_MS8607_SENS2_L0+3, 0 
	MOVWF       R7 
	MOVF        Measure_MS8607_SENS_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_SENS_L0+1, 0 
	MOVWF       R1 
	MOVF        Measure_MS8607_SENS_L0+2, 0 
	MOVWF       R2 
	MOVF        Measure_MS8607_SENS_L0+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       Measure_MS8607_SENS_L0+0 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       Measure_MS8607_SENS_L0+1 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       Measure_MS8607_SENS_L0+2 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       Measure_MS8607_SENS_L0+3 
;MS8607.c,198 :: 		PRES= (D1[0] * SENS / pow(2,21) - OFF) / pow(2,15);
	MOVF        Measure_MS8607_D1_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_D1_L0+1, 0 
	MOVWF       R1 
	MOVF        Measure_MS8607_D1_L0+2, 0 
	MOVWF       R2 
	MOVF        Measure_MS8607_D1_L0+3, 0 
	MOVWF       R3 
	CALL        _longword2double+0, 0
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R4 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R5 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R6 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVLW       0
	MOVWF       FARG_pow_x+0 
	MOVLW       0
	MOVWF       FARG_pow_x+1 
	MOVLW       0
	MOVWF       FARG_pow_x+2 
	MOVLW       128
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       40
	MOVWF       FARG_pow_y+2 
	MOVLW       131
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R0 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R1 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R2 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        Measure_MS8607_OFF_L0+0, 0 
	MOVWF       R4 
	MOVF        Measure_MS8607_OFF_L0+1, 0 
	MOVWF       R5 
	MOVF        Measure_MS8607_OFF_L0+2, 0 
	MOVWF       R6 
	MOVF        Measure_MS8607_OFF_L0+3, 0 
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVLW       0
	MOVWF       FARG_pow_x+0 
	MOVLW       0
	MOVWF       FARG_pow_x+1 
	MOVLW       0
	MOVWF       FARG_pow_x+2 
	MOVLW       128
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       112
	MOVWF       FARG_pow_y+2 
	MOVLW       130
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R0 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R1 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R2 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _PRES+0 
	MOVF        R1, 0 
	MOVWF       _PRES+1 
	MOVF        R2, 0 
	MOVWF       _PRES+2 
	MOVF        R3, 0 
	MOVWF       _PRES+3 
;MS8607.c,200 :: 		RH = 100 * (-6 + (125.0 * D3[0] /pow(2,16)));
	MOVF        Measure_MS8607_D3_L0+0, 0 
	MOVWF       R0 
	MOVF        Measure_MS8607_D3_L0+1, 0 
	MOVWF       R1 
	MOVF        Measure_MS8607_D3_L0+2, 0 
	MOVWF       R2 
	MOVF        Measure_MS8607_D3_L0+3, 0 
	MOVWF       R3 
	CALL        _longword2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVLW       0
	MOVWF       FARG_pow_x+0 
	MOVLW       0
	MOVWF       FARG_pow_x+1 
	MOVLW       0
	MOVWF       FARG_pow_x+2 
	MOVLW       128
	MOVWF       FARG_pow_x+3 
	MOVLW       0
	MOVWF       FARG_pow_y+0 
	MOVLW       0
	MOVWF       FARG_pow_y+1 
	MOVLW       0
	MOVWF       FARG_pow_y+2 
	MOVLW       131
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R0 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R1 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R2 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       192
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _RH+0 
	MOVF        R1, 0 
	MOVWF       _RH+1 
	MOVF        R2, 0 
	MOVWF       _RH+2 
	MOVF        R3, 0 
	MOVWF       _RH+3 
;MS8607.c,201 :: 		RH = RH / 100.0;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _RH+0 
	MOVF        R1, 0 
	MOVWF       _RH+1 
	MOVF        R2, 0 
	MOVWF       _RH+2 
	MOVF        R3, 0 
	MOVWF       _RH+3 
;MS8607.c,202 :: 		TEMP= TEMP/ 100;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	MOVF        _TEMP+0, 0 
	MOVWF       R0 
	MOVF        _TEMP+1, 0 
	MOVWF       R1 
	MOVF        _TEMP+2, 0 
	MOVWF       R2 
	MOVF        _TEMP+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Measure_MS8607+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Measure_MS8607+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Measure_MS8607+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Measure_MS8607+3 
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       _TEMP+0 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       _TEMP+1 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       _TEMP+2 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       _TEMP+3 
;MS8607.c,203 :: 		PRES= PRES/ 100;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	MOVF        _PRES+0, 0 
	MOVWF       R0 
	MOVF        _PRES+1, 0 
	MOVWF       R1 
	MOVF        _PRES+2, 0 
	MOVWF       R2 
	MOVF        _PRES+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _PRES+0 
	MOVF        R1, 0 
	MOVWF       _PRES+1 
	MOVF        R2, 0 
	MOVWF       _PRES+2 
	MOVF        R3, 0 
	MOVWF       _PRES+3 
;MS8607.c,204 :: 		FAR = (TEMP * 9)/5 +32.0;
	MOVF        FLOC__Measure_MS8607+0, 0 
	MOVWF       R0 
	MOVF        FLOC__Measure_MS8607+1, 0 
	MOVWF       R1 
	MOVF        FLOC__Measure_MS8607+2, 0 
	MOVWF       R2 
	MOVF        FLOC__Measure_MS8607+3, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       16
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       132
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _FAR+0 
	MOVF        R1, 0 
	MOVWF       _FAR+1 
	MOVF        R2, 0 
	MOVWF       _FAR+2 
	MOVF        R3, 0 
	MOVWF       _FAR+3 
;MS8607.c,206 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;MS8607.c,207 :: 		}
L_end_Measure_MS8607:
	RETURN      0
; end of _Measure_MS8607

_getTemperature:

;MS8607.c,209 :: 		long double getTemperature(){
;MS8607.c,210 :: 		return TEMP;
	MOVF        _TEMP+0, 0 
	MOVWF       R0 
	MOVF        _TEMP+1, 0 
	MOVWF       R1 
	MOVF        _TEMP+2, 0 
	MOVWF       R2 
	MOVF        _TEMP+3, 0 
	MOVWF       R3 
;MS8607.c,211 :: 		}
L_end_getTemperature:
	RETURN      0
; end of _getTemperature

_getHumidity:

;MS8607.c,212 :: 		long double getHumidity(){
;MS8607.c,213 :: 		return RH;
	MOVF        _RH+0, 0 
	MOVWF       R0 
	MOVF        _RH+1, 0 
	MOVWF       R1 
	MOVF        _RH+2, 0 
	MOVWF       R2 
	MOVF        _RH+3, 0 
	MOVWF       R3 
;MS8607.c,214 :: 		}
L_end_getHumidity:
	RETURN      0
; end of _getHumidity

_getPressure:

;MS8607.c,215 :: 		long double getPressure(){
;MS8607.c,216 :: 		return PRES;
	MOVF        _PRES+0, 0 
	MOVWF       R0 
	MOVF        _PRES+1, 0 
	MOVWF       R1 
	MOVF        _PRES+2, 0 
	MOVWF       R2 
	MOVF        _PRES+3, 0 
	MOVWF       R3 
;MS8607.c,217 :: 		}
L_end_getPressure:
	RETURN      0
; end of _getPressure

_getFahrenheit:

;MS8607.c,218 :: 		long double getFahrenheit(){
;MS8607.c,219 :: 		return FAR;
	MOVF        _FAR+0, 0 
	MOVWF       R0 
	MOVF        _FAR+1, 0 
	MOVWF       R1 
	MOVF        _FAR+2, 0 
	MOVWF       R2 
	MOVF        _FAR+3, 0 
	MOVWF       R3 
;MS8607.c,220 :: 		}
L_end_getFahrenheit:
	RETURN      0
; end of _getFahrenheit
