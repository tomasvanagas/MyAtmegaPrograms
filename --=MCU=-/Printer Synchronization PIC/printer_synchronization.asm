
_main:

;printer_synchronization.c,27 :: 		void main(){
;printer_synchronization.c,28 :: 		TRISA = 0b1;
	MOVLW      1
	MOVWF      TRISA+0
;printer_synchronization.c,29 :: 		TRISB = 0b10100;
	MOVLW      20
	MOVWF      TRISB+0
;printer_synchronization.c,31 :: 		PORTA = 0;
	CLRF       PORTA+0
;printer_synchronization.c,32 :: 		PORTB = 0;
	CLRF       PORTB+0
;printer_synchronization.c,34 :: 		OldStateButtonUp = 0;
	CLRF       _OldStateButtonUp+0
;printer_synchronization.c,35 :: 		OldStateButtonDown = 0;
	CLRF       _OldStateButtonDown+0
;printer_synchronization.c,37 :: 		SetPoint = 0;
	CLRF       _SetPoint+0
	CLRF       _SetPoint+1
;printer_synchronization.c,40 :: 		InputOldState = 0;
	CLRF       _InputOldState+0
;printer_synchronization.c,41 :: 		InputWidthNow = 0;
	CLRF       _InputWidthNow+0
	CLRF       _InputWidthNow+1
;printer_synchronization.c,42 :: 		LastInputWidth = 0;
	CLRF       _LastInputWidth+0
	CLRF       _LastInputWidth+1
;printer_synchronization.c,43 :: 		OldCycleTime = 0;
	CLRF       _OldCycleTime+0
	CLRF       _OldCycleTime+1
;printer_synchronization.c,44 :: 		CycleTimeNow = 0;
	CLRF       _CycleTimeNow+0
	CLRF       _CycleTimeNow+1
;printer_synchronization.c,46 :: 		PrintCycleTimeNow = 0;
	CLRF       _PrintCycleTimeNow+0
	CLRF       _PrintCycleTimeNow+1
;printer_synchronization.c,47 :: 		VirtualPrintCycleNow = 0;
	CLRF       _VirtualPrintCycleNow+0
	CLRF       _VirtualPrintCycleNow+1
;printer_synchronization.c,48 :: 		PrintingUntil = 0;
	CLRF       _PrintingUntil+0
	CLRF       _PrintingUntil+1
;printer_synchronization.c,49 :: 		Printing = 0;
	CLRF       _Printing+0
	CLRF       _Printing+1
;printer_synchronization.c,52 :: 		while(1){
L_main0:
;printer_synchronization.c,54 :: 		if(CycleTimeNow<3000){
	MOVLW      11
	SUBWF      _CycleTimeNow+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main44
	MOVLW      184
	SUBWF      _CycleTimeNow+0, 0
L__main44:
	BTFSC      STATUS+0, 0
	GOTO       L_main2
;printer_synchronization.c,55 :: 		CycleTimeNow++;
	INCF       _CycleTimeNow+0, 1
	BTFSC      STATUS+0, 2
	INCF       _CycleTimeNow+1, 1
;printer_synchronization.c,56 :: 		}
L_main2:
;printer_synchronization.c,58 :: 		if(INPUT==1){
	BTFSS      PORTB+0, 4
	GOTO       L_main3
;printer_synchronization.c,60 :: 		if(InputOldState==0){
	MOVF       _InputOldState+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main4
;printer_synchronization.c,62 :: 		if(ThisCyclePrinted==0){
	MOVLW      0
	XORWF      _ThisCyclePrinted+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main45
	MOVLW      0
	XORWF      _ThisCyclePrinted+0, 0
L__main45:
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;printer_synchronization.c,63 :: 		if(OldCycleTime>0){
	MOVF       _OldCycleTime+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main46
	MOVF       _OldCycleTime+0, 0
	SUBLW      0
L__main46:
	BTFSC      STATUS+0, 0
	GOTO       L_main6
;printer_synchronization.c,64 :: 		if(LastInputWidth>0){
	MOVF       _LastInputWidth+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main47
	MOVF       _LastInputWidth+0, 0
	SUBLW      0
L__main47:
	BTFSC      STATUS+0, 0
	GOTO       L_main7
;printer_synchronization.c,65 :: 		Printing = LastInputWidth;
	MOVF       _LastInputWidth+0, 0
	MOVWF      _Printing+0
	MOVF       _LastInputWidth+1, 0
	MOVWF      _Printing+1
;printer_synchronization.c,66 :: 		}
L_main7:
;printer_synchronization.c,67 :: 		}
L_main6:
;printer_synchronization.c,68 :: 		}
L_main5:
;printer_synchronization.c,69 :: 		ThisCyclePrinted = 0;
	CLRF       _ThisCyclePrinted+0
	CLRF       _ThisCyclePrinted+1
;printer_synchronization.c,71 :: 		OldCycleTime = CycleTimeNow;
	MOVF       _CycleTimeNow+0, 0
	MOVWF      _OldCycleTime+0
	MOVF       _CycleTimeNow+1, 0
	MOVWF      _OldCycleTime+1
;printer_synchronization.c,72 :: 		CycleTimeNow = 0;
	CLRF       _CycleTimeNow+0
	CLRF       _CycleTimeNow+1
;printer_synchronization.c,73 :: 		}
L_main4:
;printer_synchronization.c,74 :: 		InputOldState = 1;
	MOVLW      1
	MOVWF      _InputOldState+0
;printer_synchronization.c,75 :: 		if(InputWidthNow<500){
	MOVLW      1
	SUBWF      _InputWidthNow+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main48
	MOVLW      244
	SUBWF      _InputWidthNow+0, 0
L__main48:
	BTFSC      STATUS+0, 0
	GOTO       L_main8
;printer_synchronization.c,76 :: 		InputWidthNow++;
	INCF       _InputWidthNow+0, 1
	BTFSC      STATUS+0, 2
	INCF       _InputWidthNow+1, 1
;printer_synchronization.c,77 :: 		}
L_main8:
;printer_synchronization.c,78 :: 		}
	GOTO       L_main9
L_main3:
;printer_synchronization.c,80 :: 		if(InputWidthNow>0){
	MOVF       _InputWidthNow+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main49
	MOVF       _InputWidthNow+0, 0
	SUBLW      0
L__main49:
	BTFSC      STATUS+0, 0
	GOTO       L_main10
;printer_synchronization.c,81 :: 		LastInputWidth = InputWidthNow;
	MOVF       _InputWidthNow+0, 0
	MOVWF      _LastInputWidth+0
	MOVF       _InputWidthNow+1, 0
	MOVWF      _LastInputWidth+1
;printer_synchronization.c,82 :: 		InputWidthNow = 0;
	CLRF       _InputWidthNow+0
	CLRF       _InputWidthNow+1
;printer_synchronization.c,83 :: 		}
L_main10:
;printer_synchronization.c,84 :: 		InputOldState = 0;
	CLRF       _InputOldState+0
;printer_synchronization.c,85 :: 		}
L_main9:
;printer_synchronization.c,87 :: 		if(ThisCyclePrinted==0){
	MOVLW      0
	XORWF      _ThisCyclePrinted+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main50
	MOVLW      0
	XORWF      _ThisCyclePrinted+0, 0
L__main50:
	BTFSS      STATUS+0, 2
	GOTO       L_main11
;printer_synchronization.c,88 :: 		if(OldCycleTime>0){
	MOVF       _OldCycleTime+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main51
	MOVF       _OldCycleTime+0, 0
	SUBLW      0
L__main51:
	BTFSC      STATUS+0, 0
	GOTO       L_main12
;printer_synchronization.c,89 :: 		if(LastInputWidth>0){
	MOVF       _LastInputWidth+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main52
	MOVF       _LastInputWidth+0, 0
	SUBLW      0
L__main52:
	BTFSC      STATUS+0, 0
	GOTO       L_main13
;printer_synchronization.c,90 :: 		if(CycleTimeNow>=(OldCycleTime/18)*SetPoint){
	MOVLW      18
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _OldCycleTime+0, 0
	MOVWF      R0+0
	MOVF       _OldCycleTime+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVF       _SetPoint+0, 0
	MOVWF      R4+0
	MOVF       _SetPoint+1, 0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+1, 0
	SUBWF      _CycleTimeNow+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main53
	MOVF       R0+0, 0
	SUBWF      _CycleTimeNow+0, 0
L__main53:
	BTFSS      STATUS+0, 0
	GOTO       L_main14
;printer_synchronization.c,91 :: 		Printing = LastInputWidth;
	MOVF       _LastInputWidth+0, 0
	MOVWF      _Printing+0
	MOVF       _LastInputWidth+1, 0
	MOVWF      _Printing+1
;printer_synchronization.c,92 :: 		ThisCyclePrinted = 1;
	MOVLW      1
	MOVWF      _ThisCyclePrinted+0
	MOVLW      0
	MOVWF      _ThisCyclePrinted+1
;printer_synchronization.c,93 :: 		}
L_main14:
;printer_synchronization.c,94 :: 		}
L_main13:
;printer_synchronization.c,95 :: 		}
L_main12:
;printer_synchronization.c,96 :: 		}
L_main11:
;printer_synchronization.c,100 :: 		if(Printing>0){
	MOVF       _Printing+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main54
	MOVF       _Printing+0, 0
	SUBLW      0
L__main54:
	BTFSC      STATUS+0, 0
	GOTO       L_main15
;printer_synchronization.c,101 :: 		OUTPUT = 1;
	BSF        PORTB+0, 7
;printer_synchronization.c,102 :: 		Printing--;
	MOVLW      1
	SUBWF      _Printing+0, 1
	BTFSS      STATUS+0, 0
	DECF       _Printing+1, 1
;printer_synchronization.c,103 :: 		}
	GOTO       L_main16
L_main15:
;printer_synchronization.c,105 :: 		OUTPUT = 0;
	BCF        PORTB+0, 7
;printer_synchronization.c,106 :: 		}
L_main16:
;printer_synchronization.c,115 :: 		if(BUTTON_UP==1){
	BTFSS      PORTA+0, 0
	GOTO       L_main17
;printer_synchronization.c,116 :: 		if(OldStateButtonUp==0){
	MOVF       _OldStateButtonUp+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main18
;printer_synchronization.c,117 :: 		OldStateButtonUp = 1;
	MOVLW      1
	MOVWF      _OldStateButtonUp+0
;printer_synchronization.c,118 :: 		if(SetPoint<17){
	MOVLW      0
	SUBWF      _SetPoint+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main55
	MOVLW      17
	SUBWF      _SetPoint+0, 0
L__main55:
	BTFSC      STATUS+0, 0
	GOTO       L_main19
;printer_synchronization.c,119 :: 		SetPoint++;
	INCF       _SetPoint+0, 1
	BTFSC      STATUS+0, 2
	INCF       _SetPoint+1, 1
;printer_synchronization.c,120 :: 		}
L_main19:
;printer_synchronization.c,121 :: 		}
L_main18:
;printer_synchronization.c,122 :: 		}
	GOTO       L_main20
L_main17:
;printer_synchronization.c,124 :: 		OldStateButtonUp = 0;
	CLRF       _OldStateButtonUp+0
;printer_synchronization.c,125 :: 		}
L_main20:
;printer_synchronization.c,127 :: 		if(BUTTON_DOWN==1){
	BTFSS      PORTB+0, 2
	GOTO       L_main21
;printer_synchronization.c,128 :: 		if(OldStateButtonDown==0){
	MOVF       _OldStateButtonDown+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main22
;printer_synchronization.c,129 :: 		OldStateButtonDown = 1;
	MOVLW      1
	MOVWF      _OldStateButtonDown+0
;printer_synchronization.c,130 :: 		if(SetPoint>0){
	MOVF       _SetPoint+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main56
	MOVF       _SetPoint+0, 0
	SUBLW      0
L__main56:
	BTFSC      STATUS+0, 0
	GOTO       L_main23
;printer_synchronization.c,131 :: 		SetPoint--;
	MOVLW      1
	SUBWF      _SetPoint+0, 1
	BTFSS      STATUS+0, 0
	DECF       _SetPoint+1, 1
;printer_synchronization.c,132 :: 		}
L_main23:
;printer_synchronization.c,133 :: 		}
L_main22:
;printer_synchronization.c,134 :: 		}
	GOTO       L_main24
L_main21:
;printer_synchronization.c,136 :: 		OldStateButtonDown = 0;
	CLRF       _OldStateButtonDown+0
;printer_synchronization.c,137 :: 		}
L_main24:
;printer_synchronization.c,142 :: 		if(SetPoint<2){
	MOVLW      0
	SUBWF      _SetPoint+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main57
	MOVLW      2
	SUBWF      _SetPoint+0, 0
L__main57:
	BTFSC      STATUS+0, 0
	GOTO       L_main25
;printer_synchronization.c,143 :: 		LED1 = 1;
	BSF        PORTB+0, 6
;printer_synchronization.c,144 :: 		LED2 = 0;
	BCF        PORTB+0, 1
;printer_synchronization.c,145 :: 		LED3 = 0;
	BCF        PORTA+0, 3
;printer_synchronization.c,146 :: 		LED4 = 0;
	BCF        PORTA+0, 2
;printer_synchronization.c,147 :: 		LED5 = 0;
	BCF        PORTA+0, 1
;printer_synchronization.c,148 :: 		}
	GOTO       L_main26
L_main25:
;printer_synchronization.c,149 :: 		else if(SetPoint<4){
	MOVLW      0
	SUBWF      _SetPoint+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main58
	MOVLW      4
	SUBWF      _SetPoint+0, 0
L__main58:
	BTFSC      STATUS+0, 0
	GOTO       L_main27
;printer_synchronization.c,150 :: 		LED1 = 1;
	BSF        PORTB+0, 6
;printer_synchronization.c,151 :: 		LED2 = 1;
	BSF        PORTB+0, 1
;printer_synchronization.c,152 :: 		LED3 = 0;
	BCF        PORTA+0, 3
;printer_synchronization.c,153 :: 		LED4 = 0;
	BCF        PORTA+0, 2
;printer_synchronization.c,154 :: 		LED5 = 0;
	BCF        PORTA+0, 1
;printer_synchronization.c,155 :: 		}
	GOTO       L_main28
L_main27:
;printer_synchronization.c,156 :: 		else if(SetPoint<6){
	MOVLW      0
	SUBWF      _SetPoint+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main59
	MOVLW      6
	SUBWF      _SetPoint+0, 0
L__main59:
	BTFSC      STATUS+0, 0
	GOTO       L_main29
;printer_synchronization.c,157 :: 		LED1 = 0;
	BCF        PORTB+0, 6
;printer_synchronization.c,158 :: 		LED2 = 1;
	BSF        PORTB+0, 1
;printer_synchronization.c,159 :: 		LED3 = 0;
	BCF        PORTA+0, 3
;printer_synchronization.c,160 :: 		LED4 = 0;
	BCF        PORTA+0, 2
;printer_synchronization.c,161 :: 		LED5 = 0;
	BCF        PORTA+0, 1
;printer_synchronization.c,162 :: 		}
	GOTO       L_main30
L_main29:
;printer_synchronization.c,163 :: 		else if(SetPoint<8){
	MOVLW      0
	SUBWF      _SetPoint+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main60
	MOVLW      8
	SUBWF      _SetPoint+0, 0
L__main60:
	BTFSC      STATUS+0, 0
	GOTO       L_main31
;printer_synchronization.c,164 :: 		LED1 = 0;
	BCF        PORTB+0, 6
;printer_synchronization.c,165 :: 		LED2 = 1;
	BSF        PORTB+0, 1
;printer_synchronization.c,166 :: 		LED3 = 1;
	BSF        PORTA+0, 3
;printer_synchronization.c,167 :: 		LED4 = 0;
	BCF        PORTA+0, 2
;printer_synchronization.c,168 :: 		LED5 = 0;
	BCF        PORTA+0, 1
;printer_synchronization.c,169 :: 		}
	GOTO       L_main32
L_main31:
;printer_synchronization.c,170 :: 		else if(SetPoint<10){
	MOVLW      0
	SUBWF      _SetPoint+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main61
	MOVLW      10
	SUBWF      _SetPoint+0, 0
L__main61:
	BTFSC      STATUS+0, 0
	GOTO       L_main33
;printer_synchronization.c,171 :: 		LED1 = 0;
	BCF        PORTB+0, 6
;printer_synchronization.c,172 :: 		LED2 = 0;
	BCF        PORTB+0, 1
;printer_synchronization.c,173 :: 		LED3 = 1;
	BSF        PORTA+0, 3
;printer_synchronization.c,174 :: 		LED4 = 0;
	BCF        PORTA+0, 2
;printer_synchronization.c,175 :: 		LED5 = 0;
	BCF        PORTA+0, 1
;printer_synchronization.c,176 :: 		}
	GOTO       L_main34
L_main33:
;printer_synchronization.c,177 :: 		else if(SetPoint<12){
	MOVLW      0
	SUBWF      _SetPoint+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main62
	MOVLW      12
	SUBWF      _SetPoint+0, 0
L__main62:
	BTFSC      STATUS+0, 0
	GOTO       L_main35
;printer_synchronization.c,178 :: 		LED1 = 0;
	BCF        PORTB+0, 6
;printer_synchronization.c,179 :: 		LED2 = 0;
	BCF        PORTB+0, 1
;printer_synchronization.c,180 :: 		LED3 = 1;
	BSF        PORTA+0, 3
;printer_synchronization.c,181 :: 		LED4 = 1;
	BSF        PORTA+0, 2
;printer_synchronization.c,182 :: 		LED5 = 0;
	BCF        PORTA+0, 1
;printer_synchronization.c,183 :: 		}
	GOTO       L_main36
L_main35:
;printer_synchronization.c,184 :: 		else if(SetPoint<14){
	MOVLW      0
	SUBWF      _SetPoint+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main63
	MOVLW      14
	SUBWF      _SetPoint+0, 0
L__main63:
	BTFSC      STATUS+0, 0
	GOTO       L_main37
;printer_synchronization.c,185 :: 		LED1 = 0;
	BCF        PORTB+0, 6
;printer_synchronization.c,186 :: 		LED2 = 0;
	BCF        PORTB+0, 1
;printer_synchronization.c,187 :: 		LED3 = 0;
	BCF        PORTA+0, 3
;printer_synchronization.c,188 :: 		LED4 = 1;
	BSF        PORTA+0, 2
;printer_synchronization.c,189 :: 		LED5 = 0;
	BCF        PORTA+0, 1
;printer_synchronization.c,190 :: 		}
	GOTO       L_main38
L_main37:
;printer_synchronization.c,191 :: 		else if(SetPoint<16){
	MOVLW      0
	SUBWF      _SetPoint+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main64
	MOVLW      16
	SUBWF      _SetPoint+0, 0
L__main64:
	BTFSC      STATUS+0, 0
	GOTO       L_main39
;printer_synchronization.c,192 :: 		LED1 = 0;
	BCF        PORTB+0, 6
;printer_synchronization.c,193 :: 		LED2 = 0;
	BCF        PORTB+0, 1
;printer_synchronization.c,194 :: 		LED3 = 0;
	BCF        PORTA+0, 3
;printer_synchronization.c,195 :: 		LED4 = 1;
	BSF        PORTA+0, 2
;printer_synchronization.c,196 :: 		LED5 = 1;
	BSF        PORTA+0, 1
;printer_synchronization.c,197 :: 		}
	GOTO       L_main40
L_main39:
;printer_synchronization.c,198 :: 		else if(SetPoint<18){
	MOVLW      0
	SUBWF      _SetPoint+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main65
	MOVLW      18
	SUBWF      _SetPoint+0, 0
L__main65:
	BTFSC      STATUS+0, 0
	GOTO       L_main41
;printer_synchronization.c,199 :: 		LED1 = 0;
	BCF        PORTB+0, 6
;printer_synchronization.c,200 :: 		LED2 = 0;
	BCF        PORTB+0, 1
;printer_synchronization.c,201 :: 		LED3 = 0;
	BCF        PORTA+0, 3
;printer_synchronization.c,202 :: 		LED4 = 0;
	BCF        PORTA+0, 2
;printer_synchronization.c,203 :: 		LED5 = 1;
	BSF        PORTA+0, 1
;printer_synchronization.c,204 :: 		}
L_main41:
L_main40:
L_main38:
L_main36:
L_main34:
L_main32:
L_main30:
L_main28:
L_main26:
;printer_synchronization.c,207 :: 		delay_ms(1);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      111
	MOVWF      R13+0
L_main42:
	DECFSZ     R13+0, 1
	GOTO       L_main42
	DECFSZ     R12+0, 1
	GOTO       L_main42
;printer_synchronization.c,208 :: 		}
	GOTO       L_main0
;printer_synchronization.c,209 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
