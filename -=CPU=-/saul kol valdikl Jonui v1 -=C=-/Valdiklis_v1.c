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
#include <string.h>
#include <ff.h>
#include <sdcard.h>

// Alphanumeric LCD Module functions portc
#include <lcd.h>
#asm                    
   .equ __lcd_port=0x15 
#endasm

//////// Mygtuku Aprasimas ////////
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
///////////////////////////////////


// PINS
#define LCD_LED PORTA.7

#define BUTTON_INPUT1 PIND.6 
#define BUTTON_INPUT2 PIND.5 
#define BUTTON_INPUT3 PIND.4 
#define BUTTON_INPUT4 PIND.3 
#define BUTTON_INPUT5 PIND.2

#define TERMOSWITCH_INPUT PIND.7

#define WATER_PUMP PORTB.0
#define ANTIFREEZE_PUMP PORTB.1

#define TEMPERATURE_BOIL PORTA.1
#define TEMPERATURE_S_INP PORTA.2
#define TEMPERATURE_S_OUT PORTA.3












#define ButtonFiltrationTimer 20 // x*cycle (cycle~1ms) 
///////////////////////////////////////////////////////////////////////////////////
////////////////////////// VARIABLES //////////////////////////////////////////////
// Real Time
eeprom unsigned int RealTimeYear; 
eeprom signed char RealTimeMonth, RealTimeDay, RealTimeHour, RealTimeMinute;
eeprom unsigned char RealTimeSecond; 


// Logs     
#define LOG_COUNT 90
eeprom unsigned char NewestLog;

eeprom unsigned int  LogYear[LOG_COUNT];
eeprom unsigned char LogMonth[LOG_COUNT];
eeprom unsigned char LogDay[LOG_COUNT];
eeprom unsigned char LogHour[LOG_COUNT];
eeprom unsigned char LogMinute[LOG_COUNT];

eeprom unsigned char LogType[LOG_COUNT];

eeprom signed int LogData1[LOG_COUNT];
eeprom signed int LogData2[LOG_COUNT];

// Lcd Address
signed int Address[3];
char RefreshLcd;


// Solar Colector Parameters
#define MAX_DIFFERENCE_SOLAR_BOILER 250
#define DEFAULT_DIFFERENCE_SOLAR_BOILER 100
#define MIN_DIFFERENCE_SOLAR_BOILER 50
#define DEFAULT_WATER_FLOW 20



signed int LAST_SOLAR_INPUT_TEMP, LAST_SOLAR_OUTPUT_TEMP;
signed int BOILER_TEMP, SOLAR_INPUT_TEMP, SOLAR_OUTPUT_TEMP;
eeprom signed int LitersPerMinute;
eeprom unsigned long int SolarColectorWattHours;
eeprom unsigned long int WattHoursPerDay;
eeprom signed int MinimumAntifreezeTemp;
eeprom signed int DifferenceBoilerAndSolar;



eeprom signed int MaxDayTemperature;
            
char Acceleration;

char PAGRINDINIS_LANGAS;
char Call_1Second;
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
#define ADC_VREF_TYPE 0x40
// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input){
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
///////////////////////////////////////////////////////////////////////////////////
////////////////////////////// FUNCTIONS //////////////////////////////////////////
signed int GetTemperature(void){
signed int input = read_adc(0);
signed int Temperature;// -20.7C ~ 179.3C

input = input - 166;
Temperature = input*2 - 207;
Temperature = Temperature + input/3;
     
return Temperature;
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
    else if(Num==10){return 'a';}
    else if(Num==11){return 'b';} 
    else if(Num==12){return 'c';}
    else if(Num==13){return 'd';} 
    else if(Num==14){return 'e';} 
    else if(Num==15){return 'f';}
    else{           return '-';}
return 0;
}

char IndexToNum(char Index){
    if(Index=='0'){     return 0;}
    else if(Index=='1'){return 1;}
    else if(Index=='2'){return 2;}
    else if(Index=='3'){return 3;}
    else if(Index=='4'){return 4;}
    else if(Index=='5'){return 5;}
    else if(Index=='6'){return 6;}
    else if(Index=='7'){return 7;} 
    else if(Index=='8'){return 8;}
    else if(Index=='9'){return 9;}
    else if(Index=='a'){return 10;}
    else if(Index=='b'){return 11;} 
    else if(Index=='c'){return 12;}
    else if(Index=='d'){return 13;} 
    else if(Index=='e'){return 14;} 
    else if(Index=='f'){return 15;}
    else{               return 16;}
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

void MakeValidRealTimeDate(){
    if(RealTimeYear<2011){
    RealTimeYear = 2011;
    }
    else if(RealTimeYear>9999){
    RealTimeYear = 2011;
    }

    if(RealTimeMonth>12){
    RealTimeMonth = 12;
    }
    else if(RealTimeMonth<1){
    RealTimeMonth = 1;
    }
    
    if(RealTimeDay>DayCountInMonth(RealTimeYear, RealTimeMonth)){
    RealTimeDay = DayCountInMonth(RealTimeYear, RealTimeMonth);      
    }
    else if(RealTimeDay<1){
    RealTimeDay = 1;
    }
}

unsigned int WhatIsTheCode(){
return (RealTimeYear-2000)*RealTimeMonth*RealTimeDay;
}

char GetOldestLogID(void){
    if(NewestLog==0){
    return LOG_COUNT-1;
    }
return NewestLog-1;
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
                                            
                            char flash *str){
signed int i,a;
unsigned int StrLenght = strlenf(str);                            
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
_lcd_ready();
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

/*
flash char * flash error_msg[]={
"",
"FR_DISK_ERR",
"FR_INT_ERR",
"FR_INT_ERR",
"FR_NOT_READY",
"FR_NO_FILE",
"FR_NO_PATH",
"FR_INVALID_NAME",
"FR_DENIED",
"FR_EXIST",
"FR_INVALID_OBJECT",
"FR_WRITE_PROTECTED",
"FR_INVALID_DRIVE",
"FR_NOT_ENABLED",
"FR_NO_FILESYSTEM",
"FR_MKFS_ABORTED",
"FR_TIMEOUT"
};
*/

/*
void error(FRESULT res){
    if((res>=FR_DISK_ERR) && (res<=FR_TIMEOUT)){
    lcd_clear();    
    lcd_puts("FS ERROR:");
    lcd_putsf(error_msg[res]);
    delay_ms(1000);
    }
}
*/

static unsigned char DataToSent[200];
static unsigned char ReceivedData[200];
void SendMBus(){
unsigned int lenght;
unsigned char i,a,b;
char character_bits[8];
char character;
lenght = strlen(DataToSent);
DDRA.4 = 1;
    for(i=0;i<lenght;i++){
    character = DataToSent[i];
    b = 128;
     
    PORTA.4 = 1; 
         
        for(a=7;a>=0;a--){
            if(character>=b){
            character_bits[a] = 1;
            }
            else{
            character_bits[a] = 0;
            }
        b = b/2;
        }  
     
        for(a=0;a<8;a++){
            if(character_bits[a]==1){
            PORTA.4 = 1;
            }
            else{
            PORTA.4 = 0;
            }         
        }
        
    PORTA.4 = 1;
    delay_us(100);    
    PORTA.4 = 0;                 
    }
DDRA.4 = 0;
}

void GetMBus(void){
unsigned int i,a,character,b;
    for(i=0;i<200;i++){
        while(PINA.4==0);
        while(PINA.4==1);
    character = 0;    
    b = 1;    
        for(a=0;a<8;a++){                 
            if(PINA.4==1){
            character = character + b;
            }
        b = b*2;
        delay_us(100);    
        }
        
        while(PINA.4==1); 
        while(PINA.4==0);    
    }
}
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void){
static signed int InteruptTimer, MissTimer;
InteruptTimer++;
/////////////////////////// 1 Second Callback ///////////////////////////////////////
    if(InteruptTimer>=495){// Periodas
    Call_1Second++;
    InteruptTimer = 0;
    MissTimer++;
        if(MissTimer>=1000){
        InteruptTimer = 50;// -(Tukstantosios periodo dalys)
        MissTimer = 0;        
        } 
    }
/////////////////////////////////////////////////////////////////////////////////////
static unsigned int RefreshTimer;       
RefreshTimer++;    
    if(RefreshTimer>=20){
    RefreshTimer = 0; 
    RefreshLcd = 1;
    }
    
static unsigned char MemoryTimer;
MemoryTimer++;
    if(MemoryTimer>=5){     
    disk_timerproc();
    MemoryTimer = 0;
    }
     
} 

//FILINFO file_info;


void main(void){
// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0 
PORTA=0x00;
DDRA=0b10001110;

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

// ADC initialization
// ADC Clock frequency: 62.500 kHz
// ADC Voltage Reference: Int., cap. on AREF
// ADC Auto Trigger Source: Free Running
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0xA7;
SFIOR&=0x1F; 

// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("sei")











// Uzfiksuoti kada buvo issijunges valdiklis
    if(LogType[GetOldestLogID()]==99){             
    LogType[GetOldestLogID()] = 3;
    NewestLog = GetOldestLogID();
    }

    if((LitersPerMinute>=100)||(LitersPerMinute<=0)){
    LitersPerMinute = DEFAULT_WATER_FLOW;
    }
    
    
MinimumAntifreezeTemp = 350;

    if((DifferenceBoilerAndSolar<MIN_DIFFERENCE_SOLAR_BOILER)||
    (DifferenceBoilerAndSolar>MAX_DIFFERENCE_SOLAR_BOILER)){
    DifferenceBoilerAndSolar = DEFAULT_DIFFERENCE_SOLAR_BOILER;
    }
    
    if((MaxDayTemperature<=-1000)||
    (MaxDayTemperature>=1000)){
    MaxDayTemperature = 0;
    }
          
    if(WattHoursPerDay==4294967295){
    WattHoursPerDay = 0;
    }

    if(SolarColectorWattHours==4294967295){
    SolarColectorWattHours = 0;   
    }

    if((RealTimeHour<0)||(RealTimeHour>=24)||
    (RealTimeMinute<0)||(RealTimeMinute>=60)){
    RealTimeHour = 0;
    RealTimeMinute = 0;
    }

    
MakeValidRealTimeDate();

LCD_LED = 1;

// Hello
lcd_clear();
lcd_puts("SAULES KOLEKTOR.");
lcd_puts("VALDIKLIS V1.0  ");
delay_ms(1000);




/*
// FAT function result 
static FRESULT res;
// will hold the information for logical drive 0:
static FATFS fat;
// pointer to the FATFS type structure 
static FATFS *pfat;
// number of free clusters on logical drive 0:
static unsigned long free_clusters;
// number of free kbytes on logical drive 0: 
static unsigned long free_kbytes;
// root directory path for logical drive 0: 
static char root_path[]="0:/";
*/



// point to the FATFS structure that holds
//information for the logical drive 0: 
//pfat=&fat;

/*
// mount logical drive 0: 
lcd_clear();
if ((res=f_mount(0,pfat))==FR_OK)
   lcd_puts("Logical drive 0:Mounted OK");
else
   // an error occured, display it and stop 
   error(res);
delay_ms(2000);
*/

/*
lcd_clear();
static unsigned char disk_status;
disk_status = disk_initialize(0);
    if(disk_status & STA_NOINIT) lcd_puts("Disk init failed");
    else if(disk_status & STA_NODISK) lcd_puts("Card not present");
    else if(disk_status & STA_PROTECT) lcd_puts("Card write\nprotected");
    else lcd_puts("Init OK");
delay_ms(2000);
*/





/*
lcd_clear();
    if((res=f_getfree(root_path,&free_clusters,&pfat))==FR_OK){
    free_kbytes=free_clusters 
    pfat->csize/2; 
    lcd_puts("Free space:     ");
    lcd_put_number(0,6,0,0,free_kbytes,0);
    lcd_puts("kB");
    }
    else
    error(res);

delay_ms(3000);
*/



   
    while(1){
    //////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////// TERMODAVIKLIAI ////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////     
    static unsigned char TERMOSWICH;
        if(TERMOSWITCH_INPUT==1){
            if(TERMOSWICH==0){
            TERMOSWICH = 1;
            Address[0] = 4;
            Address[1] = 0;
            Address[2] = 0;
            ANTIFREEZE_PUMP = 1;
            WATER_PUMP = 1;
            Acceleration = 5;
            }
        }
        else{
        TERMOSWICH = 0;
        }
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////     


                 
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
                    MaxDayTemperature = SOLAR_OUTPUT_TEMP;
                    WattHoursPerDay = 0;
                     
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



    //////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////// Temperaturu Gavimas////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////    
        if(Called_1Second==1){
        static signed char SolarColectorState=-1;
            if(SolarColectorState==-1){
            TEMPERATURE_BOIL = 1;
            TEMPERATURE_S_INP = 0;
            TEMPERATURE_S_OUT = 0;   
            }
            else if(SolarColectorState==10){
            BOILER_TEMP = GetTemperature();
                if(BOILER_TEMP>999){
                BOILER_TEMP = 999;
                }
                else if(BOILER_TEMP<-999){
                BOILER_TEMP = -999;
                }

            TEMPERATURE_BOIL = 0;
            TEMPERATURE_S_INP = 1;
            TEMPERATURE_S_OUT = 0;           
            }
            else if(SolarColectorState==20){
            LAST_SOLAR_INPUT_TEMP = SOLAR_INPUT_TEMP;
            SOLAR_INPUT_TEMP = GetTemperature();
                if(SOLAR_INPUT_TEMP>999){
                SOLAR_INPUT_TEMP = 999;
                }
                else if(SOLAR_INPUT_TEMP<-999){
                SOLAR_INPUT_TEMP = -999;
                }

                if(MaxDayTemperature<SOLAR_INPUT_TEMP){
                MaxDayTemperature = SOLAR_INPUT_TEMP;
                }
                
            TEMPERATURE_BOIL = 0;
            TEMPERATURE_S_INP = 0;
            TEMPERATURE_S_OUT = 1;
            }
            else if(SolarColectorState==30){
            SolarColectorState = 0;

            LAST_SOLAR_OUTPUT_TEMP = SOLAR_OUTPUT_TEMP;
            SOLAR_OUTPUT_TEMP = GetTemperature();
                if(SOLAR_OUTPUT_TEMP>999){
                SOLAR_OUTPUT_TEMP = 999;
                }
                else if(SOLAR_OUTPUT_TEMP<-999){
                SOLAR_OUTPUT_TEMP = -999;
                }
                
                if(MaxDayTemperature<SOLAR_OUTPUT_TEMP){
                MaxDayTemperature = SOLAR_OUTPUT_TEMP;
                }                
                
            TEMPERATURE_BOIL = 1;
            TEMPERATURE_S_INP = 0;
            TEMPERATURE_S_OUT = 0;       
            }
        SolarColectorState++;
        }
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////        


                   
    //////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// Perjungti Siurblius ///////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
        if(Called_1Second==1){
                 
            if(SOLAR_OUTPUT_TEMP>LAST_SOLAR_OUTPUT_TEMP){
                if(Acceleration<5){
                Acceleration++;
                }
            }
            else{
                if(Acceleration>0){
                Acceleration--;
                }
            }
                                       
            if(SOLAR_OUTPUT_TEMP>DifferenceBoilerAndSolar+BOILER_TEMP){
            WATER_PUMP = 1;
            Acceleration = 5;
            }
            else{
            WATER_PUMP = 0;
            }

            if(Acceleration>=5){
                if(SOLAR_OUTPUT_TEMP>=MinimumAntifreezeTemp){
                ANTIFREEZE_PUMP = 1;
                }
                else{
                ANTIFREEZE_PUMP = 0;
                }
            }
            else if(Acceleration<=0){
            ANTIFREEZE_PUMP = 0;
            }

            if((SOLAR_OUTPUT_TEMP>=850)||(SOLAR_INPUT_TEMP>=850)){
            ANTIFREEZE_PUMP = 1;
            WATER_PUMP = 1;
            Acceleration = 5;
            }

            if(TERMOSWITCH_INPUT==1){
            ANTIFREEZE_PUMP = 1;
            WATER_PUMP = 1;
            Acceleration = 5;
            }                   
        }
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////



    //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////// Atlikto darbo ir galios apskaiciavimas /////////////////
    //////////////////////////////////////////////////////////////////////////////////        
        if(Called_1Second==1){
        static unsigned char CHECK_JOB_POWER;
        CHECK_JOB_POWER++;
            if(CHECK_JOB_POWER>=30){
            static signed int SolarPower;
            int InputTemperature = (LAST_SOLAR_INPUT_TEMP+SOLAR_INPUT_TEMP)/2;
            int OutputTemperature = (LAST_SOLAR_OUTPUT_TEMP+SOLAR_OUTPUT_TEMP)/2;
            int TemperatureDifference = OutputTemperature - InputTemperature;             
             
                               
                if(TemperatureDifference>0){
                    if(ANTIFREEZE_PUMP==1){
                    unsigned int Job;

                    Job = (LitersPerMinute*TemperatureDifference)/170;
                    SolarColectorWattHours += Job;
                    WattHoursPerDay += Job; 
                     
                      
                    SolarPower = ((LitersPerMinute*TemperatureDifference)/3)*2;                                        
                    }
                    else{
                    SolarPower = 0;
                    }
                }
                else{
                SolarPower = 0;
                }
                                
            CHECK_JOB_POWER = 0;    
            }  
        }
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////



    //////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////// Ivykiai //////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    static char LOGS_Termoswich; 
    // 95C Apsauga isijungiant    
        if(LOGS_Termoswich==0){
            if(TERMOSWITCH_INPUT==1){
            char id;
            id = GetOldestLogID();
            LOGS_Termoswich = 1;
             
            LogYear[id] = RealTimeYear;
            LogMonth[id] = RealTimeMonth;
            LogDay[id] = RealTimeDay;
            LogHour[id] = RealTimeHour;
            LogMinute[id] = RealTimeMinute;

            LogType[id] = 1;

            LogData1[id] = SOLAR_OUTPUT_TEMP/10;
            LogData2[id] = BOILER_TEMP/10;

            NewestLog = id;     
            }
        }    

    // 95C Apsauga issijungiant
        if(LOGS_Termoswich==1){
            if(TERMOSWITCH_INPUT==0){
            char id;
            id = GetOldestLogID();
            LOGS_Termoswich = 0;
             
            LogYear[id] = RealTimeYear;
            LogMonth[id] = RealTimeMonth;
            LogDay[id] = RealTimeDay;
            LogHour[id] = RealTimeHour;
            LogMinute[id] = RealTimeMinute;

            LogType[id] = 2;

            LogData1[id] = SOLAR_OUTPUT_TEMP/10;
            LogData2[id] = BOILER_TEMP/10;

            NewestLog = id;     
            }
        }

    // Atnaujinti issijungimo irasa
        if(Called_1Second==1){
        char id;
        id = GetOldestLogID();
        LOGS_Termoswich = 0;
             
        LogYear[id] = RealTimeYear;
        LogMonth[id] = RealTimeMonth;
        LogDay[id] = RealTimeDay;
        LogHour[id] = RealTimeHour;
        LogMinute[id] = RealTimeMinute;

        LogType[id] = 99;

        LogData1[id] = SOLAR_OUTPUT_TEMP/10;
        LogData2[id] = BOILER_TEMP/10;
        }    
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////


                                                          
    //////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////// Mygtukai /////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    static char BUTTON[5], ButtonFilter[5];
    static char DUAL_BUTTON[4], DualButtonFilter[4];              

    // 1 Mygtukas
        if(BUTTON_INPUT1==1){
        PAGRINDINIS_LANGAS = 0;
            if(DualButtonFilter[0]<ButtonFiltrationTimer){
                if(ButtonFilter[0]<ButtonFiltrationTimer){
                ButtonFilter[0]++;
                }
            }
        }
        else{
            if(ButtonFilter[0]>=ButtonFiltrationTimer){        
            BUTTON[0] = 1;
            RefreshLcd = 1;
            }
            else{
            BUTTON[0] = 0;
            }
        ButtonFilter[0] = 0; 
        }
         
    // 1 ir 2 Mygtukas    
        if((BUTTON_INPUT1==1)&&(BUTTON_INPUT2==1)){   
        ButtonFilter[0] = 0;
        ButtonFilter[1] = 0;
            if(DualButtonFilter[0]<ButtonFiltrationTimer){         
            DualButtonFilter[0]++;
            }
        }
        else if((BUTTON_INPUT1==0)&&(BUTTON_INPUT2==0)){
            if(DualButtonFilter[0]>=ButtonFiltrationTimer){
            DUAL_BUTTON[0] = 1;
            RefreshLcd = 1;
            }
            else{
            DUAL_BUTTON[0] = 0;
            }
        DualButtonFilter[0] = 0; 
        }
        
    // 2 Mygtukas
        if(BUTTON_INPUT2==1){
        PAGRINDINIS_LANGAS = 0;
            if(DualButtonFilter[0]<ButtonFiltrationTimer){
                if(ButtonFilter[1]<ButtonFiltrationTimer){
                ButtonFilter[1]++;
                }
            }
        }
        else{
            if(ButtonFilter[1]>=ButtonFiltrationTimer){        
            BUTTON[1] = 1;
            RefreshLcd = 1;
            }
            else{
            BUTTON[1] = 0;
            }
        ButtonFilter[1] = 0; 
        }

    // 2 ir 3 Mygtukas    
        if((BUTTON_INPUT2==1)&&(BUTTON_INPUT3==1)){   
        ButtonFilter[1] = 0;
        ButtonFilter[2] = 0;
            if(DualButtonFilter[1]<ButtonFiltrationTimer){         
            DualButtonFilter[1]++;
            }
        }
        else if((BUTTON_INPUT2==0)&&(BUTTON_INPUT3==0)){
            if(DualButtonFilter[1]>=ButtonFiltrationTimer){
            DUAL_BUTTON[1] = 1;
            RefreshLcd = 1;
            }
            else{
            DUAL_BUTTON[1] = 0;
            }
        DualButtonFilter[1] = 0; 
        }

    // 3 Mygtukas
        if(BUTTON_INPUT3==1){
        PAGRINDINIS_LANGAS = 0;
            if(ButtonFilter[2]<ButtonFiltrationTimer){
            ButtonFilter[2]++;
            }
        }
        else{
            if(ButtonFilter[2]>=ButtonFiltrationTimer){        
            BUTTON[2] = 1;
            RefreshLcd = 1;
            }
            else{
            BUTTON[2] = 0;
            }
        ButtonFilter[2] = 0; 
        } 

    // 3 ir 4 Mygtukas    
        if((BUTTON_INPUT3==1)&&(BUTTON_INPUT4==1)){   
        ButtonFilter[2] = 0;
        ButtonFilter[3] = 0;
            if(DualButtonFilter[2]<ButtonFiltrationTimer){         
            DualButtonFilter[2]++;
            }
        }
        else if((BUTTON_INPUT3==0)&&(BUTTON_INPUT4==0)){
            if(DualButtonFilter[2]>=ButtonFiltrationTimer){
            DUAL_BUTTON[2] = 1;
            RefreshLcd = 1;
            }
            else{
            DUAL_BUTTON[2] = 0;
            }
        DualButtonFilter[2] = 0; 
        }

    // 4 Mygtukas
        if(BUTTON_INPUT4==1){
        PAGRINDINIS_LANGAS = 0;
            if(ButtonFilter[3]<ButtonFiltrationTimer){
            ButtonFilter[3]++;
            }
        }
        else{
            if(ButtonFilter[3]>=ButtonFiltrationTimer){        
            BUTTON[3] = 1;
            RefreshLcd = 1;
            }
            else{
            BUTTON[3] = 0;
            }
        ButtonFilter[3] = 0; 
        }  

    // 4 ir 5 Mygtukas    
        if((BUTTON_INPUT4==1)&&(BUTTON_INPUT5==1)){   
        ButtonFilter[3] = 0;
        ButtonFilter[4] = 0;
            if(DualButtonFilter[3]<ButtonFiltrationTimer){         
            DualButtonFilter[3]++;
            }
        }
        else if((BUTTON_INPUT4==0)&&(BUTTON_INPUT5==0)){
            if(DualButtonFilter[3]>=ButtonFiltrationTimer){
            DUAL_BUTTON[3] = 1;
            RefreshLcd = 1;
            }
            else{
            DUAL_BUTTON[3] = 0;
            }
        DualButtonFilter[3] = 0; 
        }

    // 5 Mygtukas
        if(BUTTON_INPUT5==1){
        PAGRINDINIS_LANGAS = 0;
            if(ButtonFilter[4]<ButtonFiltrationTimer){
            ButtonFilter[4]++;
            }
        }
        else{
            if(ButtonFilter[4]>=ButtonFiltrationTimer){        
            BUTTON[4] = 1;
            RefreshLcd = 1;
            }
            else{
            BUTTON[4] = 0;
            }
        ButtonFilter[4] = 0; 
        }      

    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////     
                  
    //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////// LCD ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    // LCD LED
/*        if(PAGRINDINIS_LANGAS<15){
//            if(LCD_LED==0){
            LCD_LED = 1;
//            }
        }
        else{
//            if(LCD_LED==1){
            LCD_LED = 0;
//            }
        } */

    // Grazinti i pradini langa
        if(TERMOSWITCH_INPUT==1){
            if(PAGRINDINIS_LANGAS>=30){
            Address[0] = 4;
            Address[1] = 0;
            Address[2] = 0;     
            }
        }
        else{
            if(PAGRINDINIS_LANGAS>=120){
            Address[0] = 0;
            Address[1] = 0;
            Address[2] = 0;     
            }
        }
        
    // Pagrindiniame meniu vaikscioti kairen desinen
        if(Address[1]==0){// Jei y == 0, tai pagrindinis meniu
            if(Address[2]==0){

                if(DUAL_BUTTON[0]==1){
                    if(TERMOSWITCH_INPUT==0){
                    Address[0] = 0;
                    }
                    else{
                    Address[0] = 3;
                    }
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
        _lcd_ready();
        lcd_clear();
        _lcd_ready();
        }

    ///////////////////////////////////////////////////////////   
    // x.  y.  z.
    // 0. Kolektoriaus isejimo ir boilerio temperaturos
    // 1. Kolektoriaus isejimo ir iejimo temperaturos 
    // 2. Temperaturu skirtumo lentele
    // 3. Vandens srauto lentele          
    // 4. 95C Apsaugos lentele
    // 5. Momentines galios lentele
    // 6. Energijos skaitiklio lentele
    // 7. Energijos skaitiklis per viena diena
    // 8. Maksimali dienos temperatura
    // 9. Svarbiu ivykiu lentele     
    // 10. Datos lentele
    // 11. Laiko lentele
    // 12. Matuojama temperatura
    // 13. Atstatyti viska  
    ///////////////////////////////////////////////////////////   
                    
        
        if(CODE_IsEntering==0){
            if(Address[0]==0){
                if(Address[1]==0){
                    if(RefreshLcd==1){
                    // 1 Eilute
                    lcd_put_number(1,3,1,1,0,SOLAR_OUTPUT_TEMP);
                    lcd_putsf("C KOL.TEMP.");


                    // 2 Eilute
                    lcd_put_number(1,3,1,1,0,BOILER_TEMP);
                    lcd_putsf("C BOIL.TEMP"); 
                    }                                        
                }
            }
            else if(Address[0]==1){       
                if(Address[1]==0){
                    if(RefreshLcd==1){ 
                    // 1 Eilute
                    lcd_put_number(1,3,1,1,0,SOLAR_OUTPUT_TEMP);
                    lcd_putsf("C KOL.ISEJ.");

                    // 2 Eilute
                    lcd_put_number(1,3,1,1,0,SOLAR_INPUT_TEMP);
                    lcd_putsf("C KOL.IEJIM");
                    }
                }  
            }
            else if(Address[0]==2){
            /////////////////////////////////////////////////////////////////////
                if(RefreshLcd==1){   
                lcd_put_number(0,3,0,1,DifferenceBoilerAndSolar,0);
                lcd_putsf("C TEMP.SKIRT");
                }
                
                if(Address[1]==0){
                    if(RefreshLcd==1){                
                    lcd_putsf("    KEISTI?-->* ");
                    }
                        
                    if(BUTTON[4]==1){
                    Address[1] = 1;
                    }                            
                }
                
                
                ///// 1 Skirtumo skaicius /////
                else if(Address[1]==1){ 
                // Mygtuku aprasymas ir kursorius
                    if(RefreshLcd==1){
                        if(DifferenceBoilerAndSolar>MAX_DIFFERENCE_SOLAR_BOILER-100){
                        lcd_buttons(0,1,0,1,1, 0,0,0,0);
                        }
                        else if(DifferenceBoilerAndSolar<MIN_DIFFERENCE_SOLAR_BOILER+100){
                        lcd_buttons(0,1,1,0,1, 0,0,0,0);
                        }
                        else{
                        lcd_buttons(0,1,1,1,1, 0,0,0,0);
                        }             
                    lcd_cursor(0,0);
                    }
                ////////////

                     
                // Adreso valdymui    
                    if(BUTTON[1]==1){
                    Address[1]++; 
                    }
                //////////////////
                                 

                // Patvirtinti
                    if(BUTTON[4]==1){
                    Address[1] = 0;
                    }
                //////////////

                        
                // 1 Skirtumo skaiciaus keitimas
                    if(BUTTON[2]==1){
                        if(DifferenceBoilerAndSolar<=MAX_DIFFERENCE_SOLAR_BOILER-100){
                        DifferenceBoilerAndSolar = DifferenceBoilerAndSolar + 100;
                        }
                    }
                    else if(BUTTON[3]==1){
                        if(DifferenceBoilerAndSolar>=MIN_DIFFERENCE_SOLAR_BOILER+100){
                        DifferenceBoilerAndSolar = DifferenceBoilerAndSolar - 100;
                        }
                    }    
                ///////////////////    
                }
            ///////////////////////////////


            ///// 2 Skirtumo skaicius /////
                else if(Address[1]==2){ 
                // Mygtuku aprasymas ir kursorius
                    if(RefreshLcd==1){
                        if(DifferenceBoilerAndSolar>MAX_DIFFERENCE_SOLAR_BOILER-10){
                        lcd_buttons(1,1,0,1,1, 0,0,0,0);
                        }
                        else if(DifferenceBoilerAndSolar<MIN_DIFFERENCE_SOLAR_BOILER+10){
                        lcd_buttons(1,1,1,0,1, 0,0,0,0);
                        }
                        else{
                        lcd_buttons(1,1,1,1,1, 0,0,0,0);
                        }
                    lcd_cursor(1,0);
                    }
                ////////////
                     
                // Adreso valdymui
                    if(BUTTON[0]==1){
                    Address[1]--; 
                    }
                    else if(BUTTON[1]==1){
                    Address[1]++; 
                    }
                ////////////////// 

                        
                // Patvirtinti
                    if(BUTTON[4]==1){
                    Address[1] = 0;
                    }
                //////////////
                
                               
                // 2 Skirtumo skaiciaus keitimas
                    if(BUTTON[2]==1){
                        if(DifferenceBoilerAndSolar<=MAX_DIFFERENCE_SOLAR_BOILER-10){
                        DifferenceBoilerAndSolar = DifferenceBoilerAndSolar + 10;
                        }    
                    }
                    else if(BUTTON[3]==1){
                        if(DifferenceBoilerAndSolar>=MIN_DIFFERENCE_SOLAR_BOILER+10){
                        DifferenceBoilerAndSolar = DifferenceBoilerAndSolar - 10;
                        }
                    }
                ////////////////////                
                }
            ///////////////////////////////


            ///// 3 Skirtumo skaicius /////
                else if(Address[1]==3){ 
                // Mygtuku aprasymas ir kursorius
                    if(RefreshLcd==1){
                        if(DifferenceBoilerAndSolar>MAX_DIFFERENCE_SOLAR_BOILER-1){
                        lcd_buttons(1,0,0,1,1, 0,0,0,0);
                        }
                        else if(DifferenceBoilerAndSolar<MIN_DIFFERENCE_SOLAR_BOILER+1){
                        lcd_buttons(1,0,1,0,1, 0,0,0,0);
                        }
                        else{
                        lcd_buttons(1,0,1,1,1, 0,0,0,0);
                        }
                    lcd_cursor(3,0);
                    }
                ////////////  

                     
                // Adreso valdymui
                    if(BUTTON[0]==1){
                    Address[1]--;
                    }
                //////////////////

                        
                // Patvirtinti
                    if(BUTTON[4]==1){
                    Address[1] = 0;
                    }
                //////////////
                        
                // Skirtumo keitimas
                    if(BUTTON[2]==1){
                        if(DifferenceBoilerAndSolar<=MAX_DIFFERENCE_SOLAR_BOILER-1){
                        DifferenceBoilerAndSolar++;
                        }    
                    }
                    else if(BUTTON[3]==1){
                        if(DifferenceBoilerAndSolar>=MIN_DIFFERENCE_SOLAR_BOILER+1){
                        DifferenceBoilerAndSolar--;
                        }
                    }
                ////////////////////
                }       
            ///////////////////////////////                    
              
             
            /////////////////////////////////////////////////////////////////////   
            }
            else if(Address[0]==3){
            /////////////////////////////////////////////////////////////////////
            /*    if(RefreshLcd==1){
                lcd_put_number(0,2,0,1,LitersPerMinute,0);
                lcd_putsf(   "L/MIN SRAUTAS");
                }
                


                if(Address[1]==0){
                    if(RefreshLcd==1){
                    lcd_putsf("    KEISTI?-->* ");
                    }
                    
                    if(BUTTON[4]==1){
                    EnterCode(3,0,0,3,1,0);
                    } 
                }
                else if(Address[1]==1){


                // Mygtukai
                    if(LitersPerMinute>=90){ 
                    lcd_buttons(0,1,0,1,1, 0,0,0,0); 
                    }
                    else if(LitersPerMinute<=10){
                    lcd_buttons(0,1,1,0,1, 0,0,0,0);  
                    }
                    else{
                    lcd_buttons(0,1,1,1,1, 0,0,0,0); 
                    }
                ///////////
                 
                // Kursorius    
                lcd_cursor(0,0);         
                ////////////
                }
                else if(Address[1]==2){



                // Mygtukai
                    if(LitersPerMinute>=99){ 
                    lcd_buttons(1,0,0,1,1, 0,0,0,0); 
                    }
                    else if(LitersPerMinute<=1){
                    lcd_buttons(1,0,1,0,1, 0,0,0,0);   
                    }
                    else{
                    lcd_buttons(1,0,1,1,1, 0,0,0,0); 
                    }
                ///////////    
                    
                // Kursorius    
                lcd_cursor(2,0);
                //////////// 
                }*/






                if(Address[2]==0){
                    if(Address[1]==0){
                        if(BUTTON[4]==1){
                        EnterCode(3,0,0,3,0,1);
                        }
                    }  
                }
                else{
                    if(BUTTON[4]==1){
                    Address[1] = 0; 
                    Address[2] = 0;
                    }

                    if(BUTTON[0]==1){
                        if(Address[2]>1){
                        Address[2]--;
                        }
                    }
                    else if(BUTTON[1]==1){
                        if(Address[2]<2){
                        Address[2]++;
                        }
                    }
                    
                    if(BUTTON[2]==1){
                        if(Address[2]==1){
                            if(LitersPerMinute<90){
                            LitersPerMinute = LitersPerMinute + 10;
                            }
                        }
                        else if(Address[2]==2){
                            if(LitersPerMinute<99){
                            LitersPerMinute++;
                            }
                        }
                    }
                    else if(BUTTON[3]==1){
                        if(Address[2]==1){
                            if(LitersPerMinute>10){
                            LitersPerMinute = LitersPerMinute - 10;
                            }
                        }
                        else if(Address[2]==2){
                            if(LitersPerMinute>1){
                            LitersPerMinute--;
                            }
                        } 
                    }   
                }
               
                if(RefreshLcd==1){
                    if(Address[2]==0){
                        if(Address[1]==0){
                        lcd_put_number(0,2,0,1,LitersPerMinute,0);
                        lcd_putsf(   "L/MIN SRAUTAS");                
                        lcd_putsf("    KEISTI?-->* ");              
                        }
                    }
                    else{
                    lcd_put_number(0,2,0,1,LitersPerMinute,0);
                    lcd_putsf("L/MIN SRAUTAS");  
                           
                        if(Address[2]==1){
                        lcd_gotoxy(0,1);
                            if(LitersPerMinute>=90){ 
                            lcd_buttons(0,1,0,1,1, 0,0,0,0); 
                            }
                            else if(LitersPerMinute<=10){
                            lcd_buttons(0,1,1,0,1, 0,0,0,0);  
                            }
                            else{
                            lcd_buttons(0,1,1,1,1, 0,0,0,0); 
                            }
                            
                        }
                        else{
                        lcd_gotoxy(0,1);
                            if(LitersPerMinute>=99){ 
                            lcd_buttons(1,0,0,1,1, 0,0,0,0); 
                            }
                            else if(LitersPerMinute<=1){
                            lcd_buttons(1,0,1,0,1, 0,0,0,0);   
                            }
                            else{
                            lcd_buttons(1,0,1,1,1, 0,0,0,0); 
                            } 
                        }

                        if(Address[2]==1){
                        lcd_cursor(0,0);
                        }
                        else if(Address[2]==2){
                        lcd_cursor(2,0);
                        }
                    }
                }
            /////////////////////////////////////////////////////////////////////   
            }
            else if(Address[0]==4){
                if(RefreshLcd==1){
                    if(TERMOSWITCH_INPUT==0){    
                    lcd_putsf("  95C APSAUGA   ");
                    lcd_putsf("  NESUVEIKUSI   ");
                    }
                    else{
                    lcd_putsf("--SUVEIKE  95C--");
                    lcd_putsf("----APSAUGA-----");
                    } 
                }
            }
            else if(Address[0]==5){
                if(Address[1]==0){
                    if(RefreshLcd==1){                        
                        if(SolarPower>9999){
                        SolarPower = 9999;
                        }
                        else if(SolarPower<0){
                        SolarPower = 0;
                        }                                                           
                    lcd_put_number(0,4,0,0,SolarPower,0);      
                        lcd_putsf("W MOMENTINE ");
                    lcd_putsf("     GALIA      "); 
                    }
                }
            }
            else if(Address[0]==6){
                if(Address[1]==0){
                    if(RefreshLcd==1){
                    lcd_putsf("  ");
                    lcd_put_number(0,10,0,3,SolarColectorWattHours,0);      
                    lcd_putsf("kWh");
                    lcd_putsf("ENERG.SKAITIKLIS");
                    }
                }
            }
            else if(Address[0]==7){
                if(Address[1]==0){
                    if(RefreshLcd==1){
                    lcd_putsf("  ");
                    lcd_put_number(0,10,0,3,WattHoursPerDay,0);                         
                    lcd_putsf("kWh");
                    lcd_putsf("ENERG. PER DIENA");
                    }
                }
            }
            else if(Address[0]==8){//+
                if(Address[1]==0){
                    if(RefreshLcd==1){
                    lcd_putsf("MAKS.DIENOS.TEMP");
                    lcd_putsf("    ");
                    lcd_put_number(1,3,1,1,0,MaxDayTemperature);
                    lcd_putsf("C      ");  
                    }
                }
            }
            else if(Address[0]==9){

                if(Address[1]==0){
                    if(Address[2]==0){    
                        if(BUTTON[4]==1){
                        Address[1] = 1;
                        }
                    }
                }
                else{
                    if(Address[1]!=LOG_COUNT+1){
                        if(Address[2]==0){
                            
                            if(DUAL_BUTTON[0]==1){
                            Address[1] = 0;
                            }
                           
                            if(BUTTON[0]==1){
                                if(Address[1]>1){ 
                                Address[1]--;
                                }
                                else{
                                Address[1] = LOG_COUNT+1;
                                }
                            }
                            else if(BUTTON[1]==1){
                                if(Address[1]<LOG_COUNT+1){ 
                                Address[1]++;
                                }
                                else{
                                Address[1] = 1;
                                } 
                            }
                            
                            if(BUTTON[4]==1){
                            signed int a;
                            a = NewestLog + Address[1] - 1;
                                if(a>=LOG_COUNT){
                                a = a - LOG_COUNT;
                                }
                                if((LogType[a]>=1)&&(LogType[a]<=50)){
                                Address[2] = 1;
                                }
                            }
                                                
                        }
                        else{               
                            if(DUAL_BUTTON[0]==1){
                            Address[2] = 0;
                            }
                                    
                            if(BUTTON[4]==1){
                                if(Address[2]<4){
                                Address[2]++;
                                }
                                else{
                                Address[2] = 0;
                                }
                            }
                        }
                    }
                    else{
                        if(Address[2]==0){
                            if(DUAL_BUTTON[0]==1){
                            Address[1] = 0;
                            }
                        
                            if(BUTTON[0]==1){
                                if(Address[1]>1){ 
                                Address[1]--;
                                }
                                else{
                                Address[1] = 1;
                                }
                            }
                            else if(BUTTON[1]==1){
                                if(Address[1]<LOG_COUNT+1){ 
                                Address[1]++;
                                }
                                else{
                                Address[1] = 1;
                                } 
                            }

                            if(BUTTON[4]==1){ 
                            EnterCode(9,LOG_COUNT+1,0,9,LOG_COUNT+1,1);
                            }
                        }
                        else{
                        unsigned int i;
                        NewestLog = 0;
                        lcd_clear();
                        lcd_putsf("TRINAMA: 000%   ");
                        lcd_putsf("PALAUKITE...    "); 
                            for(i=0;i<LOG_COUNT;i++){
                            unsigned int a;

                            LogYear[i] = 0;
                            LogMonth[i] = 0;
                            LogDay[i] = 0;
                            LogHour[i] = 0;
                            LogMinute[i] = 0;

                            LogType[i] = 0;

                            LogData1[i] = 0;
                            LogData2[i] = 0;
                             
                            a = (i*100)/LOG_COUNT;
                            lcd_gotoxy(9,0);
                            lcd_put_number(0,3,0,0,a,0);                            
                            }    
                        Address[1] = 0;
                        Address[2] = 0;
                                 
                        lcd_clear(); 
                        lcd_putsf("    ISTRINTA    "); 
                        delay_ms(1000);    
                        }
                    }
                } 



                if(RefreshLcd==1){
                    if(Address[1]==0){
                    lcd_putsf("SVARBUS IVYKIAI:");
                    lcd_putsf("PERZIURETI?-->* ");
                    }
                    else{
                        if(Address[1]!=LOG_COUNT+1){
                        signed int a;
                        a = NewestLog + Address[1] - 1;
                            if(a>=LOG_COUNT){
                            a = a - LOG_COUNT;
                            }

                             
                            if(Address[1]>=10){
                            lcd_putchar(NumToIndex( Address[1]/10 ));
                            }
                            else{
                            lcd_putchar(' ');
                            }
                        lcd_putchar(NumToIndex(Address[1]-(Address[1]/10)*10) );
                        lcd_putchar('.');   

                            if(Address[2]==0){
                            char IvykisYra = 1;
                                if(LogType[a]==1){
                                lcd_putsf("SUVEIKE 95C  ");
                                }
                                else if(LogType[a]==2){
                                lcd_putsf("ATKRITO 95C  ");     
                                }
                                else if(LogType[a]==3){
                                lcd_putsf("DINGO ITAMPA ");     
                                }
                                else{
                                IvykisYra = 0;
                                lcd_putsf("NERA IVYKIO  ");
                                }

                                if(IvykisYra==1){   
                                lcd_buttons(1,1,0,0,1, 1,0,0,0);
                                }
                                else{
                                lcd_buttons(1,1,0,0,0, 1,0,0,0);   
                                }
                                    
                            }
                            else{
                            lcd_putchar(NumToIndex( Address[2] ));
                            lcd_putchar('.');
                            lcd_putchar(' ');
                                
                                if(Address[2]==1){
                                //11.1. 2011.07.31
                                //11.2. 02:37
                                //11.3. 95.3C S.K.
                                //11.4. 34.4C BOIL
                                //11.5.
                                lcd_put_number(0,4,0,0,LogYear[a],0);
                                lcd_putchar('.');
                                lcd_put_number(0,2,0,0,LogMonth[a],0);             
                                lcd_putchar('.');
                                lcd_put_number(0,2,0,0,LogDay[a],0);
                                }
                                else if(Address[2]==2){
                                lcd_putsf("  ");
                                lcd_put_number(0,2,0,0,LogHour[a],0);
                                lcd_putchar(':');
                                lcd_put_number(0,2,0,0,LogMinute[a],0);
                                lcd_putsf("   ");        
                                }
                                else if(Address[2]==3){
                                lcd_put_number(1,2,1,0,0,LogData1[a]);
                                lcd_putsf("C SAUL.");
                                }
                                else if(Address[2]==4){
                                lcd_put_number(1,2,1,0,0,LogData2[a]);
                                lcd_putsf("C BOIL.");
                                }
                            lcd_buttons(0,0,0,0,1, 1,0,0,0);           
                            }
                        }
                        else{
                            if(Address[2]==0){
                            lcd_putsf("TRINTI IRASUS?  ");
                            lcd_putsf(" <||>   TAIP=>*"); 
                            }
                        }             
                    }
                }
            }
            else if(Address[0]==10){//+

                if(Address[1]==0){         
                    if(BUTTON[4]==1){
                    Address[1] = 1;
                    }
                }
                else{
                    if(BUTTON[0]==1){ 
                    Address[1]--;
                        if(Address[1]<1){
                        Address[1] = 8;
                        }
                    }
                    else if(BUTTON[1]==1){
                    Address[1]++;
                        if(Address[1]>8){
                        Address[1] = 1;
                        }
                    }
                    
                    if(BUTTON[2]==1){
                        if(Address[1]==1){
                            if(RealTimeYear<9000){
                            RealTimeYear = RealTimeYear + 1000;  
                            }
                        }
                        else if(Address[1]==2){
                            if(RealTimeYear<9900){
                            RealTimeYear = RealTimeYear + 100; 
                            }
                        }
                        else if(Address[1]==3){
                            if(RealTimeYear<9990){
                            RealTimeYear = RealTimeYear + 10;
                            }
                        }
                        else if(Address[1]==4){
                            if(RealTimeYear<9999){
                            RealTimeYear = RealTimeYear + 1;
                            } 
                        }
                        else if(Address[1]==5){
                            if(RealTimeMonth<=2){
                            RealTimeMonth = RealTimeMonth + 10;
                            }
                        }
                        else if(Address[1]==6){
                            if(RealTimeMonth<12){
                            RealTimeMonth = RealTimeMonth + 1;
                            } 
                        }
                        else if(Address[1]==7){
                            if(RealTimeDay<=DayCountInMonth(RealTimeYear,RealTimeMonth)-10){
                            RealTimeDay = RealTimeDay + 10;
                            } 
                        }
                        else if(Address[1]==8){
                            if(RealTimeDay<DayCountInMonth(RealTimeYear,RealTimeMonth)){
                            RealTimeDay = RealTimeDay + 1;
                            }  
                        }  
                    }
                    else if(BUTTON[3]==1){
                        if(Address[1]==1){
                            if(RealTimeYear>=3011){
                            RealTimeYear = RealTimeYear - 1000;
                            }
                        }
                        else if(Address[1]==2){
                            if(RealTimeYear>=2111){
                            RealTimeYear = RealTimeYear - 100;
                            }
                        }
                        else if(Address[1]==3){
                            if(RealTimeYear>=2021){
                            RealTimeYear = RealTimeYear - 10;
                            }
                        }
                        else if(Address[1]==4){
                            if(RealTimeYear>2011){
                            RealTimeYear = RealTimeYear - 1;
                            } 
                        }
                        else if(Address[1]==5){
                            if(RealTimeMonth>10){
                            RealTimeMonth = RealTimeMonth - 10;
                            }
                        }
                        else if(Address[1]==6){
                            if(RealTimeMonth>1){
                            RealTimeMonth = RealTimeMonth - 1;
                            } 
                        }
                        else if(Address[1]==7){
                            if(RealTimeDay>10){
                            RealTimeDay = RealTimeDay - 10;
                            } 
                        }
                        else if(Address[1]==8){
                            if(RealTimeDay>1){
                            RealTimeDay = RealTimeDay - 1;
                            }  
                        } 
                    }

                    if(BUTTON[4]==1){
                    Address[1] = 0;
                    }  
                }
                                     
                if(RefreshLcd==1){
                MakeValidRealTimeDate();
                 
                lcd_putsf("DATA: ");
                lcd_put_number(0,4,0,0,RealTimeYear,0);                
                lcd_putchar('.');                  
                lcd_put_number(0,2,0,0,RealTimeMonth,0);             
                lcd_putchar('.');
                lcd_put_number(0,2,0,0,RealTimeDay,0);
                 
                    if(Address[1]==0){
                    lcd_putsf("NUSTATYTI? -->* ");
                    }
                    else{
                    lcd_buttons(1,1,1,1,1,0,0,0,0);
                        if(Address[1]==1){
                        lcd_cursor(6,0); 
                        }
                        else if(Address[1]==2){
                        lcd_cursor(7,0); 
                        }
                        else if(Address[1]==3){
                        lcd_cursor(8,0); 
                        }
                        else if(Address[1]==4){
                        lcd_cursor(9,0); 
                        }
                        else if(Address[1]==5){
                        lcd_cursor(11,0);
                        }
                        else if(Address[1]==6){
                        lcd_cursor(12,0); 
                        }
                        else if(Address[1]==7){
                        lcd_cursor(14,0); 
                        }
                        else if(Address[1]==8){
                        lcd_cursor(15,0); 
                        } 
                    }
                }   
            }
            else if(Address[0]==11){//+

                if(Address[1]==0){ 
                    if(BUTTON[4]==1){
                    Address[1] = 1;
                    }
                }
                else{
                    if(BUTTON[0]==1){
                        if(Address[1]==1){
                        Address[1] = 4;
                        }
                        else{
                        Address[1]--;
                        }
                    }
                    else if(BUTTON[1]==1){
                        if(Address[1]==4){
                        Address[1] = 1;
                        }
                        else{
                        Address[1]++;
                        }
                    }
                     
                    if(BUTTON[2]==1){
                        if(Address[1]==1){
                            if(RealTimeHour<=13){
                            RealTimeHour = RealTimeHour + 10;
                            }
                        }
                        else if(Address[1]==2){
                            if(RealTimeHour<23){
                            RealTimeHour++;
                            }      
                        }
                        else if(Address[1]==3){
                            if(RealTimeMinute<50){
                            RealTimeMinute = RealTimeMinute + 10;
                            }     
                        }
                        else if(Address[1]==4){
                            if(RealTimeMinute<59){
                            RealTimeMinute++;
                            }
                        } 
                    }                
                    else if(BUTTON[3]==1){
                        if(Address[1]==1){
                            if(RealTimeHour>=10){
                            RealTimeHour = RealTimeHour - 10;
                            }   
                        }
                        else if(Address[1]==2){
                            if(RealTimeHour>=1){
                            RealTimeHour--;
                            } 
                        }
                        else if(Address[1]==3){
                            if(RealTimeMinute>=10){
                            RealTimeMinute = RealTimeMinute - 10;
                            }    
                        }
                        else if(Address[1]==4){
                            if(RealTimeMinute>=1){
                            RealTimeMinute--;
                            } 
                        }  
                    }
                 
                    if(BUTTON[4]==1){
                    Address[1] = 0;
                    }
                 
                }

                if(RefreshLcd==1){
                lcd_putsf("LAIKAS: ");
                lcd_put_number(0,2,0,0,RealTimeHour,0);
                lcd_putchar(':');
                lcd_put_number(0,2,0,0,RealTimeMinute,0);
                              
                    if(Address[1]==0){
                    lcd_putchar(':');
                    lcd_put_number(0,2,0,0,RealTimeSecond,0);
                    lcd_putsf("NUSTATYTI? -->* ");
                    }
                    else{
                    RealTimeSecond = 0;
                    lcd_putsf("   ");
                    lcd_buttons(1,1,1,1,1, 0,0,0,0);
                        if(Address[1]==1){
                        lcd_cursor(8,0);
                        }
                        else if(Address[1]==2){
                        lcd_cursor(9,0);
                        }
                        else if(Address[1]==3){
                        lcd_cursor(11,0);
                        }
                        else if(Address[1]==4){
                        lcd_cursor(12,0); 
                        }
                    }
                }
            }
            else if(Address[0]==12){
                if(RefreshLcd==1){
                    if(SolarColectorState/10==0){ 
                    lcd_putsf("MATUOJA: BOILER.");
                    }
                    else if(SolarColectorState/10==1){
                    lcd_putsf("MATUOJA: S.IEJI.");
                    }
                    else if(SolarColectorState/10==2){
                    lcd_putsf("MATUOJA: S.ISEJ.");
                    }
                    else{
                    lcd_putsf("MATUOJA: ------ ");
                    }
                    
                    
                lcd_putsf("TEMP:    ");
                lcd_put_number(1,3,1,1,0,GetTemperature());
                }
            }
            else if(Address[0]==13){             
                if(Address[1]==0){
                    if(RefreshLcd==1){
                    lcd_putsf("ATSTATYTI VISKA?");
                    lcd_putsf("        TAIP=>* ");     
                    }
                                
                    if(BUTTON[4]==1){
                    EnterCode(13,0,0,13,1,0); 
                    }                                
                }
                else{
                unsigned char i;
                NewestLog = 0;
                         
                lcd_clear();
                lcd_putsf("   ATSTATOMA    ");
                lcd_putsf("   PALAUKITE    ");

                RealTimeYear = 0;
                RealTimeMonth = 0;
                RealTimeDay = 0;
                RealTimeHour = 0;
                RealTimeMinute = 0;


                LitersPerMinute = 20;
                SolarColectorWattHours = 0;
                WattHoursPerDay = 0;
                MinimumAntifreezeTemp = 350;
                DifferenceBoilerAndSolar = 100;
                MaxDayTemperature = 0;                     
                         
                    for(i=0;i<LOG_COUNT;i++){
                    LogYear[i] = 0;
                    LogMonth[i] = 0;
                    LogDay[i] = 0;
                    LogHour[i] = 0;
                    LogMinute[i] = 0;

                    LogType[i] = 0;

                    LogData1[i] = 0;
                    LogData2[i] = 0;
                    }
                    
                    if(1){
                    unsigned char Position;
                        while(1){
                        unsigned char CycleBack;
                        Position++;    
                        lcd_clear();
                        CycleBack = lcd_put_runing_text(0,0,16,Position,"ISJUNKITE IR VEL IJUNKITE VALDIKLI");
                            if(CycleBack==1){
                            Position = 0;
                            }
                        delay_ms(300);     
                        }
                    }           
                }
            }
/*            else if(Address[0]==14){
                if(Address[1]==0){
                    if(RefreshLcd==1){
                    lcd_putsf("DUOMENU         SIUNTIMAS MBUS");
                    }
                    
                    if(BUTTON[4]==1){
                    Address[1] = 1;
                    }
                }
                else if(Address[1]==1){
                //static unsigned char DataToSent[200];
                //static unsigned char ReceivedData[200];
                    if(RefreshLcd==1){
                    unsigned char i;
                        for(i=0;i<16;i++){
                            if(Address[2]+i<200){
                            lcd_putchar(DataToSent[Address[2]+i]);
                            }
                            else{
                            lcd_putchar(' ');
                            }
                        }
                     
                    lcd_put_number(0,3,0,0,Address[2],0);
                    lcd_putchar(' ');
                    lcd_put_number(0,3,0,0,DataToSent[Address[2]],0);
                    }
                    
                    if(DUAL_BUTTON[0]==1){
                    Address[0] = 0;
                    Address[1] = 0;
                    Address[2] = 0;
                    }
                    
                    if(BUTTON[0]==1){
                        if(Address[2]>0){
                        Address[2]--;
                        }
                    }
                    else if(BUTTON[1]==1){
                        if(Address[2]<199){
                        Address[2]++;
                        }
                    }
                    
                    if(BUTTON[2]==1){
                    DataToSent[Address[2]]++;
                    }
                    
                    if(BUTTON[3]==1){
                    DataToSent[Address[2]]--;
                    }
                    
                    if(BUTTON[4]==1){
                    Address[1] = 1;
                    Address[2] = 0;
                    
                    lcd_clear();
                    lcd_putsf("SIUNCIAMA:");
                    delay_ms(1000);
                     
                    SendMBus();
                     
                    lcd_clear();
                    lcd_putsf("GAUNAMA:");
                    delay_ms(1000);
                     
                    GetMBus();
                    }
                    
                    
                }
                else if(Address[1]==2){
                    if(RefreshLcd==1){
                    unsigned char i;
                        for(i=0;i<16;i++){
                            if(Address[2]+i<200){
                            lcd_putchar(ReceivedData[Address[2]+i]);
                            }
                            else{
                            lcd_putchar(' ');
                            }
                        }
                     
                    lcd_put_number(0,3,0,0,Address[2],0);
                    lcd_putchar(' ');
                    lcd_put_number(0,3,0,0,ReceivedData[Address[2]],0);
                    }
                    
                    if(DUAL_BUTTON[0]==1){
                    Address[1] = 0;
                    Address[2] = 0;
                    }
                    
                    if(BUTTON[0]==1){
                        if(Address[2]>0){
                        Address[2]--;
                        }
                    }
                    else if(BUTTON[1]==1){
                        if(Address[2]<199){
                        Address[2]++;
                        }
                    }
                                      
                }
            }*/    
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
                lcd_buttons(0,1,1,1,1,1,0,0,0);
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
                lcd_buttons(1,1,1,1,1,1,0,0,0);
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
                lcd_buttons(1,1,1,1,1,1,0,0,0);
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
                lcd_buttons(1,0,1,1,1,1,0,0,0);
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

            if(DUAL_BUTTON[0]==1){
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
        }   
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////    
    Called_1Second = 0;
    delay_ms(1);
    }
}