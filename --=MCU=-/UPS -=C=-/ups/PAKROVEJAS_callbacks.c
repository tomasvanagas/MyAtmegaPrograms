/*****************************************************
Author  : TOMAS

Chip type               : Atmega16
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
Version                 : v2.0
*****************************************************/
//////////////////////////////////////////////////////////////////////////
//////////////////////////////Includes////////////////////////////////////
#include <mega16.h>
#include <delay.h>
//////////////////////////////////////////////////////////////////////////
//////////////////////////////Defines/////////////////////////////////////
#define MIN_DCHR_HOURS 2


#define TIME_DCHR-BEEPER_SEC 10
#define BEEPER_DURATION_TIME_SEC 1


#define START_CHARGE_BUTTON 1
#define CHARGE_BUTTON_TIME_SEC 0

#define END_ACTION_BUTTON 2
#define END_ACTION_FOULT_SEC 0
#define END_ACTION_DCHR_SEC 0
#define END_ACTION_CHAR_SEC 0

#define START_DISCHARGE_BUTTON 3
#define START_DCHR_TIME_SEC 0

#define SHOW_LAST_DCHR_TIME 4
//////////////////////////////////////////////////////////////////////////
/////////////////////////////Callbacks////////////////////////////////////
    char OnButtonPress(char Button[3]){       
        if((Button[0]==1)&&(Button[1]==0)&&(Button[2]==0)&&(Button[3]==0)){
        
        
    return 1;
    }  
 

    char OnBeeperStarts(){
    return 1;
    }
    char OnBeeperDuration(){
    return 1;
    }
    char OnBeeperEnds(){
    return 1;
    }








   
    char OnChargeStarts(char StartType){
    /*  START TYPES
    StartType = 0 ->
    StartType = 1 ->
    StartType = 2 ->
    StartType = 3 ->
    */
    return 1;
    }  
    char OnChargeModeStarts(){
    return 1;
    }
    char OnChargeModeEnds(){
    return 1;
    }
    char OnLoadModeStarts(){
    return 1;
    }
    char OnLoadModeEnds(){
    return 1;
    }
    char OnChargeEnds(char EndType){
    /*  END TYPES
    EndType = 0 ->
    EndType = 1 ->
    EndType = 2 ->
    EndType = 3 ->
    */
    return 1;
    }
 














   
    char OnDischargeStarts(char StartType){
    /*  START TYPES
    StartType = 0 ->
    StartType = 1 ->
    StartType = 2 ->
    StartType = 3 ->
    */
    return 1;
    } 
    char OnDischargeDuration(char hours, char minutes){
    return 1;
    }
    char OnDischargeEnds(char ExitType, char hours, char minutes){
    /*  END TYPES
    EndType = 0 ->
    EndType = 1 ->
    EndType = 2 ->
    EndType = 3 ->
    */
    return 1;
    }   
     
    
    
    
    
    
    
    
   
    char OnDischargeSkipStarts(){
    return 1;
    }
    char OnDischargeSkipDuration(){
    return 1;
    }
    char OnDischargeSkipEnds(){
    return 1;
    } 
//////////////////////////////////////////////////////////////////////////
//////////////////////////Functions///////////////////////////////////////
    char SetDisplay(char string[15], char duty){ 






    return 1;
    }
    
    char SetChargingAuto(char type){

    return 1;
    }
    char SetChargingManual(char type){

    return 1;
    }
    
    char SetDishargingAuto(char type){

    return 1;
    }
    char SetDishargingManual(char type){

    return 1;
    } 
    
    
    
    
    
    

/////////////////////////////Script END///////////////////////////////////





































































//////////////////////COMMON PROGRAM ZONE//////////////////////////////////
void Display(){




}

void Outputs(){




}






void main(void){

/*unsigned int  e, f,c, RAIDE, ISK_PRA_UZL; // UZLAIKYMO ir t.t kintamieji

char OSC; //EKRANO DAZNIS

char MYGTUKAS_1, MYGTUKAS_2, MYGTUKAS_3,MYGTUKAS_4; // MYGTUKAI

unsigned int  viena_minute, minutes, desimtys_minutes,
valandos, desimtys_valandos;//PASKUTINIO ISKROVIMO LAIKAS

unsigned int viena_minute2, minutes2, valandos2;

char segm_a, segm_b, segm_c, segm_d, segm_e, segm_f, 
segm_g,segm_h;   // SEGMENTAI

char ISKROVIMAS, KRAUTI, krovimas, LOAD,BEEPER_OFF, FOULT, 
ISKROVIMO_PRALEIDIMAS, PENKIOS_VALANDOS_PRAEJO; // PADETYS

char ZALIAS, RAUDONAS, GELTONAS; // INDIKATORIAUS SPALVOS

unsigned int trisdesimt_sekundziu; // KROVIMO IR LOAD SUDETAS LAIKAS

unsigned int sesios_sekundes,
taskelio_sekunde;//BEGANCIO TASKELIO LAIKAS

unsigned int foult_laikas, foult_periodas;//begancio foulto laikas

unsigned int DVI_SEKUNDES, VIENA_SEKUNDE, KETURIOS_SEKUNDES,
DESIMT_SEKUNDZIU, VIENUOLIKA_SEKUNDZIU, TRISDESIMT_SEKUNDZIU,
VIENA_MINUTE, PUSE_SEKUNDES; //KONSTANTOS */


// Crystal Oscillator division factor: 1


DDRA=0b11010000;
DDRB=0b00;
DDRC=0b11111111;
DDRD=0b11111100;



/*VIENA_SEKUNDE = 1000; //viena sekunde:
DVI_SEKUNDES = 2*VIENA_SEKUNDE;
KETURIOS_SEKUNDES = 4*VIENA_SEKUNDE;
VIENA_MINUTE = 60*VIENA_SEKUNDE;
DESIMT_SEKUNDZIU = 10*VIENA_SEKUNDE;
VIENUOLIKA_SEKUNDZIU = 11*VIENA_SEKUNDE;
TRISDESIMT_SEKUNDZIU = 30*VIENA_SEKUNDE;
PUSE_SEKUNDES = VIENA_SEKUNDE/2;    

krovimas = 1;  */



char Status;
/*Status = 0; - nieko
Status = 1; - krovimas
Status = 2; - apkrova
Status = 3; - iskrovimas*/

char ChargeStartType;
/*ChargeStartType = 0; - automatinis
ChargeStartType = 1; - rankinis*/

char ChargeEndType;
/*ChargeEndType = 0; - automatinis
ChargeEndType = 1; - rankinis*/

char DischargeStartType;
/*DischargeStartType = 0; automatinis
DischargeStartType = 1; rankinis*/

char DischargeEndType;
/*DischargeEndType = 0; nera kontakto 
DischargeEndType = 1; kontaktas sujungtas*/

char DischargeFoult;
/*DischargeFoult = 0; nera klaidos
DischargeFoult = 1; yra klaida*/

char segm_a,segm_b,segm_c,segm_d,segm_e,segm_f,segm_g,segm_h;
/*segm_a - virsutinis segmetas
segm_b - desinysis virsutinis segmetas
segm_c - desinysis apatinis segmetas
segm_d - apatinis segmetas
segm_e - kairysis apatinis segmetas
segm_f - kairysis virsutinis segmetas
segm_g - vidurinysis segmetas
segm_h - taskelio segmetas*/

char itampa;
/*itampa = 0; raudonas
itampa = 1; raudonas + geltonas
itampa = 2; geltonas
itampa = 3; geltonas + zalias
itampa = 4; zalias*/






    while(1){ 
    OSC = OSC + 1;
        if(OSC>=15){
        OSC = 0;} 

    // MYGTUKAI
    char Button[3];
        {if(PINA.0==0){
        Button[0] = 1;}   
        else
        Button[0] = 0;}
        {if(PINA.1==0){
        Button[1] = 1;}   
        else
        Button[1] = 0;}
        {if(PINA.2==0){
        Button[2] = 1;}   
        else
        Button[2] = 0;}
        {if(PINA.3==0){
        Button[3] = 1;}   
        else
        Button[3] = 0;}
        
        if((Button[0]!=0)||(Button[1]!=0)||(Button[2]!=0)||(Button[3]!=0)){
        OnButtonPress(Button);
        }
///////////////////////////////////////////////////////////////////////    
                   



    // ITAMPOS INDIKATORIAI
    itampa = 0;
    char raudonas,geltonas,zalias;
        if(PINB.4==1){
        zalias = 1;}
        if(PINB.0==1){
        geltonas = 1;}
        if(PINB.1==1){
        raudonas = 1;}
        if(itampa==0){
            if(raudonas==1){
                if(geltonas==1){
                    if(zalias==0){
                    itampa = 1;
                    }
                }
            }
        }        
        if(itampa==0){
            if(raudonas==0){
                if(geltonas==1){
                    if(zalias==0){
                    itampa = 2;
                    }
                    if(zalias==1){
                    itampa = 3;
                    }
                }
            }
        }        
        if(itampa==0){
            if(raudonas==0){
                if(geltonas==0){
                    if(zalias==1){
                    itampa = 4;
                    }
                }
            }
        }
///////////////////////////////////////////////////////////////////////




        















































    }
}
    

