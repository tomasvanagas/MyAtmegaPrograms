/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 7/12/2015
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega2561
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 2048
*****************************************************/

#include <mega2561.h>
#include <delay.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x02 ;PORTA
#endasm
#include <lcd.h>

char NumToIndex(char Num){
    if(Num==0){     return '0';}
    else if(Num==1){return '1';}
    else if(Num==2){return '2';}
    else if(Num==3){return '3';}
    else if(Num==4){return '4';}
    else if(Num==5){return '5';}
    else if(Num==6){return '6';}
    else if(Num==7){return '7';}
    else if(Num==8){return '8';}
    else if(Num==9){return '9';}
    else{           return '-';}
return 0;
}

char lcd_put_number(char Type, char Lenght, char IsSign, 

                    char NumbersAfterDot,

                    unsigned long int Number0,
                    signed long int Number1){
    if(Lenght>0){                   
    unsigned long int k = 1;
    unsigned char i;               
        for(i=0;i<Lenght-1;i++) k = k*10;

        if(Type==0){
        unsigned long int a;
        unsigned char b;
        a = Number0;
         
            if(IsSign==1){
            lcd_putchar('+'); 
            }

            if(a<0){
            a = a*(-1);
            }
            
            if(k*10<a){
            a = k*10 - 1;
            }
            
            for(i=0;i<Lenght;i++){
                if(NumbersAfterDot!=0){
                    if(Lenght-NumbersAfterDot==i){
                    lcd_putchar('.');
                    }
                }
            b = a/k;                      
            lcd_putchar( NumToIndex( b ) );                 
            a = a - b*k;
            k = k/10;
            }
        return 1; 
        }

        else if(Type==1){
        signed long int a;
        unsigned char b;
        a = Number1;
         
            if(IsSign==1){
                if(a>=0){
                lcd_putchar('+');
                }
                else{
                lcd_putchar('-');
                } 
            }

            if(a<0){
            a = a*(-1);
            }
            
            if(k*10<a){
            a = k*10 - 1;
            }
            
            for(i=0;i<Lenght;i++){
                if(NumbersAfterDot!=0){
                    if(Lenght-NumbersAfterDot==i){
                    lcd_putchar('.');
                    }
                }
            b = a/k;                      
            lcd_putchar( NumToIndex( b ) );                 
            a = a - b*k;
            k = k/10;
            }
        return 1; 
        }
    }        
return 0;
}






#define ADC_VREF_TYPE 0x00

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=(adc_input & 0x07) | (ADC_VREF_TYPE & 0xff);
if (adc_input & 0x08) ADCSRB |= 0x08;
else ADCSRB &= 0xf7;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

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

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTE=0x00;
DDRE=0x00;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State5=T State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
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
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=FFh
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=0x00;
TCCR2A=0x00;
TCCR2B=0x00;
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=FFFFh
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
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
OCR3CH=0x00;
OCR3CL=0x00;

// Timer/Counter 4 initialization
// Clock source: System Clock
// Clock value: Timer4 Stopped
// Mode: Normal top=FFFFh
// OC4A output: Discon.
// OC4B output: Discon.
// OC4C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer4 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR4A=0x00;
TCCR4B=0x00;
TCNT4H=0x00;
TCNT4L=0x00;
ICR4H=0x00;
ICR4L=0x00;
OCR4AH=0x00;
OCR4AL=0x00;
OCR4BH=0x00;
OCR4BL=0x00;
OCR4CH=0x00;
OCR4CL=0x00;

// Timer/Counter 5 initialization
// Clock source: System Clock
// Clock value: Timer5 Stopped
// Mode: Normal top=FFFFh
// OC5A output: Discon.
// OC5B output: Discon.
// OC5C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer5 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR5A=0x00;
TCCR5B=0x00;
TCNT5H=0x00;
TCNT5L=0x00;
ICR5H=0x00;
ICR5L=0x00;
OCR5AH=0x00;
OCR5AL=0x00;
OCR5BH=0x00;
OCR5BL=0x00;
OCR5CH=0x00;
OCR5CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;
// PCINT0 interrupt: Off
// PCINT1 interrupt: Off
// PCINT2 interrupt: Off
// PCINT3 interrupt: Off
// PCINT4 interrupt: Off
// PCINT5 interrupt: Off
// PCINT6 interrupt: Off
// PCINT7 interrupt: Off
// PCINT8 interrupt: Off
// PCINT9 interrupt: Off
// PCINT10 interrupt: Off
// PCINT11 interrupt: Off
// PCINT12 interrupt: Off
// PCINT13 interrupt: Off
// PCINT14 interrupt: Off
// PCINT15 interrupt: Off
// PCINT16 interrupt: Off
// PCINT17 interrupt: Off
// PCINT18 interrupt: Off
// PCINT19 interrupt: Off
// PCINT20 interrupt: Off
// PCINT21 interrupt: Off
// PCINT22 interrupt: Off
// PCINT23 interrupt: Off
PCMSK0=0x00;
PCMSK1=0x00;
PCMSK2=0x00;
PCICR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x00;
// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=0x00;
// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=0x00;
// Timer/Counter 3 Interrupt(s) initialization
TIMSK3=0x00;
// Timer/Counter 4 Interrupt(s) initialization
TIMSK4=0x00;
// Timer/Counter 5 Interrupt(s) initialization
TIMSK5=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
ADCSRB=0x00;

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: None
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
// ADC4: On, ADC5: On, ADC6: On, ADC7: On
DIDR0=0x00;
// Digital input buffers on ADC8: On, ADC9: On, ADC10: On, ADC11: On
// ADC12: On, ADC13: On, ADC14: On, ADC15: On
DIDR2=0x00;
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

// LCD module initialization
lcd_init(20);

    while(1){     
    static unsigned char stand_by_pos[2];
    stand_by_pos[0]++;

        if(stand_by_pos[0]>=225){
        stand_by_pos[0] = 0;
        stand_by_pos[1]++;
            if(stand_by_pos[1]>=44){
            stand_by_pos[1] = 0;
            }

        lcd_clear();
            if(stand_by_pos[1]==0){lcd_gotoxy(0,2);lcd_putchar('|');lcd_gotoxy(0,1);lcd_putchar('|');lcd_gotoxy(0,0);lcd_putchar('^');}    
            else if(stand_by_pos[1]==1){lcd_gotoxy(0,1);lcd_putchar('|');lcd_gotoxy(0,0);lcd_putsf("+>");}
            else if((stand_by_pos[1]>=2)&&(stand_by_pos[1]<=19)){lcd_gotoxy(stand_by_pos[1]-2,0);lcd_putsf("-->");}
            else if(stand_by_pos[1]==20){lcd_gotoxy(18,0);lcd_putsf("-+");lcd_gotoxy(19,1);lcd_putchar('v');}
            else if(stand_by_pos[1]==21){lcd_gotoxy(19,0);lcd_putchar('|');lcd_gotoxy(19,1);lcd_putchar('|');lcd_gotoxy(19,2);lcd_putchar('v');}
            else if(stand_by_pos[1]==22){lcd_gotoxy(19,1);lcd_putchar('|');lcd_gotoxy(19,2);lcd_putchar('|');lcd_gotoxy(19,3);lcd_putchar('v');}
            else if(stand_by_pos[1]==23){lcd_gotoxy(19,2);lcd_putchar('|');lcd_gotoxy(18,3);lcd_putsf("<+");}
            else if((stand_by_pos[1]>=24)&&(stand_by_pos[1]<=41)){lcd_gotoxy(17-stand_by_pos[1]+24,3);lcd_putsf("<--");}
            else if(stand_by_pos[1]==42){lcd_gotoxy(0,2);lcd_putchar('^');lcd_gotoxy(0,3);lcd_putsf("+-");}
            else if(stand_by_pos[1]==43){lcd_gotoxy(0,1);lcd_putchar('^');lcd_gotoxy(0,2);lcd_putchar('|');lcd_gotoxy(0,3);lcd_putchar('|');}

        lcd_gotoxy(1,1);
        lcd_putsf("     "); 
        lcd_put_number(0,2,0,0,/*RealTimeHour*/19,0);
        lcd_putsf(":");
        lcd_put_number(0,2,0,0,/*RealTimeMinute*/59,0);
        lcd_putsf(":");
        lcd_put_number(0,2,0,0,/*RealTimeSecond*/59,0);    
        lcd_putsf("     ");

        lcd_gotoxy(1,2);     
        lcd_putsf("    2");
        lcd_put_number(0,3,0,0,/*RealTimeYear*/2015,0);
        lcd_putsf(".");
        lcd_put_number(0,2,0,0,/*RealTimeMonth*/07,0);
        lcd_putsf(".");
        lcd_put_number(0,2,0,0,/*RealTimeDay*/12,0);
        lcd_putsf("    ");
        }
    delay_ms(500);
    };
}
