/*******************************
Project   : Soliariumo Valdiklis
Version   : V1.0
Date      : 2012.09.10
Author    : Tomas
Chip type : ATmega128
*******************************/
#include <mega128.h>
#include <delay.h>
#include <math.h>
#include <stdio.h>
/*
unsigned char PORTF_data[8];
unsigned char PORTFEx(unsigned char adress_bit, unsigned char value){
unsigned char data, i, a;
data = 0;
PORTF_data[adress_bit] = value;

a = 1;
    for(i=0;i<8;i++){
    data += PORTF_data[adress_bit]*a;
    a = a*2;
    }

PORTF = data;
return 0;
}
unsigned char PINFEx(char adress_bit){
unsigned char data, bits[8], a, b;
signed char i;
data = PINF;

    for(i=7;i>=0;i--){
    b = 1;
        for(a=0;a<7;a++){
        b = b*2;
        }

        if(data>=b){
        bits[i] = 1;
        data -= b;
        }
        else{
        bits[i] = 0;
        }
    }
return bits[adress_bit];
}
*/

/*unsigned char PORTG_data[5];
unsigned char PORTGEx(unsigned char adress_bit, unsigned char value){
unsigned char data, i, a;
data = 0;
PORTG_data[adress_bit] = value;

a = 1;
    for(i=0;i<5;i++){
    data += PORTG_data[adress_bit]*a;
    a = a*2;
    }

PORTG = data;
return 0;
}*/

unsigned char PINGEx(char adress_bit){
unsigned char data, bits[5], a, b;
signed char i;
data = PING;

    for(i=4;i>=0;i--){
    b = 1;
        for(a=0;a<i;a++){
        b = b*2;
        }

        if(data>=b){
        bits[i] = 1;
        data -= b;
        }
        else{
        bits[i] = 0;
        }
    }
return bits[adress_bit];
}









// Temperature sensors
#asm
   .equ __w1_port=0x12 //PORTD
   .equ __w1_bit=0
#endasm
#include <ds18b20.h>

#define MAX_DS18B20_DEVICES 8

eeprom unsigned char DS18B20_IS_ASSIGNED[MAX_DS18B20_DEVICES];
// 1. Assigned and turned on
// 2. Assigned but turned off
// X. Not assigned

eeprom unsigned char DS18B20_ADDRESSES[MAX_DS18B20_DEVICES][9];
// 0. Kambario temperaturos daviklis
// 1. Lauko temperaturos daviklis
// 2. Pirmojo soliariumo temperaturos daviklis
// 3. Antrojo soliariumo temperaturos daviklis
// 4. Treciojo soliariumo temperaturos daviklis
// 5. Papildomas kambario temperaturos daviklis

float TEMPERATURES[MAX_DS18B20_DEVICES];
eeprom float ROOM_TEMPERATURE;
///////////////////////////////////








///////////// BUTTONS /////////////
// PINS
#define BUTTON_UP 0
#define BUTTON_LEFT 1
#define BUTTON_ENTER 2
#define BUTTON_RIGHT 3
#define BUTTON_DOWN 4
///////////////////////////////////





/*
unsigned char OUTPUT(unsigned char address, unsigned char value){
    if(address==3){
    PORTB.4 = value;
    return 1;
    }
    else if(address==4){
    PORTB.5 = value;
    return 1;
    }
    else if(address==5){
    PORTB.6 = value;
    return 1;
    }
    else if(address==6){
    PORTB.7 = value;
    return 1;
    }
    else if(address==7){
//    PORTGEx(4,value);
    return 1;
    }
    else if(address==8){
//    PORTGEx(3,value);
    return 1;
    }
    else if(address==9){
    PORTA.0 = value;
    return 1;
    }
    else if(address==10){
    PORTA.1 = value;
    return 1;
    }
    else if(address==11){
    PORTA.2 = value;
    return 1;
    }
    else if(address==12){
    PORTA.7 = value;
    return 1;
    }
    else if(address==13){
    PORTA.5 = value;
    return 1;
    }
    else if(address==14){
    PORTA.3 = value;
    return 1;
    }
    else if(address==15){
    PORTA.4 = value;
    return 1;
    }
    else if(address==16){
    PORTA.6 = value;
    return 1;
    }
return 0;
}
*/




unsigned char BUTTON_INPUT(unsigned char input){
    if(input==0){   return PINGEx(1);  }
    if(input==1){   return PINGEx(0);  } 
    if(input==2){   return PINC.0;  }
    if(input==3){   return PINC.2;  }
    if(input==4){   return PINC.1;  }
return 0;
}



#define SOLARIUM1_AT_WORK PORTD.1
#define SOLARIUM2_AT_WORK PORTD.2
#define SOLARIUM3_AT_WORK PORTD.3




// Neveiklumo taimeriai
unsigned int STAND_BY_TIMER;
unsigned char MAIN_MENU_TIMER,LCD_LED_TIMER;

eeprom unsigned char MANUAL_CONTROLLER;
//eeprom unsigned char VALVES[4];
unsigned char dac_data[4];
#define ADC_VREF_TYPE 0x20

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input){
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




// Other
char RefreshTime;

//////////// Mygtukai /////////////
#define ButtonFiltrationTimer 10 // x*cycle (cycle~1ms)
///////////////////////////////////



//-----------------------------------------------------------------------------------//
//--------------------------------- Lcd System --------------------------------------//
//-----------------------------------------------------------------------------------//
#define LCD_LED PORTB.0

static unsigned char RowsOnWindow;
static unsigned char Address[6];
static unsigned char SelectedRow;
static unsigned char RefreshLcd;
static unsigned char lcd_light_osc;
static unsigned char lcd_light_now;
eeprom unsigned char lcd_light;

#asm
   .equ __lcd_port=0x03 ;PORTE
#endasm
#include <lcd.h>

/*// Ekrano apsvietimas
//interrupt [TIM0_OVF] void timer0_ovf_isr(void){
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
//}*/

/*
unsigned char lcd_cursor(unsigned char x, unsigned char y){
lcd_gotoxy(x,y);
_lcd_ready();
_lcd_write_data(0xe);
return 1;
}
*/

unsigned char SelectAnotherRow(char up_down){
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

/*
unsigned char lcd_put_runing_text(   unsigned char Start_x,
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
*/

//-----------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------//

void main(void){
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=0
PORTB=0x00;
DDRB=0xF1;

// Port C initialization
// Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
// State7=T State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T
PORTC=0x00;
DDRC=0b01111000;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTD=0b00000000;
DDRD=0b00000000;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTE=0x00;
DDRE=0x00;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=Out Func3=Out Func2=In Func1=In Func0=In
// State4=0 State3=0 State2=T State1=T State0=T
PORTG=0x00;
//DDRG=0x18;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

/// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
//TCCR0=0x02;
//TCNT0=0x00;
//OCR0=0x00;



// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
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
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=FFFFh
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;
ETIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AVCC pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/128k
//#pragma optsize-
//WDTCR=0x1B;
//WDTCR=0x0B;
//#ifdef _OPTIMIZE_SIZE_
//#pragma optsize+
//#endif

// Global enable interrupts
//#asm("sei")                // del ds18b20 isjungtas

delay_ms(1000);
LCD_LED = 1;

// LCD module initialization
lcd_init(20);
//LCD_LED_TIMER = 30; lcd_light_now = lcd_light;
lcd_putsf("+------------------+");
lcd_putsf("/ SOLIAR. AUSINIMO /");
lcd_putsf("/ VALDIKLIS V1.");
lcd_put_number(0,3,0,0,__BUILD__,0);
lcd_putsf(" /+------------------+");
delay_ms(1000);
lcd_light_now = 20;

//dac_data[0] = VALVES[0];
//dac_data[1] = VALVES[1];
//dac_data[2] = VALVES[2];
//dac_data[3] = VALVES[3];

dac_data[0] = 0;
dac_data[1] = 255;
dac_data[2] = 255;
dac_data[3] = 255;
 
// Default values
    if(1){
    unsigned char i;
        for(i=0;i<MAX_DS18B20_DEVICES;i++){if(DS18B20_IS_ASSIGNED[i]>2){DS18B20_IS_ASSIGNED[i] = 0;}}
        if(lcd_light>100){lcd_light = 100;}
        if((ROOM_TEMPERATURE<10.0)||(ROOM_TEMPERATURE>30.0)){ROOM_TEMPERATURE = 20.0;}
    }
    
// DS18B20 temperature sensors
static unsigned char ds18b20_devices;
static unsigned char rom_code[MAX_DS18B20_DEVICES][9];
static unsigned char ds18b20_sensor_assignation[MAX_DS18B20_DEVICES];
    if(1){
    unsigned char i, j;
        for(i=0;i<MAX_DS18B20_DEVICES;i++){ds18b20_sensor_assignation[i] = 255;} 
     
    ds18b20_devices = w1_search(0xf0,rom_code);


        if(ds18b20_devices>=1){
        lcd_clear();
        lcd_gotoxy(0,1);
        lcd_putsf("RASTA DS18B20\nTERMODAVIKLIU: ");
        lcd_putchar(NumToIndex(ds18b20_devices));
        delay_ms(1000);
        }

        for(i=0;i<MAX_DS18B20_DEVICES;i++){
            if(DS18B20_IS_ASSIGNED[i]==1){
            DS18B20_IS_ASSIGNED[i] = 2;
            ds18b20_sensor_assignation[i] = 255;
            }
        }

        for(i=0;i<ds18b20_devices;i++){
        unsigned char Found = 0;

            if(!ds18b20_init(&rom_code[i][0],-55,128,DS18B20_12BIT_RES)){
            lcd_clear();
            lcd_putsf("STARTAVIMO KLAIDA:\nTEMP. DAVIKLIS");
                while(1){
                delay_ms(100);
                }
            }

            for(j=0;j<MAX_DS18B20_DEVICES;j++){
                if(DS18B20_IS_ASSIGNED[j]==2){
                unsigned char a, Match = 1;

                    for(a=0;a<9;a++){
                        if(rom_code[i][a]!=DS18B20_ADDRESSES[j][a]){
                        Match = 0;
                        break;
                        }
                    }

                    if(Match==1){
                        if(Found==0){
                        ds18b20_sensor_assignation[j] = i;
                        DS18B20_IS_ASSIGNED[j] = 1;
                        Found = 1;
                        }
                        else{
                        DS18B20_IS_ASSIGNED[j] = 255;
                        }
                    }
                }
            }
        }
    }
///////////////////////////////



static unsigned char STAND_BY = 1;

    while (1){

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

            if(1){
            RefreshLcd++;

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
        TimeRefreshed = 0;
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
    ///////////////////////////// DS18B20 ////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    static unsigned char ds18b20_wait_time;
    static unsigned char ds18b20_scanning_device;
    static unsigned char error_temperature[MAX_DS18B20_DEVICES];
        if((TimeRefreshed>=1)||(ds18b20_scanning_device>=1)){
        ds18b20_wait_time++;
            if(ds18b20_wait_time>=3){
                if(DS18B20_IS_ASSIGNED[ds18b20_scanning_device]==1){
                float i;
                i = ds18b20_temperature(&rom_code[ds18b20_sensor_assignation[ds18b20_scanning_device]][0]); 
                    if((i>-100.0)&&(i<200.0)){
                    TEMPERATURES[ds18b20_scanning_device] = i;
                    error_temperature[ds18b20_scanning_device] = 0;
                    }
                    else{
                        if(error_temperature[ds18b20_scanning_device]<10){
                        error_temperature[ds18b20_scanning_device]++;
                        }
                    }
                }

                if((error_temperature[ds18b20_scanning_device]==0)||(error_temperature[ds18b20_scanning_device]==10)){
                ds18b20_scanning_device++;
                }

                if(ds18b20_scanning_device>=MAX_DS18B20_DEVICES){
                ds18b20_wait_time = 0;
                ds18b20_scanning_device = 0;
                }

            }
        }
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////









    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// DAC /////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    static unsigned char ADC_CHANNEL=4;
        if(ADC_CHANNEL>7){
        ADC_CHANNEL = 4;
        }
             
        if(ADC_CHANNEL==4){
            if(dac_data[3]>read_adc(ADC_CHANNEL)){
            PORTC.4 = 1;
            }
            else{
            PORTC.4 = 0;
            }
        }
        else if(ADC_CHANNEL==5){
            if(dac_data[2]>read_adc(ADC_CHANNEL)){
            PORTC.3 = 1;
            }
            else{
            PORTC.3 = 0;
            }
        }
        else if(ADC_CHANNEL==6){
            if(dac_data[1]>read_adc(ADC_CHANNEL)){
            PORTC.6 = 1;
            }
            else{
            PORTC.6 = 0;
            }
        }
        else if(ADC_CHANNEL==7){
            if(dac_data[0]>read_adc(ADC_CHANNEL)){
            PORTC.5 = 1;
            }
            else{
            PORTC.5 = 0;
            }
        }
    ADC_CHANNEL++;
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////










    //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////// VALDYMO ALGORITMAS /////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    static unsigned char AlgorythmSecondTimer=0;
    static unsigned char ALGORYTHM_REFRESH_TIME=60;
     
    static float VERY_LAST_TEMPERATURES[MAX_DS18B20_DEVICES];
//    static unsigned char VERY_LAST_SOLARIUM_STATE[3];
//    static unsigned char VERY_LAST_DACS[4];

    static float LAST_TEMPERATURES[MAX_DS18B20_DEVICES];
    static unsigned char LAST_SOLARIUM_STATE[3];
//    static unsigned char LAST_DACS[4];
        
    static float SOLARIUM_OUTSIDE_OFFSET = 5.0;
    static float SOLARIUM_INSIDE_OFFSET = 2.5;
        
    // 0. Kambario temperaturos daviklis
    // 1. Lauko temperaturos daviklis
    // 2. Pirmojo soliariumo temperaturos daviklis
    // 3. Antrojo soliariumo temperaturos daviklis
    // 4. Treciojo soliariumo temperaturos daviklis
    // 5. Papildomas kambario temperaturos daviklis   

        if(TimeRefreshed>=1){
        AlgorythmSecondTimer++;
            if(AlgorythmSecondTimer>ALGORYTHM_REFRESH_TIME){
            AlgorythmSecondTimer = 0;
                if(MANUAL_CONTROLLER==0){

                    if(TEMPERATURES[1]+SOLARIUM_OUTSIDE_OFFSET<ROOM_TEMPERATURE){// Jei lauke yra salta
                        
                        // Jeigu atsalo
                        if( ROOM_TEMPERATURE-TEMPERATURES[0]>SOLARIUM_INSIDE_OFFSET ){// jei zemiau uzstatytos ribos
                            if( ROOM_TEMPERATURE-TEMPERATURES[0]<(SOLARIUM_INSIDE_OFFSET*2) ){// jei nezemiau uzstatytos ribos dvigubai
                                if(LAST_TEMPERATURES[0]>=TEMPERATURES[0]){// jei paskutine temperatura yra mazesne arba tokia pati
                                    if(dac_data[1]<=245){
                                    dac_data[1] += 10;
                                    dac_data[2] = dac_data[1];
                                    dac_data[3] = dac_data[1];
                                    }
                                    else{
                                    dac_data[1] = 255;
                                    dac_data[2] = 255;
                                    dac_data[3] = 255;
                                    }
                                }
                                else{ 
                                // Temperatura eina gera linkme    
                                }
                            }
                            else{
                            dac_data[0] = 0;
                            dac_data[1] = 255;
                            dac_data[2] = 255;
                            dac_data[3] = 255; 
                            }
                        }
                        
                        // Jeigu perkaito
                        else if( TEMPERATURES[0]-ROOM_TEMPERATURE>SOLARIUM_INSIDE_OFFSET ){// jei daugiau uzstatytos ribos
                            if( TEMPERATURES[0]-ROOM_TEMPERATURE<(SOLARIUM_INSIDE_OFFSET*2) ){// jei nedaugiau uzstatytos ribos dvigubai
                                if(LAST_TEMPERATURES[0]<=TEMPERATURES[0]){// jei paskutine temperatura yra mazesne arba tokia pati
                                    if(dac_data[1]>=10){
                                    dac_data[1] -= 10;
                                    dac_data[2] = dac_data[1];
                                    dac_data[3] = dac_data[1];
                                    }
                                    else{
                                    dac_data[1] = 255;
                                    dac_data[2] = 255;
                                    dac_data[3] = 255;
                                    }
                                }
                                else{ 
                                // Temperatura eina gera linkme    
                                }
                            }
                            else{
                            dac_data[0] = 255;
                            dac_data[1] = 0;
                            dac_data[2] = 0;
                            dac_data[3] = 0; 
                            }
                        }

                        // jei siek tiek daugiau
                        else if(TEMPERATURES[0]>ROOM_TEMPERATURE){ // jeigu temperatura ribose bet siek tiek didesne
                            if(LAST_TEMPERATURES[0]<TEMPERATURES[0]){// jei temperatura padidejo
                                if(dac_data[1]>=2){
                                dac_data[1] -= 2;
                                dac_data[2] = dac_data[1];
                                dac_data[3] = dac_data[1];
                                }
                                else{
                                dac_data[1] = 0;
                                dac_data[2] = 0;
                                dac_data[3] = 0;
                                } 
                            }
                            else{
                            // Gerai
                            } 
                        }
                        
                        // jei siek tiek maziau
                        else if(TEMPERATURES[0]<ROOM_TEMPERATURE){ // jeigu temperatura ribose bet siek tiek mazesne
                            if(LAST_TEMPERATURES[0]>TEMPERATURES[0]){// jei temperatura sumazejo
                                if(dac_data[1]<=253){
                                dac_data[1] += 2;
                                dac_data[2] = dac_data[1];
                                dac_data[3] = dac_data[1];
                                }
                                else{
                                dac_data[1] = 255;
                                dac_data[2] = 255;
                                dac_data[3] = 255;
                                }
                            }
                            else{
                            // Gerai
                            }        
                        }


                    dac_data[0] = 255 - dac_data[1];


                    /*unsigned int solariums_opens=0, count=0; 

                        if((SOLARIUM1_AT_WORK==1)|| (TEMPERATURES[2]>TEMPERATURES[0]+5.0) ){
                            if(DS18B20_IS_ASSIGNED[2]==1){
                                if(LAST_SOLARIUM_STATE[0]==1){// Turi buti pradirbes bent 1 cikla
                                    if(TEMPERATURES[2] > (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei is soliariumo iseinantis oras aukstesnes temp negu uzstatyta
                                        if(TEMPERATURES[0] < (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei kambario temperatura zemesne
                                            if(TEMPERATURES[0]<LAST_TEMPERATURES[0]<VERY_LAST_TEMPERATURES[0]){
                                                if(dac_data[1]<=235){
                                                dac_data[1] = dac_data[1] + 20;
                                                }
                                                else{
                                                dac_data[1] = 255;
                                                } 
                                            }           
                                        }
                                        else if( (ROOM_TEMPERATURE-SOLARIUM_INSIDE_OFFSET) < TEMPERATURES[0] ){// Jei kambario temperatura aukstesne
                                            if(TEMPERATURES[0]>LAST_TEMPERATURES[0]>VERY_LAST_TEMPERATURES[0]){
                                                if(dac_data[1]>=20){ 
                                                dac_data[1] = dac_data[1] - 20;
                                                }
                                                else{
                                                dac_data[1] = 0;
                                                }
                                            } 
                                        }
                                        else{// Jei kambario temperatura ribose
                                            if(TEMPERATURES[0]>ROOM_TEMPERATURE){// Jei aukstesne
                                                if(dac_data[1]<=250){
                                                dac_data[1] = dac_data[1] + 5;
                                                } 
                                            }
                                            else if(TEMPERATURES[0]<ROOM_TEMPERATURE){// Jei zemesne
                                                if(dac_data[1]>=5){
                                                dac_data[1] = dac_data[1] - 5;   
                                                }
                                            }
                                        }
                                    }
                                    else{
                                    dac_data[1] = 255;
                                    } 
                                }
                                else{
                                dac_data[1] = 255;
                                LAST_SOLARIUM_STATE[0] = 1;
                                }                             
                            }
                            else{
                            dac_data[1] = 255;
                            }
                        solariums_opens = dac_data[1];
                        count = 1;                      
                        }
                        else{
                        dac_data[1] = 0;
                        LAST_SOLARIUM_STATE[0] = 0;    
                        }


                        if((SOLARIUM2_AT_WORK==1)|| (TEMPERATURES[3]>TEMPERATURES[0]+5.0) ){
                            if(DS18B20_IS_ASSIGNED[3]==1){
                                if(LAST_SOLARIUM_STATE[1]==1){// Turi buti pradirbes bent 1 cikla
                                    if(TEMPERATURES[3] > (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei is soliariumo iseinantis oras aukstesnes temp negu uzstatyta
                                        if(TEMPERATURES[0] < (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei kambario temperatura zemesne
                                            if(TEMPERATURES[0]<LAST_TEMPERATURES[0]<VERY_LAST_TEMPERATURES[0]){
                                                if(dac_data[2]<=235){
                                                dac_data[2] = dac_data[2] + 20;
                                                }
                                                else{
                                                dac_data[2] = 255;
                                                } 
                                            }           
                                        }
                                        else if( (ROOM_TEMPERATURE-SOLARIUM_INSIDE_OFFSET) < TEMPERATURES[0] ){// Jei kambario temperatura aukstesne
                                            if(TEMPERATURES[0]>LAST_TEMPERATURES[0]>VERY_LAST_TEMPERATURES[0]){
                                                if(dac_data[2]>=20){ 
                                                dac_data[2] = dac_data[2] - 20;
                                                }
                                                else{
                                                dac_data[2] = 0;
                                                }
                                            } 
                                        }
                                        else{// Jei kambario temperatura ribose
                                            if(TEMPERATURES[0]>ROOM_TEMPERATURE){// Jei aukstesne
                                                if(dac_data[2]<=250){
                                                dac_data[2] = dac_data[2] + 5;
                                                } 
                                            }
                                            else if(TEMPERATURES[0]<ROOM_TEMPERATURE){// Jei zemesne
                                                if(dac_data[2]>=5){
                                                dac_data[2] = dac_data[2] - 5;   
                                                }
                                            }
                                        }
                                    }
                                    else{
                                    dac_data[2] = 255;
                                    } 
                                }
                                else{
                                dac_data[2] = 255;
                                LAST_SOLARIUM_STATE[1] = 1;
                                }                             
                            }
                            else{
                            dac_data[2] = 255;
                            }
                        solariums_opens = dac_data[2];
                        count = 1;                      
                        }
                        else{
                        dac_data[2] = 0;
                        LAST_SOLARIUM_STATE[1] = 0;    
                        }
                                                

                        if((SOLARIUM3_AT_WORK==1)|| (TEMPERATURES[4]>TEMPERATURES[0]+5.0) ){
                            if(DS18B20_IS_ASSIGNED[4]==1){
                                if(LAST_SOLARIUM_STATE[2]==1){// Turi buti pradirbes bent 1 cikla
                                    if(TEMPERATURES[4] > (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei is soliariumo iseinantis oras aukstesnes temp negu uzstatyta
                                        if(TEMPERATURES[0] < (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei kambario temperatura zemesne
                                            if(TEMPERATURES[0]<LAST_TEMPERATURES[0]<VERY_LAST_TEMPERATURES[0]){
                                                if(dac_data[3]<=235){
                                                dac_data[3] = dac_data[3] + 20;
                                                }
                                                else{
                                                dac_data[3] = 255;
                                                } 
                                            }           
                                        }
                                        else if( (ROOM_TEMPERATURE-SOLARIUM_INSIDE_OFFSET) < TEMPERATURES[0] ){// Jei kambario temperatura aukstesne
                                            if(TEMPERATURES[0]>LAST_TEMPERATURES[0]>VERY_LAST_TEMPERATURES[0]){
                                                if(dac_data[3]>=20){ 
                                                dac_data[3] = dac_data[3] - 20;
                                                }
                                                else{
                                                dac_data[3] = 0;
                                                }
                                            } 
                                        }
                                        else{// Jei kambario temperatura ribose
                                            if(TEMPERATURES[0]>ROOM_TEMPERATURE){// Jei aukstesne
                                                if(dac_data[3]<=250){
                                                dac_data[3] = dac_data[3] + 5;
                                                } 
                                            }
                                            else if(TEMPERATURES[0]<ROOM_TEMPERATURE){// Jei zemesne
                                                if(dac_data[3]>=5){
                                                dac_data[3] = dac_data[3] - 5;   
                                                }
                                            }
                                        }
                                    }
                                    else{
                                    dac_data[3] = 255;
                                    } 
                                }
                                else{
                                dac_data[3] = 255;
                                LAST_SOLARIUM_STATE[2] = 1;
                                }                             
                            }
                            else{
                            dac_data[3] = 255;
                            }
                        solariums_opens = dac_data[3];
                        count = 1;                      
                        }
                        else{
                        dac_data[3] = 0;
                        LAST_SOLARIUM_STATE[2] = 0;    
                        }




                        if(count>0){    
                        dac_data[0] = 255 - (solariums_opens/count);
                        }
                        else{
                        dac_data[0] = 255;
                        }*/    

                    }
                    else{
                    dac_data[0] = 255;
                    dac_data[1] = 0;
                    dac_data[2] = 0;
                    dac_data[3] = 0; 
                    }
                    



                // VERY LAST
                    if(1){
                    unsigned char i;
                        for(i=0;i<MAX_DS18B20_DEVICES;i++){
                        VERY_LAST_TEMPERATURES[i] = LAST_TEMPERATURES[i];
                        }    
                        
                    //VERY_LAST_SOLARIUM_STATE[0] = LAST_SOLARIUM_STATE[0];
                    //VERY_LAST_SOLARIUM_STATE[1] = LAST_SOLARIUM_STATE[1];
                    //VERY_LAST_SOLARIUM_STATE[2] = LAST_SOLARIUM_STATE[2];
                        
                    //    for(i=0;i<MAX_DS18B20_DEVICES;i++){ 
                    //    VERY_LAST_DACS[i] = LAST_DACS[i];
                    //    }
                    }


                // LAST
                    if(1){
                    unsigned char i;
                        for(i=0;i<MAX_DS18B20_DEVICES;i++){
                        LAST_TEMPERATURES[i] = TEMPERATURES[i];
                        }    
                        
                    LAST_SOLARIUM_STATE[0] = SOLARIUM1_AT_WORK;
                    LAST_SOLARIUM_STATE[1] = SOLARIUM2_AT_WORK;
                    LAST_SOLARIUM_STATE[2] = SOLARIUM3_AT_WORK;
                        
                    //    for(i=0;i<MAX_DS18B20_DEVICES;i++){ 
                    //    LAST_DACS[i] = dac_data[i];
                    //    }
                    }
                                         
                } 
            }
        }
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////











    //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////// LCD ////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    // Lcd led pwm
    lcd_light_osc += 1;
        if(lcd_light_osc>=20){
        lcd_light_osc = 0;
        }

        if(lcd_light_now>lcd_light_osc){
        LCD_LED = 1;
        }
        else{
        LCD_LED = 0;
        }



    // Lcd led antibrighter
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
                if(stand_by_pos[1]==0){lcd_gotoxy(0,2);lcd_putchar('/');lcd_gotoxy(0,1);lcd_putchar('/');lcd_gotoxy(0,0);lcd_putchar('^');}
                else if(stand_by_pos[1]==1){lcd_gotoxy(0,1);lcd_putchar('/');lcd_gotoxy(0,0);lcd_putsf("+>");}
                else if((stand_by_pos[1]>=2)&&(stand_by_pos[1]<=19)){lcd_gotoxy(stand_by_pos[1]-2,0);lcd_putsf("-->");}
                else if(stand_by_pos[1]==20){lcd_gotoxy(18,0);lcd_putsf("-+");lcd_gotoxy(19,1);lcd_putchar('v');}
                else if(stand_by_pos[1]==21){lcd_gotoxy(19,0);lcd_putchar('/');lcd_gotoxy(19,1);lcd_putchar('/');lcd_gotoxy(19,2);lcd_putchar('v');}
                else if(stand_by_pos[1]==22){lcd_gotoxy(19,1);lcd_putchar('/');lcd_gotoxy(19,2);lcd_putchar('/');lcd_gotoxy(19,3);lcd_putchar('v');}
                else if(stand_by_pos[1]==23){lcd_gotoxy(19,2);lcd_putchar('/');lcd_gotoxy(18,3);lcd_putsf("<+");}
                else if((stand_by_pos[1]>=24)&&(stand_by_pos[1]<=41)){lcd_gotoxy(17-stand_by_pos[1]+24,3);lcd_putsf("<--");}
                else if(stand_by_pos[1]==42){lcd_gotoxy(0,2);lcd_putchar('^');lcd_gotoxy(0,3);lcd_putsf("+-");}
                else if(stand_by_pos[1]==43){lcd_gotoxy(0,1);lcd_putchar('^');lcd_gotoxy(0,2);lcd_putchar('/');lcd_gotoxy(0,3);lcd_putchar('/');}

            lcd_gotoxy(1,1);
            lcd_putsf("    SOLIARIUMO    ");
            lcd_gotoxy(1,2);
            lcd_putsf("    VALDIKLIS     ");
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
                RowsOnWindow = 8;
                    for(row=Address[5];row<4+Address[5];row++){
                    lcd_gotoxy(0,lcd_row);
                        if(row==0){
                        lcd_putsf("  -=PAGR. MENIU=-");
                        }
                        else if(row==1){
                        lcd_putsf("1.KAMBARIO: ");
                            if(DS18B20_IS_ASSIGNED[0]==1){
                            char lcd_buffer[10];
                            sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[0]);
                            lcd_puts(lcd_buffer);
                            }
                            else if(DS18B20_IS_ASSIGNED[0]==2){
                            lcd_putsf("OFF");
                            }
                            else{
                            lcd_putsf("----");
                            }
                        }
                        else if(row==2){
                        lcd_putsf("2.LAUKO:    ");
                            if(DS18B20_IS_ASSIGNED[1]==1){
                            char lcd_buffer[10];
                            sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[1]);
                            lcd_puts(lcd_buffer);
                            }
                            else if(DS18B20_IS_ASSIGNED[1]==2){
                            lcd_putsf("OFF");
                            }
                            else{
                            lcd_putsf("----");
                            }
                        }
                        else if(row==3){
                        lcd_putsf("3.SKLENDES:  ");

                        }
                        else if(row==4){
                        lcd_putsf("4.SOLIAR.1: ");
                            if(DS18B20_IS_ASSIGNED[2]==1){
                            char lcd_buffer[10];
                            sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[2]);
                            lcd_puts(lcd_buffer);
                            }
                            else if(DS18B20_IS_ASSIGNED[2]==2){
                            lcd_putsf("OFF");
                            }
                            else{
                            lcd_putsf("----");
                            }
                        }
                        else if(row==5){
                        lcd_putsf("5.SOLIAR.2: ");
                            if(DS18B20_IS_ASSIGNED[3]==1){
                            char lcd_buffer[10];
                            sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[3]);
                            lcd_puts(lcd_buffer);
                            }
                            else if(DS18B20_IS_ASSIGNED[3]==2){
                            lcd_putsf("OFF");
                            }
                            else{
                            lcd_putsf("----");
                            }
                        }
                        else if(row==6){
                        lcd_putsf("6.SOLIAR.3: ");
                            if(DS18B20_IS_ASSIGNED[4]==1){
                            char lcd_buffer[10];
                            sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[4]);
                            lcd_puts(lcd_buffer);
                            }
                            else if(DS18B20_IS_ASSIGNED[4]==2){
                            lcd_putsf("OFF");
                            }
                            else{
                            lcd_putsf("----");
                            }
                        }
                        else if(row==7){
                        lcd_putsf("7.NUSTATYMAI");
                        }
                    lcd_row++;
                    }

                lcd_gotoxy(19,SelectedRow-Address[5]);
                lcd_putchar('<');
                }
            }

            // Kambario temp
            else if(Address[0]==1){
            unsigned char USING_TEMPERATURE_SENSOR=0;
                if(BUTTON[BUTTON_DOWN]==1){
                SelectAnotherRow(0);
                }
                else if(BUTTON[BUTTON_UP]==1){
                SelectAnotherRow(1);
                }
                else if(BUTTON[BUTTON_ENTER]==1){
                    if(SelectedRow==0){
                    Address[0] = 0;
                    SelectedRow = 0;
                    Address[5] = 0;
                    }
                }
                else if(BUTTON[BUTTON_LEFT]==1){
                    if(SelectedRow==1){
                        if(ROOM_TEMPERATURE>10.0){
                        ROOM_TEMPERATURE = ROOM_TEMPERATURE - 0.1;
                        }
                        else{
                        ROOM_TEMPERATURE = 10.0; 
                        } 
                    }
                    else if((SelectedRow==2)||(SelectedRow==3)){                         
                        if((DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1)||(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2)){
                        signed char i, Found=0;
                            for(i=ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR]-1;i>=0;i--){
                            unsigned char used=0, a;
                                for(a=0;a<MAX_DS18B20_DEVICES;a++){
                                    if(DS18B20_IS_ASSIGNED[a]==1){
                                        if(ds18b20_sensor_assignation[a]==i){
                                        used = 1;
                                        break;
                                        }
                                    }    
                                }
                                    
                                if(used==0){
                                unsigned char b;
                                ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
                                    for(b=0;b<9;b++){                          
                                    DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];    
                                    }
                                TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;    
                                Found = 1;    
                                break;  
                                } 
                            }
                                
                            if(Found==0){
                            DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 0;    
                            ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = 255;
                            TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;                                
                            }
                        }  
                    } 
                }                    
                else if(BUTTON[BUTTON_RIGHT]==1){
                    if(SelectedRow==1){
                        if(ROOM_TEMPERATURE<30.0){
                        ROOM_TEMPERATURE = ROOM_TEMPERATURE + 0.1;
                        }
                        else{
                        ROOM_TEMPERATURE = 30.0; 
                        } 
                    }
                    else if((SelectedRow==2)||(SelectedRow==3)){
                    unsigned char i, Found=0;
                            
                        if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                        i = ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] + 1;
                        }
                        else{
                        i = 0; 
                        }
                            
                        for(i=i;i<ds18b20_devices;i++){
                        unsigned char used=0, a;               
                            for(a=0;a<MAX_DS18B20_DEVICES;a++){
                                if(DS18B20_IS_ASSIGNED[a]==1){
                                    if(ds18b20_sensor_assignation[a]==i){
                                    used = 1;
                                    break;         
                                    }
                                }    
                            }
                                
                            if(used==0){
                            unsigned char b;
                            ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
                                for(b=0;b<9;b++){                          
                                DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];  
                                }
                            DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 1;
                            Found = 1;
                            TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;    
                            break;  
                            } 
                        }
                            
                        if(Found==0){    
                        lcd_clear();
                        lcd_putsf(" AUKSTESNIO NUMERIO ");
                        lcd_putsf(" LAISVO TERMOMETRO  ");
                        lcd_putsf("        NERA        ");
                        delay_ms(1000); 
                        lcd_clear();
                        }  
                    }
                }

                if(RefreshLcd>=1){
                unsigned char row, lcd_row;
                lcd_row = 0;
                RowsOnWindow = 4;
                    for(row=Address[5];row<4+Address[5];row++){
                    lcd_gotoxy(0,lcd_row);
                        if(row==0){
                        lcd_putsf(" -=KAMBARIO TERM.=- ");
                        }
                        else if(row==1){
                        char lcd_buffer[10];
                        lcd_putsf("1.UZSTATYTA:");
                        sprintf(lcd_buffer,"%+2.1f\xdfC",ROOM_TEMPERATURE);
                        lcd_puts(lcd_buffer);
                        }
                        else if(row==2){
                        lcd_putsf("2.TEMPERAT.:");
                            if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                            char lcd_buffer[10];
                            sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[USING_TEMPERATURE_SENSOR]);
                            lcd_puts(lcd_buffer);
                            }
                            else if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2){
                            lcd_putsf("    OFF");
                            }
                            else{
                            lcd_putsf("   ----");
                            }
                        }
                        else if(row==3){
                        lcd_putsf("3.TERMOMETRO NR:");   
                            if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                            lcd_putchar(NumToIndex(ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR])+1);
                            lcd_putchar('/');
                            lcd_putchar(NumToIndex(ds18b20_devices));    
                            }
                            else{
                            lcd_putsf("-/");
                            lcd_putchar(NumToIndex(ds18b20_devices));
                            }
                        }
                    lcd_row++;
                    }

                lcd_gotoxy(19,SelectedRow-Address[5]);
                lcd_putchar('<');
                }
            }

            // Lauko temp
            else if(Address[0]==2){
            unsigned char USING_TEMPERATURE_SENSOR=1;
                if(BUTTON[BUTTON_DOWN]==1){
                SelectAnotherRow(0);
                }
                else if(BUTTON[BUTTON_UP]==1){
                SelectAnotherRow(1);
                }
                else if(BUTTON[BUTTON_ENTER]==1){
                    if(SelectedRow==0){
                    Address[0] = 0;
                    SelectedRow = 0;
                    Address[5] = 0;
                    }
                }
                else if(BUTTON[BUTTON_LEFT]==1){
                    if((SelectedRow==1)||(SelectedRow==2)){                         
                        if((DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1)||(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2)){
                        signed char i, Found=0;
                            for(i=ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR]-1;i>=0;i--){
                            unsigned char used=0, a;
                                for(a=0;a<MAX_DS18B20_DEVICES;a++){
                                    if(DS18B20_IS_ASSIGNED[a]==1){
                                        if(ds18b20_sensor_assignation[a]==i){
                                        used = 1;
                                        break;
                                        }
                                    }    
                                }
                                        
                                if(used==0){
                                unsigned char b;
                                ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
                                    for(b=0;b<9;b++){                          
                                    DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];  
                                    }
                                Found = 1;
                                TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;    
                                break;  
                                } 
                            }
                                    
                            if(Found==0){
                            DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 0;    
                            ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = 255;
                            TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;                                
                            }
                        }
                    }
                }    
                else if(BUTTON[BUTTON_RIGHT]==1){
                    if((SelectedRow==1)||(SelectedRow==2)){
                    unsigned char i, Found=0;       
                        if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                        i = ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] + 1;
                        }
                        else{
                        i = 0; 
                        }
                                
                        for(i=i;i<ds18b20_devices;i++){
                        unsigned char used=0, a;
                            for(a=0;a<MAX_DS18B20_DEVICES;a++){
                                if(DS18B20_IS_ASSIGNED[a]==1){
                                    if(ds18b20_sensor_assignation[a]==i){
                                    used = 1;
                                    break;         
                                    }
                                }    
                            }
                                    
                            if(used==0){
                            unsigned char b;
                            ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
                                for(b=0;b<9;b++){                          
                                DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];  
                                }
                            DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 1;
                            Found = 1;
                            TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;    
                            break;  
                            } 
                        }
                                
                        if(Found==0){    
                        lcd_clear();
                        lcd_putsf(" AUKSTESNIO NUMERIO ");
                        lcd_putsf(" LAISVO TERMOMETRO  ");
                        lcd_putsf("        NERA        ");  
                        delay_ms(1000); 
                        lcd_clear();
                        }
                    }
                }

                if(RefreshLcd>=1){
                unsigned char row, lcd_row;
                lcd_row = 0;
                RowsOnWindow = 4;
                    for(row=Address[5];row<4+Address[5];row++){
                    lcd_gotoxy(0,lcd_row);
                        if(row==0){
                        lcd_putsf("  -=LAUKO TERM.=-  ");
                        }
                        else if(row==1){
                        lcd_putsf("1.TEMPERAT.:");
                            if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                            char lcd_buffer[10];
                            sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[USING_TEMPERATURE_SENSOR]);
                            lcd_puts(lcd_buffer);
                            }
                            else if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2){
                            lcd_putsf("    OFF");
                            }
                            else{
                            lcd_putsf("   ----");
                            }
                        }
                        else if(row==2){
                        lcd_putsf("2.TERMOMETRO NR:");   
                            if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                            lcd_putchar(NumToIndex(ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR])+1);
                            lcd_putchar('/');
                            lcd_putchar(NumToIndex(ds18b20_devices));    
                            }
                            else{
                            lcd_putsf("-/");
                            lcd_putchar(NumToIndex(ds18b20_devices));
                            }
                        }
                    lcd_row++;
                    }

                lcd_gotoxy(19,SelectedRow-Address[5]);
                lcd_putchar('<');
                }
            }

            // Sklendes
            else if(Address[0]==3){
                if(BUTTON[BUTTON_DOWN]==1){
                SelectAnotherRow(0);
                }
                else if(BUTTON[BUTTON_UP]==1){
                SelectAnotherRow(1);
                }
                else if(BUTTON[BUTTON_ENTER]==1){
                    if(SelectedRow==0){
                    Address[0] = 0;
                    SelectedRow = 0;
                    Address[5] = 0;
                    }
                }
                else if(BUTTON[BUTTON_LEFT]==1){
                    if(SelectedRow==1){
                        if(MANUAL_CONTROLLER==1){
                        MANUAL_CONTROLLER = 0;
                        }
                        else{
                        MANUAL_CONTROLLER = 1;
                        } 
                     
                    }
                    else if(SelectedRow==2){
                        if(MANUAL_CONTROLLER==1){
                            if(dac_data[0]>0){
                            dac_data[0]--;
                            }
                        }  
                    }
                    else if(SelectedRow==3){
                        if(MANUAL_CONTROLLER==1){
                            if(dac_data[1]>0){
                            dac_data[1]--;
                            }
                        } 
                    }
                    else if(SelectedRow==4){
                        if(MANUAL_CONTROLLER==1){
                            if(dac_data[2]>0){
                            dac_data[2]--;
                            }
                        } 
                    }
                    else if(SelectedRow==5){
                        if(MANUAL_CONTROLLER==1){
                            if(dac_data[3]>0){
                            dac_data[3]--;
                            }
                        } 
                    }
                }    
                else if(BUTTON[BUTTON_RIGHT]==1){
                    if(SelectedRow==1){
                        if(MANUAL_CONTROLLER==1){
                        MANUAL_CONTROLLER = 0;
                        }
                        else{
                        MANUAL_CONTROLLER = 1;
                        } 
                    }
                    else if(SelectedRow==2){
                        if(MANUAL_CONTROLLER==1){
                            if(dac_data[0]<255){
                            dac_data[0]++;
                            }
                        }  
                    }
                    else if(SelectedRow==3){
                        if(MANUAL_CONTROLLER==1){
                            if(dac_data[1]<255){
                            dac_data[1]++;
                            }
                        } 
                    }
                    else if(SelectedRow==4){
                        if(MANUAL_CONTROLLER==1){
                            if(dac_data[2]<255){
                            dac_data[2]++;
                            }
                        } 
                    }
                    else if(SelectedRow==5){
                        if(MANUAL_CONTROLLER==1){
                            if(dac_data[3]<255){
                            dac_data[3]++;
                            }
                        } 
                    }
                }

                if(RefreshLcd>=1){
                unsigned char row, lcd_row;
                lcd_row = 0;
                RowsOnWindow = 6;
                    for(row=Address[5];row<4+Address[5];row++){
                    lcd_gotoxy(0,lcd_row);
                        if(row==0){
                        lcd_putsf("    -=SKLENDES=-");
                        }
                        else if(row==1){
                        lcd_putsf("REZIMAS:");
                            if(MANUAL_CONTROLLER==1){
                            lcd_putsf(" RANKINIS");    
                            }
                            else{
                            lcd_putsf(" AUTOMAT."); 
                            }
                        }
                        else if(row==2){
                        lcd_putsf("LAUKO:    ");
                        lcd_put_number(0,3,0,0,dac_data[0],0);
                        lcd_putsf("/255");
                        }
                        else if(row==3){
                        lcd_putsf("SOLIAR.1: ");
                        lcd_put_number(0,3,0,0,dac_data[1],0);
                        lcd_putsf("/255");
                        }
                        else if(row==4){
                        lcd_putsf("SOLIAR.2: ");
                        lcd_put_number(0,3,0,0,dac_data[2],0);
                        lcd_putsf("/255");
                        }
                        else if(row==5){
                        lcd_putsf("SOLIAR.3: ");
                        lcd_put_number(0,3,0,0,dac_data[3],0);
                        lcd_putsf("/255");
                        }
                    lcd_row++;
                    }

                lcd_gotoxy(19,SelectedRow-Address[5]);
                lcd_putchar('<');
                }
            }

            // 1 soliariumo temp
            else if(Address[0]==4){
            unsigned char USING_TEMPERATURE_SENSOR=2;
                if(BUTTON[BUTTON_DOWN]==1){
                SelectAnotherRow(0);
                }
                else if(BUTTON[BUTTON_UP]==1){
                SelectAnotherRow(1);
                }
                else if(BUTTON[BUTTON_ENTER]==1){
                    if(SelectedRow==0){
                    Address[0] = 0;
                    SelectedRow = 0;
                    Address[5] = 0;
                    }
                }
                else if(BUTTON[BUTTON_LEFT]==1){
                    if((SelectedRow==1)||(SelectedRow==2)){                         
                        if((DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1)||(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2)){
                        signed char i, Found=0;
                            for(i=ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR]-1;i>=0;i--){
                            unsigned char used=0, a;
                                for(a=0;a<MAX_DS18B20_DEVICES;a++){
                                    if(DS18B20_IS_ASSIGNED[a]==1){
                                        if(ds18b20_sensor_assignation[a]==i){
                                        used = 1;
                                        break;
                                        }
                                    }    
                                }
                                        
                                if(used==0){
                                unsigned char b;
                                ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
                                    for(b=0;b<9;b++){                          
                                    DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];  
                                    }
                                Found = 1;
                                TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;    
                                break;  
                                } 
                            }
                                    
                            if(Found==0){
                            DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 0;    
                            ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = 255;
                            TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;                                
                            }
                        }
                    }
                }    
                else if(BUTTON[BUTTON_RIGHT]==1){
                    if((SelectedRow==1)||(SelectedRow==2)){
                    unsigned char i, Found=0;       
                        if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                        i = ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] + 1;
                        }
                        else{
                        i = 0; 
                        }
                                
                        for(i=i;i<ds18b20_devices;i++){
                        unsigned char used=0, a;
                            for(a=0;a<MAX_DS18B20_DEVICES;a++){
                                if(DS18B20_IS_ASSIGNED[a]==1){
                                    if(ds18b20_sensor_assignation[a]==i){
                                    used = 1;
                                    break;         
                                    }
                                }    
                            }
                                    
                            if(used==0){
                            unsigned char b;
                            ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
                                for(b=0;b<9;b++){                          
                                DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];  
                                }
                            DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 1;
                            Found = 1;
                            TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;    
                            break;  
                            } 
                        }
                                
                        if(Found==0){    
                        lcd_clear();
                        lcd_putsf(" AUKSTESNIO NUMERIO ");
                        lcd_putsf(" LAISVO TERMOMETRO  ");
                        lcd_putsf("        NERA        ");  
                        delay_ms(1000); 
                        lcd_clear();
                        }
                    }
                }

                if(RefreshLcd>=1){
                unsigned char row, lcd_row;
                lcd_row = 0;
                RowsOnWindow = 4;
                    for(row=Address[5];row<4+Address[5];row++){
                    lcd_gotoxy(0,lcd_row);
                        if(row==0){
                        lcd_putsf("-=SOLIAR. 1 TERM.=- ");
                        }
                        else if(row==1){
                        lcd_putsf("1.TEMPERAT.:");
                            if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                            char lcd_buffer[10];
                            sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[USING_TEMPERATURE_SENSOR]);
                            lcd_puts(lcd_buffer);
                            }
                            else if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2){
                            lcd_putsf("    OFF");
                            }
                            else{
                            lcd_putsf("   ----");
                            }
                        }
                        else if(row==2){
                        lcd_putsf("2.TERMOMETRO NR:");   
                            if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                            lcd_putchar(NumToIndex(ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR])+1);
                            lcd_putchar('/');
                            lcd_putchar(NumToIndex(ds18b20_devices));    
                            }
                            else{
                            lcd_putsf("-/");
                            lcd_putchar(NumToIndex(ds18b20_devices));
                            }
                        }
                    lcd_row++;
                    }

                lcd_gotoxy(19,SelectedRow-Address[5]);
                lcd_putchar('<');
                }
            }

            // 2 soliariumo temp
            else if(Address[0]==5){
            unsigned char USING_TEMPERATURE_SENSOR=3;
                if(BUTTON[BUTTON_DOWN]==1){
                SelectAnotherRow(0);
                }
                else if(BUTTON[BUTTON_UP]==1){
                SelectAnotherRow(1);
                }
                else if(BUTTON[BUTTON_ENTER]==1){
                    if(SelectedRow==0){
                    Address[0] = 0;
                    SelectedRow = 0;
                    Address[5] = 0;
                    }
                }
                else if(BUTTON[BUTTON_LEFT]==1){
                    if((SelectedRow==1)||(SelectedRow==2)){                         
                        if((DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1)||(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2)){
                        signed char i, Found=0;
                            for(i=ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR]-1;i>=0;i--){
                            unsigned char used=0, a;
                                for(a=0;a<MAX_DS18B20_DEVICES;a++){
                                    if(DS18B20_IS_ASSIGNED[a]==1){
                                        if(ds18b20_sensor_assignation[a]==i){
                                        used = 1;
                                        break;
                                        }
                                    }    
                                }
                                        
                                if(used==0){
                                unsigned char b;
                                ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
                                    for(b=0;b<9;b++){                          
                                    DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];  
                                    }
                                Found = 1;
                                TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;    
                                break;  
                                } 
                            }
                                    
                            if(Found==0){
                            DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 0;    
                            ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = 255;
                            TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;                                
                            }
                        }
                    }
                }    
                else if(BUTTON[BUTTON_RIGHT]==1){
                    if((SelectedRow==1)||(SelectedRow==2)){
                    unsigned char i, Found=0;       
                        if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                        i = ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] + 1;
                        }
                        else{
                        i = 0; 
                        }
                                
                        for(i=i;i<ds18b20_devices;i++){
                        unsigned char used=0, a;
                            for(a=0;a<MAX_DS18B20_DEVICES;a++){
                                if(DS18B20_IS_ASSIGNED[a]==1){
                                    if(ds18b20_sensor_assignation[a]==i){
                                    used = 1;
                                    break;         
                                    }
                                }    
                            }
                                    
                            if(used==0){
                            unsigned char b;
                            ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
                                for(b=0;b<9;b++){                          
                                DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];  
                                }
                            DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 1;
                            Found = 1;
                            TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;    
                            break;  
                            } 
                        }
                                
                        if(Found==0){    
                        lcd_clear();
                        lcd_putsf(" AUKSTESNIO NUMERIO ");
                        lcd_putsf(" LAISVO TERMOMETRO  ");
                        lcd_putsf("        NERA        ");  
                        delay_ms(1000); 
                        lcd_clear();
                        }
                    }
                }

                if(RefreshLcd>=1){
                unsigned char row, lcd_row;
                lcd_row = 0;
                RowsOnWindow = 4;
                    for(row=Address[5];row<4+Address[5];row++){
                    lcd_gotoxy(0,lcd_row);
                        if(row==0){
                        lcd_putsf("-=SOLIAR. 2 TERM.=- ");
                        }
                        else if(row==1){
                        lcd_putsf("1.TEMPERAT.:");
                            if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                            char lcd_buffer[10];
                            sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[USING_TEMPERATURE_SENSOR]);
                            lcd_puts(lcd_buffer);
                            }
                            else if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2){
                            lcd_putsf("    OFF");
                            }
                            else{
                            lcd_putsf("   ----");
                            }
                        }
                        else if(row==2){
                        lcd_putsf("2.TERMOMETRO NR:");   
                            if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                            lcd_putchar(NumToIndex(ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR])+1);
                            lcd_putchar('/');
                            lcd_putchar(NumToIndex(ds18b20_devices));    
                            }
                            else{
                            lcd_putsf("-/");
                            lcd_putchar(NumToIndex(ds18b20_devices));
                            }
                        }
                    lcd_row++;
                    }

                lcd_gotoxy(19,SelectedRow-Address[5]);
                lcd_putchar('<');
                }
            }

            // 3 soliariumo temp
            else if(Address[0]==6){   
            unsigned char USING_TEMPERATURE_SENSOR=4;
                if(BUTTON[BUTTON_DOWN]==1){
                SelectAnotherRow(0);
                }
                else if(BUTTON[BUTTON_UP]==1){
                SelectAnotherRow(1);
                }
                else if(BUTTON[BUTTON_ENTER]==1){
                    if(SelectedRow==0){
                    Address[0] = 0;
                    SelectedRow = 0;
                    Address[5] = 0;
                    }
                }
                else if(BUTTON[BUTTON_LEFT]==1){
                    if((SelectedRow==1)||(SelectedRow==2)){                         
                        if((DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1)||(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2)){
                        signed char i, Found=0;
                            for(i=ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR]-1;i>=0;i--){
                            unsigned char used=0, a;
                                for(a=0;a<MAX_DS18B20_DEVICES;a++){
                                    if(DS18B20_IS_ASSIGNED[a]==1){
                                        if(ds18b20_sensor_assignation[a]==i){
                                        used = 1;
                                        break;
                                        }
                                    }    
                                }
                                        
                                if(used==0){
                                unsigned char b;
                                ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
                                    for(b=0;b<9;b++){                          
                                    DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];  
                                    }
                                Found = 1;
                                TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;    
                                break;  
                                } 
                            }
                                    
                            if(Found==0){
                            DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 0;    
                            ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = 255;
                            TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;                                
                            }
                        }
                    }
                }    
                else if(BUTTON[BUTTON_RIGHT]==1){
                    if((SelectedRow==1)||(SelectedRow==2)){
                    unsigned char i, Found=0;       
                        if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                        i = ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] + 1;
                        }
                        else{
                        i = 0; 
                        }
                                
                        for(i=i;i<ds18b20_devices;i++){
                        unsigned char used=0, a;
                            for(a=0;a<MAX_DS18B20_DEVICES;a++){
                                if(DS18B20_IS_ASSIGNED[a]==1){
                                    if(ds18b20_sensor_assignation[a]==i){
                                    used = 1;
                                    break;         
                                    }
                                }    
                            }
                                    
                            if(used==0){
                            unsigned char b;
                            ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
                                for(b=0;b<9;b++){                          
                                DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];  
                                }
                            DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 1;
                            Found = 1;
                            TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;    
                            break;  
                            } 
                        }
                                
                        if(Found==0){    
                        lcd_clear();
                        lcd_putsf(" AUKSTESNIO NUMERIO ");
                        lcd_putsf(" LAISVO TERMOMETRO  ");
                        lcd_putsf("        NERA        ");  
                        delay_ms(1000); 
                        lcd_clear();
                        }
                    }
                }

                if(RefreshLcd>=1){
                unsigned char row, lcd_row;
                lcd_row = 0;
                RowsOnWindow = 4;
                    for(row=Address[5];row<4+Address[5];row++){
                    lcd_gotoxy(0,lcd_row);
                        if(row==0){
                        lcd_putsf("-=SOLIAR. 3 TERM.=- ");
                        }
                        else if(row==1){
                        lcd_putsf("1.TEMPERAT.:");
                            if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                            char lcd_buffer[10];
                            sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[USING_TEMPERATURE_SENSOR]);
                            lcd_puts(lcd_buffer);
                            }
                            else if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2){
                            lcd_putsf("    OFF");
                            }
                            else{
                            lcd_putsf("   ----");
                            }
                        }
                        else if(row==2){
                        lcd_putsf("2.TERMOMETRO NR:");   
                            if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
                            lcd_putchar(NumToIndex(ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR])+1);
                            lcd_putchar('/');
                            lcd_putchar(NumToIndex(ds18b20_devices));    
                            }
                            else{
                            lcd_putsf("-/");
                            lcd_putchar(NumToIndex(ds18b20_devices));
                            }
                        }
                    lcd_row++;
                    }

                lcd_gotoxy(19,SelectedRow-Address[5]);
                lcd_putchar('<');
                }
            }

            // Nustatymai
            else if(Address[0]==7){
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
                    RowsOnWindow = 1;
                        for(row=Address[5];row<4+Address[5];row++){
                        lcd_gotoxy(0,lcd_row);
                            if(row==0){
                            lcd_putsf("   -=NUSTATYMAI=-   ");
                            }
                            else if(row==1){
                            lcd_putsf("NEBAIGTA");
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
                        if(lcd_light<20){
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

                    lcd_gotoxy(19,0);
                    lcd_putchar('+');
                    lcd_gotoxy(19,3);
                    lcd_putchar('-');
                    }
                }
                else if(Address[1]==2){

                }
            }
        }

        if(RefreshLcd>=1){
        RefreshLcd--;
        }
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////
    delay_ms(1);
    }
}
