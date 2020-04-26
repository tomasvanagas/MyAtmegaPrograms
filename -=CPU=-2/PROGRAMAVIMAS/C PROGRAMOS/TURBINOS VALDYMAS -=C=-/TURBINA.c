/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 5/25/2010
Author  : NeVaDa
Company : namai
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <delay.h>
void main(void)
{
char ZEMUTINE_ITAMPA, AUKSTUTINE_ITAMPA, OSC,
KONDENCATORIAUS_ISKROVIMAS,NUOSEKLIAI,LYGIAGRECIAI;

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB.0 = 0;
DDRB.1 = 0;
DDRB.2 = 0;
DDRB.3 = 0;
DDRB.4 = 0;
DDRB.5 = 0;
DDRB.6 = 0;
DDRB.7 = 1;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC.0 = 0;
DDRC.1 = 0;
DDRC.2 = 0;
DDRC.3 = 0;
DDRC.4 = 0;
DDRC.5 = 0;
DDRC.6 = 0;
DDRC.7 = 0;

// Port D initialization
// Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=In Func1=In Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD.0 = 1;
DDRD.1 = 0;
DDRD.2 = 0;
DDRD.3 = 1;
DDRD.4 = 0;
DDRD.5 = 1;
DDRD.6 = 0;
DDRD.7 = 0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

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
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

KONDENCATORIAUS_ISKROVIMAS = 1;


      do{
      delay_ms(10);

          // OSCILATORIUS
      OSC = OSC + 1;
      if(OSC==6){
      OSC = 0;}

          // PROGRAMA
      if(AUKSTUTINE_ITAMPA==1){
      KONDENCATORIAUS_ISKROVIMAS = 1;}

      if(ZEMUTINE_ITAMPA==1){
      KONDENCATORIAUS_ISKROVIMAS = 0;}


      {if((KONDENCATORIAUS_ISKROVIMAS==1)&&(OSC==0)){
      LYGIAGRECIAI = 1;}
      else
      LYGIAGRECIAI = 0;}

      {if((KONDENCATORIAUS_ISKROVIMAS==1)&&(OSC==3)){
      NUOSEKLIAI = 1;}
      else
      NUOSEKLIAI = 0;}


          // ISEJIMAI          
      {if(LYGIAGRECIAI==1){
      PORTD.3 = 1;
      PORTB.7 = 1;}
      else
      PORTD.3 = 0;
      PORTB.7 = 0;}

      {if(NUOSEKLIAI==1){
      PORTD.0 = 1;}
      else
      PORTD.0 = 0;}


            // FILTRAVIMAS
      ZEMUTINE_ITAMPA = 0;
      AUKSTUTINE_ITAMPA = 0;
      }
while(1);}