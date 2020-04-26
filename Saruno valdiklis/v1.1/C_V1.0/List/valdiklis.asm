
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega2561
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 2048 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega2561
	#pragma AVRPART MEMORY PROG_FLASH 262144
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 8192
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x200

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU RAMPZ=0x3B
	.EQU EIND=0x3C
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x74
	.EQU XMCRB=0x75
	.EQU GPIOR0=0x1E

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
	.DEF __lcd_x=R4
	.DEF __lcd_y=R3
	.DEF __lcd_maxx=R6

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

_0x0:
	.DB  0x2B,0x3E,0x0,0x2D,0x2D,0x3E,0x0,0x2D
	.DB  0x2B,0x0,0x3C,0x2B,0x0,0x3C,0x2D,0x2D
	.DB  0x0,0x2B,0x2D,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x3A,0x0,0x20,0x20,0x20,0x20
	.DB  0x32,0x0,0x2E,0x0
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
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRA,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x2000)
	LDI  R25,HIGH(0x2000)
	LDI  R26,LOW(0x200)
	LDI  R27,HIGH(0x200)
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

	OUT  RAMPZ,R24

	OUT  EIND,R24

;GPIOR0 INITIALIZATION
	LDI  R30,0x00
	OUT  GPIOR0,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x21FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x21FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0xA00)
	LDI  R29,HIGH(0xA00)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xA00

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
;Date    : 7/12/2015
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega2561
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 2048
;*****************************************************/
;
;#include <mega2561.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x02 ;PORTA
; 0000 001E #endasm
;#include <lcd.h>
;
;char NumToIndex(char Num){
; 0000 0021 char NumToIndex(char Num){

	.CSEG
_NumToIndex:
; 0000 0022     if(Num==0){     return '0';}
;	Num -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x3
	LDI  R30,LOW(48)
	JMP  _0x2020001
; 0000 0023     else if(Num==1){return '1';}
_0x3:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x5
	LDI  R30,LOW(49)
	JMP  _0x2020001
; 0000 0024     else if(Num==2){return '2';}
_0x5:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x7
	LDI  R30,LOW(50)
	JMP  _0x2020001
; 0000 0025     else if(Num==3){return '3';}
_0x7:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x9
	LDI  R30,LOW(51)
	JMP  _0x2020001
; 0000 0026     else if(Num==4){return '4';}
_0x9:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xB
	LDI  R30,LOW(52)
	JMP  _0x2020001
; 0000 0027     else if(Num==5){return '5';}
_0xB:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0xD
	LDI  R30,LOW(53)
	JMP  _0x2020001
; 0000 0028     else if(Num==6){return '6';}
_0xD:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0xF
	LDI  R30,LOW(54)
	JMP  _0x2020001
; 0000 0029     else if(Num==7){return '7';}
_0xF:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x11
	LDI  R30,LOW(55)
	JMP  _0x2020001
; 0000 002A     else if(Num==8){return '8';}
_0x11:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x13
	LDI  R30,LOW(56)
	JMP  _0x2020001
; 0000 002B     else if(Num==9){return '9';}
_0x13:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x15
	LDI  R30,LOW(57)
	JMP  _0x2020001
; 0000 002C     else{           return '-';}
_0x15:
	LDI  R30,LOW(45)
	JMP  _0x2020001
; 0000 002D return 0;
; 0000 002E }
;
;char lcd_put_number(char Type, char Lenght, char IsSign,
; 0000 0031 
; 0000 0032                     char NumbersAfterDot,
; 0000 0033 
; 0000 0034                     unsigned long int Number0,
; 0000 0035                     signed long int Number1){
_lcd_put_number:
; 0000 0036     if(Lenght>0){
;	Type -> Y+11
;	Lenght -> Y+10
;	IsSign -> Y+9
;	NumbersAfterDot -> Y+8
;	Number0 -> Y+4
;	Number1 -> Y+0
	LDD  R26,Y+10
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x17
; 0000 0037     unsigned long int k = 1;
; 0000 0038     unsigned char i;
; 0000 0039         for(i=0;i<Lenght-1;i++) k = k*10;
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
_0x19:
	LDD  R30,Y+15
	LDI  R31,0
	SBIW R30,1
	LD   R26,Y
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x1A
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x19
_0x1A:
; 0000 003B if(Type==0){
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x1B
; 0000 003C         unsigned long int a;
; 0000 003D         unsigned char b;
; 0000 003E         a = Number0;
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
	CALL SUBOPT_0x2
; 0000 003F 
; 0000 0040             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x1C
; 0000 0041             lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0042             }
; 0000 0043 
; 0000 0044             if(a<0){
_0x1C:
	CALL SUBOPT_0x3
; 0000 0045             a = a*(-1);
; 0000 0046             }
; 0000 0047 
; 0000 0048             if(k*10<a){
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRSH _0x1E
; 0000 0049             a = k*10 - 1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
; 0000 004A             }
; 0000 004B 
; 0000 004C             for(i=0;i<Lenght;i++){
_0x1E:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x20:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0x21
; 0000 004D                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x22
; 0000 004E                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0x7
	BRNE _0x23
; 0000 004F                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0050                     }
; 0000 0051                 }
_0x23:
; 0000 0052             b = a/k;
_0x22:
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0053             lcd_putchar( NumToIndex( b ) );
; 0000 0054             a = a - b*k;
; 0000 0055             k = k/10;
; 0000 0056             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x20
_0x21:
; 0000 0057         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2020002
; 0000 0058         }
; 0000 0059 
; 0000 005A         else if(Type==1){
_0x1B:
	LDD  R26,Y+16
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x25
; 0000 005B         signed long int a;
; 0000 005C         unsigned char b;
; 0000 005D         a = Number1;
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
	CALL SUBOPT_0x2
; 0000 005E 
; 0000 005F             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x26
; 0000 0060                 if(a>=0){
	LDD  R26,Y+4
	TST  R26
	BRMI _0x27
; 0000 0061                 lcd_putchar('+');
	LDI  R30,LOW(43)
	RJMP _0x52
; 0000 0062                 }
; 0000 0063                 else{
_0x27:
; 0000 0064                 lcd_putchar('-');
	LDI  R30,LOW(45)
_0x52:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0065                 }
; 0000 0066             }
; 0000 0067 
; 0000 0068             if(a<0){
_0x26:
	LDD  R26,Y+4
	TST  R26
	BRPL _0x29
; 0000 0069             a = a*(-1);
	CALL SUBOPT_0x0
	__GETD2N 0xFFFFFFFF
	CALL __MULD12
	CALL SUBOPT_0x2
; 0000 006A             }
; 0000 006B 
; 0000 006C             if(k*10<a){
_0x29:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRSH _0x2A
; 0000 006D             a = k*10 - 1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
; 0000 006E             }
; 0000 006F 
; 0000 0070             for(i=0;i<Lenght;i++){
_0x2A:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x2C:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0x2D
; 0000 0071                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x2E
; 0000 0072                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0x7
	BRNE _0x2F
; 0000 0073                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0074                     }
; 0000 0075                 }
_0x2F:
; 0000 0076             b = a/k;
_0x2E:
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0077             lcd_putchar( NumToIndex( b ) );
; 0000 0078             a = a - b*k;
; 0000 0079             k = k/10;
; 0000 007A             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x2C
_0x2D:
; 0000 007B         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2020002
; 0000 007C         }
; 0000 007D     }
_0x25:
	ADIW R28,5
; 0000 007E return 0;
_0x17:
	LDI  R30,LOW(0)
_0x2020002:
	ADIW R28,12
	RET
; 0000 007F }
;
;
;
;
;
;
;#define ADC_VREF_TYPE 0x00
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 008A {
; 0000 008B ADMUX=(adc_input & 0x07) | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 008C if (adc_input & 0x08) ADCSRB |= 0x08;
; 0000 008D else ADCSRB &= 0xf7;
; 0000 008E // Delay needed for the stabilization of the ADC input voltage
; 0000 008F delay_us(10);
; 0000 0090 // Start the AD conversion
; 0000 0091 ADCSRA|=0x40;
; 0000 0092 // Wait for the AD conversion to complete
; 0000 0093 while ((ADCSRA & 0x10)==0);
; 0000 0094 ADCSRA|=0x10;
; 0000 0095 return ADCW;
; 0000 0096 }
;
;// Declare your global variables here
;
;void main(void)
; 0000 009B {
_main:
; 0000 009C // Declare your local variables here
; 0000 009D 
; 0000 009E // Crystal Oscillator division factor: 1
; 0000 009F #pragma optsize-
; 0000 00A0 CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00A1 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00A2 #ifdef _OPTIMIZE_SIZE_
; 0000 00A3 #pragma optsize+
; 0000 00A4 #endif
; 0000 00A5 
; 0000 00A6 // Input/Output Ports initialization
; 0000 00A7 // Port A initialization
; 0000 00A8 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A9 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00AA PORTA=0x00;
	OUT  0x2,R30
; 0000 00AB DDRA=0x00;
	OUT  0x1,R30
; 0000 00AC 
; 0000 00AD // Port B initialization
; 0000 00AE // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00AF // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00B0 PORTB=0x00;
	OUT  0x5,R30
; 0000 00B1 DDRB=0x00;
	OUT  0x4,R30
; 0000 00B2 
; 0000 00B3 // Port C initialization
; 0000 00B4 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00B5 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00B6 PORTC=0x00;
	OUT  0x8,R30
; 0000 00B7 DDRC=0x00;
	OUT  0x7,R30
; 0000 00B8 
; 0000 00B9 // Port D initialization
; 0000 00BA // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00BB // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00BC PORTD=0x00;
	OUT  0xB,R30
; 0000 00BD DDRD=0x00;
	OUT  0xA,R30
; 0000 00BE 
; 0000 00BF // Port E initialization
; 0000 00C0 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00C1 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00C2 PORTE=0x00;
	OUT  0xE,R30
; 0000 00C3 DDRE=0x00;
	OUT  0xD,R30
; 0000 00C4 
; 0000 00C5 // Port F initialization
; 0000 00C6 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00C7 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00C8 PORTF=0x00;
	OUT  0x11,R30
; 0000 00C9 DDRF=0x00;
	OUT  0x10,R30
; 0000 00CA 
; 0000 00CB // Port G initialization
; 0000 00CC // Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00CD // State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00CE PORTG=0x00;
	OUT  0x14,R30
; 0000 00CF DDRG=0x00;
	OUT  0x13,R30
; 0000 00D0 
; 0000 00D1 // Timer/Counter 0 initialization
; 0000 00D2 // Clock source: System Clock
; 0000 00D3 // Clock value: Timer 0 Stopped
; 0000 00D4 // Mode: Normal top=FFh
; 0000 00D5 // OC0A output: Disconnected
; 0000 00D6 // OC0B output: Disconnected
; 0000 00D7 TCCR0A=0x00;
	OUT  0x24,R30
; 0000 00D8 TCCR0B=0x00;
	OUT  0x25,R30
; 0000 00D9 TCNT0=0x00;
	OUT  0x26,R30
; 0000 00DA OCR0A=0x00;
	OUT  0x27,R30
; 0000 00DB OCR0B=0x00;
	OUT  0x28,R30
; 0000 00DC 
; 0000 00DD // Timer/Counter 1 initialization
; 0000 00DE // Clock source: System Clock
; 0000 00DF // Clock value: Timer1 Stopped
; 0000 00E0 // Mode: Normal top=FFFFh
; 0000 00E1 // OC1A output: Discon.
; 0000 00E2 // OC1B output: Discon.
; 0000 00E3 // OC1C output: Discon.
; 0000 00E4 // Noise Canceler: Off
; 0000 00E5 // Input Capture on Falling Edge
; 0000 00E6 // Timer1 Overflow Interrupt: Off
; 0000 00E7 // Input Capture Interrupt: Off
; 0000 00E8 // Compare A Match Interrupt: Off
; 0000 00E9 // Compare B Match Interrupt: Off
; 0000 00EA // Compare C Match Interrupt: Off
; 0000 00EB TCCR1A=0x00;
	STS  128,R30
; 0000 00EC TCCR1B=0x00;
	STS  129,R30
; 0000 00ED TCNT1H=0x00;
	STS  133,R30
; 0000 00EE TCNT1L=0x00;
	STS  132,R30
; 0000 00EF ICR1H=0x00;
	STS  135,R30
; 0000 00F0 ICR1L=0x00;
	STS  134,R30
; 0000 00F1 OCR1AH=0x00;
	STS  137,R30
; 0000 00F2 OCR1AL=0x00;
	STS  136,R30
; 0000 00F3 OCR1BH=0x00;
	STS  139,R30
; 0000 00F4 OCR1BL=0x00;
	STS  138,R30
; 0000 00F5 OCR1CH=0x00;
	STS  141,R30
; 0000 00F6 OCR1CL=0x00;
	STS  140,R30
; 0000 00F7 
; 0000 00F8 // Timer/Counter 2 initialization
; 0000 00F9 // Clock source: System Clock
; 0000 00FA // Clock value: Timer2 Stopped
; 0000 00FB // Mode: Normal top=FFh
; 0000 00FC // OC2A output: Disconnected
; 0000 00FD // OC2B output: Disconnected
; 0000 00FE ASSR=0x00;
	STS  182,R30
; 0000 00FF TCCR2A=0x00;
	STS  176,R30
; 0000 0100 TCCR2B=0x00;
	STS  177,R30
; 0000 0101 TCNT2=0x00;
	STS  178,R30
; 0000 0102 OCR2A=0x00;
	STS  179,R30
; 0000 0103 OCR2B=0x00;
	STS  180,R30
; 0000 0104 
; 0000 0105 // Timer/Counter 3 initialization
; 0000 0106 // Clock source: System Clock
; 0000 0107 // Clock value: Timer3 Stopped
; 0000 0108 // Mode: Normal top=FFFFh
; 0000 0109 // OC3A output: Discon.
; 0000 010A // OC3B output: Discon.
; 0000 010B // OC3C output: Discon.
; 0000 010C // Noise Canceler: Off
; 0000 010D // Input Capture on Falling Edge
; 0000 010E // Timer3 Overflow Interrupt: Off
; 0000 010F // Input Capture Interrupt: Off
; 0000 0110 // Compare A Match Interrupt: Off
; 0000 0111 // Compare B Match Interrupt: Off
; 0000 0112 // Compare C Match Interrupt: Off
; 0000 0113 TCCR3A=0x00;
	STS  144,R30
; 0000 0114 TCCR3B=0x00;
	STS  145,R30
; 0000 0115 TCNT3H=0x00;
	STS  149,R30
; 0000 0116 TCNT3L=0x00;
	STS  148,R30
; 0000 0117 ICR3H=0x00;
	STS  151,R30
; 0000 0118 ICR3L=0x00;
	STS  150,R30
; 0000 0119 OCR3AH=0x00;
	STS  153,R30
; 0000 011A OCR3AL=0x00;
	STS  152,R30
; 0000 011B OCR3BH=0x00;
	STS  155,R30
; 0000 011C OCR3BL=0x00;
	STS  154,R30
; 0000 011D OCR3CH=0x00;
	STS  157,R30
; 0000 011E OCR3CL=0x00;
	STS  156,R30
; 0000 011F 
; 0000 0120 // Timer/Counter 4 initialization
; 0000 0121 // Clock source: System Clock
; 0000 0122 // Clock value: Timer4 Stopped
; 0000 0123 // Mode: Normal top=FFFFh
; 0000 0124 // OC4A output: Discon.
; 0000 0125 // OC4B output: Discon.
; 0000 0126 // OC4C output: Discon.
; 0000 0127 // Noise Canceler: Off
; 0000 0128 // Input Capture on Falling Edge
; 0000 0129 // Timer4 Overflow Interrupt: Off
; 0000 012A // Input Capture Interrupt: Off
; 0000 012B // Compare A Match Interrupt: Off
; 0000 012C // Compare B Match Interrupt: Off
; 0000 012D // Compare C Match Interrupt: Off
; 0000 012E TCCR4A=0x00;
	STS  160,R30
; 0000 012F TCCR4B=0x00;
	STS  161,R30
; 0000 0130 TCNT4H=0x00;
	STS  165,R30
; 0000 0131 TCNT4L=0x00;
	STS  164,R30
; 0000 0132 ICR4H=0x00;
	STS  167,R30
; 0000 0133 ICR4L=0x00;
	STS  166,R30
; 0000 0134 OCR4AH=0x00;
	STS  169,R30
; 0000 0135 OCR4AL=0x00;
	STS  168,R30
; 0000 0136 OCR4BH=0x00;
	STS  171,R30
; 0000 0137 OCR4BL=0x00;
	STS  170,R30
; 0000 0138 OCR4CH=0x00;
	STS  173,R30
; 0000 0139 OCR4CL=0x00;
	STS  172,R30
; 0000 013A 
; 0000 013B // Timer/Counter 5 initialization
; 0000 013C // Clock source: System Clock
; 0000 013D // Clock value: Timer5 Stopped
; 0000 013E // Mode: Normal top=FFFFh
; 0000 013F // OC5A output: Discon.
; 0000 0140 // OC5B output: Discon.
; 0000 0141 // OC5C output: Discon.
; 0000 0142 // Noise Canceler: Off
; 0000 0143 // Input Capture on Falling Edge
; 0000 0144 // Timer5 Overflow Interrupt: Off
; 0000 0145 // Input Capture Interrupt: Off
; 0000 0146 // Compare A Match Interrupt: Off
; 0000 0147 // Compare B Match Interrupt: Off
; 0000 0148 // Compare C Match Interrupt: Off
; 0000 0149 TCCR5A=0x00;
	STS  288,R30
; 0000 014A TCCR5B=0x00;
	STS  289,R30
; 0000 014B TCNT5H=0x00;
	STS  293,R30
; 0000 014C TCNT5L=0x00;
	STS  292,R30
; 0000 014D ICR5H=0x00;
	STS  295,R30
; 0000 014E ICR5L=0x00;
	STS  294,R30
; 0000 014F OCR5AH=0x00;
	STS  297,R30
; 0000 0150 OCR5AL=0x00;
	STS  296,R30
; 0000 0151 OCR5BH=0x00;
	STS  299,R30
; 0000 0152 OCR5BL=0x00;
	STS  298,R30
; 0000 0153 OCR5CH=0x00;
	STS  301,R30
; 0000 0154 OCR5CL=0x00;
	STS  300,R30
; 0000 0155 
; 0000 0156 // External Interrupt(s) initialization
; 0000 0157 // INT0: Off
; 0000 0158 // INT1: Off
; 0000 0159 // INT2: Off
; 0000 015A // INT3: Off
; 0000 015B // INT4: Off
; 0000 015C // INT5: Off
; 0000 015D // INT6: Off
; 0000 015E // INT7: Off
; 0000 015F EICRA=0x00;
	STS  105,R30
; 0000 0160 EICRB=0x00;
	STS  106,R30
; 0000 0161 EIMSK=0x00;
	OUT  0x1D,R30
; 0000 0162 // PCINT0 interrupt: Off
; 0000 0163 // PCINT1 interrupt: Off
; 0000 0164 // PCINT2 interrupt: Off
; 0000 0165 // PCINT3 interrupt: Off
; 0000 0166 // PCINT4 interrupt: Off
; 0000 0167 // PCINT5 interrupt: Off
; 0000 0168 // PCINT6 interrupt: Off
; 0000 0169 // PCINT7 interrupt: Off
; 0000 016A // PCINT8 interrupt: Off
; 0000 016B // PCINT9 interrupt: Off
; 0000 016C // PCINT10 interrupt: Off
; 0000 016D // PCINT11 interrupt: Off
; 0000 016E // PCINT12 interrupt: Off
; 0000 016F // PCINT13 interrupt: Off
; 0000 0170 // PCINT14 interrupt: Off
; 0000 0171 // PCINT15 interrupt: Off
; 0000 0172 // PCINT16 interrupt: Off
; 0000 0173 // PCINT17 interrupt: Off
; 0000 0174 // PCINT18 interrupt: Off
; 0000 0175 // PCINT19 interrupt: Off
; 0000 0176 // PCINT20 interrupt: Off
; 0000 0177 // PCINT21 interrupt: Off
; 0000 0178 // PCINT22 interrupt: Off
; 0000 0179 // PCINT23 interrupt: Off
; 0000 017A PCMSK0=0x00;
	STS  107,R30
; 0000 017B PCMSK1=0x00;
	STS  108,R30
; 0000 017C PCMSK2=0x00;
	STS  109,R30
; 0000 017D PCICR=0x00;
	STS  104,R30
; 0000 017E 
; 0000 017F // Timer/Counter 0 Interrupt(s) initialization
; 0000 0180 TIMSK0=0x00;
	STS  110,R30
; 0000 0181 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0182 TIMSK1=0x00;
	STS  111,R30
; 0000 0183 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0184 TIMSK2=0x00;
	STS  112,R30
; 0000 0185 // Timer/Counter 3 Interrupt(s) initialization
; 0000 0186 TIMSK3=0x00;
	STS  113,R30
; 0000 0187 // Timer/Counter 4 Interrupt(s) initialization
; 0000 0188 TIMSK4=0x00;
	STS  114,R30
; 0000 0189 // Timer/Counter 5 Interrupt(s) initialization
; 0000 018A TIMSK5=0x00;
	STS  115,R30
; 0000 018B 
; 0000 018C // Analog Comparator initialization
; 0000 018D // Analog Comparator: Off
; 0000 018E // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 018F ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0190 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0191 
; 0000 0192 // ADC initialization
; 0000 0193 // ADC Clock frequency: 1000.000 kHz
; 0000 0194 // ADC Voltage Reference: AREF pin
; 0000 0195 // ADC Auto Trigger Source: None
; 0000 0196 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 0197 // ADC4: On, ADC5: On, ADC6: On, ADC7: On
; 0000 0198 DIDR0=0x00;
	STS  126,R30
; 0000 0199 // Digital input buffers on ADC8: On, ADC9: On, ADC10: On, ADC11: On
; 0000 019A // ADC12: On, ADC13: On, ADC14: On, ADC15: On
; 0000 019B DIDR2=0x00;
	STS  125,R30
; 0000 019C ADMUX=ADC_VREF_TYPE & 0xff;
	STS  124,R30
; 0000 019D ADCSRA=0x83;
	LDI  R30,LOW(131)
	STS  122,R30
; 0000 019E 
; 0000 019F // LCD module initialization
; 0000 01A0 lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01A1 
; 0000 01A2     while(1){
_0x35:
; 0000 01A3     static unsigned char stand_by_pos[2];
; 0000 01A4     stand_by_pos[0]++;
	LDS  R30,_stand_by_pos_S0000003001
	SUBI R30,-LOW(1)
	STS  _stand_by_pos_S0000003001,R30
; 0000 01A5 
; 0000 01A6         if(stand_by_pos[0]>=225){
	LDS  R26,_stand_by_pos_S0000003001
	CPI  R26,LOW(0xE1)
	BRSH PC+3
	JMP _0x38
; 0000 01A7         stand_by_pos[0] = 0;
	LDI  R30,LOW(0)
	STS  _stand_by_pos_S0000003001,R30
; 0000 01A8         stand_by_pos[1]++;
	__GETB1MN _stand_by_pos_S0000003001,1
	SUBI R30,-LOW(1)
	__PUTB1MN _stand_by_pos_S0000003001,1
; 0000 01A9             if(stand_by_pos[1]>=44){
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x2C)
	BRLO _0x39
; 0000 01AA             stand_by_pos[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _stand_by_pos_S0000003001,1
; 0000 01AB             }
; 0000 01AC 
; 0000 01AD         lcd_clear();
_0x39:
	CALL _lcd_clear
; 0000 01AE             if(stand_by_pos[1]==0){lcd_gotoxy(0,2);lcd_putchar('|');lcd_gotoxy(0,1);lcd_putchar('|');lcd_gotoxy(0,0);lcd_putchar('^');}
	__GETB1MN _stand_by_pos_S0000003001,1
	CPI  R30,0
	BRNE _0x3A
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	LDI  R30,LOW(94)
	RJMP _0x54
; 0000 01AF             else if(stand_by_pos[1]==1){lcd_gotoxy(0,1);lcd_putchar('|');lcd_gotoxy(0,0);lcd_putsf("+>");}
_0x3A:
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x1)
	BRNE _0x3C
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,0
	CALL SUBOPT_0xE
; 0000 01B0             else if((stand_by_pos[1]>=2)&&(stand_by_pos[1]<=19)){lcd_gotoxy(stand_by_pos[1]-2,0);lcd_putsf("-->");}
	RJMP _0x3D
_0x3C:
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x2)
	BRLO _0x3F
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x14)
	BRLO _0x40
_0x3F:
	RJMP _0x3E
_0x40:
	__GETB1MN _stand_by_pos_S0000003001,1
	LDI  R31,0
	SBIW R30,2
	ST   -Y,R30
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,3
	CALL SUBOPT_0xE
; 0000 01B1             else if(stand_by_pos[1]==20){lcd_gotoxy(18,0);lcd_putsf("-+");lcd_gotoxy(19,1);lcd_putchar('v');}
	RJMP _0x41
_0x3E:
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x14)
	BRNE _0x42
	LDI  R30,LOW(18)
	ST   -Y,R30
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,7
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	LDI  R30,LOW(118)
	RJMP _0x54
; 0000 01B2             else if(stand_by_pos[1]==21){lcd_gotoxy(19,0);lcd_putchar('|');lcd_gotoxy(19,1);lcd_putchar('|');lcd_gotoxy(19,2);lcd_putchar('v');}
_0x42:
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x15)
	BRNE _0x44
	LDI  R30,LOW(19)
	ST   -Y,R30
	CALL SUBOPT_0xD
	CALL SUBOPT_0x10
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	LDI  R30,LOW(118)
	RJMP _0x54
; 0000 01B3             else if(stand_by_pos[1]==22){lcd_gotoxy(19,1);lcd_putchar('|');lcd_gotoxy(19,2);lcd_putchar('|');lcd_gotoxy(19,3);lcd_putchar('v');}
_0x44:
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x16)
	BRNE _0x46
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
	LDI  R30,LOW(19)
	CALL SUBOPT_0x12
	LDI  R30,LOW(118)
	RJMP _0x54
; 0000 01B4             else if(stand_by_pos[1]==23){lcd_gotoxy(19,2);lcd_putchar('|');lcd_gotoxy(18,3);lcd_putsf("<+");}
_0x46:
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x17)
	BRNE _0x48
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
	LDI  R30,LOW(18)
	CALL SUBOPT_0x12
	__POINTW1FN _0x0,10
	CALL SUBOPT_0xE
; 0000 01B5             else if((stand_by_pos[1]>=24)&&(stand_by_pos[1]<=41)){lcd_gotoxy(17-stand_by_pos[1]+24,3);lcd_putsf("<--");}
	RJMP _0x49
_0x48:
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x18)
	BRLO _0x4B
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x2A)
	BRLO _0x4C
_0x4B:
	RJMP _0x4A
_0x4C:
	__GETB1MN _stand_by_pos_S0000003001,1
	LDI  R31,0
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,-LOW(24)
	CALL SUBOPT_0x12
	__POINTW1FN _0x0,13
	CALL SUBOPT_0xE
; 0000 01B6             else if(stand_by_pos[1]==42){lcd_gotoxy(0,2);lcd_putchar('^');lcd_gotoxy(0,3);lcd_putsf("+-");}
	RJMP _0x4D
_0x4A:
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x2A)
	BRNE _0x4E
	CALL SUBOPT_0xA
	LDI  R30,LOW(94)
	ST   -Y,R30
	CALL _lcd_putchar
	LDI  R30,LOW(0)
	CALL SUBOPT_0x12
	__POINTW1FN _0x0,17
	CALL SUBOPT_0xE
; 0000 01B7             else if(stand_by_pos[1]==43){lcd_gotoxy(0,1);lcd_putchar('^');lcd_gotoxy(0,2);lcd_putchar('|');lcd_gotoxy(0,3);lcd_putchar('|');}
	RJMP _0x4F
_0x4E:
	__GETB2MN _stand_by_pos_S0000003001,1
	CPI  R26,LOW(0x2B)
	BRNE _0x50
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(94)
	ST   -Y,R30
	CALL _lcd_putchar
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(124)
_0x54:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 01B8 
; 0000 01B9         lcd_gotoxy(1,1);
_0x50:
_0x4F:
_0x4D:
_0x49:
_0x41:
_0x3D:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01BA         lcd_putsf("     ");
	__POINTW1FN _0x0,20
	CALL SUBOPT_0xE
; 0000 01BB         lcd_put_number(0,2,0,0,/*RealTimeHour*/19,0);
	CALL SUBOPT_0x13
	__GETD1N 0x13
	CALL SUBOPT_0x14
; 0000 01BC         lcd_putsf(":");
; 0000 01BD         lcd_put_number(0,2,0,0,/*RealTimeMinute*/59,0);
	CALL SUBOPT_0x13
	__GETD1N 0x3B
	CALL SUBOPT_0x14
; 0000 01BE         lcd_putsf(":");
; 0000 01BF         lcd_put_number(0,2,0,0,/*RealTimeSecond*/59,0);
	CALL SUBOPT_0x13
	__GETD1N 0x3B
	CALL SUBOPT_0x15
; 0000 01C0         lcd_putsf("     ");
	__POINTW1FN _0x0,20
	CALL SUBOPT_0xE
; 0000 01C1 
; 0000 01C2         lcd_gotoxy(1,2);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01C3         lcd_putsf("    2");
	__POINTW1FN _0x0,28
	CALL SUBOPT_0xE
; 0000 01C4         lcd_put_number(0,3,0,0,/*RealTimeYear*/2015,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	__GETD1N 0x7DF
	CALL SUBOPT_0x15
; 0000 01C5         lcd_putsf(".");
	__POINTW1FN _0x0,34
	CALL SUBOPT_0xE
; 0000 01C6         lcd_put_number(0,2,0,0,/*RealTimeMonth*/07,0);
	CALL SUBOPT_0x13
	__GETD1N 0x7
	CALL SUBOPT_0x15
; 0000 01C7         lcd_putsf(".");
	__POINTW1FN _0x0,34
	CALL SUBOPT_0xE
; 0000 01C8         lcd_put_number(0,2,0,0,/*RealTimeDay*/12,0);
	CALL SUBOPT_0x13
	__GETD1N 0xC
	CALL SUBOPT_0x15
; 0000 01C9         lcd_putsf("    ");
	__POINTW1FN _0x0,21
	CALL SUBOPT_0xE
; 0000 01CA         }
; 0000 01CB     delay_ms(500);
_0x38:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01CC     };
	RJMP _0x35
; 0000 01CD }
_0x51:
	RJMP _0x51
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
	CALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
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
	JMP  _0x2020001
__lcd_read_nibble_G100:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
    andi  r30,0xf0
	RET
_lcd_read_byte0_G100:
	CALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R4,Y+1
	LDD  R3,Y+0
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
	MOV  R3,R30
	MOV  R4,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	CP   R4,R6
	BRLO _0x2000004
	__lcd_putchar1:
	INC  R3
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R3
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	INC  R4
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2020001
_lcd_putsf:
	ST   -Y,R17
_0x2000008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
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
	CALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2020001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R6,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x16
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x17
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x17
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x17
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x200000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2020001:
	ADIW R28,1
	RET

	.DSEG
_stand_by_pos_S0000003001:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	__GETD2N 0xA
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	__GETD1S 6
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x0
	CALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	__SUBD1N 1
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDD  R26,Y+20
	CLR  R27
	LDD  R30,Y+18
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDD  R30,Y+5
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x9:
	RCALL SUBOPT_0x3
	CALL __DIVD21U
	ST   Y,R30
	ST   -Y,R30
	CALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
	LD   R26,Y
	CLR  R27
	RCALL SUBOPT_0x8
	CALL __CWD2
	CALL __MULD12U
	RCALL SUBOPT_0x3
	CALL __SUBD21
	__PUTD2S 1
	__GETD2S 6
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(124)
	ST   -Y,R30
	CALL _lcd_putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(124)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
	__POINTW1FN _0x0,26
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x15:
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	JMP  _lcd_put_number

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G100


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

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
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

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
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

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
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

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

;END OF CODE MARKER
__END_OF_CODE:
