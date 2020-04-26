//*****************************************************************//
//                                                                 //
//          Saules kolektoriaus temperaturu komutatorius           //
//                                                                 //
//*****************************************************************//
//                                                                 //
//   OUTPUTAS.F0 - (  A  )       ________    _    __               //
//   OUTPUTAS.F1 - (  B  )       \__   __\  \ \  / /               //
//   OUTPUTAS.F2 - (  C  )          \ \      \ \/ /                //
//   OUTPUTAS.F3 - (  D1 )           \_\  .   \__/  .              //
//   OUTPUTAS.F4 - (  D2 )                                         //
//                                                                 //
//*****************************************************************//

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

while(1){                               // AMZINAS CIKLAS

OUTPUTAS = 0b10001;                      // NR.1
OUTPUTAI();
resetas_1sec();
INPUTAS();

OUTPUTAS = 0b10011;                      // NR.2
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b10010;                      // NR.3
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b10100;                      // NR.4
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b10111;                      // NR.5
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b10101;                      // NR.6
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b10110;                      // NR.7
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b1100;                      // NR.8
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b1010;                      // NR.9
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b1101;                      // NR.10
OUTPUTAI();
uzlaikymas_1sec();
INPUTAS();

OUTPUTAS = 0b1011;                      // NR.11
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