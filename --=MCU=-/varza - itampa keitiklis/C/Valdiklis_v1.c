/*****************************************************
Project : Saules kolektoriaus valdiklis
Version : v1.0
Date    : 2011-08-20
Author  : T.V.

Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
*****************************************************/
#include <mega32.h>
#include <delay.h>




// Alphanumeric LCD Module functions portc
#include <lcd.h>
#asm                    
   .equ __lcd_port=0x15 
#endasm


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



#define TEMPERATURE_BOIL PORTA.1
#define TEMPERATURE_S_INP PORTA.2
#define TEMPERATURE_S_OUT PORTA.3









#define ADC_VREF_TYPE 0x00

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}




void main(void){
// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0 
PORTA=0x00;
DDRA=0b00000000;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0b00000011;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0b00000000;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0b00000000;

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

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83; 

// LCD module initialization
lcd_init(20);

// Global enable interrupts
#asm("sei")



   
    while(1){
    unsigned int a;
    a = read_adc(0);
    lcd_clear();
    lcd_put_number(1,4,0,0,0,a);
    lcd_putsf(" bit");
    delay_ms(1000);
    }
}