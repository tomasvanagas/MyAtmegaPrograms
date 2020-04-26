/*****************************************************
Project     : Baznycios varpu valdiklis V1.0 
Date        : 2012.02.06
Author      : Tomas Vanagas
Chip type   : ATmega32
*****************************************************/

#include <mega32.h>
#include <delay.h>

// I2C Bus functions
#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=7
   .equ __scl_bit=6
#endasm
#include <i2c.h> 

// DS1307 Real Time Clock functions
#include <ds1307.h>

// PINS
eeprom unsigned char BELL_OUTPUT_ADDRESS; 
#define BELL_OUTPUT_DEFAULT 22

#define BUTTON_UP 0
#define BUTTON_LEFT 1
#define BUTTON_ENTER 2
#define BUTTON_RIGHT 3
#define BUTTON_DOWN 4

unsigned char OUTPUT(unsigned char address, unsigned char value){
    if(address==17){
    PORTC.3 = value;
    return 1;
    }
    else if(address==18){
    PORTC.4 = value;
    return 1;
    }
    else if(address==19){
    PORTC.5 = value;
    return 1;
    }
    else if(address==20){
    PORTD.5 = value;
    return 1;
    }
    else if(address==21){
    PORTD.4 = value;
    return 1;
    }
    else if(address==22){
    PORTD.7 = value;
    return 1;
    }
return 0;
}

unsigned char BUTTON_INPUT(unsigned char input){
    if(input==0){   return PIND.1;  }
    if(input==1){   return PIND.0;  }
    if(input==2){   return PIND.2;  }
    if(input==3){   return PIND.3;  }
    if(input==4){   return PIND.6;  }
return 0;
}

// Real Time 
unsigned char RealTimeYear, RealTimeMonth, RealTimeDay, RealTimeHour, RealTimeMinute, RealTimeWeekDay, RealTimeSecond;
eeprom unsigned char SUMMER_TIME_TURNED_ON;
eeprom unsigned char IS_CLOCK_SUMMER;

eeprom signed char RealTimePrecisioningValue;
unsigned char IsRealTimePrecisioned;



// Code
eeprom unsigned int  CODE;
eeprom unsigned char IS_LOCK_TURNED_ON;


// Neveiklumo taimeriai
unsigned int STAND_BY_TIMER;
unsigned char MAIN_MENU_TIMER,LCD_LED_TIMER;



// Skambuciai 
#define BELL_TYPE_COUNT 14
#define BELL_COUNT 20
eeprom unsigned char BELL_TIME[BELL_TYPE_COUNT][BELL_COUNT][3];
/////////////////////////////////
// TYPE 0:  Pirmadienio
// TYPE 1:  Antradienio
// TYPE 2:  Treciadienio
// TYPE 3:  Ketvirtadienio
// TYPE 4:  Penktadienio
// TYPE 5:  Sestadienio
// TYPE 6:  Sekmadienio
                                        
// TYPE 7:  Velyku ketvirtadienio
// TYPE 8:  Velyku penktadienio
// TYPE 9: Velyku sestadienio
// TYPE 10: Velyku sekmadienio

// TYPE 11: Kaledu 1-os dienos
// TYPE 12: Kaledu 2-os dienos

// TYPE 13: Porciunkules atlaidai
///////////////////////////////// 



// Other
char RefreshTime;

//////////// Mygtukai /////////////
#define ButtonFiltrationTimer 20 // x*cycle (cycle~1ms) 
///////////////////////////////////








//-----------------------------------------------------------------------------------//
//------------------------------------ Functions ------------------------------------//
//-----------------------------------------------------------------------------------//
unsigned char IsEasterToday(unsigned int year, unsigned char month, unsigned char day){
unsigned int G, C, X, Z, D, E, F, N;
unsigned char EasterSunday, EasterSaturday, EasterFriday, EasterThursday;

year += 2000;

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
    if(EasterThursday>31){
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
    if(EasterFriday>31){
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
    if(EasterSaturday>31){
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
    if(EasterSunday>31){
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

unsigned char IsChristmasToday(unsigned int year, unsigned char month, unsigned char day){
//Gruodzio 25 - 26

year += 2000;

    if(year!=0){
        if(month==12){
            if(day==25){
            return 1;
            }
            else if(day==26){
            return 1; 
            }
        } 
    }
return 0;
}

unsigned char IsPorciunkuleToday(unsigned char month, unsigned char day, unsigned char weekday){
    if(month==8){
        if(day<=7){
            if(weekday==7){
            return 1;
            }
        }
    }
return 0;
}

unsigned char GetEasterMonth(unsigned int year){
unsigned int G, C, X, Z, D, E, F, N;

year += 2000;

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

    if(N>31){
    return 4;    
    }
    else{
    return 3;
    }
}

unsigned char GetEasterDay(unsigned int year){
unsigned int G, C, X, Z, D, E, F, N;

year += 2000;

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

    if(N>31){
    return N - 31;     
    }
    else{
    return N;
    }
}

unsigned char DayCountInMonth(unsigned int year, char month){ 
year += 2000;

    if((month==1)||(month==3)||(month==5)||(month==7)||(month==8)||(month==10)||(month==12)){return 31;}
    else if((month==4)||(month==6)||(month==9)||(month==11)){return 30;}
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

unsigned char IsSummerTime(unsigned char month, unsigned char day, unsigned char weekday){
    if(month==3){
        if(day==25){
            if(weekday==7){
            return 1;
            }
        }
        else if(day>25){
            if(day+(7-weekday)>31){
            return 1;
            }
            else{
                if(weekday==7){
                return 1;
                }
            }

        }
    }
    else if((month>3)&&(month<10)){
    return 1;
    }
    else if(month==10){
        if(day==25){
            if(weekday==7){
            return 0;
            }
        }
        else if(day>25){
            if(day+(7-weekday)>31){
            return 0;
            }
            else{
                if(weekday==7){
                return 0;
                }
            }
        }
    return 1;
    }
return 0;
}

unsigned char GetFreeBellId(unsigned char bell_type){
unsigned char i;
    for(i=0;i<BELL_COUNT;i++){
    unsigned char checking_time[3];
    checking_time[0] = BELL_TIME[bell_type][i][0];
    checking_time[1] = BELL_TIME[bell_type][i][1];
    checking_time[2] = BELL_TIME[bell_type][i][2];
        if(checking_time[2]>0){
            if(checking_time[0]<24){
                if(checking_time[1]>=60){
                BELL_TIME[bell_type][i][0] = 0;
                BELL_TIME[bell_type][i][1] = 0;
                BELL_TIME[bell_type][i][2] = 0; 
                return i;    
                break;    
                }
            }
            else{
            BELL_TIME[bell_type][i][0] = 0;
            BELL_TIME[bell_type][i][1] = 0;
            BELL_TIME[bell_type][i][2] = 0;
            return i;
            break;
            }
        }
        else{
        BELL_TIME[bell_type][i][0] = 0;
        BELL_TIME[bell_type][i][1] = 0;
        BELL_TIME[bell_type][i][2] = 0;
        return i;
        break;
        }
    }   
return 255;    
}

unsigned char GetBellId(unsigned char bell_type, unsigned char row){
    if(bell_type<BELL_TYPE_COUNT){
        if(row<BELL_COUNT){
        unsigned char k, i, BELL_ID;
        unsigned char time[3];
        time[0] = 0; 
        time[1] = 0; 
        time[2] = 0;
                                             
            for(k=0;k<=row;k++){
            unsigned char current_time[3], set_value;
            current_time[0] = 255; 
            current_time[1] = 255; 
            current_time[2] = 255;
            BELL_ID = 255;
                                                 
                for(i=0;i<BELL_COUNT;i++){
                unsigned char checking_time[3];
                checking_time[0] = BELL_TIME[bell_type][i][0];
                checking_time[1] = BELL_TIME[bell_type][i][1];
                checking_time[2] = BELL_TIME[bell_type][i][2];
                    if(checking_time[0]<24){
                        if(checking_time[1]<60){
                            if(checking_time[2]>0){ 
                                if(checking_time[0]>time[0]){
                                    if(checking_time[0]<current_time[0]){
                                    current_time[0] = checking_time[0];
                                    current_time[1] = checking_time[1];
                                    current_time[2] = checking_time[2];
                                    set_value = 1;
                                    BELL_ID = i; 
                                    }
                                    else if(checking_time[0]==current_time[0]){
                                        if(checking_time[1]<current_time[1]){
                                        current_time[0] = checking_time[0];
                                        current_time[1] = checking_time[1];
                                        current_time[2] = checking_time[2]; 
                                        set_value = 1;
                                        BELL_ID = i;
                                        } 
                                    } 
                                }
                                else if(checking_time[0]==time[0]){
                                    if(checking_time[1]>time[1]){
                                        if(checking_time[0]<current_time[0]){
                                        current_time[0] = checking_time[0];
                                        current_time[1] = checking_time[1];
                                        current_time[2] = checking_time[2];
                                        set_value = 1;
                                        BELL_ID = i; 
                                        }
                                        else if(checking_time[0]==current_time[0]){
                                            if(checking_time[1]<current_time[1]){
                                            current_time[0] = checking_time[0];
                                            current_time[1] = checking_time[1];
                                            current_time[2] = checking_time[2]; 
                                            set_value = 1;
                                            BELL_ID = i;
                                            }
                                            else if(checking_time[1]==current_time[1]){
                                            BELL_TIME[bell_type][i][0] = 0;
                                            BELL_TIME[bell_type][i][1] = 0;
                                            BELL_TIME[bell_type][i][2] = 0; 
                                            } 
                                        } 
                                    }    
                                }    
                            }
                            else{
                            BELL_TIME[bell_type][i][0] = 0;
                            BELL_TIME[bell_type][i][1] = 0;
                            BELL_TIME[bell_type][i][2] = 0;
                            }
                        }
                        else{
                        BELL_TIME[bell_type][i][0] = 0;
                        BELL_TIME[bell_type][i][1] = 0;
                        BELL_TIME[bell_type][i][2] = 0;
                        }
                    }
                    else{
                    BELL_TIME[bell_type][i][0] = 0;
                    BELL_TIME[bell_type][i][1] = 0;
                    BELL_TIME[bell_type][i][2] = 0;
                    }    
                }

                if(set_value==1){
                time[0] = current_time[0]; 
                time[1] = current_time[1];
                time[2] = current_time[2];
                }
            }
        return BELL_ID;
        }
    return 255;    
    }
return 255; 
}

//-----------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------//









//-----------------------------------------------------------------------------------//
//--------------------------------- Lcd System --------------------------------------//
//-----------------------------------------------------------------------------------//
#define LCD_LED PORTA.7
                  
static unsigned char RowsOnWindow;
static unsigned char Address[6];
static unsigned char SelectedRow;
static unsigned char RefreshLcd;
static unsigned char lcd_light_osc;
static unsigned char lcd_light_now;
eeprom unsigned char lcd_light;

#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

// Ekrano apsvietimas
interrupt [TIM0_OVF] void timer0_ovf_isr(void){
lcd_light_osc += 1;
    if(lcd_light_osc>=100){
    lcd_light_osc = 0;
    }
            
    if(lcd_light_now>lcd_light_osc){
    LCD_LED = 1; 
    }
    else{
    LCD_LED = 0;
    }
}

char SelectAnotherRow(char up_down){
// 0 - down
// 1 - up
    if(up_down==0){
        if(SelectedRow<RowsOnWindow-1){
        SelectedRow++;
            if(Address[5]+3<SelectedRow){
            Address[5] = SelectedRow - 3;  
            }
        return 1; 
        } 
    }
    else{
        if(SelectedRow>0){
        SelectedRow--;
            if(Address[5]>SelectedRow){
            Address[5] = SelectedRow;  
            }
        return 1; 
        } 
    }
return 0;
}

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

//-----------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------//











void main(void){
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0b00000000;
DDRA= 0b10000000;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0b00000000;
DDRB= 0b00000000;

// Port C initialization
// Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0b00000000;
DDRC= 0b00111000;

// Port D initialization
// Func7=Out Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0b00000000;
DDRD= 0b10110000;

/// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x02;
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

// I2C Bus initialization
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: Off
// SQW/OUT pin state: 0
rtc_init(0,0,0);

// Global enable interrupts
#asm("sei")


// 2 Wire Bus initialization
// Generate Acknowledge Pulse: Off
// 2 Wire Bus Slave Address: 0h
// General Call Recognition: Off
// Bit Rate: 400.000 kHz
//TWSR=0x00;
//TWBR=0x02;
//TWAR=0x00;
//TWCR=0x04;

// I2C Bus initialization
i2c_init();
                                       			
// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: Off
// SQW/OUT pin state: 0
rtc_init(0,0,0);
        															
// LCD module initialization
lcd_init(20);

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/128k
WDTCR=0x0B;

LCD_LED_TIMER = 30; lcd_light_now = lcd_light;
lcd_putsf("+------------------+");
lcd_putsf("| BAZNYCIOS VARPU  |");
lcd_putsf("| VALDIKLIS V1.");
lcd_put_number(0,3,0,0,__BUILD__,0);
lcd_putsf(" |+------------------+");
delay_ms(1500);

// Default values
    if(lcd_light>100){lcd_light = 100;}

    if(BELL_OUTPUT_ADDRESS==255){BELL_OUTPUT_ADDRESS = BELL_OUTPUT_DEFAULT;} 

    if((SUMMER_TIME_TURNED_ON>1)||(IS_CLOCK_SUMMER>1)){SUMMER_TIME_TURNED_ON = 0;IS_CLOCK_SUMMER = 0;}                  

    if((CODE>9999)||(IS_LOCK_TURNED_ON>1)){CODE = 0; IS_LOCK_TURNED_ON = 0;}

    if((RealTimePrecisioningValue>29)||(RealTimePrecisioningValue<-29)){RealTimePrecisioningValue = 0;}
    if(IsRealTimePrecisioned>1){IsRealTimePrecisioned = 0;}

rtc_get_time(&RealTimeHour,&RealTimeMinute,&RealTimeSecond);
rtc_get_date(&RealTimeDay, &RealTimeMonth, &RealTimeYear); 

static unsigned char STAND_BY;
static unsigned char UNLOCKED;
STAND_BY = 1;

    while(1){     
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////// Funkcija kas 1 secunde //////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////        
    static unsigned int SecondCounter;
    SecondCounter++;
        if(SecondCounter>=500){
        SecondCounter = 0;
        RefreshTime++;
        }

    static unsigned char TimeRefreshed;
        if(RefreshTime>=1){
        TimeRefreshed = 1;
        RefreshTime--;

        static unsigned char TIME_EDITING;             
            if(TIME_EDITING!=1){
            unsigned char Second;
            rtc_get_time(&RealTimeHour,&RealTimeMinute,&Second);
            rtc_get_date(&RealTimeDay,&RealTimeMonth,&RealTimeYear);
            RealTimeWeekDay = rtc_read(0x03);
             
                if(RealTimeSecond!=Second){
                RealTimeSecond = Second;                                                                
                RefreshLcd++;

                    if(SUMMER_TIME_TURNED_ON==1){
                        if(IS_CLOCK_SUMMER==0){
                            if(IsSummerTime(RealTimeMonth, RealTimeDay, RealTimeWeekDay)==1){
                                if(RealTimeHour<23){
                                RealTimeHour++;
                                rtc_set_time(RealTimeHour,RealTimeMinute,RealTimeSecond);
                                IS_CLOCK_SUMMER = 1;  
                                }  
                            }        
                        }
                        else{
                            if(IsSummerTime(RealTimeMonth, RealTimeDay, RealTimeWeekDay)==0){
                                if(RealTimeHour>0){
                                RealTimeHour--;
                                rtc_set_time(RealTimeHour,RealTimeMinute,RealTimeSecond);
                                IS_CLOCK_SUMMER = 0;  
                                }  
                            } 
                             
                        }
                    }

                                        
                    if(RealTimeHour==0){
                        if(RealTimeMinute==0){
                            if(RealTimeSecond==30){
                                if(IsRealTimePrecisioned==0){
                                    if(RealTimePrecisioningValue!=0){
                                        if(RealTimeWeekDay==1){  
                                        RealTimeSecond += RealTimePrecisioningValue;
                                        IsRealTimePrecisioned = 1;
                                        }
                                    rtc_set_time(RealTimeHour,RealTimeMinute,RealTimeSecond);   
                                    } 
                                }
                            }
                        }
                        else{
                        IsRealTimePrecisioned = 0;
                        }
                    }   

                        
                //---- Skambuciai ----//
                static unsigned int CALL_BELL;
                    if(RealTimeSecond==0){
                    unsigned char bell_id,type,a,b,c,z;
                    a = IsEasterToday(RealTimeYear, RealTimeMonth, RealTimeDay);
                    b = IsChristmasToday(RealTimeYear, RealTimeMonth, RealTimeDay);
                    c = IsPorciunkuleToday(RealTimeMonth, RealTimeDay, RealTimeWeekDay);             
                    z = RealTimeWeekDay;                   
                    /////////////////////////////////
                    // TYPE 0:  Pirmadienio
                    // TYPE 1:  Antradienio
                    // TYPE 2:  Treciadienio
                    // TYPE 3:  Ketvirtadienio
                    // TYPE 4:  Penktadienio
                    // TYPE 5:  Sestadienio
                    // TYPE 6:  Sekmadienio
                                                                                  
                    // TYPE 7:  Velyku ketvirtadienio
                    // TYPE 8:  Velyku penktadienio
                    // TYPE 9:  Velyku sestadienio
                    // TYPE 10: Velyku sekmadienio

                    // TYPE 11: Kaledu 1-os dienos
                    // TYPE 12: Kaledu 2-os dienos
                    
                    // TYPE 13: Porciunkules atlaidai
                    /////////////////////////////////    

                        if(a==4){      type = 7; }// Velyku Ketvirtadienis
                        else if(a==5){ type = 8; }// Velyku Penktadienis
                        else if(a==6){ type = 9; }// Velyku Sestadienis
                        else if(a==7){ type = 10;}// Velyku Sekmadienis
                            
                        else if(b==1){ type = 11;}// Kaledu 1-os diena
                        else if(b==2){ type = 12;}// Kaledu 2-os diena
                        
                        else if(c==1){ type = 13;}// Porciunkules atlaidai
                            
                        else if(z==1){ type = 0; }// Pirmadienis
                        else if(z==2){ type = 1; }// Antradienis
                        else if(z==3){ type = 2; }// Treciadienis
                        else if(z==4){ type = 3; }// Ketvirtadienis
                        else if(z==5){ type = 4; }// Penktadienis
                        else if(z==6){ type = 5; }// Sestadienis
                        else if(z==7){ type = 6; }// Sekmadienis
                                    
                        for(bell_id=0;bell_id<BELL_COUNT;bell_id++){
                            if(BELL_TIME[type][bell_id][0]==RealTimeHour){
                                if(BELL_TIME[type][bell_id][1]==RealTimeMinute){  
                                CALL_BELL = BELL_TIME[type][bell_id][2];    
                                }
                            } 
                        }                    
                    }
                    
                    if(CALL_BELL>0){   
                    OUTPUT(BELL_OUTPUT_ADDRESS, 1);
                    CALL_BELL--;
                    }
                    else{               
                    OUTPUT(BELL_OUTPUT_ADDRESS, 0);
                    }    
                //--------------------//    
                    

                    if(STAND_BY_TIMER>0){
                    STAND_BY_TIMER--;
                        if(STAND_BY_TIMER==0){
                        STAND_BY = 1;
                        Address[0] = 0;
                        Address[1] = 0;
                        Address[2] = 0;
                        Address[3] = 0;
                        Address[4] = 0;
                        Address[5] = 0;
                        SelectedRow = 0;
                        UNLOCKED = 0;
                        }
                    }
                    
                    if(MAIN_MENU_TIMER>0){
                    MAIN_MENU_TIMER--;     
                        if(MAIN_MENU_TIMER==0){
                        Address[0] = 0;
                        Address[1] = 0;
                        Address[2] = 0;
                        Address[3] = 0;
                        Address[4] = 0;
                        Address[5] = 0;
                        SelectedRow = 0;
                        } 
                    }
                    
                    if(LCD_LED_TIMER>0){
                    LCD_LED_TIMER--; 
                    }

                }
            }
            else{
            RefreshLcd++; 
            }            
        }
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////


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
                    RefreshLcd = RefreshLcd + 2;
                    STAND_BY_TIMER = 45;
                    MAIN_MENU_TIMER = 30;
                    LCD_LED_TIMER = 15; lcd_light_now = lcd_light;
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
    ///////////////////////////// LCD ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    // Lcd led
    static unsigned char lcd_led_counter;
        if(LCD_LED_TIMER==0){
            if(lcd_light_now>0){
            lcd_led_counter++;
                if(lcd_led_counter>=25){
                lcd_led_counter = 0;
                lcd_light_now--; 
                }
            }
        }

         
        if(STAND_BY==1){
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
            lcd_put_number(0,2,0,0,RealTimeHour,0);
            lcd_putsf(":");
            lcd_put_number(0,2,0,0,RealTimeMinute,0);
            lcd_putsf(":");
            lcd_put_number(0,2,0,0,RealTimeSecond,0);    
            lcd_putsf("     ");

            lcd_gotoxy(1,2);     
            lcd_putsf("    2");
            lcd_put_number(0,3,0,0,RealTimeYear,0);
            lcd_putsf(".");
            lcd_put_number(0,2,0,0,RealTimeMonth,0);
            lcd_putsf(".");
            lcd_put_number(0,2,0,0,RealTimeDay,0);
            lcd_putsf("    ");
            }
            
            if(BUTTON[BUTTON_LEFT]==1){
            STAND_BY = 0;
            }
            else if(BUTTON[BUTTON_RIGHT]==1){
            STAND_BY = 0;
            }
            else if(BUTTON[BUTTON_DOWN]==1){
            STAND_BY = 0;    
            }
            else if(BUTTON[BUTTON_UP]==1){
            STAND_BY = 0; 
            }
            else if(BUTTON[BUTTON_ENTER]==1){
            STAND_BY = 0;
            }
            
        }
        else if((IS_LOCK_TURNED_ON==1)&&(UNLOCKED==0)){
        static unsigned int entering_code;
            if(RefreshLcd>=1){
            lcd_clear();
            } 

            if(BUTTON[BUTTON_LEFT]==1){
                if(Address[0]>0){
                Address[0]--;
                }
            }
            else if(BUTTON[BUTTON_RIGHT]==1){
                if(Address[0]<3){   
                Address[0]++;
                }
            }
            else if(BUTTON[BUTTON_DOWN]==1){
                if(Address[0]==0){
                    if(entering_code>=1000){
                    entering_code += -1000;    
                    } 
                }
                else if(Address[0]==1){
                unsigned int a;
                a = entering_code - ((entering_code/1000) * 1000);
                    if(a>=100){
                    entering_code += -100;    
                    } 
                }
                else if(Address[0]==2){
                unsigned int a;
                a = entering_code - ((entering_code/100) * 100);
                    if(a>=10){
                    entering_code += -10;    
                    } 
                }
                else if(Address[0]==3){
                unsigned int a;
                a = entering_code - ((entering_code/10) * 10);
                    if(a>=1){
                    entering_code += -1;    
                    } 
                }     
            }
            else if(BUTTON[BUTTON_UP]==1){
                if(Address[0]==0){
                    if(entering_code<9000){
                    entering_code += 1000;    
                    } 
                }
                else if(Address[0]==1){
                unsigned int a;
                a = entering_code - ((entering_code/1000) * 1000);
                    if(a<900){
                    entering_code += 100;    
                    } 
                }
                else if(Address[0]==2){
                unsigned char a;
                a = entering_code - ((entering_code/1000) * 1000);
                a = a - ((a/100) * 100);
                    if(a<90){
                    entering_code += 10;    
                    } 
                }
                else if(Address[0]==3){
                unsigned char a;
                a = entering_code - ((entering_code/1000) * 1000);
                a = a - ((a/100) * 100);
                a = a - ((a/10) * 10);
                    if(a<9){
                    entering_code += 1;    
                    } 
                }     
            }
            else if(BUTTON[BUTTON_ENTER]==1){
            Address[0] = 0;
                if(entering_code==CODE){
                UNLOCKED = 1;
                entering_code = 0; 
                lcd_clear();
                lcd_gotoxy(7,1);
                lcd_putsf("KODAS"); 
                lcd_gotoxy(5,2);
                lcd_putsf("TEISINGAS");
                delay_ms(1500); 
                }
                else{
                lcd_clear();
                entering_code = 0;
                lcd_gotoxy(7,1);
                lcd_putsf("KODAS"); 
                lcd_gotoxy(4,2);
                lcd_putsf("NETEISINGAS");
                delay_ms(1500);
                }
            }

            if(RefreshLcd>=1){
            unsigned int i;
            lcd_putsf("-=====UZRAKTAS=====-");
            lcd_gotoxy(0,1);
            lcd_putsf("IVESKITE KODA: ");
            lcd_gotoxy(14,2); 
            i = entering_code;
                if(Address[0]==0){
                lcd_putchar( NumToIndex( i/1000) );
                }
                else{
                lcd_putchar('*');
                }
            i = i - (i/1000)*1000;            
                if(Address[0]==1){
                lcd_putchar( NumToIndex( i/100) );
                }
                else{
                lcd_putchar('*');
                }
            i = i - (i/100)*100;            
                if(Address[0]==2){
                lcd_putchar( NumToIndex( i/10) );
                }
                else{
                lcd_putchar('*');
                }
            i = i - (i/10)*10;            
                if(Address[0]==3){
                lcd_putchar( NumToIndex(i) );
                }
                else{
                lcd_putchar('*');
                }
            lcd_gotoxy(0,3);    
            lcd_putsf("-==================-");             
            }         
        }
        else{

            if(RefreshLcd>=1){
            lcd_clear();
            }

            // Pagrindinis langas
            if(Address[0]==0){
                if(BUTTON[BUTTON_DOWN]==1){
                SelectAnotherRow(0); 
                }
                else if(BUTTON[BUTTON_UP]==1){
                SelectAnotherRow(1); 
                }
                else if(BUTTON[BUTTON_ENTER]==1){
                Address[0] = SelectedRow;
                SelectedRow = 0;
                Address[5] = 0;
                }
                
                if(RefreshLcd>=1){
                unsigned char row, lcd_row;
                lcd_row = 0;
                RowsOnWindow = 5;
                    for(row=Address[5];row<4+Address[5];row++){
                    lcd_gotoxy(0,lcd_row);
                     
                        if(row==0){
                        lcd_putsf("  -=PAGR. MENIU=-"); 
                        }
                        else if(row==1){
                        lcd_putsf("1.LAIKAS: "); 
                        lcd_put_number(0,2,0,0,RealTimeHour,0);
                        lcd_putsf(":");
                        lcd_put_number(0,2,0,0,RealTimeMinute,0);
                        lcd_putsf(" ");
                        }
                        else if(row==2){
                        lcd_putsf("2.DATA: 20");
                        lcd_put_number(0,2,0,0,RealTimeYear,0);
                        lcd_putsf(".");
                        lcd_put_number(0,2,0,0,RealTimeMonth,0);
                        lcd_putsf(".");
                        lcd_put_number(0,2,0,0,RealTimeDay,0);
                        }
                        else if(row==3){
                        lcd_putsf("3.SKAMBEJIMAI");
                        }
                        else if(row==4){
                        lcd_putsf("4.NUSTATYMAI");
                        }
                    lcd_row++;
                    }
                    
                lcd_gotoxy(19,SelectedRow-Address[5]);
                lcd_putchar('<');                     
                }                        
            }
            
            // Laikas
            else if(Address[0]==1){
                if(Address[1]==0){           
                    if(BUTTON[BUTTON_DOWN]==1){
                        if(SelectedRow<2){
                        SelectedRow = 2;
                        } 
                    }
                    else if(BUTTON[BUTTON_UP]==1){
                        if(SelectedRow>0){
                        SelectedRow = 0;
                        } 
                    }
                    else if(BUTTON[BUTTON_ENTER]==1){
                        if(SelectedRow==0){
                        Address[0] = 0;
                        }
                        else{
                        Address[1] = 1;
                        }
                    SelectedRow = 0;
                    Address[5] = 0; 
                    }
                }
                else{
                    if(BUTTON[BUTTON_DOWN]==1){
                        if(Address[1]==1){
                            if(RealTimeHour-10>=0){
                            RealTimeHour += -10; 
                            }
                        }
                        else if(Address[1]==2){
                            if(RealTimeHour-1>=0){
                            RealTimeHour += -1; 
                            }
                        }
                        else if(Address[1]==3){
                            if(RealTimeMinute-10>=0){
                            RealTimeMinute += -10; 
                            }
                        }
                        else if(Address[1]==4){
                            if(RealTimeMinute-1>=0){
                            RealTimeMinute += -1; 
                            }
                        }
                    }
                    else if(BUTTON[BUTTON_UP]==1){
                        if(Address[1]==1){
                            if(RealTimeHour+10<24){
                            RealTimeHour += 10; 
                            }
                        }
                        else if(Address[1]==2){
                            if(RealTimeHour+1<24){
                            RealTimeHour += 1; 
                            }
                        }
                        else if(Address[1]==3){
                            if(RealTimeMinute+10<60){
                            RealTimeMinute += 10; 
                            }
                        }
                        else if(Address[1]==4){
                            if(RealTimeMinute+1<60){
                            RealTimeMinute += 1; 
                            }
                        } 
                    }
                    else if(BUTTON[BUTTON_LEFT]==1){
                        if(Address[1]>1){
                        Address[1]--;
                        }
                    }
                    else if(BUTTON[BUTTON_RIGHT]==1){
                        if(Address[1]<4){
                        Address[1]++;
                        }
                    }
                    else if(BUTTON[BUTTON_ENTER]==1){
                    Address[1] = 0;
                    SelectedRow = 0;
                    Address[5] = 0; 
                    } 
                } 
                
                if(RefreshLcd>=1){
                RowsOnWindow = 7;
                  
                lcd_putsf("     -=LAIKAS=-     "); 
                lcd_putsf("LAIKAS: "); 
                lcd_put_number(0,2,0,0,RealTimeHour,0);
                lcd_putsf(":");
                lcd_put_number(0,2,0,0,RealTimeMinute,0);
                lcd_putsf(":");
                    if(Address[1]>0){
                    RealTimeSecond = 0;
                    }
                lcd_put_number(0,2,0,0,RealTimeSecond,0);
                lcd_putsf("    ");
                                      
                    if(Address[1]==0){
                    lcd_putsf("      REDAGUOTI?");
                    lcd_gotoxy(19,SelectedRow);
                    lcd_putchar('<');
                    }
                    else{
                        if(Address[1]==1){
                        lcd_putsf("        ^");  
                        }
                        else if(Address[1]==2){
                        lcd_putsf("         ^");  
                        }
                        else if(Address[1]==3){
                        lcd_putsf("           ^");  
                        }
                        else if(Address[1]==4){
                        lcd_putsf("            ^");  
                        }
                    rtc_set_time(RealTimeHour, RealTimeMinute, RealTimeSecond);   
                    }
                 
                 
                    if(SUMMER_TIME_TURNED_ON==1){
                    lcd_gotoxy(0,3);
                        if(IS_CLOCK_SUMMER==0){
                        lcd_putsf("(ZIEMOS LAIKAS)"); 
                        }
                        else{
                        lcd_putsf("(VASAROS LAIKAS)");    
                        }
                    }                     
                }                                            
            }

            // Data
            else if(Address[0]==2){
                if(Address[1]==0){
                    if(BUTTON[BUTTON_UP]==1){
                    SelectedRow = 0;
                    }
                    else if(BUTTON[BUTTON_DOWN]==1){
                    SelectedRow = 3;
                    }
                    else if(BUTTON[BUTTON_ENTER]==1){
                        if(SelectedRow==0){
                        Address[0] = 0;
                        }
                        else{
                        Address[1] = 1;
                        }
                    SelectedRow = 0;
                    Address[5] = 0;
                    } 
                }
                else{
                    if(BUTTON[BUTTON_UP]==1){
                        if(Address[1]==1){
                            if(RealTimeYear<90){
                            RealTimeYear +=10;
                            }
                        }
                        else if(Address[1]==2){
                            if(RealTimeYear<99){
                            RealTimeYear +=1;
                            } 
                        }
                        else if(Address[1]==3){
                            if(RealTimeMonth<=2){
                            RealTimeMonth +=10;
                            }
                        }
                        else if(Address[1]==4){
                            if(RealTimeMonth<12){
                            RealTimeMonth +=1;
                            } 
                        }
                        else if(Address[1]==5){
                            if(RealTimeDay<=DayCountInMonth(RealTimeYear,RealTimeMonth)-10){
                            RealTimeDay += 10;
                            } 
                        }
                        else if(Address[1]==6){
                            if(RealTimeDay<DayCountInMonth(RealTimeYear,RealTimeMonth)){
                            RealTimeDay += 1;
                            }  
                        }
                        else if(Address[1]==7){
                            if(RealTimeWeekDay<7){
                            RealTimeWeekDay += 1;
                            }  
                        }
                    }
                    else if(BUTTON[BUTTON_DOWN]==1){
                        if(Address[1]==1){
                            if(RealTimeYear>=10){
                            RealTimeYear += -10;
                            }
                        }
                        else if(Address[1]==2){
                            if(RealTimeYear>0){
                            RealTimeYear += -1;
                            } 
                        }
                        else if(Address[1]==3){
                            if(RealTimeMonth>10){
                            RealTimeMonth += -10;
                            }
                        }
                        else if(Address[1]==4){
                            if(RealTimeMonth>1){
                            RealTimeMonth += -1;
                            } 
                        }
                        else if(Address[1]==5){
                            if(RealTimeDay>10){
                            RealTimeDay += -10;
                            } 
                        }
                        else if(Address[1]==6){
                            if(RealTimeDay>1){
                            RealTimeDay += -1;
                            }  
                        }
                        else if(Address[1]==7){
                            if(RealTimeWeekDay>1){
                            RealTimeWeekDay += -1;
                            }  
                        }
                        
                    }
                    else if(BUTTON[BUTTON_LEFT]==1){
                        if(Address[1]>1){
                        Address[1]--;
                        }
                    }
                    else if(BUTTON[BUTTON_RIGHT]==1){
                        if(Address[1]<7){   
                        Address[1]++;
                        }
                    }
                    else if(BUTTON[BUTTON_ENTER]==1){
                    Address[1] = 0;
                    SelectedRow = 0;
                    Address[5] = 0;
                    }
                    
                    if(DayCountInMonth(RealTimeYear, RealTimeMonth)<RealTimeDay){
                    RealTimeDay = DayCountInMonth(RealTimeYear, RealTimeMonth);
                    } 
                }
             
                if(RefreshLcd>=1){
                lcd_putsf(" -=NUSTATYTI DATA=- ");
                  
                 
                    if(RealTimeWeekDay==1){
                    lcd_putsf("SAV.DIENA: PIRMAD.  ");
                    }
                    else if(RealTimeWeekDay==2){
                    lcd_putsf("SAV.DIENA: ANTRAD.  ");
                    }
                    else if(RealTimeWeekDay==3){
                    lcd_putsf("SAV.DIENA: TRECIAD. ");
                    }
                    else if(RealTimeWeekDay==4){
                    lcd_putsf("SAV.DIENA: KETVIRT. ");
                    }
                    else if(RealTimeWeekDay==5){
                    lcd_putsf("SAV.DIENA: PENKTAD. ");
                    }
                    else if(RealTimeWeekDay==6){
                    lcd_putsf("SAV.DIENA: SESTAD.  ");
                    }
                    else if(RealTimeWeekDay==7){
                    lcd_putsf("SAV.DIENA: SEKMAD.  ");
                    }
                    else{
                    lcd_putsf("???                 ");
                    }
                 
                lcd_putsf("DATA: 2");
                lcd_put_number(0,3,0,0,RealTimeYear,0);
                lcd_putsf(".");
                lcd_put_number(0,2,0,0,RealTimeMonth,0);
                lcd_putsf(".");
                lcd_put_number(0,2,0,0,RealTimeDay,0);
                lcd_putsf("    ");

                    if(Address[1]==0){
                    lcd_putsf("      REDAGUOTI?    "); 
                    }                 
                    else{
                        if(Address[1]==1){
                        lcd_putsf("        ^           "); 
                        }
                        else if(Address[1]==2){
                        lcd_putsf("         ^          "); 
                        }
                        
                        else if(Address[1]==3){
                        lcd_putsf("           ^        "); 
                        }
                        else if(Address[1]==4){
                        lcd_putsf("            ^       "); 
                        }
                        
                        else if(Address[1]==5){
                        lcd_putsf("              ^     "); 
                        }
                        else if(Address[1]==6){
                        lcd_putsf("               ^    "); 
                        }
                        else if(Address[1]==7){
                        lcd_gotoxy(16, 2);
                        lcd_putchar('^');
                        lcd_gotoxy(0, 3);
                        lcd_putsf("                |   "); 
                        }
                    rtc_set_date(RealTimeDay, RealTimeMonth, RealTimeYear);
                    rtc_write(0x03, RealTimeWeekDay); 
                    }
                            
                    if(Address[1]==0){        
                    lcd_gotoxy(19,SelectedRow);
                    lcd_putchar('<');
                    } 
                }  
            }
                       
            // Skambejimai
            else if(Address[0]==3){             
            // SKAMBEJIMU MENIU                
                if(Address[1]==0){
                    if(BUTTON[BUTTON_DOWN]==1){
                    SelectAnotherRow(0); 
                    }
                    else if(BUTTON[BUTTON_UP]==1){
                    SelectAnotherRow(1); 
                    }
                    else if(BUTTON[BUTTON_ENTER]==1){
                        if(SelectedRow==0){
                        Address[0] = 0;
                        }
                        else{                       
                        Address[1] = SelectedRow;
                        }
                    SelectedRow = 0;
                    Address[5] = 0;
                    }
                               
                    if(RefreshLcd>=1){
                    unsigned char row, lcd_row;
                    lcd_row = 0;
                    RowsOnWindow = 5;
                        for(row=Address[5];row<4+Address[5];row++){
                        lcd_gotoxy(0,lcd_row);
                             
                            if(row==0){
                            lcd_putsf("  -=SKAMBEJIMAI=-"); 
                            }
                            else if(row==1){
                            lcd_putsf("1.EILINIS LAIKAS");
                            }
                            else if(row==2){
                            lcd_putsf("2.VELYKU LAIKAS");
                            }
                            else if(row==3){
                            lcd_putsf("3.KALEDU LAIKAS");
                            }
                            else if(row==4){
                            lcd_putsf("4.PORCIUNKULE");
                            }
                                 
                        lcd_row++;
                        } 
                         
                    lcd_gotoxy(19,SelectedRow-Address[5]);
                    lcd_putchar('<');                     
                    }
                }
            /////////////////////

            // EILINIO LAIKO MENIU
                else if(Address[1]==1){                
                    if(Address[2]==0){
                        if(BUTTON[BUTTON_DOWN]==1){
                        SelectAnotherRow(0); 
                        }
                        else if(BUTTON[BUTTON_UP]==1){
                        SelectAnotherRow(1); 
                        }
                        else if(BUTTON[BUTTON_ENTER]==1){
                            if(SelectedRow==0){
                            Address[1] = 0;
                            }
                            else{
                            Address[2] = SelectedRow;
                            }    
                        SelectedRow = 0;
                        Address[5] = 0;
                        }
                     
                     
                        if(RefreshLcd>=1){
                        unsigned char row, lcd_row;
                        lcd_row = 0;
                        RowsOnWindow = 8;
                            for(row=Address[5];row<4+Address[5];row++){
                            lcd_gotoxy(0,lcd_row);
                             
                                if(row==0){
                                lcd_putsf(" -=EILINIS LAIKAS=-");
                                }
                                else if(row==1){
                                lcd_putsf("1.PIRMAD. LAIKAS");
                                }
                                else if(row==2){
                                lcd_putsf("2.ANTRAD. LAIKAS");
                                }
                                else if(row==3){
                                lcd_putsf("3.TRECIAD. LAIKAS");
                                }
                                else if(row==4){
                                lcd_putsf("4.KETVIRTAD. LAIKAS");
                                }
                                else if(row==5){
                                lcd_putsf("5.PENKTAD. LAIKAS");
                                }
                                else if(row==6){
                                lcd_putsf("6.SESTAD. LAIKAS");
                                }
                                else if(row==7){
                                lcd_putsf("7.SEKMAD. LAIKAS");
                                }
                                 
                            lcd_row++;
                            }
                         
                        lcd_gotoxy(19,SelectedRow-Address[5]);
                        lcd_putchar('<');                     
                        }
                    }
                    else if( (Address[2]>=1)&&(Address[2]<=7) ){
                        if(Address[3]==0){
                            if(BUTTON[BUTTON_DOWN]==1){
                            SelectAnotherRow(0); 
                            }
                            else if(BUTTON[BUTTON_UP]==1){
                            SelectAnotherRow(1); 
                            }
                            else if(BUTTON[BUTTON_ENTER]==1){
                                if(SelectedRow==0){
                                Address[2] = 0;
                                }
                                else if(SelectedRow>=1){
                                unsigned char id;
                                id = GetBellId(Address[2]-1, SelectedRow-1);
                                    if(id==255){
                                    id = GetFreeBellId(Address[2]-1);
                                    Address[3] = id+1; 
                                    }
                                Address[3] = id+1; 
                                }
                            SelectedRow = 0;
                            Address[5] = 0;   
                            }

                            if(RefreshLcd>=1){
                            unsigned char row, lcd_row;
                            lcd_row = 0;
                            RowsOnWindow = BELL_COUNT + 1;
                                for(row=Address[5];row<4+Address[5];row++){
                                lcd_gotoxy(0,lcd_row);
                                 
                                    if(row==0){
                                        if(Address[2]==1){
                                        lcd_putsf("  -=PIRMADIENIS=-");
                                        }
                                        else if(Address[2]==2){
                                        lcd_putsf("  -=ANTRADIENIS=-");
                                        }
                                        else if(Address[2]==3){
                                        lcd_putsf("  -=TRECIADIENIS=-");
                                        }
                                        else if(Address[2]==4){
                                        lcd_putsf(" -=KETVIRTADIENIS=-");
                                        }
                                        else if(Address[2]==5){
                                        lcd_putsf("  -=PENKTADIENIS=-");
                                        }
                                        else if(Address[2]==6){
                                        lcd_putsf("  -=SESTADIENIS=-");
                                        }
                                        else if(Address[2]==7){
                                        lcd_putsf("  -=SEKMADIENIS=-");
                                        }
                                    }
                                    else if(row>=1){
                                        if(row<=BELL_COUNT){
                                        unsigned char id;
                                        id = GetBellId(Address[2]-1, row-1);     
                                        lcd_put_number(0,2,0,0,row,0);
                                        lcd_putsf(". ");

                                            if(id!=255){
                                            lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][id][0],0);
                                            lcd_putchar(':');
                                            lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][id][1],0);
                                            lcd_putsf(" (");
                                            lcd_put_number(0,3,0,0,BELL_TIME[Address[2]-1][id][2],0);
                                            lcd_putsf("SEC)");       
                                            }
                                            else{
                                            lcd_putsf("TUSCIA");  
                                            }
                                        }  
                                    }
                                     
                                lcd_row++;
                                }
                             
                            lcd_gotoxy(19,SelectedRow-Address[5]);
                            lcd_putchar('<');                     
                            }
                        }
                        else{
                            if(Address[3]<=BELL_COUNT){
                                if(BUTTON[BUTTON_DOWN]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==0){
                                        SelectedRow = 2;
                                        }
                                        else if(SelectedRow==1){
                                        SelectedRow = 2; 
                                        }
                                        else if(SelectedRow==2){
                                        SelectedRow = 3;
                                        }
                                    }
                                    else if(Address[4]==1){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][0]-10 >= 0){
                                        BELL_TIME[Address[2]-1][Address[3]-1][0] += -10;
                                        } 
                                    }
                                    else if(Address[4]==2){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][0]-1 >= 0){
                                        BELL_TIME[Address[2]-1][Address[3]-1][0] += -1;
                                        } 
                                    }
                                    else if(Address[4]==3){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][1]-10 >= 0){
                                        BELL_TIME[Address[2]-1][Address[3]-1][1] += -10;
                                        } 
                                    }
                                    else if(Address[4]==4){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][1]-1 >= 0){
                                        BELL_TIME[Address[2]-1][Address[3]-1][1] += -1;
                                        } 
                                    }
                                    else if(Address[4]==5){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][2]-100 > 0){
                                        BELL_TIME[Address[2]-1][Address[3]-1][2] += -100;
                                        } 
                                    }
                                    else if(Address[4]==6){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][2]-10 > 0){
                                        BELL_TIME[Address[2]-1][Address[3]-1][2] += -10;
                                        } 
                                    }
                                    else if(Address[4]==7){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][2]-1 > 0){
                                        BELL_TIME[Address[2]-1][Address[3]-1][2] += -1;
                                        } 
                                    }
                                }
                                else if(BUTTON[BUTTON_UP]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==1){
                                        SelectedRow = 0;
                                        }
                                        else if(SelectedRow==2){
                                        SelectedRow = 0;
                                        }
                                        else if(SelectedRow==3){
                                        SelectedRow = 2;
                                        }
                                    }
                                    else if(Address[4]==1){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][0]+10 < 24){
                                        BELL_TIME[Address[2]-1][Address[3]-1][0] += 10;
                                        } 
                                    }
                                    else if(Address[4]==2){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][0]+1 < 24){
                                        BELL_TIME[Address[2]-1][Address[3]-1][0] += 1;
                                        } 
                                    }
                                    else if(Address[4]==3){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][1]+10 < 60){
                                        BELL_TIME[Address[2]-1][Address[3]-1][1] += 10;
                                        } 
                                    }
                                    else if(Address[4]==4){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][1]+1 < 60){
                                        BELL_TIME[Address[2]-1][Address[3]-1][1] += 1;
                                        } 
                                    }
                                    else if(Address[4]==5){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][2]+100 <= 255){
                                        BELL_TIME[Address[2]-1][Address[3]-1][2] += 100;
                                        } 
                                    }
                                    else if(Address[4]==6){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][2]+10 <= 255){
                                        BELL_TIME[Address[2]-1][Address[3]-1][2] += 10;
                                        } 
                                    }
                                    else if(Address[4]==7){
                                        if(BELL_TIME[Address[2]-1][Address[3]-1][2]+1 <= 255){
                                        BELL_TIME[Address[2]-1][Address[3]-1][2] += 1;
                                        } 
                                    } 
                                }
                                else if(BUTTON[BUTTON_LEFT]==1){
                                    if(Address[4]>1){
                                    Address[4]--;
                                    } 
                                }
                                else if(BUTTON[BUTTON_RIGHT]==1){
                                    if(Address[4]>0){
                                        if(Address[4]<7){
                                        Address[4]++;
                                        }
                                    }   
                                }
                                else if(BUTTON[BUTTON_ENTER]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==0){
                                        Address[3] = 0;
                                        }
                                        else if(SelectedRow==2){
                                        Address[4] = 1;                                    
                                        }
                                        else if(SelectedRow==3){
                                        BELL_TIME[Address[2]-1][Address[3]-1][0] = 0;
                                        BELL_TIME[Address[2]-1][Address[3]-1][1] = 0;
                                        BELL_TIME[Address[2]-1][Address[3]-1][2] = 0; 
                                        Address[3] = 0;                                    
                                        }
                                    }
                                    else{
                                    Address[4] = 0; 
                                    }   
                                SelectedRow = 0;
                                Address[5] = 0;
                                }
                             
                                if(RefreshLcd>=1){
                                lcd_putsf(" -=LAIKO KEITIMAS=- ");
                                    if(BELL_TIME[Address[2]-1][Address[3]-1][0]>=24){
                                    BELL_TIME[Address[2]-1][Address[3]-1][0] = 0;
                                    BELL_TIME[Address[2]-1][Address[3]-1][1] = 0;
                                    BELL_TIME[Address[2]-1][Address[3]-1][2] = 0;
                                    }
                                    else if(BELL_TIME[Address[2]-1][Address[3]-1][1]>=60){
                                    BELL_TIME[Address[2]-1][Address[3]-1][0] = 0;
                                    BELL_TIME[Address[2]-1][Address[3]-1][1] = 0;
                                    BELL_TIME[Address[2]-1][Address[3]-1][2] = 0;
                                    }
                                          
                                lcd_putsf("LAIKAS: ");
                                lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][Address[3]-1][0],0);
                                lcd_putchar('.');
                                lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][Address[3]-1][1],0);
                                lcd_putsf(" (");
                                lcd_put_number(0,3,0,0,BELL_TIME[Address[2]-1][Address[3]-1][2],0);
                                lcd_putchar(')');lcd_putsf(" ");
                                 
                                 
                                    if(Address[4]==1){
                                    lcd_putsf("        ^"); 
                                    }
                                    else if(Address[4]==2){ 
                                    lcd_putsf("         ^"); 
                                    }
                                    else if(Address[4]==3){ 
                                    lcd_putsf("           ^"); 
                                    }
                                    else if(Address[4]==4){ 
                                    lcd_putsf("            ^"); 
                                    }
                                    else if(Address[4]==5){ 
                                    lcd_putsf("               ^"); 
                                    }
                                    else if(Address[4]==6){ 
                                    lcd_putsf("                ^"); 
                                    }
                                    else if(Address[4]==7){ 
                                    lcd_putsf("                 ^"); 
                                    }
                                    else if(Address[4]==0){
                                    lcd_putsf("      REDAGUOTI?    ");
                                    lcd_putsf("       TRINTI?      ");
                                    lcd_gotoxy(19,SelectedRow-Address[5]);
                                    lcd_putchar('<');
                                    }                     
                                }
                            }
                            else{
                            Address[3] = 0;
                            SelectedRow = 0;
                            Address[5] = 0; 
                            }
                        }
                    }
                    else{
                    Address[2] = 0;
                    SelectedRow = 0;
                    Address[5] = 0;
                    }
                }
            /////////////////////
                
            // VELYKU LAIKO MENIU
                else if(Address[1]==2){
                    if(Address[2]==0){           
                        if(BUTTON[BUTTON_DOWN]==1){
                        SelectAnotherRow(0); 
                        }
                        else if(BUTTON[BUTTON_UP]==1){
                        SelectAnotherRow(1); 
                        }
                        else if(BUTTON[BUTTON_ENTER]==1){
                            if(SelectedRow==0){
                            Address[1] = 0;
                            }
                            else{
                            Address[2] = SelectedRow;
                            }
                        SelectedRow = 0;
                        Address[5] = 0;
                        }

                        if(RefreshLcd>=1){
                        unsigned char row, lcd_row;
                        lcd_row = 0; 
                        RowsOnWindow = 6;
                            for(row=Address[5];row<4+Address[5];row++){
                            lcd_gotoxy(0,lcd_row);
                                 
                                if(row==0){
                                lcd_putsf(" -=VELYKU LAIKAS=-");
                                }
                                else if(row==1){
                                lcd_putsf("1.VELYKU KETVIRTAD.");
                                }
                                else if(row==2){
                                lcd_putsf("2.VELYKU PENKTAD.");
                                }
                                else if(row==3){
                                lcd_putsf("3.VELYKU SESTADIEN.");
                                }
                                else if(row==4){
                                lcd_putsf("4.VELYKU SEKMAD.");
                                }
                                else if(row==5){
                                lcd_putsf("5.KADA BUS VELYKOS?");
                                }
                                     
                            lcd_row++;
                            }
                              
                        lcd_gotoxy(19,SelectedRow-Address[5]);
                        lcd_putchar('<');                     
                        }
                        
                        
                    }
                    else if( (Address[2]>=1)&&(Address[2]<=4) ){
                     
                        if(Address[3]==0){
                            if(BUTTON[BUTTON_DOWN]==1){
                            SelectAnotherRow(0); 
                            }
                            else if(BUTTON[BUTTON_UP]==1){
                            SelectAnotherRow(1); 
                            }
                            else if(BUTTON[BUTTON_ENTER]==1){
                                if(SelectedRow==0){
                                Address[2] = 0;
                                }
                                else{
                                Address[3] = SelectedRow;
                                }
                            SelectedRow = 0;
                            Address[5] = 0;
                            }

                            if(RefreshLcd>=1){
                            unsigned char row, lcd_row;
                            lcd_row = 0;
                            RowsOnWindow = 20;
                                for(row=Address[5];row<4+Address[5];row++){
                                lcd_gotoxy(0,lcd_row);
                                 
                                    if(row==0){
                                        if(Address[2]==1){
                                        lcd_putsf("-=VEL. KETVIRTAD.=-");
                                        }
                                        else if(Address[2]==2){
                                        lcd_putsf(" -=VEL. PENKTAD.=-");
                                        }
                                        else if(Address[2]==3){
                                        lcd_putsf("  -=VEL. SESTAD.=-");
                                        }
                                        else if(Address[2]==4){
                                        lcd_putsf("  -=VEL. SEKMAD.=-");
                                        }
                                    }
                                    else if(row>=1){
                                        if(row<=BELL_COUNT){
                                        unsigned char id;
                                        id = GetBellId(Address[2]+6, row-1);     
                                        lcd_put_number(0,2,0,0,row,0);
                                        lcd_putsf(". ");

                                            if(id!=255){
                                            lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][id][0],0);
                                            lcd_putchar(':');
                                            lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][id][1],0);
                                            lcd_putsf(" (");
                                            lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+6][id][2],0);
                                            lcd_putsf("SEC)");       
                                            }
                                            else{
                                            lcd_putsf("TUSCIA");  
                                            }
                                        }  
                                    }
                                     
                                lcd_row++;
                                }
                             
                            lcd_gotoxy(19,SelectedRow-Address[5]);
                            lcd_putchar('<');                     
                            } 
                        }
                        else{
                            if(Address[3]<=BELL_COUNT){
                                if(BUTTON[BUTTON_DOWN]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==0){
                                        SelectedRow = 2;
                                        }
                                        else if(SelectedRow==1){
                                        SelectedRow = 2;
                                        }
                                        else if(SelectedRow==2){
                                        SelectedRow = 3;
                                        }
                                    }
                                    else if(Address[4]==1){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][0]-10 >= 0){
                                        BELL_TIME[Address[2]+6][Address[3]-1][0] += -10;
                                        } 
                                    }
                                    else if(Address[4]==2){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][0]-1 >= 0){
                                        BELL_TIME[Address[2]+6][Address[3]-1][0] += -1;
                                        } 
                                    }
                                    else if(Address[4]==3){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][1]-10 >= 0){
                                        BELL_TIME[Address[2]+6][Address[3]-1][1] += -10;
                                        } 
                                    }
                                    else if(Address[4]==4){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][1]-1 >= 0){
                                        BELL_TIME[Address[2]+6][Address[3]-1][1] += -1;
                                        } 
                                    }
                                    else if(Address[4]==5){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][2]-100 > 0){
                                        BELL_TIME[Address[2]+6][Address[3]-1][2] += -100;
                                        } 
                                    }
                                    else if(Address[4]==6){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][2]-10 > 0){
                                        BELL_TIME[Address[2]+6][Address[3]-1][2] += -10;
                                        } 
                                    }
                                    else if(Address[4]==7){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][2]-1 > 0){
                                        BELL_TIME[Address[2]+6][Address[3]-1][2] += -1;
                                        } 
                                    }
                                }
                                else if(BUTTON[BUTTON_UP]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==1){
                                        SelectedRow = 0;
                                        }
                                        else if(SelectedRow==2){
                                        SelectedRow = 0;
                                        }
                                        else if(SelectedRow==3){
                                        SelectedRow = 2;
                                        }
                                    }
                                    else if(Address[4]==1){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][0]+10 < 24){
                                        BELL_TIME[Address[2]+6][Address[3]-1][0] += 10;
                                        } 
                                    }
                                    else if(Address[4]==2){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][0]+1 < 24){
                                        BELL_TIME[Address[2]+6][Address[3]-1][0] += 1;
                                        } 
                                    }
                                    else if(Address[4]==3){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][1]+10 < 60){
                                        BELL_TIME[Address[2]+6][Address[3]-1][1] += 10;
                                        } 
                                    }
                                    else if(Address[4]==4){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][1]+1 < 60){
                                        BELL_TIME[Address[2]+6][Address[3]-1][1] += 1;
                                        } 
                                    }
                                    else if(Address[4]==5){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][2]+100 <= 255){
                                        BELL_TIME[Address[2]+6][Address[3]-1][2] += 100;
                                        } 
                                    }
                                    else if(Address[4]==6){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][2]+10 <= 255){
                                        BELL_TIME[Address[2]+6][Address[3]-1][2] += 10;
                                        } 
                                    }
                                    else if(Address[4]==7){
                                        if(BELL_TIME[Address[2]+6][Address[3]-1][2]+1 <= 255){
                                        BELL_TIME[Address[2]+6][Address[3]-1][2] += 1;
                                        } 
                                    } 
                                }
                                else if(BUTTON[BUTTON_LEFT]==1){
                                    if(Address[4]>1){
                                    Address[4]--;
                                    } 
                                }
                                else if(BUTTON[BUTTON_RIGHT]==1){
                                    if(Address[4]>0){
                                        if(Address[4]<7){
                                        Address[4]++;
                                        }
                                    }   
                                }
                                else if(BUTTON[BUTTON_ENTER]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==0){
                                        Address[3] = 0;
                                        }
                                        else if(SelectedRow==2){
                                        Address[4] = 1;                                    
                                        }
                                        else if(SelectedRow==3){
                                        BELL_TIME[Address[2]+6][Address[3]-1][0] = 0;
                                        BELL_TIME[Address[2]+6][Address[3]-1][1] = 0;
                                        BELL_TIME[Address[2]+6][Address[3]-1][2] = 0; 
                                        Address[3] = 0;                                    
                                        }
                                    }
                                    else{
                                    Address[4] = 0; 
                                    }
                                SelectedRow = 0;
                                Address[5] = 0;
                                }
                             
                                if(RefreshLcd>=1){
                                lcd_putsf(" -=LAIKO KEITIMAS=- ");
                                    if(BELL_TIME[Address[2]+6][Address[3]-1][0]>=24){
                                    BELL_TIME[Address[2]+6][Address[3]-1][0] = 0;
                                    BELL_TIME[Address[2]+6][Address[3]-1][1] = 0;
                                    BELL_TIME[Address[2]+6][Address[3]-1][2] = 0;
                                    }
                                    else if(BELL_TIME[Address[2]-1][Address[3]-1][1]>=60){
                                    BELL_TIME[Address[2]+6][Address[3]-1][0] = 0;
                                    BELL_TIME[Address[2]+6][Address[3]-1][1] = 0;
                                    BELL_TIME[Address[2]+6][Address[3]-1][2] = 0;
                                    }
                                          
                                lcd_putsf("LAIKAS: ");
                                lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][Address[3]-1][0],0);
                                lcd_putchar('.');
                                lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][Address[3]-1][1],0);
                                lcd_putsf(" (");
                                lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+6][Address[3]-1][2],0);
                                lcd_putchar(')');lcd_putsf(" ");
                                 
                                 
                                    if(Address[4]==1){
                                    lcd_putsf("        ^"); 
                                    }
                                    else if(Address[4]==2){ 
                                    lcd_putsf("         ^"); 
                                    }
                                    else if(Address[4]==3){ 
                                    lcd_putsf("           ^"); 
                                    }
                                    else if(Address[4]==4){ 
                                    lcd_putsf("            ^"); 
                                    }
                                    else if(Address[4]==5){ 
                                    lcd_putsf("               ^"); 
                                    }
                                    else if(Address[4]==6){ 
                                    lcd_putsf("                ^"); 
                                    }
                                    else if(Address[4]==7){ 
                                    lcd_putsf("                 ^"); 
                                    }
                                    else if(Address[4]==0){
                                    lcd_putsf("      REDAGUOTI?    ");
                                    lcd_putsf("       TRINTI?      ");
                                    lcd_gotoxy(19,SelectedRow-Address[5]);
                                    lcd_putchar('<');
                                    }                     
                                }
                            }
                            else{
                            Address[3] = 0;
                            SelectedRow = 0;
                            Address[5] = 0; 
                            }
                        }   
                    }
                    else if(Address[2]==5){
                        if(BUTTON[BUTTON_ENTER]==1){
                        Address[2] = 0;
                        SelectedRow = 0;
                        Address[5] = 0;
                        }
                        
                        if(RefreshLcd>=1){
                        lcd_putsf("  -=VELYKU DATOS=-  ");
                        
                        lcd_putsf("1. 2");        
                        lcd_put_number(0,3,0,0,RealTimeYear,0);
                        lcd_putsf(".");
                        lcd_put_number(0,2,0,0,GetEasterMonth(RealTimeYear),0);
                        lcd_putsf(".");
                        lcd_put_number(0,2,0,0,GetEasterDay(RealTimeYear),0);
                        lcd_putsf("       ");
                        
                        lcd_putsf("2. 2"); 
                        lcd_put_number(0,3,0,0,RealTimeYear+1,0);
                        lcd_putsf(".");
                        lcd_put_number(0,2,0,0,GetEasterMonth(RealTimeYear+1),0);
                        lcd_putsf(".");
                        lcd_put_number(0,2,0,0,GetEasterDay(RealTimeYear+1),0);
                        lcd_putsf("       ");
                        
                        lcd_putsf("3. 2"); 
                        lcd_put_number(0,3,0,0,RealTimeYear+2,0);
                        lcd_putsf(".");
                        lcd_put_number(0,2,0,0,GetEasterMonth(RealTimeYear+2),0);
                        lcd_putsf(".");
                        lcd_put_number(0,2,0,0,GetEasterDay(RealTimeYear+2),0);                
                        }           
                    }
                    else{
                    Address[2] = 0;
                    SelectedRow = 0;
                    Address[5] = 0;
                    } 
                }
            /////////////////////
                
            // KALEDU LAIKO MENIU
                else if(Address[1]==3){
                    if(Address[2]==0){            
                        if(BUTTON[BUTTON_DOWN]==1){
                        SelectAnotherRow(0); 
                        }
                        else if(BUTTON[BUTTON_UP]==1){
                        SelectAnotherRow(1); 
                        }
                        else if(BUTTON[BUTTON_ENTER]==1){
                            if(SelectedRow==0){
                            Address[1] = 0;
                            }
                            else{
                            Address[2] = SelectedRow;
                            }
                        SelectedRow = 0;
                        Address[5] = 0;
                        }
                        
                        if(RefreshLcd>=1){
                        unsigned char row, lcd_row;
                        lcd_row = 0;
                        RowsOnWindow = 3;
                            for(row=Address[5];row<4+Address[5];row++){
                            lcd_gotoxy(0,lcd_row);
                             
                                if(row==0){
                                lcd_putsf(" -=KALEDU LAIKAS=-");
                                }
                                else if(row==1){
                                lcd_putsf("1.GRUODZIO 25 D.");
                                }
                                else if(row==2){
                                lcd_putsf("2.GRUODZIO 26 D.");
                                }
                                 
                            lcd_row++;
                            }
                         
                        lcd_gotoxy(19,SelectedRow-Address[5]);
                        lcd_putchar('<');                     
                        }
                    }
                    else if( (Address[2]>=1)&&(Address[2]<=2) ){
                        if(Address[3]==0){
                            if(BUTTON[BUTTON_DOWN]==1){
                            SelectAnotherRow(0); 
                            }
                            else if(BUTTON[BUTTON_UP]==1){
                            SelectAnotherRow(1); 
                            }
                            else if(BUTTON[BUTTON_ENTER]==1){
                                if(SelectedRow==0){
                                Address[2] = 0;
                                }
                                else{
                                Address[3] = SelectedRow;
                                }
                            SelectedRow = 0;
                            Address[5] = 0;
                            }
                             
                            if(RefreshLcd>=1){
                            unsigned char row, lcd_row;
                            lcd_row = 0;
                            RowsOnWindow = 20;
                                for(row=Address[5];row<4+Address[5];row++){
                                lcd_gotoxy(0,lcd_row);
                                     
                                    if(row==0){
                                        if(Address[2]==1){
                                        lcd_putsf(" -=GRUODZIO 25 D.=-");
                                        }
                                        else if(Address[2]==2){
                                        lcd_putsf(" -=GRUODZIO 26 D.=-");
                                        }
                                    }
                                    else if(row>=1){
                                        if(row<=BELL_COUNT){
                                        unsigned char id;
                                        id = GetBellId(Address[2]+10, row-1);     
                                        lcd_put_number(0,2,0,0,row,0);
                                        lcd_putsf(". ");

                                            if(id!=255){
                                            lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][id][0],0);
                                            lcd_putchar(':');
                                            lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][id][1],0);
                                            lcd_putsf(" (");
                                            lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+10][id][2],0);
                                            lcd_putsf("SEC)");       
                                            }
                                            else{
                                            lcd_putsf("TUSCIA");  
                                            }
                                        }  
                                    }
                                         
                                lcd_row++;
                                }
                                 
                            lcd_gotoxy(19,SelectedRow-Address[5]);
                            lcd_putchar('<');                     
                            } 
                        }
                        else{
                            if(Address[3]<=BELL_COUNT){
                                if(BUTTON[BUTTON_DOWN]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==0){
                                        SelectedRow = 2;
                                        }
                                        else if(SelectedRow==1){
                                        SelectedRow = 2;
                                        }
                                        else if(SelectedRow==2){
                                        SelectedRow = 3;
                                        }
                                    }
                                    else if(Address[4]==1){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][0]-10 >= 0){
                                        BELL_TIME[Address[2]+10][Address[3]-1][0] += -10;
                                        } 
                                    }
                                    else if(Address[4]==2){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][0]-1 >= 0){
                                        BELL_TIME[Address[2]+10][Address[3]-1][0] += -1;
                                        } 
                                    }
                                    else if(Address[4]==3){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][1]-10 >= 0){
                                        BELL_TIME[Address[2]+10][Address[3]-1][1] += -10;
                                        } 
                                    }
                                    else if(Address[4]==4){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][1]-1 >= 0){
                                        BELL_TIME[Address[2]+10][Address[3]-1][1] += -1;
                                        } 
                                    }
                                    else if(Address[4]==5){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][2]-100 > 0){
                                        BELL_TIME[Address[2]+10][Address[3]-1][2] += -100;
                                        } 
                                    }
                                    else if(Address[4]==6){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][2]-10 > 0){
                                        BELL_TIME[Address[2]+10][Address[3]-1][2] += -10;
                                        } 
                                    }
                                    else if(Address[4]==7){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][2]-1 > 0){
                                        BELL_TIME[Address[2]+10][Address[3]-1][2] += -1;
                                        } 
                                    }
                                }
                                else if(BUTTON[BUTTON_UP]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==1){
                                        SelectedRow = 0;
                                        }    
                                        else if(SelectedRow==2){
                                        SelectedRow = 0;
                                        }
                                        else if(SelectedRow==3){
                                        SelectedRow = 2;
                                        }
                                    }
                                    else if(Address[4]==1){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][0]+10 < 24){
                                        BELL_TIME[Address[2]+10][Address[3]-1][0] += 10;
                                        } 
                                    }
                                    else if(Address[4]==2){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][0]+1 < 24){
                                        BELL_TIME[Address[2]+10][Address[3]-1][0] += 1;
                                        } 
                                    }
                                    else if(Address[4]==3){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][1]+10 < 60){
                                        BELL_TIME[Address[2]+10][Address[3]-1][1] += 10;
                                        } 
                                    }
                                    else if(Address[4]==4){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][1]+1 < 60){
                                        BELL_TIME[Address[2]+10][Address[3]-1][1] += 1;
                                        } 
                                    }
                                    else if(Address[4]==5){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][2]+100 <= 255){
                                        BELL_TIME[Address[2]+10][Address[3]-1][2] += 100;
                                        } 
                                    }
                                    else if(Address[4]==6){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][2]+10 <= 255){
                                        BELL_TIME[Address[2]+10][Address[3]-1][2] += 10;
                                        } 
                                    }
                                    else if(Address[4]==7){
                                        if(BELL_TIME[Address[2]+10][Address[3]-1][2]+1 <= 255){
                                        BELL_TIME[Address[2]+10][Address[3]-1][2] += 1;
                                        } 
                                    } 
                                }
                                else if(BUTTON[BUTTON_LEFT]==1){
                                    if(Address[4]>1){
                                    Address[4]--;
                                    } 
                                }
                                else if(BUTTON[BUTTON_RIGHT]==1){
                                    if(Address[4]>0){
                                        if(Address[4]<7){
                                        Address[4]++;
                                        }
                                    }   
                                }
                                else if(BUTTON[BUTTON_ENTER]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==0){
                                        Address[3] = 0;
                                        }
                                        else if(SelectedRow==2){
                                        Address[4] = 1;                                    
                                        }
                                        else if(SelectedRow==3){
                                        BELL_TIME[Address[2]+10][Address[3]-1][0] = 0;
                                        BELL_TIME[Address[2]+10][Address[3]-1][1] = 0;
                                        BELL_TIME[Address[2]+10][Address[3]-1][2] = 0; 
                                        Address[3] = 0;                                    
                                        }
                                    }
                                    else{
                                    Address[4] = 0; 
                                    }
                                SelectedRow = 0;
                                Address[5] = 0;
                                }
                             
                                if(RefreshLcd>=1){
                                lcd_putsf(" -=LAIKO KEITIMAS=- ");
                                    if(BELL_TIME[Address[2]+10][Address[3]-1][0]>=24){
                                    BELL_TIME[Address[2]+10][Address[3]-1][0] = 0;
                                    BELL_TIME[Address[2]+10][Address[3]-1][1] = 0;
                                    BELL_TIME[Address[2]+10][Address[3]-1][2] = 0;
                                    }
                                    else if(BELL_TIME[Address[2]-1][Address[3]-1][1]>=60){
                                    BELL_TIME[Address[2]+10][Address[3]-1][0] = 0;
                                    BELL_TIME[Address[2]+10][Address[3]-1][1] = 0;
                                    BELL_TIME[Address[2]+10][Address[3]-1][2] = 0;
                                    }
                                          
                                lcd_putsf("LAIKAS: ");
                                lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][Address[3]-1][0],0);
                                lcd_putchar('.');
                                lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][Address[3]-1][1],0);
                                lcd_putsf(" (");
                                lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+10][Address[3]-1][2],0);
                                lcd_putchar(')');lcd_putsf(" ");
                                 
                                 
                                    if(Address[4]==1){
                                    lcd_putsf("        ^"); 
                                    }
                                    else if(Address[4]==2){ 
                                    lcd_putsf("         ^"); 
                                    }
                                    else if(Address[4]==3){ 
                                    lcd_putsf("           ^"); 
                                    }
                                    else if(Address[4]==4){ 
                                    lcd_putsf("            ^"); 
                                    }
                                    else if(Address[4]==5){ 
                                    lcd_putsf("               ^"); 
                                    }
                                    else if(Address[4]==6){ 
                                    lcd_putsf("                ^"); 
                                    }
                                    else if(Address[4]==7){ 
                                    lcd_putsf("                 ^"); 
                                    }
                                    else if(Address[4]==0){
                                    lcd_putsf("      REDAGUOTI?    ");
                                    lcd_putsf("       TRINTI?      ");
                                    lcd_gotoxy(19,SelectedRow-Address[5]);
                                    lcd_putchar('<');
                                    }                     
                                }
                            }
                            else{
                            Address[3] = 0;
                            SelectedRow = 0;
                            Address[5] = 0; 
                            }
                        }
                    }                                               
                }
            /////////////////////                                                   

            // PORCIUNKULES ATLAIDU LAIKO MENIU
                else if(Address[1]==4){
                    if(Address[2]==0){            
                        if(BUTTON[BUTTON_DOWN]==1){
                        SelectAnotherRow(0); 
                        }
                        else if(BUTTON[BUTTON_UP]==1){
                        SelectAnotherRow(1); 
                        }
                        else if(BUTTON[BUTTON_ENTER]==1){
                            if(SelectedRow==0){
                            Address[1] = 0;
                            }
                            else{
                            Address[2] = SelectedRow;
                            }
                        SelectedRow = 0;
                        Address[5] = 0;
                        }
                        
                        if(RefreshLcd>=1){
                        unsigned char row, lcd_row;
                        lcd_row = 0;
                        RowsOnWindow = 2;
                            for(row=Address[5];row<4+Address[5];row++){
                            lcd_gotoxy(0,lcd_row);
                             
                                if(row==0){
                                lcd_putsf("  -=PORCIUNKULE=-  ");
                                }
                                else if(row==1){
                                lcd_putsf("1.SEKMADIENIS");
                                }
                                 
                            lcd_row++;
                            }
                         
                        lcd_gotoxy(19,SelectedRow-Address[5]);
                        lcd_putchar('<');                     
                        }
                    }
                    else if(Address[2]==1){
                        if(Address[3]==0){
                            if(BUTTON[BUTTON_DOWN]==1){
                            SelectAnotherRow(0); 
                            }
                            else if(BUTTON[BUTTON_UP]==1){
                            SelectAnotherRow(1); 
                            }
                            else if(BUTTON[BUTTON_ENTER]==1){
                                if(SelectedRow==0){
                                Address[2] = 0;
                                }
                                else{
                                Address[3] = SelectedRow;
                                }
                            SelectedRow = 0;
                            Address[5] = 0;
                            }
                             
                            if(RefreshLcd>=1){
                            unsigned char row, lcd_row;
                            lcd_row = 0;
                            RowsOnWindow = 20;
                                for(row=Address[5];row<4+Address[5];row++){
                                lcd_gotoxy(0,lcd_row);
                                     
                                    if(row==0){
                                        if(Address[2]==1){
                                        lcd_putsf("  -=SEKMADIENIS=-  ");
                                        }
                                    }
                                    else if(row>=1){
                                        if(row<=BELL_COUNT){
                                        unsigned char id;
                                        id = GetBellId(13, row-1);     
                                        lcd_put_number(0,2,0,0,row,0);
                                        lcd_putsf(". ");

                                            if(id!=255){
                                            lcd_put_number(0,2,0,0,BELL_TIME[13][id][0],0);
                                            lcd_putchar(':');
                                            lcd_put_number(0,2,0,0,BELL_TIME[13][id][1],0);
                                            lcd_putsf(" (");
                                            lcd_put_number(0,3,0,0,BELL_TIME[13][id][2],0);
                                            lcd_putsf("SEC)");       
                                            }
                                            else{
                                            lcd_putsf("TUSCIA");  
                                            }
                                        }  
                                    }
                                         
                                lcd_row++;
                                }
                                 
                            lcd_gotoxy(19,SelectedRow-Address[5]);
                            lcd_putchar('<');                     
                            } 
                        }
                        else{
                            if(Address[3]<=BELL_COUNT){
                                if(BUTTON[BUTTON_DOWN]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==0){
                                        SelectedRow = 2;
                                        }
                                        else if(SelectedRow==1){
                                        SelectedRow = 2;
                                        }
                                        else if(SelectedRow==2){
                                        SelectedRow = 3;
                                        }
                                    }
                                    else if(Address[4]==1){
                                        if(BELL_TIME[13][Address[3]-1][0]-10 >= 0){
                                        BELL_TIME[13][Address[3]-1][0] += -10;
                                        } 
                                    }
                                    else if(Address[4]==2){
                                        if(BELL_TIME[13][Address[3]-1][0]-1 >= 0){
                                        BELL_TIME[13][Address[3]-1][0] += -1;
                                        } 
                                    }
                                    else if(Address[4]==3){
                                        if(BELL_TIME[13][Address[3]-1][1]-10 >= 0){
                                        BELL_TIME[13][Address[3]-1][1] += -10;
                                        } 
                                    }
                                    else if(Address[4]==4){
                                        if(BELL_TIME[13][Address[3]-1][1]-1 >= 0){
                                        BELL_TIME[13][Address[3]-1][1] += -1;
                                        } 
                                    }
                                    else if(Address[4]==5){
                                        if(BELL_TIME[13][Address[3]-1][2]-100 > 0){
                                        BELL_TIME[13][Address[3]-1][2] += -100;
                                        } 
                                    }
                                    else if(Address[4]==6){
                                        if(BELL_TIME[13][Address[3]-1][2]-10 > 0){
                                        BELL_TIME[13][Address[3]-1][2] += -10;
                                        } 
                                    }
                                    else if(Address[4]==7){
                                        if(BELL_TIME[13][Address[3]-1][2]-1 > 0){
                                        BELL_TIME[13][Address[3]-1][2] += -1;
                                        } 
                                    }
                                }
                                else if(BUTTON[BUTTON_UP]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==1){
                                        SelectedRow = 0;
                                        }    
                                        else if(SelectedRow==2){
                                        SelectedRow = 0;
                                        }
                                        else if(SelectedRow==3){
                                        SelectedRow = 2;
                                        }
                                    }
                                    else if(Address[4]==1){
                                        if(BELL_TIME[13][Address[3]-1][0]+10 < 24){
                                        BELL_TIME[13][Address[3]-1][0] += 10;
                                        } 
                                    }
                                    else if(Address[4]==2){
                                        if(BELL_TIME[13][Address[3]-1][0]+1 < 24){
                                        BELL_TIME[13][Address[3]-1][0] += 1;
                                        } 
                                    }
                                    else if(Address[4]==3){
                                        if(BELL_TIME[13][Address[3]-1][1]+10 < 60){
                                        BELL_TIME[13][Address[3]-1][1] += 10;
                                        } 
                                    }
                                    else if(Address[4]==4){
                                        if(BELL_TIME[13][Address[3]-1][1]+1 < 60){
                                        BELL_TIME[13][Address[3]-1][1] += 1;
                                        } 
                                    }
                                    else if(Address[4]==5){
                                        if(BELL_TIME[13][Address[3]-1][2]+100 <= 255){
                                        BELL_TIME[13][Address[3]-1][2] += 100;
                                        } 
                                    }
                                    else if(Address[4]==6){
                                        if(BELL_TIME[13][Address[3]-1][2]+10 <= 255){
                                        BELL_TIME[13][Address[3]-1][2] += 10;
                                        } 
                                    }
                                    else if(Address[4]==7){
                                        if(BELL_TIME[13][Address[3]-1][2]+1 <= 255){
                                        BELL_TIME[13][Address[3]-1][2] += 1;
                                        } 
                                    } 
                                }
                                else if(BUTTON[BUTTON_LEFT]==1){
                                    if(Address[4]>1){
                                    Address[4]--;
                                    } 
                                }
                                else if(BUTTON[BUTTON_RIGHT]==1){
                                    if(Address[4]>0){
                                        if(Address[4]<7){
                                        Address[4]++;
                                        }
                                    }   
                                }
                                else if(BUTTON[BUTTON_ENTER]==1){
                                    if(Address[4]==0){
                                        if(SelectedRow==0){
                                        Address[3] = 0;
                                        }
                                        else if(SelectedRow==2){
                                        Address[4] = 1;                                    
                                        }
                                        else if(SelectedRow==3){
                                        BELL_TIME[13][Address[3]-1][0] = 0;
                                        BELL_TIME[13][Address[3]-1][1] = 0;
                                        BELL_TIME[13][Address[3]-1][2] = 0; 
                                        Address[3] = 0;                                    
                                        }
                                    }
                                    else{
                                    Address[4] = 0; 
                                    }
                                SelectedRow = 0;
                                Address[5] = 0;
                                }
                             
                                if(RefreshLcd>=1){
                                lcd_putsf(" -=LAIKO KEITIMAS=- ");
                                    if(BELL_TIME[13][Address[3]-1][0]>=24){
                                    BELL_TIME[13][Address[3]-1][0] = 0;
                                    BELL_TIME[13][Address[3]-1][1] = 0;
                                    BELL_TIME[13][Address[3]-1][2] = 0;
                                    }
                                    else if(BELL_TIME[Address[2]-1][Address[3]-1][1]>=60){
                                    BELL_TIME[13][Address[3]-1][0] = 0;
                                    BELL_TIME[13][Address[3]-1][1] = 0;
                                    BELL_TIME[13][Address[3]-1][2] = 0;
                                    }
                                          
                                lcd_putsf("LAIKAS: ");
                                lcd_put_number(0,2,0,0,BELL_TIME[13][Address[3]-1][0],0);
                                lcd_putchar('.');
                                lcd_put_number(0,2,0,0,BELL_TIME[13][Address[3]-1][1],0);
                                lcd_putsf(" (");
                                lcd_put_number(0,3,0,0,BELL_TIME[13][Address[3]-1][2],0);
                                lcd_putchar(')');lcd_putsf(" ");
                                 
                                 
                                    if(Address[4]==1){
                                    lcd_putsf("        ^"); 
                                    }
                                    else if(Address[4]==2){ 
                                    lcd_putsf("         ^"); 
                                    }
                                    else if(Address[4]==3){ 
                                    lcd_putsf("           ^"); 
                                    }
                                    else if(Address[4]==4){ 
                                    lcd_putsf("            ^"); 
                                    }
                                    else if(Address[4]==5){ 
                                    lcd_putsf("               ^"); 
                                    }
                                    else if(Address[4]==6){ 
                                    lcd_putsf("                ^"); 
                                    }
                                    else if(Address[4]==7){ 
                                    lcd_putsf("                 ^"); 
                                    }
                                    else if(Address[4]==0){
                                    lcd_putsf("      REDAGUOTI?    ");
                                    lcd_putsf("       TRINTI?      ");
                                    lcd_gotoxy(19,SelectedRow-Address[5]);
                                    lcd_putchar('<');
                                    }                     
                                }
                            }
                            else{
                            Address[3] = 0;
                            SelectedRow = 0;
                            Address[5] = 0; 
                            }
                        }
                    }                                               
                }
            /////////////////////


            }

            // Nustatymai
            else if(Address[0]==4){ 
                if(Address[1]==0){
                    if(BUTTON[BUTTON_DOWN]==1){
                    SelectAnotherRow(0); 
                    }
                    else if(BUTTON[BUTTON_UP]==1){
                    SelectAnotherRow(1); 
                    }
                    else if(BUTTON[BUTTON_ENTER]==1){
                        if(SelectedRow==0){
                        Address[0] = 0;
                        }
                        else{
                        Address[1] = SelectedRow;
                        }
                    SelectedRow = 0;
                    Address[5] = 0;
                    }
                    
                    if(RefreshLcd>=1){
                    unsigned char row, lcd_row;
                    lcd_row = 0;
                    RowsOnWindow = 7;
                        for(row=Address[5];row<4+Address[5];row++){
                        lcd_gotoxy(0,lcd_row);
                            if(row==0){                              
                            lcd_putsf("   -=NUSTATYMAI=-   "); 
                            }
                            else if(row==1){
                            lcd_putsf("1.EKRANO APSVIETIM.");
                            }
                            else if(row==2){
                            lcd_putsf("2.VALYTI SKAMBEJIM.");
                            }
                            else if(row==3){
                            lcd_putsf("3.VASAROS LAIKAS");
                            }
                            else if(row==4){
                            lcd_putsf("4.LAIKO TIKSLINIMAS");
                            }
                            else if(row==5){
                            lcd_putsf("5.VALDIKLIO KODAS");
                            }
                            else if(row==6){
                            lcd_putsf("6.VALDIKLIO ISVADAI");
                            }
                        lcd_row++;
                        }
                    lcd_gotoxy(19,SelectedRow-Address[5]);
                    lcd_putchar('<');                     
                    }
                }
                else if(Address[1]==1){
                    if(BUTTON[BUTTON_DOWN]==1){
                        if(lcd_light>0){
                        lcd_light += -1;    
                        }  
                    }
                    else if(BUTTON[BUTTON_UP]==1){
                        if(lcd_light<100){
                        lcd_light += 1;    
                        } 
                    }
                    else if(BUTTON[BUTTON_ENTER]==1){
                    Address[1] = 0;
                    SelectedRow = 0;
                    Address[5] = 0;
                    }
                    
                    if(RefreshLcd>=1){       
                    lcd_putsf("-=EKRANO APSVIET.=- ");
                    lcd_putsf("APSVIETIMAS:");
                    lcd_put_number(0,3,0,0,lcd_light,0); 
                    lcd_putchar('%'); 
                           
                    lcd_gotoxy(19,0);
                    lcd_putchar('+');
                    lcd_gotoxy(19,3);
                    lcd_putchar('-');                      
                    }  
                }
                else if(Address[1]==2){
                    if(Address[2]==0){
                        if(BUTTON[BUTTON_LEFT]==1){
                        Address[3] = 0;     
                        }
                        else if(BUTTON[BUTTON_RIGHT]==1){
                        Address[3] = 1;     
                        }
                        else if(BUTTON[BUTTON_ENTER]==1){
                            if(Address[3]==0){
                            Address[1] = 0;
                            }
                            else{
                            Address[2] = 1;
                            }
                        Address[3] = 0;
                        Address[4] = 0;
                        SelectedRow = 0;
                        Address[5] = 0;
                        }
                        
                        if(RefreshLcd>=1){
                        lcd_putsf("       VALYTI       ");
                        lcd_putsf("    SKAMBEJIMUS?    ");
                        lcd_putsf("     NE     TAIP    ");
                            if(Address[3]==0){
                            lcd_putsf("     ^^            <");
                            }
                            else{
                            lcd_putsf("            ^^^^   <");
                            }                     
                        }
                         
                    }
                    else{                        
                        if(Address[4]>=3){
                        Address[4] = 0;
                        Address[3]++;
                            if(Address[3]>=BELL_COUNT){
                            Address[3] = 0;
                            Address[2]++;
                                if(Address[2]>BELL_TYPE_COUNT){
                                Address[1] = 0; 
                                Address[2] = 0;
                                 
                                SelectedRow = 0;
                                Address[5] = 0;
                                }
                            } 
                        }
                        
                        if(RefreshLcd>=1){
                        lcd_clear(); 
                        lcd_gotoxy(0,1);
                        lcd_putsf("TRINAMI SKAMBEJIMAI:");
                        lcd_gotoxy(4,2);
                        lcd_putsf("B / ");
                        lcd_put_number(0,4,0,0,(BELL_TYPE_COUNT-1)*BELL_COUNT*3+(BELL_COUNT-1)*3+3,0);
                        lcd_putsf("B");
                        }
                        
                        if(Address[2]>0){
                        unsigned int number;
                        BELL_TIME[Address[2]-1][Address[3]][Address[4]] = 0;
                        number = (Address[2]-1)*BELL_COUNT*3 + Address[3]+Address[3]+Address[3] + Address[4] + 1;
                        lcd_gotoxy(0,2);
                        lcd_put_number(0,4,0,0,number,0);
                        Address[4]++;
                        }                        
                    }
                }
                else if(Address[1]==3){
                    if(BUTTON[BUTTON_DOWN]==1){
                        if(Address[2]==0){ 
                        Address[2] = 1;    
                        }  
                    }
                    else if(BUTTON[BUTTON_UP]==1){
                        if(Address[2]!=0){ 
                        Address[2] = 0;    
                        } 
                    }
                    else if(BUTTON[BUTTON_ENTER]==1){
                        if(Address[2]==0){ 
                        Address[1] = 0;
                        SelectedRow = 0;
                        Address[5] = 0;    
                        }
                        else{
                            if(SUMMER_TIME_TURNED_ON==0){
                            SUMMER_TIME_TURNED_ON = 1;
                            IS_CLOCK_SUMMER = IsSummerTime(RealTimeMonth, RealTimeDay, RealTimeWeekDay);
                            }
                            else{
                            SUMMER_TIME_TURNED_ON = 0;
                            }
                        }
                    }
                    
                    if(RefreshLcd>=1){       
                    lcd_putsf(" -=VASAROS LAIKAS=- ");
                    lcd_putsf("PADETIS: ");
                        if(SUMMER_TIME_TURNED_ON==0){
                        lcd_putsf("ISJUNGTAS");
                        }
                        else{
                        lcd_putsf("IJUNGTAS");
                        } 
                        
                        if(Address[2]==0){                            
                        lcd_gotoxy(19,0);
                        lcd_putchar('<');
                        }
                        else{
                        lcd_gotoxy(19,1);
                        lcd_putchar('<');
                        }                      
                    } 
                }
                else if(Address[1]==4){
                    if(BUTTON[BUTTON_DOWN]==1){
                        if(RealTimePrecisioningValue>-20){
                        RealTimePrecisioningValue--;
                        }
                        else{
                        RealTimePrecisioningValue = -20;
                        }      
                    }
                    else if(BUTTON[BUTTON_UP]==1){
                        if(RealTimePrecisioningValue<20){
                        RealTimePrecisioningValue++;
                        }
                        else{
                        RealTimePrecisioningValue = 20;
                        }     
                    }
                    else if(BUTTON[BUTTON_ENTER]==1){
                    Address[1] = 0; 
                    SelectedRow = 0;
                    Address[5] = 0;
                    }

                    if(RefreshLcd>=1){       
                    lcd_putsf("  -=TIKSLINIMAS=-  +");
                    lcd_putsf("LAIKO TIKSLINIMAS   ");
                    lcd_putsf("SEKUNDEMIS PER      ");
                    lcd_putsf("SAVAITE: ");
                    lcd_put_number(1,2,1,0,0,RealTimePrecisioningValue); 
                    lcd_putsf(" SEC.  -");                          
                    }
                }
                else if(Address[1]==5){
                    if(BUTTON[BUTTON_LEFT]==1){
                        if(Address[2]>1){
                        Address[2]--;
                        }
                    }
                    else if(BUTTON[BUTTON_RIGHT]==1){
                        if(Address[2]<4){   
                        Address[2]++;
                        }
                    }
                    else if(BUTTON[BUTTON_DOWN]==1){
                        if(Address[2]==0){
                        SelectAnotherRow(0);
                            if(SelectedRow==2){
                            SelectAnotherRow(0);
                            }
                        }
                        else if(Address[2]==1){
                            if(entering_code>=1000){
                            entering_code += -1000;    
                            } 
                        }
                        else if(Address[2]==2){
                        unsigned int a;
                        a = entering_code - ((entering_code/1000) * 1000);
                            if(a>=100){
                            entering_code += -100;    
                            } 
                        }
                        else if(Address[2]==3){
                        unsigned int a;
                        a = entering_code - ((entering_code/100) * 100);
                            if(a>=10){
                            entering_code += -10;    
                            } 
                        }
                        else if(Address[2]==4){
                        unsigned int a;
                        a = entering_code - ((entering_code/10) * 10);
                            if(a>=1){
                            entering_code += -1;    
                            } 
                        } 
                    }
                    else if(BUTTON[BUTTON_UP]==1){
                        if(Address[2]==0){
                        SelectAnotherRow(1);
                            if(SelectedRow==2){
                            SelectAnotherRow(1);
                            }
                        }
                        else if(Address[2]==1){
                            if(entering_code<9000){
                            entering_code += 1000;    
                            } 
                        }
                        else if(Address[2]==2){
                        unsigned int a;
                        a = entering_code - ((entering_code/1000) * 1000);
                            if(a<900){
                            entering_code += 100;    
                            } 
                        }
                        else if(Address[2]==3){
                        unsigned char a;
                        a = entering_code - ((entering_code/1000) * 1000);
                        a = a - ((a/100) * 100);
                            if(a<90){
                            entering_code += 10;    
                            } 
                        }
                        else if(Address[2]==4){
                        unsigned char a;
                        a = entering_code - ((entering_code/1000) * 1000);
                        a = a - ((a/100) * 100);
                        a = a - ((a/10) * 10);
                            if(a<9){
                            entering_code += 1;    
                            } 
                        } 
                    }
                    else if(BUTTON[BUTTON_ENTER]==1){
                        if(SelectedRow==0){
                        Address[1] = 0; 
                        SelectedRow = 0;
                        Address[5] = 0;
                        }
                        else if(SelectedRow==1){
                            if(IS_LOCK_TURNED_ON==1){
                            IS_LOCK_TURNED_ON = 0;
                            CODE = 0;
                            }
                            else{
                            IS_LOCK_TURNED_ON = 1;
                            CODE = 0;
                            UNLOCKED = 1; 
                            }
                        SelectedRow = 0;
                        Address[5] = 0; 
                        }
                        else if(SelectedRow==3){
                            if(Address[2]==0){
                            Address[2] = 1;
                            }
                            else{
                            Address[2] = 0;
                            CODE = entering_code;
                            UNLOCKED = 1;
                                
                            SelectedRow = 0;
                            Address[5] = 0;
                            }
                        entering_code = 0; 
                        }
                    }             

                    if(RefreshLcd>=1){
                    lcd_putsf("     -=KODAS=-      ");
                        if(IS_LOCK_TURNED_ON==1){
                        RowsOnWindow = 4;
                        lcd_putsf("1.ISJUNGTI KODA?    ");
                        lcd_putsf("2.KODAS:     ");     
                            if(Address[2]==0){
                            lcd_putsf("****   ");    
                            lcd_putsf("         REDAGUOTI?");
                            }
                            else{
                            unsigned int i;
                            lcd_gotoxy(13,2); 
                            i = entering_code;
                                if(Address[2]==1){
                                lcd_putchar( NumToIndex( i/1000) );
                                }
                                else{
                                lcd_putchar('*');
                                }
                            i = i - (i/1000)*1000;            
                                if(Address[2]==2){
                                lcd_putchar( NumToIndex( i/100) );
                                }
                                else{
                                lcd_putchar('*');
                                }
                            i = i - (i/100)*100;            
                                if(Address[2]==3){
                                lcd_putchar( NumToIndex( i/10) );
                                }
                                else{
                                lcd_putchar('*');
                                }
                            i = i - (i/10)*10;            
                                if(Address[2]==4){
                                lcd_putchar( NumToIndex(i) );
                                }
                                else{
                                lcd_putchar('*');
                                }
                            lcd_gotoxy(0,3);
                                if(Address[2]==1){
                                lcd_putsf("             ^"); 
                                }
                                else if(Address[2]==2){
                                lcd_putsf("              ^"); 
                                }
                                else if(Address[2]==3){
                                lcd_putsf("               ^"); 
                                }
                                else if(Address[2]==4){
                                lcd_putsf("                ^"); 
                                }
                            } 
                        }
                        else{
                        RowsOnWindow = 2;
                        lcd_putsf("1. IJUNGTI KODA?");
                        }
                    lcd_gotoxy(19,SelectedRow-Address[5]);
                    lcd_putchar('<');                         
                    }
                }
                else if(Address[1]==6){
                    if(BUTTON[BUTTON_DOWN]==1){
                        if(BELL_OUTPUT_ADDRESS>17){
                        BELL_OUTPUT_ADDRESS--;
                        } 
                    }
                    else if(BUTTON[BUTTON_UP]==1){
                        if(BELL_OUTPUT_ADDRESS<22){
                        BELL_OUTPUT_ADDRESS++;
                        }
                    }
                    else if(BUTTON[BUTTON_ENTER]==1){
                    Address[1] = 0;
                    SelectedRow = 0;
                    Address[5] = 0;
                    } 
                 
                    if(RefreshLcd>=1){
                    lcd_putsf("    -=ISVADAI=-    +");
                    lcd_putsf("1. VARPU ISEJ.: ");
                    lcd_put_number(0,2,0,0,BELL_OUTPUT_ADDRESS,0);
                    lcd_putsf(" <");
                    lcd_gotoxy(19,3);lcd_putchar('-');
                    }                                                   
                }
            }
        }
                    
        if(RefreshLcd>=1){    
        RefreshLcd--;
        } 
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////    
    TimeRefreshed = 0;
    delay_ms(1);
    }
}