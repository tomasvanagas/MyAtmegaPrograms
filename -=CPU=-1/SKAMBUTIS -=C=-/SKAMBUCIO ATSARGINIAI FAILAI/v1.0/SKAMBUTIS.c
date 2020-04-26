/*****************************************************


Project : Skambutis
Version : v1.0 
Date    : 4/11/2010
Author  : Tomas Vanagas 

Chip type               : ATmega32
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <delay.h>
void main(void)
{
signed int viena_sekunde1, viena_sekunde2, viena_sekunde3,
viena_sekunde4;


char OSC;      //LED DAZNIS

char 
MYGTUKAS_1, MYGTUKAS_2, MYGTUKAS_3, MYGTUKAS_4,
MYGTUKAS_5, MYGTUKAS_6, MYGTUKAS_7,
MYGTUKAS_PASPAUSTAS;     //MYGTUKAI

char segm_a, segm_b, segm_c, segm_d, segm_e,
segm_f, segm_g, segm_h; // SEGMENTAI

signed char dvi_sekundes, sekundes, minutes, desimtys_minutes, 
valandos, desimtys_valandos; // TIKRO LAIKO KINTAMIEJI

char a; // DUOMENU NESEJO KINTAMASIS

signed char b,c,d,e; // UZLAIKYMO KINTAMIEJI

signed char REDAGAVIMAS, REDAG_SK_NR, 
EILUTES_SKAICIUS; // PIRMINIAI KINTAMIEJI


// Standartiniai skambucio laikai:
char 
SKAMBUTIS_1dh, SKAMBUTIS_1h, SKAMBUTIS_1dm, SKAMBUTIS_1m,
SKAMBUTIS_2dh, SKAMBUTIS_2h, SKAMBUTIS_2dm, SKAMBUTIS_2m,
SKAMBUTIS_3dh, SKAMBUTIS_3h, SKAMBUTIS_3dm, SKAMBUTIS_3m,
SKAMBUTIS_4dh, SKAMBUTIS_4h, SKAMBUTIS_4dm, SKAMBUTIS_4m,
SKAMBUTIS_5dh, SKAMBUTIS_5h, SKAMBUTIS_5dm, SKAMBUTIS_5m,
SKAMBUTIS_6dh, SKAMBUTIS_6h, SKAMBUTIS_6dm, SKAMBUTIS_6m,
SKAMBUTIS_7dh, SKAMBUTIS_7h, SKAMBUTIS_7dm, SKAMBUTIS_7m,
SKAMBUTIS_8dh, SKAMBUTIS_8h, SKAMBUTIS_8dm, SKAMBUTIS_8m,
SKAMBUTIS_9dh, SKAMBUTIS_9h, SKAMBUTIS_9dm, SKAMBUTIS_9m,
SKAMBUTIS_10dh,SKAMBUTIS_10h,SKAMBUTIS_10dm,SKAMBUTIS_10m,
SKAMBUTIS_11dh,SKAMBUTIS_11h,SKAMBUTIS_11dm,SKAMBUTIS_11m,
SKAMBUTIS_12dh,SKAMBUTIS_12h,SKAMBUTIS_12dm,SKAMBUTIS_12m,
SKAMBUTIS_13dh,SKAMBUTIS_13h,SKAMBUTIS_13dm,SKAMBUTIS_13m,
SKAMBUTIS_14dh,SKAMBUTIS_14h,SKAMBUTIS_14dm,SKAMBUTIS_14m,
SKAMBUTIS_15dh,SKAMBUTIS_15h,SKAMBUTIS_15dm,SKAMBUTIS_15m,
SKAMBUTIS_16dh,SKAMBUTIS_16h,SKAMBUTIS_16dm,SKAMBUTIS_16m,
SKAMBUTIS_17dh,SKAMBUTIS_17h,SKAMBUTIS_17dm,SKAMBUTIS_17m,
SKAMBUTIS_18dh,SKAMBUTIS_18h,SKAMBUTIS_18dm,SKAMBUTIS_18m,
SKAMBUTIS_19dh,SKAMBUTIS_19h,SKAMBUTIS_19dm,SKAMBUTIS_19m,
SKAMBUTIS_20dh,SKAMBUTIS_20h,SKAMBUTIS_20dm,SKAMBUTIS_20m;
 
PORTA=0x00;
DDRA.0=0;
DDRA.1=0;
DDRA.2=0;
DDRA.3=1;
DDRA.4=1;
DDRA.5=1;
DDRA.6=1;
DDRA.7=1;

PORTB=0x00;
DDRB.0=1;
DDRB.1=1;
DDRB.2=1;
DDRB.3=1;
DDRB.4=1;
DDRB.5=1;
DDRB.6=1;
DDRB.7=1;

PORTC=0x00;
DDRC.0=1;
DDRC.1=1;
DDRC.2=1;
DDRC.3=1;
DDRC.4=1;
DDRC.5=1;
DDRC.6=1;
DDRC.7=1;

PORTD=0x00;
DDRD.0=1;
DDRD.1=1;
DDRD.2=1;
DDRD.3=1;
DDRD.4=1;
DDRD.5=1;
DDRD.6=1;
DDRD.7=1;

TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

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

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x00;

ACSR=0x00;
SFIOR=0x00;



// STANDARTINIS LAIKAS:
SKAMBUTIS_1dh = 0;
SKAMBUTIS_1h  = 8;
SKAMBUTIS_1dm = 0;        // 8:00
SKAMBUTIS_1m  = 0;

SKAMBUTIS_2dh = 0;
SKAMBUTIS_2h  = 8;
SKAMBUTIS_2dm = 4;        // 8:45
SKAMBUTIS_2m  = 5;

SKAMBUTIS_3dh = 0;
SKAMBUTIS_3h  = 8;
SKAMBUTIS_3dm = 5;        // 8:55
SKAMBUTIS_3m  = 5;

SKAMBUTIS_4dh = 0;
SKAMBUTIS_4h  = 9;
SKAMBUTIS_4dm = 4;        // 9:40
SKAMBUTIS_4m  = 0;

SKAMBUTIS_5dh = 1;
SKAMBUTIS_5h  = 0;
SKAMBUTIS_5dm = 0;        // 10:00
SKAMBUTIS_5m  = 0;

SKAMBUTIS_6dh = 1;
SKAMBUTIS_6h  = 0;
SKAMBUTIS_6dm = 4;        // 10:45
SKAMBUTIS_6m  = 5;

SKAMBUTIS_7dh = 1;
SKAMBUTIS_7h  = 1;
SKAMBUTIS_7dm = 0;        // 11:05
SKAMBUTIS_7m  = 5;

SKAMBUTIS_8dh = 1;
SKAMBUTIS_8h  = 1;
SKAMBUTIS_8dm = 5;        // 11:50
SKAMBUTIS_8m  = 0;

SKAMBUTIS_9dh = 1;
SKAMBUTIS_9h  = 2;
SKAMBUTIS_9dm = 0;        // 12:00
SKAMBUTIS_9m  = 0;

SKAMBUTIS_10dh = 1;
SKAMBUTIS_10h  = 2;
SKAMBUTIS_10dm = 4;       // 12:45
SKAMBUTIS_10m  = 5;

SKAMBUTIS_11dh = 1;
SKAMBUTIS_11h  = 2;
SKAMBUTIS_11dm = 5;       // 12:55
SKAMBUTIS_11m  = 5;

SKAMBUTIS_12dh = 1;
SKAMBUTIS_12h  = 3;
SKAMBUTIS_12dm = 4;       // 13:40
SKAMBUTIS_12m  = 0;

SKAMBUTIS_13dh = 1;
SKAMBUTIS_13h  = 3;
SKAMBUTIS_13dm = 5;       // 13:50
SKAMBUTIS_13m  = 0;

SKAMBUTIS_14dh = 1;
SKAMBUTIS_14h  = 4;
SKAMBUTIS_14dm = 3;       // 14:35
SKAMBUTIS_14m  = 5;

SKAMBUTIS_15dh = 1;
SKAMBUTIS_15h  = 4;
SKAMBUTIS_15dm = 4;       // 14:40
SKAMBUTIS_15m  = 0;

SKAMBUTIS_16dh = 1;
SKAMBUTIS_16h  = 5;
SKAMBUTIS_16dm = 2;       // 15:25
SKAMBUTIS_16m  = 5;

SKAMBUTIS_17dh = 1;
SKAMBUTIS_17h  = 5;
SKAMBUTIS_17dm = 3;       // 15:30
SKAMBUTIS_17m  = 0;

SKAMBUTIS_18dh = 1;
SKAMBUTIS_18h  = 6;
SKAMBUTIS_18dm = 1;       // 16:15
SKAMBUTIS_18m  = 5;

SKAMBUTIS_19dh = 1;
SKAMBUTIS_19h  = 6;
SKAMBUTIS_19dm = 2;       // 16:20
SKAMBUTIS_19m  = 0;

           
SKAMBUTIS_20dh = 1;
SKAMBUTIS_20h  = 7;
SKAMBUTIS_20dm = 0;       // 17:05
SKAMBUTIS_20m  = 5;


      do{
      
      OSC = OSC + 1 ;
      delay_us(10);
      if(OSC==32){
      OSC=0;}
      //           IEJIMAI ==> KINTAMIEJI(MYGTUKAI)
      {if((PINA.2==0)&&(PINA.1==1)&&(PINA.0==1)&&(b==0)){
      MYGTUKAS_1 = 1;}
      else
      MYGTUKAS_1 = 0;}
      {if((PINA.2==1)&&(PINA.1==0)&&(PINA.0==1)&&(b==0)){
      MYGTUKAS_2 = 1;}
      else
      MYGTUKAS_2 = 0;}
      {if((PINA.2==0)&&(PINA.1==0)&&(PINA.0==1)&&(b==0)){
      MYGTUKAS_3 = 1;}
      else
      MYGTUKAS_3 = 0;}
      {if((PINA.2==1)&&(PINA.1==1)&&(PINA.0==0)&&(b==0)){
      MYGTUKAS_4 = 1;}
      else
      MYGTUKAS_4 = 0;}
      {if((PINA.2==0)&&(PINA.1==1)&&(PINA.0==0)&&(b==0)){
      MYGTUKAS_5 = 1;}
      else
      MYGTUKAS_5 = 0;}
      {if((PINA.2==1)&&(PINA.1==0)&&(PINA.0==0)&&(b==0)){
      MYGTUKAS_6 = 1;}
      else
      MYGTUKAS_6 = 0;}
      {if((PINA.2==0)&&(PINA.1==0)&&(PINA.0==0)&&(b==0)){
      MYGTUKAS_7 = 1;}
      else
      MYGTUKAS_7 = 0;}

      {if((PINA.2==1)&&(PINA.1==1)&&(PINA.0==1)){
      MYGTUKAS_PASPAUSTAS = 0;}
      else
      MYGTUKAS_PASPAUSTAS = 1;}

      {if(MYGTUKAS_PASPAUSTAS==1){
      b = 1;}
      else
      b = 0;}


      //LAIKRODZIO DAZNIO GENERATORIUS:
     

      //TIKRAS LAIKAS:
      //redaguojant:
      
      if((desimtys_valandos<0)&&(valandos<4)){
      desimtys_valandos = 2;}

      if((desimtys_valandos<0)&&(valandos>=4)){
      desimtys_valandos = 1;}

      if(valandos<0){
      valandos = 9;}
      if(desimtys_minutes<0){
      desimtys_minutes = 5;}
      if(minutes<0){
      minutes = 9;} 

      //laiko skaiciavimas:
      if((dvi_sekundes==1)&&(c==0)&&(REDAGAVIMAS==0)){
      sekundes = sekundes + 2;
      c = 1;}
      if(dvi_sekundes==0){
      c = 0;}

      if((sekundes==60)&&(REDAGAVIMAS==0)){
      minutes = minutes + 1;
      sekundes = 0;}

      if((minutes==10)&&(REDAGAVIMAS==0)){
      desimtys_minutes = desimtys_minutes + 1;
      minutes = 0;}

      if((desimtys_minutes==6)&&(REDAGAVIMAS==0)){
      valandos = valandos + 1;
      desimtys_minutes = 0;}

      if((valandos==10)&&(REDAGAVIMAS==0)){
      desimtys_valandos = desimtys_valandos + 1;
      valandos = 0;}

      if((valandos>=4)&&(desimtys_valandos>=2)&&
      (REDAGAVIMAS==0)){
      valandos = 0;
      desimtys_valandos = 0;}



      //REDAGAVIMAS:

      if(MYGTUKAS_6==1){
      REDAGAVIMAS = 1;}
      if(MYGTUKAS_2==1){
      REDAG_SK_NR = REDAG_SK_NR - 1;}
      if(MYGTUKAS_4==1){
      REDAG_SK_NR = REDAG_SK_NR + 1;}

      if(REDAG_SK_NR==-1){
      REDAG_SK_NR = 3;}

      if(REDAG_SK_NR==4){
      REDAG_SK_NR = 0;}

      if(MYGTUKAS_3==1){
      REDAGAVIMAS = 0;
      REDAG_SK_NR = 0;}

      //TIKROJO LAIKO REDAGAVIMAS:
      if((EILUTES_SKAICIUS==0)&&(REDAGAVIMAS==1)){
      if((REDAG_SK_NR==0)&&(MYGTUKAS_1==1)){
      desimtys_valandos = desimtys_valandos + 1;}
      if((REDAG_SK_NR==0)&&(MYGTUKAS_5==1)){
      desimtys_valandos = desimtys_valandos - 1;}
      if((REDAG_SK_NR==1)&&(MYGTUKAS_1==1)){
      valandos = valandos + 1;}
      if((REDAG_SK_NR==1)&&(MYGTUKAS_5==1)){
      valandos = valandos - 1;}
      if((REDAG_SK_NR==2)&&(MYGTUKAS_1==1)){
      desimtys_minutes = desimtys_minutes + 1;}
      if((REDAG_SK_NR==2)&&(MYGTUKAS_5==1)){
      desimtys_minutes = desimtys_minutes - 1;}
      if((REDAG_SK_NR==3)&&(MYGTUKAS_1==1)){
      minutes = minutes + 1;}
      if((REDAG_SK_NR==3)&&(MYGTUKAS_5==1)){
      minutes = minutes - 1;}}
      if(REDAGAVIMAS==1){
      if(minutes==10){
      minutes=0;}
      if(desimtys_minutes==6){
      desimtys_minutes = 0;}
      if(valandos==10){
      valandos = 0;}
      if(desimtys_valandos==3){
      desimtys_valandos = 0;}
      if((desimtys_valandos==2)&&(valandos>=4)){
      desimtys_valandos = 0;}

      if(minutes==-1){
      minutes = 9;}
      if(desimtys_minutes==-1){
      desimtys_minutes = 5;}
      if((valandos==-1)&&(desimtys_valandos<=1)){
      valandos = 9;}
      if((valandos==-1)&&(desimtys_valandos>=2)){
      valandos = 3;}}

      //VISUAL:
      if(EILUTES_SKAICIUS==0){
      if(OSC==0){
      a = 14;}
      if(OSC==4){
      a = 11;}
      if(OSC==8){
      a = 10;}
      if(OSC==12){
      a = 30;}
      if(OSC==16){
      a = desimtys_valandos;}
      if(OSC==20){
      a = valandos;}
      if(OSC==24){
      a = desimtys_minutes;}
      if(OSC==28){
      a = minutes;}}






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
      segm_f = 1;
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


      //SIGNALO FILTRAVIMAS
      if((OSC!=0)&&(OSC!=4)&&(OSC!=8)&&(OSC!=12)&&
      (OSC!=16)&&(OSC!=20)&&(OSC!=24)&&(OSC!=28)){
      a = 0;}




      //            ISEJIMAI:
      {if(segm_a==1){
      PORTD.5 = 0;}
      else
      PORTD.5 = 1;}
      {if(segm_b==1){
      PORTD.2 = 0;}
      else
      PORTD.2 = 1;}
      {if(segm_c==1){
      PORTD.1 = 0;}
      else
      PORTD.1 = 1;}
      {if(segm_d==1){
      PORTD.3 = 0;}
      else
      PORTD.3 = 1;}
      {if(segm_e==1){
      PORTD.0 = 0;}
      else
      PORTD.0 = 1;}
      {if(segm_f==1){
      PORTD.7 = 0;}
      else
      PORTD.7 = 1;}
      {if(segm_g==1){
      PORTD.6 = 0;}
      else
      PORTD.6 = 1;}

      //SKAICIU:
      {if(OSC==0){
      PORTB.3 = 0;}
      else              // SKAICIUS NR.0
      PORTB.3 = 1;}

      {if(OSC==4){
      PORTB.5 = 0;}
      else              // SKAICIUS NR.1
      PORTB.5 = 1;}

      {if(OSC==8){
      PORTB.2 = 0;}
      else              // SKAICIUS NR.2
      PORTB.2 = 1;}

      {if(OSC==12){
      PORTB.0 = 0;}
      else              // SKAICIUS NR.3
      PORTB.0 = 1;}

      {if(OSC==16){
      PORTB.1 = 0;}
      else              // SKAICIUS NR.4
      PORTB.1 = 1;}

      {if(OSC==20){
      PORTB.6 = 0;}
      else              // SKAICIUS NR.5
      PORTB.6 = 1;}

      {if(OSC==24){
      PORTB.7 = 0;}
      else              // SKAICIUS NR.6
      PORTB.7 = 1;}

      {if(OSC==28){
      PORTB.4 = 0;}
      else              // SKAICIUS NR.7
      PORTB.4 = 1;}
      }
while (1);}
