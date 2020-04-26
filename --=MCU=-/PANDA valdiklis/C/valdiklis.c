/*****************************************************
Project : Panda valdiklis v1.0 
Date    : 5/1/2014
Author  : Tomas

Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <delay.h>

#define ADC_VREF_TYPE 0x20

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
// Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=0 State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x20;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
// Mode: Phase correct PWM top=FFh
// OC0 output: Non-Inverted PWM
TCCR0=0x62;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
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
// ADC Clock frequency: 62.500 kHz
// ADC Voltage Reference: AREF pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x87;


// read_adc(0) - 12V (178bit = 14.0V) (182bit = 14.3V) (182bit = 14.6V)
// read_adc(1) - Potenciometras
// read_adc(2) - 48V

                                                                                                             
static unsigned char LOW_AKU_48; LOW_AKU_48 = 0;



// INPUTS
#define KROVIMAS_220_48
#define DEGIMAS
#define AKU_12 read_adc(0)
#define AKU_48 read_adc(2) 

// OUTPUTS
#define GENERATORIAUS_ZADINIMAS OCR0 
#define KROVIMAS_48_12 OCR1A
#define RELE_GEN_12
#define INVERTERIS
  


    while(1){
     
        if(KROVIMAS_220_48==1){
        LOW_AKU_48 = 0;            
        }     
      
        
        
      
        if(AKU_48>){         
            if(AKU_12<178){
                if(KROVIMAS_48_12<128){
                KROVIMAS_48_12++;
                }
            }
            else if(AKU_12<182){
                if(KROVIMAS_48_12>0){
                KROVIMAS_48_12--;
                }
            } 
        }
        else{            
        LOW_AKU_48 = 1;
        KROVIMAS_48_12--;
        }
                
       
        if(DEGIMAS==1){
            if(LOW_AKU_48==1){
            // Kai nusesta 48V aku isjungti inverteri
            INVERTERIS = 0;
                if(RELE_GEN_12==0){
                // Sumazinti zadinima iki 0 tada gales ijungti krovimo rele               
                    if(GENERATORIAUS_ZADINIMAS>0){
                    GENERATORIAUS_ZADINIMAS--;
                    }
                    else if(GENERATORIAUS_ZADINIMAS==0){
                    RELE_GEN_12 = 1; 
                    }
                }
                else{
                // Krovimo rele ijungta galima didinti zadinima iki reikiamo pwm
                    if(AKU_12<178){
                        if(GENERATORIAUS_ZADINIMAS<200){// Maximalus pwm kraunant 12V akumuliatoriu is generatoriaus
                        GENERATORIAUS_ZADINIMAS++;
                        }
                    }
                    else if(AKU_12<182){     
                        if(GENERATORIAUS_ZADINIMAS>0){
                        GENERATORIAUS_ZADINIMAS--;
                        }
                    }
                }   
            }    
            else{
            // Jei ijungta krovimo rele isjungti zadinima 0 tada isjungti krovimo rele, o tada ijungti zadinima iki maximalaus ir tada ijungti inverteri        
                if(RELE_GEN_12==1){
                    if(GENERATORIAUS_ZADINIMAS>0){
                    GENERATORIAUS_ZADINIMAS--;
                    }
                    else{
                    RELE_GEN_12 = 0;
                    }
                }
                else{
                    if(GENERATORIAUS_ZADINIMAS<255){// Inverteriui reikia pilno zadinimo
                    GENERATORIAUS_ZADINIMAS++;
                    }
                    else{
                    INVERTERIS = 1;
                    }    
                }   
            }
            
        }
        else{
        // Degimas dingo - isjungti inverteri, isjungti zadinima ir isjungti krovimo rele
        INVERTERIS = 0;
            if(GENERATORIAUS_ZADINIMAS>0){
            GENERATORIAUS_ZADINIMAS--;
            }
            else{
            RELE_GEN_12 = 0;
            }
        }

    delay_ms(10);
    }
}
