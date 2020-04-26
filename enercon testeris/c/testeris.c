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



unsigned char sinusA[60]={
0, 26, 53, 78, 103, 127, 149, 170, 189, 206,
220, 232, 242, 249, 253, 255, 253, 249, 242, 232,
220, 206, 189, 170, 149, 127, 103, 78, 53, 26,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

unsigned char sinusB[60]={
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 26, 53, 78, 103, 127, 149, 170, 189, 206,
220, 232, 242, 249, 253, 255, 253, 249, 242, 232,
220, 206, 189, 170, 149, 127, 103, 78, 53, 26,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

unsigned char sinusC[60]={
220, 206, 189, 170, 149, 127, 103, 78, 53, 26,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 26, 53, 78, 103, 127, 149, 170, 189, 206,
220, 232, 242, 249, 253, 255, 253, 249, 242, 232};





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




#define A_FAZE_APACIA PORTD.0
#define B_FAZE_APACIA PORTD.1
#define C_FAZE_APACIA PORTD.2
//#define FAST_ON PIND.3
unsigned char FAST_ON;
unsigned char APCIOS_UZLAIKYMAS_IJUNGIANT[3];




unsigned char SIN_CIKLAS, START, DALIKLIS, DAZNIO_DALIKLIS, UPDATE_LCD;
int lcd_update_skaitiklis, sek_skaitiklis,  DAZNIS, daznio_skaitiklis;
unsigned char sinus_OUTPUT[3][60];


unsigned char STEP_UP_PLOTIS;


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void){
    

}




// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void){

}


// Timer1 output compare B interrupt service routine
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{

}



// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void){
lcd_update_skaitiklis++;
    if(lcd_update_skaitiklis==1569){
    // impulsas kas 0.1 sekundes (8 MHz)
    lcd_update_skaitiklis = 0;
    UPDATE_LCD = 1;
      
          
    sek_skaitiklis++;
        if(sek_skaitiklis>=10){
        // impulsas kas sekunde (8 MHz)    
        UPDATE_LCD = 1;  
        DAZNIS = daznio_skaitiklis;
        sek_skaitiklis = 0;
        daznio_skaitiklis = 0;
                  
        }
        
        
        
    }
         
        
DALIKLIS++;    
    if(DALIKLIS>=DAZNIO_DALIKLIS){
    DALIKLIS = 0;
        if(START==1){      
        SIN_CIKLAS++;
            if(SIN_CIKLAS>=60){
            SIN_CIKLAS = 0; 
            daznio_skaitiklis++;       
            } 
                


            if(FAST_ON==1){
            /////////////// A /////////////
                if(sinusA[SIN_CIKLAS]>0){
                A_FAZE_APACIA = 0;
                APCIOS_UZLAIKYMAS_IJUNGIANT[0] = 0;
                }
            OCR0 = sinus_OUTPUT[0][SIN_CIKLAS];
                if(sinusA[SIN_CIKLAS]==0){
                    if(APCIOS_UZLAIKYMAS_IJUNGIANT[0]==1){
                    A_FAZE_APACIA = 1;
                    }
                    else{
                    APCIOS_UZLAIKYMAS_IJUNGIANT[0] = 1;
                    }
                }
            ///////////////////////////////



            /////////////// B /////////////               
                if(sinusB[SIN_CIKLAS]>0){
                B_FAZE_APACIA = 0;
                APCIOS_UZLAIKYMAS_IJUNGIANT[1] = 0;
                }    
            OCR1A = sinus_OUTPUT[1][SIN_CIKLAS];
                if(sinusB[SIN_CIKLAS]==0){
                    if(APCIOS_UZLAIKYMAS_IJUNGIANT[1]==1){
                    B_FAZE_APACIA = 1;
                    }
                    else{
                    APCIOS_UZLAIKYMAS_IJUNGIANT[1] = 1;
                    }
                }
            ///////////////////////////////


                    
            /////////////// C /////////////
                if(sinusC[SIN_CIKLAS]>0){
                C_FAZE_APACIA = 0;
                APCIOS_UZLAIKYMAS_IJUNGIANT[2] = 0;
                }
            OCR2 = sinus_OUTPUT[2][SIN_CIKLAS];    
                if(sinusC[SIN_CIKLAS]==0){
                    if(APCIOS_UZLAIKYMAS_IJUNGIANT[2]==1){
                    C_FAZE_APACIA = 1;
                    }
                    else{
                    APCIOS_UZLAIKYMAS_IJUNGIANT[2] = 1;
                    }
                }
            ///////////////////////////////
             
             
              
            /////////// STEP UP ///////////
            OCR1B = STEP_UP_PLOTIS;
            ///////////////////////////////
             
            }
            else{
            A_FAZE_APACIA = 0;
            B_FAZE_APACIA = 0;
            C_FAZE_APACIA = 0;
            OCR0 = 0;
            OCR1A = 0;
            OCR1B = 0;
            OCR2 = 0;
            }      
                
        }
        else{
        A_FAZE_APACIA = 0;
        B_FAZE_APACIA = 0;
        C_FAZE_APACIA = 0;
        OCR0 = 0;
        OCR1A = 0;
        OCR1B = 0;
        OCR2 = 0;
        }  
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
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0b11110111;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 8000.000 kHz
// Mode: Phase correct PWM top=FFh
// OC0 output: Non-Inverted PWM
TCCR0=0x61;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000.000 kHz
// Mode: Ph. correct PWM top=00FFh
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xA1;
TCCR1B=0x01;
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
// Clock value: 8000.000 kHz
// Mode: Phase correct PWM top=FFh
// OC2 output: Non-Inverted PWM
ASSR=0x00;
TCCR2=0x61;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x45;

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
            
                
    delay_ms(40);
    pos++; 
    }    
lcd_clear(); 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




START = 1;
FAST_ON = 1;
    while(1){
      
        if(UPDATE_LCD==1){
        unsigned char x, ofset;
        UPDATE_LCD = 0;
         
         
            
            
            
        lcd_clear();

                 
        lcd_gotoxy(0,0);
        lcd_putsf("-===SIMULIACIJA===- ");
            if(FAST_ON==1){
            
            lcd_putsf("PWM:");    
            lcd_put_number(0,3,0,0,read_adc(1),0);
            lcd_putsf("/255  | ON  |");
                 
            lcd_gotoxy(0,2);
            lcd_putsf("DAZNIS:");
            lcd_put_number(0,3,0,0,DAZNIS,0);
            lcd_putsf(" Hz -----");
                 
                 
                  
                 
            lcd_gotoxy(0,3);
            lcd_putsf("STEPUP PWM: ");
            lcd_put_number(0,3,0,0,read_adc(2),0);            
            lcd_putsf("/255");
            }
            else{
            lcd_putsf("PWM:000/255  | OFF |");
            lcd_putsf("DAZNIS:000 Hz ----- ");
            lcd_putsf("STEPUP PWM: 000/255");
            } 


        ofset = 255 - read_adc(1);
        DAZNIO_DALIKLIS = (1 + (255 - read_adc(0))) / 8;        
        STEP_UP_PLOTIS = read_adc(2);
            for(x=0; x<60; x++){
                if(ofset<sinusA[x]){
                sinus_OUTPUT[0][x] = sinusA[x] - ofset;
                }
                else{
                sinus_OUTPUT[0][x] = 0;
                }
                
                if(ofset<sinusB[x]){
                sinus_OUTPUT[1][x] = sinusB[x] - ofset;
                }
                else{
                sinus_OUTPUT[1][x] = 0;
                }
                
                if(ofset<sinusC[x]){
                sinus_OUTPUT[2][x] = sinusC[x] - ofset;
                }
                else{
                sinus_OUTPUT[2][x] = 0;
                }
            }




 
         
        }       
    } 
}
