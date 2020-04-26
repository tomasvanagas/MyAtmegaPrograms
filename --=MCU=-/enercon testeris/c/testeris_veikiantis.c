/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2015.07.16
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega16.h>
#include <delay.h>

// Sinusoides ciklas 
// A fazes kilimas nuo 0 iki 44 leidimasis nuo 45 iki 89, apsivertimas ir tada 
// leidimasis nuo 90 iki 134,  kylimas nuo 135 iki 179.
// B fazes kilimas nuo 60 iki 104 leidimasis nuo 105 iki 149, apsivertimas ir tada 
// leidimasis nuo 150 iki 14,  kylimas nuo 15 iki 59.
// C fazes kilimas nuo 120 iki 164 leidimasis nuo 165 iki 29, apsivertimas ir tada 
// leidimasis nuo 30 iki 74,  kylimas nuo 75 iki 119.
unsigned char SIN_CIKLAS; // 0-179 pakopu


// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>

unsigned char NumToIndex(char Num){
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

unsigned char lcd_put_number(char Type, char Lenght, char IsSign,

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



unsigned char GALINGUMAS; // galingumas nuo 0 iki 255 (0-100%)
unsigned char UPDATE_LCD;
int lcd_update_skaitiklis, sek_skaitiklis,  DAZNIS, daznio_skaitiklis;


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
lcd_update_skaitiklis++;
        if(lcd_update_skaitiklis==200){
        lcd_update_skaitiklis = 0;
        UPDATE_LCD = 1;
        }

sek_skaitiklis++;
    if(sek_skaitiklis>=1961){
    UPDATE_LCD = 1;  
    DAZNIS = daznio_skaitiklis;
    sek_skaitiklis = 0;
    daznio_skaitiklis = 0;
    }
}











#define ADC_VREF_TYPE 0x60

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}












// Declare your global variables here

void main(void){
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=0 State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x08;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=T State5=0 State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xA0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: Phase correct PWM top=FFh
// OC0 output: Non-Inverted PWM
TCCR0=0x62;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: Ph. correct PWM top=00FFh
// OC1A output: Non-Inv.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x81;
TCCR1B=0x02;
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
// Clock value: 1000,000 kHz
// Mode: Phase correct PWM top=FFh
// OC2 output: Non-Inverted PWM
ASSR=0x00;
TCCR2=0x62;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 62,500 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: None
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x87;


// Global enable interrupts
#asm("sei")


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////// LCD module initialization ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
lcd_init(20);
static unsigned char pos;
    while(pos<44){
    lcd_clear();
        if(pos==0){lcd_gotoxy(0,2);lcd_putchar('/');lcd_gotoxy(0,1);lcd_putchar('/');lcd_gotoxy(0,0);lcd_putchar('^');}
        else if(pos==1){lcd_gotoxy(0,1);lcd_putchar('/');lcd_gotoxy(0,0);lcd_putsf("+>");}
        else if((pos>=2)&&(pos<=19)){lcd_gotoxy(pos-2,0);lcd_putsf("-->");}
        else if(pos==20){lcd_gotoxy(18,0);lcd_putsf("-+");lcd_gotoxy(19,1);lcd_putchar('v');}
        else if(pos==21){lcd_gotoxy(19,0);lcd_putchar('/');lcd_gotoxy(19,1);lcd_putchar('/');lcd_gotoxy(19,2);lcd_putchar('v');}
        else if(pos==22){lcd_gotoxy(19,1);lcd_putchar('/');lcd_gotoxy(19,2);lcd_putchar('/');lcd_gotoxy(19,3);lcd_putchar('v');}
        else if(pos==23){lcd_gotoxy(19,2);lcd_putchar('/');lcd_gotoxy(18,3);lcd_putsf("<+");}
        else if((pos>=24)&&(pos<=41)){lcd_gotoxy(17-pos+24,3);lcd_putsf("<--");}
        else if(pos==42){lcd_gotoxy(0,2);lcd_putchar('^');lcd_gotoxy(0,3);lcd_putsf("+-");}
        else if(pos==43){lcd_gotoxy(0,1);lcd_putchar('^');lcd_gotoxy(0,2);lcd_putchar('/');lcd_gotoxy(0,3);lcd_putchar('/');}

    lcd_gotoxy(1,1);
    lcd_putsf("  TopEnerga IGBT  ");
    lcd_gotoxy(1,2);
    lcd_putsf("     TESTERIS     ");
            
                
    delay_ms(70);
    pos++;
    }    
lcd_clear(); 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
OCR0 = 128;
OCR1A = 128;
OCR2 = 128;
// Sinusoides ciklas 
// A fazes kilimas nuo 0 iki 44 leidimasis nuo 45 iki 89, apsivertimas ir tada 
// leidimasis nuo 90 iki 134,  kylimas nuo 135 iki 179.
// B fazes kilimas nuo 60 iki 104 leidimasis nuo 105 iki 149, apsivertimas ir tada 
// leidimasis nuo 150 iki 14,  kylimas nuo 15 iki 59.
// C fazes kilimas nuo 120 iki 164 leidimasis nuo 165 iki 29, apsivertimas ir tada 
// leidimasis nuo 30 iki 74,  kylimas nuo 75 iki 119.


//static unsigned char DAZNIS; // daznis nuo 0 iki 255 (0-x Hz)   =>

static unsigned char i,a;


    while(1){
    

        
    SIN_CIKLAS++;
        if(SIN_CIKLAS>=180){
        SIN_CIKLAS = 0; 
        daznio_skaitiklis++;       
        }

    GALINGUMAS = 1;
  
        // A fazes kilimas nuo 0 iki 44 leidimasis nuo 45 iki 89, apsivertimas ir tada 
        // leidimasis nuo 90 iki 134,  kylimas nuo 135 iki 179.        
        if((SIN_CIKLAS>0)&&(SIN_CIKLAS<=45)){
        OCR0 = (SIN_CIKLAS * 2);  
        }
        else if((SIN_CIKLAS>45)&&(SIN_CIKLAS<90)){
        OCR0 = ((45 - (SIN_CIKLAS-45) ) * 2);
        }
        else{
        OCR0 = 0;
        }

    


        // B fazes kilimas nuo 60 iki 104 leidimasis nuo 105 iki 149, apsivertimas ir tada 
        // leidimasis nuo 150 iki 14,  kylimas nuo 15 iki 59.        
        if((SIN_CIKLAS>60)&&(SIN_CIKLAS<=105)){
        unsigned char x;
        x = ((SIN_CIKLAS-60) * 2);
        OCR1A = x;
        }
        else if((SIN_CIKLAS>105)&&(SIN_CIKLAS<149)){
        unsigned char x;
        x = ((45 - (SIN_CIKLAS-105) ) * 2); 
        OCR1A = x;
        }
        else{
        OCR1A = 0;
        }

    

        // C fazes kilimas nuo 120 iki 164 leidimasis nuo 165 iki 29, apsivertimas ir tada 
        // leidimasis nuo 30 iki 74,  kylimas nuo 75 iki 119.
        if((SIN_CIKLAS>120)&&(SIN_CIKLAS<=165)){
        i = ((SIN_CIKLAS-120) * 2); 
        OCR2 = i;
        }
        else if(SIN_CIKLAS>165){
        i = ((45 - (SIN_CIKLAS-165) ) * 2); 
        OCR2 = i;
        }
        else if(SIN_CIKLAS<30){  
        i = ((45 - (SIN_CIKLAS+15) ) * 2);
        OCR2 = i;
        }
        else{
        OCR2 = 0;
        }
    

        if(UPDATE_LCD==1){
        UPDATE_LCD = 0;
        lcd_clear();     
        lcd_gotoxy(0,0);
        lcd_putsf("PWM_A:");
        lcd_put_number(0,3,0,0,OCR0,0);
        lcd_putsf("  ADC_0:");
        a = read_adc(0);
        lcd_put_number(0,3,0,0,a,0);
         

        lcd_gotoxy(0,1);
        lcd_putsf("PWM_B:");
        lcd_put_number(0,3,0,0,OCR1A,0);
        lcd_putsf("  ADC_1:");
        lcd_put_number(0,3,0,0,read_adc(1),0);
                                        
         
        lcd_gotoxy(0,2);
        lcd_putsf("PWM_C:");
        lcd_put_number(0,3,0,0,OCR2,0);
         
        lcd_gotoxy(0,3);
        lcd_putsf("DAZNIS:");
        lcd_put_number(0,3,0,0,DAZNIS,0);     
        }       
    

    a = a/10;
    i = 0;
        while(i<a){
        i++;
       delay_us(2000);
        }
    } 
}
