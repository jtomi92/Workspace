#line 1 "C:/Users/Nils/Desktop/PIC/home_control/test/test.c"
void main() {

TRISA = 0;
TRISB = 0;
TRISC = 0;
TRISD = 0;

while (1){
PORTA = 1;
PORTB = 1;
PORTC = 1;
PORTD = 1;

delay_ms(300);


PORTA = 0;
PORTB = 0;
PORTC = 0;
PORTD = 0;

delay_ms(300);

}

}
