/*****************************************************
Project : UPS v2
Version : v2
Date    : 2011-03-25
Author  : Tomas

Chip type               : ATmega16
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega16.h>
#include <delay.h>
#include <string.h>

#define LED_SEGMENT_A PORTC.6
#define LED_SEGMENT_B PORTC.4
#define LED_SEGMENT_C PORTC.1
#define LED_SEGMENT_D PORTC.3
#define LED_SEGMENT_E PORTD.7
#define LED_SEGMENT_F PORTC.5
#define LED_SEGMENT_G PORTC.0 
#define LED_SEGMENT_H PORTC.2
                                       
#define LED_BLOCK_0 PORTC.7
#define LED_BLOCK_1 PORTA.6
#define LED_BLOCK_2 PORTA.7
#define LED_BLOCK_3 PORTA.4


///////////////////// VARIABLES /////////////////////////////////////
int OSC;
char BUTTON[4];
//char BATTERY;
char SKIP;
char UPS_STATE,OLD_UPS_STATE;
eeprom char BATTERY_FOULT;
char KRAUTI, LOAD, BEEPER_OFF;

char LcdText[4], LcdTaskas[4];

char RealTime;





unsigned int Timer3;// Begancio Taskelio Taimeris

eeprom unsigned int Timer4;// Paskutinio Iskrorivimo valandos
eeprom unsigned int Timer5;// Paskutinio Iskrorivimo minutes

unsigned int Timer7;// Dabartinio Iskrovimo Laiko Sekundziu Skaicius
unsigned int Timer8;// Dabartinio Iskrovimo Laiko Minuciu Skaicius
unsigned int Timer9;// Dabartinio Iskrovimo Laiko Valandu Skaicius

unsigned int Timer10;// 2 Mygtuko Uzlaikymo Taimeris

unsigned int Timer11;// 3 Mygtuko Uzlaikymo Taimeris

unsigned int Timer12;// Krovimo taimeris (30 sec)

//unsigned int Timer13;

unsigned int Timer14;// Iskrovimo sustabdymo taimeris

//signed int Timer15;// 1 savaites taimerio sekundes dalis


unsigned int Timer19;// "diSchArGE FouLt" taimeris

unsigned int Timer20;// "diSchArGinG" taimeris

//unsigned int Timer22;

//unsigned int Timer23;

unsigned int Timer24;// ms skaicius po kiekvienos iskrovimo laiko sekundes suejimo 

char LangoAdresas;
char LanguTrigeris;      
 
unsigned int BATTERY_VOLTAGE;// Baterijos itampa (U x 10)
unsigned int BATTERY_VOLTAGE_ARCHIVE[10];
eeprom unsigned int MAX_BATTERY_VOLTAGE;// Baterijos maksimali itampa (Umax x 10)
eeprom unsigned int MIN_BATTERY_VOLTAGE;// Baterijos minimali itampa (Umin x 10) 
char ItamposTrigeris1;
char ItamposTrigeris2;

/////////////////////////////////////////////////////////////////////
#define ADC_VREF_TYPE 0x40
unsigned int read_adc(unsigned char adc_input){
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
delay_us(10);
ADCSRA|=0x40;
    while((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////   
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

char UpdateVariableOSC(){
OSC++;
    if(OSC>=15){
    OSC = 0;
    }
return 1;
}

char WhatLcdChannelIsOn(){
    if(OSC==0){
    return 0;
    }
    else if(OSC==4){
    return 1;
    }
    else if(OSC==8){
    return 2;
    }
    else if(OSC==12){
    return 3;
    }
    else{
    return -1;
    }
return -1;
}
    
char RelayOutputs(){
    if(UPS_STATE==2){
    PORTD.3 = 1;
    }
    else{
    PORTD.3 = 0;
    }
  
    if(KRAUTI==1){
    PORTD.6 = 1;
    }
    else{
    PORTD.6 = 0;
    }
KRAUTI = 0;

    if(LOAD==1){
    PORTD.5 = 1;
    }
    else{
    PORTD.5 = 0;
    }
LOAD = 0;

    if(BEEPER_OFF==1){
    PORTD.4 = 1;
    }
    else{
    PORTD.4 = 0;
    }
BEEPER_OFF = 0;

return 1;
}
    
char UpdateLcd(){
char i;
char LcdChannel = WhatLcdChannelIsOn();
    if(LcdChannel!=-1){
    char a=0, b=0, c=0, d=0, e=0, f=0, g=0;
    char input = LcdText[LcdChannel];
    // Bloko valdymas
        if(LcdChannel==0){     LED_BLOCK_0 = 1;LED_BLOCK_1 = 0;LED_BLOCK_2 = 0;LED_BLOCK_3 = 0;}
        else if(LcdChannel==1){LED_BLOCK_0 = 0;LED_BLOCK_1 = 1;LED_BLOCK_2 = 0;LED_BLOCK_3 = 0;}
        else if(LcdChannel==2){LED_BLOCK_0 = 0;LED_BLOCK_1 = 0;LED_BLOCK_2 = 1;LED_BLOCK_3 = 0;}
        else if(LcdChannel==3){LED_BLOCK_0 = 0;LED_BLOCK_1 = 0;LED_BLOCK_2 = 0;LED_BLOCK_3 = 1;}
            
    // Segmentu valdymas        
        if(input=='0'){
        a = 1;
        b = 1;
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        g = 0;
        }        
        else if(input=='1'){
        a = 0;
        b = 1;
        c = 1;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }        
        else if(input=='2'){
        a = 1;
        b = 1;
        c = 0;
        d = 1;
        e = 1;
        f = 0;
        g = 1;
        }        
        else if(input=='3'){
        a = 1;
        b = 1;
        c = 1;
        d = 1;
        e = 0;
        f = 0;
        g = 1;
        }        
        else if(input=='4'){
        a = 0;
        b = 1;
        c = 1;
        d = 0;
        e = 0;
        f = 1;
        g = 1;
        }        
        else if(input=='5'){
        a = 1;
        b = 0;
        c = 1;
        d = 1;
        e = 0;
        f = 1;
        g = 1;
        }       
        else if(input=='6'){
        a = 1;
        b = 0;
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
        d = 0;
        e = 0;
        f = 0;
        g = 0;
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
        e = 0;
        f = 1;
        g = 1;
        }       
        else if(input=='a'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }        
        else if(input=='A'){
        a = 1;
        b = 1;
        c = 1;
        d = 0;
        e = 1;
        f = 1;
        g = 1;
        }        
        else if(input=='b'){
        a = 0;
        b = 0;
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        g = 1;
        }        
        else if(input=='B'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }        
        else if(input=='c'){
        a = 0;
        b = 0;
        c = 0;
        d = 1;
        e = 1;
        f = 0;
        g = 1;
        }
        else if(input=='C'){
        a = 1;
        b = 0;
        c = 0;
        d = 1;
        e = 1;
        f = 1;
        g = 1;
        }        
        else if(input=='d'){
        a = 0;
        b = 1;
        c = 1;
        d = 1;
        e = 1;
        f = 0;
        g = 1;
        }
        else if(input=='D'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }        
        else if(input=='e'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='E'){
        a = 1;
        b = 0;
        c = 0;
        d = 1;
        e = 1;
        f = 1;
        g = 1;
        }        
        else if(input=='f'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='F'){
        a = 1;
        b = 0;
        c = 0;
        d = 0;
        e = 1;
        f = 1;
        g = 1;
        }        
        else if(input=='g'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='G'){
        a = 1;
        b = 0;
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        g = 0;
        }        
        else if(input=='h'){
        a = 0;
        b = 0;
        c = 1;
        d = 0;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='H'){
        a = 0;
        b = 1;
        c = 1;
        d = 0;
        e = 1;
        f = 1;
        g = 1;
        }        
        else if(input=='i'){
        a = 0;
        b = 0;
        c = 1;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='I'){
        a = 0;
        b = 1;
        c = 1;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='j'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='J'){
        a = 0;
        b = 1;
        c = 1;
        d = 1;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='k'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='K'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }        
        else if(input=='l'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='L'){
        a = 0;
        b = 0;
        c = 0;
        d = 1;
        e = 1;
        f = 1;
        g = 0;
        }
        else if(input=='m'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='M'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='n'){
        a = 0;
        b = 0;
        c = 1;
        d = 0;
        e = 1;
        f = 0;
        g = 1;
        }
        else if(input=='N'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='o'){
        a = 0;
        b = 0;
        c = 1;
        d = 1;
        e = 1;
        f = 0;
        g = 1;
        }
        else if(input=='O'){
        a = 1;
        b = 1;
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        g = 0;
        }
        else if(input=='p'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='P'){
        a = 1;
        b = 1;
        c = 0;
        d = 0;
        e = 1;
        f = 1;
        g = 1;
        }       
        else if(input=='q'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='Q'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }             
        else if(input=='r'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 1;
        f = 0;
        g = 1;
        }
        else if(input=='R'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }        
        else if(input=='s'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='S'){
        a = 1;
        b = 0;
        c = 1;
        d = 1;
        e = 0;
        f = 1;
        g = 1;
        }
        else if(input=='t'){
        a = 0;
        b = 0;
        c = 0;
        d = 1;
        e = 1;
        f = 1;
        g = 1;
        }
        else if(input=='T'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }        
        else if(input=='u'){
        a = 0;
        b = 0;
        c = 1;
        d = 1;
        e = 1;
        f = 0;
        g = 0;
        }
        else if(input=='U'){
        a = 0;
        b = 1;
        c = 1;
        d = 1;
        e = 1;
        f = 1;
        g = 0;
        }        
        else if(input=='v'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='V'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }       
        else if(input=='w'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='W'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }       
        else if(input=='x'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='X'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }        
        else if(input=='y'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='Y'){
        a = 0;
        b = 1;
        c = 1;
        d = 0;
        e = 0;
        f = 1;
        g = 1;
        }        
        else if(input=='z'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }
        else if(input=='Z'){
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        f = 0;
        g = 0;
        }        
        else if(input=='='){
        a = 0;
        b = 0;
        c = 0;
        d = 1;
        e = 0;
        f = 0;
        g = 1;
        }
        else if(input=='_'){
        a = 0;
        b = 0;
        c = 0;
        d = 1;
        e = 0;
        f = 0;
        g = 0;
        }       
        if(a==1){                    LED_SEGMENT_A = 0;}else{LED_SEGMENT_A = 1;}
        if(b==1){                    LED_SEGMENT_B = 0;}else{LED_SEGMENT_B = 1;}
        if(c==1){                    LED_SEGMENT_C = 0;}else{LED_SEGMENT_C = 1;}
        if(d==1){                    LED_SEGMENT_D = 0;}else{LED_SEGMENT_D = 1;}  
        if(e==1){                    LED_SEGMENT_E = 0;}else{LED_SEGMENT_E = 1;}  
        if(f==1){                    LED_SEGMENT_F = 0;}else{LED_SEGMENT_F = 1;}  
        if(g==1){                    LED_SEGMENT_G = 0;}else{LED_SEGMENT_G = 1;}  
        if(LcdTaskas[LcdChannel]==1){LED_SEGMENT_H = 0;}else{LED_SEGMENT_H = 1;}
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
        
    PORTC.7 = 0;    // 1
    PORTA.6 = 0;    // 2
    PORTA.7 = 0;    // 3
    PORTA.4 = 0;    // 4
    }    

    for(i=0;i<4;i++){LcdText[i] = 0;LcdTaskas[i] = 0;}  
return 1;
}

char CheckButtons(){
    if(PINA.0==0){BUTTON[0] = 1;}else{BUTTON[0] = 0;}
    if(PINA.1==0){BUTTON[1] = 1;}else{BUTTON[1] = 0;}
    if(PINA.2==0){BUTTON[2] = 1;}else{BUTTON[2] = 0;}
    if(PINA.3==0){BUTTON[3] = 1;}else{BUTTON[3] = 0;}     
return 1;
}

char CheckBattery(){
static unsigned int Timer29;
Timer29++;
    if(Timer29>=250){        
    unsigned int Bits = read_adc(5);
    unsigned int MomentVoltage, VoltageSum = 0;
    char i;
       
    MomentVoltage = Bits/5 - Bits/90;
     
        for(i=9;i>0;i--){     
        BATTERY_VOLTAGE_ARCHIVE[i] = BATTERY_VOLTAGE_ARCHIVE[i-1];
        }        
    BATTERY_VOLTAGE_ARCHIVE[0] = MomentVoltage;  
          
        for(i=0;i<10;i++){
        VoltageSum = VoltageSum + BATTERY_VOLTAGE_ARCHIVE[i];
        }         
    BATTERY_VOLTAGE = VoltageSum/10;
      
    Timer29 = 0;        
    }
return 1;
}

char led_put_runing_text(unsigned int Position,char flash *str){
unsigned int StrLenght = strlenf(str);                            
signed int i,a;                            
    for(i=0;i<4;i++){
    a = i + Position - 4;
        if(a>=0){
            if(a<StrLenght){
            //lcd_putchar(str[a]);
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

signed int Timer16;// 1 savaites taimerio sekundziu skaicius
eeprom signed int Timer17;// 1 savaites taimerio minuciu skaicius
eeprom signed int Timer18;// 1 savaites taimerio valandu skaicius
char StartDischargeAfter(   unsigned char days,     unsigned char hours,    
                            unsigned char minutes,  unsigned char seconds){
Timer16 = seconds;
Timer17 = minutes;
Timer18 = hours + days*24;                          
return 1;
}                            
                            

// Timer 0 overflow interrupt service routine
unsigned int InteruptTimer;
interrupt [TIM0_OVF] void timer0_ovf_isr(void){

InteruptTimer++;
/////////////////////////// 1 Second Callback ///////////////////////////////////////
    if(InteruptTimer>=495){
    RealTime = 1; 
    InteruptTimer = 0;
    }
/////////////////////////////////////////////////////////////////////////////////////
}


void main(void){
// Crystal Oscillator division factor: 1
PORTA=0x00;
DDRA=0b11010000;

PORTB=0x00;
DDRB=0b00;

PORTC=0x00;
DDRC=0b11111111;

PORTD=0x00;
DDRD=0b11111100;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x03;
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
//TCCR2=0x00;
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
// ADC Clock frequency: 62.500 kHz
// ADC Voltage Reference: Int., cap. on AREF
// ADC Auto Trigger Source: Free Running
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0xA7;
SFIOR&=0x1F;

// Global enable interrupts
#asm("sei")


// Kai pasijungia ir buna nesamoningi skaiciai reikia nuresetint i default'us  
    if((Timer4==65535)||(Timer5==65535)){Timer4 = 0;Timer5 = 0;}
    
    if(BATTERY_FOULT==255){BATTERY_FOULT = 0;}
         
    if((Timer18>168)||(Timer18<0)){ StartDischargeAfter(7,0,0,0);}
    
    if(MAX_BATTERY_VOLTAGE==65535){MAX_BATTERY_VOLTAGE = 146;}
    
    if(MIN_BATTERY_VOLTAGE==65535){MIN_BATTERY_VOLTAGE = 110;}
/////////////////////////////////////////////////////////////////////////////    
    
UPS_STATE = 1;

// Ijungiant prabega uzrasas "HELLO"
static unsigned int Timer1;// "HELLO" Taimeris
    while(Timer1<2000){
    char HelloPadetis = Timer1/200;
    UpdateVariableOSC();
    Timer1++;                          
    led_put_runing_text(HelloPadetis,"HELLO");
    UpdateLcd();         
    delay_ms(1);
    }  

// Programos kodas
    while(1){
    UpdateVariableOSC();
    CheckBattery();










//////////////////////////// 1 sec callback ////////////////////////////////////////
        if(RealTime==1){
        //////////// 1 SAVAITES TIMERIS /////////////       
            if(UPS_STATE!=2){             
                if((Timer16>0)||(Timer17>0)||(Timer18>0)){
                // Taimeris skaiciuoja tik tada kai neissikraudinejama
                Timer16--;//s
                    if(Timer16<0){
                    Timer16 = 59;//m
                    Timer17--;
                        if(Timer17<0){
                        Timer17 = 59;
                        Timer18--;//h
                        }
                    }
                }
                else{
                    if(UPS_STATE==0){
                        if(SKIP==0){
                        // Jei UPS neuzsiemes ir nera SKIP'o - issikraudineti
                        UPS_STATE = 2;
                        }
                        else{
                        // Jei UPS uzimtas pratesti
                        // savaitini taimeri pusvalandziu
                        StartDischargeAfter(0,0,30,0);
                        } 
                    }
                    else{
                    // Jei UPS uzimtas pratesti
                    // savaitini taimeri pusvalandziu 
                    StartDischargeAfter(0,0,30,0);
                    }
                }
            }       
    /////////////////////////////////////////////
    ////////// Discharge Time Counter ///////////
            if(UPS_STATE==2){
            // Iskrovimo laikas skaiciuojamas tik tada kai issikraudinejama
            Timer7++;//s
            Timer24 = 0;
                if(Timer7>=60){
                Timer7 = 0;
                Timer8++;//m
                    if(Timer8>=60){
                    Timer8 = 0;
                    Timer9++;//h
                    }
                }
            }
    /////////////////////////////////////////////
        RealTime = 0;
        }
////////////////////////////////////////////////////////////////////////////////////













//////////////////////////// SKIPER ////////////////////////////////////////////////
        if(PIND.2==1){
            if(SKIP==0){
            // Isijungiant SKIP'o kontaktui - nutraukti viska ir ikrauti
            SKIP = 1;
            UPS_STATE = 1;
            }
        }
        else{
        SKIP = 0;
        }
////////////////////////////////////////////////////////////////////////////////////              













/////////////////////// UPS STATUSAS ///////////////////////////////////////////////
        if(UPS_STATE==0){
        // Nulinis statusas       
        char NulinioStatusoPadetis;
        Timer3++;// Begancio taskelio taimeris
            
            if(Timer3>=3000){// Begancio taskelio taimerio resetas
            Timer3 = 0;
            }
        NulinioStatusoPadetis = Timer3/500;
            if(NulinioStatusoPadetis==0){     LcdTaskas[0] = 1;}
            else if(NulinioStatusoPadetis==1){LcdTaskas[1] = 1;}
            else if(NulinioStatusoPadetis==2){LcdTaskas[2] = 1;}
            else if(NulinioStatusoPadetis==3){LcdTaskas[3] = 1;}   
            else if(NulinioStatusoPadetis==4){LcdTaskas[2] = 1;}
            else if(NulinioStatusoPadetis==5){LcdTaskas[1] = 1;}     

            
        // Tikrinti baterijas del issikrovimo
            if(BATTERY_VOLTAGE<=MIN_BATTERY_VOLTAGE){  
            UPS_STATE = 1;
            }
            
                        
        }
        else if(UPS_STATE==1){
        // Krovimo statusas
            if(OLD_UPS_STATE!=1){
            Timer12 = 0;
            KRAUTI = 0;
            LOAD = 0;
            }         
        // Charge State          
        Timer12++;
            if(Timer12>=30000){
            Timer12 = 0;
            }
                              
            if((Timer12>=0)&&(Timer12<3000)){
            LOAD = 1;
            KRAUTI = 0;
            LcdText[0] = 'L';LcdText[1] = 'o';LcdText[2] = 'A';LcdText[3] = 'd';
            }
            else{  
            LOAD = 0;
            KRAUTI = 1;
            LcdText[0] = 'c';LcdText[1] = 'h';LcdText[2] = 'A';LcdText[3] = 'r';
            }
            
            if(BATTERY_VOLTAGE>=MAX_BATTERY_VOLTAGE){
            // Jei baterija uzsikrovusi isjungti krovima 
            UPS_STATE = 0;
            }                      
        }
        else if(UPS_STATE==2){
        // Iskrovimo statusas
        char DchrPadetis;
        Timer24++; 
         
            if(OLD_UPS_STATE!=2){
            // Jei katik isijunge iskrovimas
             
            // Nuresetint dabartinio iskrovimo laikmati 
            Timer7 = 0;
            Timer8 = 0;
            Timer9 = 0;
            }
            
        Timer20++;// Begancio uzrasio taimeris
            if(Timer20>=7500){
            Timer20 = 0;
            }
        DchrPadetis = Timer20/500;
        led_put_runing_text(DchrPadetis,"diSchArGinG");
         
         
        BEEPER_OFF = 0;            
        // Beeper off
            if(Timer7==10){
                if(Timer8==0){
                    if(Timer9==0){
                    BEEPER_OFF = 1;
                    }
                }     
            }                   

        // Iskrovimo stabdymo blokas pagal itampos davikli:
            //if(BATTERY==0){
            if(BATTERY_VOLTAGE<=MIN_BATTERY_VOLTAGE){
            // Skaiciuoti 5 sekundes kad isjungti iskrovima kai
            // tik baterija tampa tuscia 
            Timer14++;
                if(Timer14>=5000){
                UPS_STATE = 1;// Vietoj iskrovimo ijungti krovima 
                Timer14 = 0;
                                 
                // Dabartinio iskrovimo laiko vertes 
                // perkelti i paskutinio iskrovimo laika                  
                Timer4 = Timer8;
                Timer5 = Timer9;
                  
                // Iskrovimas sekmingas todel savaitini 
                // taimeri graziname i pradines vertes
                StartDischargeAfter(7,0,0,0); 
                 
                // Jei iskrovimo laikas nesiekia 
                // 3 valandu rodyti baterijos klaida                 
                    if(Timer5<3){
                    BATTERY_FOULT = 1;
                    } 
                } 
            }
            else{
            Timer14 = 0;
            }
        }

    // Kai baigiasi krovimas, nesvarbu kas leme jo baigti
        if((OLD_UPS_STATE==1)&&(UPS_STATE!=1)){       
        Timer12 = 0;        
        KRAUTI = 0;
        LOAD = 0;
        }

    // Kai pasibaigia iskrovimas, nesvarbu kas leme jo baigti    
        if((OLD_UPS_STATE==2)&&(UPS_STATE!=2)){                  
        BEEPER_OFF = 0;
        Timer7 = 0;
        Timer8 = 0;
        Timer9 = 0;         
        Timer14 = 0;        
        }

    OLD_UPS_STATE = UPS_STATE;
////////////////////////////////////////////////////////////////////////////////////    











///////////////////////// BATTERY_FOULT ////////////////////////////////////////////
        if(BATTERY_FOULT==1){
            if(UPS_STATE==0){
            char FoultPadetis;
            static unsigned int Timer2;
            Timer2++;
                if(Timer2>=3400){
                Timer2 = 0;
                }
            FoultPadetis = Timer2/200;
            led_put_runing_text(FoultPadetis,"bAttErY FouLt");    

            LcdTaskas[0] = 0;
            LcdTaskas[1] = 0;
            LcdTaskas[2] = 0;
            LcdTaskas[3] = 0;                  
            }            
        } 
////////////////////////////////////////////////////////////////////////////////////













///////////////////////////// MYGTUKAI /////////////////////////////////////////////
    // Kai nuspaustas tik 1 mygtukas
        if((BUTTON[0]==1)&&(BUTTON[1]==0)&&(BUTTON[2]==0)&&(BUTTON[3]==0)){
            if(UPS_STATE==0){ 
            UPS_STATE = 1;
            }
        }

    // Kai nuspaustas tik 2 mygtukas:
    // Iskrovimo nutraukimas ir baterijos klaidos nuresetinimo:        
        if((BUTTON[0]==0)&&(BUTTON[1]==1)&&(BUTTON[2]==0)&&(BUTTON[3]==0)){
            if(UPS_STATE==2){
            UPS_STATE = 1;// Vietoj iskrovimo ijungti krovima
             
            // Iskrovimas nutrauktas samoningai todel savaitini 
            // taimeri graziname i pradines vertes        
            StartDischargeAfter(7,0,0,0);
            }

        // Jei buvo baterijos klaida laikant mygtuka ji nuresetinama
            if(BATTERY_FOULT==1){
            Timer10++;
                if(Timer10>=2000){// ~ 2 sec
                BATTERY_FOULT = 0;
                Timer10 = 0;
                }
            }  
        }
        else{
        Timer10 = 0;// Baterijos klaidos nuresetinimo taimeris
        }

    // Kai nuspaustas tik 3 mygtukas:
    // Iskrovimo ijungimas:     
        if((BUTTON[0]==0)&&(BUTTON[1]==0)&&(BUTTON[2]==1)&&(BUTTON[3]==0)){
            if(UPS_STATE==0){
                if(SKIP==0){
                // Jei ups neuzimtas, SKIP'o nera, tai po ~2sec isijungs iskrovimas 
                Timer11++;
                    if(Timer11>2000){
                    UPS_STATE = 2;
                    Timer11 = 0;
                    BATTERY_FOULT = 0; 
                    }
                }
                else{
                // Jei ups neuzimtas, SKIP'as yra rodyti, kad iskrovima ijungti neimanoma
                int FoultPadetis;        
                Timer19++;
                    if(Timer19>=3600){
                    Timer19 = 0;
                    }
                FoultPadetis = Timer19/200;
                led_put_runing_text(FoultPadetis,"cAnt diSchArGE"); 
                LcdTaskas[0] = 0;
                LcdTaskas[1] = 0;
                LcdTaskas[2] = 0;
                LcdTaskas[3] = 0;                       
                }
            }     
        }
        else{
        Timer11 = 0;
        Timer19 = 0;
        }

    // Kai nuspaustas 4 mygtukas, o su visais kitais valdoma
        if(BUTTON[3]==1){
         
            // Langu valdymas
            if(BUTTON[2]==1){
                if(LanguTrigeris==0){
                LanguTrigeris = 1;
                LangoAdresas++;
                    if(LangoAdresas>4){
                    LangoAdresas = 0;
                    }
                }
            }
            else{
            LanguTrigeris = 0;
            }

            // Paskutinio iskrovimo langas            
            if(LangoAdresas==0){
                if(UPS_STATE==2){
                    if(Timer9>=10){             
                    LcdText[0] = NumToIndex(Timer9/10);
                    LcdText[1] = NumToIndex(Timer9 - (Timer9/10)*10);
                    LcdText[2] = NumToIndex(Timer8/10);
                    LcdText[3] = NumToIndex(Timer8 - (Timer8/10)*10);
                 
                    LcdTaskas[0] = 0;
                    LcdTaskas[1] = 1;
                    LcdTaskas[2] = 0;
                    LcdTaskas[3] = 0;
                    }
                    else if(Timer9==0){
                    LcdText[0] = NumToIndex(Timer8/10);
                    LcdText[1] = NumToIndex(Timer8 - (Timer8/10)*10);
                    LcdText[2] = NumToIndex(Timer7/10);
                    LcdText[3] = NumToIndex(Timer7 - (Timer7/10)*10);
                          
                    LcdTaskas[0] = 0;
                        if(Timer24<=300){
                        LcdTaskas[1] = 1;
                        }
                        else{
                        LcdTaskas[1] = 0;
                        }
                    LcdTaskas[2] = 0;
                    LcdTaskas[3] = 0;
                    }
                    else if((Timer9>=1)&&(Timer9<=9)){
                    LcdText[0] = NumToIndex(Timer9 - (Timer9/10)*10);  
                    LcdText[1] = NumToIndex(Timer8/10);
                    LcdText[2] = NumToIndex(Timer8 - (Timer8/10)*10);
                    LcdText[3] = NumToIndex(Timer7/10);
                                 
                    LcdTaskas[0] = 1;
                    LcdTaskas[1] = 0;
                        if(Timer24<=300){
                        LcdTaskas[2] = 1;
                        }
                        else{
                        LcdTaskas[2] = 0;
                        }               
                    LcdTaskas[3] = 0;
                    }   
                }
                else{
                LcdText[0] = NumToIndex(Timer5/10);
                LcdText[1] = NumToIndex(Timer5 - (Timer5/10)*10);
                LcdText[2] = NumToIndex(Timer4/10);
                LcdText[3] = NumToIndex(Timer4 - (Timer4/10)*10);
                
                LcdTaskas[0] = 0;
                LcdTaskas[1] = 1;
                LcdTaskas[2] = 0;
                LcdTaskas[3] = 0;
                }
            }
             
            // Dabartine itampa
            if(LangoAdresas==1){
            char Padetis;
            static unsigned int Timer26;
                if(Timer26<=1500){
                Timer26++;
                }
            Padetis = Timer26/300;
              
            LcdTaskas[0] = 0;
            LcdTaskas[1] = 0;
            LcdTaskas[2] = 0;
            LcdTaskas[3] = 0;
                if(Padetis==1){
                LcdText[0] = ' ';
                LcdText[1] = ' ';  
                LcdText[2] = ' ';              
                LcdText[3] = 'U';
                }
                else if(Padetis==2){
                LcdText[0] = ' ';
                LcdText[1] = ' ';  
                LcdText[2] = 'U';              
                LcdText[3] = '=';
                }
                else if(Padetis==3){
                LcdText[0] = ' ';
                LcdText[1] = 'U';  
                LcdText[2] = '=';              
                LcdText[3] = NumToIndex( BATTERY_VOLTAGE/100 );
                }
                else if(Padetis==4){
                LcdText[0] = 'U';
                LcdText[1] = '=';  
                LcdText[2] = NumToIndex( BATTERY_VOLTAGE/100 );              
                LcdText[3] = NumToIndex( (BATTERY_VOLTAGE-(BATTERY_VOLTAGE/100)*100)/10);
                LcdTaskas[3] = 1; 
                }
                else if(Padetis==5){
                LcdText[0] = '=';
                LcdText[1] = NumToIndex( BATTERY_VOLTAGE/100 );  
                LcdText[2] = NumToIndex( (BATTERY_VOLTAGE-(BATTERY_VOLTAGE/100)*100)/10);              
                LcdText[3] = NumToIndex(  BATTERY_VOLTAGE-(BATTERY_VOLTAGE/10)*10);
                LcdTaskas[2] = 1;
                }
                else{
                LcdText[0] = ' ';
                LcdText[1] = ' ';  
                LcdText[2] = ' ';              
                LcdText[3] = ' ';
                }     
            }
            else{
            Timer26 = 0; 
            }
         
            // Minimali itampa            
            if(LangoAdresas==2){ 
            char Padetis;
            static unsigned int Timer27;
                if(Timer27<=3300){
                Timer27++;
                }
            Padetis = Timer27/300;
              
            LcdTaskas[0] = 0;
            LcdTaskas[1] = 0;
            LcdTaskas[2] = 0;
            LcdTaskas[3] = 0;
                if(Padetis==1){
                LcdText[0] = ' ';
                LcdText[1] = ' ';  
                LcdText[2] = ' ';              
                LcdText[3] = 'F';
                }
                else if(Padetis==2){
                LcdText[0] = ' ';
                LcdText[1] = ' ';  
                LcdText[2] = 'F';              
                LcdText[3] = 'L';
                }
                else if(Padetis==3){
                LcdText[0] = ' ';
                LcdText[1] = 'F';  
                LcdText[2] = 'L';              
                LcdText[3] = 'o';
                }
                else if(Padetis==4){
                LcdText[0] = 'F';
                LcdText[1] = 'L';  
                LcdText[2] = 'o';              
                LcdText[3] = 'o';
                }
                else if(Padetis==5){
                LcdText[0] = 'L';
                LcdText[1] = 'o';  
                LcdText[2] = 'o';              
                LcdText[3] = 'r';
                }
                else if(Padetis==6){
                LcdText[0] = 'o';
                LcdText[1] = 'o';  
                LcdText[2] = 'r';              
                LcdText[3] = '_';
                }
                else if(Padetis==7){
                LcdText[0] = 'o';
                LcdText[1] = 'r';  
                LcdText[2] = '_';              
                LcdText[3] = 'U';
                }
                else if(Padetis==8){
                LcdText[0] = 'r';
                LcdText[1] = '_';  
                LcdText[2] = 'U';              
                LcdText[3] = '=';
                }
                else if(Padetis==9){
                LcdText[0] = '_';
                LcdText[1] = 'U';  
                LcdText[2] = '=';              
                LcdText[3] = NumToIndex( MIN_BATTERY_VOLTAGE/100 );
                }
                else if(Padetis==10){
                LcdText[0] = 'U';
                LcdText[1] = '=';  
                LcdText[2] = NumToIndex( MIN_BATTERY_VOLTAGE/100 );              
                LcdText[3] = NumToIndex( (MIN_BATTERY_VOLTAGE-(MIN_BATTERY_VOLTAGE/100)*100)/10);
                LcdTaskas[3] = 1; 
                }
                else if(Padetis==11){
                LcdText[0] = '=';
                LcdText[1] = NumToIndex( MIN_BATTERY_VOLTAGE/100 );  
                LcdText[2] = NumToIndex( (MIN_BATTERY_VOLTAGE-(MIN_BATTERY_VOLTAGE/100)*100)/10);              
                LcdText[3] = NumToIndex(  MIN_BATTERY_VOLTAGE-(MIN_BATTERY_VOLTAGE/10)*10);
                LcdTaskas[2] = 1; 
                }
                else{
                LcdText[0] = ' ';
                LcdText[1] = ' ';  
                LcdText[2] = ' ';              
                LcdText[3] = ' ';
                }  

                if((BUTTON[0]==0)&&(BUTTON[1]==1)&&(BUTTON[2]==0)){
                    if(ItamposTrigeris1==0){
                    MIN_BATTERY_VOLTAGE++;
                    ItamposTrigeris1 = 1; 
                    } 
                }
                else if((BUTTON[0]==1)&&(BUTTON[1]==0)&&(BUTTON[2]==0)){
                    if(ItamposTrigeris1==0){
                    MIN_BATTERY_VOLTAGE--;
                    ItamposTrigeris1 = 1; 
                    } 
                }
                else{
                ItamposTrigeris1 = 0;
                }
            }
            else{
            Timer27 = 0; 
            }
                      
            // Maksimali itampa
            if(LangoAdresas==3){
            char Padetis;
            static unsigned int Timer28;
                if(Timer28<=2700){
                Timer28++;
                }
            Padetis = Timer28/300;
                  
            LcdTaskas[0] = 0;
            LcdTaskas[1] = 0;
            LcdTaskas[2] = 0;
            LcdTaskas[3] = 0;
                if(Padetis==1){
                LcdText[0] = ' ';
                LcdText[1] = ' ';  
                LcdText[2] = ' ';              
                LcdText[3] = 't';
                }
                else if(Padetis==2){
                LcdText[0] = ' ';
                LcdText[1] = ' ';  
                LcdText[2] = 't';              
                LcdText[3] = 'o';
                }
                else if(Padetis==3){
                LcdText[0] = ' ';
                LcdText[1] = 't';  
                LcdText[2] = 'o';              
                LcdText[3] = 'P';
                }
                else if(Padetis==4){
                LcdText[0] = 't';
                LcdText[1] = 'o';  
                LcdText[2] = 'P';              
                LcdText[3] = '_';
                }
                else if(Padetis==5){
                LcdText[0] = 'o';
                LcdText[1] = 'P';  
                LcdText[2] = '_';              
                LcdText[3] = 'U';
                }
                else if(Padetis==6){
                LcdText[0] = 'P';
                LcdText[1] = '_';  
                LcdText[2] = 'U';              
                LcdText[3] = '=';
                }
                else if(Padetis==7){
                LcdText[0] = '_';
                LcdText[1] = 'U';  
                LcdText[2] = '=';              
                LcdText[3] = NumToIndex( MAX_BATTERY_VOLTAGE/100 );
                }
                else if(Padetis==8){
                LcdText[0] = 'U';
                LcdText[1] = '=';  
                LcdText[2] = NumToIndex( MAX_BATTERY_VOLTAGE/100 );              
                LcdText[3] = NumToIndex( (MAX_BATTERY_VOLTAGE-(MAX_BATTERY_VOLTAGE/100)*100)/10);
                LcdTaskas[3] = 1; 
                }
                else if(Padetis==9){
                LcdText[0] = '=';
                LcdText[1] = NumToIndex( MAX_BATTERY_VOLTAGE/100 );  
                LcdText[2] = NumToIndex( (MAX_BATTERY_VOLTAGE-(MAX_BATTERY_VOLTAGE/100)*100)/10);              
                LcdText[3] = NumToIndex(  MAX_BATTERY_VOLTAGE-(MAX_BATTERY_VOLTAGE/10)*10);
                LcdTaskas[2] = 1; 
                }
                else{
                LcdText[0] = ' ';
                LcdText[1] = ' ';  
                LcdText[2] = ' ';              
                LcdText[3] = ' ';
                }  

                if((BUTTON[0]==0)&&(BUTTON[1]==1)&&(BUTTON[2]==0)){
                    if(ItamposTrigeris2==0){
                    MAX_BATTERY_VOLTAGE++;
                    ItamposTrigeris2 = 1; 
                    } 
                }
                else if((BUTTON[0]==1)&&(BUTTON[1]==0)&&(BUTTON[2]==0)){
                    if(ItamposTrigeris2==0){
                    MAX_BATTERY_VOLTAGE--;
                    ItamposTrigeris2 = 1; 
                    } 
                }
                else{
                ItamposTrigeris2 = 0;
                }
            }
            else{
            Timer28 = 0;
            }  
        }
        else{
        LangoAdresas = 0;
        }
        
    // Kai nuspaustas tik 1 ir 4 mygtukas:
    // Krovimo nutraukimo funkcija:              
        if((BUTTON[0]==1)&&(BUTTON[1]==0)&&(BUTTON[2]==0)&&(BUTTON[3]==1)){
        // Charge Off
        static unsigned int Timer21;                
            if(UPS_STATE==1){
            Timer21++;
                if(Timer21>=5000){
                UPS_STATE = 0;
                }
            }
            else{
            Timer21 = 0;
            }
        }
        else{
        Timer21 = 0;
        }    
        
////////////////////////////////////////////////////////////////////////////////////       









    RelayOutputs();
    CheckButtons();
    UpdateLcd();

    delay_us(900);
    }
}
