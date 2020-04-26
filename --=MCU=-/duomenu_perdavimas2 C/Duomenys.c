#include <mega16.h>

char MasterSendsData(Address, Size, Data[]){
unsigned int i, g;
char databits[Size][10];
char AddressBits[10];
//////////////// Address ////////////////
char AddressBuffer = Address;  
// 9
    if(AddressBuffer>=512){
    AddressBits[i][9] = 1;
    AddressBuffer = AddressBuffer - 512;
    }
// 8
    if(AddressBuffer>=256){
    AddressBits[i][8] = 1;
    AddressBuffer = AddressBuffer - 256;
    }  
// 7
    if(AddressBuffer>=128){
    AddressBits[i][7] = 1;
    AddressBuffer = AddressBuffer - 128;
    }
// 6
    if(AddressBuffer>=64){
    AddressBits[i][6] = 1;
    AddressBuffer = AddressBuffer - 64;
    }
// 5
    if(AddressBuffer>=32){
    AddressBits[i][5] = 1;
    AddressBuffer = AddressBuffer - 32;
    }
// 4
    if(AddressBuffer>=16){
    AddressBits[i][4] = 1;
    AddressBuffer = AddressBuffer - 16;
    } 
// 3
    if(AddressBuffer>=8){
    AddressBits[i][3] = 1;
    AddressBuffer = AddressBuffer - 8;
    }
// 2
    if(AddressBuffer>=4){
    AddressBits[i][2] = 1;
    AddressBuffer = AddressBuffer - 4;
    }
// 1
    if(AddressBuffer>=2){
    AddressBits[i][1] = 1;
    AddressBuffer = AddressBuffer - 2;
    }
// 0
    if(AddressBuffer>=1){
    AddressBits[i][0] = 1;
    AddressBuffer = AddressBuffer - 1;
    }
/////////////////////////////////////////
///////////////// Data //////////////////  
    for(i;i<Size;i++){
    unsigned int SEND_BUFFER = Data[i];  
    // 9
        if(SEND_BUFFER>=512){
        databits[i][9] = 1;
        SEND_BUFFER = SEND_BUFFER - 512;
        }
    // 8
        if(SEND_BUFFER>=256){
        databits[i][8] = 1;
        SEND_BUFFER = SEND_BUFFER - 256;
        }  
    // 7
        if(SEND_BUFFER>=128){
        databits[i][7] = 1;
        SEND_BUFFER = SEND_BUFFER - 128;
        }
    // 6
        if(SEND_BUFFER>=64){
        databits[i][6] = 1;
        SEND_BUFFER = SEND_BUFFER - 64;
        }
    // 5
        if(SEND_BUFFER>=32){
        databits[i][5] = 1;
        SEND_BUFFER = SEND_BUFFER - 32;
        }
    // 4
        if(SEND_BUFFER>=16){
        databits[i][4] = 1;
        SEND_BUFFER = SEND_BUFFER - 16;
        } 
    // 3
        if(SEND_BUFFER>=8){
        databits[i][3] = 1;
        SEND_BUFFER = SEND_BUFFER - 8;
        }
    // 2
        if(SEND_BUFFER>=4){
        databits[i][2] = 1;
        SEND_BUFFER = SEND_BUFFER - 4;
        }
    // 1
        if(SEND_BUFFER>=2){
        databits[i][1] = 1;
        SEND_BUFFER = SEND_BUFFER - 2;
        }
    // 0
        if(SEND_BUFFER>=1){
        databits[i][0] = 1;
        SEND_BUFFER = SEND_BUFFER - 1;
        }           
    }
/////////////////////////////////////////

// Reset
i = 0;
PORTD.2 = 1;    
delay_us(5);
PORTD.2 = 0;        

// Address
i = 0;
g = 0;
    for(i;i<10;i++){
        if(AddressBits[i]==1){PORTD.1 = 1;}    
    delay_us(5);    
    PORTD.1 = 0;
    }

i = 0;
    while(PIND.0==1){
    i++;
        if(i>=50){return 0;}
    delay_us(1);
    }
i = 0;

// Data
i = 0;
    for(i;i<Size;i++){
        if(databits[i]==1){
        PORTD.1 = 1;
            while(PIND.0);
        PORTD.1 = 0;
        }
    }
// 






    
    
}           





















// Declare your global variables here
unsigned int RX_BUFFER[8], TX_BUFFER[8];
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
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0b11111111;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=T 
PORTD=0x00;
DDRD=0b00000010;

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
    if(PINC.0==1){
    unsigned int Timer1, Timer2;
    DDRD.2 = 1;  
        while(1){// MASTER
        /////// CLOCK ///////        
            if(Timer1==0){
            PORTD.2 = 0; 
            }
            if(Timer1==10){
            PORTD.2 = 1;
            }
            if(Timer1==15){
            Timer1 = 0;
            }
        Timer1++;
        /////////////////////

            if(Timer2==20000){
            SendDataTo(Address,TX_BUFFER);
            
            char i;
            char databits[8][10];  
                for(i;i<8;i++){
                tx_buffer2 = TX_BUFFER[i];  
                // 9
                    if(tx_buffer2>=512){
                    databits[i][9] = 1;
                    tx_buffer2 = tx_buffer - 512;
                    }
                // 8
                    if(tx_buffer2>=256){
                    databits[i][8] = 1;
                    tx_buffer2 = tx_buffer - 256;
                    }  
                // 7
                    if(tx_buffer2>=128){
                    databits[i][7] = 1;
                    tx_buffer2 = tx_buffer - 128;
                    }
                // 6
                    if(tx_buffer2>=64){
                    databits[i][6] = 1;
                    tx_buffer2 = tx_buffer - 64;
                    }
                // 5
                    if(tx_buffer2>=32){
                    databits[i][5] = 1;
                    tx_buffer2 = tx_buffer - 32;
                    }
                // 4
                    if(tx_buffer2>=16){
                    databits[i][4] = 1;
                    tx_buffer2 = tx_buffer - 16;
                    } 
                // 3
                    if(tx_buffer2>=8){
                    databits[i][3] = 1;
                    tx_buffer2 = tx_buffer - 8;
                    }
                // 2
                    if(tx_buffer2>=4){
                    databits[i][2] = 1;
                    tx_buffer2 = tx_buffer - 4;
                    }
                // 1
                    if(tx_buffer2>=2){
                    databits[i][1] = 1;
                    tx_buffer2 = tx_buffer - 2;
                    }
                // 0
                    if(tx_buffer2>=1){
                    databits[i][0] = 1;
                    tx_buffer2 = tx_buffer - 1;
                    }





                    
                Timer2 = 0;
                }
            }

        Timer2++; 
        }
    }
    else{
    DDRD.2 = 0;
        while(1){// SLAVE







                  
        }
    }
}

















































































/* 

Veikiantis per USART

#include <mega16.h>
#include <delay.h>

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE<256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index];
   if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

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
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

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

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 56000 (2x)
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x11;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/16k
#pragma optsize-
WDTCR=0x18;
WDTCR=0x08;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Global enable interrupts
#asm("sei")

    while (1){
    ////////////////////////////////////////
        if(PINA.0==1){
        putchar('1');
        }
        else{
        putchar('0');
        }
        
        if(PINA.1==1){
        putchar('1');
        }
        else{
        putchar('0');
        }
        
        if(PINA.2==1){
        putchar('1');
        }
        else{
        putchar('0');
        }
        
        if(PINA.3==1){
        putchar('1');
        }
        else{
        putchar('0');
        }
        
        if(PINA.4==1){
        putchar('1');
        }
        else{
        putchar('0');
        }
        
        if(PINA.5==1){
        putchar('1');
        }
        else{
        putchar('0');
        }
        
        if(PINA.6==1){
        putchar('1');
        }
        else{
        putchar('0');
        }
        
        if(PINA.7==1){
        putchar('1');
        }
        else{
        putchar('0');
        }
    ////////////////////////////////////////
        if(rx_buffer[0]=='1'){
        PORTB.7 = 1;
        }
        else{
        PORTB.7 = 0;
        }
        
        if(rx_buffer[1]=='1'){
        PORTB.6 = 1;
        }
        else{
        PORTB.6 = 0;
        }
        
        if(rx_buffer[2]=='1'){
        PORTB.5 = 1;
        }
        else{
        PORTB.5 = 0;
        }
        
        if(rx_buffer[3]=='1'){
        PORTB.4 = 1;
        }
        else{
        PORTB.4 = 0;
        }
        
        if(rx_buffer[4]=='1'){
        PORTB.3 = 1;
        }
        else{
        PORTB.3 = 0;
        }
        
        if(rx_buffer[5]=='1'){
        PORTB.2 = 1;
        }
        else{
        PORTB.2 = 0;
        }
        
        if(rx_buffer[6]=='1'){
        PORTB.1 = 1;
        }
        else{
        PORTB.1 = 0;
        }
        
        if(rx_buffer[7]=='1'){
        PORTB.0 = 1;
        }
        else{
        PORTB.0 = 0;
        }
    // Rx    
    //rx_wr_index = 7;
    //rx_rd_index = 7;
    //rx_counter = 7;
      
    // Tx
    //tx_wr_index = 0;
    //tx_rd_index = 0;
    //tx_counter = 0;   
       
    delay_ms(1);        
    ////////////////////////////////////////
    
    }
}*/