
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8,000000 MHz
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
	.DEF _Count0=R4
	.DEF _Count1=R6
	.DEF _Count2=R8
	.DEF _Count3=R11
	.DEF _PHASE=R10
	.DEF _ONE_SECOND=R13
	.DEF _STATED_FREQUENCY=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
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
;Project :
;Version :
;Date    : 2014.10.10
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
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
;
;//#define PORTC.0 PHASE_UP1
;//#define PORTC.0 PHASE_UP2
;//#define PORTC.0 PHASE_UP3
;//#define PORTC.0 PHASE_DOWN1
;//#define PORTC.0 PHASE_DOWN2
;//#define PORTC.0 PHASE_DOWN3
;
;
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x12 ;PORTD
; 0000 0021 #endasm
;#include <lcd.h>
;
;
;char NumToIndex(char Num){
; 0000 0025 char NumToIndex(char Num){

	.CSEG
; 0000 0026     if(Num==0){     return '0';}
;	Num -> Y+0
; 0000 0027     else if(Num==1){return '1';}
; 0000 0028     else if(Num==2){return '2';}
; 0000 0029     else if(Num==3){return '3';}
; 0000 002A     else if(Num==4){return '4';}
; 0000 002B     else if(Num==5){return '5';}
; 0000 002C     else if(Num==6){return '6';}
; 0000 002D     else if(Num==7){return '7';}
; 0000 002E     else if(Num==8){return '8';}
; 0000 002F     else if(Num==9){return '9';}
; 0000 0030     else{           return '-';}
; 0000 0031 return 0;
; 0000 0032 }
;
;char lcd_put_number(char Type, char Lenght, char IsSign,
; 0000 0035 
; 0000 0036                     char NumbersAfterDot,
; 0000 0037 
; 0000 0038                     unsigned long int Number0,
; 0000 0039                     signed long int Number1){
; 0000 003A     if(Lenght>0){
;	Type -> Y+11
;	Lenght -> Y+10
;	IsSign -> Y+9
;	NumbersAfterDot -> Y+8
;	Number0 -> Y+4
;	Number1 -> Y+0
; 0000 003B     unsigned long int k = 1;
; 0000 003C     unsigned char i;
; 0000 003D         for(i=0;i<Lenght-1;i++) k = k*10;
;	Type -> Y+16
;	Lenght -> Y+15
;	IsSign -> Y+14
;	NumbersAfterDot -> Y+13
;	Number0 -> Y+9
;	Number1 -> Y+5
;	k -> Y+1
;	i -> Y+0
; 0000 003F if(Type==0){
; 0000 0040         unsigned long int a;
; 0000 0041         unsigned char b;
; 0000 0042         a = Number0;
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
; 0000 0043 
; 0000 0044             if(IsSign==1){
; 0000 0045             lcd_putchar('+');
; 0000 0046             }
; 0000 0047 
; 0000 0048             if(a<0){
; 0000 0049             a = a*(-1);
; 0000 004A             }
; 0000 004B 
; 0000 004C             if(k*10<a){
; 0000 004D             a = k*10 - 1;
; 0000 004E             }
; 0000 004F 
; 0000 0050             for(i=0;i<Lenght;i++){
; 0000 0051                 if(NumbersAfterDot!=0){
; 0000 0052                     if(Lenght-NumbersAfterDot==i){
; 0000 0053                     lcd_putchar('.');
; 0000 0054                     }
; 0000 0055                 }
; 0000 0056             b = a/k;
; 0000 0057             lcd_putchar( NumToIndex( b ) );
; 0000 0058             a = a - b*k;
; 0000 0059             k = k/10;
; 0000 005A             }
; 0000 005B         return 1;
; 0000 005C         }
; 0000 005D 
; 0000 005E         else if(Type==1){
; 0000 005F         signed long int a;
; 0000 0060         unsigned char b;
; 0000 0061         a = Number1;
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
; 0000 0062 
; 0000 0063             if(IsSign==1){
; 0000 0064                 if(a>=0){
; 0000 0065                 lcd_putchar('+');
; 0000 0066                 }
; 0000 0067                 else{
; 0000 0068                 lcd_putchar('-');
; 0000 0069                 }
; 0000 006A             }
; 0000 006B 
; 0000 006C             if(a<0){
; 0000 006D             a = a*(-1);
; 0000 006E             }
; 0000 006F 
; 0000 0070             if(k*10<a){
; 0000 0071             a = k*10 - 1;
; 0000 0072             }
; 0000 0073 
; 0000 0074             for(i=0;i<Lenght;i++){
; 0000 0075                 if(NumbersAfterDot!=0){
; 0000 0076                     if(Lenght-NumbersAfterDot==i){
; 0000 0077                     lcd_putchar('.');
; 0000 0078                     }
; 0000 0079                 }
; 0000 007A             b = a/k;
; 0000 007B             lcd_putchar( NumToIndex( b ) );
; 0000 007C             a = a - b*k;
; 0000 007D             k = k/10;
; 0000 007E             }
; 0000 007F         return 1;
; 0000 0080         }
; 0000 0081     }
; 0000 0082 return 0;
; 0000 0083 }
;
;
;unsigned int Count0, Count1, Count2;
;unsigned char Count3;
;unsigned char PHASE;
;unsigned char ONE_SECOND;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 008D interrupt [10] void timer0_ovf_isr(void){
_timer0_ovf_isr:
; 0000 008E //Count0++;
; 0000 008F }
	RETI
;
;
;
;
;
;unsigned char STATED_FREQUENCY, CYCLE_PHASE;
;unsigned int STATED_PWM, PWM_PHASE, PWM_LENGHT;
;
;
;unsigned char PHASE_PHASE;
;unsigned char PHASE_UP_A, PHASE_UP_B, PHASE_UP_C, PHASE_DOWN_A, PHASE_DOWN_B, PHASE_DOWN_C;
;
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void){
; 0000 009D interrupt [9] void timer1_ovf_isr(void){
_timer1_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 009E 
; 0000 009F Count0++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 00A0     if(Count0>=150){
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R4,R30
	CPC  R5,R31
	BRSH PC+2
	RJMP _0x30
; 0000 00A1     Count0 = 0;
	CLR  R4
	CLR  R5
; 0000 00A2     PHASE_PHASE++;
	LDS  R30,_PHASE_PHASE
	SUBI R30,-LOW(1)
	STS  _PHASE_PHASE,R30
; 0000 00A3         if(PHASE_PHASE>=12){
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0xC)
	BRLO _0x31
; 0000 00A4         PHASE_PHASE = 0;
	LDI  R30,LOW(0)
	STS  _PHASE_PHASE,R30
; 0000 00A5         }
; 0000 00A6 
; 0000 00A7 
; 0000 00A8 
; 0000 00A9         if(PHASE_PHASE==0){
_0x31:
	LDS  R30,_PHASE_PHASE
	CPI  R30,0
	BRNE _0x32
; 0000 00AA         PHASE_UP_A = 0;
	RCALL SUBOPT_0x1
; 0000 00AB         PHASE_DOWN_A = 0;
; 0000 00AC         PHASE_UP_B = 0;
	RCALL SUBOPT_0x2
; 0000 00AD         //PHASE_DOWN_B = 0;
; 0000 00AE         //PHASE_UP_C = 0;
; 0000 00AF         PHASE_DOWN_C = 0;
; 0000 00B0 
; 0000 00B1         PHASE_DOWN_B = 1;
	RJMP _0x78
; 0000 00B2         PHASE_UP_C = 1;
; 0000 00B3         }
; 0000 00B4         else if(PHASE_PHASE==1){
_0x32:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x1)
	BRNE _0x34
; 0000 00B5         //PHASE_UP_A = 0;
; 0000 00B6         PHASE_DOWN_A = 0;
	RCALL SUBOPT_0x3
; 0000 00B7         PHASE_UP_B = 0;
	RCALL SUBOPT_0x2
; 0000 00B8         //PHASE_DOWN_B = 0;
; 0000 00B9         //PHASE_UP_C = 0;
; 0000 00BA         PHASE_DOWN_C = 0;
; 0000 00BB 
; 0000 00BC         PHASE_UP_A = 1;
	RCALL SUBOPT_0x4
; 0000 00BD         PHASE_DOWN_B = 1;
	RJMP _0x78
; 0000 00BE         PHASE_UP_C = 1;
; 0000 00BF         }
; 0000 00C0         else if(PHASE_PHASE==2){
_0x34:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x2)
	BRNE _0x36
; 0000 00C1         //PHASE_UP_A = 0;
; 0000 00C2         PHASE_DOWN_A = 0;
	RCALL SUBOPT_0x3
; 0000 00C3         PHASE_UP_B = 0;
	RCALL SUBOPT_0x5
; 0000 00C4         //PHASE_DOWN_B = 0;
; 0000 00C5         PHASE_UP_C = 0;
; 0000 00C6         PHASE_DOWN_C = 0;
	RCALL SUBOPT_0x6
; 0000 00C7 
; 0000 00C8         PHASE_UP_A = 1;
	RCALL SUBOPT_0x4
; 0000 00C9         PHASE_DOWN_B = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x7
; 0000 00CA         }
; 0000 00CB         else if(PHASE_PHASE==3){
	RJMP _0x37
_0x36:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x3)
	BRNE _0x38
; 0000 00CC         //PHASE_UP_A = 0;
; 0000 00CD         PHASE_DOWN_A = 0;
	RCALL SUBOPT_0x3
; 0000 00CE         PHASE_UP_B = 0;
	RCALL SUBOPT_0x5
; 0000 00CF         //PHASE_DOWN_B = 0;
; 0000 00D0         PHASE_UP_C = 0;
; 0000 00D1         //PHASE_DOWN_C = 0;
; 0000 00D2 
; 0000 00D3         PHASE_UP_A = 1;
	RCALL SUBOPT_0x4
; 0000 00D4         PHASE_DOWN_B = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x7
; 0000 00D5         PHASE_DOWN_C = 1;
	RCALL SUBOPT_0x8
; 0000 00D6         }
; 0000 00D7         else if(PHASE_PHASE==4){
	RJMP _0x39
_0x38:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x4)
	BRNE _0x3A
; 0000 00D8         //PHASE_UP_A = 0;
; 0000 00D9         PHASE_DOWN_A = 0;
	RCALL SUBOPT_0x3
; 0000 00DA         PHASE_UP_B = 0;
	RCALL SUBOPT_0x9
; 0000 00DB         PHASE_DOWN_B = 0;
	RCALL SUBOPT_0xA
; 0000 00DC         PHASE_UP_C = 0;
; 0000 00DD         //PHASE_DOWN_C = 0;
; 0000 00DE 
; 0000 00DF         PHASE_UP_A = 1;
	RCALL SUBOPT_0x4
; 0000 00E0         PHASE_DOWN_C = 1;
	RCALL SUBOPT_0x8
; 0000 00E1         }
; 0000 00E2         else if(PHASE_PHASE==5){
	RJMP _0x3B
_0x3A:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x5)
	BRNE _0x3C
; 0000 00E3         //PHASE_UP_A = 0;
; 0000 00E4         PHASE_DOWN_A = 0;
	RCALL SUBOPT_0x3
; 0000 00E5         //PHASE_UP_B = 0;
; 0000 00E6         PHASE_DOWN_B = 0;
	RCALL SUBOPT_0xB
; 0000 00E7         PHASE_UP_C = 0;
; 0000 00E8         //PHASE_DOWN_C = 0;
; 0000 00E9 
; 0000 00EA         PHASE_UP_A = 1;
	RCALL SUBOPT_0x4
; 0000 00EB         PHASE_UP_B = 1;
	RCALL SUBOPT_0xC
; 0000 00EC         PHASE_DOWN_C = 1;
; 0000 00ED         }
; 0000 00EE         else if(PHASE_PHASE==6){
	RJMP _0x3D
_0x3C:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x6)
	BRNE _0x3E
; 0000 00EF         PHASE_UP_A = 0;
	RCALL SUBOPT_0x1
; 0000 00F0         PHASE_DOWN_A = 0;
; 0000 00F1         //PHASE_UP_B = 0;
; 0000 00F2         PHASE_DOWN_B = 0;
	RCALL SUBOPT_0xB
; 0000 00F3         PHASE_UP_C = 0;
; 0000 00F4         //PHASE_DOWN_C = 0;
; 0000 00F5 
; 0000 00F6         PHASE_UP_B = 1;
	RCALL SUBOPT_0xC
; 0000 00F7         PHASE_DOWN_C = 1;
; 0000 00F8         }
; 0000 00F9         else if(PHASE_PHASE==7){
	RJMP _0x3F
_0x3E:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x7)
	BRNE _0x40
; 0000 00FA         PHASE_UP_A = 0;
	RCALL SUBOPT_0xD
; 0000 00FB         //PHASE_DOWN_A = 0;
; 0000 00FC         //PHASE_UP_B = 0;
; 0000 00FD         PHASE_DOWN_B = 0;
; 0000 00FE         PHASE_UP_C = 0;
; 0000 00FF         //PHASE_DOWN_C = 0;
; 0000 0100 
; 0000 0101         PHASE_DOWN_A = 1;
	RCALL SUBOPT_0xE
; 0000 0102         PHASE_UP_B = 1;
	RCALL SUBOPT_0xC
; 0000 0103         PHASE_DOWN_C = 1;
; 0000 0104         }
; 0000 0105         else if(PHASE_PHASE==8){
	RJMP _0x41
_0x40:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x8)
	BRNE _0x42
; 0000 0106         PHASE_UP_A = 0;
	RCALL SUBOPT_0xD
; 0000 0107         //PHASE_DOWN_A = 0;
; 0000 0108         //PHASE_UP_B = 0;
; 0000 0109         PHASE_DOWN_B = 0;
; 0000 010A         PHASE_UP_C = 0;
; 0000 010B         PHASE_DOWN_C = 0;
	RCALL SUBOPT_0x6
; 0000 010C 
; 0000 010D         PHASE_DOWN_A = 1;
	RCALL SUBOPT_0xE
; 0000 010E         PHASE_UP_B = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x9
; 0000 010F         }
; 0000 0110         else if(PHASE_PHASE==9){
	RJMP _0x43
_0x42:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x9)
	BRNE _0x44
; 0000 0111         PHASE_UP_A = 0;
	RCALL SUBOPT_0xF
; 0000 0112         //PHASE_DOWN_A = 0;
; 0000 0113         //PHASE_UP_B = 0;
; 0000 0114         PHASE_DOWN_B = 0;
	RCALL SUBOPT_0x7
; 0000 0115         //PHASE_UP_C = 0;
; 0000 0116         PHASE_DOWN_C = 0;
	RCALL SUBOPT_0x6
; 0000 0117 
; 0000 0118         PHASE_DOWN_A = 1;
	RCALL SUBOPT_0xE
; 0000 0119         PHASE_UP_B = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x9
; 0000 011A         PHASE_UP_C = 1;
	RJMP _0x79
; 0000 011B         }
; 0000 011C         else if(PHASE_PHASE==10){
_0x44:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0xA)
	BRNE _0x46
; 0000 011D         PHASE_UP_A = 0;
	RCALL SUBOPT_0xF
; 0000 011E         //PHASE_DOWN_A = 0;
; 0000 011F         PHASE_UP_B = 0;
	RCALL SUBOPT_0x9
; 0000 0120         PHASE_DOWN_B = 0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x7
; 0000 0121         //PHASE_UP_C = 0;
; 0000 0122         PHASE_DOWN_C = 0;
	RCALL SUBOPT_0x6
; 0000 0123 
; 0000 0124         PHASE_DOWN_A = 1;
	RCALL SUBOPT_0xE
; 0000 0125         PHASE_UP_C = 1;
	RJMP _0x79
; 0000 0126         }
; 0000 0127         else if(PHASE_PHASE==11){
_0x46:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0xB)
	BRNE _0x48
; 0000 0128         PHASE_UP_A = 0;
	RCALL SUBOPT_0xF
; 0000 0129         //PHASE_DOWN_A = 0;
; 0000 012A         PHASE_UP_B = 0;
	RCALL SUBOPT_0x2
; 0000 012B         //PHASE_DOWN_B = 0;
; 0000 012C         //PHASE_UP_C = 0;
; 0000 012D         PHASE_DOWN_C = 0;
; 0000 012E 
; 0000 012F         PHASE_DOWN_A = 1;
	RCALL SUBOPT_0xE
; 0000 0130         PHASE_DOWN_B = 1;
_0x78:
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x7
; 0000 0131         PHASE_UP_C = 1;
_0x79:
	LDI  R30,LOW(1)
	STS  _PHASE_UP_C,R30
; 0000 0132         }
; 0000 0133 
; 0000 0134 
; 0000 0135         if(PHASE_DOWN_A==1){
_0x48:
_0x43:
_0x41:
_0x3F:
_0x3D:
_0x3B:
_0x39:
_0x37:
	LDS  R26,_PHASE_DOWN_A
	CPI  R26,LOW(0x1)
	BRNE _0x49
; 0000 0136         PORTC.5 = 0;
	CBI  0x15,5
; 0000 0137         PORTC.4 = 1;
	SBI  0x15,4
; 0000 0138         }
; 0000 0139         else{
	RJMP _0x4E
_0x49:
; 0000 013A         PORTC.4 = 0;
	CBI  0x15,4
; 0000 013B         }
_0x4E:
; 0000 013C 
; 0000 013D         if(PHASE_DOWN_B==1){
	LDS  R26,_PHASE_DOWN_B
	CPI  R26,LOW(0x1)
	BRNE _0x51
; 0000 013E         PORTC.3 = 0;
	CBI  0x15,3
; 0000 013F         PORTC.2 = 1;
	SBI  0x15,2
; 0000 0140         }
; 0000 0141         else{
	RJMP _0x56
_0x51:
; 0000 0142         PORTC.2 = 0;
	CBI  0x15,2
; 0000 0143         }
_0x56:
; 0000 0144 
; 0000 0145         if(PHASE_DOWN_C==1){
	LDS  R26,_PHASE_DOWN_C
	CPI  R26,LOW(0x1)
	BRNE _0x59
; 0000 0146         PORTC.1 = 0;
	CBI  0x15,1
; 0000 0147         PORTC.0 = 1;
	SBI  0x15,0
; 0000 0148         }
; 0000 0149         else{
	RJMP _0x5E
_0x59:
; 0000 014A         PORTC.0 = 0;
	CBI  0x15,0
; 0000 014B         }
_0x5E:
; 0000 014C     }
; 0000 014D 
; 0000 014E 
; 0000 014F 
; 0000 0150 Count1++;
_0x30:
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0151     if(Count1>=10){
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x61
; 0000 0152     Count1 = 0;
	CLR  R6
	CLR  R7
; 0000 0153     }
; 0000 0154 
; 0000 0155     if(Count1<=5){
_0x61:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R6
	CPC  R31,R7
	BRLO _0x62
; 0000 0156         if(PHASE_UP_A==1){
	LDS  R26,_PHASE_UP_A
	CPI  R26,LOW(0x1)
	BRNE _0x63
; 0000 0157         PORTC.5 = 1;
	SBI  0x15,5
; 0000 0158         }
; 0000 0159         if(PHASE_UP_B==1){
_0x63:
	LDS  R26,_PHASE_UP_B
	CPI  R26,LOW(0x1)
	BRNE _0x66
; 0000 015A         PORTC.3 = 1;
	SBI  0x15,3
; 0000 015B         }
; 0000 015C         if(PHASE_UP_C==1){
_0x66:
	LDS  R26,_PHASE_UP_C
	CPI  R26,LOW(0x1)
	BRNE _0x69
; 0000 015D         PORTC.1 = 1;
	SBI  0x15,1
; 0000 015E         }
; 0000 015F     }
_0x69:
; 0000 0160     else{
	RJMP _0x6C
_0x62:
; 0000 0161     PORTC.5 = 0;
	CBI  0x15,5
; 0000 0162     PORTC.3 = 0;
	CBI  0x15,3
; 0000 0163     PORTC.1 = 0;
	CBI  0x15,1
; 0000 0164     }
_0x6C:
; 0000 0165 
; 0000 0166 
; 0000 0167 
; 0000 0168 /*
; 0000 0169     if(PWM_PHASE>=PWM_LENGHT){
; 0000 016A     PWM_PHASE = 0;
; 0000 016B 
; 0000 016C     CYCLE_PHASE++;
; 0000 016D         if(CYCLE_PHASE>12){
; 0000 016E         CYCLE_PHASE = 1;
; 0000 016F         }
; 0000 0170 
; 0000 0171         if(CYCLE_PHASE==1){
; 0000 0172 
; 0000 0173         }
; 0000 0174         else if(CYCLE_PHASE==2){
; 0000 0175 
; 0000 0176         }
; 0000 0177         else if(CYCLE_PHASE==3){
; 0000 0178 
; 0000 0179         }
; 0000 017A         else if(CYCLE_PHASE==4){
; 0000 017B 
; 0000 017C         }
; 0000 017D         else if(CYCLE_PHASE==5){
; 0000 017E 
; 0000 017F         }
; 0000 0180         else if(CYCLE_PHASE==6){
; 0000 0181 
; 0000 0182         }
; 0000 0183         else if(CYCLE_PHASE==7){
; 0000 0184 
; 0000 0185         }
; 0000 0186         else if(CYCLE_PHASE==8){
; 0000 0187 
; 0000 0188         }
; 0000 0189         else if(CYCLE_PHASE==9){
; 0000 018A 
; 0000 018B         }
; 0000 018C         else if(CYCLE_PHASE==10){
; 0000 018D 
; 0000 018E         }
; 0000 018F         else if(CYCLE_PHASE==11){
; 0000 0190 
; 0000 0191         }
; 0000 0192         else if(PHASE==12){
; 0000 0193 
; 0000 0194         }
; 0000 0195     }
; 0000 0196 */
; 0000 0197 
; 0000 0198 
; 0000 0199 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 019D {
_timer2_ovf_isr:
; 0000 019E // Place your code here
; 0000 019F //Count2++;
; 0000 01A0 }
	RETI
;
;
;
;void main(void){
; 0000 01A4 void main(void){
_main:
; 0000 01A5 // Declare your local variables here
; 0000 01A6 
; 0000 01A7 // Input/Output Ports initialization
; 0000 01A8 // Port B initialization
; 0000 01A9 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01AA // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01AB PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01AC DDRB=0x00;
	OUT  0x17,R30
; 0000 01AD 
; 0000 01AE // Port C initialization
; 0000 01AF // Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 01B0 // State6=T State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 01B1 PORTC=0x00;
	OUT  0x15,R30
; 0000 01B2 DDRC=0x3F;
	LDI  R30,LOW(63)
	OUT  0x14,R30
; 0000 01B3 
; 0000 01B4 // Port D initialization
; 0000 01B5 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01B6 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01B7 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01B8 DDRD=0x00;
	OUT  0x11,R30
; 0000 01B9 
; 0000 01BA // Timer/Counter 0 initialization
; 0000 01BB // Clock source: System Clock
; 0000 01BC // Clock value: Timer 0 Stopped
; 0000 01BD TCCR0=0x00;
	OUT  0x33,R30
; 0000 01BE TCNT0=0x00;
	OUT  0x32,R30
; 0000 01BF 
; 0000 01C0 // Timer/Counter 1 initialization
; 0000 01C1 // Clock source: System Clock
; 0000 01C2 // Clock value: 31.250 kHz
; 0000 01C3 // Mode: Fast PWM top=OCR1A
; 0000 01C4 // OC1A output: Discon.
; 0000 01C5 // OC1B output: Discon.
; 0000 01C6 // Noise Canceler: Off
; 0000 01C7 // Input Capture on Falling Edge
; 0000 01C8 // Timer1 Overflow Interrupt: On
; 0000 01C9 // Input Capture Interrupt: Off
; 0000 01CA // Compare A Match Interrupt: Off
; 0000 01CB // Compare B Match Interrupt: Off
; 0000 01CC TCCR1A=0x03;
	LDI  R30,LOW(3)
	OUT  0x2F,R30
; 0000 01CD TCCR1B=0x1C;
	LDI  R30,LOW(28)
	OUT  0x2E,R30
; 0000 01CE TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 01CF TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01D0 ICR1H=0x00;
	OUT  0x27,R30
; 0000 01D1 ICR1L=0x00;
	OUT  0x26,R30
; 0000 01D2 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01D3 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01D4 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01D5 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01D6 
; 0000 01D7 // Timer/Counter 2 initialization
; 0000 01D8 // Clock source: System Clock
; 0000 01D9 // Clock value: Timer2 Stopped
; 0000 01DA // Mode: Normal top=FFh
; 0000 01DB // OC2 output: Disconnected
; 0000 01DC ASSR=0x00;
	OUT  0x22,R30
; 0000 01DD TCCR2=0x00;
	OUT  0x25,R30
; 0000 01DE TCNT2=0x00;
	OUT  0x24,R30
; 0000 01DF OCR2=0x00;
	OUT  0x23,R30
; 0000 01E0 
; 0000 01E1 // External Interrupt(s) initialization
; 0000 01E2 // INT0: Off
; 0000 01E3 // INT1: Off
; 0000 01E4 MCUCR=0x00;
	OUT  0x35,R30
; 0000 01E5 
; 0000 01E6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01E7 TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 01E8 
; 0000 01E9 // Analog Comparator initialization
; 0000 01EA // Analog Comparator: Off
; 0000 01EB // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01EC ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01ED SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01EE 
; 0000 01EF // LCD module initialization
; 0000 01F0 lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 01F1 
; 0000 01F2 // Global enable interrupts
; 0000 01F3 #asm("sei")
	sei
; 0000 01F4 //OCR1A = 100;
; 0000 01F5 
; 0000 01F6     while(1){
_0x73:
; 0000 01F7     unsigned int TIME;
; 0000 01F8        // if(ONE_SECOND==1){
; 0000 01F9 
; 0000 01FA         //ONE_SECOND = 0;
; 0000 01FB         /*
; 0000 01FC         Phase++;
; 0000 01FD             if(PHASE>12){
; 0000 01FE             Phase = 1;
; 0000 01FF             }
; 0000 0200 
; 0000 0201             if(PHASE==1){
; 0000 0202 
; 0000 0203             }
; 0000 0204             if(PHASE==1){
; 0000 0205 
; 0000 0206             }
; 0000 0207             if(PHASE==1){
; 0000 0208 
; 0000 0209             }
; 0000 020A             if(PHASE==1){
; 0000 020B 
; 0000 020C             }
; 0000 020D             if(PHASE==1){
; 0000 020E 
; 0000 020F             }
; 0000 0210             if(PHASE==1){
; 0000 0211 
; 0000 0212             }
; 0000 0213             if(PHASE==1){
; 0000 0214 
; 0000 0215             }
; 0000 0216             if(PHASE==1){
; 0000 0217 
; 0000 0218             }
; 0000 0219             if(PHASE==1){
; 0000 021A 
; 0000 021B             }
; 0000 021C             if(PHASE==1){
; 0000 021D 
; 0000 021E             }
; 0000 021F             if(PHASE==1){
; 0000 0220 
; 0000 0221             }
; 0000 0222             if(PHASE==1){
; 0000 0223 
; 0000 0224             }
; 0000 0225             */
; 0000 0226 
; 0000 0227         //lcd_clear();
; 0000 0228         //lcd_gotoxy(0,0);
; 0000 0229         //lcd_put_number(0,5,0,0,Count0,0);
; 0000 022A         //Count0 = 0;
; 0000 022B 
; 0000 022C         //lcd_gotoxy(0,1);
; 0000 022D         //lcd_put_number(0,5,0,0,Count2,0);
; 0000 022E         //Count2 = 0;
; 0000 022F 
; 0000 0230 
; 0000 0231 
; 0000 0232         //Count3++;
; 0000 0233         //lcd_gotoxy(0,2);
; 0000 0234         //lcd_put_number(0,7,0,0,Count3,0);
; 0000 0235 
; 0000 0236 
; 0000 0237         // CPU USAGE ///////////////////////////////////////////////////////////////
; 0000 0238         //Count3 = 0;
; 0000 0239         //lcd_gotoxy(0,3);
; 0000 023A 
; 0000 023B         //lcd_puts("CPU COUNTS: ");
; 0000 023C         //lcd_put_number(0,7,0,0,TIME,0);
; 0000 023D         //TIME = Count3;
; 0000 023E         ////////////////////////////////////////////////////////////////////////////
; 0000 023F        // }
; 0000 0240 
; 0000 0241 
; 0000 0242 
; 0000 0243 
; 0000 0244 
; 0000 0245         //PORTC.0 = 0;// 250 ns
; 0000 0246     //delay_ms(1000);
; 0000 0247     }
	RJMP _0x73
; 0000 0248 }
_0x76:
	RJMP _0x76
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
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
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G100:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2020001
__lcd_read_nibble_G100:
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    andi  r30,0xf0
	RET
_lcd_read_byte0_G100:
	RCALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_clear:
	RCALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x10
	RCALL __lcd_ready
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x10
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
__long_delay_G100:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G100:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2020001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x11
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x10
	RCALL __long_delay_G100
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x10
	RCALL __long_delay_G100
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x10
	RCALL __long_delay_G100
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x200000B:
	RCALL __lcd_ready
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x10
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x2020001:
	ADIW R28,1
	RET

	.DSEG
_PHASE_PHASE:
	.BYTE 0x1
_PHASE_UP_A:
	.BYTE 0x1
_PHASE_UP_B:
	.BYTE 0x1
_PHASE_UP_C:
	.BYTE 0x1
_PHASE_DOWN_A:
	.BYTE 0x1
_PHASE_DOWN_B:
	.BYTE 0x1
_PHASE_DOWN_C:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDS  R26,_PHASE_PHASE
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STS  _PHASE_UP_A,R30
	STS  _PHASE_DOWN_A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	STS  _PHASE_UP_B,R30
	LDI  R30,LOW(0)
	STS  _PHASE_DOWN_C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	STS  _PHASE_DOWN_A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	STS  _PHASE_UP_A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	STS  _PHASE_UP_B,R30
	LDI  R30,LOW(0)
	STS  _PHASE_UP_C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	STS  _PHASE_DOWN_C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	STS  _PHASE_DOWN_B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	STS  _PHASE_DOWN_C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	STS  _PHASE_UP_B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x7
	LDI  R30,LOW(0)
	STS  _PHASE_UP_C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0x7
	LDI  R30,LOW(0)
	STS  _PHASE_UP_C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x9
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	STS  _PHASE_UP_A,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1)
	STS  _PHASE_DOWN_A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	STS  _PHASE_UP_A,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	RCALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G100


	.CSEG
;END OF CODE MARKER
__END_OF_CODE:
