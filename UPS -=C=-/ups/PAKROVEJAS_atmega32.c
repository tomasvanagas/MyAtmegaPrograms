/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.5b Evaluation
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 4/9/2010
Author  : Freeware, for evaluation and non-commercial use only
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <delay.h>
  
void main(void){
signed int viena_sekunde, viena_sekunde2 ,viena_sekunde3, 
viena_sekunde4, b, e, f;

char  a, c, d; // UZLAIKYMO ir t.t kintamieji

char OSC; //EKRANO DAZNIS

char MYGTUKAS_1, MYGTUKAS_2, MYGTUKAS_3,MYGTUKAS_4; // MYGTUKAI

char  sekundes, minutes, desimtys_minutes,
valandos, desimtys_valandos;//PASKUTINIO ISKROVIMO LAIKAS

char sekundes2, minutes2, desimtys_minutes2, valandos2;

char segm_a, segm_b, segm_c, segm_d, segm_e, segm_f, 
segm_g,segm_h;   // SEGMENTAI

char ISKROVIMAS, KRAUTI, krovimas, LOAD,
BEEPER_OFF, FOULT, ISKROVIMO_PRALEIDIMAS; // PADETYS

char ZALIAS, RAUDONAS, GELTONAS; // INDIKATORIAUS SPALVOS

char trisdesimt_sekundziu; // KROVIMO IR LOAD SUDETAS LAIKAS

char sesios_sekundes; //BEGANCIO TASKELIO LAIKAS



// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA = 0x00;
DDRA.0=0;
DDRA.1=1;
DDRA.2=1;
DDRA.3=1;
DDRA.4=1;
DDRA.5=0;
DDRA.6=0;
DDRA.7=0;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB = 0x00;
DDRB.0=1;
DDRB.1=1;
DDRB.2=1;
DDRB.3=1;
DDRB.4=1;
DDRB.5=1;
DDRB.6=1;
DDRB.7=1;

// Port C initialization
// Func7=In Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=0 State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC = 0x00;
DDRC.0 = 0;
DDRC.1 = 0;
DDRC.2 = 0;
DDRC.3 = 0;
DDRC.4 = 0;
DDRC.5 = 0;
DDRC.6 = 1;
DDRC.7 = 0;

// Port D initialization
// Func7=In Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=0 State5=T State4=T State3=T State2=T State1=0 State0=0 
PORTD=0x00;
DDRD.0 = 1;
DDRD.1 = 1;
DDRD.2 = 0;
DDRD.3 = 0;
DDRD.4 = 0;
DDRD.5 = 0;
DDRD.6 = 1;
DDRD.7 = 0;

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
ACSR=0x00;
SFIOR=0x00;


krovimas = 1;

      
      do{
      b = 1000; //viena sekunde:
      delay_us(500);

      //INPUTAI
      if(PINA.6==1){
      MYGTUKAS_1 = 1;}

      if(PINC.7==1){
      MYGTUKAS_2 = 1;}

      if(PIND.3 == 1){
      MYGTUKAS_3 = 1;}

      if(PIND.2 == 1){
      MYGTUKAS_4 = 1;}

      if(PINC.1==1){
      ZALIAS = 1;}

      if(PIND.7==1){
      GELTONAS = 1;}

      if(PINC.0==1){
      RAUDONAS = 1;}

      if(PINA.7==1){
      ISKROVIMO_PRALEIDIMAS = 1;}

      //MYGTUKAI
      OSC = OSC + 1;
      if(OSC == 15){
      OSC = 0;}

      if(MYGTUKAS_1==1){
      krovimas = 1;
      ISKROVIMAS = 0;
      viena_sekunde2 = 0;
      sekundes2 = 0;
      minutes2 = 0;
      desimtys_minutes2 = 0;
      valandos2 = 0;
      segm_h = 1;}

      {if((MYGTUKAS_2==1)&&(f<2000)){
      krovimas = 0;
      ISKROVIMAS = 0;
      f = f + 1;}
      else
      f = 0;}
      if((MYGTUKAS_2==1)&&(f==2000)){
      FOULT = 0;}

      {if((MYGTUKAS_3==1)&&(e<2000)){
      e = e + 1;}
      else
      e = 0;}
      if((MYGTUKAS_3==1)&&(e==2000)) {
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
      if((ISKROVIMAS==0)&&(c==1)){
      FOULT = 1;}

      //ISKROVIMAS:
      if((ISKROVIMAS==1)&&(krovimas==0)&&(c==0)){
      viena_sekunde = 0;
      sekundes = 0;
      minutes = 0;
      desimtys_minutes = 0;
      valandos = 0;
      desimtys_valandos = 0;
      c = 1;}

      {if((ISKROVIMAS==1)&&(krovimas==0)){ 
      viena_sekunde = viena_sekunde + 1; 
      if(viena_sekunde==b){ 
      sekundes = sekundes + 1; 
      viena_sekunde = 0;} 
      if(sekundes == 60){
      minutes = minutes + 1;
      sekundes = 0;} 
      if(minutes == 10){
      desimtys_minutes = desimtys_minutes + 1;
      minutes = 0;}
      if(desimtys_minutes == 6){
      valandos = valandos + 1;
      desimtys_minutes = 0;} 
      if(valandos == 10){
      desimtys_valandos = desimtys_valandos + 1;
      valandos = 0;}
      if(desimtys_valandos==10){
      desimtys_valandos = 0;}}
      else 
      c = 0;}


      //ISK_PRALEID:            
      if((ISKROVIMO_PRALEIDIMAS==1)&&(d==0)){
      krovimas = 1;
      viena_sekunde2 = 0;
      sekundes2 = 0;
      minutes2 = 0;
      valandos2 = 0;}
      if((ISKROVIMO_PRALEIDIMAS==0)&&(d==1)){
      d = 0;}

      if((valandos2==5)&&(minutes2==0)&&(sekundes2==0)){
      ISKROVIMAS = 1;
      c = 1;}

      if((valandos2==120)&&(minutes2==0)&&(sekundes2==0)&&
      (krovimas==0)){
      ISKROVIMAS = 1;
      c = 1;}      
                  
      viena_sekunde2 = viena_sekunde2 + 1; 
      if(viena_sekunde2==b){
      sekundes2 = sekundes2 + 1;
      viena_sekunde2 = 0;} 
      if(sekundes2==60){
      minutes2 = minutes2 + 1;
      sekundes2 = 0;}
      if(minutes2==60){
      valandos2 = valandos2 + 1;
      minutes2 = 0;}

      if(valandos2==120){
      viena_sekunde2 = 0;
      sekundes2 = 0;
      minutes2 = 0;
      valandos2 = 0;}

      //BEEPERIS:      
      if((sekundes==10)&&(minutes==0)&&
      (desimtys_minutes==0)&&(valandos==0)&&
      (desimtys_valandos==0)){
      BEEPER_OFF = 1;}

      //KROVIMAS:
      if(krovimas==1){
      ISKROVIMAS = 0;
      viena_sekunde3 = viena_sekunde3 + 1;
      if(viena_sekunde3 == b){
      trisdesimt_sekundziu = trisdesimt_sekundziu + 1;
      viena_sekunde3 = 0;} 
      if(trisdesimt_sekundziu < 4){
      LOAD = 1;}
      if(trisdesimt_sekundziu > 3){
      KRAUTI = 1;}
      if(trisdesimt_sekundziu==30){
      trisdesimt_sekundziu = -1;}}
      if(krovimas==0){
      viena_sekunde3 = 0;
      trisdesimt_sekundziu = 0;}

      //            VISUALISATION:
      //ISKROVIMAS:
      if((ISKROVIMAS==1)&&(krovimas==0)&&
      (MYGTUKAS_4==0)){
      if(OSC == 0){
      a = 12;}
      if(OSC == 4){
      a = 11;}
      if(OSC == 8){
      a = 13;}
      if(OSC == 12){
      a = 14;}}


      //KROVIMAS:
      if((KRAUTI==1)&&(ISKROVIMAS==0)&&(MYGTUKAS_4==0)){
      if(OSC == 0){
      a = 11;}
      if(OSC == 4){
      a = 13;}
      if(OSC == 8){
      a = 10;}
      if(OSC == 12){
      a = 14;}} 


      if((LOAD==1)&&(ISKROVIMAS==0)&&(MYGTUKAS_4==0)){
      if(OSC == 0){
      a = 15;}
      if(OSC == 4){
      a = 17;}
      if(OSC == 8){
      a = 10;}
      if(OSC == 12){
      a = 12;}}

      //FOULT:
      if((minutes!=0)&&(desimtys_minutes!=0)&&(valandos!=0)&&
      (desimtys_valandos==0)&&(valandos<3)&&(krovimas==0)&&
      (ISKROVIMAS==0)&&(MYGTUKAS_4==0)&&(FOULT == 1)){
      if(OSC == 0){
      a = 16;}
      if(OSC == 4){
      a = 17;}
      if(OSC == 8){
      a = 15;}
      if(OSC == 12){
      a = 18;}}

      //PASKUTINIO ISKROVIMO LAIKAS:
      if(MYGTUKAS_4==1){
      if(OSC == 0){
      a = desimtys_valandos;
      segm_h = 0;}
      if(OSC == 4){
      a = valandos;
      segm_h = 1;}
      if(OSC == 8){
      a = desimtys_minutes;
      segm_h = 0;}
      if(OSC == 12){
      a = minutes;
      segm_h = 0;}}

      //NIEKO NERODO
      if((krovimas==0)&&(ISKROVIMAS==0)&&(FOULT==0)&&
      (MYGTUKAS_4==0)){
      viena_sekunde4 = viena_sekunde4 + 1;
      if(viena_sekunde4==b){
      sesios_sekundes = sesios_sekundes + 1;
      viena_sekunde4 = 0;}
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
      //a==10 "A"
      //a==11 "c"
      //a==12 "d"
      //a==13 "h"
      //a==14 "r"
      //a==15 "L"
      //a==16 "F"
      //a==17 "o"
      //a==18 "t"
      //a==19 " "
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
      if(a == 10){
      segm_a = 1;
      segm_b = 1;
      segm_c = 1;
      segm_d = 0;
      segm_e = 1;
      segm_f = 1;
      segm_g = 1;}
      if(a == 11){
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 1;
      segm_e = 1;
      segm_f = 0;
      segm_g = 1;}
      if(a == 12){
      segm_a = 0;
      segm_b = 1;
      segm_c = 1;
      segm_d = 1;
      segm_e = 1;
      segm_f = 0;
      segm_g = 1;}
      if(a == 13){
      segm_a = 0;
      segm_b = 0;
      segm_c = 1;
      segm_d = 0;
      segm_e = 1;
      segm_f = 1;
      segm_g = 1;}
      if(a == 14){
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 0;
      segm_e = 1;
      segm_f = 0;
      segm_g = 1;}
      if(a == 15){
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 1;
      segm_e = 1;
      segm_f = 1;
      segm_g = 0;}
      if(a == 16){
      segm_a = 1;
      segm_b = 0;
      segm_c = 0;
      segm_d = 0;
      segm_e = 1;
      segm_f = 1;
      segm_g = 1;}
      if(a == 17){
      segm_a = 0;
      segm_b = 0;
      segm_c = 1;
      segm_d = 1;
      segm_e = 1;
      segm_f = 0;
      segm_g = 1;}
      if(a == 18){
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 1;
      segm_e = 1;
      segm_f = 1;
      segm_g = 1;}
      if(a == 19){
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 0;
      segm_e = 0;
      segm_f = 0;
      segm_g = 0;}

      {if(ISKROVIMAS==1){
      PORTA.4 = 1;}
      else
      PORTA.4 = 0;}

      {if(KRAUTI==1){
      PORTA.1 = 1;}
      else
      PORTA.1 = 0;}

      {if(LOAD==1){
      PORTA.2 = 1;}
      else
      PORTA.2 = 0;}

      {if(BEEPER_OFF==1){
      PORTA.3 = 1;}
      else
      PORTA.3 = 0;}


      //       SEGMENTAI:
      {if(segm_a==1){
      PORTB.7 = 0;}
      else
      PORTB.7 = 1;}
      {if(segm_b==1){
      PORTB.5 = 0;}
      else
      PORTB.5 = 1;}
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
      PORTB.6 = 0;}
      else
      PORTB.6 = 1;}
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
      PORTC.6 = 1;}
      else 
      PORTC.6 = 0;}
      {if(OSC == 4){
      PORTD.0 = 1;}
      else
      PORTD.0 = 0;}
      {if(OSC == 8){
      PORTD.6 = 1;}
      else
      PORTD.6 = 0;}
      {if(OSC == 12){
      PORTD.1 = 1;}
      else
      PORTD.1 = 0;}




      //FILTRAVIMAS
      segm_a = 0;
      segm_b = 0;
      segm_c = 0;
      segm_d = 0;
      segm_e = 0;
      segm_f = 0;
      segm_g = 0;
      segm_h = 0;
      a = 19;
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
      }
while (1);}