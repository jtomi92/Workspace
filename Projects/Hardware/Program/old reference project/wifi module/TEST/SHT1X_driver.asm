
_SHT_Reset:

;SHT1X_driver.c,24 :: 		void SHT_Reset() {
;SHT1X_driver.c,25 :: 		Soft_I2C_Scl = 0;                              // SCL low
	BCF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,26 :: 		Soft_I2C_Sda_Direction = 1;                     // define SDA as input
	BSF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;SHT1X_driver.c,27 :: 		for (i = 1; i <= 18; i++)              // repeat 18 times
	MOVLW       1
	MOVWF       _i+0 
L_SHT_Reset0:
	MOVF        _i+0, 0 
	SUBLW       18
	BTFSS       STATUS+0, 0 
	GOTO        L_SHT_Reset1
;SHT1X_driver.c,28 :: 		Soft_I2C_Scl = ~Soft_I2C_Scl;                        // invert SCL
	BTG         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,27 :: 		for (i = 1; i <= 18; i++)              // repeat 18 times
	INCF        _i+0, 1 
;SHT1X_driver.c,28 :: 		Soft_I2C_Scl = ~Soft_I2C_Scl;                        // invert SCL
	GOTO        L_SHT_Reset0
L_SHT_Reset1:
;SHT1X_driver.c,29 :: 		}
L_end_SHT_Reset:
	RETURN      0
; end of _SHT_Reset

_Transmission_Start:

;SHT1X_driver.c,31 :: 		void Transmission_Start() {
;SHT1X_driver.c,32 :: 		Soft_I2C_Sda_Direction = 1;                     // define SDA as input
	BSF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;SHT1X_driver.c,33 :: 		Soft_I2C_Scl = 1;                              // SCL high
	BSF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,34 :: 		Delay_1us();                           // 1us delay
	CALL        _Delay_1us+0, 0
;SHT1X_driver.c,35 :: 		Soft_I2C_Sda_Direction = 0;                     // define SDA as output
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;SHT1X_driver.c,36 :: 		Soft_I2C_Scl = 0;                              // SDA low
	BCF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,37 :: 		Delay_1us();                           // 1us delay
	CALL        _Delay_1us+0, 0
;SHT1X_driver.c,38 :: 		Soft_I2C_Scl = 0;                              // SCL low
	BCF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,39 :: 		Delay_1us();                           // 1us delay
	CALL        _Delay_1us+0, 0
;SHT1X_driver.c,40 :: 		Soft_I2C_Scl = 1;                              // SCL high
	BSF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,41 :: 		Delay_1us();                           // 1us delay
	CALL        _Delay_1us+0, 0
;SHT1X_driver.c,42 :: 		Soft_I2C_Sda_Direction = 1;                     // define SDA as input
	BSF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;SHT1X_driver.c,43 :: 		Delay_1us();                           // 1us delay
	CALL        _Delay_1us+0, 0
;SHT1X_driver.c,44 :: 		Soft_I2C_Scl = 0;                              // SCL low
	BCF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,45 :: 		}
L_end_Transmission_Start:
	RETURN      0
; end of _Transmission_Start

_MCU_ACK:

;SHT1X_driver.c,48 :: 		void MCU_ACK() {
;SHT1X_driver.c,49 :: 		Soft_I2C_Sda_Direction = 0;     // define SDA as output
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;SHT1X_driver.c,50 :: 		Soft_I2C_Sda = 0;              // SDA low
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
;SHT1X_driver.c,51 :: 		Soft_I2C_Scl = 1;              // SCL high
	BSF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,52 :: 		Delay_1us();           // 1us delay
	CALL        _Delay_1us+0, 0
;SHT1X_driver.c,53 :: 		Soft_I2C_Scl = 0;              // SCL low
	BCF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,54 :: 		Delay_1us();           // 1us delay
	CALL        _Delay_1us+0, 0
;SHT1X_driver.c,55 :: 		Soft_I2C_Sda_Direction = 1;     // define SDA as input
	BSF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;SHT1X_driver.c,56 :: 		}
L_end_MCU_ACK:
	RETURN      0
; end of _MCU_ACK

_Measure:

;SHT1X_driver.c,59 :: 		int Measure(short num) {
;SHT1X_driver.c,61 :: 		j = num;                           // j = command (0x03 or 0x05)
	MOVF        FARG_Measure_num+0, 0 
	MOVWF       _j+0 
;SHT1X_driver.c,62 :: 		SHT_Reset();                       // procedure for reseting SHT11
	CALL        _SHT_Reset+0, 0
;SHT1X_driver.c,63 :: 		Transmission_Start();              // procedure for starting transmission
	CALL        _Transmission_Start+0, 0
;SHT1X_driver.c,64 :: 		k = 0;                             // k = 0
	CLRF        _k+0 
	CLRF        _k+1 
;SHT1X_driver.c,65 :: 		Soft_I2C_Sda_Direction = 0;                 // define SDA as output
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;SHT1X_driver.c,66 :: 		Soft_I2C_Scl = 0;                          // SCL low
	BCF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,67 :: 		for(i = 1; i <= 8; i++) {          // repeat 8 times
	MOVLW       1
	MOVWF       _i+0 
L_Measure3:
	MOVF        _i+0, 0 
	SUBLW       8
	BTFSS       STATUS+0, 0 
	GOTO        L_Measure4
;SHT1X_driver.c,68 :: 		if (j.B7 == 1)                   // if bit 7 = 1
	BTFSS       _j+0, 7 
	GOTO        L_Measure6
;SHT1X_driver.c,69 :: 		Soft_I2C_Sda_Direction = 1;              // define SDA as input
	BSF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
	GOTO        L_Measure7
L_Measure6:
;SHT1X_driver.c,71 :: 		Soft_I2C_Sda_Direction = 0;              // define SDA as output
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;SHT1X_driver.c,72 :: 		Soft_I2C_Sda = 0;                       // SDA low
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
;SHT1X_driver.c,73 :: 		}
L_Measure7:
;SHT1X_driver.c,74 :: 		Delay_1us();                     // 1us delay
	CALL        _Delay_1us+0, 0
;SHT1X_driver.c,75 :: 		Soft_I2C_Scl = 1;                        // SCL high
	BSF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,76 :: 		Delay_1us();                     // 1us delay
	CALL        _Delay_1us+0, 0
;SHT1X_driver.c,77 :: 		Soft_I2C_Scl = 0;                        // SCL low
	BCF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,78 :: 		j <<= 1;                         // move contents of j one place left
	RLCF        _j+0, 1 
	BCF         _j+0, 0 
;SHT1X_driver.c,67 :: 		for(i = 1; i <= 8; i++) {          // repeat 8 times
	INCF        _i+0, 1 
;SHT1X_driver.c,79 :: 		}
	GOTO        L_Measure3
L_Measure4:
;SHT1X_driver.c,81 :: 		Soft_I2C_Sda_Direction = 1;                 // define SDA as input
	BSF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;SHT1X_driver.c,82 :: 		Soft_I2C_Scl = 1;                          // SCL high
	BSF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,83 :: 		Delay_1us();                       // 1us delay
	CALL        _Delay_1us+0, 0
;SHT1X_driver.c,84 :: 		Soft_I2C_Scl = 0;                          // SCL low
	BCF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,85 :: 		Delay_1us();                       // 1us delay
	CALL        _Delay_1us+0, 0
;SHT1X_driver.c,86 :: 		while (Soft_I2C_Sda == 1)                  // while SDA is high, do nothing
L_Measure8:
	BTFSS       RC0_bit+0, BitPos(RC0_bit+0) 
	GOTO        L_Measure9
;SHT1X_driver.c,87 :: 		Delay_1us();                     // 1us delay
	CALL        _Delay_1us+0, 0
	GOTO        L_Measure8
L_Measure9:
;SHT1X_driver.c,89 :: 		for (i = 1; i <=16; i++) {         // repeat 16 times
	MOVLW       1
	MOVWF       _i+0 
L_Measure10:
	MOVF        _i+0, 0 
	SUBLW       16
	BTFSS       STATUS+0, 0 
	GOTO        L_Measure11
;SHT1X_driver.c,90 :: 		k <<= 1;                         // move contents of k one place left
	RLCF        _k+0, 1 
	BCF         _k+0, 0 
	RLCF        _k+1, 1 
;SHT1X_driver.c,91 :: 		Soft_I2C_Scl = 1;                        // SCL high
	BSF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,92 :: 		if (Soft_I2C_Sda == 1)                   // if SDA is high
	BTFSS       RC0_bit+0, BitPos(RC0_bit+0) 
	GOTO        L_Measure13
;SHT1X_driver.c,93 :: 		k = k | 0x0001;
	BSF         _k+0, 0 
L_Measure13:
;SHT1X_driver.c,94 :: 		Soft_I2C_Scl = 0;
	BCF         RC1_bit+0, BitPos(RC1_bit+0) 
;SHT1X_driver.c,95 :: 		if (i == 8)                      // if counter i = 8 then
	MOVF        _i+0, 0 
	XORLW       8
	BTFSS       STATUS+0, 2 
	GOTO        L_Measure14
;SHT1X_driver.c,96 :: 		MCU_ACK();                     // MCU acknowledge
	CALL        _MCU_ACK+0, 0
L_Measure14:
;SHT1X_driver.c,89 :: 		for (i = 1; i <=16; i++) {         // repeat 16 times
	INCF        _i+0, 1 
;SHT1X_driver.c,97 :: 		}
	GOTO        L_Measure10
L_Measure11:
;SHT1X_driver.c,98 :: 		return k;                          // returns contents of k
	MOVF        _k+0, 0 
	MOVWF       R0 
	MOVF        _k+1, 0 
	MOVWF       R1 
;SHT1X_driver.c,99 :: 		}
L_end_Measure:
	RETURN      0
; end of _Measure

_Read_SHT1X:

;SHT1X_driver.c,101 :: 		char* Read_SHT1X() {
;SHT1X_driver.c,107 :: 		Soft_I2C_Sda_Direction = 0;
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;SHT1X_driver.c,108 :: 		Soft_I2C_Scl_Direction = 0;                 // SCL is output
	BCF         TRISC1_bit+0, BitPos(TRISC1_bit+0) 
;SHT1X_driver.c,111 :: 		RC1IE_bit = 0;                // disable Rx1 intterupts
	BCF         RC1IE_bit+0, BitPos(RC1IE_bit+0) 
;SHT1X_driver.c,113 :: 		SOt = Measure(0x03);        // function for measuring (command 0x03 is for temperature)
	MOVLW       3
	MOVWF       FARG_Measure_num+0 
	CALL        _Measure+0, 0
	MOVF        R0, 0 
	MOVWF       _SOt+0 
	MOVF        R1, 0 
	MOVWF       _SOt+1 
;SHT1X_driver.c,115 :: 		SOrh = Measure(0x05);       // function for measuring (command 0x05 is for humidity)
	MOVLW       5
	MOVWF       FARG_Measure_num+0 
	CALL        _Measure+0, 0
	MOVF        R0, 0 
	MOVWF       _SOrh+0 
	MOVF        R1, 0 
	MOVWF       _SOrh+1 
;SHT1X_driver.c,116 :: 		RC1IE_bit = 1;                // enable Rx1 intterupts
	BSF         RC1IE_bit+0, BitPos(RC1IE_bit+0) 
;SHT1X_driver.c,121 :: 		if(SOt > D1)                     // if temperature is positive
	MOVF        _SOt+1, 0 
	SUBLW       15
	BTFSS       STATUS+0, 2 
	GOTO        L__Read_SHT1X22
	MOVF        _SOt+0, 0 
	SUBLW       160
L__Read_SHT1X22:
	BTFSC       STATUS+0, 0 
	GOTO        L_Read_SHT1X15
;SHT1X_driver.c,122 :: 		Ta_res = SOt * D2 - D1;        // calculate temperature
	MOVLW       160
	SUBWF       _SOt+0, 0 
	MOVWF       _Ta_res+0 
	MOVLW       15
	SUBWFB      _SOt+1, 0 
	MOVWF       _Ta_res+1 
	GOTO        L_Read_SHT1X16
L_Read_SHT1X15:
;SHT1X_driver.c,124 :: 		Ta_res = D1 - SOt * D2;        // calculate temperature
	MOVF        _SOt+0, 0 
	SUBLW       160
	MOVWF       _Ta_res+0 
	MOVF        _SOt+1, 0 
	MOVWF       _Ta_res+1 
	MOVLW       15
	SUBFWB      _Ta_res+1, 1 
L_Read_SHT1X16:
;SHT1X_driver.c,128 :: 		temp = SOrh * SOrh * C3 / 100000;             // calculate humidity
	MOVF        _SOrh+0, 0 
	MOVWF       R0 
	MOVF        _SOrh+1, 0 
	MOVWF       R1 
	MOVF        _SOrh+0, 0 
	MOVWF       R4 
	MOVF        _SOrh+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       28
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       R2 
	MOVWF       R3 
	MOVLW       160
	MOVWF       R4 
	MOVLW       134
	MOVWF       R5 
	MOVLW       1
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Div_32x32_S+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Read_SHT1X+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Read_SHT1X+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Read_SHT1X+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Read_SHT1X+3 
	MOVF        FLOC__Read_SHT1X+0, 0 
	MOVWF       _temp+0 
	MOVF        FLOC__Read_SHT1X+1, 0 
	MOVWF       _temp+1 
;SHT1X_driver.c,129 :: 		Rh_res = SOrh * C2 / 100 - temp - C1;         // calculate humidity
	MOVF        _SOrh+0, 0 
	MOVWF       R0 
	MOVF        _SOrh+1, 0 
	MOVWF       R1 
	MOVLW       149
	MOVWF       R4 
	MOVLW       1
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        FLOC__Read_SHT1X+0, 0 
	SUBWF       R0, 0 
	MOVWF       _Rh_res+0 
	MOVF        FLOC__Read_SHT1X+1, 0 
	SUBWFB      R1, 0 
	MOVWF       _Rh_res+1 
	MOVLW       144
	SUBWF       _Rh_res+0, 1 
	MOVLW       1
	SUBWFB      _Rh_res+1, 1 
;SHT1X_driver.c,131 :: 		p1 = itoa(Ta_res,converter);
	MOVF        _Ta_res+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _Ta_res+1, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       Read_SHT1X_converter_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(Read_SHT1X_converter_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       Read_SHT1X_p1_L0+0 
	MOVF        R1, 0 
	MOVWF       Read_SHT1X_p1_L0+1 
;SHT1X_driver.c,132 :: 		p2 = itoa(Rh_res,converter);
	MOVF        _Rh_res+0, 0 
	MOVWF       FARG_itoa_i+0 
	MOVF        _Rh_res+1, 0 
	MOVWF       FARG_itoa_i+1 
	MOVLW       Read_SHT1X_converter_L0+0
	MOVWF       FARG_itoa_b+0 
	MOVLW       hi_addr(Read_SHT1X_converter_L0+0)
	MOVWF       FARG_itoa_b+1 
	CALL        _itoa+0, 0
	MOVF        R0, 0 
	MOVWF       Read_SHT1X_p2_L0+0 
	MOVF        R1, 0 
	MOVWF       Read_SHT1X_p2_L0+1 
;SHT1X_driver.c,133 :: 		strcpy(buffer,p1);
	MOVLW       Read_SHT1X_buffer_L0+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(Read_SHT1X_buffer_L0+0)
	MOVWF       FARG_strcpy_to+1 
	MOVF        Read_SHT1X_p1_L0+0, 0 
	MOVWF       FARG_strcpy_from+0 
	MOVF        Read_SHT1X_p1_L0+1, 0 
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;SHT1X_driver.c,134 :: 		strcat(buffer,":");
	MOVLW       Read_SHT1X_buffer_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(Read_SHT1X_buffer_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr1_SHT1X_driver+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr1_SHT1X_driver+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SHT1X_driver.c,135 :: 		strcat(buffer,p2);
	MOVLW       Read_SHT1X_buffer_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(Read_SHT1X_buffer_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVF        Read_SHT1X_p2_L0+0, 0 
	MOVWF       FARG_strcat_from+0 
	MOVF        Read_SHT1X_p2_L0+1, 0 
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SHT1X_driver.c,136 :: 		strcat(buffer,":");
	MOVLW       Read_SHT1X_buffer_L0+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(Read_SHT1X_buffer_L0+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr2_SHT1X_driver+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr2_SHT1X_driver+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;SHT1X_driver.c,138 :: 		return buffer;
	MOVLW       Read_SHT1X_buffer_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(Read_SHT1X_buffer_L0+0)
	MOVWF       R1 
;SHT1X_driver.c,139 :: 		}
L_end_Read_SHT1X:
	RETURN      0
; end of _Read_SHT1X
