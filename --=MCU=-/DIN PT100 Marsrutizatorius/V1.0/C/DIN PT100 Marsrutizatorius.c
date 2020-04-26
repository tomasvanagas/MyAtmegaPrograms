////////////// TEMPERATURE ROUTER //////////////
void TEMPERATURE_ROUTER_INIT();
void TEMPERATURE_ROUTER();

// Inputs, outputs
#define BEAM_SELECTION_INPUT  PORTB.F3

#define OUTPUT_MEMORIZATION   PORTA.F1
#define OUTPUT_RESET          PORTA.F0
#define OUTPUT_CLOCK          PORTA.F2
#define OUTPUT_UNUSED         PORTA.F3

#define TEMPERATURE_CHOICE_A  PORTB.F1
#define TEMPERATURE_CHOICE_B  PORTB.F5
#define TEMPERATURE_CHOICE_C  PORTB.F6
#define TEMPERATURE_CHOICE_D1 PORTB.F2
#define TEMPERATURE_CHOICE_D2 PORTB.F4

// Times
#define TEMPERATURE_CYCLE_TIME  5000

#define TEMPERATURE_MEM_START   4200
#define TEMPERATURE_MEM_END     4800

#define TEMPERATURE_CLOCK_START 0
#define TEMPERATURE_CLOCK_END   600

#define TEMPERATURE_RESET_START 0
#define TEMPERATURE_RESET_END   600


// Variables
char BEAM_SELECTION;
int TEMPERATURE_TIMER;
char TEMPERATURE_POSITION;
////////////////////////////////////////////////


void main(){
TRISA = 0b00000000;
TRISB = 0b00001000;

PORTA = 0;
PORTB = 0;
TEMPERATURE_ROUTER_INIT();
  while(1){
  TEMPERATURE_ROUTER();
  delay_ms(1);
  }
}

////////////////////////////////////////////////////////////////////////////
//////////////////////////// TEMPERATURE ROUTER ////////////////////////////
////////////////////////////////////////////////////////////////////////////
void TEMPERATURE_ROUTER_INIT(){
BEAM_SELECTION = BEAM_SELECTION_INPUT;
TEMPERATURE_TIMER = 0;
TEMPERATURE_POSITION = 0;
}
////////////////////////////////////////////////////////////////////////////
void TEMPERATURE_ROUTER(){

     if(TEMPERATURE_POSITION==0){        //OUTPUT 1
     TEMPERATURE_CHOICE_A = 1;TEMPERATURE_CHOICE_B = 0;TEMPERATURE_CHOICE_C = 0;
     }
     else if(TEMPERATURE_POSITION==1){   //OUTPUT 5
     TEMPERATURE_CHOICE_A = 1;TEMPERATURE_CHOICE_B = 0;TEMPERATURE_CHOICE_C = 1;
     }
     else if(TEMPERATURE_POSITION==2){   //OUTPUT 4
     TEMPERATURE_CHOICE_A = 0;TEMPERATURE_CHOICE_B = 0;TEMPERATURE_CHOICE_C = 1;
     }
     else if(TEMPERATURE_POSITION==3){   //OUTPUT 6
     TEMPERATURE_CHOICE_A = 0;TEMPERATURE_CHOICE_B = 1;TEMPERATURE_CHOICE_C = 1;
     }
     else if(TEMPERATURE_POSITION==4){   //OUTPUT 3
     TEMPERATURE_CHOICE_A = 1;TEMPERATURE_CHOICE_B = 1;TEMPERATURE_CHOICE_C = 0;
     }
     else if(TEMPERATURE_POSITION==5){   //OUTPUT 2
     TEMPERATURE_CHOICE_A = 0;TEMPERATURE_CHOICE_B = 1;TEMPERATURE_CHOICE_C = 0;
     }
     else if(TEMPERATURE_POSITION==6){   //OUTPUT 1
     TEMPERATURE_CHOICE_A = 1;TEMPERATURE_CHOICE_B = 0;TEMPERATURE_CHOICE_C = 0;
     }
     else if(TEMPERATURE_POSITION==7){   //OUTPUT 5
     TEMPERATURE_CHOICE_A = 1;TEMPERATURE_CHOICE_B = 0;TEMPERATURE_CHOICE_C = 1;
     }
     else if(TEMPERATURE_POSITION==8){   //OUTPUT 4
     TEMPERATURE_CHOICE_A = 0;TEMPERATURE_CHOICE_B = 0;TEMPERATURE_CHOICE_C = 1;
     }
     else if(TEMPERATURE_POSITION==9){   //OUTPUT 6
     TEMPERATURE_CHOICE_A = 0;TEMPERATURE_CHOICE_B = 1;TEMPERATURE_CHOICE_C = 1;
     }
     else if(TEMPERATURE_POSITION==10){  //OUTPUT 3
     TEMPERATURE_CHOICE_A = 1;TEMPERATURE_CHOICE_B = 1;TEMPERATURE_CHOICE_C = 0;
     }
     else if(TEMPERATURE_POSITION==11){  //OUTPUT 2
     TEMPERATURE_CHOICE_A = 0;TEMPERATURE_CHOICE_B = 1;TEMPERATURE_CHOICE_C = 0;
     }


     if(BEAM_SELECTION==0){
          if(TEMPERATURE_POSITION<6){
          TEMPERATURE_CHOICE_D1 = 0;
          TEMPERATURE_CHOICE_D2 = 1;
          }
          else{
          TEMPERATURE_CHOICE_D1 = 1;
          TEMPERATURE_CHOICE_D2 = 0;
          }
     }
     else{
     TEMPERATURE_CHOICE_D1 = 0;
     TEMPERATURE_CHOICE_D2 = 0;
     }


// Memorization
     if(TEMPERATURE_TIMER==TEMPERATURE_MEM_START){
     OUTPUT_MEMORIZATION = 1;
     }
     if(TEMPERATURE_TIMER==TEMPERATURE_MEM_END){
     OUTPUT_MEMORIZATION = 0;
     }

// CLOCK, RESET
     if(TEMPERATURE_POSITION==0){
          if(TEMPERATURE_TIMER==TEMPERATURE_RESET_START){
          OUTPUT_RESET = 1;
          }
          if(TEMPERATURE_TIMER==TEMPERATURE_RESET_END){
          OUTPUT_RESET = 0;
          }
     }
     else{
          if(TEMPERATURE_TIMER==TEMPERATURE_CLOCK_START){
          OUTPUT_CLOCK = 1;
          }
          if(TEMPERATURE_TIMER==TEMPERATURE_CLOCK_END){
          OUTPUT_CLOCK = 0;
          }
     }

// POSITION
TEMPERATURE_TIMER++;
     if(TEMPERATURE_TIMER>=TEMPERATURE_CYCLE_TIME){
     TEMPERATURE_TIMER = 0;
     TEMPERATURE_POSITION++;
          if(BEAM_SELECTION==0){
               if(TEMPERATURE_POSITION>12-1){
               TEMPERATURE_POSITION = 0;
               }
          }
          else{
               if(TEMPERATURE_POSITION>6-1){
               TEMPERATURE_POSITION = 0;
               }
          }
     }
     
     
}
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////