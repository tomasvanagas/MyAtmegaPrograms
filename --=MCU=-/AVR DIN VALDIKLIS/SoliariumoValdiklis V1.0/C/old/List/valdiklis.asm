
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
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
	.DB  0x2B,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2B,0x0,0x7C,0x20,0x53
	.DB  0x4F,0x4C,0x49,0x41,0x52,0x2E,0x20,0x41
	.DB  0x55,0x53,0x49,0x4E,0x49,0x4D,0x4F,0x20
	.DB  0x7C,0x0,0x7C,0x20,0x56,0x41,0x4C,0x44
	.DB  0x49,0x4B,0x4C,0x49,0x53,0x20,0x56,0x31
	.DB  0x2E,0x0,0x20,0x7C,0x2B,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2B
	.DB  0x0,0x20,0x20,0x2D,0x3D,0x50,0x41,0x47
	.DB  0x52,0x2E,0x20,0x4D,0x45,0x4E,0x49,0x55
	.DB  0x3D,0x2D,0x20,0x20,0x20,0x0,0x56,0x49
	.DB  0x44,0x41,0x55,0x53,0x20,0x54,0x45,0x4D
	.DB  0x50,0x2E,0x2B,0x32,0x32,0x2E,0x35,0x43
	.DB  0x20,0x3C,0x0,0x55,0x5A,0x53,0x54,0x41
	.DB  0x54,0x59,0x54,0x41,0x20,0x54,0x2E,0x2B
	.DB  0x32,0x32,0x2E,0x30,0x43,0x20,0x20,0x0
	.DB  0x4E,0x55,0x53,0x54,0x41,0x54,0x59,0x4D
	.DB  0x41,0x49,0x0,0x2D,0x3D,0x56,0x49,0x44
	.DB  0x49,0x4E,0x2E,0x54,0x45,0x52,0x4D,0x4F
	.DB  0x4D,0x45,0x54,0x52,0x2E,0x3D,0x2D,0x0
	.DB  0x50,0x41,0x44,0x45,0x52,0x49,0x4E,0x49
	.DB  0x4D,0x41,0x53,0x3A,0x20,0x2B,0x30,0x2E
	.DB  0x30,0x43,0x20,0x20,0x0,0x41,0x44,0x52
	.DB  0x45,0x53,0x41,0x53,0x3A,0x20,0x30,0x31
	.DB  0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x20
	.DB  0x20,0x0,0x2D,0x3D,0x55,0x5A,0x53,0x54
	.DB  0x41,0x54,0x59,0x2E,0x3D,0x2D,0x0
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
;/*****************************************************
;Project     : Soliariumo valdiklis V1.0
;Date        : 2012.06.11
;Author      : Tomas Vanagas
;Chip type   : ATmega32
;*****************************************************/
;
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
;
;// DS1307 Real Time Clock functions
;//#include <ds1307.h>
;
;// PINS
;#define BUTTON_UP 0
;#define BUTTON_LEFT 1
;#define BUTTON_ENTER 2
;#define BUTTON_RIGHT 3
;#define BUTTON_DOWN 4
;
;unsigned char OUTPUT(unsigned char address, unsigned char value){
; 0000 0015 unsigned char OUTPUT(unsigned char address, unsigned char value){

	.CSEG
; 0000 0016     if(address==17){
;	address -> Y+1
;	value -> Y+0
; 0000 0017 //    PORTC.3 = value;
; 0000 0018 //    return 1;
; 0000 0019     }
; 0000 001A     else if(address==18){
; 0000 001B //    PORTC.4 = value;
; 0000 001C //    return 1;
; 0000 001D     }
; 0000 001E     else if(address==19){
; 0000 001F //    PORTC.5 = value;
; 0000 0020 //    return 1;
; 0000 0021     }
; 0000 0022     else if(address==20){
; 0000 0023 //    PORTD.5 = value;
; 0000 0024 //    return 1;
; 0000 0025     }
; 0000 0026     else if(address==21){
; 0000 0027 //    PORTD.4 = value;
; 0000 0028 //    return 1;
; 0000 0029     }
; 0000 002A     else if(address==22){
; 0000 002B //    PORTD.7 = value;
; 0000 002C //    return 1;
; 0000 002D     }
; 0000 002E return 0;
; 0000 002F }
;
;unsigned char BUTTON_INPUT(unsigned char input){
; 0000 0031 unsigned char BUTTON_INPUT(unsigned char input){
_BUTTON_INPUT:
; 0000 0032 //    if(input==0){   return PIND.1;  }
; 0000 0033 //    if(input==1){   return PIND.0;  }
; 0000 0034 //    if(input==2){   return PIND.2;  }
; 0000 0035 //    if(input==3){   return PIND.3;  }
; 0000 0036 //    if(input==4){   return PIND.6;  }
; 0000 0037 return 0;
;	input -> Y+0
	LDI  R30,LOW(0)
	JMP  _0x2020001
; 0000 0038 }
;
;// Real Time
;//unsigned char RealTimeYear, RealTimeMonth, RealTimeDay, RealTimeHour, RealTimeMinute, RealTimeWeekDay, RealTimeSecond;
;//eeprom unsigned char SUMMER_TIME_TURNED_ON;
;//eeprom unsigned char IS_CLOCK_SUMMER;
;
;//eeprom signed char RealTimePrecisioningValue;
;//unsigned char IsRealTimePrecisioned;
;
;
;
;// Code
;//eeprom unsigned int  CODE;
;//eeprom unsigned char IS_LOCK_TURNED_ON;
;
;
;// Neveiklumo taimeriai
;unsigned int STAND_BY_TIMER;
;unsigned char MAIN_MENU_TIMER,LCD_LED_TIMER;
;
;
;
;
;// Other
;char RefreshTime;
;
;//////////// Mygtukai /////////////
;#define ButtonFiltrationTimer 20 // x*cycle (cycle~1ms)
;///////////////////////////////////
;
;//-----------------------------------------------------------------------------------//
;//--------------------------------- Lcd System --------------------------------------//
;//-----------------------------------------------------------------------------------//
;#define LCD_LED PORTA.7
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
   .equ __lcd_port=0x18 ;PORTB
; 0000 0066 #endasm
;#include <lcd.h>
;
;// Ekrano apsvietimas
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 006A interrupt [17] void timer0_ovf_isr(void){
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 006B lcd_light_osc += 1;
	LDS  R30,_lcd_light_osc_G000
	SUBI R30,-LOW(1)
	STS  _lcd_light_osc_G000,R30
; 0000 006C     if(lcd_light_osc>=100){
	LDS  R26,_lcd_light_osc_G000
	CPI  R26,LOW(0x64)
	BRLO _0xE
; 0000 006D     lcd_light_osc = 0;
	LDI  R30,LOW(0)
	STS  _lcd_light_osc_G000,R30
; 0000 006E     }
; 0000 006F 
; 0000 0070     if(lcd_light_now>lcd_light_osc){
_0xE:
	LDS  R30,_lcd_light_osc_G000
	LDS  R26,_lcd_light_now_G000
	CP   R30,R26
	BRSH _0xF
; 0000 0071     LCD_LED = 1;
	SBI  0x1B,7
; 0000 0072     }
; 0000 0073     else{
	RJMP _0x12
_0xF:
; 0000 0074     LCD_LED = 0;
	CBI  0x1B,7
; 0000 0075     }
_0x12:
; 0000 0076 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;char SelectAnotherRow(char up_down){
; 0000 0078 char SelectAnotherRow(char up_down){
_SelectAnotherRow:
; 0000 0079 // 0 - down
; 0000 007A // 1 - up
; 0000 007B     if(up_down==0){
;	up_down -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x15
; 0000 007C         if(SelectedRow<RowsOnWindow-1){
	LDS  R30,_RowsOnWindow_G000
	LDI  R31,0
	SBIW R30,1
	LDS  R26,_SelectedRow_G000
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x16
; 0000 007D         SelectedRow++;
	LDS  R30,_SelectedRow_G000
	SUBI R30,-LOW(1)
	STS  _SelectedRow_G000,R30
; 0000 007E             if(Address[5]+3<SelectedRow){
	CALL SUBOPT_0x0
	ADIW R30,3
	MOVW R26,R30
	LDS  R30,_SelectedRow_G000
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x17
; 0000 007F             Address[5] = SelectedRow - 3;
	LDS  R30,_SelectedRow_G000
	LDI  R31,0
	SBIW R30,3
	__PUTB1MN _Address_G000,5
; 0000 0080             }
; 0000 0081         return 1;
_0x17:
	JMP  _0x2020002
; 0000 0082         }
; 0000 0083     }
_0x16:
; 0000 0084     else{
	RJMP _0x18
_0x15:
; 0000 0085         if(SelectedRow>0){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRLO _0x19
; 0000 0086         SelectedRow--;
	LDS  R30,_SelectedRow_G000
	SUBI R30,LOW(1)
	STS  _SelectedRow_G000,R30
; 0000 0087             if(Address[5]>SelectedRow){
	__GETB2MN _Address_G000,5
	CP   R30,R26
	BRSH _0x1A
; 0000 0088             Address[5] = SelectedRow;
	__PUTB1MN _Address_G000,5
; 0000 0089             }
; 0000 008A         return 1;
_0x1A:
	JMP  _0x2020002
; 0000 008B         }
; 0000 008C     }
_0x19:
_0x18:
; 0000 008D return 0;
	LDI  R30,LOW(0)
	JMP  _0x2020001
; 0000 008E }
;
;char NumToIndex(char Num){
; 0000 0090 char NumToIndex(char Num){
_NumToIndex:
; 0000 0091     if(Num==0){     return '0';}
;	Num -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x1B
	LDI  R30,LOW(48)
	JMP  _0x2020001
; 0000 0092     else if(Num==1){return '1';}
_0x1B:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x1D
	LDI  R30,LOW(49)
	JMP  _0x2020001
; 0000 0093     else if(Num==2){return '2';}
_0x1D:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x1F
	LDI  R30,LOW(50)
	JMP  _0x2020001
; 0000 0094     else if(Num==3){return '3';}
_0x1F:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x21
	LDI  R30,LOW(51)
	JMP  _0x2020001
; 0000 0095     else if(Num==4){return '4';}
_0x21:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x23
	LDI  R30,LOW(52)
	JMP  _0x2020001
; 0000 0096     else if(Num==5){return '5';}
_0x23:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x25
	LDI  R30,LOW(53)
	JMP  _0x2020001
; 0000 0097     else if(Num==6){return '6';}
_0x25:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x27
	LDI  R30,LOW(54)
	JMP  _0x2020001
; 0000 0098     else if(Num==7){return '7';}
_0x27:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x29
	LDI  R30,LOW(55)
	JMP  _0x2020001
; 0000 0099     else if(Num==8){return '8';}
_0x29:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x2B
	LDI  R30,LOW(56)
	JMP  _0x2020001
; 0000 009A     else if(Num==9){return '9';}
_0x2B:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x2D
	LDI  R30,LOW(57)
	JMP  _0x2020001
; 0000 009B     else{           return '-';}
_0x2D:
	LDI  R30,LOW(45)
	JMP  _0x2020001
; 0000 009C return 0;
; 0000 009D }
;
;char lcd_put_number(char Type, char Lenght, char IsSign,
; 0000 00A0 
; 0000 00A1                     char NumbersAfterDot,
; 0000 00A2 
; 0000 00A3                     unsigned long int Number0,
; 0000 00A4                     signed long int Number1){
_lcd_put_number:
; 0000 00A5     if(Lenght>0){
;	Type -> Y+11
;	Lenght -> Y+10
;	IsSign -> Y+9
;	NumbersAfterDot -> Y+8
;	Number0 -> Y+4
;	Number1 -> Y+0
	LDD  R26,Y+10
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x2F
; 0000 00A6     unsigned long int k = 1;
; 0000 00A7     unsigned char i;
; 0000 00A8         for(i=0;i<Lenght-1;i++) k = k*10;
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
_0x31:
	LDD  R30,Y+15
	LDI  R31,0
	SBIW R30,1
	LD   R26,Y
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x32
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x31
_0x32:
; 0000 00AA if(Type==0){
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x33
; 0000 00AB         unsigned long int a;
; 0000 00AC         unsigned char b;
; 0000 00AD         a = Number0;
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
	CALL SUBOPT_0x3
; 0000 00AE 
; 0000 00AF             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x34
; 0000 00B0             lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00B1             }
; 0000 00B2 
; 0000 00B3             if(a<0){
_0x34:
	CALL SUBOPT_0x4
; 0000 00B4             a = a*(-1);
; 0000 00B5             }
; 0000 00B6 
; 0000 00B7             if(k*10<a){
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	BRSH _0x36
; 0000 00B8             a = k*10 - 1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
; 0000 00B9             }
; 0000 00BA 
; 0000 00BB             for(i=0;i<Lenght;i++){
_0x36:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x38:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0x39
; 0000 00BC                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x3A
; 0000 00BD                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0x8
	BRNE _0x3B
; 0000 00BE                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00BF                     }
; 0000 00C0                 }
_0x3B:
; 0000 00C1             b = a/k;
_0x3A:
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 00C2             lcd_putchar( NumToIndex( b ) );
; 0000 00C3             a = a - b*k;
; 0000 00C4             k = k/10;
; 0000 00C5             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x38
_0x39:
; 0000 00C6         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2020003
; 0000 00C7         }
; 0000 00C8 
; 0000 00C9         else if(Type==1){
_0x33:
	LDD  R26,Y+16
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x3D
; 0000 00CA         signed long int a;
; 0000 00CB         unsigned char b;
; 0000 00CC         a = Number1;
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
	CALL SUBOPT_0x3
; 0000 00CD 
; 0000 00CE             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x3E
; 0000 00CF                 if(a>=0){
	LDD  R26,Y+4
	TST  R26
	BRMI _0x3F
; 0000 00D0                 lcd_putchar('+');
	LDI  R30,LOW(43)
	RJMP _0x73
; 0000 00D1                 }
; 0000 00D2                 else{
_0x3F:
; 0000 00D3                 lcd_putchar('-');
	LDI  R30,LOW(45)
_0x73:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00D4                 }
; 0000 00D5             }
; 0000 00D6 
; 0000 00D7             if(a<0){
_0x3E:
	LDD  R26,Y+4
	TST  R26
	BRPL _0x41
; 0000 00D8             a = a*(-1);
	CALL SUBOPT_0x1
	__GETD2N 0xFFFFFFFF
	CALL __MULD12
	CALL SUBOPT_0x3
; 0000 00D9             }
; 0000 00DA 
; 0000 00DB             if(k*10<a){
_0x41:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	BRSH _0x42
; 0000 00DC             a = k*10 - 1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
; 0000 00DD             }
; 0000 00DE 
; 0000 00DF             for(i=0;i<Lenght;i++){
_0x42:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x44:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0x45
; 0000 00E0                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x46
; 0000 00E1                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0x8
	BRNE _0x47
; 0000 00E2                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00E3                     }
; 0000 00E4                 }
_0x47:
; 0000 00E5             b = a/k;
_0x46:
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 00E6             lcd_putchar( NumToIndex( b ) );
; 0000 00E7             a = a - b*k;
; 0000 00E8             k = k/10;
; 0000 00E9             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x44
_0x45:
; 0000 00EA         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2020003
; 0000 00EB         }
; 0000 00EC     }
_0x3D:
	ADIW R28,5
; 0000 00ED return 0;
_0x2F:
	LDI  R30,LOW(0)
_0x2020003:
	ADIW R28,12
	RET
; 0000 00EE }
;
;//-----------------------------------------------------------------------------------//
;//-----------------------------------------------------------------------------------//
;//-----------------------------------------------------------------------------------//
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
;void main(void){
; 0000 00FE void main(void){
_main:
; 0000 00FF // Declare your local variables here
; 0000 0100 
; 0000 0101 // Input/Output Ports initialization
; 0000 0102 // Port A initialization
; 0000 0103 // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out
; 0000 0104 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0105 PORTA=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0106 DDRA= 0b10000000;
	LDI  R30,LOW(128)
	OUT  0x1A,R30
; 0000 0107 
; 0000 0108 // Port B initialization
; 0000 0109 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 010A // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 010B PORTB=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 010C DDRB= 0b00000000;
	OUT  0x17,R30
; 0000 010D 
; 0000 010E // Port C initialization
; 0000 010F // Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 0110 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0111 PORTC=0b00000000;
	OUT  0x15,R30
; 0000 0112 DDRC= 0b00111000;
	LDI  R30,LOW(56)
	OUT  0x14,R30
; 0000 0113 
; 0000 0114 // Port D initialization
; 0000 0115 // Func7=Out Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0116 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0117 PORTD=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0118 DDRD= 0b10110000;
	LDI  R30,LOW(176)
	OUT  0x11,R30
; 0000 0119 
; 0000 011A /// Timer/Counter 0 initialization
; 0000 011B // Clock source: System Clock
; 0000 011C // Clock value: 1000.000 kHz
; 0000 011D // Mode: Normal top=FFh
; 0000 011E // OC0 output: Disconnected
; 0000 011F TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0120 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0121 OCR0=0x00;
	OUT  0x31,R30
; 0000 0122 
; 0000 0123 // Timer/Counter 1 initialization
; 0000 0124 // Clock source: System Clock
; 0000 0125 // Clock value: Timer1 Stopped
; 0000 0126 // Mode: Normal top=FFFFh
; 0000 0127 // OC1A output: Discon.
; 0000 0128 // OC1B output: Discon.
; 0000 0129 // Noise Canceler: Off
; 0000 012A // Input Capture on Falling Edge
; 0000 012B // Timer1 Overflow Interrupt: Off
; 0000 012C // Input Capture Interrupt: Off
; 0000 012D // Compare A Match Interrupt: Off
; 0000 012E // Compare B Match Interrupt: Off
; 0000 012F TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0130 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0131 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0132 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0133 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0134 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0135 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0136 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0137 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0138 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0139 
; 0000 013A // Timer/Counter 2 initialization
; 0000 013B // Clock source: System Clock
; 0000 013C // Clock value: Timer2 Stopped
; 0000 013D // Mode: Normal top=FFh
; 0000 013E // OC2 output: Disconnected
; 0000 013F ASSR=0x00;
	OUT  0x30,R30
; 0000 0140 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0141 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0142 OCR2=0x00;
	OUT  0x23,R30
; 0000 0143 
; 0000 0144 // External Interrupt(s) initialization
; 0000 0145 // INT0: Off
; 0000 0146 // INT1: Off
; 0000 0147 // INT2: Off
; 0000 0148 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0149 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 014A 
; 0000 014B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 014C TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 014D 
; 0000 014E // Analog Comparator initialization
; 0000 014F // Analog Comparator: Off
; 0000 0150 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0151 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0152 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0153 
; 0000 0154 // I2C Bus initialization
; 0000 0155 //i2c_init();
; 0000 0156 
; 0000 0157 // DS1307 Real Time Clock initialization
; 0000 0158 // Square wave output on pin SQW/OUT: Off
; 0000 0159 // SQW/OUT pin state: 0
; 0000 015A //rtc_init(0,0,0);
; 0000 015B 
; 0000 015C // Global enable interrupts
; 0000 015D #asm("sei")
	sei
; 0000 015E 
; 0000 015F 
; 0000 0160 // 2 Wire Bus initialization
; 0000 0161 // Generate Acknowledge Pulse: Off
; 0000 0162 // 2 Wire Bus Slave Address: 0h
; 0000 0163 // General Call Recognition: Off
; 0000 0164 // Bit Rate: 400.000 kHz
; 0000 0165 //TWSR=0x00;
; 0000 0166 //TWBR=0x02;
; 0000 0167 //TWAR=0x00;
; 0000 0168 //TWCR=0x04;
; 0000 0169 
; 0000 016A // I2C Bus initialization
; 0000 016B //i2c_init();
; 0000 016C 
; 0000 016D // DS1307 Real Time Clock initialization
; 0000 016E // Square wave output on pin SQW/OUT: Off
; 0000 016F // SQW/OUT pin state: 0
; 0000 0170 //rtc_init(0,0,0);
; 0000 0171 
; 0000 0172 // LCD module initialization
; 0000 0173 lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0174 
; 0000 0175 // Watchdog Timer initialization
; 0000 0176 // Watchdog Timer Prescaler: OSC/128k
; 0000 0177 WDTCR=0x0B;
	LDI  R30,LOW(11)
	OUT  0x21,R30
; 0000 0178 
; 0000 0179 LCD_LED_TIMER = 30; lcd_light_now = lcd_light;
	LDI  R30,LOW(30)
	CALL SUBOPT_0xB
; 0000 017A lcd_putsf("+------------------+");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0xC
; 0000 017B lcd_putsf("| SOLIAR. AUSINIMO |");
	__POINTW1FN _0x0,21
	CALL SUBOPT_0xC
; 0000 017C lcd_putsf("| VALDIKLIS V1.");
	__POINTW1FN _0x0,42
	CALL SUBOPT_0xC
; 0000 017D lcd_put_number(0,3,0,0,__BUILD__,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	__GETD1N 0x9
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _lcd_put_number
; 0000 017E lcd_putsf(" |+------------------+");
	__POINTW1FN _0x0,58
	CALL SUBOPT_0xC
; 0000 017F delay_ms(1500);
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0180 
; 0000 0181 // Default values
; 0000 0182     if(lcd_light>100){lcd_light = 100;}
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x65)
	BRLO _0x48
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	LDI  R30,LOW(100)
	CALL __EEPROMWRB
; 0000 0183 
; 0000 0184     while(1){
_0x48:
_0x49:
; 0000 0185     //////////////////////////////////////////////////////////////////////////////////
; 0000 0186     //////////////////////////// Funkcija kas 1 secunde //////////////////////////////
; 0000 0187     //////////////////////////////////////////////////////////////////////////////////
; 0000 0188     static unsigned int SecondCounter;
; 0000 0189     SecondCounter++;
	LDI  R26,LOW(_SecondCounter_S0000006001)
	LDI  R27,HIGH(_SecondCounter_S0000006001)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 018A         if(SecondCounter>=500){
	LDS  R26,_SecondCounter_S0000006001
	LDS  R27,_SecondCounter_S0000006001+1
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0x4C
; 0000 018B         SecondCounter = 0;
	LDI  R30,LOW(0)
	STS  _SecondCounter_S0000006001,R30
	STS  _SecondCounter_S0000006001+1,R30
; 0000 018C         RefreshTime++;
	INC  R9
; 0000 018D         }
; 0000 018E     //////////////////////////////////////////////////////////////////////////////////
; 0000 018F     //////////////////////////////////////////////////////////////////////////////////
; 0000 0190     //////////////////////////////////////////////////////////////////////////////////
; 0000 0191 
; 0000 0192 
; 0000 0193     //////////////////////////////////////////////////////////////////////////////////
; 0000 0194     /////////////////////////////////////// Mygtukai /////////////////////////////////
; 0000 0195     //////////////////////////////////////////////////////////////////////////////////
; 0000 0196     static unsigned char BUTTON[5], ButtonFilter[5];
_0x4C:
; 0000 0197         if(1){
; 0000 0198         unsigned char i;
; 0000 0199             for(i=0;i<5;i++){
	SBIW R28,1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0x4F:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRSH _0x50
; 0000 019A                 if(BUTTON_INPUT(i)==1){
	LD   R30,Y
	ST   -Y,R30
	RCALL _BUTTON_INPUT
	CPI  R30,LOW(0x1)
	BRNE _0x51
; 0000 019B                     if(ButtonFilter[i]<ButtonFiltrationTimer){
	CALL SUBOPT_0xD
	BRSH _0x52
; 0000 019C                     ButtonFilter[i]++;
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_ButtonFilter_S0000006001)
	SBCI R27,HIGH(-_ButtonFilter_S0000006001)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 019D                     }
; 0000 019E                 }
_0x52:
; 0000 019F                 else{
	RJMP _0x53
_0x51:
; 0000 01A0                     if(ButtonFilter[i]>=ButtonFiltrationTimer){
	CALL SUBOPT_0xD
	BRLO _0x54
; 0000 01A1                     BUTTON[i] = 1;
	CALL SUBOPT_0xE
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 01A2                     RefreshLcd = RefreshLcd + 2;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,-LOW(2)
	STS  _RefreshLcd_G000,R30
; 0000 01A3                     STAND_BY_TIMER = 45;
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	MOVW R4,R30
; 0000 01A4                     MAIN_MENU_TIMER = 30;
	LDI  R30,LOW(30)
	MOV  R7,R30
; 0000 01A5                     LCD_LED_TIMER = 15; lcd_light_now = lcd_light;
	LDI  R30,LOW(15)
	CALL SUBOPT_0xB
; 0000 01A6                     }
; 0000 01A7                     else{
	RJMP _0x55
_0x54:
; 0000 01A8                     BUTTON[i] = 0;
	CALL SUBOPT_0xE
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 01A9                     }
_0x55:
; 0000 01AA                 ButtonFilter[i] = 0;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_ButtonFilter_S0000006001)
	SBCI R31,HIGH(-_ButtonFilter_S0000006001)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 01AB                 }
_0x53:
; 0000 01AC             }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x4F
_0x50:
; 0000 01AD         }
	ADIW R28,1
; 0000 01AE     //////////////////////////////////////////////////////////////////////////////////
; 0000 01AF     //////////////////////////////////////////////////////////////////////////////////
; 0000 01B0     //////////////////////////////////////////////////////////////////////////////////
; 0000 01B1 
; 0000 01B2 
; 0000 01B3     //////////////////////////////////////////////////////////////////////////////////
; 0000 01B4     ///////////////////////////// LCD ////////////////////////////////////////////////
; 0000 01B5     //////////////////////////////////////////////////////////////////////////////////
; 0000 01B6     // Lcd led
; 0000 01B7     static unsigned char lcd_led_counter;
; 0000 01B8         if(LCD_LED_TIMER==0){
	TST  R6
	BRNE _0x56
; 0000 01B9             if(lcd_light_now>0){
	LDS  R26,_lcd_light_now_G000
	CPI  R26,LOW(0x1)
	BRLO _0x57
; 0000 01BA             lcd_led_counter++;
	LDS  R30,_lcd_led_counter_S0000006001
	SUBI R30,-LOW(1)
	STS  _lcd_led_counter_S0000006001,R30
; 0000 01BB                 if(lcd_led_counter>=25){
	LDS  R26,_lcd_led_counter_S0000006001
	CPI  R26,LOW(0x19)
	BRLO _0x58
; 0000 01BC                 lcd_led_counter = 0;
	LDI  R30,LOW(0)
	STS  _lcd_led_counter_S0000006001,R30
; 0000 01BD                 lcd_light_now--;
	LDS  R30,_lcd_light_now_G000
	SUBI R30,LOW(1)
	STS  _lcd_light_now_G000,R30
; 0000 01BE                 }
; 0000 01BF             }
_0x58:
; 0000 01C0         }
_0x57:
; 0000 01C1 
; 0000 01C2 
; 0000 01C3 
; 0000 01C4 
; 0000 01C5         if(RefreshLcd>=1){
_0x56:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x59
; 0000 01C6         lcd_clear();
	CALL _lcd_clear
; 0000 01C7         }
; 0000 01C8 
; 0000 01C9         // Pagrindinis langas
; 0000 01CA         if(Address[0]==0){
_0x59:
	LDS  R30,_Address_G000
	CPI  R30,0
	BRNE _0x5A
; 0000 01CB             if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S0000006001,4
	CPI  R26,LOW(0x1)
	BRNE _0x5B
; 0000 01CC             SelectAnotherRow(0);
	CALL SUBOPT_0xF
; 0000 01CD             }
; 0000 01CE             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x5C
_0x5B:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x5D
; 0000 01CF             SelectAnotherRow(1);
	CALL SUBOPT_0x10
; 0000 01D0             }
; 0000 01D1             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x5E
_0x5D:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x5F
; 0000 01D2             Address[0] = SelectedRow;
	CALL SUBOPT_0x11
; 0000 01D3             SelectedRow = 0;
; 0000 01D4             Address[5] = 0;
; 0000 01D5             }
; 0000 01D6 
; 0000 01D7             if(RefreshLcd>=1){
_0x5F:
_0x5E:
_0x5C:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x60
; 0000 01D8             lcd_putsf("  -=PAGR. MENIU=-   ");
	__POINTW1FN _0x0,81
	CALL SUBOPT_0xC
; 0000 01D9             lcd_putsf("VIDAUS TEMP.+22.5C <");
	CALL SUBOPT_0x12
; 0000 01DA 
; 0000 01DB 
; 0000 01DC 
; 0000 01DD             lcd_putsf("UZSTATYTA T.+22.0C  ");
	__POINTW1FN _0x0,123
	CALL SUBOPT_0xC
; 0000 01DE 
; 0000 01DF 
; 0000 01E0 
; 0000 01E1             lcd_putsf("NUSTATYMAI");
	__POINTW1FN _0x0,144
	CALL SUBOPT_0xC
; 0000 01E2             lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 01E3             lcd_putchar('<');
; 0000 01E4             }
; 0000 01E5         }
_0x60:
; 0000 01E6         else if(Address[0]==1){
	RJMP _0x61
_0x5A:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BRNE _0x62
; 0000 01E7             if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S0000006001,4
	CPI  R26,LOW(0x1)
	BRNE _0x63
; 0000 01E8             SelectAnotherRow(0);
	CALL SUBOPT_0xF
; 0000 01E9             }
; 0000 01EA             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x64
_0x63:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x65
; 0000 01EB             SelectAnotherRow(1);
	CALL SUBOPT_0x10
; 0000 01EC             }
; 0000 01ED             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x66
_0x65:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x67
; 0000 01EE             Address[0] = SelectedRow;
	CALL SUBOPT_0x11
; 0000 01EF             SelectedRow = 0;
; 0000 01F0             Address[5] = 0;
; 0000 01F1             }
; 0000 01F2 
; 0000 01F3             if(RefreshLcd>=1){
_0x67:
_0x66:
_0x64:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x68
; 0000 01F4             lcd_putsf("-=VIDIN.TERMOMETR.=-");
	__POINTW1FN _0x0,155
	CALL SUBOPT_0xC
; 0000 01F5             lcd_putsf("VIDAUS TEMP.+22.5C <");
	CALL SUBOPT_0x12
; 0000 01F6             lcd_putsf("PADERINIMAS: +0.0C  ");
	__POINTW1FN _0x0,176
	CALL SUBOPT_0xC
; 0000 01F7             lcd_putsf("ADRESAS: 012345678  ");
	__POINTW1FN _0x0,197
	CALL SUBOPT_0xC
; 0000 01F8             lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 01F9             lcd_putchar('<');
; 0000 01FA             }
; 0000 01FB         }
_0x68:
; 0000 01FC         else if(Address[0]==2){
	RJMP _0x69
_0x62:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x2)
	BRNE _0x6A
; 0000 01FD             if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S0000006001,4
	CPI  R26,LOW(0x1)
	BRNE _0x6B
; 0000 01FE             SelectAnotherRow(0);
	CALL SUBOPT_0xF
; 0000 01FF             }
; 0000 0200             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x6C
_0x6B:
	LDS  R26,_BUTTON_S0000006001
	CPI  R26,LOW(0x1)
	BRNE _0x6D
; 0000 0201             SelectAnotherRow(1);
	CALL SUBOPT_0x10
; 0000 0202             }
; 0000 0203             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x6E
_0x6D:
	__GETB2MN _BUTTON_S0000006001,2
	CPI  R26,LOW(0x1)
	BRNE _0x6F
; 0000 0204             Address[0] = SelectedRow;
	CALL SUBOPT_0x11
; 0000 0205             SelectedRow = 0;
; 0000 0206             Address[5] = 0;
; 0000 0207             }
; 0000 0208 
; 0000 0209             if(RefreshLcd>=1){
_0x6F:
_0x6E:
_0x6C:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x70
; 0000 020A             lcd_putsf("-=UZSTATY.=-");
	__POINTW1FN _0x0,218
	CALL SUBOPT_0xC
; 0000 020B             lcd_putsf("VIDAUS TEMP.+22.5C <");
	CALL SUBOPT_0x12
; 0000 020C             lcd_putsf("PADERINIMAS: +0.0C  ");
	__POINTW1FN _0x0,176
	CALL SUBOPT_0xC
; 0000 020D             lcd_putsf("ADRESAS: 012345678  ");
	__POINTW1FN _0x0,197
	CALL SUBOPT_0xC
; 0000 020E             lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 020F             lcd_putchar('<');
; 0000 0210             }
; 0000 0211         }
_0x70:
; 0000 0212 
; 0000 0213         if(RefreshLcd>=1){
_0x6A:
_0x69:
_0x61:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x71
; 0000 0214         RefreshLcd--;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,LOW(1)
	STS  _RefreshLcd_G000,R30
; 0000 0215         }
; 0000 0216     //////////////////////////////////////////////////////////////////////////////////
; 0000 0217     //////////////////////////////////////////////////////////////////////////////////
; 0000 0218     //////////////////////////////////////////////////////////////////////////////////
; 0000 0219     delay_ms(1);
_0x71:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 021A     }
	RJMP _0x49
; 0000 021B }
_0x72:
	RJMP _0x72
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
	BRLO _0x2000004
	__lcd_putchar1:
	INC  R11
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R11
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	INC  R8
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
	LDD  R10,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x15
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x16
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x16
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x16
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
_0x2020002:
	LDI  R30,LOW(1)
_0x2020001:
	ADIW R28,1
	RET

	.DSEG
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
_SecondCounter_S0000006001:
	.BYTE 0x2
_BUTTON_S0000006001:
	.BYTE 0x5
_ButtonFilter_S0000006001:
	.BYTE 0x5
_lcd_led_counter_S0000006001:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	__GETB1MN _Address_G000,5
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	__GETD2N 0xA
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	__GETD1S 6
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x1
	CALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__SUBD1N 1
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
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
SUBOPT_0x9:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xA:
	RCALL SUBOPT_0x4
	CALL __DIVD21U
	ST   Y,R30
	ST   -Y,R30
	CALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
	LD   R26,Y
	CLR  R27
	RCALL SUBOPT_0x9
	CALL __CWD2
	CALL __MULD12U
	RCALL SUBOPT_0x4
	CALL __SUBD21
	__PUTD2S 1
	__GETD2S 6
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	MOV  R6,R30
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	CALL __EEPROMRDB
	STS  _lcd_light_now_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_ButtonFilter_S0000006001)
	SBCI R31,HIGH(-_ButtonFilter_S0000006001)
	LD   R26,Z
	CPI  R26,LOW(0x14)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_BUTTON_S0000006001)
	SBCI R31,HIGH(-_BUTTON_S0000006001)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _SelectAnotherRow

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _SelectAnotherRow

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	LDS  R30,_SelectedRow_G000
	STS  _Address_G000,R30
	LDI  R30,LOW(0)
	STS  _SelectedRow_G000,R30
	__PUTB1MN _Address_G000,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	__POINTW1FN _0x0,102
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDS  R26,_SelectedRow_G000
	CLR  R27
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x14:
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _lcd_gotoxy
	LDI  R30,LOW(60)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
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

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

;END OF CODE MARKER
__END_OF_CODE:
