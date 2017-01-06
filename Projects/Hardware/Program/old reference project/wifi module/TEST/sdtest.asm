
_UART1_Write_Line:

;sdtest.c,15 :: 		void UART1_Write_Line(char *uart_text) {
;sdtest.c,16 :: 		UART1_Write_Text(uart_text);
	MOVF        FARG_UART1_Write_Line_uart_text+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        FARG_UART1_Write_Line_uart_text+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,17 :: 		UART1_Write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;sdtest.c,18 :: 		UART1_Write(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;sdtest.c,19 :: 		}
L_end_UART1_Write_Line:
	RETURN      0
; end of _UART1_Write_Line

_M_Create_New_File:

;sdtest.c,22 :: 		void M_Create_New_File() {
;sdtest.c,23 :: 		filename[7] = 'A';
	MOVLW       65
	MOVWF       _filename+7 
;sdtest.c,24 :: 		Mmc_Fat_Set_File_Date(2010, 4, 19, 9, 0, 0); // Set file date & time info
	MOVLW       218
	MOVWF       FARG_Mmc_Fat_Set_File_Date_year+0 
	MOVLW       7
	MOVWF       FARG_Mmc_Fat_Set_File_Date_year+1 
	MOVLW       4
	MOVWF       FARG_Mmc_Fat_Set_File_Date_month+0 
	MOVLW       19
	MOVWF       FARG_Mmc_Fat_Set_File_Date_day+0 
	MOVLW       9
	MOVWF       FARG_Mmc_Fat_Set_File_Date_hours+0 
	CLRF        FARG_Mmc_Fat_Set_File_Date_mins+0 
	CLRF        FARG_Mmc_Fat_Set_File_Date_seconds+0 
	CALL        _Mmc_Fat_Set_File_Date+0, 0
;sdtest.c,25 :: 		Mmc_Fat_Assign(&filename, 0xA0);          // Find existing file or create a new one
	MOVLW       _filename+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	MOVLW       160
	MOVWF       FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
;sdtest.c,26 :: 		Mmc_Fat_Rewrite();                        // To clear file and start with new data
	CALL        _Mmc_Fat_Rewrite+0, 0
;sdtest.c,27 :: 		for(loop = 1; loop <= 99; loop++) {
	MOVLW       1
	MOVWF       _loop+0 
L_M_Create_New_File0:
	MOVF        _loop+0, 0 
	SUBLW       99
	BTFSS       STATUS+0, 0 
	GOTO        L_M_Create_New_File1
;sdtest.c,28 :: 		UART1_Write('.');
	MOVLW       46
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;sdtest.c,29 :: 		file_contents[0] = loop / 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+0 
;sdtest.c,30 :: 		file_contents[1] = loop % 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+1 
;sdtest.c,31 :: 		Mmc_Fat_Write(file_contents, LINE_LEN-1);   // write data to the assigned file
	MOVLW       _file_contents+0
	MOVWF       FARG_Mmc_Fat_Write_fdata+0 
	MOVLW       hi_addr(_file_contents+0)
	MOVWF       FARG_Mmc_Fat_Write_fdata+1 
	MOVLW       42
	MOVWF       FARG_Mmc_Fat_Write_len+0 
	MOVLW       0
	MOVWF       FARG_Mmc_Fat_Write_len+1 
	CALL        _Mmc_Fat_Write+0, 0
;sdtest.c,27 :: 		for(loop = 1; loop <= 99; loop++) {
	INCF        _loop+0, 1 
;sdtest.c,32 :: 		}
	GOTO        L_M_Create_New_File0
L_M_Create_New_File1:
;sdtest.c,33 :: 		}
L_end_M_Create_New_File:
	RETURN      0
; end of _M_Create_New_File

_M_Create_Multiple_Files:

;sdtest.c,36 :: 		void M_Create_Multiple_Files() {
;sdtest.c,37 :: 		for(loop2 = 'B'; loop2 <= 'Z'; loop2++) {
	MOVLW       66
	MOVWF       _loop2+0 
L_M_Create_Multiple_Files3:
	MOVF        _loop2+0, 0 
	SUBLW       90
	BTFSS       STATUS+0, 0 
	GOTO        L_M_Create_Multiple_Files4
;sdtest.c,38 :: 		UART1_Write(loop2);                  // signal the progress
	MOVF        _loop2+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;sdtest.c,39 :: 		filename[7] = loop2;                 // set filename
	MOVF        _loop2+0, 0 
	MOVWF       _filename+7 
;sdtest.c,40 :: 		Mmc_Fat_Set_File_Date(2010, 4, 19, 9, 0, 0); // Set file date & time info
	MOVLW       218
	MOVWF       FARG_Mmc_Fat_Set_File_Date_year+0 
	MOVLW       7
	MOVWF       FARG_Mmc_Fat_Set_File_Date_year+1 
	MOVLW       4
	MOVWF       FARG_Mmc_Fat_Set_File_Date_month+0 
	MOVLW       19
	MOVWF       FARG_Mmc_Fat_Set_File_Date_day+0 
	MOVLW       9
	MOVWF       FARG_Mmc_Fat_Set_File_Date_hours+0 
	CLRF        FARG_Mmc_Fat_Set_File_Date_mins+0 
	CLRF        FARG_Mmc_Fat_Set_File_Date_seconds+0 
	CALL        _Mmc_Fat_Set_File_Date+0, 0
;sdtest.c,41 :: 		Mmc_Fat_Assign(&filename, 0xA0);     // find existing file or create a new one
	MOVLW       _filename+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	MOVLW       160
	MOVWF       FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
;sdtest.c,42 :: 		Mmc_Fat_Rewrite();                   // To clear file and start with new data
	CALL        _Mmc_Fat_Rewrite+0, 0
;sdtest.c,43 :: 		for(loop = 1; loop <= 44; loop++) {
	MOVLW       1
	MOVWF       _loop+0 
L_M_Create_Multiple_Files6:
	MOVF        _loop+0, 0 
	SUBLW       44
	BTFSS       STATUS+0, 0 
	GOTO        L_M_Create_Multiple_Files7
;sdtest.c,44 :: 		file_contents[0] = loop / 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+0 
;sdtest.c,45 :: 		file_contents[1] = loop % 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+1 
;sdtest.c,46 :: 		Mmc_Fat_Write(file_contents, LINE_LEN-1);  // write data to the assigned file
	MOVLW       _file_contents+0
	MOVWF       FARG_Mmc_Fat_Write_fdata+0 
	MOVLW       hi_addr(_file_contents+0)
	MOVWF       FARG_Mmc_Fat_Write_fdata+1 
	MOVLW       42
	MOVWF       FARG_Mmc_Fat_Write_len+0 
	MOVLW       0
	MOVWF       FARG_Mmc_Fat_Write_len+1 
	CALL        _Mmc_Fat_Write+0, 0
;sdtest.c,43 :: 		for(loop = 1; loop <= 44; loop++) {
	INCF        _loop+0, 1 
;sdtest.c,47 :: 		}
	GOTO        L_M_Create_Multiple_Files6
L_M_Create_Multiple_Files7:
;sdtest.c,37 :: 		for(loop2 = 'B'; loop2 <= 'Z'; loop2++) {
	INCF        _loop2+0, 1 
;sdtest.c,48 :: 		}
	GOTO        L_M_Create_Multiple_Files3
L_M_Create_Multiple_Files4:
;sdtest.c,49 :: 		}
L_end_M_Create_Multiple_Files:
	RETURN      0
; end of _M_Create_Multiple_Files

_M_Open_File_Rewrite:

;sdtest.c,52 :: 		void M_Open_File_Rewrite() {
;sdtest.c,53 :: 		filename[7] = 'C';
	MOVLW       67
	MOVWF       _filename+7 
;sdtest.c,54 :: 		Mmc_Fat_Assign(&filename, 0);
	MOVLW       _filename+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	CLRF        FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
;sdtest.c,55 :: 		Mmc_Fat_Rewrite();
	CALL        _Mmc_Fat_Rewrite+0, 0
;sdtest.c,56 :: 		for(loop = 1; loop <= 55; loop++) {
	MOVLW       1
	MOVWF       _loop+0 
L_M_Open_File_Rewrite9:
	MOVF        _loop+0, 0 
	SUBLW       55
	BTFSS       STATUS+0, 0 
	GOTO        L_M_Open_File_Rewrite10
;sdtest.c,57 :: 		file_contents[0] = loop / 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+0 
;sdtest.c,58 :: 		file_contents[1] = loop % 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+1 
;sdtest.c,59 :: 		Mmc_Fat_Write(file_contents, LINE_LEN-1);    // write data to the assigned file
	MOVLW       _file_contents+0
	MOVWF       FARG_Mmc_Fat_Write_fdata+0 
	MOVLW       hi_addr(_file_contents+0)
	MOVWF       FARG_Mmc_Fat_Write_fdata+1 
	MOVLW       42
	MOVWF       FARG_Mmc_Fat_Write_len+0 
	MOVLW       0
	MOVWF       FARG_Mmc_Fat_Write_len+1 
	CALL        _Mmc_Fat_Write+0, 0
;sdtest.c,56 :: 		for(loop = 1; loop <= 55; loop++) {
	INCF        _loop+0, 1 
;sdtest.c,60 :: 		}
	GOTO        L_M_Open_File_Rewrite9
L_M_Open_File_Rewrite10:
;sdtest.c,61 :: 		}
L_end_M_Open_File_Rewrite:
	RETURN      0
; end of _M_Open_File_Rewrite

_M_Open_File_Append:

;sdtest.c,65 :: 		void M_Open_File_Append() {
;sdtest.c,66 :: 		filename[7] = 'B';
	MOVLW       66
	MOVWF       _filename+7 
;sdtest.c,67 :: 		Mmc_Fat_Assign(&filename, 0);
	MOVLW       _filename+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	CLRF        FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
;sdtest.c,68 :: 		Mmc_Fat_Set_File_Date(2010, 4, 19, 9, 20, 0);
	MOVLW       218
	MOVWF       FARG_Mmc_Fat_Set_File_Date_year+0 
	MOVLW       7
	MOVWF       FARG_Mmc_Fat_Set_File_Date_year+1 
	MOVLW       4
	MOVWF       FARG_Mmc_Fat_Set_File_Date_month+0 
	MOVLW       19
	MOVWF       FARG_Mmc_Fat_Set_File_Date_day+0 
	MOVLW       9
	MOVWF       FARG_Mmc_Fat_Set_File_Date_hours+0 
	MOVLW       20
	MOVWF       FARG_Mmc_Fat_Set_File_Date_mins+0 
	CLRF        FARG_Mmc_Fat_Set_File_Date_seconds+0 
	CALL        _Mmc_Fat_Set_File_Date+0, 0
;sdtest.c,69 :: 		Mmc_Fat_Append();                                    // Prepare file for append
	CALL        _Mmc_Fat_Append+0, 0
;sdtest.c,70 :: 		Mmc_Fat_Write(" for mikroElektronika 2010n", 27);   // Write data to assigned file
	MOVLW       ?lstr1_sdtest+0
	MOVWF       FARG_Mmc_Fat_Write_fdata+0 
	MOVLW       hi_addr(?lstr1_sdtest+0)
	MOVWF       FARG_Mmc_Fat_Write_fdata+1 
	MOVLW       27
	MOVWF       FARG_Mmc_Fat_Write_len+0 
	MOVLW       0
	MOVWF       FARG_Mmc_Fat_Write_len+1 
	CALL        _Mmc_Fat_Write+0, 0
;sdtest.c,71 :: 		}
L_end_M_Open_File_Append:
	RETURN      0
; end of _M_Open_File_Append

_M_Open_File_Read:

;sdtest.c,74 :: 		void M_Open_File_Read() {
;sdtest.c,77 :: 		filename[7] = 'B';
	MOVLW       66
	MOVWF       _filename+7 
;sdtest.c,78 :: 		Mmc_Fat_Assign(&filename, 0);
	MOVLW       _filename+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	CLRF        FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
;sdtest.c,79 :: 		Mmc_Fat_Reset(&size);            // To read file, procedure returns size of file
	MOVLW       _size+0
	MOVWF       FARG_Mmc_Fat_Reset_size+0 
	MOVLW       hi_addr(_size+0)
	MOVWF       FARG_Mmc_Fat_Reset_size+1 
	CALL        _Mmc_Fat_Reset+0, 0
;sdtest.c,80 :: 		for (i = 1; i <= size; i++) {
	MOVLW       1
	MOVWF       _i+0 
	MOVLW       0
	MOVWF       _i+1 
	MOVWF       _i+2 
	MOVWF       _i+3 
L_M_Open_File_Read12:
	MOVF        _i+3, 0 
	SUBWF       _size+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Open_File_Read34
	MOVF        _i+2, 0 
	SUBWF       _size+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Open_File_Read34
	MOVF        _i+1, 0 
	SUBWF       _size+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Open_File_Read34
	MOVF        _i+0, 0 
	SUBWF       _size+0, 0 
L__M_Open_File_Read34:
	BTFSS       STATUS+0, 0 
	GOTO        L_M_Open_File_Read13
;sdtest.c,81 :: 		Mmc_Fat_Read(&character);
	MOVLW       M_Open_File_Read_character_L0+0
	MOVWF       FARG_Mmc_Fat_Read_fdata+0 
	MOVLW       hi_addr(M_Open_File_Read_character_L0+0)
	MOVWF       FARG_Mmc_Fat_Read_fdata+1 
	CALL        _Mmc_Fat_Read+0, 0
;sdtest.c,82 :: 		UART1_Write(character);        // Write data to UART
	MOVF        M_Open_File_Read_character_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;sdtest.c,80 :: 		for (i = 1; i <= size; i++) {
	MOVLW       1
	ADDWF       _i+0, 1 
	MOVLW       0
	ADDWFC      _i+1, 1 
	ADDWFC      _i+2, 1 
	ADDWFC      _i+3, 1 
;sdtest.c,83 :: 		}
	GOTO        L_M_Open_File_Read12
L_M_Open_File_Read13:
;sdtest.c,84 :: 		}
L_end_M_Open_File_Read:
	RETURN      0
; end of _M_Open_File_Read

_M_Delete_File:

;sdtest.c,88 :: 		void M_Delete_File() {
;sdtest.c,89 :: 		filename[7] = 'F';
	MOVLW       70
	MOVWF       _filename+7 
;sdtest.c,90 :: 		Mmc_Fat_Assign(filename, 0);
	MOVLW       _filename+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	CLRF        FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
;sdtest.c,91 :: 		Mmc_Fat_Delete();
	CALL        _Mmc_Fat_Delete+0, 0
;sdtest.c,92 :: 		}
L_end_M_Delete_File:
	RETURN      0
; end of _M_Delete_File

_M_Test_File_Exist:

;sdtest.c,96 :: 		void M_Test_File_Exist() {
;sdtest.c,102 :: 		filename[7] = 'B';       //uncomment this line to search for file that DOES exists
	MOVLW       66
	MOVWF       _filename+7 
;sdtest.c,104 :: 		if (Mmc_Fat_Assign(filename, 0)) {
	MOVLW       _filename+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	CLRF        FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_M_Test_File_Exist15
;sdtest.c,106 :: 		Mmc_Fat_Get_File_Date(&year, &month, &day, &hour, &minute);
	MOVLW       M_Test_File_Exist_year_L0+0
	MOVWF       FARG_Mmc_Fat_Get_File_Date_year+0 
	MOVLW       hi_addr(M_Test_File_Exist_year_L0+0)
	MOVWF       FARG_Mmc_Fat_Get_File_Date_year+1 
	MOVLW       M_Test_File_Exist_month_L0+0
	MOVWF       FARG_Mmc_Fat_Get_File_Date_month+0 
	MOVLW       hi_addr(M_Test_File_Exist_month_L0+0)
	MOVWF       FARG_Mmc_Fat_Get_File_Date_month+1 
	MOVLW       M_Test_File_Exist_day_L0+0
	MOVWF       FARG_Mmc_Fat_Get_File_Date_day+0 
	MOVLW       hi_addr(M_Test_File_Exist_day_L0+0)
	MOVWF       FARG_Mmc_Fat_Get_File_Date_day+1 
	MOVLW       M_Test_File_Exist_hour_L0+0
	MOVWF       FARG_Mmc_Fat_Get_File_Date_hours+0 
	MOVLW       hi_addr(M_Test_File_Exist_hour_L0+0)
	MOVWF       FARG_Mmc_Fat_Get_File_Date_hours+1 
	MOVLW       M_Test_File_Exist_minute_L0+0
	MOVWF       FARG_Mmc_Fat_Get_File_Date_mins+0 
	MOVLW       hi_addr(M_Test_File_Exist_minute_L0+0)
	MOVWF       FARG_Mmc_Fat_Get_File_Date_mins+1 
	CALL        _Mmc_Fat_Get_File_Date+0, 0
;sdtest.c,107 :: 		UART1_Write_Text(" created: ");
	MOVLW       ?lstr2_sdtest+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_sdtest+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,108 :: 		WordToStr(year, outstr);
	MOVF        M_Test_File_Exist_year_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        M_Test_File_Exist_year_L0+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;sdtest.c,109 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,110 :: 		ByteToStr(month, outstr);
	MOVF        M_Test_File_Exist_month_L0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;sdtest.c,111 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,112 :: 		WordToStr(day, outstr);
	MOVF        M_Test_File_Exist_day_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;sdtest.c,113 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,114 :: 		WordToStr(hour, outstr);
	MOVF        M_Test_File_Exist_hour_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;sdtest.c,115 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,116 :: 		WordToStr(minute, outstr);
	MOVF        M_Test_File_Exist_minute_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;sdtest.c,117 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,120 :: 		Mmc_Fat_Get_File_Date_Modified(&year, &month, &day, &hour, &minute);
	MOVLW       M_Test_File_Exist_year_L0+0
	MOVWF       FARG_Mmc_Fat_Get_File_Date_Modified_year+0 
	MOVLW       hi_addr(M_Test_File_Exist_year_L0+0)
	MOVWF       FARG_Mmc_Fat_Get_File_Date_Modified_year+1 
	MOVLW       M_Test_File_Exist_month_L0+0
	MOVWF       FARG_Mmc_Fat_Get_File_Date_Modified_month+0 
	MOVLW       hi_addr(M_Test_File_Exist_month_L0+0)
	MOVWF       FARG_Mmc_Fat_Get_File_Date_Modified_month+1 
	MOVLW       M_Test_File_Exist_day_L0+0
	MOVWF       FARG_Mmc_Fat_Get_File_Date_Modified_day+0 
	MOVLW       hi_addr(M_Test_File_Exist_day_L0+0)
	MOVWF       FARG_Mmc_Fat_Get_File_Date_Modified_day+1 
	MOVLW       M_Test_File_Exist_hour_L0+0
	MOVWF       FARG_Mmc_Fat_Get_File_Date_Modified_hours+0 
	MOVLW       hi_addr(M_Test_File_Exist_hour_L0+0)
	MOVWF       FARG_Mmc_Fat_Get_File_Date_Modified_hours+1 
	MOVLW       M_Test_File_Exist_minute_L0+0
	MOVWF       FARG_Mmc_Fat_Get_File_Date_Modified_mins+0 
	MOVLW       hi_addr(M_Test_File_Exist_minute_L0+0)
	MOVWF       FARG_Mmc_Fat_Get_File_Date_Modified_mins+1 
	CALL        _Mmc_Fat_Get_File_Date_Modified+0, 0
;sdtest.c,121 :: 		UART1_Write_Text(" modified: ");
	MOVLW       ?lstr3_sdtest+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_sdtest+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,122 :: 		WordToStr(year, outstr);
	MOVF        M_Test_File_Exist_year_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        M_Test_File_Exist_year_L0+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;sdtest.c,123 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,124 :: 		ByteToStr(month, outstr);
	MOVF        M_Test_File_Exist_month_L0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;sdtest.c,125 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,126 :: 		WordToStr(day, outstr);
	MOVF        M_Test_File_Exist_day_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;sdtest.c,127 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,128 :: 		WordToStr(hour, outstr);
	MOVF        M_Test_File_Exist_hour_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;sdtest.c,129 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,130 :: 		WordToStr(minute, outstr);
	MOVF        M_Test_File_Exist_minute_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;sdtest.c,131 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;sdtest.c,134 :: 		fsize = Mmc_Fat_Get_File_Size();
	CALL        _Mmc_Fat_Get_File_Size+0, 0
;sdtest.c,135 :: 		LongToStr((signed long)fsize, outstr);
	MOVF        R0, 0 
	MOVWF       FARG_LongToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_LongToStr_input+1 
	MOVF        R2, 0 
	MOVWF       FARG_LongToStr_input+2 
	MOVF        R3, 0 
	MOVWF       FARG_LongToStr_input+3 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_LongToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_LongToStr_output+1 
	CALL        _LongToStr+0, 0
;sdtest.c,136 :: 		UART1_Write_Line(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;sdtest.c,137 :: 		}
	GOTO        L_M_Test_File_Exist16
L_M_Test_File_Exist15:
;sdtest.c,140 :: 		UART1_Write(0x55);
	MOVLW       85
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;sdtest.c,141 :: 		Delay_ms(1000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_M_Test_File_Exist17:
	DECFSZ      R13, 1, 1
	BRA         L_M_Test_File_Exist17
	DECFSZ      R12, 1, 1
	BRA         L_M_Test_File_Exist17
	DECFSZ      R11, 1, 1
	BRA         L_M_Test_File_Exist17
	NOP
;sdtest.c,142 :: 		UART1_Write(0x55);
	MOVLW       85
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;sdtest.c,143 :: 		}
L_M_Test_File_Exist16:
;sdtest.c,144 :: 		}
L_end_M_Test_File_Exist:
	RETURN      0
; end of _M_Test_File_Exist

_M_Create_Swap_File:

;sdtest.c,149 :: 		void M_Create_Swap_File() {
;sdtest.c,152 :: 		for(i=0; i<512; i++)
	CLRF        M_Create_Swap_File_i_L0+0 
	CLRF        M_Create_Swap_File_i_L0+1 
L_M_Create_Swap_File18:
	MOVLW       2
	SUBWF       M_Create_Swap_File_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Create_Swap_File38
	MOVLW       0
	SUBWF       M_Create_Swap_File_i_L0+0, 0 
L__M_Create_Swap_File38:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Create_Swap_File19
;sdtest.c,153 :: 		Buffer[i] = i;
	MOVLW       _Buffer+0
	ADDWF       M_Create_Swap_File_i_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_Buffer+0)
	ADDWFC      M_Create_Swap_File_i_L0+1, 0 
	MOVWF       FSR1H 
	MOVF        M_Create_Swap_File_i_L0+0, 0 
	MOVWF       POSTINC1+0 
;sdtest.c,152 :: 		for(i=0; i<512; i++)
	INFSNZ      M_Create_Swap_File_i_L0+0, 1 
	INCF        M_Create_Swap_File_i_L0+1, 1 
;sdtest.c,153 :: 		Buffer[i] = i;
	GOTO        L_M_Create_Swap_File18
L_M_Create_Swap_File19:
;sdtest.c,155 :: 		size = Mmc_Fat_Get_Swap_File(5000, "mikroE.txt", 0x20);   // see help on this function for details
	MOVLW       136
	MOVWF       FARG_Mmc_Fat_Get_Swap_File_nSect+0 
	MOVLW       19
	MOVWF       FARG_Mmc_Fat_Get_Swap_File_nSect+1 
	MOVLW       0
	MOVWF       FARG_Mmc_Fat_Get_Swap_File_nSect+2 
	MOVWF       FARG_Mmc_Fat_Get_Swap_File_nSect+3 
	MOVLW       ?lstr4_sdtest+0
	MOVWF       FARG_Mmc_Fat_Get_Swap_File_name+0 
	MOVLW       hi_addr(?lstr4_sdtest+0)
	MOVWF       FARG_Mmc_Fat_Get_Swap_File_name+1 
	MOVLW       32
	MOVWF       FARG_Mmc_Fat_Get_Swap_File_file_attr+0 
	CALL        _Mmc_Fat_Get_Swap_File+0, 0
	MOVF        R0, 0 
	MOVWF       _size+0 
	MOVF        R1, 0 
	MOVWF       _size+1 
	MOVF        R2, 0 
	MOVWF       _size+2 
	MOVF        R3, 0 
	MOVWF       _size+3 
;sdtest.c,157 :: 		if (size) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	IORWF       R2, 0 
	IORWF       R3, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_M_Create_Swap_File21
;sdtest.c,158 :: 		LongToStr((signed long)size, err_txt);
	MOVF        _size+0, 0 
	MOVWF       FARG_LongToStr_input+0 
	MOVF        _size+1, 0 
	MOVWF       FARG_LongToStr_input+1 
	MOVF        _size+2, 0 
	MOVWF       FARG_LongToStr_input+2 
	MOVF        _size+3, 0 
	MOVWF       FARG_LongToStr_input+3 
	MOVLW       _err_txt+0
	MOVWF       FARG_LongToStr_output+0 
	MOVLW       hi_addr(_err_txt+0)
	MOVWF       FARG_LongToStr_output+1 
	CALL        _LongToStr+0, 0
;sdtest.c,159 :: 		UART1_Write_Line(err_txt);
	MOVLW       _err_txt+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(_err_txt+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;sdtest.c,161 :: 		for(i=0; i<5000; i++) {
	CLRF        M_Create_Swap_File_i_L0+0 
	CLRF        M_Create_Swap_File_i_L0+1 
L_M_Create_Swap_File22:
	MOVLW       19
	SUBWF       M_Create_Swap_File_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Create_Swap_File39
	MOVLW       136
	SUBWF       M_Create_Swap_File_i_L0+0, 0 
L__M_Create_Swap_File39:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Create_Swap_File23
;sdtest.c,162 :: 		Mmc_Write_Sector(size++, Buffer);
	MOVF        _size+0, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+0 
	MOVF        _size+1, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+1 
	MOVF        _size+2, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+2 
	MOVF        _size+3, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+3 
	MOVLW       _Buffer+0
	MOVWF       FARG_Mmc_Write_Sector_dbuff+0 
	MOVLW       hi_addr(_Buffer+0)
	MOVWF       FARG_Mmc_Write_Sector_dbuff+1 
	CALL        _Mmc_Write_Sector+0, 0
	MOVLW       1
	ADDWF       _size+0, 1 
	MOVLW       0
	ADDWFC      _size+1, 1 
	ADDWFC      _size+2, 1 
	ADDWFC      _size+3, 1 
;sdtest.c,163 :: 		UART1_Write('.');
	MOVLW       46
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;sdtest.c,161 :: 		for(i=0; i<5000; i++) {
	INFSNZ      M_Create_Swap_File_i_L0+0, 1 
	INCF        M_Create_Swap_File_i_L0+1, 1 
;sdtest.c,164 :: 		}
	GOTO        L_M_Create_Swap_File22
L_M_Create_Swap_File23:
;sdtest.c,165 :: 		}
L_M_Create_Swap_File21:
;sdtest.c,166 :: 		}
L_end_M_Create_Swap_File:
	RETURN      0
; end of _M_Create_Swap_File

_main:

;sdtest.c,169 :: 		void main() {
;sdtest.c,171 :: 		ADCON1 |= 0x0F;                  // Configure AN pins as digital
	MOVLW       15
	IORWF       ADCON1+0, 1 
;sdtest.c,175 :: 		UART1_Init(9600);
	MOVLW       103
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;sdtest.c,176 :: 		Delay_ms(10);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main25:
	DECFSZ      R13, 1, 1
	BRA         L_main25
	DECFSZ      R12, 1, 1
	BRA         L_main25
	NOP
	NOP
;sdtest.c,178 :: 		UART1_Write_Line("PIC-Started"); // PIC present report
	MOVLW       ?lstr5_sdtest+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(?lstr5_sdtest+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;sdtest.c,181 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;sdtest.c,184 :: 		if (Mmc_Fat_Init() == 0) {
	CALL        _Mmc_Fat_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main26
;sdtest.c,186 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;sdtest.c,188 :: 		UART1_Write_Line("Test Start.");
	MOVLW       ?lstr6_sdtest+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(?lstr6_sdtest+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;sdtest.c,190 :: 		M_Create_New_File();
	CALL        _M_Create_New_File+0, 0
;sdtest.c,192 :: 		M_Create_Multiple_Files();
	CALL        _M_Create_Multiple_Files+0, 0
;sdtest.c,193 :: 		M_Open_File_Rewrite();
	CALL        _M_Open_File_Rewrite+0, 0
;sdtest.c,194 :: 		M_Open_File_Append();
	CALL        _M_Open_File_Append+0, 0
;sdtest.c,195 :: 		M_Open_File_Read();
	CALL        _M_Open_File_Read+0, 0
;sdtest.c,196 :: 		M_Delete_File();
	CALL        _M_Delete_File+0, 0
;sdtest.c,197 :: 		M_Test_File_Exist();
	CALL        _M_Test_File_Exist+0, 0
;sdtest.c,198 :: 		M_Create_Swap_File();
	CALL        _M_Create_Swap_File+0, 0
;sdtest.c,200 :: 		UART1_Write_Line("Test End.");
	MOVLW       ?lstr7_sdtest+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(?lstr7_sdtest+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;sdtest.c,202 :: 		}
	GOTO        L_main27
L_main26:
;sdtest.c,204 :: 		UART1_Write_Line(err_txt); // Note: Mmc_Fat_Init tries to initialize a card more than once.
	MOVLW       _err_txt+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(_err_txt+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;sdtest.c,206 :: 		}
L_main27:
;sdtest.c,208 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
