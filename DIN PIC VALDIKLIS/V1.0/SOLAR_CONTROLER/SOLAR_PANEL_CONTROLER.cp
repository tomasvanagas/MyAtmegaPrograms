#line 1 "G:/-=CPU=-/DIN PIC VALDIKLIS/SOLAR_CONTROLER/SOLAR_PANEL_CONTROLER.c"
#line 36 "G:/-=CPU=-/DIN PIC VALDIKLIS/SOLAR_CONTROLER/SOLAR_PANEL_CONTROLER.c"
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

 if( PORTA.F2 ==1){
 if( PORTA.F3 ==0){
 if(SwitchingWorkScd< 60 ){
 SwitchingWorkMscnd++;
 if(SwitchingWorkMscnd>1000){
 SwitchingWorkMscnd = 0;
 SwitchingWorkScd++;
 }

 if(SwitchingWorkingRelay==0){
  PORTB.F3  = 1;
  PORTB.F2  = 0;
 }
 else{
  PORTB.F3  = 0;
  PORTB.F2  = 1;
 }

 }
 else{
  PORTB.F3  = 1;
  PORTB.F2  = 1;

 SwitchingExchangeMscnd++;
 if(SwitchingExchangeMscnd>1000){
 SwitchingExchangeMscnd = 0;
 SwitchingExchangeScd++;
 }

 if(SwitchingExchangeScd>= 60 ){
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
  PORTB.F3  = 1;
  PORTB.F2  = 1;
 }
 }
 else{
  PORTB.F3  = 0;
  PORTB.F2  = 0;
 }
}

void TimeRelay(void){
static unsigned int TimeRelayCounter;

 if( PORTB.F1 ==1){
 TimeRelayCounter =  10000 ;
 }

 if(TimeRelayCounter>0){
 TimeRelayCounter--;
  PORTB.F6  = 1;
 }
 else{
  PORTB.F6  = 0;
 }
}
