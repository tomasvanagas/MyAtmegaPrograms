
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega2560
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

	#pragma AVRPART ADMIN PART_NAME ATmega2560
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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

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
;� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 1/15/2012
;Author  : NeVaDa
;Company : Home
;Comments:
;
;
;Chip type               : ATmega2560
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 2048
;*****************************************************/
;
;#include <mega2560.h>
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
;// Declare your global variables here
;
;void main(void)
; 0000 001E {

	.CSEG
_main:
; 0000 001F // Declare your local variables here
; 0000 0020 
; 0000 0021 // Crystal Oscillator division factor: 1
; 0000 0022 #pragma optsize-
; 0000 0023 CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0024 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0025 #ifdef _OPTIMIZE_SIZE_
; 0000 0026 #pragma optsize+
; 0000 0027 #endif
; 0000 0028 
; 0000 0029 // Input/Output Ports initialization
; 0000 002A // Port A initialization
; 0000 002B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 002C // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 002D PORTA=0x00;
	OUT  0x2,R30
; 0000 002E DDRA=0x00;
	OUT  0x1,R30
; 0000 002F 
; 0000 0030 // Port B initialization
; 0000 0031 // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0032 // State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0033 PORTB=0x00;
	OUT  0x5,R30
; 0000 0034 DDRB=0x80;
	LDI  R30,LOW(128)
	OUT  0x4,R30
; 0000 0035 
; 0000 0036 // Port C initialization
; 0000 0037 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0038 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0039 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 003A DDRC=0x00;
	OUT  0x7,R30
; 0000 003B 
; 0000 003C // Port D initialization
; 0000 003D // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 003E // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 003F PORTD=0x00;
	OUT  0xB,R30
; 0000 0040 DDRD=0x00;
	OUT  0xA,R30
; 0000 0041 
; 0000 0042 // Port E initialization
; 0000 0043 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0044 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0045 PORTE=0x00;
	OUT  0xE,R30
; 0000 0046 DDRE=0x00;
	OUT  0xD,R30
; 0000 0047 
; 0000 0048 // Port F initialization
; 0000 0049 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 004A // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 004B PORTF=0x00;
	OUT  0x11,R30
; 0000 004C DDRF=0x00;
	OUT  0x10,R30
; 0000 004D 
; 0000 004E // Port G initialization
; 0000 004F // Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0050 // State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0051 PORTG=0x00;
	OUT  0x14,R30
; 0000 0052 DDRG=0x00;
	OUT  0x13,R30
; 0000 0053 
; 0000 0054 // Port H initialization
; 0000 0055 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0056 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0057 PORTH=0x00;
	STS  258,R30
; 0000 0058 DDRH=0x00;
	STS  257,R30
; 0000 0059 
; 0000 005A // Port J initialization
; 0000 005B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 005C // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 005D PORTJ=0x00;
	STS  261,R30
; 0000 005E DDRJ=0x00;
	STS  260,R30
; 0000 005F 
; 0000 0060 // Port K initialization
; 0000 0061 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0062 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0063 PORTK=0x00;
	STS  264,R30
; 0000 0064 DDRK=0x00;
	STS  263,R30
; 0000 0065 
; 0000 0066 // Port L initialization
; 0000 0067 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0068 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0069 PORTL=0x00;
	STS  267,R30
; 0000 006A DDRL=0x00;
	STS  266,R30
; 0000 006B 
; 0000 006C // Timer/Counter 0 initialization
; 0000 006D // Clock source: System Clock
; 0000 006E // Clock value: 8000.000 kHz
; 0000 006F // Mode: Fast PWM top=FFh
; 0000 0070 // OC0A output: Non-Inverted PWM
; 0000 0071 // OC0B output: Disconnected
; 0000 0072 TCCR0A=0x83;
	LDI  R30,LOW(131)
	OUT  0x24,R30
; 0000 0073 TCCR0B=0x01;
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 0074 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0075 OCR0A=0x00;
	OUT  0x27,R30
; 0000 0076 OCR0B=0x00;
	OUT  0x28,R30
; 0000 0077 
; 0000 0078 // Timer/Counter 1 initialization
; 0000 0079 // Clock source: System Clock
; 0000 007A // Clock value: Timer1 Stopped
; 0000 007B // Mode: Normal top=FFFFh
; 0000 007C // OC1A output: Discon.
; 0000 007D // OC1B output: Discon.
; 0000 007E // OC1C output: Discon.
; 0000 007F // Noise Canceler: Off
; 0000 0080 // Input Capture on Falling Edge
; 0000 0081 // Timer1 Overflow Interrupt: Off
; 0000 0082 // Input Capture Interrupt: Off
; 0000 0083 // Compare A Match Interrupt: Off
; 0000 0084 // Compare B Match Interrupt: Off
; 0000 0085 // Compare C Match Interrupt: Off
; 0000 0086 TCCR1A=0x00;
	STS  128,R30
; 0000 0087 TCCR1B=0x00;
	STS  129,R30
; 0000 0088 TCNT1H=0x00;
	STS  133,R30
; 0000 0089 TCNT1L=0x00;
	STS  132,R30
; 0000 008A ICR1H=0x00;
	STS  135,R30
; 0000 008B ICR1L=0x00;
	STS  134,R30
; 0000 008C OCR1AH=0x00;
	STS  137,R30
; 0000 008D OCR1AL=0x00;
	STS  136,R30
; 0000 008E OCR1BH=0x00;
	STS  139,R30
; 0000 008F OCR1BL=0x00;
	STS  138,R30
; 0000 0090 OCR1CH=0x00;
	STS  141,R30
; 0000 0091 OCR1CL=0x00;
	STS  140,R30
; 0000 0092 
; 0000 0093 // Timer/Counter 2 initialization
; 0000 0094 // Clock source: System Clock
; 0000 0095 // Clock value: Timer2 Stopped
; 0000 0096 // Mode: Normal top=FFh
; 0000 0097 // OC2A output: Disconnected
; 0000 0098 // OC2B output: Disconnected
; 0000 0099 ASSR=0x00;
	STS  182,R30
; 0000 009A TCCR2A=0x00;
	STS  176,R30
; 0000 009B TCCR2B=0x00;
	STS  177,R30
; 0000 009C TCNT2=0x00;
	STS  178,R30
; 0000 009D OCR2A=0x00;
	STS  179,R30
; 0000 009E OCR2B=0x00;
	STS  180,R30
; 0000 009F 
; 0000 00A0 // Timer/Counter 3 initialization
; 0000 00A1 // Clock source: System Clock
; 0000 00A2 // Clock value: Timer3 Stopped
; 0000 00A3 // Mode: Normal top=FFFFh
; 0000 00A4 // OC3A output: Discon.
; 0000 00A5 // OC3B output: Discon.
; 0000 00A6 // OC3C output: Discon.
; 0000 00A7 // Noise Canceler: Off
; 0000 00A8 // Input Capture on Falling Edge
; 0000 00A9 // Timer3 Overflow Interrupt: Off
; 0000 00AA // Input Capture Interrupt: Off
; 0000 00AB // Compare A Match Interrupt: Off
; 0000 00AC // Compare B Match Interrupt: Off
; 0000 00AD // Compare C Match Interrupt: Off
; 0000 00AE TCCR3A=0x00;
	STS  144,R30
; 0000 00AF TCCR3B=0x00;
	STS  145,R30
; 0000 00B0 TCNT3H=0x00;
	STS  149,R30
; 0000 00B1 TCNT3L=0x00;
	STS  148,R30
; 0000 00B2 ICR3H=0x00;
	STS  151,R30
; 0000 00B3 ICR3L=0x00;
	STS  150,R30
; 0000 00B4 OCR3AH=0x00;
	STS  153,R30
; 0000 00B5 OCR3AL=0x00;
	STS  152,R30
; 0000 00B6 OCR3BH=0x00;
	STS  155,R30
; 0000 00B7 OCR3BL=0x00;
	STS  154,R30
; 0000 00B8 OCR3CH=0x00;
	STS  157,R30
; 0000 00B9 OCR3CL=0x00;
	STS  156,R30
; 0000 00BA 
; 0000 00BB // Timer/Counter 4 initialization
; 0000 00BC // Clock source: System Clock
; 0000 00BD // Clock value: Timer4 Stopped
; 0000 00BE // Mode: Normal top=FFFFh
; 0000 00BF // OC4A output: Discon.
; 0000 00C0 // OC4B output: Discon.
; 0000 00C1 // OC4C output: Discon.
; 0000 00C2 // Noise Canceler: Off
; 0000 00C3 // Input Capture on Falling Edge
; 0000 00C4 // Timer4 Overflow Interrupt: Off
; 0000 00C5 // Input Capture Interrupt: Off
; 0000 00C6 // Compare A Match Interrupt: Off
; 0000 00C7 // Compare B Match Interrupt: Off
; 0000 00C8 // Compare C Match Interrupt: Off
; 0000 00C9 TCCR4A=0x00;
	STS  160,R30
; 0000 00CA TCCR4B=0x00;
	STS  161,R30
; 0000 00CB TCNT4H=0x00;
	STS  165,R30
; 0000 00CC TCNT4L=0x00;
	STS  164,R30
; 0000 00CD ICR4H=0x00;
	STS  167,R30
; 0000 00CE ICR4L=0x00;
	STS  166,R30
; 0000 00CF OCR4AH=0x00;
	STS  169,R30
; 0000 00D0 OCR4AL=0x00;
	STS  168,R30
; 0000 00D1 OCR4BH=0x00;
	STS  171,R30
; 0000 00D2 OCR4BL=0x00;
	STS  170,R30
; 0000 00D3 OCR4CH=0x00;
	STS  173,R30
; 0000 00D4 OCR4CL=0x00;
	STS  172,R30
; 0000 00D5 
; 0000 00D6 // Timer/Counter 5 initialization
; 0000 00D7 // Clock source: System Clock
; 0000 00D8 // Clock value: Timer5 Stopped
; 0000 00D9 // Mode: Normal top=FFFFh
; 0000 00DA // OC5A output: Discon.
; 0000 00DB // OC5B output: Discon.
; 0000 00DC // OC5C output: Discon.
; 0000 00DD // Noise Canceler: Off
; 0000 00DE // Input Capture on Falling Edge
; 0000 00DF // Timer5 Overflow Interrupt: Off
; 0000 00E0 // Input Capture Interrupt: Off
; 0000 00E1 // Compare A Match Interrupt: Off
; 0000 00E2 // Compare B Match Interrupt: Off
; 0000 00E3 // Compare C Match Interrupt: Off
; 0000 00E4 TCCR5A=0x00;
	STS  288,R30
; 0000 00E5 TCCR5B=0x00;
	STS  289,R30
; 0000 00E6 TCNT5H=0x00;
	STS  293,R30
; 0000 00E7 TCNT5L=0x00;
	STS  292,R30
; 0000 00E8 ICR5H=0x00;
	STS  295,R30
; 0000 00E9 ICR5L=0x00;
	STS  294,R30
; 0000 00EA OCR5AH=0x00;
	STS  297,R30
; 0000 00EB OCR5AL=0x00;
	STS  296,R30
; 0000 00EC OCR5BH=0x00;
	STS  299,R30
; 0000 00ED OCR5BL=0x00;
	STS  298,R30
; 0000 00EE OCR5CH=0x00;
	STS  301,R30
; 0000 00EF OCR5CL=0x00;
	STS  300,R30
; 0000 00F0 
; 0000 00F1 // External Interrupt(s) initialization
; 0000 00F2 // INT0: Off
; 0000 00F3 // INT1: Off
; 0000 00F4 // INT2: Off
; 0000 00F5 // INT3: Off
; 0000 00F6 // INT4: Off
; 0000 00F7 // INT5: Off
; 0000 00F8 // INT6: Off
; 0000 00F9 // INT7: Off
; 0000 00FA EICRA=0x00;
	STS  105,R30
; 0000 00FB EICRB=0x00;
	STS  106,R30
; 0000 00FC EIMSK=0x00;
	OUT  0x1D,R30
; 0000 00FD // PCINT0 interrupt: Off
; 0000 00FE // PCINT1 interrupt: Off
; 0000 00FF // PCINT2 interrupt: Off
; 0000 0100 // PCINT3 interrupt: Off
; 0000 0101 // PCINT4 interrupt: Off
; 0000 0102 // PCINT5 interrupt: Off
; 0000 0103 // PCINT6 interrupt: Off
; 0000 0104 // PCINT7 interrupt: Off
; 0000 0105 // PCINT8 interrupt: Off
; 0000 0106 // PCINT9 interrupt: Off
; 0000 0107 // PCINT10 interrupt: Off
; 0000 0108 // PCINT11 interrupt: Off
; 0000 0109 // PCINT12 interrupt: Off
; 0000 010A // PCINT13 interrupt: Off
; 0000 010B // PCINT14 interrupt: Off
; 0000 010C // PCINT15 interrupt: Off
; 0000 010D // PCINT16 interrupt: Off
; 0000 010E // PCINT17 interrupt: Off
; 0000 010F // PCINT18 interrupt: Off
; 0000 0110 // PCINT19 interrupt: Off
; 0000 0111 // PCINT20 interrupt: Off
; 0000 0112 // PCINT21 interrupt: Off
; 0000 0113 // PCINT22 interrupt: Off
; 0000 0114 // PCINT23 interrupt: Off
; 0000 0115 PCMSK0=0x00;
	STS  107,R30
; 0000 0116 PCMSK1=0x00;
	STS  108,R30
; 0000 0117 PCMSK2=0x00;
	STS  109,R30
; 0000 0118 PCICR=0x00;
	STS  104,R30
; 0000 0119 
; 0000 011A // Timer/Counter 0 Interrupt(s) initialization
; 0000 011B TIMSK0=0x00;
	STS  110,R30
; 0000 011C // Timer/Counter 1 Interrupt(s) initialization
; 0000 011D TIMSK1=0x00;
	STS  111,R30
; 0000 011E // Timer/Counter 2 Interrupt(s) initialization
; 0000 011F TIMSK2=0x00;
	STS  112,R30
; 0000 0120 // Timer/Counter 3 Interrupt(s) initialization
; 0000 0121 TIMSK3=0x00;
	STS  113,R30
; 0000 0122 // Timer/Counter 4 Interrupt(s) initialization
; 0000 0123 TIMSK4=0x00;
	STS  114,R30
; 0000 0124 // Timer/Counter 5 Interrupt(s) initialization
; 0000 0125 TIMSK5=0x00;
	STS  115,R30
; 0000 0126 
; 0000 0127 // Analog Comparator initialization
; 0000 0128 // Analog Comparator: Off
; 0000 0129 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 012A ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 012B ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 012C 
; 0000 012D static unsigned char i;
; 0000 012E     while (1){
_0x3:
; 0000 012F 
; 0000 0130         if(i==0){
	LDS  R30,_i_S0000000000
	CPI  R30,0
	BRNE _0x6
; 0000 0131             if(OCR0A==255){
	IN   R30,0x27
	CPI  R30,LOW(0xFF)
	BRNE _0x7
; 0000 0132             i = 1;
	LDI  R30,LOW(1)
	STS  _i_S0000000000,R30
; 0000 0133             }
; 0000 0134             else{
	RJMP _0x8
_0x7:
; 0000 0135             OCR0A++;
	IN   R30,0x27
	SUBI R30,-LOW(1)
	OUT  0x27,R30
; 0000 0136             }
_0x8:
; 0000 0137         }
; 0000 0138         else{
	RJMP _0x9
_0x6:
; 0000 0139             if(OCR0A==0){
	IN   R30,0x27
	CPI  R30,0
	BRNE _0xA
; 0000 013A             i = 0;
	LDI  R30,LOW(0)
	STS  _i_S0000000000,R30
; 0000 013B             }
; 0000 013C             else{
	RJMP _0xB
_0xA:
; 0000 013D             OCR0A--;
	IN   R30,0x27
	SUBI R30,LOW(1)
	OUT  0x27,R30
; 0000 013E             }
_0xB:
; 0000 013F         }
_0x9:
; 0000 0140     delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0141     };
	RJMP _0x3
; 0000 0142 }
_0xC:
	RJMP _0xC

	.DSEG
_i_S0000000000:
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

;END OF CODE MARKER
__END_OF_CODE:
