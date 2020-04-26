/*****************************************************
Project : PAKROVEJAS
Version : V1.1
Date    : 2010-05-09
Author  : TOMAS

Chip type               : ATmega162
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega162.h>
#include <delay.h>

void main(void){
unsigned int  e, f,c, RAIDE, ISK_PRA_UZL; // UZLAIKYMO ir t.t kintamieji

char OSC; //EKRANO DAZNIS

char MYGTUKAS_1, MYGTUKAS_2, MYGTUKAS_3,MYGTUKAS_4; // MYGTUKAI

unsigned int  viena_minute, minutes, desimtys_minutes,
valandos, desimtys_valandos;//PASKUTINIO ISKROVIMO LAIKAS

unsigned int viena_minute2, minutes2, valandos2;

char segm_a, segm_b, segm_c, segm_d, segm_e, segm_f, 
segm_g,segm_h;   // SEGMENTAI

char ISKROVIMAS, KRAUTI, krovimas, LOAD,BEEPER_OFF, FOULT, 
ISKROVIMO_PRALEIDIMAS, PENKIOS_VALANDOS_PRAEJO; // PADETYS

char ZALIAS, RAUDONAS, GELTONAS; // INDIKATORIAUS SPALVOS

unsigned int trisdesimt_sekundziu; // KROVIMO IR LOAD SUDETAS LAIKAS

unsigned int sesios_sekundes,
taskelio_sekunde;//BEGANCIO TASKELIO LAIKAS

unsigned int foult_laikas, foult_periodas;//begancio foulto laikas

unsigned int DVI_SEKUNDES, VIENA_SEKUNDE, KETURIOS_SEKUNDES,
DESIMT_SEKUNDZIU, VIENUOLIKA_SEKUNDZIU, TRISDESIMT_SEKUNDZIU,
VIENA_MINUTE, PUSE_SEKUNDES; //KONSTANTOS


// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

PORTA=0x00;
DDRA=0x7F;

PORTB=0x00;
DDRB=0x1F;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x3C;
 
PORTE=0x00;
DDRE=0x00;




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
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
MCUCR=0x00;
EMCUCR=0x00;
TIMSK=0x00;
ETIMSK=0x00;
ACSR=0x00;

VIENA_SEKUNDE = 1000; //viena sekunde:
DVI_SEKUNDES = 2*VIENA_SEKUNDE;
KETURIOS_SEKUNDES = 4*VIENA_SEKUNDE;
VIENA_MINUTE = 60*VIENA_SEKUNDE;
DESIMT_SEKUNDZIU = 10*VIENA_SEKUNDE;
VIENUOLIKA_SEKUNDZIU = 11*VIENA_SEKUNDE;
TRISDESIMT_SEKUNDZIU = 30*VIENA_SEKUNDE;
PUSE_SEKUNDES = VIENA_SEKUNDE/2;

krovimas = 1;


      do{
      delay_us(1775);

      //INPUTAI
      if(PINE.0==1){
      MYGTUKAS_1 = 1;}
      if(PINE.2==1){
      MYGTUKAS_2 = 1;}
      if(PIND.7 == 1){
      MYGTUKAS_3 = 1;}
      if(PIND.6 == 1){
      MYGTUKAS_4 = 1;}
      if(PINC.2==1){
      ZALIAS = 1;}
      if(PINC.3==1){
      GELTONAS = 1;}
      if(PINC.1==1){
      RAUDONAS = 1;}
      if(PINC.4==1){
      ISKROVIMO_PRALEIDIMAS = 1;}

      //PIRMINIS MYGTUKU FILTRAVIMAS:
      if(((MYGTUKAS_1==1)&&(MYGTUKAS_2==1))||
      ((MYGTUKAS_1==1)&&(MYGTUKAS_3==1))||
      ((MYGTUKAS_1==1)&&(MYGTUKAS_4==1))||
      ((MYGTUKAS_2==1)&&(MYGTUKAS_3==1))||
      ((MYGTUKAS_2==1)&&(MYGTUKAS_4==1))||
      ((MYGTUKAS_3==1)&&(MYGTUKAS_4==1))){
      MYGTUKAS_1 = 0;
      MYGTUKAS_2 = 0;
      MYGTUKAS_3 = 0;
      MYGTUKAS_4 = 0;}


      //MYGTUKAI
      OSC = OSC + 1;
      if(OSC == 15){
      OSC = 0;}

      if(MYGTUKAS_1==1){
      krovimas = 1;
      ISKROVIMAS = 0;
      if(OSC==0){
      segm_h = 1;}}

      {if((MYGTUKAS_2==1)&&(f<DVI_SEKUNDES)){
      krovimas = 0;
      ISKROVIMAS = 0;
      f = f + 1;}
      else
      f = 0;}
      if((MYGTUKAS_2==1)&&(f==DVI_SEKUNDES)){
      FOULT = 0;}

      {if((MYGTUKAS_3==1)&&(e<DVI_SEKUNDES)){
      e = e + 1;}
      else
      e = 0;}
      if((MYGTUKAS_3==1)&&(e==DVI_SEKUNDES)) {
      ISKROVIMAS = 1;}

      //        PADETYS:
      //RAUDONAS:
      if((RAUDONAS==1)&&(GELTONAS==0)){
      ISKROVIMAS = 0;
      krovimas = 1;}

      //ZALIAS:
      if((ZALIAS==1)&&(GELTONAS==0)){
      krovimas = 0;}

      //FOULT:
      if(c==1){
      FOULT = 1;}
      if(((minutes==0)&&(desimtys_minutes==0)&&(valandos==0)&&
      (desimtys_valandos==0))||(valandos>=3)){
      FOULT = 0;}

      //ISKROVIMAS:
      if((ISKROVIMAS==1)&&(krovimas==0)&&(c==0)){
      c = 1;
      viena_minute = 0;
      minutes = 0;
      desimtys_minutes = 0;
      valandos = 0;
      desimtys_valandos = 0;}

      if(ISKROVIMAS==0){
      c = 0;}

      if(ISKROVIMAS==1){ 
      viena_minute = viena_minute + 1; 
      if(viena_minute==VIENA_MINUTE){
      minutes = minutes + 1;
      viena_minute = 0;} 
      if(minutes==10){
      desimtys_minutes = desimtys_minutes + 1;
      minutes = 0;}
      if(desimtys_minutes==6){
      valandos = valandos + 1;
      desimtys_minutes = 0;} 
      if(valandos == 10){
      desimtys_valandos = desimtys_valandos + 1;
      valandos = 0;}
      if(desimtys_valandos==10){
      desimtys_valandos = 0;}}


      //ISK_PRALEID:           
      if((ISKROVIMO_PRALEIDIMAS==1)&&(ISK_PRA_UZL==0)){
      ISK_PRA_UZL = 1;
      krovimas = 1;
      viena_minute2 = 0;
      minutes2 = 0;
      valandos2 = 0;
      PENKIOS_VALANDOS_PRAEJO = 0;}
      if(ISKROVIMO_PRALEIDIMAS==0){
      ISK_PRA_UZL = 0;}

      if((valandos2==5)&&(minutes2==0)&&
      (PENKIOS_VALANDOS_PRAEJO==0)){
      ISKROVIMAS = 1;
      PENKIOS_VALANDOS_PRAEJO = 1;}

      if(valandos2==120){
      valandos2 = 0;
      viena_minute2 = 0;
      minutes2 = 0;
      ISKROVIMAS = 1;}
            
      viena_minute2 = viena_minute2 + 1;      
      if(viena_minute2==VIENA_MINUTE){
      minutes2 = minutes2 + 1;
      viena_minute2 = 0;}
      if(minutes2==60){
      valandos2 = valandos2 + 1;
      minutes2 = 0;}

      //BEEPERIS:      
      if((viena_minute>=DESIMT_SEKUNDZIU)&&
      (viena_minute<=VIENUOLIKA_SEKUNDZIU)&&(minutes==0)&&
      (desimtys_minutes==0)&&(valandos==0)&&
      (desimtys_valandos==0)){
      BEEPER_OFF = 1;}

      //KROVIMAS:
      {if(krovimas==1){
      ISKROVIMAS = 0;
      if(trisdesimt_sekundziu==TRISDESIMT_SEKUNDZIU){
      trisdesimt_sekundziu = 0;}      
      trisdesimt_sekundziu = trisdesimt_sekundziu + 1;       
      if(trisdesimt_sekundziu<KETURIOS_SEKUNDES){
      LOAD = 1;}
      if(trisdesimt_sekundziu>=KETURIOS_SEKUNDES){
      KRAUTI = 1;}}
      else{
      trisdesimt_sekundziu = 0;}}



      //            VISUALISATION:
      //ISKROVIMAS:
      if((ISKROVIMAS==1)&&(MYGTUKAS_4==0)){
      if(OSC == 0){
      RAIDE = 12;}
      if(OSC == 4){
      RAIDE = 11;}
      if(OSC == 8){
      RAIDE = 13;}
      if(OSC == 12){
      RAIDE = 14;}}


      //KROVIMAS:
      if((KRAUTI==1)&&(MYGTUKAS_4==0)){
      if(OSC == 0){
      RAIDE = 11;}
      if(OSC == 4){
      RAIDE = 13;}
      if(OSC == 8){
      RAIDE = 10;}
      if(OSC == 12){
      RAIDE = 14;}} 


      if((LOAD==1)&&(MYGTUKAS_4==0)){
      if(OSC == 0){
      RAIDE = 15;}
      if(OSC == 4){
      RAIDE = 17;}
      if(OSC == 8){
      RAIDE = 10;}
      if(OSC == 12){
      RAIDE = 12;}}

      //FOULT:
      if(FOULT==1){
      if(foult_periodas==PUSE_SEKUNDES){
      foult_laikas = foult_laikas + 1;
      foult_periodas = 0;}
      foult_periodas = foult_periodas + 1;
      if(foult_laikas==9){
      foult_laikas = 1;}      
      if((krovimas==0)&&(ISKROVIMAS==0)&&(MYGTUKAS_4==0)){            

      if(foult_laikas==1){
      if(OSC==12){
      RAIDE = 16;}}
      if(foult_laikas==2){
      if(OSC==8){
      RAIDE = 16;}
      if(OSC==12){
      RAIDE = 17;}}
      if(foult_laikas==3){
      if(OSC==4){
      RAIDE = 16;}
      if(OSC==8){
      RAIDE = 17;}
      if(OSC==12){
      RAIDE = 20;}}
      if(foult_laikas==4){
      if(OSC==0){
      RAIDE = 16;}
      if(OSC==4){
      RAIDE = 17;}
      if(OSC==8){
      RAIDE = 20;}
      if(OSC==12){
      RAIDE = 15;}}
      if(foult_laikas==5){
      if(OSC==0){
      RAIDE = 17;}
      if(OSC==4){
      RAIDE = 20;}
      if(OSC==8){
      RAIDE = 15;}
      if(OSC==12){
      RAIDE = 18;}}
      if(foult_laikas==6){
      if(OSC==0){
      RAIDE = 20;}
      if(OSC==4){
      RAIDE = 15;}
      if(OSC==8){
      RAIDE = 18;}}
      if(foult_laikas==7){
      if(OSC==0){
      RAIDE = 15;}
      if(OSC==4){
      RAIDE = 18;}}
      if(foult_laikas==8){
      if(OSC==0){
      RAIDE = 18;}}}}



      //PASKUTINIO ISKROVIMO LAIKAS:
      if(MYGTUKAS_4==1){
      if(OSC == 0){
      RAIDE = desimtys_valandos;
      segm_h = 0;}
      if(OSC == 4){
      RAIDE = valandos;
      segm_h = 1;}
      if(OSC == 8){
      RAIDE = desimtys_minutes;
      segm_h = 0;}
      if(OSC == 12){
      RAIDE = minutes;
      segm_h = 0;}}

      //NIEKO NERODO
      if((krovimas==0)&&(ISKROVIMAS==0)&&(FOULT==0)&&
      (MYGTUKAS_4==0)){
      taskelio_sekunde = taskelio_sekunde + 1;
      if(taskelio_sekunde==VIENA_SEKUNDE){
      sesios_sekundes = sesios_sekundes + 1;
      taskelio_sekunde = 0;}
      if(sesios_sekundes==6){
      sesios_sekundes = 0;}

      if((OSC==0)&&(sesios_sekundes==0)){
      segm_h = 1;}
      if((OSC==4)&&((sesios_sekundes==1)||
      (sesios_sekundes==5))){
      segm_h = 1;}
      if((OSC==8)&&((sesios_sekundes==2)||
      (sesios_sekundes==4))){
      segm_h = 1;}
      if((OSC==12)&&(sesios_sekundes==3)){
      segm_h = 1;}}



      //        ADRESAVIMAS I PIN:
      //OUTPUTS:
      //RAIDE==10 "A"
      //RAIDE==11 "c"
      //RAIDE==12 "d"
      //RAIDE==13 "h"
      //RAIDE==14 "r"
      //RAIDE==15 "L"
      //RAIDE==16 "F"
      //RAIDE==17 "o"
      //RAIDE==18 "t"
      //RAIDE==19 " "
      //RAIDE==20 "u"
      if(RAIDE == 0){
      segm_a = 1;
      segm_b = 1;
      segm_c = 1;
      segm_d = 1;
      segm_e = 1;
      segm_f = 1;
      segm_g = 0;}
      if(RAIDE == 1){
      segm_a = 0;
      segm_b = 1;
      segm_c = 1;
      segm_d = 0;
      segm_e = 0;
      segm_f = 0;
      segm_g = 0;}
      if(RAIDE == 2){
      segm_a = 1;
      segm_b = 1;
      segm_c = 0;
      segm_d = 1;
      segm_e = 1;
      segm_f = 0;
      segm_g = 1;}
      if(RAIDE == 3){
      segm_a = 1;
      segm_b = 1;
      segm_c = 1;
      segm_d = 1;
      segm_e = 0;
      segm_f = 0;
      segm_g = 1;}
      if(RAIDE == 4){
      segm_a = 0;
      segm_b = 1;
      segm_c = 1;
      segm_d = 0;
      segm_e = 0;
      segm_f = 1;
      segm_g = 1;}
      if(RAIDE == 5){
      segm_a = 1;
      segm_b = 0;
      segm_c = 1;
      segm_d = 1;
      segm_e = 0;
      segm_f = 1;
      segm_g = 1;}
      if(RAIDE == 6){
      segm_a = 1;
      segm_b = 0;
      segm_c = 1;
      segm_d = 1;
      segm_e = 1;
      segm_f = 1;
      segm_g = 1;}
      if(RAIDE == 7){
      segm_a = 1;
      segm_b = 1;
      segm_c = 1;
      segm_d = 0;
      segm_e = 0;
      segm_f = 0;
      segm_g = 0;}
      if(RAIDE == 8){
      segm_a = 1;
      segm_b = 1;
      segm_c = 1;
      segm_d = 1;
      segm_e = 1;
      segm_f = 1;
      segm_g = 1;}
      if(RAIDE == 9){
      segm_a = 1;
      segm_b = 1;
      segm_c = 1;
      segm_d = 1;
      segm_e = 0;
      segm_f = 1;
      segm_g = 1;}
      if(RAIDE == 10){
      segm_a = 1;
      segm_b = 1;
      segm_c = 1;
      segm_d = 0;
      segm_e = 1;
      segm_f = 1;
      segm_g = 1;}
      if(RAIDE == 11){
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 1;
      segm_e = 1;
      segm_f = 0;
      segm_g = 1;}
      if(RAIDE == 12){
      segm_a = 0;
      segm_b = 1;
      segm_c = 1;
      segm_d = 1;
      segm_e = 1;
      segm_f = 0;
      segm_g = 1;}
      if(RAIDE == 13){
      segm_a = 0;
      segm_b = 0;
      segm_c = 1;
      segm_d = 0;
      segm_e = 1;
      segm_f = 1;
      segm_g = 1;}
      if(RAIDE == 14){
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 0;
      segm_e = 1;
      segm_f = 0;
      segm_g = 1;}
      if(RAIDE == 15){
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 1;
      segm_e = 1;
      segm_f = 1;
      segm_g = 0;}
      if(RAIDE == 16){
      segm_a = 1;
      segm_b = 0;
      segm_c = 0;
      segm_d = 0;
      segm_e = 1;
      segm_f = 1;
      segm_g = 1;}
      if(RAIDE == 17){
      segm_a = 0;
      segm_b = 0;
      segm_c = 1;
      segm_d = 1;
      segm_e = 1;
      segm_f = 0;
      segm_g = 1;}
      if(RAIDE == 18){
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 1;
      segm_e = 1;
      segm_f = 1;
      segm_g = 1;}
      if(RAIDE == 19){
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 0;
      segm_e = 0;
      segm_f = 0;
      segm_g = 0;}
      if(RAIDE == 20){
      segm_a = 0;
      segm_b = 0;
      segm_c = 1;
      segm_d = 1;
      segm_e = 1;
      segm_f = 0;
      segm_g = 0;}

      {if(ISKROVIMAS==1){
      PORTA.3 = 1;}
      else
      PORTA.3 = 0;}

      {if(KRAUTI==1){
      PORTA.0 = 1;}
      else
      PORTA.0 = 0;}

      {if(LOAD==1){
      PORTA.1 = 1;}
      else
      PORTA.1 = 0;}

      {if(BEEPER_OFF==1){
      PORTA.2 = 1;}
      else
      PORTA.2 = 0;}


      //       SEGMENTAI:
      {if(segm_a==1){
      PORTA.6 = 0;}
      else
      PORTA.6 = 1;}
      {if(segm_b==1){
      PORTA.4 = 0;}
      else
      PORTA.4 = 1;}
      {if(segm_c==1){
      PORTB.2 = 0;}
      else
      PORTB.2 = 1;}
      {if(segm_d==1){
      PORTB.4 = 0;}
      else
      PORTB.4 = 1;}
      {if(segm_e==1){
      PORTB.0 = 0;}
      else
      PORTB.0 = 1;}
      {if(segm_f==1){
      PORTA.5 = 0;}
      else
      PORTA.5 = 1;}
      {if(segm_g==1){
      PORTB.1 = 0;}
      else
      PORTB.1 = 1;}
      {if(segm_h==1){
      PORTB.3 = 0;}
      else
      PORTB.3 = 1;}
      //       OSC DAZNIS:
      {if(OSC == 0){
      PORTD.2 = 1;}
      else 
      PORTD.2 = 0;}
      {if(OSC == 4){
      PORTD.4 = 1;}
      else
      PORTD.4 = 0;}
      {if(OSC == 8){
      PORTD.3 = 1;}
      else
      PORTD.3 = 0;}
      {if(OSC == 12){
      PORTD.5 = 1;}
      else
      PORTD.5 = 0;}




      //FILTRAVIMAS
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 0;
      segm_e = 0;
      segm_f = 0;
      segm_g = 0;
      segm_h = 0;
      RAIDE = 19;
      BEEPER_OFF = 0;
      LOAD = 0;
      KRAUTI = 0;
      MYGTUKAS_1 = 0;
      MYGTUKAS_2 = 0;
      MYGTUKAS_3 = 0;
      MYGTUKAS_4 = 0;
      RAUDONAS = 0;
      GELTONAS = 0;
      ZALIAS = 0;
      ISKROVIMO_PRALEIDIMAS = 0;
      }
while (1);}