
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	.DEF _OSC=R5

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _adc_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x0:
	.DB  0x48,0x45,0x4C,0x4C,0x4F,0x0
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
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 5/24/2012
;Author  : NeVaDa
;Company : Home
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
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
;
;#define LED_SEGMENT_A PORTD.4
;#define LED_SEGMENT_B PORTD.6
;#define LED_SEGMENT_C PORTD.0
;#define LED_SEGMENT_D PORTC.2
;#define LED_SEGMENT_E PORTC.1
;#define LED_SEGMENT_F PORTB.6
;#define LED_SEGMENT_G PORTD.1
;#define LED_SEGMENT_H PORTC.3
;
;#define LED_BLOCK_0 PORTD.3
;#define LED_BLOCK_1 PORTB.7
;#define LED_BLOCK_2 PORTD.5
;#define LED_BLOCK_3 PORTD.2
;
;
;
;//////////// Mygtukai /////////////
;#define BUTTON_UP 0
;#define BUTTON_LEFT 1
;#define BUTTON_ENTER 2
;#define BUTTON_RIGHT 3
;#define BUTTON_DOWN 4
;
;#define ButtonFiltrationTimer 20 // x*cycle (cycle~1ms)
;
;unsigned char BUTTON_INPUT(unsigned char input){
; 0000 0035 unsigned char BUTTON_INPUT(unsigned char input){

	.CSEG
_BUTTON_INPUT:
; 0000 0036     if(input==0){return PINB.5;}
;	input -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x3
	LDI  R30,0
	SBIC 0x16,5
	LDI  R30,1
	RJMP _0x2020002
; 0000 0037     if(input==1){return PINC.0;}
_0x3:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x4
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	RJMP _0x2020002
; 0000 0038     if(input==2){return PINB.3;}
_0x4:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x5
	LDI  R30,0
	SBIC 0x16,3
	LDI  R30,1
	RJMP _0x2020002
; 0000 0039     if(input==3){return PINB.2;}
_0x5:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x6
	LDI  R30,0
	SBIC 0x16,2
	LDI  R30,1
	RJMP _0x2020002
; 0000 003A     if(input==4){return PINB.4;}
_0x6:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x7
	LDI  R30,0
	SBIC 0x16,4
	LDI  R30,1
	RJMP _0x2020002
; 0000 003B return 0;
_0x7:
	LDI  R30,LOW(0)
_0x2020002:
	ADIW R28,1
	RET
; 0000 003C }
;///////////////////////////////////
;
;char NumToIndex(char Num){
; 0000 003F char NumToIndex(char Num){
; 0000 0040     if(Num==0){     return '0';}
;	Num -> Y+0
; 0000 0041     else if(Num==1){return '1';}
; 0000 0042     else if(Num==2){return '2';}
; 0000 0043     else if(Num==3){return '3';}
; 0000 0044     else if(Num==4){return '4';}
; 0000 0045     else if(Num==5){return '5';}
; 0000 0046     else if(Num==6){return '6';}
; 0000 0047     else if(Num==7){return '7';}
; 0000 0048     else if(Num==8){return '8';}
; 0000 0049     else if(Num==9){return '9';}
; 0000 004A return 0;
; 0000 004B }
;
;unsigned char LcdText[4], LcdTaskas[4], OSC;
;unsigned char UpdateLedDisplay(){
; 0000 004E unsigned char UpdateLedDisplay(){
_UpdateLedDisplay:
; 0000 004F unsigned char LcdChannel;
; 0000 0050 
; 0000 0051 OSC++;
	ST   -Y,R17
;	LcdChannel -> R17
	INC  R5
; 0000 0052     if(OSC>=15){
	LDI  R30,LOW(15)
	CP   R5,R30
	BRLO _0x1B
; 0000 0053     OSC = 0;
	CLR  R5
; 0000 0054     }
; 0000 0055 
; 0000 0056     if(OSC==0){
_0x1B:
	TST  R5
	BRNE _0x1C
; 0000 0057     LcdChannel = 0;
	LDI  R17,LOW(0)
; 0000 0058     }
; 0000 0059     else if(OSC==4){
	RJMP _0x1D
_0x1C:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x1E
; 0000 005A     LcdChannel = 1;
	LDI  R17,LOW(1)
; 0000 005B     }
; 0000 005C     else if(OSC==8){
	RJMP _0x1F
_0x1E:
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x20
; 0000 005D     LcdChannel = 2;
	LDI  R17,LOW(2)
; 0000 005E     }
; 0000 005F     else if(OSC==12){
	RJMP _0x21
_0x20:
	LDI  R30,LOW(12)
	CP   R30,R5
	BRNE _0x22
; 0000 0060     LcdChannel = 3;
	LDI  R17,LOW(3)
; 0000 0061     }
; 0000 0062     else{
	RJMP _0x23
_0x22:
; 0000 0063     LcdChannel = 5;
	LDI  R17,LOW(5)
; 0000 0064     }
_0x23:
_0x21:
_0x1F:
_0x1D:
; 0000 0065 
; 0000 0066     if(LcdChannel!=5){
	CPI  R17,5
	BRNE PC+2
	RJMP _0x24
; 0000 0067     unsigned char a=0, b=0, c=0, d=0, e=0, f=0, g=0, input = LcdText[LcdChannel];
; 0000 0068 
; 0000 0069     // Segmentu valdymas
; 0000 006A         if(input=='0'){
	SBIW R28,8
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
;	a -> Y+7
;	b -> Y+6
;	c -> Y+5
;	d -> Y+4
;	e -> Y+3
;	f -> Y+2
;	g -> Y+1
;	input -> Y+0
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_LcdText)
	SBCI R31,HIGH(-_LcdText)
	LD   R30,Z
	ST   Y,R30
	LD   R26,Y
	CPI  R26,LOW(0x30)
	BRNE _0x25
; 0000 006B         a = 1;
	RCALL SUBOPT_0x1
; 0000 006C         b = 1;
; 0000 006D         c = 1;
	RCALL SUBOPT_0x2
; 0000 006E         d = 1;
; 0000 006F         e = 1;
	RCALL SUBOPT_0x3
; 0000 0070         f = 1;
	STD  Y+2,R30
; 0000 0071         }
; 0000 0072         else if(input=='1'){
	RJMP _0x26
_0x25:
	LD   R26,Y
	CPI  R26,LOW(0x31)
	BRNE _0x27
; 0000 0073         b = 1;
	RCALL SUBOPT_0x4
; 0000 0074         c = 1;
; 0000 0075         }
; 0000 0076         else if(input=='2'){
	RJMP _0x28
_0x27:
	LD   R26,Y
	CPI  R26,LOW(0x32)
	BRNE _0x29
; 0000 0077         a = 1;
	RCALL SUBOPT_0x1
; 0000 0078         b = 1;
; 0000 0079         d = 1;
	RCALL SUBOPT_0x5
; 0000 007A         e = 1;
; 0000 007B         g = 1;
	STD  Y+1,R30
; 0000 007C         }
; 0000 007D         else if(input=='3'){
	RJMP _0x2A
_0x29:
	LD   R26,Y
	CPI  R26,LOW(0x33)
	BRNE _0x2B
; 0000 007E         a = 1;
	RCALL SUBOPT_0x1
; 0000 007F         b = 1;
; 0000 0080         c = 1;
	RCALL SUBOPT_0x2
; 0000 0081         d = 1;
; 0000 0082         g = 1;
	STD  Y+1,R30
; 0000 0083         }
; 0000 0084         else if(input=='4'){
	RJMP _0x2C
_0x2B:
	LD   R26,Y
	CPI  R26,LOW(0x34)
	BRNE _0x2D
; 0000 0085         b = 1;
	RCALL SUBOPT_0x4
; 0000 0086         c = 1;
; 0000 0087         f = 1;
	RCALL SUBOPT_0x6
; 0000 0088         g = 1;
; 0000 0089         }
; 0000 008A         else if(input=='5'){
	RJMP _0x2E
_0x2D:
	LD   R26,Y
	CPI  R26,LOW(0x35)
	BRNE _0x2F
; 0000 008B         a = 1;
	RCALL SUBOPT_0x7
; 0000 008C         c = 1;
; 0000 008D         d = 1;
; 0000 008E         f = 1;
	RCALL SUBOPT_0x8
; 0000 008F         g = 1;
; 0000 0090         }
; 0000 0091         else if(input=='6'){
	RJMP _0x30
_0x2F:
	LD   R26,Y
	CPI  R26,LOW(0x36)
	BRNE _0x31
; 0000 0092         a = 1;
	RCALL SUBOPT_0x7
; 0000 0093         c = 1;
; 0000 0094         d = 1;
; 0000 0095         e = 1;
	RCALL SUBOPT_0x3
; 0000 0096         f = 1;
	RCALL SUBOPT_0x8
; 0000 0097         g = 1;
; 0000 0098         }
; 0000 0099         else if(input=='7'){
	RJMP _0x32
_0x31:
	LD   R26,Y
	CPI  R26,LOW(0x37)
	BRNE _0x33
; 0000 009A         a = 1;
	RCALL SUBOPT_0x1
; 0000 009B         b = 1;
; 0000 009C         c = 1;
	STD  Y+5,R30
; 0000 009D         }
; 0000 009E         else if(input=='8'){
	RJMP _0x34
_0x33:
	LD   R26,Y
	CPI  R26,LOW(0x38)
	BRNE _0x35
; 0000 009F         a = 1;
	RCALL SUBOPT_0x1
; 0000 00A0         b = 1;
; 0000 00A1         c = 1;
	RCALL SUBOPT_0x2
; 0000 00A2         d = 1;
; 0000 00A3         e = 1;
	RCALL SUBOPT_0x3
; 0000 00A4         f = 1;
	RCALL SUBOPT_0x8
; 0000 00A5         g = 1;
; 0000 00A6         }
; 0000 00A7         else if(input=='9'){
	RJMP _0x36
_0x35:
	LD   R26,Y
	CPI  R26,LOW(0x39)
	BRNE _0x37
; 0000 00A8         a = 1;
	RCALL SUBOPT_0x1
; 0000 00A9         b = 1;
; 0000 00AA         c = 1;
	RCALL SUBOPT_0x2
; 0000 00AB         d = 1;
; 0000 00AC         f = 1;
	RCALL SUBOPT_0x8
; 0000 00AD         g = 1;
; 0000 00AE         }
; 0000 00AF         else if(input=='A'){
	RJMP _0x38
_0x37:
	LD   R26,Y
	CPI  R26,LOW(0x41)
	BRNE _0x39
; 0000 00B0         a = 1;
	RCALL SUBOPT_0x1
; 0000 00B1         b = 1;
; 0000 00B2         c = 1;
	RCALL SUBOPT_0x9
; 0000 00B3         e = 1;
; 0000 00B4         f = 1;
	RCALL SUBOPT_0x8
; 0000 00B5         g = 1;
; 0000 00B6         }
; 0000 00B7         else if(input=='b'){
	RJMP _0x3A
_0x39:
	LD   R26,Y
	CPI  R26,LOW(0x62)
	BRNE _0x3B
; 0000 00B8         c = 1;
	RCALL SUBOPT_0xA
; 0000 00B9         d = 1;
; 0000 00BA         e = 1;
	RCALL SUBOPT_0x3
; 0000 00BB         f = 1;
	RCALL SUBOPT_0x8
; 0000 00BC         g = 1;
; 0000 00BD         }
; 0000 00BE         else if(input=='c'){
	RJMP _0x3C
_0x3B:
	LD   R26,Y
	CPI  R26,LOW(0x63)
	BRNE _0x3D
; 0000 00BF         d = 1;
	RCALL SUBOPT_0xB
; 0000 00C0         e = 1;
; 0000 00C1         g = 1;
	STD  Y+1,R30
; 0000 00C2         }
; 0000 00C3         else if(input=='C'){
	RJMP _0x3E
_0x3D:
	LD   R26,Y
	CPI  R26,LOW(0x43)
	BRNE _0x3F
; 0000 00C4         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 00C5         d = 1;
	RCALL SUBOPT_0xB
; 0000 00C6         e = 1;
; 0000 00C7         f = 1;
	RCALL SUBOPT_0x8
; 0000 00C8         g = 1;
; 0000 00C9         }
; 0000 00CA         else if(input=='d'){
	RJMP _0x40
_0x3F:
	LD   R26,Y
	CPI  R26,LOW(0x64)
	BRNE _0x41
; 0000 00CB         b = 1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0000 00CC         c = 1;
	RCALL SUBOPT_0xA
; 0000 00CD         d = 1;
; 0000 00CE         e = 1;
	RCALL SUBOPT_0x3
; 0000 00CF         g = 1;
	STD  Y+1,R30
; 0000 00D0         }
; 0000 00D1         else if(input=='E'){
	RJMP _0x42
_0x41:
	LD   R26,Y
	CPI  R26,LOW(0x45)
	BRNE _0x43
; 0000 00D2         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 00D3         d = 1;
	RCALL SUBOPT_0xB
; 0000 00D4         e = 1;
; 0000 00D5         f = 1;
	RCALL SUBOPT_0x8
; 0000 00D6         g = 1;
; 0000 00D7         }
; 0000 00D8         else if(input=='F'){
	RJMP _0x44
_0x43:
	LD   R26,Y
	CPI  R26,LOW(0x46)
	BRNE _0x45
; 0000 00D9         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 00DA         e = 1;
	RCALL SUBOPT_0x3
; 0000 00DB         f = 1;
	RCALL SUBOPT_0x8
; 0000 00DC         g = 1;
; 0000 00DD         }
; 0000 00DE         else if(input=='G'){
	RJMP _0x46
_0x45:
	LD   R26,Y
	CPI  R26,LOW(0x47)
	BRNE _0x47
; 0000 00DF         a = 1;
	RCALL SUBOPT_0x7
; 0000 00E0         c = 1;
; 0000 00E1         d = 1;
; 0000 00E2         e = 1;
	RCALL SUBOPT_0x3
; 0000 00E3         f = 1;
	STD  Y+2,R30
; 0000 00E4         }
; 0000 00E5         else if(input=='h'){
	RJMP _0x48
_0x47:
	LD   R26,Y
	CPI  R26,LOW(0x68)
	BRNE _0x49
; 0000 00E6         c = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x9
; 0000 00E7         e = 1;
; 0000 00E8         f = 1;
	RCALL SUBOPT_0x8
; 0000 00E9         g = 1;
; 0000 00EA         }
; 0000 00EB         else if(input=='H'){
	RJMP _0x4A
_0x49:
	LD   R26,Y
	CPI  R26,LOW(0x48)
	BRNE _0x4B
; 0000 00EC         b = 1;
	RCALL SUBOPT_0x4
; 0000 00ED         c = 1;
; 0000 00EE         e = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3
; 0000 00EF         f = 1;
	RCALL SUBOPT_0x8
; 0000 00F0         g = 1;
; 0000 00F1         }
; 0000 00F2         else if(input=='i'){
	RJMP _0x4C
_0x4B:
	LD   R26,Y
	CPI  R26,LOW(0x69)
	BRNE _0x4D
; 0000 00F3         c = 1;
	LDI  R30,LOW(1)
	STD  Y+5,R30
; 0000 00F4         }
; 0000 00F5         else if(input=='I'){
	RJMP _0x4E
_0x4D:
	LD   R26,Y
	CPI  R26,LOW(0x49)
	BRNE _0x4F
; 0000 00F6         b = 1;
	RCALL SUBOPT_0x4
; 0000 00F7         c = 1;
; 0000 00F8         }
; 0000 00F9         else if(input=='J'){
	RJMP _0x50
_0x4F:
	LD   R26,Y
	CPI  R26,LOW(0x4A)
	BRNE _0x51
; 0000 00FA         b = 1;
	RCALL SUBOPT_0x4
; 0000 00FB         c = 1;
; 0000 00FC         d = 1;
	RJMP _0xC8
; 0000 00FD         }
; 0000 00FE         else if(input=='L'){
_0x51:
	LD   R26,Y
	CPI  R26,LOW(0x4C)
	BRNE _0x53
; 0000 00FF         d = 1;
	RCALL SUBOPT_0xB
; 0000 0100         e = 1;
; 0000 0101         f = 1;
	STD  Y+2,R30
; 0000 0102         }
; 0000 0103         else if(input=='n'){
	RJMP _0x54
_0x53:
	LD   R26,Y
	CPI  R26,LOW(0x6E)
	BRNE _0x55
; 0000 0104         c = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x9
; 0000 0105         e = 1;
; 0000 0106         g = 1;
	STD  Y+1,R30
; 0000 0107         }
; 0000 0108         else if(input=='o'){
	RJMP _0x56
_0x55:
	LD   R26,Y
	CPI  R26,LOW(0x6F)
	BRNE _0x57
; 0000 0109         c = 1;
	RCALL SUBOPT_0xA
; 0000 010A         d = 1;
; 0000 010B         e = 1;
	RCALL SUBOPT_0x3
; 0000 010C         g = 1;
	STD  Y+1,R30
; 0000 010D         }
; 0000 010E         else if(input=='O'){
	RJMP _0x58
_0x57:
	LD   R26,Y
	CPI  R26,LOW(0x4F)
	BRNE _0x59
; 0000 010F         a = 1;
	RCALL SUBOPT_0x1
; 0000 0110         b = 1;
; 0000 0111         c = 1;
	RCALL SUBOPT_0x2
; 0000 0112         d = 1;
; 0000 0113         e = 1;
	RCALL SUBOPT_0x3
; 0000 0114         f = 1;
	STD  Y+2,R30
; 0000 0115         }
; 0000 0116         else if(input=='P'){
	RJMP _0x5A
_0x59:
	LD   R26,Y
	CPI  R26,LOW(0x50)
	BRNE _0x5B
; 0000 0117         a = 1;
	RCALL SUBOPT_0x1
; 0000 0118         b = 1;
; 0000 0119         e = 1;
	RCALL SUBOPT_0x3
; 0000 011A         f = 1;
	RCALL SUBOPT_0x8
; 0000 011B         g = 1;
; 0000 011C         }
; 0000 011D         else if(input=='r'){
	RJMP _0x5C
_0x5B:
	LD   R26,Y
	CPI  R26,LOW(0x72)
	BRNE _0x5D
; 0000 011E         e = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3
; 0000 011F         g = 1;
	STD  Y+1,R30
; 0000 0120         }
; 0000 0121         else if(input=='S'){
	RJMP _0x5E
_0x5D:
	LD   R26,Y
	CPI  R26,LOW(0x53)
	BRNE _0x5F
; 0000 0122         a = 1;
	RCALL SUBOPT_0x7
; 0000 0123         c = 1;
; 0000 0124         d = 1;
; 0000 0125         f = 1;
	RCALL SUBOPT_0x8
; 0000 0126         g = 1;
; 0000 0127         }
; 0000 0128         else if(input=='t'){
	RJMP _0x60
_0x5F:
	LD   R26,Y
	CPI  R26,LOW(0x74)
	BRNE _0x61
; 0000 0129         d = 1;
	RCALL SUBOPT_0xB
; 0000 012A         e = 1;
; 0000 012B         f = 1;
	RCALL SUBOPT_0x8
; 0000 012C         g = 1;
; 0000 012D         }
; 0000 012E         else if(input=='u'){
	RJMP _0x62
_0x61:
	LD   R26,Y
	CPI  R26,LOW(0x75)
	BRNE _0x63
; 0000 012F         c = 1;
	RCALL SUBOPT_0xA
; 0000 0130         d = 1;
; 0000 0131         e = 1;
	STD  Y+3,R30
; 0000 0132         }
; 0000 0133         else if(input=='U'){
	RJMP _0x64
_0x63:
	LD   R26,Y
	CPI  R26,LOW(0x55)
	BRNE _0x65
; 0000 0134         b = 1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0000 0135         c = 1;
	RCALL SUBOPT_0xA
; 0000 0136         d = 1;
; 0000 0137         e = 1;
	RCALL SUBOPT_0x3
; 0000 0138         f = 1;
	STD  Y+2,R30
; 0000 0139         }
; 0000 013A         else if(input=='Y'){
	RJMP _0x66
_0x65:
	LD   R26,Y
	CPI  R26,LOW(0x59)
	BRNE _0x67
; 0000 013B         b = 1;
	RCALL SUBOPT_0x4
; 0000 013C         c = 1;
; 0000 013D         f = 1;
	RCALL SUBOPT_0x6
; 0000 013E         g = 1;
; 0000 013F         }
; 0000 0140         else if(input=='='){
	RJMP _0x68
_0x67:
	LD   R26,Y
	CPI  R26,LOW(0x3D)
	BRNE _0x69
; 0000 0141         d = 1;
	LDI  R30,LOW(1)
	STD  Y+4,R30
; 0000 0142         g = 1;
	STD  Y+1,R30
; 0000 0143         }
; 0000 0144         else if(input=='_'){
	RJMP _0x6A
_0x69:
	LD   R26,Y
	CPI  R26,LOW(0x5F)
	BRNE _0x6B
; 0000 0145         d = 1;
_0xC8:
	LDI  R30,LOW(1)
	STD  Y+4,R30
; 0000 0146         }
; 0000 0147 
; 0000 0148         if(a==1){                    LED_SEGMENT_A = 0;}
_0x6B:
_0x6A:
_0x68:
_0x66:
_0x64:
_0x62:
_0x60:
_0x5E:
_0x5C:
_0x5A:
_0x58:
_0x56:
_0x54:
_0x50:
_0x4E:
_0x4C:
_0x4A:
_0x48:
_0x46:
_0x44:
_0x42:
_0x40:
_0x3E:
_0x3C:
_0x3A:
_0x38:
_0x36:
_0x34:
_0x32:
_0x30:
_0x2E:
_0x2C:
_0x2A:
_0x28:
_0x26:
	LDD  R26,Y+7
	CPI  R26,LOW(0x1)
	BRNE _0x6C
	CBI  0x12,4
; 0000 0149         if(b==1){                    LED_SEGMENT_B = 0;}
_0x6C:
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x6F
	CBI  0x12,6
; 0000 014A         if(c==1){                    LED_SEGMENT_C = 0;}
_0x6F:
	LDD  R26,Y+5
	CPI  R26,LOW(0x1)
	BRNE _0x72
	CBI  0x12,0
; 0000 014B         if(d==1){                    LED_SEGMENT_D = 0;}
_0x72:
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x75
	CBI  0x15,2
; 0000 014C         if(e==1){                    LED_SEGMENT_E = 0;}
_0x75:
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x78
	CBI  0x15,1
; 0000 014D         if(f==1){                    LED_SEGMENT_F = 0;}
_0x78:
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0x7B
	CBI  0x18,6
; 0000 014E         if(g==1){                    LED_SEGMENT_G = 0;}
_0x7B:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x7E
	CBI  0x12,1
; 0000 014F         if(LcdTaskas[LcdChannel]==1){LED_SEGMENT_H = 0;}
_0x7E:
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_LcdTaskas)
	SBCI R31,HIGH(-_LcdTaskas)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x81
	CBI  0x15,3
; 0000 0150 
; 0000 0151     // Bloko valdymas
; 0000 0152         if(LcdChannel==0){     LED_BLOCK_0 = 1;}
_0x81:
	CPI  R17,0
	BRNE _0x84
	SBI  0x12,3
; 0000 0153         else if(LcdChannel==1){LED_BLOCK_1 = 1;}
	RJMP _0x87
_0x84:
	CPI  R17,1
	BRNE _0x88
	SBI  0x18,7
; 0000 0154         else if(LcdChannel==2){LED_BLOCK_2 = 1;}
	RJMP _0x8B
_0x88:
	CPI  R17,2
	BRNE _0x8C
	SBI  0x12,5
; 0000 0155         else if(LcdChannel==3){LED_BLOCK_3 = 1;}
	RJMP _0x8F
_0x8C:
	CPI  R17,3
	BRNE _0x90
	SBI  0x12,2
; 0000 0156     }
_0x90:
_0x8F:
_0x8B:
_0x87:
	ADIW R28,8
; 0000 0157     else{
	RJMP _0x93
_0x24:
; 0000 0158     LED_SEGMENT_A = 1;
	SBI  0x12,4
; 0000 0159     LED_SEGMENT_B = 1;
	SBI  0x12,6
; 0000 015A     LED_SEGMENT_C = 1;
	SBI  0x12,0
; 0000 015B     LED_SEGMENT_D = 1;
	SBI  0x15,2
; 0000 015C     LED_SEGMENT_E = 1;
	SBI  0x15,1
; 0000 015D     LED_SEGMENT_F = 1;
	SBI  0x18,6
; 0000 015E     LED_SEGMENT_G = 1;
	SBI  0x12,1
; 0000 015F     LED_SEGMENT_H = 1;
	SBI  0x15,3
; 0000 0160 
; 0000 0161     LED_BLOCK_0 = 0;
	CBI  0x12,3
; 0000 0162     LED_BLOCK_1 = 0;
	CBI  0x18,7
; 0000 0163     LED_BLOCK_2 = 0;
	CBI  0x12,5
; 0000 0164     LED_BLOCK_3 = 0;
	CBI  0x12,2
; 0000 0165     }
_0x93:
; 0000 0166 return 1;
	LDI  R30,LOW(1)
	LD   R17,Y+
	RET
; 0000 0167 }
;
;unsigned char led_display_clear(){
; 0000 0169 unsigned char led_display_clear(){
; 0000 016A unsigned char i;
; 0000 016B     for(i=0;i<4;i++){LcdText[i] = 0;LcdTaskas[i] = 0;}
;	i -> R17
; 0000 016C UpdateLedDisplay();
; 0000 016D return 1;
; 0000 016E }
;
;unsigned char led_put_runing_text(unsigned int Position,unsigned char flash *str){
; 0000 0170 unsigned char led_put_runing_text(unsigned int Position,unsigned char flash *str){
_led_put_runing_text:
; 0000 0171 unsigned int StrLenght = strlenf(str);
; 0000 0172 signed int i,a;
; 0000 0173     for(i=0;i<4;i++){
	RCALL __SAVELOCR6
;	Position -> Y+8
;	*str -> Y+6
;	StrLenght -> R16,R17
;	i -> R18,R19
;	a -> R20,R21
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0xC
	RCALL _strlenf
	MOVW R16,R30
	__GETWRN 18,19,0
_0xB0:
	__CPWRN 18,19,4
	BRGE _0xB1
; 0000 0174     a = i + Position - 4;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADD  R30,R18
	ADC  R31,R19
	SBIW R30,4
	MOVW R20,R30
; 0000 0175         if(a>=0){
	TST  R21
	BRMI _0xB2
; 0000 0176             if(a<StrLenght){
	__CPWRR 20,21,16,17
	BRSH _0xB3
; 0000 0177             LcdText[i] = str[a];
	MOVW R30,R18
	SUBI R30,LOW(-_LcdText)
	SBCI R31,HIGH(-_LcdText)
	MOVW R0,R30
	MOVW R30,R20
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R0
	ST   X,R30
; 0000 0178             }
; 0000 0179             else{
	RJMP _0xB4
_0xB3:
; 0000 017A                 if(i==0){
	MOV  R0,R18
	OR   R0,R19
	BRNE _0xB5
; 0000 017B                 return 1;
	LDI  R30,LOW(1)
	RJMP _0x2020001
; 0000 017C                 }
; 0000 017D             }
_0xB5:
_0xB4:
; 0000 017E         }
; 0000 017F     }
_0xB2:
	__ADDWRN 18,19,1
	RJMP _0xB0
_0xB1:
; 0000 0180 return 0;
	LDI  R30,LOW(0)
_0x2020001:
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
; 0000 0181 }
;
;#define FIRST_ADC_INPUT 4
;#define LAST_ADC_INPUT 5
;unsigned char adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
;#define ADC_VREF_TYPE 0x20
;interrupt [ADC_INT] void adc_isr(void){
; 0000 0187 interrupt [15] void adc_isr(void){
_adc_isr:
	ST   -Y,R24
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0188 static unsigned char input_index=0;
; 0000 0189 adc_data[input_index]=ADCH;
	LDS  R26,_input_index_S0000005000
	LDI  R27,0
	SUBI R26,LOW(-_adc_data)
	SBCI R27,HIGH(-_adc_data)
	IN   R30,0x5
	ST   X,R30
; 0000 018A if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
	LDS  R26,_input_index_S0000005000
	SUBI R26,-LOW(1)
	STS  _input_index_S0000005000,R26
	CPI  R26,LOW(0x2)
	BRLO _0xB6
; 0000 018B    input_index=0;
	LDI  R30,LOW(0)
	STS  _input_index_S0000005000,R30
; 0000 018C ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;
_0xB6:
	LDS  R30,_input_index_S0000005000
	SUBI R30,-LOW(36)
	OUT  0x7,R30
; 0000 018D delay_us(10);
	__DELAY_USB 27
; 0000 018E ADCSRA|=0x40;
	SBI  0x6,6
; 0000 018F }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R24,Y+
	RETI
;
;#define VOLTAGE_CONFIGURATION_A 0
;#define VOLTAGE_CONFIGURATION_B 0
;#define VOLTAGE_CONFIGURATION_C 0
;
;
;unsigned int GetVoltage(unsigned char voltage_data){
; 0000 0196 unsigned int GetVoltage(unsigned char voltage_data){
; 0000 0197 return ((voltage_data*VOLTAGE_CONFIGURATION_A)/VOLTAGE_CONFIGURATION_B)+VOLTAGE_CONFIGURATION_C;
;	voltage_data -> Y+0
; 0000 0198 }
;
;unsigned int GetCurrent(unsigned char voltage_data,unsigned int resistance){
; 0000 019A unsigned int GetCurrent(unsigned char voltage_data,unsigned int resistance){
; 0000 019B return (((voltage_data*VOLTAGE_CONFIGURATION_A)/VOLTAGE_CONFIGURATION_B)+VOLTAGE_CONFIGURATION_C)*resistance;
;	voltage_data -> Y+2
;	resistance -> Y+0
; 0000 019C }
;
;unsigned int GetPower(unsigned int voltage, unsigned int current, unsigned int resistance){
; 0000 019E unsigned int GetPower(unsigned int voltage, unsigned int current, unsigned int resistance){
; 0000 019F 
; 0000 01A0 }
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 01A6 {
_main:
; 0000 01A7 // Declare your local variables here
; 0000 01A8 
; 0000 01A9 // Input/Output Ports initialization
; 0000 01AA // Port B initialization
; 0000 01AB // Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
; 0000 01AC // State7=0 State6=0 State5=T State4=T State3=T State2=T State1=0 State0=T
; 0000 01AD PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01AE DDRB=0xC2;
	LDI  R30,LOW(194)
	OUT  0x17,R30
; 0000 01AF 
; 0000 01B0 // Port C initialization
; 0000 01B1 // Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=In
; 0000 01B2 // State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=T
; 0000 01B3 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01B4 DDRC=0x0E;
	LDI  R30,LOW(14)
	OUT  0x14,R30
; 0000 01B5 
; 0000 01B6 // Port D initialization
; 0000 01B7 // Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 01B8 // State7=T State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 01B9 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01BA DDRD=0x7F;
	LDI  R30,LOW(127)
	OUT  0x11,R30
; 0000 01BB 
; 0000 01BC // Timer/Counter 0 initialization
; 0000 01BD // Clock source: System Clock
; 0000 01BE // Clock value: Timer 0 Stopped
; 0000 01BF TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 01C0 TCNT0=0x00;
	OUT  0x32,R30
; 0000 01C1 
; 0000 01C2 // Timer/Counter 1 initialization
; 0000 01C3 // Clock source: System Clock
; 0000 01C4 // Clock value: 8000.000 kHz
; 0000 01C5 // Mode: Fast PWM top=OCR1A
; 0000 01C6 // OC1A output: Toggle
; 0000 01C7 // OC1B output: Discon.
; 0000 01C8 // Noise Canceler: Off
; 0000 01C9 // Input Capture on Falling Edge
; 0000 01CA // Timer1 Overflow Interrupt: Off
; 0000 01CB // Input Capture Interrupt: Off
; 0000 01CC // Compare A Match Interrupt: Off
; 0000 01CD // Compare B Match Interrupt: Off
; 0000 01CE TCCR1A=0x43;
	LDI  R30,LOW(67)
	OUT  0x2F,R30
; 0000 01CF TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 01D0 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 01D1 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01D2 ICR1H=0x00;
	OUT  0x27,R30
; 0000 01D3 ICR1L=0x00;
	OUT  0x26,R30
; 0000 01D4 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01D5 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01D6 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01D7 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01D8 
; 0000 01D9 // Timer/Counter 2 initialization
; 0000 01DA // Clock source: System Clock
; 0000 01DB // Clock value: Timer2 Stopped
; 0000 01DC // Mode: Normal top=FFh
; 0000 01DD // OC2 output: Disconnected
; 0000 01DE ASSR=0x00;
	OUT  0x22,R30
; 0000 01DF TCCR2=0x00;
	OUT  0x25,R30
; 0000 01E0 TCNT2=0x00;
	OUT  0x24,R30
; 0000 01E1 OCR2=0x00;
	OUT  0x23,R30
; 0000 01E2 
; 0000 01E3 // External Interrupt(s) initialization
; 0000 01E4 // INT0: Off
; 0000 01E5 // INT1: Off
; 0000 01E6 MCUCR=0x00;
	OUT  0x35,R30
; 0000 01E7 
; 0000 01E8 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01E9 TIMSK=0x00;
	OUT  0x39,R30
; 0000 01EA 
; 0000 01EB // Analog Comparator initialization
; 0000 01EC // Analog Comparator: Off
; 0000 01ED // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01EE ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01EF SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01F0 
; 0000 01F1 // ADC initialization
; 0000 01F2 // ADC Clock frequency: 62.500 kHz
; 0000 01F3 // ADC Voltage Reference: AREF pin
; 0000 01F4 // Only the 8 most significant bits of
; 0000 01F5 // the AD conversion result are used
; 0000 01F6 ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
	LDI  R30,LOW(36)
	OUT  0x7,R30
; 0000 01F7 ADCSRA=0xCF;
	LDI  R30,LOW(207)
	OUT  0x6,R30
; 0000 01F8 
; 0000 01F9 // Watchdog Timer initialization
; 0000 01FA // Watchdog Timer Prescaler: OSC/128k
; 0000 01FB #pragma optsize-
; 0000 01FC WDTCR=0x1B;
	LDI  R30,LOW(27)
	OUT  0x21,R30
; 0000 01FD WDTCR=0x0B;
	LDI  R30,LOW(11)
	OUT  0x21,R30
; 0000 01FE #ifdef _OPTIMIZE_SIZE_
; 0000 01FF #pragma optsize+
; 0000 0200 #endif
; 0000 0201 
; 0000 0202 // Global enable interrupts
; 0000 0203 #asm("sei")
	sei
; 0000 0204 
; 0000 0205 
; 0000 0206 
; 0000 0207 // Ijungiant prabega uzrasas "HELLO"
; 0000 0208     if(1){
; 0000 0209     unsigned int Timer1 = 0;
; 0000 020A         while(Timer1<2000){
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
;	Timer1 -> Y+0
_0xB8:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x7D0)
	LDI  R30,HIGH(0x7D0)
	CPC  R27,R30
	BRSH _0xBA
; 0000 020B         unsigned char HelloPadetis = Timer1/200;
; 0000 020C         Timer1++;
	SBIW R28,1
;	Timer1 -> Y+1
;	HelloPadetis -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL __DIVW21U
	ST   Y,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 020D         led_put_runing_text(HelloPadetis,"HELLO");
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xC
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0xC
	RCALL _led_put_runing_text
; 0000 020E         UpdateLedDisplay();
	RCALL SUBOPT_0xE
; 0000 020F         delay_ms(1);
; 0000 0210         }
	ADIW R28,1
	RJMP _0xB8
_0xBA:
; 0000 0211     }
	ADIW R28,2
; 0000 0212 
; 0000 0213 
; 0000 0214 
; 0000 0215     while(1){
_0xBB:
; 0000 0216     //////////////////////////////////////////////////////////////////////////////////
; 0000 0217     /////////////////////////////////////// Mygtukai /////////////////////////////////
; 0000 0218     //////////////////////////////////////////////////////////////////////////////////
; 0000 0219     static unsigned char BUTTON[5], ButtonFilter[5];
; 0000 021A         if(1){
; 0000 021B         unsigned char i;
; 0000 021C             for(i=0;i<5;i++){
	SBIW R28,1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0xC0:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRSH _0xC1
; 0000 021D                 if(BUTTON_INPUT(i)==1){
	LD   R30,Y
	ST   -Y,R30
	RCALL _BUTTON_INPUT
	CPI  R30,LOW(0x1)
	BRNE _0xC2
; 0000 021E                     if(ButtonFilter[i]<ButtonFiltrationTimer){
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	BRSH _0xC3
; 0000 021F                     ButtonFilter[i]++;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_ButtonFilter_S0000009001)
	SBCI R27,HIGH(-_ButtonFilter_S0000009001)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 0220                     }
; 0000 0221                 }
_0xC3:
; 0000 0222                 else{
	RJMP _0xC4
_0xC2:
; 0000 0223                     if(ButtonFilter[i]>=ButtonFiltrationTimer){
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	BRLO _0xC5
; 0000 0224                     BUTTON[i] = 1;
	RCALL SUBOPT_0xD
	SUBI R30,LOW(-_BUTTON_S0000009001)
	SBCI R31,HIGH(-_BUTTON_S0000009001)
	LDI  R26,LOW(1)
	RJMP _0xC9
; 0000 0225                     }
; 0000 0226                     else{
_0xC5:
; 0000 0227                     BUTTON[i] = 0;
	RCALL SUBOPT_0xD
	SUBI R30,LOW(-_BUTTON_S0000009001)
	SBCI R31,HIGH(-_BUTTON_S0000009001)
	LDI  R26,LOW(0)
_0xC9:
	STD  Z+0,R26
; 0000 0228                     }
; 0000 0229                 ButtonFilter[i] = 0;
	RCALL SUBOPT_0xD
	SUBI R30,LOW(-_ButtonFilter_S0000009001)
	SBCI R31,HIGH(-_ButtonFilter_S0000009001)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 022A                 }
_0xC4:
; 0000 022B             }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xC0
_0xC1:
; 0000 022C         }
	ADIW R28,1
; 0000 022D     //////////////////////////////////////////////////////////////////////////////////
; 0000 022E     //////////////////////////////////////////////////////////////////////////////////
; 0000 022F     //////////////////////////////////////////////////////////////////////////////////
; 0000 0230 
; 0000 0231 
; 0000 0232 
; 0000 0233 
; 0000 0234 
; 0000 0235     //////////////////////////////////////////////////////////////////////////////////
; 0000 0236     ////////////////////////////////////// Displejus /////////////////////////////////
; 0000 0237     //////////////////////////////////////////////////////////////////////////////////
; 0000 0238 
; 0000 0239 
; 0000 023A     //////////////////////////////////////////////////////////////////////////////////
; 0000 023B     //////////////////////////////////////////////////////////////////////////////////
; 0000 023C     //////////////////////////////////////////////////////////////////////////////////
; 0000 023D     UpdateLedDisplay();
	RCALL SUBOPT_0xE
; 0000 023E     delay_ms(1);
; 0000 023F     }
	RJMP _0xBB
; 0000 0240 }
_0xC7:
	RJMP _0xC7

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

	.DSEG
_LcdText:
	.BYTE 0x4
_LcdTaskas:
	.BYTE 0x4
_adc_data:
	.BYTE 0x2
_input_index_S0000005000:
	.BYTE 0x1
_BUTTON_S0000009001:
	.BYTE 0x5
_ButtonFilter_S0000009001:
	.BYTE 0x5

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	STD  Y+7,R30
	STD  Y+6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x2:
	STD  Y+5,R30
	LDI  R30,LOW(1)
	STD  Y+4,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x3:
	STD  Y+3,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	STD  Y+6,R30
	STD  Y+5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5:
	STD  Y+4,R30
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	STD  Y+2,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	STD  Y+7,R30
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x8:
	STD  Y+2,R30
	LDI  R30,LOW(1)
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	STD  Y+5,R30
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	RCALL _UpdateLedDisplay
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0xC
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	SUBI R30,LOW(-_ButtonFilter_S0000009001)
	SBCI R31,HIGH(-_ButtonFilter_S0000009001)
	LD   R26,Z
	CPI  R26,LOW(0x14)
	RET


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
