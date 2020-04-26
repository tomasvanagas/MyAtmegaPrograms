char INPUTAS_1,INPUTAS_2,RELE_RESET,RELE_CLOCK,RELE_VENT,RELE_MEM,RELE,RELE_TRUMPA_CIRKUL;
char periodas;
unsigned int ciklas;

char trump_cirk_sekunde,trump_cirk_sekundes;

void saul_kol_blokas();
void trumpa_cirkul();

void main(){
TRISA = 0b10;
TRISB = 0b11;

PORTA = 0;
PORTB = 0;

ciklas = 0;
periodas = 0;


trump_cirk_sekunde = 0;
trump_cirk_sekundes = 0;

// MEMORIZACIJOS RELE   PORTB.F4    (MEM)
// RELE 1               PORTB.F5    (RELE_RESET)
// RELE 2               PORTB.F6    (RELE_CLOCK)
// RELE 3               PORTB.F7    (RELE_TRUMPA_CIRKUL)
// RELE 4               PORTA.F0    (NEPANAUDOTA_RELE)

// IEJIMAS              PORTA.F1    (NEPANAUDOTAS_INPUT)

  while(1){
  saul_kol_blokas();
  trumpa_cirkul();
  
  Delay_ms(10);
  }
  
}

void saul_kol_blokas(){
ciklas = ciklas + 1;

////////////////////////////////////////////////////////////////
  if(ciklas>=490){                  // 490 * 10(ms) = 4.9 sec ((1 PERIODAS))
  ciklas = 0;
  periodas = periodas + 1;
  }

  if(periodas==12){
  periodas = 0;
  }

  if((ciklas>=0)&&(ciklas<60)){  //NUO 0(ms) IKI 600(ms)
    {if(periodas==0){
    RELE_RESET = 1;
    }
    else
    RELE_CLOCK = 1;
    }
  }
  if((ciklas>=420)&&(ciklas<480)){//NUO 4200(ms) IKI 4800(ms)
  RELE_MEM = 1;
  }
////////////////////////////////////////////////////////////////

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
  RELE_TRUMPA_CIRKUL = 0;
  }
  
}

