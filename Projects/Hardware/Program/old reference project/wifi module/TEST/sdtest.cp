#line 1 "C:/Users/Nils/Desktop/PIC/wifi module/TEST/sdtest.c"

sbit Mmc_Chip_Select at LATC2_bit;
sbit Mmc_Chip_Select_Direction at TRISC2_bit;


const LINE_LEN = 43;
char err_txt[20] = "FAT16 not found";
char file_contents[LINE_LEN] = "XX MMC/SD FAT16 library by Anton Rieckertn";
char filename[14] = "MIKRO00x.TXT";
unsigned short loop, loop2;
unsigned long i, size;
char Buffer[512];


void UART1_Write_Line(char *uart_text) {
 UART1_Write_Text(uart_text);
 UART1_Write(13);
 UART1_Write(10);
}


void M_Create_New_File() {
 filename[7] = 'A';
 Mmc_Fat_Set_File_Date(2010, 4, 19, 9, 0, 0);
 Mmc_Fat_Assign(&filename, 0xA0);
 Mmc_Fat_Rewrite();
 for(loop = 1; loop <= 99; loop++) {
 UART1_Write('.');
 file_contents[0] = loop / 10 + 48;
 file_contents[1] = loop % 10 + 48;
 Mmc_Fat_Write(file_contents, LINE_LEN-1);
 }
}


void M_Create_Multiple_Files() {
 for(loop2 = 'B'; loop2 <= 'Z'; loop2++) {
 UART1_Write(loop2);
 filename[7] = loop2;
 Mmc_Fat_Set_File_Date(2010, 4, 19, 9, 0, 0);
 Mmc_Fat_Assign(&filename, 0xA0);
 Mmc_Fat_Rewrite();
 for(loop = 1; loop <= 44; loop++) {
 file_contents[0] = loop / 10 + 48;
 file_contents[1] = loop % 10 + 48;
 Mmc_Fat_Write(file_contents, LINE_LEN-1);
 }
 }
}


void M_Open_File_Rewrite() {
 filename[7] = 'C';
 Mmc_Fat_Assign(&filename, 0);
 Mmc_Fat_Rewrite();
 for(loop = 1; loop <= 55; loop++) {
 file_contents[0] = loop / 10 + 48;
 file_contents[1] = loop % 10 + 48;
 Mmc_Fat_Write(file_contents, LINE_LEN-1);
 }
}



void M_Open_File_Append() {
 filename[7] = 'B';
 Mmc_Fat_Assign(&filename, 0);
 Mmc_Fat_Set_File_Date(2010, 4, 19, 9, 20, 0);
 Mmc_Fat_Append();
 Mmc_Fat_Write(" for mikroElektronika 2010n", 27);
}


void M_Open_File_Read() {
 char character;

 filename[7] = 'B';
 Mmc_Fat_Assign(&filename, 0);
 Mmc_Fat_Reset(&size);
 for (i = 1; i <= size; i++) {
 Mmc_Fat_Read(&character);
 UART1_Write(character);
 }
}



void M_Delete_File() {
 filename[7] = 'F';
 Mmc_Fat_Assign(filename, 0);
 Mmc_Fat_Delete();
}



void M_Test_File_Exist() {
 unsigned long fsize;
 unsigned int year;
 unsigned short month, day, hour, minute;
 unsigned char outstr[12];

 filename[7] = 'B';

 if (Mmc_Fat_Assign(filename, 0)) {

 Mmc_Fat_Get_File_Date(&year, &month, &day, &hour, &minute);
 UART1_Write_Text(" created: ");
 WordToStr(year, outstr);
 UART1_Write_Text(outstr);
 ByteToStr(month, outstr);
 UART1_Write_Text(outstr);
 WordToStr(day, outstr);
 UART1_Write_Text(outstr);
 WordToStr(hour, outstr);
 UART1_Write_Text(outstr);
 WordToStr(minute, outstr);
 UART1_Write_Text(outstr);


 Mmc_Fat_Get_File_Date_Modified(&year, &month, &day, &hour, &minute);
 UART1_Write_Text(" modified: ");
 WordToStr(year, outstr);
 UART1_Write_Text(outstr);
 ByteToStr(month, outstr);
 UART1_Write_Text(outstr);
 WordToStr(day, outstr);
 UART1_Write_Text(outstr);
 WordToStr(hour, outstr);
 UART1_Write_Text(outstr);
 WordToStr(minute, outstr);
 UART1_Write_Text(outstr);


 fsize = Mmc_Fat_Get_File_Size();
 LongToStr((signed long)fsize, outstr);
 UART1_Write_Line(outstr);
 }
 else {

 UART1_Write(0x55);
 Delay_ms(1000);
 UART1_Write(0x55);
 }
}




void M_Create_Swap_File() {
 unsigned int i;

 for(i=0; i<512; i++)
 Buffer[i] = i;

 size = Mmc_Fat_Get_Swap_File(5000, "mikroE.txt", 0x20);

 if (size) {
 LongToStr((signed long)size, err_txt);
 UART1_Write_Line(err_txt);

 for(i=0; i<5000; i++) {
 Mmc_Write_Sector(size++, Buffer);
 UART1_Write('.');
 }
 }
}


void main() {

 ADCON1 |= 0x0F;



 UART1_Init(9600);
 Delay_ms(10);

 UART1_Write_Line("PIC-Started");


 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);


 if (Mmc_Fat_Init() == 0) {

 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);

 UART1_Write_Line("Test Start.");

 M_Create_New_File();

 M_Create_Multiple_Files();
 M_Open_File_Rewrite();
 M_Open_File_Append();
 M_Open_File_Read();
 M_Delete_File();
 M_Test_File_Exist();
 M_Create_Swap_File();

 UART1_Write_Line("Test End.");

 }
 else {
 UART1_Write_Line(err_txt);

 }

}
