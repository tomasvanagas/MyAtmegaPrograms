#line 1 "D:/PROGRAMAVIMAS/C PROGRAMOS/SAULES_KOLEKTORIAUS_TEMP_VALDYMAS -=C=-/TEMP_VALDYMAS.c"
char OUTPUTAS;

void INPUTAS();
void OUTPUTAI();
void uzlaikymas_1sec();
void resetas_1sec();

void main() {{
TRISA = 0b10;
TRISB = 0;}

OUTPUTAS = 0b11000;
PORTA = 0;
PORTB = 0;

while(1){

OUTPUTAS = 0b10001;
OUTPUTAI();
resetas_1sec();
INPUTAS();

OUTPUTAS = 0b10011;
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b10010;
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b10100;
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b10111;
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b10101;
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b10110;
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b1100;
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b1010;
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b1101;
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b1011;
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

}}


void INPUTAS(){
while(PORTA.F1==1){}
while(PORTA.F1==0){}}

void OUTPUTAI(){
PORTB.F1 = OUTPUTAS.F0;
PORTB.F4 = OUTPUTAS.F1;
PORTB.F2 = OUTPUTAS.F2;
PORTB.F5 = OUTPUTAS.F3;
PORTB.F6 = OUTPUTAS.F4;}

void uzlaikymas_1sec(){
Delay_ms(1000);}

void resetas_1sec(){
PORTB.F7 = 1;
uzlaikymas_1sec();
PORTB.F7 = 0;}
