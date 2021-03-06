#include <mega8.h>
#include <delay.h>
#include <string.h>

#define LED_SEGMENT_A PORTD.4
#define LED_SEGMENT_B PORTD.6
#define LED_SEGMENT_C PORTD.0
#define LED_SEGMENT_D PORTC.2
#define LED_SEGMENT_E PORTC.1
#define LED_SEGMENT_F PORTB.6
#define LED_SEGMENT_G PORTD.1
#define LED_SEGMENT_H PORTC.3

#define LED_BLOCK_0 PORTD.3
#define LED_BLOCK_1 PORTB.7
#define LED_BLOCK_2 PORTD.5
#define LED_BLOCK_3 PORTD.2



//////////// Mygtukai /////////////
#define BUTTON_UP 0
#define BUTTON_LEFT 1
#define BUTTON_ENTER 2
#define BUTTON_RIGHT 3
#define BUTTON_DOWN 4

#define ButtonFiltrationTimer 20 // x*cycle (cycle~1ms)

unsigned char BUTTON_INPUT(unsigned char input){
    if(input==0){return PINB.5;}
    if(input==1){return PINC.0;}
    if(input==2){return PINB.3;}
    if(input==3){return PINB.2;}
    if(input==4){return PINB.4;}
return 0;
}
///////////////////////////////////

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
return 0;
}

unsigned char LcdText[4], LcdTaskas[4], OSC;
unsigned char UpdateLedDisplay(){
unsigned char LcdChannel;

OSC++;
    if(OSC>=15){
    OSC = 0;
    }

    if(OSC==0){
    LcdChannel = 0;
    }
    else if(OSC==4){
    LcdChannel = 1;
    }
    else if(OSC==8){
    LcdChannel = 2;
    }
    else if(OSC==12){
    LcdChannel = 3;
    }
    else{
    LcdChannel = 5;
    }

    if(LcdChannel!=5){
    unsigned char a=0, b=0, c=0, d=0, e=0, f=0, g=0, input = LcdText[LcdChannel];

    // Segmentu valdymas
        if(input=='0'){
        a = 1;
        b = 1;
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        }
        else if(input=='1'){
        b = 1;
        c = 1;
        }
        else if(input=='2'){
        a = 1;
        b = 1;
        d = 1;
        e = 1;
        g = 1;
        }
        else if(input=='3'){
        a = 1;
        b = 1;
        c = 1;
        d = 1;
        g = 1;
        }
        else if(input=='4'){
        b = 1;
        c = 1;
        f = 1;
        g = 1;
        }
        else if(input=='5'){
        a = 1;
        c = 1;
        d = 1;
        f = 1;
        g = 1;
        }
        else if(input=='6'){
        a = 1;
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='7'){
        a = 1;
        b = 1;
        c = 1;
        }
        else if(input=='8'){
        a = 1;
        b = 1;
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='9'){
        a = 1;
        b = 1;
        c = 1;
        d = 1;
        f = 1;
        g = 1;
        }
        else if(input=='A'){
        a = 1;
        b = 1;
        c = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='b'){
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='c'){
        d = 1;
        e = 1;
        g = 1;
        }
        else if(input=='C'){
        a = 1;
        d = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='d'){
        b = 1;
        c = 1;
        d = 1;
        e = 1;
        g = 1;
        }
        else if(input=='E'){
        a = 1;
        d = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='F'){
        a = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='G'){
        a = 1;
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        }
        else if(input=='h'){
        c = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='H'){
        b = 1;
        c = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='i'){
        c = 1;
        }
        else if(input=='I'){
        b = 1;
        c = 1;
        }
        else if(input=='J'){
        b = 1;
        c = 1;
        d = 1;
        }
        else if(input=='L'){
        d = 1;
        e = 1;
        f = 1;
        }
        else if(input=='n'){
        c = 1;
        e = 1;
        g = 1;
        }
        else if(input=='o'){
        c = 1;
        d = 1;
        e = 1;
        g = 1;
        }
        else if(input=='O'){
        a = 1;
        b = 1;
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        }
        else if(input=='P'){
        a = 1;
        b = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='r'){
        e = 1;
        g = 1;
        }
        else if(input=='S'){
        a = 1;
        c = 1;
        d = 1;
        f = 1;
        g = 1;
        }
        else if(input=='t'){
        d = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='u'){
        c = 1;
        d = 1;
        e = 1;
        }
        else if(input=='U'){
        b = 1;
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        }
        else if(input=='Y'){
        b = 1;
        c = 1;
        f = 1;
        g = 1;
        }
        else if(input=='='){
        d = 1;
        g = 1;
        }
        else if(input=='_'){
        d = 1;
        }

        if(a==1){                    LED_SEGMENT_A = 0;}
        if(b==1){                    LED_SEGMENT_B = 0;}
        if(c==1){                    LED_SEGMENT_C = 0;}
        if(d==1){                    LED_SEGMENT_D = 0;}
        if(e==1){                    LED_SEGMENT_E = 0;}
        if(f==1){                    LED_SEGMENT_F = 0;}
        if(g==1){                    LED_SEGMENT_G = 0;}
        if(LcdTaskas[LcdChannel]==1){LED_SEGMENT_H = 0;}

    // Bloko valdymas
        if(LcdChannel==0){     LED_BLOCK_0 = 1;}
        else if(LcdChannel==1){LED_BLOCK_1 = 1;}
        else if(LcdChannel==2){LED_BLOCK_2 = 1;}
        else if(LcdChannel==3){LED_BLOCK_3 = 1;}
    }
    else{
    LED_SEGMENT_A = 1;
    LED_SEGMENT_B = 1;
    LED_SEGMENT_C = 1;
    LED_SEGMENT_D = 1;
    LED_SEGMENT_E = 1;
    LED_SEGMENT_F = 1;
    LED_SEGMENT_G = 1;
    LED_SEGMENT_H = 1;

    LED_BLOCK_0 = 0;
    LED_BLOCK_1 = 0;
    LED_BLOCK_2 = 0;
    LED_BLOCK_3 = 0;
    }
return 1;
}

unsigned char led_display_clear(){
unsigned char i;
    for(i=0;i<4;i++){LcdText[i] = 0;LcdTaskas[i] = 0;}
UpdateLedDisplay();
return 1;
}

unsigned char led_put_runing_text(unsigned int Position,unsigned char flash *str){
unsigned int StrLenght = strlenf(str);
signed int i,a;
    for(i=0;i<4;i++){
    a = i + Position - 4;
        if(a>=0){
            if(a<StrLenght){
            LcdText[i] = str[a];
            }
            else{
                if(i==0){
                return 1;
                }
            }
        }
    }
return 0;
}

#define FIRST_ADC_INPUT 4
#define LAST_ADC_INPUT 5
unsigned char adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
#define ADC_VREF_TYPE 0x20
interrupt [ADC_INT] void adc_isr(void){
static unsigned char input_index=0;
adc_data[input_index]=ADCH;
if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
   input_index=0;
ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;
delay_us(10);
ADCSRA|=0x40;
}

#define VOLTAGE_CONFIGURATION_A 0
#define VOLTAGE_CONFIGURATION_B 0
#define VOLTAGE_CONFIGURATION_C 0


unsigned int GetVoltage(unsigned char voltage_data){
return ((voltage_data*VOLTAGE_CONFIGURATION_A)/VOLTAGE_CONFIGURATION_B)+VOLTAGE_CONFIGURATION_C;
}

unsigned int GetCurrent(unsigned char voltage_data, unsigned int resistance){
return (((voltage_data*VOLTAGE_CONFIGURATION_A)/VOLTAGE_CONFIGURATION_B)+VOLTAGE_CONFIGURATION_C)*resistance;
}

unsigned int GetPower(unsigned int voltage, unsigned int current, unsigned int resistance){

}


// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
// State7=0 State6=0 State5=T State4=T State3=T State2=T State1=0 State0=T
PORTB=0x00;
DDRB=0xC2;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=In
// State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=T
PORTC=0x00;
DDRC=0x0E;

// Port D initialization
// Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=T State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTD=0x00;
DDRD=0x7F;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000.000 kHz
// Mode: Fast PWM top=OCR1A
// OC1A output: Toggle
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x43;
TCCR1B=0x19;
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

// ADC initialization
// ADC Clock frequency: 62.500 kHz
// ADC Voltage Reference: AREF pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
ADCSRA=0xCF;

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/128k
#pragma optsize-
WDTCR=0x1B;
WDTCR=0x0B;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Global enable interrupts
#asm("sei")



// Ijungiant prabega uzrasas "HELLO"
    if(1){
    unsigned int Timer1 = 0;
        while(Timer1<2000){
        unsigned char HelloPadetis = Timer1/200;
        Timer1++;
        led_put_runing_text(HelloPadetis,"HELLO");
        UpdateLedDisplay();
        delay_ms(1);
        }
    }



    while(1){
    //////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////// Mygtukai /////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    static unsigned char BUTTON[5], ButtonFilter[5];
        if(1){
        unsigned char i;
            for(i=0;i<5;i++){
                if(BUTTON_INPUT(i)==1){
                    if(ButtonFilter[i]<ButtonFiltrationTimer){
                    ButtonFilter[i]++;
                    }
                }
                else{
                    if(ButtonFilter[i]>=ButtonFiltrationTimer){
                    BUTTON[i] = 1;
                    }
                    else{
                    BUTTON[i] = 0;
                    }
                ButtonFilter[i] = 0;
                }
            }
        }
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////





    //////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////// Displejus /////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////


    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    UpdateLedDisplay();
    delay_ms(1);
    }
}
