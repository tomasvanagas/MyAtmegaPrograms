
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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
	.DEF _STAND_BY_TIMER=R4
	.DEF _MAIN_MENU_TIMER=R7
	.DEF _LCD_LED_TIMER=R6
	.DEF _RefreshTime=R9
	.DEF __lcd_x=R8
	.DEF __lcd_y=R11
	.DEF __lcd_maxx=R10

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

_conv_delay_G102:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G102:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF

_0x6C:
	.DB  0x1
_0x90:
	.DB  0x4
_0xB1:
	.DB  0x3C
_0xB2:
	.DB  0x0,0x0,0xA0,0x40
_0xB3:
	.DB  0x0,0x0,0x20,0x40
_0x0:
	.DB  0x2B,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2B,0x0,0x2F,0x20,0x53
	.DB  0x4F,0x4C,0x49,0x41,0x52,0x2E,0x20,0x41
	.DB  0x55,0x53,0x49,0x4E,0x49,0x4D,0x4F,0x20
	.DB  0x2F,0x0,0x2F,0x20,0x56,0x41,0x4C,0x44
	.DB  0x49,0x4B,0x4C,0x49,0x53,0x20,0x56,0x31
	.DB  0x2E,0x0,0x20,0x2F,0x2B,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2B
	.DB  0x0,0x52,0x41,0x53,0x54,0x41,0x20,0x44
	.DB  0x53,0x31,0x38,0x42,0x32,0x30,0xA,0x54
	.DB  0x45,0x52,0x4D,0x4F,0x44,0x41,0x56,0x49
	.DB  0x4B,0x4C,0x49,0x55,0x3A,0x20,0x0,0x53
	.DB  0x54,0x41,0x52,0x54,0x41,0x56,0x49,0x4D
	.DB  0x4F,0x20,0x4B,0x4C,0x41,0x49,0x44,0x41
	.DB  0x3A,0xA,0x54,0x45,0x4D,0x50,0x2E,0x20
	.DB  0x44,0x41,0x56,0x49,0x4B,0x4C,0x49,0x53
	.DB  0x0,0x2B,0x3E,0x0,0x2D,0x2D,0x3E,0x0
	.DB  0x3C,0x2B,0x0,0x3C,0x2D,0x2D,0x0,0x2B
	.DB  0x2D,0x0,0x20,0x20,0x20,0x20,0x53,0x4F
	.DB  0x4C,0x49,0x41,0x52,0x49,0x55,0x4D,0x4F
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x56,0x41,0x4C,0x44,0x49,0x4B,0x4C
	.DB  0x49,0x53,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x2D,0x3D,0x50,0x41,0x47,0x52
	.DB  0x2E,0x20,0x4D,0x45,0x4E,0x49,0x55,0x3D
	.DB  0x2D,0x0,0x31,0x2E,0x4B,0x41,0x4D,0x42
	.DB  0x41,0x52,0x49,0x4F,0x3A,0x20,0x0,0x25
	.DB  0x2B,0x32,0x2E,0x31,0x66,0xDF,0x43,0x0
	.DB  0x4F,0x46,0x46,0x0,0x2D,0x2D,0x2D,0x2D
	.DB  0x0,0x32,0x2E,0x4C,0x41,0x55,0x4B,0x4F
	.DB  0x3A,0x20,0x20,0x20,0x20,0x0,0x33,0x2E
	.DB  0x53,0x4B,0x4C,0x45,0x4E,0x44,0x45,0x53
	.DB  0x3A,0x20,0x20,0x0,0x34,0x2E,0x53,0x4F
	.DB  0x4C,0x49,0x41,0x52,0x2E,0x31,0x3A,0x20
	.DB  0x0,0x35,0x2E,0x53,0x4F,0x4C,0x49,0x41
	.DB  0x52,0x2E,0x32,0x3A,0x20,0x0,0x36,0x2E
	.DB  0x53,0x4F,0x4C,0x49,0x41,0x52,0x2E,0x33
	.DB  0x3A,0x20,0x0,0x37,0x2E,0x4E,0x55,0x53
	.DB  0x54,0x41,0x54,0x59,0x4D,0x41,0x49,0x0
	.DB  0x20,0x41,0x55,0x4B,0x53,0x54,0x45,0x53
	.DB  0x4E,0x49,0x4F,0x20,0x4E,0x55,0x4D,0x45
	.DB  0x52,0x49,0x4F,0x20,0x0,0x20,0x4C,0x41
	.DB  0x49,0x53,0x56,0x4F,0x20,0x54,0x45,0x52
	.DB  0x4D,0x4F,0x4D,0x45,0x54,0x52,0x4F,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x4E,0x45,0x52,0x41,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x2D,0x3D,0x4B,0x41,0x4D,0x42,0x41,0x52
	.DB  0x49,0x4F,0x20,0x54,0x45,0x52,0x4D,0x2E
	.DB  0x3D,0x2D,0x20,0x0,0x31,0x2E,0x55,0x5A
	.DB  0x53,0x54,0x41,0x54,0x59,0x54,0x41,0x3A
	.DB  0x0,0x32,0x2E,0x54,0x45,0x4D,0x50,0x45
	.DB  0x52,0x41,0x54,0x2E,0x3A,0x0,0x20,0x20
	.DB  0x20,0x20,0x4F,0x46,0x46,0x0,0x20,0x20
	.DB  0x20,0x2D,0x2D,0x2D,0x2D,0x0,0x33,0x2E
	.DB  0x54,0x45,0x52,0x4D,0x4F,0x4D,0x45,0x54
	.DB  0x52,0x4F,0x20,0x4E,0x52,0x3A,0x0,0x2D
	.DB  0x2F,0x0,0x20,0x20,0x2D,0x3D,0x4C,0x41
	.DB  0x55,0x4B,0x4F,0x20,0x54,0x45,0x52,0x4D
	.DB  0x2E,0x3D,0x2D,0x20,0x20,0x0,0x31,0x2E
	.DB  0x54,0x45,0x4D,0x50,0x45,0x52,0x41,0x54
	.DB  0x2E,0x3A,0x0,0x32,0x2E,0x54,0x45,0x52
	.DB  0x4D,0x4F,0x4D,0x45,0x54,0x52,0x4F,0x20
	.DB  0x4E,0x52,0x3A,0x0,0x20,0x20,0x20,0x20
	.DB  0x2D,0x3D,0x53,0x4B,0x4C,0x45,0x4E,0x44
	.DB  0x45,0x53,0x3D,0x2D,0x0,0x52,0x45,0x5A
	.DB  0x49,0x4D,0x41,0x53,0x3A,0x0,0x20,0x52
	.DB  0x41,0x4E,0x4B,0x49,0x4E,0x49,0x53,0x0
	.DB  0x20,0x41,0x55,0x54,0x4F,0x4D,0x41,0x54
	.DB  0x2E,0x0,0x2F,0x32,0x35,0x35,0x0,0x2D
	.DB  0x3D,0x53,0x4F,0x4C,0x49,0x41,0x52,0x2E
	.DB  0x20,0x31,0x20,0x54,0x45,0x52,0x4D,0x2E
	.DB  0x3D,0x2D,0x20,0x0,0x2D,0x3D,0x53,0x4F
	.DB  0x4C,0x49,0x41,0x52,0x2E,0x20,0x32,0x20
	.DB  0x54,0x45,0x52,0x4D,0x2E,0x3D,0x2D,0x20
	.DB  0x0,0x2D,0x3D,0x53,0x4F,0x4C,0x49,0x41
	.DB  0x52,0x2E,0x20,0x33,0x20,0x54,0x45,0x52
	.DB  0x4D,0x2E,0x3D,0x2D,0x20,0x0,0x20,0x20
	.DB  0x20,0x2D,0x3D,0x4E,0x55,0x53,0x54,0x41
	.DB  0x54,0x59,0x4D,0x41,0x49,0x3D,0x2D,0x20
	.DB  0x20,0x20,0x0,0x4E,0x45,0x42,0x41,0x49
	.DB  0x47,0x54,0x41,0x0,0x2D,0x3D,0x45,0x4B
	.DB  0x52,0x41,0x4E,0x4F,0x20,0x41,0x50,0x53
	.DB  0x56,0x49,0x45,0x54,0x2E,0x3D,0x2D,0x20
	.DB  0x0,0x41,0x50,0x53,0x56,0x49,0x45,0x54
	.DB  0x49,0x4D,0x41,0x53,0x3A,0x0
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2060003:
	.DB  0x80,0xC0
_0x208005F:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _STAND_BY_S0000006000
	.DW  _0x6C*2

	.DW  0x01
	.DW  _ADC_CHANNEL_S0000006001
	.DW  _0x90*2

	.DW  0x01
	.DW  _ALGORYTHM_REFRESH_TIME_S0000006001
	.DW  _0xB1*2

	.DW  0x04
	.DW  _SOLARIUM_OUTSIDE_OFFSET_S0000006001
	.DW  _0xB2*2

	.DW  0x04
	.DW  _SOLARIUM_INSIDE_OFFSET_S0000006001
	.DW  _0xB3*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x208005F*2

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
	STS  XMCRB,R30

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
	LDI  R24,LOW(0x1000)
	LDI  R25,HIGH(0x1000)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x10FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x10FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x500)
	LDI  R29,HIGH(0x500)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*******************************
;Project   : Soliariumo Valdiklis
;Version   : V1.0
;Date      : 2012.09.10
;Author    : Tomas
;Chip type : ATmega128
;*******************************/
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <math.h>
;#include <stdio.h>
;/*
;unsigned char PORTF_data[8];
;unsigned char PORTFEx(unsigned char adress_bit, unsigned char value){
;unsigned char data, i, a;
;data = 0;
;PORTF_data[adress_bit] = value;
;
;a = 1;
;    for(i=0;i<8;i++){
;    data += PORTF_data[adress_bit]*a;
;    a = a*2;
;    }
;
;PORTF = data;
;return 0;
;}
;unsigned char PINFEx(char adress_bit){
;unsigned char data, bits[8], a, b;
;signed char i;
;data = PINF;
;
;    for(i=7;i>=0;i--){
;    b = 1;
;        for(a=0;a<7;a++){
;        b = b*2;
;        }
;
;        if(data>=b){
;        bits[i] = 1;
;        data -= b;
;        }
;        else{
;        bits[i] = 0;
;        }
;    }
;return bits[adress_bit];
;}
;*/
;
;/*unsigned char PORTG_data[5];
;unsigned char PORTGEx(unsigned char adress_bit, unsigned char value){
;unsigned char data, i, a;
;data = 0;
;PORTG_data[adress_bit] = value;
;
;a = 1;
;    for(i=0;i<5;i++){
;    data += PORTG_data[adress_bit]*a;
;    a = a*2;
;    }
;
;PORTG = data;
;return 0;
;}*/
;
;unsigned char PINGEx(char adress_bit){
; 0000 0043 unsigned char PINGEx(char adress_bit){

	.CSEG
_PINGEx:
; 0000 0044 unsigned char data, bits[5], a, b;
; 0000 0045 signed char i;
; 0000 0046 data = PING;
	SBIW R28,5
	CALL __SAVELOCR4
;	adress_bit -> Y+9
;	data -> R17
;	bits -> Y+4
;	a -> R16
;	b -> R19
;	i -> R18
	LDS  R17,99
; 0000 0047 
; 0000 0048     for(i=4;i>=0;i--){
	LDI  R18,LOW(4)
_0x4:
	CPI  R18,0
	BRLT _0x5
; 0000 0049     b = 1;
	LDI  R19,LOW(1)
; 0000 004A         for(a=0;a<i;a++){
	LDI  R16,LOW(0)
_0x7:
	MOV  R30,R18
	MOV  R26,R16
	CALL SUBOPT_0x0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x8
; 0000 004B         b = b*2;
	LSL  R19
; 0000 004C         }
	SUBI R16,-1
	RJMP _0x7
_0x8:
; 0000 004D 
; 0000 004E         if(data>=b){
	CP   R17,R19
	BRLO _0x9
; 0000 004F         bits[i] = 1;
	CALL SUBOPT_0x1
	LDI  R30,LOW(1)
	ST   X,R30
; 0000 0050         data -= b;
	MOV  R26,R17
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL SUBOPT_0x2
	MOV  R17,R30
; 0000 0051         }
; 0000 0052         else{
	RJMP _0xA
_0x9:
; 0000 0053         bits[i] = 0;
	CALL SUBOPT_0x1
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0054         }
_0xA:
; 0000 0055     }
	SUBI R18,1
	RJMP _0x4
_0x5:
; 0000 0056 return bits[adress_bit];
	LDD  R30,Y+9
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CALL __LOADLOCR4
	ADIW R28,10
	RET
; 0000 0057 }
;
;
;
;
;
;
;
;
;
;// Temperature sensors
;#asm
   .equ __w1_port=0x12 //PORTD
   .equ __w1_bit=0
; 0000 0065 #endasm
;#include <ds18b20.h>
;
;#define MAX_DS18B20_DEVICES 8
;
;eeprom unsigned char DS18B20_IS_ASSIGNED[MAX_DS18B20_DEVICES];
;// 1. Assigned and turned on
;// 2. Assigned but turned off
;// X. Not assigned
;
;eeprom unsigned char DS18B20_ADDRESSES[MAX_DS18B20_DEVICES][9];
;// 0. Kambario temperaturos daviklis
;// 1. Lauko temperaturos daviklis
;// 2. Pirmojo soliariumo temperaturos daviklis
;// 3. Antrojo soliariumo temperaturos daviklis
;// 4. Treciojo soliariumo temperaturos daviklis
;// 5. Papildomas kambario temperaturos daviklis
;
;float TEMPERATURES[MAX_DS18B20_DEVICES];
;eeprom float ROOM_TEMPERATURE;
;///////////////////////////////////
;
;
;
;
;
;
;
;
;///////////// BUTTONS /////////////
;// PINS
;#define BUTTON_UP 0
;#define BUTTON_LEFT 1
;#define BUTTON_ENTER 2
;#define BUTTON_RIGHT 3
;#define BUTTON_DOWN 4
;///////////////////////////////////
;
;
;
;
;
;/*
;unsigned char OUTPUT(unsigned char address, unsigned char value){
;    if(address==3){
;    PORTB.4 = value;
;    return 1;
;    }
;    else if(address==4){
;    PORTB.5 = value;
;    return 1;
;    }
;    else if(address==5){
;    PORTB.6 = value;
;    return 1;
;    }
;    else if(address==6){
;    PORTB.7 = value;
;    return 1;
;    }
;    else if(address==7){
;//    PORTGEx(4,value);
;    return 1;
;    }
;    else if(address==8){
;//    PORTGEx(3,value);
;    return 1;
;    }
;    else if(address==9){
;    PORTA.0 = value;
;    return 1;
;    }
;    else if(address==10){
;    PORTA.1 = value;
;    return 1;
;    }
;    else if(address==11){
;    PORTA.2 = value;
;    return 1;
;    }
;    else if(address==12){
;    PORTA.7 = value;
;    return 1;
;    }
;    else if(address==13){
;    PORTA.5 = value;
;    return 1;
;    }
;    else if(address==14){
;    PORTA.3 = value;
;    return 1;
;    }
;    else if(address==15){
;    PORTA.4 = value;
;    return 1;
;    }
;    else if(address==16){
;    PORTA.6 = value;
;    return 1;
;    }
;return 0;
;}
;*/
;
;
;
;
;unsigned char BUTTON_INPUT(unsigned char input){
; 0000 00D0 unsigned char BUTTON_INPUT(unsigned char input){
_BUTTON_INPUT:
; 0000 00D1     if(input==0){   return PINGEx(1);  }
;	input -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0xB
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _PINGEx
	RJMP _0x20E000B
; 0000 00D2     if(input==1){   return PINGEx(0);  }
_0xB:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0xC
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _PINGEx
	RJMP _0x20E000B
; 0000 00D3     if(input==2){   return PINC.0;  }
_0xC:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0xD
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	RJMP _0x20E000B
; 0000 00D4     if(input==3){   return PINC.2;  }
_0xD:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0xE
	LDI  R30,0
	SBIC 0x13,2
	LDI  R30,1
	RJMP _0x20E000B
; 0000 00D5     if(input==4){   return PINC.1;  }
_0xE:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xF
	LDI  R30,0
	SBIC 0x13,1
	LDI  R30,1
	RJMP _0x20E000B
; 0000 00D6 return 0;
_0xF:
	RJMP _0x20E000C
; 0000 00D7 }
;
;
;
;#define SOLARIUM1_AT_WORK PORTD.1
;#define SOLARIUM2_AT_WORK PORTD.2
;#define SOLARIUM3_AT_WORK PORTD.3
;
;
;
;
;// Neveiklumo taimeriai
;unsigned int STAND_BY_TIMER;
;unsigned char MAIN_MENU_TIMER,LCD_LED_TIMER;
;
;eeprom unsigned char MANUAL_CONTROLLER;
;//eeprom unsigned char VALVES[4];
;unsigned char dac_data[4];
;#define ADC_VREF_TYPE 0x20
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input){
; 0000 00ED unsigned char read_adc(unsigned char adc_input){
_read_adc:
; 0000 00EE ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 00EF // Delay needed for the stabilization of the ADC input voltage
; 0000 00F0 delay_us(10);
	__DELAY_USB 27
; 0000 00F1 // Start the AD conversion
; 0000 00F2 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 00F3 // Wait for the AD conversion to complete
; 0000 00F4 while ((ADCSRA & 0x10)==0);
_0x10:
	SBIS 0x6,4
	RJMP _0x10
; 0000 00F5 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 00F6 return ADCH;
	IN   R30,0x5
	RJMP _0x20E000B
; 0000 00F7 }
;
;
;
;
;// Other
;char RefreshTime;
;
;//////////// Mygtukai /////////////
;#define ButtonFiltrationTimer 10 // x*cycle (cycle~1ms)
;///////////////////////////////////
;
;
;
;//-----------------------------------------------------------------------------------//
;//--------------------------------- Lcd System --------------------------------------//
;//-----------------------------------------------------------------------------------//
;#define LCD_LED PORTB.0
;
;static unsigned char RowsOnWindow;
;static unsigned char Address[6];
;static unsigned char SelectedRow;
;static unsigned char RefreshLcd;
;static unsigned char lcd_light_osc;
;static unsigned char lcd_light_now;
;eeprom unsigned char lcd_light;
;
;#asm
   .equ __lcd_port=0x03 ;PORTE
; 0000 0114 #endasm
;#include <lcd.h>
;
;/*// Ekrano apsvietimas
;//interrupt [TIM0_OVF] void timer0_ovf_isr(void){
;lcd_light_osc += 1;
;    if(lcd_light_osc>=100){
;    lcd_light_osc = 0;
;    }
;
;    if(lcd_light_now>lcd_light_osc){
;    LCD_LED = 1;
;    }
;    else{
;    LCD_LED = 0;
;    }
;//}*/
;
;/*
;unsigned char lcd_cursor(unsigned char x, unsigned char y){
;lcd_gotoxy(x,y);
;_lcd_ready();
;_lcd_write_data(0xe);
;return 1;
;}
;*/
;
;unsigned char SelectAnotherRow(char up_down){
; 0000 012F unsigned char SelectAnotherRow(char up_down){
_SelectAnotherRow:
; 0000 0130 // 0 - down
; 0000 0131 // 1 - up
; 0000 0132     if(up_down==0){
;	up_down -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x13
; 0000 0133         if(SelectedRow<RowsOnWindow-1){
	LDS  R30,_RowsOnWindow_G000
	CALL SUBOPT_0x3
	LDS  R26,_SelectedRow_G000
	CALL SUBOPT_0x4
	BRGE _0x14
; 0000 0134         SelectedRow++;
	LDS  R30,_SelectedRow_G000
	SUBI R30,-LOW(1)
	STS  _SelectedRow_G000,R30
; 0000 0135             if(Address[5]+3<SelectedRow){
	CALL SUBOPT_0x5
	ADIW R30,3
	MOVW R26,R30
	LDS  R30,_SelectedRow_G000
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x15
; 0000 0136             Address[5] = SelectedRow - 3;
	LDS  R30,_SelectedRow_G000
	LDI  R31,0
	SBIW R30,3
	__PUTB1MN _Address_G000,5
; 0000 0137             }
; 0000 0138         return 1;
_0x15:
	LDI  R30,LOW(1)
	RJMP _0x20E000B
; 0000 0139         }
; 0000 013A     }
_0x14:
; 0000 013B     else{
	RJMP _0x16
_0x13:
; 0000 013C         if(SelectedRow>0){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRLO _0x17
; 0000 013D         SelectedRow--;
	LDS  R30,_SelectedRow_G000
	SUBI R30,LOW(1)
	STS  _SelectedRow_G000,R30
; 0000 013E             if(Address[5]>SelectedRow){
	__GETB2MN _Address_G000,5
	CP   R30,R26
	BRSH _0x18
; 0000 013F             Address[5] = SelectedRow;
	__PUTB1MN _Address_G000,5
; 0000 0140             }
; 0000 0141         return 1;
_0x18:
	LDI  R30,LOW(1)
	RJMP _0x20E000B
; 0000 0142         }
; 0000 0143     }
_0x17:
_0x16:
; 0000 0144 return 0;
	RJMP _0x20E000C
; 0000 0145 }
;
;unsigned char NumToIndex(char Num){
; 0000 0147 unsigned char NumToIndex(char Num){
_NumToIndex:
; 0000 0148     if(Num==0){     return '0';}
;	Num -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x19
	LDI  R30,LOW(48)
	RJMP _0x20E000B
; 0000 0149     else if(Num==1){return '1';}
_0x19:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x1B
	LDI  R30,LOW(49)
	RJMP _0x20E000B
; 0000 014A     else if(Num==2){return '2';}
_0x1B:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x1D
	LDI  R30,LOW(50)
	RJMP _0x20E000B
; 0000 014B     else if(Num==3){return '3';}
_0x1D:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x1F
	LDI  R30,LOW(51)
	RJMP _0x20E000B
; 0000 014C     else if(Num==4){return '4';}
_0x1F:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x21
	LDI  R30,LOW(52)
	RJMP _0x20E000B
; 0000 014D     else if(Num==5){return '5';}
_0x21:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x23
	LDI  R30,LOW(53)
	RJMP _0x20E000B
; 0000 014E     else if(Num==6){return '6';}
_0x23:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x25
	LDI  R30,LOW(54)
	RJMP _0x20E000B
; 0000 014F     else if(Num==7){return '7';}
_0x25:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x27
	LDI  R30,LOW(55)
	RJMP _0x20E000B
; 0000 0150     else if(Num==8){return '8';}
_0x27:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x29
	LDI  R30,LOW(56)
	RJMP _0x20E000B
; 0000 0151     else if(Num==9){return '9';}
_0x29:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x2B
	LDI  R30,LOW(57)
	RJMP _0x20E000B
; 0000 0152     else{           return '-';}
_0x2B:
	LDI  R30,LOW(45)
	RJMP _0x20E000B
; 0000 0153 return 0;
_0x20E000C:
	LDI  R30,LOW(0)
_0x20E000B:
	ADIW R28,1
	RET
; 0000 0154 }
;
;unsigned char lcd_put_number(char Type, char Lenght, char IsSign,
; 0000 0157 
; 0000 0158                     char NumbersAfterDot,
; 0000 0159 
; 0000 015A                     unsigned long int Number0,
; 0000 015B                     signed long int Number1){
_lcd_put_number:
; 0000 015C     if(Lenght>0){
;	Type -> Y+11
;	Lenght -> Y+10
;	IsSign -> Y+9
;	NumbersAfterDot -> Y+8
;	Number0 -> Y+4
;	Number1 -> Y+0
	LDD  R26,Y+10
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x2D
; 0000 015D     unsigned long int k = 1;
; 0000 015E     unsigned char i;
; 0000 015F         for(i=0;i<Lenght-1;i++) k = k*10;
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
_0x2F:
	LDD  R30,Y+15
	CALL SUBOPT_0x3
	LD   R26,Y
	CALL SUBOPT_0x4
	BRGE _0x30
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x2F
_0x30:
; 0000 0161 if(Type==0){
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x31
; 0000 0162         unsigned long int a;
; 0000 0163         unsigned char b;
; 0000 0164         a = Number0;
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
	CALL SUBOPT_0x8
; 0000 0165 
; 0000 0166             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x32
; 0000 0167             lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0168             }
; 0000 0169 
; 0000 016A             if(a<0){
_0x32:
	CALL SUBOPT_0x9
; 0000 016B             a = a*(-1);
; 0000 016C             }
; 0000 016D 
; 0000 016E             if(k*10<a){
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	BRSH _0x34
; 0000 016F             a = k*10 - 1;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC
; 0000 0170             }
; 0000 0171 
; 0000 0172             for(i=0;i<Lenght;i++){
_0x34:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x36:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0x37
; 0000 0173                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x38
; 0000 0174                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0xD
	BRNE _0x39
; 0000 0175                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0176                     }
; 0000 0177                 }
_0x39:
; 0000 0178             b = a/k;
_0x38:
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
; 0000 0179             lcd_putchar( NumToIndex( b ) );
; 0000 017A             a = a - b*k;
; 0000 017B             k = k/10;
; 0000 017C             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x36
_0x37:
; 0000 017D         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x20E000A
; 0000 017E         }
; 0000 017F 
; 0000 0180         else if(Type==1){
_0x31:
	LDD  R26,Y+16
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x3B
; 0000 0181         signed long int a;
; 0000 0182         unsigned char b;
; 0000 0183         a = Number1;
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
	CALL SUBOPT_0x10
	CALL SUBOPT_0x8
; 0000 0184 
; 0000 0185             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x3C
; 0000 0186                 if(a>=0){
	LDD  R26,Y+4
	TST  R26
	BRMI _0x3D
; 0000 0187                 lcd_putchar('+');
	LDI  R30,LOW(43)
	RJMP _0x2E4
; 0000 0188                 }
; 0000 0189                 else{
_0x3D:
; 0000 018A                 lcd_putchar('-');
	LDI  R30,LOW(45)
_0x2E4:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 018B                 }
; 0000 018C             }
; 0000 018D 
; 0000 018E             if(a<0){
_0x3C:
	LDD  R26,Y+4
	TST  R26
	BRPL _0x3F
; 0000 018F             a = a*(-1);
	CALL SUBOPT_0x6
	__GETD2N 0xFFFFFFFF
	CALL __MULD12
	CALL SUBOPT_0x8
; 0000 0190             }
; 0000 0191 
; 0000 0192             if(k*10<a){
_0x3F:
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	BRSH _0x40
; 0000 0193             a = k*10 - 1;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC
; 0000 0194             }
; 0000 0195 
; 0000 0196             for(i=0;i<Lenght;i++){
_0x40:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x42:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0x43
; 0000 0197                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x44
; 0000 0198                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0xD
	BRNE _0x45
; 0000 0199                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 019A                     }
; 0000 019B                 }
_0x45:
; 0000 019C             b = a/k;
_0x44:
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
; 0000 019D             lcd_putchar( NumToIndex( b ) );
; 0000 019E             a = a - b*k;
; 0000 019F             k = k/10;
; 0000 01A0             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x42
_0x43:
; 0000 01A1         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x20E000A
; 0000 01A2         }
; 0000 01A3     }
_0x3B:
	ADIW R28,5
; 0000 01A4 return 0;
_0x2D:
	LDI  R30,LOW(0)
_0x20E000A:
	ADIW R28,12
	RET
; 0000 01A5 }
;
;/*
;unsigned char lcd_put_runing_text(   unsigned char Start_x,
;                            unsigned char Start_y,
;
;                            unsigned int Lenght,
;                            unsigned int Position,
;
;                            char flash *str,
;                            unsigned int StrLenght){
;signed int i,a;
;lcd_gotoxy(Start_x,Start_y);
;
;    for(i=0;i<Lenght;i++){
;    a = i + Position - Lenght;
;        if(a>=0){
;            if(a<StrLenght){
;            lcd_putchar(str[a]);
;            }
;            else{
;                if(i==0){
;                return 1;
;                }
;            }
;        }
;        else{
;        lcd_putchar(' ');
;        }
;    }
;return 0;
;}
;*/
;
;//-----------------------------------------------------------------------------------//
;//-----------------------------------------------------------------------------------//
;//-----------------------------------------------------------------------------------//
;
;void main(void){
; 0000 01CB void main(void){
_main:
; 0000 01CC // Declare your local variables here
; 0000 01CD 
; 0000 01CE // Input/Output Ports initialization
; 0000 01CF // Port A initialization
; 0000 01D0 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01D1 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 01D2 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01D3 DDRA=0x00;
	OUT  0x1A,R30
; 0000 01D4 
; 0000 01D5 // Port B initialization
; 0000 01D6 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=Out
; 0000 01D7 // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=0
; 0000 01D8 PORTB=0x00;
	OUT  0x18,R30
; 0000 01D9 DDRB=0xF1;
	LDI  R30,LOW(241)
	OUT  0x17,R30
; 0000 01DA 
; 0000 01DB // Port C initialization
; 0000 01DC // Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 01DD // State7=T State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T
; 0000 01DE PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01DF DDRC=0b01111000;
	LDI  R30,LOW(120)
	OUT  0x14,R30
; 0000 01E0 
; 0000 01E1 // Port D initialization
; 0000 01E2 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01E3 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01E4 PORTD=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01E5 DDRD=0b00000000;
	OUT  0x11,R30
; 0000 01E6 
; 0000 01E7 // Port E initialization
; 0000 01E8 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01E9 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01EA PORTE=0x00;
	OUT  0x3,R30
; 0000 01EB DDRE=0x00;
	OUT  0x2,R30
; 0000 01EC 
; 0000 01ED // Port F initialization
; 0000 01EE // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01EF // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01F0 PORTF=0x00;
	STS  98,R30
; 0000 01F1 DDRF=0x00;
	STS  97,R30
; 0000 01F2 
; 0000 01F3 // Port G initialization
; 0000 01F4 // Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 01F5 // State4=0 State3=0 State2=T State1=T State0=T
; 0000 01F6 PORTG=0x00;
	STS  101,R30
; 0000 01F7 //DDRG=0x18;
; 0000 01F8 DDRG=0x00;
	STS  100,R30
; 0000 01F9 
; 0000 01FA // Timer/Counter 0 initialization
; 0000 01FB // Clock source: System Clock
; 0000 01FC // Clock value: Timer 0 Stopped
; 0000 01FD // Mode: Normal top=FFh
; 0000 01FE // OC0 output: Disconnected
; 0000 01FF ASSR=0x00;
	OUT  0x30,R30
; 0000 0200 TCCR0=0x00;
	OUT  0x33,R30
; 0000 0201 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0202 OCR0=0x00;
	OUT  0x31,R30
; 0000 0203 
; 0000 0204 /// Timer/Counter 0 initialization
; 0000 0205 // Clock source: System Clock
; 0000 0206 // Clock value: 1000.000 kHz
; 0000 0207 // Mode: Normal top=FFh
; 0000 0208 // OC0 output: Disconnected
; 0000 0209 //TCCR0=0x02;
; 0000 020A //TCNT0=0x00;
; 0000 020B //OCR0=0x00;
; 0000 020C 
; 0000 020D 
; 0000 020E 
; 0000 020F // Timer/Counter 1 initialization
; 0000 0210 // Clock source: System Clock
; 0000 0211 // Clock value: Timer1 Stopped
; 0000 0212 // Mode: Normal top=FFFFh
; 0000 0213 // OC1A output: Discon.
; 0000 0214 // OC1B output: Discon.
; 0000 0215 // OC1C output: Discon.
; 0000 0216 // Noise Canceler: Off
; 0000 0217 // Input Capture on Falling Edge
; 0000 0218 // Timer1 Overflow Interrupt: Off
; 0000 0219 // Input Capture Interrupt: Off
; 0000 021A // Compare A Match Interrupt: Off
; 0000 021B // Compare B Match Interrupt: Off
; 0000 021C // Compare C Match Interrupt: Off
; 0000 021D TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 021E TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 021F TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0220 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0221 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0222 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0223 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0224 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0225 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0226 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0227 OCR1CH=0x00;
	STS  121,R30
; 0000 0228 OCR1CL=0x00;
	STS  120,R30
; 0000 0229 
; 0000 022A // Timer/Counter 2 initialization
; 0000 022B // Clock source: System Clock
; 0000 022C // Clock value: Timer2 Stopped
; 0000 022D // Mode: Normal top=FFh
; 0000 022E // OC2 output: Disconnected
; 0000 022F TCCR2=0x00;
	OUT  0x25,R30
; 0000 0230 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0231 OCR2=0x00;
	OUT  0x23,R30
; 0000 0232 
; 0000 0233 // Timer/Counter 3 initialization
; 0000 0234 // Clock source: System Clock
; 0000 0235 // Clock value: Timer3 Stopped
; 0000 0236 // Mode: Normal top=FFFFh
; 0000 0237 // OC3A output: Discon.
; 0000 0238 // OC3B output: Discon.
; 0000 0239 // OC3C output: Discon.
; 0000 023A // Noise Canceler: Off
; 0000 023B // Input Capture on Falling Edge
; 0000 023C // Timer3 Overflow Interrupt: Off
; 0000 023D // Input Capture Interrupt: Off
; 0000 023E // Compare A Match Interrupt: Off
; 0000 023F // Compare B Match Interrupt: Off
; 0000 0240 // Compare C Match Interrupt: Off
; 0000 0241 TCCR3A=0x00;
	STS  139,R30
; 0000 0242 TCCR3B=0x00;
	STS  138,R30
; 0000 0243 TCNT3H=0x00;
	STS  137,R30
; 0000 0244 TCNT3L=0x00;
	STS  136,R30
; 0000 0245 ICR3H=0x00;
	STS  129,R30
; 0000 0246 ICR3L=0x00;
	STS  128,R30
; 0000 0247 OCR3AH=0x00;
	STS  135,R30
; 0000 0248 OCR3AL=0x00;
	STS  134,R30
; 0000 0249 OCR3BH=0x00;
	STS  133,R30
; 0000 024A OCR3BL=0x00;
	STS  132,R30
; 0000 024B OCR3CH=0x00;
	STS  131,R30
; 0000 024C OCR3CL=0x00;
	STS  130,R30
; 0000 024D 
; 0000 024E // External Interrupt(s) initialization
; 0000 024F // INT0: Off
; 0000 0250 // INT1: Off
; 0000 0251 // INT2: Off
; 0000 0252 // INT3: Off
; 0000 0253 // INT4: Off
; 0000 0254 // INT5: Off
; 0000 0255 // INT6: Off
; 0000 0256 // INT7: Off
; 0000 0257 EICRA=0x00;
	STS  106,R30
; 0000 0258 EICRB=0x00;
	OUT  0x3A,R30
; 0000 0259 EIMSK=0x00;
	OUT  0x39,R30
; 0000 025A 
; 0000 025B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 025C TIMSK=0x00;
	OUT  0x37,R30
; 0000 025D ETIMSK=0x00;
	STS  125,R30
; 0000 025E 
; 0000 025F // Analog Comparator initialization
; 0000 0260 // Analog Comparator: Off
; 0000 0261 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0262 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0263 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0264 
; 0000 0265 // ADC initialization
; 0000 0266 // ADC Clock frequency: 1000.000 kHz
; 0000 0267 // ADC Voltage Reference: AVCC pin
; 0000 0268 // Only the 8 most significant bits of
; 0000 0269 // the AD conversion result are used
; 0000 026A ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 026B ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 026C 
; 0000 026D // Watchdog Timer initialization
; 0000 026E // Watchdog Timer Prescaler: OSC/128k
; 0000 026F //#pragma optsize-
; 0000 0270 //WDTCR=0x1B;
; 0000 0271 //WDTCR=0x0B;
; 0000 0272 //#ifdef _OPTIMIZE_SIZE_
; 0000 0273 //#pragma optsize+
; 0000 0274 //#endif
; 0000 0275 
; 0000 0276 // Global enable interrupts
; 0000 0277 //#asm("sei")                // del ds18b20 isjungtas
; 0000 0278 
; 0000 0279 delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 027A LCD_LED = 1;
	SBI  0x18,0
; 0000 027B 
; 0000 027C // LCD module initialization
; 0000 027D lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 027E //LCD_LED_TIMER = 30; lcd_light_now = lcd_light;
; 0000 027F lcd_putsf("+------------------+");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x12
; 0000 0280 lcd_putsf("/ SOLIAR. AUSINIMO /");
	__POINTW1FN _0x0,21
	CALL SUBOPT_0x12
; 0000 0281 lcd_putsf("/ VALDIKLIS V1.");
	__POINTW1FN _0x0,42
	CALL SUBOPT_0x12
; 0000 0282 lcd_put_number(0,3,0,0,__BUILD__,0);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	__GETD1N 0x144
	CALL SUBOPT_0x15
; 0000 0283 lcd_putsf(" /+------------------+");
	__POINTW1FN _0x0,58
	CALL SUBOPT_0x12
; 0000 0284 delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 0285 lcd_light_now = 20;
	LDI  R30,LOW(20)
	STS  _lcd_light_now_G000,R30
; 0000 0286 
; 0000 0287 //dac_data[0] = VALVES[0];
; 0000 0288 //dac_data[1] = VALVES[1];
; 0000 0289 //dac_data[2] = VALVES[2];
; 0000 028A //dac_data[3] = VALVES[3];
; 0000 028B 
; 0000 028C dac_data[0] = 0;
	CALL SUBOPT_0x16
; 0000 028D dac_data[1] = 255;
; 0000 028E dac_data[2] = 255;
; 0000 028F dac_data[3] = 255;
; 0000 0290 
; 0000 0291 // Default values
; 0000 0292     if(1){
; 0000 0293     unsigned char i;
; 0000 0294         for(i=0;i<MAX_DS18B20_DEVICES;i++){if(DS18B20_IS_ASSIGNED[i]>2){DS18B20_IS_ASSIGNED[i] = 0;}}
	SBIW R28,1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0x4A:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x4B
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3)
	BRLO _0x4C
	CALL SUBOPT_0x17
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
_0x4C:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x4A
_0x4B:
; 0000 0295         if(lcd_light>100){lcd_light = 100;}
	CALL SUBOPT_0x18
	CPI  R30,LOW(0x65)
	BRLO _0x4D
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	LDI  R30,LOW(100)
	CALL __EEPROMWRB
; 0000 0296         if((ROOM_TEMPERATURE<10.0)||(ROOM_TEMPERATURE>30.0)){ROOM_TEMPERATURE = 20.0;}
_0x4D:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	BRLO _0x4F
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	BREQ PC+4
	BRCS PC+3
	JMP  _0x4F
	RJMP _0x4E
_0x4F:
	LDI  R26,LOW(_ROOM_TEMPERATURE)
	LDI  R27,HIGH(_ROOM_TEMPERATURE)
	__GETD1N 0x41A00000
	CALL __EEPROMWRD
; 0000 0297     }
_0x4E:
	ADIW R28,1
; 0000 0298 
; 0000 0299 // DS18B20 temperature sensors
; 0000 029A static unsigned char ds18b20_devices;
; 0000 029B static unsigned char rom_code[MAX_DS18B20_DEVICES][9];
; 0000 029C static unsigned char ds18b20_sensor_assignation[MAX_DS18B20_DEVICES];
; 0000 029D     if(1){
; 0000 029E     unsigned char i, j;
; 0000 029F         for(i=0;i<MAX_DS18B20_DEVICES;i++){ds18b20_sensor_assignation[i] = 255;}
	SBIW R28,2
;	i -> Y+1
;	j -> Y+0
	LDI  R30,LOW(0)
	STD  Y+1,R30
_0x53:
	LDD  R26,Y+1
	CPI  R26,LOW(0x8)
	BRSH _0x54
	CALL SUBOPT_0x1C
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x53
_0x54:
; 0000 02A0 
; 0000 02A1     ds18b20_devices = w1_search(0xf0,rom_code);
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDI  R30,LOW(_rom_code_S0000006000)
	LDI  R31,HIGH(_rom_code_S0000006000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _w1_search
	STS  _ds18b20_devices_S0000006000,R30
; 0000 02A2 
; 0000 02A3 
; 0000 02A4         if(ds18b20_devices>=1){
	LDS  R26,_ds18b20_devices_S0000006000
	CPI  R26,LOW(0x1)
	BRLO _0x55
; 0000 02A5         lcd_clear();
	CALL _lcd_clear
; 0000 02A6         lcd_gotoxy(0,1);
	CALL SUBOPT_0x1D
; 0000 02A7         lcd_putsf("RASTA DS18B20\nTERMODAVIKLIU: ");
	__POINTW1FN _0x0,81
	CALL SUBOPT_0x12
; 0000 02A8         lcd_putchar(NumToIndex(ds18b20_devices));
	LDS  R30,_ds18b20_devices_S0000006000
	CALL SUBOPT_0x1E
; 0000 02A9         delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 02AA         }
; 0000 02AB 
; 0000 02AC         for(i=0;i<MAX_DS18B20_DEVICES;i++){
_0x55:
	LDI  R30,LOW(0)
	STD  Y+1,R30
_0x57:
	LDD  R26,Y+1
	CPI  R26,LOW(0x8)
	BRSH _0x58
; 0000 02AD             if(DS18B20_IS_ASSIGNED[i]==1){
	CALL SUBOPT_0x1F
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x59
; 0000 02AE             DS18B20_IS_ASSIGNED[i] = 2;
	CALL SUBOPT_0x1F
	LDI  R30,LOW(2)
	CALL __EEPROMWRB
; 0000 02AF             ds18b20_sensor_assignation[i] = 255;
	CALL SUBOPT_0x1C
; 0000 02B0             }
; 0000 02B1         }
_0x59:
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x57
_0x58:
; 0000 02B2 
; 0000 02B3         for(i=0;i<ds18b20_devices;i++){
	LDI  R30,LOW(0)
	STD  Y+1,R30
_0x5B:
	CALL SUBOPT_0x20
	BRLO PC+3
	JMP _0x5C
; 0000 02B4         unsigned char Found = 0;
; 0000 02B5 
; 0000 02B6             if(!ds18b20_init(&rom_code[i][0],-55,128,DS18B20_12BIT_RES)){
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	i -> Y+2
;	j -> Y+1
;	Found -> Y+0
	LDD  R30,Y+2
	CALL SUBOPT_0x21
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(201)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _ds18b20_init
	CPI  R30,0
	BRNE _0x5D
; 0000 02B7             lcd_clear();
	CALL _lcd_clear
; 0000 02B8             lcd_putsf("STARTAVIMO KLAIDA:\nTEMP. DAVIKLIS");
	__POINTW1FN _0x0,111
	CALL SUBOPT_0x12
; 0000 02B9                 while(1){
_0x5E:
; 0000 02BA                 delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x22
; 0000 02BB                 }
	RJMP _0x5E
; 0000 02BC             }
; 0000 02BD 
; 0000 02BE             for(j=0;j<MAX_DS18B20_DEVICES;j++){
_0x5D:
	LDI  R30,LOW(0)
	STD  Y+1,R30
_0x62:
	LDD  R26,Y+1
	CPI  R26,LOW(0x8)
	BRLO PC+3
	JMP _0x63
; 0000 02BF                 if(DS18B20_IS_ASSIGNED[j]==2){
	CALL SUBOPT_0x1F
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x64
; 0000 02C0                 unsigned char a, Match = 1;
; 0000 02C1 
; 0000 02C2                     for(a=0;a<9;a++){
	SBIW R28,2
	LDI  R30,LOW(1)
	ST   Y,R30
;	i -> Y+4
;	j -> Y+3
;	Found -> Y+2
;	a -> Y+1
;	Match -> Y+0
	LDI  R30,LOW(0)
	STD  Y+1,R30
_0x66:
	LDD  R26,Y+1
	CPI  R26,LOW(0x9)
	BRSH _0x67
; 0000 02C3                         if(rom_code[i][a]!=DS18B20_ADDRESSES[j][a]){
	LDD  R30,Y+4
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	LD   R22,X
	LDD  R30,Y+3
	CALL SUBOPT_0x24
	CALL SUBOPT_0x23
	CALL __EEPROMRDB
	CP   R30,R22
	BREQ _0x68
; 0000 02C4                         Match = 0;
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 02C5                         break;
	RJMP _0x67
; 0000 02C6                         }
; 0000 02C7                     }
_0x68:
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x66
_0x67:
; 0000 02C8 
; 0000 02C9                     if(Match==1){
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x69
; 0000 02CA                         if(Found==0){
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x6A
; 0000 02CB                         ds18b20_sensor_assignation[j] = i;
	LDD  R30,Y+3
	CALL SUBOPT_0x25
	LDD  R26,Y+4
	STD  Z+0,R26
; 0000 02CC                         DS18B20_IS_ASSIGNED[j] = 1;
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
; 0000 02CD                         Found = 1;
	STD  Y+2,R30
; 0000 02CE                         }
; 0000 02CF                         else{
	RJMP _0x6B
_0x6A:
; 0000 02D0                         DS18B20_IS_ASSIGNED[j] = 255;
	CALL SUBOPT_0x26
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
; 0000 02D1                         }
_0x6B:
; 0000 02D2                     }
; 0000 02D3                 }
_0x69:
	ADIW R28,2
; 0000 02D4             }
_0x64:
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x62
_0x63:
; 0000 02D5         }
	ADIW R28,1
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x5B
_0x5C:
; 0000 02D6     }
	ADIW R28,2
; 0000 02D7 ///////////////////////////////
; 0000 02D8 
; 0000 02D9 
; 0000 02DA 
; 0000 02DB static unsigned char STAND_BY = 1;

	.DSEG

	.CSEG
; 0000 02DC 
; 0000 02DD     while (1){
_0x6D:
; 0000 02DE 
; 0000 02DF     //////////////////////////////////////////////////////////////////////////////////
; 0000 02E0     //////////////////////////// Funkcija kas 1 secunde //////////////////////////////
; 0000 02E1     //////////////////////////////////////////////////////////////////////////////////
; 0000 02E2     static unsigned int SecondCounter;
; 0000 02E3     SecondCounter++;
	LDI  R26,LOW(_SecondCounter_S0000006001)
	LDI  R27,HIGH(_SecondCounter_S0000006001)
	CALL SUBOPT_0x28
; 0000 02E4         if(SecondCounter>=500){
	LDS  R26,_SecondCounter_S0000006001
	LDS  R27,_SecondCounter_S0000006001+1
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0x70
; 0000 02E5         SecondCounter = 0;
	LDI  R30,LOW(0)
	STS  _SecondCounter_S0000006001,R30
	STS  _SecondCounter_S0000006001+1,R30
; 0000 02E6         RefreshTime++;
	INC  R9
; 0000 02E7         }
; 0000 02E8 
; 0000 02E9     static unsigned char TimeRefreshed;
_0x70:
; 0000 02EA         if(RefreshTime>=1){
	LDI  R30,LOW(1)
	CP   R9,R30
	BRLO _0x71
; 0000 02EB         TimeRefreshed = 1;
	STS  _TimeRefreshed_S0000006001,R30
; 0000 02EC         RefreshTime--;
	DEC  R9
; 0000 02ED 
; 0000 02EE             if(1){
; 0000 02EF             RefreshLcd++;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,-LOW(1)
	STS  _RefreshLcd_G000,R30
; 0000 02F0 
; 0000 02F1                 if(STAND_BY_TIMER>0){
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BRSH _0x73
; 0000 02F2                 STAND_BY_TIMER--;
	MOVW R30,R4
	SBIW R30,1
	MOVW R4,R30
; 0000 02F3                     if(STAND_BY_TIMER==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x74
; 0000 02F4                     STAND_BY = 1;
	LDI  R30,LOW(1)
	STS  _STAND_BY_S0000006000,R30
; 0000 02F5                     Address[0] = 0;
	CALL SUBOPT_0x29
; 0000 02F6                     Address[1] = 0;
; 0000 02F7                     Address[2] = 0;
; 0000 02F8                     Address[3] = 0;
; 0000 02F9                     Address[4] = 0;
; 0000 02FA                     Address[5] = 0;
; 0000 02FB                     SelectedRow = 0;
; 0000 02FC                     }
; 0000 02FD                 }
_0x74:
; 0000 02FE 
; 0000 02FF                 if(MAIN_MENU_TIMER>0){
_0x73:
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x75
; 0000 0300                 MAIN_MENU_TIMER--;
	DEC  R7
; 0000 0301                     if(MAIN_MENU_TIMER==0){
	TST  R7
	BRNE _0x76
; 0000 0302                     Address[0] = 0;
	CALL SUBOPT_0x29
; 0000 0303                     Address[1] = 0;
; 0000 0304                     Address[2] = 0;
; 0000 0305                     Address[3] = 0;
; 0000 0306                     Address[4] = 0;
; 0000 0307                     Address[5] = 0;
; 0000 0308                     SelectedRow = 0;
; 0000 0309                     }
; 0000 030A                 }
_0x76:
; 0000 030B 
; 0000 030C                 if(LCD_LED_TIMER>0){
_0x75:
	LDI  R30,LOW(0)
	CP   R30,R6
	BRSH _0x77
; 0000 030D                 LCD_LED_TIMER--;
	DEC  R6
; 0000 030E                 }
; 0000 030F 
; 0000 0310             }
_0x77:
; 0000 0311         }
; 0000 0312         else{
	RJMP _0x78
_0x71:
; 0000 0313         TimeRefreshed = 0;
	LDI  R30,LOW(0)
	STS  _TimeRefreshed_S0000006001,R30
; 0000 0314         }
_0x78:
; 0000 0315     //////////////////////////////////////////////////////////////////////////////////
; 0000 0316     //////////////////////////////////////////////////////////////////////////////////
; 0000 0317     //////////////////////////////////////////////////////////////////////////////////
; 0000 0318 
; 0000 0319 
; 0000 031A 
; 0000 031B 
; 0000 031C 
; 0000 031D 
; 0000 031E 
; 0000 031F 
; 0000 0320 
; 0000 0321 
; 0000 0322 
; 0000 0323 
; 0000 0324     //////////////////////////////////////////////////////////////////////////////////
; 0000 0325     /////////////////////////////////////// Mygtukai /////////////////////////////////
; 0000 0326     //////////////////////////////////////////////////////////////////////////////////
; 0000 0327     static unsigned char BUTTON[5], ButtonFilter[5];
; 0000 0328         if(1){
; 0000 0329         unsigned char i;
; 0000 032A             for(i=0;i<5;i++){
	SBIW R28,1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0x7B:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRSH _0x7C
; 0000 032B                 if(BUTTON_INPUT(i)==1){
	LD   R30,Y
	ST   -Y,R30
	RCALL _BUTTON_INPUT
	CPI  R30,LOW(0x1)
	BRNE _0x7D
; 0000 032C                     if(ButtonFilter[i]<ButtonFiltrationTimer){
	CALL SUBOPT_0x2A
	BRSH _0x7E
; 0000 032D                     ButtonFilter[i]++;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_ButtonFilter_S0000006001)
	SBCI R27,HIGH(-_ButtonFilter_S0000006001)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 032E                     }
; 0000 032F                 }
_0x7E:
; 0000 0330                 else{
	RJMP _0x7F
_0x7D:
; 0000 0331                     if(ButtonFilter[i]>=ButtonFiltrationTimer){
	CALL SUBOPT_0x2A
	BRLO _0x80
; 0000 0332                     BUTTON[i] = 1;
	CALL SUBOPT_0x2B
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 0333                     RefreshLcd = RefreshLcd + 2;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,-LOW(2)
	STS  _RefreshLcd_G000,R30
; 0000 0334                     STAND_BY_TIMER = 45;
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	MOVW R4,R30
; 0000 0335                     MAIN_MENU_TIMER = 30;
	LDI  R30,LOW(30)
	MOV  R7,R30
; 0000 0336                     LCD_LED_TIMER = 15; lcd_light_now = lcd_light;
	LDI  R30,LOW(15)
	MOV  R6,R30
	CALL SUBOPT_0x18
	STS  _lcd_light_now_G000,R30
; 0000 0337                     }
; 0000 0338                     else{
	RJMP _0x81
_0x80:
; 0000 0339                     BUTTON[i] = 0;
	CALL SUBOPT_0x2B
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 033A                     }
_0x81:
; 0000 033B                 ButtonFilter[i] = 0;
	CALL SUBOPT_0x2C
	SUBI R30,LOW(-_ButtonFilter_S0000006001)
	SBCI R31,HIGH(-_ButtonFilter_S0000006001)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 033C                 }
_0x7F:
; 0000 033D             }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x7B
_0x7C:
; 0000 033E         }
	ADIW R28,1
; 0000 033F     //////////////////////////////////////////////////////////////////////////////////
; 0000 0340     //////////////////////////////////////////////////////////////////////////////////
; 0000 0341     //////////////////////////////////////////////////////////////////////////////////
; 0000 0342 
; 0000 0343 
; 0000 0344 
; 0000 0345 
; 0000 0346 
; 0000 0347 
; 0000 0348 
; 0000 0349 
; 0000 034A 
; 0000 034B 
; 0000 034C 
; 0000 034D 
; 0000 034E     //////////////////////////////////////////////////////////////////////////////////
; 0000 034F     ///////////////////////////// DS18B20 ////////////////////////////////////////////
; 0000 0350     //////////////////////////////////////////////////////////////////////////////////
; 0000 0351     static unsigned char ds18b20_wait_time;
; 0000 0352     static unsigned char ds18b20_scanning_device;
; 0000 0353     static unsigned char error_temperature[MAX_DS18B20_DEVICES];
; 0000 0354         if((TimeRefreshed>=1)||(ds18b20_scanning_device>=1)){
	LDS  R26,_TimeRefreshed_S0000006001
	CPI  R26,LOW(0x1)
	BRSH _0x83
	LDS  R26,_ds18b20_scanning_device_S0000006001
	CPI  R26,LOW(0x1)
	BRSH _0x83
	RJMP _0x82
_0x83:
; 0000 0355         ds18b20_wait_time++;
	LDS  R30,_ds18b20_wait_time_S0000006001
	SUBI R30,-LOW(1)
	STS  _ds18b20_wait_time_S0000006001,R30
; 0000 0356             if(ds18b20_wait_time>=3){
	LDS  R26,_ds18b20_wait_time_S0000006001
	CPI  R26,LOW(0x3)
	BRSH PC+3
	JMP _0x85
; 0000 0357                 if(DS18B20_IS_ASSIGNED[ds18b20_scanning_device]==1){
	LDS  R26,_ds18b20_scanning_device_S0000006001
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x86
; 0000 0358                 float i;
; 0000 0359                 i = ds18b20_temperature(&rom_code[ds18b20_sensor_assignation[ds18b20_scanning_device]][0]);
	SBIW R28,4
;	i -> Y+0
	LDS  R30,_ds18b20_scanning_device_S0000006001
	CALL SUBOPT_0x25
	LD   R30,Z
	CALL SUBOPT_0x21
	ST   -Y,R31
	ST   -Y,R30
	CALL _ds18b20_temperature
	CALL __PUTD1S0
; 0000 035A                     if((i>-100.0)&&(i<200.0)){
	CALL SUBOPT_0x2E
	__GETD1N 0xC2C80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x88
	CALL SUBOPT_0x2E
	__GETD1N 0x43480000
	CALL __CMPF12
	BRLO _0x89
_0x88:
	RJMP _0x87
_0x89:
; 0000 035B                     TEMPERATURES[ds18b20_scanning_device] = i;
	LDS  R30,_ds18b20_scanning_device_S0000006001
	CALL SUBOPT_0x2F
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x2E
	CALL __PUTDZ20
; 0000 035C                     error_temperature[ds18b20_scanning_device] = 0;
	CALL SUBOPT_0x30
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 035D                     }
; 0000 035E                     else{
	RJMP _0x8A
_0x87:
; 0000 035F                         if(error_temperature[ds18b20_scanning_device]<10){
	CALL SUBOPT_0x30
	LD   R26,Z
	CPI  R26,LOW(0xA)
	BRSH _0x8B
; 0000 0360                         error_temperature[ds18b20_scanning_device]++;
	LDS  R26,_ds18b20_scanning_device_S0000006001
	LDI  R27,0
	SUBI R26,LOW(-_error_temperature_S0000006001)
	SBCI R27,HIGH(-_error_temperature_S0000006001)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 0361                         }
; 0000 0362                     }
_0x8B:
_0x8A:
; 0000 0363                 }
	ADIW R28,4
; 0000 0364 
; 0000 0365                 if((error_temperature[ds18b20_scanning_device]==0)||(error_temperature[ds18b20_scanning_device]==10)){
_0x86:
	CALL SUBOPT_0x30
	LD   R26,Z
	CPI  R26,LOW(0x0)
	BREQ _0x8D
	CPI  R26,LOW(0xA)
	BRNE _0x8C
_0x8D:
; 0000 0366                 ds18b20_scanning_device++;
	LDS  R30,_ds18b20_scanning_device_S0000006001
	SUBI R30,-LOW(1)
	STS  _ds18b20_scanning_device_S0000006001,R30
; 0000 0367                 }
; 0000 0368 
; 0000 0369                 if(ds18b20_scanning_device>=MAX_DS18B20_DEVICES){
_0x8C:
	LDS  R26,_ds18b20_scanning_device_S0000006001
	CPI  R26,LOW(0x8)
	BRLO _0x8F
; 0000 036A                 ds18b20_wait_time = 0;
	LDI  R30,LOW(0)
	STS  _ds18b20_wait_time_S0000006001,R30
; 0000 036B                 ds18b20_scanning_device = 0;
	STS  _ds18b20_scanning_device_S0000006001,R30
; 0000 036C                 }
; 0000 036D 
; 0000 036E             }
_0x8F:
; 0000 036F         }
_0x85:
; 0000 0370     //////////////////////////////////////////////////////////////////////////////////
; 0000 0371     //////////////////////////////////////////////////////////////////////////////////
; 0000 0372     //////////////////////////////////////////////////////////////////////////////////
; 0000 0373 
; 0000 0374 
; 0000 0375 
; 0000 0376 
; 0000 0377 
; 0000 0378 
; 0000 0379 
; 0000 037A 
; 0000 037B 
; 0000 037C     //////////////////////////////////////////////////////////////////////////////////
; 0000 037D     //////////////////////////////// DAC /////////////////////////////////////////////
; 0000 037E     //////////////////////////////////////////////////////////////////////////////////
; 0000 037F     static unsigned char ADC_CHANNEL=4;
_0x82:

	.DSEG

	.CSEG
; 0000 0380         if(ADC_CHANNEL>7){
	LDS  R26,_ADC_CHANNEL_S0000006001
	CPI  R26,LOW(0x8)
	BRLO _0x91
; 0000 0381         ADC_CHANNEL = 4;
	LDI  R30,LOW(4)
	STS  _ADC_CHANNEL_S0000006001,R30
; 0000 0382         }
; 0000 0383 
; 0000 0384         if(ADC_CHANNEL==4){
_0x91:
	LDS  R26,_ADC_CHANNEL_S0000006001
	CPI  R26,LOW(0x4)
	BRNE _0x92
; 0000 0385             if(dac_data[3]>read_adc(ADC_CHANNEL)){
	CALL SUBOPT_0x31
	__GETB2MN _dac_data,3
	CP   R30,R26
	BRSH _0x93
; 0000 0386             PORTC.4 = 1;
	SBI  0x15,4
; 0000 0387             }
; 0000 0388             else{
	RJMP _0x96
_0x93:
; 0000 0389             PORTC.4 = 0;
	CBI  0x15,4
; 0000 038A             }
_0x96:
; 0000 038B         }
; 0000 038C         else if(ADC_CHANNEL==5){
	RJMP _0x99
_0x92:
	LDS  R26,_ADC_CHANNEL_S0000006001
	CPI  R26,LOW(0x5)
	BRNE _0x9A
; 0000 038D             if(dac_data[2]>read_adc(ADC_CHANNEL)){
	CALL SUBOPT_0x31
	__GETB2MN _dac_data,2
	CP   R30,R26
	BRSH _0x9B
; 0000 038E             PORTC.3 = 1;
	SBI  0x15,3
; 0000 038F             }
; 0000 0390             else{
	RJMP _0x9E
_0x9B:
; 0000 0391             PORTC.3 = 0;
	CBI  0x15,3
; 0000 0392             }
_0x9E:
; 0000 0393         }
; 0000 0394         else if(ADC_CHANNEL==6){
	RJMP _0xA1
_0x9A:
	LDS  R26,_ADC_CHANNEL_S0000006001
	CPI  R26,LOW(0x6)
	BRNE _0xA2
; 0000 0395             if(dac_data[1]>read_adc(ADC_CHANNEL)){
	CALL SUBOPT_0x31
	__GETB2MN _dac_data,1
	CP   R30,R26
	BRSH _0xA3
; 0000 0396             PORTC.6 = 1;
	SBI  0x15,6
; 0000 0397             }
; 0000 0398             else{
	RJMP _0xA6
_0xA3:
; 0000 0399             PORTC.6 = 0;
	CBI  0x15,6
; 0000 039A             }
_0xA6:
; 0000 039B         }
; 0000 039C         else if(ADC_CHANNEL==7){
	RJMP _0xA9
_0xA2:
	LDS  R26,_ADC_CHANNEL_S0000006001
	CPI  R26,LOW(0x7)
	BRNE _0xAA
; 0000 039D             if(dac_data[0]>read_adc(ADC_CHANNEL)){
	CALL SUBOPT_0x31
	LDS  R26,_dac_data
	CP   R30,R26
	BRSH _0xAB
; 0000 039E             PORTC.5 = 1;
	SBI  0x15,5
; 0000 039F             }
; 0000 03A0             else{
	RJMP _0xAE
_0xAB:
; 0000 03A1             PORTC.5 = 0;
	CBI  0x15,5
; 0000 03A2             }
_0xAE:
; 0000 03A3         }
; 0000 03A4     ADC_CHANNEL++;
_0xAA:
_0xA9:
_0xA1:
_0x99:
	LDS  R30,_ADC_CHANNEL_S0000006001
	SUBI R30,-LOW(1)
	STS  _ADC_CHANNEL_S0000006001,R30
; 0000 03A5     //////////////////////////////////////////////////////////////////////////////////
; 0000 03A6     //////////////////////////////////////////////////////////////////////////////////
; 0000 03A7     //////////////////////////////////////////////////////////////////////////////////
; 0000 03A8 
; 0000 03A9 
; 0000 03AA 
; 0000 03AB 
; 0000 03AC 
; 0000 03AD 
; 0000 03AE 
; 0000 03AF 
; 0000 03B0 
; 0000 03B1 
; 0000 03B2     //////////////////////////////////////////////////////////////////////////////////
; 0000 03B3     ///////////////////////// VALDYMO ALGORITMAS /////////////////////////////////////
; 0000 03B4     //////////////////////////////////////////////////////////////////////////////////
; 0000 03B5     static unsigned char AlgorythmSecondTimer=0;
; 0000 03B6     static unsigned char ALGORYTHM_REFRESH_TIME=60;

	.DSEG

	.CSEG
; 0000 03B7 
; 0000 03B8     static float VERY_LAST_TEMPERATURES[MAX_DS18B20_DEVICES];
; 0000 03B9 //    static unsigned char VERY_LAST_SOLARIUM_STATE[3];
; 0000 03BA //    static unsigned char VERY_LAST_DACS[4];
; 0000 03BB 
; 0000 03BC     static float LAST_TEMPERATURES[MAX_DS18B20_DEVICES];
; 0000 03BD     static unsigned char LAST_SOLARIUM_STATE[3];
; 0000 03BE //    static unsigned char LAST_DACS[4];
; 0000 03BF 
; 0000 03C0     static float SOLARIUM_OUTSIDE_OFFSET = 5.0;

	.DSEG

	.CSEG
; 0000 03C1     static float SOLARIUM_INSIDE_OFFSET = 2.5;

	.DSEG

	.CSEG
; 0000 03C2 
; 0000 03C3     // 0. Kambario temperaturos daviklis
; 0000 03C4     // 1. Lauko temperaturos daviklis
; 0000 03C5     // 2. Pirmojo soliariumo temperaturos daviklis
; 0000 03C6     // 3. Antrojo soliariumo temperaturos daviklis
; 0000 03C7     // 4. Treciojo soliariumo temperaturos daviklis
; 0000 03C8     // 5. Papildomas kambario temperaturos daviklis
; 0000 03C9 
; 0000 03CA         if(TimeRefreshed>=1){
	LDS  R26,_TimeRefreshed_S0000006001
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0xB4
; 0000 03CB         AlgorythmSecondTimer++;
	LDS  R30,_AlgorythmSecondTimer_S0000006001
	SUBI R30,-LOW(1)
	STS  _AlgorythmSecondTimer_S0000006001,R30
; 0000 03CC             if(AlgorythmSecondTimer>ALGORYTHM_REFRESH_TIME){
	LDS  R30,_ALGORYTHM_REFRESH_TIME_S0000006001
	LDS  R26,_AlgorythmSecondTimer_S0000006001
	CP   R30,R26
	BRLO PC+3
	JMP _0xB5
; 0000 03CD             AlgorythmSecondTimer = 0;
	LDI  R30,LOW(0)
	STS  _AlgorythmSecondTimer_S0000006001,R30
; 0000 03CE                 if(MANUAL_CONTROLLER==0){
	CALL SUBOPT_0x32
	CPI  R30,0
	BREQ PC+3
	JMP _0xB6
; 0000 03CF 
; 0000 03D0                     if(TEMPERATURES[1]+SOLARIUM_OUTSIDE_OFFSET<ROOM_TEMPERATURE){// Jei lauke yra salta
	CALL SUBOPT_0x33
	LDS  R26,_SOLARIUM_OUTSIDE_OFFSET_S0000006001
	LDS  R27,_SOLARIUM_OUTSIDE_OFFSET_S0000006001+1
	LDS  R24,_SOLARIUM_OUTSIDE_OFFSET_S0000006001+2
	LDS  R25,_SOLARIUM_OUTSIDE_OFFSET_S0000006001+3
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x34
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRLO PC+3
	JMP _0xB7
; 0000 03D1 
; 0000 03D2                         // Jeigu atsalo
; 0000 03D3                         if( ROOM_TEMPERATURE-TEMPERATURES[0]>SOLARIUM_INSIDE_OFFSET ){// jei zemiau uzstatytos ribos
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
	BREQ PC+2
	BRCC PC+3
	JMP  _0xB8
; 0000 03D4                             if( ROOM_TEMPERATURE-TEMPERATURES[0]<(SOLARIUM_INSIDE_OFFSET*2) ){// jei nezemiau uzstatytos ribos dvigubai
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x37
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRSH _0xB9
; 0000 03D5                                 if(LAST_TEMPERATURES[0]>=TEMPERATURES[0]){// jei paskutine temperatura yra mazesne arba tokia pati
	CALL SUBOPT_0x38
	BRLO _0xBA
; 0000 03D6                                     if(dac_data[1]<=245){
	__GETB2MN _dac_data,1
	CPI  R26,LOW(0xF6)
	BRSH _0xBB
; 0000 03D7                                     dac_data[1] += 10;
	__GETB1MN _dac_data,1
	SUBI R30,-LOW(10)
	CALL SUBOPT_0x39
; 0000 03D8                                     dac_data[2] = dac_data[1];
; 0000 03D9                                     dac_data[3] = dac_data[1];
	RJMP _0x2E5
; 0000 03DA                                     }
; 0000 03DB                                     else{
_0xBB:
; 0000 03DC                                     dac_data[1] = 255;
	CALL SUBOPT_0x3A
; 0000 03DD                                     dac_data[2] = 255;
; 0000 03DE                                     dac_data[3] = 255;
_0x2E5:
	__PUTB1MN _dac_data,3
; 0000 03DF                                     }
; 0000 03E0                                 }
; 0000 03E1                                 else{
_0xBA:
; 0000 03E2                                 // Temperatura eina gera linkme
; 0000 03E3                                 }
; 0000 03E4                             }
; 0000 03E5                             else{
	RJMP _0xBE
_0xB9:
; 0000 03E6                             dac_data[0] = 0;
	CALL SUBOPT_0x16
; 0000 03E7                             dac_data[1] = 255;
; 0000 03E8                             dac_data[2] = 255;
; 0000 03E9                             dac_data[3] = 255;
; 0000 03EA                             }
_0xBE:
; 0000 03EB                         }
; 0000 03EC 
; 0000 03ED                         // Jeigu perkaito
; 0000 03EE                         else if( TEMPERATURES[0]-ROOM_TEMPERATURE>SOLARIUM_INSIDE_OFFSET ){// jei daugiau uzstatytos ribos
	RJMP _0xBF
_0xB8:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x36
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC0
; 0000 03EF                             if( TEMPERATURES[0]-ROOM_TEMPERATURE<(SOLARIUM_INSIDE_OFFSET*2) ){// jei nedaugiau uzstatytos ribos dvigubai
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3B
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x37
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BRSH _0xC1
; 0000 03F0                                 if(LAST_TEMPERATURES[0]<=TEMPERATURES[0]){// jei paskutine temperatura yra mazesne arba tokia pati
	CALL SUBOPT_0x38
	BREQ PC+4
	BRCS PC+3
	JMP  _0xC2
; 0000 03F1                                     if(dac_data[1]>=10){
	__GETB2MN _dac_data,1
	CPI  R26,LOW(0xA)
	BRLO _0xC3
; 0000 03F2                                     dac_data[1] -= 10;
	CALL SUBOPT_0x3C
	SBIW R30,10
	CALL SUBOPT_0x3D
; 0000 03F3                                     dac_data[2] = dac_data[1];
; 0000 03F4                                     dac_data[3] = dac_data[1];
	RJMP _0x2E6
; 0000 03F5                                     }
; 0000 03F6                                     else{
_0xC3:
; 0000 03F7                                     dac_data[1] = 255;
	CALL SUBOPT_0x3A
; 0000 03F8                                     dac_data[2] = 255;
; 0000 03F9                                     dac_data[3] = 255;
_0x2E6:
	__PUTB1MN _dac_data,3
; 0000 03FA                                     }
; 0000 03FB                                 }
; 0000 03FC                                 else{
_0xC2:
; 0000 03FD                                 // Temperatura eina gera linkme
; 0000 03FE                                 }
; 0000 03FF                             }
; 0000 0400                             else{
	RJMP _0xC6
_0xC1:
; 0000 0401                             dac_data[0] = 255;
	CALL SUBOPT_0x3E
; 0000 0402                             dac_data[1] = 0;
; 0000 0403                             dac_data[2] = 0;
; 0000 0404                             dac_data[3] = 0;
; 0000 0405                             }
_0xC6:
; 0000 0406                         }
; 0000 0407 
; 0000 0408                         // jei siek tiek daugiau
; 0000 0409                         else if(TEMPERATURES[0]>ROOM_TEMPERATURE){ // jeigu temperatura ribose bet siek tiek didesne
	RJMP _0xC7
_0xC0:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3F
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC8
; 0000 040A                             if(LAST_TEMPERATURES[0]<TEMPERATURES[0]){// jei temperatura padidejo
	CALL SUBOPT_0x38
	BRSH _0xC9
; 0000 040B                                 if(dac_data[1]>=2){
	__GETB2MN _dac_data,1
	CPI  R26,LOW(0x2)
	BRLO _0xCA
; 0000 040C                                 dac_data[1] -= 2;
	CALL SUBOPT_0x3C
	SBIW R30,2
	CALL SUBOPT_0x3D
; 0000 040D                                 dac_data[2] = dac_data[1];
; 0000 040E                                 dac_data[3] = dac_data[1];
	RJMP _0x2E7
; 0000 040F                                 }
; 0000 0410                                 else{
_0xCA:
; 0000 0411                                 dac_data[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _dac_data,1
; 0000 0412                                 dac_data[2] = 0;
	__PUTB1MN _dac_data,2
; 0000 0413                                 dac_data[3] = 0;
_0x2E7:
	__PUTB1MN _dac_data,3
; 0000 0414                                 }
; 0000 0415                             }
; 0000 0416                             else{
_0xC9:
; 0000 0417                             // Gerai
; 0000 0418                             }
; 0000 0419                         }
; 0000 041A 
; 0000 041B                         // jei siek tiek maziau
; 0000 041C                         else if(TEMPERATURES[0]<ROOM_TEMPERATURE){ // jeigu temperatura ribose bet siek tiek mazesne
	RJMP _0xCD
_0xC8:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3F
	BRSH _0xCE
; 0000 041D                             if(LAST_TEMPERATURES[0]>TEMPERATURES[0]){// jei temperatura sumazejo
	CALL SUBOPT_0x38
	BREQ PC+2
	BRCC PC+3
	JMP  _0xCF
; 0000 041E                                 if(dac_data[1]<=253){
	__GETB2MN _dac_data,1
	CPI  R26,LOW(0xFE)
	BRSH _0xD0
; 0000 041F                                 dac_data[1] += 2;
	__GETB1MN _dac_data,1
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x39
; 0000 0420                                 dac_data[2] = dac_data[1];
; 0000 0421                                 dac_data[3] = dac_data[1];
	RJMP _0x2E8
; 0000 0422                                 }
; 0000 0423                                 else{
_0xD0:
; 0000 0424                                 dac_data[1] = 255;
	CALL SUBOPT_0x3A
; 0000 0425                                 dac_data[2] = 255;
; 0000 0426                                 dac_data[3] = 255;
_0x2E8:
	__PUTB1MN _dac_data,3
; 0000 0427                                 }
; 0000 0428                             }
; 0000 0429                             else{
_0xCF:
; 0000 042A                             // Gerai
; 0000 042B                             }
; 0000 042C                         }
; 0000 042D 
; 0000 042E 
; 0000 042F                     dac_data[0] = 255 - dac_data[1];
_0xCE:
_0xCD:
_0xC7:
_0xBF:
	__GETB1MN _dac_data,1
	LDI  R31,0
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	CALL SUBOPT_0x2
	STS  _dac_data,R30
; 0000 0430 
; 0000 0431 
; 0000 0432                     /*unsigned int solariums_opens=0, count=0;
; 0000 0433 
; 0000 0434                         if((SOLARIUM1_AT_WORK==1)|| (TEMPERATURES[2]>TEMPERATURES[0]+5.0) ){
; 0000 0435                             if(DS18B20_IS_ASSIGNED[2]==1){
; 0000 0436                                 if(LAST_SOLARIUM_STATE[0]==1){// Turi buti pradirbes bent 1 cikla
; 0000 0437                                     if(TEMPERATURES[2] > (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei is soliariumo iseinantis oras aukstesnes temp negu uzstatyta
; 0000 0438                                         if(TEMPERATURES[0] < (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei kambario temperatura zemesne
; 0000 0439                                             if(TEMPERATURES[0]<LAST_TEMPERATURES[0]<VERY_LAST_TEMPERATURES[0]){
; 0000 043A                                                 if(dac_data[1]<=235){
; 0000 043B                                                 dac_data[1] = dac_data[1] + 20;
; 0000 043C                                                 }
; 0000 043D                                                 else{
; 0000 043E                                                 dac_data[1] = 255;
; 0000 043F                                                 }
; 0000 0440                                             }
; 0000 0441                                         }
; 0000 0442                                         else if( (ROOM_TEMPERATURE-SOLARIUM_INSIDE_OFFSET) < TEMPERATURES[0] ){// Jei kambario temperatura aukstesne
; 0000 0443                                             if(TEMPERATURES[0]>LAST_TEMPERATURES[0]>VERY_LAST_TEMPERATURES[0]){
; 0000 0444                                                 if(dac_data[1]>=20){
; 0000 0445                                                 dac_data[1] = dac_data[1] - 20;
; 0000 0446                                                 }
; 0000 0447                                                 else{
; 0000 0448                                                 dac_data[1] = 0;
; 0000 0449                                                 }
; 0000 044A                                             }
; 0000 044B                                         }
; 0000 044C                                         else{// Jei kambario temperatura ribose
; 0000 044D                                             if(TEMPERATURES[0]>ROOM_TEMPERATURE){// Jei aukstesne
; 0000 044E                                                 if(dac_data[1]<=250){
; 0000 044F                                                 dac_data[1] = dac_data[1] + 5;
; 0000 0450                                                 }
; 0000 0451                                             }
; 0000 0452                                             else if(TEMPERATURES[0]<ROOM_TEMPERATURE){// Jei zemesne
; 0000 0453                                                 if(dac_data[1]>=5){
; 0000 0454                                                 dac_data[1] = dac_data[1] - 5;
; 0000 0455                                                 }
; 0000 0456                                             }
; 0000 0457                                         }
; 0000 0458                                     }
; 0000 0459                                     else{
; 0000 045A                                     dac_data[1] = 255;
; 0000 045B                                     }
; 0000 045C                                 }
; 0000 045D                                 else{
; 0000 045E                                 dac_data[1] = 255;
; 0000 045F                                 LAST_SOLARIUM_STATE[0] = 1;
; 0000 0460                                 }
; 0000 0461                             }
; 0000 0462                             else{
; 0000 0463                             dac_data[1] = 255;
; 0000 0464                             }
; 0000 0465                         solariums_opens = dac_data[1];
; 0000 0466                         count = 1;
; 0000 0467                         }
; 0000 0468                         else{
; 0000 0469                         dac_data[1] = 0;
; 0000 046A                         LAST_SOLARIUM_STATE[0] = 0;
; 0000 046B                         }
; 0000 046C 
; 0000 046D 
; 0000 046E                         if((SOLARIUM2_AT_WORK==1)|| (TEMPERATURES[3]>TEMPERATURES[0]+5.0) ){
; 0000 046F                             if(DS18B20_IS_ASSIGNED[3]==1){
; 0000 0470                                 if(LAST_SOLARIUM_STATE[1]==1){// Turi buti pradirbes bent 1 cikla
; 0000 0471                                     if(TEMPERATURES[3] > (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei is soliariumo iseinantis oras aukstesnes temp negu uzstatyta
; 0000 0472                                         if(TEMPERATURES[0] < (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei kambario temperatura zemesne
; 0000 0473                                             if(TEMPERATURES[0]<LAST_TEMPERATURES[0]<VERY_LAST_TEMPERATURES[0]){
; 0000 0474                                                 if(dac_data[2]<=235){
; 0000 0475                                                 dac_data[2] = dac_data[2] + 20;
; 0000 0476                                                 }
; 0000 0477                                                 else{
; 0000 0478                                                 dac_data[2] = 255;
; 0000 0479                                                 }
; 0000 047A                                             }
; 0000 047B                                         }
; 0000 047C                                         else if( (ROOM_TEMPERATURE-SOLARIUM_INSIDE_OFFSET) < TEMPERATURES[0] ){// Jei kambario temperatura aukstesne
; 0000 047D                                             if(TEMPERATURES[0]>LAST_TEMPERATURES[0]>VERY_LAST_TEMPERATURES[0]){
; 0000 047E                                                 if(dac_data[2]>=20){
; 0000 047F                                                 dac_data[2] = dac_data[2] - 20;
; 0000 0480                                                 }
; 0000 0481                                                 else{
; 0000 0482                                                 dac_data[2] = 0;
; 0000 0483                                                 }
; 0000 0484                                             }
; 0000 0485                                         }
; 0000 0486                                         else{// Jei kambario temperatura ribose
; 0000 0487                                             if(TEMPERATURES[0]>ROOM_TEMPERATURE){// Jei aukstesne
; 0000 0488                                                 if(dac_data[2]<=250){
; 0000 0489                                                 dac_data[2] = dac_data[2] + 5;
; 0000 048A                                                 }
; 0000 048B                                             }
; 0000 048C                                             else if(TEMPERATURES[0]<ROOM_TEMPERATURE){// Jei zemesne
; 0000 048D                                                 if(dac_data[2]>=5){
; 0000 048E                                                 dac_data[2] = dac_data[2] - 5;
; 0000 048F                                                 }
; 0000 0490                                             }
; 0000 0491                                         }
; 0000 0492                                     }
; 0000 0493                                     else{
; 0000 0494                                     dac_data[2] = 255;
; 0000 0495                                     }
; 0000 0496                                 }
; 0000 0497                                 else{
; 0000 0498                                 dac_data[2] = 255;
; 0000 0499                                 LAST_SOLARIUM_STATE[1] = 1;
; 0000 049A                                 }
; 0000 049B                             }
; 0000 049C                             else{
; 0000 049D                             dac_data[2] = 255;
; 0000 049E                             }
; 0000 049F                         solariums_opens = dac_data[2];
; 0000 04A0                         count = 1;
; 0000 04A1                         }
; 0000 04A2                         else{
; 0000 04A3                         dac_data[2] = 0;
; 0000 04A4                         LAST_SOLARIUM_STATE[1] = 0;
; 0000 04A5                         }
; 0000 04A6 
; 0000 04A7 
; 0000 04A8                         if((SOLARIUM3_AT_WORK==1)|| (TEMPERATURES[4]>TEMPERATURES[0]+5.0) ){
; 0000 04A9                             if(DS18B20_IS_ASSIGNED[4]==1){
; 0000 04AA                                 if(LAST_SOLARIUM_STATE[2]==1){// Turi buti pradirbes bent 1 cikla
; 0000 04AB                                     if(TEMPERATURES[4] > (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei is soliariumo iseinantis oras aukstesnes temp negu uzstatyta
; 0000 04AC                                         if(TEMPERATURES[0] < (ROOM_TEMPERATURE+SOLARIUM_INSIDE_OFFSET) ){// Jei kambario temperatura zemesne
; 0000 04AD                                             if(TEMPERATURES[0]<LAST_TEMPERATURES[0]<VERY_LAST_TEMPERATURES[0]){
; 0000 04AE                                                 if(dac_data[3]<=235){
; 0000 04AF                                                 dac_data[3] = dac_data[3] + 20;
; 0000 04B0                                                 }
; 0000 04B1                                                 else{
; 0000 04B2                                                 dac_data[3] = 255;
; 0000 04B3                                                 }
; 0000 04B4                                             }
; 0000 04B5                                         }
; 0000 04B6                                         else if( (ROOM_TEMPERATURE-SOLARIUM_INSIDE_OFFSET) < TEMPERATURES[0] ){// Jei kambario temperatura aukstesne
; 0000 04B7                                             if(TEMPERATURES[0]>LAST_TEMPERATURES[0]>VERY_LAST_TEMPERATURES[0]){
; 0000 04B8                                                 if(dac_data[3]>=20){
; 0000 04B9                                                 dac_data[3] = dac_data[3] - 20;
; 0000 04BA                                                 }
; 0000 04BB                                                 else{
; 0000 04BC                                                 dac_data[3] = 0;
; 0000 04BD                                                 }
; 0000 04BE                                             }
; 0000 04BF                                         }
; 0000 04C0                                         else{// Jei kambario temperatura ribose
; 0000 04C1                                             if(TEMPERATURES[0]>ROOM_TEMPERATURE){// Jei aukstesne
; 0000 04C2                                                 if(dac_data[3]<=250){
; 0000 04C3                                                 dac_data[3] = dac_data[3] + 5;
; 0000 04C4                                                 }
; 0000 04C5                                             }
; 0000 04C6                                             else if(TEMPERATURES[0]<ROOM_TEMPERATURE){// Jei zemesne
; 0000 04C7                                                 if(dac_data[3]>=5){
; 0000 04C8                                                 dac_data[3] = dac_data[3] - 5;
; 0000 04C9                                                 }
; 0000 04CA                                             }
; 0000 04CB                                         }
; 0000 04CC                                     }
; 0000 04CD                                     else{
; 0000 04CE                                     dac_data[3] = 255;
; 0000 04CF                                     }
; 0000 04D0                                 }
; 0000 04D1                                 else{
; 0000 04D2                                 dac_data[3] = 255;
; 0000 04D3                                 LAST_SOLARIUM_STATE[2] = 1;
; 0000 04D4                                 }
; 0000 04D5                             }
; 0000 04D6                             else{
; 0000 04D7                             dac_data[3] = 255;
; 0000 04D8                             }
; 0000 04D9                         solariums_opens = dac_data[3];
; 0000 04DA                         count = 1;
; 0000 04DB                         }
; 0000 04DC                         else{
; 0000 04DD                         dac_data[3] = 0;
; 0000 04DE                         LAST_SOLARIUM_STATE[2] = 0;
; 0000 04DF                         }
; 0000 04E0 
; 0000 04E1 
; 0000 04E2 
; 0000 04E3 
; 0000 04E4                         if(count>0){
; 0000 04E5                         dac_data[0] = 255 - (solariums_opens/count);
; 0000 04E6                         }
; 0000 04E7                         else{
; 0000 04E8                         dac_data[0] = 255;
; 0000 04E9                         }*/
; 0000 04EA 
; 0000 04EB                     }
; 0000 04EC                     else{
	RJMP _0xD3
_0xB7:
; 0000 04ED                     dac_data[0] = 255;
	CALL SUBOPT_0x3E
; 0000 04EE                     dac_data[1] = 0;
; 0000 04EF                     dac_data[2] = 0;
; 0000 04F0                     dac_data[3] = 0;
; 0000 04F1                     }
_0xD3:
; 0000 04F2 
; 0000 04F3 
; 0000 04F4 
; 0000 04F5 
; 0000 04F6                 // VERY LAST
; 0000 04F7                     if(1){
; 0000 04F8                     unsigned char i;
; 0000 04F9                         for(i=0;i<MAX_DS18B20_DEVICES;i++){
	SBIW R28,1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0xD6:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0xD7
; 0000 04FA                         VERY_LAST_TEMPERATURES[i] = LAST_TEMPERATURES[i];
	LD   R30,Y
	LDI  R26,LOW(_VERY_LAST_TEMPERATURES_S0000006001)
	LDI  R27,HIGH(_VERY_LAST_TEMPERATURES_S0000006001)
	CALL SUBOPT_0x40
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LD   R30,Y
	LDI  R26,LOW(_LAST_TEMPERATURES_S0000006001)
	LDI  R27,HIGH(_LAST_TEMPERATURES_S0000006001)
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
; 0000 04FB                         }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xD6
_0xD7:
; 0000 04FC 
; 0000 04FD                     //VERY_LAST_SOLARIUM_STATE[0] = LAST_SOLARIUM_STATE[0];
; 0000 04FE                     //VERY_LAST_SOLARIUM_STATE[1] = LAST_SOLARIUM_STATE[1];
; 0000 04FF                     //VERY_LAST_SOLARIUM_STATE[2] = LAST_SOLARIUM_STATE[2];
; 0000 0500 
; 0000 0501                     //    for(i=0;i<MAX_DS18B20_DEVICES;i++){
; 0000 0502                     //    VERY_LAST_DACS[i] = LAST_DACS[i];
; 0000 0503                     //    }
; 0000 0504                     }
	ADIW R28,1
; 0000 0505 
; 0000 0506 
; 0000 0507                 // LAST
; 0000 0508                     if(1){
; 0000 0509                     unsigned char i;
; 0000 050A                         for(i=0;i<MAX_DS18B20_DEVICES;i++){
	SBIW R28,1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0xDA:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0xDB
; 0000 050B                         LAST_TEMPERATURES[i] = TEMPERATURES[i];
	LD   R30,Y
	LDI  R26,LOW(_LAST_TEMPERATURES_S0000006001)
	LDI  R27,HIGH(_LAST_TEMPERATURES_S0000006001)
	CALL SUBOPT_0x40
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LD   R30,Y
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x41
; 0000 050C                         }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xDA
_0xDB:
; 0000 050D 
; 0000 050E                     LAST_SOLARIUM_STATE[0] = SOLARIUM1_AT_WORK;
	LDI  R30,0
	SBIC 0x12,1
	LDI  R30,1
	STS  _LAST_SOLARIUM_STATE_S0000006001,R30
; 0000 050F                     LAST_SOLARIUM_STATE[1] = SOLARIUM2_AT_WORK;
	LDI  R30,0
	SBIC 0x12,2
	LDI  R30,1
	__PUTB1MN _LAST_SOLARIUM_STATE_S0000006001,1
; 0000 0510                     LAST_SOLARIUM_STATE[2] = SOLARIUM3_AT_WORK;
	LDI  R30,0
	SBIC 0x12,3
	LDI  R30,1
	__PUTB1MN _LAST_SOLARIUM_STATE_S0000006001,2
; 0000 0511 
; 0000 0512                     //    for(i=0;i<MAX_DS18B20_DEVICES;i++){
; 0000 0513                     //    LAST_DACS[i] = dac_data[i];
; 0000 0514                     //    }
; 0000 0515                     }
	ADIW R28,1
; 0000 0516 
; 0000 0517                 }
; 0000 0518             }
_0xB6:
; 0000 0519         }
_0xB5:
; 0000 051A     //////////////////////////////////////////////////////////////////////////////////
; 0000 051B     //////////////////////////////////////////////////////////////////////////////////
; 0000 051C     //////////////////////////////////////////////////////////////////////////////////
; 0000 051D 
; 0000 051E 
; 0000 051F 
; 0000 0520 
; 0000 0521 
; 0000 0522 
; 0000 0523 
; 0000 0524 
; 0000 0525 
; 0000 0526 
; 0000 0527 
; 0000 0528     //////////////////////////////////////////////////////////////////////////////////
; 0000 0529     ///////////////////////////// LCD ////////////////////////////////////////////////
; 0000 052A     //////////////////////////////////////////////////////////////////////////////////
; 0000 052B     // Lcd led pwm
; 0000 052C     lcd_light_osc += 1;
_0xB4:
	LDS  R30,_lcd_light_osc_G000
	SUBI R30,-LOW(1)
	STS  _lcd_light_osc_G000,R30
; 0000 052D         if(lcd_light_osc>=20){
	LDS  R26,_lcd_light_osc_G000
	CPI  R26,LOW(0x14)
	BRLO _0xDC
; 0000 052E         lcd_light_osc = 0;
	LDI  R30,LOW(0)
	STS  _lcd_light_osc_G000,R30
; 0000 052F         }
; 0000 0530 
; 0000 0531         if(lcd_light_now>lcd_light_osc){
_0xDC:
	LDS  R30,_lcd_light_osc_G000
	LDS  R26,_lcd_light_now_G000
	CP   R30,R26
	BRSH _0xDD
; 0000 0532         LCD_LED = 1;
	SBI  0x18,0
; 0000 0533         }
; 0000 0534         else{
	RJMP _0xE0
_0xDD:
; 0000 0535         LCD_LED = 0;
	CBI  0x18,0
; 0000 0536         }
_0xE0:
; 0000 0537 
; 0000 0538 
; 0000 0539 
; 0000 053A     // Lcd led antibrighter
; 0000 053B     static unsigned char lcd_led_counter;
; 0000 053C         if(LCD_LED_TIMER==0){
	TST  R6
	BRNE _0xE3
; 0000 053D             if(lcd_light_now>0){
	LDS  R26,_lcd_light_now_G000
	CPI  R26,LOW(0x1)
	BRLO _0xE4
; 0000 053E             lcd_led_counter++;
	LDS  R30,_lcd_led_counter_S0000006001
	SUBI R30,-LOW(1)
	STS  _lcd_led_counter_S0000006001,R30
; 0000 053F                 if(lcd_led_counter>=25){
	LDS  R26,_lcd_led_counter_S0000006001
	CPI  R26,LOW(0x19)
	BRLO _0xE5
; 0000 0540                 lcd_led_counter = 0;
	LDI  R30,LOW(0)
	STS  _lcd_led_counter_S0000006001,R30
; 0000 0541                 lcd_light_now--;
	LDS  R30,_lcd_light_now_G000
	SUBI R30,LOW(1)
	STS  _lcd_light_now_G000,R30
; 0000 0542                 }
; 0000 0543             }
_0xE5:
; 0000 0544         }
_0xE4:
; 0000 0545 
; 0000 0546 
; 0000 0547 
; 0000 0548 
; 0000 0549         if(STAND_BY==1){
_0xE3:
	LDS  R26,_STAND_BY_S0000006000
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0xE6
; 0000 054A         static unsigned char stand_by_pos[2];
; 0000 054B         stand_by_pos[0]++;
	LDS  R30,_stand_by_pos_S0000006002
	SUBI R30,-LOW(1)
	STS  _stand_by_pos_S0000006002,R30
; 0000 054C 
; 0000 054D             if(stand_by_pos[0]>=225){
	LDS  R26,_stand_by_pos_S0000006002
	CPI  R26,LOW(0xE1)
	BRSH PC+3
	JMP _0xE7
; 0000 054E             stand_by_pos[0] = 0;
	LDI  R30,LOW(0)
	STS  _stand_by_pos_S0000006002,R30
; 0000 054F             stand_by_pos[1]++;
	__GETB1MN _stand_by_pos_S0000006002,1
	SUBI R30,-LOW(1)
	__PUTB1MN _stand_by_pos_S0000006002,1
; 0000 0550                 if(stand_by_pos[1]>=44){
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x2C)
	BRLO _0xE8
; 0000 0551                 stand_by_pos[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _stand_by_pos_S0000006002,1
; 0000 0552                 }
; 0000 0553 
; 0000 0554             lcd_clear();
_0xE8:
	CALL _lcd_clear
; 0000 0555                 if(stand_by_pos[1]==0){lcd_gotoxy(0,2);lcd_putchar('/');lcd_gotoxy(0,1);lcd_putchar('/');lcd_gotoxy(0,0);lcd_putchar('^');}
	__GETB1MN _stand_by_pos_S0000006002,1
	CPI  R30,0
	BRNE _0xE9
	CALL SUBOPT_0x42
	CALL SUBOPT_0x43
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x43
	CALL SUBOPT_0x14
	CALL _lcd_gotoxy
	LDI  R30,LOW(94)
	RJMP _0x2E9
; 0000 0556                 else if(stand_by_pos[1]==1){lcd_gotoxy(0,1);lcd_putchar('/');lcd_gotoxy(0,0);lcd_putsf("+>");}
_0xE9:
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x1)
	BRNE _0xEB
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x43
	CALL SUBOPT_0x14
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,145
	CALL SUBOPT_0x12
; 0000 0557                 else if((stand_by_pos[1]>=2)&&(stand_by_pos[1]<=19)){lcd_gotoxy(stand_by_pos[1]-2,0);lcd_putsf("-->");}
	RJMP _0xEC
_0xEB:
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x2)
	BRLO _0xEE
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x14)
	BRLO _0xEF
_0xEE:
	RJMP _0xED
_0xEF:
	__GETB1MN _stand_by_pos_S0000006002,1
	LDI  R31,0
	SBIW R30,2
	CALL SUBOPT_0x44
	__POINTW1FN _0x0,148
	CALL SUBOPT_0x12
; 0000 0558                 else if(stand_by_pos[1]==20){lcd_gotoxy(18,0);lcd_putsf("-+");lcd_gotoxy(19,1);lcd_putchar('v');}
	RJMP _0xF0
_0xED:
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x14)
	BRNE _0xF1
	LDI  R30,LOW(18)
	CALL SUBOPT_0x44
	__POINTW1FN _0x0,18
	CALL SUBOPT_0x12
	CALL SUBOPT_0x45
	LDI  R30,LOW(118)
	RJMP _0x2E9
; 0000 0559                 else if(stand_by_pos[1]==21){lcd_gotoxy(19,0);lcd_putchar('/');lcd_gotoxy(19,1);lcd_putchar('/');lcd_gotoxy(19,2);lcd_putchar('v');}
_0xF1:
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x15)
	BRNE _0xF3
	LDI  R30,LOW(19)
	CALL SUBOPT_0x44
	CALL SUBOPT_0x43
	CALL SUBOPT_0x45
	CALL SUBOPT_0x43
	CALL SUBOPT_0x46
	LDI  R30,LOW(118)
	RJMP _0x2E9
; 0000 055A                 else if(stand_by_pos[1]==22){lcd_gotoxy(19,1);lcd_putchar('/');lcd_gotoxy(19,2);lcd_putchar('/');lcd_gotoxy(19,3);lcd_putchar('v');}
_0xF3:
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x16)
	BRNE _0xF5
	CALL SUBOPT_0x45
	CALL SUBOPT_0x43
	CALL SUBOPT_0x46
	CALL SUBOPT_0x43
	CALL SUBOPT_0x47
	LDI  R30,LOW(118)
	RJMP _0x2E9
; 0000 055B                 else if(stand_by_pos[1]==23){lcd_gotoxy(19,2);lcd_putchar('/');lcd_gotoxy(18,3);lcd_putsf("<+");}
_0xF5:
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x17)
	BRNE _0xF7
	CALL SUBOPT_0x46
	CALL SUBOPT_0x43
	LDI  R30,LOW(18)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,152
	CALL SUBOPT_0x12
; 0000 055C                 else if((stand_by_pos[1]>=24)&&(stand_by_pos[1]<=41)){lcd_gotoxy(17-stand_by_pos[1]+24,3);lcd_putsf("<--");}
	RJMP _0xF8
_0xF7:
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x18)
	BRLO _0xFA
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x2A)
	BRLO _0xFB
_0xFA:
	RJMP _0xF9
_0xFB:
	__GETB1MN _stand_by_pos_S0000006002,1
	LDI  R31,0
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	CALL SUBOPT_0x2
	SUBI R30,-LOW(24)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,155
	CALL SUBOPT_0x12
; 0000 055D                 else if(stand_by_pos[1]==42){lcd_gotoxy(0,2);lcd_putchar('^');lcd_gotoxy(0,3);lcd_putsf("+-");}
	RJMP _0xFC
_0xF9:
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x2A)
	BRNE _0xFD
	CALL SUBOPT_0x42
	LDI  R30,LOW(94)
	ST   -Y,R30
	CALL _lcd_putchar
	CALL SUBOPT_0x13
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,159
	CALL SUBOPT_0x12
; 0000 055E                 else if(stand_by_pos[1]==43){lcd_gotoxy(0,1);lcd_putchar('^');lcd_gotoxy(0,2);lcd_putchar('/');lcd_gotoxy(0,3);lcd_putchar('/');}
	RJMP _0xFE
_0xFD:
	__GETB2MN _stand_by_pos_S0000006002,1
	CPI  R26,LOW(0x2B)
	BRNE _0xFF
	CALL SUBOPT_0x1D
	LDI  R30,LOW(94)
	ST   -Y,R30
	CALL _lcd_putchar
	CALL SUBOPT_0x42
	CALL SUBOPT_0x43
	CALL SUBOPT_0x13
	CALL _lcd_gotoxy
	LDI  R30,LOW(47)
_0x2E9:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 055F 
; 0000 0560             lcd_gotoxy(1,1);
_0xFF:
_0xFE:
_0xFC:
_0xF8:
_0xF0:
_0xEC:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0561             lcd_putsf("    SOLIARIUMO    ");
	__POINTW1FN _0x0,162
	CALL SUBOPT_0x12
; 0000 0562             lcd_gotoxy(1,2);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0563             lcd_putsf("    VALDIKLIS     ");
	__POINTW1FN _0x0,181
	CALL SUBOPT_0x12
; 0000 0564             }
; 0000 0565 
; 0000 0566             if(BUTTON[BUTTON_LEFT]==1){
_0xE7:
	__GETB2MN _BUTTON_S0000006001,1
	CPI  R26,LOW(0x1)
	BREQ _0x2EA
; 0000 0567             STAND_BY = 0;
; 0000 0568             }
; 0000 0569             else if(BUTTON[BUTTON_RIGHT]==1){
	__GETB2MN _BUTTON_S0000006001,3
	CPI  R26,LOW(0x1)
	BREQ _0x2EA
; 0000 056A             STAND_BY = 0;
; 0000 056B             }
; 0000 056C             else if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S0000006001,4
	CPI  R26,LOW(0x1)
	BREQ _0x2EA
; 0000 056D             STAND_BY = 0;
; 0000 056E             }
; 0000 056F             else if(BUTTON[BUTTON_UP]==1){
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BREQ _0x2EA
; 0000 0570             STAND_BY = 0;
; 0000 0571             }
; 0000 0572             else if(BUTTON[BUTTON_ENTER]==1){
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x108
; 0000 0573             STAND_BY = 0;
_0x2EA:
	LDI  R30,LOW(0)
	STS  _STAND_BY_S0000006000,R30
; 0000 0574             }
; 0000 0575 
; 0000 0576         }
_0x108:
; 0000 0577         else{
	JMP  _0x109
_0xE6:
; 0000 0578 
; 0000 0579             if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x10A
; 0000 057A             lcd_clear();
	CALL _lcd_clear
; 0000 057B             }
; 0000 057C 
; 0000 057D 
; 0000 057E             // Pagrindinis langas
; 0000 057F             if(Address[0]==0){
_0x10A:
	LDS  R30,_Address_G000
	CPI  R30,0
	BREQ PC+3
	JMP _0x10B
; 0000 0580                 if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S0000006001,4
	CPI  R26,LOW(0x1)
	BRNE _0x10C
; 0000 0581                 SelectAnotherRow(0);
	CALL SUBOPT_0x48
; 0000 0582                 }
; 0000 0583                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x10D
_0x10C:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x10E
; 0000 0584                 SelectAnotherRow(1);
	CALL SUBOPT_0x49
; 0000 0585                 }
; 0000 0586                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x10F
_0x10E:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x110
; 0000 0587                 Address[0] = SelectedRow;
	LDS  R30,_SelectedRow_G000
	CALL SUBOPT_0x4A
; 0000 0588                 SelectedRow = 0;
; 0000 0589                 Address[5] = 0;
; 0000 058A                 }
; 0000 058B 
; 0000 058C                 if(RefreshLcd>=1){
_0x110:
_0x10F:
_0x10D:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x111
; 0000 058D                 unsigned char row, lcd_row;
; 0000 058E                 lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 058F                 RowsOnWindow = 8;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x4B
; 0000 0590                     for(row=Address[5];row<4+Address[5];row++){
_0x113:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4C
	BRLT PC+3
	JMP _0x114
; 0000 0591                     lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x4D
; 0000 0592                         if(row==0){
	BRNE _0x115
; 0000 0593                         lcd_putsf("  -=PAGR. MENIU=-");
	__POINTW1FN _0x0,200
	RJMP _0x2EB
; 0000 0594                         }
; 0000 0595                         else if(row==1){
_0x115:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x117
; 0000 0596                         lcd_putsf("1.KAMBARIO: ");
	__POINTW1FN _0x0,218
	CALL SUBOPT_0x12
; 0000 0597                             if(DS18B20_IS_ASSIGNED[0]==1){
	LDI  R26,LOW(_DS18B20_IS_ASSIGNED)
	LDI  R27,HIGH(_DS18B20_IS_ASSIGNED)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x118
; 0000 0598                             char lcd_buffer[10];
; 0000 0599                             sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[0]);
	CALL SUBOPT_0x4E
;	row -> Y+11
;	lcd_row -> Y+10
;	lcd_buffer -> Y+0
	LDS  R30,_TEMPERATURES
	LDS  R31,_TEMPERATURES+1
	LDS  R22,_TEMPERATURES+2
	LDS  R23,_TEMPERATURES+3
	CALL SUBOPT_0x4F
; 0000 059A                             lcd_puts(lcd_buffer);
; 0000 059B                             }
; 0000 059C                             else if(DS18B20_IS_ASSIGNED[0]==2){
	RJMP _0x119
_0x118:
	LDI  R26,LOW(_DS18B20_IS_ASSIGNED)
	LDI  R27,HIGH(_DS18B20_IS_ASSIGNED)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x11A
; 0000 059D                             lcd_putsf("OFF");
	__POINTW1FN _0x0,240
	RJMP _0x2EC
; 0000 059E                             }
; 0000 059F                             else{
_0x11A:
; 0000 05A0                             lcd_putsf("----");
	__POINTW1FN _0x0,244
_0x2EC:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05A1                             }
_0x119:
; 0000 05A2                         }
; 0000 05A3                         else if(row==2){
	RJMP _0x11C
_0x117:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x11D
; 0000 05A4                         lcd_putsf("2.LAUKO:    ");
	__POINTW1FN _0x0,249
	CALL SUBOPT_0x12
; 0000 05A5                             if(DS18B20_IS_ASSIGNED[1]==1){
	__POINTW2MN _DS18B20_IS_ASSIGNED,1
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x11E
; 0000 05A6                             char lcd_buffer[10];
; 0000 05A7                             sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[1]);
	CALL SUBOPT_0x4E
;	row -> Y+11
;	lcd_row -> Y+10
;	lcd_buffer -> Y+0
	CALL SUBOPT_0x33
	CALL SUBOPT_0x4F
; 0000 05A8                             lcd_puts(lcd_buffer);
; 0000 05A9                             }
; 0000 05AA                             else if(DS18B20_IS_ASSIGNED[1]==2){
	RJMP _0x11F
_0x11E:
	__POINTW2MN _DS18B20_IS_ASSIGNED,1
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x120
; 0000 05AB                             lcd_putsf("OFF");
	__POINTW1FN _0x0,240
	RJMP _0x2ED
; 0000 05AC                             }
; 0000 05AD                             else{
_0x120:
; 0000 05AE                             lcd_putsf("----");
	__POINTW1FN _0x0,244
_0x2ED:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05AF                             }
_0x11F:
; 0000 05B0                         }
; 0000 05B1                         else if(row==3){
	RJMP _0x122
_0x11D:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x123
; 0000 05B2                         lcd_putsf("3.SKLENDES:  ");
	__POINTW1FN _0x0,262
	RJMP _0x2EB
; 0000 05B3 
; 0000 05B4                         }
; 0000 05B5                         else if(row==4){
_0x123:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x125
; 0000 05B6                         lcd_putsf("4.SOLIAR.1: ");
	__POINTW1FN _0x0,276
	CALL SUBOPT_0x12
; 0000 05B7                             if(DS18B20_IS_ASSIGNED[2]==1){
	__POINTW2MN _DS18B20_IS_ASSIGNED,2
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x126
; 0000 05B8                             char lcd_buffer[10];
; 0000 05B9                             sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[2]);
	CALL SUBOPT_0x4E
;	row -> Y+11
;	lcd_row -> Y+10
;	lcd_buffer -> Y+0
	__GETD1MN _TEMPERATURES,8
	CALL SUBOPT_0x4F
; 0000 05BA                             lcd_puts(lcd_buffer);
; 0000 05BB                             }
; 0000 05BC                             else if(DS18B20_IS_ASSIGNED[2]==2){
	RJMP _0x127
_0x126:
	__POINTW2MN _DS18B20_IS_ASSIGNED,2
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x128
; 0000 05BD                             lcd_putsf("OFF");
	__POINTW1FN _0x0,240
	RJMP _0x2EE
; 0000 05BE                             }
; 0000 05BF                             else{
_0x128:
; 0000 05C0                             lcd_putsf("----");
	__POINTW1FN _0x0,244
_0x2EE:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05C1                             }
_0x127:
; 0000 05C2                         }
; 0000 05C3                         else if(row==5){
	RJMP _0x12A
_0x125:
	LDD  R26,Y+1
	CPI  R26,LOW(0x5)
	BRNE _0x12B
; 0000 05C4                         lcd_putsf("5.SOLIAR.2: ");
	__POINTW1FN _0x0,289
	CALL SUBOPT_0x12
; 0000 05C5                             if(DS18B20_IS_ASSIGNED[3]==1){
	__POINTW2MN _DS18B20_IS_ASSIGNED,3
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x12C
; 0000 05C6                             char lcd_buffer[10];
; 0000 05C7                             sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[3]);
	CALL SUBOPT_0x4E
;	row -> Y+11
;	lcd_row -> Y+10
;	lcd_buffer -> Y+0
	__GETD1MN _TEMPERATURES,12
	CALL SUBOPT_0x4F
; 0000 05C8                             lcd_puts(lcd_buffer);
; 0000 05C9                             }
; 0000 05CA                             else if(DS18B20_IS_ASSIGNED[3]==2){
	RJMP _0x12D
_0x12C:
	__POINTW2MN _DS18B20_IS_ASSIGNED,3
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x12E
; 0000 05CB                             lcd_putsf("OFF");
	__POINTW1FN _0x0,240
	RJMP _0x2EF
; 0000 05CC                             }
; 0000 05CD                             else{
_0x12E:
; 0000 05CE                             lcd_putsf("----");
	__POINTW1FN _0x0,244
_0x2EF:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05CF                             }
_0x12D:
; 0000 05D0                         }
; 0000 05D1                         else if(row==6){
	RJMP _0x130
_0x12B:
	LDD  R26,Y+1
	CPI  R26,LOW(0x6)
	BRNE _0x131
; 0000 05D2                         lcd_putsf("6.SOLIAR.3: ");
	__POINTW1FN _0x0,302
	CALL SUBOPT_0x12
; 0000 05D3                             if(DS18B20_IS_ASSIGNED[4]==1){
	__POINTW2MN _DS18B20_IS_ASSIGNED,4
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x132
; 0000 05D4                             char lcd_buffer[10];
; 0000 05D5                             sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[4]);
	CALL SUBOPT_0x4E
;	row -> Y+11
;	lcd_row -> Y+10
;	lcd_buffer -> Y+0
	__GETD1MN _TEMPERATURES,16
	CALL SUBOPT_0x4F
; 0000 05D6                             lcd_puts(lcd_buffer);
; 0000 05D7                             }
; 0000 05D8                             else if(DS18B20_IS_ASSIGNED[4]==2){
	RJMP _0x133
_0x132:
	__POINTW2MN _DS18B20_IS_ASSIGNED,4
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x134
; 0000 05D9                             lcd_putsf("OFF");
	__POINTW1FN _0x0,240
	RJMP _0x2F0
; 0000 05DA                             }
; 0000 05DB                             else{
_0x134:
; 0000 05DC                             lcd_putsf("----");
	__POINTW1FN _0x0,244
_0x2F0:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05DD                             }
_0x133:
; 0000 05DE                         }
; 0000 05DF                         else if(row==7){
	RJMP _0x136
_0x131:
	LDD  R26,Y+1
	CPI  R26,LOW(0x7)
	BRNE _0x137
; 0000 05E0                         lcd_putsf("7.NUSTATYMAI");
	__POINTW1FN _0x0,315
_0x2EB:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05E1                         }
; 0000 05E2                     lcd_row++;
_0x137:
_0x136:
_0x130:
_0x12A:
_0x122:
_0x11C:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 05E3                     }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x113
_0x114:
; 0000 05E4 
; 0000 05E5                 lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 05E6                 lcd_putchar('<');
; 0000 05E7                 }
; 0000 05E8             }
_0x111:
; 0000 05E9 
; 0000 05EA             // Kambario temp
; 0000 05EB             else if(Address[0]==1){
	JMP  _0x138
_0x10B:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x139
; 0000 05EC             unsigned char USING_TEMPERATURE_SENSOR=0;
; 0000 05ED                 if(BUTTON[BUTTON_DOWN]==1){
	SBIW R28,1
	LDI  R30,LOW(0)
	CALL SUBOPT_0x52
;	USING_TEMPERATURE_SENSOR -> Y+0
	BRNE _0x13A
; 0000 05EE                 SelectAnotherRow(0);
	CALL SUBOPT_0x48
; 0000 05EF                 }
; 0000 05F0                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x13B
_0x13A:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x13C
; 0000 05F1                 SelectAnotherRow(1);
	CALL SUBOPT_0x49
; 0000 05F2                 }
; 0000 05F3                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x13D
_0x13C:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x13E
; 0000 05F4                     if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x13F
; 0000 05F5                     Address[0] = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4A
; 0000 05F6                     SelectedRow = 0;
; 0000 05F7                     Address[5] = 0;
; 0000 05F8                     }
; 0000 05F9                 }
_0x13F:
; 0000 05FA                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x140
_0x13E:
	__GETB2MN _BUTTON_S0000006001,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x141
; 0000 05FB                     if(SelectedRow==1){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x142
; 0000 05FC                         if(ROOM_TEMPERATURE>10.0){
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	BREQ PC+2
	BRCC PC+3
	JMP  _0x143
; 0000 05FD                         ROOM_TEMPERATURE = ROOM_TEMPERATURE - 0.1;
	CALL SUBOPT_0x19
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	LDI  R26,LOW(_ROOM_TEMPERATURE)
	LDI  R27,HIGH(_ROOM_TEMPERATURE)
	RJMP _0x2F1
; 0000 05FE                         }
; 0000 05FF                         else{
_0x143:
; 0000 0600                         ROOM_TEMPERATURE = 10.0;
	LDI  R26,LOW(_ROOM_TEMPERATURE)
	LDI  R27,HIGH(_ROOM_TEMPERATURE)
	CALL SUBOPT_0x55
_0x2F1:
	CALL __EEPROMWRD
; 0000 0601                         }
; 0000 0602                     }
; 0000 0603                     else if((SelectedRow==2)||(SelectedRow==3)){
	RJMP _0x145
_0x142:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BREQ _0x147
	CPI  R26,LOW(0x3)
	BREQ _0x147
	RJMP _0x146
_0x147:
; 0000 0604                         if((DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1)||(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2)){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BREQ _0x14A
	CPI  R30,LOW(0x2)
	BREQ _0x14A
	RJMP _0x149
_0x14A:
; 0000 0605                         signed char i, Found=0;
; 0000 0606                             for(i=ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR]-1;i>=0;i--){
	CALL SUBOPT_0x56
;	USING_TEMPERATURE_SENSOR -> Y+2
;	i -> Y+1
;	Found -> Y+0
	LD   R30,Z
	CALL SUBOPT_0x3
	STD  Y+1,R30
_0x14D:
	LDD  R26,Y+1
	CPI  R26,0
	BRGE PC+3
	JMP _0x14E
; 0000 0607                             unsigned char used=0, a;
; 0000 0608                                 for(a=0;a<MAX_DS18B20_DEVICES;a++){
	CALL SUBOPT_0x57
;	USING_TEMPERATURE_SENSOR -> Y+4
;	i -> Y+3
;	Found -> Y+2
;	used -> Y+1
;	a -> Y+0
_0x150:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x151
; 0000 0609                                     if(DS18B20_IS_ASSIGNED[a]==1){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x152
; 0000 060A                                         if(ds18b20_sensor_assignation[a]==i){
	LD   R30,Y
	CALL SUBOPT_0x25
	CALL SUBOPT_0x58
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x153
; 0000 060B                                         used = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 060C                                         break;
	RJMP _0x151
; 0000 060D                                         }
; 0000 060E                                     }
_0x153:
; 0000 060F                                 }
_0x152:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x150
_0x151:
; 0000 0610 
; 0000 0611                                 if(used==0){
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x154
; 0000 0612                                 unsigned char b;
; 0000 0613                                 ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
	CALL SUBOPT_0x59
;	USING_TEMPERATURE_SENSOR -> Y+5
;	i -> Y+4
;	Found -> Y+3
;	used -> Y+2
;	a -> Y+1
;	b -> Y+0
	CALL SUBOPT_0x5A
; 0000 0614                                     for(b=0;b<9;b++){
_0x156:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRSH _0x157
; 0000 0615                                     DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];
	LDD  R30,Y+5
	CALL SUBOPT_0x24
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5B
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5C
; 0000 0616                                     }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x156
_0x157:
; 0000 0617                                 TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	LDD  R30,Y+5
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x5D
; 0000 0618                                 Found = 1;
	LDI  R30,LOW(1)
	STD  Y+3,R30
; 0000 0619                                 break;
	ADIW R28,3
	RJMP _0x14E
; 0000 061A                                 }
; 0000 061B                             }
_0x154:
	ADIW R28,2
	LDD  R30,Y+1
	SUBI R30,LOW(1)
	STD  Y+1,R30
	RJMP _0x14D
_0x14E:
; 0000 061C 
; 0000 061D                             if(Found==0){
	LD   R30,Y
	CPI  R30,0
	BRNE _0x158
; 0000 061E                             DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 0;
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x5E
; 0000 061F                             ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = 255;
	CALL SUBOPT_0x5F
; 0000 0620                             TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 0621                             }
; 0000 0622                         }
_0x158:
	ADIW R28,2
; 0000 0623                     }
_0x149:
; 0000 0624                 }
_0x146:
_0x145:
; 0000 0625                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x159
_0x141:
	__GETB2MN _BUTTON_S0000006001,3
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x15A
; 0000 0626                     if(SelectedRow==1){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x15B
; 0000 0627                         if(ROOM_TEMPERATURE<30.0){
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	BRSH _0x15C
; 0000 0628                         ROOM_TEMPERATURE = ROOM_TEMPERATURE + 0.1;
	CALL SUBOPT_0x34
	__GETD2N 0x3DCCCCCD
	CALL __ADDF12
	LDI  R26,LOW(_ROOM_TEMPERATURE)
	LDI  R27,HIGH(_ROOM_TEMPERATURE)
	RJMP _0x2F2
; 0000 0629                         }
; 0000 062A                         else{
_0x15C:
; 0000 062B                         ROOM_TEMPERATURE = 30.0;
	LDI  R26,LOW(_ROOM_TEMPERATURE)
	LDI  R27,HIGH(_ROOM_TEMPERATURE)
	__GETD1N 0x41F00000
_0x2F2:
	CALL __EEPROMWRD
; 0000 062C                         }
; 0000 062D                     }
; 0000 062E                     else if((SelectedRow==2)||(SelectedRow==3)){
	RJMP _0x15E
_0x15B:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BREQ _0x160
	CPI  R26,LOW(0x3)
	BREQ _0x160
	RJMP _0x15F
_0x160:
; 0000 062F                     unsigned char i, Found=0;
; 0000 0630 
; 0000 0631                         if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	CALL SUBOPT_0x60
;	USING_TEMPERATURE_SENSOR -> Y+2
;	i -> Y+1
;	Found -> Y+0
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x162
; 0000 0632                         i = ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] + 1;
	LDD  R30,Y+2
	CALL SUBOPT_0x25
	LD   R30,Z
	SUBI R30,-LOW(1)
	RJMP _0x2F3
; 0000 0633                         }
; 0000 0634                         else{
_0x162:
; 0000 0635                         i = 0;
	LDI  R30,LOW(0)
_0x2F3:
	STD  Y+1,R30
; 0000 0636                         }
; 0000 0637 
; 0000 0638                         for(i=i;i<ds18b20_devices;i++){
	STD  Y+1,R30
_0x165:
	CALL SUBOPT_0x20
	BRLO PC+3
	JMP _0x166
; 0000 0639                         unsigned char used=0, a;
; 0000 063A                             for(a=0;a<MAX_DS18B20_DEVICES;a++){
	CALL SUBOPT_0x57
;	USING_TEMPERATURE_SENSOR -> Y+4
;	i -> Y+3
;	Found -> Y+2
;	used -> Y+1
;	a -> Y+0
_0x168:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x169
; 0000 063B                                 if(DS18B20_IS_ASSIGNED[a]==1){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x16A
; 0000 063C                                     if(ds18b20_sensor_assignation[a]==i){
	LD   R30,Y
	CALL SUBOPT_0x25
	LD   R26,Z
	LDD  R30,Y+3
	CP   R30,R26
	BRNE _0x16B
; 0000 063D                                     used = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 063E                                     break;
	RJMP _0x169
; 0000 063F                                     }
; 0000 0640                                 }
_0x16B:
; 0000 0641                             }
_0x16A:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x168
_0x169:
; 0000 0642 
; 0000 0643                             if(used==0){
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x16C
; 0000 0644                             unsigned char b;
; 0000 0645                             ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
	CALL SUBOPT_0x59
;	USING_TEMPERATURE_SENSOR -> Y+5
;	i -> Y+4
;	Found -> Y+3
;	used -> Y+2
;	a -> Y+1
;	b -> Y+0
	CALL SUBOPT_0x5A
; 0000 0646                                 for(b=0;b<9;b++){
_0x16E:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRSH _0x16F
; 0000 0647                                 DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];
	LDD  R30,Y+5
	CALL SUBOPT_0x24
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5B
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5C
; 0000 0648                                 }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x16E
_0x16F:
; 0000 0649                             DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 1;
	LDD  R26,Y+5
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x27
; 0000 064A                             Found = 1;
	CALL SUBOPT_0x61
; 0000 064B                             TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 064C                             break;
	ADIW R28,3
	RJMP _0x166
; 0000 064D                             }
; 0000 064E                         }
_0x16C:
	ADIW R28,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x165
_0x166:
; 0000 064F 
; 0000 0650                         if(Found==0){
	LD   R30,Y
	CPI  R30,0
	BRNE _0x170
; 0000 0651                         lcd_clear();
	CALL SUBOPT_0x62
; 0000 0652                         lcd_putsf(" AUKSTESNIO NUMERIO ");
; 0000 0653                         lcd_putsf(" LAISVO TERMOMETRO  ");
	CALL SUBOPT_0x63
; 0000 0654                         lcd_putsf("        NERA        ");
	CALL SUBOPT_0x64
; 0000 0655                         delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 0656                         lcd_clear();
	CALL _lcd_clear
; 0000 0657                         }
; 0000 0658                     }
_0x170:
	ADIW R28,2
; 0000 0659                 }
_0x15F:
_0x15E:
; 0000 065A 
; 0000 065B                 if(RefreshLcd>=1){
_0x15A:
_0x159:
_0x140:
_0x13D:
_0x13B:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x171
; 0000 065C                 unsigned char row, lcd_row;
; 0000 065D                 lcd_row = 0;
	CALL SUBOPT_0x65
;	USING_TEMPERATURE_SENSOR -> Y+2
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 065E                 RowsOnWindow = 4;
; 0000 065F                     for(row=Address[5];row<4+Address[5];row++){
_0x173:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4C
	BRLT PC+3
	JMP _0x174
; 0000 0660                     lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x4D
; 0000 0661                         if(row==0){
	BRNE _0x175
; 0000 0662                         lcd_putsf(" -=KAMBARIO TERM.=- ");
	__POINTW1FN _0x0,391
	CALL SUBOPT_0x12
; 0000 0663                         }
; 0000 0664                         else if(row==1){
	RJMP _0x176
_0x175:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x177
; 0000 0665                         char lcd_buffer[10];
; 0000 0666                         lcd_putsf("1.UZSTATYTA:");
	SBIW R28,10
;	USING_TEMPERATURE_SENSOR -> Y+12
;	row -> Y+11
;	lcd_row -> Y+10
;	lcd_buffer -> Y+0
	__POINTW1FN _0x0,412
	CALL SUBOPT_0x12
; 0000 0667                         sprintf(lcd_buffer,"%+2.1f\xdfC",ROOM_TEMPERATURE);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,231
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x34
	CALL SUBOPT_0x4F
; 0000 0668                         lcd_puts(lcd_buffer);
; 0000 0669                         }
; 0000 066A                         else if(row==2){
	RJMP _0x178
_0x177:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x179
; 0000 066B                         lcd_putsf("2.TEMPERAT.:");
	__POINTW1FN _0x0,425
	CALL SUBOPT_0x12
; 0000 066C                             if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x17A
; 0000 066D                             char lcd_buffer[10];
; 0000 066E                             sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[USING_TEMPERATURE_SENSOR]);
	CALL SUBOPT_0x4E
;	USING_TEMPERATURE_SENSOR -> Y+12
;	row -> Y+11
;	lcd_row -> Y+10
;	lcd_buffer -> Y+0
	LDD  R30,Y+16
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x66
; 0000 066F                             lcd_puts(lcd_buffer);
; 0000 0670                             }
; 0000 0671                             else if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2){
	RJMP _0x17B
_0x17A:
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x17C
; 0000 0672                             lcd_putsf("    OFF");
	__POINTW1FN _0x0,438
	RJMP _0x2F4
; 0000 0673                             }
; 0000 0674                             else{
_0x17C:
; 0000 0675                             lcd_putsf("   ----");
	__POINTW1FN _0x0,446
_0x2F4:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0676                             }
_0x17B:
; 0000 0677                         }
; 0000 0678                         else if(row==3){
	RJMP _0x17E
_0x179:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x17F
; 0000 0679                         lcd_putsf("3.TERMOMETRO NR:");
	__POINTW1FN _0x0,454
	CALL SUBOPT_0x12
; 0000 067A                             if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x180
; 0000 067B                             lcd_putchar(NumToIndex(ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR])+1);
	LDD  R30,Y+2
	CALL SUBOPT_0x25
	CALL SUBOPT_0x67
; 0000 067C                             lcd_putchar('/');
; 0000 067D                             lcd_putchar(NumToIndex(ds18b20_devices));
	RJMP _0x2F5
; 0000 067E                             }
; 0000 067F                             else{
_0x180:
; 0000 0680                             lcd_putsf("-/");
	CALL SUBOPT_0x68
; 0000 0681                             lcd_putchar(NumToIndex(ds18b20_devices));
_0x2F5:
	LDS  R30,_ds18b20_devices_S0000006000
	CALL SUBOPT_0x1E
; 0000 0682                             }
; 0000 0683                         }
; 0000 0684                     lcd_row++;
_0x17F:
_0x17E:
_0x178:
_0x176:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0685                     }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x173
_0x174:
; 0000 0686 
; 0000 0687                 lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0688                 lcd_putchar('<');
; 0000 0689                 }
; 0000 068A             }
_0x171:
	ADIW R28,1
; 0000 068B 
; 0000 068C             // Lauko temp
; 0000 068D             else if(Address[0]==2){
	RJMP _0x182
_0x139:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x183
; 0000 068E             unsigned char USING_TEMPERATURE_SENSOR=1;
; 0000 068F                 if(BUTTON[BUTTON_DOWN]==1){
	SBIW R28,1
	LDI  R30,LOW(1)
	CALL SUBOPT_0x52
;	USING_TEMPERATURE_SENSOR -> Y+0
	BRNE _0x184
; 0000 0690                 SelectAnotherRow(0);
	CALL SUBOPT_0x48
; 0000 0691                 }
; 0000 0692                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x185
_0x184:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x186
; 0000 0693                 SelectAnotherRow(1);
	CALL SUBOPT_0x49
; 0000 0694                 }
; 0000 0695                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x187
_0x186:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x188
; 0000 0696                     if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x189
; 0000 0697                     Address[0] = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4A
; 0000 0698                     SelectedRow = 0;
; 0000 0699                     Address[5] = 0;
; 0000 069A                     }
; 0000 069B                 }
_0x189:
; 0000 069C                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x18A
_0x188:
	__GETB2MN _BUTTON_S0000006001,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x18B
; 0000 069D                     if((SelectedRow==1)||(SelectedRow==2)){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BREQ _0x18D
	CPI  R26,LOW(0x2)
	BREQ _0x18D
	RJMP _0x18C
_0x18D:
; 0000 069E                         if((DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1)||(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2)){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BREQ _0x190
	CPI  R30,LOW(0x2)
	BREQ _0x190
	RJMP _0x18F
_0x190:
; 0000 069F                         signed char i, Found=0;
; 0000 06A0                             for(i=ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR]-1;i>=0;i--){
	CALL SUBOPT_0x56
;	USING_TEMPERATURE_SENSOR -> Y+2
;	i -> Y+1
;	Found -> Y+0
	LD   R30,Z
	CALL SUBOPT_0x3
	STD  Y+1,R30
_0x193:
	LDD  R26,Y+1
	CPI  R26,0
	BRGE PC+3
	JMP _0x194
; 0000 06A1                             unsigned char used=0, a;
; 0000 06A2                                 for(a=0;a<MAX_DS18B20_DEVICES;a++){
	CALL SUBOPT_0x57
;	USING_TEMPERATURE_SENSOR -> Y+4
;	i -> Y+3
;	Found -> Y+2
;	used -> Y+1
;	a -> Y+0
_0x196:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x197
; 0000 06A3                                     if(DS18B20_IS_ASSIGNED[a]==1){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x198
; 0000 06A4                                         if(ds18b20_sensor_assignation[a]==i){
	LD   R30,Y
	CALL SUBOPT_0x25
	CALL SUBOPT_0x58
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x199
; 0000 06A5                                         used = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 06A6                                         break;
	RJMP _0x197
; 0000 06A7                                         }
; 0000 06A8                                     }
_0x199:
; 0000 06A9                                 }
_0x198:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x196
_0x197:
; 0000 06AA 
; 0000 06AB                                 if(used==0){
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x19A
; 0000 06AC                                 unsigned char b;
; 0000 06AD                                 ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
	CALL SUBOPT_0x59
;	USING_TEMPERATURE_SENSOR -> Y+5
;	i -> Y+4
;	Found -> Y+3
;	used -> Y+2
;	a -> Y+1
;	b -> Y+0
	CALL SUBOPT_0x5A
; 0000 06AE                                     for(b=0;b<9;b++){
_0x19C:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRSH _0x19D
; 0000 06AF                                     DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];
	LDD  R30,Y+5
	CALL SUBOPT_0x24
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5B
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5C
; 0000 06B0                                     }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x19C
_0x19D:
; 0000 06B1                                 Found = 1;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x61
; 0000 06B2                                 TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 06B3                                 break;
	ADIW R28,3
	RJMP _0x194
; 0000 06B4                                 }
; 0000 06B5                             }
_0x19A:
	ADIW R28,2
	LDD  R30,Y+1
	SUBI R30,LOW(1)
	STD  Y+1,R30
	RJMP _0x193
_0x194:
; 0000 06B6 
; 0000 06B7                             if(Found==0){
	LD   R30,Y
	CPI  R30,0
	BRNE _0x19E
; 0000 06B8                             DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 0;
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x5E
; 0000 06B9                             ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = 255;
	CALL SUBOPT_0x5F
; 0000 06BA                             TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 06BB                             }
; 0000 06BC                         }
_0x19E:
	ADIW R28,2
; 0000 06BD                     }
_0x18F:
; 0000 06BE                 }
_0x18C:
; 0000 06BF                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x19F
_0x18B:
	__GETB2MN _BUTTON_S0000006001,3
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x1A0
; 0000 06C0                     if((SelectedRow==1)||(SelectedRow==2)){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BREQ _0x1A2
	CPI  R26,LOW(0x2)
	BREQ _0x1A2
	RJMP _0x1A1
_0x1A2:
; 0000 06C1                     unsigned char i, Found=0;
; 0000 06C2                         if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	CALL SUBOPT_0x60
;	USING_TEMPERATURE_SENSOR -> Y+2
;	i -> Y+1
;	Found -> Y+0
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x1A4
; 0000 06C3                         i = ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] + 1;
	LDD  R30,Y+2
	CALL SUBOPT_0x25
	LD   R30,Z
	SUBI R30,-LOW(1)
	RJMP _0x2F6
; 0000 06C4                         }
; 0000 06C5                         else{
_0x1A4:
; 0000 06C6                         i = 0;
	LDI  R30,LOW(0)
_0x2F6:
	STD  Y+1,R30
; 0000 06C7                         }
; 0000 06C8 
; 0000 06C9                         for(i=i;i<ds18b20_devices;i++){
	STD  Y+1,R30
_0x1A7:
	CALL SUBOPT_0x20
	BRLO PC+3
	JMP _0x1A8
; 0000 06CA                         unsigned char used=0, a;
; 0000 06CB                             for(a=0;a<MAX_DS18B20_DEVICES;a++){
	CALL SUBOPT_0x57
;	USING_TEMPERATURE_SENSOR -> Y+4
;	i -> Y+3
;	Found -> Y+2
;	used -> Y+1
;	a -> Y+0
_0x1AA:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x1AB
; 0000 06CC                                 if(DS18B20_IS_ASSIGNED[a]==1){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x1AC
; 0000 06CD                                     if(ds18b20_sensor_assignation[a]==i){
	LD   R30,Y
	CALL SUBOPT_0x25
	LD   R26,Z
	LDD  R30,Y+3
	CP   R30,R26
	BRNE _0x1AD
; 0000 06CE                                     used = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 06CF                                     break;
	RJMP _0x1AB
; 0000 06D0                                     }
; 0000 06D1                                 }
_0x1AD:
; 0000 06D2                             }
_0x1AC:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x1AA
_0x1AB:
; 0000 06D3 
; 0000 06D4                             if(used==0){
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x1AE
; 0000 06D5                             unsigned char b;
; 0000 06D6                             ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
	CALL SUBOPT_0x59
;	USING_TEMPERATURE_SENSOR -> Y+5
;	i -> Y+4
;	Found -> Y+3
;	used -> Y+2
;	a -> Y+1
;	b -> Y+0
	CALL SUBOPT_0x5A
; 0000 06D7                                 for(b=0;b<9;b++){
_0x1B0:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRSH _0x1B1
; 0000 06D8                                 DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];
	LDD  R30,Y+5
	CALL SUBOPT_0x24
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5B
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5C
; 0000 06D9                                 }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x1B0
_0x1B1:
; 0000 06DA                             DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 1;
	LDD  R26,Y+5
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x27
; 0000 06DB                             Found = 1;
	CALL SUBOPT_0x61
; 0000 06DC                             TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 06DD                             break;
	ADIW R28,3
	RJMP _0x1A8
; 0000 06DE                             }
; 0000 06DF                         }
_0x1AE:
	ADIW R28,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x1A7
_0x1A8:
; 0000 06E0 
; 0000 06E1                         if(Found==0){
	LD   R30,Y
	CPI  R30,0
	BRNE _0x1B2
; 0000 06E2                         lcd_clear();
	CALL SUBOPT_0x62
; 0000 06E3                         lcd_putsf(" AUKSTESNIO NUMERIO ");
; 0000 06E4                         lcd_putsf(" LAISVO TERMOMETRO  ");
	CALL SUBOPT_0x63
; 0000 06E5                         lcd_putsf("        NERA        ");
	CALL SUBOPT_0x64
; 0000 06E6                         delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 06E7                         lcd_clear();
	CALL _lcd_clear
; 0000 06E8                         }
; 0000 06E9                     }
_0x1B2:
	ADIW R28,2
; 0000 06EA                 }
_0x1A1:
; 0000 06EB 
; 0000 06EC                 if(RefreshLcd>=1){
_0x1A0:
_0x19F:
_0x18A:
_0x187:
_0x185:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x1B3
; 0000 06ED                 unsigned char row, lcd_row;
; 0000 06EE                 lcd_row = 0;
	CALL SUBOPT_0x65
;	USING_TEMPERATURE_SENSOR -> Y+2
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 06EF                 RowsOnWindow = 4;
; 0000 06F0                     for(row=Address[5];row<4+Address[5];row++){
_0x1B5:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4C
	BRLT PC+3
	JMP _0x1B6
; 0000 06F1                     lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x4D
; 0000 06F2                         if(row==0){
	BRNE _0x1B7
; 0000 06F3                         lcd_putsf("  -=LAUKO TERM.=-  ");
	__POINTW1FN _0x0,474
	CALL SUBOPT_0x12
; 0000 06F4                         }
; 0000 06F5                         else if(row==1){
	RJMP _0x1B8
_0x1B7:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x1B9
; 0000 06F6                         lcd_putsf("1.TEMPERAT.:");
	CALL SUBOPT_0x69
; 0000 06F7                             if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x1BA
; 0000 06F8                             char lcd_buffer[10];
; 0000 06F9                             sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[USING_TEMPERATURE_SENSOR]);
	CALL SUBOPT_0x4E
;	USING_TEMPERATURE_SENSOR -> Y+12
;	row -> Y+11
;	lcd_row -> Y+10
;	lcd_buffer -> Y+0
	LDD  R30,Y+16
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x66
; 0000 06FA                             lcd_puts(lcd_buffer);
; 0000 06FB                             }
; 0000 06FC                             else if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2){
	RJMP _0x1BB
_0x1BA:
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x1BC
; 0000 06FD                             lcd_putsf("    OFF");
	__POINTW1FN _0x0,438
	RJMP _0x2F7
; 0000 06FE                             }
; 0000 06FF                             else{
_0x1BC:
; 0000 0700                             lcd_putsf("   ----");
	__POINTW1FN _0x0,446
_0x2F7:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0701                             }
_0x1BB:
; 0000 0702                         }
; 0000 0703                         else if(row==2){
	RJMP _0x1BE
_0x1B9:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x1BF
; 0000 0704                         lcd_putsf("2.TERMOMETRO NR:");
	CALL SUBOPT_0x6A
; 0000 0705                             if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x1C0
; 0000 0706                             lcd_putchar(NumToIndex(ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR])+1);
	LDD  R30,Y+2
	CALL SUBOPT_0x25
	CALL SUBOPT_0x67
; 0000 0707                             lcd_putchar('/');
; 0000 0708                             lcd_putchar(NumToIndex(ds18b20_devices));
	RJMP _0x2F8
; 0000 0709                             }
; 0000 070A                             else{
_0x1C0:
; 0000 070B                             lcd_putsf("-/");
	CALL SUBOPT_0x68
; 0000 070C                             lcd_putchar(NumToIndex(ds18b20_devices));
_0x2F8:
	LDS  R30,_ds18b20_devices_S0000006000
	CALL SUBOPT_0x1E
; 0000 070D                             }
; 0000 070E                         }
; 0000 070F                     lcd_row++;
_0x1BF:
_0x1BE:
_0x1B8:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0710                     }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x1B5
_0x1B6:
; 0000 0711 
; 0000 0712                 lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0713                 lcd_putchar('<');
; 0000 0714                 }
; 0000 0715             }
_0x1B3:
	ADIW R28,1
; 0000 0716 
; 0000 0717             // Sklendes
; 0000 0718             else if(Address[0]==3){
	RJMP _0x1C2
_0x183:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0x1C3
; 0000 0719                 if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S0000006001,4
	CPI  R26,LOW(0x1)
	BRNE _0x1C4
; 0000 071A                 SelectAnotherRow(0);
	CALL SUBOPT_0x48
; 0000 071B                 }
; 0000 071C                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x1C5
_0x1C4:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x1C6
; 0000 071D                 SelectAnotherRow(1);
	CALL SUBOPT_0x49
; 0000 071E                 }
; 0000 071F                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x1C7
_0x1C6:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x1C8
; 0000 0720                     if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x1C9
; 0000 0721                     Address[0] = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4A
; 0000 0722                     SelectedRow = 0;
; 0000 0723                     Address[5] = 0;
; 0000 0724                     }
; 0000 0725                 }
_0x1C9:
; 0000 0726                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x1CA
_0x1C8:
	__GETB2MN _BUTTON_S0000006001,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x1CB
; 0000 0727                     if(SelectedRow==1){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x1CC
; 0000 0728                         if(MANUAL_CONTROLLER==1){
	CALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0x1CD
; 0000 0729                         MANUAL_CONTROLLER = 0;
	LDI  R26,LOW(_MANUAL_CONTROLLER)
	LDI  R27,HIGH(_MANUAL_CONTROLLER)
	LDI  R30,LOW(0)
	RJMP _0x2F9
; 0000 072A                         }
; 0000 072B                         else{
_0x1CD:
; 0000 072C                         MANUAL_CONTROLLER = 1;
	LDI  R26,LOW(_MANUAL_CONTROLLER)
	LDI  R27,HIGH(_MANUAL_CONTROLLER)
	LDI  R30,LOW(1)
_0x2F9:
	CALL __EEPROMWRB
; 0000 072D                         }
; 0000 072E 
; 0000 072F                     }
; 0000 0730                     else if(SelectedRow==2){
	RJMP _0x1CF
_0x1CC:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x1D0
; 0000 0731                         if(MANUAL_CONTROLLER==1){
	CALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0x1D1
; 0000 0732                             if(dac_data[0]>0){
	LDS  R26,_dac_data
	CPI  R26,LOW(0x1)
	BRLO _0x1D2
; 0000 0733                             dac_data[0]--;
	LDS  R30,_dac_data
	SUBI R30,LOW(1)
	STS  _dac_data,R30
; 0000 0734                             }
; 0000 0735                         }
_0x1D2:
; 0000 0736                     }
_0x1D1:
; 0000 0737                     else if(SelectedRow==3){
	RJMP _0x1D3
_0x1D0:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x1D4
; 0000 0738                         if(MANUAL_CONTROLLER==1){
	CALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0x1D5
; 0000 0739                             if(dac_data[1]>0){
	__GETB2MN _dac_data,1
	CPI  R26,LOW(0x1)
	BRLO _0x1D6
; 0000 073A                             dac_data[1]--;
	__GETB1MN _dac_data,1
	SUBI R30,LOW(1)
	__PUTB1MN _dac_data,1
; 0000 073B                             }
; 0000 073C                         }
_0x1D6:
; 0000 073D                     }
_0x1D5:
; 0000 073E                     else if(SelectedRow==4){
	RJMP _0x1D7
_0x1D4:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x4)
	BRNE _0x1D8
; 0000 073F                         if(MANUAL_CONTROLLER==1){
	CALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0x1D9
; 0000 0740                             if(dac_data[2]>0){
	__GETB2MN _dac_data,2
	CPI  R26,LOW(0x1)
	BRLO _0x1DA
; 0000 0741                             dac_data[2]--;
	__GETB1MN _dac_data,2
	SUBI R30,LOW(1)
	__PUTB1MN _dac_data,2
; 0000 0742                             }
; 0000 0743                         }
_0x1DA:
; 0000 0744                     }
_0x1D9:
; 0000 0745                     else if(SelectedRow==5){
	RJMP _0x1DB
_0x1D8:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x5)
	BRNE _0x1DC
; 0000 0746                         if(MANUAL_CONTROLLER==1){
	CALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0x1DD
; 0000 0747                             if(dac_data[3]>0){
	__GETB2MN _dac_data,3
	CPI  R26,LOW(0x1)
	BRLO _0x1DE
; 0000 0748                             dac_data[3]--;
	__GETB1MN _dac_data,3
	SUBI R30,LOW(1)
	__PUTB1MN _dac_data,3
; 0000 0749                             }
; 0000 074A                         }
_0x1DE:
; 0000 074B                     }
_0x1DD:
; 0000 074C                 }
_0x1DC:
_0x1DB:
_0x1D7:
_0x1D3:
_0x1CF:
; 0000 074D                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x1DF
_0x1CB:
	__GETB2MN _BUTTON_S0000006001,3
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x1E0
; 0000 074E                     if(SelectedRow==1){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x1E1
; 0000 074F                         if(MANUAL_CONTROLLER==1){
	CALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0x1E2
; 0000 0750                         MANUAL_CONTROLLER = 0;
	LDI  R26,LOW(_MANUAL_CONTROLLER)
	LDI  R27,HIGH(_MANUAL_CONTROLLER)
	LDI  R30,LOW(0)
	RJMP _0x2FA
; 0000 0751                         }
; 0000 0752                         else{
_0x1E2:
; 0000 0753                         MANUAL_CONTROLLER = 1;
	LDI  R26,LOW(_MANUAL_CONTROLLER)
	LDI  R27,HIGH(_MANUAL_CONTROLLER)
	LDI  R30,LOW(1)
_0x2FA:
	CALL __EEPROMWRB
; 0000 0754                         }
; 0000 0755                     }
; 0000 0756                     else if(SelectedRow==2){
	RJMP _0x1E4
_0x1E1:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x1E5
; 0000 0757                         if(MANUAL_CONTROLLER==1){
	CALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0x1E6
; 0000 0758                             if(dac_data[0]<255){
	LDS  R26,_dac_data
	CPI  R26,LOW(0xFF)
	BRSH _0x1E7
; 0000 0759                             dac_data[0]++;
	LDS  R30,_dac_data
	SUBI R30,-LOW(1)
	STS  _dac_data,R30
; 0000 075A                             }
; 0000 075B                         }
_0x1E7:
; 0000 075C                     }
_0x1E6:
; 0000 075D                     else if(SelectedRow==3){
	RJMP _0x1E8
_0x1E5:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x1E9
; 0000 075E                         if(MANUAL_CONTROLLER==1){
	CALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0x1EA
; 0000 075F                             if(dac_data[1]<255){
	__GETB2MN _dac_data,1
	CPI  R26,LOW(0xFF)
	BRSH _0x1EB
; 0000 0760                             dac_data[1]++;
	__GETB1MN _dac_data,1
	SUBI R30,-LOW(1)
	__PUTB1MN _dac_data,1
; 0000 0761                             }
; 0000 0762                         }
_0x1EB:
; 0000 0763                     }
_0x1EA:
; 0000 0764                     else if(SelectedRow==4){
	RJMP _0x1EC
_0x1E9:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x4)
	BRNE _0x1ED
; 0000 0765                         if(MANUAL_CONTROLLER==1){
	CALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0x1EE
; 0000 0766                             if(dac_data[2]<255){
	__GETB2MN _dac_data,2
	CPI  R26,LOW(0xFF)
	BRSH _0x1EF
; 0000 0767                             dac_data[2]++;
	__GETB1MN _dac_data,2
	SUBI R30,-LOW(1)
	__PUTB1MN _dac_data,2
; 0000 0768                             }
; 0000 0769                         }
_0x1EF:
; 0000 076A                     }
_0x1EE:
; 0000 076B                     else if(SelectedRow==5){
	RJMP _0x1F0
_0x1ED:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x5)
	BRNE _0x1F1
; 0000 076C                         if(MANUAL_CONTROLLER==1){
	CALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0x1F2
; 0000 076D                             if(dac_data[3]<255){
	__GETB2MN _dac_data,3
	CPI  R26,LOW(0xFF)
	BRSH _0x1F3
; 0000 076E                             dac_data[3]++;
	__GETB1MN _dac_data,3
	SUBI R30,-LOW(1)
	__PUTB1MN _dac_data,3
; 0000 076F                             }
; 0000 0770                         }
_0x1F3:
; 0000 0771                     }
_0x1F2:
; 0000 0772                 }
_0x1F1:
_0x1F0:
_0x1EC:
_0x1E8:
_0x1E4:
; 0000 0773 
; 0000 0774                 if(RefreshLcd>=1){
_0x1E0:
_0x1DF:
_0x1CA:
_0x1C7:
_0x1C5:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x1F4
; 0000 0775                 unsigned char row, lcd_row;
; 0000 0776                 lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0777                 RowsOnWindow = 6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x4B
; 0000 0778                     for(row=Address[5];row<4+Address[5];row++){
_0x1F6:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4C
	BRLT PC+3
	JMP _0x1F7
; 0000 0779                     lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x4D
; 0000 077A                         if(row==0){
	BRNE _0x1F8
; 0000 077B                         lcd_putsf("    -=SKLENDES=-");
	__POINTW1FN _0x0,524
	RJMP _0x2FB
; 0000 077C                         }
; 0000 077D                         else if(row==1){
_0x1F8:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x1FA
; 0000 077E                         lcd_putsf("REZIMAS:");
	__POINTW1FN _0x0,541
	CALL SUBOPT_0x12
; 0000 077F                             if(MANUAL_CONTROLLER==1){
	CALL SUBOPT_0x32
	CPI  R30,LOW(0x1)
	BRNE _0x1FB
; 0000 0780                             lcd_putsf(" RANKINIS");
	__POINTW1FN _0x0,550
	RJMP _0x2FC
; 0000 0781                             }
; 0000 0782                             else{
_0x1FB:
; 0000 0783                             lcd_putsf(" AUTOMAT.");
	__POINTW1FN _0x0,560
_0x2FC:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0784                             }
; 0000 0785                         }
; 0000 0786                         else if(row==2){
	RJMP _0x1FD
_0x1FA:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x1FE
; 0000 0787                         lcd_putsf("LAUKO:    ");
	__POINTW1FN _0x0,251
	CALL SUBOPT_0x12
; 0000 0788                         lcd_put_number(0,3,0,0,dac_data[0],0);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	LDS  R30,_dac_data
	RJMP _0x2FD
; 0000 0789                         lcd_putsf("/255");
; 0000 078A                         }
; 0000 078B                         else if(row==3){
_0x1FE:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x200
; 0000 078C                         lcd_putsf("SOLIAR.1: ");
	__POINTW1FN _0x0,278
	CALL SUBOPT_0x12
; 0000 078D                         lcd_put_number(0,3,0,0,dac_data[1],0);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	__GETB1MN _dac_data,1
	RJMP _0x2FD
; 0000 078E                         lcd_putsf("/255");
; 0000 078F                         }
; 0000 0790                         else if(row==4){
_0x200:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x202
; 0000 0791                         lcd_putsf("SOLIAR.2: ");
	__POINTW1FN _0x0,291
	CALL SUBOPT_0x12
; 0000 0792                         lcd_put_number(0,3,0,0,dac_data[2],0);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	__GETB1MN _dac_data,2
	RJMP _0x2FD
; 0000 0793                         lcd_putsf("/255");
; 0000 0794                         }
; 0000 0795                         else if(row==5){
_0x202:
	LDD  R26,Y+1
	CPI  R26,LOW(0x5)
	BRNE _0x204
; 0000 0796                         lcd_putsf("SOLIAR.3: ");
	__POINTW1FN _0x0,304
	CALL SUBOPT_0x12
; 0000 0797                         lcd_put_number(0,3,0,0,dac_data[3],0);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	__GETB1MN _dac_data,3
_0x2FD:
	LDI  R31,0
	CALL __CWD1
	CALL SUBOPT_0x15
; 0000 0798                         lcd_putsf("/255");
	__POINTW1FN _0x0,570
_0x2FB:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0799                         }
; 0000 079A                     lcd_row++;
_0x204:
_0x1FD:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 079B                     }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x1F6
_0x1F7:
; 0000 079C 
; 0000 079D                 lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 079E                 lcd_putchar('<');
; 0000 079F                 }
; 0000 07A0             }
_0x1F4:
; 0000 07A1 
; 0000 07A2             // 1 soliariumo temp
; 0000 07A3             else if(Address[0]==4){
	RJMP _0x205
_0x1C3:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x206
; 0000 07A4             unsigned char USING_TEMPERATURE_SENSOR=2;
; 0000 07A5                 if(BUTTON[BUTTON_DOWN]==1){
	SBIW R28,1
	LDI  R30,LOW(2)
	CALL SUBOPT_0x52
;	USING_TEMPERATURE_SENSOR -> Y+0
	BRNE _0x207
; 0000 07A6                 SelectAnotherRow(0);
	CALL SUBOPT_0x48
; 0000 07A7                 }
; 0000 07A8                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x208
_0x207:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x209
; 0000 07A9                 SelectAnotherRow(1);
	CALL SUBOPT_0x49
; 0000 07AA                 }
; 0000 07AB                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x20A
_0x209:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x20B
; 0000 07AC                     if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x20C
; 0000 07AD                     Address[0] = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4A
; 0000 07AE                     SelectedRow = 0;
; 0000 07AF                     Address[5] = 0;
; 0000 07B0                     }
; 0000 07B1                 }
_0x20C:
; 0000 07B2                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x20D
_0x20B:
	__GETB2MN _BUTTON_S0000006001,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x20E
; 0000 07B3                     if((SelectedRow==1)||(SelectedRow==2)){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BREQ _0x210
	CPI  R26,LOW(0x2)
	BREQ _0x210
	RJMP _0x20F
_0x210:
; 0000 07B4                         if((DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1)||(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2)){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BREQ _0x213
	CPI  R30,LOW(0x2)
	BREQ _0x213
	RJMP _0x212
_0x213:
; 0000 07B5                         signed char i, Found=0;
; 0000 07B6                             for(i=ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR]-1;i>=0;i--){
	CALL SUBOPT_0x56
;	USING_TEMPERATURE_SENSOR -> Y+2
;	i -> Y+1
;	Found -> Y+0
	LD   R30,Z
	CALL SUBOPT_0x3
	STD  Y+1,R30
_0x216:
	LDD  R26,Y+1
	CPI  R26,0
	BRGE PC+3
	JMP _0x217
; 0000 07B7                             unsigned char used=0, a;
; 0000 07B8                                 for(a=0;a<MAX_DS18B20_DEVICES;a++){
	CALL SUBOPT_0x57
;	USING_TEMPERATURE_SENSOR -> Y+4
;	i -> Y+3
;	Found -> Y+2
;	used -> Y+1
;	a -> Y+0
_0x219:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x21A
; 0000 07B9                                     if(DS18B20_IS_ASSIGNED[a]==1){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x21B
; 0000 07BA                                         if(ds18b20_sensor_assignation[a]==i){
	LD   R30,Y
	CALL SUBOPT_0x25
	CALL SUBOPT_0x58
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x21C
; 0000 07BB                                         used = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 07BC                                         break;
	RJMP _0x21A
; 0000 07BD                                         }
; 0000 07BE                                     }
_0x21C:
; 0000 07BF                                 }
_0x21B:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x219
_0x21A:
; 0000 07C0 
; 0000 07C1                                 if(used==0){
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x21D
; 0000 07C2                                 unsigned char b;
; 0000 07C3                                 ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
	CALL SUBOPT_0x59
;	USING_TEMPERATURE_SENSOR -> Y+5
;	i -> Y+4
;	Found -> Y+3
;	used -> Y+2
;	a -> Y+1
;	b -> Y+0
	CALL SUBOPT_0x5A
; 0000 07C4                                     for(b=0;b<9;b++){
_0x21F:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRSH _0x220
; 0000 07C5                                     DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];
	LDD  R30,Y+5
	CALL SUBOPT_0x24
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5B
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5C
; 0000 07C6                                     }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x21F
_0x220:
; 0000 07C7                                 Found = 1;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x61
; 0000 07C8                                 TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 07C9                                 break;
	ADIW R28,3
	RJMP _0x217
; 0000 07CA                                 }
; 0000 07CB                             }
_0x21D:
	ADIW R28,2
	LDD  R30,Y+1
	SUBI R30,LOW(1)
	STD  Y+1,R30
	RJMP _0x216
_0x217:
; 0000 07CC 
; 0000 07CD                             if(Found==0){
	LD   R30,Y
	CPI  R30,0
	BRNE _0x221
; 0000 07CE                             DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 0;
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x5E
; 0000 07CF                             ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = 255;
	CALL SUBOPT_0x5F
; 0000 07D0                             TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 07D1                             }
; 0000 07D2                         }
_0x221:
	ADIW R28,2
; 0000 07D3                     }
_0x212:
; 0000 07D4                 }
_0x20F:
; 0000 07D5                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x222
_0x20E:
	__GETB2MN _BUTTON_S0000006001,3
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x223
; 0000 07D6                     if((SelectedRow==1)||(SelectedRow==2)){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BREQ _0x225
	CPI  R26,LOW(0x2)
	BREQ _0x225
	RJMP _0x224
_0x225:
; 0000 07D7                     unsigned char i, Found=0;
; 0000 07D8                         if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	CALL SUBOPT_0x60
;	USING_TEMPERATURE_SENSOR -> Y+2
;	i -> Y+1
;	Found -> Y+0
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x227
; 0000 07D9                         i = ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] + 1;
	LDD  R30,Y+2
	CALL SUBOPT_0x25
	LD   R30,Z
	SUBI R30,-LOW(1)
	RJMP _0x2FE
; 0000 07DA                         }
; 0000 07DB                         else{
_0x227:
; 0000 07DC                         i = 0;
	LDI  R30,LOW(0)
_0x2FE:
	STD  Y+1,R30
; 0000 07DD                         }
; 0000 07DE 
; 0000 07DF                         for(i=i;i<ds18b20_devices;i++){
	STD  Y+1,R30
_0x22A:
	CALL SUBOPT_0x20
	BRLO PC+3
	JMP _0x22B
; 0000 07E0                         unsigned char used=0, a;
; 0000 07E1                             for(a=0;a<MAX_DS18B20_DEVICES;a++){
	CALL SUBOPT_0x57
;	USING_TEMPERATURE_SENSOR -> Y+4
;	i -> Y+3
;	Found -> Y+2
;	used -> Y+1
;	a -> Y+0
_0x22D:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x22E
; 0000 07E2                                 if(DS18B20_IS_ASSIGNED[a]==1){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x22F
; 0000 07E3                                     if(ds18b20_sensor_assignation[a]==i){
	LD   R30,Y
	CALL SUBOPT_0x25
	LD   R26,Z
	LDD  R30,Y+3
	CP   R30,R26
	BRNE _0x230
; 0000 07E4                                     used = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 07E5                                     break;
	RJMP _0x22E
; 0000 07E6                                     }
; 0000 07E7                                 }
_0x230:
; 0000 07E8                             }
_0x22F:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x22D
_0x22E:
; 0000 07E9 
; 0000 07EA                             if(used==0){
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x231
; 0000 07EB                             unsigned char b;
; 0000 07EC                             ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
	CALL SUBOPT_0x59
;	USING_TEMPERATURE_SENSOR -> Y+5
;	i -> Y+4
;	Found -> Y+3
;	used -> Y+2
;	a -> Y+1
;	b -> Y+0
	CALL SUBOPT_0x5A
; 0000 07ED                                 for(b=0;b<9;b++){
_0x233:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRSH _0x234
; 0000 07EE                                 DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];
	LDD  R30,Y+5
	CALL SUBOPT_0x24
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5B
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5C
; 0000 07EF                                 }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x233
_0x234:
; 0000 07F0                             DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 1;
	LDD  R26,Y+5
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x27
; 0000 07F1                             Found = 1;
	CALL SUBOPT_0x61
; 0000 07F2                             TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 07F3                             break;
	ADIW R28,3
	RJMP _0x22B
; 0000 07F4                             }
; 0000 07F5                         }
_0x231:
	ADIW R28,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x22A
_0x22B:
; 0000 07F6 
; 0000 07F7                         if(Found==0){
	LD   R30,Y
	CPI  R30,0
	BRNE _0x235
; 0000 07F8                         lcd_clear();
	CALL SUBOPT_0x62
; 0000 07F9                         lcd_putsf(" AUKSTESNIO NUMERIO ");
; 0000 07FA                         lcd_putsf(" LAISVO TERMOMETRO  ");
	CALL SUBOPT_0x63
; 0000 07FB                         lcd_putsf("        NERA        ");
	CALL SUBOPT_0x64
; 0000 07FC                         delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 07FD                         lcd_clear();
	CALL _lcd_clear
; 0000 07FE                         }
; 0000 07FF                     }
_0x235:
	ADIW R28,2
; 0000 0800                 }
_0x224:
; 0000 0801 
; 0000 0802                 if(RefreshLcd>=1){
_0x223:
_0x222:
_0x20D:
_0x20A:
_0x208:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x236
; 0000 0803                 unsigned char row, lcd_row;
; 0000 0804                 lcd_row = 0;
	CALL SUBOPT_0x65
;	USING_TEMPERATURE_SENSOR -> Y+2
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 0805                 RowsOnWindow = 4;
; 0000 0806                     for(row=Address[5];row<4+Address[5];row++){
_0x238:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4C
	BRLT PC+3
	JMP _0x239
; 0000 0807                     lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x4D
; 0000 0808                         if(row==0){
	BRNE _0x23A
; 0000 0809                         lcd_putsf("-=SOLIAR. 1 TERM.=- ");
	__POINTW1FN _0x0,575
	CALL SUBOPT_0x12
; 0000 080A                         }
; 0000 080B                         else if(row==1){
	RJMP _0x23B
_0x23A:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x23C
; 0000 080C                         lcd_putsf("1.TEMPERAT.:");
	CALL SUBOPT_0x69
; 0000 080D                             if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x23D
; 0000 080E                             char lcd_buffer[10];
; 0000 080F                             sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[USING_TEMPERATURE_SENSOR]);
	CALL SUBOPT_0x4E
;	USING_TEMPERATURE_SENSOR -> Y+12
;	row -> Y+11
;	lcd_row -> Y+10
;	lcd_buffer -> Y+0
	LDD  R30,Y+16
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x66
; 0000 0810                             lcd_puts(lcd_buffer);
; 0000 0811                             }
; 0000 0812                             else if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2){
	RJMP _0x23E
_0x23D:
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x23F
; 0000 0813                             lcd_putsf("    OFF");
	__POINTW1FN _0x0,438
	RJMP _0x2FF
; 0000 0814                             }
; 0000 0815                             else{
_0x23F:
; 0000 0816                             lcd_putsf("   ----");
	__POINTW1FN _0x0,446
_0x2FF:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0817                             }
_0x23E:
; 0000 0818                         }
; 0000 0819                         else if(row==2){
	RJMP _0x241
_0x23C:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x242
; 0000 081A                         lcd_putsf("2.TERMOMETRO NR:");
	CALL SUBOPT_0x6A
; 0000 081B                             if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x243
; 0000 081C                             lcd_putchar(NumToIndex(ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR])+1);
	LDD  R30,Y+2
	CALL SUBOPT_0x25
	CALL SUBOPT_0x67
; 0000 081D                             lcd_putchar('/');
; 0000 081E                             lcd_putchar(NumToIndex(ds18b20_devices));
	RJMP _0x300
; 0000 081F                             }
; 0000 0820                             else{
_0x243:
; 0000 0821                             lcd_putsf("-/");
	CALL SUBOPT_0x68
; 0000 0822                             lcd_putchar(NumToIndex(ds18b20_devices));
_0x300:
	LDS  R30,_ds18b20_devices_S0000006000
	CALL SUBOPT_0x1E
; 0000 0823                             }
; 0000 0824                         }
; 0000 0825                     lcd_row++;
_0x242:
_0x241:
_0x23B:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0826                     }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x238
_0x239:
; 0000 0827 
; 0000 0828                 lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0829                 lcd_putchar('<');
; 0000 082A                 }
; 0000 082B             }
_0x236:
	ADIW R28,1
; 0000 082C 
; 0000 082D             // 2 soliariumo temp
; 0000 082E             else if(Address[0]==5){
	RJMP _0x245
_0x206:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x5)
	BREQ PC+3
	JMP _0x246
; 0000 082F             unsigned char USING_TEMPERATURE_SENSOR=3;
; 0000 0830                 if(BUTTON[BUTTON_DOWN]==1){
	SBIW R28,1
	LDI  R30,LOW(3)
	CALL SUBOPT_0x52
;	USING_TEMPERATURE_SENSOR -> Y+0
	BRNE _0x247
; 0000 0831                 SelectAnotherRow(0);
	CALL SUBOPT_0x48
; 0000 0832                 }
; 0000 0833                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x248
_0x247:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x249
; 0000 0834                 SelectAnotherRow(1);
	CALL SUBOPT_0x49
; 0000 0835                 }
; 0000 0836                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x24A
_0x249:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x24B
; 0000 0837                     if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x24C
; 0000 0838                     Address[0] = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4A
; 0000 0839                     SelectedRow = 0;
; 0000 083A                     Address[5] = 0;
; 0000 083B                     }
; 0000 083C                 }
_0x24C:
; 0000 083D                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x24D
_0x24B:
	__GETB2MN _BUTTON_S0000006001,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x24E
; 0000 083E                     if((SelectedRow==1)||(SelectedRow==2)){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BREQ _0x250
	CPI  R26,LOW(0x2)
	BREQ _0x250
	RJMP _0x24F
_0x250:
; 0000 083F                         if((DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1)||(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2)){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BREQ _0x253
	CPI  R30,LOW(0x2)
	BREQ _0x253
	RJMP _0x252
_0x253:
; 0000 0840                         signed char i, Found=0;
; 0000 0841                             for(i=ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR]-1;i>=0;i--){
	CALL SUBOPT_0x56
;	USING_TEMPERATURE_SENSOR -> Y+2
;	i -> Y+1
;	Found -> Y+0
	LD   R30,Z
	CALL SUBOPT_0x3
	STD  Y+1,R30
_0x256:
	LDD  R26,Y+1
	CPI  R26,0
	BRGE PC+3
	JMP _0x257
; 0000 0842                             unsigned char used=0, a;
; 0000 0843                                 for(a=0;a<MAX_DS18B20_DEVICES;a++){
	CALL SUBOPT_0x57
;	USING_TEMPERATURE_SENSOR -> Y+4
;	i -> Y+3
;	Found -> Y+2
;	used -> Y+1
;	a -> Y+0
_0x259:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x25A
; 0000 0844                                     if(DS18B20_IS_ASSIGNED[a]==1){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x25B
; 0000 0845                                         if(ds18b20_sensor_assignation[a]==i){
	LD   R30,Y
	CALL SUBOPT_0x25
	CALL SUBOPT_0x58
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x25C
; 0000 0846                                         used = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 0847                                         break;
	RJMP _0x25A
; 0000 0848                                         }
; 0000 0849                                     }
_0x25C:
; 0000 084A                                 }
_0x25B:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x259
_0x25A:
; 0000 084B 
; 0000 084C                                 if(used==0){
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x25D
; 0000 084D                                 unsigned char b;
; 0000 084E                                 ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
	CALL SUBOPT_0x59
;	USING_TEMPERATURE_SENSOR -> Y+5
;	i -> Y+4
;	Found -> Y+3
;	used -> Y+2
;	a -> Y+1
;	b -> Y+0
	CALL SUBOPT_0x5A
; 0000 084F                                     for(b=0;b<9;b++){
_0x25F:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRSH _0x260
; 0000 0850                                     DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];
	LDD  R30,Y+5
	CALL SUBOPT_0x24
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5B
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5C
; 0000 0851                                     }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x25F
_0x260:
; 0000 0852                                 Found = 1;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x61
; 0000 0853                                 TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 0854                                 break;
	ADIW R28,3
	RJMP _0x257
; 0000 0855                                 }
; 0000 0856                             }
_0x25D:
	ADIW R28,2
	LDD  R30,Y+1
	SUBI R30,LOW(1)
	STD  Y+1,R30
	RJMP _0x256
_0x257:
; 0000 0857 
; 0000 0858                             if(Found==0){
	LD   R30,Y
	CPI  R30,0
	BRNE _0x261
; 0000 0859                             DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 0;
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x5E
; 0000 085A                             ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = 255;
	CALL SUBOPT_0x5F
; 0000 085B                             TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 085C                             }
; 0000 085D                         }
_0x261:
	ADIW R28,2
; 0000 085E                     }
_0x252:
; 0000 085F                 }
_0x24F:
; 0000 0860                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x262
_0x24E:
	__GETB2MN _BUTTON_S0000006001,3
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x263
; 0000 0861                     if((SelectedRow==1)||(SelectedRow==2)){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BREQ _0x265
	CPI  R26,LOW(0x2)
	BREQ _0x265
	RJMP _0x264
_0x265:
; 0000 0862                     unsigned char i, Found=0;
; 0000 0863                         if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	CALL SUBOPT_0x60
;	USING_TEMPERATURE_SENSOR -> Y+2
;	i -> Y+1
;	Found -> Y+0
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x267
; 0000 0864                         i = ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] + 1;
	LDD  R30,Y+2
	CALL SUBOPT_0x25
	LD   R30,Z
	SUBI R30,-LOW(1)
	RJMP _0x301
; 0000 0865                         }
; 0000 0866                         else{
_0x267:
; 0000 0867                         i = 0;
	LDI  R30,LOW(0)
_0x301:
	STD  Y+1,R30
; 0000 0868                         }
; 0000 0869 
; 0000 086A                         for(i=i;i<ds18b20_devices;i++){
	STD  Y+1,R30
_0x26A:
	CALL SUBOPT_0x20
	BRLO PC+3
	JMP _0x26B
; 0000 086B                         unsigned char used=0, a;
; 0000 086C                             for(a=0;a<MAX_DS18B20_DEVICES;a++){
	CALL SUBOPT_0x57
;	USING_TEMPERATURE_SENSOR -> Y+4
;	i -> Y+3
;	Found -> Y+2
;	used -> Y+1
;	a -> Y+0
_0x26D:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x26E
; 0000 086D                                 if(DS18B20_IS_ASSIGNED[a]==1){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x26F
; 0000 086E                                     if(ds18b20_sensor_assignation[a]==i){
	LD   R30,Y
	CALL SUBOPT_0x25
	LD   R26,Z
	LDD  R30,Y+3
	CP   R30,R26
	BRNE _0x270
; 0000 086F                                     used = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 0870                                     break;
	RJMP _0x26E
; 0000 0871                                     }
; 0000 0872                                 }
_0x270:
; 0000 0873                             }
_0x26F:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x26D
_0x26E:
; 0000 0874 
; 0000 0875                             if(used==0){
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x271
; 0000 0876                             unsigned char b;
; 0000 0877                             ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
	CALL SUBOPT_0x59
;	USING_TEMPERATURE_SENSOR -> Y+5
;	i -> Y+4
;	Found -> Y+3
;	used -> Y+2
;	a -> Y+1
;	b -> Y+0
	CALL SUBOPT_0x5A
; 0000 0878                                 for(b=0;b<9;b++){
_0x273:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRSH _0x274
; 0000 0879                                 DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];
	LDD  R30,Y+5
	CALL SUBOPT_0x24
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5B
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5C
; 0000 087A                                 }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x273
_0x274:
; 0000 087B                             DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 1;
	LDD  R26,Y+5
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x27
; 0000 087C                             Found = 1;
	CALL SUBOPT_0x61
; 0000 087D                             TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 087E                             break;
	ADIW R28,3
	RJMP _0x26B
; 0000 087F                             }
; 0000 0880                         }
_0x271:
	ADIW R28,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x26A
_0x26B:
; 0000 0881 
; 0000 0882                         if(Found==0){
	LD   R30,Y
	CPI  R30,0
	BRNE _0x275
; 0000 0883                         lcd_clear();
	CALL SUBOPT_0x62
; 0000 0884                         lcd_putsf(" AUKSTESNIO NUMERIO ");
; 0000 0885                         lcd_putsf(" LAISVO TERMOMETRO  ");
	CALL SUBOPT_0x63
; 0000 0886                         lcd_putsf("        NERA        ");
	CALL SUBOPT_0x64
; 0000 0887                         delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 0888                         lcd_clear();
	CALL _lcd_clear
; 0000 0889                         }
; 0000 088A                     }
_0x275:
	ADIW R28,2
; 0000 088B                 }
_0x264:
; 0000 088C 
; 0000 088D                 if(RefreshLcd>=1){
_0x263:
_0x262:
_0x24D:
_0x24A:
_0x248:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x276
; 0000 088E                 unsigned char row, lcd_row;
; 0000 088F                 lcd_row = 0;
	CALL SUBOPT_0x65
;	USING_TEMPERATURE_SENSOR -> Y+2
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 0890                 RowsOnWindow = 4;
; 0000 0891                     for(row=Address[5];row<4+Address[5];row++){
_0x278:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4C
	BRLT PC+3
	JMP _0x279
; 0000 0892                     lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x4D
; 0000 0893                         if(row==0){
	BRNE _0x27A
; 0000 0894                         lcd_putsf("-=SOLIAR. 2 TERM.=- ");
	__POINTW1FN _0x0,596
	CALL SUBOPT_0x12
; 0000 0895                         }
; 0000 0896                         else if(row==1){
	RJMP _0x27B
_0x27A:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x27C
; 0000 0897                         lcd_putsf("1.TEMPERAT.:");
	CALL SUBOPT_0x69
; 0000 0898                             if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x27D
; 0000 0899                             char lcd_buffer[10];
; 0000 089A                             sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[USING_TEMPERATURE_SENSOR]);
	CALL SUBOPT_0x4E
;	USING_TEMPERATURE_SENSOR -> Y+12
;	row -> Y+11
;	lcd_row -> Y+10
;	lcd_buffer -> Y+0
	LDD  R30,Y+16
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x66
; 0000 089B                             lcd_puts(lcd_buffer);
; 0000 089C                             }
; 0000 089D                             else if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2){
	RJMP _0x27E
_0x27D:
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x27F
; 0000 089E                             lcd_putsf("    OFF");
	__POINTW1FN _0x0,438
	RJMP _0x302
; 0000 089F                             }
; 0000 08A0                             else{
_0x27F:
; 0000 08A1                             lcd_putsf("   ----");
	__POINTW1FN _0x0,446
_0x302:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 08A2                             }
_0x27E:
; 0000 08A3                         }
; 0000 08A4                         else if(row==2){
	RJMP _0x281
_0x27C:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x282
; 0000 08A5                         lcd_putsf("2.TERMOMETRO NR:");
	CALL SUBOPT_0x6A
; 0000 08A6                             if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x283
; 0000 08A7                             lcd_putchar(NumToIndex(ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR])+1);
	LDD  R30,Y+2
	CALL SUBOPT_0x25
	CALL SUBOPT_0x67
; 0000 08A8                             lcd_putchar('/');
; 0000 08A9                             lcd_putchar(NumToIndex(ds18b20_devices));
	RJMP _0x303
; 0000 08AA                             }
; 0000 08AB                             else{
_0x283:
; 0000 08AC                             lcd_putsf("-/");
	CALL SUBOPT_0x68
; 0000 08AD                             lcd_putchar(NumToIndex(ds18b20_devices));
_0x303:
	LDS  R30,_ds18b20_devices_S0000006000
	CALL SUBOPT_0x1E
; 0000 08AE                             }
; 0000 08AF                         }
; 0000 08B0                     lcd_row++;
_0x282:
_0x281:
_0x27B:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 08B1                     }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x278
_0x279:
; 0000 08B2 
; 0000 08B3                 lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 08B4                 lcd_putchar('<');
; 0000 08B5                 }
; 0000 08B6             }
_0x276:
	ADIW R28,1
; 0000 08B7 
; 0000 08B8             // 3 soliariumo temp
; 0000 08B9             else if(Address[0]==6){
	RJMP _0x285
_0x246:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x6)
	BREQ PC+3
	JMP _0x286
; 0000 08BA             unsigned char USING_TEMPERATURE_SENSOR=4;
; 0000 08BB                 if(BUTTON[BUTTON_DOWN]==1){
	SBIW R28,1
	LDI  R30,LOW(4)
	CALL SUBOPT_0x52
;	USING_TEMPERATURE_SENSOR -> Y+0
	BRNE _0x287
; 0000 08BC                 SelectAnotherRow(0);
	CALL SUBOPT_0x48
; 0000 08BD                 }
; 0000 08BE                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x288
_0x287:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x289
; 0000 08BF                 SelectAnotherRow(1);
	CALL SUBOPT_0x49
; 0000 08C0                 }
; 0000 08C1                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x28A
_0x289:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x28B
; 0000 08C2                     if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x28C
; 0000 08C3                     Address[0] = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4A
; 0000 08C4                     SelectedRow = 0;
; 0000 08C5                     Address[5] = 0;
; 0000 08C6                     }
; 0000 08C7                 }
_0x28C:
; 0000 08C8                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x28D
_0x28B:
	__GETB2MN _BUTTON_S0000006001,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x28E
; 0000 08C9                     if((SelectedRow==1)||(SelectedRow==2)){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BREQ _0x290
	CPI  R26,LOW(0x2)
	BREQ _0x290
	RJMP _0x28F
_0x290:
; 0000 08CA                         if((DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1)||(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2)){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BREQ _0x293
	CPI  R30,LOW(0x2)
	BREQ _0x293
	RJMP _0x292
_0x293:
; 0000 08CB                         signed char i, Found=0;
; 0000 08CC                             for(i=ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR]-1;i>=0;i--){
	CALL SUBOPT_0x56
;	USING_TEMPERATURE_SENSOR -> Y+2
;	i -> Y+1
;	Found -> Y+0
	LD   R30,Z
	CALL SUBOPT_0x3
	STD  Y+1,R30
_0x296:
	LDD  R26,Y+1
	CPI  R26,0
	BRGE PC+3
	JMP _0x297
; 0000 08CD                             unsigned char used=0, a;
; 0000 08CE                                 for(a=0;a<MAX_DS18B20_DEVICES;a++){
	CALL SUBOPT_0x57
;	USING_TEMPERATURE_SENSOR -> Y+4
;	i -> Y+3
;	Found -> Y+2
;	used -> Y+1
;	a -> Y+0
_0x299:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x29A
; 0000 08CF                                     if(DS18B20_IS_ASSIGNED[a]==1){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x29B
; 0000 08D0                                         if(ds18b20_sensor_assignation[a]==i){
	LD   R30,Y
	CALL SUBOPT_0x25
	CALL SUBOPT_0x58
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x29C
; 0000 08D1                                         used = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 08D2                                         break;
	RJMP _0x29A
; 0000 08D3                                         }
; 0000 08D4                                     }
_0x29C:
; 0000 08D5                                 }
_0x29B:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x299
_0x29A:
; 0000 08D6 
; 0000 08D7                                 if(used==0){
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x29D
; 0000 08D8                                 unsigned char b;
; 0000 08D9                                 ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
	CALL SUBOPT_0x59
;	USING_TEMPERATURE_SENSOR -> Y+5
;	i -> Y+4
;	Found -> Y+3
;	used -> Y+2
;	a -> Y+1
;	b -> Y+0
	CALL SUBOPT_0x5A
; 0000 08DA                                     for(b=0;b<9;b++){
_0x29F:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRSH _0x2A0
; 0000 08DB                                     DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];
	LDD  R30,Y+5
	CALL SUBOPT_0x24
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5B
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5C
; 0000 08DC                                     }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x29F
_0x2A0:
; 0000 08DD                                 Found = 1;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x61
; 0000 08DE                                 TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 08DF                                 break;
	ADIW R28,3
	RJMP _0x297
; 0000 08E0                                 }
; 0000 08E1                             }
_0x29D:
	ADIW R28,2
	LDD  R30,Y+1
	SUBI R30,LOW(1)
	STD  Y+1,R30
	RJMP _0x296
_0x297:
; 0000 08E2 
; 0000 08E3                             if(Found==0){
	LD   R30,Y
	CPI  R30,0
	BRNE _0x2A1
; 0000 08E4                             DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 0;
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x5E
; 0000 08E5                             ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = 255;
	CALL SUBOPT_0x5F
; 0000 08E6                             TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 08E7                             }
; 0000 08E8                         }
_0x2A1:
	ADIW R28,2
; 0000 08E9                     }
_0x292:
; 0000 08EA                 }
_0x28F:
; 0000 08EB                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x2A2
_0x28E:
	__GETB2MN _BUTTON_S0000006001,3
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x2A3
; 0000 08EC                     if((SelectedRow==1)||(SelectedRow==2)){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BREQ _0x2A5
	CPI  R26,LOW(0x2)
	BREQ _0x2A5
	RJMP _0x2A4
_0x2A5:
; 0000 08ED                     unsigned char i, Found=0;
; 0000 08EE                         if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	CALL SUBOPT_0x60
;	USING_TEMPERATURE_SENSOR -> Y+2
;	i -> Y+1
;	Found -> Y+0
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x2A7
; 0000 08EF                         i = ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] + 1;
	LDD  R30,Y+2
	CALL SUBOPT_0x25
	LD   R30,Z
	SUBI R30,-LOW(1)
	RJMP _0x304
; 0000 08F0                         }
; 0000 08F1                         else{
_0x2A7:
; 0000 08F2                         i = 0;
	LDI  R30,LOW(0)
_0x304:
	STD  Y+1,R30
; 0000 08F3                         }
; 0000 08F4 
; 0000 08F5                         for(i=i;i<ds18b20_devices;i++){
	STD  Y+1,R30
_0x2AA:
	CALL SUBOPT_0x20
	BRLO PC+3
	JMP _0x2AB
; 0000 08F6                         unsigned char used=0, a;
; 0000 08F7                             for(a=0;a<MAX_DS18B20_DEVICES;a++){
	CALL SUBOPT_0x57
;	USING_TEMPERATURE_SENSOR -> Y+4
;	i -> Y+3
;	Found -> Y+2
;	used -> Y+1
;	a -> Y+0
_0x2AD:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRSH _0x2AE
; 0000 08F8                                 if(DS18B20_IS_ASSIGNED[a]==1){
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x2AF
; 0000 08F9                                     if(ds18b20_sensor_assignation[a]==i){
	LD   R30,Y
	CALL SUBOPT_0x25
	LD   R26,Z
	LDD  R30,Y+3
	CP   R30,R26
	BRNE _0x2B0
; 0000 08FA                                     used = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 08FB                                     break;
	RJMP _0x2AE
; 0000 08FC                                     }
; 0000 08FD                                 }
_0x2B0:
; 0000 08FE                             }
_0x2AF:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x2AD
_0x2AE:
; 0000 08FF 
; 0000 0900                             if(used==0){
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x2B1
; 0000 0901                             unsigned char b;
; 0000 0902                             ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR] = i;
	CALL SUBOPT_0x59
;	USING_TEMPERATURE_SENSOR -> Y+5
;	i -> Y+4
;	Found -> Y+3
;	used -> Y+2
;	a -> Y+1
;	b -> Y+0
	CALL SUBOPT_0x5A
; 0000 0903                                 for(b=0;b<9;b++){
_0x2B3:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRSH _0x2B4
; 0000 0904                                 DS18B20_ADDRESSES[USING_TEMPERATURE_SENSOR][b] = rom_code[i][b];
	LDD  R30,Y+5
	CALL SUBOPT_0x24
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5B
	MOVW R26,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5C
; 0000 0905                                 }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x2B3
_0x2B4:
; 0000 0906                             DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR] = 1;
	LDD  R26,Y+5
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x27
; 0000 0907                             Found = 1;
	CALL SUBOPT_0x61
; 0000 0908                             TEMPERATURES[USING_TEMPERATURE_SENSOR] = 0.0;
	CALL SUBOPT_0x5D
; 0000 0909                             break;
	ADIW R28,3
	RJMP _0x2AB
; 0000 090A                             }
; 0000 090B                         }
_0x2B1:
	ADIW R28,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x2AA
_0x2AB:
; 0000 090C 
; 0000 090D                         if(Found==0){
	LD   R30,Y
	CPI  R30,0
	BRNE _0x2B5
; 0000 090E                         lcd_clear();
	CALL SUBOPT_0x62
; 0000 090F                         lcd_putsf(" AUKSTESNIO NUMERIO ");
; 0000 0910                         lcd_putsf(" LAISVO TERMOMETRO  ");
	CALL SUBOPT_0x63
; 0000 0911                         lcd_putsf("        NERA        ");
	CALL SUBOPT_0x64
; 0000 0912                         delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 0913                         lcd_clear();
	CALL _lcd_clear
; 0000 0914                         }
; 0000 0915                     }
_0x2B5:
	ADIW R28,2
; 0000 0916                 }
_0x2A4:
; 0000 0917 
; 0000 0918                 if(RefreshLcd>=1){
_0x2A3:
_0x2A2:
_0x28D:
_0x28A:
_0x288:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x2B6
; 0000 0919                 unsigned char row, lcd_row;
; 0000 091A                 lcd_row = 0;
	CALL SUBOPT_0x65
;	USING_TEMPERATURE_SENSOR -> Y+2
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 091B                 RowsOnWindow = 4;
; 0000 091C                     for(row=Address[5];row<4+Address[5];row++){
_0x2B8:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4C
	BRLT PC+3
	JMP _0x2B9
; 0000 091D                     lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x4D
; 0000 091E                         if(row==0){
	BRNE _0x2BA
; 0000 091F                         lcd_putsf("-=SOLIAR. 3 TERM.=- ");
	__POINTW1FN _0x0,617
	CALL SUBOPT_0x12
; 0000 0920                         }
; 0000 0921                         else if(row==1){
	RJMP _0x2BB
_0x2BA:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x2BC
; 0000 0922                         lcd_putsf("1.TEMPERAT.:");
	CALL SUBOPT_0x69
; 0000 0923                             if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x2BD
; 0000 0924                             char lcd_buffer[10];
; 0000 0925                             sprintf(lcd_buffer,"%+2.1f\xdfC",TEMPERATURES[USING_TEMPERATURE_SENSOR]);
	CALL SUBOPT_0x4E
;	USING_TEMPERATURE_SENSOR -> Y+12
;	row -> Y+11
;	lcd_row -> Y+10
;	lcd_buffer -> Y+0
	LDD  R30,Y+16
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x66
; 0000 0926                             lcd_puts(lcd_buffer);
; 0000 0927                             }
; 0000 0928                             else if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==2){
	RJMP _0x2BE
_0x2BD:
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x2BF
; 0000 0929                             lcd_putsf("    OFF");
	__POINTW1FN _0x0,438
	RJMP _0x305
; 0000 092A                             }
; 0000 092B                             else{
_0x2BF:
; 0000 092C                             lcd_putsf("   ----");
	__POINTW1FN _0x0,446
_0x305:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 092D                             }
_0x2BE:
; 0000 092E                         }
; 0000 092F                         else if(row==2){
	RJMP _0x2C1
_0x2BC:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x2C2
; 0000 0930                         lcd_putsf("2.TERMOMETRO NR:");
	CALL SUBOPT_0x6A
; 0000 0931                             if(DS18B20_IS_ASSIGNED[USING_TEMPERATURE_SENSOR]==1){
	LDD  R26,Y+2
	CALL SUBOPT_0x2D
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x2C3
; 0000 0932                             lcd_putchar(NumToIndex(ds18b20_sensor_assignation[USING_TEMPERATURE_SENSOR])+1);
	LDD  R30,Y+2
	CALL SUBOPT_0x25
	CALL SUBOPT_0x67
; 0000 0933                             lcd_putchar('/');
; 0000 0934                             lcd_putchar(NumToIndex(ds18b20_devices));
	RJMP _0x306
; 0000 0935                             }
; 0000 0936                             else{
_0x2C3:
; 0000 0937                             lcd_putsf("-/");
	CALL SUBOPT_0x68
; 0000 0938                             lcd_putchar(NumToIndex(ds18b20_devices));
_0x306:
	LDS  R30,_ds18b20_devices_S0000006000
	CALL SUBOPT_0x1E
; 0000 0939                             }
; 0000 093A                         }
; 0000 093B                     lcd_row++;
_0x2C2:
_0x2C1:
_0x2BB:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 093C                     }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x2B8
_0x2B9:
; 0000 093D 
; 0000 093E                 lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 093F                 lcd_putchar('<');
; 0000 0940                 }
; 0000 0941             }
_0x2B6:
	ADIW R28,1
; 0000 0942 
; 0000 0943             // Nustatymai
; 0000 0944             else if(Address[0]==7){
	RJMP _0x2C5
_0x286:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x7)
	BREQ PC+3
	JMP _0x2C6
; 0000 0945                 if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BREQ PC+3
	JMP _0x2C7
; 0000 0946                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S0000006001,4
	CPI  R26,LOW(0x1)
	BRNE _0x2C8
; 0000 0947                     SelectAnotherRow(0);
	CALL SUBOPT_0x48
; 0000 0948                     }
; 0000 0949                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x2C9
_0x2C8:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x2CA
; 0000 094A                     SelectAnotherRow(1);
	CALL SUBOPT_0x49
; 0000 094B                     }
; 0000 094C                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x2CB
_0x2CA:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x2CC
; 0000 094D                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x2CD
; 0000 094E                         Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
; 0000 094F                         }
; 0000 0950                         else{
	RJMP _0x2CE
_0x2CD:
; 0000 0951                         Address[1] = SelectedRow;
	LDS  R30,_SelectedRow_G000
	__PUTB1MN _Address_G000,1
; 0000 0952                         }
_0x2CE:
; 0000 0953                     SelectedRow = 0;
	CALL SUBOPT_0x6B
; 0000 0954                     Address[5] = 0;
; 0000 0955                     }
; 0000 0956 
; 0000 0957                     if(RefreshLcd>=1){
_0x2CC:
_0x2CB:
_0x2C9:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x2CF
; 0000 0958                     unsigned char row, lcd_row;
; 0000 0959                     lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 095A                     RowsOnWindow = 1;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x4B
; 0000 095B                         for(row=Address[5];row<4+Address[5];row++){
_0x2D1:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4C
	BRGE _0x2D2
; 0000 095C                         lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x4D
; 0000 095D                             if(row==0){
	BRNE _0x2D3
; 0000 095E                             lcd_putsf("   -=NUSTATYMAI=-   ");
	__POINTW1FN _0x0,638
	RJMP _0x307
; 0000 095F                             }
; 0000 0960                             else if(row==1){
_0x2D3:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x2D5
; 0000 0961                             lcd_putsf("NEBAIGTA");
	__POINTW1FN _0x0,659
_0x307:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0962                             }
; 0000 0963                         lcd_row++;
_0x2D5:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0964                         }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x2D1
_0x2D2:
; 0000 0965                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0966                     lcd_putchar('<');
; 0000 0967                     }
; 0000 0968                 }
_0x2CF:
; 0000 0969                 else if(Address[1]==1){
	RJMP _0x2D6
_0x2C7:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x2D7
; 0000 096A                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S0000006001,4
	CPI  R26,LOW(0x1)
	BRNE _0x2D8
; 0000 096B                         if(lcd_light>0){
	CALL SUBOPT_0x18
	CPI  R30,LOW(0x1)
	BRLO _0x2D9
; 0000 096C                         lcd_light += -1;
	CALL SUBOPT_0x18
	SUBI R30,-LOW(255)
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	CALL __EEPROMWRB
; 0000 096D                         }
; 0000 096E                     }
_0x2D9:
; 0000 096F                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x2DA
_0x2D8:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x2DB
; 0000 0970                         if(lcd_light<20){
	CALL SUBOPT_0x18
	CPI  R30,LOW(0x14)
	BRSH _0x2DC
; 0000 0971                         lcd_light += 1;
	CALL SUBOPT_0x18
	SUBI R30,-LOW(1)
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	CALL __EEPROMWRB
; 0000 0972                         }
; 0000 0973                     }
_0x2DC:
; 0000 0974                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x2DD
_0x2DB:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x2DE
; 0000 0975                     Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 0976                     SelectedRow = 0;
	CALL SUBOPT_0x6B
; 0000 0977                     Address[5] = 0;
; 0000 0978                     }
; 0000 0979 
; 0000 097A                     if(RefreshLcd>=1){
_0x2DE:
_0x2DD:
_0x2DA:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x2DF
; 0000 097B                     lcd_putsf("-=EKRANO APSVIET.=- ");
	__POINTW1FN _0x0,668
	CALL SUBOPT_0x12
; 0000 097C                     lcd_putsf("APSVIETIMAS:");
	__POINTW1FN _0x0,689
	CALL SUBOPT_0x12
; 0000 097D                     lcd_put_number(0,3,0,0,lcd_light,0);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
	LDI  R31,0
	CALL __CWD1
	CALL SUBOPT_0x15
; 0000 097E 
; 0000 097F                     lcd_gotoxy(19,0);
	LDI  R30,LOW(19)
	CALL SUBOPT_0x44
; 0000 0980                     lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0981                     lcd_gotoxy(19,3);
	CALL SUBOPT_0x47
; 0000 0982                     lcd_putchar('-');
	LDI  R30,LOW(45)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0983                     }
; 0000 0984                 }
_0x2DF:
; 0000 0985                 else if(Address[1]==2){
_0x2D7:
; 0000 0986 
; 0000 0987                 }
; 0000 0988             }
_0x2D6:
; 0000 0989         }
_0x2C6:
_0x2C5:
_0x285:
_0x245:
_0x205:
_0x1C2:
_0x182:
_0x138:
_0x109:
; 0000 098A 
; 0000 098B         if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x2E2
; 0000 098C         RefreshLcd--;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,LOW(1)
	STS  _RefreshLcd_G000,R30
; 0000 098D         }
; 0000 098E     //////////////////////////////////////////////////////////////////////////////////
; 0000 098F     //////////////////////////////////////////////////////////////////////////////////
; 0000 0990     //////////////////////////////////////////////////////////////////////////////////
; 0000 0991     delay_ms(1);
_0x2E2:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x22
; 0000 0992     }
	JMP  _0x6D
; 0000 0993 }
_0x2E3:
	RJMP _0x2E3

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0x6C
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x6C
	RJMP _0x20E0009
__floor1:
    brtc __floor0
	CALL SUBOPT_0x6C
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20E0009:
	ADIW R28,4
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x28
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x28
_0x2020014:
_0x2020013:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20E0005
__ftoe_G101:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2020019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2020000,0
	CALL SUBOPT_0x6D
	RJMP _0x20E0008
_0x2020019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2020018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2020000,1
	CALL SUBOPT_0x6D
	RJMP _0x20E0008
_0x2020018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x202001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x202001B:
	LDD  R17,Y+11
_0x202001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001E
	CALL SUBOPT_0x6E
	RJMP _0x202001C
_0x202001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x202001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x6E
	RJMP _0x2020020
_0x202001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x6F
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2020021
	CALL SUBOPT_0x6E
_0x2020022:
	CALL SUBOPT_0x6F
	BRLO _0x2020024
	CALL SUBOPT_0x70
	CALL SUBOPT_0x71
	RJMP _0x2020022
_0x2020024:
	RJMP _0x2020025
_0x2020021:
_0x2020026:
	CALL SUBOPT_0x6F
	BRSH _0x2020028
	CALL SUBOPT_0x70
	CALL SUBOPT_0x72
	CALL SUBOPT_0x73
	SUBI R19,LOW(1)
	RJMP _0x2020026
_0x2020028:
	CALL SUBOPT_0x6E
_0x2020025:
	__GETD1S 12
	CALL SUBOPT_0x74
	CALL SUBOPT_0x73
	CALL SUBOPT_0x6F
	BRLO _0x2020029
	CALL SUBOPT_0x70
	CALL SUBOPT_0x71
_0x2020029:
_0x2020020:
	LDI  R17,LOW(0)
_0x202002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x202002C
	__GETD2S 4
	CALL SUBOPT_0x75
	CALL SUBOPT_0x74
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x70
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x76
	CALL SUBOPT_0x77
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x70
	CALL SUBOPT_0x54
	CALL SUBOPT_0x73
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x202002A
	CALL SUBOPT_0x76
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x202002A
_0x202002C:
	CALL SUBOPT_0x78
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x202002E
	CALL SUBOPT_0x76
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R19
_0x202002E:
	CPI  R19,10
	BRLT _0x202002F
	CALL SUBOPT_0x78
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
_0x202002F:
	CALL SUBOPT_0x78
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20E0008:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G101:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x28
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2020036
	CPI  R18,37
	BRNE _0x2020037
	LDI  R17,LOW(1)
	RJMP _0x2020038
_0x2020037:
	CALL SUBOPT_0x79
_0x2020038:
	RJMP _0x2020035
_0x2020036:
	CPI  R30,LOW(0x1)
	BRNE _0x2020039
	CPI  R18,37
	BRNE _0x202003A
	CALL SUBOPT_0x79
	RJMP _0x202010E
_0x202003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x202003B
	LDI  R16,LOW(1)
	RJMP _0x2020035
_0x202003B:
	CPI  R18,43
	BRNE _0x202003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003C:
	CPI  R18,32
	BRNE _0x202003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003D:
	RJMP _0x202003E
_0x2020039:
	CPI  R30,LOW(0x2)
	BRNE _0x202003F
_0x202003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020040
	ORI  R16,LOW(128)
	RJMP _0x2020035
_0x2020040:
	RJMP _0x2020041
_0x202003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2020042
_0x2020041:
	CPI  R18,48
	BRLO _0x2020044
	CPI  R18,58
	BRLO _0x2020045
_0x2020044:
	RJMP _0x2020043
_0x2020045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2020035
_0x2020043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2020046
	LDI  R17,LOW(4)
	RJMP _0x2020035
_0x2020046:
	RJMP _0x2020047
_0x2020042:
	CPI  R30,LOW(0x4)
	BRNE _0x2020049
	CPI  R18,48
	BRLO _0x202004B
	CPI  R18,58
	BRLO _0x202004C
_0x202004B:
	RJMP _0x202004A
_0x202004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2020035
_0x202004A:
_0x2020047:
	CPI  R18,108
	BRNE _0x202004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2020035
_0x202004D:
	RJMP _0x202004E
_0x2020049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2020035
_0x202004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2020053
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x7A
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x7C
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0x45)
	BREQ _0x2020057
	CPI  R30,LOW(0x65)
	BRNE _0x2020058
_0x2020057:
	RJMP _0x2020059
_0x2020058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x202005A
_0x2020059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x7D
	CALL __GETD1P
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x7F
	LDD  R26,Y+13
	TST  R26
	BRMI _0x202005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x202005D
	RJMP _0x202005E
_0x202005B:
	CALL SUBOPT_0x10
	CALL __ANEGF1
	CALL SUBOPT_0x7E
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x202005D:
	SBRS R16,7
	RJMP _0x202005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x7C
	RJMP _0x2020060
_0x202005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2020060:
_0x202005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2020062
	CALL SUBOPT_0x10
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2020063
_0x2020062:
	CALL SUBOPT_0x10
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G101
_0x2020063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x80
	RJMP _0x2020064
_0x202005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2020066
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x81
	CALL SUBOPT_0x80
	RJMP _0x2020067
_0x2020066:
	CPI  R30,LOW(0x70)
	BRNE _0x2020069
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x81
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x202006B
	CP   R20,R17
	BRLO _0x202006C
_0x202006B:
	RJMP _0x202006A
_0x202006C:
	MOV  R17,R20
_0x202006A:
_0x2020064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x202006D
_0x2020069:
	CPI  R30,LOW(0x64)
	BREQ _0x2020070
	CPI  R30,LOW(0x69)
	BRNE _0x2020071
_0x2020070:
	ORI  R16,LOW(4)
	RJMP _0x2020072
_0x2020071:
	CPI  R30,LOW(0x75)
	BRNE _0x2020073
_0x2020072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2020074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x82
	LDI  R17,LOW(10)
	RJMP _0x2020075
_0x2020074:
	__GETD1N 0x2710
	CALL SUBOPT_0x82
	LDI  R17,LOW(5)
	RJMP _0x2020075
_0x2020073:
	CPI  R30,LOW(0x58)
	BRNE _0x2020077
	ORI  R16,LOW(8)
	RJMP _0x2020078
_0x2020077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20200B6
_0x2020078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x202007A
	__GETD1N 0x10000000
	CALL SUBOPT_0x82
	LDI  R17,LOW(8)
	RJMP _0x2020075
_0x202007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x82
	LDI  R17,LOW(4)
_0x2020075:
	CPI  R20,0
	BREQ _0x202007B
	ANDI R16,LOW(127)
	RJMP _0x202007C
_0x202007B:
	LDI  R20,LOW(1)
_0x202007C:
	SBRS R16,1
	RJMP _0x202007D
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x7D
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x202010F
_0x202007D:
	SBRS R16,2
	RJMP _0x202007F
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x81
	CALL __CWD1
	RJMP _0x202010F
_0x202007F:
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x81
	CLR  R22
	CLR  R23
_0x202010F:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2020081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2020082
	CALL SUBOPT_0x10
	CALL __ANEGD1
	CALL SUBOPT_0x7E
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2020082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2020083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2020084
_0x2020083:
	ANDI R16,LOW(251)
_0x2020084:
_0x2020081:
	MOV  R19,R20
_0x202006D:
	SBRC R16,0
	RJMP _0x2020085
_0x2020086:
	CP   R17,R21
	BRSH _0x2020089
	CP   R19,R21
	BRLO _0x202008A
_0x2020089:
	RJMP _0x2020088
_0x202008A:
	SBRS R16,7
	RJMP _0x202008B
	SBRS R16,2
	RJMP _0x202008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x202008D
_0x202008C:
	LDI  R18,LOW(48)
_0x202008D:
	RJMP _0x202008E
_0x202008B:
	LDI  R18,LOW(32)
_0x202008E:
	CALL SUBOPT_0x79
	SUBI R21,LOW(1)
	RJMP _0x2020086
_0x2020088:
_0x2020085:
_0x202008F:
	CP   R17,R20
	BRSH _0x2020091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2020092
	CALL SUBOPT_0x83
	BREQ _0x2020093
	SUBI R21,LOW(1)
_0x2020093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2020092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x7C
	CPI  R21,0
	BREQ _0x2020094
	SUBI R21,LOW(1)
_0x2020094:
	SUBI R20,LOW(1)
	RJMP _0x202008F
_0x2020091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2020095
_0x2020096:
	CPI  R19,0
	BREQ _0x2020098
	SBRS R16,3
	RJMP _0x2020099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x202009A
_0x2020099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x202009A:
	CALL SUBOPT_0x79
	CPI  R21,0
	BREQ _0x202009B
	SUBI R21,LOW(1)
_0x202009B:
	SUBI R19,LOW(1)
	RJMP _0x2020096
_0x2020098:
	RJMP _0x202009C
_0x2020095:
_0x202009E:
	CALL SUBOPT_0x84
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20200A0
	SBRS R16,3
	RJMP _0x20200A1
	SUBI R18,-LOW(55)
	RJMP _0x20200A2
_0x20200A1:
	SUBI R18,-LOW(87)
_0x20200A2:
	RJMP _0x20200A3
_0x20200A0:
	SUBI R18,-LOW(48)
_0x20200A3:
	SBRC R16,4
	RJMP _0x20200A5
	CPI  R18,49
	BRSH _0x20200A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20200A6
_0x20200A7:
	RJMP _0x20200A9
_0x20200A6:
	CP   R20,R19
	BRSH _0x2020110
	CP   R21,R19
	BRLO _0x20200AC
	SBRS R16,0
	RJMP _0x20200AD
_0x20200AC:
	RJMP _0x20200AB
_0x20200AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20200AE
_0x2020110:
	LDI  R18,LOW(48)
_0x20200A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20200AF
	CALL SUBOPT_0x83
	BREQ _0x20200B0
	SUBI R21,LOW(1)
_0x20200B0:
_0x20200AF:
_0x20200AE:
_0x20200A5:
	CALL SUBOPT_0x79
	CPI  R21,0
	BREQ _0x20200B1
	SUBI R21,LOW(1)
_0x20200B1:
_0x20200AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x84
	CALL __MODD21U
	CALL SUBOPT_0x7E
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x82
	__GETD1S 16
	CALL __CPD10
	BREQ _0x202009F
	RJMP _0x202009E
_0x202009F:
_0x202009C:
	SBRS R16,0
	RJMP _0x20200B2
_0x20200B3:
	CPI  R21,0
	BREQ _0x20200B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x7C
	RJMP _0x20200B3
_0x20200B5:
_0x20200B2:
_0x20200B6:
_0x2020054:
_0x202010E:
	LDI  R17,LOW(0)
_0x2020035:
	RJMP _0x2020030
_0x2020032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x85
	SBIW R30,0
	BRNE _0x20200B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20E0007
_0x20200B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x85
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20E0007:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_ds18b20_select:
	ST   -Y,R17
	CALL _w1_init
	CPI  R30,0
	BRNE _0x2040003
	LDI  R30,LOW(0)
	JMP  _0x20E0004
_0x2040003:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x2040004
	LDI  R30,LOW(85)
	ST   -Y,R30
	CALL _w1_write
	LDI  R17,LOW(0)
_0x2040006:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	ST   -Y,R30
	CALL _w1_write
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO _0x2040006
	RJMP _0x2040008
_0x2040004:
	LDI  R30,LOW(204)
	ST   -Y,R30
	CALL _w1_write
_0x2040008:
	LDI  R30,LOW(1)
	JMP  _0x20E0004
_ds18b20_read_spd:
	CALL __SAVELOCR4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x86
	BRNE _0x2040009
	LDI  R30,LOW(0)
	RJMP _0x20E0006
_0x2040009:
	LDI  R30,LOW(190)
	ST   -Y,R30
	CALL _w1_write
	LDI  R17,LOW(0)
	__POINTWRM 18,19,___ds18b20_scratch_pad
_0x204000B:
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	CALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x204000B
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	CALL _w1_dow_crc8
	CALL __LNEGB1
_0x20E0006:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
_ds18b20_temperature:
	ST   -Y,R17
	CALL SUBOPT_0x87
	BRNE _0x204000D
	CALL SUBOPT_0x88
	JMP  _0x20E0004
_0x204000D:
	__GETB2MN ___ds18b20_scratch_pad,4
	LDI  R27,0
	LDI  R30,LOW(5)
	CALL __ASRW12
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	CALL SUBOPT_0x86
	BRNE _0x204000E
	CALL SUBOPT_0x88
	JMP  _0x20E0004
_0x204000E:
	LDI  R30,LOW(68)
	ST   -Y,R30
	CALL _w1_write
	MOV  R30,R17
	LDI  R26,LOW(_conv_delay_G102*2)
	LDI  R27,HIGH(_conv_delay_G102*2)
	CALL SUBOPT_0x89
	CALL SUBOPT_0x22
	CALL SUBOPT_0x87
	BRNE _0x204000F
	CALL SUBOPT_0x88
	JMP  _0x20E0004
_0x204000F:
	CALL _w1_init
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G102*2)
	LDI  R27,HIGH(_bit_mask_G102*2)
	CALL SUBOPT_0x89
	LDS  R26,___ds18b20_scratch_pad
	LDS  R27,___ds18b20_scratch_pad+1
	AND  R30,R26
	AND  R31,R27
	CALL SUBOPT_0x8A
	__GETD2N 0x3D800000
	CALL __MULF12
	JMP  _0x20E0004
_ds18b20_init:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	CALL SUBOPT_0x86
	BRNE _0x2040010
	LDI  R30,LOW(0)
	RJMP _0x20E0005
_0x2040010:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
	LDI  R30,LOW(78)
	ST   -Y,R30
	CALL _w1_write
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _w1_write
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _w1_write
	LD   R30,Y
	ST   -Y,R30
	CALL _w1_write
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x2040011
	LDI  R30,LOW(0)
	RJMP _0x20E0005
_0x2040011:
	__GETB2MN ___ds18b20_scratch_pad,3
	LDD  R30,Y+2
	CP   R30,R26
	BRNE _0x2040013
	__GETB2MN ___ds18b20_scratch_pad,2
	LDD  R30,Y+1
	CP   R30,R26
	BRNE _0x2040013
	__GETB2MN ___ds18b20_scratch_pad,4
	LD   R30,Y
	CP   R30,R26
	BREQ _0x2040012
_0x2040013:
	LDI  R30,LOW(0)
	RJMP _0x20E0005
_0x2040012:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	CALL SUBOPT_0x86
	BRNE _0x2040015
	LDI  R30,LOW(0)
	RJMP _0x20E0005
_0x2040015:
	LDI  R30,LOW(72)
	ST   -Y,R30
	CALL _w1_write
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x22
	CALL _w1_init
_0x20E0005:
	ADIW R28,5
	RET
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
	JMP  _0x20E0003
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
	CALL SUBOPT_0x2C
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R8,Y+1
	LDD  R11,Y+0
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
	MOV  R11,R30
	MOV  R8,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	CP   R8,R10
	BRLO _0x2060004
	__lcd_putchar1:
	INC  R11
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R11
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2060004:
	INC  R8
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20E0003
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
	RJMP _0x20E0004
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
_0x20E0004:
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
	RJMP _0x20E0003
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R10,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x8B
	RCALL __long_delay_G103
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G103
	RCALL __long_delay_G103
	LDI  R30,LOW(40)
	CALL SUBOPT_0x8C
	LDI  R30,LOW(4)
	CALL SUBOPT_0x8C
	LDI  R30,LOW(133)
	CALL SUBOPT_0x8C
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G103
	CPI  R30,LOW(0x5)
	BREQ _0x206000B
	LDI  R30,LOW(0)
	RJMP _0x20E0003
_0x206000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20E0003:
	ADIW R28,1
	RET

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x208000D
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2080000,0
	CALL SUBOPT_0x6D
	RJMP _0x20E0002
_0x208000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x208000C
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2080000,1
	CALL SUBOPT_0x6D
	RJMP _0x20E0002
_0x208000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x208000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	LDI  R30,LOW(45)
	ST   X,R30
_0x208000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2080010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2080010:
	LDD  R17,Y+8
_0x2080011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2080013
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x75
	CALL SUBOPT_0x90
	RJMP _0x2080011
_0x2080013:
	CALL SUBOPT_0x91
	CALL __ADDF12
	CALL SUBOPT_0x8D
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x90
_0x2080014:
	CALL SUBOPT_0x91
	CALL __CMPF12
	BRLO _0x2080016
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x72
	CALL SUBOPT_0x90
	SUBI R17,-LOW(1)
	RJMP _0x2080014
_0x2080016:
	CPI  R17,0
	BRNE _0x2080017
	CALL SUBOPT_0x8E
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2080018
_0x2080017:
_0x2080019:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x208001B
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x75
	CALL SUBOPT_0x74
	CALL __PUTPARD1
	CALL _floor
	CALL SUBOPT_0x90
	CALL SUBOPT_0x91
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x77
	LDI  R31,0
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x8A
	CALL __MULF12
	CALL SUBOPT_0x92
	CALL SUBOPT_0x54
	CALL SUBOPT_0x8D
	RJMP _0x2080019
_0x208001B:
_0x2080018:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20E0001
	CALL SUBOPT_0x8E
	LDI  R30,LOW(46)
	ST   X,R30
_0x208001D:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x208001F
	CALL SUBOPT_0x92
	CALL SUBOPT_0x72
	CALL SUBOPT_0x8D
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x77
	LDI  R31,0
	CALL SUBOPT_0x92
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x54
	CALL SUBOPT_0x8D
	RJMP _0x208001D
_0x208001F:
_0x20E0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20E0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.CSEG

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
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
___ds18b20_scratch_pad:
	.BYTE 0x9

	.ESEG
_DS18B20_IS_ASSIGNED:
	.BYTE 0x8
_DS18B20_ADDRESSES:
	.BYTE 0x48

	.DSEG
_TEMPERATURES:
	.BYTE 0x20

	.ESEG
_ROOM_TEMPERATURE:
	.BYTE 0x4
_MANUAL_CONTROLLER:
	.BYTE 0x1

	.DSEG
_dac_data:
	.BYTE 0x4
_RowsOnWindow_G000:
	.BYTE 0x1
_Address_G000:
	.BYTE 0x6
_SelectedRow_G000:
	.BYTE 0x1
_RefreshLcd_G000:
	.BYTE 0x1
_lcd_light_osc_G000:
	.BYTE 0x1
_lcd_light_now_G000:
	.BYTE 0x1

	.ESEG
_lcd_light:
	.BYTE 0x1

	.DSEG
_ds18b20_devices_S0000006000:
	.BYTE 0x1
_rom_code_S0000006000:
	.BYTE 0x48
_ds18b20_sensor_assignation_S0000006000:
	.BYTE 0x8
_STAND_BY_S0000006000:
	.BYTE 0x1
_SecondCounter_S0000006001:
	.BYTE 0x2
_TimeRefreshed_S0000006001:
	.BYTE 0x1
_BUTTON_S0000006001:
	.BYTE 0x5
_ButtonFilter_S0000006001:
	.BYTE 0x5
_ds18b20_wait_time_S0000006001:
	.BYTE 0x1
_ds18b20_scanning_device_S0000006001:
	.BYTE 0x1
_error_temperature_S0000006001:
	.BYTE 0x8
_ADC_CHANNEL_S0000006001:
	.BYTE 0x1
_AlgorythmSecondTimer_S0000006001:
	.BYTE 0x1
_ALGORYTHM_REFRESH_TIME_S0000006001:
	.BYTE 0x1
_VERY_LAST_TEMPERATURES_S0000006001:
	.BYTE 0x20
_LAST_TEMPERATURES_S0000006001:
	.BYTE 0x20
_LAST_SOLARIUM_STATE_S0000006001:
	.BYTE 0x3
_SOLARIUM_OUTSIDE_OFFSET_S0000006001:
	.BYTE 0x4
_SOLARIUM_INSIDE_OFFSET_S0000006001:
	.BYTE 0x4
_lcd_led_counter_S0000006001:
	.BYTE 0x1
_stand_by_pos_S0000006002:
	.BYTE 0x2
__base_y_G103:
	.BYTE 0x4
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x0:
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	MOV  R30,R18
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDI  R31,0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x4:
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x5:
	__GETB1MN _Address_G000,5
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	__GETD2N 0xA
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	__GETD1S 6
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x6
	CALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__SUBD1N 1
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
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
SUBOPT_0xE:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0x9
	CALL __DIVD21U
	ST   Y,R30
	ST   -Y,R30
	CALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
	LD   R26,Y
	CLR  R27
	RCALL SUBOPT_0xE
	CALL __CWD2
	CALL __MULD12U
	RCALL SUBOPT_0x9
	CALL __SUBD21
	__PUTD2S 1
	__GETD2S 6
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 62 TIMES, CODE SIZE REDUCTION:119 WORDS
SUBOPT_0x12:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x15:
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	JMP  _lcd_put_number

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	STS  _dac_data,R30
	LDI  R30,LOW(255)
	__PUTB1MN _dac_data,1
	__PUTB1MN _dac_data,2
	__PUTB1MN _dac_data,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x17:
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_DS18B20_IS_ASSIGNED)
	SBCI R27,HIGH(-_DS18B20_IS_ASSIGNED)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(_ROOM_TEMPERATURE)
	LDI  R27,HIGH(_ROOM_TEMPERATURE)
	CALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	__GETD1N 0x41200000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	__GETD1N 0x41F00000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(-_ds18b20_sensor_assignation_S0000006000)
	SBCI R31,HIGH(-_ds18b20_sensor_assignation_S0000006000)
	LDI  R26,LOW(255)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1E:
	ST   -Y,R30
	CALL _NumToIndex
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	LDD  R26,Y+1
	LDI  R27,0
	SUBI R26,LOW(-_DS18B20_IS_ASSIGNED)
	SBCI R27,HIGH(-_DS18B20_IS_ASSIGNED)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	LDS  R30,_ds18b20_devices_S0000006000
	LDD  R26,Y+1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(9)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_rom_code_S0000006000)
	SBCI R31,HIGH(-_rom_code_S0000006000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	MOVW R26,R30
	LDD  R30,Y+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(9)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_DS18B20_ADDRESSES)
	SBCI R31,HIGH(-_DS18B20_ADDRESSES)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 42 TIMES, CODE SIZE REDUCTION:120 WORDS
SUBOPT_0x25:
	LDI  R31,0
	SUBI R30,LOW(-_ds18b20_sensor_assignation_S0000006000)
	SBCI R31,HIGH(-_ds18b20_sensor_assignation_S0000006000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDD  R26,Y+3
	LDI  R27,0
	SUBI R26,LOW(-_DS18B20_IS_ASSIGNED)
	SBCI R27,HIGH(-_DS18B20_IS_ASSIGNED)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
	__PUTB1MN _Address_G000,1
	__PUTB1MN _Address_G000,2
	__PUTB1MN _Address_G000,3
	__PUTB1MN _Address_G000,4
	__PUTB1MN _Address_G000,5
	STS  _SelectedRow_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_ButtonFilter_S0000006001)
	SBCI R31,HIGH(-_ButtonFilter_S0000006001)
	LD   R26,Z
	CPI  R26,LOW(0xA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_BUTTON_S0000006001)
	SBCI R31,HIGH(-_BUTTON_S0000006001)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x2C:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x2D:
	LDI  R27,0
	SUBI R26,LOW(-_DS18B20_IS_ASSIGNED)
	SBCI R27,HIGH(-_DS18B20_IS_ASSIGNED)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:102 WORDS
SUBOPT_0x2F:
	LDI  R26,LOW(_TEMPERATURES)
	LDI  R27,HIGH(_TEMPERATURES)
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x30:
	LDS  R30,_ds18b20_scanning_device_S0000006001
	LDI  R31,0
	SUBI R30,LOW(-_error_temperature_S0000006001)
	SBCI R31,HIGH(-_error_temperature_S0000006001)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x31:
	LDS  R30,_ADC_CHANNEL_S0000006001
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x32:
	LDI  R26,LOW(_MANUAL_CONTROLLER)
	LDI  R27,HIGH(_MANUAL_CONTROLLER)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	__GETD1MN _TEMPERATURES,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x34:
	LDI  R26,LOW(_ROOM_TEMPERATURE)
	LDI  R27,HIGH(_ROOM_TEMPERATURE)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	LDS  R26,_TEMPERATURES
	LDS  R27,_TEMPERATURES+1
	LDS  R24,_TEMPERATURES+2
	LDS  R25,_TEMPERATURES+3
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x36:
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_SOLARIUM_INSIDE_OFFSET_S0000006001
	LDS  R31,_SOLARIUM_INSIDE_OFFSET_S0000006001+1
	LDS  R22,_SOLARIUM_INSIDE_OFFSET_S0000006001+2
	LDS  R23,_SOLARIUM_INSIDE_OFFSET_S0000006001+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x37:
	LDS  R26,_SOLARIUM_INSIDE_OFFSET_S0000006001
	LDS  R27,_SOLARIUM_INSIDE_OFFSET_S0000006001+1
	LDS  R24,_SOLARIUM_INSIDE_OFFSET_S0000006001+2
	LDS  R25,_SOLARIUM_INSIDE_OFFSET_S0000006001+3
	__GETD1N 0x40000000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x38:
	LDS  R30,_TEMPERATURES
	LDS  R31,_TEMPERATURES+1
	LDS  R22,_TEMPERATURES+2
	LDS  R23,_TEMPERATURES+3
	LDS  R26,_LAST_TEMPERATURES_S0000006001
	LDS  R27,_LAST_TEMPERATURES_S0000006001+1
	LDS  R24,_LAST_TEMPERATURES_S0000006001+2
	LDS  R25,_LAST_TEMPERATURES_S0000006001+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	__PUTB1MN _dac_data,1
	__GETB1MN _dac_data,1
	__PUTB1MN _dac_data,2
	__GETB1MN _dac_data,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(255)
	__PUTB1MN _dac_data,1
	__PUTB1MN _dac_data,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3B:
	LDS  R26,_TEMPERATURES
	LDS  R27,_TEMPERATURES+1
	LDS  R24,_TEMPERATURES+2
	LDS  R25,_TEMPERATURES+3
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	__POINTW2MN _dac_data,1
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	ST   X,R30
	__GETB1MN _dac_data,1
	__PUTB1MN _dac_data,2
	__GETB1MN _dac_data,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(255)
	STS  _dac_data,R30
	LDI  R30,LOW(0)
	__PUTB1MN _dac_data,1
	__PUTB1MN _dac_data,2
	__PUTB1MN _dac_data,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	LDS  R26,_TEMPERATURES
	LDS  R27,_TEMPERATURES+1
	LDS  R24,_TEMPERATURES+2
	LDS  R25,_TEMPERATURES+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	MOVW R26,R0
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x43:
	LDI  R30,LOW(47)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x44:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x45:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _SelectAnotherRow

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _SelectAnotherRow

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x4A:
	STS  _Address_G000,R30
	LDI  R30,LOW(0)
	STS  _SelectedRow_G000,R30
	__PUTB1MN _Address_G000,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4B:
	STS  _RowsOnWindow_G000,R30
	__GETB1MN _Address_G000,5
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4C:
	ADIW R30,4
	LDD  R26,Y+1
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x4D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDD  R30,Y+1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x4E:
	SBIW R28,10
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,231
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:107 WORDS
SUBOPT_0x4F:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x50:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDS  R26,_SelectedRow_G000
	CLR  R27
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x51:
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _lcd_gotoxy
	LDI  R30,LOW(60)
	ST   -Y,R30
	CALL _lcd_putchar
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	ST   Y,R30
	__GETB2MN _BUTTON_S0000006001,4
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x53:
	__GETD1N 0x3DCCCCCD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x55:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x56:
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	LDD  R30,Y+2
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x57:
	SBIW R28,2
	LDI  R30,LOW(0)
	STD  Y+1,R30
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x58:
	LD   R26,Z
	LDD  R30,Y+3
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x59:
	SBIW R28,1
	LDD  R30,Y+5
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5A:
	LDD  R26,Y+4
	STD  Z+0,R26
	LDI  R30,LOW(0)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x5B:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDD  R30,Y+4
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x5C:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R22
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x5D:
	ADD  R26,R30
	ADC  R27,R31
	__GETD1N 0x0
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5E:
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	LDD  R30,Y+2
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5F:
	LDI  R26,LOW(255)
	STD  Z+0,R26
	LDD  R30,Y+2
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x60:
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	LDD  R26,Y+2
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x61:
	STD  Y+3,R30
	LDD  R30,Y+5
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x62:
	CALL _lcd_clear
	__POINTW1FN _0x0,328
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x63:
	__POINTW1FN _0x0,349
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x64:
	__POINTW1FN _0x0,370
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x65:
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	LDI  R30,LOW(4)
	RJMP SUBOPT_0x4B

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x66:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RJMP SUBOPT_0x4F

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x67:
	LD   R30,Z
	ST   -Y,R30
	CALL _NumToIndex
	SUBI R30,-LOW(1)
	ST   -Y,R30
	CALL _lcd_putchar
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x68:
	__POINTW1FN _0x0,471
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x69:
	__POINTW1FN _0x0,494
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	__POINTW1FN _0x0,507
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6B:
	LDI  R30,LOW(0)
	STS  _SelectedRow_G000,R30
	__PUTB1MN _Address_G000,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6C:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6D:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x6E:
	__GETD2S 4
	RCALL SUBOPT_0x55
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6F:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x70:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x71:
	RCALL SUBOPT_0x53
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	RCALL SUBOPT_0x55
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x74:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x75:
	RCALL SUBOPT_0x53
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x76:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x78:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x79:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x7A:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7B:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7C:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x7D:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7E:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7F:
	RCALL SUBOPT_0x7A
	RJMP SUBOPT_0x7B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x80:
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x81:
	RCALL SUBOPT_0x7D
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x82:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x83:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x84:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x85:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x86:
	ST   -Y,R31
	ST   -Y,R30
	CALL _ds18b20_select
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x87:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ds18b20_read_spd
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x88:
	__GETD1N 0xC61C3C00
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x89:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8A:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8B:
	CALL __long_delay_G103
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8C:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8D:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8F:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x90:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x91:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x92:
	__GETD2S 9
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

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
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

_w1_dow_crc8:
	clr  r30
	ld   r24,y
	tst  r24
	breq __w1_dow_crc83
	ldi  r22,0x18
	ldd  r26,y+1
	ldd  r27,y+2
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,3
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

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

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
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

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
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

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
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

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
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

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
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
