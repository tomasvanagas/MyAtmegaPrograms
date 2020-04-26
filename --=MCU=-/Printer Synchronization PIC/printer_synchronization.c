#define INPUT PORTB.F4
#define OUTPUT PORTB.F7

#define LED1 PORTB.F6
#define LED2 PORTB.F1
#define LED3 PORTA.F3
#define LED4 PORTA.F2
#define LED5 PORTA.F1

#define BUTTON_UP PORTA.F0
#define BUTTON_DOWN PORTB.F2
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
    
    if(INPUT==1){

      if(InputOldState==0){
      // Atspausdinti jei nespejo atspausdinti
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
    
    
  ///////////////////////
    if(Printing>0){
    OUTPUT = 1;
    Printing--;
    }
    else{
    OUTPUT = 0;
    }
  ///////////////////////
    
    
    
        
  /////////////////////////////////////////////////////////////////////
  // Reguliavimas /////////////////////////////////////////////////////

          if(BUTTON_UP==1){
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

          if(BUTTON_DOWN==1){
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

  /////////////////////////////////////////////////////////////////////
  // Atvaizdavimas ////////////////////////////////////////////////////

          if(SetPoint<2){
          LED1 = 1;
          LED2 = 0;
          LED3 = 0;
          LED4 = 0;
          LED5 = 0;
          }
          else if(SetPoint<4){
          LED1 = 1;
          LED2 = 1;
          LED3 = 0;
          LED4 = 0;
          LED5 = 0;
          }
          else if(SetPoint<6){
          LED1 = 0;
          LED2 = 1;
          LED3 = 0;
          LED4 = 0;
          LED5 = 0;
          }
          else if(SetPoint<8){
          LED1 = 0;
          LED2 = 1;
          LED3 = 1;
          LED4 = 0;
          LED5 = 0;
          }
          else if(SetPoint<10){
          LED1 = 0;
          LED2 = 0;
          LED3 = 1;
          LED4 = 0;
          LED5 = 0;
          }
          else if(SetPoint<12){
          LED1 = 0;
          LED2 = 0;
          LED3 = 1;
          LED4 = 1;
          LED5 = 0;
          }
          else if(SetPoint<14){
          LED1 = 0;
          LED2 = 0;
          LED3 = 0;
          LED4 = 1;
          LED5 = 0;
          }
          else if(SetPoint<16){
          LED1 = 0;
          LED2 = 0;
          LED3 = 0;
          LED4 = 1;
          LED5 = 1;
          }
          else if(SetPoint<18){
          LED1 = 0;
          LED2 = 0;
          LED3 = 0;
          LED4 = 0;
          LED5 = 1;
          }

  /////////////////////////////////////////////////////////////////////
  delay_ms(1);
  }
}