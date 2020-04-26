
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
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
	.DEF _RealTimeYear=R5
	.DEF _RealTimeMonth=R4
	.DEF _RealTimeDay=R7
	.DEF _RealTimeHour=R6
	.DEF _RealTimeMinute=R9
	.DEF _RealTimeWeekDay=R8
	.DEF _RealTimeSecond=R11
	.DEF _IsRealTimePrecisioned=R10
	.DEF _STAND_BY_TIMER=R12

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

_0x0:
	.DB  0x2B,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2B,0x0,0x7C,0x20,0x42
	.DB  0x41,0x5A,0x4E,0x59,0x43,0x49,0x4F,0x53
	.DB  0x20,0x56,0x41,0x52,0x50,0x55,0x20,0x20
	.DB  0x7C,0x0,0x7C,0x20,0x56,0x41,0x4C,0x44
	.DB  0x49,0x4B,0x4C,0x49,0x53,0x20,0x56,0x31
	.DB  0x2E,0x0,0x20,0x7C,0x2B,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2B
	.DB  0x0,0x2B,0x3E,0x0,0x2D,0x2D,0x3E,0x0
	.DB  0x3C,0x2B,0x0,0x3C,0x2D,0x2D,0x0,0x2B
	.DB  0x2D,0x0,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x3A,0x0,0x20,0x20,0x20,0x20,0x32,0x0
	.DB  0x4B,0x4F,0x44,0x41,0x53,0x0,0x54,0x45
	.DB  0x49,0x53,0x49,0x4E,0x47,0x41,0x53,0x0
	.DB  0x4E,0x45,0x54,0x45,0x49,0x53,0x49,0x4E
	.DB  0x47,0x41,0x53,0x0,0x2D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x55,0x5A,0x52,0x41,0x4B,0x54
	.DB  0x41,0x53,0x3D,0x3D,0x3D,0x3D,0x3D,0x2D
	.DB  0x0,0x49,0x56,0x45,0x53,0x4B,0x49,0x54
	.DB  0x45,0x20,0x4B,0x4F,0x44,0x41,0x3A,0x20
	.DB  0x0,0x2D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x2D,0x0,0x20,0x20
	.DB  0x2D,0x3D,0x50,0x41,0x47,0x52,0x2E,0x20
	.DB  0x4D,0x45,0x4E,0x49,0x55,0x3D,0x2D,0x0
	.DB  0x31,0x2E,0x4C,0x41,0x49,0x4B,0x41,0x53
	.DB  0x3A,0x20,0x0,0x32,0x2E,0x44,0x41,0x54
	.DB  0x41,0x3A,0x20,0x32,0x30,0x0,0x33,0x2E
	.DB  0x53,0x4B,0x41,0x4D,0x42,0x45,0x4A,0x49
	.DB  0x4D,0x41,0x49,0x0,0x34,0x2E,0x4E,0x55
	.DB  0x53,0x54,0x41,0x54,0x59,0x4D,0x41,0x49
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x2D,0x3D
	.DB  0x4C,0x41,0x49,0x4B,0x41,0x53,0x3D,0x2D
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x52,0x45,0x44,0x41
	.DB  0x47,0x55,0x4F,0x54,0x49,0x3F,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x5E
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x5E,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x5E
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x5E,0x0,0x28
	.DB  0x5A,0x49,0x45,0x4D,0x4F,0x53,0x20,0x4C
	.DB  0x41,0x49,0x4B,0x41,0x53,0x29,0x0,0x28
	.DB  0x56,0x41,0x53,0x41,0x52,0x4F,0x53,0x20
	.DB  0x4C,0x41,0x49,0x4B,0x41,0x53,0x29,0x0
	.DB  0x20,0x2D,0x3D,0x4E,0x55,0x53,0x54,0x41
	.DB  0x54,0x59,0x54,0x49,0x20,0x44,0x41,0x54
	.DB  0x41,0x3D,0x2D,0x20,0x0,0x53,0x41,0x56
	.DB  0x2E,0x44,0x49,0x45,0x4E,0x41,0x3A,0x20
	.DB  0x50,0x49,0x52,0x4D,0x41,0x44,0x2E,0x20
	.DB  0x20,0x0,0x53,0x41,0x56,0x2E,0x44,0x49
	.DB  0x45,0x4E,0x41,0x3A,0x20,0x41,0x4E,0x54
	.DB  0x52,0x41,0x44,0x2E,0x20,0x20,0x0,0x53
	.DB  0x41,0x56,0x2E,0x44,0x49,0x45,0x4E,0x41
	.DB  0x3A,0x20,0x54,0x52,0x45,0x43,0x49,0x41
	.DB  0x44,0x2E,0x20,0x0,0x53,0x41,0x56,0x2E
	.DB  0x44,0x49,0x45,0x4E,0x41,0x3A,0x20,0x4B
	.DB  0x45,0x54,0x56,0x49,0x52,0x54,0x2E,0x20
	.DB  0x0,0x53,0x41,0x56,0x2E,0x44,0x49,0x45
	.DB  0x4E,0x41,0x3A,0x20,0x50,0x45,0x4E,0x4B
	.DB  0x54,0x41,0x44,0x2E,0x20,0x0,0x53,0x41
	.DB  0x56,0x2E,0x44,0x49,0x45,0x4E,0x41,0x3A
	.DB  0x20,0x53,0x45,0x53,0x54,0x41,0x44,0x2E
	.DB  0x20,0x20,0x0,0x53,0x41,0x56,0x2E,0x44
	.DB  0x49,0x45,0x4E,0x41,0x3A,0x20,0x53,0x45
	.DB  0x4B,0x4D,0x41,0x44,0x2E,0x20,0x20,0x0
	.DB  0x3F,0x3F,0x3F,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x44,0x41,0x54
	.DB  0x41,0x3A,0x20,0x32,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x52,0x45,0x44,0x41,0x47
	.DB  0x55,0x4F,0x54,0x49,0x3F,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x5E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x5E,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x5E
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x5E,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x5E,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x5E,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x7C,0x20,0x20,0x20,0x0,0x20,0x20,0x2D
	.DB  0x3D,0x53,0x4B,0x41,0x4D,0x42,0x45,0x4A
	.DB  0x49,0x4D,0x41,0x49,0x3D,0x2D,0x0,0x31
	.DB  0x2E,0x45,0x49,0x4C,0x49,0x4E,0x49,0x53
	.DB  0x20,0x4C,0x41,0x49,0x4B,0x41,0x53,0x0
	.DB  0x32,0x2E,0x56,0x45,0x4C,0x59,0x4B,0x55
	.DB  0x20,0x4C,0x41,0x49,0x4B,0x41,0x53,0x0
	.DB  0x33,0x2E,0x4B,0x41,0x4C,0x45,0x44,0x55
	.DB  0x20,0x4C,0x41,0x49,0x4B,0x41,0x53,0x0
	.DB  0x20,0x2D,0x3D,0x45,0x49,0x4C,0x49,0x4E
	.DB  0x49,0x53,0x20,0x4C,0x41,0x49,0x4B,0x41
	.DB  0x53,0x3D,0x2D,0x0,0x31,0x2E,0x50,0x49
	.DB  0x52,0x4D,0x41,0x44,0x2E,0x20,0x4C,0x41
	.DB  0x49,0x4B,0x41,0x53,0x0,0x32,0x2E,0x41
	.DB  0x4E,0x54,0x52,0x41,0x44,0x2E,0x20,0x4C
	.DB  0x41,0x49,0x4B,0x41,0x53,0x0,0x33,0x2E
	.DB  0x54,0x52,0x45,0x43,0x49,0x41,0x44,0x2E
	.DB  0x20,0x4C,0x41,0x49,0x4B,0x41,0x53,0x0
	.DB  0x34,0x2E,0x4B,0x45,0x54,0x56,0x49,0x52
	.DB  0x54,0x41,0x44,0x2E,0x20,0x4C,0x41,0x49
	.DB  0x4B,0x41,0x53,0x0,0x35,0x2E,0x50,0x45
	.DB  0x4E,0x4B,0x54,0x41,0x44,0x2E,0x20,0x4C
	.DB  0x41,0x49,0x4B,0x41,0x53,0x0,0x36,0x2E
	.DB  0x53,0x45,0x53,0x54,0x41,0x44,0x2E,0x20
	.DB  0x4C,0x41,0x49,0x4B,0x41,0x53,0x0,0x37
	.DB  0x2E,0x53,0x45,0x4B,0x4D,0x41,0x44,0x2E
	.DB  0x20,0x4C,0x41,0x49,0x4B,0x41,0x53,0x0
	.DB  0x20,0x20,0x2D,0x3D,0x50,0x49,0x52,0x4D
	.DB  0x41,0x44,0x49,0x45,0x4E,0x49,0x53,0x3D
	.DB  0x2D,0x0,0x20,0x20,0x2D,0x3D,0x41,0x4E
	.DB  0x54,0x52,0x41,0x44,0x49,0x45,0x4E,0x49
	.DB  0x53,0x3D,0x2D,0x0,0x20,0x20,0x2D,0x3D
	.DB  0x54,0x52,0x45,0x43,0x49,0x41,0x44,0x49
	.DB  0x45,0x4E,0x49,0x53,0x3D,0x2D,0x0,0x20
	.DB  0x2D,0x3D,0x4B,0x45,0x54,0x56,0x49,0x52
	.DB  0x54,0x41,0x44,0x49,0x45,0x4E,0x49,0x53
	.DB  0x3D,0x2D,0x0,0x20,0x20,0x2D,0x3D,0x50
	.DB  0x45,0x4E,0x4B,0x54,0x41,0x44,0x49,0x45
	.DB  0x4E,0x49,0x53,0x3D,0x2D,0x0,0x20,0x20
	.DB  0x2D,0x3D,0x53,0x45,0x53,0x54,0x41,0x44
	.DB  0x49,0x45,0x4E,0x49,0x53,0x3D,0x2D,0x0
	.DB  0x20,0x20,0x2D,0x3D,0x53,0x45,0x4B,0x4D
	.DB  0x41,0x44,0x49,0x45,0x4E,0x49,0x53,0x3D
	.DB  0x2D,0x0,0x20,0x28,0x0,0x53,0x45,0x43
	.DB  0x29,0x0,0x54,0x55,0x53,0x43,0x49,0x41
	.DB  0x0,0x20,0x2D,0x3D,0x4C,0x41,0x49,0x4B
	.DB  0x4F,0x20,0x4B,0x45,0x49,0x54,0x49,0x4D
	.DB  0x41,0x53,0x3D,0x2D,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x5E,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x5E
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x5E,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x54,0x52,0x49,0x4E,0x54
	.DB  0x49,0x3F,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x2D,0x3D,0x56,0x45,0x4C,0x59
	.DB  0x4B,0x55,0x20,0x4C,0x41,0x49,0x4B,0x41
	.DB  0x53,0x3D,0x2D,0x0,0x31,0x2E,0x56,0x45
	.DB  0x4C,0x59,0x4B,0x55,0x20,0x4B,0x45,0x54
	.DB  0x56,0x49,0x52,0x54,0x41,0x44,0x2E,0x0
	.DB  0x32,0x2E,0x56,0x45,0x4C,0x59,0x4B,0x55
	.DB  0x20,0x50,0x45,0x4E,0x4B,0x54,0x41,0x44
	.DB  0x2E,0x0,0x33,0x2E,0x56,0x45,0x4C,0x59
	.DB  0x4B,0x55,0x20,0x53,0x45,0x53,0x54,0x41
	.DB  0x44,0x49,0x45,0x4E,0x2E,0x0,0x34,0x2E
	.DB  0x56,0x45,0x4C,0x59,0x4B,0x55,0x20,0x53
	.DB  0x45,0x4B,0x4D,0x41,0x44,0x2E,0x0,0x35
	.DB  0x2E,0x4B,0x41,0x44,0x41,0x20,0x42,0x55
	.DB  0x53,0x20,0x56,0x45,0x4C,0x59,0x4B,0x4F
	.DB  0x53,0x3F,0x0,0x2D,0x3D,0x56,0x45,0x4C
	.DB  0x2E,0x20,0x4B,0x45,0x54,0x56,0x49,0x52
	.DB  0x54,0x41,0x44,0x2E,0x3D,0x2D,0x0,0x20
	.DB  0x2D,0x3D,0x56,0x45,0x4C,0x2E,0x20,0x50
	.DB  0x45,0x4E,0x4B,0x54,0x41,0x44,0x2E,0x3D
	.DB  0x2D,0x0,0x20,0x20,0x2D,0x3D,0x56,0x45
	.DB  0x4C,0x2E,0x20,0x53,0x45,0x53,0x54,0x41
	.DB  0x44,0x2E,0x3D,0x2D,0x0,0x20,0x20,0x2D
	.DB  0x3D,0x56,0x45,0x4C,0x2E,0x20,0x53,0x45
	.DB  0x4B,0x4D,0x41,0x44,0x2E,0x3D,0x2D,0x0
	.DB  0x20,0x20,0x2D,0x3D,0x56,0x45,0x4C,0x59
	.DB  0x4B,0x55,0x20,0x44,0x41,0x54,0x4F,0x53
	.DB  0x3D,0x2D,0x20,0x20,0x0,0x31,0x2E,0x20
	.DB  0x32,0x0,0x32,0x2E,0x20,0x32,0x0,0x33
	.DB  0x2E,0x20,0x32,0x0,0x20,0x2D,0x3D,0x4B
	.DB  0x41,0x4C,0x45,0x44,0x55,0x20,0x4C,0x41
	.DB  0x49,0x4B,0x41,0x53,0x3D,0x2D,0x0,0x31
	.DB  0x2E,0x47,0x52,0x55,0x4F,0x44,0x5A,0x49
	.DB  0x4F,0x20,0x32,0x35,0x20,0x44,0x2E,0x0
	.DB  0x32,0x2E,0x47,0x52,0x55,0x4F,0x44,0x5A
	.DB  0x49,0x4F,0x20,0x32,0x36,0x20,0x44,0x2E
	.DB  0x0,0x20,0x2D,0x3D,0x47,0x52,0x55,0x4F
	.DB  0x44,0x5A,0x49,0x4F,0x20,0x32,0x35,0x20
	.DB  0x44,0x2E,0x3D,0x2D,0x0,0x20,0x2D,0x3D
	.DB  0x47,0x52,0x55,0x4F,0x44,0x5A,0x49,0x4F
	.DB  0x20,0x32,0x36,0x20,0x44,0x2E,0x3D,0x2D
	.DB  0x0,0x20,0x20,0x20,0x2D,0x3D,0x4E,0x55
	.DB  0x53,0x54,0x41,0x54,0x59,0x4D,0x41,0x49
	.DB  0x3D,0x2D,0x20,0x20,0x20,0x0,0x31,0x2E
	.DB  0x45,0x4B,0x52,0x41,0x4E,0x4F,0x20,0x41
	.DB  0x50,0x53,0x56,0x49,0x45,0x54,0x49,0x4D
	.DB  0x2E,0x0,0x32,0x2E,0x56,0x41,0x4C,0x59
	.DB  0x54,0x49,0x20,0x53,0x4B,0x41,0x4D,0x42
	.DB  0x45,0x4A,0x49,0x4D,0x2E,0x0,0x33,0x2E
	.DB  0x56,0x41,0x53,0x41,0x52,0x4F,0x53,0x20
	.DB  0x4C,0x41,0x49,0x4B,0x41,0x53,0x0,0x34
	.DB  0x2E,0x4C,0x41,0x49,0x4B,0x4F,0x20,0x54
	.DB  0x49,0x4B,0x53,0x4C,0x49,0x4E,0x49,0x4D
	.DB  0x41,0x53,0x0,0x35,0x2E,0x56,0x41,0x4C
	.DB  0x44,0x49,0x4B,0x4C,0x49,0x4F,0x20,0x4B
	.DB  0x4F,0x44,0x41,0x53,0x0,0x36,0x2E,0x56
	.DB  0x41,0x4C,0x44,0x49,0x4B,0x4C,0x49,0x4F
	.DB  0x20,0x49,0x53,0x56,0x41,0x44,0x41,0x49
	.DB  0x0,0x2D,0x3D,0x45,0x4B,0x52,0x41,0x4E
	.DB  0x4F,0x20,0x41,0x50,0x53,0x56,0x49,0x45
	.DB  0x54,0x2E,0x3D,0x2D,0x20,0x0,0x41,0x50
	.DB  0x53,0x56,0x49,0x45,0x54,0x49,0x4D,0x41
	.DB  0x53,0x3A,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x56,0x41,0x4C,0x59,0x54,0x49
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x53,0x4B,0x41,0x4D
	.DB  0x42,0x45,0x4A,0x49,0x4D,0x55,0x53,0x3F
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x4E,0x45,0x20,0x20,0x20,0x20
	.DB  0x20,0x54,0x41,0x49,0x50,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x5E
	.DB  0x5E,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x3C,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x5E,0x5E,0x5E,0x5E,0x20
	.DB  0x20,0x20,0x3C,0x0,0x54,0x52,0x49,0x4E
	.DB  0x41,0x4D,0x49,0x20,0x53,0x4B,0x41,0x4D
	.DB  0x42,0x45,0x4A,0x49,0x4D,0x41,0x49,0x3A
	.DB  0x0,0x42,0x20,0x2F,0x20,0x0,0x42,0x0
	.DB  0x20,0x2D,0x3D,0x56,0x41,0x53,0x41,0x52
	.DB  0x4F,0x53,0x20,0x4C,0x41,0x49,0x4B,0x41
	.DB  0x53,0x3D,0x2D,0x20,0x0,0x50,0x41,0x44
	.DB  0x45,0x54,0x49,0x53,0x3A,0x20,0x0,0x49
	.DB  0x53,0x4A,0x55,0x4E,0x47,0x54,0x41,0x53
	.DB  0x0,0x49,0x4A,0x55,0x4E,0x47,0x54,0x41
	.DB  0x53,0x0,0x20,0x20,0x2D,0x3D,0x54,0x49
	.DB  0x4B,0x53,0x4C,0x49,0x4E,0x49,0x4D,0x41
	.DB  0x53,0x3D,0x2D,0x20,0x20,0x2B,0x0,0x4C
	.DB  0x41,0x49,0x4B,0x4F,0x20,0x54,0x49,0x4B
	.DB  0x53,0x4C,0x49,0x4E,0x49,0x4D,0x41,0x53
	.DB  0x20,0x20,0x20,0x0,0x53,0x45,0x4B,0x55
	.DB  0x4E,0x44,0x45,0x4D,0x49,0x53,0x20,0x50
	.DB  0x45,0x52,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x4D,0x45,0x4E,0x45,0x53,0x49,0x3A
	.DB  0x20,0x20,0x0,0x20,0x53,0x45,0x43,0x2E
	.DB  0x20,0x20,0x2D,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x2D,0x3D,0x4B,0x4F,0x44,0x41,0x53
	.DB  0x3D,0x2D,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x31,0x2E,0x49,0x53,0x4A,0x55,0x4E
	.DB  0x47,0x54,0x49,0x20,0x4B,0x4F,0x44,0x41
	.DB  0x3F,0x20,0x20,0x20,0x20,0x0,0x32,0x2E
	.DB  0x4B,0x4F,0x44,0x41,0x53,0x3A,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x2A,0x2A,0x2A,0x2A
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x52,0x45,0x44
	.DB  0x41,0x47,0x55,0x4F,0x54,0x49,0x3F,0x0
	.DB  0x31,0x2E,0x20,0x49,0x4A,0x55,0x4E,0x47
	.DB  0x54,0x49,0x20,0x4B,0x4F,0x44,0x41,0x3F
	.DB  0x0,0x20,0x20,0x20,0x20,0x2D,0x3D,0x49
	.DB  0x53,0x56,0x41,0x44,0x41,0x49,0x3D,0x2D
	.DB  0x20,0x20,0x20,0x20,0x2B,0x0,0x31,0x2E
	.DB  0x20,0x56,0x41,0x52,0x50,0x55,0x20,0x49
	.DB  0x53,0x45,0x4A,0x2E,0x3A,0x20,0x0
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
;Project     : Baznycios varpu valdiklis V1.0
;Date        : 2012.02.06
;Author      : Tomas Vanagas
;Chip type   : ATmega32
;*****************************************************/
;
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
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=7
   .equ __scl_bit=6
; 0000 0010 #endasm
;#include <i2c.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// PINS
;eeprom unsigned char BELL_OUTPUT_ADDRESS;
;#define BELL_OUTPUT_DEFAULT 22
;
;#define BUTTON_UP 0
;#define BUTTON_LEFT 1
;#define BUTTON_ENTER 2
;#define BUTTON_RIGHT 3
;#define BUTTON_DOWN 4
;
;unsigned char OUTPUT(unsigned char address, unsigned char value){
; 0000 0020 unsigned char OUTPUT(unsigned char address, unsigned char value){

	.CSEG
_OUTPUT:
; 0000 0021     if(address==17){
;	address -> Y+1
;	value -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0x11)
	BRNE _0x3
; 0000 0022     PORTC.3 = value;
	LD   R30,Y
	CPI  R30,0
	BRNE _0x4
	CBI  0x15,3
	RJMP _0x5
_0x4:
	SBI  0x15,3
_0x5:
; 0000 0023     return 1;
	LDI  R30,LOW(1)
	RJMP _0x2060009
; 0000 0024     }
; 0000 0025     else if(address==18){
_0x3:
	LDD  R26,Y+1
	CPI  R26,LOW(0x12)
	BRNE _0x7
; 0000 0026     PORTC.4 = value;
	LD   R30,Y
	CPI  R30,0
	BRNE _0x8
	CBI  0x15,4
	RJMP _0x9
_0x8:
	SBI  0x15,4
_0x9:
; 0000 0027     return 1;
	LDI  R30,LOW(1)
	RJMP _0x2060009
; 0000 0028     }
; 0000 0029     else if(address==19){
_0x7:
	LDD  R26,Y+1
	CPI  R26,LOW(0x13)
	BRNE _0xB
; 0000 002A     PORTC.5 = value;
	LD   R30,Y
	CPI  R30,0
	BRNE _0xC
	CBI  0x15,5
	RJMP _0xD
_0xC:
	SBI  0x15,5
_0xD:
; 0000 002B     return 1;
	LDI  R30,LOW(1)
	RJMP _0x2060009
; 0000 002C     }
; 0000 002D     else if(address==20){
_0xB:
	LDD  R26,Y+1
	CPI  R26,LOW(0x14)
	BRNE _0xF
; 0000 002E     PORTD.5 = value;
	LD   R30,Y
	CPI  R30,0
	BRNE _0x10
	CBI  0x12,5
	RJMP _0x11
_0x10:
	SBI  0x12,5
_0x11:
; 0000 002F     return 1;
	LDI  R30,LOW(1)
	RJMP _0x2060009
; 0000 0030     }
; 0000 0031     else if(address==21){
_0xF:
	LDD  R26,Y+1
	CPI  R26,LOW(0x15)
	BRNE _0x13
; 0000 0032     PORTD.4 = value;
	LD   R30,Y
	CPI  R30,0
	BRNE _0x14
	CBI  0x12,4
	RJMP _0x15
_0x14:
	SBI  0x12,4
_0x15:
; 0000 0033     return 1;
	LDI  R30,LOW(1)
	RJMP _0x2060009
; 0000 0034     }
; 0000 0035     else if(address==22){
_0x13:
	LDD  R26,Y+1
	CPI  R26,LOW(0x16)
	BRNE _0x17
; 0000 0036     PORTD.7 = value;
	LD   R30,Y
	CPI  R30,0
	BRNE _0x18
	CBI  0x12,7
	RJMP _0x19
_0x18:
	SBI  0x12,7
_0x19:
; 0000 0037     return 1;
	LDI  R30,LOW(1)
	RJMP _0x2060009
; 0000 0038     }
; 0000 0039 return 0;
_0x17:
	LDI  R30,LOW(0)
	RJMP _0x2060009
; 0000 003A }
;
;unsigned char BUTTON_INPUT(unsigned char input){
; 0000 003C unsigned char BUTTON_INPUT(unsigned char input){
_BUTTON_INPUT:
; 0000 003D     if(input==0){   return PIND.1;  }
;	input -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x1A
	LDI  R30,0
	SBIC 0x10,1
	LDI  R30,1
	RJMP _0x206000F
; 0000 003E     if(input==1){   return PIND.0;  }
_0x1A:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x1B
	LDI  R30,0
	SBIC 0x10,0
	LDI  R30,1
	RJMP _0x206000F
; 0000 003F     if(input==2){   return PIND.2;  }
_0x1B:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x1C
	LDI  R30,0
	SBIC 0x10,2
	LDI  R30,1
	RJMP _0x206000F
; 0000 0040     if(input==3){   return PIND.3;  }
_0x1C:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x1D
	LDI  R30,0
	SBIC 0x10,3
	LDI  R30,1
	RJMP _0x206000F
; 0000 0041     if(input==4){   return PIND.6;  }
_0x1D:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x1E
	LDI  R30,0
	SBIC 0x10,6
	LDI  R30,1
	RJMP _0x206000F
; 0000 0042 return 0;
_0x1E:
	LDI  R30,LOW(0)
_0x206000F:
	ADIW R28,1
	RET
; 0000 0043 }
;
;// Real Time
;unsigned char RealTimeYear, RealTimeMonth, RealTimeDay, RealTimeHour, RealTimeMinute, RealTimeWeekDay, RealTimeSecond;
;eeprom unsigned char SUMMER_TIME_TURNED_ON;
;eeprom unsigned char IS_CLOCK_SUMMER;
;
;eeprom signed char RealTimePrecisioningValue;
;unsigned char IsRealTimePrecisioned;
;
;
;
;// Code
;eeprom unsigned int  CODE;
;eeprom unsigned char IS_LOCK_TURNED_ON;
;
;
;// Neveiklumo taimeriai
;unsigned int STAND_BY_TIMER;
;unsigned char MAIN_MENU_TIMER,LCD_LED_TIMER;
;
;
;
;// Skambuciai
;#define BELL_TYPE_COUNT 13
;#define BELL_COUNT 20
;eeprom unsigned char BELL_TIME[BELL_TYPE_COUNT][BELL_COUNT][3];
;/////////////////////////////////
;// TYPE 0:  Pirmadienio
;// TYPE 1:  Antradienio
;// TYPE 2:  Treciadienio
;// TYPE 3:  Ketvirtadienio
;// TYPE 4:  Penktadienio
;// TYPE 5:  Sestadienio
;// TYPE 6:  Sekmadienio
;
;// TYPE 7:  Velyku ketvirtadienio
;// TYPE 8:  Velyku penktadienio
;// TYPE 9: Velyku sestadienio
;// TYPE 10: Velyku sekmadienio
;
;// TYPE 11: Kaledu 1-os dienos
;// TYPE 12: Kaledu 2-os dienos
;/////////////////////////////////
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
;
;
;
;
;
;
;
;//-----------------------------------------------------------------------------------//
;//------------------------------------ Functions ------------------------------------//
;//-----------------------------------------------------------------------------------//
;unsigned char IsEasterToday(unsigned int year, unsigned char month, unsigned char day){
; 0000 0083 unsigned char IsEasterToday(unsigned int year, unsigned char month, unsigned char day){
_IsEasterToday:
; 0000 0084 unsigned int G, C, X, Z, D, E, F, N;
; 0000 0085 unsigned char EasterSunday, EasterSaturday, EasterFriday, EasterThursday;
; 0000 0086 
; 0000 0087 year += 2000;
	SBIW R28,14
	CALL __SAVELOCR6
;	year -> Y+22
;	month -> Y+21
;	day -> Y+20
;	G -> R16,R17
;	C -> R18,R19
;	X -> R20,R21
;	Z -> Y+18
;	D -> Y+16
;	E -> Y+14
;	F -> Y+12
;	N -> Y+10
;	EasterSunday -> Y+9
;	EasterSaturday -> Y+8
;	EasterFriday -> Y+7
;	EasterThursday -> Y+6
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0000 0088 
; 0000 0089 G = year-((year/19)*19)+1;
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0x0
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0x1
; 0000 008A C = (year/100)+1;
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0x2
; 0000 008B X = 3*C/4-12;
; 0000 008C Z = ((8*C+5)/25)-5;
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 008D D = 5*year/4-X-10;
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0x3
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 008E F = 11*G+20+Z-X;
	CALL SUBOPT_0x4
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0x5
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 008F E = F-((F/30)*30);
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x6
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+14,R26
	STD  Y+14+1,R27
; 0000 0090     if(((E==25)&&(G>11))||(E==24)){ E++;    }
	SBIW R26,25
	BRNE _0x20
	__CPWRN 16,17,12
	BRSH _0x22
_0x20:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,24
	BRNE _0x1F
_0x22:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 0091 N = 44-E;
_0x1F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x7
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0092     if(N<21){   N = N+30;   }
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,21
	BRSH _0x24
	ADIW R30,30
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0093 N = N+7-((D+N)-(((D+N)/7)*7));
_0x24:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,7
	PUSH R31
	PUSH R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL SUBOPT_0x8
	POP  R26
	POP  R27
	CALL SUBOPT_0x9
; 0000 0094 
; 0000 0095 EasterSunday = N;
	LDD  R30,Y+10
	STD  Y+9,R30
; 0000 0096 EasterSaturday = N - 1;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,1
	STD  Y+8,R30
; 0000 0097 EasterFriday = N - 2;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,2
	STD  Y+7,R30
; 0000 0098 EasterThursday = N - 3;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,3
	STD  Y+6,R30
; 0000 0099 
; 0000 009A // Velyku ketvirtadienis
; 0000 009B     if(EasterThursday>31){
	LDD  R26,Y+6
	CPI  R26,LOW(0x20)
	BRLO _0x25
; 0000 009C     EasterThursday = EasterThursday - 31;
	CALL SUBOPT_0xA
	SBIW R30,31
	STD  Y+6,R30
; 0000 009D     // Balandzio N-oji diena
; 0000 009E         if(month==4){
	LDD  R26,Y+21
	CPI  R26,LOW(0x4)
	BRNE _0x26
; 0000 009F             if(day==EasterThursday){
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x27
; 0000 00A0             return 4;
	LDI  R30,LOW(4)
	RJMP _0x206000E
; 0000 00A1             }
; 0000 00A2         }
_0x27:
; 0000 00A3     }
_0x26:
; 0000 00A4     else{
	RJMP _0x28
_0x25:
; 0000 00A5     // Kovo N-oji diena
; 0000 00A6         if(month==3){
	LDD  R26,Y+21
	CPI  R26,LOW(0x3)
	BRNE _0x29
; 0000 00A7             if(day==EasterThursday){
	LDD  R30,Y+6
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x2A
; 0000 00A8             return 4;
	LDI  R30,LOW(4)
	RJMP _0x206000E
; 0000 00A9             }
; 0000 00AA         }
_0x2A:
; 0000 00AB     }
_0x29:
_0x28:
; 0000 00AC 
; 0000 00AD // Velyku penktadienis
; 0000 00AE     if(EasterFriday>31){
	LDD  R26,Y+7
	CPI  R26,LOW(0x20)
	BRLO _0x2B
; 0000 00AF     EasterFriday = EasterFriday - 31;
	LDD  R30,Y+7
	CALL SUBOPT_0xB
	STD  Y+7,R30
; 0000 00B0     // Balandzio N-oji diena
; 0000 00B1         if(month==4){
	LDD  R26,Y+21
	CPI  R26,LOW(0x4)
	BRNE _0x2C
; 0000 00B2             if(day==EasterFriday){
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x2D
; 0000 00B3             return 5;
	LDI  R30,LOW(5)
	RJMP _0x206000E
; 0000 00B4             }
; 0000 00B5         }
_0x2D:
; 0000 00B6     }
_0x2C:
; 0000 00B7     else{
	RJMP _0x2E
_0x2B:
; 0000 00B8     // Kovo N-oji diena
; 0000 00B9         if(month==3){
	LDD  R26,Y+21
	CPI  R26,LOW(0x3)
	BRNE _0x2F
; 0000 00BA             if(day==EasterFriday){
	LDD  R30,Y+7
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x30
; 0000 00BB             return 5;
	LDI  R30,LOW(5)
	RJMP _0x206000E
; 0000 00BC             }
; 0000 00BD         }
_0x30:
; 0000 00BE     }
_0x2F:
_0x2E:
; 0000 00BF 
; 0000 00C0 // Velyku sestadienis
; 0000 00C1     if(EasterSaturday>31){
	LDD  R26,Y+8
	CPI  R26,LOW(0x20)
	BRLO _0x31
; 0000 00C2     EasterSaturday = EasterSaturday - 31;
	LDD  R30,Y+8
	CALL SUBOPT_0xB
	STD  Y+8,R30
; 0000 00C3     // Balandzio N-oji diena
; 0000 00C4         if(month==4){
	LDD  R26,Y+21
	CPI  R26,LOW(0x4)
	BRNE _0x32
; 0000 00C5             if(day==EasterSaturday){
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x33
; 0000 00C6             return 6;
	LDI  R30,LOW(6)
	RJMP _0x206000E
; 0000 00C7             }
; 0000 00C8         }
_0x33:
; 0000 00C9     }
_0x32:
; 0000 00CA     else{
	RJMP _0x34
_0x31:
; 0000 00CB     // Kovo N-oji diena
; 0000 00CC         if(month==3){
	LDD  R26,Y+21
	CPI  R26,LOW(0x3)
	BRNE _0x35
; 0000 00CD             if(day==EasterSaturday){
	LDD  R30,Y+8
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x36
; 0000 00CE             return 6;
	LDI  R30,LOW(6)
	RJMP _0x206000E
; 0000 00CF             }
; 0000 00D0         }
_0x36:
; 0000 00D1     }
_0x35:
_0x34:
; 0000 00D2 
; 0000 00D3 // Velyku sekmadienis
; 0000 00D4     if(EasterSunday>31){
	LDD  R26,Y+9
	CPI  R26,LOW(0x20)
	BRLO _0x37
; 0000 00D5     EasterSunday = EasterSunday - 31;
	LDD  R30,Y+9
	CALL SUBOPT_0xB
	STD  Y+9,R30
; 0000 00D6     // Balandzio N-oji diena
; 0000 00D7         if(month==4){
	LDD  R26,Y+21
	CPI  R26,LOW(0x4)
	BRNE _0x38
; 0000 00D8             if(day==EasterSunday){
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x39
; 0000 00D9             return 7;
	LDI  R30,LOW(7)
	RJMP _0x206000E
; 0000 00DA             }
; 0000 00DB         }
_0x39:
; 0000 00DC     }
_0x38:
; 0000 00DD     else{
	RJMP _0x3A
_0x37:
; 0000 00DE     // Kovo N-oji diena
; 0000 00DF         if(month==3){
	LDD  R26,Y+21
	CPI  R26,LOW(0x3)
	BRNE _0x3B
; 0000 00E0             if(day==EasterSunday){
	LDD  R30,Y+9
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x3C
; 0000 00E1             return 7;
	LDI  R30,LOW(7)
	RJMP _0x206000E
; 0000 00E2             }
; 0000 00E3         }
_0x3C:
; 0000 00E4     }
_0x3B:
_0x3A:
; 0000 00E5 
; 0000 00E6 return 0;
	LDI  R30,LOW(0)
_0x206000E:
	CALL __LOADLOCR6
	ADIW R28,24
	RET
; 0000 00E7 }
;
;unsigned char IsChristmasToday(unsigned int year, unsigned char month, unsigned char day){
; 0000 00E9 unsigned char IsChristmasToday(unsigned int year, unsigned char month, unsigned char day){
_IsChristmasToday:
; 0000 00EA //Gruodzio 25 - 26
; 0000 00EB 
; 0000 00EC year += 2000;
;	year -> Y+2
;	month -> Y+1
;	day -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00ED 
; 0000 00EE     if(year!=0){
	SBIW R30,0
	BREQ _0x3D
; 0000 00EF         if(month==12){
	LDD  R26,Y+1
	CPI  R26,LOW(0xC)
	BRNE _0x3E
; 0000 00F0             if(day==25){
	LD   R26,Y
	CPI  R26,LOW(0x19)
	BRNE _0x3F
; 0000 00F1             return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000D
; 0000 00F2             }
; 0000 00F3             else if(day==26){
_0x3F:
	LD   R26,Y
	CPI  R26,LOW(0x1A)
	BRNE _0x41
; 0000 00F4             return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000D
; 0000 00F5             }
; 0000 00F6         }
_0x41:
; 0000 00F7     }
_0x3E:
; 0000 00F8 return 0;
_0x3D:
	LDI  R30,LOW(0)
_0x206000D:
	ADIW R28,4
	RET
; 0000 00F9 }
;
;unsigned char GetEasterMonth(unsigned int year){
; 0000 00FB unsigned char GetEasterMonth(unsigned int year){
_GetEasterMonth:
; 0000 00FC unsigned int G, C, X, Z, D, E, F, N;
; 0000 00FD 
; 0000 00FE year += 2000;
	CALL SUBOPT_0xC
;	year -> Y+16
;	G -> R16,R17
;	C -> R18,R19
;	X -> R20,R21
;	Z -> Y+14
;	D -> Y+12
;	E -> Y+10
;	F -> Y+8
;	N -> Y+6
; 0000 00FF 
; 0000 0100 G = year-((year/19)*19)+1;
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x1
; 0000 0101 C = (year/100)+1;
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x2
; 0000 0102 X = 3*C/4-12;
; 0000 0103 Z = ((8*C+5)/25)-5;
	CALL SUBOPT_0xD
; 0000 0104 D = 5*year/4-X-10;
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0105 F = 11*G+20+Z-X;
	CALL SUBOPT_0x4
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x5
	CALL SUBOPT_0xE
; 0000 0106 E = F-((F/30)*30);
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x9
; 0000 0107     if(((E==25)&&(G>11))||(E==24)){ E++;    }
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,25
	BRNE _0x43
	__CPWRN 16,17,12
	BRSH _0x45
_0x43:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,24
	BRNE _0x42
_0x45:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0108 N = 44-E;
_0x42:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x7
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0109     if(N<21){   N = N+30;   }
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,21
	BRSH _0x47
	ADIW R30,30
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 010A N = N+7-((D+N)-(((D+N)/7)*7));
_0x47:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,7
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xF
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0xF
	CALL SUBOPT_0x8
	POP  R26
	POP  R27
	CALL SUBOPT_0x10
; 0000 010B 
; 0000 010C     if(N>31){
	BRLO _0x48
; 0000 010D     return 4;
	LDI  R30,LOW(4)
	RJMP _0x206000C
; 0000 010E     }
; 0000 010F     else{
_0x48:
; 0000 0110     return 3;
	LDI  R30,LOW(3)
	RJMP _0x206000C
; 0000 0111     }
; 0000 0112 }
;
;unsigned char GetEasterDay(unsigned int year){
; 0000 0114 unsigned char GetEasterDay(unsigned int year){
_GetEasterDay:
; 0000 0115 unsigned int G, C, X, Z, D, E, F, N;
; 0000 0116 
; 0000 0117 year += 2000;
	CALL SUBOPT_0xC
;	year -> Y+16
;	G -> R16,R17
;	C -> R18,R19
;	X -> R20,R21
;	Z -> Y+14
;	D -> Y+12
;	E -> Y+10
;	F -> Y+8
;	N -> Y+6
; 0000 0118 
; 0000 0119 G = year-((year/19)*19)+1;
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x1
; 0000 011A C = (year/100)+1;
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x2
; 0000 011B X = 3*C/4-12;
; 0000 011C Z = ((8*C+5)/25)-5;
	CALL SUBOPT_0xD
; 0000 011D D = 5*year/4-X-10;
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 011E F = 11*G+20+Z-X;
	CALL SUBOPT_0x4
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x5
	CALL SUBOPT_0xE
; 0000 011F E = F-((F/30)*30);
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x9
; 0000 0120     if(((E==25)&&(G>11))||(E==24)){ E++;    }
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,25
	BRNE _0x4B
	__CPWRN 16,17,12
	BRSH _0x4D
_0x4B:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,24
	BRNE _0x4A
_0x4D:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0121 N = 44-E;
_0x4A:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x7
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0122     if(N<21){   N = N+30;   }
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,21
	BRSH _0x4F
	ADIW R30,30
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0123 N = N+7-((D+N)-(((D+N)/7)*7));
_0x4F:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,7
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xF
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0xF
	CALL SUBOPT_0x8
	POP  R26
	POP  R27
	CALL SUBOPT_0x10
; 0000 0124 
; 0000 0125     if(N>31){
	BRLO _0x50
; 0000 0126     return N - 31;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,31
	RJMP _0x206000C
; 0000 0127     }
; 0000 0128     else{
_0x50:
; 0000 0129     return N;
	LDD  R30,Y+6
; 0000 012A     }
; 0000 012B }
_0x206000C:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
;
;unsigned char DayCountInMonth(unsigned int year, char month){
; 0000 012D unsigned char DayCountInMonth(unsigned int year, char month){
_DayCountInMonth:
; 0000 012E year += 2000;
;	year -> Y+1
;	month -> Y+0
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 012F 
; 0000 0130     if((month==1)||(month==3)||(month==5)||(month==7)||(month==8)||(month==10)||(month==12)){return 31;}
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BREQ _0x53
	CPI  R26,LOW(0x3)
	BREQ _0x53
	CPI  R26,LOW(0x5)
	BREQ _0x53
	CPI  R26,LOW(0x7)
	BREQ _0x53
	CPI  R26,LOW(0x8)
	BREQ _0x53
	CPI  R26,LOW(0xA)
	BREQ _0x53
	CPI  R26,LOW(0xC)
	BRNE _0x52
_0x53:
	LDI  R30,LOW(31)
	RJMP _0x206000A
; 0000 0131     else if((month==4)||(month==6)||(month==9)||(month==11)){return 30;}
_0x52:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BREQ _0x57
	CPI  R26,LOW(0x6)
	BREQ _0x57
	CPI  R26,LOW(0x9)
	BREQ _0x57
	CPI  R26,LOW(0xB)
	BRNE _0x56
_0x57:
	LDI  R30,LOW(30)
	RJMP _0x206000A
; 0000 0132     else if(month==2){
_0x56:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x5A
; 0000 0133     unsigned int a;
; 0000 0134     a = year/4;
	SBIW R28,2
;	year -> Y+3
;	month -> Y+2
;	a -> Y+0
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	CALL __LSRW2
	ST   Y,R30
	STD  Y+1,R31
; 0000 0135     a = a*4;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(4)
	CALL __MULB1W2U
	ST   Y,R30
	STD  Y+1,R31
; 0000 0136         if(a==year){
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x5B
; 0000 0137         return 29;
	LDI  R30,LOW(29)
	ADIW R28,2
	RJMP _0x206000A
; 0000 0138         }
; 0000 0139         else{
_0x5B:
; 0000 013A         return 28;
	LDI  R30,LOW(28)
	ADIW R28,2
	RJMP _0x206000A
; 0000 013B         }
; 0000 013C     }
; 0000 013D     else{
_0x5A:
; 0000 013E     return 0;
	RJMP _0x206000B
; 0000 013F     }
; 0000 0140 }
;
;unsigned char IsSummerTime(unsigned char month, unsigned char day, unsigned char weekday){
; 0000 0142 unsigned char IsSummerTime(unsigned char month, unsigned char day, unsigned char weekday){
_IsSummerTime:
; 0000 0143     if(month==3){
;	month -> Y+2
;	day -> Y+1
;	weekday -> Y+0
	LDD  R26,Y+2
	CPI  R26,LOW(0x3)
	BRNE _0x5E
; 0000 0144         if(day==25){
	LDD  R26,Y+1
	CPI  R26,LOW(0x19)
	BRNE _0x5F
; 0000 0145             if(weekday==7){
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x60
; 0000 0146             return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000A
; 0000 0147             }
; 0000 0148         }
_0x60:
; 0000 0149         else if(day>25){
	RJMP _0x61
_0x5F:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1A)
	BRLO _0x62
; 0000 014A             if(day+(7-weekday)>31){
	CALL SUBOPT_0x11
	BRLT _0x63
; 0000 014B             return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000A
; 0000 014C             }
; 0000 014D             else{
_0x63:
; 0000 014E                 if(weekday==7){
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x65
; 0000 014F                 return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000A
; 0000 0150                 }
; 0000 0151             }
_0x65:
; 0000 0152 
; 0000 0153         }
; 0000 0154     }
_0x62:
_0x61:
; 0000 0155     else if((month>3)&&(month<10)){
	RJMP _0x66
_0x5E:
	LDD  R26,Y+2
	CPI  R26,LOW(0x4)
	BRLO _0x68
	CPI  R26,LOW(0xA)
	BRLO _0x69
_0x68:
	RJMP _0x67
_0x69:
; 0000 0156     return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000A
; 0000 0157     }
; 0000 0158     else if(month==10){
_0x67:
	LDD  R26,Y+2
	CPI  R26,LOW(0xA)
	BRNE _0x6B
; 0000 0159         if(day==25){
	LDD  R26,Y+1
	CPI  R26,LOW(0x19)
	BRNE _0x6C
; 0000 015A             if(weekday==7){
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BREQ _0x206000B
; 0000 015B             return 0;
; 0000 015C             }
; 0000 015D         }
; 0000 015E         else if(day>25){
	RJMP _0x6E
_0x6C:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1A)
	BRLO _0x6F
; 0000 015F             if(day+(7-weekday)>31){
	CALL SUBOPT_0x11
	BRGE _0x206000B
; 0000 0160             return 0;
; 0000 0161             }
; 0000 0162             else{
; 0000 0163                 if(weekday==7){
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BREQ _0x206000B
; 0000 0164                 return 0;
; 0000 0165                 }
; 0000 0166             }
; 0000 0167         }
; 0000 0168     return 1;
_0x6F:
_0x6E:
	LDI  R30,LOW(1)
	RJMP _0x206000A
; 0000 0169     }
; 0000 016A return 0;
_0x6B:
_0x66:
_0x206000B:
	LDI  R30,LOW(0)
_0x206000A:
	ADIW R28,3
	RET
; 0000 016B }
;
;unsigned char GetFreeBellId(unsigned char bell_type){
; 0000 016D unsigned char GetFreeBellId(unsigned char bell_type){
_GetFreeBellId:
; 0000 016E unsigned char i;
; 0000 016F     for(i=0;i<BELL_COUNT;i++){
	ST   -Y,R17
;	bell_type -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x74:
	CPI  R17,20
	BRSH _0x75
; 0000 0170     unsigned char checking_time[3];
; 0000 0171     checking_time[0] = BELL_TIME[bell_type][i][0];
	SBIW R28,3
;	bell_type -> Y+4
;	checking_time -> Y+0
	CALL SUBOPT_0x12
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDB
	ST   Y,R30
; 0000 0172     checking_time[1] = BELL_TIME[bell_type][i][1];
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 0173     checking_time[2] = BELL_TIME[bell_type][i][2];
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
; 0000 0174         if(checking_time[2]>0){
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRLO _0x76
; 0000 0175             if(checking_time[0]<24){
	LD   R26,Y
	CPI  R26,LOW(0x18)
	BRSH _0x77
; 0000 0176                 if(checking_time[1]>=60){
	LDD  R26,Y+1
	CPI  R26,LOW(0x3C)
	BRLO _0x78
; 0000 0177                 BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
; 0000 0178                 BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x16
; 0000 0179                 BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x17
; 0000 017A                 return i;
	RJMP _0x2060009
; 0000 017B                 break;
; 0000 017C                 }
; 0000 017D             }
_0x78:
; 0000 017E             else{
	RJMP _0x79
_0x77:
; 0000 017F             BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
; 0000 0180             BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x16
; 0000 0181             BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x17
; 0000 0182             return i;
	RJMP _0x2060009
; 0000 0183             break;
; 0000 0184             }
_0x79:
; 0000 0185         }
; 0000 0186         else{
	RJMP _0x7A
_0x76:
; 0000 0187         BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
; 0000 0188         BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x16
; 0000 0189         BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x17
; 0000 018A         return i;
	RJMP _0x2060009
; 0000 018B         break;
; 0000 018C         }
_0x7A:
; 0000 018D     }
	ADIW R28,3
	SUBI R17,-1
	RJMP _0x74
_0x75:
; 0000 018E return 255;
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2060009
; 0000 018F }
;
;unsigned char GetBellId(unsigned char bell_type, unsigned char row){
; 0000 0191 unsigned char GetBellId(unsigned char bell_type, unsigned char row){
_GetBellId:
; 0000 0192     if(bell_type<BELL_TYPE_COUNT){
;	bell_type -> Y+1
;	row -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0xD)
	BRLO PC+3
	JMP _0x7B
; 0000 0193         if(row<BELL_COUNT){
	LD   R26,Y
	CPI  R26,LOW(0x14)
	BRLO PC+3
	JMP _0x7C
; 0000 0194         unsigned char k, i, BELL_ID;
; 0000 0195         unsigned char time[3];
; 0000 0196         time[0] = 0;
	SBIW R28,6
;	bell_type -> Y+7
;	row -> Y+6
;	k -> Y+5
;	i -> Y+4
;	BELL_ID -> Y+3
;	time -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0197         time[1] = 0;
	STD  Y+1,R30
; 0000 0198         time[2] = 0;
	STD  Y+2,R30
; 0000 0199 
; 0000 019A             for(k=0;k<=row;k++){
	STD  Y+5,R30
_0x7E:
	LDD  R30,Y+6
	LDD  R26,Y+5
	CP   R30,R26
	BRSH PC+3
	JMP _0x7F
; 0000 019B             unsigned char current_time[3], set_value;
; 0000 019C             current_time[0] = 255;
	SBIW R28,4
;	bell_type -> Y+11
;	row -> Y+10
;	k -> Y+9
;	i -> Y+8
;	BELL_ID -> Y+7
;	time -> Y+4
;	current_time -> Y+1
;	set_value -> Y+0
	LDI  R30,LOW(255)
	STD  Y+1,R30
; 0000 019D             current_time[1] = 255;
	STD  Y+2,R30
; 0000 019E             current_time[2] = 255;
	STD  Y+3,R30
; 0000 019F             BELL_ID = 255;
	STD  Y+7,R30
; 0000 01A0 
; 0000 01A1                 for(i=0;i<BELL_COUNT;i++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
_0x81:
	LDD  R26,Y+8
	CPI  R26,LOW(0x14)
	BRLO PC+3
	JMP _0x82
; 0000 01A2                 unsigned char checking_time[3];
; 0000 01A3                 checking_time[0] = BELL_TIME[bell_type][i][0];
	SBIW R28,3
;	bell_type -> Y+14
;	row -> Y+13
;	k -> Y+12
;	i -> Y+11
;	BELL_ID -> Y+10
;	time -> Y+7
;	current_time -> Y+4
;	set_value -> Y+3
;	checking_time -> Y+0
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	ST   Y,R30
; 0000 01A4                 checking_time[1] = BELL_TIME[bell_type][i][1];
	CALL SUBOPT_0x18
	CALL SUBOPT_0x13
; 0000 01A5                 checking_time[2] = BELL_TIME[bell_type][i][2];
	CALL SUBOPT_0x18
	CALL SUBOPT_0x14
; 0000 01A6                     if(checking_time[0]<24){
	LD   R26,Y
	CPI  R26,LOW(0x18)
	BRLO PC+3
	JMP _0x83
; 0000 01A7                         if(checking_time[1]<60){
	LDD  R26,Y+1
	CPI  R26,LOW(0x3C)
	BRLO PC+3
	JMP _0x84
; 0000 01A8                             if(checking_time[2]>0){
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRLO _0x85
; 0000 01A9                                 if(checking_time[0]>time[0]){
	LDD  R30,Y+7
	LD   R26,Y
	CP   R30,R26
	BRSH _0x86
; 0000 01AA                                     if(checking_time[0]<current_time[0]){
	LDD  R30,Y+4
	CP   R26,R30
	BRLO _0x4AD
; 0000 01AB                                     current_time[0] = checking_time[0];
; 0000 01AC                                     current_time[1] = checking_time[1];
; 0000 01AD                                     current_time[2] = checking_time[2];
; 0000 01AE                                     set_value = 1;
; 0000 01AF                                     BELL_ID = i;
; 0000 01B0                                     }
; 0000 01B1                                     else if(checking_time[0]==current_time[0]){
	CP   R30,R26
	BRNE _0x89
; 0000 01B2                                         if(checking_time[1]<current_time[1]){
	LDD  R30,Y+5
	LDD  R26,Y+1
	CP   R26,R30
	BRSH _0x8A
; 0000 01B3                                         current_time[0] = checking_time[0];
_0x4AD:
	LD   R30,Y
	CALL SUBOPT_0x1A
; 0000 01B4                                         current_time[1] = checking_time[1];
; 0000 01B5                                         current_time[2] = checking_time[2];
; 0000 01B6                                         set_value = 1;
; 0000 01B7                                         BELL_ID = i;
; 0000 01B8                                         }
; 0000 01B9                                     }
_0x8A:
; 0000 01BA                                 }
_0x89:
; 0000 01BB                                 else if(checking_time[0]==time[0]){
	RJMP _0x8B
_0x86:
	LDD  R30,Y+7
	LD   R26,Y
	CP   R30,R26
	BRNE _0x8C
; 0000 01BC                                     if(checking_time[1]>time[1]){
	LDD  R30,Y+8
	LDD  R26,Y+1
	CP   R30,R26
	BRSH _0x8D
; 0000 01BD                                         if(checking_time[0]<current_time[0]){
	LDD  R30,Y+4
	LD   R26,Y
	CP   R26,R30
	BRSH _0x8E
; 0000 01BE                                         current_time[0] = checking_time[0];
	LD   R30,Y
	CALL SUBOPT_0x1A
; 0000 01BF                                         current_time[1] = checking_time[1];
; 0000 01C0                                         current_time[2] = checking_time[2];
; 0000 01C1                                         set_value = 1;
; 0000 01C2                                         BELL_ID = i;
; 0000 01C3                                         }
; 0000 01C4                                         else if(checking_time[0]==current_time[0]){
	RJMP _0x8F
_0x8E:
	LDD  R30,Y+4
	LD   R26,Y
	CP   R30,R26
	BRNE _0x90
; 0000 01C5                                             if(checking_time[1]<current_time[1]){
	LDD  R30,Y+5
	LDD  R26,Y+1
	CP   R26,R30
	BRSH _0x91
; 0000 01C6                                             current_time[0] = checking_time[0];
	LD   R30,Y
	CALL SUBOPT_0x1A
; 0000 01C7                                             current_time[1] = checking_time[1];
; 0000 01C8                                             current_time[2] = checking_time[2];
; 0000 01C9                                             set_value = 1;
; 0000 01CA                                             BELL_ID = i;
; 0000 01CB                                             }
; 0000 01CC                                             else if(checking_time[1]==current_time[1]){
	RJMP _0x92
_0x91:
	LDD  R30,Y+5
	LDD  R26,Y+1
	CP   R30,R26
	BRNE _0x93
; 0000 01CD                                             BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
; 0000 01CE                                             BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x1C
; 0000 01CF                                             BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x1D
; 0000 01D0                                             }
; 0000 01D1                                         }
_0x93:
_0x92:
; 0000 01D2                                     }
_0x90:
_0x8F:
; 0000 01D3                                 }
_0x8D:
; 0000 01D4                             }
_0x8C:
_0x8B:
; 0000 01D5                             else{
	RJMP _0x94
_0x85:
; 0000 01D6                             BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
; 0000 01D7                             BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x1C
; 0000 01D8                             BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x1D
; 0000 01D9                             }
_0x94:
; 0000 01DA                         }
; 0000 01DB                         else{
	RJMP _0x95
_0x84:
; 0000 01DC                         BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
; 0000 01DD                         BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x1C
; 0000 01DE                         BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x1D
; 0000 01DF                         }
_0x95:
; 0000 01E0                     }
; 0000 01E1                     else{
	RJMP _0x96
_0x83:
; 0000 01E2                     BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
; 0000 01E3                     BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x1C
; 0000 01E4                     BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x1D
; 0000 01E5                     }
_0x96:
; 0000 01E6                 }
	ADIW R28,3
	LDD  R30,Y+8
	SUBI R30,-LOW(1)
	STD  Y+8,R30
	RJMP _0x81
_0x82:
; 0000 01E7 
; 0000 01E8                 if(set_value==1){
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x97
; 0000 01E9                 time[0] = current_time[0];
	LDD  R30,Y+1
	STD  Y+4,R30
; 0000 01EA                 time[1] = current_time[1];
	LDD  R30,Y+2
	STD  Y+5,R30
; 0000 01EB                 time[2] = current_time[2];
	LDD  R30,Y+3
	STD  Y+6,R30
; 0000 01EC                 }
; 0000 01ED             }
_0x97:
	ADIW R28,4
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x7E
_0x7F:
; 0000 01EE         return BELL_ID;
	LDD  R30,Y+3
	ADIW R28,6
	RJMP _0x2060009
; 0000 01EF         }
; 0000 01F0     return 255;
_0x7C:
; 0000 01F1     }
; 0000 01F2 return 255;
_0x7B:
_0x2060008:
	LDI  R30,LOW(255)
_0x2060009:
	ADIW R28,2
	RET
; 0000 01F3 }
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
; 0000 0210 #endasm
;#include <lcd.h>
;
;// Ekrano apsvietimas
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 0214 interrupt [12] void timer0_ovf_isr(void){
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0215 lcd_light_osc += 1;
	LDS  R30,_lcd_light_osc_G000
	SUBI R30,-LOW(1)
	STS  _lcd_light_osc_G000,R30
; 0000 0216     if(lcd_light_osc>=100){
	LDS  R26,_lcd_light_osc_G000
	CPI  R26,LOW(0x64)
	BRLO _0x98
; 0000 0217     lcd_light_osc = 0;
	LDI  R30,LOW(0)
	STS  _lcd_light_osc_G000,R30
; 0000 0218     }
; 0000 0219 
; 0000 021A     if(lcd_light_now>lcd_light_osc){
_0x98:
	LDS  R30,_lcd_light_osc_G000
	LDS  R26,_lcd_light_now_G000
	CP   R30,R26
	BRSH _0x99
; 0000 021B     LCD_LED = 1;
	SBI  0x1B,7
; 0000 021C     }
; 0000 021D     else{
	RJMP _0x9C
_0x99:
; 0000 021E     LCD_LED = 0;
	CBI  0x1B,7
; 0000 021F     }
_0x9C:
; 0000 0220 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;char SelectAnotherRow(char up_down){
; 0000 0222 char SelectAnotherRow(char up_down){
_SelectAnotherRow:
; 0000 0223 // 0 - down
; 0000 0224 // 1 - up
; 0000 0225     if(up_down==0){
;	up_down -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x9F
; 0000 0226         if(SelectedRow<RowsOnWindow-1){
	LDS  R30,_RowsOnWindow_G000
	CALL SUBOPT_0x1E
	LDS  R26,_SelectedRow_G000
	CALL SUBOPT_0x1F
	BRGE _0xA0
; 0000 0227         SelectedRow++;
	LDS  R30,_SelectedRow_G000
	SUBI R30,-LOW(1)
	STS  _SelectedRow_G000,R30
; 0000 0228             if(Address[5]+3<SelectedRow){
	CALL SUBOPT_0x20
	ADIW R30,3
	MOVW R26,R30
	LDS  R30,_SelectedRow_G000
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0xA1
; 0000 0229             Address[5] = SelectedRow - 3;
	LDS  R30,_SelectedRow_G000
	LDI  R31,0
	SBIW R30,3
	__PUTB1MN _Address_G000,5
; 0000 022A             }
; 0000 022B         return 1;
_0xA1:
	LDI  R30,LOW(1)
	RJMP _0x2060006
; 0000 022C         }
; 0000 022D     }
_0xA0:
; 0000 022E     else{
	RJMP _0xA2
_0x9F:
; 0000 022F         if(SelectedRow>0){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRLO _0xA3
; 0000 0230         SelectedRow--;
	LDS  R30,_SelectedRow_G000
	SUBI R30,LOW(1)
	STS  _SelectedRow_G000,R30
; 0000 0231             if(Address[5]>SelectedRow){
	__GETB2MN _Address_G000,5
	CP   R30,R26
	BRSH _0xA4
; 0000 0232             Address[5] = SelectedRow;
	__PUTB1MN _Address_G000,5
; 0000 0233             }
; 0000 0234         return 1;
_0xA4:
	LDI  R30,LOW(1)
	RJMP _0x2060006
; 0000 0235         }
; 0000 0236     }
_0xA3:
_0xA2:
; 0000 0237 return 0;
	RJMP _0x2060007
; 0000 0238 }
;
;char NumToIndex(char Num){
; 0000 023A char NumToIndex(char Num){
_NumToIndex:
; 0000 023B     if(Num==0){     return '0';}
;	Num -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0xA5
	LDI  R30,LOW(48)
	RJMP _0x2060006
; 0000 023C     else if(Num==1){return '1';}
_0xA5:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0xA7
	LDI  R30,LOW(49)
	RJMP _0x2060006
; 0000 023D     else if(Num==2){return '2';}
_0xA7:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0xA9
	LDI  R30,LOW(50)
	RJMP _0x2060006
; 0000 023E     else if(Num==3){return '3';}
_0xA9:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0xAB
	LDI  R30,LOW(51)
	RJMP _0x2060006
; 0000 023F     else if(Num==4){return '4';}
_0xAB:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xAD
	LDI  R30,LOW(52)
	RJMP _0x2060006
; 0000 0240     else if(Num==5){return '5';}
_0xAD:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0xAF
	LDI  R30,LOW(53)
	RJMP _0x2060006
; 0000 0241     else if(Num==6){return '6';}
_0xAF:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0xB1
	LDI  R30,LOW(54)
	RJMP _0x2060006
; 0000 0242     else if(Num==7){return '7';}
_0xB1:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0xB3
	LDI  R30,LOW(55)
	RJMP _0x2060006
; 0000 0243     else if(Num==8){return '8';}
_0xB3:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0xB5
	LDI  R30,LOW(56)
	RJMP _0x2060006
; 0000 0244     else if(Num==9){return '9';}
_0xB5:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0xB7
	LDI  R30,LOW(57)
	RJMP _0x2060006
; 0000 0245     else{           return '-';}
_0xB7:
	LDI  R30,LOW(45)
	RJMP _0x2060006
; 0000 0246 return 0;
_0x2060007:
	LDI  R30,LOW(0)
_0x2060006:
	ADIW R28,1
	RET
; 0000 0247 }
;
;char lcd_put_number(char Type, char Lenght, char IsSign,
; 0000 024A 
; 0000 024B                     char NumbersAfterDot,
; 0000 024C 
; 0000 024D                     unsigned long int Number0,
; 0000 024E                     signed long int Number1){
_lcd_put_number:
; 0000 024F     if(Lenght>0){
;	Type -> Y+11
;	Lenght -> Y+10
;	IsSign -> Y+9
;	NumbersAfterDot -> Y+8
;	Number0 -> Y+4
;	Number1 -> Y+0
	LDD  R26,Y+10
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0xB9
; 0000 0250     unsigned long int k = 1;
; 0000 0251     unsigned char i;
; 0000 0252         for(i=0;i<Lenght-1;i++) k = k*10;
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
_0xBB:
	LDD  R30,Y+15
	CALL SUBOPT_0x1E
	LD   R26,Y
	CALL SUBOPT_0x1F
	BRGE _0xBC
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xBB
_0xBC:
; 0000 0254 if(Type==0){
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0xBD
; 0000 0255         unsigned long int a;
; 0000 0256         unsigned char b;
; 0000 0257         a = Number0;
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
	CALL SUBOPT_0x23
; 0000 0258 
; 0000 0259             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0xBE
; 0000 025A             lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 025B             }
; 0000 025C 
; 0000 025D             if(a<0){
_0xBE:
	CALL SUBOPT_0x24
; 0000 025E             a = a*(-1);
; 0000 025F             }
; 0000 0260 
; 0000 0261             if(k*10<a){
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	BRSH _0xC0
; 0000 0262             a = k*10 - 1;
	CALL SUBOPT_0x25
	CALL SUBOPT_0x27
; 0000 0263             }
; 0000 0264 
; 0000 0265             for(i=0;i<Lenght;i++){
_0xC0:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0xC2:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0xC3
; 0000 0266                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0xC4
; 0000 0267                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0x28
	BRNE _0xC5
; 0000 0268                     lcd_putchar('.');
	CALL SUBOPT_0x29
; 0000 0269                     }
; 0000 026A                 }
_0xC5:
; 0000 026B             b = a/k;
_0xC4:
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
; 0000 026C             lcd_putchar( NumToIndex( b ) );
; 0000 026D             a = a - b*k;
; 0000 026E             k = k/10;
; 0000 026F             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0xC2
_0xC3:
; 0000 0270         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2060005
; 0000 0271         }
; 0000 0272 
; 0000 0273         else if(Type==1){
_0xBD:
	LDD  R26,Y+16
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0xC7
; 0000 0274         signed long int a;
; 0000 0275         unsigned char b;
; 0000 0276         a = Number1;
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
	CALL SUBOPT_0x23
; 0000 0277 
; 0000 0278             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0xC8
; 0000 0279                 if(a>=0){
	LDD  R26,Y+4
	TST  R26
	BRMI _0xC9
; 0000 027A                 lcd_putchar('+');
	LDI  R30,LOW(43)
	RJMP _0x4AE
; 0000 027B                 }
; 0000 027C                 else{
_0xC9:
; 0000 027D                 lcd_putchar('-');
	LDI  R30,LOW(45)
_0x4AE:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 027E                 }
; 0000 027F             }
; 0000 0280 
; 0000 0281             if(a<0){
_0xC8:
	LDD  R26,Y+4
	TST  R26
	BRPL _0xCB
; 0000 0282             a = a*(-1);
	CALL SUBOPT_0x21
	__GETD2N 0xFFFFFFFF
	CALL __MULD12
	CALL SUBOPT_0x23
; 0000 0283             }
; 0000 0284 
; 0000 0285             if(k*10<a){
_0xCB:
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	BRSH _0xCC
; 0000 0286             a = k*10 - 1;
	CALL SUBOPT_0x25
	CALL SUBOPT_0x27
; 0000 0287             }
; 0000 0288 
; 0000 0289             for(i=0;i<Lenght;i++){
_0xCC:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0xCE:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0xCF
; 0000 028A                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0xD0
; 0000 028B                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0x28
	BRNE _0xD1
; 0000 028C                     lcd_putchar('.');
	CALL SUBOPT_0x29
; 0000 028D                     }
; 0000 028E                 }
_0xD1:
; 0000 028F             b = a/k;
_0xD0:
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
; 0000 0290             lcd_putchar( NumToIndex( b ) );
; 0000 0291             a = a - b*k;
; 0000 0292             k = k/10;
; 0000 0293             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0xCE
_0xCF:
; 0000 0294         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2060005
; 0000 0295         }
; 0000 0296     }
_0xC7:
	ADIW R28,5
; 0000 0297 return 0;
_0xB9:
	LDI  R30,LOW(0)
_0x2060005:
	ADIW R28,12
	RET
; 0000 0298 }
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
; 0000 02A8 void main(void){
_main:
; 0000 02A9 // Declare your local variables here
; 0000 02AA 
; 0000 02AB // Input/Output Ports initialization
; 0000 02AC // Port A initialization
; 0000 02AD // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out
; 0000 02AE // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02AF PORTA=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 02B0 DDRA= 0b10000000;
	LDI  R30,LOW(128)
	OUT  0x1A,R30
; 0000 02B1 
; 0000 02B2 // Port B initialization
; 0000 02B3 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 02B4 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02B5 PORTB=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 02B6 DDRB= 0b00000000;
	OUT  0x17,R30
; 0000 02B7 
; 0000 02B8 // Port C initialization
; 0000 02B9 // Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 02BA // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02BB PORTC=0b00000000;
	OUT  0x15,R30
; 0000 02BC DDRC= 0b00111000;
	LDI  R30,LOW(56)
	OUT  0x14,R30
; 0000 02BD 
; 0000 02BE // Port D initialization
; 0000 02BF // Func7=Out Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 02C0 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02C1 PORTD=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 02C2 DDRD= 0b10110000;
	LDI  R30,LOW(176)
	OUT  0x11,R30
; 0000 02C3 
; 0000 02C4 /// Timer/Counter 0 initialization
; 0000 02C5 // Clock source: System Clock
; 0000 02C6 // Clock value: 1000.000 kHz
; 0000 02C7 // Mode: Normal top=FFh
; 0000 02C8 // OC0 output: Disconnected
; 0000 02C9 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 02CA TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 02CB OCR0=0x00;
	OUT  0x3C,R30
; 0000 02CC 
; 0000 02CD // Timer/Counter 1 initialization
; 0000 02CE // Clock source: System Clock
; 0000 02CF // Clock value: Timer1 Stopped
; 0000 02D0 // Mode: Normal top=FFFFh
; 0000 02D1 // OC1A output: Discon.
; 0000 02D2 // OC1B output: Discon.
; 0000 02D3 // Noise Canceler: Off
; 0000 02D4 // Input Capture on Falling Edge
; 0000 02D5 // Timer1 Overflow Interrupt: Off
; 0000 02D6 // Input Capture Interrupt: Off
; 0000 02D7 // Compare A Match Interrupt: Off
; 0000 02D8 // Compare B Match Interrupt: Off
; 0000 02D9 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 02DA TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 02DB TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 02DC TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 02DD ICR1H=0x00;
	OUT  0x27,R30
; 0000 02DE ICR1L=0x00;
	OUT  0x26,R30
; 0000 02DF OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 02E0 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 02E1 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 02E2 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 02E3 
; 0000 02E4 // Timer/Counter 2 initialization
; 0000 02E5 // Clock source: System Clock
; 0000 02E6 // Clock value: Timer2 Stopped
; 0000 02E7 // Mode: Normal top=FFh
; 0000 02E8 // OC2 output: Disconnected
; 0000 02E9 ASSR=0x00;
	OUT  0x22,R30
; 0000 02EA TCCR2=0x00;
	OUT  0x25,R30
; 0000 02EB TCNT2=0x00;
	OUT  0x24,R30
; 0000 02EC OCR2=0x00;
	OUT  0x23,R30
; 0000 02ED 
; 0000 02EE // External Interrupt(s) initialization
; 0000 02EF // INT0: Off
; 0000 02F0 // INT1: Off
; 0000 02F1 // INT2: Off
; 0000 02F2 MCUCR=0x00;
	OUT  0x35,R30
; 0000 02F3 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 02F4 
; 0000 02F5 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02F6 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 02F7 
; 0000 02F8 // Analog Comparator initialization
; 0000 02F9 // Analog Comparator: Off
; 0000 02FA // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 02FB ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02FC SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02FD 
; 0000 02FE // I2C Bus initialization
; 0000 02FF i2c_init();
	CALL SUBOPT_0x2C
; 0000 0300 
; 0000 0301 // DS1307 Real Time Clock initialization
; 0000 0302 // Square wave output on pin SQW/OUT: Off
; 0000 0303 // SQW/OUT pin state: 0
; 0000 0304 rtc_init(0,0,0);
; 0000 0305 
; 0000 0306 // Global enable interrupts
; 0000 0307 #asm("sei")
	sei
; 0000 0308 
; 0000 0309 
; 0000 030A // 2 Wire Bus initialization
; 0000 030B // Generate Acknowledge Pulse: Off
; 0000 030C // 2 Wire Bus Slave Address: 0h
; 0000 030D // General Call Recognition: Off
; 0000 030E // Bit Rate: 400.000 kHz
; 0000 030F //TWSR=0x00;
; 0000 0310 //TWBR=0x02;
; 0000 0311 //TWAR=0x00;
; 0000 0312 //TWCR=0x04;
; 0000 0313 
; 0000 0314 // I2C Bus initialization
; 0000 0315 i2c_init();
	CALL SUBOPT_0x2C
; 0000 0316 
; 0000 0317 // DS1307 Real Time Clock initialization
; 0000 0318 // Square wave output on pin SQW/OUT: Off
; 0000 0319 // SQW/OUT pin state: 0
; 0000 031A rtc_init(0,0,0);
; 0000 031B 
; 0000 031C // LCD module initialization
; 0000 031D lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 031E 
; 0000 031F // Watchdog Timer initialization
; 0000 0320 // Watchdog Timer Prescaler: OSC/128k
; 0000 0321 WDTCR=0x0B;
	LDI  R30,LOW(11)
	OUT  0x21,R30
; 0000 0322 
; 0000 0323 LCD_LED_TIMER = 30; lcd_light_now = lcd_light;
	LDI  R30,LOW(30)
	CALL SUBOPT_0x2D
; 0000 0324 lcd_putsf("+------------------+");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x2E
; 0000 0325 lcd_putsf("| BAZNYCIOS VARPU  |");
	__POINTW1FN _0x0,21
	CALL SUBOPT_0x2E
; 0000 0326 lcd_putsf("| VALDIKLIS V1.");
	__POINTW1FN _0x0,42
	CALL SUBOPT_0x2E
; 0000 0327 lcd_put_number(0,3,0,0,__BUILD__,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	__GETD1N 0x296
	CALL SUBOPT_0x31
; 0000 0328 lcd_putsf(" |+------------------+");
	__POINTW1FN _0x0,58
	CALL SUBOPT_0x2E
; 0000 0329 delay_ms(1500);
	CALL SUBOPT_0x32
; 0000 032A 
; 0000 032B // Default values
; 0000 032C     if(lcd_light>100){lcd_light = 100;}
	CALL SUBOPT_0x33
	CPI  R30,LOW(0x65)
	BRLO _0xD2
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	LDI  R30,LOW(100)
	CALL __EEPROMWRB
; 0000 032D 
; 0000 032E     if(BELL_OUTPUT_ADDRESS==255){BELL_OUTPUT_ADDRESS = BELL_OUTPUT_DEFAULT;}
_0xD2:
	CALL SUBOPT_0x34
	CPI  R30,LOW(0xFF)
	BRNE _0xD3
	LDI  R26,LOW(_BELL_OUTPUT_ADDRESS)
	LDI  R27,HIGH(_BELL_OUTPUT_ADDRESS)
	LDI  R30,LOW(22)
	CALL __EEPROMWRB
; 0000 032F 
; 0000 0330     if((SUMMER_TIME_TURNED_ON>1)||(IS_CLOCK_SUMMER>1)){SUMMER_TIME_TURNED_ON = 0;IS_CLOCK_SUMMER = 0;}
_0xD3:
	CALL SUBOPT_0x35
	CPI  R30,LOW(0x2)
	BRSH _0xD5
	CALL SUBOPT_0x36
	CPI  R30,LOW(0x2)
	BRLO _0xD4
_0xD5:
	LDI  R26,LOW(_SUMMER_TIME_TURNED_ON)
	LDI  R27,HIGH(_SUMMER_TIME_TURNED_ON)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	LDI  R26,LOW(_IS_CLOCK_SUMMER)
	LDI  R27,HIGH(_IS_CLOCK_SUMMER)
	CALL __EEPROMWRB
; 0000 0331 
; 0000 0332     if((CODE>9999)||(IS_LOCK_TURNED_ON>1)){CODE = 0; IS_LOCK_TURNED_ON = 0;}
_0xD4:
	LDI  R26,LOW(_CODE)
	LDI  R27,HIGH(_CODE)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x2710)
	LDI  R26,HIGH(0x2710)
	CPC  R31,R26
	BRSH _0xD8
	CALL SUBOPT_0x37
	CPI  R30,LOW(0x2)
	BRLO _0xD7
_0xD8:
	CALL SUBOPT_0x38
	LDI  R26,LOW(_IS_LOCK_TURNED_ON)
	LDI  R27,HIGH(_IS_LOCK_TURNED_ON)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0333 
; 0000 0334     if((RealTimePrecisioningValue>29)||(RealTimePrecisioningValue<-29)){RealTimePrecisioningValue = 0;}
_0xD7:
	CALL SUBOPT_0x39
	CPI  R30,LOW(0x1E)
	BRGE _0xDB
	CPI  R30,LOW(0xE3)
	BRGE _0xDA
_0xDB:
	LDI  R26,LOW(_RealTimePrecisioningValue)
	LDI  R27,HIGH(_RealTimePrecisioningValue)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0335     if(IsRealTimePrecisioned>1){IsRealTimePrecisioned = 0;}
_0xDA:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRSH _0xDD
	CLR  R10
; 0000 0336 
; 0000 0337 rtc_get_time(&RealTimeHour,&RealTimeMinute,&RealTimeSecond);
_0xDD:
	CALL SUBOPT_0x3A
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x3B
; 0000 0338 rtc_get_date(&RealTimeDay, &RealTimeMonth, &RealTimeYear);
; 0000 0339 
; 0000 033A static unsigned char STAND_BY;
; 0000 033B static unsigned char UNLOCKED;
; 0000 033C STAND_BY = 1;
	LDI  R30,LOW(1)
	STS  _STAND_BY_S000000E000,R30
; 0000 033D 
; 0000 033E     while(1){
_0xDE:
; 0000 033F     //////////////////////////////////////////////////////////////////////////////////
; 0000 0340     //////////////////////////// Funkcija kas 1 secunde //////////////////////////////
; 0000 0341     //////////////////////////////////////////////////////////////////////////////////
; 0000 0342     static unsigned int SecondCounter;
; 0000 0343     SecondCounter++;
	LDI  R26,LOW(_SecondCounter_S000000E001)
	LDI  R27,HIGH(_SecondCounter_S000000E001)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0344         if(SecondCounter>=500){
	LDS  R26,_SecondCounter_S000000E001
	LDS  R27,_SecondCounter_S000000E001+1
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0xE1
; 0000 0345         SecondCounter = 0;
	LDI  R30,LOW(0)
	STS  _SecondCounter_S000000E001,R30
	STS  _SecondCounter_S000000E001+1,R30
; 0000 0346         RefreshTime++;
	LDS  R30,_RefreshTime
	SUBI R30,-LOW(1)
	STS  _RefreshTime,R30
; 0000 0347         }
; 0000 0348 
; 0000 0349     static unsigned char TimeRefreshed;
_0xE1:
; 0000 034A         if(RefreshTime>=1){
	LDS  R26,_RefreshTime
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0xE2
; 0000 034B         TimeRefreshed = 1;
	LDI  R30,LOW(1)
	STS  _TimeRefreshed_S000000E001,R30
; 0000 034C         RefreshTime--;
	LDS  R30,_RefreshTime
	SUBI R30,LOW(1)
	STS  _RefreshTime,R30
; 0000 034D 
; 0000 034E         static unsigned char TIME_EDITING;
; 0000 034F             if(TIME_EDITING!=1){
	LDS  R26,_TIME_EDITING_S000000E002
	CPI  R26,LOW(0x1)
	BRNE PC+3
	JMP _0xE3
; 0000 0350             unsigned char Second;
; 0000 0351             rtc_get_time(&RealTimeHour,&RealTimeMinute,&Second);
	SBIW R28,1
;	Second -> Y+0
	CALL SUBOPT_0x3A
	MOVW R30,R28
	ADIW R30,4
	CALL SUBOPT_0x3B
; 0000 0352             rtc_get_date(&RealTimeDay,&RealTimeMonth,&RealTimeYear);
; 0000 0353             RealTimeWeekDay = rtc_read(0x03);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _rtc_read
	MOV  R8,R30
; 0000 0354 
; 0000 0355                 if(RealTimeSecond!=Second){
	LD   R30,Y
	CP   R30,R11
	BRNE PC+3
	JMP _0xE4
; 0000 0356                 RealTimeSecond = Second;
	LDD  R11,Y+0
; 0000 0357                 RefreshLcd++;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,-LOW(1)
	STS  _RefreshLcd_G000,R30
; 0000 0358 
; 0000 0359                     if(SUMMER_TIME_TURNED_ON==1){
	CALL SUBOPT_0x35
	CPI  R30,LOW(0x1)
	BRNE _0xE5
; 0000 035A                         if(IS_CLOCK_SUMMER==0){
	CALL SUBOPT_0x36
	CPI  R30,0
	BRNE _0xE6
; 0000 035B                             if(IsSummerTime(RealTimeMonth, RealTimeDay, RealTimeWeekDay)==1){
	CALL SUBOPT_0x3C
	CPI  R30,LOW(0x1)
	BRNE _0xE7
; 0000 035C                                 if(RealTimeHour<23){
	LDI  R30,LOW(23)
	CP   R6,R30
	BRSH _0xE8
; 0000 035D                                 RealTimeHour++;
	INC  R6
; 0000 035E                                 rtc_set_time(RealTimeHour,RealTimeMinute,RealTimeSecond);
	CALL SUBOPT_0x3D
; 0000 035F                                 IS_CLOCK_SUMMER = 1;
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0360                                 }
; 0000 0361                             }
_0xE8:
; 0000 0362                         }
_0xE7:
; 0000 0363                         else{
	RJMP _0xE9
_0xE6:
; 0000 0364                             if(IsSummerTime(RealTimeMonth, RealTimeDay, RealTimeWeekDay)==0){
	CALL SUBOPT_0x3C
	CPI  R30,0
	BRNE _0xEA
; 0000 0365                                 if(RealTimeHour>0){
	LDI  R30,LOW(0)
	CP   R30,R6
	BRSH _0xEB
; 0000 0366                                 RealTimeHour--;
	DEC  R6
; 0000 0367                                 rtc_set_time(RealTimeHour,RealTimeMinute,RealTimeSecond);
	CALL SUBOPT_0x3D
; 0000 0368                                 IS_CLOCK_SUMMER = 0;
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0369                                 }
; 0000 036A                             }
_0xEB:
; 0000 036B 
; 0000 036C                         }
_0xEA:
_0xE9:
; 0000 036D                     }
; 0000 036E 
; 0000 036F                     if(RealTimeDay==1){
_0xE5:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0xEC
; 0000 0370                         if(RealTimeHour==0){
	TST  R6
	BRNE _0xED
; 0000 0371                             if(RealTimeMinute==0){
	TST  R9
	BRNE _0xEE
; 0000 0372                                 if(RealTimeSecond==30){
	LDI  R30,LOW(30)
	CP   R30,R11
	BRNE _0xEF
; 0000 0373                                     if(IsRealTimePrecisioned==0){
	TST  R10
	BRNE _0xF0
; 0000 0374                                         if(RealTimePrecisioningValue!=0){
	CALL SUBOPT_0x39
	CPI  R30,0
	BREQ _0xF1
; 0000 0375                                         IsRealTimePrecisioned = 1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 0376                                         RealTimeSecond += RealTimePrecisioningValue;
	CALL SUBOPT_0x39
	ADD  R11,R30
; 0000 0377                                         rtc_set_time(RealTimeHour,RealTimeMinute,RealTimeSecond);
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R11
	CALL _rtc_set_time
; 0000 0378                                         }
; 0000 0379                                     }
_0xF1:
; 0000 037A                                 }
_0xF0:
; 0000 037B                             }
_0xEF:
; 0000 037C                             else{
	RJMP _0xF2
_0xEE:
; 0000 037D                             IsRealTimePrecisioned = 0;
	CLR  R10
; 0000 037E                             }
_0xF2:
; 0000 037F                         }
; 0000 0380                     }
_0xED:
; 0000 0381 
; 0000 0382 
; 0000 0383                 //---- Skambuciai ----//
; 0000 0384                 static unsigned int CALL_BELL;
_0xEC:
; 0000 0385                     if(RealTimeSecond==0){
	TST  R11
	BREQ PC+3
	JMP _0xF3
; 0000 0386                     unsigned char bell_id,type,a,b,z;
; 0000 0387                     a = IsEasterToday(RealTimeYear, RealTimeMonth, RealTimeDay);
	SBIW R28,5
;	Second -> Y+5
;	bell_id -> Y+4
;	type -> Y+3
;	a -> Y+2
;	b -> Y+1
;	z -> Y+0
	CALL SUBOPT_0x3E
	RCALL _IsEasterToday
	STD  Y+2,R30
; 0000 0388                     b = IsChristmasToday(RealTimeYear, RealTimeMonth, RealTimeDay);
	CALL SUBOPT_0x3E
	RCALL _IsChristmasToday
	STD  Y+1,R30
; 0000 0389                     z = RealTimeWeekDay;
	__PUTBSR 8,0
; 0000 038A                     /////////////////////////////////
; 0000 038B                     // TYPE 0:  Pirmadienio
; 0000 038C                     // TYPE 1:  Antradienio
; 0000 038D                     // TYPE 2:  Treciadienio
; 0000 038E                     // TYPE 3:  Ketvirtadienio
; 0000 038F                     // TYPE 4:  Penktadienio
; 0000 0390                     // TYPE 5:  Sestadienio
; 0000 0391                     // TYPE 6:  Sekmadienio
; 0000 0392 
; 0000 0393                     // TYPE 7:  Velyku ketvirtadienio
; 0000 0394                     // TYPE 8:  Velyku penktadienio
; 0000 0395                     // TYPE 9:  Velyku sestadienio
; 0000 0396                     // TYPE 10: Velyku sekmadienio
; 0000 0397 
; 0000 0398                     // TYPE 11: Kaledu 1-os dienos
; 0000 0399                     // TYPE 12: Kaledu 2-os dienos
; 0000 039A                     /////////////////////////////////
; 0000 039B 
; 0000 039C                         if(a==4){      type = 7; }// Velyku Ketvirtadienis
	LDD  R26,Y+2
	CPI  R26,LOW(0x4)
	BRNE _0xF4
	LDI  R30,LOW(7)
	RJMP _0x4AF
; 0000 039D                         else if(a==5){ type = 8; }// Velyku Penktadienis
_0xF4:
	LDD  R26,Y+2
	CPI  R26,LOW(0x5)
	BRNE _0xF6
	LDI  R30,LOW(8)
	RJMP _0x4AF
; 0000 039E                         else if(a==6){ type = 9; }// Velyku Sestadienis
_0xF6:
	LDD  R26,Y+2
	CPI  R26,LOW(0x6)
	BRNE _0xF8
	LDI  R30,LOW(9)
	RJMP _0x4AF
; 0000 039F                         else if(a==7){ type = 10;}// Velyku Sekmadienis
_0xF8:
	LDD  R26,Y+2
	CPI  R26,LOW(0x7)
	BRNE _0xFA
	LDI  R30,LOW(10)
	RJMP _0x4AF
; 0000 03A0 
; 0000 03A1                         else if(b==1){ type = 11;}// Kaledu 1-os diena
_0xFA:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0xFC
	LDI  R30,LOW(11)
	RJMP _0x4AF
; 0000 03A2                         else if(b==2){ type = 12;}// Kaledu 2-os diena
_0xFC:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0xFE
	LDI  R30,LOW(12)
	RJMP _0x4AF
; 0000 03A3 
; 0000 03A4                         else if(z==1){ type = 0; }// Pirmadienis
_0xFE:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x100
	LDI  R30,LOW(0)
	RJMP _0x4AF
; 0000 03A5                         else if(z==2){ type = 1; }// Antradienis
_0x100:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x102
	LDI  R30,LOW(1)
	RJMP _0x4AF
; 0000 03A6                         else if(z==3){ type = 2; }// Treciadienis
_0x102:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x104
	LDI  R30,LOW(2)
	RJMP _0x4AF
; 0000 03A7                         else if(z==4){ type = 3; }// Ketvirtadienis
_0x104:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x106
	LDI  R30,LOW(3)
	RJMP _0x4AF
; 0000 03A8                         else if(z==5){ type = 4; }// Penktadienis
_0x106:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x108
	LDI  R30,LOW(4)
	RJMP _0x4AF
; 0000 03A9                         else if(z==6){ type = 5; }// Sestadienis
_0x108:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x10A
	LDI  R30,LOW(5)
	RJMP _0x4AF
; 0000 03AA                         else if(z==7){ type = 6; }// Sekmadienis
_0x10A:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x10C
	LDI  R30,LOW(6)
_0x4AF:
	STD  Y+3,R30
; 0000 03AB 
; 0000 03AC                         for(bell_id=0;bell_id<BELL_COUNT;bell_id++){
_0x10C:
	LDI  R30,LOW(0)
	STD  Y+4,R30
_0x10E:
	LDD  R26,Y+4
	CPI  R26,LOW(0x14)
	BRSH _0x10F
; 0000 03AD                             if(BELL_TIME[type][bell_id][0]==RealTimeHour){
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x19
	CP   R6,R30
	BRNE _0x110
; 0000 03AE                                 if(BELL_TIME[type][bell_id][1]==RealTimeMinute){
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
	CP   R9,R30
	BRNE _0x111
; 0000 03AF                                 CALL_BELL = BELL_TIME[type][bell_id][2];
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x41
	STS  _CALL_BELL_S000000E004,R30
	STS  _CALL_BELL_S000000E004+1,R31
; 0000 03B0                                 }
; 0000 03B1                             }
_0x111:
; 0000 03B2                         }
_0x110:
	LDD  R30,Y+4
	SUBI R30,-LOW(1)
	STD  Y+4,R30
	RJMP _0x10E
_0x10F:
; 0000 03B3                     }
	ADIW R28,5
; 0000 03B4 
; 0000 03B5                     if(CALL_BELL>0){
_0xF3:
	LDS  R26,_CALL_BELL_S000000E004
	LDS  R27,_CALL_BELL_S000000E004+1
	CALL __CPW02
	BRSH _0x112
; 0000 03B6                     OUTPUT(BELL_OUTPUT_ADDRESS, 1);
	CALL SUBOPT_0x34
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _OUTPUT
; 0000 03B7                     CALL_BELL--;
	LDI  R26,LOW(_CALL_BELL_S000000E004)
	LDI  R27,HIGH(_CALL_BELL_S000000E004)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 03B8                     }
; 0000 03B9                     else{
	RJMP _0x113
_0x112:
; 0000 03BA                     OUTPUT(BELL_OUTPUT_ADDRESS, 0);
	CALL SUBOPT_0x34
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _OUTPUT
; 0000 03BB                     }
_0x113:
; 0000 03BC                 //--------------------//
; 0000 03BD 
; 0000 03BE 
; 0000 03BF                     if(STAND_BY_TIMER>0){
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BRSH _0x114
; 0000 03C0                     STAND_BY_TIMER--;
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
; 0000 03C1                         if(STAND_BY_TIMER==0){
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x115
; 0000 03C2                         STAND_BY = 1;
	LDI  R30,LOW(1)
	STS  _STAND_BY_S000000E000,R30
; 0000 03C3                         Address[0] = 0;
	CALL SUBOPT_0x42
; 0000 03C4                         Address[1] = 0;
; 0000 03C5                         Address[2] = 0;
; 0000 03C6                         Address[3] = 0;
; 0000 03C7                         Address[4] = 0;
; 0000 03C8                         Address[5] = 0;
; 0000 03C9                         SelectedRow = 0;
; 0000 03CA                         UNLOCKED = 0;
	LDI  R30,LOW(0)
	STS  _UNLOCKED_S000000E000,R30
; 0000 03CB                         }
; 0000 03CC                     }
_0x115:
; 0000 03CD 
; 0000 03CE                     if(MAIN_MENU_TIMER>0){
_0x114:
	LDS  R26,_MAIN_MENU_TIMER
	CPI  R26,LOW(0x1)
	BRLO _0x116
; 0000 03CF                     MAIN_MENU_TIMER--;
	LDS  R30,_MAIN_MENU_TIMER
	SUBI R30,LOW(1)
	STS  _MAIN_MENU_TIMER,R30
; 0000 03D0                         if(MAIN_MENU_TIMER==0){
	CPI  R30,0
	BRNE _0x117
; 0000 03D1                         Address[0] = 0;
	CALL SUBOPT_0x42
; 0000 03D2                         Address[1] = 0;
; 0000 03D3                         Address[2] = 0;
; 0000 03D4                         Address[3] = 0;
; 0000 03D5                         Address[4] = 0;
; 0000 03D6                         Address[5] = 0;
; 0000 03D7                         SelectedRow = 0;
; 0000 03D8                         }
; 0000 03D9                     }
_0x117:
; 0000 03DA 
; 0000 03DB                     if(LCD_LED_TIMER>0){
_0x116:
	LDS  R26,_LCD_LED_TIMER
	CPI  R26,LOW(0x1)
	BRLO _0x118
; 0000 03DC                     LCD_LED_TIMER--;
	LDS  R30,_LCD_LED_TIMER
	SUBI R30,LOW(1)
	STS  _LCD_LED_TIMER,R30
; 0000 03DD                     }
; 0000 03DE 
; 0000 03DF                 }
_0x118:
; 0000 03E0             }
_0xE4:
	ADIW R28,1
; 0000 03E1             else{
	RJMP _0x119
_0xE3:
; 0000 03E2             RefreshLcd++;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,-LOW(1)
	STS  _RefreshLcd_G000,R30
; 0000 03E3             }
_0x119:
; 0000 03E4         }
; 0000 03E5     //////////////////////////////////////////////////////////////////////////////////
; 0000 03E6     //////////////////////////////////////////////////////////////////////////////////
; 0000 03E7     //////////////////////////////////////////////////////////////////////////////////
; 0000 03E8 
; 0000 03E9 
; 0000 03EA     //////////////////////////////////////////////////////////////////////////////////
; 0000 03EB     /////////////////////////////////////// Mygtukai /////////////////////////////////
; 0000 03EC     //////////////////////////////////////////////////////////////////////////////////
; 0000 03ED     static unsigned char BUTTON[5], ButtonFilter[5];
_0xE2:
; 0000 03EE         if(1){
; 0000 03EF         unsigned char i;
; 0000 03F0             for(i=0;i<5;i++){
	SBIW R28,1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0x11C:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRSH _0x11D
; 0000 03F1                 if(BUTTON_INPUT(i)==1){
	LD   R30,Y
	ST   -Y,R30
	RCALL _BUTTON_INPUT
	CPI  R30,LOW(0x1)
	BRNE _0x11E
; 0000 03F2                     if(ButtonFilter[i]<ButtonFiltrationTimer){
	CALL SUBOPT_0x43
	BRSH _0x11F
; 0000 03F3                     ButtonFilter[i]++;
	CALL SUBOPT_0x44
	SUBI R26,LOW(-_ButtonFilter_S000000E001)
	SBCI R27,HIGH(-_ButtonFilter_S000000E001)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 03F4                     }
; 0000 03F5                 }
_0x11F:
; 0000 03F6                 else{
	RJMP _0x120
_0x11E:
; 0000 03F7                     if(ButtonFilter[i]>=ButtonFiltrationTimer){
	CALL SUBOPT_0x43
	BRLO _0x121
; 0000 03F8                     BUTTON[i] = 1;
	CALL SUBOPT_0x45
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 03F9                     RefreshLcd = RefreshLcd + 2;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,-LOW(2)
	STS  _RefreshLcd_G000,R30
; 0000 03FA                     STAND_BY_TIMER = 45;
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	MOVW R12,R30
; 0000 03FB                     MAIN_MENU_TIMER = 30;
	LDI  R30,LOW(30)
	STS  _MAIN_MENU_TIMER,R30
; 0000 03FC                     LCD_LED_TIMER = 15; lcd_light_now = lcd_light;
	LDI  R30,LOW(15)
	CALL SUBOPT_0x2D
; 0000 03FD                     }
; 0000 03FE                     else{
	RJMP _0x122
_0x121:
; 0000 03FF                     BUTTON[i] = 0;
	CALL SUBOPT_0x45
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0400                     }
_0x122:
; 0000 0401                 ButtonFilter[i] = 0;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_ButtonFilter_S000000E001)
	SBCI R31,HIGH(-_ButtonFilter_S000000E001)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0402                 }
_0x120:
; 0000 0403             }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x11C
_0x11D:
; 0000 0404         }
	ADIW R28,1
; 0000 0405     //////////////////////////////////////////////////////////////////////////////////
; 0000 0406     //////////////////////////////////////////////////////////////////////////////////
; 0000 0407     //////////////////////////////////////////////////////////////////////////////////
; 0000 0408 
; 0000 0409 
; 0000 040A     //////////////////////////////////////////////////////////////////////////////////
; 0000 040B     ///////////////////////////// LCD ////////////////////////////////////////////////
; 0000 040C     //////////////////////////////////////////////////////////////////////////////////
; 0000 040D     // Lcd led
; 0000 040E     static unsigned char lcd_led_counter;
; 0000 040F         if(LCD_LED_TIMER==0){
	LDS  R30,_LCD_LED_TIMER
	CPI  R30,0
	BRNE _0x123
; 0000 0410             if(lcd_light_now>0){
	LDS  R26,_lcd_light_now_G000
	CPI  R26,LOW(0x1)
	BRLO _0x124
; 0000 0411             lcd_led_counter++;
	LDS  R30,_lcd_led_counter_S000000E001
	SUBI R30,-LOW(1)
	STS  _lcd_led_counter_S000000E001,R30
; 0000 0412                 if(lcd_led_counter>=25){
	LDS  R26,_lcd_led_counter_S000000E001
	CPI  R26,LOW(0x19)
	BRLO _0x125
; 0000 0413                 lcd_led_counter = 0;
	LDI  R30,LOW(0)
	STS  _lcd_led_counter_S000000E001,R30
; 0000 0414                 lcd_light_now--;
	LDS  R30,_lcd_light_now_G000
	SUBI R30,LOW(1)
	STS  _lcd_light_now_G000,R30
; 0000 0415                 }
; 0000 0416             }
_0x125:
; 0000 0417         }
_0x124:
; 0000 0418 
; 0000 0419 
; 0000 041A         if(STAND_BY==1){
_0x123:
	LDS  R26,_STAND_BY_S000000E000
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x126
; 0000 041B         static unsigned char stand_by_pos[2];
; 0000 041C         stand_by_pos[0]++;
	LDS  R30,_stand_by_pos_S000000E002
	SUBI R30,-LOW(1)
	STS  _stand_by_pos_S000000E002,R30
; 0000 041D 
; 0000 041E             if(stand_by_pos[0]>=225){
	LDS  R26,_stand_by_pos_S000000E002
	CPI  R26,LOW(0xE1)
	BRSH PC+3
	JMP _0x127
; 0000 041F             stand_by_pos[0] = 0;
	LDI  R30,LOW(0)
	STS  _stand_by_pos_S000000E002,R30
; 0000 0420             stand_by_pos[1]++;
	__GETB1MN _stand_by_pos_S000000E002,1
	SUBI R30,-LOW(1)
	__PUTB1MN _stand_by_pos_S000000E002,1
; 0000 0421                 if(stand_by_pos[1]>=44){
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x2C)
	BRLO _0x128
; 0000 0422                 stand_by_pos[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _stand_by_pos_S000000E002,1
; 0000 0423                 }
; 0000 0424 
; 0000 0425             lcd_clear();
_0x128:
	CALL _lcd_clear
; 0000 0426                 if(stand_by_pos[1]==0){lcd_gotoxy(0,2);lcd_putchar('|');lcd_gotoxy(0,1);lcd_putchar('|');lcd_gotoxy(0,0);lcd_putchar('^');}
	__GETB1MN _stand_by_pos_S000000E002,1
	CPI  R30,0
	BRNE _0x129
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
	CALL SUBOPT_0x30
	CALL _lcd_gotoxy
	LDI  R30,LOW(94)
	RJMP _0x4B0
; 0000 0427                 else if(stand_by_pos[1]==1){lcd_gotoxy(0,1);lcd_putchar('|');lcd_gotoxy(0,0);lcd_putsf("+>");}
_0x129:
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x1)
	BRNE _0x12B
	CALL SUBOPT_0x48
	CALL SUBOPT_0x30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,81
	CALL SUBOPT_0x2E
; 0000 0428                 else if((stand_by_pos[1]>=2)&&(stand_by_pos[1]<=19)){lcd_gotoxy(stand_by_pos[1]-2,0);lcd_putsf("-->");}
	RJMP _0x12C
_0x12B:
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x2)
	BRLO _0x12E
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x14)
	BRLO _0x12F
_0x12E:
	RJMP _0x12D
_0x12F:
	__GETB1MN _stand_by_pos_S000000E002,1
	LDI  R31,0
	SBIW R30,2
	CALL SUBOPT_0x49
	__POINTW1FN _0x0,84
	CALL SUBOPT_0x2E
; 0000 0429                 else if(stand_by_pos[1]==20){lcd_gotoxy(18,0);lcd_putsf("-+");lcd_gotoxy(19,1);lcd_putchar('v');}
	RJMP _0x130
_0x12D:
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x14)
	BRNE _0x131
	LDI  R30,LOW(18)
	CALL SUBOPT_0x49
	__POINTW1FN _0x0,18
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x4A
	LDI  R30,LOW(118)
	RJMP _0x4B0
; 0000 042A                 else if(stand_by_pos[1]==21){lcd_gotoxy(19,0);lcd_putchar('|');lcd_gotoxy(19,1);lcd_putchar('|');lcd_gotoxy(19,2);lcd_putchar('v');}
_0x131:
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x15)
	BRNE _0x133
	LDI  R30,LOW(19)
	CALL SUBOPT_0x49
	CALL SUBOPT_0x47
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x47
	CALL SUBOPT_0x4B
	LDI  R30,LOW(118)
	RJMP _0x4B0
; 0000 042B                 else if(stand_by_pos[1]==22){lcd_gotoxy(19,1);lcd_putchar('|');lcd_gotoxy(19,2);lcd_putchar('|');lcd_gotoxy(19,3);lcd_putchar('v');}
_0x133:
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x16)
	BRNE _0x135
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x47
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x47
	CALL SUBOPT_0x4C
	LDI  R30,LOW(118)
	RJMP _0x4B0
; 0000 042C                 else if(stand_by_pos[1]==23){lcd_gotoxy(19,2);lcd_putchar('|');lcd_gotoxy(18,3);lcd_putsf("<+");}
_0x135:
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x17)
	BRNE _0x137
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x47
	LDI  R30,LOW(18)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,88
	CALL SUBOPT_0x2E
; 0000 042D                 else if((stand_by_pos[1]>=24)&&(stand_by_pos[1]<=41)){lcd_gotoxy(17-stand_by_pos[1]+24,3);lcd_putsf("<--");}
	RJMP _0x138
_0x137:
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x18)
	BRLO _0x13A
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x2A)
	BRLO _0x13B
_0x13A:
	RJMP _0x139
_0x13B:
	__GETB1MN _stand_by_pos_S000000E002,1
	LDI  R31,0
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,-LOW(24)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,91
	CALL SUBOPT_0x2E
; 0000 042E                 else if(stand_by_pos[1]==42){lcd_gotoxy(0,2);lcd_putchar('^');lcd_gotoxy(0,3);lcd_putsf("+-");}
	RJMP _0x13C
_0x139:
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x2A)
	BRNE _0x13D
	CALL SUBOPT_0x46
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,95
	CALL SUBOPT_0x2E
; 0000 042F                 else if(stand_by_pos[1]==43){lcd_gotoxy(0,1);lcd_putchar('^');lcd_gotoxy(0,2);lcd_putchar('|');lcd_gotoxy(0,3);lcd_putchar('|');}
	RJMP _0x13E
_0x13D:
	__GETB2MN _stand_by_pos_S000000E002,1
	CPI  R26,LOW(0x2B)
	BRNE _0x13F
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
	LDI  R30,LOW(124)
_0x4B0:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0430 
; 0000 0431             lcd_gotoxy(1,1);
_0x13F:
_0x13E:
_0x13C:
_0x138:
_0x130:
_0x12C:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x4F
; 0000 0432             lcd_putsf("     ");
	__POINTW1FN _0x0,98
	CALL SUBOPT_0x2E
; 0000 0433             lcd_put_number(0,2,0,0,RealTimeHour,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0434             lcd_putsf(":");
	CALL SUBOPT_0x52
; 0000 0435             lcd_put_number(0,2,0,0,RealTimeMinute,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x53
; 0000 0436             lcd_putsf(":");
	CALL SUBOPT_0x52
; 0000 0437             lcd_put_number(0,2,0,0,RealTimeSecond,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x54
; 0000 0438             lcd_putsf("     ");
	__POINTW1FN _0x0,98
	CALL SUBOPT_0x2E
; 0000 0439 
; 0000 043A             lcd_gotoxy(1,2);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x55
; 0000 043B             lcd_putsf("    2");
	__POINTW1FN _0x0,106
	CALL SUBOPT_0x2E
; 0000 043C             lcd_put_number(0,3,0,0,RealTimeYear,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x56
; 0000 043D             lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 043E             lcd_put_number(0,2,0,0,RealTimeMonth,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x58
; 0000 043F             lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0440             lcd_put_number(0,2,0,0,RealTimeDay,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x59
; 0000 0441             lcd_putsf("    ");
	CALL SUBOPT_0x5A
; 0000 0442             }
; 0000 0443 
; 0000 0444             if(BUTTON[BUTTON_LEFT]==1){
_0x127:
	__GETB2MN _BUTTON_S000000E001,1
	CPI  R26,LOW(0x1)
	BREQ _0x4B1
; 0000 0445             STAND_BY = 0;
; 0000 0446             }
; 0000 0447             else if(BUTTON[BUTTON_RIGHT]==1){
	__GETB2MN _BUTTON_S000000E001,3
	CPI  R26,LOW(0x1)
	BREQ _0x4B1
; 0000 0448             STAND_BY = 0;
; 0000 0449             }
; 0000 044A             else if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BREQ _0x4B1
; 0000 044B             STAND_BY = 0;
; 0000 044C             }
; 0000 044D             else if(BUTTON[BUTTON_UP]==1){
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BREQ _0x4B1
; 0000 044E             STAND_BY = 0;
; 0000 044F             }
; 0000 0450             else if(BUTTON[BUTTON_ENTER]==1){
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x148
; 0000 0451             STAND_BY = 0;
_0x4B1:
	LDI  R30,LOW(0)
	STS  _STAND_BY_S000000E000,R30
; 0000 0452             }
; 0000 0453 
; 0000 0454         }
_0x148:
; 0000 0455         else if((IS_LOCK_TURNED_ON==1)&&(UNLOCKED==0)){
	JMP  _0x149
_0x126:
	CALL SUBOPT_0x37
	CPI  R30,LOW(0x1)
	BRNE _0x14B
	LDS  R26,_UNLOCKED_S000000E000
	CPI  R26,LOW(0x0)
	BREQ _0x14C
_0x14B:
	RJMP _0x14A
_0x14C:
; 0000 0456         static unsigned int entering_code;
; 0000 0457             if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x14D
; 0000 0458             lcd_clear();
	CALL _lcd_clear
; 0000 0459             }
; 0000 045A 
; 0000 045B             if(BUTTON[BUTTON_LEFT]==1){
_0x14D:
	__GETB2MN _BUTTON_S000000E001,1
	CPI  R26,LOW(0x1)
	BRNE _0x14E
; 0000 045C                 if(Address[0]>0){
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BRLO _0x14F
; 0000 045D                 Address[0]--;
	LDS  R30,_Address_G000
	SUBI R30,LOW(1)
	STS  _Address_G000,R30
; 0000 045E                 }
; 0000 045F             }
_0x14F:
; 0000 0460             else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x150
_0x14E:
	__GETB2MN _BUTTON_S000000E001,3
	CPI  R26,LOW(0x1)
	BRNE _0x151
; 0000 0461                 if(Address[0]<3){
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x3)
	BRSH _0x152
; 0000 0462                 Address[0]++;
	LDS  R30,_Address_G000
	SUBI R30,-LOW(1)
	STS  _Address_G000,R30
; 0000 0463                 }
; 0000 0464             }
_0x152:
; 0000 0465             else if(BUTTON[BUTTON_DOWN]==1){
	RJMP _0x153
_0x151:
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x154
; 0000 0466                 if(Address[0]==0){
	LDS  R30,_Address_G000
	CPI  R30,0
	BRNE _0x155
; 0000 0467                     if(entering_code>=1000){
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLO _0x156
; 0000 0468                     entering_code += -1000;
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 0469                     }
; 0000 046A                 }
_0x156:
; 0000 046B                 else if(Address[0]==1){
	RJMP _0x157
_0x155:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BRNE _0x158
; 0000 046C                 unsigned int a;
; 0000 046D                 a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x5E
;	a -> Y+0
; 0000 046E                     if(a>=100){
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0x159
; 0000 046F                     entering_code += -100;
	CALL SUBOPT_0x5F
; 0000 0470                     }
; 0000 0471                 }
_0x159:
	RJMP _0x4B2
; 0000 0472                 else if(Address[0]==2){
_0x158:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x2)
	BRNE _0x15B
; 0000 0473                 unsigned int a;
; 0000 0474                 a = entering_code - ((entering_code/100) * 100);
	CALL SUBOPT_0x60
;	a -> Y+0
; 0000 0475                     if(a>=10){
	BRLO _0x15C
; 0000 0476                     entering_code += -10;
	CALL SUBOPT_0x61
; 0000 0477                     }
; 0000 0478                 }
_0x15C:
	RJMP _0x4B2
; 0000 0479                 else if(Address[0]==3){
_0x15B:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x3)
	BRNE _0x15E
; 0000 047A                 unsigned int a;
; 0000 047B                 a = entering_code - ((entering_code/10) * 10);
	CALL SUBOPT_0x62
;	a -> Y+0
; 0000 047C                     if(a>=1){
	BRLO _0x15F
; 0000 047D                     entering_code += -1;
	CALL SUBOPT_0x63
; 0000 047E                     }
; 0000 047F                 }
_0x15F:
_0x4B2:
	ADIW R28,2
; 0000 0480             }
_0x15E:
_0x157:
; 0000 0481             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x160
_0x154:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x161
; 0000 0482                 if(Address[0]==0){
	LDS  R30,_Address_G000
	CPI  R30,0
	BRNE _0x162
; 0000 0483                     if(entering_code<9000){
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x2328)
	LDI  R30,HIGH(0x2328)
	CPC  R27,R30
	BRSH _0x163
; 0000 0484                     entering_code += 1000;
	CALL SUBOPT_0x64
; 0000 0485                     }
; 0000 0486                 }
_0x163:
; 0000 0487                 else if(Address[0]==1){
	RJMP _0x164
_0x162:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BRNE _0x165
; 0000 0488                 unsigned int a;
; 0000 0489                 a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x5E
;	a -> Y+0
; 0000 048A                     if(a<900){
	CPI  R26,LOW(0x384)
	LDI  R30,HIGH(0x384)
	CPC  R27,R30
	BRSH _0x166
; 0000 048B                     entering_code += 100;
	CALL SUBOPT_0x65
; 0000 048C                     }
; 0000 048D                 }
_0x166:
	ADIW R28,2
; 0000 048E                 else if(Address[0]==2){
	RJMP _0x167
_0x165:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x2)
	BRNE _0x168
; 0000 048F                 unsigned char a;
; 0000 0490                 a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x66
;	a -> Y+0
; 0000 0491                 a = a - ((a/100) * 100);
	CALL SUBOPT_0x67
; 0000 0492                     if(a<90){
	LD   R26,Y
	CPI  R26,LOW(0x5A)
	BRSH _0x169
; 0000 0493                     entering_code += 10;
	CALL SUBOPT_0x68
; 0000 0494                     }
; 0000 0495                 }
_0x169:
	RJMP _0x4B3
; 0000 0496                 else if(Address[0]==3){
_0x168:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x3)
	BRNE _0x16B
; 0000 0497                 unsigned char a;
; 0000 0498                 a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x66
;	a -> Y+0
; 0000 0499                 a = a - ((a/100) * 100);
	CALL SUBOPT_0x67
; 0000 049A                 a = a - ((a/10) * 10);
	LDD  R22,Y+0
	CLR  R23
	CALL SUBOPT_0x44
	CALL SUBOPT_0x69
; 0000 049B                     if(a<9){
	BRSH _0x16C
; 0000 049C                     entering_code += 1;
	CALL SUBOPT_0x6A
; 0000 049D                     }
; 0000 049E                 }
_0x16C:
_0x4B3:
	ADIW R28,1
; 0000 049F             }
_0x16B:
_0x167:
_0x164:
; 0000 04A0             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x16D
_0x161:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x16E
; 0000 04A1             Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
; 0000 04A2                 if(entering_code==CODE){
	LDI  R26,LOW(_CODE)
	LDI  R27,HIGH(_CODE)
	CALL __EEPROMRDW
	CALL SUBOPT_0x5B
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x16F
; 0000 04A3                 UNLOCKED = 1;
	LDI  R30,LOW(1)
	STS  _UNLOCKED_S000000E000,R30
; 0000 04A4                 entering_code = 0;
	CALL SUBOPT_0x6B
; 0000 04A5                 lcd_clear();
	CALL _lcd_clear
; 0000 04A6                 lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x4F
; 0000 04A7                 lcd_putsf("KODAS");
	__POINTW1FN _0x0,112
	CALL SUBOPT_0x2E
; 0000 04A8                 lcd_gotoxy(5,2);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x55
; 0000 04A9                 lcd_putsf("TEISINGAS");
	__POINTW1FN _0x0,118
	RJMP _0x4B4
; 0000 04AA                 delay_ms(1500);
; 0000 04AB                 }
; 0000 04AC                 else{
_0x16F:
; 0000 04AD                 lcd_clear();
	CALL _lcd_clear
; 0000 04AE                 entering_code = 0;
	CALL SUBOPT_0x6B
; 0000 04AF                 lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x4F
; 0000 04B0                 lcd_putsf("KODAS");
	__POINTW1FN _0x0,112
	CALL SUBOPT_0x2E
; 0000 04B1                 lcd_gotoxy(4,2);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x55
; 0000 04B2                 lcd_putsf("NETEISINGAS");
	__POINTW1FN _0x0,128
_0x4B4:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 04B3                 delay_ms(1500);
	CALL SUBOPT_0x32
; 0000 04B4                 }
; 0000 04B5             }
; 0000 04B6 
; 0000 04B7             if(RefreshLcd>=1){
_0x16E:
_0x16D:
_0x160:
_0x153:
_0x150:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x171
; 0000 04B8             unsigned int i;
; 0000 04B9             lcd_putsf("-=====UZRAKTAS=====-");
	SBIW R28,2
;	i -> Y+0
	__POINTW1FN _0x0,140
	CALL SUBOPT_0x2E
; 0000 04BA             lcd_gotoxy(0,1);
	CALL SUBOPT_0x4E
; 0000 04BB             lcd_putsf("IVESKITE KODA: ");
	__POINTW1FN _0x0,161
	CALL SUBOPT_0x2E
; 0000 04BC             lcd_gotoxy(14,2);
	LDI  R30,LOW(14)
	CALL SUBOPT_0x55
; 0000 04BD             i = entering_code;
	CALL SUBOPT_0x5C
	ST   Y,R30
	STD  Y+1,R31
; 0000 04BE                 if(Address[0]==0){
	LDS  R30,_Address_G000
	CPI  R30,0
	BRNE _0x172
; 0000 04BF                 lcd_putchar( NumToIndex( i/1000) );
	CALL SUBOPT_0x6C
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x4B5
; 0000 04C0                 }
; 0000 04C1                 else{
_0x172:
; 0000 04C2                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x4B5:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 04C3                 }
; 0000 04C4             i = i - (i/1000)*1000;
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
; 0000 04C5                 if(Address[0]==1){
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BRNE _0x174
; 0000 04C6                 lcd_putchar( NumToIndex( i/100) );
	CALL SUBOPT_0x6E
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x4B6
; 0000 04C7                 }
; 0000 04C8                 else{
_0x174:
; 0000 04C9                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x4B6:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 04CA                 }
; 0000 04CB             i = i - (i/100)*100;
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6F
; 0000 04CC                 if(Address[0]==2){
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x2)
	BRNE _0x176
; 0000 04CD                 lcd_putchar( NumToIndex( i/10) );
	CALL SUBOPT_0x70
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x4B7
; 0000 04CE                 }
; 0000 04CF                 else{
_0x176:
; 0000 04D0                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x4B7:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 04D1                 }
; 0000 04D2             i = i - (i/10)*10;
	CALL SUBOPT_0x70
	CALL SUBOPT_0x71
; 0000 04D3                 if(Address[0]==3){
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x3)
	BRNE _0x178
; 0000 04D4                 lcd_putchar( NumToIndex(i) );
	LD   R30,Y
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x4B8
; 0000 04D5                 }
; 0000 04D6                 else{
_0x178:
; 0000 04D7                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x4B8:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 04D8                 }
; 0000 04D9             lcd_gotoxy(0,3);
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
; 0000 04DA             lcd_putsf("-==================-");
	__POINTW1FN _0x0,177
	CALL SUBOPT_0x2E
; 0000 04DB             }
	ADIW R28,2
; 0000 04DC         }
_0x171:
; 0000 04DD         else{
	JMP  _0x17A
_0x14A:
; 0000 04DE 
; 0000 04DF             if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x17B
; 0000 04E0             lcd_clear();
	CALL _lcd_clear
; 0000 04E1             }
; 0000 04E2 
; 0000 04E3             // Pagrindinis langas
; 0000 04E4             if(Address[0]==0){
_0x17B:
	LDS  R30,_Address_G000
	CPI  R30,0
	BREQ PC+3
	JMP _0x17C
; 0000 04E5                 if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x17D
; 0000 04E6                 SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 04E7                 }
; 0000 04E8                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x17E
_0x17D:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x17F
; 0000 04E9                 SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 04EA                 }
; 0000 04EB                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x180
_0x17F:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x181
; 0000 04EC                 Address[0] = SelectedRow;
	LDS  R30,_SelectedRow_G000
	STS  _Address_G000,R30
; 0000 04ED                 SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 04EE                 Address[5] = 0;
; 0000 04EF                 }
; 0000 04F0 
; 0000 04F1                 if(RefreshLcd>=1){
_0x181:
_0x180:
_0x17E:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x182
; 0000 04F2                 unsigned char row, lcd_row;
; 0000 04F3                 lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 04F4                 RowsOnWindow = 5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x75
; 0000 04F5                     for(row=Address[5];row<4+Address[5];row++){
_0x184:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRLT PC+3
	JMP _0x185
; 0000 04F6                     lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 04F7 
; 0000 04F8                         if(row==0){
	BRNE _0x186
; 0000 04F9                         lcd_putsf("  -=PAGR. MENIU=-");
	__POINTW1FN _0x0,198
	RJMP _0x4B9
; 0000 04FA                         }
; 0000 04FB                         else if(row==1){
_0x186:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x188
; 0000 04FC                         lcd_putsf("1.LAIKAS: ");
	__POINTW1FN _0x0,216
	CALL SUBOPT_0x2E
; 0000 04FD                         lcd_put_number(0,2,0,0,RealTimeHour,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 04FE                         lcd_putsf(":");
	CALL SUBOPT_0x52
; 0000 04FF                         lcd_put_number(0,2,0,0,RealTimeMinute,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x53
; 0000 0500                         lcd_putsf(" ");
	__POINTW1FN _0x0,102
	RJMP _0x4B9
; 0000 0501                         }
; 0000 0502                         else if(row==2){
_0x188:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x18A
; 0000 0503                         lcd_putsf("2.DATA: 20");
	__POINTW1FN _0x0,227
	CALL SUBOPT_0x2E
; 0000 0504                         lcd_put_number(0,2,0,0,RealTimeYear,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x56
; 0000 0505                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0506                         lcd_put_number(0,2,0,0,RealTimeMonth,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x58
; 0000 0507                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0508                         lcd_put_number(0,2,0,0,RealTimeDay,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x59
; 0000 0509                         }
; 0000 050A                         else if(row==3){
	RJMP _0x18B
_0x18A:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x18C
; 0000 050B                         lcd_putsf("3.SKAMBEJIMAI");
	__POINTW1FN _0x0,238
	RJMP _0x4B9
; 0000 050C                         }
; 0000 050D                         else if(row==4){
_0x18C:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x18E
; 0000 050E                         lcd_putsf("4.NUSTATYMAI");
	__POINTW1FN _0x0,252
_0x4B9:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 050F                         }
; 0000 0510                     lcd_row++;
_0x18E:
_0x18B:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0511                     }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x184
_0x185:
; 0000 0512 
; 0000 0513                 lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0514                 lcd_putchar('<');
; 0000 0515                 }
; 0000 0516             }
_0x182:
; 0000 0517 
; 0000 0518             // Laikas
; 0000 0519             else if(Address[0]==1){
	JMP  _0x18F
_0x17C:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x190
; 0000 051A                 if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BRNE _0x191
; 0000 051B                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x192
; 0000 051C                         if(SelectedRow<2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRSH _0x193
; 0000 051D                         SelectedRow = 2;
	LDI  R30,LOW(2)
	STS  _SelectedRow_G000,R30
; 0000 051E                         }
; 0000 051F                     }
_0x193:
; 0000 0520                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x194
_0x192:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x195
; 0000 0521                         if(SelectedRow>0){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRLO _0x196
; 0000 0522                         SelectedRow = 0;
	LDI  R30,LOW(0)
	STS  _SelectedRow_G000,R30
; 0000 0523                         }
; 0000 0524                     }
_0x196:
; 0000 0525                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x197
_0x195:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x198
; 0000 0526                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x199
; 0000 0527                         Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
; 0000 0528                         }
; 0000 0529                         else{
	RJMP _0x19A
_0x199:
; 0000 052A                         Address[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 052B                         }
_0x19A:
; 0000 052C                     SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 052D                     Address[5] = 0;
; 0000 052E                     }
; 0000 052F                 }
_0x198:
_0x197:
_0x194:
; 0000 0530                 else{
	RJMP _0x19B
_0x191:
; 0000 0531                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x19C
; 0000 0532                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x19D
; 0000 0533                             if(RealTimeHour-10>=0){
	CALL SUBOPT_0x7A
	SBIW R30,10
	TST  R31
	BRMI _0x19E
; 0000 0534                             RealTimeHour += -10;
	LDI  R30,LOW(246)
	ADD  R6,R30
; 0000 0535                             }
; 0000 0536                         }
_0x19E:
; 0000 0537                         else if(Address[1]==2){
	RJMP _0x19F
_0x19D:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x1A0
; 0000 0538                             if(RealTimeHour-1>=0){
	MOV  R30,R6
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x1A1
; 0000 0539                             RealTimeHour += -1;
	LDI  R30,LOW(255)
	ADD  R6,R30
; 0000 053A                             }
; 0000 053B                         }
_0x1A1:
; 0000 053C                         else if(Address[1]==3){
	RJMP _0x1A2
_0x1A0:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x1A3
; 0000 053D                             if(RealTimeMinute-10>=0){
	CALL SUBOPT_0x7B
	SBIW R30,10
	TST  R31
	BRMI _0x1A4
; 0000 053E                             RealTimeMinute += -10;
	LDI  R30,LOW(246)
	ADD  R9,R30
; 0000 053F                             }
; 0000 0540                         }
_0x1A4:
; 0000 0541                         else if(Address[1]==4){
	RJMP _0x1A5
_0x1A3:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x1A6
; 0000 0542                             if(RealTimeMinute-1>=0){
	MOV  R30,R9
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x1A7
; 0000 0543                             RealTimeMinute += -1;
	LDI  R30,LOW(255)
	ADD  R9,R30
; 0000 0544                             }
; 0000 0545                         }
_0x1A7:
; 0000 0546                     }
_0x1A6:
_0x1A5:
_0x1A2:
_0x19F:
; 0000 0547                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x1A8
_0x19C:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x1A9
; 0000 0548                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x1AA
; 0000 0549                             if(RealTimeHour+10<24){
	CALL SUBOPT_0x7A
	ADIW R30,10
	SBIW R30,24
	BRGE _0x1AB
; 0000 054A                             RealTimeHour += 10;
	LDI  R30,LOW(10)
	ADD  R6,R30
; 0000 054B                             }
; 0000 054C                         }
_0x1AB:
; 0000 054D                         else if(Address[1]==2){
	RJMP _0x1AC
_0x1AA:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x1AD
; 0000 054E                             if(RealTimeHour+1<24){
	CALL SUBOPT_0x7A
	ADIW R30,1
	SBIW R30,24
	BRGE _0x1AE
; 0000 054F                             RealTimeHour += 1;
	INC  R6
; 0000 0550                             }
; 0000 0551                         }
_0x1AE:
; 0000 0552                         else if(Address[1]==3){
	RJMP _0x1AF
_0x1AD:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x1B0
; 0000 0553                             if(RealTimeMinute+10<60){
	CALL SUBOPT_0x7B
	ADIW R30,10
	SBIW R30,60
	BRGE _0x1B1
; 0000 0554                             RealTimeMinute += 10;
	LDI  R30,LOW(10)
	ADD  R9,R30
; 0000 0555                             }
; 0000 0556                         }
_0x1B1:
; 0000 0557                         else if(Address[1]==4){
	RJMP _0x1B2
_0x1B0:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x1B3
; 0000 0558                             if(RealTimeMinute+1<60){
	CALL SUBOPT_0x7B
	ADIW R30,1
	SBIW R30,60
	BRGE _0x1B4
; 0000 0559                             RealTimeMinute += 1;
	INC  R9
; 0000 055A                             }
; 0000 055B                         }
_0x1B4:
; 0000 055C                     }
_0x1B3:
_0x1B2:
_0x1AF:
_0x1AC:
; 0000 055D                     else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x1B5
_0x1A9:
	__GETB2MN _BUTTON_S000000E001,1
	CPI  R26,LOW(0x1)
	BRNE _0x1B6
; 0000 055E                         if(Address[1]>1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRLO _0x1B7
; 0000 055F                         Address[1]--;
	__GETB1MN _Address_G000,1
	SUBI R30,LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 0560                         }
; 0000 0561                     }
_0x1B7:
; 0000 0562                     else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x1B8
_0x1B6:
	__GETB2MN _BUTTON_S000000E001,3
	CPI  R26,LOW(0x1)
	BRNE _0x1B9
; 0000 0563                         if(Address[1]<4){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRSH _0x1BA
; 0000 0564                         Address[1]++;
	__GETB1MN _Address_G000,1
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 0565                         }
; 0000 0566                     }
_0x1BA:
; 0000 0567                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x1BB
_0x1B9:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x1BC
; 0000 0568                     Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 0569                     SelectedRow = 0;
; 0000 056A                     Address[5] = 0;
; 0000 056B                     }
; 0000 056C                 }
_0x1BC:
_0x1BB:
_0x1B8:
_0x1B5:
_0x1A8:
_0x19B:
; 0000 056D 
; 0000 056E                 if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x1BD
; 0000 056F                 RowsOnWindow = 7;
	LDI  R30,LOW(7)
	STS  _RowsOnWindow_G000,R30
; 0000 0570 
; 0000 0571                 lcd_putsf("     -=LAIKAS=-     ");
	__POINTW1FN _0x0,265
	CALL SUBOPT_0x2E
; 0000 0572                 lcd_putsf("LAIKAS: ");
	CALL SUBOPT_0x7D
; 0000 0573                 lcd_put_number(0,2,0,0,RealTimeHour,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0574                 lcd_putsf(":");
	CALL SUBOPT_0x52
; 0000 0575                 lcd_put_number(0,2,0,0,RealTimeMinute,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x53
; 0000 0576                 lcd_putsf(":");
	CALL SUBOPT_0x52
; 0000 0577                     if(Address[1]>0){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRLO _0x1BE
; 0000 0578                     RealTimeSecond = 0;
	CLR  R11
; 0000 0579                     }
; 0000 057A                 lcd_put_number(0,2,0,0,RealTimeSecond,0);
_0x1BE:
	CALL SUBOPT_0x50
	CALL SUBOPT_0x54
; 0000 057B                 lcd_putsf("    ");
	CALL SUBOPT_0x5A
; 0000 057C 
; 0000 057D                     if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BRNE _0x1BF
; 0000 057E                     lcd_putsf("      REDAGUOTI?");
	__POINTW1FN _0x0,286
	CALL SUBOPT_0x2E
; 0000 057F                     lcd_gotoxy(19,SelectedRow);
	CALL SUBOPT_0x7E
; 0000 0580                     lcd_putchar('<');
; 0000 0581                     }
; 0000 0582                     else{
	RJMP _0x1C0
_0x1BF:
; 0000 0583                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x1C1
; 0000 0584                         lcd_putsf("        ^");
	__POINTW1FN _0x0,303
	RJMP _0x4BA
; 0000 0585                         }
; 0000 0586                         else if(Address[1]==2){
_0x1C1:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x1C3
; 0000 0587                         lcd_putsf("         ^");
	__POINTW1FN _0x0,313
	RJMP _0x4BA
; 0000 0588                         }
; 0000 0589                         else if(Address[1]==3){
_0x1C3:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x1C5
; 0000 058A                         lcd_putsf("           ^");
	__POINTW1FN _0x0,324
	RJMP _0x4BA
; 0000 058B                         }
; 0000 058C                         else if(Address[1]==4){
_0x1C5:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x1C7
; 0000 058D                         lcd_putsf("            ^");
	__POINTW1FN _0x0,337
_0x4BA:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 058E                         }
; 0000 058F                     rtc_set_time(RealTimeHour, RealTimeMinute, RealTimeSecond);
_0x1C7:
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R11
	CALL _rtc_set_time
; 0000 0590                     }
_0x1C0:
; 0000 0591 
; 0000 0592 
; 0000 0593                     if(SUMMER_TIME_TURNED_ON==1){
	CALL SUBOPT_0x35
	CPI  R30,LOW(0x1)
	BRNE _0x1C8
; 0000 0594                     lcd_gotoxy(0,3);
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
; 0000 0595                         if(IS_CLOCK_SUMMER==0){
	CALL SUBOPT_0x36
	CPI  R30,0
	BRNE _0x1C9
; 0000 0596                         lcd_putsf("(ZIEMOS LAIKAS)");
	__POINTW1FN _0x0,351
	RJMP _0x4BB
; 0000 0597                         }
; 0000 0598                         else{
_0x1C9:
; 0000 0599                         lcd_putsf("(VASAROS LAIKAS)");
	__POINTW1FN _0x0,367
_0x4BB:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 059A                         }
; 0000 059B                     }
; 0000 059C                 }
_0x1C8:
; 0000 059D             }
_0x1BD:
; 0000 059E 
; 0000 059F             // Data
; 0000 05A0             else if(Address[0]==2){
	JMP  _0x1CB
_0x190:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x1CC
; 0000 05A1                 if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BRNE _0x1CD
; 0000 05A2                     if(BUTTON[BUTTON_UP]==1){
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x1CE
; 0000 05A3                     SelectedRow = 0;
	LDI  R30,LOW(0)
	STS  _SelectedRow_G000,R30
; 0000 05A4                     }
; 0000 05A5                     else if(BUTTON[BUTTON_DOWN]==1){
	RJMP _0x1CF
_0x1CE:
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x1D0
; 0000 05A6                     SelectedRow = 3;
	LDI  R30,LOW(3)
	STS  _SelectedRow_G000,R30
; 0000 05A7                     }
; 0000 05A8                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x1D1
_0x1D0:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x1D2
; 0000 05A9                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x1D3
; 0000 05AA                         Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
; 0000 05AB                         }
; 0000 05AC                         else{
	RJMP _0x1D4
_0x1D3:
; 0000 05AD                         Address[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 05AE                         }
_0x1D4:
; 0000 05AF                     SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 05B0                     Address[5] = 0;
; 0000 05B1                     }
; 0000 05B2                 }
_0x1D2:
_0x1D1:
_0x1CF:
; 0000 05B3                 else{
	RJMP _0x1D5
_0x1CD:
; 0000 05B4                     if(BUTTON[BUTTON_UP]==1){
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x1D6
; 0000 05B5                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x1D7
; 0000 05B6                             if(RealTimeYear<90){
	LDI  R30,LOW(90)
	CP   R5,R30
	BRSH _0x1D8
; 0000 05B7                             RealTimeYear +=10;
	LDI  R30,LOW(10)
	ADD  R5,R30
; 0000 05B8                             }
; 0000 05B9                         }
_0x1D8:
; 0000 05BA                         else if(Address[1]==2){
	RJMP _0x1D9
_0x1D7:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x1DA
; 0000 05BB                             if(RealTimeYear<99){
	LDI  R30,LOW(99)
	CP   R5,R30
	BRSH _0x1DB
; 0000 05BC                             RealTimeYear +=1;
	INC  R5
; 0000 05BD                             }
; 0000 05BE                         }
_0x1DB:
; 0000 05BF                         else if(Address[1]==3){
	RJMP _0x1DC
_0x1DA:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x1DD
; 0000 05C0                             if(RealTimeMonth<=2){
	LDI  R30,LOW(2)
	CP   R30,R4
	BRLO _0x1DE
; 0000 05C1                             RealTimeMonth +=10;
	LDI  R30,LOW(10)
	ADD  R4,R30
; 0000 05C2                             }
; 0000 05C3                         }
_0x1DE:
; 0000 05C4                         else if(Address[1]==4){
	RJMP _0x1DF
_0x1DD:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x1E0
; 0000 05C5                             if(RealTimeMonth<12){
	LDI  R30,LOW(12)
	CP   R4,R30
	BRSH _0x1E1
; 0000 05C6                             RealTimeMonth +=1;
	INC  R4
; 0000 05C7                             }
; 0000 05C8                         }
_0x1E1:
; 0000 05C9                         else if(Address[1]==5){
	RJMP _0x1E2
_0x1E0:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x5)
	BRNE _0x1E3
; 0000 05CA                             if(RealTimeDay<=DayCountInMonth(RealTimeYear,RealTimeMonth)-10){
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x80
	MOV  R26,R7
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x1E4
; 0000 05CB                             RealTimeDay += 10;
	LDI  R30,LOW(10)
	ADD  R7,R30
; 0000 05CC                             }
; 0000 05CD                         }
_0x1E4:
; 0000 05CE                         else if(Address[1]==6){
	RJMP _0x1E5
_0x1E3:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x6)
	BRNE _0x1E6
; 0000 05CF                             if(RealTimeDay<DayCountInMonth(RealTimeYear,RealTimeMonth)){
	CALL SUBOPT_0x7F
	CP   R7,R30
	BRSH _0x1E7
; 0000 05D0                             RealTimeDay += 1;
	INC  R7
; 0000 05D1                             }
; 0000 05D2                         }
_0x1E7:
; 0000 05D3                         else if(Address[1]==7){
	RJMP _0x1E8
_0x1E6:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x7)
	BRNE _0x1E9
; 0000 05D4                             if(RealTimeWeekDay<7){
	LDI  R30,LOW(7)
	CP   R8,R30
	BRSH _0x1EA
; 0000 05D5                             RealTimeWeekDay += 1;
	INC  R8
; 0000 05D6                             }
; 0000 05D7                         }
_0x1EA:
; 0000 05D8                     }
_0x1E9:
_0x1E8:
_0x1E5:
_0x1E2:
_0x1DF:
_0x1DC:
_0x1D9:
; 0000 05D9                     else if(BUTTON[BUTTON_DOWN]==1){
	RJMP _0x1EB
_0x1D6:
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x1EC
; 0000 05DA                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x1ED
; 0000 05DB                             if(RealTimeYear>=10){
	LDI  R30,LOW(10)
	CP   R5,R30
	BRLO _0x1EE
; 0000 05DC                             RealTimeYear += -10;
	LDI  R30,LOW(246)
	ADD  R5,R30
; 0000 05DD                             }
; 0000 05DE                         }
_0x1EE:
; 0000 05DF                         else if(Address[1]==2){
	RJMP _0x1EF
_0x1ED:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x1F0
; 0000 05E0                             if(RealTimeYear>0){
	LDI  R30,LOW(0)
	CP   R30,R5
	BRSH _0x1F1
; 0000 05E1                             RealTimeYear += -1;
	LDI  R30,LOW(255)
	ADD  R5,R30
; 0000 05E2                             }
; 0000 05E3                         }
_0x1F1:
; 0000 05E4                         else if(Address[1]==3){
	RJMP _0x1F2
_0x1F0:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x1F3
; 0000 05E5                             if(RealTimeMonth>10){
	LDI  R30,LOW(10)
	CP   R30,R4
	BRSH _0x1F4
; 0000 05E6                             RealTimeMonth += -10;
	LDI  R30,LOW(246)
	ADD  R4,R30
; 0000 05E7                             }
; 0000 05E8                         }
_0x1F4:
; 0000 05E9                         else if(Address[1]==4){
	RJMP _0x1F5
_0x1F3:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x1F6
; 0000 05EA                             if(RealTimeMonth>1){
	LDI  R30,LOW(1)
	CP   R30,R4
	BRSH _0x1F7
; 0000 05EB                             RealTimeMonth += -1;
	LDI  R30,LOW(255)
	ADD  R4,R30
; 0000 05EC                             }
; 0000 05ED                         }
_0x1F7:
; 0000 05EE                         else if(Address[1]==5){
	RJMP _0x1F8
_0x1F6:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x5)
	BRNE _0x1F9
; 0000 05EF                             if(RealTimeDay>10){
	LDI  R30,LOW(10)
	CP   R30,R7
	BRSH _0x1FA
; 0000 05F0                             RealTimeDay += -10;
	LDI  R30,LOW(246)
	ADD  R7,R30
; 0000 05F1                             }
; 0000 05F2                         }
_0x1FA:
; 0000 05F3                         else if(Address[1]==6){
	RJMP _0x1FB
_0x1F9:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x6)
	BRNE _0x1FC
; 0000 05F4                             if(RealTimeDay>1){
	LDI  R30,LOW(1)
	CP   R30,R7
	BRSH _0x1FD
; 0000 05F5                             RealTimeDay += -1;
	LDI  R30,LOW(255)
	ADD  R7,R30
; 0000 05F6                             }
; 0000 05F7                         }
_0x1FD:
; 0000 05F8                         else if(Address[1]==7){
	RJMP _0x1FE
_0x1FC:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x7)
	BRNE _0x1FF
; 0000 05F9                             if(RealTimeWeekDay>1){
	LDI  R30,LOW(1)
	CP   R30,R8
	BRSH _0x200
; 0000 05FA                             RealTimeWeekDay += -1;
	LDI  R30,LOW(255)
	ADD  R8,R30
; 0000 05FB                             }
; 0000 05FC                         }
_0x200:
; 0000 05FD 
; 0000 05FE                     }
_0x1FF:
_0x1FE:
_0x1FB:
_0x1F8:
_0x1F5:
_0x1F2:
_0x1EF:
; 0000 05FF                     else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x201
_0x1EC:
	__GETB2MN _BUTTON_S000000E001,1
	CPI  R26,LOW(0x1)
	BRNE _0x202
; 0000 0600                         if(Address[1]>1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRLO _0x203
; 0000 0601                         Address[1]--;
	__GETB1MN _Address_G000,1
	SUBI R30,LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 0602                         }
; 0000 0603                     }
_0x203:
; 0000 0604                     else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x204
_0x202:
	__GETB2MN _BUTTON_S000000E001,3
	CPI  R26,LOW(0x1)
	BRNE _0x205
; 0000 0605                         if(Address[1]<7){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x7)
	BRSH _0x206
; 0000 0606                         Address[1]++;
	__GETB1MN _Address_G000,1
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 0607                         }
; 0000 0608                     }
_0x206:
; 0000 0609                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x207
_0x205:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x208
; 0000 060A                     Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 060B                     SelectedRow = 0;
; 0000 060C                     Address[5] = 0;
; 0000 060D                     }
; 0000 060E 
; 0000 060F                     if(DayCountInMonth(RealTimeYear, RealTimeMonth)<RealTimeDay){
_0x208:
_0x207:
_0x204:
_0x201:
_0x1EB:
	CALL SUBOPT_0x7F
	CP   R30,R7
	BRSH _0x209
; 0000 0610                     RealTimeDay = DayCountInMonth(RealTimeYear, RealTimeMonth);
	CALL SUBOPT_0x7F
	MOV  R7,R30
; 0000 0611                     }
; 0000 0612                 }
_0x209:
_0x1D5:
; 0000 0613 
; 0000 0614                 if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x20A
; 0000 0615                 lcd_putsf(" -=NUSTATYTI DATA=- ");
	__POINTW1FN _0x0,384
	CALL SUBOPT_0x2E
; 0000 0616 
; 0000 0617 
; 0000 0618                     if(RealTimeWeekDay==1){
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0x20B
; 0000 0619                     lcd_putsf("SAV.DIENA: PIRMAD.  ");
	__POINTW1FN _0x0,405
	RJMP _0x4BC
; 0000 061A                     }
; 0000 061B                     else if(RealTimeWeekDay==2){
_0x20B:
	LDI  R30,LOW(2)
	CP   R30,R8
	BRNE _0x20D
; 0000 061C                     lcd_putsf("SAV.DIENA: ANTRAD.  ");
	__POINTW1FN _0x0,426
	RJMP _0x4BC
; 0000 061D                     }
; 0000 061E                     else if(RealTimeWeekDay==3){
_0x20D:
	LDI  R30,LOW(3)
	CP   R30,R8
	BRNE _0x20F
; 0000 061F                     lcd_putsf("SAV.DIENA: TRECIAD. ");
	__POINTW1FN _0x0,447
	RJMP _0x4BC
; 0000 0620                     }
; 0000 0621                     else if(RealTimeWeekDay==4){
_0x20F:
	LDI  R30,LOW(4)
	CP   R30,R8
	BRNE _0x211
; 0000 0622                     lcd_putsf("SAV.DIENA: KETVIRT. ");
	__POINTW1FN _0x0,468
	RJMP _0x4BC
; 0000 0623                     }
; 0000 0624                     else if(RealTimeWeekDay==5){
_0x211:
	LDI  R30,LOW(5)
	CP   R30,R8
	BRNE _0x213
; 0000 0625                     lcd_putsf("SAV.DIENA: PENKTAD. ");
	__POINTW1FN _0x0,489
	RJMP _0x4BC
; 0000 0626                     }
; 0000 0627                     else if(RealTimeWeekDay==6){
_0x213:
	LDI  R30,LOW(6)
	CP   R30,R8
	BRNE _0x215
; 0000 0628                     lcd_putsf("SAV.DIENA: SESTAD.  ");
	__POINTW1FN _0x0,510
	RJMP _0x4BC
; 0000 0629                     }
; 0000 062A                     else if(RealTimeWeekDay==7){
_0x215:
	LDI  R30,LOW(7)
	CP   R30,R8
	BRNE _0x217
; 0000 062B                     lcd_putsf("SAV.DIENA: SEKMAD.  ");
	__POINTW1FN _0x0,531
	RJMP _0x4BC
; 0000 062C                     }
; 0000 062D                     else{
_0x217:
; 0000 062E                     lcd_putsf("???                 ");
	__POINTW1FN _0x0,552
_0x4BC:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 062F                     }
; 0000 0630 
; 0000 0631                 lcd_putsf("DATA: 2");
	__POINTW1FN _0x0,573
	CALL SUBOPT_0x2E
; 0000 0632                 lcd_put_number(0,3,0,0,RealTimeYear,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x56
; 0000 0633                 lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0634                 lcd_put_number(0,2,0,0,RealTimeMonth,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x58
; 0000 0635                 lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0636                 lcd_put_number(0,2,0,0,RealTimeDay,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x59
; 0000 0637                 lcd_putsf("    ");
	CALL SUBOPT_0x5A
; 0000 0638 
; 0000 0639                     if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BRNE _0x219
; 0000 063A                     lcd_putsf("      REDAGUOTI?    ");
	CALL SUBOPT_0x81
; 0000 063B                     }
; 0000 063C                     else{
	RJMP _0x21A
_0x219:
; 0000 063D                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x21B
; 0000 063E                         lcd_putsf("        ^           ");
	__POINTW1FN _0x0,602
	RJMP _0x4BD
; 0000 063F                         }
; 0000 0640                         else if(Address[1]==2){
_0x21B:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x21D
; 0000 0641                         lcd_putsf("         ^          ");
	__POINTW1FN _0x0,623
	RJMP _0x4BD
; 0000 0642                         }
; 0000 0643 
; 0000 0644                         else if(Address[1]==3){
_0x21D:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x21F
; 0000 0645                         lcd_putsf("           ^        ");
	__POINTW1FN _0x0,644
	RJMP _0x4BD
; 0000 0646                         }
; 0000 0647                         else if(Address[1]==4){
_0x21F:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x221
; 0000 0648                         lcd_putsf("            ^       ");
	__POINTW1FN _0x0,665
	RJMP _0x4BD
; 0000 0649                         }
; 0000 064A 
; 0000 064B                         else if(Address[1]==5){
_0x221:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x5)
	BRNE _0x223
; 0000 064C                         lcd_putsf("              ^     ");
	__POINTW1FN _0x0,686
	RJMP _0x4BD
; 0000 064D                         }
; 0000 064E                         else if(Address[1]==6){
_0x223:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x6)
	BRNE _0x225
; 0000 064F                         lcd_putsf("               ^    ");
	__POINTW1FN _0x0,707
	RJMP _0x4BD
; 0000 0650                         }
; 0000 0651                         else if(Address[1]==7){
_0x225:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x7)
	BRNE _0x227
; 0000 0652                         lcd_gotoxy(16, 2);
	LDI  R30,LOW(16)
	CALL SUBOPT_0x55
; 0000 0653                         lcd_putchar('^');
	CALL SUBOPT_0x4D
; 0000 0654                         lcd_gotoxy(0, 3);
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
; 0000 0655                         lcd_putsf("                |   ");
	__POINTW1FN _0x0,728
_0x4BD:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0656                         }
; 0000 0657                     rtc_set_date(RealTimeDay, RealTimeMonth, RealTimeYear);
_0x227:
	ST   -Y,R7
	ST   -Y,R4
	ST   -Y,R5
	CALL _rtc_set_date
; 0000 0658                     rtc_write(0x03, RealTimeWeekDay);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R8
	CALL _rtc_write
; 0000 0659                     }
_0x21A:
; 0000 065A 
; 0000 065B                     if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BRNE _0x228
; 0000 065C                     lcd_gotoxy(19,SelectedRow);
	CALL SUBOPT_0x7E
; 0000 065D                     lcd_putchar('<');
; 0000 065E                     }
; 0000 065F                 }
_0x228:
; 0000 0660             }
_0x20A:
; 0000 0661 
; 0000 0662             // Skambejimai
; 0000 0663             else if(Address[0]==3){
	JMP  _0x229
_0x1CC:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0x22A
; 0000 0664             // SKAMBEJIMU MENIU
; 0000 0665                 if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BREQ PC+3
	JMP _0x22B
; 0000 0666                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x22C
; 0000 0667                     SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0668                     }
; 0000 0669                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x22D
_0x22C:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x22E
; 0000 066A                     SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 066B                     }
; 0000 066C                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x22F
_0x22E:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x230
; 0000 066D                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x231
; 0000 066E                         Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
; 0000 066F                         }
; 0000 0670                         else{
	RJMP _0x232
_0x231:
; 0000 0671                         Address[1] = SelectedRow;
	LDS  R30,_SelectedRow_G000
	__PUTB1MN _Address_G000,1
; 0000 0672                         }
_0x232:
; 0000 0673                     SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0674                     Address[5] = 0;
; 0000 0675                     }
; 0000 0676 
; 0000 0677                     if(RefreshLcd>=1){
_0x230:
_0x22F:
_0x22D:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x233
; 0000 0678                     unsigned char row, lcd_row;
; 0000 0679                     lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 067A                     RowsOnWindow = 4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x75
; 0000 067B                         for(row=Address[5];row<4+Address[5];row++){
_0x235:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRGE _0x236
; 0000 067C                         lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 067D 
; 0000 067E                             if(row==0){
	BRNE _0x237
; 0000 067F                             lcd_putsf("  -=SKAMBEJIMAI=-");
	__POINTW1FN _0x0,749
	RJMP _0x4BE
; 0000 0680                             }
; 0000 0681                             else if(row==1){
_0x237:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x239
; 0000 0682                             lcd_putsf("1.EILINIS LAIKAS");
	__POINTW1FN _0x0,767
	RJMP _0x4BE
; 0000 0683                             }
; 0000 0684                             else if(row==2){
_0x239:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x23B
; 0000 0685                             lcd_putsf("2.VELYKU LAIKAS");
	__POINTW1FN _0x0,784
	RJMP _0x4BE
; 0000 0686                             }
; 0000 0687                             else if(row==3){
_0x23B:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x23D
; 0000 0688                             lcd_putsf("3.KALEDU LAIKAS");
	__POINTW1FN _0x0,800
_0x4BE:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0689                             }
; 0000 068A 
; 0000 068B                         lcd_row++;
_0x23D:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 068C                         }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x235
_0x236:
; 0000 068D 
; 0000 068E                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 068F                     lcd_putchar('<');
; 0000 0690                     }
; 0000 0691                 }
_0x233:
; 0000 0692             /////////////////////
; 0000 0693 
; 0000 0694             // EILINIO LAIKO MENIU
; 0000 0695                 else if(Address[1]==1){
	JMP  _0x23E
_0x22B:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x23F
; 0000 0696                     if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BREQ PC+3
	JMP _0x240
; 0000 0697                         if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x241
; 0000 0698                         SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0699                         }
; 0000 069A                         else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x242
_0x241:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x243
; 0000 069B                         SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 069C                         }
; 0000 069D                         else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x244
_0x243:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x245
; 0000 069E                             if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x246
; 0000 069F                             Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 06A0                             }
; 0000 06A1                             else{
	RJMP _0x247
_0x246:
; 0000 06A2                             Address[2] = SelectedRow;
	CALL SUBOPT_0x82
; 0000 06A3                             }
_0x247:
; 0000 06A4                         SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 06A5                         Address[5] = 0;
; 0000 06A6                         }
; 0000 06A7 
; 0000 06A8 
; 0000 06A9                         if(RefreshLcd>=1){
_0x245:
_0x244:
_0x242:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x248
; 0000 06AA                         unsigned char row, lcd_row;
; 0000 06AB                         lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 06AC                         RowsOnWindow = 8;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x75
; 0000 06AD                             for(row=Address[5];row<4+Address[5];row++){
_0x24A:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRGE _0x24B
; 0000 06AE                             lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 06AF 
; 0000 06B0                                 if(row==0){
	BRNE _0x24C
; 0000 06B1                                 lcd_putsf(" -=EILINIS LAIKAS=-");
	__POINTW1FN _0x0,816
	RJMP _0x4BF
; 0000 06B2                                 }
; 0000 06B3                                 else if(row==1){
_0x24C:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x24E
; 0000 06B4                                 lcd_putsf("1.PIRMAD. LAIKAS");
	__POINTW1FN _0x0,836
	RJMP _0x4BF
; 0000 06B5                                 }
; 0000 06B6                                 else if(row==2){
_0x24E:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x250
; 0000 06B7                                 lcd_putsf("2.ANTRAD. LAIKAS");
	__POINTW1FN _0x0,853
	RJMP _0x4BF
; 0000 06B8                                 }
; 0000 06B9                                 else if(row==3){
_0x250:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x252
; 0000 06BA                                 lcd_putsf("3.TRECIAD. LAIKAS");
	__POINTW1FN _0x0,870
	RJMP _0x4BF
; 0000 06BB                                 }
; 0000 06BC                                 else if(row==4){
_0x252:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x254
; 0000 06BD                                 lcd_putsf("4.KETVIRTAD. LAIKAS");
	__POINTW1FN _0x0,888
	RJMP _0x4BF
; 0000 06BE                                 }
; 0000 06BF                                 else if(row==5){
_0x254:
	LDD  R26,Y+1
	CPI  R26,LOW(0x5)
	BRNE _0x256
; 0000 06C0                                 lcd_putsf("5.PENKTAD. LAIKAS");
	__POINTW1FN _0x0,908
	RJMP _0x4BF
; 0000 06C1                                 }
; 0000 06C2                                 else if(row==6){
_0x256:
	LDD  R26,Y+1
	CPI  R26,LOW(0x6)
	BRNE _0x258
; 0000 06C3                                 lcd_putsf("6.SESTAD. LAIKAS");
	__POINTW1FN _0x0,926
	RJMP _0x4BF
; 0000 06C4                                 }
; 0000 06C5                                 else if(row==7){
_0x258:
	LDD  R26,Y+1
	CPI  R26,LOW(0x7)
	BRNE _0x25A
; 0000 06C6                                 lcd_putsf("7.SEKMAD. LAIKAS");
	__POINTW1FN _0x0,943
_0x4BF:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 06C7                                 }
; 0000 06C8 
; 0000 06C9                             lcd_row++;
_0x25A:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 06CA                             }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x24A
_0x24B:
; 0000 06CB 
; 0000 06CC                         lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 06CD                         lcd_putchar('<');
; 0000 06CE                         }
; 0000 06CF                     }
_0x248:
; 0000 06D0                     else if( (Address[2]>=1)&&(Address[2]<=7) ){
	RJMP _0x25B
_0x240:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRLO _0x25D
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x8)
	BRLO _0x25E
_0x25D:
	RJMP _0x25C
_0x25E:
; 0000 06D1                         if(Address[3]==0){
	__GETB1MN _Address_G000,3
	CPI  R30,0
	BREQ PC+3
	JMP _0x25F
; 0000 06D2                             if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x260
; 0000 06D3                             SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 06D4                             }
; 0000 06D5                             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x261
_0x260:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x262
; 0000 06D6                             SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 06D7                             }
; 0000 06D8                             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x263
_0x262:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x264
; 0000 06D9                                 if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x265
; 0000 06DA                                 Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
; 0000 06DB                                 }
; 0000 06DC                                 else if(SelectedRow>=1){
	RJMP _0x266
_0x265:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRLO _0x267
; 0000 06DD                                 unsigned char id;
; 0000 06DE                                 id = GetBellId(Address[2]-1, SelectedRow-1);
	SBIW R28,1
;	id -> Y+0
	CALL SUBOPT_0x83
	ST   -Y,R30
	LDS  R30,_SelectedRow_G000
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x84
; 0000 06DF                                     if(id==255){
	LD   R26,Y
	CPI  R26,LOW(0xFF)
	BRNE _0x268
; 0000 06E0                                     id = GetFreeBellId(Address[2]-1);
	CALL SUBOPT_0x83
	ST   -Y,R30
	CALL _GetFreeBellId
	ST   Y,R30
; 0000 06E1                                     Address[3] = id+1;
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,3
; 0000 06E2                                     }
; 0000 06E3                                 Address[3] = id+1;
_0x268:
	LD   R30,Y
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,3
; 0000 06E4                                 }
	ADIW R28,1
; 0000 06E5                             SelectedRow = 0;
_0x267:
_0x266:
	CALL SUBOPT_0x74
; 0000 06E6                             Address[5] = 0;
; 0000 06E7                             }
; 0000 06E8 
; 0000 06E9                             if(RefreshLcd>=1){
_0x264:
_0x263:
_0x261:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x269
; 0000 06EA                             unsigned char row, lcd_row;
; 0000 06EB                             lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 06EC                             RowsOnWindow = BELL_COUNT + 1;
	LDI  R30,LOW(21)
	CALL SUBOPT_0x75
; 0000 06ED                                 for(row=Address[5];row<4+Address[5];row++){
_0x26B:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRLT PC+3
	JMP _0x26C
; 0000 06EE                                 lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 06EF 
; 0000 06F0                                     if(row==0){
	BRNE _0x26D
; 0000 06F1                                         if(Address[2]==1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x26E
; 0000 06F2                                         lcd_putsf("  -=PIRMADIENIS=-");
	__POINTW1FN _0x0,960
	RJMP _0x4C0
; 0000 06F3                                         }
; 0000 06F4                                         else if(Address[2]==2){
_0x26E:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x270
; 0000 06F5                                         lcd_putsf("  -=ANTRADIENIS=-");
	__POINTW1FN _0x0,978
	RJMP _0x4C0
; 0000 06F6                                         }
; 0000 06F7                                         else if(Address[2]==3){
_0x270:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x272
; 0000 06F8                                         lcd_putsf("  -=TRECIADIENIS=-");
	__POINTW1FN _0x0,996
	RJMP _0x4C0
; 0000 06F9                                         }
; 0000 06FA                                         else if(Address[2]==4){
_0x272:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x274
; 0000 06FB                                         lcd_putsf(" -=KETVIRTADIENIS=-");
	__POINTW1FN _0x0,1015
	RJMP _0x4C0
; 0000 06FC                                         }
; 0000 06FD                                         else if(Address[2]==5){
_0x274:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x5)
	BRNE _0x276
; 0000 06FE                                         lcd_putsf("  -=PENKTADIENIS=-");
	__POINTW1FN _0x0,1035
	RJMP _0x4C0
; 0000 06FF                                         }
; 0000 0700                                         else if(Address[2]==6){
_0x276:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x6)
	BRNE _0x278
; 0000 0701                                         lcd_putsf("  -=SESTADIENIS=-");
	__POINTW1FN _0x0,1054
	RJMP _0x4C0
; 0000 0702                                         }
; 0000 0703                                         else if(Address[2]==7){
_0x278:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x7)
	BRNE _0x27A
; 0000 0704                                         lcd_putsf("  -=SEKMADIENIS=-");
	__POINTW1FN _0x0,1072
_0x4C0:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0705                                         }
; 0000 0706                                     }
_0x27A:
; 0000 0707                                     else if(row>=1){
	RJMP _0x27B
_0x26D:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x27C
; 0000 0708                                         if(row<=BELL_COUNT){
	CPI  R26,LOW(0x15)
	BRSH _0x27D
; 0000 0709                                         unsigned char id;
; 0000 070A                                         id = GetBellId(Address[2]-1, row-1);
	SBIW R28,1
;	row -> Y+2
;	lcd_row -> Y+1
;	id -> Y+0
	CALL SUBOPT_0x83
	CALL SUBOPT_0x85
	CALL SUBOPT_0x84
; 0000 070B                                         lcd_put_number(0,2,0,0,row,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xA
	CALL SUBOPT_0x86
; 0000 070C                                         lcd_putsf(". ");
	CALL SUBOPT_0x87
; 0000 070D 
; 0000 070E                                             if(id!=255){
	LD   R26,Y
	CPI  R26,LOW(0xFF)
	BREQ _0x27E
; 0000 070F                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][id][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x83
	CALL SUBOPT_0x88
	CALL SUBOPT_0x19
	CALL SUBOPT_0x89
; 0000 0710                                             lcd_putchar(':');
	CALL SUBOPT_0x8A
; 0000 0711                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][id][1],0);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x88
	CALL SUBOPT_0x40
	CALL SUBOPT_0x89
; 0000 0712                                             lcd_putsf(" (");
	CALL SUBOPT_0x8B
; 0000 0713                                             lcd_put_number(0,3,0,0,BELL_TIME[Address[2]-1][id][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x83
	CALL SUBOPT_0x88
	CALL SUBOPT_0x41
	CALL SUBOPT_0x86
; 0000 0714                                             lcd_putsf("SEC)");
	__POINTW1FN _0x0,1093
	RJMP _0x4C1
; 0000 0715                                             }
; 0000 0716                                             else{
_0x27E:
; 0000 0717                                             lcd_putsf("TUSCIA");
	__POINTW1FN _0x0,1098
_0x4C1:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0718                                             }
; 0000 0719                                         }
	ADIW R28,1
; 0000 071A                                     }
_0x27D:
; 0000 071B 
; 0000 071C                                 lcd_row++;
_0x27C:
_0x27B:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 071D                                 }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x26B
_0x26C:
; 0000 071E 
; 0000 071F                             lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0720                             lcd_putchar('<');
; 0000 0721                             }
; 0000 0722                         }
_0x269:
; 0000 0723                         else{
	RJMP _0x280
_0x25F:
; 0000 0724                             if(Address[3]<=BELL_COUNT){
	__GETB2MN _Address_G000,3
	CPI  R26,LOW(0x15)
	BRLO PC+3
	JMP _0x281
; 0000 0725                                 if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x282
; 0000 0726                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x283
; 0000 0727                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x284
; 0000 0728                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x4C2
; 0000 0729                                         }
; 0000 072A                                         else if(SelectedRow==1){
_0x284:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x286
; 0000 072B                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x4C2
; 0000 072C                                         }
; 0000 072D                                         else if(SelectedRow==2){
_0x286:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x288
; 0000 072E                                         SelectedRow = 3;
	LDI  R30,LOW(3)
_0x4C2:
	STS  _SelectedRow_G000,R30
; 0000 072F                                         }
; 0000 0730                                     }
_0x288:
; 0000 0731                                     else if(Address[4]==1){
	RJMP _0x289
_0x283:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x28A
; 0000 0732                                         if(BELL_TIME[Address[2]-1][Address[3]-1][0]-10 >= 0){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x28B
; 0000 0733                                         BELL_TIME[Address[2]-1][Address[3]-1][0] += -10;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 0734                                         }
; 0000 0735                                     }
_0x28B:
; 0000 0736                                     else if(Address[4]==2){
	RJMP _0x28C
_0x28A:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x28D
; 0000 0737                                         if(BELL_TIME[Address[2]-1][Address[3]-1][0]-1 >= 0){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x28E
; 0000 0738                                         BELL_TIME[Address[2]-1][Address[3]-1][0] += -1;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 0739                                         }
; 0000 073A                                     }
_0x28E:
; 0000 073B                                     else if(Address[4]==3){
	RJMP _0x28F
_0x28D:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x290
; 0000 073C                                         if(BELL_TIME[Address[2]-1][Address[3]-1][1]-10 >= 0){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x291
; 0000 073D                                         BELL_TIME[Address[2]-1][Address[3]-1][1] += -10;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 073E                                         }
; 0000 073F                                     }
_0x291:
; 0000 0740                                     else if(Address[4]==4){
	RJMP _0x292
_0x290:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x293
; 0000 0741                                         if(BELL_TIME[Address[2]-1][Address[3]-1][1]-1 >= 0){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x294
; 0000 0742                                         BELL_TIME[Address[2]-1][Address[3]-1][1] += -1;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 0743                                         }
; 0000 0744                                     }
_0x294:
; 0000 0745                                     else if(Address[4]==5){
	RJMP _0x295
_0x293:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x296
; 0000 0746                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]-100 > 0){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x90
	BRGE _0x297
; 0000 0747                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += -100;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(156)
	CALL __EEPROMWRB
; 0000 0748                                         }
; 0000 0749                                     }
_0x297:
; 0000 074A                                     else if(Address[4]==6){
	RJMP _0x298
_0x296:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x299
; 0000 074B                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]-10 > 0){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x92
	BRGE _0x29A
; 0000 074C                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += -10;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 074D                                         }
; 0000 074E                                     }
_0x29A:
; 0000 074F                                     else if(Address[4]==7){
	RJMP _0x29B
_0x299:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x29C
; 0000 0750                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]-1 > 0){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	CALL SUBOPT_0x1E
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x29D
; 0000 0751                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += -1;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 0752                                         }
; 0000 0753                                     }
_0x29D:
; 0000 0754                                 }
_0x29C:
_0x29B:
_0x298:
_0x295:
_0x292:
_0x28F:
_0x28C:
_0x289:
; 0000 0755                                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x29E
_0x282:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x29F
; 0000 0756                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x2A0
; 0000 0757                                         if(SelectedRow==1){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x2A1
; 0000 0758                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x4C3
; 0000 0759                                         }
; 0000 075A                                         else if(SelectedRow==2){
_0x2A1:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x2A3
; 0000 075B                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x4C3
; 0000 075C                                         }
; 0000 075D                                         else if(SelectedRow==3){
_0x2A3:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x2A5
; 0000 075E                                         SelectedRow = 2;
	LDI  R30,LOW(2)
_0x4C3:
	STS  _SelectedRow_G000,R30
; 0000 075F                                         }
; 0000 0760                                     }
_0x2A5:
; 0000 0761                                     else if(Address[4]==1){
	RJMP _0x2A6
_0x2A0:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x2A7
; 0000 0762                                         if(BELL_TIME[Address[2]-1][Address[3]-1][0]+10 < 24){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x93
	SBIW R30,24
	BRGE _0x2A8
; 0000 0763                                         BELL_TIME[Address[2]-1][Address[3]-1][0] += 10;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 0764                                         }
; 0000 0765                                     }
_0x2A8:
; 0000 0766                                     else if(Address[4]==2){
	RJMP _0x2A9
_0x2A7:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x2AA
; 0000 0767                                         if(BELL_TIME[Address[2]-1][Address[3]-1][0]+1 < 24){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x94
	SBIW R30,24
	BRGE _0x2AB
; 0000 0768                                         BELL_TIME[Address[2]-1][Address[3]-1][0] += 1;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0769                                         }
; 0000 076A                                     }
_0x2AB:
; 0000 076B                                     else if(Address[4]==3){
	RJMP _0x2AC
_0x2AA:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x2AD
; 0000 076C                                         if(BELL_TIME[Address[2]-1][Address[3]-1][1]+10 < 60){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x93
	SBIW R30,60
	BRGE _0x2AE
; 0000 076D                                         BELL_TIME[Address[2]-1][Address[3]-1][1] += 10;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 076E                                         }
; 0000 076F                                     }
_0x2AE:
; 0000 0770                                     else if(Address[4]==4){
	RJMP _0x2AF
_0x2AD:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x2B0
; 0000 0771                                         if(BELL_TIME[Address[2]-1][Address[3]-1][1]+1 < 60){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x94
	SBIW R30,60
	BRGE _0x2B1
; 0000 0772                                         BELL_TIME[Address[2]-1][Address[3]-1][1] += 1;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0773                                         }
; 0000 0774                                     }
_0x2B1:
; 0000 0775                                     else if(Address[4]==5){
	RJMP _0x2B2
_0x2B0:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x2B3
; 0000 0776                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]+100 <= 255){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x95
	BRGE _0x2B4
; 0000 0777                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += 100;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(100)
	CALL __EEPROMWRB
; 0000 0778                                         }
; 0000 0779                                     }
_0x2B4:
; 0000 077A                                     else if(Address[4]==6){
	RJMP _0x2B5
_0x2B3:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x2B6
; 0000 077B                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]+10 <= 255){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x96
	BRGE _0x2B7
; 0000 077C                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += 10;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 077D                                         }
; 0000 077E                                     }
_0x2B7:
; 0000 077F                                     else if(Address[4]==7){
	RJMP _0x2B8
_0x2B6:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x2B9
; 0000 0780                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]+1 <= 255){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x97
	BRGE _0x2BA
; 0000 0781                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += 1;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0782                                         }
; 0000 0783                                     }
_0x2BA:
; 0000 0784                                 }
_0x2B9:
_0x2B8:
_0x2B5:
_0x2B2:
_0x2AF:
_0x2AC:
_0x2A9:
_0x2A6:
; 0000 0785                                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x2BB
_0x29F:
	__GETB2MN _BUTTON_S000000E001,1
	CPI  R26,LOW(0x1)
	BRNE _0x2BC
; 0000 0786                                     if(Address[4]>1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRLO _0x2BD
; 0000 0787                                     Address[4]--;
	CALL SUBOPT_0x98
; 0000 0788                                     }
; 0000 0789                                 }
_0x2BD:
; 0000 078A                                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x2BE
_0x2BC:
	__GETB2MN _BUTTON_S000000E001,3
	CPI  R26,LOW(0x1)
	BRNE _0x2BF
; 0000 078B                                     if(Address[4]>0){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRLO _0x2C0
; 0000 078C                                         if(Address[4]<7){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRSH _0x2C1
; 0000 078D                                         Address[4]++;
	CALL SUBOPT_0x99
; 0000 078E                                         }
; 0000 078F                                     }
_0x2C1:
; 0000 0790                                 }
_0x2C0:
; 0000 0791                                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x2C2
_0x2BF:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x2C3
; 0000 0792                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x2C4
; 0000 0793                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BREQ _0x4C4
; 0000 0794                                         Address[3] = 0;
; 0000 0795                                         }
; 0000 0796                                         else if(SelectedRow==2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x2C7
; 0000 0797                                         Address[4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,4
; 0000 0798                                         }
; 0000 0799                                         else if(SelectedRow==3){
	RJMP _0x2C8
_0x2C7:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x2C9
; 0000 079A                                         BELL_TIME[Address[2]-1][Address[3]-1][0] = 0;
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x9A
; 0000 079B                                         BELL_TIME[Address[2]-1][Address[3]-1][1] = 0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x9B
; 0000 079C                                         BELL_TIME[Address[2]-1][Address[3]-1][2] = 0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x1D
; 0000 079D                                         Address[3] = 0;
_0x4C4:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 079E                                         }
; 0000 079F                                     }
_0x2C9:
_0x2C8:
; 0000 07A0                                     else{
	RJMP _0x2CA
_0x2C4:
; 0000 07A1                                     Address[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,4
; 0000 07A2                                     }
_0x2CA:
; 0000 07A3                                 SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 07A4                                 Address[5] = 0;
; 0000 07A5                                 }
; 0000 07A6 
; 0000 07A7                                 if(RefreshLcd>=1){
_0x2C3:
_0x2C2:
_0x2BE:
_0x2BB:
_0x29E:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x2CB
; 0000 07A8                                 lcd_putsf(" -=LAIKO KEITIMAS=- ");
	CALL SUBOPT_0x9C
; 0000 07A9                                     if(BELL_TIME[Address[2]-1][Address[3]-1][0]>=24){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CPI  R30,LOW(0x18)
	BRSH _0x4C5
; 0000 07AA                                     BELL_TIME[Address[2]-1][Address[3]-1][0] = 0;
; 0000 07AB                                     BELL_TIME[Address[2]-1][Address[3]-1][1] = 0;
; 0000 07AC                                     BELL_TIME[Address[2]-1][Address[3]-1][2] = 0;
; 0000 07AD                                     }
; 0000 07AE                                     else if(BELL_TIME[Address[2]-1][Address[3]-1][1]>=60){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CPI  R30,LOW(0x3C)
	BRLO _0x2CE
; 0000 07AF                                     BELL_TIME[Address[2]-1][Address[3]-1][0] = 0;
_0x4C5:
	__GETB1MN _Address_G000,2
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x9A
; 0000 07B0                                     BELL_TIME[Address[2]-1][Address[3]-1][1] = 0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x9B
; 0000 07B1                                     BELL_TIME[Address[2]-1][Address[3]-1][2] = 0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x1D
; 0000 07B2                                     }
; 0000 07B3 
; 0000 07B4                                 lcd_putsf("LAIKAS: ");
_0x2CE:
	CALL SUBOPT_0x7D
; 0000 07B5                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][Address[3]-1][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x89
; 0000 07B6                                 lcd_putchar('.');
	CALL SUBOPT_0x29
; 0000 07B7                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][Address[3]-1][1],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x89
; 0000 07B8                                 lcd_putsf(" (");
	CALL SUBOPT_0x8B
; 0000 07B9                                 lcd_put_number(0,3,0,0,BELL_TIME[Address[2]-1][Address[3]-1][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x86
; 0000 07BA                                 lcd_putchar(')');lcd_putsf(" ");
	CALL SUBOPT_0x9D
; 0000 07BB 
; 0000 07BC 
; 0000 07BD                                     if(Address[4]==1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x2CF
; 0000 07BE                                     lcd_putsf("        ^");
	CALL SUBOPT_0x9E
; 0000 07BF                                     }
; 0000 07C0                                     else if(Address[4]==2){
	RJMP _0x2D0
_0x2CF:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x2D1
; 0000 07C1                                     lcd_putsf("         ^");
	CALL SUBOPT_0x9F
; 0000 07C2                                     }
; 0000 07C3                                     else if(Address[4]==3){
	RJMP _0x2D2
_0x2D1:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x2D3
; 0000 07C4                                     lcd_putsf("           ^");
	CALL SUBOPT_0xA0
; 0000 07C5                                     }
; 0000 07C6                                     else if(Address[4]==4){
	RJMP _0x2D4
_0x2D3:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x2D5
; 0000 07C7                                     lcd_putsf("            ^");
	CALL SUBOPT_0xA1
; 0000 07C8                                     }
; 0000 07C9                                     else if(Address[4]==5){
	RJMP _0x2D6
_0x2D5:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x2D7
; 0000 07CA                                     lcd_putsf("               ^");
	CALL SUBOPT_0xA2
; 0000 07CB                                     }
; 0000 07CC                                     else if(Address[4]==6){
	RJMP _0x2D8
_0x2D7:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x2D9
; 0000 07CD                                     lcd_putsf("                ^");
	CALL SUBOPT_0xA3
; 0000 07CE                                     }
; 0000 07CF                                     else if(Address[4]==7){
	RJMP _0x2DA
_0x2D9:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x2DB
; 0000 07D0                                     lcd_putsf("                 ^");
	CALL SUBOPT_0xA4
; 0000 07D1                                     }
; 0000 07D2                                     else if(Address[4]==0){
	RJMP _0x2DC
_0x2DB:
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x2DD
; 0000 07D3                                     lcd_putsf("      REDAGUOTI?    ");
	CALL SUBOPT_0x81
; 0000 07D4                                     lcd_putsf("       TRINTI?      ");
	CALL SUBOPT_0xA5
; 0000 07D5                                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0xA6
; 0000 07D6                                     lcd_putchar('<');
; 0000 07D7                                     }
; 0000 07D8                                 }
_0x2DD:
_0x2DC:
_0x2DA:
_0x2D8:
_0x2D6:
_0x2D4:
_0x2D2:
_0x2D0:
; 0000 07D9                             }
_0x2CB:
; 0000 07DA                             else{
	RJMP _0x2DE
_0x281:
; 0000 07DB                             Address[3] = 0;
	CALL SUBOPT_0xA7
; 0000 07DC                             SelectedRow = 0;
; 0000 07DD                             Address[5] = 0;
; 0000 07DE                             }
_0x2DE:
; 0000 07DF                         }
_0x280:
; 0000 07E0                     }
; 0000 07E1                     else{
	RJMP _0x2DF
_0x25C:
; 0000 07E2                     Address[2] = 0;
	CALL SUBOPT_0xA8
; 0000 07E3                     SelectedRow = 0;
; 0000 07E4                     Address[5] = 0;
; 0000 07E5                     }
_0x2DF:
_0x25B:
; 0000 07E6                 }
; 0000 07E7             /////////////////////
; 0000 07E8 
; 0000 07E9             // VELYKU LAIKO MENIU
; 0000 07EA                 else if(Address[1]==2){
	RJMP _0x2E0
_0x23F:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x2E1
; 0000 07EB                     if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BREQ PC+3
	JMP _0x2E2
; 0000 07EC                         if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x2E3
; 0000 07ED                         SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 07EE                         }
; 0000 07EF                         else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x2E4
_0x2E3:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x2E5
; 0000 07F0                         SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 07F1                         }
; 0000 07F2                         else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x2E6
_0x2E5:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x2E7
; 0000 07F3                             if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x2E8
; 0000 07F4                             Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 07F5                             }
; 0000 07F6                             else{
	RJMP _0x2E9
_0x2E8:
; 0000 07F7                             Address[2] = SelectedRow;
	CALL SUBOPT_0x82
; 0000 07F8                             }
_0x2E9:
; 0000 07F9                         SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 07FA                         Address[5] = 0;
; 0000 07FB                         }
; 0000 07FC 
; 0000 07FD                         if(RefreshLcd>=1){
_0x2E7:
_0x2E6:
_0x2E4:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x2EA
; 0000 07FE                         unsigned char row, lcd_row;
; 0000 07FF                         lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0800                         RowsOnWindow = 6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x75
; 0000 0801                             for(row=Address[5];row<4+Address[5];row++){
_0x2EC:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRGE _0x2ED
; 0000 0802                             lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 0803 
; 0000 0804                                 if(row==0){
	BRNE _0x2EE
; 0000 0805                                 lcd_putsf(" -=VELYKU LAIKAS=-");
	__POINTW1FN _0x0,1201
	RJMP _0x4C6
; 0000 0806                                 }
; 0000 0807                                 else if(row==1){
_0x2EE:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x2F0
; 0000 0808                                 lcd_putsf("1.VELYKU KETVIRTAD.");
	__POINTW1FN _0x0,1220
	RJMP _0x4C6
; 0000 0809                                 }
; 0000 080A                                 else if(row==2){
_0x2F0:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x2F2
; 0000 080B                                 lcd_putsf("2.VELYKU PENKTAD.");
	__POINTW1FN _0x0,1240
	RJMP _0x4C6
; 0000 080C                                 }
; 0000 080D                                 else if(row==3){
_0x2F2:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x2F4
; 0000 080E                                 lcd_putsf("3.VELYKU SESTADIEN.");
	__POINTW1FN _0x0,1258
	RJMP _0x4C6
; 0000 080F                                 }
; 0000 0810                                 else if(row==4){
_0x2F4:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x2F6
; 0000 0811                                 lcd_putsf("4.VELYKU SEKMAD.");
	__POINTW1FN _0x0,1278
	RJMP _0x4C6
; 0000 0812                                 }
; 0000 0813                                 else if(row==5){
_0x2F6:
	LDD  R26,Y+1
	CPI  R26,LOW(0x5)
	BRNE _0x2F8
; 0000 0814                                 lcd_putsf("5.KADA BUS VELYKOS?");
	__POINTW1FN _0x0,1295
_0x4C6:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0815                                 }
; 0000 0816 
; 0000 0817                             lcd_row++;
_0x2F8:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0818                             }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x2EC
_0x2ED:
; 0000 0819 
; 0000 081A                         lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 081B                         lcd_putchar('<');
; 0000 081C                         }
; 0000 081D 
; 0000 081E 
; 0000 081F                     }
_0x2EA:
; 0000 0820                     else if( (Address[2]>=1)&&(Address[2]<=4) ){
	RJMP _0x2F9
_0x2E2:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRLO _0x2FB
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x5)
	BRLO _0x2FC
_0x2FB:
	RJMP _0x2FA
_0x2FC:
; 0000 0821 
; 0000 0822                         if(Address[3]==0){
	__GETB1MN _Address_G000,3
	CPI  R30,0
	BREQ PC+3
	JMP _0x2FD
; 0000 0823                             if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x2FE
; 0000 0824                             SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0825                             }
; 0000 0826                             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x2FF
_0x2FE:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x300
; 0000 0827                             SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0828                             }
; 0000 0829                             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x301
_0x300:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x302
; 0000 082A                                 if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x303
; 0000 082B                                 Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
; 0000 082C                                 }
; 0000 082D                                 else{
	RJMP _0x304
_0x303:
; 0000 082E                                 Address[3] = SelectedRow;
	LDS  R30,_SelectedRow_G000
	__PUTB1MN _Address_G000,3
; 0000 082F                                 }
_0x304:
; 0000 0830                             SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0831                             Address[5] = 0;
; 0000 0832                             }
; 0000 0833 
; 0000 0834                             if(RefreshLcd>=1){
_0x302:
_0x301:
_0x2FF:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x305
; 0000 0835                             unsigned char row, lcd_row;
; 0000 0836                             lcd_row = 0;
	CALL SUBOPT_0xA9
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 0837                             RowsOnWindow = 20;
; 0000 0838                                 for(row=Address[5];row<4+Address[5];row++){
_0x307:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRLT PC+3
	JMP _0x308
; 0000 0839                                 lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 083A 
; 0000 083B                                     if(row==0){
	BRNE _0x309
; 0000 083C                                         if(Address[2]==1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x30A
; 0000 083D                                         lcd_putsf("-=VEL. KETVIRTAD.=-");
	__POINTW1FN _0x0,1315
	RJMP _0x4C7
; 0000 083E                                         }
; 0000 083F                                         else if(Address[2]==2){
_0x30A:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x30C
; 0000 0840                                         lcd_putsf(" -=VEL. PENKTAD.=-");
	__POINTW1FN _0x0,1335
	RJMP _0x4C7
; 0000 0841                                         }
; 0000 0842                                         else if(Address[2]==3){
_0x30C:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x30E
; 0000 0843                                         lcd_putsf("  -=VEL. SESTAD.=-");
	__POINTW1FN _0x0,1354
	RJMP _0x4C7
; 0000 0844                                         }
; 0000 0845                                         else if(Address[2]==4){
_0x30E:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x310
; 0000 0846                                         lcd_putsf("  -=VEL. SEKMAD.=-");
	__POINTW1FN _0x0,1373
_0x4C7:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0847                                         }
; 0000 0848                                     }
_0x310:
; 0000 0849                                     else if(row>=1){
	RJMP _0x311
_0x309:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRLO _0x312
; 0000 084A                                         if(row<=BELL_COUNT){
	CPI  R26,LOW(0x15)
	BRSH _0x313
; 0000 084B                                         unsigned char id;
; 0000 084C                                         id = GetBellId(Address[2]+6, row-1);
	SBIW R28,1
;	row -> Y+2
;	lcd_row -> Y+1
;	id -> Y+0
	__GETB1MN _Address_G000,2
	SUBI R30,-LOW(6)
	CALL SUBOPT_0x85
	CALL SUBOPT_0x84
; 0000 084D                                         lcd_put_number(0,2,0,0,row,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xA
	CALL SUBOPT_0x86
; 0000 084E                                         lcd_putsf(". ");
	CALL SUBOPT_0x87
; 0000 084F 
; 0000 0850                                             if(id!=255){
	LD   R26,Y
	CPI  R26,LOW(0xFF)
	BREQ _0x314
; 0000 0851                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][id][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xAA
	CALL SUBOPT_0x19
	CALL SUBOPT_0x89
; 0000 0852                                             lcd_putchar(':');
	CALL SUBOPT_0x8A
; 0000 0853                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][id][1],0);
	CALL SUBOPT_0xAA
	CALL SUBOPT_0x40
	CALL SUBOPT_0x89
; 0000 0854                                             lcd_putsf(" (");
	CALL SUBOPT_0x8B
; 0000 0855                                             lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+6][id][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xAA
	CALL SUBOPT_0x41
	CALL SUBOPT_0x86
; 0000 0856                                             lcd_putsf("SEC)");
	__POINTW1FN _0x0,1093
	RJMP _0x4C8
; 0000 0857                                             }
; 0000 0858                                             else{
_0x314:
; 0000 0859                                             lcd_putsf("TUSCIA");
	__POINTW1FN _0x0,1098
_0x4C8:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 085A                                             }
; 0000 085B                                         }
	ADIW R28,1
; 0000 085C                                     }
_0x313:
; 0000 085D 
; 0000 085E                                 lcd_row++;
_0x312:
_0x311:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 085F                                 }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x307
_0x308:
; 0000 0860 
; 0000 0861                             lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0862                             lcd_putchar('<');
; 0000 0863                             }
; 0000 0864                         }
_0x305:
; 0000 0865                         else{
	RJMP _0x316
_0x2FD:
; 0000 0866                             if(Address[3]<=BELL_COUNT){
	__GETB2MN _Address_G000,3
	CPI  R26,LOW(0x15)
	BRLO PC+3
	JMP _0x317
; 0000 0867                                 if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x318
; 0000 0868                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x319
; 0000 0869                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x31A
; 0000 086A                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x4C9
; 0000 086B                                         }
; 0000 086C                                         else if(SelectedRow==1){
_0x31A:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x31C
; 0000 086D                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x4C9
; 0000 086E                                         }
; 0000 086F                                         else if(SelectedRow==2){
_0x31C:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x31E
; 0000 0870                                         SelectedRow = 3;
	LDI  R30,LOW(3)
_0x4C9:
	STS  _SelectedRow_G000,R30
; 0000 0871                                         }
; 0000 0872                                     }
_0x31E:
; 0000 0873                                     else if(Address[4]==1){
	RJMP _0x31F
_0x319:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x320
; 0000 0874                                         if(BELL_TIME[Address[2]+6][Address[3]-1][0]-10 >= 0){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x321
; 0000 0875                                         BELL_TIME[Address[2]+6][Address[3]-1][0] += -10;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 0876                                         }
; 0000 0877                                     }
_0x321:
; 0000 0878                                     else if(Address[4]==2){
	RJMP _0x322
_0x320:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x323
; 0000 0879                                         if(BELL_TIME[Address[2]+6][Address[3]-1][0]-1 >= 0){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x324
; 0000 087A                                         BELL_TIME[Address[2]+6][Address[3]-1][0] += -1;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 087B                                         }
; 0000 087C                                     }
_0x324:
; 0000 087D                                     else if(Address[4]==3){
	RJMP _0x325
_0x323:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x326
; 0000 087E                                         if(BELL_TIME[Address[2]+6][Address[3]-1][1]-10 >= 0){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x327
; 0000 087F                                         BELL_TIME[Address[2]+6][Address[3]-1][1] += -10;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 0880                                         }
; 0000 0881                                     }
_0x327:
; 0000 0882                                     else if(Address[4]==4){
	RJMP _0x328
_0x326:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x329
; 0000 0883                                         if(BELL_TIME[Address[2]+6][Address[3]-1][1]-1 >= 0){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x32A
; 0000 0884                                         BELL_TIME[Address[2]+6][Address[3]-1][1] += -1;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 0885                                         }
; 0000 0886                                     }
_0x32A:
; 0000 0887                                     else if(Address[4]==5){
	RJMP _0x32B
_0x329:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x32C
; 0000 0888                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]-100 > 0){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x90
	BRGE _0x32D
; 0000 0889                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += -100;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(156)
	CALL __EEPROMWRB
; 0000 088A                                         }
; 0000 088B                                     }
_0x32D:
; 0000 088C                                     else if(Address[4]==6){
	RJMP _0x32E
_0x32C:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x32F
; 0000 088D                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]-10 > 0){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x92
	BRGE _0x330
; 0000 088E                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += -10;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 088F                                         }
; 0000 0890                                     }
_0x330:
; 0000 0891                                     else if(Address[4]==7){
	RJMP _0x331
_0x32F:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x332
; 0000 0892                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]-1 > 0){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	CALL SUBOPT_0x1E
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x333
; 0000 0893                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += -1;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 0894                                         }
; 0000 0895                                     }
_0x333:
; 0000 0896                                 }
_0x332:
_0x331:
_0x32E:
_0x32B:
_0x328:
_0x325:
_0x322:
_0x31F:
; 0000 0897                                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x334
_0x318:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x335
; 0000 0898                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x336
; 0000 0899                                         if(SelectedRow==1){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x337
; 0000 089A                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x4CA
; 0000 089B                                         }
; 0000 089C                                         else if(SelectedRow==2){
_0x337:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x339
; 0000 089D                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x4CA
; 0000 089E                                         }
; 0000 089F                                         else if(SelectedRow==3){
_0x339:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x33B
; 0000 08A0                                         SelectedRow = 2;
	LDI  R30,LOW(2)
_0x4CA:
	STS  _SelectedRow_G000,R30
; 0000 08A1                                         }
; 0000 08A2                                     }
_0x33B:
; 0000 08A3                                     else if(Address[4]==1){
	RJMP _0x33C
_0x336:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x33D
; 0000 08A4                                         if(BELL_TIME[Address[2]+6][Address[3]-1][0]+10 < 24){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x93
	SBIW R30,24
	BRGE _0x33E
; 0000 08A5                                         BELL_TIME[Address[2]+6][Address[3]-1][0] += 10;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 08A6                                         }
; 0000 08A7                                     }
_0x33E:
; 0000 08A8                                     else if(Address[4]==2){
	RJMP _0x33F
_0x33D:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x340
; 0000 08A9                                         if(BELL_TIME[Address[2]+6][Address[3]-1][0]+1 < 24){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x94
	SBIW R30,24
	BRGE _0x341
; 0000 08AA                                         BELL_TIME[Address[2]+6][Address[3]-1][0] += 1;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 08AB                                         }
; 0000 08AC                                     }
_0x341:
; 0000 08AD                                     else if(Address[4]==3){
	RJMP _0x342
_0x340:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x343
; 0000 08AE                                         if(BELL_TIME[Address[2]+6][Address[3]-1][1]+10 < 60){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x93
	SBIW R30,60
	BRGE _0x344
; 0000 08AF                                         BELL_TIME[Address[2]+6][Address[3]-1][1] += 10;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 08B0                                         }
; 0000 08B1                                     }
_0x344:
; 0000 08B2                                     else if(Address[4]==4){
	RJMP _0x345
_0x343:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x346
; 0000 08B3                                         if(BELL_TIME[Address[2]+6][Address[3]-1][1]+1 < 60){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x94
	SBIW R30,60
	BRGE _0x347
; 0000 08B4                                         BELL_TIME[Address[2]+6][Address[3]-1][1] += 1;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 08B5                                         }
; 0000 08B6                                     }
_0x347:
; 0000 08B7                                     else if(Address[4]==5){
	RJMP _0x348
_0x346:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x349
; 0000 08B8                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]+100 <= 255){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x95
	BRGE _0x34A
; 0000 08B9                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += 100;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(100)
	CALL __EEPROMWRB
; 0000 08BA                                         }
; 0000 08BB                                     }
_0x34A:
; 0000 08BC                                     else if(Address[4]==6){
	RJMP _0x34B
_0x349:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x34C
; 0000 08BD                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]+10 <= 255){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x96
	BRGE _0x34D
; 0000 08BE                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += 10;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 08BF                                         }
; 0000 08C0                                     }
_0x34D:
; 0000 08C1                                     else if(Address[4]==7){
	RJMP _0x34E
_0x34C:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x34F
; 0000 08C2                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]+1 <= 255){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x97
	BRGE _0x350
; 0000 08C3                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += 1;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 08C4                                         }
; 0000 08C5                                     }
_0x350:
; 0000 08C6                                 }
_0x34F:
_0x34E:
_0x34B:
_0x348:
_0x345:
_0x342:
_0x33F:
_0x33C:
; 0000 08C7                                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x351
_0x335:
	__GETB2MN _BUTTON_S000000E001,1
	CPI  R26,LOW(0x1)
	BRNE _0x352
; 0000 08C8                                     if(Address[4]>1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRLO _0x353
; 0000 08C9                                     Address[4]--;
	CALL SUBOPT_0x98
; 0000 08CA                                     }
; 0000 08CB                                 }
_0x353:
; 0000 08CC                                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x354
_0x352:
	__GETB2MN _BUTTON_S000000E001,3
	CPI  R26,LOW(0x1)
	BRNE _0x355
; 0000 08CD                                     if(Address[4]>0){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRLO _0x356
; 0000 08CE                                         if(Address[4]<7){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRSH _0x357
; 0000 08CF                                         Address[4]++;
	CALL SUBOPT_0x99
; 0000 08D0                                         }
; 0000 08D1                                     }
_0x357:
; 0000 08D2                                 }
_0x356:
; 0000 08D3                                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x358
_0x355:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x359
; 0000 08D4                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x35A
; 0000 08D5                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BREQ _0x4CB
; 0000 08D6                                         Address[3] = 0;
; 0000 08D7                                         }
; 0000 08D8                                         else if(SelectedRow==2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x35D
; 0000 08D9                                         Address[4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,4
; 0000 08DA                                         }
; 0000 08DB                                         else if(SelectedRow==3){
	RJMP _0x35E
_0x35D:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x35F
; 0000 08DC                                         BELL_TIME[Address[2]+6][Address[3]-1][0] = 0;
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0xAC
; 0000 08DD                                         BELL_TIME[Address[2]+6][Address[3]-1][1] = 0;
	CALL SUBOPT_0x8F
	CALL SUBOPT_0xAD
; 0000 08DE                                         BELL_TIME[Address[2]+6][Address[3]-1][2] = 0;
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x1D
; 0000 08DF                                         Address[3] = 0;
_0x4CB:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 08E0                                         }
; 0000 08E1                                     }
_0x35F:
_0x35E:
; 0000 08E2                                     else{
	RJMP _0x360
_0x35A:
; 0000 08E3                                     Address[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,4
; 0000 08E4                                     }
_0x360:
; 0000 08E5                                 SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 08E6                                 Address[5] = 0;
; 0000 08E7                                 }
; 0000 08E8 
; 0000 08E9                                 if(RefreshLcd>=1){
_0x359:
_0x358:
_0x354:
_0x351:
_0x334:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x361
; 0000 08EA                                 lcd_putsf(" -=LAIKO KEITIMAS=- ");
	CALL SUBOPT_0x9C
; 0000 08EB                                     if(BELL_TIME[Address[2]+6][Address[3]-1][0]>=24){
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8D
	CPI  R30,LOW(0x18)
	BRSH _0x4CC
; 0000 08EC                                     BELL_TIME[Address[2]+6][Address[3]-1][0] = 0;
; 0000 08ED                                     BELL_TIME[Address[2]+6][Address[3]-1][1] = 0;
; 0000 08EE                                     BELL_TIME[Address[2]+6][Address[3]-1][2] = 0;
; 0000 08EF                                     }
; 0000 08F0                                     else if(BELL_TIME[Address[2]-1][Address[3]-1][1]>=60){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CPI  R30,LOW(0x3C)
	BRLO _0x364
; 0000 08F1                                     BELL_TIME[Address[2]+6][Address[3]-1][0] = 0;
_0x4CC:
	__GETB1MN _Address_G000,2
	LDI  R31,0
	ADIW R30,6
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0xAC
; 0000 08F2                                     BELL_TIME[Address[2]+6][Address[3]-1][1] = 0;
	CALL SUBOPT_0x8F
	CALL SUBOPT_0xAD
; 0000 08F3                                     BELL_TIME[Address[2]+6][Address[3]-1][2] = 0;
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x1D
; 0000 08F4                                     }
; 0000 08F5 
; 0000 08F6                                 lcd_putsf("LAIKAS: ");
_0x364:
	CALL SUBOPT_0x7D
; 0000 08F7                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][Address[3]-1][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x89
; 0000 08F8                                 lcd_putchar('.');
	CALL SUBOPT_0x29
; 0000 08F9                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][Address[3]-1][1],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x89
; 0000 08FA                                 lcd_putsf(" (");
	CALL SUBOPT_0x8B
; 0000 08FB                                 lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+6][Address[3]-1][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xAB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x86
; 0000 08FC                                 lcd_putchar(')');lcd_putsf(" ");
	CALL SUBOPT_0x9D
; 0000 08FD 
; 0000 08FE 
; 0000 08FF                                     if(Address[4]==1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x365
; 0000 0900                                     lcd_putsf("        ^");
	CALL SUBOPT_0x9E
; 0000 0901                                     }
; 0000 0902                                     else if(Address[4]==2){
	RJMP _0x366
_0x365:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x367
; 0000 0903                                     lcd_putsf("         ^");
	CALL SUBOPT_0x9F
; 0000 0904                                     }
; 0000 0905                                     else if(Address[4]==3){
	RJMP _0x368
_0x367:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x369
; 0000 0906                                     lcd_putsf("           ^");
	CALL SUBOPT_0xA0
; 0000 0907                                     }
; 0000 0908                                     else if(Address[4]==4){
	RJMP _0x36A
_0x369:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x36B
; 0000 0909                                     lcd_putsf("            ^");
	CALL SUBOPT_0xA1
; 0000 090A                                     }
; 0000 090B                                     else if(Address[4]==5){
	RJMP _0x36C
_0x36B:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x36D
; 0000 090C                                     lcd_putsf("               ^");
	CALL SUBOPT_0xA2
; 0000 090D                                     }
; 0000 090E                                     else if(Address[4]==6){
	RJMP _0x36E
_0x36D:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x36F
; 0000 090F                                     lcd_putsf("                ^");
	CALL SUBOPT_0xA3
; 0000 0910                                     }
; 0000 0911                                     else if(Address[4]==7){
	RJMP _0x370
_0x36F:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x371
; 0000 0912                                     lcd_putsf("                 ^");
	CALL SUBOPT_0xA4
; 0000 0913                                     }
; 0000 0914                                     else if(Address[4]==0){
	RJMP _0x372
_0x371:
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x373
; 0000 0915                                     lcd_putsf("      REDAGUOTI?    ");
	CALL SUBOPT_0x81
; 0000 0916                                     lcd_putsf("       TRINTI?      ");
	CALL SUBOPT_0xA5
; 0000 0917                                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0xA6
; 0000 0918                                     lcd_putchar('<');
; 0000 0919                                     }
; 0000 091A                                 }
_0x373:
_0x372:
_0x370:
_0x36E:
_0x36C:
_0x36A:
_0x368:
_0x366:
; 0000 091B                             }
_0x361:
; 0000 091C                             else{
	RJMP _0x374
_0x317:
; 0000 091D                             Address[3] = 0;
	CALL SUBOPT_0xA7
; 0000 091E                             SelectedRow = 0;
; 0000 091F                             Address[5] = 0;
; 0000 0920                             }
_0x374:
; 0000 0921                         }
_0x316:
; 0000 0922                     }
; 0000 0923                     else if(Address[2]==5){
	RJMP _0x375
_0x2FA:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x5)
	BREQ PC+3
	JMP _0x376
; 0000 0924                         if(BUTTON[BUTTON_ENTER]==1){
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x377
; 0000 0925                         Address[2] = 0;
	CALL SUBOPT_0xA8
; 0000 0926                         SelectedRow = 0;
; 0000 0927                         Address[5] = 0;
; 0000 0928                         }
; 0000 0929 
; 0000 092A                         if(RefreshLcd>=1){
_0x377:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x378
; 0000 092B                         lcd_putsf("  -=VELYKU DATOS=-  ");
	__POINTW1FN _0x0,1392
	CALL SUBOPT_0x2E
; 0000 092C 
; 0000 092D                         lcd_putsf("1. 2");
	__POINTW1FN _0x0,1413
	CALL SUBOPT_0x2E
; 0000 092E                         lcd_put_number(0,3,0,0,RealTimeYear,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x56
; 0000 092F                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0930                         lcd_put_number(0,2,0,0,GetEasterMonth(RealTimeYear),0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xAE
	CALL SUBOPT_0xAF
; 0000 0931                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0932                         lcd_put_number(0,2,0,0,GetEasterDay(RealTimeYear),0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xAE
	CALL SUBOPT_0xB0
; 0000 0933                         lcd_putsf("       ");
	__POINTW1FN _0x0,565
	CALL SUBOPT_0x2E
; 0000 0934 
; 0000 0935                         lcd_putsf("2. 2");
	__POINTW1FN _0x0,1418
	CALL SUBOPT_0x2E
; 0000 0936                         lcd_put_number(0,3,0,0,RealTimeYear+1,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	MOV  R30,R5
	CALL SUBOPT_0x94
	CALL SUBOPT_0x86
; 0000 0937                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0938                         lcd_put_number(0,2,0,0,GetEasterMonth(RealTimeYear+1),0);
	CALL SUBOPT_0x50
	MOV  R30,R5
	CALL SUBOPT_0x94
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xAF
; 0000 0939                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 093A                         lcd_put_number(0,2,0,0,GetEasterDay(RealTimeYear+1),0);
	CALL SUBOPT_0x50
	MOV  R30,R5
	CALL SUBOPT_0x94
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB0
; 0000 093B                         lcd_putsf("       ");
	__POINTW1FN _0x0,565
	CALL SUBOPT_0x2E
; 0000 093C 
; 0000 093D                         lcd_putsf("3. 2");
	__POINTW1FN _0x0,1423
	CALL SUBOPT_0x2E
; 0000 093E                         lcd_put_number(0,3,0,0,RealTimeYear+2,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xB1
	CALL SUBOPT_0x86
; 0000 093F                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0940                         lcd_put_number(0,2,0,0,GetEasterMonth(RealTimeYear+2),0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xAF
; 0000 0941                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0942                         lcd_put_number(0,2,0,0,GetEasterDay(RealTimeYear+2),0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB0
; 0000 0943                         }
; 0000 0944                     }
_0x378:
; 0000 0945                     else{
	RJMP _0x379
_0x376:
; 0000 0946                     Address[2] = 0;
	CALL SUBOPT_0xA8
; 0000 0947                     SelectedRow = 0;
; 0000 0948                     Address[5] = 0;
; 0000 0949                     }
_0x379:
_0x375:
_0x2F9:
; 0000 094A                 }
; 0000 094B             /////////////////////
; 0000 094C 
; 0000 094D             // KALEDU LAIKO MENIU
; 0000 094E                 else if(Address[1]==3){
	RJMP _0x37A
_0x2E1:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0x37B
; 0000 094F                     if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BREQ PC+3
	JMP _0x37C
; 0000 0950                         if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x37D
; 0000 0951                         SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0952                         }
; 0000 0953                         else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x37E
_0x37D:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x37F
; 0000 0954                         SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0955                         }
; 0000 0956                         else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x380
_0x37F:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x381
; 0000 0957                             if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x382
; 0000 0958                             Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 0959                             }
; 0000 095A                             else{
	RJMP _0x383
_0x382:
; 0000 095B                             Address[2] = SelectedRow;
	CALL SUBOPT_0x82
; 0000 095C                             }
_0x383:
; 0000 095D                         SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 095E                         Address[5] = 0;
; 0000 095F                         }
; 0000 0960 
; 0000 0961                         if(RefreshLcd>=1){
_0x381:
_0x380:
_0x37E:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x384
; 0000 0962                         unsigned char row, lcd_row;
; 0000 0963                         lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0964                         RowsOnWindow = 3;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x75
; 0000 0965                             for(row=Address[5];row<4+Address[5];row++){
_0x386:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRGE _0x387
; 0000 0966                             lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 0967 
; 0000 0968                                 if(row==0){
	BRNE _0x388
; 0000 0969                                 lcd_putsf(" -=KALEDU LAIKAS=-");
	__POINTW1FN _0x0,1428
	RJMP _0x4CD
; 0000 096A                                 }
; 0000 096B                                 else if(row==1){
_0x388:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x38A
; 0000 096C                                 lcd_putsf("1.GRUODZIO 25 D.");
	__POINTW1FN _0x0,1447
	RJMP _0x4CD
; 0000 096D                                 }
; 0000 096E                                 else if(row==2){
_0x38A:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x38C
; 0000 096F                                 lcd_putsf("2.GRUODZIO 26 D.");
	__POINTW1FN _0x0,1464
_0x4CD:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0970                                 }
; 0000 0971 
; 0000 0972                             lcd_row++;
_0x38C:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0973                             }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x386
_0x387:
; 0000 0974 
; 0000 0975                         lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0976                         lcd_putchar('<');
; 0000 0977                         }
; 0000 0978                     }
_0x384:
; 0000 0979                     else if( (Address[2]>=1)&&(Address[2]<=2) ){
	RJMP _0x38D
_0x37C:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRLO _0x38F
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRLO _0x390
_0x38F:
	RJMP _0x38E
_0x390:
; 0000 097A                         if(Address[3]==0){
	__GETB1MN _Address_G000,3
	CPI  R30,0
	BREQ PC+3
	JMP _0x391
; 0000 097B                             if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x392
; 0000 097C                             SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 097D                             }
; 0000 097E                             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x393
_0x392:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x394
; 0000 097F                             SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0980                             }
; 0000 0981                             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x395
_0x394:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x396
; 0000 0982                                 if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x397
; 0000 0983                                 Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
; 0000 0984                                 }
; 0000 0985                                 else{
	RJMP _0x398
_0x397:
; 0000 0986                                 Address[3] = SelectedRow;
	LDS  R30,_SelectedRow_G000
	__PUTB1MN _Address_G000,3
; 0000 0987                                 }
_0x398:
; 0000 0988                             SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0989                             Address[5] = 0;
; 0000 098A                             }
; 0000 098B 
; 0000 098C                             if(RefreshLcd>=1){
_0x396:
_0x395:
_0x393:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x399
; 0000 098D                             unsigned char row, lcd_row;
; 0000 098E                             lcd_row = 0;
	CALL SUBOPT_0xA9
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 098F                             RowsOnWindow = 20;
; 0000 0990                                 for(row=Address[5];row<4+Address[5];row++){
_0x39B:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRLT PC+3
	JMP _0x39C
; 0000 0991                                 lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 0992 
; 0000 0993                                     if(row==0){
	BRNE _0x39D
; 0000 0994                                         if(Address[2]==1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x39E
; 0000 0995                                         lcd_putsf(" -=GRUODZIO 25 D.=-");
	__POINTW1FN _0x0,1481
	RJMP _0x4CE
; 0000 0996                                         }
; 0000 0997                                         else if(Address[2]==2){
_0x39E:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x3A0
; 0000 0998                                         lcd_putsf(" -=GRUODZIO 26 D.=-");
	__POINTW1FN _0x0,1501
_0x4CE:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0999                                         }
; 0000 099A                                     }
_0x3A0:
; 0000 099B                                     else if(row>=1){
	RJMP _0x3A1
_0x39D:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x3A2
; 0000 099C                                         if(row<=BELL_COUNT){
	CPI  R26,LOW(0x15)
	BRLO PC+3
	JMP _0x3A3
; 0000 099D                                         unsigned char id;
; 0000 099E                                         id = GetBellId(Address[2]+10, row-1);
	SBIW R28,1
;	row -> Y+2
;	lcd_row -> Y+1
;	id -> Y+0
	__GETB1MN _Address_G000,2
	SUBI R30,-LOW(10)
	CALL SUBOPT_0x85
	CALL SUBOPT_0x84
; 0000 099F                                         lcd_put_number(0,2,0,0,row,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xA
	CALL SUBOPT_0x86
; 0000 09A0                                         lcd_putsf(". ");
	CALL SUBOPT_0x87
; 0000 09A1 
; 0000 09A2                                             if(id!=255){
	LD   R26,Y
	CPI  R26,LOW(0xFF)
	BREQ _0x3A4
; 0000 09A3                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][id][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x88
	CALL SUBOPT_0x19
	CALL SUBOPT_0x89
; 0000 09A4                                             lcd_putchar(':');
	CALL SUBOPT_0x8A
; 0000 09A5                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][id][1],0);
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x88
	CALL SUBOPT_0x40
	CALL SUBOPT_0x89
; 0000 09A6                                             lcd_putsf(" (");
	CALL SUBOPT_0x8B
; 0000 09A7                                             lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+10][id][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x88
	CALL SUBOPT_0x41
	CALL SUBOPT_0x86
; 0000 09A8                                             lcd_putsf("SEC)");
	__POINTW1FN _0x0,1093
	RJMP _0x4CF
; 0000 09A9                                             }
; 0000 09AA                                             else{
_0x3A4:
; 0000 09AB                                             lcd_putsf("TUSCIA");
	__POINTW1FN _0x0,1098
_0x4CF:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 09AC                                             }
; 0000 09AD                                         }
	ADIW R28,1
; 0000 09AE                                     }
_0x3A3:
; 0000 09AF 
; 0000 09B0                                 lcd_row++;
_0x3A2:
_0x3A1:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 09B1                                 }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x39B
_0x39C:
; 0000 09B2 
; 0000 09B3                             lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 09B4                             lcd_putchar('<');
; 0000 09B5                             }
; 0000 09B6                         }
_0x399:
; 0000 09B7                         else{
	RJMP _0x3A6
_0x391:
; 0000 09B8                             if(Address[3]<=BELL_COUNT){
	__GETB2MN _Address_G000,3
	CPI  R26,LOW(0x15)
	BRLO PC+3
	JMP _0x3A7
; 0000 09B9                                 if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x3A8
; 0000 09BA                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x3A9
; 0000 09BB                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x3AA
; 0000 09BC                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x4D0
; 0000 09BD                                         }
; 0000 09BE                                         else if(SelectedRow==1){
_0x3AA:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x3AC
; 0000 09BF                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x4D0
; 0000 09C0                                         }
; 0000 09C1                                         else if(SelectedRow==2){
_0x3AC:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x3AE
; 0000 09C2                                         SelectedRow = 3;
	LDI  R30,LOW(3)
_0x4D0:
	STS  _SelectedRow_G000,R30
; 0000 09C3                                         }
; 0000 09C4                                     }
_0x3AE:
; 0000 09C5                                     else if(Address[4]==1){
	RJMP _0x3AF
_0x3A9:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x3B0
; 0000 09C6                                         if(BELL_TIME[Address[2]+10][Address[3]-1][0]-10 >= 0){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x3B1
; 0000 09C7                                         BELL_TIME[Address[2]+10][Address[3]-1][0] += -10;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 09C8                                         }
; 0000 09C9                                     }
_0x3B1:
; 0000 09CA                                     else if(Address[4]==2){
	RJMP _0x3B2
_0x3B0:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x3B3
; 0000 09CB                                         if(BELL_TIME[Address[2]+10][Address[3]-1][0]-1 >= 0){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x3B4
; 0000 09CC                                         BELL_TIME[Address[2]+10][Address[3]-1][0] += -1;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 09CD                                         }
; 0000 09CE                                     }
_0x3B4:
; 0000 09CF                                     else if(Address[4]==3){
	RJMP _0x3B5
_0x3B3:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x3B6
; 0000 09D0                                         if(BELL_TIME[Address[2]+10][Address[3]-1][1]-10 >= 0){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x3B7
; 0000 09D1                                         BELL_TIME[Address[2]+10][Address[3]-1][1] += -10;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 09D2                                         }
; 0000 09D3                                     }
_0x3B7:
; 0000 09D4                                     else if(Address[4]==4){
	RJMP _0x3B8
_0x3B6:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x3B9
; 0000 09D5                                         if(BELL_TIME[Address[2]+10][Address[3]-1][1]-1 >= 0){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x3BA
; 0000 09D6                                         BELL_TIME[Address[2]+10][Address[3]-1][1] += -1;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 09D7                                         }
; 0000 09D8                                     }
_0x3BA:
; 0000 09D9                                     else if(Address[4]==5){
	RJMP _0x3BB
_0x3B9:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x3BC
; 0000 09DA                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]-100 > 0){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x90
	BRGE _0x3BD
; 0000 09DB                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += -100;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(156)
	CALL __EEPROMWRB
; 0000 09DC                                         }
; 0000 09DD                                     }
_0x3BD:
; 0000 09DE                                     else if(Address[4]==6){
	RJMP _0x3BE
_0x3BC:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x3BF
; 0000 09DF                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]-10 > 0){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x92
	BRGE _0x3C0
; 0000 09E0                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += -10;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 09E1                                         }
; 0000 09E2                                     }
_0x3C0:
; 0000 09E3                                     else if(Address[4]==7){
	RJMP _0x3C1
_0x3BF:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x3C2
; 0000 09E4                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]-1 > 0){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	CALL SUBOPT_0x1E
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x3C3
; 0000 09E5                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += -1;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 09E6                                         }
; 0000 09E7                                     }
_0x3C3:
; 0000 09E8                                 }
_0x3C2:
_0x3C1:
_0x3BE:
_0x3BB:
_0x3B8:
_0x3B5:
_0x3B2:
_0x3AF:
; 0000 09E9                                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x3C4
_0x3A8:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x3C5
; 0000 09EA                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x3C6
; 0000 09EB                                         if(SelectedRow==1){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x3C7
; 0000 09EC                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x4D1
; 0000 09ED                                         }
; 0000 09EE                                         else if(SelectedRow==2){
_0x3C7:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x3C9
; 0000 09EF                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x4D1
; 0000 09F0                                         }
; 0000 09F1                                         else if(SelectedRow==3){
_0x3C9:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x3CB
; 0000 09F2                                         SelectedRow = 2;
	LDI  R30,LOW(2)
_0x4D1:
	STS  _SelectedRow_G000,R30
; 0000 09F3                                         }
; 0000 09F4                                     }
_0x3CB:
; 0000 09F5                                     else if(Address[4]==1){
	RJMP _0x3CC
_0x3C6:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x3CD
; 0000 09F6                                         if(BELL_TIME[Address[2]+10][Address[3]-1][0]+10 < 24){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x93
	SBIW R30,24
	BRGE _0x3CE
; 0000 09F7                                         BELL_TIME[Address[2]+10][Address[3]-1][0] += 10;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 09F8                                         }
; 0000 09F9                                     }
_0x3CE:
; 0000 09FA                                     else if(Address[4]==2){
	RJMP _0x3CF
_0x3CD:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x3D0
; 0000 09FB                                         if(BELL_TIME[Address[2]+10][Address[3]-1][0]+1 < 24){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x94
	SBIW R30,24
	BRGE _0x3D1
; 0000 09FC                                         BELL_TIME[Address[2]+10][Address[3]-1][0] += 1;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 09FD                                         }
; 0000 09FE                                     }
_0x3D1:
; 0000 09FF                                     else if(Address[4]==3){
	RJMP _0x3D2
_0x3D0:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x3D3
; 0000 0A00                                         if(BELL_TIME[Address[2]+10][Address[3]-1][1]+10 < 60){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x93
	SBIW R30,60
	BRGE _0x3D4
; 0000 0A01                                         BELL_TIME[Address[2]+10][Address[3]-1][1] += 10;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 0A02                                         }
; 0000 0A03                                     }
_0x3D4:
; 0000 0A04                                     else if(Address[4]==4){
	RJMP _0x3D5
_0x3D3:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x3D6
; 0000 0A05                                         if(BELL_TIME[Address[2]+10][Address[3]-1][1]+1 < 60){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x94
	SBIW R30,60
	BRGE _0x3D7
; 0000 0A06                                         BELL_TIME[Address[2]+10][Address[3]-1][1] += 1;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0A07                                         }
; 0000 0A08                                     }
_0x3D7:
; 0000 0A09                                     else if(Address[4]==5){
	RJMP _0x3D8
_0x3D6:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x3D9
; 0000 0A0A                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]+100 <= 255){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x95
	BRGE _0x3DA
; 0000 0A0B                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += 100;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(100)
	CALL __EEPROMWRB
; 0000 0A0C                                         }
; 0000 0A0D                                     }
_0x3DA:
; 0000 0A0E                                     else if(Address[4]==6){
	RJMP _0x3DB
_0x3D9:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x3DC
; 0000 0A0F                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]+10 <= 255){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x96
	BRGE _0x3DD
; 0000 0A10                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += 10;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 0A11                                         }
; 0000 0A12                                     }
_0x3DD:
; 0000 0A13                                     else if(Address[4]==7){
	RJMP _0x3DE
_0x3DC:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x3DF
; 0000 0A14                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]+1 <= 255){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x97
	BRGE _0x3E0
; 0000 0A15                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += 1;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0A16                                         }
; 0000 0A17                                     }
_0x3E0:
; 0000 0A18                                 }
_0x3DF:
_0x3DE:
_0x3DB:
_0x3D8:
_0x3D5:
_0x3D2:
_0x3CF:
_0x3CC:
; 0000 0A19                                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x3E1
_0x3C5:
	__GETB2MN _BUTTON_S000000E001,1
	CPI  R26,LOW(0x1)
	BRNE _0x3E2
; 0000 0A1A                                     if(Address[4]>1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRLO _0x3E3
; 0000 0A1B                                     Address[4]--;
	CALL SUBOPT_0x98
; 0000 0A1C                                     }
; 0000 0A1D                                 }
_0x3E3:
; 0000 0A1E                                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x3E4
_0x3E2:
	__GETB2MN _BUTTON_S000000E001,3
	CPI  R26,LOW(0x1)
	BRNE _0x3E5
; 0000 0A1F                                     if(Address[4]>0){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRLO _0x3E6
; 0000 0A20                                         if(Address[4]<7){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRSH _0x3E7
; 0000 0A21                                         Address[4]++;
	CALL SUBOPT_0x99
; 0000 0A22                                         }
; 0000 0A23                                     }
_0x3E7:
; 0000 0A24                                 }
_0x3E6:
; 0000 0A25                                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x3E8
_0x3E5:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x3E9
; 0000 0A26                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x3EA
; 0000 0A27                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BREQ _0x4D2
; 0000 0A28                                         Address[3] = 0;
; 0000 0A29                                         }
; 0000 0A2A                                         else if(SelectedRow==2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x3ED
; 0000 0A2B                                         Address[4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,4
; 0000 0A2C                                         }
; 0000 0A2D                                         else if(SelectedRow==3){
	RJMP _0x3EE
_0x3ED:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x3EF
; 0000 0A2E                                         BELL_TIME[Address[2]+10][Address[3]-1][0] = 0;
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0xB3
; 0000 0A2F                                         BELL_TIME[Address[2]+10][Address[3]-1][1] = 0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0xB4
; 0000 0A30                                         BELL_TIME[Address[2]+10][Address[3]-1][2] = 0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x1D
; 0000 0A31                                         Address[3] = 0;
_0x4D2:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 0A32                                         }
; 0000 0A33                                     }
_0x3EF:
_0x3EE:
; 0000 0A34                                     else{
	RJMP _0x3F0
_0x3EA:
; 0000 0A35                                     Address[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,4
; 0000 0A36                                     }
_0x3F0:
; 0000 0A37                                 SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0A38                                 Address[5] = 0;
; 0000 0A39                                 }
; 0000 0A3A 
; 0000 0A3B                                 if(RefreshLcd>=1){
_0x3E9:
_0x3E8:
_0x3E4:
_0x3E1:
_0x3C4:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x3F1
; 0000 0A3C                                 lcd_putsf(" -=LAIKO KEITIMAS=- ");
	CALL SUBOPT_0x9C
; 0000 0A3D                                     if(BELL_TIME[Address[2]+10][Address[3]-1][0]>=24){
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CPI  R30,LOW(0x18)
	BRSH _0x4D3
; 0000 0A3E                                     BELL_TIME[Address[2]+10][Address[3]-1][0] = 0;
; 0000 0A3F                                     BELL_TIME[Address[2]+10][Address[3]-1][1] = 0;
; 0000 0A40                                     BELL_TIME[Address[2]+10][Address[3]-1][2] = 0;
; 0000 0A41                                     }
; 0000 0A42                                     else if(BELL_TIME[Address[2]-1][Address[3]-1][1]>=60){
	CALL SUBOPT_0x83
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CPI  R30,LOW(0x3C)
	BRLO _0x3F4
; 0000 0A43                                     BELL_TIME[Address[2]+10][Address[3]-1][0] = 0;
_0x4D3:
	__GETB1MN _Address_G000,2
	CALL SUBOPT_0x93
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0xB3
; 0000 0A44                                     BELL_TIME[Address[2]+10][Address[3]-1][1] = 0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0xB4
; 0000 0A45                                     BELL_TIME[Address[2]+10][Address[3]-1][2] = 0;
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x1D
; 0000 0A46                                     }
; 0000 0A47 
; 0000 0A48                                 lcd_putsf("LAIKAS: ");
_0x3F4:
	CALL SUBOPT_0x7D
; 0000 0A49                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][Address[3]-1][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x89
; 0000 0A4A                                 lcd_putchar('.');
	CALL SUBOPT_0x29
; 0000 0A4B                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][Address[3]-1][1],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x89
; 0000 0A4C                                 lcd_putsf(" (");
	CALL SUBOPT_0x8B
; 0000 0A4D                                 lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+10][Address[3]-1][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x86
; 0000 0A4E                                 lcd_putchar(')');lcd_putsf(" ");
	CALL SUBOPT_0x9D
; 0000 0A4F 
; 0000 0A50 
; 0000 0A51                                     if(Address[4]==1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x3F5
; 0000 0A52                                     lcd_putsf("        ^");
	CALL SUBOPT_0x9E
; 0000 0A53                                     }
; 0000 0A54                                     else if(Address[4]==2){
	RJMP _0x3F6
_0x3F5:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x3F7
; 0000 0A55                                     lcd_putsf("         ^");
	CALL SUBOPT_0x9F
; 0000 0A56                                     }
; 0000 0A57                                     else if(Address[4]==3){
	RJMP _0x3F8
_0x3F7:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x3F9
; 0000 0A58                                     lcd_putsf("           ^");
	CALL SUBOPT_0xA0
; 0000 0A59                                     }
; 0000 0A5A                                     else if(Address[4]==4){
	RJMP _0x3FA
_0x3F9:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x3FB
; 0000 0A5B                                     lcd_putsf("            ^");
	CALL SUBOPT_0xA1
; 0000 0A5C                                     }
; 0000 0A5D                                     else if(Address[4]==5){
	RJMP _0x3FC
_0x3FB:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x3FD
; 0000 0A5E                                     lcd_putsf("               ^");
	CALL SUBOPT_0xA2
; 0000 0A5F                                     }
; 0000 0A60                                     else if(Address[4]==6){
	RJMP _0x3FE
_0x3FD:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x3FF
; 0000 0A61                                     lcd_putsf("                ^");
	CALL SUBOPT_0xA3
; 0000 0A62                                     }
; 0000 0A63                                     else if(Address[4]==7){
	RJMP _0x400
_0x3FF:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x401
; 0000 0A64                                     lcd_putsf("                 ^");
	CALL SUBOPT_0xA4
; 0000 0A65                                     }
; 0000 0A66                                     else if(Address[4]==0){
	RJMP _0x402
_0x401:
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x403
; 0000 0A67                                     lcd_putsf("      REDAGUOTI?    ");
	CALL SUBOPT_0x81
; 0000 0A68                                     lcd_putsf("       TRINTI?      ");
	CALL SUBOPT_0xA5
; 0000 0A69                                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0xA6
; 0000 0A6A                                     lcd_putchar('<');
; 0000 0A6B                                     }
; 0000 0A6C                                 }
_0x403:
_0x402:
_0x400:
_0x3FE:
_0x3FC:
_0x3FA:
_0x3F8:
_0x3F6:
; 0000 0A6D                             }
_0x3F1:
; 0000 0A6E                             else{
	RJMP _0x404
_0x3A7:
; 0000 0A6F                             Address[3] = 0;
	CALL SUBOPT_0xA7
; 0000 0A70                             SelectedRow = 0;
; 0000 0A71                             Address[5] = 0;
; 0000 0A72                             }
_0x404:
; 0000 0A73                         }
_0x3A6:
; 0000 0A74                     }
; 0000 0A75                 }
_0x38E:
_0x38D:
; 0000 0A76             /////////////////////
; 0000 0A77 
; 0000 0A78             }
_0x37B:
_0x37A:
_0x2E0:
_0x23E:
; 0000 0A79 
; 0000 0A7A             // Nustatymai
; 0000 0A7B             else if(Address[0]==4){
	RJMP _0x405
_0x22A:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x406
; 0000 0A7C                 if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BREQ PC+3
	JMP _0x407
; 0000 0A7D                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x408
; 0000 0A7E                     SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0A7F                     }
; 0000 0A80                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x409
_0x408:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x40A
; 0000 0A81                     SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0A82                     }
; 0000 0A83                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x40B
_0x40A:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x40C
; 0000 0A84                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x40D
; 0000 0A85                         Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
; 0000 0A86                         }
; 0000 0A87                         else{
	RJMP _0x40E
_0x40D:
; 0000 0A88                         Address[1] = SelectedRow;
	LDS  R30,_SelectedRow_G000
	__PUTB1MN _Address_G000,1
; 0000 0A89                         }
_0x40E:
; 0000 0A8A                     SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0A8B                     Address[5] = 0;
; 0000 0A8C                     }
; 0000 0A8D 
; 0000 0A8E                     if(RefreshLcd>=1){
_0x40C:
_0x40B:
_0x409:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x40F
; 0000 0A8F                     unsigned char row, lcd_row;
; 0000 0A90                     lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0A91                     RowsOnWindow = 7;
	LDI  R30,LOW(7)
	CALL SUBOPT_0x75
; 0000 0A92                         for(row=Address[5];row<4+Address[5];row++){
_0x411:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRGE _0x412
; 0000 0A93                         lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 0A94                             if(row==0){
	BRNE _0x413
; 0000 0A95                             lcd_putsf("   -=NUSTATYMAI=-   ");
	__POINTW1FN _0x0,1521
	RJMP _0x4D4
; 0000 0A96                             }
; 0000 0A97                             else if(row==1){
_0x413:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x415
; 0000 0A98                             lcd_putsf("1.EKRANO APSVIETIM.");
	__POINTW1FN _0x0,1542
	RJMP _0x4D4
; 0000 0A99                             }
; 0000 0A9A                             else if(row==2){
_0x415:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x417
; 0000 0A9B                             lcd_putsf("2.VALYTI SKAMBEJIM.");
	__POINTW1FN _0x0,1562
	RJMP _0x4D4
; 0000 0A9C                             }
; 0000 0A9D                             else if(row==3){
_0x417:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x419
; 0000 0A9E                             lcd_putsf("3.VASAROS LAIKAS");
	__POINTW1FN _0x0,1582
	RJMP _0x4D4
; 0000 0A9F                             }
; 0000 0AA0                             else if(row==4){
_0x419:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x41B
; 0000 0AA1                             lcd_putsf("4.LAIKO TIKSLINIMAS");
	__POINTW1FN _0x0,1599
	RJMP _0x4D4
; 0000 0AA2                             }
; 0000 0AA3                             else if(row==5){
_0x41B:
	LDD  R26,Y+1
	CPI  R26,LOW(0x5)
	BRNE _0x41D
; 0000 0AA4                             lcd_putsf("5.VALDIKLIO KODAS");
	__POINTW1FN _0x0,1619
	RJMP _0x4D4
; 0000 0AA5                             }
; 0000 0AA6                             else if(row==6){
_0x41D:
	LDD  R26,Y+1
	CPI  R26,LOW(0x6)
	BRNE _0x41F
; 0000 0AA7                             lcd_putsf("6.VALDIKLIO ISVADAI");
	__POINTW1FN _0x0,1637
_0x4D4:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0AA8                             }
; 0000 0AA9                         lcd_row++;
_0x41F:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0AAA                         }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x411
_0x412:
; 0000 0AAB                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0AAC                     lcd_putchar('<');
; 0000 0AAD                     }
; 0000 0AAE                 }
_0x40F:
; 0000 0AAF                 else if(Address[1]==1){
	RJMP _0x420
_0x407:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x421
; 0000 0AB0                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x422
; 0000 0AB1                         if(lcd_light>0){
	CALL SUBOPT_0x33
	CPI  R30,LOW(0x1)
	BRLO _0x423
; 0000 0AB2                         lcd_light += -1;
	CALL SUBOPT_0x33
	SUBI R30,-LOW(255)
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	CALL __EEPROMWRB
; 0000 0AB3                         }
; 0000 0AB4                     }
_0x423:
; 0000 0AB5                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x424
_0x422:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x425
; 0000 0AB6                         if(lcd_light<100){
	CALL SUBOPT_0x33
	CPI  R30,LOW(0x64)
	BRSH _0x426
; 0000 0AB7                         lcd_light += 1;
	CALL SUBOPT_0x33
	SUBI R30,-LOW(1)
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	CALL __EEPROMWRB
; 0000 0AB8                         }
; 0000 0AB9                     }
_0x426:
; 0000 0ABA                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x427
_0x425:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x428
; 0000 0ABB                     Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 0ABC                     SelectedRow = 0;
; 0000 0ABD                     Address[5] = 0;
; 0000 0ABE                     }
; 0000 0ABF 
; 0000 0AC0                     if(RefreshLcd>=1){
_0x428:
_0x427:
_0x424:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x429
; 0000 0AC1                     lcd_putsf("-=EKRANO APSVIET.=- ");
	__POINTW1FN _0x0,1657
	CALL SUBOPT_0x2E
; 0000 0AC2                     lcd_putsf("APSVIETIMAS:");
	__POINTW1FN _0x0,1678
	CALL SUBOPT_0x2E
; 0000 0AC3                     lcd_put_number(0,3,0,0,lcd_light,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x33
	CALL SUBOPT_0x89
; 0000 0AC4                     lcd_putchar('%');
	LDI  R30,LOW(37)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0AC5 
; 0000 0AC6                     lcd_gotoxy(19,0);
	LDI  R30,LOW(19)
	CALL SUBOPT_0x49
; 0000 0AC7                     lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0AC8                     lcd_gotoxy(19,3);
	CALL SUBOPT_0x4C
; 0000 0AC9                     lcd_putchar('-');
	LDI  R30,LOW(45)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0ACA                     }
; 0000 0ACB                 }
_0x429:
; 0000 0ACC                 else if(Address[1]==2){
	RJMP _0x42A
_0x421:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x42B
; 0000 0ACD                     if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BREQ PC+3
	JMP _0x42C
; 0000 0ACE                         if(BUTTON[BUTTON_LEFT]==1){
	__GETB2MN _BUTTON_S000000E001,1
	CPI  R26,LOW(0x1)
	BRNE _0x42D
; 0000 0ACF                         Address[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 0AD0                         }
; 0000 0AD1                         else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x42E
_0x42D:
	__GETB2MN _BUTTON_S000000E001,3
	CPI  R26,LOW(0x1)
	BRNE _0x42F
; 0000 0AD2                         Address[3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,3
; 0000 0AD3                         }
; 0000 0AD4                         else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x430
_0x42F:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x431
; 0000 0AD5                             if(Address[3]==0){
	__GETB1MN _Address_G000,3
	CPI  R30,0
	BRNE _0x432
; 0000 0AD6                             Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 0AD7                             }
; 0000 0AD8                             else{
	RJMP _0x433
_0x432:
; 0000 0AD9                             Address[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0ADA                             }
_0x433:
; 0000 0ADB                         Address[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 0ADC                         Address[4] = 0;
	__PUTB1MN _Address_G000,4
; 0000 0ADD                         SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0ADE                         Address[5] = 0;
; 0000 0ADF                         }
; 0000 0AE0 
; 0000 0AE1                         if(RefreshLcd>=1){
_0x431:
_0x430:
_0x42E:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x434
; 0000 0AE2                         lcd_putsf("       VALYTI       ");
	__POINTW1FN _0x0,1691
	CALL SUBOPT_0x2E
; 0000 0AE3                         lcd_putsf("    SKAMBEJIMUS?    ");
	__POINTW1FN _0x0,1712
	CALL SUBOPT_0x2E
; 0000 0AE4                         lcd_putsf("     NE     TAIP    ");
	__POINTW1FN _0x0,1733
	CALL SUBOPT_0x2E
; 0000 0AE5                             if(Address[3]==0){
	__GETB1MN _Address_G000,3
	CPI  R30,0
	BRNE _0x435
; 0000 0AE6                             lcd_putsf("     ^^            <");
	__POINTW1FN _0x0,1754
	RJMP _0x4D5
; 0000 0AE7                             }
; 0000 0AE8                             else{
_0x435:
; 0000 0AE9                             lcd_putsf("            ^^^^   <");
	__POINTW1FN _0x0,1775
_0x4D5:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0AEA                             }
; 0000 0AEB                         }
; 0000 0AEC 
; 0000 0AED                     }
_0x434:
; 0000 0AEE                     else{
	RJMP _0x437
_0x42C:
; 0000 0AEF                         if(Address[4]>=3){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRLO _0x438
; 0000 0AF0                         Address[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,4
; 0000 0AF1                         Address[3]++;
	__GETB1MN _Address_G000,3
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,3
; 0000 0AF2                             if(Address[3]>=BELL_COUNT){
	__GETB2MN _Address_G000,3
	CPI  R26,LOW(0x14)
	BRLO _0x439
; 0000 0AF3                             Address[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 0AF4                             Address[2]++;
	__GETB1MN _Address_G000,2
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0AF5                                 if(Address[2]>BELL_TYPE_COUNT){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0xE)
	BRLO _0x43A
; 0000 0AF6                                 Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 0AF7                                 Address[2] = 0;
	CALL SUBOPT_0xA8
; 0000 0AF8 
; 0000 0AF9                                 SelectedRow = 0;
; 0000 0AFA                                 Address[5] = 0;
; 0000 0AFB                                 }
; 0000 0AFC                             }
_0x43A:
; 0000 0AFD                         }
_0x439:
; 0000 0AFE 
; 0000 0AFF                         if(RefreshLcd>=1){
_0x438:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x43B
; 0000 0B00                         lcd_clear();
	CALL _lcd_clear
; 0000 0B01                         lcd_gotoxy(0,1);
	CALL SUBOPT_0x4E
; 0000 0B02                         lcd_putsf("TRINAMI SKAMBEJIMAI:");
	__POINTW1FN _0x0,1796
	CALL SUBOPT_0x2E
; 0000 0B03                         lcd_gotoxy(4,2);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x55
; 0000 0B04                         lcd_putsf("B / ");
	__POINTW1FN _0x0,1817
	CALL SUBOPT_0x2E
; 0000 0B05                         lcd_put_number(0,4,0,0,(BELL_TYPE_COUNT-1)*BELL_COUNT*3+(BELL_COUNT-1)*3+3,0);
	CALL SUBOPT_0xB5
	__GETD1N 0x30C
	CALL SUBOPT_0x31
; 0000 0B06                         lcd_putsf("B");
	__POINTW1FN _0x0,1822
	CALL SUBOPT_0x2E
; 0000 0B07                         }
; 0000 0B08 
; 0000 0B09                         if(Address[2]>0){
_0x43B:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRLO _0x43C
; 0000 0B0A                         unsigned int number;
; 0000 0B0B                         BELL_TIME[Address[2]-1][Address[3]][Address[4]] = 0;
	SBIW R28,2
;	number -> Y+0
	CALL SUBOPT_0x83
	LDI  R26,LOW(60)
	LDI  R27,HIGH(60)
	CALL __MULW12U
	SUBI R30,LOW(-_BELL_TIME)
	SBCI R31,HIGH(-_BELL_TIME)
	CALL SUBOPT_0xB6
	CALL SUBOPT_0x8F
	CALL SUBOPT_0xB7
	CALL SUBOPT_0x9A
; 0000 0B0C                         number = (Address[2]-1)*BELL_COUNT*3 + Address[3]+Address[3]+Address[3] + Address[4] + 1;
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	CALL __MULW12
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xB8
	CALL SUBOPT_0xB8
	CALL SUBOPT_0xB7
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 0B0D                         lcd_gotoxy(0,2);
	CALL SUBOPT_0x46
; 0000 0B0E                         lcd_put_number(0,4,0,0,number,0);
	CALL SUBOPT_0xB5
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x31
; 0000 0B0F                         Address[4]++;
	CALL SUBOPT_0x99
; 0000 0B10                         }
	ADIW R28,2
; 0000 0B11                     }
_0x43C:
_0x437:
; 0000 0B12                 }
; 0000 0B13                 else if(Address[1]==3){
	RJMP _0x43D
_0x42B:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0x43E
; 0000 0B14                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x43F
; 0000 0B15                         if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x440
; 0000 0B16                         Address[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0B17                         }
; 0000 0B18                     }
_0x440:
; 0000 0B19                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x441
_0x43F:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x442
; 0000 0B1A                         if(Address[2]!=0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BREQ _0x443
; 0000 0B1B                         Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
; 0000 0B1C                         }
; 0000 0B1D                     }
_0x443:
; 0000 0B1E                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x444
_0x442:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x445
; 0000 0B1F                         if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x446
; 0000 0B20                         Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 0B21                         SelectedRow = 0;
; 0000 0B22                         Address[5] = 0;
; 0000 0B23                         }
; 0000 0B24                         else{
	RJMP _0x447
_0x446:
; 0000 0B25                             if(SUMMER_TIME_TURNED_ON==0){
	CALL SUBOPT_0x35
	CPI  R30,0
	BRNE _0x448
; 0000 0B26                             SUMMER_TIME_TURNED_ON = 1;
	LDI  R26,LOW(_SUMMER_TIME_TURNED_ON)
	LDI  R27,HIGH(_SUMMER_TIME_TURNED_ON)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0B27                             IS_CLOCK_SUMMER = IsSummerTime(RealTimeMonth, RealTimeDay, RealTimeWeekDay);
	CALL SUBOPT_0x3C
	LDI  R26,LOW(_IS_CLOCK_SUMMER)
	LDI  R27,HIGH(_IS_CLOCK_SUMMER)
	RJMP _0x4D6
; 0000 0B28                             }
; 0000 0B29                             else{
_0x448:
; 0000 0B2A                             SUMMER_TIME_TURNED_ON = 0;
	LDI  R26,LOW(_SUMMER_TIME_TURNED_ON)
	LDI  R27,HIGH(_SUMMER_TIME_TURNED_ON)
	LDI  R30,LOW(0)
_0x4D6:
	CALL __EEPROMWRB
; 0000 0B2B                             }
; 0000 0B2C                         }
_0x447:
; 0000 0B2D                     }
; 0000 0B2E 
; 0000 0B2F                     if(RefreshLcd>=1){
_0x445:
_0x444:
_0x441:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x44A
; 0000 0B30                     lcd_putsf(" -=VASAROS LAIKAS=- ");
	__POINTW1FN _0x0,1824
	CALL SUBOPT_0x2E
; 0000 0B31                     lcd_putsf("PADETIS: ");
	__POINTW1FN _0x0,1845
	CALL SUBOPT_0x2E
; 0000 0B32                         if(SUMMER_TIME_TURNED_ON==0){
	CALL SUBOPT_0x35
	CPI  R30,0
	BRNE _0x44B
; 0000 0B33                         lcd_putsf("ISJUNGTAS");
	__POINTW1FN _0x0,1855
	RJMP _0x4D7
; 0000 0B34                         }
; 0000 0B35                         else{
_0x44B:
; 0000 0B36                         lcd_putsf("IJUNGTAS");
	__POINTW1FN _0x0,1865
_0x4D7:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0B37                         }
; 0000 0B38 
; 0000 0B39                         if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x44D
; 0000 0B3A                         lcd_gotoxy(19,0);
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x4D8
; 0000 0B3B                         lcd_putchar('<');
; 0000 0B3C                         }
; 0000 0B3D                         else{
_0x44D:
; 0000 0B3E                         lcd_gotoxy(19,1);
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x4D8:
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0B3F                         lcd_putchar('<');
	LDI  R30,LOW(60)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0B40                         }
; 0000 0B41                     }
; 0000 0B42                 }
_0x44A:
; 0000 0B43                 else if(Address[1]==4){
	RJMP _0x44F
_0x43E:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x450
; 0000 0B44                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x451
; 0000 0B45                         if(RealTimePrecisioningValue>-29){
	CALL SUBOPT_0x39
	MOV  R26,R30
	LDI  R30,LOW(227)
	CP   R30,R26
	BRGE _0x452
; 0000 0B46                         RealTimePrecisioningValue--;
	CALL SUBOPT_0x39
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
; 0000 0B47                         }
; 0000 0B48                         else{
	RJMP _0x453
_0x452:
; 0000 0B49                         RealTimePrecisioningValue = -29;
	LDI  R26,LOW(_RealTimePrecisioningValue)
	LDI  R27,HIGH(_RealTimePrecisioningValue)
	LDI  R30,LOW(227)
	CALL __EEPROMWRB
; 0000 0B4A                         }
_0x453:
; 0000 0B4B                     }
; 0000 0B4C                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x454
_0x451:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x455
; 0000 0B4D                         if(RealTimePrecisioningValue<29){
	CALL SUBOPT_0x39
	CPI  R30,LOW(0x1D)
	BRGE _0x456
; 0000 0B4E                         RealTimePrecisioningValue++;
	CALL SUBOPT_0x39
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 0B4F                         }
; 0000 0B50                         else{
	RJMP _0x457
_0x456:
; 0000 0B51                         RealTimePrecisioningValue = 29;
	LDI  R26,LOW(_RealTimePrecisioningValue)
	LDI  R27,HIGH(_RealTimePrecisioningValue)
	LDI  R30,LOW(29)
	CALL __EEPROMWRB
; 0000 0B52                         }
_0x457:
; 0000 0B53                     }
; 0000 0B54                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x458
_0x455:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x459
; 0000 0B55                     Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 0B56                     SelectedRow = 0;
; 0000 0B57                     Address[5] = 0;
; 0000 0B58                     }
; 0000 0B59 
; 0000 0B5A                     if(RefreshLcd>=1){
_0x459:
_0x458:
_0x454:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x45A
; 0000 0B5B                     lcd_putsf("  -=TIKSLINIMAS=-  +");
	__POINTW1FN _0x0,1874
	CALL SUBOPT_0x2E
; 0000 0B5C                     lcd_putsf("LAIKO TIKSLINIMAS   ");
	__POINTW1FN _0x0,1895
	CALL SUBOPT_0x2E
; 0000 0B5D                     lcd_putsf("SEKUNDEMIS PER      ");
	__POINTW1FN _0x0,1916
	CALL SUBOPT_0x2E
; 0000 0B5E                     lcd_putsf("MENESI:  ");
	__POINTW1FN _0x0,1937
	CALL SUBOPT_0x2E
; 0000 0B5F                     lcd_put_number(1,2,1,0,0,RealTimePrecisioningValue);
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
	CALL SUBOPT_0x39
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL __CWD1
	CALL __PUTPARD1
	CALL _lcd_put_number
; 0000 0B60                     lcd_putsf(" SEC.  -");
	__POINTW1FN _0x0,1947
	CALL SUBOPT_0x2E
; 0000 0B61                     }
; 0000 0B62                 }
_0x45A:
; 0000 0B63                 else if(Address[1]==5){
	RJMP _0x45B
_0x450:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x5)
	BREQ PC+3
	JMP _0x45C
; 0000 0B64                     if(BUTTON[BUTTON_LEFT]==1){
	__GETB2MN _BUTTON_S000000E001,1
	CPI  R26,LOW(0x1)
	BRNE _0x45D
; 0000 0B65                         if(Address[2]>1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRLO _0x45E
; 0000 0B66                         Address[2]--;
	__GETB1MN _Address_G000,2
	SUBI R30,LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0B67                         }
; 0000 0B68                     }
_0x45E:
; 0000 0B69                     else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x45F
_0x45D:
	__GETB2MN _BUTTON_S000000E001,3
	CPI  R26,LOW(0x1)
	BRNE _0x460
; 0000 0B6A                         if(Address[2]<4){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRSH _0x461
; 0000 0B6B                         Address[2]++;
	__GETB1MN _Address_G000,2
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0B6C                         }
; 0000 0B6D                     }
_0x461:
; 0000 0B6E                     else if(BUTTON[BUTTON_DOWN]==1){
	RJMP _0x462
_0x460:
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x463
; 0000 0B6F                         if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x464
; 0000 0B70                         SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0B71                             if(SelectedRow==2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x465
; 0000 0B72                             SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0B73                             }
; 0000 0B74                         }
_0x465:
; 0000 0B75                         else if(Address[2]==1){
	RJMP _0x466
_0x464:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x467
; 0000 0B76                             if(entering_code>=1000){
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLO _0x468
; 0000 0B77                             entering_code += -1000;
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 0B78                             }
; 0000 0B79                         }
_0x468:
; 0000 0B7A                         else if(Address[2]==2){
	RJMP _0x469
_0x467:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x46A
; 0000 0B7B                         unsigned int a;
; 0000 0B7C                         a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x5E
;	a -> Y+0
; 0000 0B7D                             if(a>=100){
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0x46B
; 0000 0B7E                             entering_code += -100;
	CALL SUBOPT_0x5F
; 0000 0B7F                             }
; 0000 0B80                         }
_0x46B:
	RJMP _0x4D9
; 0000 0B81                         else if(Address[2]==3){
_0x46A:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x46D
; 0000 0B82                         unsigned int a;
; 0000 0B83                         a = entering_code - ((entering_code/100) * 100);
	CALL SUBOPT_0x60
;	a -> Y+0
; 0000 0B84                             if(a>=10){
	BRLO _0x46E
; 0000 0B85                             entering_code += -10;
	CALL SUBOPT_0x61
; 0000 0B86                             }
; 0000 0B87                         }
_0x46E:
	RJMP _0x4D9
; 0000 0B88                         else if(Address[2]==4){
_0x46D:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x470
; 0000 0B89                         unsigned int a;
; 0000 0B8A                         a = entering_code - ((entering_code/10) * 10);
	CALL SUBOPT_0x62
;	a -> Y+0
; 0000 0B8B                             if(a>=1){
	BRLO _0x471
; 0000 0B8C                             entering_code += -1;
	CALL SUBOPT_0x63
; 0000 0B8D                             }
; 0000 0B8E                         }
_0x471:
_0x4D9:
	ADIW R28,2
; 0000 0B8F                     }
_0x470:
_0x469:
_0x466:
; 0000 0B90                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x472
_0x463:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x473
; 0000 0B91                         if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x474
; 0000 0B92                         SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0B93                             if(SelectedRow==2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x475
; 0000 0B94                             SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0B95                             }
; 0000 0B96                         }
_0x475:
; 0000 0B97                         else if(Address[2]==1){
	RJMP _0x476
_0x474:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x477
; 0000 0B98                             if(entering_code<9000){
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x2328)
	LDI  R30,HIGH(0x2328)
	CPC  R27,R30
	BRSH _0x478
; 0000 0B99                             entering_code += 1000;
	CALL SUBOPT_0x64
; 0000 0B9A                             }
; 0000 0B9B                         }
_0x478:
; 0000 0B9C                         else if(Address[2]==2){
	RJMP _0x479
_0x477:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x47A
; 0000 0B9D                         unsigned int a;
; 0000 0B9E                         a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x5E
;	a -> Y+0
; 0000 0B9F                             if(a<900){
	CPI  R26,LOW(0x384)
	LDI  R30,HIGH(0x384)
	CPC  R27,R30
	BRSH _0x47B
; 0000 0BA0                             entering_code += 100;
	CALL SUBOPT_0x65
; 0000 0BA1                             }
; 0000 0BA2                         }
_0x47B:
	ADIW R28,2
; 0000 0BA3                         else if(Address[2]==3){
	RJMP _0x47C
_0x47A:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x47D
; 0000 0BA4                         unsigned char a;
; 0000 0BA5                         a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x66
;	a -> Y+0
; 0000 0BA6                         a = a - ((a/100) * 100);
	CALL SUBOPT_0x67
; 0000 0BA7                             if(a<90){
	LD   R26,Y
	CPI  R26,LOW(0x5A)
	BRSH _0x47E
; 0000 0BA8                             entering_code += 10;
	CALL SUBOPT_0x68
; 0000 0BA9                             }
; 0000 0BAA                         }
_0x47E:
	RJMP _0x4DA
; 0000 0BAB                         else if(Address[2]==4){
_0x47D:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x480
; 0000 0BAC                         unsigned char a;
; 0000 0BAD                         a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x66
;	a -> Y+0
; 0000 0BAE                         a = a - ((a/100) * 100);
	CALL SUBOPT_0x67
; 0000 0BAF                         a = a - ((a/10) * 10);
	LDD  R22,Y+0
	CLR  R23
	CALL SUBOPT_0x44
	CALL SUBOPT_0x69
; 0000 0BB0                             if(a<9){
	BRSH _0x481
; 0000 0BB1                             entering_code += 1;
	CALL SUBOPT_0x6A
; 0000 0BB2                             }
; 0000 0BB3                         }
_0x481:
_0x4DA:
	ADIW R28,1
; 0000 0BB4                     }
_0x480:
_0x47C:
_0x479:
_0x476:
; 0000 0BB5                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x482
_0x473:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x483
; 0000 0BB6                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x484
; 0000 0BB7                         Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 0BB8                         SelectedRow = 0;
; 0000 0BB9                         Address[5] = 0;
; 0000 0BBA                         }
; 0000 0BBB                         else if(SelectedRow==1){
	RJMP _0x485
_0x484:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x486
; 0000 0BBC                             if(IS_LOCK_TURNED_ON==1){
	CALL SUBOPT_0x37
	CPI  R30,LOW(0x1)
	BRNE _0x487
; 0000 0BBD                             IS_LOCK_TURNED_ON = 0;
	LDI  R26,LOW(_IS_LOCK_TURNED_ON)
	LDI  R27,HIGH(_IS_LOCK_TURNED_ON)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0BBE                             CODE = 0;
	CALL SUBOPT_0x38
; 0000 0BBF                             }
; 0000 0BC0                             else{
	RJMP _0x488
_0x487:
; 0000 0BC1                             IS_LOCK_TURNED_ON = 1;
	LDI  R26,LOW(_IS_LOCK_TURNED_ON)
	LDI  R27,HIGH(_IS_LOCK_TURNED_ON)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0BC2                             CODE = 0;
	CALL SUBOPT_0x38
; 0000 0BC3                             UNLOCKED = 1;
	LDI  R30,LOW(1)
	STS  _UNLOCKED_S000000E000,R30
; 0000 0BC4                             }
_0x488:
; 0000 0BC5                         SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0BC6                         Address[5] = 0;
; 0000 0BC7                         }
; 0000 0BC8                         else if(SelectedRow==3){
	RJMP _0x489
_0x486:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x48A
; 0000 0BC9                             if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x48B
; 0000 0BCA                             Address[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0BCB                             }
; 0000 0BCC                             else{
	RJMP _0x48C
_0x48B:
; 0000 0BCD                             Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
; 0000 0BCE                             CODE = entering_code;
	CALL SUBOPT_0x5C
	LDI  R26,LOW(_CODE)
	LDI  R27,HIGH(_CODE)
	CALL __EEPROMWRW
; 0000 0BCF                             UNLOCKED = 1;
	LDI  R30,LOW(1)
	STS  _UNLOCKED_S000000E000,R30
; 0000 0BD0 
; 0000 0BD1                             SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0BD2                             Address[5] = 0;
; 0000 0BD3                             }
_0x48C:
; 0000 0BD4                         entering_code = 0;
	CALL SUBOPT_0x6B
; 0000 0BD5                         }
; 0000 0BD6                     }
_0x48A:
_0x489:
_0x485:
; 0000 0BD7 
; 0000 0BD8                     if(RefreshLcd>=1){
_0x483:
_0x482:
_0x472:
_0x462:
_0x45F:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x48D
; 0000 0BD9                     lcd_putsf("     -=KODAS=-      ");
	__POINTW1FN _0x0,1956
	CALL SUBOPT_0x2E
; 0000 0BDA                         if(IS_LOCK_TURNED_ON==1){
	CALL SUBOPT_0x37
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x48E
; 0000 0BDB                         RowsOnWindow = 4;
	LDI  R30,LOW(4)
	STS  _RowsOnWindow_G000,R30
; 0000 0BDC                         lcd_putsf("1.ISJUNGTI KODA?    ");
	__POINTW1FN _0x0,1977
	CALL SUBOPT_0x2E
; 0000 0BDD                         lcd_putsf("2.KODAS:     ");
	__POINTW1FN _0x0,1998
	CALL SUBOPT_0x2E
; 0000 0BDE                             if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x48F
; 0000 0BDF                             lcd_putsf("****   ");
	__POINTW1FN _0x0,2012
	CALL SUBOPT_0x2E
; 0000 0BE0                             lcd_putsf("         REDAGUOTI?");
	__POINTW1FN _0x0,2020
	CALL SUBOPT_0x2E
; 0000 0BE1                             }
; 0000 0BE2                             else{
	RJMP _0x490
_0x48F:
; 0000 0BE3                             unsigned int i;
; 0000 0BE4                             lcd_gotoxy(13,2);
	SBIW R28,2
;	i -> Y+0
	LDI  R30,LOW(13)
	CALL SUBOPT_0x55
; 0000 0BE5                             i = entering_code;
	CALL SUBOPT_0x5C
	ST   Y,R30
	STD  Y+1,R31
; 0000 0BE6                                 if(Address[2]==1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x491
; 0000 0BE7                                 lcd_putchar( NumToIndex( i/1000) );
	CALL SUBOPT_0x6C
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x4DB
; 0000 0BE8                                 }
; 0000 0BE9                                 else{
_0x491:
; 0000 0BEA                                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x4DB:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0BEB                                 }
; 0000 0BEC                             i = i - (i/1000)*1000;
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
; 0000 0BED                                 if(Address[2]==2){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x493
; 0000 0BEE                                 lcd_putchar( NumToIndex( i/100) );
	CALL SUBOPT_0x6E
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x4DC
; 0000 0BEF                                 }
; 0000 0BF0                                 else{
_0x493:
; 0000 0BF1                                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x4DC:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0BF2                                 }
; 0000 0BF3                             i = i - (i/100)*100;
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6F
; 0000 0BF4                                 if(Address[2]==3){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x495
; 0000 0BF5                                 lcd_putchar( NumToIndex( i/10) );
	CALL SUBOPT_0x70
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x4DD
; 0000 0BF6                                 }
; 0000 0BF7                                 else{
_0x495:
; 0000 0BF8                                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x4DD:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0BF9                                 }
; 0000 0BFA                             i = i - (i/10)*10;
	CALL SUBOPT_0x70
	CALL SUBOPT_0x71
; 0000 0BFB                                 if(Address[2]==4){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x497
; 0000 0BFC                                 lcd_putchar( NumToIndex(i) );
	LD   R30,Y
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x4DE
; 0000 0BFD                                 }
; 0000 0BFE                                 else{
_0x497:
; 0000 0BFF                                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x4DE:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0C00                                 }
; 0000 0C01                             lcd_gotoxy(0,3);
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
; 0000 0C02                                 if(Address[2]==1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x499
; 0000 0C03                                 lcd_putsf("             ^");
	__POINTW1FN _0x0,1128
	RJMP _0x4DF
; 0000 0C04                                 }
; 0000 0C05                                 else if(Address[2]==2){
_0x499:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x49B
; 0000 0C06                                 lcd_putsf("              ^");
	__POINTW1FN _0x0,1127
	RJMP _0x4DF
; 0000 0C07                                 }
; 0000 0C08                                 else if(Address[2]==3){
_0x49B:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x49D
; 0000 0C09                                 lcd_putsf("               ^");
	__POINTW1FN _0x0,1126
	RJMP _0x4DF
; 0000 0C0A                                 }
; 0000 0C0B                                 else if(Address[2]==4){
_0x49D:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x49F
; 0000 0C0C                                 lcd_putsf("                ^");
	__POINTW1FN _0x0,1143
_0x4DF:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0C0D                                 }
; 0000 0C0E                             }
_0x49F:
	ADIW R28,2
_0x490:
; 0000 0C0F                         }
; 0000 0C10                         else{
	RJMP _0x4A0
_0x48E:
; 0000 0C11                         RowsOnWindow = 2;
	LDI  R30,LOW(2)
	STS  _RowsOnWindow_G000,R30
; 0000 0C12                         lcd_putsf("1. IJUNGTI KODA?");
	__POINTW1FN _0x0,2040
	CALL SUBOPT_0x2E
; 0000 0C13                         }
_0x4A0:
; 0000 0C14                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0xA6
; 0000 0C15                     lcd_putchar('<');
; 0000 0C16                     }
; 0000 0C17                 }
_0x48D:
; 0000 0C18                 else if(Address[1]==6){
	RJMP _0x4A1
_0x45C:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x6)
	BREQ PC+3
	JMP _0x4A2
; 0000 0C19                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000E001,4
	CPI  R26,LOW(0x1)
	BRNE _0x4A3
; 0000 0C1A                         if(BELL_OUTPUT_ADDRESS>17){
	CALL SUBOPT_0x34
	CPI  R30,LOW(0x12)
	BRLO _0x4A4
; 0000 0C1B                         BELL_OUTPUT_ADDRESS--;
	CALL SUBOPT_0x34
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
; 0000 0C1C                         }
; 0000 0C1D                     }
_0x4A4:
; 0000 0C1E                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x4A5
_0x4A3:
	LDS  R26,_BUTTON_S000000E001
	CPI  R26,LOW(0x1)
	BRNE _0x4A6
; 0000 0C1F                         if(BELL_OUTPUT_ADDRESS<22){
	CALL SUBOPT_0x34
	CPI  R30,LOW(0x16)
	BRSH _0x4A7
; 0000 0C20                         BELL_OUTPUT_ADDRESS++;
	CALL SUBOPT_0x34
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 0C21                         }
; 0000 0C22                     }
_0x4A7:
; 0000 0C23                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x4A8
_0x4A6:
	__GETB2MN _BUTTON_S000000E001,2
	CPI  R26,LOW(0x1)
	BRNE _0x4A9
; 0000 0C24                     Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 0C25                     SelectedRow = 0;
; 0000 0C26                     Address[5] = 0;
; 0000 0C27                     }
; 0000 0C28 
; 0000 0C29                     if(RefreshLcd>=1){
_0x4A9:
_0x4A8:
_0x4A5:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x4AA
; 0000 0C2A                     lcd_putsf("    -=ISVADAI=-    +");
	__POINTW1FN _0x0,2057
	CALL SUBOPT_0x2E
; 0000 0C2B                     lcd_putsf("1. VARPU ISEJ.: ");
	__POINTW1FN _0x0,2078
	CALL SUBOPT_0x2E
; 0000 0C2C                     lcd_put_number(0,2,0,0,BELL_OUTPUT_ADDRESS,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x34
	CALL SUBOPT_0x89
; 0000 0C2D                     lcd_putsf(" <");
	__POINTW1FN _0x0,1772
	CALL SUBOPT_0x2E
; 0000 0C2E                     lcd_gotoxy(19,3);lcd_putchar('-');
	CALL SUBOPT_0x4C
	LDI  R30,LOW(45)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0C2F                     }
; 0000 0C30                 }
_0x4AA:
; 0000 0C31             }
_0x4A2:
_0x4A1:
_0x45B:
_0x44F:
_0x43D:
_0x42A:
_0x420:
; 0000 0C32         }
_0x406:
_0x405:
_0x229:
_0x1CB:
_0x18F:
_0x17A:
_0x149:
; 0000 0C33 
; 0000 0C34         if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x4AB
; 0000 0C35         RefreshLcd--;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,LOW(1)
	STS  _RefreshLcd_G000,R30
; 0000 0C36         }
; 0000 0C37     //////////////////////////////////////////////////////////////////////////////////
; 0000 0C38     //////////////////////////////////////////////////////////////////////////////////
; 0000 0C39     //////////////////////////////////////////////////////////////////////////////////
; 0000 0C3A     TimeRefreshed = 0;
_0x4AB:
	LDI  R30,LOW(0)
	STS  _TimeRefreshed_S000000E001,R30
; 0000 0C3B     delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0C3C     }
	JMP  _0xDE
; 0000 0C3D }
_0x4AC:
	RJMP _0x4AC

	.CSEG
_rtc_read:
	ST   -Y,R17
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xBB
	MOV  R17,R30
	CALL _i2c_stop
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2060003
_rtc_write:
	CALL SUBOPT_0xB9
	LD   R30,Y
	CALL SUBOPT_0xBC
	JMP  _0x2060003
_rtc_init:
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	CALL SUBOPT_0xBD
	LDI  R30,LOW(7)
	CALL SUBOPT_0xBE
	CALL SUBOPT_0xBC
	JMP  _0x2060002
_rtc_get_time:
	CALL SUBOPT_0xBD
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_write
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xBF
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	CALL SUBOPT_0xBF
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	CALL SUBOPT_0xBB
	ST   -Y,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RJMP _0x2060004
_rtc_set_time:
	CALL SUBOPT_0xBD
	LDI  R30,LOW(0)
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xC1
	CALL SUBOPT_0xBE
	ST   -Y,R30
	CALL _bin2bcd
	CALL SUBOPT_0xBC
	JMP  _0x2060002
_rtc_get_date:
	CALL SUBOPT_0xBD
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _i2c_write
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xBF
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0xBF
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	CALL SUBOPT_0xBB
	ST   -Y,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
_0x2060004:
	ST   X,R30
	CALL _i2c_stop
	ADIW R28,6
	RET
_rtc_set_date:
	CALL SUBOPT_0xBD
	LDI  R30,LOW(4)
	CALL SUBOPT_0xBE
	ST   -Y,R30
	CALL _bin2bcd
	CALL SUBOPT_0xC1
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xBC
	JMP  _0x2060002
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
	JMP  _0x2060001
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
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2060003:
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
	BRLO _0x2020004
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
_0x2020004:
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
	JMP  _0x2060001
_lcd_putsf:
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	LDD  R17,Y+0
_0x2060002:
	ADIW R28,3
	RET
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
	RJMP _0x2060001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xC2
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0xC3
	LDI  R30,LOW(4)
	CALL SUBOPT_0xC3
	LDI  R30,LOW(133)
	CALL SUBOPT_0xC3
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x2060001
_0x202000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2060001:
	ADIW R28,1
	RET

	.CSEG
_bcd2bin:
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
_bin2bcd:
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret

	.ESEG
_BELL_OUTPUT_ADDRESS:
	.BYTE 0x1
_SUMMER_TIME_TURNED_ON:
	.BYTE 0x1
_IS_CLOCK_SUMMER:
	.BYTE 0x1
_RealTimePrecisioningValue:
	.BYTE 0x1
_CODE:
	.BYTE 0x2
_IS_LOCK_TURNED_ON:
	.BYTE 0x1

	.DSEG
_MAIN_MENU_TIMER:
	.BYTE 0x1
_LCD_LED_TIMER:
	.BYTE 0x1

	.ESEG
_BELL_TIME:
	.BYTE 0x30C

	.DSEG
_RefreshTime:
	.BYTE 0x1
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
_STAND_BY_S000000E000:
	.BYTE 0x1
_UNLOCKED_S000000E000:
	.BYTE 0x1
_SecondCounter_S000000E001:
	.BYTE 0x2
_TimeRefreshed_S000000E001:
	.BYTE 0x1
_TIME_EDITING_S000000E002:
	.BYTE 0x1
_CALL_BELL_S000000E004:
	.BYTE 0x2
_BUTTON_S000000E001:
	.BYTE 0x5
_ButtonFilter_S000000E001:
	.BYTE 0x5
_lcd_led_counter_S000000E001:
	.BYTE 0x1
_stand_by_pos_S000000E002:
	.BYTE 0x2
_entering_code_S000000E002:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	CALL __DIVW21U
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ADIW R30,1
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	ADIW R30,1
	MOVW R18,R30
	__MULBNWRU 18,19,3
	CALL __LSRW2
	SBIW R30,12
	MOVW R20,R30
	__MULBNWRU 18,19,8
	ADIW R30,5
	MOVW R26,R30
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CALL __DIVW21U
	SBIW R30,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(5)
	CALL __MULB1W2U
	CALL __LSRW2
	SUB  R30,R20
	SBC  R31,R21
	SBIW R30,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	__MULBNWRU 16,17,11
	ADIW R30,20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ADD  R30,R26
	ADC  R31,R27
	SUB  R30,R20
	SBC  R31,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __DIVW21U
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __DIVW21U
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+10,R26
	STD  Y+10+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDD  R30,Y+6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R31,0
	SBIW R30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xC:
	SBIW R28,10
	CALL __SAVELOCR6
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x11:
	LDD  R22,Y+1
	CLR  R23
	LD   R30,Y
	LDI  R31,0
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:162 WORDS
SUBOPT_0x12:
	LDD  R30,Y+4
	LDI  R26,LOW(60)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_BELL_TIME)
	SBCI R31,HIGH(-_BELL_TIME)
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	MOVW R22,R26
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	CALL __EEPROMRDB
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __EEPROMRDB
	STD  Y+2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x17:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	MOV  R30,R17
	ADIW R28,3
	LDD  R17,Y+0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:207 WORDS
SUBOPT_0x18:
	LDD  R30,Y+14
	LDI  R26,LOW(60)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_BELL_TIME)
	SBCI R31,HIGH(-_BELL_TIME)
	MOVW R26,R30
	LDD  R30,Y+11
	LDI  R31,0
	MOVW R22,R26
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x19:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1A:
	STD  Y+4,R30
	LDD  R30,Y+1
	STD  Y+5,R30
	LDD  R30,Y+2
	STD  Y+6,R30
	LDI  R30,LOW(1)
	STD  Y+3,R30
	LDD  R30,Y+11
	STD  Y+10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1B:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1C:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1D:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 183 TIMES, CODE SIZE REDUCTION:361 WORDS
SUBOPT_0x1E:
	LDI  R31,0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1F:
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x20:
	__GETB1MN _Address_G000,5
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x22:
	__GETD2N 0xA
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	__GETD1S 6
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x21
	CALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	__SUBD1N 1
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(46)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x2B:
	RCALL SUBOPT_0x24
	CALL __DIVD21U
	ST   Y,R30
	ST   -Y,R30
	CALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
	LD   R26,Y
	CLR  R27
	RCALL SUBOPT_0x2A
	CALL __CWD2
	CALL __MULD12U
	RCALL SUBOPT_0x24
	CALL __SUBD21
	__PUTD2S 1
	__GETD2S 6
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	CALL _i2c_init
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	JMP  _rtc_init

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	STS  _LCD_LED_TIMER,R30
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	CALL __EEPROMRDB
	STS  _lcd_light_now_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 121 TIMES, CODE SIZE REDUCTION:237 WORDS
SUBOPT_0x2E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 54 TIMES, CODE SIZE REDUCTION:103 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 52 TIMES, CODE SIZE REDUCTION:405 WORDS
SUBOPT_0x31:
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	JMP  _lcd_put_number

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x33:
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x34:
	LDI  R26,LOW(_BELL_OUTPUT_ADDRESS)
	LDI  R27,HIGH(_BELL_OUTPUT_ADDRESS)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	LDI  R26,LOW(_SUMMER_TIME_TURNED_ON)
	LDI  R27,HIGH(_SUMMER_TIME_TURNED_ON)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDI  R26,LOW(_IS_CLOCK_SUMMER)
	LDI  R27,HIGH(_IS_CLOCK_SUMMER)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	LDI  R26,LOW(_IS_LOCK_TURNED_ON)
	LDI  R27,HIGH(_IS_LOCK_TURNED_ON)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	LDI  R26,LOW(_CODE)
	LDI  R27,HIGH(_CODE)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x39:
	LDI  R26,LOW(_RealTimePrecisioningValue)
	LDI  R27,HIGH(_RealTimePrecisioningValue)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3B:
	ST   -Y,R31
	ST   -Y,R30
	CALL _rtc_get_time
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _rtc_get_date

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	ST   -Y,R4
	ST   -Y,R7
	ST   -Y,R8
	JMP  _IsSummerTime

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R11
	CALL _rtc_set_time
	LDI  R26,LOW(_IS_CLOCK_SUMMER)
	LDI  R27,HIGH(_IS_CLOCK_SUMMER)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	MOV  R30,R5
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R4
	ST   -Y,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x3F:
	LDD  R30,Y+3
	LDI  R26,LOW(60)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_BELL_TIME)
	SBCI R31,HIGH(-_BELL_TIME)
	MOVW R26,R30
	LDD  R30,Y+4
	LDI  R31,0
	MOVW R22,R26
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:96 WORDS
SUBOPT_0x40:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x41:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __EEPROMRDB
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x42:
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
SUBOPT_0x43:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_ButtonFilter_S000000E001)
	SBCI R31,HIGH(-_ButtonFilter_S000000E001)
	LD   R26,Z
	CPI  R26,LOW(0x14)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x44:
	LD   R26,Y
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_BUTTON_S000000E001)
	SBCI R31,HIGH(-_BUTTON_S000000E001)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x46:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(124)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x47

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x49:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4A:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4C:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	LDI  R30,LOW(94)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:141 WORDS
SUBOPT_0x50:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x51:
	MOV  R30,R6
	LDI  R31,0
	CALL __CWD1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	__POINTW1FN _0x0,104
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x53:
	MOV  R30,R9
	LDI  R31,0
	CALL __CWD1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	MOV  R30,R11
	LDI  R31,0
	CALL __CWD1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x55:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x56:
	MOV  R30,R5
	LDI  R31,0
	CALL __CWD1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x57:
	__POINTW1FN _0x0,56
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x58:
	MOV  R30,R4
	LDI  R31,0
	CALL __CWD1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x59:
	MOV  R30,R7
	LDI  R31,0
	CALL __CWD1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	__POINTW1FN _0x0,99
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x5B:
	LDS  R26,_entering_code_S000000E002
	LDS  R27,_entering_code_S000000E002+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x5C:
	LDS  R30,_entering_code_S000000E002
	LDS  R31,_entering_code_S000000E002+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	SUBI R30,LOW(-64536)
	SBCI R31,HIGH(-64536)
	STS  _entering_code_S000000E002,R30
	STS  _entering_code_S000000E002+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x5E:
	SBIW R28,2
	RCALL SUBOPT_0x5B
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12U
	RCALL SUBOPT_0x5B
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	RCALL SUBOPT_0x5C
	SUBI R30,LOW(-65436)
	SBCI R31,HIGH(-65436)
	STS  _entering_code_S000000E002,R30
	STS  _entering_code_S000000E002+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x60:
	SBIW R28,2
	RCALL SUBOPT_0x5B
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12U
	RCALL SUBOPT_0x5B
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
	SBIW R26,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	RCALL SUBOPT_0x5C
	SUBI R30,LOW(-65526)
	SBCI R31,HIGH(-65526)
	STS  _entering_code_S000000E002,R30
	STS  _entering_code_S000000E002+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x62:
	SBIW R28,2
	RCALL SUBOPT_0x5B
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	RCALL SUBOPT_0x5B
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x63:
	RCALL SUBOPT_0x5C
	SUBI R30,LOW(-65535)
	SBCI R31,HIGH(-65535)
	STS  _entering_code_S000000E002,R30
	STS  _entering_code_S000000E002+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x64:
	RCALL SUBOPT_0x5C
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	STS  _entering_code_S000000E002,R30
	STS  _entering_code_S000000E002+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x65:
	RCALL SUBOPT_0x5C
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _entering_code_S000000E002,R30
	STS  _entering_code_S000000E002+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x66:
	SBIW R28,1
	RCALL SUBOPT_0x5B
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12U
	RCALL SUBOPT_0x5B
	CALL __SWAPW12
	SUB  R30,R26
	ST   Y,R30
	LDD  R22,Y+0
	CLR  R23
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x67:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x68:
	RCALL SUBOPT_0x5C
	ADIW R30,10
	STS  _entering_code_S000000E002,R30
	STS  _entering_code_S000000E002+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x69:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	ST   Y,R30
	LD   R26,Y
	CPI  R26,LOW(0x9)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6A:
	RCALL SUBOPT_0x5C
	ADIW R30,1
	STS  _entering_code_S000000E002,R30
	STS  _entering_code_S000000E002+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	LDI  R30,LOW(0)
	STS  _entering_code_S000000E002,R30
	STS  _entering_code_S000000E002+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6C:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6D:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12U
	LD   R26,Y
	LDD  R27,Y+1
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6E:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6F:
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12U
	LD   R26,Y
	LDD  R27,Y+1
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x70:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x71:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	LD   R26,Y
	LDD  R27,Y+1
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x72:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _SelectAnotherRow

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x73:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _SelectAnotherRow

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0x74:
	LDI  R30,LOW(0)
	STS  _SelectedRow_G000,R30
	__PUTB1MN _Address_G000,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x75:
	STS  _RowsOnWindow_G000,R30
	__GETB1MN _Address_G000,5
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x76:
	ADIW R30,4
	LDD  R26,Y+1
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x77:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDD  R30,Y+1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x78:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDS  R26,_SelectedRow_G000
	CLR  R27
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x79:
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _lcd_gotoxy
	LDI  R30,LOW(60)
	ST   -Y,R30
	CALL _lcd_putchar
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	MOV  R30,R6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7B:
	MOV  R30,R9
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7C:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7D:
	__POINTW1FN _0x0,218
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7E:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDS  R30,_SelectedRow_G000
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(60)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x7F:
	MOV  R30,R5
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R4
	JMP  _DayCountInMonth

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x80:
	LDI  R31,0
	SBIW R30,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x81:
	__POINTW1FN _0x0,581
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x82:
	LDS  R30,_SelectedRow_G000
	__PUTB1MN _Address_G000,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 48 TIMES, CODE SIZE REDUCTION:91 WORDS
SUBOPT_0x83:
	__GETB1MN _Address_G000,2
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x84:
	ST   -Y,R30
	CALL _GetBellId
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x85:
	ST   -Y,R30
	LDD  R30,Y+3
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x86:
	CALL __CWD1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x87:
	__POINTW1FN _0x0,465
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0x88:
	LDI  R26,LOW(60)
	LDI  R27,HIGH(60)
	CALL __MULW12U
	SUBI R30,LOW(-_BELL_TIME)
	SBCI R31,HIGH(-_BELL_TIME)
	MOVW R26,R30
	LDD  R30,Y+4
	LDI  R31,0
	MOVW R22,R26
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x89:
	LDI  R31,0
	RJMP SUBOPT_0x86

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8A:
	LDI  R30,LOW(58)
	ST   -Y,R30
	CALL _lcd_putchar
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8B:
	__POINTW1FN _0x0,1090
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 117 TIMES, CODE SIZE REDUCTION:1041 WORDS
SUBOPT_0x8C:
	LDI  R26,LOW(60)
	LDI  R27,HIGH(60)
	CALL __MULW12U
	SUBI R30,LOW(-_BELL_TIME)
	SBCI R31,HIGH(-_BELL_TIME)
	MOVW R26,R30
	__GETB1MN _Address_G000,3
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:171 WORDS
SUBOPT_0x8D:
	MOVW R22,R26
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R26,R22
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:171 WORDS
SUBOPT_0x8E:
	MOVW R22,R26
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R26,R22
	RJMP SUBOPT_0x40

;OPTIMIZER ADDED SUBROUTINE, CALLED 58 TIMES, CODE SIZE REDUCTION:225 WORDS
SUBOPT_0x8F:
	MOVW R22,R26
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x90:
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	MOVW R26,R30
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x91:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x92:
	SBIW R30,10
	MOVW R26,R30
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 47 TIMES, CODE SIZE REDUCTION:89 WORDS
SUBOPT_0x93:
	LDI  R31,0
	ADIW R30,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x94:
	LDI  R31,0
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x95:
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x96:
	ADIW R30,10
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x97:
	ADIW R30,1
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x98:
	__GETB1MN _Address_G000,4
	SUBI R30,LOW(1)
	__PUTB1MN _Address_G000,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x99:
	__GETB1MN _Address_G000,4
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9A:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x83

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9B:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x83

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9C:
	__POINTW1FN _0x0,1105
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9D:
	LDI  R30,LOW(41)
	ST   -Y,R30
	CALL _lcd_putchar
	__POINTW1FN _0x0,102
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9E:
	__POINTW1FN _0x0,303
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9F:
	__POINTW1FN _0x0,313
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA0:
	__POINTW1FN _0x0,324
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA1:
	__POINTW1FN _0x0,337
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA2:
	__POINTW1FN _0x0,1126
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA3:
	__POINTW1FN _0x0,1143
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA4:
	__POINTW1FN _0x0,1161
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA5:
	__POINTW1FN _0x0,1180
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xA6:
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _lcd_gotoxy
	LDI  R30,LOW(60)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA7:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA8:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA9:
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	LDI  R30,LOW(20)
	RJMP SUBOPT_0x75

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAA:
	__GETB1MN _Address_G000,2
	LDI  R31,0
	ADIW R30,6
	RJMP SUBOPT_0x88

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:213 WORDS
SUBOPT_0xAB:
	__GETB1MN _Address_G000,2
	LDI  R31,0
	ADIW R30,6
	RJMP SUBOPT_0x8C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xAC:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0xAB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAD:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0xAB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAE:
	MOV  R30,R5
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xAF:
	CALL _GetEasterMonth
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB0:
	CALL _GetEasterDay
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB1:
	MOV  R30,R5
	LDI  R31,0
	ADIW R30,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0xB2:
	__GETB1MN _Address_G000,2
	RJMP SUBOPT_0x93

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB3:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0xB2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB4:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0xB2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB6:
	MOVW R26,R30
	__GETB1MN _Address_G000,3
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB7:
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _Address_G000,4
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB8:
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _Address_G000,3
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB9:
	CALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+1
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBA:
	CALL _i2c_start
	LDI  R30,LOW(209)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBB:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xBC:
	ST   -Y,R30
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xBD:
	CALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBE:
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xBF:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC0:
	ST   -Y,R30
	CALL _i2c_write
	LD   R30,Y
	ST   -Y,R30
	JMP  _bin2bcd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC1:
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+1
	ST   -Y,R30
	JMP  _bin2bcd

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC2:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC3:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	ret

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

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

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
