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

///////////////////// VARIABLES /////////////////////////////////////
int OSC;
char BUTTON[4];
char BATTERY;
char SKIP;
char UPS_STATE,OLD_UPS_STATE;
eeprom char BATTERY_FOULT;
char KRAUTI, LOAD, BEEPER_OFF;

char LcdText[4], LcdTaskas[4];

unsigned int Timer1;// "HELLO" Taimeris

unsigned int Timer2;// "BattErY Foult" Taimeris

unsigned int Timer3;// Begancio Taskelio Taimeris

eeprom unsigned int Timer4;// Paskutinio Iskrorivimo valandos
eeprom unsigned int Timer5;// Paskutinio Iskrorivimo minutes

unsigned int Timer6;// Dabartinio Iskrovimo Laiko Sekundes Dalis
unsigned int Timer7;// Dabartinio Iskrovimo Laiko Sekundziu Skaicius
unsigned int Timer8;// Dabartinio Iskrovimo Laiko Minuciu Skaicius
unsigned int Timer9;// Dabartinio Iskrovimo Laiko Valandu Skaicius

unsigned int Timer10;// 2 Mygtuko Uzlaikymo Taimeris

unsigned int Timer11;// 3 Mygtuko Uzlaikymo Taimeris

unsigned int Timer12;// Krovimo taimeris (30 sec)

unsigned int Timer13;// Krovimo sustabdymo taimeris

unsigned int Timer14;// Iskrovimo sustabdymo taimeris

signed int Timer15;// 1 savaites taimerio sekundes dalis
signed int Timer16;// 1 savaites taimerio sekundziu skaicius
eeprom signed int Timer17;// 1 savaites taimerio minuciu skaicius
eeprom signed int Timer18;// 1 savaites taimerio valandu skaicius

unsigned int Timer19;// "diSchArGE FouLt" taimeris

unsigned int Timer20;// "diSchArGinG" taimeris

unsigned int Timer21;// krovimo isjungimo mygtuku taimeris (5sec) (1 ir 4 mygtukai)

unsigned int Timer22;// Sekundes trukmes keitimo taimeris

unsigned int Timer23;// Paskutinio iskrovimo reseto uzlaikymas

eeprom unsigned int REFRESH_RATE;
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
        if(LcdChannel==0){     PORTC.7 = 1;PORTA.6 = 0;PORTA.7 = 0;PORTA.4 = 0;}
        else if(LcdChannel==1){PORTC.7 = 0;PORTA.6 = 1;PORTA.7 = 0;PORTA.4 = 0;}
        else if(LcdChannel==2){PORTC.7 = 0;PORTA.6 = 0;PORTA.7 = 1;PORTA.4 = 0;}
        else if(LcdChannel==3){PORTC.7 = 0;PORTA.6 = 0;PORTA.7 = 0;PORTA.4 = 1;}
            
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
        if(a==1){                    PORTC.6 = 0;}else{PORTC.6 = 1;}
        if(b==1){                    PORTC.4 = 0;}else{PORTC.4 = 1;}
        if(c==1){                    PORTC.1 = 0;}else{PORTC.1 = 1;}
        if(d==1){                    PORTC.3 = 0;}else{PORTC.3 = 1;}  
        if(e==1){                    PORTD.7 = 0;}else{PORTD.7 = 1;}  
        if(f==1){                    PORTC.5 = 0;}else{PORTC.5 = 1;}  
        if(g==1){                    PORTC.0 = 0;}else{PORTC.0 = 1;}  
        if(LcdTaskas[LcdChannel]==1){PORTC.2 = 0;}else{PORTC.2 = 1;}
    }
    else{
    PORTC.6 = 1;    // a
    PORTC.4 = 1;    // b  
    PORTC.1 = 1;    // c
    PORTC.3 = 1;    // d
    PORTD.7 = 1;    // e
    PORTC.5 = 1;    // f
    PORTC.0 = 1;    // g
    PORTC.2 = 1;    // h
        
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
char GELTONAS, RAUDONAS, ZALIAS;
     if(PINB.0==1){GELTONAS = 1;}else{GELTONAS = 0;}
     if(PINB.1==1){RAUDONAS = 1;}else{RAUDONAS = 0;}
     if(PINB.4==1){ZALIAS = 1;  }else{ZALIAS = 0;  }
     
     if((RAUDONAS==0)&&(GELTONAS==0)&&(ZALIAS==0)){     BATTERY = 0;}    
     else if((RAUDONAS==1)&&(GELTONAS==0)&&(ZALIAS==0)){BATTERY = 0;}
     else if((RAUDONAS==1)&&(GELTONAS==1)&&(ZALIAS==0)){BATTERY = 1;}
     else if((RAUDONAS==0)&&(GELTONAS==1)&&(ZALIAS==0)){BATTERY = 2;}
     else if((RAUDONAS==0)&&(GELTONAS==1)&&(ZALIAS==1)){BATTERY = 3;}
     else if((RAUDONAS==0)&&(GELTONAS==0)&&(ZALIAS==1)){BATTERY = 4;}
     else if((RAUDONAS==1)&&(GELTONAS==1)&&(ZALIAS==1)){BATTERY = 4;}
     else if((RAUDONAS==1)&&(GELTONAS==0)&&(ZALIAS==1)){BATTERY = 4;}
return 1;
}

void main(void){
// Crystal Oscillator division factor: 1
PORTA=0x00;
DDRA=0b11010000;

PORTB=0x00;
DDRB=0b00000000;

PORTC=0x00;
DDRC=0b11111111;

PORTD=0x00;
DDRD=0b11111100;

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

    if((Timer4==65535)||(Timer5==65535)){Timer4 = 0;Timer5 = 0;}
    if(BATTERY_FOULT==255){BATTERY_FOULT= 0;}
    if(REFRESH_RATE==65535){REFRESH_RATE = 75;}

    if((Timer15==32767)||(Timer16==32767)||(Timer17==32767)||(Timer18==32767)){
    Timer15 = 0;Timer16=0;Timer17=0;Timer18=168;}
    if((Timer15<0)||(Timer16<0)||(Timer17<0)||(Timer18<0)){
    Timer15 = 0;Timer16=0;Timer17=0;Timer18=168;}

UPS_STATE = 1;

// Ijungiant prabega uzrasas "HELLO"
    while(Timer1<2000){
    char HelloPadetis = Timer1/200;
    UpdateVariableOSC();
    Timer1++;                          
        if(HelloPadetis==1){                                                        LcdText[3] = 'H';}
        else if(HelloPadetis==2){                                  LcdText[2] = 'H';LcdText[3] = 'E';}
        else if(HelloPadetis==3){                 LcdText[1] = 'H';LcdText[2] = 'E';LcdText[3] = 'L';}
        else if(HelloPadetis==4){LcdText[0] = 'H';LcdText[1] = 'E';LcdText[2] = 'L';LcdText[3] = 'L';}
        else if(HelloPadetis==5){LcdText[0] = 'E';LcdText[1] = 'L';LcdText[2] = 'L';LcdText[3] = 'O';}
        else if(HelloPadetis==6){LcdText[0] = 'L';LcdText[1] = 'L';LcdText[2] = 'O';}
        else if(HelloPadetis==7){LcdText[0] = 'L';LcdText[1] = 'O';}
        else if(HelloPadetis==8){LcdText[0] = 'O';}  
    UpdateLcd();         
    delay_ms(1);
    }  

// Programos kodas
    while(1){
    UpdateVariableOSC();
    CheckBattery();
//////////////////////////// SKIPER ////////////////////////////////////////////////
        if(PIND.2==1){
            if(SKIP==0){
                if(UPS_STATE==2){
                Timer15 = 0;Timer16 = 0;Timer17 = 30;Timer18 = 0;
                }           
            UPS_STATE = 1;
            SKIP = 1;      
            }
        }
        else{
        SKIP = 0;
        }
////////////////////////////////////////////////////////////////////////////////////         
///////////////////////////// 1 SAVAITES TIMERIS ///////////////////////////////////
        if(UPS_STATE!=2){
            if((Timer15>0)||(Timer16>0)||(Timer17>0)||(Timer18>0)){
            Timer15--;
                if(Timer15<0){
                Timer15 = 999;
                Timer16--;
                    if(Timer16<0){
                    Timer16 = 59;
                    Timer17--;
                        if(Timer17<0){
                        Timer17 = 59;
                        Timer18--;
                        }
                    }
                }
            }
            else{
                if((SKIP==1)||(UPS_STATE!=0)){
                Timer15 = 0;Timer16 = 0;Timer17 = 30;Timer18 = 0;  
                }
                else{
                UPS_STATE = 2;
                Timer15 = 0;Timer16 = 0;Timer17 = 0;Timer18 = 168;
                }
            }
        }
             
////////////////////////////////////////////////////////////////////////////////////     
/////////////////////// UPS STATUSAS ///////////////////////////////////////////////
        if(UPS_STATE==0){
        // Nulinis statusas       
        char NulinioStatusoPadetis;
        Timer3++;
            if(Timer3>=3000){
            Timer3 = 0;
            }
        NulinioStatusoPadetis = Timer3/500;
            if(NulinioStatusoPadetis==0){     LcdTaskas[0] = 1;}
            else if(NulinioStatusoPadetis==1){LcdTaskas[1] = 1;}
            else if(NulinioStatusoPadetis==2){LcdTaskas[2] = 1;}
            else if(NulinioStatusoPadetis==3){LcdTaskas[3] = 1;}   
            else if(NulinioStatusoPadetis==4){LcdTaskas[2] = 1;}
            else if(NulinioStatusoPadetis==5){LcdTaskas[1] = 1;} 
        }
        else if(UPS_STATE==1){
        // Krovimas
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

        // Stop Charge
            if(BATTERY==4){
            Timer13++;
                if(Timer13>=5000){
                UPS_STATE = 0;
                Timer13 = 0;
                }
            }
            else{
            Timer13 = 0;
            }                      
        }
        else if(UPS_STATE==2){
        char DchrPadetis;
        // Iskrovimas
            if(OLD_UPS_STATE!=2){
            Timer6 = 0;
            Timer7 = 0;
            Timer8 = 0;
            Timer9 = 0;
            }
            
        Timer20++;
            if(Timer20>=7500){
            Timer20 = 0;
            }
        DchrPadetis = Timer20/500;
            if(DchrPadetis==1){       LcdText[0] = ' ';LcdText[1] = ' ';LcdText[2] = ' ';LcdText[3] = 'd';}
            else if (DchrPadetis==2){ LcdText[0] = ' ';LcdText[1] = ' ';LcdText[2] = 'd';LcdText[3] = 'i';}
            else if (DchrPadetis==3){ LcdText[0] = ' ';LcdText[1] = 'd';LcdText[2] = 'i';LcdText[3] = 'S';}
            else if (DchrPadetis==4){ LcdText[0] = 'd';LcdText[1] = 'i';LcdText[2] = 'S';LcdText[3] = 'c';}
            else if (DchrPadetis==5){ LcdText[0] = 'i';LcdText[1] = 'S';LcdText[2] = 'c';LcdText[3] = 'h';}
            else if (DchrPadetis==6){ LcdText[0] = 'S';LcdText[1] = 'c';LcdText[2] = 'h';LcdText[3] = 'A';}
            else if (DchrPadetis==7){ LcdText[0] = 'c';LcdText[1] = 'h';LcdText[2] = 'A';LcdText[3] = 'r';}
            else if (DchrPadetis==8){ LcdText[0] = 'h';LcdText[1] = 'A';LcdText[2] = 'r';LcdText[3] = 'G';}    
            else if (DchrPadetis==9){ LcdText[0] = 'A';LcdText[1] = 'r';LcdText[2] = 'G';LcdText[3] = 'i';}
            else if (DchrPadetis==10){LcdText[0] = 'r';LcdText[1] = 'G';LcdText[2] = 'i';LcdText[3] = 'n';}
            else if (DchrPadetis==11){LcdText[0] = 'G';LcdText[1] = 'i';LcdText[2] = 'n';LcdText[3] = 'G';}
            else if (DchrPadetis==12){LcdText[0] = 'i';LcdText[1] = 'n';LcdText[2] = 'G';LcdText[3] = ' ';}
            else if (DchrPadetis==13){LcdText[0] = 'n';LcdText[1] = 'G';LcdText[2] = ' ';LcdText[3] = ' ';}
            else if (DchrPadetis==14){LcdText[0] = 'G';LcdText[1] = ' ';LcdText[2] = ' ';LcdText[3] = ' ';}
          
        Timer6++;
            if(Timer6>=1000){
            Timer6 = 0;
            Timer7++;
                if(Timer7>=60){
                Timer7 = 0;
                Timer8++;
                    if(Timer8>=60){
                    Timer8 = 0;
                    Timer9++;
                    }
                }
            }


        BEEPER_OFF = 0;            
        // Beeper off
            if(Timer7==10){
                if(Timer8==0){
                    if(Timer9==0){
                    BEEPER_OFF = 1;
                    }
                }     
            }                   

        // Stop Discharge
            if(BATTERY==0){
            Timer14++;
                if(Timer14>=5000){
                UPS_STATE = 1;
                Timer14 = 0;
                                 
                // Laiko Issaugojimas                  
                Timer4 = Timer8;
                Timer5 = Timer9;
                  
                // 1 Savaite
                Timer15 = 0;Timer16 = 0;Timer17 = 0;Timer18 = 168;  
                    if(Timer5<3){
                    BATTERY_FOULT = 1;
                    } 
                } 
            }
            else{
            Timer14 = 0;
            }
        }


        if((OLD_UPS_STATE==1)&&(UPS_STATE!=1)){
        // Kai baigiasi krovimas
        Timer12 = 0;        
        KRAUTI = 0;
        LOAD = 0;
        Timer13 = 0; 
        }
        if((OLD_UPS_STATE==2)&&(UPS_STATE!=2)){
        // Kai pasibaigia iskrovimas          
        BEEPER_OFF = 0;    
        Timer6 = 0;
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
            Timer2++;
                if(Timer2>=3400){
                Timer2 = 0;
                }
            FoultPadetis = Timer2/200;
                if(FoultPadetis==1){      LcdText[0] = ' ';LcdText[1] = ' ';LcdText[2] = ' ';LcdText[3] = 'b';} 
                else if(FoultPadetis==2){ LcdText[0] = ' ';LcdText[1] = ' ';LcdText[2] = 'b';LcdText[3] = 'A';}
                else if(FoultPadetis==3){ LcdText[0] = ' ';LcdText[1] = 'b';LcdText[2] = 'A';LcdText[3] = 't';}
                else if(FoultPadetis==4){ LcdText[0] = 'b';LcdText[1] = 'A';LcdText[2] = 't';LcdText[3] = 't';}
                else if(FoultPadetis==5){ LcdText[0] = 'A';LcdText[1] = 't';LcdText[2] = 't';LcdText[3] = 'E';}
                else if(FoultPadetis==6){ LcdText[0] = 't';LcdText[1] = 't';LcdText[2] = 'E';LcdText[3] = 'r';}
                else if(FoultPadetis==7){ LcdText[0] = 't';LcdText[1] = 'E';LcdText[2] = 'r';LcdText[3] = 'Y';}
                else if(FoultPadetis==8){ LcdText[0] = 'E';LcdText[1] = 'r';LcdText[2] = 'Y';LcdText[3] = ' ';}
                else if(FoultPadetis==9){ LcdText[0] = 'r';LcdText[1] = 'Y';LcdText[2] = ' ';LcdText[3] = 'F';}
                else if(FoultPadetis==10){LcdText[0] = 'Y';LcdText[1] = ' ';LcdText[2] = 'F';LcdText[3] = 'o';}
                else if(FoultPadetis==11){LcdText[0] = ' ';LcdText[1] = 'F';LcdText[2] = 'o';LcdText[3] = 'u';}
                else if(FoultPadetis==12){LcdText[0] = 'F';LcdText[1] = 'o';LcdText[2] = 'u';LcdText[3] = 'L';}
                else if(FoultPadetis==13){LcdText[0] = 'o';LcdText[1] = 'u';LcdText[2] = 'L';LcdText[3] = 't';}
                else if(FoultPadetis==14){LcdText[0] = 'u';LcdText[1] = 'L';LcdText[2] = 't';LcdText[3] = ' ';}
                else if(FoultPadetis==15){LcdText[0] = 'L';LcdText[1] = 't';LcdText[2] = ' ';LcdText[3] = ' ';}
                else if(FoultPadetis==16){LcdText[0] = 't';LcdText[1] = ' ';LcdText[2] = ' ';LcdText[3] = ' ';}
            LcdTaskas[0] = 0;
            LcdTaskas[1] = 0;
            LcdTaskas[2] = 0;
            LcdTaskas[3] = 0;                  
            }            
        } 
////////////////////////////////////////////////////////////////////////////////////
///////////////////////////// MYGTUKAI /////////////////////////////////////////////
        if(BUTTON[0]==1){
            if(UPS_STATE==0){
            UPS_STATE = 1;
            }
        }
        
        if(BUTTON[1]==1){
            if(UPS_STATE==2){
            UPS_STATE = 1;
            KRAUTI = 0;
            LOAD = 0;
            Timer16=0;Timer17=0;Timer18=168;
            }
            if(BATTERY_FOULT==1){
            Timer10++;
                if(Timer10>=2000){
                BATTERY_FOULT = 0;
                Timer10 = 0;
                }
            }  
        }
        else{
        Timer10 = 0;
        }
        
        if(BUTTON[2]==1){
            if(UPS_STATE==0){
                if(SKIP==0){
                Timer11++;
                    if(Timer11>2000){
                    UPS_STATE = 2;
                    Timer11 = 0;
                    BATTERY_FOULT = 0;
                    Timer16=0;Timer17=0;Timer18=168; 
                    }
                }
                else{
                int FoultPadetis;        
                Timer19++;
                    if(Timer19>=3800){
                    Timer19 = 0;
                    }
                FoultPadetis = Timer19/200;
                                                
                    if(FoultPadetis==1){      LcdText[0] = ' ';LcdText[1] = ' ';LcdText[2] = ' ';LcdText[3] = 'd';} 
                    else if(FoultPadetis==2){ LcdText[0] = ' ';LcdText[1] = ' ';LcdText[2] = 'd';LcdText[3] = 'i';}
                    else if(FoultPadetis==3){ LcdText[0] = ' ';LcdText[1] = 'd';LcdText[2] = 'i';LcdText[3] = 'S';}
                    else if(FoultPadetis==4){ LcdText[0] = 'd';LcdText[1] = 'i';LcdText[2] = 'S';LcdText[3] = 'c';}
                    else if(FoultPadetis==5){ LcdText[0] = 'i';LcdText[1] = 'S';LcdText[2] = 'c';LcdText[3] = 'h';}
                    else if(FoultPadetis==6){ LcdText[0] = 'S';LcdText[1] = 'c';LcdText[2] = 'h';LcdText[3] = 'A';}
                    else if(FoultPadetis==7){ LcdText[0] = 'c';LcdText[1] = 'h';LcdText[2] = 'A';LcdText[3] = 'r';}
                    else if(FoultPadetis==8){ LcdText[0] = 'h';LcdText[1] = 'A';LcdText[2] = 'r';LcdText[3] = 'G';}
                    else if(FoultPadetis==9){ LcdText[0] = 'A';LcdText[1] = 'r';LcdText[2] = 'G';LcdText[3] = 'E';}
                    else if(FoultPadetis==10){LcdText[0] = 'r';LcdText[1] = 'G';LcdText[2] = 'E';LcdText[1] = ' ';}
                    else if(FoultPadetis==11){LcdText[0] = 'G';LcdText[1] = 'E';LcdText[1] = ' ';LcdText[3] = 'F';}
                    else if(FoultPadetis==12){LcdText[0] = 'E';LcdText[1] = ' ';LcdText[2] = 'F';LcdText[3] = 'o';}
                    else if(FoultPadetis==13){LcdText[1] = ' ';LcdText[1] = 'F';LcdText[2] = 'o';LcdText[3] = 'u';}
                    else if(FoultPadetis==14){LcdText[0] = 'F';LcdText[1] = 'o';LcdText[2] = 'u';LcdText[3] = 'L';}
                    else if(FoultPadetis==15){LcdText[0] = 'o';LcdText[1] = 'u';LcdText[2] = 'L';LcdText[3] = 't';}
                    else if(FoultPadetis==16){LcdText[0] = 'u';LcdText[1] = 'L';LcdText[2] = 't';LcdText[3] = ' ';}
                    else if(FoultPadetis==17){LcdText[0] = 'L';LcdText[1] = 't';LcdText[2] = ' ';LcdText[3] = ' ';}
                    else if(FoultPadetis==18){LcdText[0] = 't';LcdText[1] = ' ';LcdText[2] = ' ';LcdText[3] = ' ';}
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
        
        if(BUTTON[3]==1){
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
                    if(Timer6<=300){
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
                    if(Timer6<=300){
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

        if((BUTTON[2]==1)&&(BUTTON[3]==1)){
        // Refresh Rate
        LcdText[0] = NumToIndex(REFRESH_RATE/1000);
        LcdText[1] = NumToIndex( (REFRESH_RATE-(REFRESH_RATE/1000)*1000)/100 );
        LcdText[2] = NumToIndex( (REFRESH_RATE-(REFRESH_RATE/100)*100)/10 );
        LcdText[3] = NumToIndex(  REFRESH_RATE-(REFRESH_RATE/10)*10 );
        LcdTaskas[0] = 0;
        LcdTaskas[1] = 0;
        LcdTaskas[2] = 0;
        LcdTaskas[3] = 1;
            if(BUTTON[0]==1){
            Timer22++;
                if(Timer22>=500){
                Timer22 = 0;
                }
             
                if(Timer22==0){
                REFRESH_RATE--;
                }
            }
            else if(BUTTON[1]==1){
            Timer22++;
                if(Timer22>=500){
                Timer22 = 0;
                }
             
                if(Timer22==0){
                REFRESH_RATE++;
                }
            }
            else{
            Timer22 = 0;
            }
        }
        else{
        Timer22 = 0;
        } 
              
        if((BUTTON[0]==1)&&(BUTTON[3]==1)){
        // Charge Off
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

        if((BUTTON[0]==1)&&(BUTTON[1]==1)&&(BUTTON[2]==1)&&(BUTTON[3]==1)){
        // Reset Last Discharge
        Timer23++;
            if(Timer23>=5000){
            char ResetPadetis;      
            Timer4 = 0; 
            Timer5 = 0;
             
            ResetPadetis = Timer23/500;
                if(ResetPadetis==10){LcdText[0] = ' ';LcdText[1] = ' ';LcdText[2] = ' ';LcdText[3] = 'r';}
                if(ResetPadetis==11){LcdText[0] = ' ';LcdText[1] = ' ';LcdText[2] = 'r';LcdText[3] = 'E';}
                if(ResetPadetis==12){LcdText[0] = ' ';LcdText[1] = 'r';LcdText[2] = 'E';LcdText[3] = 'S';}
                if(ResetPadetis==13){LcdText[0] = 'r';LcdText[1] = 'E';LcdText[2] = 'S';LcdText[3] = 'E';}
                if(ResetPadetis==14){LcdText[0] = 'E';LcdText[1] = 'S';LcdText[2] = 'E';LcdText[3] = 't';}
                if(ResetPadetis==15){LcdText[0] = 'S';LcdText[1] = 'E';LcdText[2] = 't';LcdText[3] = 'E';}
                if(ResetPadetis==16){LcdText[0] = 'E';LcdText[1] = 't';LcdText[2] = 'E';LcdText[3] = 'd';}
                if(ResetPadetis==17){LcdText[0] = 't';LcdText[1] = 'E';LcdText[2] = 'd';LcdText[3] = ' ';}
                if(ResetPadetis==18){LcdText[0] = 'E';LcdText[1] = 'd';LcdText[2] = ' ';LcdText[3] = ' ';}
                if(ResetPadetis==19){LcdText[0] = 'd';LcdText[1] = ' ';LcdText[2] = ' ';LcdText[3] = ' ';} 
            }
        }
        else{
        Timer23 = 0;
        }
////////////////////////////////////////////////////////////////////////////////////       
    RelayOutputs();
    CheckButtons();
    UpdateLcd();
        if(REFRESH_RATE>0){
        unsigned int i;
            for(i=0;i<REFRESH_RATE;i++){
            delay_us(1);
            }
        }
        else{
        delay_us(1);
        }        
    }
}
