/*****************************************************
Project : 
Version : 
Date    : 7/14/2010
Author  : NeVaDa
Company : namai
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 4.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>

void oscilatorius();

void inputai();
void outputai();

void sekundes_ir_jos_daliu_trukme_ciklais();
void sekundes_trukmes_keitimas();

void dabartinis_laikas();
void dabartinio_laiko_skaiciavimas();

void pasisveikinimas();

void padeciu_medis();

void blyksintis_skaicius();

void fontai();

void kondensatoriaus_busena();

void mosfet_valdymas();



char pasisveikinimas_baigtas;

signed char x,y,z;

unsigned int VIENA_SEKUNDE, PUSE_SEKUNDES, KETVIRTADALIS_SEKUNDES;

char OSC;

char a, segm_a, segm_b, segm_c, segm_d, segm_e, segm_f, 
segm_g, segm_h;

char MYGTUKAS_1, MYGTUKAS_2, MYGTUKAS_3, MYGTUKAS_4,
MYGTUKAS_5, MYGTUKAS_6, MYGTUKAS_7, mygtuko_OSR; 

char kondensatorius_tuscias, kondensatorius_vidutinis, 
kondensatorius_pilnas, kondensatoriaus_rodymo_padetis;
unsigned int kondensatoriaus_rodymo_laikas;

unsigned int pasisveikinimo_laikas1;
char pasisveikinimo_laikas2;

char REDAGAVIMAS;

char SKAICIUS_DEGA;
unsigned int blyksincio_skaiciaus_laiko_paskutinis_ciklas,
blyksincio_skaiciaus_laikas, 
blyksincio_skaiciaus_laiko_vidurinysis_ciklas;

unsigned int viena_laikrodzio_sekunde;
signed char laikrodzio_sekundes,
laikrodzio_minutes, laikrodzio_valandos;

char begancio_uzraso_DABAR_padetis;
unsigned int begancio_uzraso_DABAR_laikas;

char pfet_kairysis, pfet_desinysis,
nfet_kairysis, nfet_desinysis;



void main(void){
 // 0 in ; 1 out ; 
PORTA = 0;
DDRA = 0b00011110;

PORTB = 0;
DDRB = 0b00011110;

PORTC = 0;
DDRC = 0b11111111;

PORTD = 0;
DDRD = 0b00011000;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

VIENA_SEKUNDE = 11400;
sekundes_ir_jos_daliu_trukme_ciklais(); 



while(pasisveikinimas_baigtas==0){
oscilatorius();
pasisveikinimas();
fontai();
outputai();}

while (1){
oscilatorius();
mosfet_valdymas();
inputai();
sekundes_ir_jos_daliu_trukme_ciklais();
padeciu_medis();
dabartinio_laiko_skaiciavimas();
blyksintis_skaicius();
fontai();
outputai();}}



void inputai(){

//MYGTUKAI
MYGTUKAS_1 = 0;
MYGTUKAS_2 = 0;
MYGTUKAS_3 = 0;
MYGTUKAS_4 = 0;
MYGTUKAS_5 = 0;
MYGTUKAS_6 = 0;
MYGTUKAS_7 = 0;

if((PIND.6==1)&&(PIND.5==1)&&(PIND.7==0)&&
(mygtuko_OSR==0)){                                
mygtuko_OSR = 1;
MYGTUKAS_1 = 1;}

if((PIND.6==1)&&(PIND.5==0)&&(PIND.7==1)&&
(mygtuko_OSR==0)){                                 
mygtuko_OSR = 1;
MYGTUKAS_2 = 1;}

if((PIND.6==1)&&(PIND.5==0)&&(PIND.7==0)&&
(mygtuko_OSR==0)){                                 
mygtuko_OSR = 1;
MYGTUKAS_3 = 1;}

if((PIND.6==0)&&(PIND.5==0)&&(PIND.7==1)&&
(mygtuko_OSR==0)){                                
mygtuko_OSR = 1;
MYGTUKAS_4 = 1;}

if((PIND.6==0)&&(PIND.5==0)&&(PIND.7==0)&&
(mygtuko_OSR==0)){                                 
mygtuko_OSR = 1;
MYGTUKAS_5 = 1;}

if((PIND.6==0)&&(PIND.5==1)&&(PIND.7==0)&&
(mygtuko_OSR==0)){                                
mygtuko_OSR = 1;
MYGTUKAS_6 = 1;}

if((PIND.6==0)&&(PIND.5==1)&&(PIND.7==1)&&
(mygtuko_OSR==0)){                                 
mygtuko_OSR = 1;
MYGTUKAS_7 = 1;}


if((PIND.6==1)&&(PIND.5==1)&&(PIND.7==1)){        
mygtuko_OSR = 0;}


//ITAMPOS
kondensatorius_tuscias = 0;
kondensatorius_vidutinis = 0;
kondensatorius_pilnas = 0;

if((PIND.3==0)&&(PIND.4==0)){
kondensatorius_tuscias = 1;}
if((PIND.3==1)&&(PIND.4==0)){
kondensatorius_vidutinis = 1;}
if((PIND.3==1)&&(PIND.4==1)){
kondensatorius_pilnas = 1;}}



void oscilatorius(){
OSC = OSC + 1;
    if(OSC>=31){
    OSC = 0;
    }
}


// +
void sekundes_ir_jos_daliu_trukme_ciklais(){
PUSE_SEKUNDES = VIENA_SEKUNDE / 2;
KETVIRTADALIS_SEKUNDES = VIENA_SEKUNDE / 4;}


// +
void pasisveikinimas(){
pasisveikinimo_laikas1 = pasisveikinimo_laikas1 + 1;
if(pasisveikinimo_laikas1>=VIENA_SEKUNDE){
pasisveikinimo_laikas2 = pasisveikinimo_laikas2 + 1;
pasisveikinimo_laikas1 = 0;}

if(pasisveikinimo_laikas2==1){
if(OSC==28){
a = 17;}}
if(pasisveikinimo_laikas2==2){
if(OSC==24){
a = 17;}
if(OSC==28){
a = 15;}}
if(pasisveikinimo_laikas2==3){
if(OSC==20){
a = 17;}
if(OSC==24){
a = 15;}
if(OSC==28){
a = 22;}}
if(pasisveikinimo_laikas2==4){
if(OSC==16){
a = 17;}
if(OSC==20){
a = 15;}
if(OSC==24){
a = 22;}
if(OSC==28){
a = 22;}}
if(pasisveikinimo_laikas2==5){
if(OSC==12){
a = 17;}
if(OSC==16){
a = 15;}
if(OSC==20){
a = 22;}
if(OSC==24){
a = 22;}
if(OSC==28){
a = 0;}}
if(pasisveikinimo_laikas2==6){
if(OSC==8){
a = 17;}
if(OSC==12){
a = 15;}
if(OSC==16){
a = 22;}
if(OSC==20){
a = 22;}
if(OSC==24){
a = 0;}}
if(pasisveikinimo_laikas2==7){
if(OSC==4){
a = 17;}
if(OSC==8){
a = 15;}
if(OSC==12){
a = 22;}
if(OSC==16){
a = 22;}
if(OSC==20){
a = 0;}}
if(pasisveikinimo_laikas2==8){
if(OSC==0){
a = 17;}
if(OSC==4){
a = 15;}
if(OSC==8){
a = 22;}
if(OSC==12){
a = 22;}
if(OSC==16){
a = 0;}}
if(pasisveikinimo_laikas2==10){
if(OSC==0){
a = 17;}
if(OSC==4){
a = 15;}
if(OSC==8){
a = 22;}
if(OSC==12){
a = 22;}
if(OSC==16){
a = 0;}}
if(pasisveikinimo_laikas2==12){
if(OSC==0){
a = 17;}
if(OSC==4){
a = 15;}
if(OSC==8){
a = 22;}
if(OSC==12){
a = 22;}
if(OSC==16){
a = 0;}}
if(pasisveikinimo_laikas2==14){
if(OSC==0){
a = 17;}
if(OSC==4){
a = 15;}
if(OSC==8){
a = 22;}
if(OSC==12){
a = 22;}
if(OSC==16){
a = 0;}}
if(pasisveikinimo_laikas2==15){
if(OSC==0){
a = 15;}
if(OSC==4){
a = 22;}
if(OSC==8){
a = 22;}
if(OSC==12){
a = 0;}}
if(pasisveikinimo_laikas2==16){
if(OSC==0){
a = 22;}
if(OSC==4){
a = 22;}
if(OSC==8){
a = 0;}}
if(pasisveikinimo_laikas2==17){
if(OSC==0){
a = 22;}
if(OSC==4){
a = 0;}}
if(pasisveikinimo_laikas2==18){
if(OSC==0){
a = 0;}}
if(pasisveikinimo_laikas2==20){
pasisveikinimas_baigtas = 1;
pasisveikinimo_laikas1 = 0;
pasisveikinimo_laikas2 = 0;}}


// +
void fontai(){
//SKAICIAI IR RAIDES:
// a==10 (A)
// a==11 (b)
// a==12 (c)
// a==13 (C)
// a==14 (d)
// a==15 (E)
// a==16 (F)
// a==17 (H)
// a==18 (h)
// a==19 (I)
// a==20 (i)
// a==21 (J)
// a==22 (L)
// a==23 (o)
// a==24 (P)
// a==25 (S)
// a==26 (t)
// a==27 (u)
// a==28 (U)
// a==29 (Z)
// a==30 (r)
// a==31 (_)
// a==32 (-)
// a==33 ( )
// a==34 (n)


if(a == 0){
segm_a = 1;
segm_b = 1;
segm_c = 1;
segm_d = 1;
segm_e = 1;
segm_f = 1;
segm_g = 0;}
if(a == 1){
segm_a = 0;
segm_b = 1;
segm_c = 1;
segm_d = 0;
segm_e = 0;
segm_f = 0;
segm_g = 0;}
if(a == 2){
segm_a = 1;
segm_b = 1;
segm_c = 0;
segm_d = 1;
segm_e = 1;
segm_f = 0;
segm_g = 1;}
if(a == 3){
segm_a = 1;
segm_b = 1;
segm_c = 1;
segm_d = 1;
segm_e = 0;
segm_f = 0;
segm_g = 1;}
if(a == 4){
segm_a = 0;
segm_b = 1;
segm_c = 1;
segm_d = 0;
segm_e = 0;
segm_f = 1;
segm_g = 1;}
if(a == 5){
segm_a = 1;
segm_b = 0;
segm_c = 1;
segm_d = 1;
segm_e = 0;
segm_f = 1;
segm_g = 1;}
if(a == 6){
segm_a = 1;
segm_b = 0;
segm_c = 1;
segm_d = 1;
segm_e = 1;
segm_f = 1;
segm_g = 1;}
if(a == 7){
segm_a = 1;
segm_b = 1;
segm_c = 1;
segm_d = 0;
segm_e = 0;
segm_f = 0;
segm_g = 0;}
if(a == 8){
segm_a = 1;
segm_b = 1;
segm_c = 1;
segm_d = 1;
segm_e = 1;
segm_f = 1;
segm_g = 1;}
if(a == 9){
segm_a = 1;
segm_b = 1;
segm_c = 1;
segm_d = 1;
segm_e = 0;
segm_f = 1;
segm_g = 1;}
if(a ==10){
segm_a = 1;
segm_b = 1;
segm_c = 1;
segm_d = 0;
segm_e = 1;
segm_f = 1;
segm_g = 1;}
if(a ==11){
segm_a = 0;
segm_b = 0;
segm_c = 1;
segm_d = 1;
segm_e = 1;
segm_f = 1;
segm_g = 1;}
if(a ==12){
segm_a = 0;
segm_b = 0;
segm_c = 0;
segm_d = 1;
segm_e = 1;
segm_f = 0;
segm_g = 1;}
if(a ==13){
segm_a = 1;
segm_b = 0;
segm_c = 0;
segm_d = 1;
segm_e = 1;
segm_f = 1;
segm_g = 0;}
if(a ==14){
segm_a = 0;
segm_b = 1;
segm_c = 1;
segm_d = 1;
segm_e = 1;
segm_f = 0;
segm_g = 1;}
if(a ==15){
segm_a = 1;
segm_b = 0;
segm_c = 0;
segm_d = 1;
segm_e = 1;
segm_f = 1;
segm_g = 1;}
if(a ==16){
segm_a = 1;
segm_b = 0;
segm_c = 0;
segm_d = 0;
segm_e = 1;
segm_f = 1;
segm_g = 1;}
if(a ==17){
segm_a = 0;
segm_b = 1;
segm_c = 1;
segm_d = 0;
segm_e = 1;
segm_f = 1;
segm_g = 1;}
if(a ==18){
segm_a = 0;
segm_b = 0;
segm_c = 1;
segm_d = 0;
segm_e = 1;
segm_f = 1;
segm_g = 1;}
if(a ==19){
segm_a = 0;
segm_b = 1;
segm_c = 1;
segm_d = 0;
segm_e = 0;
segm_f = 0;
segm_g = 0;}
if(a ==20){
segm_a = 0;
segm_b = 0;
segm_c = 1;
segm_d = 0;
segm_e = 0;
segm_f = 0;
segm_g = 0;}
if(a ==21){
segm_a = 0;
segm_b = 1;
segm_c = 1;
segm_d = 1;
segm_e = 0;
segm_f = 0;
segm_g = 0;}
if(a ==22){
segm_a = 0;
segm_b = 0;
segm_c = 0;
segm_d = 1;
segm_e = 1;
segm_f = 1;
segm_g = 0;}
if(a ==23){
segm_a = 0;
segm_b = 0;
segm_c = 1;
segm_d = 1;
segm_e = 1;
segm_f = 0;
segm_g = 1;}
if(a ==24){
segm_a = 1;
segm_b = 1;
segm_c = 0;
segm_d = 0;
segm_e = 1;
segm_f = 1;
segm_g = 1;}
if(a ==25){
segm_a = 1;
segm_b = 0;
segm_c = 1;
segm_d = 1;
segm_e = 0;
segm_f = 1;
segm_g = 1;}
if(a ==26){
segm_a = 0;
segm_b = 0;
segm_c = 0;
segm_d = 1;
segm_e = 1;
segm_f = 1;
segm_g = 1;}
if(a ==27){
segm_a = 0;
segm_b = 0;
segm_c = 1;
segm_d = 1;
segm_e = 1;
segm_f = 0;
segm_g = 0;}
if(a ==28){
segm_a = 0;
segm_b = 1;
segm_c = 1;
segm_d = 1;
segm_e = 1;
segm_f = 1;
segm_g = 0;}
if(a ==29){
segm_a = 1;
segm_b = 1;
segm_c = 0;
segm_d = 1;
segm_e = 1;
segm_f = 0;
segm_g = 1;}
if(a ==30){
segm_a = 0;
segm_b = 0;
segm_c = 0;
segm_d = 0;
segm_e = 1;
segm_f = 0;
segm_g = 1;}
if(a ==31){
segm_a = 0;
segm_b = 0;
segm_c = 0;
segm_d = 1;
segm_e = 0;
segm_f = 0;
segm_g = 0;}
if(a ==32){
segm_a = 0;
segm_b = 0;
segm_c = 0;
segm_d = 0;
segm_e = 0;
segm_f = 0;
segm_g = 1;}
if(a ==33){
segm_a = 0;
segm_b = 0;
segm_c = 0;
segm_d = 0;
segm_e = 0;
segm_f = 0;
segm_g = 0;}
if(a ==34){
segm_a = 0;
segm_b = 0;
segm_c = 1;
segm_d = 0;
segm_e = 1;
segm_f = 0;
segm_g = 1;}}         



void padeciu_medis(){

if(MYGTUKAS_7==1){
MYGTUKAS_7 = 0;
x = 0;
y = 0;}

if(x==0){

if(y==0){
dabartinis_laikas();}
if(y==1){
sekundes_trukmes_keitimas();}}


if(x==1){

if(y==0){
kondensatoriaus_busena();}}


if(REDAGAVIMAS==0){
if(MYGTUKAS_1==1){
if((x==0)&&(y==0)){    //kordinates kurios leidzia padidinti y
y = y + 1;}}
if(MYGTUKAS_5==1){
if((x==0)&&(y==1)){    //kordinates kurios leidzia sumazinti y
y = y - 1;}}
if(MYGTUKAS_4==1){
if((x==0)&&(y==0)){    //kordinates kurios leidzia padidinti x
x = x + 1;}}
if(MYGTUKAS_2==1){
if((x==1)&&(y==0)){    //kordinates kurios leidzia sumazinti x
x = x - 1;}}
MYGTUKAS_1 = 0;
MYGTUKAS_2 = 0;
MYGTUKAS_4 = 0;
MYGTUKAS_5 = 0;}



}                      //kordinates kuriose negalima redaguoti


// +
void blyksintis_skaicius(){
blyksincio_skaiciaus_laiko_paskutinis_ciklas = PUSE_SEKUNDES;
if(REDAGAVIMAS==1){
blyksincio_skaiciaus_laikas = blyksincio_skaiciaus_laikas + 1;

if(blyksincio_skaiciaus_laikas>=
blyksincio_skaiciaus_laiko_paskutinis_ciklas){
blyksincio_skaiciaus_laikas = 0;}


blyksincio_skaiciaus_laiko_vidurinysis_ciklas = 
blyksincio_skaiciaus_laiko_paskutinis_ciklas / 2;

SKAICIUS_DEGA = blyksincio_skaiciaus_laikas /
blyksincio_skaiciaus_laiko_vidurinysis_ciklas;

if(SKAICIUS_DEGA==0){
if(z==-4){
if(OSC==0){
a = 33;}}
if(z==-3){
if(OSC==4){
a = 33;}}
if(z==-2){
if(OSC==8){
a = 33;}}
if(z==-1){
if(OSC==12){
a = 33;}}
if(z==0){
if(OSC==16){
a = 33;}}
if(z==1){
if(OSC==20){
a = 33;}}
if(z==2){
if(OSC==24){
a = 33;}}
if(z==3){
if(OSC==28){
a = 33;}}}}}



void outputai(){
{if(segm_a==1){
PORTC.6 = 0;}
else
PORTC.6 = 1;}
{if(segm_b==1){
PORTC.0 = 0;}
else
PORTC.0 = 1;} 
{if(segm_c==1){
PORTC.2 = 0;}
else
PORTC.2 = 1;}
{if(segm_d==1){
PORTC.4 = 0;}
else
PORTC.4 = 1;}
{if(segm_e==1){
PORTC.5 = 0;}
else
PORTC.5 = 1;}
{if(segm_f==1){
PORTC.7 = 0;}
else
PORTC.7 = 1;}
{if(segm_g==1){
PORTC.1 = 0;}
else
PORTC.1 = 1;}
{if(segm_h==1){
PORTC.3 = 0;}
else
PORTC.3 = 1;}

a = 40;
segm_a = 0;
segm_b = 0;
segm_c = 0;
segm_d = 0;
segm_e = 0;
segm_f = 0;
segm_g = 0;
segm_h = 0;

PORTA.1 = 0;   // A
PORTA.4 = 0;   // B
PORTA.3 = 0;   // C
PORTA.2 = 0;   // D

if(OSC==0){
PORTA.1 = 0;
PORTA.4 = 0;
PORTA.3 = 1;
PORTA.2 = 0;}
if(OSC==4){
PORTA.1 = 1;
PORTA.4 = 1;
PORTA.3 = 0;
PORTA.2 = 0;}
if(OSC==8){
PORTA.1 = 1;
PORTA.4 = 1;
PORTA.3 = 1;
PORTA.2 = 0;}
if(OSC==12){
PORTA.1 = 0;
PORTA.4 = 1;
PORTA.3 = 0;
PORTA.2 = 0;}
if(OSC==16){
PORTA.1 = 0;
PORTA.4 = 1;
PORTA.3 = 1;
PORTA.2 = 0;}
if(OSC==20){
PORTA.1 = 1;
PORTA.4 = 0;
PORTA.3 = 0;
PORTA.2 = 0;}
if(OSC==24){
PORTA.1 = 1;
PORTA.4 = 0;
PORTA.3 = 1;
PORTA.2 = 0;}
if(OSC==28){
PORTA.1 = 0;
PORTA.4 = 0;
PORTA.3 = 0;
PORTA.2 = 1;}

    if(pfet_kairysis==1){
    PORTB.1 = 1;
    }
    else{
    PORTB.1 = 0;
    }
    
    if(pfet_desinysis==1){
    PORTB.2 = 1;
    }
    else{
    PORTB.2 = 0;
    } 
    
    if(nfet_desinysis==1){
    PORTB.3 = 1;
    }
    else{
    PORTB.3 = 0;
    }
    
    if(nfet_kairysis==1){
    PORTB.4 = 1;
    }
    else{
    PORTB.4 = 0;
    }
}


// +
void dabartinis_laikas(){
if((MYGTUKAS_6==1)&&(REDAGAVIMAS==0)){
REDAGAVIMAS = 1;
MYGTUKAS_6 = 0;
z = 0;}
if(((MYGTUKAS_6==1)||(MYGTUKAS_3==1))&&(REDAGAVIMAS==1)){
REDAGAVIMAS = 0;}
MYGTUKAS_6 = 0;

if(REDAGAVIMAS==1){
viena_laikrodzio_sekunde = 0;
laikrodzio_sekundes = 0;

if(MYGTUKAS_2==1){
z = z - 1;
MYGTUKAS_2 = 0;}
if(MYGTUKAS_4==1){
z = z + 1;}
if(z<0){
z = 3;}
if(z>3){
z = 0;}

if(z==0){
if(MYGTUKAS_1==1){
laikrodzio_valandos = laikrodzio_valandos + 10;
MYGTUKAS_1 = 0;}
if(MYGTUKAS_5==1){
laikrodzio_valandos = laikrodzio_valandos - 10;
MYGTUKAS_5 = 0;}}

if(z==1){
if(MYGTUKAS_1==1){
laikrodzio_valandos = laikrodzio_valandos + 1;
MYGTUKAS_1 = 0;}
if(MYGTUKAS_5==1){
laikrodzio_valandos = laikrodzio_valandos - 1;
MYGTUKAS_5 = 0;}}

if(z==2){
if(MYGTUKAS_1==1){
laikrodzio_minutes = laikrodzio_minutes + 10;
MYGTUKAS_1 = 0;}
if(MYGTUKAS_5==1){
laikrodzio_minutes = laikrodzio_minutes - 10;
MYGTUKAS_5 = 0;}}

if(z==3){
if(MYGTUKAS_1==1){
laikrodzio_minutes = laikrodzio_minutes + 1;
MYGTUKAS_1 = 0;}
if(MYGTUKAS_5==1){
laikrodzio_minutes = laikrodzio_minutes - 1;
MYGTUKAS_5 = 0;}}}





begancio_uzraso_DABAR_laikas = 
begancio_uzraso_DABAR_laikas + 1;

if(begancio_uzraso_DABAR_laikas>=
PUSE_SEKUNDES){
begancio_uzraso_DABAR_laikas = 0;
begancio_uzraso_DABAR_padetis = 
begancio_uzraso_DABAR_padetis + 1;}

if(begancio_uzraso_DABAR_padetis>=10){
begancio_uzraso_DABAR_padetis = 0;}


if(begancio_uzraso_DABAR_padetis==1){
if(OSC==12){
a = 14;}}
if(begancio_uzraso_DABAR_padetis==2){
if(OSC==8){
a = 14;}
if(OSC==12){
a = 10;}}
if(begancio_uzraso_DABAR_padetis==3){
if(OSC==4){
a = 14;}
if(OSC==8){
a = 10;}
if(OSC==12){
a = 11;}}
if(begancio_uzraso_DABAR_padetis==4){
if(OSC==0){
a = 14;}
if(OSC==4){
a = 10;}
if(OSC==8){
a = 11;}
if(OSC==12){
a = 10;}}
if(begancio_uzraso_DABAR_padetis==5){
if(OSC==0){
a = 10;}
if(OSC==4){
a = 11;}
if(OSC==8){
a = 10;}
if(OSC==12){
a = 30;}}
if(begancio_uzraso_DABAR_padetis==6){
if(OSC==0){
a = 11;}
if(OSC==4){
a = 10;}
if(OSC==8){
a = 30;}}
if(begancio_uzraso_DABAR_padetis==7){
if(OSC==0){
a = 10;}
if(OSC==4){
a = 30;}}
if(begancio_uzraso_DABAR_padetis==8){
if(OSC==0){
a = 30;}}

if((OSC==12)&&(viena_laikrodzio_sekunde<=PUSE_SEKUNDES)){
segm_h = 1;}
if(OSC==16){
a = laikrodzio_valandos / 10;}
if(OSC==20){
segm_h = 1;
a = laikrodzio_valandos - (laikrodzio_valandos / 10) * 10;}
if(OSC==24){
a = laikrodzio_minutes / 10;}
if(OSC==28){
a = laikrodzio_minutes - (laikrodzio_minutes / 10) * 10;}}


// +
void sekundes_trukmes_keitimas(){
if((MYGTUKAS_6==1)&&(REDAGAVIMAS==0)){
REDAGAVIMAS = 1;
MYGTUKAS_6 = 0;
z = -1;}
if(((MYGTUKAS_6==1)||(MYGTUKAS_3==1))&&(REDAGAVIMAS==1)){
REDAGAVIMAS = 0;
MYGTUKAS_6 = 0;
MYGTUKAS_3 = 0;}

if(REDAGAVIMAS==1){
if(MYGTUKAS_2==1){
z = z - 1;
MYGTUKAS_2 = 0;}
if(MYGTUKAS_4==1){
z = z + 1;
MYGTUKAS_4 = 0;}

if(z==-2){
z = 3;}
if(z==4){
z = -1;}


if(z==-1){
if((MYGTUKAS_1==1)&&(VIENA_SEKUNDE<=55530)){
VIENA_SEKUNDE = VIENA_SEKUNDE + 10000;}
if((MYGTUKAS_5==1)&&(VIENA_SEKUNDE>10000)){
VIENA_SEKUNDE = VIENA_SEKUNDE - 10000;}
MYGTUKAS_1 = 0;
MYGTUKAS_5 = 0;}
                                     
if(z==0){
if((MYGTUKAS_1==1)&&(VIENA_SEKUNDE<=64530)){
VIENA_SEKUNDE = VIENA_SEKUNDE + 1000;}
if((MYGTUKAS_5==1)&&(VIENA_SEKUNDE>1000)){
VIENA_SEKUNDE = VIENA_SEKUNDE - 1000;}
MYGTUKAS_1 = 0;
MYGTUKAS_5 = 0;}

if(z==1){
if((MYGTUKAS_1==1)&&(VIENA_SEKUNDE<=65430)){
VIENA_SEKUNDE = VIENA_SEKUNDE + 100;}
if((MYGTUKAS_5==1)&&(VIENA_SEKUNDE>100)){
VIENA_SEKUNDE = VIENA_SEKUNDE - 100;}
MYGTUKAS_1 = 0;
MYGTUKAS_5 = 0;}

if(z==2){
if((MYGTUKAS_1==1)&&(VIENA_SEKUNDE<=65520)){
VIENA_SEKUNDE = VIENA_SEKUNDE + 10;}
if((MYGTUKAS_5==1)&&(VIENA_SEKUNDE>10)){
VIENA_SEKUNDE = VIENA_SEKUNDE - 10;}
MYGTUKAS_1 = 0;
MYGTUKAS_5 = 0;}

if(z==3){
if((MYGTUKAS_1==1)&&(VIENA_SEKUNDE<=65529)){
VIENA_SEKUNDE = VIENA_SEKUNDE + 1;}
if((MYGTUKAS_5==1)&&(VIENA_SEKUNDE>2)){
VIENA_SEKUNDE = VIENA_SEKUNDE - 1;}
MYGTUKAS_1 = 0;
MYGTUKAS_5 = 0;}}


if(OSC==0){
a = 5;}
if(OSC==4){
a = 15;}
if(OSC==8){
segm_a = 1;
segm_d = 1;
segm_e = 1;
segm_f = 1;
segm_h = 1;}
if(OSC==12){
a = VIENA_SEKUNDE/10000;}
if(OSC==16){
a = (VIENA_SEKUNDE - ((VIENA_SEKUNDE/10000)*10000)) / 1000;}
if(OSC==20){
a = (VIENA_SEKUNDE - ((VIENA_SEKUNDE/1000)*1000)) / 100;}
if(OSC==24){
a = (VIENA_SEKUNDE - ((VIENA_SEKUNDE/100)*100)) / 10;}
if(OSC==28){
a = (VIENA_SEKUNDE - (VIENA_SEKUNDE/10)*10);}}


// +
void kondensatoriaus_busena(){
kondensatoriaus_rodymo_laikas = kondensatoriaus_rodymo_laikas + 1;
if(kondensatoriaus_rodymo_laikas>=KETVIRTADALIS_SEKUNDES){
kondensatoriaus_rodymo_laikas = 0;
kondensatoriaus_rodymo_padetis = kondensatoriaus_rodymo_padetis + 1;}

if((kondensatorius_pilnas==1)&&(kondensatoriaus_rodymo_padetis==29)){
kondensatoriaus_rodymo_padetis =0;}
if((kondensatorius_vidutinis==1)&&(kondensatoriaus_rodymo_padetis==27)){
kondensatoriaus_rodymo_padetis = 0;}
if((kondensatorius_tuscias==1)&&(kondensatoriaus_rodymo_padetis==31)){
kondensatoriaus_rodymo_padetis = 0;} 

if((kondensatorius_tuscias==1)||(kondensatorius_pilnas==1)){
if(kondensatoriaus_rodymo_padetis==1){
if(OSC==28){
a = 12;}}
if(kondensatoriaus_rodymo_padetis==2){
if(OSC==24){
a = 12;}
if(OSC==28){
a = 23;}}
if(kondensatoriaus_rodymo_padetis==3){
if(OSC==20){
a = 12;}
if(OSC==24){
a = 23;}
if(OSC==28){
a = 34;}}
if(kondensatoriaus_rodymo_padetis==4){
if(OSC==16){
a = 12;}
if(OSC==20){
a = 23;}
if(OSC==24){
a = 34;}
if(OSC==28){
a = 14;}}
if(kondensatoriaus_rodymo_padetis==5){
if(OSC==12){
a = 12;}
if(OSC==16){
a = 23;}
if(OSC==20){
a = 34;}
if(OSC==24){
a = 14;}
if(OSC==28){
a = 15;}}
if(kondensatoriaus_rodymo_padetis==6){
if(OSC==8){
a = 12;}
if(OSC==12){
a = 23;}
if(OSC==16){
a = 34;}
if(OSC==20){
a = 14;}
if(OSC==24){
a = 15;}
if(OSC==28){
a = 34;}}
if(kondensatoriaus_rodymo_padetis==7){
if(OSC==4){
a = 12;}
if(OSC==8){
a = 23;}
if(OSC==12){
a = 34;}
if(OSC==16){
a = 14;}
if(OSC==20){
a = 15;}
if(OSC==24){
a = 34;}
if(OSC==28){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==8){
if(OSC==0){
a = 12;}
if(OSC==4){
a = 23;}
if(OSC==8){
a = 34;}
if(OSC==12){
a = 14;}
if(OSC==16){
a = 15;}
if(OSC==20){
a = 34;}
if(OSC==24){
a = 5;}
if(OSC==28){
a = 10;}}
if(kondensatoriaus_rodymo_padetis==9){
if(OSC==0){
a = 23;}
if(OSC==4){
a = 34;}
if(OSC==8){
a = 14;}
if(OSC==12){
a = 15;}
if(OSC==16){
a = 34;}
if(OSC==20){
a = 5;}
if(OSC==24){
a = 10;}
if(OSC==28){
a = 26;}}
if(kondensatoriaus_rodymo_padetis==10){
if(OSC==0){
a = 34;}
if(OSC==4){
a = 14;}
if(OSC==8){
a = 15;}
if(OSC==12){
a = 34;}
if(OSC==16){
a = 5;}
if(OSC==20){
a = 10;}
if(OSC==24){
a = 26;}
if(OSC==28){
a = 23;}}
if(kondensatoriaus_rodymo_padetis==11){
if(OSC==0){
a = 14;}
if(OSC==4){
a = 15;}
if(OSC==8){
a = 34;}
if(OSC==12){
a = 5;}
if(OSC==16){
a = 10;}
if(OSC==20){
a = 26;}
if(OSC==24){
a = 23;}
if(OSC==28){
a = 30;}}
if(kondensatoriaus_rodymo_padetis==12){
if(OSC==0){
a = 15;}
if(OSC==4){
a = 34;}
if(OSC==8){
a = 5;}
if(OSC==12){
a = 10;}
if(OSC==16){
a = 26;}
if(OSC==20){
a = 23;}
if(OSC==24){
a = 30;}
if(OSC==28){
a = 20;}}
if(kondensatoriaus_rodymo_padetis==13){
if(OSC==0){
a = 34;}
if(OSC==4){
a = 5;}
if(OSC==8){
a = 10;}
if(OSC==12){
a = 26;}
if(OSC==16){
a = 23;}
if(OSC==20){
a = 30;}
if(OSC==24){
a = 20;}
if(OSC==28){
a = 27;}}
if(kondensatoriaus_rodymo_padetis==14){
if(OSC==0){
a = 5;}
if(OSC==4){
a = 10;}
if(OSC==8){
a = 26;}
if(OSC==12){
a = 23;}
if(OSC==16){
a = 30;}
if(OSC==20){
a = 20;}
if(OSC==24){
a = 27;}
if(OSC==28){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==15){
if(OSC==0){
a = 10;}
if(OSC==4){
a = 26;}
if(OSC==8){
a = 23;}
if(OSC==12){
a = 30;}
if(OSC==16){
a = 20;}
if(OSC==20){
a = 27;}
if(OSC==24){
a = 5;}}}

if(kondensatorius_pilnas==1){
if(kondensatoriaus_rodymo_padetis==16){
if(OSC==0){
a = 26;}
if(OSC==4){
a = 23;}
if(OSC==8){
a = 30;}
if(OSC==12){
a = 20;}
if(OSC==16){
a = 27;}
if(OSC==20){
a = 5;}
if(OSC==28){
a = 24;}}
if(kondensatoriaus_rodymo_padetis==17){
if(OSC==0){
a = 23;}
if(OSC==4){
a = 30;}
if(OSC==8){
a = 20;}
if(OSC==12){
a = 27;}
if(OSC==16){
a = 5;}
if(OSC==24){
a = 24;}
if(OSC==28){
a = 19;}}
if(kondensatoriaus_rodymo_padetis==18){
if(OSC==0){
a = 30;}
if(OSC==4){
a = 20;}
if(OSC==8){
a = 27;}
if(OSC==12){
a = 5;}
if(OSC==20){
a = 24;}
if(OSC==24){
a = 19;}
if(OSC==28){
a = 22;}}
if(kondensatoriaus_rodymo_padetis==19){
if(OSC==0){
a = 20;}
if(OSC==4){
a = 27;}
if(OSC==8){
a = 5;}
if(OSC==16){
a = 24;}
if(OSC==20){
a = 19;}
if(OSC==24){
a = 22;}
if(OSC==28){
a = 34;}}
if(kondensatoriaus_rodymo_padetis==20){
if(OSC==0){
a = 27;}
if(OSC==4){
a = 5;}
if(OSC==12){
a = 24;}
if(OSC==16){
a = 19;}
if(OSC==20){
a = 22;}
if(OSC==24){
a = 34;}
if(OSC==28){
a = 10;}}
if(kondensatoriaus_rodymo_padetis==21){
if(OSC==0){
a = 5;}
if(OSC==8){
a = 24;}
if(OSC==12){
a = 19;}
if(OSC==16){
a = 22;}
if(OSC==20){
a = 34;}
if(OSC==24){
a = 10;}
if(OSC==28){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==22){
if(OSC==4){
a = 24;}
if(OSC==8){
a = 19;}
if(OSC==12){
a = 22;}
if(OSC==16){
a = 34;}
if(OSC==20){
a = 10;}
if(OSC==24){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==23){
if(OSC==0){
a = 24;}
if(OSC==4){
a = 19;}
if(OSC==8){
a = 22;}
if(OSC==12){
a = 34;}
if(OSC==16){
a = 10;}
if(OSC==20){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==24){
if(OSC==0){
a = 19;}
if(OSC==4){
a = 22;}
if(OSC==8){
a = 34;}
if(OSC==12){
a = 10;}
if(OSC==16){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==25){
if(OSC==0){
a = 22;}
if(OSC==4){
a = 34;}
if(OSC==8){
a = 10;}
if(OSC==12){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==26){
if(OSC==0){
a = 34;}
if(OSC==4){
a = 10;}
if(OSC==8){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==27){
if(OSC==0){
a = 10;}
if(OSC==4){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==27){
if(OSC==0){
a = 5;}}}

if(kondensatorius_tuscias==1){
if(kondensatoriaus_rodymo_padetis==16){
if(OSC==0){
a = 26;}
if(OSC==4){
a = 23;}
if(OSC==8){
a = 30;}
if(OSC==12){
a = 20;}
if(OSC==16){
a = 27;}
if(OSC==20){
a = 5;}
if(OSC==28){
a = 26;}}
if(kondensatoriaus_rodymo_padetis==17){
if(OSC==0){
a = 23;}
if(OSC==4){
a = 30;}
if(OSC==8){
a = 20;}
if(OSC==12){
a = 27;}
if(OSC==16){
a = 5;}
if(OSC==24){
a = 26;}
if(OSC==28){
a = 28;}}
if(kondensatoriaus_rodymo_padetis==18){
if(OSC==0){
a = 30;}
if(OSC==4){
a = 20;}
if(OSC==8){
a = 27;}
if(OSC==12){
a = 5;}
if(OSC==20){
a = 26;}
if(OSC==24){
a = 28;}
if(OSC==28){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==19){
if(OSC==0){
a = 20;}
if(OSC==4){
a = 27;}
if(OSC==8){
a = 5;}
if(OSC==16){
a = 26;}
if(OSC==20){
a = 28;}
if(OSC==24){
a = 5;}
if(OSC==28){
a = 13;}}
if(kondensatoriaus_rodymo_padetis==20){
if(OSC==0){
a = 27;}
if(OSC==4){
a = 5;}
if(OSC==12){
a = 26;}
if(OSC==16){
a = 28;}
if(OSC==20){
a = 5;}
if(OSC==24){
a = 13;}
if(OSC==28){
a = 19;}}
if(kondensatoriaus_rodymo_padetis==21){
if(OSC==0){
a = 5;}
if(OSC==8){
a = 26;}
if(OSC==12){
a = 28;}
if(OSC==16){
a = 5;}
if(OSC==20){
a = 13;}
if(OSC==24){
a = 19;}
if(OSC==28){
a = 10;}}
if(kondensatoriaus_rodymo_padetis==22){
if(OSC==4){
a = 26;}
if(OSC==8){
a = 28;}
if(OSC==12){
a = 5;}
if(OSC==16){
a = 13;}
if(OSC==20){
a = 19;}
if(OSC==24){
a = 10;}
if(OSC==28){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==23){
if(OSC==0){
a = 26;}
if(OSC==4){
a = 28;}
if(OSC==8){
a = 5;}
if(OSC==12){
a = 13;}
if(OSC==16){
a = 19;}
if(OSC==20){
a = 10;}
if(OSC==24){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==24){
if(OSC==0){
a = 28;}
if(OSC==4){
a = 5;}
if(OSC==8){
a = 13;}
if(OSC==12){
a = 19;}
if(OSC==16){
a = 10;}
if(OSC==20){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==25){
if(OSC==0){
a = 5;}
if(OSC==4){
a = 13;}
if(OSC==8){
a = 19;}
if(OSC==12){
a = 10;}
if(OSC==16){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==26){
if(OSC==0){
a = 13;}
if(OSC==4){
a = 19;}
if(OSC==8){
a = 10;}
if(OSC==12){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==27){
if(OSC==0){
a = 19;}
if(OSC==4){
a = 10;}
if(OSC==8){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==28){
if(OSC==0){
a = 10;}
if(OSC==4){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==29){
if(OSC==0){
a = 5;}}}


if(kondensatorius_vidutinis){
if(kondensatoriaus_rodymo_padetis==1){
if(OSC==28){
a = 12;}}
if(kondensatoriaus_rodymo_padetis==2){
if(OSC==24){
a = 12;}
if(OSC==28){
a = 23;}}
if(kondensatoriaus_rodymo_padetis==3){
if(OSC==20){
a = 12;}
if(OSC==24){
a = 23;}
if(OSC==28){
a = 34;}}
if(kondensatoriaus_rodymo_padetis==4){
if(OSC==16){
a = 12;}
if(OSC==20){
a = 23;}
if(OSC==24){
a = 34;}
if(OSC==28){
a = 14;}}
if(kondensatoriaus_rodymo_padetis==5){
if(OSC==12){
a = 12;}
if(OSC==16){
a = 23;}
if(OSC==20){
a = 34;}
if(OSC==24){
a = 14;}
if(OSC==28){
a = 15;}}
if(kondensatoriaus_rodymo_padetis==6){
if(OSC==8){
a = 12;}
if(OSC==12){
a = 23;}
if(OSC==16){
a = 34;}
if(OSC==20){
a = 14;}
if(OSC==24){
a = 15;}
if(OSC==28){
a = 34;}}
if(kondensatoriaus_rodymo_padetis==7){
if(OSC==4){
a = 12;}
if(OSC==8){
a = 23;}
if(OSC==12){
a = 34;}
if(OSC==16){
a = 14;}
if(OSC==20){
a = 15;}
if(OSC==24){
a = 34;}
if(OSC==28){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==8){
if(OSC==0){
a = 12;}
if(OSC==4){
a = 23;}
if(OSC==8){
a = 34;}
if(OSC==12){
a = 14;}
if(OSC==16){
a = 15;}
if(OSC==20){
a = 34;}
if(OSC==24){
a = 5;}
if(OSC==28){
a = 10;}}
if(kondensatoriaus_rodymo_padetis==9){
if(OSC==0){
a = 23;}
if(OSC==4){
a = 34;}
if(OSC==8){
a = 14;}
if(OSC==12){
a = 15;}
if(OSC==16){
a = 34;}
if(OSC==20){
a = 5;}
if(OSC==24){
a = 10;}
if(OSC==28){
a = 26;}}
if(kondensatoriaus_rodymo_padetis==10){
if(OSC==0){
a = 34;}
if(OSC==4){
a = 14;}
if(OSC==8){
a = 15;}
if(OSC==12){
a = 34;}
if(OSC==16){
a = 5;}
if(OSC==20){
a = 10;}
if(OSC==24){
a = 26;}
if(OSC==28){
a = 23;}}
if(kondensatoriaus_rodymo_padetis==11){
if(OSC==0){
a = 14;}
if(OSC==4){
a = 15;}
if(OSC==8){
a = 34;}
if(OSC==12){
a = 5;}
if(OSC==16){
a = 10;}
if(OSC==20){
a = 26;}
if(OSC==24){
a = 23;}
if(OSC==28){
a = 30;}}
if(kondensatoriaus_rodymo_padetis==12){
if(OSC==0){
a = 15;}
if(OSC==4){
a = 34;}
if(OSC==8){
a = 5;}
if(OSC==12){
a = 10;}
if(OSC==16){
a = 26;}
if(OSC==20){
a = 23;}
if(OSC==24){
a = 30;}
if(OSC==28){
a = 20;}}
if(kondensatoriaus_rodymo_padetis==13){
if(OSC==0){
a = 34;}
if(OSC==4){
a = 5;}
if(OSC==8){
a = 10;}
if(OSC==12){
a = 26;}
if(OSC==16){
a = 23;}
if(OSC==20){
a = 30;}
if(OSC==24){
a = 20;}
if(OSC==28){
a = 10;}}
if(kondensatoriaus_rodymo_padetis==14){
if(OSC==0){
a = 5;}
if(OSC==4){
a = 10;}
if(OSC==8){
a = 26;}
if(OSC==12){
a = 23;}
if(OSC==16){
a = 30;}
if(OSC==20){
a = 20;}
if(OSC==24){
a = 10;}
if(OSC==28){
a = 27;}}
if(kondensatoriaus_rodymo_padetis==15){
if(OSC==0){
a = 10;}
if(OSC==4){
a = 26;}
if(OSC==8){
a = 23;}
if(OSC==12){
a = 30;}
if(OSC==16){
a = 20;}
if(OSC==20){
a = 10;}
if(OSC==24){
a = 27;}
if(OSC==28){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==16){
if(OSC==0){
a = 26;}
if(OSC==4){
a = 23;}
if(OSC==8){
a = 30;}
if(OSC==12){
a = 20;}
if(OSC==16){
a = 10;}
if(OSC==20){
a = 27;}
if(OSC==24){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==17){
if(OSC==0){
a = 23;}
if(OSC==4){
a = 30;}
if(OSC==8){
a = 20;}
if(OSC==12){
a = 10;}
if(OSC==16){
a = 27;}
if(OSC==20){
a = 5;}
if(OSC==28){
a = 24;}}
if(kondensatoriaus_rodymo_padetis==18){
if(OSC==0){
a = 30;}
if(OSC==4){
a = 20;}
if(OSC==8){
a = 10;}
if(OSC==12){
a = 27;}
if(OSC==16){
a = 5;}
if(OSC==24){
a = 24;}
if(OSC==28){
a = 28;}}
if(kondensatoriaus_rodymo_padetis==19){
if(OSC==0){
a = 20;}
if(OSC==4){
a = 10;}
if(OSC==8){
a = 27;}
if(OSC==12){
a = 5;}
if(OSC==20){
a = 24;}
if(OSC==24){
a = 28;}
if(OSC==28){
a = 5;}}
if(kondensatoriaus_rodymo_padetis==19){
if(OSC==0){
a = 10;}
if(OSC==4){
a = 27;}
if(OSC==8){
a = 5;}
if(OSC==16){
a = 24;}
if(OSC==20){
a = 28;}
if(OSC==24){
a = 5;}
if(OSC==28){
a = 15;}}
if(kondensatoriaus_rodymo_padetis==20){
if(OSC==0){
a = 27;}
if(OSC==4){
a = 5;}
if(OSC==12){
a = 24;}
if(OSC==16){
a = 28;}
if(OSC==20){
a = 5;}
if(OSC==24){
a = 15;}}
if(kondensatoriaus_rodymo_padetis==21){
if(OSC==0){
a = 5;}
if(OSC==8){
a = 24;}
if(OSC==12){
a = 28;}
if(OSC==16){
a = 5;}
if(OSC==20){
a = 15;}}
if(kondensatoriaus_rodymo_padetis==22){
if(OSC==4){
a = 24;}
if(OSC==8){
a = 28;}
if(OSC==12){
a = 5;}
if(OSC==16){
a = 15;}}
if(kondensatoriaus_rodymo_padetis==23){
if(OSC==0){
a = 24;}
if(OSC==4){
a = 28;}
if(OSC==8){
a = 5;}
if(OSC==12){
a = 15;}}
if(kondensatoriaus_rodymo_padetis==24){
if(OSC==0){
a = 28;}
if(OSC==4){
a = 5;}
if(OSC==8){
a = 15;}}
if(kondensatoriaus_rodymo_padetis==25){
if(OSC==0){
a = 5;}
if(OSC==4){
a = 15;}}
if(kondensatoriaus_rodymo_padetis==25){
if(OSC==0){
a = 15;}}

}}



void dabartinio_laiko_skaiciavimas(){
viena_laikrodzio_sekunde = viena_laikrodzio_sekunde + 1;
if(viena_laikrodzio_sekunde>=VIENA_SEKUNDE){
viena_laikrodzio_sekunde = 0;
laikrodzio_sekundes = laikrodzio_sekundes + 1;}

if(laikrodzio_sekundes>=60){
laikrodzio_sekundes = 0;
laikrodzio_minutes = laikrodzio_minutes + 1;}

if(laikrodzio_minutes>=60){
laikrodzio_minutes = 0;
laikrodzio_valandos = laikrodzio_valandos + 1;}
if(laikrodzio_minutes<0){
laikrodzio_minutes = 59;
laikrodzio_valandos = laikrodzio_valandos - 1;}

if(laikrodzio_valandos>=24){
laikrodzio_valandos = 0;}
if(laikrodzio_valandos<0){
laikrodzio_valandos = 23;}}



void mosfet_valdymas(){
unsigned int a,b,c,d;
a = PUSE_SEKUNDES/4;
b = (PUSE_SEKUNDES/4)*3;
c = (PUSE_SEKUNDES/4)*5;
d = (PUSE_SEKUNDES/4)*7;
          
    if((viena_laikrodzio_sekunde<b)&&(viena_laikrodzio_sekunde>a)){
    pfet_desinysis = 0;
    nfet_kairysis = 0;

    pfet_kairysis = 1;
    nfet_desinysis = 1;
    }
    else if((viena_laikrodzio_sekunde>c)&&(viena_laikrodzio_sekunde<d)){
    pfet_kairysis = 0;
    nfet_desinysis = 0;

    pfet_desinysis = 1;
    nfet_kairysis = 1;
    }
    else{
    pfet_kairysis = 0;
    pfet_desinysis = 0;
    nfet_kairysis = 0;
    nfet_desinysis = 0;
    }
}

