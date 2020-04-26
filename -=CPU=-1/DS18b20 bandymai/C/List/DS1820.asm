
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _ds1820_devices=R4
	.DEF __lcd_x=R3
	.DEF __lcd_y=R6
	.DEF __lcd_maxx=R5

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

_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

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
;Date    : 1/24/2012
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
;// 1 Wire Bus functions
;#asm
   .equ __w1_port=0x02 ;PORTA
   .equ __w1_bit = 0
; 0000 001E #endasm
;#include <1wire.h>
;
;// DS1820 Temperature Sensor functions
;#include <ds1820.h>
;
;// maximum number of DS1820 devices
;// connected to the 1 Wire bus
;#define MAX_DS1820 20
;// number of DS1820 devices
;// connected to the 1 Wire bus
;unsigned char ds1820_devices;
;// DS1820 devices ROM code storage area,
;// 9 bytes are used for each device
;// (see the w1_search function description in the help)
;unsigned char ds1820_rom_codes[MAX_DS1820][2][9];
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x05 ;PORTB
; 0000 0032 #endasm
;#include <lcd.h>
;
;char NumToIndex(char Num){
; 0000 0035 char NumToIndex(char Num){

	.CSEG
_NumToIndex:
; 0000 0036     if(Num==0){     return '0';}
;	Num -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x3
	LDI  R30,LOW(48)
	JMP  _0x2040001
; 0000 0037     else if(Num==1){return '1';}
_0x3:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x5
	LDI  R30,LOW(49)
	JMP  _0x2040001
; 0000 0038     else if(Num==2){return '2';}
_0x5:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x7
	LDI  R30,LOW(50)
	JMP  _0x2040001
; 0000 0039     else if(Num==3){return '3';}
_0x7:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x9
	LDI  R30,LOW(51)
	JMP  _0x2040001
; 0000 003A     else if(Num==4){return '4';}
_0x9:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xB
	LDI  R30,LOW(52)
	JMP  _0x2040001
; 0000 003B     else if(Num==5){return '5';}
_0xB:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0xD
	LDI  R30,LOW(53)
	JMP  _0x2040001
; 0000 003C     else if(Num==6){return '6';}
_0xD:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0xF
	LDI  R30,LOW(54)
	JMP  _0x2040001
; 0000 003D     else if(Num==7){return '7';}
_0xF:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x11
	LDI  R30,LOW(55)
	JMP  _0x2040001
; 0000 003E     else if(Num==8){return '8';}
_0x11:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x13
	LDI  R30,LOW(56)
	JMP  _0x2040001
; 0000 003F     else if(Num==9){return '9';}
_0x13:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x15
	LDI  R30,LOW(57)
	JMP  _0x2040001
; 0000 0040     else if(Num==10){return 'a';}
_0x15:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x17
	LDI  R30,LOW(97)
	JMP  _0x2040001
; 0000 0041     else if(Num==11){return 'b';}
_0x17:
	LD   R26,Y
	CPI  R26,LOW(0xB)
	BRNE _0x19
	LDI  R30,LOW(98)
	JMP  _0x2040001
; 0000 0042     else if(Num==12){return 'c';}
_0x19:
	LD   R26,Y
	CPI  R26,LOW(0xC)
	BRNE _0x1B
	LDI  R30,LOW(99)
	JMP  _0x2040001
; 0000 0043     else if(Num==13){return 'd';}
_0x1B:
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRNE _0x1D
	LDI  R30,LOW(100)
	JMP  _0x2040001
; 0000 0044     else if(Num==14){return 'e';}
_0x1D:
	LD   R26,Y
	CPI  R26,LOW(0xE)
	BRNE _0x1F
	LDI  R30,LOW(101)
	JMP  _0x2040001
; 0000 0045     else if(Num==15){return 'f';}
_0x1F:
	LD   R26,Y
	CPI  R26,LOW(0xF)
	BRNE _0x21
	LDI  R30,LOW(102)
	JMP  _0x2040001
; 0000 0046     else{           return '-';}
_0x21:
	LDI  R30,LOW(45)
	JMP  _0x2040001
; 0000 0047 return 0;
; 0000 0048 }
;
;// Declare your global variables here
;
;void main(void){
; 0000 004C void main(void){
_main:
; 0000 004D // Declare your local variables here
; 0000 004E 
; 0000 004F // Crystal Oscillator division factor: 1
; 0000 0050 #pragma optsize-
; 0000 0051 CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0052 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0053 #ifdef _OPTIMIZE_SIZE_
; 0000 0054 #pragma optsize+
; 0000 0055 #endif
; 0000 0056 
; 0000 0057 // Input/Output Ports initialization
; 0000 0058 // Port A initialization
; 0000 0059 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 005A // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 005B PORTA=0x00;
	OUT  0x2,R30
; 0000 005C DDRA=0x00;
	OUT  0x1,R30
; 0000 005D 
; 0000 005E // Port B initialization
; 0000 005F // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0060 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0061 PORTB=0x00;
	OUT  0x5,R30
; 0000 0062 DDRB=0x00;
	OUT  0x4,R30
; 0000 0063 
; 0000 0064 // Port C initialization
; 0000 0065 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0066 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0067 PORTC=0x00;
	OUT  0x8,R30
; 0000 0068 DDRC=0x00;
	OUT  0x7,R30
; 0000 0069 
; 0000 006A // Port D initialization
; 0000 006B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 006C // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 006D PORTD=0x00;
	OUT  0xB,R30
; 0000 006E DDRD=0x00;
	OUT  0xA,R30
; 0000 006F 
; 0000 0070 // Port E initialization
; 0000 0071 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0072 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0073 PORTE=0x00;
	OUT  0xE,R30
; 0000 0074 DDRE=0x00;
	OUT  0xD,R30
; 0000 0075 
; 0000 0076 // Port F initialization
; 0000 0077 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0078 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0079 PORTF=0x00;
	OUT  0x11,R30
; 0000 007A DDRF=0x00;
	OUT  0x10,R30
; 0000 007B 
; 0000 007C // Port G initialization
; 0000 007D // Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 007E // State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 007F PORTG=0x00;
	OUT  0x14,R30
; 0000 0080 DDRG=0x00;
	OUT  0x13,R30
; 0000 0081 
; 0000 0082 // Port H initialization
; 0000 0083 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0084 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0085 PORTH=0x00;
	STS  258,R30
; 0000 0086 DDRH=0x00;
	STS  257,R30
; 0000 0087 
; 0000 0088 // Port J initialization
; 0000 0089 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 008A // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 008B PORTJ=0x00;
	STS  261,R30
; 0000 008C DDRJ=0x00;
	STS  260,R30
; 0000 008D 
; 0000 008E // Port K initialization
; 0000 008F // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0090 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0091 PORTK=0x00;
	STS  264,R30
; 0000 0092 DDRK=0x00;
	STS  263,R30
; 0000 0093 
; 0000 0094 // Port L initialization
; 0000 0095 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0096 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0097 PORTL=0x00;
	STS  267,R30
; 0000 0098 DDRL=0x00;
	STS  266,R30
; 0000 0099 
; 0000 009A // Timer/Counter 0 initialization
; 0000 009B // Clock source: System Clock
; 0000 009C // Clock value: Timer 0 Stopped
; 0000 009D // Mode: Normal top=FFh
; 0000 009E // OC0A output: Disconnected
; 0000 009F // OC0B output: Disconnected
; 0000 00A0 TCCR0A=0x00;
	OUT  0x24,R30
; 0000 00A1 TCCR0B=0x00;
	OUT  0x25,R30
; 0000 00A2 TCNT0=0x00;
	OUT  0x26,R30
; 0000 00A3 OCR0A=0x00;
	OUT  0x27,R30
; 0000 00A4 OCR0B=0x00;
	OUT  0x28,R30
; 0000 00A5 
; 0000 00A6 // Timer/Counter 1 initialization
; 0000 00A7 // Clock source: System Clock
; 0000 00A8 // Clock value: Timer1 Stopped
; 0000 00A9 // Mode: Normal top=FFFFh
; 0000 00AA // OC1A output: Discon.
; 0000 00AB // OC1B output: Discon.
; 0000 00AC // OC1C output: Discon.
; 0000 00AD // Noise Canceler: Off
; 0000 00AE // Input Capture on Falling Edge
; 0000 00AF // Timer1 Overflow Interrupt: Off
; 0000 00B0 // Input Capture Interrupt: Off
; 0000 00B1 // Compare A Match Interrupt: Off
; 0000 00B2 // Compare B Match Interrupt: Off
; 0000 00B3 // Compare C Match Interrupt: Off
; 0000 00B4 TCCR1A=0x00;
	STS  128,R30
; 0000 00B5 TCCR1B=0x00;
	STS  129,R30
; 0000 00B6 TCNT1H=0x00;
	STS  133,R30
; 0000 00B7 TCNT1L=0x00;
	STS  132,R30
; 0000 00B8 ICR1H=0x00;
	STS  135,R30
; 0000 00B9 ICR1L=0x00;
	STS  134,R30
; 0000 00BA OCR1AH=0x00;
	STS  137,R30
; 0000 00BB OCR1AL=0x00;
	STS  136,R30
; 0000 00BC OCR1BH=0x00;
	STS  139,R30
; 0000 00BD OCR1BL=0x00;
	STS  138,R30
; 0000 00BE OCR1CH=0x00;
	STS  141,R30
; 0000 00BF OCR1CL=0x00;
	STS  140,R30
; 0000 00C0 
; 0000 00C1 // Timer/Counter 2 initialization
; 0000 00C2 // Clock source: System Clock
; 0000 00C3 // Clock value: Timer2 Stopped
; 0000 00C4 // Mode: Normal top=FFh
; 0000 00C5 // OC2A output: Disconnected
; 0000 00C6 // OC2B output: Disconnected
; 0000 00C7 ASSR=0x00;
	STS  182,R30
; 0000 00C8 TCCR2A=0x00;
	STS  176,R30
; 0000 00C9 TCCR2B=0x00;
	STS  177,R30
; 0000 00CA TCNT2=0x00;
	STS  178,R30
; 0000 00CB OCR2A=0x00;
	STS  179,R30
; 0000 00CC OCR2B=0x00;
	STS  180,R30
; 0000 00CD 
; 0000 00CE // Timer/Counter 3 initialization
; 0000 00CF // Clock source: System Clock
; 0000 00D0 // Clock value: Timer3 Stopped
; 0000 00D1 // Mode: Normal top=FFFFh
; 0000 00D2 // OC3A output: Discon.
; 0000 00D3 // OC3B output: Discon.
; 0000 00D4 // OC3C output: Discon.
; 0000 00D5 // Noise Canceler: Off
; 0000 00D6 // Input Capture on Falling Edge
; 0000 00D7 // Timer3 Overflow Interrupt: Off
; 0000 00D8 // Input Capture Interrupt: Off
; 0000 00D9 // Compare A Match Interrupt: Off
; 0000 00DA // Compare B Match Interrupt: Off
; 0000 00DB // Compare C Match Interrupt: Off
; 0000 00DC TCCR3A=0x00;
	STS  144,R30
; 0000 00DD TCCR3B=0x00;
	STS  145,R30
; 0000 00DE TCNT3H=0x00;
	STS  149,R30
; 0000 00DF TCNT3L=0x00;
	STS  148,R30
; 0000 00E0 ICR3H=0x00;
	STS  151,R30
; 0000 00E1 ICR3L=0x00;
	STS  150,R30
; 0000 00E2 OCR3AH=0x00;
	STS  153,R30
; 0000 00E3 OCR3AL=0x00;
	STS  152,R30
; 0000 00E4 OCR3BH=0x00;
	STS  155,R30
; 0000 00E5 OCR3BL=0x00;
	STS  154,R30
; 0000 00E6 OCR3CH=0x00;
	STS  157,R30
; 0000 00E7 OCR3CL=0x00;
	STS  156,R30
; 0000 00E8 
; 0000 00E9 // Timer/Counter 4 initialization
; 0000 00EA // Clock source: System Clock
; 0000 00EB // Clock value: Timer4 Stopped
; 0000 00EC // Mode: Normal top=FFFFh
; 0000 00ED // OC4A output: Discon.
; 0000 00EE // OC4B output: Discon.
; 0000 00EF // OC4C output: Discon.
; 0000 00F0 // Noise Canceler: Off
; 0000 00F1 // Input Capture on Falling Edge
; 0000 00F2 // Timer4 Overflow Interrupt: Off
; 0000 00F3 // Input Capture Interrupt: Off
; 0000 00F4 // Compare A Match Interrupt: Off
; 0000 00F5 // Compare B Match Interrupt: Off
; 0000 00F6 // Compare C Match Interrupt: Off
; 0000 00F7 TCCR4A=0x00;
	STS  160,R30
; 0000 00F8 TCCR4B=0x00;
	STS  161,R30
; 0000 00F9 TCNT4H=0x00;
	STS  165,R30
; 0000 00FA TCNT4L=0x00;
	STS  164,R30
; 0000 00FB ICR4H=0x00;
	STS  167,R30
; 0000 00FC ICR4L=0x00;
	STS  166,R30
; 0000 00FD OCR4AH=0x00;
	STS  169,R30
; 0000 00FE OCR4AL=0x00;
	STS  168,R30
; 0000 00FF OCR4BH=0x00;
	STS  171,R30
; 0000 0100 OCR4BL=0x00;
	STS  170,R30
; 0000 0101 OCR4CH=0x00;
	STS  173,R30
; 0000 0102 OCR4CL=0x00;
	STS  172,R30
; 0000 0103 
; 0000 0104 // Timer/Counter 5 initialization
; 0000 0105 // Clock source: System Clock
; 0000 0106 // Clock value: Timer5 Stopped
; 0000 0107 // Mode: Normal top=FFFFh
; 0000 0108 // OC5A output: Discon.
; 0000 0109 // OC5B output: Discon.
; 0000 010A // OC5C output: Discon.
; 0000 010B // Noise Canceler: Off
; 0000 010C // Input Capture on Falling Edge
; 0000 010D // Timer5 Overflow Interrupt: Off
; 0000 010E // Input Capture Interrupt: Off
; 0000 010F // Compare A Match Interrupt: Off
; 0000 0110 // Compare B Match Interrupt: Off
; 0000 0111 // Compare C Match Interrupt: Off
; 0000 0112 TCCR5A=0x00;
	STS  288,R30
; 0000 0113 TCCR5B=0x00;
	STS  289,R30
; 0000 0114 TCNT5H=0x00;
	STS  293,R30
; 0000 0115 TCNT5L=0x00;
	STS  292,R30
; 0000 0116 ICR5H=0x00;
	STS  295,R30
; 0000 0117 ICR5L=0x00;
	STS  294,R30
; 0000 0118 OCR5AH=0x00;
	STS  297,R30
; 0000 0119 OCR5AL=0x00;
	STS  296,R30
; 0000 011A OCR5BH=0x00;
	STS  299,R30
; 0000 011B OCR5BL=0x00;
	STS  298,R30
; 0000 011C OCR5CH=0x00;
	STS  301,R30
; 0000 011D OCR5CL=0x00;
	STS  300,R30
; 0000 011E 
; 0000 011F // External Interrupt(s) initialization
; 0000 0120 // INT0: Off
; 0000 0121 // INT1: Off
; 0000 0122 // INT2: Off
; 0000 0123 // INT3: Off
; 0000 0124 // INT4: Off
; 0000 0125 // INT5: Off
; 0000 0126 // INT6: Off
; 0000 0127 // INT7: Off
; 0000 0128 EICRA=0x00;
	STS  105,R30
; 0000 0129 EICRB=0x00;
	STS  106,R30
; 0000 012A EIMSK=0x00;
	OUT  0x1D,R30
; 0000 012B // PCINT0 interrupt: Off
; 0000 012C // PCINT1 interrupt: Off
; 0000 012D // PCINT2 interrupt: Off
; 0000 012E // PCINT3 interrupt: Off
; 0000 012F // PCINT4 interrupt: Off
; 0000 0130 // PCINT5 interrupt: Off
; 0000 0131 // PCINT6 interrupt: Off
; 0000 0132 // PCINT7 interrupt: Off
; 0000 0133 // PCINT8 interrupt: Off
; 0000 0134 // PCINT9 interrupt: Off
; 0000 0135 // PCINT10 interrupt: Off
; 0000 0136 // PCINT11 interrupt: Off
; 0000 0137 // PCINT12 interrupt: Off
; 0000 0138 // PCINT13 interrupt: Off
; 0000 0139 // PCINT14 interrupt: Off
; 0000 013A // PCINT15 interrupt: Off
; 0000 013B // PCINT16 interrupt: Off
; 0000 013C // PCINT17 interrupt: Off
; 0000 013D // PCINT18 interrupt: Off
; 0000 013E // PCINT19 interrupt: Off
; 0000 013F // PCINT20 interrupt: Off
; 0000 0140 // PCINT21 interrupt: Off
; 0000 0141 // PCINT22 interrupt: Off
; 0000 0142 // PCINT23 interrupt: Off
; 0000 0143 PCMSK0=0x00;
	STS  107,R30
; 0000 0144 PCMSK1=0x00;
	STS  108,R30
; 0000 0145 PCMSK2=0x00;
	STS  109,R30
; 0000 0146 PCICR=0x00;
	STS  104,R30
; 0000 0147 
; 0000 0148 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0149 TIMSK0=0x00;
	STS  110,R30
; 0000 014A // Timer/Counter 1 Interrupt(s) initialization
; 0000 014B TIMSK1=0x00;
	STS  111,R30
; 0000 014C // Timer/Counter 2 Interrupt(s) initialization
; 0000 014D TIMSK2=0x00;
	STS  112,R30
; 0000 014E // Timer/Counter 3 Interrupt(s) initialization
; 0000 014F TIMSK3=0x00;
	STS  113,R30
; 0000 0150 // Timer/Counter 4 Interrupt(s) initialization
; 0000 0151 TIMSK4=0x00;
	STS  114,R30
; 0000 0152 // Timer/Counter 5 Interrupt(s) initialization
; 0000 0153 TIMSK5=0x00;
	STS  115,R30
; 0000 0154 
; 0000 0155 // Analog Comparator initialization
; 0000 0156 // Analog Comparator: Off
; 0000 0157 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0158 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0159 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 015A 
; 0000 015B // Determine the number of DS1820 devices
; 0000 015C // connected to the 1 Wire bus
; 0000 015D ds1820_devices=w1_search(0xf0,ds1820_rom_codes[0]);
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDI  R30,LOW(_ds1820_rom_codes)
	LDI  R31,HIGH(_ds1820_rom_codes)
	ST   -Y,R31
	ST   -Y,R30
	CALL _w1_search
	MOV  R4,R30
; 0000 015E 
; 0000 015F // LCD module initialization
; 0000 0160 lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0161 lcd_putchar(NumToIndex(ds1820_devices));
	ST   -Y,R4
	RCALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0162 
; 0000 0163     while(1){
_0x23:
; 0000 0164     // Place your code here
; 0000 0165 
; 0000 0166     }
	RJMP _0x23
; 0000 0167 }
_0x26:
	RJMP _0x26

	.CSEG
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
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
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G101:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2040001
__lcd_read_nibble_G101:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
    andi  r30,0xf0
	RET
_lcd_read_byte0_G101:
	CALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R3,Y+1
	LDD  R6,Y+0
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
	MOV  R6,R30
	MOV  R3,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	CP   R3,R5
	BRLO _0x2020004
	__lcd_putchar1:
	INC  R6
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R6
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2020004:
	INC  R3
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2040001
__long_delay_G101:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G101:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2040001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R5,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x1
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x1
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x1
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x2040001
_0x202000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2040001:
	ADIW R28,1
	RET

	.DSEG
___ds1820_scratch_pad:
	.BYTE 0x9
_ds1820_rom_codes:
	.BYTE 0x168
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101


	.CSEG
_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x3C0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x25
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xCB
	sbis __w1_port-2,__w1_bit
	inc  r30
	__DELAY_USW 0x30C
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1D
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0xD5
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x23
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xC8
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xD
	set
	ret

_w1_write:
	ldi  r22,8
	ld   r23,y+
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_search:
	push r20
	push r21
	clr  r1
	clr  r20
	ld   r26,y
	ldd  r27,y+1
__w1_search0:
	mov  r0,r1
	clr  r1
	rcall _w1_init
	tst  r30
	breq __w1_search7
	ldd  r30,y+2
	st   -y,r30
	rcall _w1_write
	ldi  r21,1
__w1_search1:
	cp   r21,r0
	brsh __w1_search6
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search2
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search3
	rcall __sel_bit
	and  r24,r25
	brne __w1_search3
	mov  r1,r21
	rjmp __w1_search3
__w1_search2:
	rcall __w1_read_bit
__w1_search3:
	rcall __sel_bit
	and  r24,r25
	ldi  r23,0
	breq __w1_search5
__w1_search4:
	ldi  r23,1
__w1_search5:
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search6:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search9
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search8
__w1_search7:
	mov  r30,r20
	pop  r21
	pop  r20
	adiw r28,3
	ret
__w1_search8:
	set
	rcall __set_bit
	rjmp __w1_search4
__w1_search9:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search10
	rjmp __w1_search11
__w1_search10:
	cp   r21,r0
	breq __w1_search12
	mov  r1,r21
__w1_search11:
	clt
	rcall __set_bit
	clr  r23
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search12:
	set
	rcall __set_bit
	ldi  r23,1
	rcall __w1_write_bit
__w1_search13:
	inc  r21
	cpi  r21,65
	brlt __w1_search1
	rcall __w1_read_bit
	rol  r30
	rol  r30
	andi r30,1
	adiw r26,8
	st   x,r30
	sbiw r26,8
	inc  r20
	tst  r1
	breq __w1_search7
	ldi  r21,9
__w1_search14:
	ld   r30,x
	adiw r26,9
	st   x,r30
	sbiw r26,8
	dec  r21
	brne __w1_search14
	rjmp __w1_search0

__sel_bit:
	mov  r30,r21
	dec  r30
	mov  r22,r30
	lsr  r30
	lsr  r30
	lsr  r30
	clr  r31
	add  r30,r26
	adc  r31,r27
	ld   r24,z
	ldi  r25,1
	andi r22,7
__sel_bit0:
	breq __sel_bit1
	lsl  r25
	dec  r22
	rjmp __sel_bit0
__sel_bit1:
	ret

__set_bit:
	rcall __sel_bit
	brts __set_bit2
	com  r25
	and  r24,r25
	rjmp __set_bit3
__set_bit2:
	or   r24,r25
__set_bit3:
	st   z,r24
	ret

;END OF CODE MARKER
__END_OF_CODE:
