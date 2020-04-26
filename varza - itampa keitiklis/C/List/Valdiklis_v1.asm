
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

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

_0x0:
	.DB  0x20,0x62,0x69,0x74,0x0
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
;
;
;
;
;// Alphanumeric LCD Module functions portc
;#include <lcd.h>
;#asm
   .equ __lcd_port=0x15
; 0000 0015 #endasm
;
;
;char NumToIndex(char Num){
; 0000 0018 char NumToIndex(char Num){

	.CSEG
_NumToIndex:
; 0000 0019     if(Num==0){     return '0';}
;	Num -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x3
	LDI  R30,LOW(48)
	JMP  _0x2020001
; 0000 001A     else if(Num==1){return '1';}
_0x3:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x5
	LDI  R30,LOW(49)
	JMP  _0x2020001
; 0000 001B     else if(Num==2){return '2';}
_0x5:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x7
	LDI  R30,LOW(50)
	JMP  _0x2020001
; 0000 001C     else if(Num==3){return '3';}
_0x7:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x9
	LDI  R30,LOW(51)
	JMP  _0x2020001
; 0000 001D     else if(Num==4){return '4';}
_0x9:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xB
	LDI  R30,LOW(52)
	JMP  _0x2020001
; 0000 001E     else if(Num==5){return '5';}
_0xB:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0xD
	LDI  R30,LOW(53)
	JMP  _0x2020001
; 0000 001F     else if(Num==6){return '6';}
_0xD:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0xF
	LDI  R30,LOW(54)
	JMP  _0x2020001
; 0000 0020     else if(Num==7){return '7';}
_0xF:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x11
	LDI  R30,LOW(55)
	JMP  _0x2020001
; 0000 0021     else if(Num==8){return '8';}
_0x11:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x13
	LDI  R30,LOW(56)
	JMP  _0x2020001
; 0000 0022     else if(Num==9){return '9';}
_0x13:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x15
	LDI  R30,LOW(57)
	JMP  _0x2020001
; 0000 0023     else{           return '-';}
_0x15:
	LDI  R30,LOW(45)
	JMP  _0x2020001
; 0000 0024 return 0;
; 0000 0025 }
;
;char lcd_put_number(char Type, char Lenght, char IsSign,
; 0000 0028 
; 0000 0029                     char NumbersAfterDot,
; 0000 002A 
; 0000 002B                     unsigned long int Number0,
; 0000 002C                     signed long int Number1){
_lcd_put_number:
; 0000 002D     if(Lenght>0){
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
; 0000 002E     unsigned long int k = 1;
; 0000 002F     unsigned char i;
; 0000 0030         for(i=0;i<Lenght-1;i++) k = k*10;
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
	__GETD1S 1
	__GETD2N 0xA
	CALL __MULD12U
	__PUTD1S 1
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x19
_0x1A:
; 0000 0032 if(Type==0){
	LDD  R30,Y+16
	CPI  R30,0
	BREQ PC+3
	JMP _0x1B
; 0000 0033         unsigned long int a;
; 0000 0034         unsigned char b;
; 0000 0035         a = Number0;
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
; 0000 0036 
; 0000 0037             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x1C
; 0000 0038             lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0039             }
; 0000 003A 
; 0000 003B             if(a<0){
_0x1C:
	__GETD2S 1
; 0000 003C             a = a*(-1);
; 0000 003D             }
; 0000 003E 
; 0000 003F             if(k*10<a){
	__GETD1S 6
	__GETD2N 0xA
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 1
	CALL __CPD21
	BRSH _0x1E
; 0000 0040             a = k*10 - 1;
	__GETD1S 6
	__GETD2N 0xA
	CALL __MULD12U
	__SUBD1N 1
	__PUTD1S 1
; 0000 0041             }
; 0000 0042 
; 0000 0043             for(i=0;i<Lenght;i++){
_0x1E:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x20:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRLO PC+3
	JMP _0x21
; 0000 0044                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x22
; 0000 0045                     if(Lenght-NumbersAfterDot==i){
	LDD  R26,Y+20
	CLR  R27
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDD  R30,Y+5
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x23
; 0000 0046                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0047                     }
; 0000 0048                 }
_0x23:
; 0000 0049             b = a/k;
_0x22:
	__GETD1S 6
	__GETD2S 1
	CALL __DIVD21U
	ST   Y,R30
; 0000 004A             lcd_putchar( NumToIndex( b ) );
	ST   -Y,R30
	RCALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 004B             a = a - b*k;
	LD   R26,Y
	CLR  R27
	__GETD1S 6
	CALL __CWD2
	CALL __MULD12U
	__GETD2S 1
	CALL __SUBD21
	__PUTD2S 1
; 0000 004C             k = k/10;
	__GETD2S 6
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 6
; 0000 004D             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x20
_0x21:
; 0000 004E         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2020002
; 0000 004F         }
; 0000 0050 
; 0000 0051         else if(Type==1){
_0x1B:
	LDD  R26,Y+16
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x25
; 0000 0052         signed long int a;
; 0000 0053         unsigned char b;
; 0000 0054         a = Number1;
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
; 0000 0055 
; 0000 0056             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x26
; 0000 0057                 if(a>=0){
	LDD  R26,Y+4
	TST  R26
	BRMI _0x27
; 0000 0058                 lcd_putchar('+');
	LDI  R30,LOW(43)
	RJMP _0x37
; 0000 0059                 }
; 0000 005A                 else{
_0x27:
; 0000 005B                 lcd_putchar('-');
	LDI  R30,LOW(45)
_0x37:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 005C                 }
; 0000 005D             }
; 0000 005E 
; 0000 005F             if(a<0){
_0x26:
	LDD  R26,Y+4
	TST  R26
	BRPL _0x29
; 0000 0060             a = a*(-1);
	__GETD1S 1
	__GETD2N 0xFFFFFFFF
	CALL __MULD12
	__PUTD1S 1
; 0000 0061             }
; 0000 0062 
; 0000 0063             if(k*10<a){
_0x29:
	__GETD1S 6
	__GETD2N 0xA
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 1
	CALL __CPD21
	BRSH _0x2A
; 0000 0064             a = k*10 - 1;
	__GETD1S 6
	__GETD2N 0xA
	CALL __MULD12U
	__SUBD1N 1
	__PUTD1S 1
; 0000 0065             }
; 0000 0066 
; 0000 0067             for(i=0;i<Lenght;i++){
_0x2A:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x2C:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRLO PC+3
	JMP _0x2D
; 0000 0068                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x2E
; 0000 0069                     if(Lenght-NumbersAfterDot==i){
	LDD  R26,Y+20
	CLR  R27
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDD  R30,Y+5
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x2F
; 0000 006A                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 006B                     }
; 0000 006C                 }
_0x2F:
; 0000 006D             b = a/k;
_0x2E:
	__GETD1S 6
	__GETD2S 1
	CALL __DIVD21U
	ST   Y,R30
; 0000 006E             lcd_putchar( NumToIndex( b ) );
	ST   -Y,R30
	RCALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 006F             a = a - b*k;
	LD   R26,Y
	CLR  R27
	__GETD1S 6
	CALL __CWD2
	CALL __MULD12U
	__GETD2S 1
	CALL __SUBD21
	__PUTD2S 1
; 0000 0070             k = k/10;
	__GETD2S 6
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 6
; 0000 0071             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x2C
_0x2D:
; 0000 0072         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2020002
; 0000 0073         }
; 0000 0074     }
_0x25:
	ADIW R28,5
; 0000 0075 return 0;
_0x17:
	LDI  R30,LOW(0)
_0x2020002:
	ADIW R28,12
	RET
; 0000 0076 }
;
;
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
;#define ADC_VREF_TYPE 0x00
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 008A {
_read_adc:
; 0000 008B ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 008C // Delay needed for the stabilization of the ADC input voltage
; 0000 008D delay_us(10);
	__DELAY_USB 27
; 0000 008E // Start the AD conversion
; 0000 008F ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0090 // Wait for the AD conversion to complete
; 0000 0091 while ((ADCSRA & 0x10)==0);
_0x30:
	SBIS 0x6,4
	RJMP _0x30
; 0000 0092 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0093 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2020001
; 0000 0094 }
;
;
;
;
;void main(void){
; 0000 0099 void main(void){
_main:
; 0000 009A // Input/Output Ports initialization
; 0000 009B // Port A initialization
; 0000 009C // Func7=Out Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=In
; 0000 009D // State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0
; 0000 009E PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 009F DDRA=0b00000000;
	OUT  0x1A,R30
; 0000 00A0 
; 0000 00A1 // Port B initialization
; 0000 00A2 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 00A3 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A4 PORTB=0x00;
	OUT  0x18,R30
; 0000 00A5 DDRB=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 00A6 
; 0000 00A7 // Port C initialization
; 0000 00A8 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A9 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00AA PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00AB DDRC=0b00000000;
	OUT  0x14,R30
; 0000 00AC 
; 0000 00AD // Port D initialization
; 0000 00AE // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00AF // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00B0 PORTD=0x00;
	OUT  0x12,R30
; 0000 00B1 DDRD=0b00000000;
	OUT  0x11,R30
; 0000 00B2 
; 0000 00B3 // Timer/Counter 0 initialization
; 0000 00B4 // Clock source: System Clock
; 0000 00B5 // Clock value: Timer 0 Stopped
; 0000 00B6 // Mode: Normal top=FFh
; 0000 00B7 // OC0 output: Disconnected
; 0000 00B8 TCCR0=0x00;
	OUT  0x33,R30
; 0000 00B9 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00BA OCR0=0x00;
	OUT  0x3C,R30
; 0000 00BB 
; 0000 00BC // Timer/Counter 1 initialization
; 0000 00BD // Clock source: System Clock
; 0000 00BE // Clock value: Timer1 Stopped
; 0000 00BF // Mode: Normal top=FFFFh
; 0000 00C0 // OC1A output: Discon.
; 0000 00C1 // OC1B output: Discon.
; 0000 00C2 // Noise Canceler: Off
; 0000 00C3 // Input Capture on Falling Edge
; 0000 00C4 // Timer1 Overflow Interrupt: Off
; 0000 00C5 // Input Capture Interrupt: Off
; 0000 00C6 // Compare A Match Interrupt: Off
; 0000 00C7 // Compare B Match Interrupt: Off
; 0000 00C8 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00C9 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00CA TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00CB TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00CC ICR1H=0x00;
	OUT  0x27,R30
; 0000 00CD ICR1L=0x00;
	OUT  0x26,R30
; 0000 00CE OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00CF OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00D0 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00D1 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00D2 
; 0000 00D3 // Timer/Counter 2 initialization
; 0000 00D4 // Clock source: System Clock
; 0000 00D5 // Clock value: Timer2 Stopped
; 0000 00D6 // Mode: Normal top=FFh
; 0000 00D7 // OC2 output: Disconnected
; 0000 00D8 ASSR=0x00;
	OUT  0x22,R30
; 0000 00D9 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00DA TCNT2=0x00;
	OUT  0x24,R30
; 0000 00DB OCR2=0x00;
	OUT  0x23,R30
; 0000 00DC 
; 0000 00DD // External Interrupt(s) initialization
; 0000 00DE // INT0: Off
; 0000 00DF // INT1: Off
; 0000 00E0 // INT2: Off
; 0000 00E1 MCUCR=0x00;
	OUT  0x35,R30
; 0000 00E2 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 00E3 
; 0000 00E4 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00E5 TIMSK=0x00;
	OUT  0x39,R30
; 0000 00E6 
; 0000 00E7 // Analog Comparator initialization
; 0000 00E8 // Analog Comparator: Off
; 0000 00E9 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00EA ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00EB SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00EC 
; 0000 00ED // ADC initialization
; 0000 00EE // ADC Clock frequency: 1000.000 kHz
; 0000 00EF // ADC Voltage Reference: AREF pin
; 0000 00F0 // Only the 8 most significant bits of
; 0000 00F1 // the AD conversion result are used
; 0000 00F2 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 00F3 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00F4 
; 0000 00F5 // LCD module initialization
; 0000 00F6 lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 00F7 
; 0000 00F8 // Global enable interrupts
; 0000 00F9 #asm("sei")
	sei
; 0000 00FA 
; 0000 00FB 
; 0000 00FC 
; 0000 00FD 
; 0000 00FE     while(1){
_0x33:
; 0000 00FF     unsigned int a;
; 0000 0100     a = read_adc(0);
	SBIW R28,2
;	a -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	ST   Y,R30
	STD  Y+1,R31
; 0000 0101     lcd_clear();
	CALL _lcd_clear
; 0000 0102     lcd_put_number(1,4,0,0,0,a);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RCALL _lcd_put_number
; 0000 0103     lcd_putsf(" bit");
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0104     delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0105     }
	ADIW R28,2
	RJMP _0x33
; 0000 0106 }
_0x36:
	RJMP _0x36
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
	LDD  R5,Y+1
	LDD  R4,Y+0
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
	MOV  R4,R30
	MOV  R5,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	CP   R5,R7
	BRLO _0x2000004
	__lcd_putchar1:
	INC  R4
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R4
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	INC  R5
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
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	ST   -Y,R30
	CALL __lcd_write_data
	RCALL __long_delay_G100
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL __lcd_write_data
	RCALL __long_delay_G100
	LDI  R30,LOW(133)
	ST   -Y,R30
	CALL __lcd_write_data
	RCALL __long_delay_G100
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
__base_y_G100:
	.BYTE 0x4

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

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

;END OF CODE MARKER
__END_OF_CODE:
