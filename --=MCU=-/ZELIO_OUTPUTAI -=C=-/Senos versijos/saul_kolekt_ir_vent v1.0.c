char INPUTAS_1,INPUTAS_2,RELE_RESET,RELE_CLOCK,RELE_VENT,RELE_MEM,RELE,RELE_TRUMPA_CIRKUL;
char vent_sekunde,vent_sekundes,vent_minutes;
char ciklo_daliklis,ciklas,periodas;
char greitasis_rezimas;

char a;

char trump_cirk_sekunde,trump_cirk_sekundes;

void ventiliacijos_blokas();
void saul_kol_blokas();
void trumpa_cirkul();

void main(){
TRISA = 0b10;
TRISB = 0b11;

PORTA = 0;
PORTB = 0;

ciklo_daliklis = 0;
ciklas = 0;
periodas = 0;

vent_sekunde = 0;
vent_sekundes = 0;
vent_minutes = 0;

trump_cirk_sekunde = 0;
trump_cirk_sekundes = 0;

// RELE 1               PORTB.F5    (RELE_RESET)
// RELE 2               PORTB.F6    (RELE_CLOCK)
// RELE 3               PORTB.F7    (RELE_TRUMPA_CIRKUL)
// RELE 4               PORTA.F0    (RELE_VENT)
// MEMORIZACIJOS RELE   PORTB.F4    (MEM)

// IEJIMAS              PORTA.F1    (VENT_INPUT)

  while(1){
  ventiliacijos_blokas();
  saul_kol_blokas();
  trumpa_cirkul();

  Delay_ms(10);
  }
  
}

void ventiliacijos_blokas(){

  {if((PORTA.F1==1)&&(a==0)){
  INPUTAS_2 = 1;                      //MYGTUKAS
  a = 1;
  }
  else
  INPUTAS_2 = 0;
  }
  
  if(PORTA.F1==0){
  a = 0;
  }
  
  
  if(INPUTAS_2==1){
    {if((vent_sekunde!=0)||(vent_sekundes!=0)||(vent_minutes!=0)){
    vent_sekunde = 0;
    vent_sekundes = 0;
    vent_minutes = 0;
    }
    else
    vent_minutes = 60;
    vent_sekundes = 0;
    vent_sekunde = 0;
    }
  }

  if((vent_sekunde!=0)||(vent_sekundes!=0)||(vent_minutes!=0)){
  vent_sekunde = vent_sekunde - 1;
  RELE_VENT = 1;
  }
  if(vent_sekunde<=-1){
  vent_sekunde = 99;
  vent_sekundes = vent_sekundes - 1;
  }
  if(vent_sekundes<=-1){
  vent_sekundes = 59;
  vent_minutes = vent_minutes - 1;
  }



  {if(RELE_VENT==1){                          // OUTPUTAS
  PORTA.F0 = 1;
  }
  else
  PORTA.F0 = 0;
  }
  RELE_VENT = 0;
}


void saul_kol_blokas(){

ciklo_daliklis = ciklo_daliklis + 1;
  if(ciklo_daliklis==60){            // 60*10 (ms) ciklas
  ciklo_daliklis = 0;
  ciklas = ciklas + 1;
  }
  if(ciklas==5){
  ciklas = 0;
  periodas = periodas + 1;
  }
  if(periodas==12){
  periodas = 0;
  }


  if(ciklas==0){
    {if(periodas==0){
    RELE_RESET = 1;
    }
    else
    RELE_CLOCK = 1;
    }
  }
  if(ciklas==3){
  RELE_MEM = 1;
  }


  {if(RELE_RESET==1){                 //OUTPUTAI
  PORTB.F5 = 1;
  }
  else
  PORTB.F5 = 0;
  }
  RELE_RESET = 0;
  
  {if(RELE_MEM==1){
  PORTB.F4 = 1;
  }
  else
  PORTB.F4 = 0;
  }
  RELE_MEM = 0;
  
  {if(RELE_CLOCK==1){
  PORTB.F6 = 1;
  }
  else
  PORTB.F6 = 0;
  }
  RELE_CLOCK = 0;
}

void trumpa_cirkul(){
trump_cirk_sekunde = trump_cirk_sekunde + 1;
  if(trump_cirk_sekunde==100){
  trump_cirk_sekunde = 0;
  trump_cirk_sekundes = trump_cirk_sekundes + 1;
  }
  if(trump_cirk_sekundes==35){
  trump_cirk_sekundes = 0;
  }
  
  if(trump_cirk_sekundes>=29){
  RELE_TRUMPA_CIRKUL = 1;
  }
  
  
  {if(RELE_TRUMPA_CIRKUL==1){
  PORTB.F7 = 1;
  }
  else
  PORTB.F7 = 0;
  }
}

