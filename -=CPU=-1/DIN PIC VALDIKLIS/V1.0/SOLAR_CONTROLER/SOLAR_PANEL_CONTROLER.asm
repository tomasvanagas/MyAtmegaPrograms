
_main:

;SOLAR_PANEL_CONTROLER.c,40 :: 		void main() {
;SOLAR_PANEL_CONTROLER.c,41 :: 		TRISA = 0b00001111;
	MOVLW      15
	MOVWF      TRISA+0
;SOLAR_PANEL_CONTROLER.c,42 :: 		TRISB = 0b00000010;
	MOVLW      2
	MOVWF      TRISB+0
;SOLAR_PANEL_CONTROLER.c,43 :: 		PORTA = 0;
	CLRF       PORTA+0
;SOLAR_PANEL_CONTROLER.c,44 :: 		PORTB = 0;
	CLRF       PORTB+0
;SOLAR_PANEL_CONTROLER.c,46 :: 		while(1){
L_main0:
;SOLAR_PANEL_CONTROLER.c,47 :: 		SwithingProcedure();
	CALL       _SwithingProcedure+0
;SOLAR_PANEL_CONTROLER.c,48 :: 		TimeRelay();
	CALL       _TimeRelay+0
;SOLAR_PANEL_CONTROLER.c,49 :: 		Delay_us(940);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      55
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
;SOLAR_PANEL_CONTROLER.c,50 :: 		}
	GOTO       L_main0
;SOLAR_PANEL_CONTROLER.c,51 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_SwithingProcedure:

;SOLAR_PANEL_CONTROLER.c,54 :: 		void SwithingProcedure(void){
;SOLAR_PANEL_CONTROLER.c,59 :: 		if(SwitchingOn==1){
	BTFSS      PORTA+0, 2
	GOTO       L_SwithingProcedure3
;SOLAR_PANEL_CONTROLER.c,60 :: 		if(SwitchingBypass==0){
	BTFSC      PORTA+0, 3
	GOTO       L_SwithingProcedure4
;SOLAR_PANEL_CONTROLER.c,61 :: 		if(SwitchingWorkScd<SwitchingWorkTime){
	MOVLW      0
	SUBWF      SwithingProcedure_SwitchingWorkScd_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__SwithingProcedure21
	MOVLW      60
	SUBWF      SwithingProcedure_SwitchingWorkScd_L0+0, 0
L__SwithingProcedure21:
	BTFSC      STATUS+0, 0
	GOTO       L_SwithingProcedure5
;SOLAR_PANEL_CONTROLER.c,62 :: 		SwitchingWorkMscnd++;
	INCF       SwithingProcedure_SwitchingWorkMscnd_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       SwithingProcedure_SwitchingWorkMscnd_L0+1, 1
;SOLAR_PANEL_CONTROLER.c,63 :: 		if(SwitchingWorkMscnd>1000){
	MOVF       SwithingProcedure_SwitchingWorkMscnd_L0+1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__SwithingProcedure22
	MOVF       SwithingProcedure_SwitchingWorkMscnd_L0+0, 0
	SUBLW      232
L__SwithingProcedure22:
	BTFSC      STATUS+0, 0
	GOTO       L_SwithingProcedure6
;SOLAR_PANEL_CONTROLER.c,64 :: 		SwitchingWorkMscnd = 0;
	CLRF       SwithingProcedure_SwitchingWorkMscnd_L0+0
	CLRF       SwithingProcedure_SwitchingWorkMscnd_L0+1
;SOLAR_PANEL_CONTROLER.c,65 :: 		SwitchingWorkScd++;
	INCF       SwithingProcedure_SwitchingWorkScd_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       SwithingProcedure_SwitchingWorkScd_L0+1, 1
;SOLAR_PANEL_CONTROLER.c,66 :: 		}
L_SwithingProcedure6:
;SOLAR_PANEL_CONTROLER.c,68 :: 		if(SwitchingWorkingRelay==0){
	MOVF       SwithingProcedure_SwitchingWorkingRelay_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_SwithingProcedure7
;SOLAR_PANEL_CONTROLER.c,69 :: 		SwitchingRelay1 = 1;
	BSF        PORTB+0, 3
;SOLAR_PANEL_CONTROLER.c,70 :: 		SwitchingRelay2 = 0;
	BCF        PORTB+0, 2
;SOLAR_PANEL_CONTROLER.c,71 :: 		}
	GOTO       L_SwithingProcedure8
L_SwithingProcedure7:
;SOLAR_PANEL_CONTROLER.c,73 :: 		SwitchingRelay1 = 0;
	BCF        PORTB+0, 3
;SOLAR_PANEL_CONTROLER.c,74 :: 		SwitchingRelay2 = 1;
	BSF        PORTB+0, 2
;SOLAR_PANEL_CONTROLER.c,75 :: 		}
L_SwithingProcedure8:
;SOLAR_PANEL_CONTROLER.c,77 :: 		}
	GOTO       L_SwithingProcedure9
L_SwithingProcedure5:
;SOLAR_PANEL_CONTROLER.c,79 :: 		SwitchingRelay1 = 1;
	BSF        PORTB+0, 3
;SOLAR_PANEL_CONTROLER.c,80 :: 		SwitchingRelay2 = 1;
	BSF        PORTB+0, 2
;SOLAR_PANEL_CONTROLER.c,82 :: 		SwitchingExchangeMscnd++;
	INCF       SwithingProcedure_SwitchingExchangeMscnd_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       SwithingProcedure_SwitchingExchangeMscnd_L0+1, 1
;SOLAR_PANEL_CONTROLER.c,83 :: 		if(SwitchingExchangeMscnd>1000){
	MOVF       SwithingProcedure_SwitchingExchangeMscnd_L0+1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__SwithingProcedure23
	MOVF       SwithingProcedure_SwitchingExchangeMscnd_L0+0, 0
	SUBLW      232
L__SwithingProcedure23:
	BTFSC      STATUS+0, 0
	GOTO       L_SwithingProcedure10
;SOLAR_PANEL_CONTROLER.c,84 :: 		SwitchingExchangeMscnd = 0;
	CLRF       SwithingProcedure_SwitchingExchangeMscnd_L0+0
	CLRF       SwithingProcedure_SwitchingExchangeMscnd_L0+1
;SOLAR_PANEL_CONTROLER.c,85 :: 		SwitchingExchangeScd++;
	INCF       SwithingProcedure_SwitchingExchangeScd_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       SwithingProcedure_SwitchingExchangeScd_L0+1, 1
;SOLAR_PANEL_CONTROLER.c,86 :: 		}
L_SwithingProcedure10:
;SOLAR_PANEL_CONTROLER.c,88 :: 		if(SwitchingExchangeScd>=SwitchingExchangeTime){
	MOVLW      0
	SUBWF      SwithingProcedure_SwitchingExchangeScd_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__SwithingProcedure24
	MOVLW      60
	SUBWF      SwithingProcedure_SwitchingExchangeScd_L0+0, 0
L__SwithingProcedure24:
	BTFSS      STATUS+0, 0
	GOTO       L_SwithingProcedure11
;SOLAR_PANEL_CONTROLER.c,89 :: 		SwitchingWorkMscnd = 0;
	CLRF       SwithingProcedure_SwitchingWorkMscnd_L0+0
	CLRF       SwithingProcedure_SwitchingWorkMscnd_L0+1
;SOLAR_PANEL_CONTROLER.c,90 :: 		SwitchingWorkScd = 0;
	CLRF       SwithingProcedure_SwitchingWorkScd_L0+0
	CLRF       SwithingProcedure_SwitchingWorkScd_L0+1
;SOLAR_PANEL_CONTROLER.c,92 :: 		SwitchingExchangeMscnd = 0;
	CLRF       SwithingProcedure_SwitchingExchangeMscnd_L0+0
	CLRF       SwithingProcedure_SwitchingExchangeMscnd_L0+1
;SOLAR_PANEL_CONTROLER.c,93 :: 		SwitchingExchangeScd = 0;
	CLRF       SwithingProcedure_SwitchingExchangeScd_L0+0
	CLRF       SwithingProcedure_SwitchingExchangeScd_L0+1
;SOLAR_PANEL_CONTROLER.c,94 :: 		if(SwitchingWorkingRelay==0){
	MOVF       SwithingProcedure_SwitchingWorkingRelay_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_SwithingProcedure12
;SOLAR_PANEL_CONTROLER.c,95 :: 		SwitchingWorkingRelay = 1;
	MOVLW      1
	MOVWF      SwithingProcedure_SwitchingWorkingRelay_L0+0
;SOLAR_PANEL_CONTROLER.c,96 :: 		}
	GOTO       L_SwithingProcedure13
L_SwithingProcedure12:
;SOLAR_PANEL_CONTROLER.c,98 :: 		SwitchingWorkingRelay = 0;
	CLRF       SwithingProcedure_SwitchingWorkingRelay_L0+0
;SOLAR_PANEL_CONTROLER.c,99 :: 		}
L_SwithingProcedure13:
;SOLAR_PANEL_CONTROLER.c,100 :: 		}
L_SwithingProcedure11:
;SOLAR_PANEL_CONTROLER.c,101 :: 		}
L_SwithingProcedure9:
;SOLAR_PANEL_CONTROLER.c,102 :: 		}
	GOTO       L_SwithingProcedure14
L_SwithingProcedure4:
;SOLAR_PANEL_CONTROLER.c,104 :: 		SwitchingRelay1 = 1;
	BSF        PORTB+0, 3
;SOLAR_PANEL_CONTROLER.c,105 :: 		SwitchingRelay2 = 1;
	BSF        PORTB+0, 2
;SOLAR_PANEL_CONTROLER.c,106 :: 		}
L_SwithingProcedure14:
;SOLAR_PANEL_CONTROLER.c,107 :: 		}
	GOTO       L_SwithingProcedure15
L_SwithingProcedure3:
;SOLAR_PANEL_CONTROLER.c,109 :: 		SwitchingRelay1 = 0;
	BCF        PORTB+0, 3
;SOLAR_PANEL_CONTROLER.c,110 :: 		SwitchingRelay2 = 0;
	BCF        PORTB+0, 2
;SOLAR_PANEL_CONTROLER.c,111 :: 		}
L_SwithingProcedure15:
;SOLAR_PANEL_CONTROLER.c,112 :: 		}
L_end_SwithingProcedure:
	RETURN
; end of _SwithingProcedure

_TimeRelay:

;SOLAR_PANEL_CONTROLER.c,114 :: 		void TimeRelay(void){
;SOLAR_PANEL_CONTROLER.c,117 :: 		if(TimeRelayInput==1){
	BTFSS      PORTB+0, 1
	GOTO       L_TimeRelay16
;SOLAR_PANEL_CONTROLER.c,118 :: 		TimeRelayCounter = TimeRelayTime;
	MOVLW      16
	MOVWF      TimeRelay_TimeRelayCounter_L0+0
	MOVLW      39
	MOVWF      TimeRelay_TimeRelayCounter_L0+1
;SOLAR_PANEL_CONTROLER.c,119 :: 		}
L_TimeRelay16:
;SOLAR_PANEL_CONTROLER.c,121 :: 		if(TimeRelayCounter>0){
	MOVF       TimeRelay_TimeRelayCounter_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__TimeRelay26
	MOVF       TimeRelay_TimeRelayCounter_L0+0, 0
	SUBLW      0
L__TimeRelay26:
	BTFSC      STATUS+0, 0
	GOTO       L_TimeRelay17
;SOLAR_PANEL_CONTROLER.c,122 :: 		TimeRelayCounter--;
	MOVLW      1
	SUBWF      TimeRelay_TimeRelayCounter_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       TimeRelay_TimeRelayCounter_L0+1, 1
;SOLAR_PANEL_CONTROLER.c,123 :: 		TimeRelayOutput = 1;
	BSF        PORTB+0, 6
;SOLAR_PANEL_CONTROLER.c,124 :: 		}
	GOTO       L_TimeRelay18
L_TimeRelay17:
;SOLAR_PANEL_CONTROLER.c,126 :: 		TimeRelayOutput = 0;
	BCF        PORTB+0, 6
;SOLAR_PANEL_CONTROLER.c,127 :: 		}
L_TimeRelay18:
;SOLAR_PANEL_CONTROLER.c,128 :: 		}
L_end_TimeRelay:
	RETURN
; end of _TimeRelay
