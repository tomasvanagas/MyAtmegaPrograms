#line 1 "D:/TOMOSIUKS/-=CPU=-/Printer Synchronization PIC/printer_synchronization.c"
#line 12 "D:/TOMOSIUKS/-=CPU=-/Printer Synchronization PIC/printer_synchronization.c"
unsigned char OldStateButtonUp, OldStateButtonDown;

unsigned int SetPoint;


unsigned char InputOldState;
unsigned int InputWidthNow, LastInputWidth;
unsigned int OldCycleTime, CycleTimeNow;

unsigned int ThisCyclePrinted;


unsigned int PrintCycleTimeNow, VirtualPrintCycleNow, PrintingUntil;
unsigned int Printing;

void main(){
TRISA = 0b1;
TRISB = 0b10100;

PORTA = 0;
PORTB = 0;

OldStateButtonUp = 0;
OldStateButtonDown = 0;

SetPoint = 0;


InputOldState = 0;
InputWidthNow = 0;
LastInputWidth = 0;
OldCycleTime = 0;
CycleTimeNow = 0;

PrintCycleTimeNow = 0;
VirtualPrintCycleNow = 0;
PrintingUntil = 0;
Printing = 0;


 while(1){

 if(CycleTimeNow<3000){
 CycleTimeNow++;
 }

 if( PORTB.F4 ==1){

 if(InputOldState==0){

 if(ThisCyclePrinted==0){
 if(OldCycleTime>0){
 if(LastInputWidth>0){
 Printing = LastInputWidth;
 }
 }
 }
 ThisCyclePrinted = 0;

 OldCycleTime = CycleTimeNow;
 CycleTimeNow = 0;
 }
 InputOldState = 1;
 if(InputWidthNow<500){
 InputWidthNow++;
 }
 }
 else{
 if(InputWidthNow>0){
 LastInputWidth = InputWidthNow;
 InputWidthNow = 0;
 }
 InputOldState = 0;
 }

 if(ThisCyclePrinted==0){
 if(OldCycleTime>0){
 if(LastInputWidth>0){
 if(CycleTimeNow>=(OldCycleTime/18)*SetPoint){
 Printing = LastInputWidth;
 ThisCyclePrinted = 1;
 }
 }
 }
 }



 if(Printing>0){
  PORTB.F7  = 1;
 Printing--;
 }
 else{
  PORTB.F7  = 0;
 }








 if( PORTA.F0 ==1){
 if(OldStateButtonUp==0){
 OldStateButtonUp = 1;
 if(SetPoint<17){
 SetPoint++;
 }
 }
 }
 else{
 OldStateButtonUp = 0;
 }

 if( PORTB.F2 ==1){
 if(OldStateButtonDown==0){
 OldStateButtonDown = 1;
 if(SetPoint>0){
 SetPoint--;
 }
 }
 }
 else{
 OldStateButtonDown = 0;
 }




 if(SetPoint<2){
  PORTB.F6  = 1;
  PORTB.F1  = 0;
  PORTA.F3  = 0;
  PORTA.F2  = 0;
  PORTA.F1  = 0;
 }
 else if(SetPoint<4){
  PORTB.F6  = 1;
  PORTB.F1  = 1;
  PORTA.F3  = 0;
  PORTA.F2  = 0;
  PORTA.F1  = 0;
 }
 else if(SetPoint<6){
  PORTB.F6  = 0;
  PORTB.F1  = 1;
  PORTA.F3  = 0;
  PORTA.F2  = 0;
  PORTA.F1  = 0;
 }
 else if(SetPoint<8){
  PORTB.F6  = 0;
  PORTB.F1  = 1;
  PORTA.F3  = 1;
  PORTA.F2  = 0;
  PORTA.F1  = 0;
 }
 else if(SetPoint<10){
  PORTB.F6  = 0;
  PORTB.F1  = 0;
  PORTA.F3  = 1;
  PORTA.F2  = 0;
  PORTA.F1  = 0;
 }
 else if(SetPoint<12){
  PORTB.F6  = 0;
  PORTB.F1  = 0;
  PORTA.F3  = 1;
  PORTA.F2  = 1;
  PORTA.F1  = 0;
 }
 else if(SetPoint<14){
  PORTB.F6  = 0;
  PORTB.F1  = 0;
  PORTA.F3  = 0;
  PORTA.F2  = 1;
  PORTA.F1  = 0;
 }
 else if(SetPoint<16){
  PORTB.F6  = 0;
  PORTB.F1  = 0;
  PORTA.F3  = 0;
  PORTA.F2  = 1;
  PORTA.F1  = 1;
 }
 else if(SetPoint<18){
  PORTB.F6  = 0;
  PORTB.F1  = 0;
  PORTA.F3  = 0;
  PORTA.F2  = 0;
  PORTA.F1  = 1;
 }


 delay_ms(1);
 }
}
