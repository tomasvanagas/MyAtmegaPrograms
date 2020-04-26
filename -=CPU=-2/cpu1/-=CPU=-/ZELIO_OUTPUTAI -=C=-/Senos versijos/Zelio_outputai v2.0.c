//*****************************************************************//
//   Zelio reles outputams sutaupyti skirta PIC16F84A programa     //
//                                                                 //
//      LETOJO REZIMO PERIODAS   =====>> 30 sekundziu (viso 2 min) //
//      GREITOJO REZIMO PERIODAS =====>> 7  sekundes  (viso 21 sec)//
//                                                                 //
//      Ciklas_29sec susideda is ===> 1. 27 sekundziu uzlaikymo    //
//                               ===> 2. 1 sekundes memorizacijos  //
//                               ===> 3. 1 sekundes uzlaikymo      //
//                                                                 //
//      Ciklas_6sec susideda is  ===> 1. 4 sekundziu uzlaikymo     //
//                               ===> 2. 1 sekundes memorizacijos  //
//                               ===> 3. 1 sekundes uzlaikymo      //
//*****************************************************************//

char GREITASIS__REZIMAS, GREITUJU_CIKLU;

void inputas();
void greituju_temp_prabegimas();
void greitasis_rezimas();
void letasis_rezimas();
void CIKLAS_29sec();
void CIKLAS_6sec();
void uzlaikymas_1sec();
void memorizacija();

void main() {
TRISA = 0b10;
TRISB = 0;
GREITUJU_CIKLU = 6;
PORTA = 0;
PORTB = 0;

while(1) { //AMZINAS CIKLAS         // PROGRAMA

inputas();
greituju_temp_prabegimas();

{if(GREITASIS__REZIMAS==0) {
letasis_rezimas();}
else
greitasis_rezimas();}

GREITASIS__REZIMAS = 0;}}           // PROGRAMA





void inputas() {
if(PORTA.F1==1){
GREITASIS__REZIMAS = 1;}}


void greituju_temp_prabegimas() {
if(GREITUJU_CIKLU>0) {
GREITASIS__REZIMAS = 1;
GREITUJU_CIKLU = GREITUJU_CIKLU - 1;}}


void greitasis_rezimas() {
PORTB.F5 = 1;             //RELE 1;
CIKLAS_6sec();
PORTB.F5 = 0;             //RELE 1;
uzlaikymas_1sec();

PORTB.F6 = 1;             //RELE 2;
CIKLAS_6sec();
PORTB.F6 = 0;             //RELE 2;
uzlaikymas_1sec();

PORTB.F7 = 1;             //RELE 3;
CIKLAS_6sec();
PORTB.F7 = 0;             //RELE 3;
uzlaikymas_1sec();

PORTA.F0 = 1;             //RELE 4;
CIKLAS_6sec();
PORTA.F0 = 0;             //RELE 4;
uzlaikymas_1sec();}


void letasis_rezimas(){
PORTB.F5 = 1;             //RELE 1;
CIKLAS_29sec();
PORTB.F5 = 0;             //RELE 1;
uzlaikymas_1sec();

PORTB.F6 = 1;             //RELE 2;
CIKLAS_29sec();
PORTB.F6 = 0;             //RELE 2;
uzlaikymas_1sec();

PORTB.F7 = 1;             //RELE 3;
CIKLAS_29sec();
PORTB.F7 = 0;             //RELE 3;
uzlaikymas_1sec();

PORTA.F0 = 1;             //RELE 4;
CIKLAS_29sec();
PORTA.F0 = 0;             //RELE 4;
uzlaikymas_1sec();}


void CIKLAS_29sec() {
Delay_ms(27000);
memorizacija();
uzlaikymas_1sec();}


void CIKLAS_6sec() {
uzlaikymas_1sec();
uzlaikymas_1sec();
uzlaikymas_1sec();
uzlaikymas_1sec();

memorizacija();

uzlaikymas_1sec();}


void uzlaikymas_1sec() {
Delay_ms(1000);}


void memorizacija() {
PORTB.F4 = 1;
uzlaikymas_1sec();
PORTB.F4 = 0;}