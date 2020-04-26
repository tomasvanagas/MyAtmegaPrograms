
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : long, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _RefreshLcd=R5
	.DEF _LAST_SOLAR_INPUT_TEMP=R6
	.DEF _LAST_SOLAR_OUTPUT_TEMP=R8
	.DEF _BOILER_TEMP=R10
	.DEF _SOLAR_INPUT_TEMP=R12
	.DEF _Acceleration=R4

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_k1:
	.DB  0x20,0x22,0x2A,0x2B,0x2C,0x5B,0x3D,0x5D
	.DB  0x7C,0x7F,0x0

_0xEC:
	.DB  0xFF
_0x0:
	.DB  0x20,0x3C,0x0,0x20,0x20,0x0,0x7C,0x7C
	.DB  0x0,0x3E,0x0,0x20,0x7C,0x20,0x0,0x20
	.DB  0x20,0x20,0x0,0x2B,0x0,0x2D,0x0,0x2A
	.DB  0x20,0x0,0x53,0x41,0x55,0x4C,0x45,0x53
	.DB  0x20,0x4B,0x4F,0x4C,0x45,0x4B,0x54,0x4F
	.DB  0x52,0x2E,0x0,0x56,0x41,0x4C,0x44,0x49
	.DB  0x4B,0x4C,0x49,0x53,0x20,0x56,0x31,0x2E
	.DB  0x30,0x20,0x20,0x0,0x43,0x20,0x4B,0x4F
	.DB  0x4C,0x2E,0x54,0x45,0x4D,0x50,0x2E,0x0
	.DB  0x43,0x20,0x42,0x4F,0x49,0x4C,0x2E,0x54
	.DB  0x45,0x4D,0x50,0x0,0x43,0x20,0x4B,0x4F
	.DB  0x4C,0x2E,0x49,0x53,0x45,0x4A,0x2E,0x0
	.DB  0x43,0x20,0x4B,0x4F,0x4C,0x2E,0x49,0x45
	.DB  0x4A,0x49,0x4D,0x0,0x43,0x20,0x54,0x45
	.DB  0x4D,0x50,0x2E,0x53,0x4B,0x49,0x52,0x54
	.DB  0x0,0x20,0x20,0x20,0x20,0x4B,0x45,0x49
	.DB  0x53,0x54,0x49,0x3F,0x2D,0x2D,0x3E,0x2A
	.DB  0x20,0x0,0x4C,0x2F,0x4D,0x49,0x4E,0x20
	.DB  0x53,0x52,0x41,0x55,0x54,0x41,0x53,0x0
	.DB  0x20,0x20,0x39,0x35,0x43,0x20,0x41,0x50
	.DB  0x53,0x41,0x55,0x47,0x41,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x4E,0x45,0x53,0x55,0x56
	.DB  0x45,0x49,0x4B,0x55,0x53,0x49,0x20,0x20
	.DB  0x20,0x0,0x2D,0x2D,0x53,0x55,0x56,0x45
	.DB  0x49,0x4B,0x45,0x20,0x20,0x39,0x35,0x43
	.DB  0x2D,0x2D,0x0,0x2D,0x2D,0x2D,0x2D,0x41
	.DB  0x50,0x53,0x41,0x55,0x47,0x41,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x0,0x57,0x20,0x4D,0x4F
	.DB  0x4D,0x45,0x4E,0x54,0x49,0x4E,0x45,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x47,0x41
	.DB  0x4C,0x49,0x41,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x6B,0x57,0x68,0x0,0x45,0x4E
	.DB  0x45,0x52,0x47,0x2E,0x53,0x4B,0x41,0x49
	.DB  0x54,0x49,0x4B,0x4C,0x49,0x53,0x0,0x45
	.DB  0x4E,0x45,0x52,0x47,0x2E,0x20,0x50,0x45
	.DB  0x52,0x20,0x44,0x49,0x45,0x4E,0x41,0x0
	.DB  0x4D,0x41,0x4B,0x53,0x2E,0x44,0x49,0x45
	.DB  0x4E,0x4F,0x53,0x2E,0x54,0x45,0x4D,0x50
	.DB  0x0,0x43,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x54,0x52,0x49,0x4E,0x41,0x4D,0x41
	.DB  0x3A,0x20,0x30,0x30,0x30,0x25,0x20,0x20
	.DB  0x20,0x0,0x50,0x41,0x4C,0x41,0x55,0x4B
	.DB  0x49,0x54,0x45,0x2E,0x2E,0x2E,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x49
	.DB  0x53,0x54,0x52,0x49,0x4E,0x54,0x41,0x20
	.DB  0x20,0x20,0x20,0x0,0x53,0x56,0x41,0x52
	.DB  0x42,0x55,0x53,0x20,0x49,0x56,0x59,0x4B
	.DB  0x49,0x41,0x49,0x3A,0x0,0x50,0x45,0x52
	.DB  0x5A,0x49,0x55,0x52,0x45,0x54,0x49,0x3F
	.DB  0x2D,0x2D,0x3E,0x2A,0x20,0x0,0x53,0x55
	.DB  0x56,0x45,0x49,0x4B,0x45,0x20,0x39,0x35
	.DB  0x43,0x20,0x20,0x0,0x41,0x54,0x4B,0x52
	.DB  0x49,0x54,0x4F,0x20,0x39,0x35,0x43,0x20
	.DB  0x20,0x0,0x44,0x49,0x4E,0x47,0x4F,0x20
	.DB  0x49,0x54,0x41,0x4D,0x50,0x41,0x20,0x0
	.DB  0x4E,0x45,0x52,0x41,0x20,0x49,0x56,0x59
	.DB  0x4B,0x49,0x4F,0x20,0x20,0x0,0x43,0x20
	.DB  0x53,0x41,0x55,0x4C,0x2E,0x0,0x43,0x20
	.DB  0x42,0x4F,0x49,0x4C,0x2E,0x0,0x54,0x52
	.DB  0x49,0x4E,0x54,0x49,0x20,0x49,0x52,0x41
	.DB  0x53,0x55,0x53,0x3F,0x20,0x20,0x0,0x20
	.DB  0x3C,0x7C,0x7C,0x3E,0x20,0x20,0x20,0x54
	.DB  0x41,0x49,0x50,0x3D,0x3E,0x2A,0x0,0x44
	.DB  0x41,0x54,0x41,0x3A,0x20,0x0,0x4E,0x55
	.DB  0x53,0x54,0x41,0x54,0x59,0x54,0x49,0x3F
	.DB  0x20,0x2D,0x2D,0x3E,0x2A,0x20,0x0,0x4C
	.DB  0x41,0x49,0x4B,0x41,0x53,0x3A,0x20,0x0
	.DB  0x4D,0x41,0x54,0x55,0x4F,0x4A,0x41,0x3A
	.DB  0x20,0x42,0x4F,0x49,0x4C,0x45,0x52,0x2E
	.DB  0x0,0x4D,0x41,0x54,0x55,0x4F,0x4A,0x41
	.DB  0x3A,0x20,0x53,0x2E,0x49,0x45,0x4A,0x49
	.DB  0x2E,0x0,0x4D,0x41,0x54,0x55,0x4F,0x4A
	.DB  0x41,0x3A,0x20,0x53,0x2E,0x49,0x53,0x45
	.DB  0x4A,0x2E,0x0,0x4D,0x41,0x54,0x55,0x4F
	.DB  0x4A,0x41,0x3A,0x20,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x20,0x0,0x54,0x45,0x4D,0x50
	.DB  0x3A,0x20,0x20,0x20,0x20,0x0,0x41,0x54
	.DB  0x53,0x54,0x41,0x54,0x59,0x54,0x49,0x20
	.DB  0x56,0x49,0x53,0x4B,0x41,0x3F,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x54
	.DB  0x41,0x49,0x50,0x3D,0x3E,0x2A,0x20,0x0
	.DB  0x20,0x20,0x20,0x41,0x54,0x53,0x54,0x41
	.DB  0x54,0x4F,0x4D,0x41,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x50,0x41,0x4C,0x41
	.DB  0x55,0x4B,0x49,0x54,0x45,0x20,0x20,0x20
	.DB  0x20,0x0,0x49,0x53,0x4A,0x55,0x4E,0x4B
	.DB  0x49,0x54,0x45,0x20,0x49,0x52,0x20,0x56
	.DB  0x45,0x4C,0x20,0x49,0x4A,0x55,0x4E,0x4B
	.DB  0x49,0x54,0x45,0x20,0x56,0x41,0x4C,0x44
	.DB  0x49,0x4B,0x4C,0x49,0x0,0x4B,0x4F,0x44
	.DB  0x41,0x53,0x3A,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x4C,0x41,0x49,0x4B,0x41,0x53,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x42,0x41,0x49,0x47,0x45,0x53
	.DB  0x49,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x4B,0x4F,0x44,0x41
	.DB  0x53,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x54,0x45,0x49,0x53,0x49
	.DB  0x4E,0x47,0x41,0x53,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x4E,0x45,0x54,0x45,0x49
	.DB  0x53,0x49,0x4E,0x47,0x41,0x53,0x20,0x20
	.DB  0x20,0x0
_0x2020003:
	.DB  0x1
_0x2040107:
	.DB  0x46,0x41,0x54
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x11
	.DW  _0xD3
	.DW  _0x0*2+26

	.DW  0x11
	.DW  _0xD3+17
	.DW  _0x0*2+43

	.DW  0x01
	.DW  _SolarColectorState_S0000010002
	.DW  _0xEC*2

	.DW  0x01
	.DW  _status_G101
	.DW  _0x2020003*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;Project : Saules kolektoriaus valdiklis
;Version : v1.0
;Date    : 2011-08-20
;Author  : T.V.
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;*****************************************************/
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <ff.h>
;#include <sdcard.h>
;
;// Alphanumeric LCD Module functions portc
;#asm
   .equ __lcd_port=0x15
; 0000 0014 #endasm
;#include <lcd.h>
;
;
;//////// Mygtuku Aprasimas ////////
;// " <||> | +||-||* "
;#define BUTTON_DESCRIPTION1   " <"
;#define BUTTON_DESCRIPTION1_0 "  "
;
;#define BUTTON_DESCRIPTION2   "||"
;#define BUTTON_DESCRIPTION2_0 "  "
;
;#define BUTTON_DESCRIPTION3   ">"
;#define BUTTON_DESCRIPTION3_0 " "
;
;#define BUTTON_DESCRIPTION4   " | "
;#define BUTTON_DESCRIPTION4_0 "   "
;
;#define BUTTON_DESCRIPTION5   "+"
;#define BUTTON_DESCRIPTION5_0 " "
;
;#define BUTTON_DESCRIPTION6   "||"
;#define BUTTON_DESCRIPTION6_0 "  "
;
;#define BUTTON_DESCRIPTION7   "-"
;#define BUTTON_DESCRIPTION7_0 " "
;
;#define BUTTON_DESCRIPTION8   "||"
;#define BUTTON_DESCRIPTION8_0 "  "
;
;#define BUTTON_DESCRIPTION9   "* "
;#define BUTTON_DESCRIPTION9_0 "  "
;///////////////////////////////////
;
;
;
;
;
;// PINS
;#define LCD_LED PORTA.7
;
;#define BUTTON_INPUT1 PIND.6
;#define BUTTON_INPUT2 PIND.5
;#define BUTTON_INPUT3 PIND.4
;#define BUTTON_INPUT4 PIND.3
;#define BUTTON_INPUT5 PIND.2
;
;#define TERMOSWITCH_INPUT PIND.7
;
;#define WATER_PUMP PORTB.0
;#define ANTIFREEZE_PUMP PORTB.1
;
;#define TEMPERATURE_BOIL PORTA.1
;#define TEMPERATURE_S_INP PORTA.2
;#define TEMPERATURE_S_OUT PORTA.3
;
;
;
;
;
;
;
;
;
;
;
;
;#define ButtonFiltrationTimer 20 // x*cycle (cycle~1ms)
;///////////////////////////////////////////////////////////////////////////////////
;////////////////////////// VARIABLES //////////////////////////////////////////////
;// Real Time
;eeprom unsigned int RealTimeYear;
;eeprom signed char RealTimeMonth, RealTimeDay, RealTimeHour, RealTimeMinute;
;eeprom unsigned char RealTimeSecond;
;
;
;// Logs
;#define LOG_COUNT 90
;eeprom unsigned char NewestLog;
;
;eeprom unsigned int  LogYear[LOG_COUNT];
;eeprom unsigned char LogMonth[LOG_COUNT];
;eeprom unsigned char LogDay[LOG_COUNT];
;eeprom unsigned char LogHour[LOG_COUNT];
;eeprom unsigned char LogMinute[LOG_COUNT];
;
;eeprom unsigned char LogType[LOG_COUNT];
;
;eeprom signed int LogData1[LOG_COUNT];
;eeprom signed int LogData2[LOG_COUNT];
;
;// Lcd Address
;signed int Address[3];
;char RefreshLcd;
;
;
;// Solar Colector Parameters
;#define MAX_DIFFERENCE_SOLAR_BOILER 250
;#define DEFAULT_DIFFERENCE_SOLAR_BOILER 100
;#define MIN_DIFFERENCE_SOLAR_BOILER 50
;#define DEFAULT_WATER_FLOW 20
;
;
;
;signed int LAST_SOLAR_INPUT_TEMP, LAST_SOLAR_OUTPUT_TEMP;
;signed int BOILER_TEMP, SOLAR_INPUT_TEMP, SOLAR_OUTPUT_TEMP;
;eeprom signed int LitersPerMinute;
;eeprom unsigned long int SolarColectorWattHours;
;eeprom unsigned long int WattHoursPerDay;
;eeprom signed int MinimumAntifreezeTemp;
;eeprom signed int DifferenceBoilerAndSolar;
;
;
;
;eeprom signed int MaxDayTemperature;
;
;char Acceleration;
;
;char PAGRINDINIS_LANGAS;
;char Call_1Second;
;///////////////////////////////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////////
;#define ADC_VREF_TYPE 0x40
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input){
; 0000 0090 unsigned int read_adc(unsigned char adc_input){

	.CSEG
_read_adc:
; 0000 0091 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0092 // Delay needed for the stabilization of the ADC input voltage
; 0000 0093 delay_us(10);
	__DELAY_USB 27
; 0000 0094 // Start the AD conversion
; 0000 0095 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0096 // Wait for the AD conversion to complete
; 0000 0097 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0098 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0099 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x2080007
; 0000 009A }
;///////////////////////////////////////////////////////////////////////////////////
;////////////////////////////// FUNCTIONS //////////////////////////////////////////
;signed int GetTemperature(void){
; 0000 009D signed int GetTemperature(void){
_GetTemperature:
; 0000 009E signed int input = read_adc(0);
; 0000 009F signed int Temperature;// -20.7C ~ 179.3C
; 0000 00A0 
; 0000 00A1 input = input - 166;
	CALL __SAVELOCR4
;	input -> R16,R17
;	Temperature -> R18,R19
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R16,R30
	__SUBWRN 16,17,166
; 0000 00A2 Temperature = input*2 - 207;
	MOVW R30,R16
	LSL  R30
	ROL  R31
	SUBI R30,LOW(207)
	SBCI R31,HIGH(207)
	MOVW R18,R30
; 0000 00A3 Temperature = Temperature + input/3;
	MOVW R26,R16
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21
	__ADDWRR 18,19,30,31
; 0000 00A4 
; 0000 00A5 return Temperature;
	MOVW R30,R18
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; 0000 00A6 }
;
;char NumToIndex(char Num){
; 0000 00A8 char NumToIndex(char Num){
_NumToIndex:
; 0000 00A9     if(Num==0){     return '0';}
;	Num -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x6
	LDI  R30,LOW(48)
	RJMP _0x2080007
; 0000 00AA     else if(Num==1){return '1';}
_0x6:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x8
	LDI  R30,LOW(49)
	RJMP _0x2080007
; 0000 00AB     else if(Num==2){return '2';}
_0x8:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0xA
	LDI  R30,LOW(50)
	RJMP _0x2080007
; 0000 00AC     else if(Num==3){return '3';}
_0xA:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0xC
	LDI  R30,LOW(51)
	RJMP _0x2080007
; 0000 00AD     else if(Num==4){return '4';}
_0xC:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xE
	LDI  R30,LOW(52)
	RJMP _0x2080007
; 0000 00AE     else if(Num==5){return '5';}
_0xE:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x10
	LDI  R30,LOW(53)
	RJMP _0x2080007
; 0000 00AF     else if(Num==6){return '6';}
_0x10:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x12
	LDI  R30,LOW(54)
	RJMP _0x2080007
; 0000 00B0     else if(Num==7){return '7';}
_0x12:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x14
	LDI  R30,LOW(55)
	RJMP _0x2080007
; 0000 00B1     else if(Num==8){return '8';}
_0x14:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x16
	LDI  R30,LOW(56)
	RJMP _0x2080007
; 0000 00B2     else if(Num==9){return '9';}
_0x16:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x18
	LDI  R30,LOW(57)
	RJMP _0x2080007
; 0000 00B3     else if(Num==10){return 'a';}
_0x18:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x1A
	LDI  R30,LOW(97)
	RJMP _0x2080007
; 0000 00B4     else if(Num==11){return 'b';}
_0x1A:
	LD   R26,Y
	CPI  R26,LOW(0xB)
	BRNE _0x1C
	LDI  R30,LOW(98)
	RJMP _0x2080007
; 0000 00B5     else if(Num==12){return 'c';}
_0x1C:
	LD   R26,Y
	CPI  R26,LOW(0xC)
	BRNE _0x1E
	LDI  R30,LOW(99)
	RJMP _0x2080007
; 0000 00B6     else if(Num==13){return 'd';}
_0x1E:
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRNE _0x20
	LDI  R30,LOW(100)
	RJMP _0x2080007
; 0000 00B7     else if(Num==14){return 'e';}
_0x20:
	LD   R26,Y
	CPI  R26,LOW(0xE)
	BRNE _0x22
	LDI  R30,LOW(101)
	RJMP _0x2080007
; 0000 00B8     else if(Num==15){return 'f';}
_0x22:
	LD   R26,Y
	CPI  R26,LOW(0xF)
	BRNE _0x24
	LDI  R30,LOW(102)
	RJMP _0x2080007
; 0000 00B9     else{           return '-';}
_0x24:
	LDI  R30,LOW(45)
; 0000 00BA return 0;
_0x2080007:
	ADIW R28,1
	RET
; 0000 00BB }
;
;char IndexToNum(char Index){
; 0000 00BD char IndexToNum(char Index){
; 0000 00BE     if(Index=='0'){     return 0;}
;	Index -> Y+0
; 0000 00BF     else if(Index=='1'){return 1;}
; 0000 00C0     else if(Index=='2'){return 2;}
; 0000 00C1     else if(Index=='3'){return 3;}
; 0000 00C2     else if(Index=='4'){return 4;}
; 0000 00C3     else if(Index=='5'){return 5;}
; 0000 00C4     else if(Index=='6'){return 6;}
; 0000 00C5     else if(Index=='7'){return 7;}
; 0000 00C6     else if(Index=='8'){return 8;}
; 0000 00C7     else if(Index=='9'){return 9;}
; 0000 00C8     else if(Index=='a'){return 10;}
; 0000 00C9     else if(Index=='b'){return 11;}
; 0000 00CA     else if(Index=='c'){return 12;}
; 0000 00CB     else if(Index=='d'){return 13;}
; 0000 00CC     else if(Index=='e'){return 14;}
; 0000 00CD     else if(Index=='f'){return 15;}
; 0000 00CE     else{               return 16;}
; 0000 00CF return 0;
; 0000 00D0 }
;
;char DayCountInMonth(unsigned int year, char month){
; 0000 00D2 char DayCountInMonth(unsigned int year, char month){
_DayCountInMonth:
; 0000 00D3     if((month==1)||(month==3)||(month==5)||(month==7)||(month==8)||(month==10)||(month==12)){
;	year -> Y+1
;	month -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BREQ _0x47
	CPI  R26,LOW(0x3)
	BREQ _0x47
	CPI  R26,LOW(0x5)
	BREQ _0x47
	CPI  R26,LOW(0x7)
	BREQ _0x47
	CPI  R26,LOW(0x8)
	BREQ _0x47
	CPI  R26,LOW(0xA)
	BREQ _0x47
	CPI  R26,LOW(0xC)
	BRNE _0x46
_0x47:
; 0000 00D4     return 31;
	LDI  R30,LOW(31)
	RJMP _0x2080006
; 0000 00D5     }
; 0000 00D6     else if((month==4)||(month==6)||(month==9)||(month==11)){
_0x46:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BREQ _0x4B
	CPI  R26,LOW(0x6)
	BREQ _0x4B
	CPI  R26,LOW(0x9)
	BREQ _0x4B
	CPI  R26,LOW(0xB)
	BRNE _0x4A
_0x4B:
; 0000 00D7     return 30;
	LDI  R30,LOW(30)
	RJMP _0x2080006
; 0000 00D8     }
; 0000 00D9     else if(month==2){
_0x4A:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x4E
; 0000 00DA     unsigned int a;
; 0000 00DB     a = year/4;
	SBIW R28,2
;	year -> Y+3
;	month -> Y+2
;	a -> Y+0
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	CALL __LSRW2
	ST   Y,R30
	STD  Y+1,R31
; 0000 00DC     a = a*4;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(4)
	CALL __MULB1W2U
	ST   Y,R30
	STD  Y+1,R31
; 0000 00DD         if(a==year){
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x4F
; 0000 00DE         return 29;
	LDI  R30,LOW(29)
	ADIW R28,2
	RJMP _0x2080006
; 0000 00DF         }
; 0000 00E0         else{
_0x4F:
; 0000 00E1         return 28;
	LDI  R30,LOW(28)
	ADIW R28,2
	RJMP _0x2080006
; 0000 00E2         }
; 0000 00E3     }
; 0000 00E4     else{
_0x4E:
; 0000 00E5     return 0;
	LDI  R30,LOW(0)
; 0000 00E6     }
; 0000 00E7 }
_0x2080006:
	ADIW R28,3
	RET
;
;void MakeValidRealTimeDate(){
; 0000 00E9 void MakeValidRealTimeDate(){
_MakeValidRealTimeDate:
; 0000 00EA     if(RealTimeYear<2011){
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x7DB)
	LDI  R26,HIGH(0x7DB)
	CPC  R31,R26
	BRLO _0x323
; 0000 00EB     RealTimeYear = 2011;
; 0000 00EC     }
; 0000 00ED     else if(RealTimeYear>9999){
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x2710)
	LDI  R26,HIGH(0x2710)
	CPC  R31,R26
	BRLO _0x54
; 0000 00EE     RealTimeYear = 2011;
_0x323:
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	LDI  R30,LOW(2011)
	LDI  R31,HIGH(2011)
	CALL __EEPROMWRW
; 0000 00EF     }
; 0000 00F0 
; 0000 00F1     if(RealTimeMonth>12){
_0x54:
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xD)
	BRLT _0x55
; 0000 00F2     RealTimeMonth = 12;
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	LDI  R30,LOW(12)
	RJMP _0x324
; 0000 00F3     }
; 0000 00F4     else if(RealTimeMonth<1){
_0x55:
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRGE _0x57
; 0000 00F5     RealTimeMonth = 1;
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	LDI  R30,LOW(1)
_0x324:
	CALL __EEPROMWRB
; 0000 00F6     }
; 0000 00F7 
; 0000 00F8     if(RealTimeDay>DayCountInMonth(RealTimeYear, RealTimeMonth)){
_0x57:
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	PUSH R30
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _DayCountInMonth
	POP  R26
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x58
; 0000 00F9     RealTimeDay = DayCountInMonth(RealTimeYear, RealTimeMonth);
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _DayCountInMonth
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	RJMP _0x325
; 0000 00FA     }
; 0000 00FB     else if(RealTimeDay<1){
_0x58:
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRGE _0x5A
; 0000 00FC     RealTimeDay = 1;
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	LDI  R30,LOW(1)
_0x325:
	CALL __EEPROMWRB
; 0000 00FD     }
; 0000 00FE }
_0x5A:
	RET
;
;unsigned int WhatIsTheCode(){
; 0000 0100 unsigned int WhatIsTheCode(){
_WhatIsTheCode:
; 0000 0101 return (RealTimeYear-2000)*RealTimeMonth*RealTimeDay;
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	SUBI R30,LOW(2000)
	SBCI R31,HIGH(2000)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	MOVW R26,R0
	CALL __MULW12U
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	MOVW R26,R0
	CALL __MULW12U
	RET
; 0000 0102 }
;
;char GetOldestLogID(void){
; 0000 0104 char GetOldestLogID(void){
_GetOldestLogID:
; 0000 0105     if(NewestLog==0){
	LDI  R26,LOW(_NewestLog)
	LDI  R27,HIGH(_NewestLog)
	CALL __EEPROMRDB
	CPI  R30,0
	BRNE _0x5B
; 0000 0106     return LOG_COUNT-1;
	LDI  R30,LOW(89)
	RET
; 0000 0107     }
; 0000 0108 return NewestLog-1;
_0x5B:
	LDI  R26,LOW(_NewestLog)
	LDI  R27,HIGH(_NewestLog)
	CALL __EEPROMRDB
	LDI  R31,0
	SBIW R30,1
	RET
; 0000 0109 }
;
;char lcd_put_number(char Type, char Lenght, char IsSign,
; 0000 010C 
; 0000 010D                     char NumbersAfterDot,
; 0000 010E 
; 0000 010F                     unsigned long int Number0,
; 0000 0110                     signed long int Number1){
_lcd_put_number:
; 0000 0111     if(Lenght>0){
;	Type -> Y+11
;	Lenght -> Y+10
;	IsSign -> Y+9
;	NumbersAfterDot -> Y+8
;	Number0 -> Y+4
;	Number1 -> Y+0
	LDD  R26,Y+10
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x5C
; 0000 0112     unsigned long int k = 1;
; 0000 0113     unsigned char i;
; 0000 0114         for(i=0;i<Lenght-1;i++) k = k*10;
	SBIW R28,5
	LDI  R30,LOW(1)
	STD  Y+1,R30
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
;	Type -> Y+16
;	Lenght -> Y+15
;	IsSign -> Y+14
;	NumbersAfterDot -> Y+13
;	Number0 -> Y+9
;	Number1 -> Y+5
;	k -> Y+1
;	i -> Y+0
	ST   Y,R30
_0x5E:
	LDD  R30,Y+15
	LDI  R31,0
	SBIW R30,1
	LD   R26,Y
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x5F
	__GETD1S 1
	__GETD2N 0xA
	CALL __MULD12U
	__PUTD1S 1
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x5E
_0x5F:
; 0000 0116 if(Type==0){
	LDD  R30,Y+16
	CPI  R30,0
	BREQ PC+3
	JMP _0x60
; 0000 0117         unsigned long int a;
; 0000 0118         unsigned char b;
; 0000 0119         a = Number0;
	SBIW R28,5
;	Type -> Y+21
;	Lenght -> Y+20
;	IsSign -> Y+19
;	NumbersAfterDot -> Y+18
;	Number0 -> Y+14
;	Number1 -> Y+10
;	k -> Y+6
;	i -> Y+5
;	a -> Y+1
;	b -> Y+0
	__GETD1S 14
	__PUTD1S 1
; 0000 011A 
; 0000 011B             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x61
; 0000 011C             lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 011D             }
; 0000 011E 
; 0000 011F             if(a<0){
_0x61:
	__GETD2S 1
; 0000 0120             a = a*(-1);
; 0000 0121             }
; 0000 0122 
; 0000 0123             if(k*10<a){
	__GETD1S 6
	__GETD2N 0xA
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 1
	CALL __CPD21
	BRSH _0x63
; 0000 0124             a = k*10 - 1;
	__GETD1S 6
	__GETD2N 0xA
	CALL __MULD12U
	__SUBD1N 1
	__PUTD1S 1
; 0000 0125             }
; 0000 0126 
; 0000 0127             for(i=0;i<Lenght;i++){
_0x63:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x65:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRLO PC+3
	JMP _0x66
; 0000 0128                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x67
; 0000 0129                     if(Lenght-NumbersAfterDot==i){
	LDD  R26,Y+20
	CLR  R27
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDD  R30,Y+5
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x68
; 0000 012A                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 012B                     }
; 0000 012C                 }
_0x68:
; 0000 012D             b = a/k;
_0x67:
	__GETD1S 6
	__GETD2S 1
	CALL __DIVD21U
	ST   Y,R30
; 0000 012E             lcd_putchar( NumToIndex( b ) );
	ST   -Y,R30
	RCALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 012F             a = a - b*k;
	LD   R26,Y
	CLR  R27
	__GETD1S 6
	CALL __CWD2
	CALL __MULD12U
	__GETD2S 1
	CALL __SUBD21
	__PUTD2S 1
; 0000 0130             k = k/10;
	__GETD2S 6
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 6
; 0000 0131             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x65
_0x66:
; 0000 0132         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2080005
; 0000 0133         }
; 0000 0134 
; 0000 0135         else if(Type==1){
_0x60:
	LDD  R26,Y+16
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x6A
; 0000 0136         signed long int a;
; 0000 0137         unsigned char b;
; 0000 0138         a = Number1;
	SBIW R28,5
;	Type -> Y+21
;	Lenght -> Y+20
;	IsSign -> Y+19
;	NumbersAfterDot -> Y+18
;	Number0 -> Y+14
;	Number1 -> Y+10
;	k -> Y+6
;	i -> Y+5
;	a -> Y+1
;	b -> Y+0
	__GETD1S 10
	__PUTD1S 1
; 0000 0139 
; 0000 013A             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x6B
; 0000 013B                 if(a>=0){
	LDD  R26,Y+4
	TST  R26
	BRMI _0x6C
; 0000 013C                 lcd_putchar('+');
	LDI  R30,LOW(43)
	RJMP _0x326
; 0000 013D                 }
; 0000 013E                 else{
_0x6C:
; 0000 013F                 lcd_putchar('-');
	LDI  R30,LOW(45)
_0x326:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0140                 }
; 0000 0141             }
; 0000 0142 
; 0000 0143             if(a<0){
_0x6B:
	LDD  R26,Y+4
	TST  R26
	BRPL _0x6E
; 0000 0144             a = a*(-1);
	__GETD1S 1
	__GETD2N 0xFFFFFFFF
	CALL __MULD12
	__PUTD1S 1
; 0000 0145             }
; 0000 0146 
; 0000 0147             if(k*10<a){
_0x6E:
	__GETD1S 6
	__GETD2N 0xA
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 1
	CALL __CPD21
	BRSH _0x6F
; 0000 0148             a = k*10 - 1;
	__GETD1S 6
	__GETD2N 0xA
	CALL __MULD12U
	__SUBD1N 1
	__PUTD1S 1
; 0000 0149             }
; 0000 014A 
; 0000 014B             for(i=0;i<Lenght;i++){
_0x6F:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x71:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRLO PC+3
	JMP _0x72
; 0000 014C                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x73
; 0000 014D                     if(Lenght-NumbersAfterDot==i){
	LDD  R26,Y+20
	CLR  R27
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDD  R30,Y+5
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x74
; 0000 014E                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 014F                     }
; 0000 0150                 }
_0x74:
; 0000 0151             b = a/k;
_0x73:
	__GETD1S 6
	__GETD2S 1
	CALL __DIVD21U
	ST   Y,R30
; 0000 0152             lcd_putchar( NumToIndex( b ) );
	ST   -Y,R30
	RCALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0153             a = a - b*k;
	LD   R26,Y
	CLR  R27
	__GETD1S 6
	CALL __CWD2
	CALL __MULD12U
	__GETD2S 1
	CALL __SUBD21
	__PUTD2S 1
; 0000 0154             k = k/10;
	__GETD2S 6
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 6
; 0000 0155             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x71
_0x72:
; 0000 0156         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2080005
; 0000 0157         }
; 0000 0158     }
_0x6A:
	ADIW R28,5
; 0000 0159 return 0;
_0x5C:
	LDI  R30,LOW(0)
_0x2080005:
	ADIW R28,12
	RET
; 0000 015A }
;
;char lcd_put_runing_text(   unsigned char Start_x,
; 0000 015D                             unsigned char Start_y,
; 0000 015E 
; 0000 015F                             unsigned int Lenght,
; 0000 0160                             unsigned int Position,
; 0000 0161 
; 0000 0162                             char flash *str){
_lcd_put_runing_text:
; 0000 0163 signed int i,a;
; 0000 0164 unsigned int StrLenght = strlenf(str);
; 0000 0165 lcd_gotoxy(Start_x,Start_y);
	CALL __SAVELOCR6
;	Start_x -> Y+13
;	Start_y -> Y+12
;	Lenght -> Y+10
;	Position -> Y+8
;	*str -> Y+6
;	i -> R16,R17
;	a -> R18,R19
;	StrLenght -> R20,R21
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOVW R20,R30
	LDD  R30,Y+13
	ST   -Y,R30
	LDD  R30,Y+13
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0166 
; 0000 0167     for(i=0;i<Lenght;i++){
	__GETWRN 16,17,0
_0x76:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x77
; 0000 0168     a = i + Position - Lenght;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R16
	ADC  R27,R17
	SUB  R26,R30
	SBC  R27,R31
	MOVW R18,R26
; 0000 0169         if(a>=0){
	TST  R19
	BRMI _0x78
; 0000 016A             if(a<StrLenght){
	__CPWRR 18,19,20,21
	BRSH _0x79
; 0000 016B             lcd_putchar(str[a]);
	MOVW R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 016C             }
; 0000 016D             else{
	RJMP _0x7A
_0x79:
; 0000 016E                 if(i==0){
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x7B
; 0000 016F                 return 1;
	LDI  R30,LOW(1)
	RJMP _0x2080004
; 0000 0170                 }
; 0000 0171             }
_0x7B:
_0x7A:
; 0000 0172         }
; 0000 0173         else{
	RJMP _0x7C
_0x78:
; 0000 0174         lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0175         }
_0x7C:
; 0000 0176     }
	__ADDWRN 16,17,1
	RJMP _0x76
_0x77:
; 0000 0177 return 0;
	LDI  R30,LOW(0)
_0x2080004:
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; 0000 0178 }
;
;char lcd_cursor(unsigned char x, unsigned char y){
; 0000 017A char lcd_cursor(unsigned char x, unsigned char y){
_lcd_cursor:
; 0000 017B _lcd_ready();
;	x -> Y+1
;	y -> Y+0
	CALL __lcd_ready
; 0000 017C lcd_gotoxy(x,y);
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 017D _lcd_ready();
	CALL __lcd_ready
; 0000 017E _lcd_write_data(0xe);
	LDI  R30,LOW(14)
	ST   -Y,R30
	CALL __lcd_write_data
; 0000 017F return 1;
	LDI  R30,LOW(1)
	ADIW R28,2
	RET
; 0000 0180 }
;
;static unsigned char CODE_IsEntering;
;static unsigned char CODE_SuccessXYZ[3];
;static unsigned char CODE_FailedXYZ[3];
;static unsigned char CODE_TimeLeft;
;static unsigned int  CODE_EnteringCode;
;static unsigned char CODE_ExecutingDigit;
;char EnterCode(char FailX,char FailY,char FailZ,
; 0000 0189         char SuccessX,char SuccessY,char SuccessZ){
_EnterCode:
; 0000 018A     if(CODE_IsEntering==0){
;	FailX -> Y+5
;	FailY -> Y+4
;	FailZ -> Y+3
;	SuccessX -> Y+2
;	SuccessY -> Y+1
;	SuccessZ -> Y+0
	LDS  R30,_CODE_IsEntering_G000
	CPI  R30,0
	BRNE _0x7D
; 0000 018B     CODE_IsEntering = 1;
	LDI  R30,LOW(1)
	STS  _CODE_IsEntering_G000,R30
; 0000 018C 
; 0000 018D     CODE_SuccessXYZ[0] = SuccessX;
	LDD  R30,Y+2
	STS  _CODE_SuccessXYZ_G000,R30
; 0000 018E     CODE_SuccessXYZ[1] = SuccessY;
	LDD  R30,Y+1
	__PUTB1MN _CODE_SuccessXYZ_G000,1
; 0000 018F     CODE_SuccessXYZ[2] = SuccessZ;
	LD   R30,Y
	__PUTB1MN _CODE_SuccessXYZ_G000,2
; 0000 0190 
; 0000 0191     CODE_FailedXYZ[0] = FailX;
	LDD  R30,Y+5
	STS  _CODE_FailedXYZ_G000,R30
; 0000 0192     CODE_FailedXYZ[1] = FailY;
	LDD  R30,Y+4
	__PUTB1MN _CODE_FailedXYZ_G000,1
; 0000 0193     CODE_FailedXYZ[2] = FailZ;
	LDD  R30,Y+3
	__PUTB1MN _CODE_FailedXYZ_G000,2
; 0000 0194 
; 0000 0195     CODE_TimeLeft = 99;
	LDI  R30,LOW(99)
	STS  _CODE_TimeLeft_G000,R30
; 0000 0196     CODE_EnteringCode = 0;
	LDI  R30,LOW(0)
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R30
; 0000 0197     CODE_ExecutingDigit = 0;
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 0198     return 1;
	LDI  R30,LOW(1)
	RJMP _0x2080003
; 0000 0199     }
; 0000 019A return 0;
_0x7D:
	LDI  R30,LOW(0)
_0x2080003:
	ADIW R28,6
	RET
; 0000 019B }
;
;char lcd_buttons(char Left,char Right, char Plius,char Minus,
; 0000 019E     char Patvirtinti, char DualButton1,char DualButton2,char DualButton3,
; 0000 019F         char DualButton4){
_lcd_buttons:
; 0000 01A0 
; 0000 01A1     if(Left==1){
;	Left -> Y+8
;	Right -> Y+7
;	Plius -> Y+6
;	Minus -> Y+5
;	Patvirtinti -> Y+4
;	DualButton1 -> Y+3
;	DualButton2 -> Y+2
;	DualButton3 -> Y+1
;	DualButton4 -> Y+0
	LDD  R26,Y+8
	CPI  R26,LOW(0x1)
	BRNE _0x7E
; 0000 01A2     lcd_putsf(BUTTON_DESCRIPTION1);
	__POINTW1FN _0x0,0
	RJMP _0x327
; 0000 01A3     }
; 0000 01A4     else{
_0x7E:
; 0000 01A5     lcd_putsf(BUTTON_DESCRIPTION1_0);
	__POINTW1FN _0x0,3
_0x327:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01A6     }
; 0000 01A7 
; 0000 01A8     if(DualButton1==1){
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x80
; 0000 01A9     lcd_putsf(BUTTON_DESCRIPTION2);
	__POINTW1FN _0x0,6
	RJMP _0x328
; 0000 01AA     }
; 0000 01AB     else{
_0x80:
; 0000 01AC     lcd_putsf(BUTTON_DESCRIPTION2_0);
	__POINTW1FN _0x0,3
_0x328:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01AD     }
; 0000 01AE 
; 0000 01AF     if(Right==1){
	LDD  R26,Y+7
	CPI  R26,LOW(0x1)
	BRNE _0x82
; 0000 01B0     lcd_putsf(BUTTON_DESCRIPTION3);
	__POINTW1FN _0x0,9
	RJMP _0x329
; 0000 01B1     }
; 0000 01B2     else{
_0x82:
; 0000 01B3     lcd_putsf(BUTTON_DESCRIPTION3_0);
	__POINTW1FN _0x0,4
_0x329:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01B4     }
; 0000 01B5 
; 0000 01B6     if(DualButton2==1){
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0x84
; 0000 01B7     lcd_putsf(BUTTON_DESCRIPTION4);
	__POINTW1FN _0x0,11
	RJMP _0x32A
; 0000 01B8     }
; 0000 01B9     else{
_0x84:
; 0000 01BA     lcd_putsf(BUTTON_DESCRIPTION4_0);
	__POINTW1FN _0x0,15
_0x32A:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01BB     }
; 0000 01BC 
; 0000 01BD     if(Plius==1){
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x86
; 0000 01BE     lcd_putsf(BUTTON_DESCRIPTION5);
	__POINTW1FN _0x0,19
	RJMP _0x32B
; 0000 01BF     }
; 0000 01C0     else{
_0x86:
; 0000 01C1     lcd_putsf(BUTTON_DESCRIPTION5_0);
	__POINTW1FN _0x0,4
_0x32B:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01C2     }
; 0000 01C3 
; 0000 01C4     if(DualButton3==1){
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x88
; 0000 01C5     lcd_putsf(BUTTON_DESCRIPTION6);
	__POINTW1FN _0x0,6
	RJMP _0x32C
; 0000 01C6     }
; 0000 01C7     else{
_0x88:
; 0000 01C8     lcd_putsf(BUTTON_DESCRIPTION6_0);
	__POINTW1FN _0x0,3
_0x32C:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01C9     }
; 0000 01CA 
; 0000 01CB     if(Minus==1){
	LDD  R26,Y+5
	CPI  R26,LOW(0x1)
	BRNE _0x8A
; 0000 01CC     lcd_putsf(BUTTON_DESCRIPTION7);
	__POINTW1FN _0x0,21
	RJMP _0x32D
; 0000 01CD     }
; 0000 01CE     else{
_0x8A:
; 0000 01CF     lcd_putsf(BUTTON_DESCRIPTION7_0);
	__POINTW1FN _0x0,4
_0x32D:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01D0     }
; 0000 01D1 
; 0000 01D2     if(DualButton4==1){
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x8C
; 0000 01D3     lcd_putsf(BUTTON_DESCRIPTION8);
	__POINTW1FN _0x0,6
	RJMP _0x32E
; 0000 01D4     }
; 0000 01D5     else{
_0x8C:
; 0000 01D6     lcd_putsf(BUTTON_DESCRIPTION8_0);
	__POINTW1FN _0x0,3
_0x32E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01D7     }
; 0000 01D8 
; 0000 01D9     if(Patvirtinti==1){
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x8E
; 0000 01DA     lcd_putsf(BUTTON_DESCRIPTION9);
	__POINTW1FN _0x0,23
	RJMP _0x32F
; 0000 01DB     }
; 0000 01DC     else{
_0x8E:
; 0000 01DD     lcd_putsf(BUTTON_DESCRIPTION9_0);
	__POINTW1FN _0x0,3
_0x32F:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01DE     }
; 0000 01DF 
; 0000 01E0 return 1;
	LDI  R30,LOW(1)
	ADIW R28,9
	RET
; 0000 01E1 }
;
;/*
;flash char * flash error_msg[]={
;"",
;"FR_DISK_ERR",
;"FR_INT_ERR",
;"FR_INT_ERR",
;"FR_NOT_READY",
;"FR_NO_FILE",
;"FR_NO_PATH",
;"FR_INVALID_NAME",
;"FR_DENIED",
;"FR_EXIST",
;"FR_INVALID_OBJECT",
;"FR_WRITE_PROTECTED",
;"FR_INVALID_DRIVE",
;"FR_NOT_ENABLED",
;"FR_NO_FILESYSTEM",
;"FR_MKFS_ABORTED",
;"FR_TIMEOUT"
;};
;*/
;
;/*
;void error(FRESULT res){
;    if((res>=FR_DISK_ERR) && (res<=FR_TIMEOUT)){
;    lcd_clear();
;    lcd_puts("FS ERROR:");
;    lcd_putsf(error_msg[res]);
;    delay_ms(1000);
;    }
;}
;*/
;
;static unsigned char DataToSent[200];
;static unsigned char ReceivedData[200];
;void SendMBus(){
; 0000 0206 void SendMBus(){
; 0000 0207 unsigned int lenght;
; 0000 0208 unsigned char i,a,b;
; 0000 0209 char character_bits[8];
; 0000 020A char character;
; 0000 020B lenght = strlen(DataToSent);
;	lenght -> R16,R17
;	i -> R19
;	a -> R18
;	b -> R21
;	character_bits -> Y+6
;	character -> R20
; 0000 020C DDRA.4 = 1;
; 0000 020D     for(i=0;i<lenght;i++){
; 0000 020E     character = DataToSent[i];
; 0000 020F     b = 128;
; 0000 0210 
; 0000 0211     PORTA.4 = 1;
; 0000 0212 
; 0000 0213         for(a=7;a>=0;a--){
; 0000 0214             if(character>=b){
; 0000 0215             character_bits[a] = 1;
; 0000 0216             }
; 0000 0217             else{
; 0000 0218             character_bits[a] = 0;
; 0000 0219             }
; 0000 021A         b = b/2;
; 0000 021B         }
; 0000 021C 
; 0000 021D         for(a=0;a<8;a++){
; 0000 021E             if(character_bits[a]==1){
; 0000 021F             PORTA.4 = 1;
; 0000 0220             }
; 0000 0221             else{
; 0000 0222             PORTA.4 = 0;
; 0000 0223             }
; 0000 0224         }
; 0000 0225 
; 0000 0226     PORTA.4 = 1;
; 0000 0227     delay_us(100);
; 0000 0228     PORTA.4 = 0;
; 0000 0229     }
; 0000 022A DDRA.4 = 0;
; 0000 022B }
;
;void GetMBus(void){
; 0000 022D void GetMBus(void){
; 0000 022E unsigned int i,a,character,b;
; 0000 022F     for(i=0;i<200;i++){
;	i -> R16,R17
;	a -> R18,R19
;	character -> R20,R21
;	b -> Y+6
; 0000 0230         while(PINA.4==0);
; 0000 0231         while(PINA.4==1);
; 0000 0232     character = 0;
; 0000 0233     b = 1;
; 0000 0234         for(a=0;a<8;a++){
; 0000 0235             if(PINA.4==1){
; 0000 0236             character = character + b;
; 0000 0237             }
; 0000 0238         b = b*2;
; 0000 0239         delay_us(100);
; 0000 023A         }
; 0000 023B 
; 0000 023C         while(PINA.4==1);
; 0000 023D         while(PINA.4==0);
; 0000 023E     }
; 0000 023F }
;///////////////////////////////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////////////////////////////
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 0245 interrupt [12] void timer0_ovf_isr(void){
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0246 static signed int InteruptTimer, MissTimer;
; 0000 0247 InteruptTimer++;
	LDI  R26,LOW(_InteruptTimer_S000000F000)
	LDI  R27,HIGH(_InteruptTimer_S000000F000)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
; 0000 0248 /////////////////////////// 1 Second Callback ///////////////////////////////////////
; 0000 0249     if(InteruptTimer>=495){// Periodas
	LDS  R26,_InteruptTimer_S000000F000
	LDS  R27,_InteruptTimer_S000000F000+1
	CPI  R26,LOW(0x1EF)
	LDI  R30,HIGH(0x1EF)
	CPC  R27,R30
	BRLT _0xBE
; 0000 024A     Call_1Second++;
	LDS  R30,_Call_1Second
	SUBI R30,-LOW(1)
	STS  _Call_1Second,R30
; 0000 024B     InteruptTimer = 0;
	LDI  R30,LOW(0)
	STS  _InteruptTimer_S000000F000,R30
	STS  _InteruptTimer_S000000F000+1,R30
; 0000 024C     MissTimer++;
	LDI  R26,LOW(_MissTimer_S000000F000)
	LDI  R27,HIGH(_MissTimer_S000000F000)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 024D         if(MissTimer>=1000){
	LDS  R26,_MissTimer_S000000F000
	LDS  R27,_MissTimer_S000000F000+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLT _0xBF
; 0000 024E         InteruptTimer = 50;// -(Tukstantosios periodo dalys)
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _InteruptTimer_S000000F000,R30
	STS  _InteruptTimer_S000000F000+1,R31
; 0000 024F         MissTimer = 0;
	LDI  R30,LOW(0)
	STS  _MissTimer_S000000F000,R30
	STS  _MissTimer_S000000F000+1,R30
; 0000 0250         }
; 0000 0251     }
_0xBF:
; 0000 0252 /////////////////////////////////////////////////////////////////////////////////////
; 0000 0253 static unsigned int RefreshTimer;
_0xBE:
; 0000 0254 RefreshTimer++;
	LDI  R26,LOW(_RefreshTimer_S000000F000)
	LDI  R27,HIGH(_RefreshTimer_S000000F000)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0255     if(RefreshTimer>=20){
	LDS  R26,_RefreshTimer_S000000F000
	LDS  R27,_RefreshTimer_S000000F000+1
	SBIW R26,20
	BRLO _0xC0
; 0000 0256     RefreshTimer = 0;
	LDI  R30,LOW(0)
	STS  _RefreshTimer_S000000F000,R30
	STS  _RefreshTimer_S000000F000+1,R30
; 0000 0257     RefreshLcd = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0258     }
; 0000 0259 
; 0000 025A static unsigned char MemoryTimer;
_0xC0:
; 0000 025B MemoryTimer++;
	LDS  R30,_MemoryTimer_S000000F000
	SUBI R30,-LOW(1)
	STS  _MemoryTimer_S000000F000,R30
; 0000 025C     if(MemoryTimer>=5){
	LDS  R26,_MemoryTimer_S000000F000
	CPI  R26,LOW(0x5)
	BRLO _0xC1
; 0000 025D     disk_timerproc();
	CALL _disk_timerproc
; 0000 025E     MemoryTimer = 0;
	LDI  R30,LOW(0)
	STS  _MemoryTimer_S000000F000,R30
; 0000 025F     }
; 0000 0260 
; 0000 0261 }
_0xC1:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;//FILINFO file_info;
;
;
;void main(void){
; 0000 0266 void main(void){
_main:
; 0000 0267 // Input/Output Ports initialization
; 0000 0268 // Port A initialization
; 0000 0269 // Func7=Out Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=In
; 0000 026A // State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0
; 0000 026B PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 026C DDRA=0b10001110;
	LDI  R30,LOW(142)
	OUT  0x1A,R30
; 0000 026D 
; 0000 026E // Port B initialization
; 0000 026F // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 0270 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0271 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0272 DDRB=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 0273 
; 0000 0274 // Port C initialization
; 0000 0275 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0276 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0277 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0278 DDRC=0b00000000;
	OUT  0x14,R30
; 0000 0279 
; 0000 027A // Port D initialization
; 0000 027B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 027C // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 027D PORTD=0x00;
	OUT  0x12,R30
; 0000 027E DDRD=0b00000000;
	OUT  0x11,R30
; 0000 027F 
; 0000 0280 // Timer/Counter 0 initialization
; 0000 0281 // Clock source: System Clock
; 0000 0282 // Clock value: 125.000 kHz
; 0000 0283 // Mode: Normal top=FFh
; 0000 0284 // OC0 output: Disconnected
; 0000 0285 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0286 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0287 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0288 
; 0000 0289 // Timer/Counter 1 initialization
; 0000 028A // Clock source: System Clock
; 0000 028B // Clock value: Timer1 Stopped
; 0000 028C // Mode: Normal top=FFFFh
; 0000 028D // OC1A output: Discon.
; 0000 028E // OC1B output: Discon.
; 0000 028F // Noise Canceler: Off
; 0000 0290 // Input Capture on Falling Edge
; 0000 0291 // Timer1 Overflow Interrupt: Off
; 0000 0292 // Input Capture Interrupt: Off
; 0000 0293 // Compare A Match Interrupt: Off
; 0000 0294 // Compare B Match Interrupt: Off
; 0000 0295 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0296 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0297 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0298 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0299 ICR1H=0x00;
	OUT  0x27,R30
; 0000 029A ICR1L=0x00;
	OUT  0x26,R30
; 0000 029B OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 029C OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 029D OCR1BH=0x00;
	OUT  0x29,R30
; 0000 029E OCR1BL=0x00;
	OUT  0x28,R30
; 0000 029F 
; 0000 02A0 // Timer/Counter 2 initialization
; 0000 02A1 // Clock source: System Clock
; 0000 02A2 // Clock value: Timer2 Stopped
; 0000 02A3 // Mode: Normal top=FFh
; 0000 02A4 // OC2 output: Disconnected
; 0000 02A5 ASSR=0x00;
	OUT  0x22,R30
; 0000 02A6 TCCR2=0x00;
	OUT  0x25,R30
; 0000 02A7 TCNT2=0x00;
	OUT  0x24,R30
; 0000 02A8 OCR2=0x00;
	OUT  0x23,R30
; 0000 02A9 
; 0000 02AA // External Interrupt(s) initialization
; 0000 02AB // INT0: Off
; 0000 02AC // INT1: Off
; 0000 02AD // INT2: Off
; 0000 02AE MCUCR=0x00;
	OUT  0x35,R30
; 0000 02AF MCUCSR=0x00;
	OUT  0x34,R30
; 0000 02B0 
; 0000 02B1 
; 0000 02B2 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02B3 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 02B4 
; 0000 02B5 // Analog Comparator initialization
; 0000 02B6 // Analog Comparator: Off
; 0000 02B7 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 02B8 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02B9 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02BA 
; 0000 02BB // ADC initialization
; 0000 02BC // ADC Clock frequency: 62.500 kHz
; 0000 02BD // ADC Voltage Reference: Int., cap. on AREF
; 0000 02BE // ADC Auto Trigger Source: Free Running
; 0000 02BF ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 02C0 ADCSRA=0xA7;
	LDI  R30,LOW(167)
	OUT  0x6,R30
; 0000 02C1 SFIOR&=0x1F;
	IN   R30,0x30
	ANDI R30,LOW(0x1F)
	OUT  0x30,R30
; 0000 02C2 
; 0000 02C3 // LCD module initialization
; 0000 02C4 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 02C5 
; 0000 02C6 // Global enable interrupts
; 0000 02C7 #asm("sei")
	sei
; 0000 02C8 
; 0000 02C9 
; 0000 02CA 
; 0000 02CB 
; 0000 02CC 
; 0000 02CD 
; 0000 02CE 
; 0000 02CF 
; 0000 02D0 
; 0000 02D1 
; 0000 02D2 
; 0000 02D3 // Uzfiksuoti kada buvo issijunges valdiklis
; 0000 02D4     if(LogType[GetOldestLogID()]==99){
	RCALL _GetOldestLogID
	LDI  R31,0
	SUBI R30,LOW(-_LogType)
	SBCI R31,HIGH(-_LogType)
	MOVW R26,R30
	CALL __EEPROMRDB
	CPI  R30,LOW(0x63)
	BRNE _0xC2
; 0000 02D5     LogType[GetOldestLogID()] = 3;
	RCALL _GetOldestLogID
	LDI  R31,0
	SUBI R30,LOW(-_LogType)
	SBCI R31,HIGH(-_LogType)
	MOVW R26,R30
	LDI  R30,LOW(3)
	CALL __EEPROMWRB
; 0000 02D6     NewestLog = GetOldestLogID();
	RCALL _GetOldestLogID
	LDI  R26,LOW(_NewestLog)
	LDI  R27,HIGH(_NewestLog)
	CALL __EEPROMWRB
; 0000 02D7     }
; 0000 02D8 
; 0000 02D9     if((LitersPerMinute>=100)||(LitersPerMinute<=0)){
_0xC2:
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRGE _0xC4
	MOVW R26,R30
	CALL __CPW02
	BRLT _0xC3
_0xC4:
; 0000 02DA     LitersPerMinute = DEFAULT_WATER_FLOW;
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __EEPROMWRW
; 0000 02DB     }
; 0000 02DC 
; 0000 02DD 
; 0000 02DE MinimumAntifreezeTemp = 350;
_0xC3:
	LDI  R26,LOW(_MinimumAntifreezeTemp)
	LDI  R27,HIGH(_MinimumAntifreezeTemp)
	LDI  R30,LOW(350)
	LDI  R31,HIGH(350)
	CALL __EEPROMWRW
; 0000 02DF 
; 0000 02E0     if((DifferenceBoilerAndSolar<MIN_DIFFERENCE_SOLAR_BOILER)||
; 0000 02E1     (DifferenceBoilerAndSolar>MAX_DIFFERENCE_SOLAR_BOILER)){
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R30,50
	BRLT _0xC7
	MOVW R30,R26
	CPI  R30,LOW(0xFB)
	LDI  R26,HIGH(0xFB)
	CPC  R31,R26
	BRLT _0xC6
_0xC7:
; 0000 02E2     DifferenceBoilerAndSolar = DEFAULT_DIFFERENCE_SOLAR_BOILER;
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __EEPROMWRW
; 0000 02E3     }
; 0000 02E4 
; 0000 02E5     if((MaxDayTemperature<=-1000)||
_0xC6:
; 0000 02E6     (MaxDayTemperature>=1000)){
	LDI  R26,LOW(_MaxDayTemperature)
	LDI  R27,HIGH(_MaxDayTemperature)
	CALL __EEPROMRDW
	MOVW R0,R30
	MOVW R26,R30
	LDI  R30,LOW(64536)
	LDI  R31,HIGH(64536)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xCA
	MOVW R30,R0
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRLT _0xC9
_0xCA:
; 0000 02E7     MaxDayTemperature = 0;
	LDI  R26,LOW(_MaxDayTemperature)
	LDI  R27,HIGH(_MaxDayTemperature)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 02E8     }
; 0000 02E9 
; 0000 02EA     if(WattHoursPerDay==4294967295){
_0xC9:
	LDI  R26,LOW(_WattHoursPerDay)
	LDI  R27,HIGH(_WattHoursPerDay)
	CALL __EEPROMRDD
	__CPD1N 0xFFFFFFFF
	BRNE _0xCC
; 0000 02EB     WattHoursPerDay = 0;
	LDI  R26,LOW(_WattHoursPerDay)
	LDI  R27,HIGH(_WattHoursPerDay)
	__GETD1N 0x0
	CALL __EEPROMWRD
; 0000 02EC     }
; 0000 02ED 
; 0000 02EE     if(SolarColectorWattHours==4294967295){
_0xCC:
	LDI  R26,LOW(_SolarColectorWattHours)
	LDI  R27,HIGH(_SolarColectorWattHours)
	CALL __EEPROMRDD
	__CPD1N 0xFFFFFFFF
	BRNE _0xCD
; 0000 02EF     SolarColectorWattHours = 0;
	LDI  R26,LOW(_SolarColectorWattHours)
	LDI  R27,HIGH(_SolarColectorWattHours)
	__GETD1N 0x0
	CALL __EEPROMWRD
; 0000 02F0     }
; 0000 02F1 
; 0000 02F2     if((RealTimeHour<0)||(RealTimeHour>=24)||
_0xCD:
; 0000 02F3     (RealTimeMinute<0)||(RealTimeMinute>=60)){
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	CPI  R30,0
	BRLT _0xCF
	CPI  R30,LOW(0x18)
	BRGE _0xCF
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	CPI  R30,0
	BRLT _0xCF
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3C)
	BRLT _0xCE
_0xCF:
; 0000 02F4     RealTimeHour = 0;
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 02F5     RealTimeMinute = 0;
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMWRB
; 0000 02F6     }
; 0000 02F7 
; 0000 02F8 
; 0000 02F9 MakeValidRealTimeDate();
_0xCE:
	RCALL _MakeValidRealTimeDate
; 0000 02FA 
; 0000 02FB LCD_LED = 1;
	SBI  0x1B,7
; 0000 02FC 
; 0000 02FD // Hello
; 0000 02FE lcd_clear();
	CALL _lcd_clear
; 0000 02FF lcd_puts("SAULES KOLEKTOR.");
	__POINTW1MN _0xD3,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0300 lcd_puts("VALDIKLIS V1.0  ");
	__POINTW1MN _0xD3,17
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0301 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0302 
; 0000 0303 
; 0000 0304 
; 0000 0305 
; 0000 0306 /*
; 0000 0307 // FAT function result
; 0000 0308 static FRESULT res;
; 0000 0309 // will hold the information for logical drive 0:
; 0000 030A static FATFS fat;
; 0000 030B // pointer to the FATFS type structure
; 0000 030C static FATFS *pfat;
; 0000 030D // number of free clusters on logical drive 0:
; 0000 030E static unsigned long free_clusters;
; 0000 030F // number of free kbytes on logical drive 0:
; 0000 0310 static unsigned long free_kbytes;
; 0000 0311 // root directory path for logical drive 0:
; 0000 0312 static char root_path[]="0:/";
; 0000 0313 */
; 0000 0314 
; 0000 0315 
; 0000 0316 
; 0000 0317 // point to the FATFS structure that holds
; 0000 0318 //information for the logical drive 0:
; 0000 0319 //pfat=&fat;
; 0000 031A 
; 0000 031B /*
; 0000 031C // mount logical drive 0:
; 0000 031D lcd_clear();
; 0000 031E if ((res=f_mount(0,pfat))==FR_OK)
; 0000 031F    lcd_puts("Logical drive 0:Mounted OK");
; 0000 0320 else
; 0000 0321    // an error occured, display it and stop
; 0000 0322    error(res);
; 0000 0323 delay_ms(2000);
; 0000 0324 */
; 0000 0325 
; 0000 0326 /*
; 0000 0327 lcd_clear();
; 0000 0328 static unsigned char disk_status;
; 0000 0329 disk_status = disk_initialize(0);
; 0000 032A     if(disk_status & STA_NOINIT) lcd_puts("Disk init failed");
; 0000 032B     else if(disk_status & STA_NODISK) lcd_puts("Card not present");
; 0000 032C     else if(disk_status & STA_PROTECT) lcd_puts("Card write\nprotected");
; 0000 032D     else lcd_puts("Init OK");
; 0000 032E delay_ms(2000);
; 0000 032F */
; 0000 0330 
; 0000 0331 
; 0000 0332 
; 0000 0333 
; 0000 0334 
; 0000 0335 /*
; 0000 0336 lcd_clear();
; 0000 0337     if((res=f_getfree(root_path,&free_clusters,&pfat))==FR_OK){
; 0000 0338     free_kbytes=free_clusters
; 0000 0339     pfat->csize/2;
; 0000 033A     lcd_puts("Free space:     ");
; 0000 033B     lcd_put_number(0,6,0,0,free_kbytes,0);
; 0000 033C     lcd_puts("kB");
; 0000 033D     }
; 0000 033E     else
; 0000 033F     error(res);
; 0000 0340 
; 0000 0341 delay_ms(3000);
; 0000 0342 */
; 0000 0343 
; 0000 0344 
; 0000 0345 
; 0000 0346 
; 0000 0347     while(1){
_0xD4:
; 0000 0348     //////////////////////////////////////////////////////////////////////////////////
; 0000 0349     ////////////////////////////// TERMODAVIKLIAI ////////////////////////////////////
; 0000 034A     //////////////////////////////////////////////////////////////////////////////////
; 0000 034B     static unsigned char TERMOSWICH;
; 0000 034C         if(TERMOSWITCH_INPUT==1){
	SBIS 0x10,7
	RJMP _0xD7
; 0000 034D             if(TERMOSWICH==0){
	LDS  R30,_TERMOSWICH_S0000010001
	CPI  R30,0
	BRNE _0xD8
; 0000 034E             TERMOSWICH = 1;
	LDI  R30,LOW(1)
	STS  _TERMOSWICH_S0000010001,R30
; 0000 034F             Address[0] = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _Address,R30
	STS  _Address+1,R31
; 0000 0350             Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0351             Address[2] = 0;
	__POINTW1MN _Address,4
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0352             ANTIFREEZE_PUMP = 1;
	SBI  0x18,1
; 0000 0353             WATER_PUMP = 1;
	SBI  0x18,0
; 0000 0354             Acceleration = 5;
	LDI  R30,LOW(5)
	MOV  R4,R30
; 0000 0355             }
; 0000 0356         }
_0xD8:
; 0000 0357         else{
	RJMP _0xDD
_0xD7:
; 0000 0358         TERMOSWICH = 0;
	LDI  R30,LOW(0)
	STS  _TERMOSWICH_S0000010001,R30
; 0000 0359         }
_0xDD:
; 0000 035A     //////////////////////////////////////////////////////////////////////////////////
; 0000 035B     //////////////////////////////////////////////////////////////////////////////////
; 0000 035C     //////////////////////////////////////////////////////////////////////////////////
; 0000 035D 
; 0000 035E 
; 0000 035F 
; 0000 0360     //////////////////////////////////////////////////////////////////////////////////
; 0000 0361     //////////////////////////// Funkcija kas 1 secunde //////////////////////////////
; 0000 0362     //////////////////////////////////////////////////////////////////////////////////
; 0000 0363     static unsigned char Called_1Second;
; 0000 0364         if(Call_1Second>=1){
	LDS  R26,_Call_1Second
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0xDE
; 0000 0365         Called_1Second = 1;
	LDI  R30,LOW(1)
	STS  _Called_1Second_S0000010001,R30
; 0000 0366         Call_1Second--;
	LDS  R30,_Call_1Second
	SUBI R30,LOW(1)
	STS  _Call_1Second,R30
; 0000 0367 
; 0000 0368         // Realus laikas
; 0000 0369             if(RealTimeSecond>=59){
	LDI  R26,LOW(_RealTimeSecond)
	LDI  R27,HIGH(_RealTimeSecond)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3B)
	BRSH PC+3
	JMP _0xDF
; 0000 036A             RealTimeSecond = 0;
	LDI  R26,LOW(_RealTimeSecond)
	LDI  R27,HIGH(_RealTimeSecond)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 036B 
; 0000 036C                 if(RealTimeMinute>=59){
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3B)
	BRGE PC+3
	JMP _0xE0
; 0000 036D                 RealTimeMinute = 0;
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 036E                     if(RealTimeHour>=23){
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x17)
	BRGE PC+3
	JMP _0xE1
; 0000 036F                     RealTimeHour = 0;
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0370                     MaxDayTemperature = SOLAR_OUTPUT_TEMP;
	LDS  R30,_SOLAR_OUTPUT_TEMP
	LDS  R31,_SOLAR_OUTPUT_TEMP+1
	LDI  R26,LOW(_MaxDayTemperature)
	LDI  R27,HIGH(_MaxDayTemperature)
	CALL __EEPROMWRW
; 0000 0371                     WattHoursPerDay = 0;
	LDI  R26,LOW(_WattHoursPerDay)
	LDI  R27,HIGH(_WattHoursPerDay)
	__GETD1N 0x0
	CALL __EEPROMWRD
; 0000 0372 
; 0000 0373                         if(DayCountInMonth(RealTimeYear,RealTimeMonth)<=RealTimeDay){
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _DayCountInMonth
	MOV  R0,R30
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	MOV  R26,R0
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	BRLT _0xE2
; 0000 0374                         RealTimeDay = 1;
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0375 
; 0000 0376                             if(RealTimeMonth>=12){
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xC)
	BRLT _0xE3
; 0000 0377                             RealTimeMonth = 1;
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0378                             RealTimeYear++;
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 0379                             }
; 0000 037A                             else{
	RJMP _0xE4
_0xE3:
; 0000 037B                             RealTimeMonth++;
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 037C                             }
_0xE4:
; 0000 037D 
; 0000 037E                         }
; 0000 037F                         else{
	RJMP _0xE5
_0xE2:
; 0000 0380                         RealTimeDay++;
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 0381                         }
_0xE5:
; 0000 0382                     }
; 0000 0383                     else{
	RJMP _0xE6
_0xE1:
; 0000 0384                     RealTimeHour++;
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 0385                     }
_0xE6:
; 0000 0386                 }
; 0000 0387                 else{
	RJMP _0xE7
_0xE0:
; 0000 0388                 RealTimeMinute++;
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 0389                 }
_0xE7:
; 0000 038A             }
; 0000 038B             else{
	RJMP _0xE8
_0xDF:
; 0000 038C             RealTimeSecond++;
	LDI  R26,LOW(_RealTimeSecond)
	LDI  R27,HIGH(_RealTimeSecond)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 038D             }
_0xE8:
; 0000 038E         /////////
; 0000 038F             if(CODE_TimeLeft>0){
	LDS  R26,_CODE_TimeLeft_G000
	CPI  R26,LOW(0x1)
	BRLO _0xE9
; 0000 0390             CODE_TimeLeft--;
	LDS  R30,_CODE_TimeLeft_G000
	SUBI R30,LOW(1)
	STS  _CODE_TimeLeft_G000,R30
; 0000 0391             }
; 0000 0392 
; 0000 0393             if(PAGRINDINIS_LANGAS<120){
_0xE9:
	LDS  R26,_PAGRINDINIS_LANGAS
	CPI  R26,LOW(0x78)
	BRSH _0xEA
; 0000 0394             PAGRINDINIS_LANGAS++;
	LDS  R30,_PAGRINDINIS_LANGAS
	SUBI R30,-LOW(1)
	STS  _PAGRINDINIS_LANGAS,R30
; 0000 0395             }
; 0000 0396         }
_0xEA:
; 0000 0397     //////////////////////////////////////////////////////////////////////////////////
; 0000 0398     //////////////////////////////////////////////////////////////////////////////////
; 0000 0399     //////////////////////////////////////////////////////////////////////////////////
; 0000 039A 
; 0000 039B 
; 0000 039C 
; 0000 039D     //////////////////////////////////////////////////////////////////////////////////
; 0000 039E     ////////////////////////////// Temperaturu Gavimas////////////////////////////////
; 0000 039F     //////////////////////////////////////////////////////////////////////////////////
; 0000 03A0         if(Called_1Second==1){
_0xDE:
	LDS  R26,_Called_1Second_S0000010001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0xEB
; 0000 03A1         static signed char SolarColectorState=-1;

	.DSEG

	.CSEG
; 0000 03A2             if(SolarColectorState==-1){
	LDS  R26,_SolarColectorState_S0000010002
	CPI  R26,LOW(0xFF)
	BRNE _0xED
; 0000 03A3             TEMPERATURE_BOIL = 1;
	RJMP _0x331
; 0000 03A4             TEMPERATURE_S_INP = 0;
; 0000 03A5             TEMPERATURE_S_OUT = 0;
; 0000 03A6             }
; 0000 03A7             else if(SolarColectorState==10){
_0xED:
	LDS  R26,_SolarColectorState_S0000010002
	CPI  R26,LOW(0xA)
	BRNE _0xF5
; 0000 03A8             BOILER_TEMP = GetTemperature();
	RCALL _GetTemperature
	MOVW R10,R30
; 0000 03A9                 if(BOILER_TEMP>999){
	LDI  R30,LOW(999)
	LDI  R31,HIGH(999)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0xF6
; 0000 03AA                 BOILER_TEMP = 999;
	RJMP _0x332
; 0000 03AB                 }
; 0000 03AC                 else if(BOILER_TEMP<-999){
_0xF6:
	LDI  R30,LOW(64537)
	LDI  R31,HIGH(64537)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0xF8
; 0000 03AD                 BOILER_TEMP = -999;
_0x332:
	MOVW R10,R30
; 0000 03AE                 }
; 0000 03AF 
; 0000 03B0             TEMPERATURE_BOIL = 0;
_0xF8:
	CBI  0x1B,1
; 0000 03B1             TEMPERATURE_S_INP = 1;
	SBI  0x1B,2
; 0000 03B2             TEMPERATURE_S_OUT = 0;
	RJMP _0x333
; 0000 03B3             }
; 0000 03B4             else if(SolarColectorState==20){
_0xF5:
	LDS  R26,_SolarColectorState_S0000010002
	CPI  R26,LOW(0x14)
	BRNE _0x100
; 0000 03B5             LAST_SOLAR_INPUT_TEMP = SOLAR_INPUT_TEMP;
	MOVW R6,R12
; 0000 03B6             SOLAR_INPUT_TEMP = GetTemperature();
	RCALL _GetTemperature
	MOVW R12,R30
; 0000 03B7                 if(SOLAR_INPUT_TEMP>999){
	LDI  R30,LOW(999)
	LDI  R31,HIGH(999)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x101
; 0000 03B8                 SOLAR_INPUT_TEMP = 999;
	RJMP _0x334
; 0000 03B9                 }
; 0000 03BA                 else if(SOLAR_INPUT_TEMP<-999){
_0x101:
	LDI  R30,LOW(64537)
	LDI  R31,HIGH(64537)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x103
; 0000 03BB                 SOLAR_INPUT_TEMP = -999;
_0x334:
	MOVW R12,R30
; 0000 03BC                 }
; 0000 03BD 
; 0000 03BE                 if(MaxDayTemperature<SOLAR_INPUT_TEMP){
_0x103:
	LDI  R26,LOW(_MaxDayTemperature)
	LDI  R27,HIGH(_MaxDayTemperature)
	CALL __EEPROMRDW
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x104
; 0000 03BF                 MaxDayTemperature = SOLAR_INPUT_TEMP;
	MOVW R30,R12
	LDI  R26,LOW(_MaxDayTemperature)
	LDI  R27,HIGH(_MaxDayTemperature)
	CALL __EEPROMWRW
; 0000 03C0                 }
; 0000 03C1 
; 0000 03C2             TEMPERATURE_BOIL = 0;
_0x104:
	CBI  0x1B,1
; 0000 03C3             TEMPERATURE_S_INP = 0;
	CBI  0x1B,2
; 0000 03C4             TEMPERATURE_S_OUT = 1;
	SBI  0x1B,3
; 0000 03C5             }
; 0000 03C6             else if(SolarColectorState==30){
	RJMP _0x10B
_0x100:
	LDS  R26,_SolarColectorState_S0000010002
	CPI  R26,LOW(0x1E)
	BRNE _0x10C
; 0000 03C7             SolarColectorState = 0;
	LDI  R30,LOW(0)
	STS  _SolarColectorState_S0000010002,R30
; 0000 03C8 
; 0000 03C9             LAST_SOLAR_OUTPUT_TEMP = SOLAR_OUTPUT_TEMP;
	__GETWRMN 8,9,0,_SOLAR_OUTPUT_TEMP
; 0000 03CA             SOLAR_OUTPUT_TEMP = GetTemperature();
	RCALL _GetTemperature
	STS  _SOLAR_OUTPUT_TEMP,R30
	STS  _SOLAR_OUTPUT_TEMP+1,R31
; 0000 03CB                 if(SOLAR_OUTPUT_TEMP>999){
	LDS  R26,_SOLAR_OUTPUT_TEMP
	LDS  R27,_SOLAR_OUTPUT_TEMP+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLT _0x10D
; 0000 03CC                 SOLAR_OUTPUT_TEMP = 999;
	LDI  R30,LOW(999)
	LDI  R31,HIGH(999)
	RJMP _0x335
; 0000 03CD                 }
; 0000 03CE                 else if(SOLAR_OUTPUT_TEMP<-999){
_0x10D:
	LDS  R26,_SOLAR_OUTPUT_TEMP
	LDS  R27,_SOLAR_OUTPUT_TEMP+1
	CPI  R26,LOW(0xFC19)
	LDI  R30,HIGH(0xFC19)
	CPC  R27,R30
	BRGE _0x10F
; 0000 03CF                 SOLAR_OUTPUT_TEMP = -999;
	LDI  R30,LOW(64537)
	LDI  R31,HIGH(64537)
_0x335:
	STS  _SOLAR_OUTPUT_TEMP,R30
	STS  _SOLAR_OUTPUT_TEMP+1,R31
; 0000 03D0                 }
; 0000 03D1 
; 0000 03D2                 if(MaxDayTemperature<SOLAR_OUTPUT_TEMP){
_0x10F:
	LDI  R26,LOW(_MaxDayTemperature)
	LDI  R27,HIGH(_MaxDayTemperature)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDS  R30,_SOLAR_OUTPUT_TEMP
	LDS  R31,_SOLAR_OUTPUT_TEMP+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x110
; 0000 03D3                 MaxDayTemperature = SOLAR_OUTPUT_TEMP;
	LDI  R26,LOW(_MaxDayTemperature)
	LDI  R27,HIGH(_MaxDayTemperature)
	CALL __EEPROMWRW
; 0000 03D4                 }
; 0000 03D5 
; 0000 03D6             TEMPERATURE_BOIL = 1;
_0x110:
_0x331:
	SBI  0x1B,1
; 0000 03D7             TEMPERATURE_S_INP = 0;
	CBI  0x1B,2
; 0000 03D8             TEMPERATURE_S_OUT = 0;
_0x333:
	CBI  0x1B,3
; 0000 03D9             }
; 0000 03DA         SolarColectorState++;
_0x10C:
_0x10B:
	LDS  R30,_SolarColectorState_S0000010002
	SUBI R30,-LOW(1)
	STS  _SolarColectorState_S0000010002,R30
; 0000 03DB         }
; 0000 03DC     //////////////////////////////////////////////////////////////////////////////////
; 0000 03DD     //////////////////////////////////////////////////////////////////////////////////
; 0000 03DE     //////////////////////////////////////////////////////////////////////////////////
; 0000 03DF 
; 0000 03E0 
; 0000 03E1 
; 0000 03E2     //////////////////////////////////////////////////////////////////////////////////
; 0000 03E3     ////////////////////////////////// Perjungti Siurblius ///////////////////////////
; 0000 03E4     //////////////////////////////////////////////////////////////////////////////////
; 0000 03E5         if(Called_1Second==1){
_0xEB:
	LDS  R26,_Called_1Second_S0000010001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x117
; 0000 03E6 
; 0000 03E7             if(SOLAR_OUTPUT_TEMP>LAST_SOLAR_OUTPUT_TEMP){
	LDS  R26,_SOLAR_OUTPUT_TEMP
	LDS  R27,_SOLAR_OUTPUT_TEMP+1
	CP   R8,R26
	CPC  R9,R27
	BRGE _0x118
; 0000 03E8                 if(Acceleration<5){
	LDI  R30,LOW(5)
	CP   R4,R30
	BRSH _0x119
; 0000 03E9                 Acceleration++;
	INC  R4
; 0000 03EA                 }
; 0000 03EB             }
_0x119:
; 0000 03EC             else{
	RJMP _0x11A
_0x118:
; 0000 03ED                 if(Acceleration>0){
	LDI  R30,LOW(0)
	CP   R30,R4
	BRSH _0x11B
; 0000 03EE                 Acceleration--;
	DEC  R4
; 0000 03EF                 }
; 0000 03F0             }
_0x11B:
_0x11A:
; 0000 03F1 
; 0000 03F2             if(SOLAR_OUTPUT_TEMP>DifferenceBoilerAndSolar+BOILER_TEMP){
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	ADD  R30,R10
	ADC  R31,R11
	LDS  R26,_SOLAR_OUTPUT_TEMP
	LDS  R27,_SOLAR_OUTPUT_TEMP+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x11C
; 0000 03F3             WATER_PUMP = 1;
	SBI  0x18,0
; 0000 03F4             Acceleration = 5;
	LDI  R30,LOW(5)
	MOV  R4,R30
; 0000 03F5             }
; 0000 03F6             else{
	RJMP _0x11F
_0x11C:
; 0000 03F7             WATER_PUMP = 0;
	CBI  0x18,0
; 0000 03F8             }
_0x11F:
; 0000 03F9 
; 0000 03FA             if(Acceleration>=5){
	LDI  R30,LOW(5)
	CP   R4,R30
	BRLO _0x122
; 0000 03FB                 if(SOLAR_OUTPUT_TEMP>=MinimumAntifreezeTemp){
	LDI  R26,LOW(_MinimumAntifreezeTemp)
	LDI  R27,HIGH(_MinimumAntifreezeTemp)
	CALL __EEPROMRDW
	LDS  R26,_SOLAR_OUTPUT_TEMP
	LDS  R27,_SOLAR_OUTPUT_TEMP+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x123
; 0000 03FC                 ANTIFREEZE_PUMP = 1;
	SBI  0x18,1
; 0000 03FD                 }
; 0000 03FE                 else{
	RJMP _0x126
_0x123:
; 0000 03FF                 ANTIFREEZE_PUMP = 0;
	CBI  0x18,1
; 0000 0400                 }
_0x126:
; 0000 0401             }
; 0000 0402             else if(Acceleration<=0){
	RJMP _0x129
_0x122:
	TST  R4
	BRNE _0x12A
; 0000 0403             ANTIFREEZE_PUMP = 0;
	CBI  0x18,1
; 0000 0404             }
; 0000 0405 
; 0000 0406             if((SOLAR_OUTPUT_TEMP>=850)||(SOLAR_INPUT_TEMP>=850)){
_0x12A:
_0x129:
	LDS  R26,_SOLAR_OUTPUT_TEMP
	LDS  R27,_SOLAR_OUTPUT_TEMP+1
	CPI  R26,LOW(0x352)
	LDI  R30,HIGH(0x352)
	CPC  R27,R30
	BRGE _0x12E
	LDI  R30,LOW(850)
	LDI  R31,HIGH(850)
	CP   R12,R30
	CPC  R13,R31
	BRLT _0x12D
_0x12E:
; 0000 0407             ANTIFREEZE_PUMP = 1;
	SBI  0x18,1
; 0000 0408             WATER_PUMP = 1;
	SBI  0x18,0
; 0000 0409             Acceleration = 5;
	LDI  R30,LOW(5)
	MOV  R4,R30
; 0000 040A             }
; 0000 040B 
; 0000 040C             if(TERMOSWITCH_INPUT==1){
_0x12D:
	SBIS 0x10,7
	RJMP _0x134
; 0000 040D             ANTIFREEZE_PUMP = 1;
	SBI  0x18,1
; 0000 040E             WATER_PUMP = 1;
	SBI  0x18,0
; 0000 040F             Acceleration = 5;
	LDI  R30,LOW(5)
	MOV  R4,R30
; 0000 0410             }
; 0000 0411         }
_0x134:
; 0000 0412     //////////////////////////////////////////////////////////////////////////////////
; 0000 0413     //////////////////////////////////////////////////////////////////////////////////
; 0000 0414     //////////////////////////////////////////////////////////////////////////////////
; 0000 0415 
; 0000 0416 
; 0000 0417 
; 0000 0418     //////////////////////////////////////////////////////////////////////////////////
; 0000 0419     ///////////////////////// Atlikto darbo ir galios apskaiciavimas /////////////////
; 0000 041A     //////////////////////////////////////////////////////////////////////////////////
; 0000 041B         if(Called_1Second==1){
_0x117:
	LDS  R26,_Called_1Second_S0000010001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x139
; 0000 041C         static unsigned char CHECK_JOB_POWER;
; 0000 041D         CHECK_JOB_POWER++;
	LDS  R30,_CHECK_JOB_POWER_S0000010002
	SUBI R30,-LOW(1)
	STS  _CHECK_JOB_POWER_S0000010002,R30
; 0000 041E             if(CHECK_JOB_POWER>=30){
	LDS  R26,_CHECK_JOB_POWER_S0000010002
	CPI  R26,LOW(0x1E)
	BRSH PC+3
	JMP _0x13A
; 0000 041F             static signed int SolarPower;
; 0000 0420             int InputTemperature = (LAST_SOLAR_INPUT_TEMP+SOLAR_INPUT_TEMP)/2;
; 0000 0421             int OutputTemperature = (LAST_SOLAR_OUTPUT_TEMP+SOLAR_OUTPUT_TEMP)/2;
; 0000 0422             int TemperatureDifference = OutputTemperature - InputTemperature;
; 0000 0423 
; 0000 0424 
; 0000 0425                 if(TemperatureDifference>0){
	SBIW R28,6
;	InputTemperature -> Y+4
;	OutputTemperature -> Y+2
;	TemperatureDifference -> Y+0
	MOVW R26,R12
	ADD  R26,R6
	ADC  R27,R7
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDS  R26,_SOLAR_OUTPUT_TEMP
	LDS  R27,_SOLAR_OUTPUT_TEMP+1
	ADD  R26,R8
	ADC  R27,R9
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	STD  Y+2,R30
	STD  Y+2+1,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SUB  R30,R26
	SBC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	BRLT PC+3
	JMP _0x13B
; 0000 0426                     if(ANTIFREEZE_PUMP==1){
	SBIS 0x18,1
	RJMP _0x13C
; 0000 0427                     unsigned int Job;
; 0000 0428 
; 0000 0429                     Job = (LitersPerMinute*TemperatureDifference)/170;
	SBIW R28,2
;	InputTemperature -> Y+6
;	OutputTemperature -> Y+4
;	TemperatureDifference -> Y+2
;	Job -> Y+0
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	CALL __DIVW21
	ST   Y,R30
	STD  Y+1,R31
; 0000 042A                     SolarColectorWattHours += Job;
	LDI  R26,LOW(_SolarColectorWattHours)
	LDI  R27,HIGH(_SolarColectorWattHours)
	CALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	LD   R30,Y
	LDD  R31,Y+1
	CLR  R22
	CLR  R23
	CALL __ADDD12
	LDI  R26,LOW(_SolarColectorWattHours)
	LDI  R27,HIGH(_SolarColectorWattHours)
	CALL __EEPROMWRD
; 0000 042B                     WattHoursPerDay += Job;
	LDI  R26,LOW(_WattHoursPerDay)
	LDI  R27,HIGH(_WattHoursPerDay)
	CALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	LD   R30,Y
	LDD  R31,Y+1
	CLR  R22
	CLR  R23
	CALL __ADDD12
	LDI  R26,LOW(_WattHoursPerDay)
	LDI  R27,HIGH(_WattHoursPerDay)
	CALL __EEPROMWRD
; 0000 042C 
; 0000 042D 
; 0000 042E                     SolarPower = ((LitersPerMinute*TemperatureDifference)/3)*2;
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21
	LSL  R30
	ROL  R31
	STS  _SolarPower_S0000010003,R30
	STS  _SolarPower_S0000010003+1,R31
; 0000 042F                     }
	ADIW R28,2
; 0000 0430                     else{
	RJMP _0x13D
_0x13C:
; 0000 0431                     SolarPower = 0;
	LDI  R30,LOW(0)
	STS  _SolarPower_S0000010003,R30
	STS  _SolarPower_S0000010003+1,R30
; 0000 0432                     }
_0x13D:
; 0000 0433                 }
; 0000 0434                 else{
	RJMP _0x13E
_0x13B:
; 0000 0435                 SolarPower = 0;
	LDI  R30,LOW(0)
	STS  _SolarPower_S0000010003,R30
	STS  _SolarPower_S0000010003+1,R30
; 0000 0436                 }
_0x13E:
; 0000 0437 
; 0000 0438             CHECK_JOB_POWER = 0;
	LDI  R30,LOW(0)
	STS  _CHECK_JOB_POWER_S0000010002,R30
; 0000 0439             }
	ADIW R28,6
; 0000 043A         }
_0x13A:
; 0000 043B     //////////////////////////////////////////////////////////////////////////////////
; 0000 043C     //////////////////////////////////////////////////////////////////////////////////
; 0000 043D     //////////////////////////////////////////////////////////////////////////////////
; 0000 043E 
; 0000 043F 
; 0000 0440 
; 0000 0441     //////////////////////////////////////////////////////////////////////////////////
; 0000 0442     /////////////////////////////////// Ivykiai //////////////////////////////////////
; 0000 0443     //////////////////////////////////////////////////////////////////////////////////
; 0000 0444     static char LOGS_Termoswich;
_0x139:
; 0000 0445     // 95C Apsauga isijungiant
; 0000 0446         if(LOGS_Termoswich==0){
	LDS  R30,_LOGS_Termoswich_S0000010001
	CPI  R30,0
	BREQ PC+3
	JMP _0x13F
; 0000 0447             if(TERMOSWITCH_INPUT==1){
	SBIS 0x10,7
	RJMP _0x140
; 0000 0448             char id;
; 0000 0449             id = GetOldestLogID();
	SBIW R28,1
;	id -> Y+0
	RCALL _GetOldestLogID
	ST   Y,R30
; 0000 044A             LOGS_Termoswich = 1;
	LDI  R30,LOW(1)
	STS  _LOGS_Termoswich_S0000010001,R30
; 0000 044B 
; 0000 044C             LogYear[id] = RealTimeYear;
	LD   R30,Y
	LDI  R26,LOW(_LogYear)
	LDI  R27,HIGH(_LogYear)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	MOVW R26,R0
	CALL __EEPROMWRW
; 0000 044D             LogMonth[id] = RealTimeMonth;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogMonth)
	SBCI R31,HIGH(-_LogMonth)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 044E             LogDay[id] = RealTimeDay;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogDay)
	SBCI R31,HIGH(-_LogDay)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 044F             LogHour[id] = RealTimeHour;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogHour)
	SBCI R31,HIGH(-_LogHour)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 0450             LogMinute[id] = RealTimeMinute;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogMinute)
	SBCI R31,HIGH(-_LogMinute)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 0451 
; 0000 0452             LogType[id] = 1;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_LogType)
	SBCI R27,HIGH(-_LogType)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0453 
; 0000 0454             LogData1[id] = SOLAR_OUTPUT_TEMP/10;
	LD   R30,Y
	LDI  R26,LOW(_LogData1)
	LDI  R27,HIGH(_LogData1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDS  R26,_SOLAR_OUTPUT_TEMP
	LDS  R27,_SOLAR_OUTPUT_TEMP+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 0455             LogData2[id] = BOILER_TEMP/10;
	LD   R30,Y
	LDI  R26,LOW(_LogData2)
	LDI  R27,HIGH(_LogData2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R26,R10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 0456 
; 0000 0457             NewestLog = id;
	LD   R30,Y
	LDI  R26,LOW(_NewestLog)
	LDI  R27,HIGH(_NewestLog)
	CALL __EEPROMWRB
; 0000 0458             }
	ADIW R28,1
; 0000 0459         }
_0x140:
; 0000 045A 
; 0000 045B     // 95C Apsauga issijungiant
; 0000 045C         if(LOGS_Termoswich==1){
_0x13F:
	LDS  R26,_LOGS_Termoswich_S0000010001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x141
; 0000 045D             if(TERMOSWITCH_INPUT==0){
	SBIC 0x10,7
	RJMP _0x142
; 0000 045E             char id;
; 0000 045F             id = GetOldestLogID();
	SBIW R28,1
;	id -> Y+0
	RCALL _GetOldestLogID
	ST   Y,R30
; 0000 0460             LOGS_Termoswich = 0;
	LDI  R30,LOW(0)
	STS  _LOGS_Termoswich_S0000010001,R30
; 0000 0461 
; 0000 0462             LogYear[id] = RealTimeYear;
	LD   R30,Y
	LDI  R26,LOW(_LogYear)
	LDI  R27,HIGH(_LogYear)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	MOVW R26,R0
	CALL __EEPROMWRW
; 0000 0463             LogMonth[id] = RealTimeMonth;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogMonth)
	SBCI R31,HIGH(-_LogMonth)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 0464             LogDay[id] = RealTimeDay;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogDay)
	SBCI R31,HIGH(-_LogDay)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 0465             LogHour[id] = RealTimeHour;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogHour)
	SBCI R31,HIGH(-_LogHour)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 0466             LogMinute[id] = RealTimeMinute;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogMinute)
	SBCI R31,HIGH(-_LogMinute)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 0467 
; 0000 0468             LogType[id] = 2;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_LogType)
	SBCI R27,HIGH(-_LogType)
	LDI  R30,LOW(2)
	CALL __EEPROMWRB
; 0000 0469 
; 0000 046A             LogData1[id] = SOLAR_OUTPUT_TEMP/10;
	LD   R30,Y
	LDI  R26,LOW(_LogData1)
	LDI  R27,HIGH(_LogData1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDS  R26,_SOLAR_OUTPUT_TEMP
	LDS  R27,_SOLAR_OUTPUT_TEMP+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 046B             LogData2[id] = BOILER_TEMP/10;
	LD   R30,Y
	LDI  R26,LOW(_LogData2)
	LDI  R27,HIGH(_LogData2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R26,R10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 046C 
; 0000 046D             NewestLog = id;
	LD   R30,Y
	LDI  R26,LOW(_NewestLog)
	LDI  R27,HIGH(_NewestLog)
	CALL __EEPROMWRB
; 0000 046E             }
	ADIW R28,1
; 0000 046F         }
_0x142:
; 0000 0470 
; 0000 0471     // Atnaujinti issijungimo irasa
; 0000 0472         if(Called_1Second==1){
_0x141:
	LDS  R26,_Called_1Second_S0000010001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x143
; 0000 0473         char id;
; 0000 0474         id = GetOldestLogID();
	SBIW R28,1
;	id -> Y+0
	RCALL _GetOldestLogID
	ST   Y,R30
; 0000 0475         LOGS_Termoswich = 0;
	LDI  R30,LOW(0)
	STS  _LOGS_Termoswich_S0000010001,R30
; 0000 0476 
; 0000 0477         LogYear[id] = RealTimeYear;
	LD   R30,Y
	LDI  R26,LOW(_LogYear)
	LDI  R27,HIGH(_LogYear)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	MOVW R26,R0
	CALL __EEPROMWRW
; 0000 0478         LogMonth[id] = RealTimeMonth;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogMonth)
	SBCI R31,HIGH(-_LogMonth)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 0479         LogDay[id] = RealTimeDay;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogDay)
	SBCI R31,HIGH(-_LogDay)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 047A         LogHour[id] = RealTimeHour;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogHour)
	SBCI R31,HIGH(-_LogHour)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 047B         LogMinute[id] = RealTimeMinute;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_LogMinute)
	SBCI R31,HIGH(-_LogMinute)
	MOVW R0,R30
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 047C 
; 0000 047D         LogType[id] = 99;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_LogType)
	SBCI R27,HIGH(-_LogType)
	LDI  R30,LOW(99)
	CALL __EEPROMWRB
; 0000 047E 
; 0000 047F         LogData1[id] = SOLAR_OUTPUT_TEMP/10;
	LD   R30,Y
	LDI  R26,LOW(_LogData1)
	LDI  R27,HIGH(_LogData1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDS  R26,_SOLAR_OUTPUT_TEMP
	LDS  R27,_SOLAR_OUTPUT_TEMP+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 0480         LogData2[id] = BOILER_TEMP/10;
	LD   R30,Y
	LDI  R26,LOW(_LogData2)
	LDI  R27,HIGH(_LogData2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R26,R10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 0481         }
	ADIW R28,1
; 0000 0482     //////////////////////////////////////////////////////////////////////////////////
; 0000 0483     //////////////////////////////////////////////////////////////////////////////////
; 0000 0484     //////////////////////////////////////////////////////////////////////////////////
; 0000 0485 
; 0000 0486 
; 0000 0487 
; 0000 0488     //////////////////////////////////////////////////////////////////////////////////
; 0000 0489     /////////////////////////////////////// Mygtukai /////////////////////////////////
; 0000 048A     //////////////////////////////////////////////////////////////////////////////////
; 0000 048B     static char BUTTON[5], ButtonFilter[5];
_0x143:
; 0000 048C     static char DUAL_BUTTON[4], DualButtonFilter[4];
; 0000 048D 
; 0000 048E     // 1 Mygtukas
; 0000 048F         if(BUTTON_INPUT1==1){
	SBIS 0x10,6
	RJMP _0x144
; 0000 0490         PAGRINDINIS_LANGAS = 0;
	LDI  R30,LOW(0)
	STS  _PAGRINDINIS_LANGAS,R30
; 0000 0491             if(DualButtonFilter[0]<ButtonFiltrationTimer){
	LDS  R26,_DualButtonFilter_S0000010001
	CPI  R26,LOW(0x14)
	BRSH _0x145
; 0000 0492                 if(ButtonFilter[0]<ButtonFiltrationTimer){
	LDS  R26,_ButtonFilter_S0000010001
	CPI  R26,LOW(0x14)
	BRSH _0x146
; 0000 0493                 ButtonFilter[0]++;
	LDS  R30,_ButtonFilter_S0000010001
	SUBI R30,-LOW(1)
	STS  _ButtonFilter_S0000010001,R30
; 0000 0494                 }
; 0000 0495             }
_0x146:
; 0000 0496         }
_0x145:
; 0000 0497         else{
	RJMP _0x147
_0x144:
; 0000 0498             if(ButtonFilter[0]>=ButtonFiltrationTimer){
	LDS  R26,_ButtonFilter_S0000010001
	CPI  R26,LOW(0x14)
	BRLO _0x148
; 0000 0499             BUTTON[0] = 1;
	LDI  R30,LOW(1)
	STS  _BUTTON_S0000010001,R30
; 0000 049A             RefreshLcd = 1;
	MOV  R5,R30
; 0000 049B             }
; 0000 049C             else{
	RJMP _0x149
_0x148:
; 0000 049D             BUTTON[0] = 0;
	LDI  R30,LOW(0)
	STS  _BUTTON_S0000010001,R30
; 0000 049E             }
_0x149:
; 0000 049F         ButtonFilter[0] = 0;
	LDI  R30,LOW(0)
	STS  _ButtonFilter_S0000010001,R30
; 0000 04A0         }
_0x147:
; 0000 04A1 
; 0000 04A2     // 1 ir 2 Mygtukas
; 0000 04A3         if((BUTTON_INPUT1==1)&&(BUTTON_INPUT2==1)){
	SBIS 0x10,6
	RJMP _0x14B
	SBIC 0x10,5
	RJMP _0x14C
_0x14B:
	RJMP _0x14A
_0x14C:
; 0000 04A4         ButtonFilter[0] = 0;
	LDI  R30,LOW(0)
	STS  _ButtonFilter_S0000010001,R30
; 0000 04A5         ButtonFilter[1] = 0;
	__PUTB1MN _ButtonFilter_S0000010001,1
; 0000 04A6             if(DualButtonFilter[0]<ButtonFiltrationTimer){
	LDS  R26,_DualButtonFilter_S0000010001
	CPI  R26,LOW(0x14)
	BRSH _0x14D
; 0000 04A7             DualButtonFilter[0]++;
	LDS  R30,_DualButtonFilter_S0000010001
	SUBI R30,-LOW(1)
	STS  _DualButtonFilter_S0000010001,R30
; 0000 04A8             }
; 0000 04A9         }
_0x14D:
; 0000 04AA         else if((BUTTON_INPUT1==0)&&(BUTTON_INPUT2==0)){
	RJMP _0x14E
_0x14A:
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x150
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x151
_0x150:
	RJMP _0x14F
_0x151:
; 0000 04AB             if(DualButtonFilter[0]>=ButtonFiltrationTimer){
	LDS  R26,_DualButtonFilter_S0000010001
	CPI  R26,LOW(0x14)
	BRLO _0x152
; 0000 04AC             DUAL_BUTTON[0] = 1;
	LDI  R30,LOW(1)
	STS  _DUAL_BUTTON_S0000010001,R30
; 0000 04AD             RefreshLcd = 1;
	MOV  R5,R30
; 0000 04AE             }
; 0000 04AF             else{
	RJMP _0x153
_0x152:
; 0000 04B0             DUAL_BUTTON[0] = 0;
	LDI  R30,LOW(0)
	STS  _DUAL_BUTTON_S0000010001,R30
; 0000 04B1             }
_0x153:
; 0000 04B2         DualButtonFilter[0] = 0;
	LDI  R30,LOW(0)
	STS  _DualButtonFilter_S0000010001,R30
; 0000 04B3         }
; 0000 04B4 
; 0000 04B5     // 2 Mygtukas
; 0000 04B6         if(BUTTON_INPUT2==1){
_0x14F:
_0x14E:
	SBIS 0x10,5
	RJMP _0x154
; 0000 04B7         PAGRINDINIS_LANGAS = 0;
	LDI  R30,LOW(0)
	STS  _PAGRINDINIS_LANGAS,R30
; 0000 04B8             if(DualButtonFilter[0]<ButtonFiltrationTimer){
	LDS  R26,_DualButtonFilter_S0000010001
	CPI  R26,LOW(0x14)
	BRSH _0x155
; 0000 04B9                 if(ButtonFilter[1]<ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000010001,1
	CPI  R26,LOW(0x14)
	BRSH _0x156
; 0000 04BA                 ButtonFilter[1]++;
	__GETB1MN _ButtonFilter_S0000010001,1
	SUBI R30,-LOW(1)
	__PUTB1MN _ButtonFilter_S0000010001,1
; 0000 04BB                 }
; 0000 04BC             }
_0x156:
; 0000 04BD         }
_0x155:
; 0000 04BE         else{
	RJMP _0x157
_0x154:
; 0000 04BF             if(ButtonFilter[1]>=ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000010001,1
	CPI  R26,LOW(0x14)
	BRLO _0x158
; 0000 04C0             BUTTON[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _BUTTON_S0000010001,1
; 0000 04C1             RefreshLcd = 1;
	MOV  R5,R30
; 0000 04C2             }
; 0000 04C3             else{
	RJMP _0x159
_0x158:
; 0000 04C4             BUTTON[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _BUTTON_S0000010001,1
; 0000 04C5             }
_0x159:
; 0000 04C6         ButtonFilter[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000010001,1
; 0000 04C7         }
_0x157:
; 0000 04C8 
; 0000 04C9     // 2 ir 3 Mygtukas
; 0000 04CA         if((BUTTON_INPUT2==1)&&(BUTTON_INPUT3==1)){
	SBIS 0x10,5
	RJMP _0x15B
	SBIC 0x10,4
	RJMP _0x15C
_0x15B:
	RJMP _0x15A
_0x15C:
; 0000 04CB         ButtonFilter[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000010001,1
; 0000 04CC         ButtonFilter[2] = 0;
	__PUTB1MN _ButtonFilter_S0000010001,2
; 0000 04CD             if(DualButtonFilter[1]<ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000010001,1
	CPI  R26,LOW(0x14)
	BRSH _0x15D
; 0000 04CE             DualButtonFilter[1]++;
	__GETB1MN _DualButtonFilter_S0000010001,1
	SUBI R30,-LOW(1)
	__PUTB1MN _DualButtonFilter_S0000010001,1
; 0000 04CF             }
; 0000 04D0         }
_0x15D:
; 0000 04D1         else if((BUTTON_INPUT2==0)&&(BUTTON_INPUT3==0)){
	RJMP _0x15E
_0x15A:
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x160
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x161
_0x160:
	RJMP _0x15F
_0x161:
; 0000 04D2             if(DualButtonFilter[1]>=ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000010001,1
	CPI  R26,LOW(0x14)
	BRLO _0x162
; 0000 04D3             DUAL_BUTTON[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _DUAL_BUTTON_S0000010001,1
; 0000 04D4             RefreshLcd = 1;
	MOV  R5,R30
; 0000 04D5             }
; 0000 04D6             else{
	RJMP _0x163
_0x162:
; 0000 04D7             DUAL_BUTTON[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DUAL_BUTTON_S0000010001,1
; 0000 04D8             }
_0x163:
; 0000 04D9         DualButtonFilter[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DualButtonFilter_S0000010001,1
; 0000 04DA         }
; 0000 04DB 
; 0000 04DC     // 3 Mygtukas
; 0000 04DD         if(BUTTON_INPUT3==1){
_0x15F:
_0x15E:
	SBIS 0x10,4
	RJMP _0x164
; 0000 04DE         PAGRINDINIS_LANGAS = 0;
	LDI  R30,LOW(0)
	STS  _PAGRINDINIS_LANGAS,R30
; 0000 04DF             if(ButtonFilter[2]<ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000010001,2
	CPI  R26,LOW(0x14)
	BRSH _0x165
; 0000 04E0             ButtonFilter[2]++;
	__GETB1MN _ButtonFilter_S0000010001,2
	SUBI R30,-LOW(1)
	__PUTB1MN _ButtonFilter_S0000010001,2
; 0000 04E1             }
; 0000 04E2         }
_0x165:
; 0000 04E3         else{
	RJMP _0x166
_0x164:
; 0000 04E4             if(ButtonFilter[2]>=ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000010001,2
	CPI  R26,LOW(0x14)
	BRLO _0x167
; 0000 04E5             BUTTON[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _BUTTON_S0000010001,2
; 0000 04E6             RefreshLcd = 1;
	MOV  R5,R30
; 0000 04E7             }
; 0000 04E8             else{
	RJMP _0x168
_0x167:
; 0000 04E9             BUTTON[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _BUTTON_S0000010001,2
; 0000 04EA             }
_0x168:
; 0000 04EB         ButtonFilter[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000010001,2
; 0000 04EC         }
_0x166:
; 0000 04ED 
; 0000 04EE     // 3 ir 4 Mygtukas
; 0000 04EF         if((BUTTON_INPUT3==1)&&(BUTTON_INPUT4==1)){
	SBIS 0x10,4
	RJMP _0x16A
	SBIC 0x10,3
	RJMP _0x16B
_0x16A:
	RJMP _0x169
_0x16B:
; 0000 04F0         ButtonFilter[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000010001,2
; 0000 04F1         ButtonFilter[3] = 0;
	__PUTB1MN _ButtonFilter_S0000010001,3
; 0000 04F2             if(DualButtonFilter[2]<ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000010001,2
	CPI  R26,LOW(0x14)
	BRSH _0x16C
; 0000 04F3             DualButtonFilter[2]++;
	__GETB1MN _DualButtonFilter_S0000010001,2
	SUBI R30,-LOW(1)
	__PUTB1MN _DualButtonFilter_S0000010001,2
; 0000 04F4             }
; 0000 04F5         }
_0x16C:
; 0000 04F6         else if((BUTTON_INPUT3==0)&&(BUTTON_INPUT4==0)){
	RJMP _0x16D
_0x169:
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x16F
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x170
_0x16F:
	RJMP _0x16E
_0x170:
; 0000 04F7             if(DualButtonFilter[2]>=ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000010001,2
	CPI  R26,LOW(0x14)
	BRLO _0x171
; 0000 04F8             DUAL_BUTTON[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _DUAL_BUTTON_S0000010001,2
; 0000 04F9             RefreshLcd = 1;
	MOV  R5,R30
; 0000 04FA             }
; 0000 04FB             else{
	RJMP _0x172
_0x171:
; 0000 04FC             DUAL_BUTTON[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DUAL_BUTTON_S0000010001,2
; 0000 04FD             }
_0x172:
; 0000 04FE         DualButtonFilter[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DualButtonFilter_S0000010001,2
; 0000 04FF         }
; 0000 0500 
; 0000 0501     // 4 Mygtukas
; 0000 0502         if(BUTTON_INPUT4==1){
_0x16E:
_0x16D:
	SBIS 0x10,3
	RJMP _0x173
; 0000 0503         PAGRINDINIS_LANGAS = 0;
	LDI  R30,LOW(0)
	STS  _PAGRINDINIS_LANGAS,R30
; 0000 0504             if(ButtonFilter[3]<ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000010001,3
	CPI  R26,LOW(0x14)
	BRSH _0x174
; 0000 0505             ButtonFilter[3]++;
	__GETB1MN _ButtonFilter_S0000010001,3
	SUBI R30,-LOW(1)
	__PUTB1MN _ButtonFilter_S0000010001,3
; 0000 0506             }
; 0000 0507         }
_0x174:
; 0000 0508         else{
	RJMP _0x175
_0x173:
; 0000 0509             if(ButtonFilter[3]>=ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000010001,3
	CPI  R26,LOW(0x14)
	BRLO _0x176
; 0000 050A             BUTTON[3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _BUTTON_S0000010001,3
; 0000 050B             RefreshLcd = 1;
	MOV  R5,R30
; 0000 050C             }
; 0000 050D             else{
	RJMP _0x177
_0x176:
; 0000 050E             BUTTON[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _BUTTON_S0000010001,3
; 0000 050F             }
_0x177:
; 0000 0510         ButtonFilter[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000010001,3
; 0000 0511         }
_0x175:
; 0000 0512 
; 0000 0513     // 4 ir 5 Mygtukas
; 0000 0514         if((BUTTON_INPUT4==1)&&(BUTTON_INPUT5==1)){
	SBIS 0x10,3
	RJMP _0x179
	SBIC 0x10,2
	RJMP _0x17A
_0x179:
	RJMP _0x178
_0x17A:
; 0000 0515         ButtonFilter[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000010001,3
; 0000 0516         ButtonFilter[4] = 0;
	__PUTB1MN _ButtonFilter_S0000010001,4
; 0000 0517             if(DualButtonFilter[3]<ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000010001,3
	CPI  R26,LOW(0x14)
	BRSH _0x17B
; 0000 0518             DualButtonFilter[3]++;
	__GETB1MN _DualButtonFilter_S0000010001,3
	SUBI R30,-LOW(1)
	__PUTB1MN _DualButtonFilter_S0000010001,3
; 0000 0519             }
; 0000 051A         }
_0x17B:
; 0000 051B         else if((BUTTON_INPUT4==0)&&(BUTTON_INPUT5==0)){
	RJMP _0x17C
_0x178:
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x17E
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x17F
_0x17E:
	RJMP _0x17D
_0x17F:
; 0000 051C             if(DualButtonFilter[3]>=ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000010001,3
	CPI  R26,LOW(0x14)
	BRLO _0x180
; 0000 051D             DUAL_BUTTON[3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _DUAL_BUTTON_S0000010001,3
; 0000 051E             RefreshLcd = 1;
	MOV  R5,R30
; 0000 051F             }
; 0000 0520             else{
	RJMP _0x181
_0x180:
; 0000 0521             DUAL_BUTTON[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DUAL_BUTTON_S0000010001,3
; 0000 0522             }
_0x181:
; 0000 0523         DualButtonFilter[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DualButtonFilter_S0000010001,3
; 0000 0524         }
; 0000 0525 
; 0000 0526     // 5 Mygtukas
; 0000 0527         if(BUTTON_INPUT5==1){
_0x17D:
_0x17C:
	SBIS 0x10,2
	RJMP _0x182
; 0000 0528         PAGRINDINIS_LANGAS = 0;
	LDI  R30,LOW(0)
	STS  _PAGRINDINIS_LANGAS,R30
; 0000 0529             if(ButtonFilter[4]<ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000010001,4
	CPI  R26,LOW(0x14)
	BRSH _0x183
; 0000 052A             ButtonFilter[4]++;
	__GETB1MN _ButtonFilter_S0000010001,4
	SUBI R30,-LOW(1)
	__PUTB1MN _ButtonFilter_S0000010001,4
; 0000 052B             }
; 0000 052C         }
_0x183:
; 0000 052D         else{
	RJMP _0x184
_0x182:
; 0000 052E             if(ButtonFilter[4]>=ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000010001,4
	CPI  R26,LOW(0x14)
	BRLO _0x185
; 0000 052F             BUTTON[4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _BUTTON_S0000010001,4
; 0000 0530             RefreshLcd = 1;
	MOV  R5,R30
; 0000 0531             }
; 0000 0532             else{
	RJMP _0x186
_0x185:
; 0000 0533             BUTTON[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _BUTTON_S0000010001,4
; 0000 0534             }
_0x186:
; 0000 0535         ButtonFilter[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000010001,4
; 0000 0536         }
_0x184:
; 0000 0537 
; 0000 0538     //////////////////////////////////////////////////////////////////////////////////
; 0000 0539     //////////////////////////////////////////////////////////////////////////////////
; 0000 053A     //////////////////////////////////////////////////////////////////////////////////
; 0000 053B 
; 0000 053C     //////////////////////////////////////////////////////////////////////////////////
; 0000 053D     ///////////////////////////// LCD ////////////////////////////////////////////////
; 0000 053E     //////////////////////////////////////////////////////////////////////////////////
; 0000 053F     // LCD LED
; 0000 0540 /*        if(PAGRINDINIS_LANGAS<15){
; 0000 0541 //            if(LCD_LED==0){
; 0000 0542             LCD_LED = 1;
; 0000 0543 //            }
; 0000 0544         }
; 0000 0545         else{
; 0000 0546 //            if(LCD_LED==1){
; 0000 0547             LCD_LED = 0;
; 0000 0548 //            }
; 0000 0549         } */
; 0000 054A 
; 0000 054B     // Grazinti i pradini langa
; 0000 054C         if(TERMOSWITCH_INPUT==1){
	SBIS 0x10,7
	RJMP _0x187
; 0000 054D             if(PAGRINDINIS_LANGAS>=30){
	LDS  R26,_PAGRINDINIS_LANGAS
	CPI  R26,LOW(0x1E)
	BRLO _0x188
; 0000 054E             Address[0] = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _Address,R30
	STS  _Address+1,R31
; 0000 054F             Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0550             Address[2] = 0;
	__POINTW1MN _Address,4
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0551             }
; 0000 0552         }
_0x188:
; 0000 0553         else{
	RJMP _0x189
_0x187:
; 0000 0554             if(PAGRINDINIS_LANGAS>=120){
	LDS  R26,_PAGRINDINIS_LANGAS
	CPI  R26,LOW(0x78)
	BRLO _0x18A
; 0000 0555             Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address,R30
	STS  _Address+1,R30
; 0000 0556             Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0557             Address[2] = 0;
	__POINTW1MN _Address,4
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0558             }
; 0000 0559         }
_0x18A:
_0x189:
; 0000 055A 
; 0000 055B     // Pagrindiniame meniu vaikscioti kairen desinen
; 0000 055C         if(Address[1]==0){// Jei y == 0, tai pagrindinis meniu
	__GETW1MN _Address,2
	SBIW R30,0
	BREQ PC+3
	JMP _0x18B
; 0000 055D             if(Address[2]==0){
	__GETW1MN _Address,4
	SBIW R30,0
	BREQ PC+3
	JMP _0x18C
; 0000 055E 
; 0000 055F                 if(DUAL_BUTTON[0]==1){
	LDS  R26,_DUAL_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x18D
; 0000 0560                     if(TERMOSWITCH_INPUT==0){
	SBIC 0x10,7
	RJMP _0x18E
; 0000 0561                     Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address,R30
	STS  _Address+1,R30
; 0000 0562                     }
; 0000 0563                     else{
	RJMP _0x18F
_0x18E:
; 0000 0564                     Address[0] = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _Address,R30
	STS  _Address+1,R31
; 0000 0565                     }
_0x18F:
; 0000 0566                 }
; 0000 0567 
; 0000 0568                 if(BUTTON[0]==1){
_0x18D:
	LDS  R26,_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x190
; 0000 0569                     if(Address[0]>0){
	LDS  R26,_Address
	LDS  R27,_Address+1
	CALL __CPW02
	BRGE _0x191
; 0000 056A                     Address[0]--;
	LDI  R26,LOW(_Address)
	LDI  R27,HIGH(_Address)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 056B                     RefreshLcd = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 056C                     }
; 0000 056D                     else{
	RJMP _0x192
_0x191:
; 0000 056E                     Address[0] = 13;
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	STS  _Address,R30
	STS  _Address+1,R31
; 0000 056F                     }
_0x192:
; 0000 0570                 }
; 0000 0571                 else if(BUTTON[1]==1){
	RJMP _0x193
_0x190:
	__GETB2MN _BUTTON_S0000010001,1
	CPI  R26,LOW(0x1)
	BRNE _0x194
; 0000 0572                     if(Address[0]<13){
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,13
	BRGE _0x195
; 0000 0573                     Address[0]++;
	LDI  R26,LOW(_Address)
	LDI  R27,HIGH(_Address)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0574                     RefreshLcd = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0575                     }
; 0000 0576                     else{
	RJMP _0x196
_0x195:
; 0000 0577                     Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address,R30
	STS  _Address+1,R30
; 0000 0578                     }
_0x196:
; 0000 0579                 }
; 0000 057A             }
_0x194:
_0x193:
; 0000 057B         }
_0x18C:
; 0000 057C 
; 0000 057D         if(RefreshLcd==1){
_0x18B:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x197
; 0000 057E         _lcd_ready();
	CALL __lcd_ready
; 0000 057F         lcd_clear();
	CALL _lcd_clear
; 0000 0580         _lcd_ready();
	CALL __lcd_ready
; 0000 0581         }
; 0000 0582 
; 0000 0583     ///////////////////////////////////////////////////////////
; 0000 0584     // x.  y.  z.
; 0000 0585     // 0. Kolektoriaus isejimo ir boilerio temperaturos
; 0000 0586     // 1. Kolektoriaus isejimo ir iejimo temperaturos
; 0000 0587     // 2. Temperaturu skirtumo lentele
; 0000 0588     // 3. Vandens srauto lentele
; 0000 0589     // 4. 95C Apsaugos lentele
; 0000 058A     // 5. Momentines galios lentele
; 0000 058B     // 6. Energijos skaitiklio lentele
; 0000 058C     // 7. Energijos skaitiklis per viena diena
; 0000 058D     // 8. Maksimali dienos temperatura
; 0000 058E     // 9. Svarbiu ivykiu lentele
; 0000 058F     // 10. Datos lentele
; 0000 0590     // 11. Laiko lentele
; 0000 0591     // 12. Matuojama temperatura
; 0000 0592     // 13. Atstatyti viska
; 0000 0593     ///////////////////////////////////////////////////////////
; 0000 0594 
; 0000 0595 
; 0000 0596         if(CODE_IsEntering==0){
_0x197:
	LDS  R30,_CODE_IsEntering_G000
	CPI  R30,0
	BREQ PC+3
	JMP _0x198
; 0000 0597             if(Address[0]==0){
	LDS  R30,_Address
	LDS  R31,_Address+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x199
; 0000 0598                 if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x19A
; 0000 0599                     if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x19B
; 0000 059A                     // 1 Eilute
; 0000 059B                     lcd_put_number(1,3,1,1,0,SOLAR_OUTPUT_TEMP);
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	LDS  R30,_SOLAR_OUTPUT_TEMP
	LDS  R31,_SOLAR_OUTPUT_TEMP+1
	CALL __CWD1
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 059C                     lcd_putsf("C KOL.TEMP.");
	__POINTW1FN _0x0,60
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 059D 
; 0000 059E 
; 0000 059F                     // 2 Eilute
; 0000 05A0                     lcd_put_number(1,3,1,1,0,BOILER_TEMP);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	MOVW R30,R10
	CALL __CWD1
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 05A1                     lcd_putsf("C BOIL.TEMP");
	__POINTW1FN _0x0,72
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05A2                     }
; 0000 05A3                 }
_0x19B:
; 0000 05A4             }
_0x19A:
; 0000 05A5             else if(Address[0]==1){
	JMP  _0x19C
_0x199:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x19D
; 0000 05A6                 if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x19E
; 0000 05A7                     if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x19F
; 0000 05A8                     // 1 Eilute
; 0000 05A9                     lcd_put_number(1,3,1,1,0,SOLAR_OUTPUT_TEMP);
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	LDS  R30,_SOLAR_OUTPUT_TEMP
	LDS  R31,_SOLAR_OUTPUT_TEMP+1
	CALL __CWD1
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 05AA                     lcd_putsf("C KOL.ISEJ.");
	__POINTW1FN _0x0,84
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05AB 
; 0000 05AC                     // 2 Eilute
; 0000 05AD                     lcd_put_number(1,3,1,1,0,SOLAR_INPUT_TEMP);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	MOVW R30,R12
	CALL __CWD1
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 05AE                     lcd_putsf("C KOL.IEJIM");
	__POINTW1FN _0x0,96
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05AF                     }
; 0000 05B0                 }
_0x19F:
; 0000 05B1             }
_0x19E:
; 0000 05B2             else if(Address[0]==2){
	JMP  _0x1A0
_0x19D:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,2
	BREQ PC+3
	JMP _0x1A1
; 0000 05B3             /////////////////////////////////////////////////////////////////////
; 0000 05B4                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1A2
; 0000 05B5                 lcd_put_number(0,3,0,1,DifferenceBoilerAndSolar,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 05B6                 lcd_putsf("C TEMP.SKIRT");
	__POINTW1FN _0x0,108
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05B7                 }
; 0000 05B8 
; 0000 05B9                 if(Address[1]==0){
_0x1A2:
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x1A3
; 0000 05BA                     if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1A4
; 0000 05BB                     lcd_putsf("    KEISTI?-->* ");
	__POINTW1FN _0x0,121
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05BC                     }
; 0000 05BD 
; 0000 05BE                     if(BUTTON[4]==1){
_0x1A4:
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x1A5
; 0000 05BF                     Address[1] = 1;
	__POINTW1MN _Address,2
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 05C0                     }
; 0000 05C1                 }
_0x1A5:
; 0000 05C2 
; 0000 05C3 
; 0000 05C4                 ///// 1 Skirtumo skaicius /////
; 0000 05C5                 else if(Address[1]==1){
	RJMP _0x1A6
_0x1A3:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x1A7
; 0000 05C6                 // Mygtuku aprasymas ir kursorius
; 0000 05C7                     if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1A8
; 0000 05C8                         if(DifferenceBoilerAndSolar>MAX_DIFFERENCE_SOLAR_BOILER-100){
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x97)
	LDI  R26,HIGH(0x97)
	CPC  R31,R26
	BRLT _0x1A9
; 0000 05C9                         lcd_buttons(0,1,0,1,1, 0,0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x336
; 0000 05CA                         }
; 0000 05CB                         else if(DifferenceBoilerAndSolar<MIN_DIFFERENCE_SOLAR_BOILER+100){
_0x1A9:
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x96)
	LDI  R26,HIGH(0x96)
	CPC  R31,R26
	BRGE _0x1AB
; 0000 05CC                         lcd_buttons(0,1,1,0,1, 0,0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x337
; 0000 05CD                         }
; 0000 05CE                         else{
_0x1AB:
; 0000 05CF                         lcd_buttons(0,1,1,1,1, 0,0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
_0x336:
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x337:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 05D0                         }
; 0000 05D1                     lcd_cursor(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_cursor
; 0000 05D2                     }
; 0000 05D3                 ////////////
; 0000 05D4 
; 0000 05D5 
; 0000 05D6                 // Adreso valdymui
; 0000 05D7                     if(BUTTON[1]==1){
_0x1A8:
	__GETB2MN _BUTTON_S0000010001,1
	CPI  R26,LOW(0x1)
	BRNE _0x1AD
; 0000 05D8                     Address[1]++;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 05D9                     }
; 0000 05DA                 //////////////////
; 0000 05DB 
; 0000 05DC 
; 0000 05DD                 // Patvirtinti
; 0000 05DE                     if(BUTTON[4]==1){
_0x1AD:
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x1AE
; 0000 05DF                     Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 05E0                     }
; 0000 05E1                 //////////////
; 0000 05E2 
; 0000 05E3 
; 0000 05E4                 // 1 Skirtumo skaiciaus keitimas
; 0000 05E5                     if(BUTTON[2]==1){
_0x1AE:
	__GETB2MN _BUTTON_S0000010001,2
	CPI  R26,LOW(0x1)
	BRNE _0x1AF
; 0000 05E6                         if(DifferenceBoilerAndSolar<=MAX_DIFFERENCE_SOLAR_BOILER-100){
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x97)
	LDI  R26,HIGH(0x97)
	CPC  R31,R26
	BRGE _0x1B0
; 0000 05E7                         DifferenceBoilerAndSolar = DifferenceBoilerAndSolar + 100;
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMWRW
; 0000 05E8                         }
; 0000 05E9                     }
_0x1B0:
; 0000 05EA                     else if(BUTTON[3]==1){
	RJMP _0x1B1
_0x1AF:
	__GETB2MN _BUTTON_S0000010001,3
	CPI  R26,LOW(0x1)
	BRNE _0x1B2
; 0000 05EB                         if(DifferenceBoilerAndSolar>=MIN_DIFFERENCE_SOLAR_BOILER+100){
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x96)
	LDI  R26,HIGH(0x96)
	CPC  R31,R26
	BRLT _0x1B3
; 0000 05EC                         DifferenceBoilerAndSolar = DifferenceBoilerAndSolar - 100;
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMWRW
; 0000 05ED                         }
; 0000 05EE                     }
_0x1B3:
; 0000 05EF                 ///////////////////
; 0000 05F0                 }
_0x1B2:
_0x1B1:
; 0000 05F1             ///////////////////////////////
; 0000 05F2 
; 0000 05F3 
; 0000 05F4             ///// 2 Skirtumo skaicius /////
; 0000 05F5                 else if(Address[1]==2){
	RJMP _0x1B4
_0x1A7:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x1B5
; 0000 05F6                 // Mygtuku aprasymas ir kursorius
; 0000 05F7                     if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1B6
; 0000 05F8                         if(DifferenceBoilerAndSolar>MAX_DIFFERENCE_SOLAR_BOILER-10){
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	CPI  R30,LOW(0xF1)
	LDI  R26,HIGH(0xF1)
	CPC  R31,R26
	BRLT _0x1B7
; 0000 05F9                         lcd_buttons(1,1,0,1,1, 0,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x338
; 0000 05FA                         }
; 0000 05FB                         else if(DifferenceBoilerAndSolar<MIN_DIFFERENCE_SOLAR_BOILER+10){
_0x1B7:
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	SBIW R30,60
	BRGE _0x1B9
; 0000 05FC                         lcd_buttons(1,1,1,0,1, 0,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x339
; 0000 05FD                         }
; 0000 05FE                         else{
_0x1B9:
; 0000 05FF                         lcd_buttons(1,1,1,1,1, 0,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
_0x338:
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x339:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 0600                         }
; 0000 0601                     lcd_cursor(1,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_cursor
; 0000 0602                     }
; 0000 0603                 ////////////
; 0000 0604 
; 0000 0605                 // Adreso valdymui
; 0000 0606                     if(BUTTON[0]==1){
_0x1B6:
	LDS  R26,_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x1BB
; 0000 0607                     Address[1]--;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	RJMP _0x33A
; 0000 0608                     }
; 0000 0609                     else if(BUTTON[1]==1){
_0x1BB:
	__GETB2MN _BUTTON_S0000010001,1
	CPI  R26,LOW(0x1)
	BRNE _0x1BD
; 0000 060A                     Address[1]++;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
_0x33A:
	ST   -X,R31
	ST   -X,R30
; 0000 060B                     }
; 0000 060C                 //////////////////
; 0000 060D 
; 0000 060E 
; 0000 060F                 // Patvirtinti
; 0000 0610                     if(BUTTON[4]==1){
_0x1BD:
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x1BE
; 0000 0611                     Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0612                     }
; 0000 0613                 //////////////
; 0000 0614 
; 0000 0615 
; 0000 0616                 // 2 Skirtumo skaiciaus keitimas
; 0000 0617                     if(BUTTON[2]==1){
_0x1BE:
	__GETB2MN _BUTTON_S0000010001,2
	CPI  R26,LOW(0x1)
	BRNE _0x1BF
; 0000 0618                         if(DifferenceBoilerAndSolar<=MAX_DIFFERENCE_SOLAR_BOILER-10){
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	CPI  R30,LOW(0xF1)
	LDI  R26,HIGH(0xF1)
	CPC  R31,R26
	BRGE _0x1C0
; 0000 0619                         DifferenceBoilerAndSolar = DifferenceBoilerAndSolar + 10;
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	ADIW R30,10
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMWRW
; 0000 061A                         }
; 0000 061B                     }
_0x1C0:
; 0000 061C                     else if(BUTTON[3]==1){
	RJMP _0x1C1
_0x1BF:
	__GETB2MN _BUTTON_S0000010001,3
	CPI  R26,LOW(0x1)
	BRNE _0x1C2
; 0000 061D                         if(DifferenceBoilerAndSolar>=MIN_DIFFERENCE_SOLAR_BOILER+10){
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	SBIW R30,60
	BRLT _0x1C3
; 0000 061E                         DifferenceBoilerAndSolar = DifferenceBoilerAndSolar - 10;
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	SBIW R30,10
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMWRW
; 0000 061F                         }
; 0000 0620                     }
_0x1C3:
; 0000 0621                 ////////////////////
; 0000 0622                 }
_0x1C2:
_0x1C1:
; 0000 0623             ///////////////////////////////
; 0000 0624 
; 0000 0625 
; 0000 0626             ///// 3 Skirtumo skaicius /////
; 0000 0627                 else if(Address[1]==3){
	RJMP _0x1C4
_0x1B5:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x1C5
; 0000 0628                 // Mygtuku aprasymas ir kursorius
; 0000 0629                     if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1C6
; 0000 062A                         if(DifferenceBoilerAndSolar>MAX_DIFFERENCE_SOLAR_BOILER-1){
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	CPI  R30,LOW(0xFA)
	LDI  R26,HIGH(0xFA)
	CPC  R31,R26
	BRLT _0x1C7
; 0000 062B                         lcd_buttons(1,0,0,1,1, 0,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x33B
; 0000 062C                         }
; 0000 062D                         else if(DifferenceBoilerAndSolar<MIN_DIFFERENCE_SOLAR_BOILER+1){
_0x1C7:
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	SBIW R30,51
	BRGE _0x1C9
; 0000 062E                         lcd_buttons(1,0,1,0,1, 0,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x33C
; 0000 062F                         }
; 0000 0630                         else{
_0x1C9:
; 0000 0631                         lcd_buttons(1,0,1,1,1, 0,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x33B:
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x33C:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 0632                         }
; 0000 0633                     lcd_cursor(3,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_cursor
; 0000 0634                     }
; 0000 0635                 ////////////
; 0000 0636 
; 0000 0637 
; 0000 0638                 // Adreso valdymui
; 0000 0639                     if(BUTTON[0]==1){
_0x1C6:
	LDS  R26,_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x1CB
; 0000 063A                     Address[1]--;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 063B                     }
; 0000 063C                 //////////////////
; 0000 063D 
; 0000 063E 
; 0000 063F                 // Patvirtinti
; 0000 0640                     if(BUTTON[4]==1){
_0x1CB:
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x1CC
; 0000 0641                     Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0642                     }
; 0000 0643                 //////////////
; 0000 0644 
; 0000 0645                 // Skirtumo keitimas
; 0000 0646                     if(BUTTON[2]==1){
_0x1CC:
	__GETB2MN _BUTTON_S0000010001,2
	CPI  R26,LOW(0x1)
	BRNE _0x1CD
; 0000 0647                         if(DifferenceBoilerAndSolar<=MAX_DIFFERENCE_SOLAR_BOILER-1){
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	CPI  R30,LOW(0xFA)
	LDI  R26,HIGH(0xFA)
	CPC  R31,R26
	BRGE _0x1CE
; 0000 0648                         DifferenceBoilerAndSolar++;
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 0649                         }
; 0000 064A                     }
_0x1CE:
; 0000 064B                     else if(BUTTON[3]==1){
	RJMP _0x1CF
_0x1CD:
	__GETB2MN _BUTTON_S0000010001,3
	CPI  R26,LOW(0x1)
	BRNE _0x1D0
; 0000 064C                         if(DifferenceBoilerAndSolar>=MIN_DIFFERENCE_SOLAR_BOILER+1){
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	SBIW R30,51
	BRLT _0x1D1
; 0000 064D                         DifferenceBoilerAndSolar--;
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
; 0000 064E                         }
; 0000 064F                     }
_0x1D1:
; 0000 0650                 ////////////////////
; 0000 0651                 }
_0x1D0:
_0x1CF:
; 0000 0652             ///////////////////////////////
; 0000 0653 
; 0000 0654 
; 0000 0655             /////////////////////////////////////////////////////////////////////
; 0000 0656             }
_0x1C5:
_0x1C4:
_0x1B4:
_0x1A6:
; 0000 0657             else if(Address[0]==3){
	JMP  _0x1D2
_0x1A1:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,3
	BREQ PC+3
	JMP _0x1D3
; 0000 0658             /////////////////////////////////////////////////////////////////////
; 0000 0659             /*    if(RefreshLcd==1){
; 0000 065A                 lcd_put_number(0,2,0,1,LitersPerMinute,0);
; 0000 065B                 lcd_putsf(   "L/MIN SRAUTAS");
; 0000 065C                 }
; 0000 065D 
; 0000 065E 
; 0000 065F 
; 0000 0660                 if(Address[1]==0){
; 0000 0661                     if(RefreshLcd==1){
; 0000 0662                     lcd_putsf("    KEISTI?-->* ");
; 0000 0663                     }
; 0000 0664 
; 0000 0665                     if(BUTTON[4]==1){
; 0000 0666                     EnterCode(3,0,0,3,1,0);
; 0000 0667                     }
; 0000 0668                 }
; 0000 0669                 else if(Address[1]==1){
; 0000 066A 
; 0000 066B 
; 0000 066C                 // Mygtukai
; 0000 066D                     if(LitersPerMinute>=90){
; 0000 066E                     lcd_buttons(0,1,0,1,1, 0,0,0,0);
; 0000 066F                     }
; 0000 0670                     else if(LitersPerMinute<=10){
; 0000 0671                     lcd_buttons(0,1,1,0,1, 0,0,0,0);
; 0000 0672                     }
; 0000 0673                     else{
; 0000 0674                     lcd_buttons(0,1,1,1,1, 0,0,0,0);
; 0000 0675                     }
; 0000 0676                 ///////////
; 0000 0677 
; 0000 0678                 // Kursorius
; 0000 0679                 lcd_cursor(0,0);
; 0000 067A                 ////////////
; 0000 067B                 }
; 0000 067C                 else if(Address[1]==2){
; 0000 067D 
; 0000 067E 
; 0000 067F 
; 0000 0680                 // Mygtukai
; 0000 0681                     if(LitersPerMinute>=99){
; 0000 0682                     lcd_buttons(1,0,0,1,1, 0,0,0,0);
; 0000 0683                     }
; 0000 0684                     else if(LitersPerMinute<=1){
; 0000 0685                     lcd_buttons(1,0,1,0,1, 0,0,0,0);
; 0000 0686                     }
; 0000 0687                     else{
; 0000 0688                     lcd_buttons(1,0,1,1,1, 0,0,0,0);
; 0000 0689                     }
; 0000 068A                 ///////////
; 0000 068B 
; 0000 068C                 // Kursorius
; 0000 068D                 lcd_cursor(2,0);
; 0000 068E                 ////////////
; 0000 068F                 }*/
; 0000 0690 
; 0000 0691 
; 0000 0692 
; 0000 0693 
; 0000 0694 
; 0000 0695 
; 0000 0696                 if(Address[2]==0){
	__GETW1MN _Address,4
	SBIW R30,0
	BRNE _0x1D4
; 0000 0697                     if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x1D5
; 0000 0698                         if(BUTTON[4]==1){
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x1D6
; 0000 0699                         EnterCode(3,0,0,3,0,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _EnterCode
; 0000 069A                         }
; 0000 069B                     }
_0x1D6:
; 0000 069C                 }
_0x1D5:
; 0000 069D                 else{
	RJMP _0x1D7
_0x1D4:
; 0000 069E                     if(BUTTON[4]==1){
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x1D8
; 0000 069F                     Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 06A0                     Address[2] = 0;
	__POINTW1MN _Address,4
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 06A1                     }
; 0000 06A2 
; 0000 06A3                     if(BUTTON[0]==1){
_0x1D8:
	LDS  R26,_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x1D9
; 0000 06A4                         if(Address[2]>1){
	__GETW2MN _Address,4
	SBIW R26,2
	BRLT _0x1DA
; 0000 06A5                         Address[2]--;
	__POINTW2MN _Address,4
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 06A6                         }
; 0000 06A7                     }
_0x1DA:
; 0000 06A8                     else if(BUTTON[1]==1){
	RJMP _0x1DB
_0x1D9:
	__GETB2MN _BUTTON_S0000010001,1
	CPI  R26,LOW(0x1)
	BRNE _0x1DC
; 0000 06A9                         if(Address[2]<2){
	__GETW2MN _Address,4
	SBIW R26,2
	BRGE _0x1DD
; 0000 06AA                         Address[2]++;
	__POINTW2MN _Address,4
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 06AB                         }
; 0000 06AC                     }
_0x1DD:
; 0000 06AD 
; 0000 06AE                     if(BUTTON[2]==1){
_0x1DC:
_0x1DB:
	__GETB2MN _BUTTON_S0000010001,2
	CPI  R26,LOW(0x1)
	BRNE _0x1DE
; 0000 06AF                         if(Address[2]==1){
	__GETW1MN _Address,4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1DF
; 0000 06B0                             if(LitersPerMinute<90){
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRGE _0x1E0
; 0000 06B1                             LitersPerMinute = LitersPerMinute + 10;
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	ADIW R30,10
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMWRW
; 0000 06B2                             }
; 0000 06B3                         }
_0x1E0:
; 0000 06B4                         else if(Address[2]==2){
	RJMP _0x1E1
_0x1DF:
	__GETW1MN _Address,4
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1E2
; 0000 06B5                             if(LitersPerMinute<99){
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRGE _0x1E3
; 0000 06B6                             LitersPerMinute++;
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 06B7                             }
; 0000 06B8                         }
_0x1E3:
; 0000 06B9                     }
_0x1E2:
_0x1E1:
; 0000 06BA                     else if(BUTTON[3]==1){
	RJMP _0x1E4
_0x1DE:
	__GETB2MN _BUTTON_S0000010001,3
	CPI  R26,LOW(0x1)
	BRNE _0x1E5
; 0000 06BB                         if(Address[2]==1){
	__GETW1MN _Address,4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1E6
; 0000 06BC                             if(LitersPerMinute>10){
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	SBIW R30,11
	BRLT _0x1E7
; 0000 06BD                             LitersPerMinute = LitersPerMinute - 10;
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	SBIW R30,10
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMWRW
; 0000 06BE                             }
; 0000 06BF                         }
_0x1E7:
; 0000 06C0                         else if(Address[2]==2){
	RJMP _0x1E8
_0x1E6:
	__GETW1MN _Address,4
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1E9
; 0000 06C1                             if(LitersPerMinute>1){
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	SBIW R30,2
	BRLT _0x1EA
; 0000 06C2                             LitersPerMinute--;
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
; 0000 06C3                             }
; 0000 06C4                         }
_0x1EA:
; 0000 06C5                     }
_0x1E9:
_0x1E8:
; 0000 06C6                 }
_0x1E5:
_0x1E4:
_0x1D7:
; 0000 06C7 
; 0000 06C8                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ PC+3
	JMP _0x1EB
; 0000 06C9                     if(Address[2]==0){
	__GETW1MN _Address,4
	SBIW R30,0
	BRNE _0x1EC
; 0000 06CA                         if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x1ED
; 0000 06CB                         lcd_put_number(0,2,0,1,LitersPerMinute,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 06CC                         lcd_putsf(   "L/MIN SRAUTAS");
	__POINTW1FN _0x0,138
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 06CD                         lcd_putsf("    KEISTI?-->* ");
	__POINTW1FN _0x0,121
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 06CE                         }
; 0000 06CF                     }
_0x1ED:
; 0000 06D0                     else{
	RJMP _0x1EE
_0x1EC:
; 0000 06D1                     lcd_put_number(0,2,0,1,LitersPerMinute,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 06D2                     lcd_putsf("L/MIN SRAUTAS");
	__POINTW1FN _0x0,138
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 06D3 
; 0000 06D4                         if(Address[2]==1){
	__GETW1MN _Address,4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1EF
; 0000 06D5                         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 06D6                             if(LitersPerMinute>=90){
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRLT _0x1F0
; 0000 06D7                             lcd_buttons(0,1,0,1,1, 0,0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x33D
; 0000 06D8                             }
; 0000 06D9                             else if(LitersPerMinute<=10){
_0x1F0:
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	SBIW R30,11
	BRGE _0x1F2
; 0000 06DA                             lcd_buttons(0,1,1,0,1, 0,0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x33E
; 0000 06DB                             }
; 0000 06DC                             else{
_0x1F2:
; 0000 06DD                             lcd_buttons(0,1,1,1,1, 0,0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
_0x33D:
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x33E:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 06DE                             }
; 0000 06DF 
; 0000 06E0                         }
; 0000 06E1                         else{
	RJMP _0x1F4
_0x1EF:
; 0000 06E2                         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 06E3                             if(LitersPerMinute>=99){
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRLT _0x1F5
; 0000 06E4                             lcd_buttons(1,0,0,1,1, 0,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x33F
; 0000 06E5                             }
; 0000 06E6                             else if(LitersPerMinute<=1){
_0x1F5:
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	CALL __EEPROMRDW
	SBIW R30,2
	BRGE _0x1F7
; 0000 06E7                             lcd_buttons(1,0,1,0,1, 0,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x340
; 0000 06E8                             }
; 0000 06E9                             else{
_0x1F7:
; 0000 06EA                             lcd_buttons(1,0,1,1,1, 0,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x33F:
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x340:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 06EB                             }
; 0000 06EC                         }
_0x1F4:
; 0000 06ED 
; 0000 06EE                         if(Address[2]==1){
	__GETW1MN _Address,4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1F9
; 0000 06EF                         lcd_cursor(0,0);
	LDI  R30,LOW(0)
	RJMP _0x341
; 0000 06F0                         }
; 0000 06F1                         else if(Address[2]==2){
_0x1F9:
	__GETW1MN _Address,4
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1FB
; 0000 06F2                         lcd_cursor(2,0);
	LDI  R30,LOW(2)
_0x341:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_cursor
; 0000 06F3                         }
; 0000 06F4                     }
_0x1FB:
_0x1EE:
; 0000 06F5                 }
; 0000 06F6             /////////////////////////////////////////////////////////////////////
; 0000 06F7             }
_0x1EB:
; 0000 06F8             else if(Address[0]==4){
	JMP  _0x1FC
_0x1D3:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,4
	BRNE _0x1FD
; 0000 06F9                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1FE
; 0000 06FA                     if(TERMOSWITCH_INPUT==0){
	SBIC 0x10,7
	RJMP _0x1FF
; 0000 06FB                     lcd_putsf("  95C APSAUGA   ");
	__POINTW1FN _0x0,152
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 06FC                     lcd_putsf("  NESUVEIKUSI   ");
	__POINTW1FN _0x0,169
	RJMP _0x342
; 0000 06FD                     }
; 0000 06FE                     else{
_0x1FF:
; 0000 06FF                     lcd_putsf("--SUVEIKE  95C--");
	__POINTW1FN _0x0,186
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0700                     lcd_putsf("----APSAUGA-----");
	__POINTW1FN _0x0,203
_0x342:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0701                     }
; 0000 0702                 }
; 0000 0703             }
_0x1FE:
; 0000 0704             else if(Address[0]==5){
	JMP  _0x201
_0x1FD:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,5
	BREQ PC+3
	JMP _0x202
; 0000 0705                 if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BREQ PC+3
	JMP _0x203
; 0000 0706                     if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x204
; 0000 0707                         if(SolarPower>9999){
	LDS  R26,_SolarPower_S0000010003
	LDS  R27,_SolarPower_S0000010003+1
	CPI  R26,LOW(0x2710)
	LDI  R30,HIGH(0x2710)
	CPC  R27,R30
	BRLT _0x205
; 0000 0708                         SolarPower = 9999;
	LDI  R30,LOW(9999)
	LDI  R31,HIGH(9999)
	STS  _SolarPower_S0000010003,R30
	STS  _SolarPower_S0000010003+1,R31
; 0000 0709                         }
; 0000 070A                         else if(SolarPower<0){
	RJMP _0x206
_0x205:
	LDS  R26,_SolarPower_S0000010003+1
	TST  R26
	BRPL _0x207
; 0000 070B                         SolarPower = 0;
	LDI  R30,LOW(0)
	STS  _SolarPower_S0000010003,R30
	STS  _SolarPower_S0000010003+1,R30
; 0000 070C                         }
; 0000 070D                     lcd_put_number(0,4,0,0,SolarPower,0);
_0x207:
_0x206:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDS  R30,_SolarPower_S0000010003
	LDS  R31,_SolarPower_S0000010003+1
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 070E                         lcd_putsf("W MOMENTINE ");
	__POINTW1FN _0x0,220
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 070F                     lcd_putsf("     GALIA      ");
	__POINTW1FN _0x0,233
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0710                     }
; 0000 0711                 }
_0x204:
; 0000 0712             }
_0x203:
; 0000 0713             else if(Address[0]==6){
	JMP  _0x208
_0x202:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,6
	BRNE _0x209
; 0000 0714                 if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x20A
; 0000 0715                     if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x20B
; 0000 0716                     lcd_putsf("  ");
	__POINTW1FN _0x0,3
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0717                     lcd_put_number(0,10,0,3,SolarColectorWattHours,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(_SolarColectorWattHours)
	LDI  R27,HIGH(_SolarColectorWattHours)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 0718                     lcd_putsf("kWh");
	__POINTW1FN _0x0,250
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0719                     lcd_putsf("ENERG.SKAITIKLIS");
	__POINTW1FN _0x0,254
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 071A                     }
; 0000 071B                 }
_0x20B:
; 0000 071C             }
_0x20A:
; 0000 071D             else if(Address[0]==7){
	JMP  _0x20C
_0x209:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,7
	BRNE _0x20D
; 0000 071E                 if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x20E
; 0000 071F                     if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x20F
; 0000 0720                     lcd_putsf("  ");
	__POINTW1FN _0x0,3
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0721                     lcd_put_number(0,10,0,3,WattHoursPerDay,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(_WattHoursPerDay)
	LDI  R27,HIGH(_WattHoursPerDay)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 0722                     lcd_putsf("kWh");
	__POINTW1FN _0x0,250
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0723                     lcd_putsf("ENERG. PER DIENA");
	__POINTW1FN _0x0,271
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0724                     }
; 0000 0725                 }
_0x20F:
; 0000 0726             }
_0x20E:
; 0000 0727             else if(Address[0]==8){//+
	JMP  _0x210
_0x20D:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,8
	BRNE _0x211
; 0000 0728                 if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x212
; 0000 0729                     if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x213
; 0000 072A                     lcd_putsf("MAKS.DIENOS.TEMP");
	__POINTW1FN _0x0,288
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 072B                     lcd_putsf("    ");
	__POINTW1FN _0x0,245
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 072C                     lcd_put_number(1,3,1,1,0,MaxDayTemperature);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	LDI  R26,LOW(_MaxDayTemperature)
	LDI  R27,HIGH(_MaxDayTemperature)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 072D                     lcd_putsf("C      ");
	__POINTW1FN _0x0,305
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 072E                     }
; 0000 072F                 }
_0x213:
; 0000 0730             }
_0x212:
; 0000 0731             else if(Address[0]==9){
	JMP  _0x214
_0x211:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,9
	BREQ PC+3
	JMP _0x215
; 0000 0732 
; 0000 0733                 if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x216
; 0000 0734                     if(Address[2]==0){
	__GETW1MN _Address,4
	SBIW R30,0
	BRNE _0x217
; 0000 0735                         if(BUTTON[4]==1){
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x218
; 0000 0736                         Address[1] = 1;
	__POINTW1MN _Address,2
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0737                         }
; 0000 0738                     }
_0x218:
; 0000 0739                 }
_0x217:
; 0000 073A                 else{
	RJMP _0x219
_0x216:
; 0000 073B                     if(Address[1]!=LOG_COUNT+1){
	__GETW1MN _Address,2
	CPI  R30,LOW(0x5B)
	LDI  R26,HIGH(0x5B)
	CPC  R31,R26
	BRNE PC+3
	JMP _0x21A
; 0000 073C                         if(Address[2]==0){
	__GETW1MN _Address,4
	SBIW R30,0
	BREQ PC+3
	JMP _0x21B
; 0000 073D 
; 0000 073E                             if(DUAL_BUTTON[0]==1){
	LDS  R26,_DUAL_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x21C
; 0000 073F                             Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0740                             }
; 0000 0741 
; 0000 0742                             if(BUTTON[0]==1){
_0x21C:
	LDS  R26,_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x21D
; 0000 0743                                 if(Address[1]>1){
	__GETW2MN _Address,2
	SBIW R26,2
	BRLT _0x21E
; 0000 0744                                 Address[1]--;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0745                                 }
; 0000 0746                                 else{
	RJMP _0x21F
_0x21E:
; 0000 0747                                 Address[1] = LOG_COUNT+1;
	__POINTW1MN _Address,2
	LDI  R26,LOW(91)
	LDI  R27,HIGH(91)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0748                                 }
_0x21F:
; 0000 0749                             }
; 0000 074A                             else if(BUTTON[1]==1){
	RJMP _0x220
_0x21D:
	__GETB2MN _BUTTON_S0000010001,1
	CPI  R26,LOW(0x1)
	BRNE _0x221
; 0000 074B                                 if(Address[1]<LOG_COUNT+1){
	__GETW2MN _Address,2
	CPI  R26,LOW(0x5B)
	LDI  R30,HIGH(0x5B)
	CPC  R27,R30
	BRGE _0x222
; 0000 074C                                 Address[1]++;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 074D                                 }
; 0000 074E                                 else{
	RJMP _0x223
_0x222:
; 0000 074F                                 Address[1] = 1;
	__POINTW1MN _Address,2
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0750                                 }
_0x223:
; 0000 0751                             }
; 0000 0752 
; 0000 0753                             if(BUTTON[4]==1){
_0x221:
_0x220:
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x224
; 0000 0754                             signed int a;
; 0000 0755                             a = NewestLog + Address[1] - 1;
	SBIW R28,2
;	a -> Y+0
	LDI  R26,LOW(_NewestLog)
	LDI  R27,HIGH(_NewestLog)
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
	__GETW1MN _Address,2
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,1
	ST   Y,R26
	STD  Y+1,R27
; 0000 0756                                 if(a>=LOG_COUNT){
	CPI  R26,LOW(0x5A)
	LDI  R30,HIGH(0x5A)
	CPC  R27,R30
	BRLT _0x225
; 0000 0757                                 a = a - LOG_COUNT;
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(90)
	SBCI R31,HIGH(90)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0758                                 }
; 0000 0759                                 if((LogType[a]>=1)&&(LogType[a]<=50)){
_0x225:
	LD   R26,Y
	LDD  R27,Y+1
	SUBI R26,LOW(-_LogType)
	SBCI R27,HIGH(-_LogType)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRLO _0x227
	CPI  R30,LOW(0x33)
	BRLO _0x228
_0x227:
	RJMP _0x226
_0x228:
; 0000 075A                                 Address[2] = 1;
	__POINTW1MN _Address,4
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 075B                                 }
; 0000 075C                             }
_0x226:
	ADIW R28,2
; 0000 075D 
; 0000 075E                         }
_0x224:
; 0000 075F                         else{
	RJMP _0x229
_0x21B:
; 0000 0760                             if(DUAL_BUTTON[0]==1){
	LDS  R26,_DUAL_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x22A
; 0000 0761                             Address[2] = 0;
	__POINTW1MN _Address,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0762                             }
; 0000 0763 
; 0000 0764                             if(BUTTON[4]==1){
_0x22A:
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x22B
; 0000 0765                                 if(Address[2]<4){
	__GETW2MN _Address,4
	SBIW R26,4
	BRGE _0x22C
; 0000 0766                                 Address[2]++;
	__POINTW2MN _Address,4
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0767                                 }
; 0000 0768                                 else{
	RJMP _0x22D
_0x22C:
; 0000 0769                                 Address[2] = 0;
	__POINTW1MN _Address,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 076A                                 }
_0x22D:
; 0000 076B                             }
; 0000 076C                         }
_0x22B:
_0x229:
; 0000 076D                     }
; 0000 076E                     else{
	RJMP _0x22E
_0x21A:
; 0000 076F                         if(Address[2]==0){
	__GETW1MN _Address,4
	SBIW R30,0
	BREQ PC+3
	JMP _0x22F
; 0000 0770                             if(DUAL_BUTTON[0]==1){
	LDS  R26,_DUAL_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x230
; 0000 0771                             Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0772                             }
; 0000 0773 
; 0000 0774                             if(BUTTON[0]==1){
_0x230:
	LDS  R26,_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x231
; 0000 0775                                 if(Address[1]>1){
	__GETW2MN _Address,2
	SBIW R26,2
	BRLT _0x232
; 0000 0776                                 Address[1]--;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0777                                 }
; 0000 0778                                 else{
	RJMP _0x233
_0x232:
; 0000 0779                                 Address[1] = 1;
	__POINTW1MN _Address,2
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 077A                                 }
_0x233:
; 0000 077B                             }
; 0000 077C                             else if(BUTTON[1]==1){
	RJMP _0x234
_0x231:
	__GETB2MN _BUTTON_S0000010001,1
	CPI  R26,LOW(0x1)
	BRNE _0x235
; 0000 077D                                 if(Address[1]<LOG_COUNT+1){
	__GETW2MN _Address,2
	CPI  R26,LOW(0x5B)
	LDI  R30,HIGH(0x5B)
	CPC  R27,R30
	BRGE _0x236
; 0000 077E                                 Address[1]++;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 077F                                 }
; 0000 0780                                 else{
	RJMP _0x237
_0x236:
; 0000 0781                                 Address[1] = 1;
	__POINTW1MN _Address,2
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0782                                 }
_0x237:
; 0000 0783                             }
; 0000 0784 
; 0000 0785                             if(BUTTON[4]==1){
_0x235:
_0x234:
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x238
; 0000 0786                             EnterCode(9,LOG_COUNT+1,0,9,LOG_COUNT+1,1);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(91)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(91)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _EnterCode
; 0000 0787                             }
; 0000 0788                         }
_0x238:
; 0000 0789                         else{
	RJMP _0x239
_0x22F:
; 0000 078A                         unsigned int i;
; 0000 078B                         NewestLog = 0;
	SBIW R28,2
;	i -> Y+0
	LDI  R26,LOW(_NewestLog)
	LDI  R27,HIGH(_NewestLog)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 078C                         lcd_clear();
	CALL _lcd_clear
; 0000 078D                         lcd_putsf("TRINAMA: 000%   ");
	__POINTW1FN _0x0,313
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 078E                         lcd_putsf("PALAUKITE...    ");
	__POINTW1FN _0x0,330
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 078F                             for(i=0;i<LOG_COUNT;i++){
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0x23B:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x5A)
	LDI  R30,HIGH(0x5A)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x23C
; 0000 0790                             unsigned int a;
; 0000 0791 
; 0000 0792                             LogYear[i] = 0;
	SBIW R28,2
;	i -> Y+2
;	a -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDI  R26,LOW(_LogYear)
	LDI  R27,HIGH(_LogYear)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 0793                             LogMonth[i] = 0;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SUBI R26,LOW(-_LogMonth)
	SBCI R27,HIGH(-_LogMonth)
	CALL __EEPROMWRB
; 0000 0794                             LogDay[i] = 0;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SUBI R26,LOW(-_LogDay)
	SBCI R27,HIGH(-_LogDay)
	CALL __EEPROMWRB
; 0000 0795                             LogHour[i] = 0;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SUBI R26,LOW(-_LogHour)
	SBCI R27,HIGH(-_LogHour)
	CALL __EEPROMWRB
; 0000 0796                             LogMinute[i] = 0;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SUBI R26,LOW(-_LogMinute)
	SBCI R27,HIGH(-_LogMinute)
	CALL __EEPROMWRB
; 0000 0797 
; 0000 0798                             LogType[i] = 0;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SUBI R26,LOW(-_LogType)
	SBCI R27,HIGH(-_LogType)
	CALL __EEPROMWRB
; 0000 0799 
; 0000 079A                             LogData1[i] = 0;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDI  R26,LOW(_LogData1)
	LDI  R27,HIGH(_LogData1)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 079B                             LogData2[i] = 0;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDI  R26,LOW(_LogData2)
	LDI  R27,HIGH(_LogData2)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 079C 
; 0000 079D                             a = (i*100)/LOG_COUNT;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(100)
	CALL __MULB1W2U
	MOVW R26,R30
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL __DIVW21U
	ST   Y,R30
	STD  Y+1,R31
; 0000 079E                             lcd_gotoxy(9,0);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 079F                             lcd_put_number(0,3,0,0,a,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 07A0                             }
	ADIW R28,2
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x23B
_0x23C:
; 0000 07A1                         Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 07A2                         Address[2] = 0;
	__POINTW1MN _Address,4
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 07A3 
; 0000 07A4                         lcd_clear();
	CALL _lcd_clear
; 0000 07A5                         lcd_putsf("    ISTRINTA    ");
	__POINTW1FN _0x0,347
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 07A6                         delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 07A7                         }
	ADIW R28,2
_0x239:
; 0000 07A8                     }
_0x22E:
; 0000 07A9                 }
_0x219:
; 0000 07AA 
; 0000 07AB 
; 0000 07AC 
; 0000 07AD                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ PC+3
	JMP _0x23D
; 0000 07AE                     if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x23E
; 0000 07AF                     lcd_putsf("SVARBUS IVYKIAI:");
	__POINTW1FN _0x0,364
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 07B0                     lcd_putsf("PERZIURETI?-->* ");
	__POINTW1FN _0x0,381
	RJMP _0x343
; 0000 07B1                     }
; 0000 07B2                     else{
_0x23E:
; 0000 07B3                         if(Address[1]!=LOG_COUNT+1){
	__GETW1MN _Address,2
	CPI  R30,LOW(0x5B)
	LDI  R26,HIGH(0x5B)
	CPC  R31,R26
	BRNE PC+3
	JMP _0x240
; 0000 07B4                         signed int a;
; 0000 07B5                         a = NewestLog + Address[1] - 1;
	SBIW R28,2
;	a -> Y+0
	LDI  R26,LOW(_NewestLog)
	LDI  R27,HIGH(_NewestLog)
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
	__GETW1MN _Address,2
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,1
	ST   Y,R26
	STD  Y+1,R27
; 0000 07B6                             if(a>=LOG_COUNT){
	CPI  R26,LOW(0x5A)
	LDI  R30,HIGH(0x5A)
	CPC  R27,R30
	BRLT _0x241
; 0000 07B7                             a = a - LOG_COUNT;
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(90)
	SBCI R31,HIGH(90)
	ST   Y,R30
	STD  Y+1,R31
; 0000 07B8                             }
; 0000 07B9 
; 0000 07BA 
; 0000 07BB                             if(Address[1]>=10){
_0x241:
	__GETW2MN _Address,2
	SBIW R26,10
	BRLT _0x242
; 0000 07BC                             lcd_putchar(NumToIndex( Address[1]/10 ));
	__GETW2MN _Address,2
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x344
; 0000 07BD                             }
; 0000 07BE                             else{
_0x242:
; 0000 07BF                             lcd_putchar(' ');
	LDI  R30,LOW(32)
_0x344:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 07C0                             }
; 0000 07C1                         lcd_putchar(NumToIndex(Address[1]-(Address[1]/10)*10) );
	__GETW2MN _Address,2
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	__GETW2MN _Address,2
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 07C2                         lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 07C3 
; 0000 07C4                             if(Address[2]==0){
	__GETW1MN _Address,4
	SBIW R30,0
	BREQ PC+3
	JMP _0x244
; 0000 07C5                             char IvykisYra = 1;
; 0000 07C6                                 if(LogType[a]==1){
	SBIW R28,1
	LDI  R30,LOW(1)
	ST   Y,R30
;	a -> Y+1
;	IvykisYra -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SUBI R26,LOW(-_LogType)
	SBCI R27,HIGH(-_LogType)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x245
; 0000 07C7                                 lcd_putsf("SUVEIKE 95C  ");
	__POINTW1FN _0x0,398
	RJMP _0x345
; 0000 07C8                                 }
; 0000 07C9                                 else if(LogType[a]==2){
_0x245:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SUBI R26,LOW(-_LogType)
	SBCI R27,HIGH(-_LogType)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x247
; 0000 07CA                                 lcd_putsf("ATKRITO 95C  ");
	__POINTW1FN _0x0,412
	RJMP _0x345
; 0000 07CB                                 }
; 0000 07CC                                 else if(LogType[a]==3){
_0x247:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SUBI R26,LOW(-_LogType)
	SBCI R27,HIGH(-_LogType)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3)
	BRNE _0x249
; 0000 07CD                                 lcd_putsf("DINGO ITAMPA ");
	__POINTW1FN _0x0,426
	RJMP _0x345
; 0000 07CE                                 }
; 0000 07CF                                 else{
_0x249:
; 0000 07D0                                 IvykisYra = 0;
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 07D1                                 lcd_putsf("NERA IVYKIO  ");
	__POINTW1FN _0x0,440
_0x345:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 07D2                                 }
; 0000 07D3 
; 0000 07D4                                 if(IvykisYra==1){
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x24B
; 0000 07D5                                 lcd_buttons(1,1,0,0,1, 1,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(1)
	RJMP _0x346
; 0000 07D6                                 }
; 0000 07D7                                 else{
_0x24B:
; 0000 07D8                                 lcd_buttons(1,1,0,0,0, 1,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
_0x346:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 07D9                                 }
; 0000 07DA 
; 0000 07DB                             }
	ADIW R28,1
; 0000 07DC                             else{
	RJMP _0x24D
_0x244:
; 0000 07DD                             lcd_putchar(NumToIndex( Address[2] ));
	__GETB1MN _Address,4
	ST   -Y,R30
	CALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 07DE                             lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 07DF                             lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 07E0 
; 0000 07E1                                 if(Address[2]==1){
	__GETW1MN _Address,4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x24E
; 0000 07E2                                 //11.1. 2011.07.31
; 0000 07E3                                 //11.2. 02:37
; 0000 07E4                                 //11.3. 95.3C S.K.
; 0000 07E5                                 //11.4. 34.4C BOIL
; 0000 07E6                                 //11.5.
; 0000 07E7                                 lcd_put_number(0,4,0,0,LogYear[a],0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDI  R26,LOW(_LogYear)
	LDI  R27,HIGH(_LogYear)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 07E8                                 lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 07E9                                 lcd_put_number(0,2,0,0,LogMonth[a],0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SUBI R26,LOW(-_LogMonth)
	SBCI R27,HIGH(-_LogMonth)
	CALL __EEPROMRDB
	LDI  R31,0
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 07EA                                 lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 07EB                                 lcd_put_number(0,2,0,0,LogDay[a],0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SUBI R26,LOW(-_LogDay)
	SBCI R27,HIGH(-_LogDay)
	CALL __EEPROMRDB
	LDI  R31,0
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 07EC                                 }
; 0000 07ED                                 else if(Address[2]==2){
	RJMP _0x24F
_0x24E:
	__GETW1MN _Address,4
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x250
; 0000 07EE                                 lcd_putsf("  ");
	__POINTW1FN _0x0,3
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 07EF                                 lcd_put_number(0,2,0,0,LogHour[a],0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SUBI R26,LOW(-_LogHour)
	SBCI R27,HIGH(-_LogHour)
	CALL __EEPROMRDB
	LDI  R31,0
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 07F0                                 lcd_putchar(':');
	LDI  R30,LOW(58)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 07F1                                 lcd_put_number(0,2,0,0,LogMinute[a],0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SUBI R26,LOW(-_LogMinute)
	SBCI R27,HIGH(-_LogMinute)
	CALL __EEPROMRDB
	LDI  R31,0
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 07F2                                 lcd_putsf("   ");
	__POINTW1FN _0x0,15
	RJMP _0x347
; 0000 07F3                                 }
; 0000 07F4                                 else if(Address[2]==3){
_0x250:
	__GETW1MN _Address,4
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x252
; 0000 07F5                                 lcd_put_number(1,2,1,0,0,LogData1[a]);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(_LogData1)
	LDI  R27,HIGH(_LogData1)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 07F6                                 lcd_putsf("C SAUL.");
	__POINTW1FN _0x0,454
	RJMP _0x347
; 0000 07F7                                 }
; 0000 07F8                                 else if(Address[2]==4){
_0x252:
	__GETW1MN _Address,4
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x254
; 0000 07F9                                 lcd_put_number(1,2,1,0,0,LogData2[a]);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(_LogData2)
	LDI  R27,HIGH(_LogData2)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 07FA                                 lcd_putsf("C BOIL.");
	__POINTW1FN _0x0,462
_0x347:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 07FB                                 }
; 0000 07FC                             lcd_buttons(0,0,0,0,1, 1,0,0,0);
_0x254:
_0x24F:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 07FD                             }
_0x24D:
; 0000 07FE                         }
	ADIW R28,2
; 0000 07FF                         else{
	RJMP _0x255
_0x240:
; 0000 0800                             if(Address[2]==0){
	__GETW1MN _Address,4
	SBIW R30,0
	BRNE _0x256
; 0000 0801                             lcd_putsf("TRINTI IRASUS?  ");
	__POINTW1FN _0x0,470
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0802                             lcd_putsf(" <||>   TAIP=>*");
	__POINTW1FN _0x0,487
_0x343:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0803                             }
; 0000 0804                         }
_0x256:
_0x255:
; 0000 0805                     }
; 0000 0806                 }
; 0000 0807             }
_0x23D:
; 0000 0808             else if(Address[0]==10){//+
	RJMP _0x257
_0x215:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,10
	BREQ PC+3
	JMP _0x258
; 0000 0809 
; 0000 080A                 if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x259
; 0000 080B                     if(BUTTON[4]==1){
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x25A
; 0000 080C                     Address[1] = 1;
	__POINTW1MN _Address,2
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 080D                     }
; 0000 080E                 }
_0x25A:
; 0000 080F                 else{
	RJMP _0x25B
_0x259:
; 0000 0810                     if(BUTTON[0]==1){
	LDS  R26,_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x25C
; 0000 0811                     Address[1]--;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0812                         if(Address[1]<1){
	__GETW2MN _Address,2
	SBIW R26,1
	BRGE _0x25D
; 0000 0813                         Address[1] = 8;
	__POINTW1MN _Address,2
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0814                         }
; 0000 0815                     }
_0x25D:
; 0000 0816                     else if(BUTTON[1]==1){
	RJMP _0x25E
_0x25C:
	__GETB2MN _BUTTON_S0000010001,1
	CPI  R26,LOW(0x1)
	BRNE _0x25F
; 0000 0817                     Address[1]++;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0818                         if(Address[1]>8){
	__GETW2MN _Address,2
	SBIW R26,9
	BRLT _0x260
; 0000 0819                         Address[1] = 1;
	__POINTW1MN _Address,2
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 081A                         }
; 0000 081B                     }
_0x260:
; 0000 081C 
; 0000 081D                     if(BUTTON[2]==1){
_0x25F:
_0x25E:
	__GETB2MN _BUTTON_S0000010001,2
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x261
; 0000 081E                         if(Address[1]==1){
	__GETW1MN _Address,2
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x262
; 0000 081F                             if(RealTimeYear<9000){
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x2328)
	LDI  R26,HIGH(0x2328)
	CPC  R31,R26
	BRSH _0x263
; 0000 0820                             RealTimeYear = RealTimeYear + 1000;
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMWRW
; 0000 0821                             }
; 0000 0822                         }
_0x263:
; 0000 0823                         else if(Address[1]==2){
	RJMP _0x264
_0x262:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x265
; 0000 0824                             if(RealTimeYear<9900){
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x26AC)
	LDI  R26,HIGH(0x26AC)
	CPC  R31,R26
	BRSH _0x266
; 0000 0825                             RealTimeYear = RealTimeYear + 100;
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMWRW
; 0000 0826                             }
; 0000 0827                         }
_0x266:
; 0000 0828                         else if(Address[1]==3){
	RJMP _0x267
_0x265:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x268
; 0000 0829                             if(RealTimeYear<9990){
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x2706)
	LDI  R26,HIGH(0x2706)
	CPC  R31,R26
	BRSH _0x269
; 0000 082A                             RealTimeYear = RealTimeYear + 10;
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	ADIW R30,10
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMWRW
; 0000 082B                             }
; 0000 082C                         }
_0x269:
; 0000 082D                         else if(Address[1]==4){
	RJMP _0x26A
_0x268:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x26B
; 0000 082E                             if(RealTimeYear<9999){
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x270F)
	LDI  R26,HIGH(0x270F)
	CPC  R31,R26
	BRSH _0x26C
; 0000 082F                             RealTimeYear = RealTimeYear + 1;
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	ADIW R30,1
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMWRW
; 0000 0830                             }
; 0000 0831                         }
_0x26C:
; 0000 0832                         else if(Address[1]==5){
	RJMP _0x26D
_0x26B:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x26E
; 0000 0833                             if(RealTimeMonth<=2){
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3)
	BRGE _0x26F
; 0000 0834                             RealTimeMonth = RealTimeMonth + 10;
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	SUBI R30,-LOW(10)
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMWRB
; 0000 0835                             }
; 0000 0836                         }
_0x26F:
; 0000 0837                         else if(Address[1]==6){
	RJMP _0x270
_0x26E:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x271
; 0000 0838                             if(RealTimeMonth<12){
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xC)
	BRGE _0x272
; 0000 0839                             RealTimeMonth = RealTimeMonth + 1;
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMWRB
; 0000 083A                             }
; 0000 083B                         }
_0x272:
; 0000 083C                         else if(Address[1]==7){
	RJMP _0x273
_0x271:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x274
; 0000 083D                             if(RealTimeDay<=DayCountInMonth(RealTimeYear,RealTimeMonth)-10){
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	PUSH R30
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _DayCountInMonth
	LDI  R31,0
	SBIW R30,10
	POP  R26
	LDI  R27,0
	SBRC R26,7
	SER  R27
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x275
; 0000 083E                             RealTimeDay = RealTimeDay + 10;
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	SUBI R30,-LOW(10)
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMWRB
; 0000 083F                             }
; 0000 0840                         }
_0x275:
; 0000 0841                         else if(Address[1]==8){
	RJMP _0x276
_0x274:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x277
; 0000 0842                             if(RealTimeDay<DayCountInMonth(RealTimeYear,RealTimeMonth)){
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	PUSH R30
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _DayCountInMonth
	POP  R26
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x278
; 0000 0843                             RealTimeDay = RealTimeDay + 1;
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMWRB
; 0000 0844                             }
; 0000 0845                         }
_0x278:
; 0000 0846                     }
_0x277:
_0x276:
_0x273:
_0x270:
_0x26D:
_0x26A:
_0x267:
_0x264:
; 0000 0847                     else if(BUTTON[3]==1){
	RJMP _0x279
_0x261:
	__GETB2MN _BUTTON_S0000010001,3
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x27A
; 0000 0848                         if(Address[1]==1){
	__GETW1MN _Address,2
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x27B
; 0000 0849                             if(RealTimeYear>=3011){
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	CPI  R30,LOW(0xBC3)
	LDI  R26,HIGH(0xBC3)
	CPC  R31,R26
	BRLO _0x27C
; 0000 084A                             RealTimeYear = RealTimeYear - 1000;
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	SUBI R30,LOW(1000)
	SBCI R31,HIGH(1000)
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMWRW
; 0000 084B                             }
; 0000 084C                         }
_0x27C:
; 0000 084D                         else if(Address[1]==2){
	RJMP _0x27D
_0x27B:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x27E
; 0000 084E                             if(RealTimeYear>=2111){
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x83F)
	LDI  R26,HIGH(0x83F)
	CPC  R31,R26
	BRLO _0x27F
; 0000 084F                             RealTimeYear = RealTimeYear - 100;
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMWRW
; 0000 0850                             }
; 0000 0851                         }
_0x27F:
; 0000 0852                         else if(Address[1]==3){
	RJMP _0x280
_0x27E:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x281
; 0000 0853                             if(RealTimeYear>=2021){
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x7E5)
	LDI  R26,HIGH(0x7E5)
	CPC  R31,R26
	BRLO _0x282
; 0000 0854                             RealTimeYear = RealTimeYear - 10;
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	SBIW R30,10
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMWRW
; 0000 0855                             }
; 0000 0856                         }
_0x282:
; 0000 0857                         else if(Address[1]==4){
	RJMP _0x283
_0x281:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x284
; 0000 0858                             if(RealTimeYear>2011){
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x7DC)
	LDI  R26,HIGH(0x7DC)
	CPC  R31,R26
	BRLO _0x285
; 0000 0859                             RealTimeYear = RealTimeYear - 1;
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	SBIW R30,1
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMWRW
; 0000 085A                             }
; 0000 085B                         }
_0x285:
; 0000 085C                         else if(Address[1]==5){
	RJMP _0x286
_0x284:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x287
; 0000 085D                             if(RealTimeMonth>10){
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xB)
	BRLT _0x288
; 0000 085E                             RealTimeMonth = RealTimeMonth - 10;
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	SBIW R30,10
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMWRB
; 0000 085F                             }
; 0000 0860                         }
_0x288:
; 0000 0861                         else if(Address[1]==6){
	RJMP _0x289
_0x287:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x28A
; 0000 0862                             if(RealTimeMonth>1){
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRLT _0x28B
; 0000 0863                             RealTimeMonth = RealTimeMonth - 1;
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	SBIW R30,1
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMWRB
; 0000 0864                             }
; 0000 0865                         }
_0x28B:
; 0000 0866                         else if(Address[1]==7){
	RJMP _0x28C
_0x28A:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x28D
; 0000 0867                             if(RealTimeDay>10){
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xB)
	BRLT _0x28E
; 0000 0868                             RealTimeDay = RealTimeDay - 10;
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	SBIW R30,10
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMWRB
; 0000 0869                             }
; 0000 086A                         }
_0x28E:
; 0000 086B                         else if(Address[1]==8){
	RJMP _0x28F
_0x28D:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x290
; 0000 086C                             if(RealTimeDay>1){
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRLT _0x291
; 0000 086D                             RealTimeDay = RealTimeDay - 1;
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	SBIW R30,1
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMWRB
; 0000 086E                             }
; 0000 086F                         }
_0x291:
; 0000 0870                     }
_0x290:
_0x28F:
_0x28C:
_0x289:
_0x286:
_0x283:
_0x280:
_0x27D:
; 0000 0871 
; 0000 0872                     if(BUTTON[4]==1){
_0x27A:
_0x279:
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x292
; 0000 0873                     Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0874                     }
; 0000 0875                 }
_0x292:
_0x25B:
; 0000 0876 
; 0000 0877                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ PC+3
	JMP _0x293
; 0000 0878                 MakeValidRealTimeDate();
	CALL _MakeValidRealTimeDate
; 0000 0879 
; 0000 087A                 lcd_putsf("DATA: ");
	__POINTW1FN _0x0,503
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 087B                 lcd_put_number(0,4,0,0,RealTimeYear,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 087C                 lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 087D                 lcd_put_number(0,2,0,0,RealTimeMonth,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 087E                 lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 087F                 lcd_put_number(0,2,0,0,RealTimeDay,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 0880 
; 0000 0881                     if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x294
; 0000 0882                     lcd_putsf("NUSTATYTI? -->* ");
	__POINTW1FN _0x0,510
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0883                     }
; 0000 0884                     else{
	RJMP _0x295
_0x294:
; 0000 0885                     lcd_buttons(1,1,1,1,1,0,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 0886                         if(Address[1]==1){
	__GETW1MN _Address,2
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x296
; 0000 0887                         lcd_cursor(6,0);
	LDI  R30,LOW(6)
	RJMP _0x348
; 0000 0888                         }
; 0000 0889                         else if(Address[1]==2){
_0x296:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x298
; 0000 088A                         lcd_cursor(7,0);
	LDI  R30,LOW(7)
	RJMP _0x348
; 0000 088B                         }
; 0000 088C                         else if(Address[1]==3){
_0x298:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x29A
; 0000 088D                         lcd_cursor(8,0);
	LDI  R30,LOW(8)
	RJMP _0x348
; 0000 088E                         }
; 0000 088F                         else if(Address[1]==4){
_0x29A:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x29C
; 0000 0890                         lcd_cursor(9,0);
	LDI  R30,LOW(9)
	RJMP _0x348
; 0000 0891                         }
; 0000 0892                         else if(Address[1]==5){
_0x29C:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x29E
; 0000 0893                         lcd_cursor(11,0);
	LDI  R30,LOW(11)
	RJMP _0x348
; 0000 0894                         }
; 0000 0895                         else if(Address[1]==6){
_0x29E:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2A0
; 0000 0896                         lcd_cursor(12,0);
	LDI  R30,LOW(12)
	RJMP _0x348
; 0000 0897                         }
; 0000 0898                         else if(Address[1]==7){
_0x2A0:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2A2
; 0000 0899                         lcd_cursor(14,0);
	LDI  R30,LOW(14)
	RJMP _0x348
; 0000 089A                         }
; 0000 089B                         else if(Address[1]==8){
_0x2A2:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2A4
; 0000 089C                         lcd_cursor(15,0);
	LDI  R30,LOW(15)
_0x348:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_cursor
; 0000 089D                         }
; 0000 089E                     }
_0x2A4:
_0x295:
; 0000 089F                 }
; 0000 08A0             }
_0x293:
; 0000 08A1             else if(Address[0]==11){//+
	RJMP _0x2A5
_0x258:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,11
	BREQ PC+3
	JMP _0x2A6
; 0000 08A2 
; 0000 08A3                 if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x2A7
; 0000 08A4                     if(BUTTON[4]==1){
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x2A8
; 0000 08A5                     Address[1] = 1;
	__POINTW1MN _Address,2
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 08A6                     }
; 0000 08A7                 }
_0x2A8:
; 0000 08A8                 else{
	RJMP _0x2A9
_0x2A7:
; 0000 08A9                     if(BUTTON[0]==1){
	LDS  R26,_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x2AA
; 0000 08AA                         if(Address[1]==1){
	__GETW1MN _Address,2
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2AB
; 0000 08AB                         Address[1] = 4;
	__POINTW1MN _Address,2
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 08AC                         }
; 0000 08AD                         else{
	RJMP _0x2AC
_0x2AB:
; 0000 08AE                         Address[1]--;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 08AF                         }
_0x2AC:
; 0000 08B0                     }
; 0000 08B1                     else if(BUTTON[1]==1){
	RJMP _0x2AD
_0x2AA:
	__GETB2MN _BUTTON_S0000010001,1
	CPI  R26,LOW(0x1)
	BRNE _0x2AE
; 0000 08B2                         if(Address[1]==4){
	__GETW1MN _Address,2
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2AF
; 0000 08B3                         Address[1] = 1;
	__POINTW1MN _Address,2
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 08B4                         }
; 0000 08B5                         else{
	RJMP _0x2B0
_0x2AF:
; 0000 08B6                         Address[1]++;
	__POINTW2MN _Address,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 08B7                         }
_0x2B0:
; 0000 08B8                     }
; 0000 08B9 
; 0000 08BA                     if(BUTTON[2]==1){
_0x2AE:
_0x2AD:
	__GETB2MN _BUTTON_S0000010001,2
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x2B1
; 0000 08BB                         if(Address[1]==1){
	__GETW1MN _Address,2
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2B2
; 0000 08BC                             if(RealTimeHour<=13){
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xE)
	BRGE _0x2B3
; 0000 08BD                             RealTimeHour = RealTimeHour + 10;
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	SUBI R30,-LOW(10)
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMWRB
; 0000 08BE                             }
; 0000 08BF                         }
_0x2B3:
; 0000 08C0                         else if(Address[1]==2){
	RJMP _0x2B4
_0x2B2:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2B5
; 0000 08C1                             if(RealTimeHour<23){
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x17)
	BRGE _0x2B6
; 0000 08C2                             RealTimeHour++;
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 08C3                             }
; 0000 08C4                         }
_0x2B6:
; 0000 08C5                         else if(Address[1]==3){
	RJMP _0x2B7
_0x2B5:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2B8
; 0000 08C6                             if(RealTimeMinute<50){
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x32)
	BRGE _0x2B9
; 0000 08C7                             RealTimeMinute = RealTimeMinute + 10;
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	SUBI R30,-LOW(10)
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMWRB
; 0000 08C8                             }
; 0000 08C9                         }
_0x2B9:
; 0000 08CA                         else if(Address[1]==4){
	RJMP _0x2BA
_0x2B8:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2BB
; 0000 08CB                             if(RealTimeMinute<59){
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3B)
	BRGE _0x2BC
; 0000 08CC                             RealTimeMinute++;
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 08CD                             }
; 0000 08CE                         }
_0x2BC:
; 0000 08CF                     }
_0x2BB:
_0x2BA:
_0x2B7:
_0x2B4:
; 0000 08D0                     else if(BUTTON[3]==1){
	RJMP _0x2BD
_0x2B1:
	__GETB2MN _BUTTON_S0000010001,3
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x2BE
; 0000 08D1                         if(Address[1]==1){
	__GETW1MN _Address,2
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2BF
; 0000 08D2                             if(RealTimeHour>=10){
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xA)
	BRLT _0x2C0
; 0000 08D3                             RealTimeHour = RealTimeHour - 10;
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	SBIW R30,10
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMWRB
; 0000 08D4                             }
; 0000 08D5                         }
_0x2C0:
; 0000 08D6                         else if(Address[1]==2){
	RJMP _0x2C1
_0x2BF:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2C2
; 0000 08D7                             if(RealTimeHour>=1){
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRLT _0x2C3
; 0000 08D8                             RealTimeHour--;
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
; 0000 08D9                             }
; 0000 08DA                         }
_0x2C3:
; 0000 08DB                         else if(Address[1]==3){
	RJMP _0x2C4
_0x2C2:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2C5
; 0000 08DC                             if(RealTimeMinute>=10){
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xA)
	BRLT _0x2C6
; 0000 08DD                             RealTimeMinute = RealTimeMinute - 10;
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	SBIW R30,10
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMWRB
; 0000 08DE                             }
; 0000 08DF                         }
_0x2C6:
; 0000 08E0                         else if(Address[1]==4){
	RJMP _0x2C7
_0x2C5:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2C8
; 0000 08E1                             if(RealTimeMinute>=1){
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRLT _0x2C9
; 0000 08E2                             RealTimeMinute--;
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
; 0000 08E3                             }
; 0000 08E4                         }
_0x2C9:
; 0000 08E5                     }
_0x2C8:
_0x2C7:
_0x2C4:
_0x2C1:
; 0000 08E6 
; 0000 08E7                     if(BUTTON[4]==1){
_0x2BE:
_0x2BD:
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x2CA
; 0000 08E8                     Address[1] = 0;
	__POINTW1MN _Address,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 08E9                     }
; 0000 08EA 
; 0000 08EB                 }
_0x2CA:
_0x2A9:
; 0000 08EC 
; 0000 08ED                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ PC+3
	JMP _0x2CB
; 0000 08EE                 lcd_putsf("LAIKAS: ");
	__POINTW1FN _0x0,527
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 08EF                 lcd_put_number(0,2,0,0,RealTimeHour,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 08F0                 lcd_putchar(':');
	LDI  R30,LOW(58)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 08F1                 lcd_put_number(0,2,0,0,RealTimeMinute,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 08F2 
; 0000 08F3                     if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x2CC
; 0000 08F4                     lcd_putchar(':');
	LDI  R30,LOW(58)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 08F5                     lcd_put_number(0,2,0,0,RealTimeSecond,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(_RealTimeSecond)
	LDI  R27,HIGH(_RealTimeSecond)
	CALL __EEPROMRDB
	LDI  R31,0
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 08F6                     lcd_putsf("NUSTATYTI? -->* ");
	__POINTW1FN _0x0,510
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 08F7                     }
; 0000 08F8                     else{
	RJMP _0x2CD
_0x2CC:
; 0000 08F9                     RealTimeSecond = 0;
	LDI  R26,LOW(_RealTimeSecond)
	LDI  R27,HIGH(_RealTimeSecond)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 08FA                     lcd_putsf("   ");
	__POINTW1FN _0x0,15
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 08FB                     lcd_buttons(1,1,1,1,1, 0,0,0,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 08FC                         if(Address[1]==1){
	__GETW1MN _Address,2
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2CE
; 0000 08FD                         lcd_cursor(8,0);
	LDI  R30,LOW(8)
	RJMP _0x349
; 0000 08FE                         }
; 0000 08FF                         else if(Address[1]==2){
_0x2CE:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2D0
; 0000 0900                         lcd_cursor(9,0);
	LDI  R30,LOW(9)
	RJMP _0x349
; 0000 0901                         }
; 0000 0902                         else if(Address[1]==3){
_0x2D0:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2D2
; 0000 0903                         lcd_cursor(11,0);
	LDI  R30,LOW(11)
	RJMP _0x349
; 0000 0904                         }
; 0000 0905                         else if(Address[1]==4){
_0x2D2:
	__GETW1MN _Address,2
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2D4
; 0000 0906                         lcd_cursor(12,0);
	LDI  R30,LOW(12)
_0x349:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_cursor
; 0000 0907                         }
; 0000 0908                     }
_0x2D4:
_0x2CD:
; 0000 0909                 }
; 0000 090A             }
_0x2CB:
; 0000 090B             else if(Address[0]==12){
	RJMP _0x2D5
_0x2A6:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,12
	BREQ PC+3
	JMP _0x2D6
; 0000 090C                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ PC+3
	JMP _0x2D7
; 0000 090D                     if(SolarColectorState/10==0){
	LDS  R26,_SolarColectorState_S0000010002
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SBIW R30,0
	BRNE _0x2D8
; 0000 090E                     lcd_putsf("MATUOJA: BOILER.");
	__POINTW1FN _0x0,536
	RJMP _0x34A
; 0000 090F                     }
; 0000 0910                     else if(SolarColectorState/10==1){
_0x2D8:
	LDS  R26,_SolarColectorState_S0000010002
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2DA
; 0000 0911                     lcd_putsf("MATUOJA: S.IEJI.");
	__POINTW1FN _0x0,553
	RJMP _0x34A
; 0000 0912                     }
; 0000 0913                     else if(SolarColectorState/10==2){
_0x2DA:
	LDS  R26,_SolarColectorState_S0000010002
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2DC
; 0000 0914                     lcd_putsf("MATUOJA: S.ISEJ.");
	__POINTW1FN _0x0,570
	RJMP _0x34A
; 0000 0915                     }
; 0000 0916                     else{
_0x2DC:
; 0000 0917                     lcd_putsf("MATUOJA: ------ ");
	__POINTW1FN _0x0,587
_0x34A:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0918                     }
; 0000 0919 
; 0000 091A 
; 0000 091B                 lcd_putsf("TEMP:    ");
	__POINTW1FN _0x0,604
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 091C                 lcd_put_number(1,3,1,1,0,GetTemperature());
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _GetTemperature
	CALL __CWD1
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 091D                 }
; 0000 091E             }
_0x2D7:
; 0000 091F             else if(Address[0]==13){
	RJMP _0x2DE
_0x2D6:
	LDS  R26,_Address
	LDS  R27,_Address+1
	SBIW R26,13
	BREQ PC+3
	JMP _0x2DF
; 0000 0920                 if(Address[1]==0){
	__GETW1MN _Address,2
	SBIW R30,0
	BRNE _0x2E0
; 0000 0921                     if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x2E1
; 0000 0922                     lcd_putsf("ATSTATYTI VISKA?");
	__POINTW1FN _0x0,614
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0923                     lcd_putsf("        TAIP=>* ");
	__POINTW1FN _0x0,631
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0924                     }
; 0000 0925 
; 0000 0926                     if(BUTTON[4]==1){
_0x2E1:
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BRNE _0x2E2
; 0000 0927                     EnterCode(13,0,0,13,1,0);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _EnterCode
; 0000 0928                     }
; 0000 0929                 }
_0x2E2:
; 0000 092A                 else{
	RJMP _0x2E3
_0x2E0:
; 0000 092B                 unsigned char i;
; 0000 092C                 NewestLog = 0;
	SBIW R28,1
;	i -> Y+0
	LDI  R26,LOW(_NewestLog)
	LDI  R27,HIGH(_NewestLog)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 092D 
; 0000 092E                 lcd_clear();
	CALL _lcd_clear
; 0000 092F                 lcd_putsf("   ATSTATOMA    ");
	__POINTW1FN _0x0,648
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0930                 lcd_putsf("   PALAUKITE    ");
	__POINTW1FN _0x0,665
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0931 
; 0000 0932                 RealTimeYear = 0;
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 0933                 RealTimeMonth = 0;
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMWRB
; 0000 0934                 RealTimeDay = 0;
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMWRB
; 0000 0935                 RealTimeHour = 0;
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMWRB
; 0000 0936                 RealTimeMinute = 0;
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMWRB
; 0000 0937 
; 0000 0938 
; 0000 0939                 LitersPerMinute = 20;
	LDI  R26,LOW(_LitersPerMinute)
	LDI  R27,HIGH(_LitersPerMinute)
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __EEPROMWRW
; 0000 093A                 SolarColectorWattHours = 0;
	LDI  R26,LOW(_SolarColectorWattHours)
	LDI  R27,HIGH(_SolarColectorWattHours)
	__GETD1N 0x0
	CALL __EEPROMWRD
; 0000 093B                 WattHoursPerDay = 0;
	LDI  R26,LOW(_WattHoursPerDay)
	LDI  R27,HIGH(_WattHoursPerDay)
	CALL __EEPROMWRD
; 0000 093C                 MinimumAntifreezeTemp = 350;
	LDI  R26,LOW(_MinimumAntifreezeTemp)
	LDI  R27,HIGH(_MinimumAntifreezeTemp)
	LDI  R30,LOW(350)
	LDI  R31,HIGH(350)
	CALL __EEPROMWRW
; 0000 093D                 DifferenceBoilerAndSolar = 100;
	LDI  R26,LOW(_DifferenceBoilerAndSolar)
	LDI  R27,HIGH(_DifferenceBoilerAndSolar)
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __EEPROMWRW
; 0000 093E                 MaxDayTemperature = 0;
	LDI  R26,LOW(_MaxDayTemperature)
	LDI  R27,HIGH(_MaxDayTemperature)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 093F 
; 0000 0940                     for(i=0;i<LOG_COUNT;i++){
	ST   Y,R30
_0x2E5:
	LD   R26,Y
	CPI  R26,LOW(0x5A)
	BRLO PC+3
	JMP _0x2E6
; 0000 0941                     LogYear[i] = 0;
	LD   R30,Y
	LDI  R26,LOW(_LogYear)
	LDI  R27,HIGH(_LogYear)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 0942                     LogMonth[i] = 0;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_LogMonth)
	SBCI R27,HIGH(-_LogMonth)
	CALL __EEPROMWRB
; 0000 0943                     LogDay[i] = 0;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_LogDay)
	SBCI R27,HIGH(-_LogDay)
	CALL __EEPROMWRB
; 0000 0944                     LogHour[i] = 0;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_LogHour)
	SBCI R27,HIGH(-_LogHour)
	CALL __EEPROMWRB
; 0000 0945                     LogMinute[i] = 0;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_LogMinute)
	SBCI R27,HIGH(-_LogMinute)
	CALL __EEPROMWRB
; 0000 0946 
; 0000 0947                     LogType[i] = 0;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_LogType)
	SBCI R27,HIGH(-_LogType)
	CALL __EEPROMWRB
; 0000 0948 
; 0000 0949                     LogData1[i] = 0;
	LD   R30,Y
	LDI  R26,LOW(_LogData1)
	LDI  R27,HIGH(_LogData1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 094A                     LogData2[i] = 0;
	LD   R30,Y
	LDI  R26,LOW(_LogData2)
	LDI  R27,HIGH(_LogData2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 094B                     }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x2E5
_0x2E6:
; 0000 094C 
; 0000 094D                     if(1){
; 0000 094E                     unsigned char Position;
; 0000 094F                         while(1){
	SBIW R28,1
;	i -> Y+1
;	Position -> Y+0
_0x2E8:
; 0000 0950                         unsigned char CycleBack;
; 0000 0951                         Position++;
	SBIW R28,1
;	i -> Y+2
;	Position -> Y+1
;	CycleBack -> Y+0
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
; 0000 0952                         lcd_clear();
	CALL _lcd_clear
; 0000 0953                         CycleBack = lcd_put_runing_text(0,0,16,Position,"ISJUNKITE IR VEL IJUNKITE VALDIKLI");
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+5
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,682
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_put_runing_text
	ST   Y,R30
; 0000 0954                             if(CycleBack==1){
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x2EB
; 0000 0955                             Position = 0;
	LDI  R30,LOW(0)
	STD  Y+1,R30
; 0000 0956                             }
; 0000 0957                         delay_ms(300);
_0x2EB:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0958                         }
	ADIW R28,1
	RJMP _0x2E8
; 0000 0959                     }
; 0000 095A                 }
_0x2E3:
; 0000 095B             }
; 0000 095C /*            else if(Address[0]==14){
; 0000 095D                 if(Address[1]==0){
; 0000 095E                     if(RefreshLcd==1){
; 0000 095F                     lcd_putsf("DUOMENU         SIUNTIMAS MBUS");
; 0000 0960                     }
; 0000 0961 
; 0000 0962                     if(BUTTON[4]==1){
; 0000 0963                     Address[1] = 1;
; 0000 0964                     }
; 0000 0965                 }
; 0000 0966                 else if(Address[1]==1){
; 0000 0967                 //static unsigned char DataToSent[200];
; 0000 0968                 //static unsigned char ReceivedData[200];
; 0000 0969                     if(RefreshLcd==1){
; 0000 096A                     unsigned char i;
; 0000 096B                         for(i=0;i<16;i++){
; 0000 096C                             if(Address[2]+i<200){
; 0000 096D                             lcd_putchar(DataToSent[Address[2]+i]);
; 0000 096E                             }
; 0000 096F                             else{
; 0000 0970                             lcd_putchar(' ');
; 0000 0971                             }
; 0000 0972                         }
; 0000 0973 
; 0000 0974                     lcd_put_number(0,3,0,0,Address[2],0);
; 0000 0975                     lcd_putchar(' ');
; 0000 0976                     lcd_put_number(0,3,0,0,DataToSent[Address[2]],0);
; 0000 0977                     }
; 0000 0978 
; 0000 0979                     if(DUAL_BUTTON[0]==1){
; 0000 097A                     Address[0] = 0;
; 0000 097B                     Address[1] = 0;
; 0000 097C                     Address[2] = 0;
; 0000 097D                     }
; 0000 097E 
; 0000 097F                     if(BUTTON[0]==1){
; 0000 0980                         if(Address[2]>0){
; 0000 0981                         Address[2]--;
; 0000 0982                         }
; 0000 0983                     }
; 0000 0984                     else if(BUTTON[1]==1){
; 0000 0985                         if(Address[2]<199){
; 0000 0986                         Address[2]++;
; 0000 0987                         }
; 0000 0988                     }
; 0000 0989 
; 0000 098A                     if(BUTTON[2]==1){
; 0000 098B                     DataToSent[Address[2]]++;
; 0000 098C                     }
; 0000 098D 
; 0000 098E                     if(BUTTON[3]==1){
; 0000 098F                     DataToSent[Address[2]]--;
; 0000 0990                     }
; 0000 0991 
; 0000 0992                     if(BUTTON[4]==1){
; 0000 0993                     Address[1] = 1;
; 0000 0994                     Address[2] = 0;
; 0000 0995 
; 0000 0996                     lcd_clear();
; 0000 0997                     lcd_putsf("SIUNCIAMA:");
; 0000 0998                     delay_ms(1000);
; 0000 0999 
; 0000 099A                     SendMBus();
; 0000 099B 
; 0000 099C                     lcd_clear();
; 0000 099D                     lcd_putsf("GAUNAMA:");
; 0000 099E                     delay_ms(1000);
; 0000 099F 
; 0000 09A0                     GetMBus();
; 0000 09A1                     }
; 0000 09A2 
; 0000 09A3 
; 0000 09A4                 }
; 0000 09A5                 else if(Address[1]==2){
; 0000 09A6                     if(RefreshLcd==1){
; 0000 09A7                     unsigned char i;
; 0000 09A8                         for(i=0;i<16;i++){
; 0000 09A9                             if(Address[2]+i<200){
; 0000 09AA                             lcd_putchar(ReceivedData[Address[2]+i]);
; 0000 09AB                             }
; 0000 09AC                             else{
; 0000 09AD                             lcd_putchar(' ');
; 0000 09AE                             }
; 0000 09AF                         }
; 0000 09B0 
; 0000 09B1                     lcd_put_number(0,3,0,0,Address[2],0);
; 0000 09B2                     lcd_putchar(' ');
; 0000 09B3                     lcd_put_number(0,3,0,0,ReceivedData[Address[2]],0);
; 0000 09B4                     }
; 0000 09B5 
; 0000 09B6                     if(DUAL_BUTTON[0]==1){
; 0000 09B7                     Address[1] = 0;
; 0000 09B8                     Address[2] = 0;
; 0000 09B9                     }
; 0000 09BA 
; 0000 09BB                     if(BUTTON[0]==1){
; 0000 09BC                         if(Address[2]>0){
; 0000 09BD                         Address[2]--;
; 0000 09BE                         }
; 0000 09BF                     }
; 0000 09C0                     else if(BUTTON[1]==1){
; 0000 09C1                         if(Address[2]<199){
; 0000 09C2                         Address[2]++;
; 0000 09C3                         }
; 0000 09C4                     }
; 0000 09C5 
; 0000 09C6                 }
; 0000 09C7             }*/
; 0000 09C8         }
_0x2DF:
_0x2DE:
_0x2D5:
_0x2A5:
_0x257:
_0x214:
_0x210:
_0x20C:
_0x208:
_0x201:
_0x1FC:
_0x1D2:
_0x1A0:
_0x19C:
; 0000 09C9         else{
	RJMP _0x2EC
_0x198:
; 0000 09CA         /////////////////////////////////////////////////////////////////////
; 0000 09CB             if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ PC+3
	JMP _0x2ED
; 0000 09CC             unsigned int i;
; 0000 09CD             lcd_putsf("KODAS: ");
	SBIW R28,2
;	i -> Y+0
	__POINTW1FN _0x0,717
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 09CE             i = CODE_EnteringCode;
	LDS  R30,_CODE_EnteringCode_G000
	LDS  R31,_CODE_EnteringCode_G000+1
	ST   Y,R30
	STD  Y+1,R31
; 0000 09CF                 if(CODE_ExecutingDigit==0){
	LDS  R30,_CODE_ExecutingDigit_G000
	CPI  R30,0
	BRNE _0x2EE
; 0000 09D0                 lcd_putchar( NumToIndex( i/1000) );
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x34B
; 0000 09D1                 }
; 0000 09D2                 else{
_0x2EE:
; 0000 09D3                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x34B:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 09D4                 }
; 0000 09D5             i = i - (i/1000)*1000;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12U
	LD   R26,Y
	LDD  R27,Y+1
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
; 0000 09D6                 if(CODE_ExecutingDigit==1){
	LDS  R26,_CODE_ExecutingDigit_G000
	CPI  R26,LOW(0x1)
	BRNE _0x2F0
; 0000 09D7                 lcd_putchar( NumToIndex( i/100) );
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x34C
; 0000 09D8                 }
; 0000 09D9                 else{
_0x2F0:
; 0000 09DA                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x34C:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 09DB                 }
; 0000 09DC             i = i - (i/100)*100;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12U
	LD   R26,Y
	LDD  R27,Y+1
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
; 0000 09DD                 if(CODE_ExecutingDigit==2){
	LDS  R26,_CODE_ExecutingDigit_G000
	CPI  R26,LOW(0x2)
	BRNE _0x2F2
; 0000 09DE                 lcd_putchar( NumToIndex( i/10) );
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x34D
; 0000 09DF                 }
; 0000 09E0                 else{
_0x2F2:
; 0000 09E1                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x34D:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 09E2                 }
; 0000 09E3             i = i - (i/10)*10;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	LD   R26,Y
	LDD  R27,Y+1
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
; 0000 09E4                 if(CODE_ExecutingDigit==3){
	LDS  R26,_CODE_ExecutingDigit_G000
	CPI  R26,LOW(0x3)
	BRNE _0x2F4
; 0000 09E5                 lcd_putchar( NumToIndex(i) );
	LD   R30,Y
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x34E
; 0000 09E6                 }
; 0000 09E7                 else{
_0x2F4:
; 0000 09E8                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x34E:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 09E9                 }
; 0000 09EA 
; 0000 09EB             lcd_putsf("   ");
	__POINTW1FN _0x0,15
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 09EC 
; 0000 09ED             i = CODE_TimeLeft;
	LDS  R30,_CODE_TimeLeft_G000
	LDI  R31,0
	ST   Y,R30
	STD  Y+1,R31
; 0000 09EE             lcd_putchar( NumToIndex( i/10) );
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 09EF             i = i - (i/10)*10;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	LD   R26,Y
	LDD  R27,Y+1
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
; 0000 09F0             lcd_putchar( NumToIndex(i) );
	LD   R30,Y
	ST   -Y,R30
	CALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 09F1             }
	ADIW R28,2
; 0000 09F2 
; 0000 09F3         ///// 1 Kodo skaicius /////////
; 0000 09F4             if(CODE_ExecutingDigit==0){
_0x2ED:
	LDS  R30,_CODE_ExecutingDigit_G000
	CPI  R30,0
	BREQ PC+3
	JMP _0x2F6
; 0000 09F5                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x2F7
; 0000 09F6                 lcd_buttons(0,1,1,1,1,1,0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 09F7                 lcd_cursor(7,0);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_cursor
; 0000 09F8                 }
; 0000 09F9 
; 0000 09FA             // pakeisti ivedama skaitmeni
; 0000 09FB                 if(BUTTON[1]==1){
_0x2F7:
	__GETB2MN _BUTTON_S0000010001,1
	CPI  R26,LOW(0x1)
	BRNE _0x2F8
; 0000 09FC                 CODE_ExecutingDigit++;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,-LOW(1)
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 09FD                 }
; 0000 09FE 
; 0000 09FF             // 1 kodo skaitmens keitimas
; 0000 0A00                 if(BUTTON[2]==1){
_0x2F8:
	__GETB2MN _BUTTON_S0000010001,2
	CPI  R26,LOW(0x1)
	BRNE _0x2F9
; 0000 0A01                     if(CODE_EnteringCode<9000){
	LDS  R26,_CODE_EnteringCode_G000
	LDS  R27,_CODE_EnteringCode_G000+1
	CPI  R26,LOW(0x2328)
	LDI  R30,HIGH(0x2328)
	CPC  R27,R30
	BRSH _0x2FA
; 0000 0A02                     CODE_EnteringCode = CODE_EnteringCode + 1000;
	LDS  R30,_CODE_EnteringCode_G000
	LDS  R31,_CODE_EnteringCode_G000+1
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R31
; 0000 0A03                     }
; 0000 0A04                 }
_0x2FA:
; 0000 0A05                 else if(BUTTON[3]==1){
	RJMP _0x2FB
_0x2F9:
	__GETB2MN _BUTTON_S0000010001,3
	CPI  R26,LOW(0x1)
	BRNE _0x2FC
; 0000 0A06                     if(CODE_EnteringCode>=1000){
	LDS  R26,_CODE_EnteringCode_G000
	LDS  R27,_CODE_EnteringCode_G000+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLO _0x2FD
; 0000 0A07                     CODE_EnteringCode = CODE_EnteringCode - 1000;
	LDS  R30,_CODE_EnteringCode_G000
	LDS  R31,_CODE_EnteringCode_G000+1
	SUBI R30,LOW(1000)
	SBCI R31,HIGH(1000)
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R31
; 0000 0A08                     }
; 0000 0A09                 }
_0x2FD:
; 0000 0A0A             }
_0x2FC:
_0x2FB:
; 0000 0A0B         ///////////////////////////////
; 0000 0A0C 
; 0000 0A0D         ///// 2 Kodo skaicius /////////
; 0000 0A0E             else if(CODE_ExecutingDigit==1){
	RJMP _0x2FE
_0x2F6:
	LDS  R26,_CODE_ExecutingDigit_G000
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x2FF
; 0000 0A0F                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x300
; 0000 0A10                 lcd_buttons(1,1,1,1,1,1,0,0,0);
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 0A11                 lcd_cursor(8,0);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_cursor
; 0000 0A12                 }
; 0000 0A13 
; 0000 0A14                 if(BUTTON[0]==1){
_0x300:
	LDS  R26,_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x301
; 0000 0A15                 CODE_ExecutingDigit--;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,LOW(1)
	RJMP _0x34F
; 0000 0A16                 }
; 0000 0A17                 else if(BUTTON[1]==1){
_0x301:
	__GETB2MN _BUTTON_S0000010001,1
	CPI  R26,LOW(0x1)
	BRNE _0x303
; 0000 0A18                 CODE_ExecutingDigit++;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,-LOW(1)
_0x34F:
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 0A19                 }
; 0000 0A1A 
; 0000 0A1B             // 2 kodo skaitmens keitimas
; 0000 0A1C                 if(BUTTON[2]==1){
_0x303:
	__GETB2MN _BUTTON_S0000010001,2
	CPI  R26,LOW(0x1)
	BRNE _0x304
; 0000 0A1D                     if(CODE_EnteringCode<9900){
	LDS  R26,_CODE_EnteringCode_G000
	LDS  R27,_CODE_EnteringCode_G000+1
	CPI  R26,LOW(0x26AC)
	LDI  R30,HIGH(0x26AC)
	CPC  R27,R30
	BRSH _0x305
; 0000 0A1E                     CODE_EnteringCode = CODE_EnteringCode + 100;
	LDS  R30,_CODE_EnteringCode_G000
	LDS  R31,_CODE_EnteringCode_G000+1
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R31
; 0000 0A1F                     }
; 0000 0A20                 }
_0x305:
; 0000 0A21                 else if(BUTTON[3]==1){
	RJMP _0x306
_0x304:
	__GETB2MN _BUTTON_S0000010001,3
	CPI  R26,LOW(0x1)
	BRNE _0x307
; 0000 0A22                     if(CODE_EnteringCode>=100){
	LDS  R26,_CODE_EnteringCode_G000
	LDS  R27,_CODE_EnteringCode_G000+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0x308
; 0000 0A23                     CODE_EnteringCode = CODE_EnteringCode - 100;
	LDS  R30,_CODE_EnteringCode_G000
	LDS  R31,_CODE_EnteringCode_G000+1
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R31
; 0000 0A24                     }
; 0000 0A25                 }
_0x308:
; 0000 0A26             }
_0x307:
_0x306:
; 0000 0A27         ///////////////////////////////
; 0000 0A28 
; 0000 0A29         ///// 3 Kodo skaicius /////////
; 0000 0A2A             else if(CODE_ExecutingDigit==2){
	RJMP _0x309
_0x2FF:
	LDS  R26,_CODE_ExecutingDigit_G000
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x30A
; 0000 0A2B                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x30B
; 0000 0A2C                 lcd_buttons(1,1,1,1,1,1,0,0,0);
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 0A2D                 lcd_cursor(9,0);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_cursor
; 0000 0A2E                 }
; 0000 0A2F 
; 0000 0A30                 if(BUTTON[0]==1){
_0x30B:
	LDS  R26,_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x30C
; 0000 0A31                 CODE_ExecutingDigit--;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,LOW(1)
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 0A32                 }
; 0000 0A33                 if(BUTTON[1]==1){
_0x30C:
	__GETB2MN _BUTTON_S0000010001,1
	CPI  R26,LOW(0x1)
	BRNE _0x30D
; 0000 0A34                 CODE_ExecutingDigit++;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,-LOW(1)
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 0A35                 }
; 0000 0A36 
; 0000 0A37             // 3 kodo skaitmens keitimas
; 0000 0A38                 if(BUTTON[2]==1){
_0x30D:
	__GETB2MN _BUTTON_S0000010001,2
	CPI  R26,LOW(0x1)
	BRNE _0x30E
; 0000 0A39                     if(CODE_EnteringCode<9990){
	LDS  R26,_CODE_EnteringCode_G000
	LDS  R27,_CODE_EnteringCode_G000+1
	CPI  R26,LOW(0x2706)
	LDI  R30,HIGH(0x2706)
	CPC  R27,R30
	BRSH _0x30F
; 0000 0A3A                     CODE_EnteringCode = CODE_EnteringCode + 10;
	LDS  R30,_CODE_EnteringCode_G000
	LDS  R31,_CODE_EnteringCode_G000+1
	ADIW R30,10
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R31
; 0000 0A3B                     }
; 0000 0A3C                 }
_0x30F:
; 0000 0A3D                 else if(BUTTON[3]==1){
	RJMP _0x310
_0x30E:
	__GETB2MN _BUTTON_S0000010001,3
	CPI  R26,LOW(0x1)
	BRNE _0x311
; 0000 0A3E                     if(CODE_EnteringCode>=10){
	LDS  R26,_CODE_EnteringCode_G000
	LDS  R27,_CODE_EnteringCode_G000+1
	SBIW R26,10
	BRLO _0x312
; 0000 0A3F                     CODE_EnteringCode = CODE_EnteringCode - 10;
	LDS  R30,_CODE_EnteringCode_G000
	LDS  R31,_CODE_EnteringCode_G000+1
	SBIW R30,10
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R31
; 0000 0A40                     }
; 0000 0A41                 }
_0x312:
; 0000 0A42             }
_0x311:
_0x310:
; 0000 0A43         ///////////////////////////////
; 0000 0A44 
; 0000 0A45         ///// 4 Kodo skaicius /////////
; 0000 0A46             else if(CODE_ExecutingDigit==3){
	RJMP _0x313
_0x30A:
	LDS  R26,_CODE_ExecutingDigit_G000
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0x314
; 0000 0A47                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x315
; 0000 0A48                 lcd_buttons(1,0,1,1,1,1,0,0,0);
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_buttons
; 0000 0A49                 lcd_cursor(10,0);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_cursor
; 0000 0A4A                 }
; 0000 0A4B 
; 0000 0A4C                 if(BUTTON[0]==1){
_0x315:
	LDS  R26,_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x316
; 0000 0A4D                 CODE_ExecutingDigit--;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,LOW(1)
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 0A4E                 }
; 0000 0A4F 
; 0000 0A50             // 4 kodo skaitmens keitimas
; 0000 0A51                 if(BUTTON[2]==1){
_0x316:
	__GETB2MN _BUTTON_S0000010001,2
	CPI  R26,LOW(0x1)
	BRNE _0x317
; 0000 0A52                     if(CODE_EnteringCode<9999){
	LDS  R26,_CODE_EnteringCode_G000
	LDS  R27,_CODE_EnteringCode_G000+1
	CPI  R26,LOW(0x270F)
	LDI  R30,HIGH(0x270F)
	CPC  R27,R30
	BRSH _0x318
; 0000 0A53                     CODE_EnteringCode = CODE_EnteringCode + 1;
	LDS  R30,_CODE_EnteringCode_G000
	LDS  R31,_CODE_EnteringCode_G000+1
	ADIW R30,1
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R31
; 0000 0A54                     }
; 0000 0A55                 }
_0x318:
; 0000 0A56                 else if(BUTTON[3]==1){
	RJMP _0x319
_0x317:
	__GETB2MN _BUTTON_S0000010001,3
	CPI  R26,LOW(0x1)
	BRNE _0x31A
; 0000 0A57                     if(CODE_EnteringCode>=1){
	LDS  R26,_CODE_EnteringCode_G000
	LDS  R27,_CODE_EnteringCode_G000+1
	SBIW R26,1
	BRLO _0x31B
; 0000 0A58                     CODE_EnteringCode = CODE_EnteringCode - 1;
	LDS  R30,_CODE_EnteringCode_G000
	LDS  R31,_CODE_EnteringCode_G000+1
	SBIW R30,1
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R31
; 0000 0A59                     }
; 0000 0A5A                 }
_0x31B:
; 0000 0A5B             }
_0x31A:
_0x319:
; 0000 0A5C         ///////////////////////////////
; 0000 0A5D 
; 0000 0A5E             if(CODE_TimeLeft==0){
_0x314:
_0x313:
_0x309:
_0x2FE:
	LDS  R30,_CODE_TimeLeft_G000
	CPI  R30,0
	BREQ PC+3
	JMP _0x31C
; 0000 0A5F             Address[0] = CODE_FailedXYZ[0];
	LDS  R30,_CODE_FailedXYZ_G000
	LDI  R31,0
	STS  _Address,R30
	STS  _Address+1,R31
; 0000 0A60             Address[1] = CODE_FailedXYZ[1];
	__POINTW2MN _Address,2
	__GETB1MN _CODE_FailedXYZ_G000,1
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0A61             Address[2] = CODE_FailedXYZ[2];
	__POINTW2MN _Address,4
	__GETB1MN _CODE_FailedXYZ_G000,2
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0A62 
; 0000 0A63             CODE_IsEntering = 0;
	LDI  R30,LOW(0)
	STS  _CODE_IsEntering_G000,R30
; 0000 0A64 
; 0000 0A65             CODE_EnteringCode = 0;
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R30
; 0000 0A66             CODE_ExecutingDigit = 0;
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 0A67 
; 0000 0A68             CODE_TimeLeft = 0;
	STS  _CODE_TimeLeft_G000,R30
; 0000 0A69 
; 0000 0A6A             CODE_SuccessXYZ[0] = 0;
	STS  _CODE_SuccessXYZ_G000,R30
; 0000 0A6B             CODE_SuccessXYZ[1] = 0;
	__PUTB1MN _CODE_SuccessXYZ_G000,1
; 0000 0A6C             CODE_SuccessXYZ[2] = 0;
	__PUTB1MN _CODE_SuccessXYZ_G000,2
; 0000 0A6D             lcd_clear();
	CALL _lcd_clear
; 0000 0A6E             lcd_putsf("    LAIKAS      ");
	__POINTW1FN _0x0,725
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0A6F             lcd_putsf("    BAIGESI     ");
	__POINTW1FN _0x0,742
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0A70             delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0A71             }
; 0000 0A72 
; 0000 0A73             if(DUAL_BUTTON[0]==1){
_0x31C:
	LDS  R26,_DUAL_BUTTON_S0000010001
	CPI  R26,LOW(0x1)
	BRNE _0x31D
; 0000 0A74             Address[0] = CODE_FailedXYZ[0];
	LDS  R30,_CODE_FailedXYZ_G000
	LDI  R31,0
	STS  _Address,R30
	STS  _Address+1,R31
; 0000 0A75             Address[1] = CODE_FailedXYZ[1];
	__POINTW2MN _Address,2
	__GETB1MN _CODE_FailedXYZ_G000,1
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0A76             Address[2] = CODE_FailedXYZ[2];
	__POINTW2MN _Address,4
	__GETB1MN _CODE_FailedXYZ_G000,2
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0A77             CODE_IsEntering = 0;
	LDI  R30,LOW(0)
	STS  _CODE_IsEntering_G000,R30
; 0000 0A78 
; 0000 0A79             CODE_EnteringCode = 0;
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R30
; 0000 0A7A             CODE_ExecutingDigit = 0;
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 0A7B 
; 0000 0A7C             CODE_TimeLeft = 0;
	STS  _CODE_TimeLeft_G000,R30
; 0000 0A7D 
; 0000 0A7E             CODE_SuccessXYZ[0] = 0;
	STS  _CODE_SuccessXYZ_G000,R30
; 0000 0A7F             CODE_SuccessXYZ[1] = 0;
	__PUTB1MN _CODE_SuccessXYZ_G000,1
; 0000 0A80             CODE_SuccessXYZ[2] = 0;
	__PUTB1MN _CODE_SuccessXYZ_G000,2
; 0000 0A81             //CODE_SuccessXYZ = (1,2,3);
; 0000 0A82             }
; 0000 0A83 
; 0000 0A84 
; 0000 0A85             if(BUTTON[4]==1){
_0x31D:
	__GETB2MN _BUTTON_S0000010001,4
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x31E
; 0000 0A86                 if(CODE_EnteringCode==WhatIsTheCode()){
	CALL _WhatIsTheCode
	LDS  R26,_CODE_EnteringCode_G000
	LDS  R27,_CODE_EnteringCode_G000+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x31F
; 0000 0A87                 Address[0] = CODE_SuccessXYZ[0];
	LDS  R30,_CODE_SuccessXYZ_G000
	LDI  R31,0
	STS  _Address,R30
	STS  _Address+1,R31
; 0000 0A88                 Address[1] = CODE_SuccessXYZ[1];
	__POINTW2MN _Address,2
	__GETB1MN _CODE_SuccessXYZ_G000,1
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0A89                 Address[2] = CODE_SuccessXYZ[2];
	__POINTW2MN _Address,4
	__GETB1MN _CODE_SuccessXYZ_G000,2
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0A8A                 lcd_clear();
	CALL _lcd_clear
; 0000 0A8B                 lcd_putsf("     KODAS      ");
	__POINTW1FN _0x0,759
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0A8C                 lcd_putsf("   TEISINGAS    ");
	__POINTW1FN _0x0,776
	RJMP _0x350
; 0000 0A8D                 delay_ms(1000);
; 0000 0A8E                 }
; 0000 0A8F                 else{
_0x31F:
; 0000 0A90                 Address[0] = CODE_FailedXYZ[0];
	LDS  R30,_CODE_FailedXYZ_G000
	LDI  R31,0
	STS  _Address,R30
	STS  _Address+1,R31
; 0000 0A91                 Address[1] = CODE_FailedXYZ[1];
	__POINTW2MN _Address,2
	__GETB1MN _CODE_FailedXYZ_G000,1
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0A92                 Address[2] = CODE_FailedXYZ[2];
	__POINTW2MN _Address,4
	__GETB1MN _CODE_FailedXYZ_G000,2
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0A93                 lcd_clear();
	CALL _lcd_clear
; 0000 0A94                 lcd_putsf("     KODAS      ");
	__POINTW1FN _0x0,759
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0A95                 lcd_putsf("  NETEISINGAS   ");
	__POINTW1FN _0x0,793
_0x350:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0A96                 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0A97                 }
; 0000 0A98             CODE_IsEntering = 0;
	LDI  R30,LOW(0)
	STS  _CODE_IsEntering_G000,R30
; 0000 0A99 
; 0000 0A9A             CODE_EnteringCode = 0;
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R30
; 0000 0A9B             CODE_ExecutingDigit = 0;
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 0A9C 
; 0000 0A9D             CODE_TimeLeft = 0;
	STS  _CODE_TimeLeft_G000,R30
; 0000 0A9E 
; 0000 0A9F             CODE_SuccessXYZ[0] = 0;
	STS  _CODE_SuccessXYZ_G000,R30
; 0000 0AA0             CODE_SuccessXYZ[1] = 0;
	__PUTB1MN _CODE_SuccessXYZ_G000,1
; 0000 0AA1             CODE_SuccessXYZ[2] = 0;
	__PUTB1MN _CODE_SuccessXYZ_G000,2
; 0000 0AA2             }
; 0000 0AA3         /////////////////////////////////////////////////////////////////////
; 0000 0AA4         }
_0x31E:
_0x2EC:
; 0000 0AA5 
; 0000 0AA6 
; 0000 0AA7 
; 0000 0AA8         if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x321
; 0000 0AA9         RefreshLcd = 0;
	CLR  R5
; 0000 0AAA         }
; 0000 0AAB     //////////////////////////////////////////////////////////////////////////////////
; 0000 0AAC     //////////////////////////////////////////////////////////////////////////////////
; 0000 0AAD     //////////////////////////////////////////////////////////////////////////////////
; 0000 0AAE     Called_1Second = 0;
_0x321:
	LDI  R30,LOW(0)
	STS  _Called_1Second_S0000010001,R30
; 0000 0AAF     delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0AB0     }
	JMP  _0xD4
; 0000 0AB1 }
_0x322:
	RJMP _0x322

	.DSEG
_0xD3:
	.BYTE 0x22

	.CSEG
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
_disk_timerproc:
	ST   -Y,R17
	ST   -Y,R16
	LDS  R17,_timer1_G101
	CPI  R17,0
	BREQ _0x20200FA
	SUBI R17,LOW(1)
	STS  _timer1_G101,R17
_0x20200FA:
	LDS  R17,_timer2_G101
	CPI  R17,0
	BREQ _0x20200FB
	SUBI R17,LOW(1)
	STS  _timer2_G101,R17
_0x20200FB:
	LDS  R17,_pv_S101000B000
	IN   R30,0x16
	ANDI R30,LOW(0x8)
	MOV  R26,R30
	IN   R30,0x16
	ANDI R30,LOW(0x4)
	OR   R30,R26
	STS  _pv_S101000B000,R30
	CP   R30,R17
	BRNE _0x20200FC
	LDS  R16,_status_G101
	ANDI R30,LOW(0x8)
	BREQ _0x20200FD
	ORI  R16,LOW(4)
	RJMP _0x20200FE
_0x20200FD:
	ANDI R16,LOW(251)
_0x20200FE:
	LDS  R30,_pv_S101000B000
	ANDI R30,LOW(0x4)
	BREQ _0x20200FF
	ORI  R16,LOW(3)
	RJMP _0x2020100
_0x20200FF:
	ANDI R16,LOW(253)
_0x2020100:
	STS  _status_G101,R16
_0x20200FC:
	LD   R16,Y+
	LD   R17,Y+
	RET

	.CSEG

	.DSEG

	.CSEG
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G103:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G103:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G103
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G103
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2080001
__lcd_read_nibble_G103:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G103
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G103
    andi  r30,0xf0
	RET
_lcd_read_byte0_G103:
	CALL __lcd_delay_G103
	RCALL __lcd_read_nibble_G103
    mov   r26,r30
	RCALL __lcd_read_nibble_G103
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2060004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2080001
_lcd_puts:
	ST   -Y,R17
_0x2060005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2060005
_0x2060007:
	RJMP _0x2080002
_lcd_putsf:
	ST   -Y,R17
_0x2060008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2060008
_0x206000A:
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G103:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G103:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2080001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	RCALL __long_delay_G103
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_init_write_G103
	RCALL __long_delay_G103
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_init_write_G103
	RCALL __long_delay_G103
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_init_write_G103
	RCALL __long_delay_G103
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G103
	RCALL __long_delay_G103
	LDI  R30,LOW(40)
	ST   -Y,R30
	CALL __lcd_write_data
	RCALL __long_delay_G103
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL __lcd_write_data
	RCALL __long_delay_G103
	LDI  R30,LOW(133)
	ST   -Y,R30
	CALL __lcd_write_data
	RCALL __long_delay_G103
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G103
	CPI  R30,LOW(0x5)
	BREQ _0x206000B
	LDI  R30,LOW(0)
	RJMP _0x2080001
_0x206000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2080001:
	ADIW R28,1
	RET

	.DSEG
_prtc_get_time:
	.BYTE 0x2
_prtc_get_date:
	.BYTE 0x2

	.ESEG
_RealTimeYear:
	.BYTE 0x2
_RealTimeMonth:
	.BYTE 0x1
_RealTimeDay:
	.BYTE 0x1
_RealTimeHour:
	.BYTE 0x1
_RealTimeMinute:
	.BYTE 0x1
_RealTimeSecond:
	.BYTE 0x1
_NewestLog:
	.BYTE 0x1
_LogYear:
	.BYTE 0xB4
_LogMonth:
	.BYTE 0x5A
_LogDay:
	.BYTE 0x5A
_LogHour:
	.BYTE 0x5A
_LogMinute:
	.BYTE 0x5A
_LogType:
	.BYTE 0x5A
_LogData1:
	.BYTE 0xB4
_LogData2:
	.BYTE 0xB4

	.DSEG
_Address:
	.BYTE 0x6
_SOLAR_OUTPUT_TEMP:
	.BYTE 0x2

	.ESEG
_LitersPerMinute:
	.BYTE 0x2
_SolarColectorWattHours:
	.BYTE 0x4
_WattHoursPerDay:
	.BYTE 0x4
_MinimumAntifreezeTemp:
	.BYTE 0x2
_DifferenceBoilerAndSolar:
	.BYTE 0x2
_MaxDayTemperature:
	.BYTE 0x2

	.DSEG
_PAGRINDINIS_LANGAS:
	.BYTE 0x1
_Call_1Second:
	.BYTE 0x1
_CODE_IsEntering_G000:
	.BYTE 0x1
_CODE_SuccessXYZ_G000:
	.BYTE 0x3
_CODE_FailedXYZ_G000:
	.BYTE 0x3
_CODE_TimeLeft_G000:
	.BYTE 0x1
_CODE_EnteringCode_G000:
	.BYTE 0x2
_CODE_ExecutingDigit_G000:
	.BYTE 0x1
_DataToSent_G000:
	.BYTE 0xC8
_InteruptTimer_S000000F000:
	.BYTE 0x2
_MissTimer_S000000F000:
	.BYTE 0x2
_RefreshTimer_S000000F000:
	.BYTE 0x2
_MemoryTimer_S000000F000:
	.BYTE 0x1
_TERMOSWICH_S0000010001:
	.BYTE 0x1
_Called_1Second_S0000010001:
	.BYTE 0x1
_SolarColectorState_S0000010002:
	.BYTE 0x1
_CHECK_JOB_POWER_S0000010002:
	.BYTE 0x1
_SolarPower_S0000010003:
	.BYTE 0x2
_LOGS_Termoswich_S0000010001:
	.BYTE 0x1
_BUTTON_S0000010001:
	.BYTE 0x5
_ButtonFilter_S0000010001:
	.BYTE 0x5
_DUAL_BUTTON_S0000010001:
	.BYTE 0x4
_DualButtonFilter_S0000010001:
	.BYTE 0x4
_status_G101:
	.BYTE 0x1
_timer1_G101:
	.BYTE 0x1
_timer2_G101:
	.BYTE 0x1
_card_type_G101:
	.BYTE 0x1
_pv_S101000B000:
	.BYTE 0x1
_FatFs_G102:
	.BYTE 0x2
_Fsid_G102:
	.BYTE 0x2
_Drive_G102:
	.BYTE 0x1
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
