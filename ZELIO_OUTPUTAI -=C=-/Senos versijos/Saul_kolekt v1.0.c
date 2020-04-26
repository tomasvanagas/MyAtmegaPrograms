char i;
void main(){
TRISA = 0b10;
TRISB = 0;

PORTA = 0;
PORTB = 0;

// RELE 1               PORTB.F5    (RESET)
// RELE 2               PORTB.F6    (CLOCK)
// RELE 3               PORTB.F7    (nepanaudota)
// RELE 4               PORTA.F0    (nepanaudota)
// MEMORIZACIJOS RELE   PORTB.F4    (MEM)

// IEJIMAS              PORTA.F1    (IN)

  while(1){
    {if(PORTA.F1==0){
    i = 0;
      while(i<=10){
        {if(i==0){
        PORTA.F5 = 1;Delay_ms(1200);PORTA.F5 = 0;      //RESET
        Delay_ms(2400);
        PORTB.F4 = 1;Delay_ms(1200);PORTB.F4 = 0;      //MEM
        Delay_ms(2400);}
        else
        PORTB.F6 = 1;Delay_ms(1200);PORTB.F6 = 0;      //CLOCK
        Delay_ms(2400);
        PORTB.F4 = 1;Delay_ms(1200);PORTB.F4 = 0;      //MEM
        Delay_ms(1200);
        }
      i = i + 1;
      }
    }
    else
    i = 0;
      while(i<=10){
        {if(i==0){
        PORTA.F5 = 1;Delay_ms(600);PORTA.F5 = 0;      //RESET
        Delay_ms(1200);
        PORTB.F4 = 1;Delay_ms(600);PORTB.F4 = 0;      //MEM
        Delay_ms(600);}
        else
        PORTB.F6 = 1;Delay_ms(600);PORTB.F6 = 0;      //CLOCK
        Delay_ms(1200);
        PORTB.F4 = 1;Delay_ms(600);PORTB.F4 = 0;      //MEM
        Delay_ms(600);
        }
      i = i + 1;
      }
    }
  }
}