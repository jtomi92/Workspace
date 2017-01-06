
_main:

;test.c,1 :: 		void main() {
;test.c,3 :: 		TRISA = 0;
	CLRF        TRISA+0 
;test.c,4 :: 		TRISB = 0;
	CLRF        TRISB+0 
;test.c,5 :: 		TRISC = 0;
	CLRF        TRISC+0 
;test.c,6 :: 		TRISD = 0;
	CLRF        TRISD+0 
;test.c,8 :: 		while (1){
L_main0:
;test.c,9 :: 		PORTA = 1;
	MOVLW       1
	MOVWF       PORTA+0 
;test.c,10 :: 		PORTB = 1;
	MOVLW       1
	MOVWF       PORTB+0 
;test.c,11 :: 		PORTC = 1;
	MOVLW       1
	MOVWF       PORTC+0 
;test.c,12 :: 		PORTD = 1;
	MOVLW       1
	MOVWF       PORTD+0 
;test.c,14 :: 		delay_ms(300);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_main2:
	DECFSZ      R13, 1, 1
	BRA         L_main2
	DECFSZ      R12, 1, 1
	BRA         L_main2
	DECFSZ      R11, 1, 1
	BRA         L_main2
	NOP
;test.c,17 :: 		PORTA = 0;
	CLRF        PORTA+0 
;test.c,18 :: 		PORTB = 0;
	CLRF        PORTB+0 
;test.c,19 :: 		PORTC = 0;
	CLRF        PORTC+0 
;test.c,20 :: 		PORTD = 0;
	CLRF        PORTD+0 
;test.c,22 :: 		delay_ms(300);
	MOVLW       7
	MOVWF       R11, 0
	MOVLW       23
	MOVWF       R12, 0
	MOVLW       106
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
	NOP
;test.c,24 :: 		}
	GOTO        L_main0
;test.c,26 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
