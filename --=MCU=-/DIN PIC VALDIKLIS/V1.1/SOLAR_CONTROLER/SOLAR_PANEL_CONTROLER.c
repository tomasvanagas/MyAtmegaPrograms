// INPUTS
#define INPUT1 PORTA.F2
#define INPUT2 PORTA.F3
#define INPUT3 PORTB.F1
#define INPUT4 PORTA.F1
#define INPUT5 PORTA.F0

// OUTPUTS
#define OUTPUT1 PORTB.F3
#define OUTPUT2 PORTB.F2
#define OUTPUT3 PORTB.F6
#define OUTPUT4 PORTB.F5
#define OUTPUT5 PORTB.F4



// Switching  Module
#define SwitchingOn INPUT1
#define SwitchingBypass INPUT2
#define SwitchingRelay1 OUTPUT1
#define SwitchingRelay2 OUTPUT2

#define SwitchingWorkTime 60  // Seconds
#define SwitchingExchangeTime 60 // Seconds



// Time Relay Module
#define TimeRelayInput INPUT3
#define TimeRelayOutput OUTPUT3

#define TimeRelayTime 10000 // Miliseconds



void TimeRelay();
void SwithingProcedure();


void main() {
TRISA = 0b00001111;
TRISB = 0b00000010;
PORTA = 0;
PORTB = 0;

     while(1){
     SwithingProcedure();
     TimeRelay();
     Delay_us(940);
     }
}


void SwithingProcedure(void){
static unsigned char SwitchingWorkingRelay;
static unsigned int SwitchingWorkMscnd, SwitchingWorkScd;
static unsigned int SwitchingExchangeMscnd, SwitchingExchangeScd;

     if(SwitchingOn==1){
          if(SwitchingBypass==0){
               if(SwitchingWorkScd<SwitchingWorkTime){
               SwitchingWorkMscnd++;
                    if(SwitchingWorkMscnd>1000){
                    SwitchingWorkMscnd = 0;
                    SwitchingWorkScd++;
                    }
                    
                    if(SwitchingWorkingRelay==0){
                    SwitchingRelay1 = 1;
                    SwitchingRelay2 = 0;
                    }
                    else{
                    SwitchingRelay1 = 0;
                    SwitchingRelay2 = 1;
                    }
                    
               }
               else{
               SwitchingRelay1 = 1;
               SwitchingRelay2 = 1;
               
               SwitchingExchangeMscnd++;
                    if(SwitchingExchangeMscnd>1000){
                    SwitchingExchangeMscnd = 0;
                    SwitchingExchangeScd++;
                    }
                    
                    if(SwitchingExchangeScd>=SwitchingExchangeTime){
                    SwitchingWorkMscnd = 0;
                    SwitchingWorkScd = 0;
                    
                    SwitchingExchangeMscnd = 0;
                    SwitchingExchangeScd = 0;
                         if(SwitchingWorkingRelay==0){
                         SwitchingWorkingRelay = 1;
                         }
                         else{
                         SwitchingWorkingRelay = 0;
                         }
                    }
               }
          }
          else{
          SwitchingRelay1 = 1;
          SwitchingRelay2 = 1;
          }
     }
     else{
     SwitchingRelay1 = 0;
     SwitchingRelay2 = 0;
     }
}









void TimeRelay(void){
static unsigned int TimeRelayCounter;

       if(TimeRelayInput==1){
       TimeRelayCounter = TimeRelayTime;
       }

       if(TimeRelayCounter>0){
       TimeRelayCounter--;
       TimeRelayOutput = 1;
       }
       else{
       TimeRelayOutput = 0;
       }
}

