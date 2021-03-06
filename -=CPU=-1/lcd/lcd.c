/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 4/16/2011
Author  : NeVaDa
Company : namai
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>
#include <delay.h>

// Declare your global variables here
unsigned int Timer1;
void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

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

// LCD module initialization
lcd_init(16);

    while (1){
    char Padetis;
    Timer1++;
    Padetis = Timer1/200;
        if(Timer1>=5800){
        Timer1 = 0;
        }
        if(Padetis*200==Timer1){
        lcd_clear();
            if(Padetis==1){      lcd_puts("               T");}
            else if(Padetis==2){ lcd_puts("              To");}
            else if(Padetis==3){ lcd_puts("             Tom");}
            else if(Padetis==4){ lcd_puts("            Toma");}
            else if(Padetis==5){ lcd_puts("           Tomas");}
            else if(Padetis==6){ lcd_puts("          Tomas ");}
            else if(Padetis==7){ lcd_puts("         Tomas V");}
            else if(Padetis==8){ lcd_puts("        Tomas Va");}
            else if(Padetis==9){ lcd_puts("       Tomas Van");}
            else if(Padetis==10){lcd_puts("      Tomas Vana");}
            else if(Padetis==11){lcd_puts("     Tomas Vanag");}
            else if(Padetis==12){lcd_puts("    Tomas Vanaga");}
            else if(Padetis==13){lcd_puts("   Tomas Vanagas");}
            else if(Padetis==14){lcd_puts("  Tomas Vanagas ");}
            else if(Padetis==15){lcd_puts(" Tomas Vanagas  ");}
            else if(Padetis==16){lcd_puts("Tomas Vanagas   ");}
            else if(Padetis==17){lcd_puts("omas Vanagas    ");}
            else if(Padetis==18){lcd_puts("mas Vanagas     ");}
            else if(Padetis==19){lcd_puts("as Vanagas      ");}
            else if(Padetis==20){lcd_puts("s Vanagas       ");}
            else if(Padetis==21){lcd_puts(" Vanagas        ");}
            else if(Padetis==22){lcd_puts("Vanagas         ");}
            else if(Padetis==23){lcd_puts("anagas          ");}
            else if(Padetis==24){lcd_puts("nagas           ");}
            else if(Padetis==25){lcd_puts("agas            ");}
            else if(Padetis==26){lcd_puts("gas             ");}
            else if(Padetis==27){lcd_puts("as              ");}
            else if(Padetis==28){lcd_puts("s               ");}
        }
    delay_ms(1);
    };
}
