/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/7/2011
Author  : NeVaDa
Company : Home
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 4.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <delay.h>

///////////// BUTTONS /////////////
// " <||> | +||-||* " 
#define BUTTON_DESCRIPTION1   " <"   
#define BUTTON_DESCRIPTION1_0 "  "

#define BUTTON_DESCRIPTION2   "||"   
#define BUTTON_DESCRIPTION2_0 "  "

#define BUTTON_DESCRIPTION3   ">"    
#define BUTTON_DESCRIPTION3_0 " "

#define BUTTON_DESCRIPTION4   " | "  
#define BUTTON_DESCRIPTION4_0 "   "

#define BUTTON_DESCRIPTION5   "+"    
#define BUTTON_DESCRIPTION5_0 " "

#define BUTTON_DESCRIPTION6   "||"   
#define BUTTON_DESCRIPTION6_0 "  "

#define BUTTON_DESCRIPTION7   "-"    
#define BUTTON_DESCRIPTION7_0 " "

#define BUTTON_DESCRIPTION8   "||"   
#define BUTTON_DESCRIPTION8_0 "  "

#define BUTTON_DESCRIPTION9   "* "   
#define BUTTON_DESCRIPTION9_0 "  "

// PINS
#define BUTTON_INPUT1 PIND.6 
#define BUTTON_INPUT2 PIND.5 
#define BUTTON_INPUT3 PIND.4 
#define BUTTON_INPUT4 PIND.3 
#define BUTTON_INPUT5 PIND.2 
///////////////////////////////////

// Inputs / Outputs
#define LCD_LED PORTA.7

// Real Time
eeprom unsigned int RealTimeYear; 
eeprom signed char RealTimeMonth, RealTimeDay, RealTimeHour, RealTimeMinute;
unsigned char RealTimeSecond;

// Lcd Address
signed char Address[3];
char RefreshLcd;

// Other
char PAGRINDINIS_LANGAS;
char Call_1Second;


//--------------------------------------------------- Meniu sistema ---------------------------------------------------//
#define LCD_LENGHT 20
#define LCD_WIDTH 4

#define BUTTON_COUNT 5


// Alphanumeric LCD Module functions portc
#asm
   .equ __lcd_port=0x15 
#endasm
#include <lcd.h>

#define MAX_MENU_TABLES 10
#define MAX_MENU_ROWS_ON_TABLE 10
#define MAX_MENU_CHARACTERS_IN_ROW 20
#define MAX_MENU_ABSOLUTE_ROWS 10
#define MAX_MENU_BUTTONS 5

//////////////////////////////////
unsigned char MenuAddress[3];   //
                                //
unsigned char MenuRow;          //
unsigned char MenuLowestRow;    //
unsigned char MenuHighestRow;   //
                                //
unsigned char MenuColumn;       //
unsigned char MenuLowestColumn; //
unsigned char MenuHighestColumn;//
//////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////
unsigned char MenuCreated[MAX_MENU_TABLES];                                    //
unsigned char MenuRowTableId[MAX_MENU_ABSOLUTE_ROWS];                          //
unsigned char MenuRowIdInTable[MAX_MENU_ABSOLUTE_ROWS];                        //
unsigned char MenuRowText[MAX_MENU_ABSOLUTE_ROWS][MAX_MENU_CHARACTERS_IN_ROW]; //
unsigned char MenuRowLinksTo[MAX_MENU_ABSOLUTE_ROWS][3];                       //
/////////////////////////////////////////////////////////////////////////////////

unsigned char MENU_BUTTON[BUTTON_COUNT];
unsigned char MENU_DUAL_BUTTON[BUTTON_COUNT-1];
unsigned char MENU_BUTTON_FILTER[BUTTON_COUNT]; 
unsigned char MENU_DUAL_BUTTON_FILTER[BUTTON_COUNT-1];  
#define MENU_BUTTON_FILTRATION_TIME 20 // cycles


void MenuShowError(char flash *string){
lcd_clear();
lcd_putsf("ERROR:");
lcd_putsf(string);
delay_ms(15000);
}

unsigned char GetMenuButtonInput(unsigned char button){
    if(button==0) return PIND.6;
    if(button==1) return PIND.5;
    if(button==2) return PIND.4;
    if(button==3) return PIND.3;
    if(button==4) return PIND.2;
MenuShowError("SELECTED INVALID BUTTON INPUT.");    
return 0;
}

void RefreshMenuButtons(){
unsigned char i;
    for(i=0;i<BUTTON_COUNT;i++){
        if(GetMenuButtonInput(i)==1){
        PAGRINDINIS_LANGAS = 0;
            if(MENU_DUAL_BUTTON_FILTER[i]<MENU_BUTTON_FILTRATION_TIME){
                if(MENU_BUTTON_FILTER[i]<MENU_BUTTON_FILTRATION_TIME){
                MENU_BUTTON_FILTER[i]++;
                }
            }
        }
        else{
            if(MENU_BUTTON_FILTER[i]>=MENU_BUTTON_FILTRATION_TIME){        
            MENU_BUTTON[i] = 1;
            RefreshLcd = 1;
            }
            else{
            MENU_BUTTON[i] = 0;
            }
        MENU_BUTTON_FILTER[i] = 0; 
        }      
    }
    
    for(i=0;i<BUTTON_COUNT-1;i++){
        if((GetMenuButtonInput(i)==1)&&(GetMenuButtonInput(i+1)==1)){   
        MENU_BUTTON_FILTER[i] = 0;
        MENU_BUTTON_FILTER[i+1] = 0;
            if(MENU_DUAL_BUTTON_FILTER[i]<MENU_BUTTON_FILTRATION_TIME){         
            MENU_DUAL_BUTTON_FILTER[i]++;
            }
        }
        else if((GetMenuButtonInput(i)==0)&&(GetMenuButtonInput(i+1)==0)){
            if(MENU_DUAL_BUTTON_FILTER[i]>=MENU_BUTTON_FILTRATION_TIME){
            MENU_DUAL_BUTTON[i] = 1;
            RefreshLcd = 1;
            }
            else{
            MENU_DUAL_BUTTON[i] = 0;
            }
        MENU_DUAL_BUTTON_FILTER[i] = 0; 
        }
    }      
}

unsigned char CreateMenuTable(unsigned char x, unsigned char y, unsigned char z){
                                                                                                                  
return 0;
}
            
unsigned char SetMenuRowParameters(unsigned char TableId, unsigned char IsPickable, unsigned char LocateToX, unsigned char LocateToY, unsigned char LocateToZ){
    if(MenuCreated[TableId]==1){


    }
MenuShowError("EDITING MENU ROW FAILED.");
return 0;
}

unsigned char PutRuningTextToMenuRow(unsigned char TableId, unsigned char Row, unsigned char Column, char flash *string, unsigned char Lenght, unsigned int TimeDelayMs){
    if(MenuCreated[TableId]==1){



    }
MenuShowError("EDITING MENU ROW FAILED.");
return 0;
}

unsigned char PutTextToMenuRow(unsigned char TableId, unsigned char Row, unsigned char Column, char flash *string){

return 0;
}

void InitMenuTexts(){
unsigned char TableId = CreateMenuTable(0,0,0);
SetMenuRowParameters(TableId, 0, 0,0,0);PutTextToMenuRow(TableId, 0, 1, "PAGRINDINIS MENIU");
SetMenuRowParameters(TableId, 1, 1,0,0);PutTextToMenuRow(TableId, 0, 0, "1.LAIKAS: 00:00");
SetMenuRowParameters(TableId, 1, 2,0,0);PutTextToMenuRow(TableId, 0, 0, "2.DATA: 2011.11.18");
SetMenuRowParameters(TableId, 1, 3,0,0);PutTextToMenuRow(TableId, 0, 0, "3.SKAMBEJIMAI");
SetMenuRowParameters(TableId, 1, 4,0,0);PutTextToMenuRow(TableId, 0, 0, "4.NUSTATYMAI");

TableId = CreateMenuTable(3,0,0);
}

void UpdateMenuTexts(){

}

void UpdateMenuVariables(){

}

///////////////////////////// FUNCTIONS /////////////////////////////////////////
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

char DayCountInMonth(unsigned int year, char month){
    if((month==1)||(month==3)||(month==5)||(month==7)||(month==8)||(month==10)||(month==12)){
    return 31;   
    }
    else if((month==4)||(month==6)||(month==9)||(month==11)){
    return 30;
    }
    else if(month==2){
    unsigned int a;
    a = year/4;
    a = a*4;
        if(a==year){
        return 29;
        }
        else{
        return 28;
        }
    }
    else{
    return 0;
    }
}

unsigned int WhatIsTheCode(){
return (RealTimeYear-2000)*RealTimeMonth*RealTimeDay;
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

char lcd_put_runing_text(   unsigned char Start_x,
                            unsigned char Start_y,
                        
                            unsigned int Lenght,                    
                            unsigned int Position,
                                            
                            char flash *str,
                            unsigned int StrLenght){
signed int i,a;
lcd_gotoxy(Start_x,Start_y);

    for(i=0;i<Lenght;i++){
    a = i + Position - Lenght;
        if(a>=0){
            if(a<StrLenght){
            lcd_putchar(str[a]);
            }
            else{
                if(i==0){
                return 1;
                }
            }
        }
        else{
        lcd_putchar(' ');
        } 
    }
return 0;                                        
}

char lcd_cursor(unsigned char x, unsigned char y){
lcd_gotoxy(x,y);
_lcd_ready();
_lcd_write_data(0xe);
return 1;
}

static unsigned char CODE_IsEntering;
static unsigned char CODE_SuccessXYZ[3];
static unsigned char CODE_FailedXYZ[3];
static unsigned char CODE_TimeLeft;
static unsigned int  CODE_EnteringCode;
static unsigned char CODE_ExecutingDigit;
char EnterCode(char FailX,char FailY,char FailZ,
        char SuccessX,char SuccessY,char SuccessZ){
    if(CODE_IsEntering==0){  
    CODE_IsEntering = 1;

    CODE_SuccessXYZ[0] = SuccessX;
    CODE_SuccessXYZ[1] = SuccessY;
    CODE_SuccessXYZ[2] = SuccessZ;

    CODE_FailedXYZ[0] = FailX;
    CODE_FailedXYZ[1] = FailY;
    CODE_FailedXYZ[2] = FailZ;

    CODE_TimeLeft = 99;
    CODE_EnteringCode = 0;
    CODE_ExecutingDigit = 0;
    return 1;
    }
return 0;
}

char lcd_buttons(char Left,char Right, char Plius,char Minus, 
    char Patvirtinti, char DualButton1,char DualButton2,char DualButton3,
        char DualButton4){
       
    if(Left==1){
    lcd_putsf(BUTTON_DESCRIPTION1);
    }
    else{
    lcd_putsf(BUTTON_DESCRIPTION1_0);
    }

    if(DualButton1==1){   
    lcd_putsf(BUTTON_DESCRIPTION2);
    }
    else{
    lcd_putsf(BUTTON_DESCRIPTION2_0);
    }
    
    if(Right==1){
    lcd_putsf(BUTTON_DESCRIPTION3);
    }
    else{
    lcd_putsf(BUTTON_DESCRIPTION3_0);
    }
    
    if(DualButton2==1){   
    lcd_putsf(BUTTON_DESCRIPTION4);
    }
    else{
    lcd_putsf(BUTTON_DESCRIPTION4_0);
    }    
        
    if(Plius==1){
    lcd_putsf(BUTTON_DESCRIPTION5);
    }
    else{
    lcd_putsf(BUTTON_DESCRIPTION5_0);
    }
    
    if(DualButton3==1){   
    lcd_putsf(BUTTON_DESCRIPTION6);
    }
    else{
    lcd_putsf(BUTTON_DESCRIPTION6_0);
    }    
    
    if(Minus==1){
    lcd_putsf(BUTTON_DESCRIPTION7);
    }
    else{
    lcd_putsf(BUTTON_DESCRIPTION7_0);
    }

    if(DualButton4==1){   
    lcd_putsf(BUTTON_DESCRIPTION8);
    }
    else{
    lcd_putsf(BUTTON_DESCRIPTION8_0);
    }        
        
    if(Patvirtinti==1){
    lcd_putsf(BUTTON_DESCRIPTION9);
    }
    else{
    lcd_putsf(BUTTON_DESCRIPTION9_0);
    }

return 1;
}

char IsDateEaster(unsigned int year, unsigned int month, unsigned int day){
unsigned int G, C, X, Z, D, E, F, N;
unsigned char EasterSunday, EasterSaturday, EasterFriday, EasterThursday;

G = year-((year/19)*19)+1;
C = (year/100)+1;
X = 3*C/4-12;
Z = ((8*C+5)/25)-5;
D = 5*year/4-X-10;
F = 11*G+20+Z-X;
E = F-((F/30)*30);
    if(((E==25)&&(G>11))||(E==24)){ E++;    }
N = 44-E;
    if(N<21){   N = N+30;   }
N = N+7-((D+N)-(((D+N)/7)*7));

EasterSunday = N;
EasterSaturday = N - 1;
EasterFriday = N - 2;
EasterThursday = N - 3;

// Velyku ketvirtadienis
    if (EasterThursday>31){
    EasterThursday = EasterThursday - 31;
    // Balandzio N-oji diena
        if(month==4){
            if(day==EasterThursday){
            return 4;
            }
        }
    }
    else{
    // Kovo N-oji diena
        if(month==3){
            if(day==EasterThursday){
            return 4;
            }
        }
    }

// Velyku penktadienis
    if (EasterFriday>31){
    EasterFriday = EasterFriday - 31;
    // Balandzio N-oji diena
        if(month==4){
            if(day==EasterFriday){
            return 5;
            }
        }
    }
    else{
    // Kovo N-oji diena
        if(month==3){
            if(day==EasterFriday){
            return 5;
            }
        }
    }

// Velyku sestadienis
    if (EasterSaturday>31){
    EasterSaturday = EasterSaturday - 31;
    // Balandzio N-oji diena
        if(month==4){
            if(day==EasterSaturday){
            return 6;
            }
        }
    }
    else{
    // Kovo N-oji diena
        if(month==3){
            if(day==EasterSaturday){
            return 6;
            }
        }
    }

// Velyku sekmadienis
    if (EasterSunday>31){
    EasterSunday = EasterSunday - 31;
    // Balandzio N-oji diena
        if(month==4){
            if(day==EasterSunday){
            return 7;
            }
        }
    }
    else{
    // Kovo N-oji diena
        if(month==3){
            if(day==EasterSunday){
            return 7;
            }
        }
    }
           
return 0;
}

/////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// Interupts /////////////////////////////////////
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void){
static signed int InteruptTimer, MissTimer;
InteruptTimer++;
    if(InteruptTimer>=495){// Periodas
    Call_1Second++;
    InteruptTimer = 0;
    MissTimer++;
        if(MissTimer>=1000){
        InteruptTimer = 5;// -(Tukstantosios periodo dalys)
        MissTimer = 0;        
        } 
    }

static unsigned int RefreshTimer;       
RefreshTimer++;    
    if(RefreshTimer>=20){
    RefreshTimer = 0; 
    RefreshLcd = 1;
    }
    
}
/////////////////////////////////////////////////////////////////////////////////////

void main(void){
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

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
TIMSK=0x01;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// LCD module initialization
lcd_init(20);

// Global enable interrupts
#asm("sei")



    while (1){
                 
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////// Funkcija kas 1 secunde //////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////        
    static unsigned char Called_1Second;
        if(Call_1Second>=1){
        Called_1Second = 1;
        Call_1Second--;
                
        // Realus laikas          
            if(RealTimeSecond>=59){
            RealTimeSecond = 0;
             
                if(RealTimeMinute>=59){
                RealTimeMinute = 0;
                    if(RealTimeHour>=23){
                    RealTimeHour = 0;
                     
                        if(DayCountInMonth(RealTimeYear,RealTimeMonth)<=RealTimeDay){
                        RealTimeDay = 1;
                         
                            if(RealTimeMonth>=12){
                            RealTimeMonth = 1;
                            RealTimeYear++;
                            }
                            else{
                            RealTimeMonth++;
                            } 

                        }
                        else{
                        RealTimeDay++;
                        }          
                    }
                    else{
                    RealTimeHour++;
                    }
                }
                else{
                RealTimeMinute++;
                }
            }
            else{
            RealTimeSecond++;
            }
        /////////    
            if(CODE_TimeLeft>0){
            CODE_TimeLeft--;
            }

            if(PAGRINDINIS_LANGAS<120){
            PAGRINDINIS_LANGAS++;
            }            
        }
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////


/*
    //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////// LCD ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    // Pagrindiniame meniu vaikscioti kairen desinen
        if(Address[1]==0){// Jei y == 0, tai pagrindinis meniu
            if(Address[2]==0){

                if(DUAL_BUTTON[0]==1){
                Address[0] = 0;
                }

                if(BUTTON[0]==1){
                    if(Address[0]>0){    
                    Address[0]--;
                    RefreshLcd = 1;
                    }
                    else{
                    Address[0] = 13;
                    }
                }
                else if(BUTTON[1]==1){
                    if(Address[0]<13){
                    Address[0]++;
                    RefreshLcd = 1;
                    }
                    else{
                    Address[0] = 0;
                    }
                }
            }
        }

        if(RefreshLcd==1){
        lcd_clear();
        }

        if(CODE_IsEntering==0){ 
            // Pagrindinis langas
            if(Address[0]==0){
                if(RefreshLcd==1){
                // LAIKAS: 12:34
                lcd_putsf("LAIKAS: "); 
                lcd_put_number(0,2,0,0,RealTimeHour,0);
                lcd_putsf(":");
                lcd_put_number(0,2,0,0,RealTimeMinute,0);
                lcd_putsf(":");
                lcd_put_number(0,2,0,0,RealTimeSecond,0);
                lcd_putsf("   ");
                    if(Address[1]==0){
                    lcd_putsf("<");
                    }
                    else{
                    lcd_putsf(" ");
                    }
                 
                lcd_putsf("DATA:"); 
                lcd_put_number(0,4,0,0,RealTimeYear,0);
                lcd_putsf(".");
                lcd_put_number(0,2,0,0,RealTimeMonth,0);
                lcd_putsf(".");
                lcd_put_number(0,2,0,0,RealTimeDay,0);
                lcd_putsf("    ");
                    if(Address[1]==1){
                    lcd_putsf("<");
                    }
                    else{
                    lcd_putsf(" ");
                    }

                lcd_putsf("SKAMBEJIMAI        ");
                    if(Address[1]==2){
                    lcd_putsf("<");
                    }
                    else{
                    lcd_putsf(" ");
                    }

                lcd_putsf("NUSTATYMAI         ");
                    if(Address[1]==3){
                    lcd_putsf("<");
                    }
                    else{
                    lcd_putsf(" ");
                    }                                  
                 

                    // Kursoriai
                    if(Address[1]==0){                
                        if(Address[2]==1){
                        lcd_cursor(8,0);
                        }    
                        else if(Address[2]==2){
                        lcd_cursor(9,0);
                        }
                        
                        else if(Address[2]==3){
                        lcd_cursor(11,0);
                        }
                        else if(Address[2]==4){
                        lcd_cursor(12,0);
                        } 
                    }
                    else if(Address[1]==1){
                        if(Address[2]==1){
                        lcd_cursor(5,1);
                        }    
                        else if(Address[2]==2){
                        lcd_cursor(6,1);
                        }
                        else if(Address[2]==3){
                        lcd_cursor(7,1);
                        }
                        else if(Address[2]==4){
                        lcd_cursor(8,1);
                        }
                        
                        if(Address[2]==5){
                        lcd_cursor(10,0);
                        }    
                        else if(Address[2]==6){
                        lcd_cursor(11,0);
                        }
                        
                        else if(Address[2]==7){
                        lcd_cursor(13,0);
                        }
                        else if(Address[2]==8){
                        lcd_cursor(14,0);
                        }
                    }
                }
                                                                
                if(Address[2]==0){
                    if(BUTTON[0]==1){
                        if(Address[1]>0){
                        Address[1]--;
                        } 
                    }
                    else if(BUTTON[1]==1){
                        if(Address[1]<3){
                        Address[1]++;
                        }
                    }
                                    
                    if(BUTTON[4]==1){
                        if(Address[1]==0){
                        Address[0] = 0;
                        Address[1] = 0;
                        Address[2] = 1;
                        }
                        if(Address[1]==1){
                        Address[0] = 0;
                        Address[1] = 1;
                        Address[2] = 1;
                        }
                        if(Address[1]==2){
                        Address[0] = 1;
                        Address[1] = 0;
                        Address[2] = 0;
                        }
                        if(Address[1]==3){
                        Address[0] = 2;
                        Address[1] = 0;
                        Address[2] = 0;
                        } 
                    } 
                }
                else{
                    if(Address[1]==1){
                        if(BUTTON[0]==1){
                            if(Address[1]>0){
                            Address[1]--;
                            } 
                        }
                        else if(BUTTON[1]==1){
                            if(Address[1]<4){
                            Address[1]++;
                            }
                        }
                    }
                    else if(Address[1]==2){
                        if(BUTTON[0]==1){
                            if(Address[1]>0){
                            Address[1]--;
                            } 
                        }
                        else if(BUTTON[1]==1){
                            if(Address[1]<8){
                            Address[1]++;
                            }
                        }
                    }
                    
                }                               
            }
            
            // Skambejimai
            else if(Address[0]==1){
                if(RefreshLcd==1){
                lcd_putsf("1.VELYKU LAIKAS");
                    if(Address[1]==0){
                    lcd_putsf("<");
                    }
                    else{
                    lcd_putsf(" ");
                    }
                                  
                lcd_putsf("2.KALEDU LAIKAS");
                    if(Address[1]==1){
                    lcd_putsf("<");
                    }
                    else{
                    lcd_putsf(" ");
                    }
                
                lcd_putsf("3.EILINIS LAIK.");  
                    if(Address[1]==2){
                    lcd_putsf("<");
                    }
                    else{
                    lcd_putsf(" ");
                    }                       
                }

                if(Address[2]==0){
                    if(BUTTON[0]==1){
                        if(Address[1]>0){
                        Address[1]--;
                        } 
                    }
                    else if(BUTTON[1]==1){
                        if(Address[1]<2){
                        Address[1]++;
                        }
                    }
                                    
                    if(BUTTON[4]==1){
                        if(Address[1]==0){
                        Address[0] = 1;
                        Address[1] = 1;
                        Address[2] = 0;
                        }
                        if(Address[1]==1){
                        Address[0] = 1;
                        Address[1] = 2;
                        Address[2] = 0;
                        }
                        if(Address[1]==2){
                        Address[0] = 1;
                        Address[1] = 3;
                        Address[2] = 0;
                        } 
                    } 
                }                                
            }
        }
        else{
        /////////////////////////////////////////////////////////////////////
            if(RefreshLcd==1){
            unsigned int i;
            lcd_putsf("KODAS: ");
            i = CODE_EnteringCode;
                if(CODE_ExecutingDigit==0){
                lcd_putchar( NumToIndex( i/1000) );
                }
                else{
                lcd_putchar('*');
                }
            i = i - (i/1000)*1000;            
                if(CODE_ExecutingDigit==1){
                lcd_putchar( NumToIndex( i/100) );
                }
                else{
                lcd_putchar('*');
                }
            i = i - (i/100)*100;            
                if(CODE_ExecutingDigit==2){
                lcd_putchar( NumToIndex( i/10) );
                }
                else{
                lcd_putchar('*');
                }
            i = i - (i/10)*10;            
                if(CODE_ExecutingDigit==3){
                lcd_putchar( NumToIndex(i) );
                }
                else{
                lcd_putchar('*');
                }

            lcd_putsf("   ");
             
            i = CODE_TimeLeft; 
            lcd_putchar( NumToIndex( i/10) );
            i = i - (i/10)*10;
            lcd_putchar( NumToIndex(i) ); 
            }

        ///// 1 Kodo skaicius /////////
            if(CODE_ExecutingDigit==0){
                if(RefreshLcd==1){
                lcd_buttons(0,1,1,1,1,0,0,0,0);
                lcd_cursor(7,0);
                }

            // pakeisti ivedama skaitmeni                
                if(BUTTON[1]==1){
                CODE_ExecutingDigit++;
                }

            // 1 kodo skaitmens keitimas                
                if(BUTTON[2]==1){
                    if(CODE_EnteringCode<9000){
                    CODE_EnteringCode = CODE_EnteringCode + 1000;
                    }
                }
                else if(BUTTON[3]==1){
                    if(CODE_EnteringCode>=1000){
                    CODE_EnteringCode = CODE_EnteringCode - 1000;
                    }
                }             
            }
        ///////////////////////////////    

        ///// 2 Kodo skaicius /////////
            else if(CODE_ExecutingDigit==1){
                if(RefreshLcd==1){
                lcd_buttons(1,1,1,1,1,0,0,0,0);
                lcd_cursor(8,0);
                }
                
                if(BUTTON[0]==1){
                CODE_ExecutingDigit--;
                }
                else if(BUTTON[1]==1){
                CODE_ExecutingDigit++;
                }
                
            // 2 kodo skaitmens keitimas                
                if(BUTTON[2]==1){
                    if(CODE_EnteringCode<9900){
                    CODE_EnteringCode = CODE_EnteringCode + 100;
                    }
                }
                else if(BUTTON[3]==1){
                    if(CODE_EnteringCode>=100){
                    CODE_EnteringCode = CODE_EnteringCode - 100;
                    }
                } 
            }
        ///////////////////////////////    

        ///// 3 Kodo skaicius /////////           
            else if(CODE_ExecutingDigit==2){
                if(RefreshLcd==1){
                lcd_buttons(1,1,1,1,1,0,0,0,0);
                lcd_cursor(9,0);
                }
                
                if(BUTTON[0]==1){
                CODE_ExecutingDigit--;
                }
                if(BUTTON[1]==1){
                CODE_ExecutingDigit++;
                }
             
            // 3 kodo skaitmens keitimas                
                if(BUTTON[2]==1){
                    if(CODE_EnteringCode<9990){
                    CODE_EnteringCode = CODE_EnteringCode + 10;
                    }
                }
                else if(BUTTON[3]==1){
                    if(CODE_EnteringCode>=10){
                    CODE_EnteringCode = CODE_EnteringCode - 10;
                    }
                } 
            }
        ///////////////////////////////    

        ///// 4 Kodo skaicius /////////
            else if(CODE_ExecutingDigit==3){
                if(RefreshLcd==1){
                lcd_buttons(1,0,1,1,1,0,0,0,0);
                lcd_cursor(10,0);
                }
                
                if(BUTTON[0]==1){
                CODE_ExecutingDigit--;
                }
             
            // 4 kodo skaitmens keitimas                
                if(BUTTON[2]==1){
                    if(CODE_EnteringCode<9999){
                    CODE_EnteringCode = CODE_EnteringCode + 1;
                    }
                }
                else if(BUTTON[3]==1){
                    if(CODE_EnteringCode>=1){
                    CODE_EnteringCode = CODE_EnteringCode - 1;
                    }
                } 
            }     
        /////////////////////////////// 
            
            if(CODE_TimeLeft==0){
            Address[0] = CODE_FailedXYZ[0];
            Address[1] = CODE_FailedXYZ[1];
            Address[2] = CODE_FailedXYZ[2];

            CODE_IsEntering = 0;

            CODE_EnteringCode = 0;
            CODE_ExecutingDigit = 0;

            CODE_TimeLeft = 0; 

            CODE_SuccessXYZ[0] = 0;
            CODE_SuccessXYZ[1] = 0;
            CODE_SuccessXYZ[2] = 0;
            lcd_clear();
            lcd_putsf("    LAIKAS      ");
            lcd_putsf("    BAIGESI     ");
            delay_ms(1000);
            }



            if(BUTTON[4]==1){
                if(CODE_EnteringCode==WhatIsTheCode()){                
                Address[0] = CODE_SuccessXYZ[0];
                Address[1] = CODE_SuccessXYZ[1];
                Address[2] = CODE_SuccessXYZ[2];
                lcd_clear();
                lcd_putsf("     KODAS      ");
                lcd_putsf("   TEISINGAS    ");
                delay_ms(1000);
                }
                else{
                Address[0] = CODE_FailedXYZ[0];
                Address[1] = CODE_FailedXYZ[1];
                Address[2] = CODE_FailedXYZ[2];
                lcd_clear();               
                lcd_putsf("     KODAS      ");
                lcd_putsf("  NETEISINGAS   ");
                delay_ms(1000);
                }
            CODE_IsEntering = 0;

            CODE_EnteringCode = 0;
            CODE_ExecutingDigit = 0;

            CODE_TimeLeft = 0; 

            CODE_SuccessXYZ[0] = 0;
            CODE_SuccessXYZ[1] = 0;
            CODE_SuccessXYZ[2] = 0;             
            }
            
                         
        /////////////////////////////////////////////////////////////////////
        }
                    
        if(RefreshLcd==1){    
        RefreshLcd = 0;
        }*/   
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////    
    Called_1Second = 0;;
    delay_ms(1);
    };
}
