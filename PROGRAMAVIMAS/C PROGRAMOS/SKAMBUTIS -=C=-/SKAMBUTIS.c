/*****************************************************
Project : Skambutis
Version : v1.1 
Date    : 2010 - 05 - 27
Author  : Tomas Vanagas
E-mail  : tomasvanagas@ymail.com
Tel.    : 8 695 87284 



Mikroschemos pavadinimas      : ATmega32
Mikroschemos taktinis daznis  : 8.000000 MHz
Isorine RAM atmintis          : 0 Baitu
Vidine RAM atmintis           : 512 Baitu
Vidine FLASH atmintis         : 33792 Baitai
*****************************************************/

signed int viena_sekunde1, viena_sekunde2,
viena_sekunde4, penkios_minutes, viena_sekunde5, puse_sekundes;

long int viena_minute5, viena_sekunde3,; 


char PILNAS,TUSCIAS,KROVIMAS,ISKROVIMAS,
BATERIJOS_BUSENA; //AKUMOLIATORIAUS:

char OSC;      //LED DAZNIS:

char 
MYGTUKAS_1, MYGTUKAS_2, MYGTUKAS_3, MYGTUKAS_4,
MYGTUKAS_5, MYGTUKAS_6, MYGTUKAS_7,
MYGTUKAS_PASPAUSTAS;     //MYGTUKAI

char segm_a, segm_b, segm_c, segm_d, segm_e,
segm_f, segm_g, segm_h; // SEGMENTAI

signed char LAIKRODIS, sekundes, minutes, desimtys_minutes, 
valandos, desimtys_valandos; // TIKRO LAIKO KINTAMIEJI

char a; // DUOMENU NESEJO KINTAMASIS

signed char x,y,z,k; // SKAMBUCIO NUSTATYMUI
signed char a2,b2,c2,d2;//ISPEJAMAJAM SKAMBUCIUI(pries pamoka)

signed char b,d,e,f,g,i; // UZLAIKYMO KINTAMIEJI

signed char REDAGAVIMAS, REDAG_SK_NR, 
EILUTES_SKAICIUS, EIL_SK; // PIRMINIAI KINTAMIEJI

char BLYKCIOTI; // KAI REDAGAVIMAS:

char PENKIOLIKA_SEKUNDZIU;// KAI PASIJUNGIA PARASO "HELLO"

char DESIMT_SEKUNDZIU;//KAI TIKRAS LAIKAS RODOMAS:

char SKAMBUTIS_TURETU_SKAMBETI,
Sesios_sekundes, SKAMBUTIS_SKAMBA,
ISPEJAMASIS_SKAMBUTIS; // SKAMBUCIO RELES PRITRAUKIMUI

signed char DB_LAIKO_RODYMAS, UZRAKINTA,UZRAKTO_KODAS_1,
UZRAKTO_KODAS_2,UZRAKTO_KODAS_3,UZRAKTO_KODAS_4, REDAG_UZRAKT_SKAIC,
a1,b1,c1,d1; //     UZRAKTAS

char KELINTADIENIO_PERZIURA, KELINTADIENIS;
signed char KELINTADIENIO_REDAGAVIMAS; // KELINTADIENIS


signed char // Standartiniai skambucio laikai:
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




#include <mega32.h>
#include <delay.h>
void main(void)
{
PORTA = 0;
DDRA = 0b10011000;

PORTB = 0;

DDRB = 0b11111111;

PORTC = 0x00;
DDRC = 0b11111110;

PORTD=0x00;
DDRD = 0b11111111;

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

UZRAKINTA = 1;
KELINTADIENIS = 1;





UZRAKTO_KODAS_1 = 1;
UZRAKTO_KODAS_2 = 9;
UZRAKTO_KODAS_3 = 1;      //UZRAKTO KODAS
UZRAKTO_KODAS_4 = 9;


      do{
      DB_LAIKO_RODYMAS = 1;
      OSC = OSC + 1 ;
      delay_us(10);
      if(OSC==32){
      OSC=0;}


      if(PENKIOLIKA_SEKUNDZIU<15){
      viena_sekunde2 = viena_sekunde2 + 1;
      if(viena_sekunde2==1300){
      PENKIOLIKA_SEKUNDZIU = PENKIOLIKA_SEKUNDZIU + 1;
      viena_sekunde2 = 0;}}

      if(PENKIOLIKA_SEKUNDZIU==2){
      if(OSC==28){
      a = 17;}}      
      if(PENKIOLIKA_SEKUNDZIU==3){
      if(OSC==24){
      a = 17;}
      if(OSC==28){
      a = 15;}}
      if(PENKIOLIKA_SEKUNDZIU==4){
      if(OSC==20){
      a = 17;}
      if(OSC==24){
      a = 15;}
      if(OSC==28){
      a = 22;}}
      if(PENKIOLIKA_SEKUNDZIU==5){
      if(OSC==16){
      a = 17;}
      if(OSC==20){
      a = 15;}
      if(OSC==24){
      a = 22;}
      if(OSC==28){
      a = 22;}}
      if(PENKIOLIKA_SEKUNDZIU==6){
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
      if(PENKIOLIKA_SEKUNDZIU==7){
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
      if(PENKIOLIKA_SEKUNDZIU==8){
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
      if(PENKIOLIKA_SEKUNDZIU==9){
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
      if(PENKIOLIKA_SEKUNDZIU==10){
      if(OSC==0){
      a = 15;}
      if(OSC==4){
      a = 22;}
      if(OSC==8){
      a = 22;}
      if(OSC==12){
      a = 0;}}
      if(PENKIOLIKA_SEKUNDZIU==11){
      if(OSC==0){
      a = 22;}
      if(OSC==4){
      a = 22;}
      if(OSC==8){
      a = 0;}}
      if(PENKIOLIKA_SEKUNDZIU==12){
      if(OSC==0){
      a = 22;}
      if(OSC==4){
      a = 0;}}
      if(PENKIOLIKA_SEKUNDZIU==13){
      if(OSC==0){
      a = 0;}}

      if(PENKIOLIKA_SEKUNDZIU==15){
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

      {if((PINC.0==1)&&(i==0)&&(REDAGAVIMAS==0)){
      LAIKRODIS = 1;
      i = 1;}
      else
      LAIKRODIS = 0;}

      if(PINC.0==0){
      i = 0;}
      //AKUMOLIATORIAUS KROVIMAS IR ISKROVIMAS:
      {if(PINA.5==1){
      PILNAS = 1;
      if(OSC==0){
      segm_h = 1;}}
      else
      PILNAS = 0;}

      {if(PINA.6==0){
      TUSCIAS = 1;
      if(OSC==4){
      segm_h = 1;}}
      else
      TUSCIAS = 0;}

      if(PILNAS==1){
      KROVIMAS = 0;}

      if(TUSCIAS==1){
      ISKROVIMAS = 0;
      KROVIMAS = 1;}

      if((KELINTADIENIS==6)&&(desimtys_valandos==0)&&(valandos==0)
      &&(desimtys_minutes==0)&&(minutes==0)&&(KROVIMAS==0)){
      ISKROVIMAS = 1;}


      //KAI REDAGUOJAMAS TIKRAS LAIKAS IR TADA ISSAUGOJAMA sekundes = 0;
      if((EILUTES_SKAICIUS==0)&&(MYGTUKAS_3==1)&&(REDAGAVIMAS==1)){
      sekundes = 0;}
      //                           UZRAKINIMAS:

      if((EILUTES_SKAICIUS==0)&&(MYGTUKAS_7==1)&&
      (KELINTADIENIO_PERZIURA==0)){
      UZRAKINTA = 1;}

      if(UZRAKINTA==0){
      viena_sekunde4 = viena_sekunde4 + 1;
      if(viena_sekunde4==2000){
      penkios_minutes = penkios_minutes + 1;
      viena_sekunde4 = 0;}
      if(penkios_minutes==60){
      UZRAKINTA = 1;
      penkios_minutes = 0;}

      if((MYGTUKAS_1==1)||(MYGTUKAS_2==1)||(MYGTUKAS_3==1)||
      (MYGTUKAS_4==1)||(MYGTUKAS_5==1)||(MYGTUKAS_6==1)||
      (MYGTUKAS_7==1)){
      viena_sekunde4 = 0;
      penkios_minutes = 0;}}


      if(UZRAKINTA==1){      
      if((MYGTUKAS_1==1)||(MYGTUKAS_2==1)||(MYGTUKAS_3==1)||
      (MYGTUKAS_4==1)||(MYGTUKAS_5==1)||(MYGTUKAS_6==1)){
      viena_minute5 = 20000;}
      if(MYGTUKAS_7==1){
      viena_minute5 = 0;}

      if(viena_minute5==0){
      REDAG_UZRAKT_SKAIC = 0;
      a1 = 0;
      b1 = 0;
      c1 = 0;
      d1 = 0;}

      if(viena_minute5!=0){
      DB_LAIKO_RODYMAS = 0;
      viena_minute5 = viena_minute5 - 1;
      if(OSC==0){
      a = 10;}
      if(OSC==4){
      a = 26;}
      if(OSC==8){
      a = 30;}
      if(OSC==12){
      a = 10;}
      if(OSC==16){
      if(REDAG_UZRAKT_SKAIC==0){
      a = a1;}
      if(REDAG_UZRAKT_SKAIC!=0){
      a = 32;}}
      if(OSC==20){
      if(REDAG_UZRAKT_SKAIC==1){
      a = b1;}
      if(REDAG_UZRAKT_SKAIC!=1){
      a = 32;}}
      if(OSC==24){
      if(REDAG_UZRAKT_SKAIC==2){
      a = c1;}
      if(REDAG_UZRAKT_SKAIC!=2){
      a = 32;}}
      if(OSC==28){
      if(REDAG_UZRAKT_SKAIC==3){
      a = d1;}
      if(REDAG_UZRAKT_SKAIC!=3){
      a = 32;
      }}

      if(MYGTUKAS_1==1){
      if(REDAG_UZRAKT_SKAIC==0){
      a1 = a1 + 1;}
      if(REDAG_UZRAKT_SKAIC==1){
      b1 = b1 + 1;}
      if(REDAG_UZRAKT_SKAIC==2){
      c1 = c1 + 1;}
      if(REDAG_UZRAKT_SKAIC==3){
      d1 = d1 + 1;}}
      if(MYGTUKAS_5==1){
      if(REDAG_UZRAKT_SKAIC==0){
      a1 = a1 - 1;}
      if(REDAG_UZRAKT_SKAIC==1){
      b1 = b1 - 1;}
      if(REDAG_UZRAKT_SKAIC==2){
      c1 = c1 - 1;}
      if(REDAG_UZRAKT_SKAIC==3){
      d1 = d1 - 1;}}
      if(MYGTUKAS_2==1){
      REDAG_UZRAKT_SKAIC = REDAG_UZRAKT_SKAIC - 1;}
      if(MYGTUKAS_4==1){
      REDAG_UZRAKT_SKAIC = REDAG_UZRAKT_SKAIC + 1;}

      if(REDAG_UZRAKT_SKAIC==-1){
      REDAG_UZRAKT_SKAIC = 3;}
      if(REDAG_UZRAKT_SKAIC==4){
      REDAG_UZRAKT_SKAIC = 0;}



      if(a1==-1){
      a1 = 9;}
      if(b1==-1){
      b1 = 9;}
      if(c1==-1){
      c1 = 9;}
      if(d1==-1){
      d1 = 9;}
      if(a1==10){
      a1 = 0;}
      if(b1==10){
      b1 = 0;}
      if(c1==10){
      c1 = 0;}
      if(d1==10){
      d1 = 0;}}}

      if((MYGTUKAS_3==1)&&(viena_minute5!=0)){
      if(
      (UZRAKTO_KODAS_1==a1)&&
      (UZRAKTO_KODAS_2==b1)&&
      (UZRAKTO_KODAS_3==c1)&&
      (UZRAKTO_KODAS_4==d1)){
      UZRAKINTA = 0;
      viena_minute5 = 0;
      a1 = 0;
      b1 = 0;
      c1 = 0;
      d1 = 0;
      REDAG_UZRAKT_SKAIC = 0;
      DB_LAIKO_RODYMAS = 1;}}

      if(UZRAKINTA==1){
      EILUTES_SKAICIUS = 0;
      REDAGAVIMAS = 0;
      MYGTUKAS_1 = 0;
      MYGTUKAS_2 = 0;
      MYGTUKAS_3 = 0;
      MYGTUKAS_4 = 0;
      MYGTUKAS_5 = 0;      
      MYGTUKAS_6 = 0;
      MYGTUKAS_7 = 0;
      KELINTADIENIO_PERZIURA = 0;
      KELINTADIENIO_REDAGAVIMAS = 0;}

      //Baterijos busena;
      if((REDAGAVIMAS==0)&&(KELINTADIENIO_REDAGAVIMAS==0)){

      if((EILUTES_SKAICIUS==0)&&(BATERIJOS_BUSENA==0)&&
      (MYGTUKAS_4==1)){
      BATERIJOS_BUSENA = 1;
      MYGTUKAS_4 = 0;}

      if((EILUTES_SKAICIUS==0)&&(BATERIJOS_BUSENA==1)&&
      ((MYGTUKAS_1==1)||(MYGTUKAS_2==1)||(MYGTUKAS_3==1)||
      (MYGTUKAS_4==1)||(MYGTUKAS_5==1)||(MYGTUKAS_6==1)||
      (MYGTUKAS_7==1))){
      BATERIJOS_BUSENA = 0;
      MYGTUKAS_1 = 0;
      MYGTUKAS_2 = 0;
      MYGTUKAS_3 = 0;
      MYGTUKAS_4 = 0;
      MYGTUKAS_5 = 0;      
      MYGTUKAS_6 = 0;
      MYGTUKAS_7 = 0;}

      if(BATERIJOS_BUSENA==1){
      DB_LAIKO_RODYMAS = 0;
      if(KROVIMAS==1){
      if(OSC==0){
      a = 12;}
      if(OSC==4){
      a = 18;}
      if(OSC==8){
      a = 10;}
      if(OSC==12){
      a = 30;}}
      if(ISKROVIMAS==1){
      if(OSC==0){
      a = 14;}
      if(OSC==4){
      a = 12;}
      if(OSC==8){
      a = 18;}
      if(OSC==12){
      a = 30;}}
      if(TUSCIAS==1){
      if(OSC==16){
      a = 26;}
      if(OSC==20){
      a = 27;}
      if(OSC==24){
      a = 5;}
      if(OSC==28){
      a = 12;}}
      if((TUSCIAS==0)&&(PILNAS==0)){
      if(OSC==16){
      a = 24;}
      if(OSC==20){
      a = 28;}
      if(OSC==24){
      a = 5;}
      if(OSC==28){
      a = 15;}}
      if(PILNAS==1){
      if(OSC==16){
      a = 26;}
      if(OSC==20){
      a = 1;}
      if(OSC==24){
      a = 22;}
      if(OSC==28){
      a = 34;}}}}

      //KELINTADIENIO NUSTATYMAI:
      if((DB_LAIKO_RODYMAS==1)&&(REDAGAVIMAS==0)&&
      (MYGTUKAS_2==1)&&(EILUTES_SKAICIUS==0)){
      KELINTADIENIO_PERZIURA = 1;}

      if(KELINTADIENIO_PERZIURA==1){
      DB_LAIKO_RODYMAS = 0;
      REDAGAVIMAS = 0;
      EILUTES_SKAICIUS = 0;}

      if((KELINTADIENIO_PERZIURA==1)&&
      (KELINTADIENIO_REDAGAVIMAS==0)&&
      ((MYGTUKAS_1==1)||(MYGTUKAS_3==1)||
      (MYGTUKAS_4==1)||(MYGTUKAS_5==1)||(MYGTUKAS_7==1))){
      KELINTADIENIO_PERZIURA = 0;
      KELINTADIENIO_REDAGAVIMAS = 0;} 

      if((KELINTADIENIO_PERZIURA==1)&&(MYGTUKAS_6==1)&&
      (KELINTADIENIO_REDAGAVIMAS==0)){
      KELINTADIENIO_REDAGAVIMAS = 1;
      MYGTUKAS_6 = 0;}

      if((KELINTADIENIO_PERZIURA==1)&&((MYGTUKAS_6==1)||
      (MYGTUKAS_3==1))&&(KELINTADIENIO_REDAGAVIMAS==1)){
      KELINTADIENIO_REDAGAVIMAS = 0;
      MYGTUKAS_6 = 0;}

      if((desimtys_valandos==0)&&(valandos==0)&&
      (desimtys_minutes==0)&&(minutes==0)&&(sekundes==0)&&
      (LAIKRODIS==1)){
      KELINTADIENIS = KELINTADIENIS + 1;}

      if((KELINTADIENIO_REDAGAVIMAS==1)&&(MYGTUKAS_1==1)){
      KELINTADIENIS = KELINTADIENIS + 1;}

      if((KELINTADIENIO_REDAGAVIMAS==1)&&(MYGTUKAS_5==1)){
      KELINTADIENIS = KELINTADIENIS - 1;}

      if(KELINTADIENIS==0){
      KELINTADIENIS = 7;}

      if(KELINTADIENIS==8){
      KELINTADIENIS = 1;}

      if((KELINTADIENIO_PERZIURA==1)&&(BATERIJOS_BUSENA==0)){
      if(OSC==0){
      a = KELINTADIENIS;}
      if(OSC==4){
      a = 32;}
      if(OSC==8){
      a = 14;}
      if(OSC==12){
      a = 20;}
      if(OSC==16){
      a = 15;}
      if(OSC==20){ 
      a = 34;}
      if(OSC==24){
      a = 20;}
      if(OSC==28){
      a = 5;}
      MYGTUKAS_1 = 0;
      MYGTUKAS_2 = 0;
      MYGTUKAS_3 = 0;
      MYGTUKAS_4 = 0;
      MYGTUKAS_5 = 0;
      MYGTUKAS_6 = 0;}

      if((KELINTADIENIO_REDAGAVIMAS==1)&&(BLYKCIOTI==1)){
      a = 33;}



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
      if((LAIKRODIS==1)&&(REDAGAVIMAS==0)){
      sekundes = sekundes + 2;}

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

      //EILUTES SKAICIAUS NUSTATYMAS:
      if(REDAGAVIMAS==0){
      if(MYGTUKAS_1==1){
      if((EILUTES_SKAICIUS!=20)&&(g==0)){
      EILUTES_SKAICIUS = EILUTES_SKAICIUS + 1;
      g = 1;}
      if((EILUTES_SKAICIUS==20)&&(g==0)){
      EILUTES_SKAICIUS = 1;
      g = 1;}}
      if(MYGTUKAS_5==1){
      if((EILUTES_SKAICIUS<=1)&&(g==0)){
      EILUTES_SKAICIUS = 20;
      g = 1;}
      if((EILUTES_SKAICIUS>=2)&&(g==0)){
      EILUTES_SKAICIUS = EILUTES_SKAICIUS - 1;
      g = 1;}}
      g = 0;
      if(MYGTUKAS_7){
      EILUTES_SKAICIUS = 0;}}
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



      //skambucio laiko redagavimas:
       if(EILUTES_SKAICIUS==0){
      d = 0;
      e = 0;}


      if(EILUTES_SKAICIUS!=0){
      d = EILUTES_SKAICIUS/10;
      e = EILUTES_SKAICIUS - d*10;}

      {if(EILUTES_SKAICIUS!=EIL_SK){
      f = 1;}
      else
      f = 0;}

      EIL_SK = EILUTES_SKAICIUS;

      if((EILUTES_SKAICIUS==1)&&(f==1)){
      x = SKAMBUTIS_1dh;
      y = SKAMBUTIS_1h;
      z = SKAMBUTIS_1dm;
      k = SKAMBUTIS_1m;}
      if((EILUTES_SKAICIUS==2)&&(f==1)){
      x = SKAMBUTIS_2dh;
      y = SKAMBUTIS_2h;
      z = SKAMBUTIS_2dm;
      k = SKAMBUTIS_2m;}
      if((EILUTES_SKAICIUS==3)&&(f==1)){
      x = SKAMBUTIS_3dh;
      y = SKAMBUTIS_3h;
      z = SKAMBUTIS_3dm;
      k = SKAMBUTIS_3m;}
      if((EILUTES_SKAICIUS==4)&&(f==1)){
      x = SKAMBUTIS_4dh;
      y = SKAMBUTIS_4h;
      z = SKAMBUTIS_4dm;
      k = SKAMBUTIS_4m;}
      if((EILUTES_SKAICIUS==5)&&(f==1)){
      x = SKAMBUTIS_5dh;
      y = SKAMBUTIS_5h;
      z = SKAMBUTIS_5dm;
      k = SKAMBUTIS_5m;}
      if((EILUTES_SKAICIUS==6)&&(f==1)){
      x = SKAMBUTIS_6dh;
      y = SKAMBUTIS_6h;
      z = SKAMBUTIS_6dm;
      k = SKAMBUTIS_6m;}
      if((EILUTES_SKAICIUS==7)&&(f==1)){
      x = SKAMBUTIS_7dh;
      y = SKAMBUTIS_7h;
      z = SKAMBUTIS_7dm;
      k = SKAMBUTIS_7m;}
      if((EILUTES_SKAICIUS==8)&&(f==1)){
      x = SKAMBUTIS_8dh;
      y = SKAMBUTIS_8h;
      z = SKAMBUTIS_8dm;
      k = SKAMBUTIS_8m;}
      if((EILUTES_SKAICIUS==9)&&(f==1)){
      x = SKAMBUTIS_9dh;
      y = SKAMBUTIS_9h;
      z = SKAMBUTIS_9dm;
      k = SKAMBUTIS_9m;}
      if((EILUTES_SKAICIUS==10)&&(f==1)){
      x = SKAMBUTIS_10dh;
      y = SKAMBUTIS_10h;
      z = SKAMBUTIS_10dm;
      k = SKAMBUTIS_10m;}
      if((EILUTES_SKAICIUS==11)&&(f==1)){
      x = SKAMBUTIS_11dh;
      y = SKAMBUTIS_11h;
      z = SKAMBUTIS_11dm;
      k = SKAMBUTIS_11m;}
      if((EILUTES_SKAICIUS==12)&&(f==1)){
      x = SKAMBUTIS_12dh;
      y = SKAMBUTIS_12h;
      z = SKAMBUTIS_12dm;
      k = SKAMBUTIS_12m;}
      if((EILUTES_SKAICIUS==13)&&(f==1)){
      x = SKAMBUTIS_13dh;
      y = SKAMBUTIS_13h;
      z = SKAMBUTIS_13dm;
      k = SKAMBUTIS_13m;}
      if((EILUTES_SKAICIUS==14)&&(f==1)){
      x = SKAMBUTIS_14dh;
      y = SKAMBUTIS_14h;
      z = SKAMBUTIS_14dm;
      k = SKAMBUTIS_14m;}
      if((EILUTES_SKAICIUS==15)&&(f==1)){
      x = SKAMBUTIS_15dh;
      y = SKAMBUTIS_15h;
      z = SKAMBUTIS_15dm;
      k = SKAMBUTIS_15m;}
      if((EILUTES_SKAICIUS==16)&&(f==1)){
      x = SKAMBUTIS_16dh;
      y = SKAMBUTIS_16h;
      z = SKAMBUTIS_16dm;
      k = SKAMBUTIS_16m;}
      if((EILUTES_SKAICIUS==17)&&(f==1)){
      x = SKAMBUTIS_17dh;
      y = SKAMBUTIS_17h;
      z = SKAMBUTIS_17dm;
      k = SKAMBUTIS_17m;}
      if((EILUTES_SKAICIUS==18)&&(f==1)){
      x = SKAMBUTIS_18dh;
      y = SKAMBUTIS_18h;
      z = SKAMBUTIS_18dm;
      k = SKAMBUTIS_18m;}
      if((EILUTES_SKAICIUS==19)&&(f==1)){
      x = SKAMBUTIS_19dh;
      y = SKAMBUTIS_19h;
      z = SKAMBUTIS_19dm;
      k = SKAMBUTIS_19m;}
      if((EILUTES_SKAICIUS==20)&&(f==1)){
      x = SKAMBUTIS_20dh;
      y = SKAMBUTIS_20h;
      z = SKAMBUTIS_20dm;
      k = SKAMBUTIS_20m;}

      if((EILUTES_SKAICIUS!=0)&&(REDAGAVIMAS==1)){
      if((MYGTUKAS_1==1)&&(REDAG_SK_NR==3)){
      k = k + 1;}
      if((MYGTUKAS_5==1)&&(REDAG_SK_NR==3)){
      k = k - 1;}
      if((MYGTUKAS_1==1)&&(REDAG_SK_NR==2)){
      z = z + 1;}
      if((MYGTUKAS_5==1)&&(REDAG_SK_NR==2)){
      z = z - 1;}
      if((MYGTUKAS_1==1)&&(REDAG_SK_NR==1)){
      y = y + 1;}
      if((MYGTUKAS_5==1)&&(REDAG_SK_NR==1)){
      y = y - 1;}
      if((MYGTUKAS_1==1)&&(REDAG_SK_NR==0)){
      x = x + 1;}
      if((MYGTUKAS_5==1)&&(REDAG_SK_NR==0)){
      x = x - 1;}

      if(k==-1){
      k = 9;}
      if(z==-1){
      z = 5;}
      if((y==-1)&&(x==2)){
      y = 3;}
      if((y==-1)&&(x!=2)){
      y = 9;}
      if((x==-1)&&(y >3)){
      x = 1;}
      if((x==-1)&&(y<4)){
      x = 2;} 

      if(k==10){
      k = 0;}
      if(z==6){
      z = 0;}
      if((y>=4)&&(x==2)&&(REDAG_SK_NR==1)){
      y = 0;}
      if((y==10)&&(x!=2)){
      y = 0;}
      if((x==2)&&(y>=4)&&(REDAG_SK_NR==0)){
      x = 0;}
      if(x==3){
      x = 0;}}

      if(MYGTUKAS_3==1){
      if(EILUTES_SKAICIUS==1){
      SKAMBUTIS_1dh = x;
      SKAMBUTIS_1h  = y;
      SKAMBUTIS_1dm = z;
      SKAMBUTIS_1m  = k;}
      if(EILUTES_SKAICIUS==2){
      SKAMBUTIS_2dh = x;
      SKAMBUTIS_2h  = y;
      SKAMBUTIS_2dm = z;
      SKAMBUTIS_2m  = k;}
      if(EILUTES_SKAICIUS==3){
      SKAMBUTIS_3dh = x;
      SKAMBUTIS_3h  = y;
      SKAMBUTIS_3dm = z;
      SKAMBUTIS_3m  = k;}
      if(EILUTES_SKAICIUS==4){
      SKAMBUTIS_4dh = x;
      SKAMBUTIS_4h  = y;
      SKAMBUTIS_4dm = z;
      SKAMBUTIS_4m  = k;}
      if(EILUTES_SKAICIUS==5){
      SKAMBUTIS_5dh = x;
      SKAMBUTIS_5h  = y;
      SKAMBUTIS_5dm = z;
      SKAMBUTIS_5m  = k;}
      if(EILUTES_SKAICIUS==6){
      SKAMBUTIS_6dh = x;
      SKAMBUTIS_6h  = y;
      SKAMBUTIS_6dm = z;
      SKAMBUTIS_6m  = k;}
      if(EILUTES_SKAICIUS==7){
      SKAMBUTIS_7dh = x;
      SKAMBUTIS_7h  = y;
      SKAMBUTIS_7dm = z;
      SKAMBUTIS_7m  = k;}
      if(EILUTES_SKAICIUS==8){
      SKAMBUTIS_8dh = x;
      SKAMBUTIS_8h  = y;
      SKAMBUTIS_8dm = z;
      SKAMBUTIS_8m  = k;}
      if(EILUTES_SKAICIUS==9){
      SKAMBUTIS_9dh = x;
      SKAMBUTIS_9h  = y;
      SKAMBUTIS_9dm = z;
      SKAMBUTIS_9m  = k;}
      if(EILUTES_SKAICIUS==10){
      SKAMBUTIS_10dh = x;
      SKAMBUTIS_10h  = y;
      SKAMBUTIS_10dm = z;
      SKAMBUTIS_10m  = k;}
      if(EILUTES_SKAICIUS==11){
      SKAMBUTIS_11dh = x;
      SKAMBUTIS_11h  = y;
      SKAMBUTIS_11dm = z;
      SKAMBUTIS_11m  = k;}
      if(EILUTES_SKAICIUS==12){
      SKAMBUTIS_12dh = x;
      SKAMBUTIS_12h  = y;
      SKAMBUTIS_12dm = z;
      SKAMBUTIS_12m  = k;}
      if(EILUTES_SKAICIUS==13){
      SKAMBUTIS_13dh = x;
      SKAMBUTIS_13h  = y;
      SKAMBUTIS_13dm = z;
      SKAMBUTIS_13m  = k;}
      if(EILUTES_SKAICIUS==14){
      SKAMBUTIS_14dh = x;
      SKAMBUTIS_14h  = y;
      SKAMBUTIS_14dm = z;
      SKAMBUTIS_14m  = k;}
      if(EILUTES_SKAICIUS==15){
      SKAMBUTIS_15dh = x;
      SKAMBUTIS_15h  = y;
      SKAMBUTIS_15dm = z;
      SKAMBUTIS_15m  = k;}
      if(EILUTES_SKAICIUS==16){
      SKAMBUTIS_16dh = x;
      SKAMBUTIS_16h  = y;
      SKAMBUTIS_16dm = z;
      SKAMBUTIS_16m  = k;}
      if(EILUTES_SKAICIUS==17){
      SKAMBUTIS_17dh = x;
      SKAMBUTIS_17h  = y;
      SKAMBUTIS_17dm = z;
      SKAMBUTIS_17m  = k;}
      if(EILUTES_SKAICIUS==18){
      SKAMBUTIS_18dh = x;
      SKAMBUTIS_18h  = y;
      SKAMBUTIS_18dm = z;
      SKAMBUTIS_18m  = k;}
      if(EILUTES_SKAICIUS==19){
      SKAMBUTIS_19dh = x;
      SKAMBUTIS_19h  = y;
      SKAMBUTIS_19dm = z;
      SKAMBUTIS_19m  = k;}
      if(EILUTES_SKAICIUS==20){
      SKAMBUTIS_20dh = x;
      SKAMBUTIS_20h  = y;
      SKAMBUTIS_20dm = z;
      SKAMBUTIS_20m  = k;}}

      // RELES PRITRAUKIMAS:
      // ispejamasis skambutis:
      a2 = desimtys_valandos;
      b2 = valandos;
      c2 = desimtys_minutes;
      d2 = minutes + 2;

      if(d2==10){
      d2 = 0;
      c2 = c2 + 1;}
      if(c2==6){
      c2 = 0;
      b2 = b2 + 1;}
      if(b2==10){
      b2 = 0;
      a2 = a2 + 1;}
      if((a2==2)&&(b2==4)){
      a2 = 0;
      b2 = 0;}


      //ispejamojo skambucio reles pritraukimas
      if((SKAMBUTIS_1dh==a2)&&
      (SKAMBUTIS_1h==b2)&&
      (SKAMBUTIS_1dm==c2)&&
      (SKAMBUTIS_1m==d2)){
      ISPEJAMASIS_SKAMBUTIS = 1;}

      if((SKAMBUTIS_3dh==a2)&&
      (SKAMBUTIS_3h==b2)&&
      (SKAMBUTIS_3dm==c2)&&
      (SKAMBUTIS_3m==d2)){
      ISPEJAMASIS_SKAMBUTIS = 1;}

      if((SKAMBUTIS_5dh==a2)&&
      (SKAMBUTIS_5h==b2)&&
      (SKAMBUTIS_5dm==c2)&&
      (SKAMBUTIS_5m==d2)){
      ISPEJAMASIS_SKAMBUTIS = 1;}

      if((SKAMBUTIS_7dh==a2)&&
      (SKAMBUTIS_7h==b2)&&
      (SKAMBUTIS_7dm==c2)&&
      (SKAMBUTIS_7m==d2)){
      ISPEJAMASIS_SKAMBUTIS = 1;}

      if((SKAMBUTIS_9dh==a2)&&
      (SKAMBUTIS_9h==b2)&&
      (SKAMBUTIS_9dm==c2)&&
      (SKAMBUTIS_9m==d2)){
      ISPEJAMASIS_SKAMBUTIS = 1;}

      if((SKAMBUTIS_11dh==a2)&&
      (SKAMBUTIS_11h==b2)&&
      (SKAMBUTIS_11dm==c2)&&
      (SKAMBUTIS_11m==d2)){
      ISPEJAMASIS_SKAMBUTIS = 1;}

      if((SKAMBUTIS_13dh==a2)&&
      (SKAMBUTIS_13h==b2)&&
      (SKAMBUTIS_13dm==c2)&&
      (SKAMBUTIS_13m==d2)){
      ISPEJAMASIS_SKAMBUTIS = 1;}

      if((SKAMBUTIS_15dh==a2)&&
      (SKAMBUTIS_15h==b2)&&
      (SKAMBUTIS_15dm==c2)&&
      (SKAMBUTIS_15m==d2)){
      ISPEJAMASIS_SKAMBUTIS = 1;}

      if((SKAMBUTIS_17dh==a2)&&
      (SKAMBUTIS_17h==b2)&&
      (SKAMBUTIS_17dm==c2)&&
      (SKAMBUTIS_17m==d2)){
      ISPEJAMASIS_SKAMBUTIS = 1;}

      if((SKAMBUTIS_19dh==a2)&&
      (SKAMBUTIS_19h==b2)&&
      (SKAMBUTIS_19dm==c2)&&
      (SKAMBUTIS_19m==d2)){
      ISPEJAMASIS_SKAMBUTIS = 1;}


      if((ISPEJAMASIS_SKAMBUTIS==1)&&(puse_sekundes!=700)&&
      (REDAGAVIMAS==0)){
      puse_sekundes = puse_sekundes + 1;
      SKAMBUTIS_SKAMBA = 1;}

      if(ISPEJAMASIS_SKAMBUTIS==0){
      puse_sekundes = 0;}

      //tikras_skambutis:
      if((SKAMBUTIS_1dh==desimtys_valandos)&&
      (SKAMBUTIS_1h==valandos)&&
      (SKAMBUTIS_1dm==desimtys_minutes)&&
      (SKAMBUTIS_1m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_2dh==desimtys_valandos)&&
      (SKAMBUTIS_2h==valandos)&&
      (SKAMBUTIS_2dm==desimtys_minutes)&&
      (SKAMBUTIS_2m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_3dh==desimtys_valandos)&&
      (SKAMBUTIS_3h==valandos)&&
      (SKAMBUTIS_3dm==desimtys_minutes)&&
      (SKAMBUTIS_3m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_4dh==desimtys_valandos)&&
      (SKAMBUTIS_4h==valandos)&&
      (SKAMBUTIS_4dm==desimtys_minutes)&&
      (SKAMBUTIS_4m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_5dh==desimtys_valandos)&&
      (SKAMBUTIS_5h==valandos)&&
      (SKAMBUTIS_5dm==desimtys_minutes)&&
      (SKAMBUTIS_5m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_6dh==desimtys_valandos)&&
      (SKAMBUTIS_6h==valandos)&&
      (SKAMBUTIS_6dm==desimtys_minutes)&&
      (SKAMBUTIS_6m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_7dh==desimtys_valandos)&&
      (SKAMBUTIS_7h==valandos)&&
      (SKAMBUTIS_7dm==desimtys_minutes)&&
      (SKAMBUTIS_7m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_8dh==desimtys_valandos)&&
      (SKAMBUTIS_8h==valandos)&&
      (SKAMBUTIS_8dm==desimtys_minutes)&&
      (SKAMBUTIS_8m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_9dh==desimtys_valandos)&&
      (SKAMBUTIS_9h==valandos)&&
      (SKAMBUTIS_9dm==desimtys_minutes)&&
      (SKAMBUTIS_9m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_10dh==desimtys_valandos)&&
      (SKAMBUTIS_10h==valandos)&&
      (SKAMBUTIS_10dm==desimtys_minutes)&&
      (SKAMBUTIS_10m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_11dh==desimtys_valandos)&&
      (SKAMBUTIS_11h==valandos)&&
      (SKAMBUTIS_11dm==desimtys_minutes)&&
      (SKAMBUTIS_11m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_12dh==desimtys_valandos)&&
      (SKAMBUTIS_12h==valandos)&&
      (SKAMBUTIS_12dm==desimtys_minutes)&&
      (SKAMBUTIS_12m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_13dh==desimtys_valandos)&&
      (SKAMBUTIS_13h==valandos)&&
      (SKAMBUTIS_13dm==desimtys_minutes)&&
      (SKAMBUTIS_13m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_14dh==desimtys_valandos)&&
      (SKAMBUTIS_14h==valandos)&&
      (SKAMBUTIS_14dm==desimtys_minutes)&&
      (SKAMBUTIS_14m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_15dh==desimtys_valandos)&&
      (SKAMBUTIS_15h==valandos)&&
      (SKAMBUTIS_15dm==desimtys_minutes)&&
      (SKAMBUTIS_15m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_16dh==desimtys_valandos)&&
      (SKAMBUTIS_16h==valandos)&&
      (SKAMBUTIS_16dm==desimtys_minutes)&&
      (SKAMBUTIS_16m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_17dh==desimtys_valandos)&&
      (SKAMBUTIS_17h==valandos)&&
      (SKAMBUTIS_17dm==desimtys_minutes)&&
      (SKAMBUTIS_17m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_18dh==desimtys_valandos)&&
      (SKAMBUTIS_18h==valandos)&&
      (SKAMBUTIS_18dm==desimtys_minutes)&&
      (SKAMBUTIS_18m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_19dh==desimtys_valandos)&&
      (SKAMBUTIS_19h==valandos)&&
      (SKAMBUTIS_19dm==desimtys_minutes)&&
      (SKAMBUTIS_19m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if((SKAMBUTIS_20dh==desimtys_valandos)&&
      (SKAMBUTIS_20h==valandos)&&
      (SKAMBUTIS_20dm==desimtys_minutes)&&
      (SKAMBUTIS_20m==minutes)){
      SKAMBUTIS_TURETU_SKAMBETI = 1;}

      if(SKAMBUTIS_TURETU_SKAMBETI==0){
      Sesios_sekundes = 0;}

      if((SKAMBUTIS_TURETU_SKAMBETI==1)&&(Sesios_sekundes!=6)){
      viena_sekunde3 = viena_sekunde3 + 1;}

      if(viena_sekunde3==1000){
      Sesios_sekundes = Sesios_sekundes + 1;
      viena_sekunde3 = 0;}

      if((Sesios_sekundes!=0)&&(Sesios_sekundes!=6)&&
      (REDAGAVIMAS==0)){
      SKAMBUTIS_SKAMBA = 1;}


      //VISUAL:
      if(DB_LAIKO_RODYMAS==1){
      //tikras laikas:
      if(EILUTES_SKAICIUS==0){

      viena_sekunde5 = viena_sekunde5 + 1;
      if(viena_sekunde5==1000){
      DESIMT_SEKUNDZIU = DESIMT_SEKUNDZIU + 1;
      viena_sekunde5 = 0;}
      if(DESIMT_SEKUNDZIU==10){
      DESIMT_SEKUNDZIU = 0;}

      if(DESIMT_SEKUNDZIU==1){
      if(OSC==12){
      a = 14;}}

      if(DESIMT_SEKUNDZIU==2){
      if(OSC==8){
      a = 14;}
      if(OSC==12){
      a = 10;}}

      if(DESIMT_SEKUNDZIU==3){
      if(OSC==4){
      a = 14;}
      if(OSC==8){
      a = 10;}
      if(OSC==12){
      a = 11;}}

      if(DESIMT_SEKUNDZIU==4){
      if(OSC==0){
      a = 14;}
      if(OSC==4){
      a = 10;}
      if(OSC==8){
      a = 11;}
      if(OSC==12){
      a = 10;}}

      if(DESIMT_SEKUNDZIU==5){
      if(OSC==0){
      a = 10;}
      if(OSC==4){
      a = 11;}
      if(OSC==8){
      a = 10;}
      if(OSC==12){
      a = 30;}}

      if(DESIMT_SEKUNDZIU==6){
      if(OSC==0){
      a = 11;}
      if(OSC==4){
      a = 10;}
      if(OSC==8){
      a = 30;}}

      if(DESIMT_SEKUNDZIU==7){
      if(OSC==0){
      a = 10;}
      if(OSC==4){
      a = 30;}}

      if(DESIMT_SEKUNDZIU==8){
      if(OSC==0){
      a = 30;}}

      if(OSC==16){
      a = desimtys_valandos;}
      if(OSC==20){
      a = valandos;
      segm_h = 1;}
      if(OSC==24){
      a = desimtys_minutes;}
      if(OSC==28){
      a = minutes;}

      if((PINC.0==1)&&(OSC==12)){
      segm_h = 1;}}}
      //skambucio laikas:
      if(EILUTES_SKAICIUS!=0){
      viena_sekunde5 = 0;
      if(OSC==0){
      a = 25;}
      if(OSC==4){
      a = 26;
      segm_h = 1;}
      if(OSC==8){
      a = d;}
      if(OSC==12){
      a = e;
      segm_h = 1;}
      if(OSC==16){
      a = x;}
      if(OSC==20){
      a = y;
      segm_h = 1;}
      if(OSC==24){
      a = z;}
      if(OSC==28){
      a = k;}}
      

      //BLYKCIOJIMAS:
      viena_sekunde1 = viena_sekunde1 + 1;
      if((viena_sekunde1==1000)&&(BLYKCIOTI==0)){
      BLYKCIOTI = 1;
      viena_sekunde1 = 0;}
      if((viena_sekunde1==1000)&&(BLYKCIOTI==1)){
      BLYKCIOTI = 0;
      viena_sekunde1 = 0;}



      if((REDAGAVIMAS==1)&&(REDAG_SK_NR==0)&&(BLYKCIOTI==1)){
      if(OSC==16){ 
      a = 33;}}
      if((REDAGAVIMAS==1)&&(REDAG_SK_NR==1)&&(BLYKCIOTI==1)){
      if(OSC==20){ 
      a = 33;}}
      if((REDAGAVIMAS==1)&&(REDAG_SK_NR==2)&&(BLYKCIOTI==1)){
      if(OSC==24){ 
      a = 33;}}
      if((REDAGAVIMAS==1)&&(REDAG_SK_NR==3)&&(BLYKCIOTI==1)){
      if(OSC==28){ 
      a = 33;}}}

      //KAI UZRAKINTA SVIESTI TASKELI
      if(UZRAKINTA==1){
      if(OSC==28){
      segm_h = 1;}}

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
      if(a ==34){
      segm_a = 0;
      segm_b = 0;
      segm_c = 1;
      segm_d = 0;
      segm_e = 1;
      segm_f = 0;
      segm_g = 1;}
                  

      //            ISEJIMAI:
      // RELES:
      {if((SKAMBUTIS_SKAMBA==1)&&(KELINTADIENIS<=5)){
      PORTC.1 = 1;}
      else
      PORTC.1 = 0;}

      {if(ISKROVIMAS==1){
      PORTA.3 = 1;}
      else
      PORTA.3 = 0;}

      {if(KROVIMAS==1){
      PORTA.4 = 1;}
      else
      PORTA.4 = 0;}

      //SEGMENTU
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
      {if(segm_h==1){
      PORTD.4 = 0;}
      else
      PORTD.4 = 1;}

      //SKAICIU:
      {if(OSC==0){
      PORTB.3 = 1;}
      else              // SKAICIUS NR.0
      PORTB.3 = 0;}

      {if(OSC==4){
      PORTB.5 = 1;}
      else              // SKAICIUS NR.1
      PORTB.5 = 0;}

      {if(OSC==8){
      PORTB.2 = 1;}
      else              // SKAICIUS NR.2
      PORTB.2 = 0;}

      {if(OSC==12){
      PORTB.0 = 1;}
      else              // SKAICIUS NR.3
      PORTB.0 = 0;}

      {if(OSC==16){
      PORTB.1 = 1;}
      else              // SKAICIUS NR.4
      PORTB.1 = 0;}

      {if(OSC==20){
      PORTB.6 = 1;}
      else              // SKAICIUS NR.5
      PORTB.6 = 0;}

      {if(OSC==24){
      PORTB.7 = 1;}
      else              // SKAICIUS NR.6
      PORTB.7 = 0;}

      {if(OSC==28){
      PORTB.4 = 1;}
      else              // SKAICIUS NR.7
      PORTB.4 = 0;}

      //PIRMINIS FILTRAVIMAS:
      SKAMBUTIS_TURETU_SKAMBETI = 0;
      a = 33;
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 0;
      segm_e = 0;
      segm_f = 0;
      segm_g = 0;
      segm_h = 0;
      DB_LAIKO_RODYMAS = 1;
      SKAMBUTIS_SKAMBA = 0;
      ISPEJAMASIS_SKAMBUTIS = 0;      
      }
while (1);}
