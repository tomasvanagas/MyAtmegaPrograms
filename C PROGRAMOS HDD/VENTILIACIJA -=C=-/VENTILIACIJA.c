void VentPrograma();
unsigned long Timer1,Timer1_End;
unsigned char Timer2,Timer2_End;
char INPUT_FILTER;


void KasSecDiodasOn();
unsigned char Timer3;


void main(){
TRISA = 0b0;
TRISB = 0b10;
PORTA = 0;
PORTB = 0;

///////////////////////////////////////////////////////////////////////////
Timer1_End = 60; // Ventiliacijos laikas minutemis (x * 1min)
Timer2_End = 10; // Ventiliacijos paleidimo/isjungimo uzlaikymas (x * 10ms)
///////////////////////////////////////////////////////////////////////////



/*
VENTILIACIJOS PALEIDIMO/ISJUNGIMO IEJIMAS - PORTB.F1
VENTILIACIJOS ISEJIMAS -                    PORTB.F2
VIRSUTINIS PAPILDOMAS  DIODAS -             PORTB.F3
APATINIS PAPILDOMAS DIODAS -                PORTB.F4
*/


Timer1_End = Timer1_End * 60 * 100;
Timer1 = Timer1_End;
     while(1){
     VentPrograma();
     KasSecDiodasOn();
     Delay_ms(10);
     }
}



void VentPrograma(){
        if(PORTB.F1==1){
             if(Timer2>=Timer2_End){
                  if(INPUT_FILTER==0){
                  INPUT_FILTER = 1;
                       if(Timer1>=Timer1_End){
                       Timer1 = 0;
                       }
                       else{
                       Timer1 = Timer1_End;
                       }
                  }
             }
             else{
             Timer2 = Timer2 + 1;
             }
        }
        else{
        INPUT_FILTER = 0;
        Timer2 = 0;
        }


        if(Timer1<Timer1_End){
        Timer1 = Timer1 + 1;
        PORTB.F2 = 1;
        }
        else{
        PORTB.F2 = 0;
        }
     }
     
     
void KasSecDiodasOn(){
        if(Timer3==200){
        Timer3 = 0;
        }
     Timer3++;
     
        if(Timer3<100){
        PORTB.F4 = 0;
        }
        
        if(Timer3>=100){
        PORTB.F4 = 1;
        }
     }