
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
	.DB  0x34,0x2E,0x50,0x4F,0x52,0x43,0x49,0x55
	.DB  0x4E,0x4B,0x55,0x4C,0x45,0x0,0x20,0x2D
	.DB  0x3D,0x45,0x49,0x4C,0x49,0x4E,0x49,0x53
	.DB  0x20,0x4C,0x41,0x49,0x4B,0x41,0x53,0x3D
	.DB  0x2D,0x0,0x31,0x2E,0x50,0x49,0x52,0x4D
	.DB  0x41,0x44,0x2E,0x20,0x4C,0x41,0x49,0x4B
	.DB  0x41,0x53,0x0,0x32,0x2E,0x41,0x4E,0x54
	.DB  0x52,0x41,0x44,0x2E,0x20,0x4C,0x41,0x49
	.DB  0x4B,0x41,0x53,0x0,0x33,0x2E,0x54,0x52
	.DB  0x45,0x43,0x49,0x41,0x44,0x2E,0x20,0x4C
	.DB  0x41,0x49,0x4B,0x41,0x53,0x0,0x34,0x2E
	.DB  0x4B,0x45,0x54,0x56,0x49,0x52,0x54,0x41
	.DB  0x44,0x2E,0x20,0x4C,0x41,0x49,0x4B,0x41
	.DB  0x53,0x0,0x35,0x2E,0x50,0x45,0x4E,0x4B
	.DB  0x54,0x41,0x44,0x2E,0x20,0x4C,0x41,0x49
	.DB  0x4B,0x41,0x53,0x0,0x36,0x2E,0x53,0x45
	.DB  0x53,0x54,0x41,0x44,0x2E,0x20,0x4C,0x41
	.DB  0x49,0x4B,0x41,0x53,0x0,0x37,0x2E,0x53
	.DB  0x45,0x4B,0x4D,0x41,0x44,0x2E,0x20,0x4C
	.DB  0x41,0x49,0x4B,0x41,0x53,0x0,0x20,0x20
	.DB  0x2D,0x3D,0x50,0x49,0x52,0x4D,0x41,0x44
	.DB  0x49,0x45,0x4E,0x49,0x53,0x3D,0x2D,0x0
	.DB  0x20,0x20,0x2D,0x3D,0x41,0x4E,0x54,0x52
	.DB  0x41,0x44,0x49,0x45,0x4E,0x49,0x53,0x3D
	.DB  0x2D,0x0,0x20,0x20,0x2D,0x3D,0x54,0x52
	.DB  0x45,0x43,0x49,0x41,0x44,0x49,0x45,0x4E
	.DB  0x49,0x53,0x3D,0x2D,0x0,0x20,0x2D,0x3D
	.DB  0x4B,0x45,0x54,0x56,0x49,0x52,0x54,0x41
	.DB  0x44,0x49,0x45,0x4E,0x49,0x53,0x3D,0x2D
	.DB  0x0,0x20,0x20,0x2D,0x3D,0x50,0x45,0x4E
	.DB  0x4B,0x54,0x41,0x44,0x49,0x45,0x4E,0x49
	.DB  0x53,0x3D,0x2D,0x0,0x20,0x20,0x2D,0x3D
	.DB  0x53,0x45,0x53,0x54,0x41,0x44,0x49,0x45
	.DB  0x4E,0x49,0x53,0x3D,0x2D,0x0,0x20,0x20
	.DB  0x2D,0x3D,0x53,0x45,0x4B,0x4D,0x41,0x44
	.DB  0x49,0x45,0x4E,0x49,0x53,0x3D,0x2D,0x0
	.DB  0x20,0x28,0x0,0x53,0x45,0x43,0x29,0x0
	.DB  0x54,0x55,0x53,0x43,0x49,0x41,0x0,0x20
	.DB  0x2D,0x3D,0x4C,0x41,0x49,0x4B,0x4F,0x20
	.DB  0x4B,0x45,0x49,0x54,0x49,0x4D,0x41,0x53
	.DB  0x3D,0x2D,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x5E,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x5E,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x5E,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x54,0x52,0x49,0x4E,0x54,0x49,0x3F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x2D,0x3D,0x56,0x45,0x4C,0x59,0x4B,0x55
	.DB  0x20,0x4C,0x41,0x49,0x4B,0x41,0x53,0x3D
	.DB  0x2D,0x0,0x31,0x2E,0x56,0x45,0x4C,0x59
	.DB  0x4B,0x55,0x20,0x4B,0x45,0x54,0x56,0x49
	.DB  0x52,0x54,0x41,0x44,0x2E,0x0,0x32,0x2E
	.DB  0x56,0x45,0x4C,0x59,0x4B,0x55,0x20,0x50
	.DB  0x45,0x4E,0x4B,0x54,0x41,0x44,0x2E,0x0
	.DB  0x33,0x2E,0x56,0x45,0x4C,0x59,0x4B,0x55
	.DB  0x20,0x53,0x45,0x53,0x54,0x41,0x44,0x49
	.DB  0x45,0x4E,0x2E,0x0,0x34,0x2E,0x56,0x45
	.DB  0x4C,0x59,0x4B,0x55,0x20,0x53,0x45,0x4B
	.DB  0x4D,0x41,0x44,0x2E,0x0,0x35,0x2E,0x4B
	.DB  0x41,0x44,0x41,0x20,0x42,0x55,0x53,0x20
	.DB  0x56,0x45,0x4C,0x59,0x4B,0x4F,0x53,0x3F
	.DB  0x0,0x2D,0x3D,0x56,0x45,0x4C,0x2E,0x20
	.DB  0x4B,0x45,0x54,0x56,0x49,0x52,0x54,0x41
	.DB  0x44,0x2E,0x3D,0x2D,0x0,0x20,0x2D,0x3D
	.DB  0x56,0x45,0x4C,0x2E,0x20,0x50,0x45,0x4E
	.DB  0x4B,0x54,0x41,0x44,0x2E,0x3D,0x2D,0x0
	.DB  0x20,0x20,0x2D,0x3D,0x56,0x45,0x4C,0x2E
	.DB  0x20,0x53,0x45,0x53,0x54,0x41,0x44,0x2E
	.DB  0x3D,0x2D,0x0,0x20,0x20,0x2D,0x3D,0x56
	.DB  0x45,0x4C,0x2E,0x20,0x53,0x45,0x4B,0x4D
	.DB  0x41,0x44,0x2E,0x3D,0x2D,0x0,0x20,0x20
	.DB  0x2D,0x3D,0x56,0x45,0x4C,0x59,0x4B,0x55
	.DB  0x20,0x44,0x41,0x54,0x4F,0x53,0x3D,0x2D
	.DB  0x20,0x20,0x0,0x31,0x2E,0x20,0x32,0x0
	.DB  0x32,0x2E,0x20,0x32,0x0,0x33,0x2E,0x20
	.DB  0x32,0x0,0x20,0x2D,0x3D,0x4B,0x41,0x4C
	.DB  0x45,0x44,0x55,0x20,0x4C,0x41,0x49,0x4B
	.DB  0x41,0x53,0x3D,0x2D,0x0,0x31,0x2E,0x47
	.DB  0x52,0x55,0x4F,0x44,0x5A,0x49,0x4F,0x20
	.DB  0x32,0x35,0x20,0x44,0x2E,0x0,0x32,0x2E
	.DB  0x47,0x52,0x55,0x4F,0x44,0x5A,0x49,0x4F
	.DB  0x20,0x32,0x36,0x20,0x44,0x2E,0x0,0x20
	.DB  0x2D,0x3D,0x47,0x52,0x55,0x4F,0x44,0x5A
	.DB  0x49,0x4F,0x20,0x32,0x35,0x20,0x44,0x2E
	.DB  0x3D,0x2D,0x0,0x20,0x2D,0x3D,0x47,0x52
	.DB  0x55,0x4F,0x44,0x5A,0x49,0x4F,0x20,0x32
	.DB  0x36,0x20,0x44,0x2E,0x3D,0x2D,0x0,0x20
	.DB  0x20,0x2D,0x3D,0x50,0x4F,0x52,0x43,0x49
	.DB  0x55,0x4E,0x4B,0x55,0x4C,0x45,0x3D,0x2D
	.DB  0x20,0x20,0x0,0x31,0x2E,0x53,0x45,0x4B
	.DB  0x4D,0x41,0x44,0x49,0x45,0x4E,0x49,0x53
	.DB  0x0,0x20,0x20,0x2D,0x3D,0x53,0x45,0x4B
	.DB  0x4D,0x41,0x44,0x49,0x45,0x4E,0x49,0x53
	.DB  0x3D,0x2D,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x2D,0x3D,0x4E,0x55,0x53,0x54,0x41,0x54
	.DB  0x59,0x4D,0x41,0x49,0x3D,0x2D,0x20,0x20
	.DB  0x20,0x0,0x31,0x2E,0x45,0x4B,0x52,0x41
	.DB  0x4E,0x4F,0x20,0x41,0x50,0x53,0x56,0x49
	.DB  0x45,0x54,0x49,0x4D,0x2E,0x0,0x32,0x2E
	.DB  0x56,0x41,0x4C,0x59,0x54,0x49,0x20,0x53
	.DB  0x4B,0x41,0x4D,0x42,0x45,0x4A,0x49,0x4D
	.DB  0x2E,0x0,0x33,0x2E,0x56,0x41,0x53,0x41
	.DB  0x52,0x4F,0x53,0x20,0x4C,0x41,0x49,0x4B
	.DB  0x41,0x53,0x0,0x34,0x2E,0x4C,0x41,0x49
	.DB  0x4B,0x4F,0x20,0x54,0x49,0x4B,0x53,0x4C
	.DB  0x49,0x4E,0x49,0x4D,0x41,0x53,0x0,0x35
	.DB  0x2E,0x56,0x41,0x4C,0x44,0x49,0x4B,0x4C
	.DB  0x49,0x4F,0x20,0x4B,0x4F,0x44,0x41,0x53
	.DB  0x0,0x36,0x2E,0x56,0x41,0x4C,0x44,0x49
	.DB  0x4B,0x4C,0x49,0x4F,0x20,0x49,0x53,0x56
	.DB  0x41,0x44,0x41,0x49,0x0,0x2D,0x3D,0x45
	.DB  0x4B,0x52,0x41,0x4E,0x4F,0x20,0x41,0x50
	.DB  0x53,0x56,0x49,0x45,0x54,0x2E,0x3D,0x2D
	.DB  0x20,0x0,0x41,0x50,0x53,0x56,0x49,0x45
	.DB  0x54,0x49,0x4D,0x41,0x53,0x3A,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x56,0x41
	.DB  0x4C,0x59,0x54,0x49,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x53,0x4B,0x41,0x4D,0x42,0x45,0x4A,0x49
	.DB  0x4D,0x55,0x53,0x3F,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x4E,0x45
	.DB  0x20,0x20,0x20,0x20,0x20,0x54,0x41,0x49
	.DB  0x50,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x5E,0x5E,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x3C,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x5E
	.DB  0x5E,0x5E,0x5E,0x20,0x20,0x20,0x3C,0x0
	.DB  0x54,0x52,0x49,0x4E,0x41,0x4D,0x49,0x20
	.DB  0x53,0x4B,0x41,0x4D,0x42,0x45,0x4A,0x49
	.DB  0x4D,0x41,0x49,0x3A,0x0,0x42,0x20,0x2F
	.DB  0x20,0x0,0x42,0x0,0x20,0x2D,0x3D,0x56
	.DB  0x41,0x53,0x41,0x52,0x4F,0x53,0x20,0x4C
	.DB  0x41,0x49,0x4B,0x41,0x53,0x3D,0x2D,0x20
	.DB  0x0,0x50,0x41,0x44,0x45,0x54,0x49,0x53
	.DB  0x3A,0x20,0x0,0x49,0x53,0x4A,0x55,0x4E
	.DB  0x47,0x54,0x41,0x53,0x0,0x49,0x4A,0x55
	.DB  0x4E,0x47,0x54,0x41,0x53,0x0,0x20,0x20
	.DB  0x2D,0x3D,0x54,0x49,0x4B,0x53,0x4C,0x49
	.DB  0x4E,0x49,0x4D,0x41,0x53,0x3D,0x2D,0x20
	.DB  0x20,0x2B,0x0,0x4C,0x41,0x49,0x4B,0x4F
	.DB  0x20,0x54,0x49,0x4B,0x53,0x4C,0x49,0x4E
	.DB  0x49,0x4D,0x41,0x53,0x20,0x20,0x20,0x0
	.DB  0x53,0x45,0x4B,0x55,0x4E,0x44,0x45,0x4D
	.DB  0x49,0x53,0x20,0x50,0x45,0x52,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x53,0x41,0x56
	.DB  0x41,0x49,0x54,0x45,0x3A,0x20,0x0,0x20
	.DB  0x53,0x45,0x43,0x2E,0x20,0x20,0x2D,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x2D,0x3D,0x4B
	.DB  0x4F,0x44,0x41,0x53,0x3D,0x2D,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x31,0x2E,0x49
	.DB  0x53,0x4A,0x55,0x4E,0x47,0x54,0x49,0x20
	.DB  0x4B,0x4F,0x44,0x41,0x3F,0x20,0x20,0x20
	.DB  0x20,0x0,0x32,0x2E,0x4B,0x4F,0x44,0x41
	.DB  0x53,0x3A,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x2A,0x2A,0x2A,0x2A,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x52,0x45,0x44,0x41,0x47,0x55,0x4F
	.DB  0x54,0x49,0x3F,0x0,0x31,0x2E,0x20,0x49
	.DB  0x4A,0x55,0x4E,0x47,0x54,0x49,0x20,0x4B
	.DB  0x4F,0x44,0x41,0x3F,0x0,0x20,0x20,0x20
	.DB  0x20,0x2D,0x3D,0x49,0x53,0x56,0x41,0x44
	.DB  0x41,0x49,0x3D,0x2D,0x20,0x20,0x20,0x20
	.DB  0x2B,0x0,0x31,0x2E,0x20,0x56,0x41,0x52
	.DB  0x50,0x55,0x20,0x49,0x53,0x45,0x4A,0x2E
	.DB  0x3A,0x20,0x0
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
;#define BELL_TYPE_COUNT 14
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
;
;// TYPE 13: Porciunkules atlaidai
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
; 0000 0085 unsigned char IsEasterToday(unsigned int year, unsigned char month, unsigned char day){
_IsEasterToday:
; 0000 0086 unsigned int G, C, X, Z, D, E, F, N;
; 0000 0087 unsigned char EasterSunday, EasterSaturday, EasterFriday, EasterThursday;
; 0000 0088 
; 0000 0089 year += 2000;
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
; 0000 008A 
; 0000 008B G = year-((year/19)*19)+1;
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0x0
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0x1
; 0000 008C C = (year/100)+1;
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0x2
; 0000 008D X = 3*C/4-12;
; 0000 008E Z = ((8*C+5)/25)-5;
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 008F D = 5*year/4-X-10;
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0x3
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 0090 F = 11*G+20+Z-X;
	CALL SUBOPT_0x4
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0x5
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0091 E = F-((F/30)*30);
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x6
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+14,R26
	STD  Y+14+1,R27
; 0000 0092     if(((E==25)&&(G>11))||(E==24)){ E++;    }
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
; 0000 0093 N = 44-E;
_0x1F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x7
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0094     if(N<21){   N = N+30;   }
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,21
	BRSH _0x24
	ADIW R30,30
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0095 N = N+7-((D+N)-(((D+N)/7)*7));
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
; 0000 0096 
; 0000 0097 EasterSunday = N;
	LDD  R30,Y+10
	STD  Y+9,R30
; 0000 0098 EasterSaturday = N - 1;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,1
	STD  Y+8,R30
; 0000 0099 EasterFriday = N - 2;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,2
	STD  Y+7,R30
; 0000 009A EasterThursday = N - 3;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,3
	STD  Y+6,R30
; 0000 009B 
; 0000 009C // Velyku ketvirtadienis
; 0000 009D     if(EasterThursday>31){
	LDD  R26,Y+6
	CPI  R26,LOW(0x20)
	BRLO _0x25
; 0000 009E     EasterThursday = EasterThursday - 31;
	CALL SUBOPT_0xA
	SBIW R30,31
	STD  Y+6,R30
; 0000 009F     // Balandzio N-oji diena
; 0000 00A0         if(month==4){
	LDD  R26,Y+21
	CPI  R26,LOW(0x4)
	BRNE _0x26
; 0000 00A1             if(day==EasterThursday){
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x27
; 0000 00A2             return 4;
	LDI  R30,LOW(4)
	RJMP _0x206000E
; 0000 00A3             }
; 0000 00A4         }
_0x27:
; 0000 00A5     }
_0x26:
; 0000 00A6     else{
	RJMP _0x28
_0x25:
; 0000 00A7     // Kovo N-oji diena
; 0000 00A8         if(month==3){
	LDD  R26,Y+21
	CPI  R26,LOW(0x3)
	BRNE _0x29
; 0000 00A9             if(day==EasterThursday){
	LDD  R30,Y+6
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x2A
; 0000 00AA             return 4;
	LDI  R30,LOW(4)
	RJMP _0x206000E
; 0000 00AB             }
; 0000 00AC         }
_0x2A:
; 0000 00AD     }
_0x29:
_0x28:
; 0000 00AE 
; 0000 00AF // Velyku penktadienis
; 0000 00B0     if(EasterFriday>31){
	LDD  R26,Y+7
	CPI  R26,LOW(0x20)
	BRLO _0x2B
; 0000 00B1     EasterFriday = EasterFriday - 31;
	LDD  R30,Y+7
	CALL SUBOPT_0xB
	STD  Y+7,R30
; 0000 00B2     // Balandzio N-oji diena
; 0000 00B3         if(month==4){
	LDD  R26,Y+21
	CPI  R26,LOW(0x4)
	BRNE _0x2C
; 0000 00B4             if(day==EasterFriday){
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x2D
; 0000 00B5             return 5;
	LDI  R30,LOW(5)
	RJMP _0x206000E
; 0000 00B6             }
; 0000 00B7         }
_0x2D:
; 0000 00B8     }
_0x2C:
; 0000 00B9     else{
	RJMP _0x2E
_0x2B:
; 0000 00BA     // Kovo N-oji diena
; 0000 00BB         if(month==3){
	LDD  R26,Y+21
	CPI  R26,LOW(0x3)
	BRNE _0x2F
; 0000 00BC             if(day==EasterFriday){
	LDD  R30,Y+7
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x30
; 0000 00BD             return 5;
	LDI  R30,LOW(5)
	RJMP _0x206000E
; 0000 00BE             }
; 0000 00BF         }
_0x30:
; 0000 00C0     }
_0x2F:
_0x2E:
; 0000 00C1 
; 0000 00C2 // Velyku sestadienis
; 0000 00C3     if(EasterSaturday>31){
	LDD  R26,Y+8
	CPI  R26,LOW(0x20)
	BRLO _0x31
; 0000 00C4     EasterSaturday = EasterSaturday - 31;
	LDD  R30,Y+8
	CALL SUBOPT_0xB
	STD  Y+8,R30
; 0000 00C5     // Balandzio N-oji diena
; 0000 00C6         if(month==4){
	LDD  R26,Y+21
	CPI  R26,LOW(0x4)
	BRNE _0x32
; 0000 00C7             if(day==EasterSaturday){
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x33
; 0000 00C8             return 6;
	LDI  R30,LOW(6)
	RJMP _0x206000E
; 0000 00C9             }
; 0000 00CA         }
_0x33:
; 0000 00CB     }
_0x32:
; 0000 00CC     else{
	RJMP _0x34
_0x31:
; 0000 00CD     // Kovo N-oji diena
; 0000 00CE         if(month==3){
	LDD  R26,Y+21
	CPI  R26,LOW(0x3)
	BRNE _0x35
; 0000 00CF             if(day==EasterSaturday){
	LDD  R30,Y+8
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x36
; 0000 00D0             return 6;
	LDI  R30,LOW(6)
	RJMP _0x206000E
; 0000 00D1             }
; 0000 00D2         }
_0x36:
; 0000 00D3     }
_0x35:
_0x34:
; 0000 00D4 
; 0000 00D5 // Velyku sekmadienis
; 0000 00D6     if(EasterSunday>31){
	LDD  R26,Y+9
	CPI  R26,LOW(0x20)
	BRLO _0x37
; 0000 00D7     EasterSunday = EasterSunday - 31;
	LDD  R30,Y+9
	CALL SUBOPT_0xB
	STD  Y+9,R30
; 0000 00D8     // Balandzio N-oji diena
; 0000 00D9         if(month==4){
	LDD  R26,Y+21
	CPI  R26,LOW(0x4)
	BRNE _0x38
; 0000 00DA             if(day==EasterSunday){
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x39
; 0000 00DB             return 7;
	LDI  R30,LOW(7)
	RJMP _0x206000E
; 0000 00DC             }
; 0000 00DD         }
_0x39:
; 0000 00DE     }
_0x38:
; 0000 00DF     else{
	RJMP _0x3A
_0x37:
; 0000 00E0     // Kovo N-oji diena
; 0000 00E1         if(month==3){
	LDD  R26,Y+21
	CPI  R26,LOW(0x3)
	BRNE _0x3B
; 0000 00E2             if(day==EasterSunday){
	LDD  R30,Y+9
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x3C
; 0000 00E3             return 7;
	LDI  R30,LOW(7)
	RJMP _0x206000E
; 0000 00E4             }
; 0000 00E5         }
_0x3C:
; 0000 00E6     }
_0x3B:
_0x3A:
; 0000 00E7 
; 0000 00E8 return 0;
	LDI  R30,LOW(0)
_0x206000E:
	CALL __LOADLOCR6
	ADIW R28,24
	RET
; 0000 00E9 }
;
;unsigned char IsChristmasToday(unsigned int year, unsigned char month, unsigned char day){
; 0000 00EB unsigned char IsChristmasToday(unsigned int year, unsigned char month, unsigned char day){
_IsChristmasToday:
; 0000 00EC //Gruodzio 25 - 26
; 0000 00ED 
; 0000 00EE year += 2000;
;	year -> Y+2
;	month -> Y+1
;	day -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00EF 
; 0000 00F0     if(year!=0){
	SBIW R30,0
	BREQ _0x3D
; 0000 00F1         if(month==12){
	LDD  R26,Y+1
	CPI  R26,LOW(0xC)
	BRNE _0x3E
; 0000 00F2             if(day==25){
	LD   R26,Y
	CPI  R26,LOW(0x19)
	BRNE _0x3F
; 0000 00F3             return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000D
; 0000 00F4             }
; 0000 00F5             else if(day==26){
_0x3F:
	LD   R26,Y
	CPI  R26,LOW(0x1A)
	BRNE _0x41
; 0000 00F6             return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000D
; 0000 00F7             }
; 0000 00F8         }
_0x41:
; 0000 00F9     }
_0x3E:
; 0000 00FA return 0;
_0x3D:
	LDI  R30,LOW(0)
_0x206000D:
	ADIW R28,4
	RET
; 0000 00FB }
;
;unsigned char IsPorciunkuleToday(unsigned char month, unsigned char day, unsigned char weekday){
; 0000 00FD unsigned char IsPorciunkuleToday(unsigned char month, unsigned char day, unsigned char weekday){
_IsPorciunkuleToday:
; 0000 00FE     if(month==8){
;	month -> Y+2
;	day -> Y+1
;	weekday -> Y+0
	LDD  R26,Y+2
	CPI  R26,LOW(0x8)
	BRNE _0x42
; 0000 00FF         if(day<=7){
	LDD  R26,Y+1
	CPI  R26,LOW(0x8)
	BRSH _0x43
; 0000 0100             if(weekday==7){
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x44
; 0000 0101             return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000A
; 0000 0102             }
; 0000 0103         }
_0x44:
; 0000 0104     }
_0x43:
; 0000 0105 return 0;
_0x42:
	RJMP _0x206000B
; 0000 0106 }
;
;unsigned char GetEasterMonth(unsigned int year){
; 0000 0108 unsigned char GetEasterMonth(unsigned int year){
_GetEasterMonth:
; 0000 0109 unsigned int G, C, X, Z, D, E, F, N;
; 0000 010A 
; 0000 010B year += 2000;
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
; 0000 010C 
; 0000 010D G = year-((year/19)*19)+1;
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x1
; 0000 010E C = (year/100)+1;
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x2
; 0000 010F X = 3*C/4-12;
; 0000 0110 Z = ((8*C+5)/25)-5;
	CALL SUBOPT_0xD
; 0000 0111 D = 5*year/4-X-10;
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0112 F = 11*G+20+Z-X;
	CALL SUBOPT_0x4
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x5
	CALL SUBOPT_0xE
; 0000 0113 E = F-((F/30)*30);
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x9
; 0000 0114     if(((E==25)&&(G>11))||(E==24)){ E++;    }
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,25
	BRNE _0x46
	__CPWRN 16,17,12
	BRSH _0x48
_0x46:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,24
	BRNE _0x45
_0x48:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0115 N = 44-E;
_0x45:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x7
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0116     if(N<21){   N = N+30;   }
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,21
	BRSH _0x4A
	ADIW R30,30
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0117 N = N+7-((D+N)-(((D+N)/7)*7));
_0x4A:
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
; 0000 0118 
; 0000 0119     if(N>31){
	BRLO _0x4B
; 0000 011A     return 4;
	LDI  R30,LOW(4)
	RJMP _0x206000C
; 0000 011B     }
; 0000 011C     else{
_0x4B:
; 0000 011D     return 3;
	LDI  R30,LOW(3)
	RJMP _0x206000C
; 0000 011E     }
; 0000 011F }
;
;unsigned char GetEasterDay(unsigned int year){
; 0000 0121 unsigned char GetEasterDay(unsigned int year){
_GetEasterDay:
; 0000 0122 unsigned int G, C, X, Z, D, E, F, N;
; 0000 0123 
; 0000 0124 year += 2000;
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
; 0000 0125 
; 0000 0126 G = year-((year/19)*19)+1;
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x1
; 0000 0127 C = (year/100)+1;
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x2
; 0000 0128 X = 3*C/4-12;
; 0000 0129 Z = ((8*C+5)/25)-5;
	CALL SUBOPT_0xD
; 0000 012A D = 5*year/4-X-10;
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 012B F = 11*G+20+Z-X;
	CALL SUBOPT_0x4
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x5
	CALL SUBOPT_0xE
; 0000 012C E = F-((F/30)*30);
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x9
; 0000 012D     if(((E==25)&&(G>11))||(E==24)){ E++;    }
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,25
	BRNE _0x4E
	__CPWRN 16,17,12
	BRSH _0x50
_0x4E:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,24
	BRNE _0x4D
_0x50:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 012E N = 44-E;
_0x4D:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x7
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 012F     if(N<21){   N = N+30;   }
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,21
	BRSH _0x52
	ADIW R30,30
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0130 N = N+7-((D+N)-(((D+N)/7)*7));
_0x52:
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
; 0000 0131 
; 0000 0132     if(N>31){
	BRLO _0x53
; 0000 0133     return N - 31;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,31
	RJMP _0x206000C
; 0000 0134     }
; 0000 0135     else{
_0x53:
; 0000 0136     return N;
	LDD  R30,Y+6
; 0000 0137     }
; 0000 0138 }
_0x206000C:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
;
;unsigned char DayCountInMonth(unsigned int year, char month){
; 0000 013A unsigned char DayCountInMonth(unsigned int year, char month){
_DayCountInMonth:
; 0000 013B year += 2000;
;	year -> Y+1
;	month -> Y+0
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 013C 
; 0000 013D     if((month==1)||(month==3)||(month==5)||(month==7)||(month==8)||(month==10)||(month==12)){return 31;}
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BREQ _0x56
	CPI  R26,LOW(0x3)
	BREQ _0x56
	CPI  R26,LOW(0x5)
	BREQ _0x56
	CPI  R26,LOW(0x7)
	BREQ _0x56
	CPI  R26,LOW(0x8)
	BREQ _0x56
	CPI  R26,LOW(0xA)
	BREQ _0x56
	CPI  R26,LOW(0xC)
	BRNE _0x55
_0x56:
	LDI  R30,LOW(31)
	RJMP _0x206000A
; 0000 013E     else if((month==4)||(month==6)||(month==9)||(month==11)){return 30;}
_0x55:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BREQ _0x5A
	CPI  R26,LOW(0x6)
	BREQ _0x5A
	CPI  R26,LOW(0x9)
	BREQ _0x5A
	CPI  R26,LOW(0xB)
	BRNE _0x59
_0x5A:
	LDI  R30,LOW(30)
	RJMP _0x206000A
; 0000 013F     else if(month==2){
_0x59:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x5D
; 0000 0140     unsigned int a;
; 0000 0141     a = year/4;
	SBIW R28,2
;	year -> Y+3
;	month -> Y+2
;	a -> Y+0
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	CALL __LSRW2
	ST   Y,R30
	STD  Y+1,R31
; 0000 0142     a = a*4;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(4)
	CALL __MULB1W2U
	ST   Y,R30
	STD  Y+1,R31
; 0000 0143         if(a==year){
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x5E
; 0000 0144         return 29;
	LDI  R30,LOW(29)
	ADIW R28,2
	RJMP _0x206000A
; 0000 0145         }
; 0000 0146         else{
_0x5E:
; 0000 0147         return 28;
	LDI  R30,LOW(28)
	ADIW R28,2
	RJMP _0x206000A
; 0000 0148         }
; 0000 0149     }
; 0000 014A     else{
_0x5D:
; 0000 014B     return 0;
	RJMP _0x206000B
; 0000 014C     }
; 0000 014D }
;
;unsigned char IsSummerTime(unsigned char month, unsigned char day, unsigned char weekday){
; 0000 014F unsigned char IsSummerTime(unsigned char month, unsigned char day, unsigned char weekday){
_IsSummerTime:
; 0000 0150     if(month==3){
;	month -> Y+2
;	day -> Y+1
;	weekday -> Y+0
	LDD  R26,Y+2
	CPI  R26,LOW(0x3)
	BRNE _0x61
; 0000 0151         if(day==25){
	LDD  R26,Y+1
	CPI  R26,LOW(0x19)
	BRNE _0x62
; 0000 0152             if(weekday==7){
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x63
; 0000 0153             return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000A
; 0000 0154             }
; 0000 0155         }
_0x63:
; 0000 0156         else if(day>25){
	RJMP _0x64
_0x62:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1A)
	BRLO _0x65
; 0000 0157             if(day+(7-weekday)>31){
	CALL SUBOPT_0x11
	BRLT _0x66
; 0000 0158             return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000A
; 0000 0159             }
; 0000 015A             else{
_0x66:
; 0000 015B                 if(weekday==7){
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x68
; 0000 015C                 return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000A
; 0000 015D                 }
; 0000 015E             }
_0x68:
; 0000 015F 
; 0000 0160         }
; 0000 0161     }
_0x65:
_0x64:
; 0000 0162     else if((month>3)&&(month<10)){
	RJMP _0x69
_0x61:
	LDD  R26,Y+2
	CPI  R26,LOW(0x4)
	BRLO _0x6B
	CPI  R26,LOW(0xA)
	BRLO _0x6C
_0x6B:
	RJMP _0x6A
_0x6C:
; 0000 0163     return 1;
	LDI  R30,LOW(1)
	RJMP _0x206000A
; 0000 0164     }
; 0000 0165     else if(month==10){
_0x6A:
	LDD  R26,Y+2
	CPI  R26,LOW(0xA)
	BRNE _0x6E
; 0000 0166         if(day==25){
	LDD  R26,Y+1
	CPI  R26,LOW(0x19)
	BRNE _0x6F
; 0000 0167             if(weekday==7){
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BREQ _0x206000B
; 0000 0168             return 0;
; 0000 0169             }
; 0000 016A         }
; 0000 016B         else if(day>25){
	RJMP _0x71
_0x6F:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1A)
	BRLO _0x72
; 0000 016C             if(day+(7-weekday)>31){
	CALL SUBOPT_0x11
	BRGE _0x206000B
; 0000 016D             return 0;
; 0000 016E             }
; 0000 016F             else{
; 0000 0170                 if(weekday==7){
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BREQ _0x206000B
; 0000 0171                 return 0;
; 0000 0172                 }
; 0000 0173             }
; 0000 0174         }
; 0000 0175     return 1;
_0x72:
_0x71:
	LDI  R30,LOW(1)
	RJMP _0x206000A
; 0000 0176     }
; 0000 0177 return 0;
_0x6E:
_0x69:
_0x206000B:
	LDI  R30,LOW(0)
_0x206000A:
	ADIW R28,3
	RET
; 0000 0178 }
;
;unsigned char GetFreeBellId(unsigned char bell_type){
; 0000 017A unsigned char GetFreeBellId(unsigned char bell_type){
_GetFreeBellId:
; 0000 017B unsigned char i;
; 0000 017C     for(i=0;i<BELL_COUNT;i++){
	ST   -Y,R17
;	bell_type -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x77:
	CPI  R17,20
	BRSH _0x78
; 0000 017D     unsigned char checking_time[3];
; 0000 017E     checking_time[0] = BELL_TIME[bell_type][i][0];
	SBIW R28,3
;	bell_type -> Y+4
;	checking_time -> Y+0
	CALL SUBOPT_0x12
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDB
	ST   Y,R30
; 0000 017F     checking_time[1] = BELL_TIME[bell_type][i][1];
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 0180     checking_time[2] = BELL_TIME[bell_type][i][2];
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
; 0000 0181         if(checking_time[2]>0){
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRLO _0x79
; 0000 0182             if(checking_time[0]<24){
	LD   R26,Y
	CPI  R26,LOW(0x18)
	BRSH _0x7A
; 0000 0183                 if(checking_time[1]>=60){
	LDD  R26,Y+1
	CPI  R26,LOW(0x3C)
	BRLO _0x7B
; 0000 0184                 BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
; 0000 0185                 BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x16
; 0000 0186                 BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x17
; 0000 0187                 return i;
	RJMP _0x2060009
; 0000 0188                 break;
; 0000 0189                 }
; 0000 018A             }
_0x7B:
; 0000 018B             else{
	RJMP _0x7C
_0x7A:
; 0000 018C             BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
; 0000 018D             BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x16
; 0000 018E             BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x17
; 0000 018F             return i;
	RJMP _0x2060009
; 0000 0190             break;
; 0000 0191             }
_0x7C:
; 0000 0192         }
; 0000 0193         else{
	RJMP _0x7D
_0x79:
; 0000 0194         BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
; 0000 0195         BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x16
; 0000 0196         BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x17
; 0000 0197         return i;
	RJMP _0x2060009
; 0000 0198         break;
; 0000 0199         }
_0x7D:
; 0000 019A     }
	ADIW R28,3
	SUBI R17,-1
	RJMP _0x77
_0x78:
; 0000 019B return 255;
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2060009
; 0000 019C }
;
;unsigned char GetBellId(unsigned char bell_type, unsigned char row){
; 0000 019E unsigned char GetBellId(unsigned char bell_type, unsigned char row){
_GetBellId:
; 0000 019F     if(bell_type<BELL_TYPE_COUNT){
;	bell_type -> Y+1
;	row -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0xE)
	BRLO PC+3
	JMP _0x7E
; 0000 01A0         if(row<BELL_COUNT){
	LD   R26,Y
	CPI  R26,LOW(0x14)
	BRLO PC+3
	JMP _0x7F
; 0000 01A1         unsigned char k, i, BELL_ID;
; 0000 01A2         unsigned char time[3];
; 0000 01A3         time[0] = 0;
	SBIW R28,6
;	bell_type -> Y+7
;	row -> Y+6
;	k -> Y+5
;	i -> Y+4
;	BELL_ID -> Y+3
;	time -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 01A4         time[1] = 0;
	STD  Y+1,R30
; 0000 01A5         time[2] = 0;
	STD  Y+2,R30
; 0000 01A6 
; 0000 01A7             for(k=0;k<=row;k++){
	STD  Y+5,R30
_0x81:
	LDD  R30,Y+6
	LDD  R26,Y+5
	CP   R30,R26
	BRSH PC+3
	JMP _0x82
; 0000 01A8             unsigned char current_time[3], set_value;
; 0000 01A9             current_time[0] = 255;
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
; 0000 01AA             current_time[1] = 255;
	STD  Y+2,R30
; 0000 01AB             current_time[2] = 255;
	STD  Y+3,R30
; 0000 01AC             BELL_ID = 255;
	STD  Y+7,R30
; 0000 01AD 
; 0000 01AE                 for(i=0;i<BELL_COUNT;i++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
_0x84:
	LDD  R26,Y+8
	CPI  R26,LOW(0x14)
	BRLO PC+3
	JMP _0x85
; 0000 01AF                 unsigned char checking_time[3];
; 0000 01B0                 checking_time[0] = BELL_TIME[bell_type][i][0];
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
; 0000 01B1                 checking_time[1] = BELL_TIME[bell_type][i][1];
	CALL SUBOPT_0x18
	CALL SUBOPT_0x13
; 0000 01B2                 checking_time[2] = BELL_TIME[bell_type][i][2];
	CALL SUBOPT_0x18
	CALL SUBOPT_0x14
; 0000 01B3                     if(checking_time[0]<24){
	LD   R26,Y
	CPI  R26,LOW(0x18)
	BRLO PC+3
	JMP _0x86
; 0000 01B4                         if(checking_time[1]<60){
	LDD  R26,Y+1
	CPI  R26,LOW(0x3C)
	BRLO PC+3
	JMP _0x87
; 0000 01B5                             if(checking_time[2]>0){
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRLO _0x88
; 0000 01B6                                 if(checking_time[0]>time[0]){
	LDD  R30,Y+7
	LD   R26,Y
	CP   R30,R26
	BRSH _0x89
; 0000 01B7                                     if(checking_time[0]<current_time[0]){
	LDD  R30,Y+4
	CP   R26,R30
	BRLO _0x539
; 0000 01B8                                     current_time[0] = checking_time[0];
; 0000 01B9                                     current_time[1] = checking_time[1];
; 0000 01BA                                     current_time[2] = checking_time[2];
; 0000 01BB                                     set_value = 1;
; 0000 01BC                                     BELL_ID = i;
; 0000 01BD                                     }
; 0000 01BE                                     else if(checking_time[0]==current_time[0]){
	CP   R30,R26
	BRNE _0x8C
; 0000 01BF                                         if(checking_time[1]<current_time[1]){
	LDD  R30,Y+5
	LDD  R26,Y+1
	CP   R26,R30
	BRSH _0x8D
; 0000 01C0                                         current_time[0] = checking_time[0];
_0x539:
	LD   R30,Y
	CALL SUBOPT_0x1A
; 0000 01C1                                         current_time[1] = checking_time[1];
; 0000 01C2                                         current_time[2] = checking_time[2];
; 0000 01C3                                         set_value = 1;
; 0000 01C4                                         BELL_ID = i;
; 0000 01C5                                         }
; 0000 01C6                                     }
_0x8D:
; 0000 01C7                                 }
_0x8C:
; 0000 01C8                                 else if(checking_time[0]==time[0]){
	RJMP _0x8E
_0x89:
	LDD  R30,Y+7
	LD   R26,Y
	CP   R30,R26
	BRNE _0x8F
; 0000 01C9                                     if(checking_time[1]>time[1]){
	LDD  R30,Y+8
	LDD  R26,Y+1
	CP   R30,R26
	BRSH _0x90
; 0000 01CA                                         if(checking_time[0]<current_time[0]){
	LDD  R30,Y+4
	LD   R26,Y
	CP   R26,R30
	BRSH _0x91
; 0000 01CB                                         current_time[0] = checking_time[0];
	LD   R30,Y
	CALL SUBOPT_0x1A
; 0000 01CC                                         current_time[1] = checking_time[1];
; 0000 01CD                                         current_time[2] = checking_time[2];
; 0000 01CE                                         set_value = 1;
; 0000 01CF                                         BELL_ID = i;
; 0000 01D0                                         }
; 0000 01D1                                         else if(checking_time[0]==current_time[0]){
	RJMP _0x92
_0x91:
	LDD  R30,Y+4
	LD   R26,Y
	CP   R30,R26
	BRNE _0x93
; 0000 01D2                                             if(checking_time[1]<current_time[1]){
	LDD  R30,Y+5
	LDD  R26,Y+1
	CP   R26,R30
	BRSH _0x94
; 0000 01D3                                             current_time[0] = checking_time[0];
	LD   R30,Y
	CALL SUBOPT_0x1A
; 0000 01D4                                             current_time[1] = checking_time[1];
; 0000 01D5                                             current_time[2] = checking_time[2];
; 0000 01D6                                             set_value = 1;
; 0000 01D7                                             BELL_ID = i;
; 0000 01D8                                             }
; 0000 01D9                                             else if(checking_time[1]==current_time[1]){
	RJMP _0x95
_0x94:
	LDD  R30,Y+5
	LDD  R26,Y+1
	CP   R30,R26
	BRNE _0x96
; 0000 01DA                                             BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
; 0000 01DB                                             BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x1C
; 0000 01DC                                             BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x1D
; 0000 01DD                                             }
; 0000 01DE                                         }
_0x96:
_0x95:
; 0000 01DF                                     }
_0x93:
_0x92:
; 0000 01E0                                 }
_0x90:
; 0000 01E1                             }
_0x8F:
_0x8E:
; 0000 01E2                             else{
	RJMP _0x97
_0x88:
; 0000 01E3                             BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
; 0000 01E4                             BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x1C
; 0000 01E5                             BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x1D
; 0000 01E6                             }
_0x97:
; 0000 01E7                         }
; 0000 01E8                         else{
	RJMP _0x98
_0x87:
; 0000 01E9                         BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
; 0000 01EA                         BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x1C
; 0000 01EB                         BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x1D
; 0000 01EC                         }
_0x98:
; 0000 01ED                     }
; 0000 01EE                     else{
	RJMP _0x99
_0x86:
; 0000 01EF                     BELL_TIME[bell_type][i][0] = 0;
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
; 0000 01F0                     BELL_TIME[bell_type][i][1] = 0;
	CALL SUBOPT_0x1C
; 0000 01F1                     BELL_TIME[bell_type][i][2] = 0;
	CALL SUBOPT_0x1D
; 0000 01F2                     }
_0x99:
; 0000 01F3                 }
	ADIW R28,3
	LDD  R30,Y+8
	SUBI R30,-LOW(1)
	STD  Y+8,R30
	RJMP _0x84
_0x85:
; 0000 01F4 
; 0000 01F5                 if(set_value==1){
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x9A
; 0000 01F6                 time[0] = current_time[0];
	LDD  R30,Y+1
	STD  Y+4,R30
; 0000 01F7                 time[1] = current_time[1];
	LDD  R30,Y+2
	STD  Y+5,R30
; 0000 01F8                 time[2] = current_time[2];
	LDD  R30,Y+3
	STD  Y+6,R30
; 0000 01F9                 }
; 0000 01FA             }
_0x9A:
	ADIW R28,4
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x81
_0x82:
; 0000 01FB         return BELL_ID;
	LDD  R30,Y+3
	ADIW R28,6
	RJMP _0x2060009
; 0000 01FC         }
; 0000 01FD     return 255;
_0x7F:
; 0000 01FE     }
; 0000 01FF return 255;
_0x7E:
_0x2060008:
	LDI  R30,LOW(255)
_0x2060009:
	ADIW R28,2
	RET
; 0000 0200 }
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
; 0000 021D #endasm
;#include <lcd.h>
;
;// Ekrano apsvietimas
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 0221 interrupt [12] void timer0_ovf_isr(void){
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0222 lcd_light_osc += 1;
	LDS  R30,_lcd_light_osc_G000
	SUBI R30,-LOW(1)
	STS  _lcd_light_osc_G000,R30
; 0000 0223     if(lcd_light_osc>=100){
	LDS  R26,_lcd_light_osc_G000
	CPI  R26,LOW(0x64)
	BRLO _0x9B
; 0000 0224     lcd_light_osc = 0;
	LDI  R30,LOW(0)
	STS  _lcd_light_osc_G000,R30
; 0000 0225     }
; 0000 0226 
; 0000 0227     if(lcd_light_now>lcd_light_osc){
_0x9B:
	LDS  R30,_lcd_light_osc_G000
	LDS  R26,_lcd_light_now_G000
	CP   R30,R26
	BRSH _0x9C
; 0000 0228     LCD_LED = 1;
	SBI  0x1B,7
; 0000 0229     }
; 0000 022A     else{
	RJMP _0x9F
_0x9C:
; 0000 022B     LCD_LED = 0;
	CBI  0x1B,7
; 0000 022C     }
_0x9F:
; 0000 022D }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;char SelectAnotherRow(char up_down){
; 0000 022F char SelectAnotherRow(char up_down){
_SelectAnotherRow:
; 0000 0230 // 0 - down
; 0000 0231 // 1 - up
; 0000 0232     if(up_down==0){
;	up_down -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0xA2
; 0000 0233         if(SelectedRow<RowsOnWindow-1){
	LDS  R30,_RowsOnWindow_G000
	CALL SUBOPT_0x1E
	LDS  R26,_SelectedRow_G000
	CALL SUBOPT_0x1F
	BRGE _0xA3
; 0000 0234         SelectedRow++;
	LDS  R30,_SelectedRow_G000
	SUBI R30,-LOW(1)
	STS  _SelectedRow_G000,R30
; 0000 0235             if(Address[5]+3<SelectedRow){
	CALL SUBOPT_0x20
	ADIW R30,3
	MOVW R26,R30
	LDS  R30,_SelectedRow_G000
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0xA4
; 0000 0236             Address[5] = SelectedRow - 3;
	LDS  R30,_SelectedRow_G000
	LDI  R31,0
	SBIW R30,3
	__PUTB1MN _Address_G000,5
; 0000 0237             }
; 0000 0238         return 1;
_0xA4:
	LDI  R30,LOW(1)
	RJMP _0x2060006
; 0000 0239         }
; 0000 023A     }
_0xA3:
; 0000 023B     else{
	RJMP _0xA5
_0xA2:
; 0000 023C         if(SelectedRow>0){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRLO _0xA6
; 0000 023D         SelectedRow--;
	LDS  R30,_SelectedRow_G000
	SUBI R30,LOW(1)
	STS  _SelectedRow_G000,R30
; 0000 023E             if(Address[5]>SelectedRow){
	__GETB2MN _Address_G000,5
	CP   R30,R26
	BRSH _0xA7
; 0000 023F             Address[5] = SelectedRow;
	__PUTB1MN _Address_G000,5
; 0000 0240             }
; 0000 0241         return 1;
_0xA7:
	LDI  R30,LOW(1)
	RJMP _0x2060006
; 0000 0242         }
; 0000 0243     }
_0xA6:
_0xA5:
; 0000 0244 return 0;
	RJMP _0x2060007
; 0000 0245 }
;
;char NumToIndex(char Num){
; 0000 0247 char NumToIndex(char Num){
_NumToIndex:
; 0000 0248     if(Num==0){     return '0';}
;	Num -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0xA8
	LDI  R30,LOW(48)
	RJMP _0x2060006
; 0000 0249     else if(Num==1){return '1';}
_0xA8:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0xAA
	LDI  R30,LOW(49)
	RJMP _0x2060006
; 0000 024A     else if(Num==2){return '2';}
_0xAA:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0xAC
	LDI  R30,LOW(50)
	RJMP _0x2060006
; 0000 024B     else if(Num==3){return '3';}
_0xAC:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0xAE
	LDI  R30,LOW(51)
	RJMP _0x2060006
; 0000 024C     else if(Num==4){return '4';}
_0xAE:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xB0
	LDI  R30,LOW(52)
	RJMP _0x2060006
; 0000 024D     else if(Num==5){return '5';}
_0xB0:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0xB2
	LDI  R30,LOW(53)
	RJMP _0x2060006
; 0000 024E     else if(Num==6){return '6';}
_0xB2:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0xB4
	LDI  R30,LOW(54)
	RJMP _0x2060006
; 0000 024F     else if(Num==7){return '7';}
_0xB4:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0xB6
	LDI  R30,LOW(55)
	RJMP _0x2060006
; 0000 0250     else if(Num==8){return '8';}
_0xB6:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0xB8
	LDI  R30,LOW(56)
	RJMP _0x2060006
; 0000 0251     else if(Num==9){return '9';}
_0xB8:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0xBA
	LDI  R30,LOW(57)
	RJMP _0x2060006
; 0000 0252     else{           return '-';}
_0xBA:
	LDI  R30,LOW(45)
	RJMP _0x2060006
; 0000 0253 return 0;
_0x2060007:
	LDI  R30,LOW(0)
_0x2060006:
	ADIW R28,1
	RET
; 0000 0254 }
;
;char lcd_put_number(char Type, char Lenght, char IsSign,
; 0000 0257 
; 0000 0258                     char NumbersAfterDot,
; 0000 0259 
; 0000 025A                     unsigned long int Number0,
; 0000 025B                     signed long int Number1){
_lcd_put_number:
; 0000 025C     if(Lenght>0){
;	Type -> Y+11
;	Lenght -> Y+10
;	IsSign -> Y+9
;	NumbersAfterDot -> Y+8
;	Number0 -> Y+4
;	Number1 -> Y+0
	LDD  R26,Y+10
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0xBC
; 0000 025D     unsigned long int k = 1;
; 0000 025E     unsigned char i;
; 0000 025F         for(i=0;i<Lenght-1;i++) k = k*10;
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
_0xBE:
	LDD  R30,Y+15
	CALL SUBOPT_0x1E
	LD   R26,Y
	CALL SUBOPT_0x1F
	BRGE _0xBF
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0xBE
_0xBF:
; 0000 0261 if(Type==0){
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0xC0
; 0000 0262         unsigned long int a;
; 0000 0263         unsigned char b;
; 0000 0264         a = Number0;
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
; 0000 0265 
; 0000 0266             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0xC1
; 0000 0267             lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0268             }
; 0000 0269 
; 0000 026A             if(a<0){
_0xC1:
	CALL SUBOPT_0x24
; 0000 026B             a = a*(-1);
; 0000 026C             }
; 0000 026D 
; 0000 026E             if(k*10<a){
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	BRSH _0xC3
; 0000 026F             a = k*10 - 1;
	CALL SUBOPT_0x25
	CALL SUBOPT_0x27
; 0000 0270             }
; 0000 0271 
; 0000 0272             for(i=0;i<Lenght;i++){
_0xC3:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0xC5:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0xC6
; 0000 0273                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0xC7
; 0000 0274                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0x28
	BRNE _0xC8
; 0000 0275                     lcd_putchar('.');
	CALL SUBOPT_0x29
; 0000 0276                     }
; 0000 0277                 }
_0xC8:
; 0000 0278             b = a/k;
_0xC7:
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
; 0000 0279             lcd_putchar( NumToIndex( b ) );
; 0000 027A             a = a - b*k;
; 0000 027B             k = k/10;
; 0000 027C             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0xC5
_0xC6:
; 0000 027D         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2060005
; 0000 027E         }
; 0000 027F 
; 0000 0280         else if(Type==1){
_0xC0:
	LDD  R26,Y+16
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0xCA
; 0000 0281         signed long int a;
; 0000 0282         unsigned char b;
; 0000 0283         a = Number1;
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
; 0000 0284 
; 0000 0285             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0xCB
; 0000 0286                 if(a>=0){
	LDD  R26,Y+4
	TST  R26
	BRMI _0xCC
; 0000 0287                 lcd_putchar('+');
	LDI  R30,LOW(43)
	RJMP _0x53A
; 0000 0288                 }
; 0000 0289                 else{
_0xCC:
; 0000 028A                 lcd_putchar('-');
	LDI  R30,LOW(45)
_0x53A:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 028B                 }
; 0000 028C             }
; 0000 028D 
; 0000 028E             if(a<0){
_0xCB:
	LDD  R26,Y+4
	TST  R26
	BRPL _0xCE
; 0000 028F             a = a*(-1);
	CALL SUBOPT_0x21
	__GETD2N 0xFFFFFFFF
	CALL __MULD12
	CALL SUBOPT_0x23
; 0000 0290             }
; 0000 0291 
; 0000 0292             if(k*10<a){
_0xCE:
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	BRSH _0xCF
; 0000 0293             a = k*10 - 1;
	CALL SUBOPT_0x25
	CALL SUBOPT_0x27
; 0000 0294             }
; 0000 0295 
; 0000 0296             for(i=0;i<Lenght;i++){
_0xCF:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0xD1:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0xD2
; 0000 0297                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0xD3
; 0000 0298                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0x28
	BRNE _0xD4
; 0000 0299                     lcd_putchar('.');
	CALL SUBOPT_0x29
; 0000 029A                     }
; 0000 029B                 }
_0xD4:
; 0000 029C             b = a/k;
_0xD3:
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
; 0000 029D             lcd_putchar( NumToIndex( b ) );
; 0000 029E             a = a - b*k;
; 0000 029F             k = k/10;
; 0000 02A0             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0xD1
_0xD2:
; 0000 02A1         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2060005
; 0000 02A2         }
; 0000 02A3     }
_0xCA:
	ADIW R28,5
; 0000 02A4 return 0;
_0xBC:
	LDI  R30,LOW(0)
_0x2060005:
	ADIW R28,12
	RET
; 0000 02A5 }
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
; 0000 02B5 void main(void){
_main:
; 0000 02B6 // Declare your local variables here
; 0000 02B7 
; 0000 02B8 // Input/Output Ports initialization
; 0000 02B9 // Port A initialization
; 0000 02BA // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out
; 0000 02BB // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02BC PORTA=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 02BD DDRA= 0b10000000;
	LDI  R30,LOW(128)
	OUT  0x1A,R30
; 0000 02BE 
; 0000 02BF // Port B initialization
; 0000 02C0 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 02C1 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02C2 PORTB=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 02C3 DDRB= 0b00000000;
	OUT  0x17,R30
; 0000 02C4 
; 0000 02C5 // Port C initialization
; 0000 02C6 // Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 02C7 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02C8 PORTC=0b00000000;
	OUT  0x15,R30
; 0000 02C9 DDRC= 0b00111000;
	LDI  R30,LOW(56)
	OUT  0x14,R30
; 0000 02CA 
; 0000 02CB // Port D initialization
; 0000 02CC // Func7=Out Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 02CD // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02CE PORTD=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 02CF DDRD= 0b10110000;
	LDI  R30,LOW(176)
	OUT  0x11,R30
; 0000 02D0 
; 0000 02D1 /// Timer/Counter 0 initialization
; 0000 02D2 // Clock source: System Clock
; 0000 02D3 // Clock value: 1000.000 kHz
; 0000 02D4 // Mode: Normal top=FFh
; 0000 02D5 // OC0 output: Disconnected
; 0000 02D6 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 02D7 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 02D8 OCR0=0x00;
	OUT  0x3C,R30
; 0000 02D9 
; 0000 02DA // Timer/Counter 1 initialization
; 0000 02DB // Clock source: System Clock
; 0000 02DC // Clock value: Timer1 Stopped
; 0000 02DD // Mode: Normal top=FFFFh
; 0000 02DE // OC1A output: Discon.
; 0000 02DF // OC1B output: Discon.
; 0000 02E0 // Noise Canceler: Off
; 0000 02E1 // Input Capture on Falling Edge
; 0000 02E2 // Timer1 Overflow Interrupt: Off
; 0000 02E3 // Input Capture Interrupt: Off
; 0000 02E4 // Compare A Match Interrupt: Off
; 0000 02E5 // Compare B Match Interrupt: Off
; 0000 02E6 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 02E7 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 02E8 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 02E9 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 02EA ICR1H=0x00;
	OUT  0x27,R30
; 0000 02EB ICR1L=0x00;
	OUT  0x26,R30
; 0000 02EC OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 02ED OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 02EE OCR1BH=0x00;
	OUT  0x29,R30
; 0000 02EF OCR1BL=0x00;
	OUT  0x28,R30
; 0000 02F0 
; 0000 02F1 // Timer/Counter 2 initialization
; 0000 02F2 // Clock source: System Clock
; 0000 02F3 // Clock value: Timer2 Stopped
; 0000 02F4 // Mode: Normal top=FFh
; 0000 02F5 // OC2 output: Disconnected
; 0000 02F6 ASSR=0x00;
	OUT  0x22,R30
; 0000 02F7 TCCR2=0x00;
	OUT  0x25,R30
; 0000 02F8 TCNT2=0x00;
	OUT  0x24,R30
; 0000 02F9 OCR2=0x00;
	OUT  0x23,R30
; 0000 02FA 
; 0000 02FB // External Interrupt(s) initialization
; 0000 02FC // INT0: Off
; 0000 02FD // INT1: Off
; 0000 02FE // INT2: Off
; 0000 02FF MCUCR=0x00;
	OUT  0x35,R30
; 0000 0300 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0301 
; 0000 0302 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0303 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0304 
; 0000 0305 // Analog Comparator initialization
; 0000 0306 // Analog Comparator: Off
; 0000 0307 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0308 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0309 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 030A 
; 0000 030B // I2C Bus initialization
; 0000 030C i2c_init();
	CALL SUBOPT_0x2C
; 0000 030D 
; 0000 030E // DS1307 Real Time Clock initialization
; 0000 030F // Square wave output on pin SQW/OUT: Off
; 0000 0310 // SQW/OUT pin state: 0
; 0000 0311 rtc_init(0,0,0);
; 0000 0312 
; 0000 0313 // Global enable interrupts
; 0000 0314 #asm("sei")
	sei
; 0000 0315 
; 0000 0316 
; 0000 0317 // 2 Wire Bus initialization
; 0000 0318 // Generate Acknowledge Pulse: Off
; 0000 0319 // 2 Wire Bus Slave Address: 0h
; 0000 031A // General Call Recognition: Off
; 0000 031B // Bit Rate: 400.000 kHz
; 0000 031C //TWSR=0x00;
; 0000 031D //TWBR=0x02;
; 0000 031E //TWAR=0x00;
; 0000 031F //TWCR=0x04;
; 0000 0320 
; 0000 0321 // I2C Bus initialization
; 0000 0322 i2c_init();
	CALL SUBOPT_0x2C
; 0000 0323 
; 0000 0324 // DS1307 Real Time Clock initialization
; 0000 0325 // Square wave output on pin SQW/OUT: Off
; 0000 0326 // SQW/OUT pin state: 0
; 0000 0327 rtc_init(0,0,0);
; 0000 0328 
; 0000 0329 // LCD module initialization
; 0000 032A lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 032B 
; 0000 032C // Watchdog Timer initialization
; 0000 032D // Watchdog Timer Prescaler: OSC/128k
; 0000 032E WDTCR=0x0B;
	LDI  R30,LOW(11)
	OUT  0x21,R30
; 0000 032F 
; 0000 0330 LCD_LED_TIMER = 30; lcd_light_now = lcd_light;
	LDI  R30,LOW(30)
	CALL SUBOPT_0x2D
; 0000 0331 lcd_putsf("+------------------+");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x2E
; 0000 0332 lcd_putsf("| BAZNYCIOS VARPU  |");
	__POINTW1FN _0x0,21
	CALL SUBOPT_0x2E
; 0000 0333 lcd_putsf("| VALDIKLIS V1.");
	__POINTW1FN _0x0,42
	CALL SUBOPT_0x2E
; 0000 0334 lcd_put_number(0,3,0,0,__BUILD__,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	__GETD1N 0x2A3
	CALL SUBOPT_0x31
; 0000 0335 lcd_putsf(" |+------------------+");
	__POINTW1FN _0x0,58
	CALL SUBOPT_0x2E
; 0000 0336 delay_ms(1500);
	CALL SUBOPT_0x32
; 0000 0337 
; 0000 0338 // Default values
; 0000 0339     if(lcd_light>100){lcd_light = 100;}
	CALL SUBOPT_0x33
	CPI  R30,LOW(0x65)
	BRLO _0xD5
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	LDI  R30,LOW(100)
	CALL __EEPROMWRB
; 0000 033A 
; 0000 033B     if(BELL_OUTPUT_ADDRESS==255){BELL_OUTPUT_ADDRESS = BELL_OUTPUT_DEFAULT;}
_0xD5:
	CALL SUBOPT_0x34
	CPI  R30,LOW(0xFF)
	BRNE _0xD6
	LDI  R26,LOW(_BELL_OUTPUT_ADDRESS)
	LDI  R27,HIGH(_BELL_OUTPUT_ADDRESS)
	LDI  R30,LOW(22)
	CALL __EEPROMWRB
; 0000 033C 
; 0000 033D     if((SUMMER_TIME_TURNED_ON>1)||(IS_CLOCK_SUMMER>1)){SUMMER_TIME_TURNED_ON = 0;IS_CLOCK_SUMMER = 0;}
_0xD6:
	CALL SUBOPT_0x35
	CPI  R30,LOW(0x2)
	BRSH _0xD8
	CALL SUBOPT_0x36
	CPI  R30,LOW(0x2)
	BRLO _0xD7
_0xD8:
	LDI  R26,LOW(_SUMMER_TIME_TURNED_ON)
	LDI  R27,HIGH(_SUMMER_TIME_TURNED_ON)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	LDI  R26,LOW(_IS_CLOCK_SUMMER)
	LDI  R27,HIGH(_IS_CLOCK_SUMMER)
	CALL __EEPROMWRB
; 0000 033E 
; 0000 033F     if((CODE>9999)||(IS_LOCK_TURNED_ON>1)){CODE = 0; IS_LOCK_TURNED_ON = 0;}
_0xD7:
	LDI  R26,LOW(_CODE)
	LDI  R27,HIGH(_CODE)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x2710)
	LDI  R26,HIGH(0x2710)
	CPC  R31,R26
	BRSH _0xDB
	CALL SUBOPT_0x37
	CPI  R30,LOW(0x2)
	BRLO _0xDA
_0xDB:
	CALL SUBOPT_0x38
	LDI  R26,LOW(_IS_LOCK_TURNED_ON)
	LDI  R27,HIGH(_IS_LOCK_TURNED_ON)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0340 
; 0000 0341     if((RealTimePrecisioningValue>29)||(RealTimePrecisioningValue<-29)){RealTimePrecisioningValue = 0;}
_0xDA:
	CALL SUBOPT_0x39
	CPI  R30,LOW(0x1E)
	BRGE _0xDE
	CPI  R30,LOW(0xE3)
	BRGE _0xDD
_0xDE:
	LDI  R26,LOW(_RealTimePrecisioningValue)
	LDI  R27,HIGH(_RealTimePrecisioningValue)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0342     if(IsRealTimePrecisioned>1){IsRealTimePrecisioned = 0;}
_0xDD:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRSH _0xE0
	CLR  R10
; 0000 0343 
; 0000 0344 rtc_get_time(&RealTimeHour,&RealTimeMinute,&RealTimeSecond);
_0xE0:
	CALL SUBOPT_0x3A
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x3B
; 0000 0345 rtc_get_date(&RealTimeDay, &RealTimeMonth, &RealTimeYear);
; 0000 0346 
; 0000 0347 static unsigned char STAND_BY;
; 0000 0348 static unsigned char UNLOCKED;
; 0000 0349 STAND_BY = 1;
	LDI  R30,LOW(1)
	STS  _STAND_BY_S000000F000,R30
; 0000 034A 
; 0000 034B     while(1){
_0xE1:
; 0000 034C     //////////////////////////////////////////////////////////////////////////////////
; 0000 034D     //////////////////////////// Funkcija kas 1 secunde //////////////////////////////
; 0000 034E     //////////////////////////////////////////////////////////////////////////////////
; 0000 034F     static unsigned int SecondCounter;
; 0000 0350     SecondCounter++;
	LDI  R26,LOW(_SecondCounter_S000000F001)
	LDI  R27,HIGH(_SecondCounter_S000000F001)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0351         if(SecondCounter>=500){
	LDS  R26,_SecondCounter_S000000F001
	LDS  R27,_SecondCounter_S000000F001+1
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0xE4
; 0000 0352         SecondCounter = 0;
	LDI  R30,LOW(0)
	STS  _SecondCounter_S000000F001,R30
	STS  _SecondCounter_S000000F001+1,R30
; 0000 0353         RefreshTime++;
	LDS  R30,_RefreshTime
	SUBI R30,-LOW(1)
	STS  _RefreshTime,R30
; 0000 0354         }
; 0000 0355 
; 0000 0356     static unsigned char TimeRefreshed;
_0xE4:
; 0000 0357         if(RefreshTime>=1){
	LDS  R26,_RefreshTime
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0xE5
; 0000 0358         TimeRefreshed = 1;
	LDI  R30,LOW(1)
	STS  _TimeRefreshed_S000000F001,R30
; 0000 0359         RefreshTime--;
	LDS  R30,_RefreshTime
	SUBI R30,LOW(1)
	STS  _RefreshTime,R30
; 0000 035A 
; 0000 035B         static unsigned char TIME_EDITING;
; 0000 035C             if(TIME_EDITING!=1){
	LDS  R26,_TIME_EDITING_S000000F002
	CPI  R26,LOW(0x1)
	BRNE PC+3
	JMP _0xE6
; 0000 035D             unsigned char Second;
; 0000 035E             rtc_get_time(&RealTimeHour,&RealTimeMinute,&Second);
	SBIW R28,1
;	Second -> Y+0
	CALL SUBOPT_0x3A
	MOVW R30,R28
	ADIW R30,4
	CALL SUBOPT_0x3B
; 0000 035F             rtc_get_date(&RealTimeDay,&RealTimeMonth,&RealTimeYear);
; 0000 0360             RealTimeWeekDay = rtc_read(0x03);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _rtc_read
	MOV  R8,R30
; 0000 0361 
; 0000 0362                 if(RealTimeSecond!=Second){
	LD   R30,Y
	CP   R30,R11
	BRNE PC+3
	JMP _0xE7
; 0000 0363                 RealTimeSecond = Second;
	LDD  R11,Y+0
; 0000 0364                 RefreshLcd++;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,-LOW(1)
	STS  _RefreshLcd_G000,R30
; 0000 0365 
; 0000 0366                     if(SUMMER_TIME_TURNED_ON==1){
	CALL SUBOPT_0x35
	CPI  R30,LOW(0x1)
	BRNE _0xE8
; 0000 0367                         if(IS_CLOCK_SUMMER==0){
	CALL SUBOPT_0x36
	CPI  R30,0
	BRNE _0xE9
; 0000 0368                             if(IsSummerTime(RealTimeMonth, RealTimeDay, RealTimeWeekDay)==1){
	CALL SUBOPT_0x3C
	CPI  R30,LOW(0x1)
	BRNE _0xEA
; 0000 0369                                 if(RealTimeHour<23){
	LDI  R30,LOW(23)
	CP   R6,R30
	BRSH _0xEB
; 0000 036A                                 RealTimeHour++;
	INC  R6
; 0000 036B                                 rtc_set_time(RealTimeHour,RealTimeMinute,RealTimeSecond);
	CALL SUBOPT_0x3D
; 0000 036C                                 IS_CLOCK_SUMMER = 1;
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 036D                                 }
; 0000 036E                             }
_0xEB:
; 0000 036F                         }
_0xEA:
; 0000 0370                         else{
	RJMP _0xEC
_0xE9:
; 0000 0371                             if(IsSummerTime(RealTimeMonth, RealTimeDay, RealTimeWeekDay)==0){
	CALL SUBOPT_0x3C
	CPI  R30,0
	BRNE _0xED
; 0000 0372                                 if(RealTimeHour>0){
	LDI  R30,LOW(0)
	CP   R30,R6
	BRSH _0xEE
; 0000 0373                                 RealTimeHour--;
	DEC  R6
; 0000 0374                                 rtc_set_time(RealTimeHour,RealTimeMinute,RealTimeSecond);
	CALL SUBOPT_0x3D
; 0000 0375                                 IS_CLOCK_SUMMER = 0;
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0376                                 }
; 0000 0377                             }
_0xEE:
; 0000 0378 
; 0000 0379                         }
_0xED:
_0xEC:
; 0000 037A                     }
; 0000 037B 
; 0000 037C 
; 0000 037D                     if(RealTimeHour==0){
_0xE8:
	TST  R6
	BRNE _0xEF
; 0000 037E                         if(RealTimeMinute==0){
	TST  R9
	BRNE _0xF0
; 0000 037F                             if(RealTimeSecond==30){
	LDI  R30,LOW(30)
	CP   R30,R11
	BRNE _0xF1
; 0000 0380                                 if(IsRealTimePrecisioned==0){
	TST  R10
	BRNE _0xF2
; 0000 0381                                     if(RealTimePrecisioningValue!=0){
	CALL SUBOPT_0x39
	CPI  R30,0
	BREQ _0xF3
; 0000 0382                                         if(RealTimeWeekDay==1){
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0xF4
; 0000 0383                                         RealTimeSecond += RealTimePrecisioningValue;
	CALL SUBOPT_0x39
	ADD  R11,R30
; 0000 0384                                         IsRealTimePrecisioned = 1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 0385                                         }
; 0000 0386                                     rtc_set_time(RealTimeHour,RealTimeMinute,RealTimeSecond);
_0xF4:
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R11
	CALL _rtc_set_time
; 0000 0387                                     }
; 0000 0388                                 }
_0xF3:
; 0000 0389                             }
_0xF2:
; 0000 038A                         }
_0xF1:
; 0000 038B                         else{
	RJMP _0xF5
_0xF0:
; 0000 038C                         IsRealTimePrecisioned = 0;
	CLR  R10
; 0000 038D                         }
_0xF5:
; 0000 038E                     }
; 0000 038F 
; 0000 0390 
; 0000 0391                 //---- Skambuciai ----//
; 0000 0392                 static unsigned int CALL_BELL;
_0xEF:
; 0000 0393                     if(RealTimeSecond==0){
	TST  R11
	BREQ PC+3
	JMP _0xF6
; 0000 0394                     unsigned char bell_id,type,a,b,c,z;
; 0000 0395                     a = IsEasterToday(RealTimeYear, RealTimeMonth, RealTimeDay);
	SBIW R28,6
;	Second -> Y+6
;	bell_id -> Y+5
;	type -> Y+4
;	a -> Y+3
;	b -> Y+2
;	c -> Y+1
;	z -> Y+0
	CALL SUBOPT_0x3E
	RCALL _IsEasterToday
	STD  Y+3,R30
; 0000 0396                     b = IsChristmasToday(RealTimeYear, RealTimeMonth, RealTimeDay);
	CALL SUBOPT_0x3E
	RCALL _IsChristmasToday
	STD  Y+2,R30
; 0000 0397                     c = IsPorciunkuleToday(RealTimeMonth, RealTimeDay, RealTimeWeekDay);
	ST   -Y,R4
	ST   -Y,R7
	ST   -Y,R8
	RCALL _IsPorciunkuleToday
	STD  Y+1,R30
; 0000 0398                     z = RealTimeWeekDay;
	__PUTBSR 8,0
; 0000 0399                     /////////////////////////////////
; 0000 039A                     // TYPE 0:  Pirmadienio
; 0000 039B                     // TYPE 1:  Antradienio
; 0000 039C                     // TYPE 2:  Treciadienio
; 0000 039D                     // TYPE 3:  Ketvirtadienio
; 0000 039E                     // TYPE 4:  Penktadienio
; 0000 039F                     // TYPE 5:  Sestadienio
; 0000 03A0                     // TYPE 6:  Sekmadienio
; 0000 03A1 
; 0000 03A2                     // TYPE 7:  Velyku ketvirtadienio
; 0000 03A3                     // TYPE 8:  Velyku penktadienio
; 0000 03A4                     // TYPE 9:  Velyku sestadienio
; 0000 03A5                     // TYPE 10: Velyku sekmadienio
; 0000 03A6 
; 0000 03A7                     // TYPE 11: Kaledu 1-os dienos
; 0000 03A8                     // TYPE 12: Kaledu 2-os dienos
; 0000 03A9 
; 0000 03AA                     // TYPE 13: Porciunkules atlaidai
; 0000 03AB                     /////////////////////////////////
; 0000 03AC 
; 0000 03AD                         if(a==4){      type = 7; }// Velyku Ketvirtadienis
	LDD  R26,Y+3
	CPI  R26,LOW(0x4)
	BRNE _0xF7
	LDI  R30,LOW(7)
	RJMP _0x53B
; 0000 03AE                         else if(a==5){ type = 8; }// Velyku Penktadienis
_0xF7:
	LDD  R26,Y+3
	CPI  R26,LOW(0x5)
	BRNE _0xF9
	LDI  R30,LOW(8)
	RJMP _0x53B
; 0000 03AF                         else if(a==6){ type = 9; }// Velyku Sestadienis
_0xF9:
	LDD  R26,Y+3
	CPI  R26,LOW(0x6)
	BRNE _0xFB
	LDI  R30,LOW(9)
	RJMP _0x53B
; 0000 03B0                         else if(a==7){ type = 10;}// Velyku Sekmadienis
_0xFB:
	LDD  R26,Y+3
	CPI  R26,LOW(0x7)
	BRNE _0xFD
	LDI  R30,LOW(10)
	RJMP _0x53B
; 0000 03B1 
; 0000 03B2                         else if(b==1){ type = 11;}// Kaledu 1-os diena
_0xFD:
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0xFF
	LDI  R30,LOW(11)
	RJMP _0x53B
; 0000 03B3                         else if(b==2){ type = 12;}// Kaledu 2-os diena
_0xFF:
	LDD  R26,Y+2
	CPI  R26,LOW(0x2)
	BRNE _0x101
	LDI  R30,LOW(12)
	RJMP _0x53B
; 0000 03B4 
; 0000 03B5                         else if(c==1){ type = 13;}// Porciunkules atlaidai
_0x101:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x103
	LDI  R30,LOW(13)
	RJMP _0x53B
; 0000 03B6 
; 0000 03B7                         else if(z==1){ type = 0; }// Pirmadienis
_0x103:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x105
	LDI  R30,LOW(0)
	RJMP _0x53B
; 0000 03B8                         else if(z==2){ type = 1; }// Antradienis
_0x105:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x107
	LDI  R30,LOW(1)
	RJMP _0x53B
; 0000 03B9                         else if(z==3){ type = 2; }// Treciadienis
_0x107:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x109
	LDI  R30,LOW(2)
	RJMP _0x53B
; 0000 03BA                         else if(z==4){ type = 3; }// Ketvirtadienis
_0x109:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x10B
	LDI  R30,LOW(3)
	RJMP _0x53B
; 0000 03BB                         else if(z==5){ type = 4; }// Penktadienis
_0x10B:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x10D
	LDI  R30,LOW(4)
	RJMP _0x53B
; 0000 03BC                         else if(z==6){ type = 5; }// Sestadienis
_0x10D:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x10F
	LDI  R30,LOW(5)
	RJMP _0x53B
; 0000 03BD                         else if(z==7){ type = 6; }// Sekmadienis
_0x10F:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x111
	LDI  R30,LOW(6)
_0x53B:
	STD  Y+4,R30
; 0000 03BE 
; 0000 03BF                         for(bell_id=0;bell_id<BELL_COUNT;bell_id++){
_0x111:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x113:
	LDD  R26,Y+5
	CPI  R26,LOW(0x14)
	BRSH _0x114
; 0000 03C0                             if(BELL_TIME[type][bell_id][0]==RealTimeHour){
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x19
	CP   R6,R30
	BRNE _0x115
; 0000 03C1                                 if(BELL_TIME[type][bell_id][1]==RealTimeMinute){
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
	CP   R9,R30
	BRNE _0x116
; 0000 03C2                                 CALL_BELL = BELL_TIME[type][bell_id][2];
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x41
	STS  _CALL_BELL_S000000F004,R30
	STS  _CALL_BELL_S000000F004+1,R31
; 0000 03C3                                 }
; 0000 03C4                             }
_0x116:
; 0000 03C5                         }
_0x115:
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x113
_0x114:
; 0000 03C6                     }
	ADIW R28,6
; 0000 03C7 
; 0000 03C8                     if(CALL_BELL>0){
_0xF6:
	LDS  R26,_CALL_BELL_S000000F004
	LDS  R27,_CALL_BELL_S000000F004+1
	CALL __CPW02
	BRSH _0x117
; 0000 03C9                     OUTPUT(BELL_OUTPUT_ADDRESS, 1);
	CALL SUBOPT_0x34
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _OUTPUT
; 0000 03CA                     CALL_BELL--;
	LDI  R26,LOW(_CALL_BELL_S000000F004)
	LDI  R27,HIGH(_CALL_BELL_S000000F004)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 03CB                     }
; 0000 03CC                     else{
	RJMP _0x118
_0x117:
; 0000 03CD                     OUTPUT(BELL_OUTPUT_ADDRESS, 0);
	CALL SUBOPT_0x34
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _OUTPUT
; 0000 03CE                     }
_0x118:
; 0000 03CF                 //--------------------//
; 0000 03D0 
; 0000 03D1 
; 0000 03D2                     if(STAND_BY_TIMER>0){
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BRSH _0x119
; 0000 03D3                     STAND_BY_TIMER--;
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
; 0000 03D4                         if(STAND_BY_TIMER==0){
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x11A
; 0000 03D5                         STAND_BY = 1;
	LDI  R30,LOW(1)
	STS  _STAND_BY_S000000F000,R30
; 0000 03D6                         Address[0] = 0;
	CALL SUBOPT_0x42
; 0000 03D7                         Address[1] = 0;
; 0000 03D8                         Address[2] = 0;
; 0000 03D9                         Address[3] = 0;
; 0000 03DA                         Address[4] = 0;
; 0000 03DB                         Address[5] = 0;
; 0000 03DC                         SelectedRow = 0;
; 0000 03DD                         UNLOCKED = 0;
	LDI  R30,LOW(0)
	STS  _UNLOCKED_S000000F000,R30
; 0000 03DE                         }
; 0000 03DF                     }
_0x11A:
; 0000 03E0 
; 0000 03E1                     if(MAIN_MENU_TIMER>0){
_0x119:
	LDS  R26,_MAIN_MENU_TIMER
	CPI  R26,LOW(0x1)
	BRLO _0x11B
; 0000 03E2                     MAIN_MENU_TIMER--;
	LDS  R30,_MAIN_MENU_TIMER
	SUBI R30,LOW(1)
	STS  _MAIN_MENU_TIMER,R30
; 0000 03E3                         if(MAIN_MENU_TIMER==0){
	CPI  R30,0
	BRNE _0x11C
; 0000 03E4                         Address[0] = 0;
	CALL SUBOPT_0x42
; 0000 03E5                         Address[1] = 0;
; 0000 03E6                         Address[2] = 0;
; 0000 03E7                         Address[3] = 0;
; 0000 03E8                         Address[4] = 0;
; 0000 03E9                         Address[5] = 0;
; 0000 03EA                         SelectedRow = 0;
; 0000 03EB                         }
; 0000 03EC                     }
_0x11C:
; 0000 03ED 
; 0000 03EE                     if(LCD_LED_TIMER>0){
_0x11B:
	LDS  R26,_LCD_LED_TIMER
	CPI  R26,LOW(0x1)
	BRLO _0x11D
; 0000 03EF                     LCD_LED_TIMER--;
	LDS  R30,_LCD_LED_TIMER
	SUBI R30,LOW(1)
	STS  _LCD_LED_TIMER,R30
; 0000 03F0                     }
; 0000 03F1 
; 0000 03F2                 }
_0x11D:
; 0000 03F3             }
_0xE7:
	ADIW R28,1
; 0000 03F4             else{
	RJMP _0x11E
_0xE6:
; 0000 03F5             RefreshLcd++;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,-LOW(1)
	STS  _RefreshLcd_G000,R30
; 0000 03F6             }
_0x11E:
; 0000 03F7         }
; 0000 03F8     //////////////////////////////////////////////////////////////////////////////////
; 0000 03F9     //////////////////////////////////////////////////////////////////////////////////
; 0000 03FA     //////////////////////////////////////////////////////////////////////////////////
; 0000 03FB 
; 0000 03FC 
; 0000 03FD     //////////////////////////////////////////////////////////////////////////////////
; 0000 03FE     /////////////////////////////////////// Mygtukai /////////////////////////////////
; 0000 03FF     //////////////////////////////////////////////////////////////////////////////////
; 0000 0400     static unsigned char BUTTON[5], ButtonFilter[5];
_0xE5:
; 0000 0401         if(1){
; 0000 0402         unsigned char i;
; 0000 0403             for(i=0;i<5;i++){
	SBIW R28,1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
_0x121:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRSH _0x122
; 0000 0404                 if(BUTTON_INPUT(i)==1){
	LD   R30,Y
	ST   -Y,R30
	RCALL _BUTTON_INPUT
	CPI  R30,LOW(0x1)
	BRNE _0x123
; 0000 0405                     if(ButtonFilter[i]<ButtonFiltrationTimer){
	CALL SUBOPT_0x43
	BRSH _0x124
; 0000 0406                     ButtonFilter[i]++;
	CALL SUBOPT_0x44
	SUBI R26,LOW(-_ButtonFilter_S000000F001)
	SBCI R27,HIGH(-_ButtonFilter_S000000F001)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 0407                     }
; 0000 0408                 }
_0x124:
; 0000 0409                 else{
	RJMP _0x125
_0x123:
; 0000 040A                     if(ButtonFilter[i]>=ButtonFiltrationTimer){
	CALL SUBOPT_0x43
	BRLO _0x126
; 0000 040B                     BUTTON[i] = 1;
	CALL SUBOPT_0x45
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 040C                     RefreshLcd = RefreshLcd + 2;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,-LOW(2)
	STS  _RefreshLcd_G000,R30
; 0000 040D                     STAND_BY_TIMER = 45;
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	MOVW R12,R30
; 0000 040E                     MAIN_MENU_TIMER = 30;
	LDI  R30,LOW(30)
	STS  _MAIN_MENU_TIMER,R30
; 0000 040F                     LCD_LED_TIMER = 15; lcd_light_now = lcd_light;
	LDI  R30,LOW(15)
	CALL SUBOPT_0x2D
; 0000 0410                     }
; 0000 0411                     else{
	RJMP _0x127
_0x126:
; 0000 0412                     BUTTON[i] = 0;
	CALL SUBOPT_0x45
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0413                     }
_0x127:
; 0000 0414                 ButtonFilter[i] = 0;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_ButtonFilter_S000000F001)
	SBCI R31,HIGH(-_ButtonFilter_S000000F001)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0415                 }
_0x125:
; 0000 0416             }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x121
_0x122:
; 0000 0417         }
	ADIW R28,1
; 0000 0418     //////////////////////////////////////////////////////////////////////////////////
; 0000 0419     //////////////////////////////////////////////////////////////////////////////////
; 0000 041A     //////////////////////////////////////////////////////////////////////////////////
; 0000 041B 
; 0000 041C 
; 0000 041D     //////////////////////////////////////////////////////////////////////////////////
; 0000 041E     ///////////////////////////// LCD ////////////////////////////////////////////////
; 0000 041F     //////////////////////////////////////////////////////////////////////////////////
; 0000 0420     // Lcd led
; 0000 0421     static unsigned char lcd_led_counter;
; 0000 0422         if(LCD_LED_TIMER==0){
	LDS  R30,_LCD_LED_TIMER
	CPI  R30,0
	BRNE _0x128
; 0000 0423             if(lcd_light_now>0){
	LDS  R26,_lcd_light_now_G000
	CPI  R26,LOW(0x1)
	BRLO _0x129
; 0000 0424             lcd_led_counter++;
	LDS  R30,_lcd_led_counter_S000000F001
	SUBI R30,-LOW(1)
	STS  _lcd_led_counter_S000000F001,R30
; 0000 0425                 if(lcd_led_counter>=25){
	LDS  R26,_lcd_led_counter_S000000F001
	CPI  R26,LOW(0x19)
	BRLO _0x12A
; 0000 0426                 lcd_led_counter = 0;
	LDI  R30,LOW(0)
	STS  _lcd_led_counter_S000000F001,R30
; 0000 0427                 lcd_light_now--;
	LDS  R30,_lcd_light_now_G000
	SUBI R30,LOW(1)
	STS  _lcd_light_now_G000,R30
; 0000 0428                 }
; 0000 0429             }
_0x12A:
; 0000 042A         }
_0x129:
; 0000 042B 
; 0000 042C 
; 0000 042D         if(STAND_BY==1){
_0x128:
	LDS  R26,_STAND_BY_S000000F000
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x12B
; 0000 042E         static unsigned char stand_by_pos[2];
; 0000 042F         stand_by_pos[0]++;
	LDS  R30,_stand_by_pos_S000000F002
	SUBI R30,-LOW(1)
	STS  _stand_by_pos_S000000F002,R30
; 0000 0430 
; 0000 0431             if(stand_by_pos[0]>=225){
	LDS  R26,_stand_by_pos_S000000F002
	CPI  R26,LOW(0xE1)
	BRSH PC+3
	JMP _0x12C
; 0000 0432             stand_by_pos[0] = 0;
	LDI  R30,LOW(0)
	STS  _stand_by_pos_S000000F002,R30
; 0000 0433             stand_by_pos[1]++;
	__GETB1MN _stand_by_pos_S000000F002,1
	SUBI R30,-LOW(1)
	__PUTB1MN _stand_by_pos_S000000F002,1
; 0000 0434                 if(stand_by_pos[1]>=44){
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x2C)
	BRLO _0x12D
; 0000 0435                 stand_by_pos[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _stand_by_pos_S000000F002,1
; 0000 0436                 }
; 0000 0437 
; 0000 0438             lcd_clear();
_0x12D:
	CALL _lcd_clear
; 0000 0439                 if(stand_by_pos[1]==0){lcd_gotoxy(0,2);lcd_putchar('|');lcd_gotoxy(0,1);lcd_putchar('|');lcd_gotoxy(0,0);lcd_putchar('^');}
	__GETB1MN _stand_by_pos_S000000F002,1
	CPI  R30,0
	BRNE _0x12E
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
	CALL SUBOPT_0x30
	CALL _lcd_gotoxy
	LDI  R30,LOW(94)
	RJMP _0x53C
; 0000 043A                 else if(stand_by_pos[1]==1){lcd_gotoxy(0,1);lcd_putchar('|');lcd_gotoxy(0,0);lcd_putsf("+>");}
_0x12E:
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x1)
	BRNE _0x130
	CALL SUBOPT_0x48
	CALL SUBOPT_0x30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,81
	CALL SUBOPT_0x2E
; 0000 043B                 else if((stand_by_pos[1]>=2)&&(stand_by_pos[1]<=19)){lcd_gotoxy(stand_by_pos[1]-2,0);lcd_putsf("-->");}
	RJMP _0x131
_0x130:
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x2)
	BRLO _0x133
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x14)
	BRLO _0x134
_0x133:
	RJMP _0x132
_0x134:
	__GETB1MN _stand_by_pos_S000000F002,1
	LDI  R31,0
	SBIW R30,2
	CALL SUBOPT_0x49
	__POINTW1FN _0x0,84
	CALL SUBOPT_0x2E
; 0000 043C                 else if(stand_by_pos[1]==20){lcd_gotoxy(18,0);lcd_putsf("-+");lcd_gotoxy(19,1);lcd_putchar('v');}
	RJMP _0x135
_0x132:
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x14)
	BRNE _0x136
	LDI  R30,LOW(18)
	CALL SUBOPT_0x49
	__POINTW1FN _0x0,18
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x4A
	LDI  R30,LOW(118)
	RJMP _0x53C
; 0000 043D                 else if(stand_by_pos[1]==21){lcd_gotoxy(19,0);lcd_putchar('|');lcd_gotoxy(19,1);lcd_putchar('|');lcd_gotoxy(19,2);lcd_putchar('v');}
_0x136:
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x15)
	BRNE _0x138
	LDI  R30,LOW(19)
	CALL SUBOPT_0x49
	CALL SUBOPT_0x47
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x47
	CALL SUBOPT_0x4B
	LDI  R30,LOW(118)
	RJMP _0x53C
; 0000 043E                 else if(stand_by_pos[1]==22){lcd_gotoxy(19,1);lcd_putchar('|');lcd_gotoxy(19,2);lcd_putchar('|');lcd_gotoxy(19,3);lcd_putchar('v');}
_0x138:
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x16)
	BRNE _0x13A
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x47
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x47
	CALL SUBOPT_0x4C
	LDI  R30,LOW(118)
	RJMP _0x53C
; 0000 043F                 else if(stand_by_pos[1]==23){lcd_gotoxy(19,2);lcd_putchar('|');lcd_gotoxy(18,3);lcd_putsf("<+");}
_0x13A:
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x17)
	BRNE _0x13C
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x47
	LDI  R30,LOW(18)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,88
	CALL SUBOPT_0x2E
; 0000 0440                 else if((stand_by_pos[1]>=24)&&(stand_by_pos[1]<=41)){lcd_gotoxy(17-stand_by_pos[1]+24,3);lcd_putsf("<--");}
	RJMP _0x13D
_0x13C:
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x18)
	BRLO _0x13F
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x2A)
	BRLO _0x140
_0x13F:
	RJMP _0x13E
_0x140:
	__GETB1MN _stand_by_pos_S000000F002,1
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
; 0000 0441                 else if(stand_by_pos[1]==42){lcd_gotoxy(0,2);lcd_putchar('^');lcd_gotoxy(0,3);lcd_putsf("+-");}
	RJMP _0x141
_0x13E:
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x2A)
	BRNE _0x142
	CALL SUBOPT_0x46
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,95
	CALL SUBOPT_0x2E
; 0000 0442                 else if(stand_by_pos[1]==43){lcd_gotoxy(0,1);lcd_putchar('^');lcd_gotoxy(0,2);lcd_putchar('|');lcd_gotoxy(0,3);lcd_putchar('|');}
	RJMP _0x143
_0x142:
	__GETB2MN _stand_by_pos_S000000F002,1
	CPI  R26,LOW(0x2B)
	BRNE _0x144
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
	LDI  R30,LOW(124)
_0x53C:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0443 
; 0000 0444             lcd_gotoxy(1,1);
_0x144:
_0x143:
_0x141:
_0x13D:
_0x135:
_0x131:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x4F
; 0000 0445             lcd_putsf("     ");
	__POINTW1FN _0x0,98
	CALL SUBOPT_0x2E
; 0000 0446             lcd_put_number(0,2,0,0,RealTimeHour,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0447             lcd_putsf(":");
	CALL SUBOPT_0x52
; 0000 0448             lcd_put_number(0,2,0,0,RealTimeMinute,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x53
; 0000 0449             lcd_putsf(":");
	CALL SUBOPT_0x52
; 0000 044A             lcd_put_number(0,2,0,0,RealTimeSecond,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x54
; 0000 044B             lcd_putsf("     ");
	__POINTW1FN _0x0,98
	CALL SUBOPT_0x2E
; 0000 044C 
; 0000 044D             lcd_gotoxy(1,2);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x55
; 0000 044E             lcd_putsf("    2");
	__POINTW1FN _0x0,106
	CALL SUBOPT_0x2E
; 0000 044F             lcd_put_number(0,3,0,0,RealTimeYear,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x56
; 0000 0450             lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0451             lcd_put_number(0,2,0,0,RealTimeMonth,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x58
; 0000 0452             lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0453             lcd_put_number(0,2,0,0,RealTimeDay,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x59
; 0000 0454             lcd_putsf("    ");
	CALL SUBOPT_0x5A
; 0000 0455             }
; 0000 0456 
; 0000 0457             if(BUTTON[BUTTON_LEFT]==1){
_0x12C:
	__GETB2MN _BUTTON_S000000F001,1
	CPI  R26,LOW(0x1)
	BREQ _0x53D
; 0000 0458             STAND_BY = 0;
; 0000 0459             }
; 0000 045A             else if(BUTTON[BUTTON_RIGHT]==1){
	__GETB2MN _BUTTON_S000000F001,3
	CPI  R26,LOW(0x1)
	BREQ _0x53D
; 0000 045B             STAND_BY = 0;
; 0000 045C             }
; 0000 045D             else if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BREQ _0x53D
; 0000 045E             STAND_BY = 0;
; 0000 045F             }
; 0000 0460             else if(BUTTON[BUTTON_UP]==1){
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BREQ _0x53D
; 0000 0461             STAND_BY = 0;
; 0000 0462             }
; 0000 0463             else if(BUTTON[BUTTON_ENTER]==1){
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x14D
; 0000 0464             STAND_BY = 0;
_0x53D:
	LDI  R30,LOW(0)
	STS  _STAND_BY_S000000F000,R30
; 0000 0465             }
; 0000 0466 
; 0000 0467         }
_0x14D:
; 0000 0468         else if((IS_LOCK_TURNED_ON==1)&&(UNLOCKED==0)){
	JMP  _0x14E
_0x12B:
	CALL SUBOPT_0x37
	CPI  R30,LOW(0x1)
	BRNE _0x150
	LDS  R26,_UNLOCKED_S000000F000
	CPI  R26,LOW(0x0)
	BREQ _0x151
_0x150:
	RJMP _0x14F
_0x151:
; 0000 0469         static unsigned int entering_code;
; 0000 046A             if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x152
; 0000 046B             lcd_clear();
	CALL _lcd_clear
; 0000 046C             }
; 0000 046D 
; 0000 046E             if(BUTTON[BUTTON_LEFT]==1){
_0x152:
	__GETB2MN _BUTTON_S000000F001,1
	CPI  R26,LOW(0x1)
	BRNE _0x153
; 0000 046F                 if(Address[0]>0){
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BRLO _0x154
; 0000 0470                 Address[0]--;
	LDS  R30,_Address_G000
	SUBI R30,LOW(1)
	STS  _Address_G000,R30
; 0000 0471                 }
; 0000 0472             }
_0x154:
; 0000 0473             else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x155
_0x153:
	__GETB2MN _BUTTON_S000000F001,3
	CPI  R26,LOW(0x1)
	BRNE _0x156
; 0000 0474                 if(Address[0]<3){
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x3)
	BRSH _0x157
; 0000 0475                 Address[0]++;
	LDS  R30,_Address_G000
	SUBI R30,-LOW(1)
	STS  _Address_G000,R30
; 0000 0476                 }
; 0000 0477             }
_0x157:
; 0000 0478             else if(BUTTON[BUTTON_DOWN]==1){
	RJMP _0x158
_0x156:
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x159
; 0000 0479                 if(Address[0]==0){
	LDS  R30,_Address_G000
	CPI  R30,0
	BRNE _0x15A
; 0000 047A                     if(entering_code>=1000){
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLO _0x15B
; 0000 047B                     entering_code += -1000;
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 047C                     }
; 0000 047D                 }
_0x15B:
; 0000 047E                 else if(Address[0]==1){
	RJMP _0x15C
_0x15A:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BRNE _0x15D
; 0000 047F                 unsigned int a;
; 0000 0480                 a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x5E
;	a -> Y+0
; 0000 0481                     if(a>=100){
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0x15E
; 0000 0482                     entering_code += -100;
	CALL SUBOPT_0x5F
; 0000 0483                     }
; 0000 0484                 }
_0x15E:
	RJMP _0x53E
; 0000 0485                 else if(Address[0]==2){
_0x15D:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x2)
	BRNE _0x160
; 0000 0486                 unsigned int a;
; 0000 0487                 a = entering_code - ((entering_code/100) * 100);
	CALL SUBOPT_0x60
;	a -> Y+0
; 0000 0488                     if(a>=10){
	BRLO _0x161
; 0000 0489                     entering_code += -10;
	CALL SUBOPT_0x61
; 0000 048A                     }
; 0000 048B                 }
_0x161:
	RJMP _0x53E
; 0000 048C                 else if(Address[0]==3){
_0x160:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x3)
	BRNE _0x163
; 0000 048D                 unsigned int a;
; 0000 048E                 a = entering_code - ((entering_code/10) * 10);
	CALL SUBOPT_0x62
;	a -> Y+0
; 0000 048F                     if(a>=1){
	BRLO _0x164
; 0000 0490                     entering_code += -1;
	CALL SUBOPT_0x63
; 0000 0491                     }
; 0000 0492                 }
_0x164:
_0x53E:
	ADIW R28,2
; 0000 0493             }
_0x163:
_0x15C:
; 0000 0494             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x165
_0x159:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x166
; 0000 0495                 if(Address[0]==0){
	LDS  R30,_Address_G000
	CPI  R30,0
	BRNE _0x167
; 0000 0496                     if(entering_code<9000){
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x2328)
	LDI  R30,HIGH(0x2328)
	CPC  R27,R30
	BRSH _0x168
; 0000 0497                     entering_code += 1000;
	CALL SUBOPT_0x64
; 0000 0498                     }
; 0000 0499                 }
_0x168:
; 0000 049A                 else if(Address[0]==1){
	RJMP _0x169
_0x167:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BRNE _0x16A
; 0000 049B                 unsigned int a;
; 0000 049C                 a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x5E
;	a -> Y+0
; 0000 049D                     if(a<900){
	CPI  R26,LOW(0x384)
	LDI  R30,HIGH(0x384)
	CPC  R27,R30
	BRSH _0x16B
; 0000 049E                     entering_code += 100;
	CALL SUBOPT_0x65
; 0000 049F                     }
; 0000 04A0                 }
_0x16B:
	ADIW R28,2
; 0000 04A1                 else if(Address[0]==2){
	RJMP _0x16C
_0x16A:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x2)
	BRNE _0x16D
; 0000 04A2                 unsigned char a;
; 0000 04A3                 a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x66
;	a -> Y+0
; 0000 04A4                 a = a - ((a/100) * 100);
	CALL SUBOPT_0x67
; 0000 04A5                     if(a<90){
	LD   R26,Y
	CPI  R26,LOW(0x5A)
	BRSH _0x16E
; 0000 04A6                     entering_code += 10;
	CALL SUBOPT_0x68
; 0000 04A7                     }
; 0000 04A8                 }
_0x16E:
	RJMP _0x53F
; 0000 04A9                 else if(Address[0]==3){
_0x16D:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x3)
	BRNE _0x170
; 0000 04AA                 unsigned char a;
; 0000 04AB                 a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x66
;	a -> Y+0
; 0000 04AC                 a = a - ((a/100) * 100);
	CALL SUBOPT_0x67
; 0000 04AD                 a = a - ((a/10) * 10);
	LDD  R22,Y+0
	CLR  R23
	CALL SUBOPT_0x44
	CALL SUBOPT_0x69
; 0000 04AE                     if(a<9){
	BRSH _0x171
; 0000 04AF                     entering_code += 1;
	CALL SUBOPT_0x6A
; 0000 04B0                     }
; 0000 04B1                 }
_0x171:
_0x53F:
	ADIW R28,1
; 0000 04B2             }
_0x170:
_0x16C:
_0x169:
; 0000 04B3             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x172
_0x166:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x173
; 0000 04B4             Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
; 0000 04B5                 if(entering_code==CODE){
	LDI  R26,LOW(_CODE)
	LDI  R27,HIGH(_CODE)
	CALL __EEPROMRDW
	CALL SUBOPT_0x5B
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x174
; 0000 04B6                 UNLOCKED = 1;
	LDI  R30,LOW(1)
	STS  _UNLOCKED_S000000F000,R30
; 0000 04B7                 entering_code = 0;
	CALL SUBOPT_0x6B
; 0000 04B8                 lcd_clear();
	CALL _lcd_clear
; 0000 04B9                 lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x4F
; 0000 04BA                 lcd_putsf("KODAS");
	__POINTW1FN _0x0,112
	CALL SUBOPT_0x2E
; 0000 04BB                 lcd_gotoxy(5,2);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x55
; 0000 04BC                 lcd_putsf("TEISINGAS");
	__POINTW1FN _0x0,118
	RJMP _0x540
; 0000 04BD                 delay_ms(1500);
; 0000 04BE                 }
; 0000 04BF                 else{
_0x174:
; 0000 04C0                 lcd_clear();
	CALL _lcd_clear
; 0000 04C1                 entering_code = 0;
	CALL SUBOPT_0x6B
; 0000 04C2                 lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x4F
; 0000 04C3                 lcd_putsf("KODAS");
	__POINTW1FN _0x0,112
	CALL SUBOPT_0x2E
; 0000 04C4                 lcd_gotoxy(4,2);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x55
; 0000 04C5                 lcd_putsf("NETEISINGAS");
	__POINTW1FN _0x0,128
_0x540:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 04C6                 delay_ms(1500);
	CALL SUBOPT_0x32
; 0000 04C7                 }
; 0000 04C8             }
; 0000 04C9 
; 0000 04CA             if(RefreshLcd>=1){
_0x173:
_0x172:
_0x165:
_0x158:
_0x155:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x176
; 0000 04CB             unsigned int i;
; 0000 04CC             lcd_putsf("-=====UZRAKTAS=====-");
	SBIW R28,2
;	i -> Y+0
	__POINTW1FN _0x0,140
	CALL SUBOPT_0x2E
; 0000 04CD             lcd_gotoxy(0,1);
	CALL SUBOPT_0x4E
; 0000 04CE             lcd_putsf("IVESKITE KODA: ");
	__POINTW1FN _0x0,161
	CALL SUBOPT_0x2E
; 0000 04CF             lcd_gotoxy(14,2);
	LDI  R30,LOW(14)
	CALL SUBOPT_0x55
; 0000 04D0             i = entering_code;
	CALL SUBOPT_0x5C
	ST   Y,R30
	STD  Y+1,R31
; 0000 04D1                 if(Address[0]==0){
	LDS  R30,_Address_G000
	CPI  R30,0
	BRNE _0x177
; 0000 04D2                 lcd_putchar( NumToIndex( i/1000) );
	CALL SUBOPT_0x6C
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x541
; 0000 04D3                 }
; 0000 04D4                 else{
_0x177:
; 0000 04D5                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x541:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 04D6                 }
; 0000 04D7             i = i - (i/1000)*1000;
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
; 0000 04D8                 if(Address[0]==1){
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BRNE _0x179
; 0000 04D9                 lcd_putchar( NumToIndex( i/100) );
	CALL SUBOPT_0x6E
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x542
; 0000 04DA                 }
; 0000 04DB                 else{
_0x179:
; 0000 04DC                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x542:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 04DD                 }
; 0000 04DE             i = i - (i/100)*100;
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6F
; 0000 04DF                 if(Address[0]==2){
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x2)
	BRNE _0x17B
; 0000 04E0                 lcd_putchar( NumToIndex( i/10) );
	CALL SUBOPT_0x70
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x543
; 0000 04E1                 }
; 0000 04E2                 else{
_0x17B:
; 0000 04E3                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x543:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 04E4                 }
; 0000 04E5             i = i - (i/10)*10;
	CALL SUBOPT_0x70
	CALL SUBOPT_0x71
; 0000 04E6                 if(Address[0]==3){
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x3)
	BRNE _0x17D
; 0000 04E7                 lcd_putchar( NumToIndex(i) );
	LD   R30,Y
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x544
; 0000 04E8                 }
; 0000 04E9                 else{
_0x17D:
; 0000 04EA                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x544:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 04EB                 }
; 0000 04EC             lcd_gotoxy(0,3);
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
; 0000 04ED             lcd_putsf("-==================-");
	__POINTW1FN _0x0,177
	CALL SUBOPT_0x2E
; 0000 04EE             }
	ADIW R28,2
; 0000 04EF         }
_0x176:
; 0000 04F0         else{
	JMP  _0x17F
_0x14F:
; 0000 04F1 
; 0000 04F2             if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x180
; 0000 04F3             lcd_clear();
	CALL _lcd_clear
; 0000 04F4             }
; 0000 04F5 
; 0000 04F6             // Pagrindinis langas
; 0000 04F7             if(Address[0]==0){
_0x180:
	LDS  R30,_Address_G000
	CPI  R30,0
	BREQ PC+3
	JMP _0x181
; 0000 04F8                 if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x182
; 0000 04F9                 SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 04FA                 }
; 0000 04FB                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x183
_0x182:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x184
; 0000 04FC                 SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 04FD                 }
; 0000 04FE                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x185
_0x184:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x186
; 0000 04FF                 Address[0] = SelectedRow;
	LDS  R30,_SelectedRow_G000
	STS  _Address_G000,R30
; 0000 0500                 SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0501                 Address[5] = 0;
; 0000 0502                 }
; 0000 0503 
; 0000 0504                 if(RefreshLcd>=1){
_0x186:
_0x185:
_0x183:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x187
; 0000 0505                 unsigned char row, lcd_row;
; 0000 0506                 lcd_row = 0;
	CALL SUBOPT_0x75
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 0507                 RowsOnWindow = 5;
; 0000 0508                     for(row=Address[5];row<4+Address[5];row++){
_0x189:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRLT PC+3
	JMP _0x18A
; 0000 0509                     lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 050A 
; 0000 050B                         if(row==0){
	BRNE _0x18B
; 0000 050C                         lcd_putsf("  -=PAGR. MENIU=-");
	__POINTW1FN _0x0,198
	RJMP _0x545
; 0000 050D                         }
; 0000 050E                         else if(row==1){
_0x18B:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x18D
; 0000 050F                         lcd_putsf("1.LAIKAS: ");
	__POINTW1FN _0x0,216
	CALL SUBOPT_0x2E
; 0000 0510                         lcd_put_number(0,2,0,0,RealTimeHour,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0511                         lcd_putsf(":");
	CALL SUBOPT_0x52
; 0000 0512                         lcd_put_number(0,2,0,0,RealTimeMinute,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x53
; 0000 0513                         lcd_putsf(" ");
	__POINTW1FN _0x0,102
	RJMP _0x545
; 0000 0514                         }
; 0000 0515                         else if(row==2){
_0x18D:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x18F
; 0000 0516                         lcd_putsf("2.DATA: 20");
	__POINTW1FN _0x0,227
	CALL SUBOPT_0x2E
; 0000 0517                         lcd_put_number(0,2,0,0,RealTimeYear,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x56
; 0000 0518                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0519                         lcd_put_number(0,2,0,0,RealTimeMonth,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x58
; 0000 051A                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 051B                         lcd_put_number(0,2,0,0,RealTimeDay,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x59
; 0000 051C                         }
; 0000 051D                         else if(row==3){
	RJMP _0x190
_0x18F:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x191
; 0000 051E                         lcd_putsf("3.SKAMBEJIMAI");
	__POINTW1FN _0x0,238
	RJMP _0x545
; 0000 051F                         }
; 0000 0520                         else if(row==4){
_0x191:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x193
; 0000 0521                         lcd_putsf("4.NUSTATYMAI");
	__POINTW1FN _0x0,252
_0x545:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0522                         }
; 0000 0523                     lcd_row++;
_0x193:
_0x190:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0524                     }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x189
_0x18A:
; 0000 0525 
; 0000 0526                 lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0527                 lcd_putchar('<');
; 0000 0528                 }
; 0000 0529             }
_0x187:
; 0000 052A 
; 0000 052B             // Laikas
; 0000 052C             else if(Address[0]==1){
	JMP  _0x194
_0x181:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x195
; 0000 052D                 if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BRNE _0x196
; 0000 052E                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x197
; 0000 052F                         if(SelectedRow<2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRSH _0x198
; 0000 0530                         SelectedRow = 2;
	LDI  R30,LOW(2)
	STS  _SelectedRow_G000,R30
; 0000 0531                         }
; 0000 0532                     }
_0x198:
; 0000 0533                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x199
_0x197:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x19A
; 0000 0534                         if(SelectedRow>0){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRLO _0x19B
; 0000 0535                         SelectedRow = 0;
	LDI  R30,LOW(0)
	STS  _SelectedRow_G000,R30
; 0000 0536                         }
; 0000 0537                     }
_0x19B:
; 0000 0538                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x19C
_0x19A:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x19D
; 0000 0539                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x19E
; 0000 053A                         Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
; 0000 053B                         }
; 0000 053C                         else{
	RJMP _0x19F
_0x19E:
; 0000 053D                         Address[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 053E                         }
_0x19F:
; 0000 053F                     SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0540                     Address[5] = 0;
; 0000 0541                     }
; 0000 0542                 }
_0x19D:
_0x19C:
_0x199:
; 0000 0543                 else{
	RJMP _0x1A0
_0x196:
; 0000 0544                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x1A1
; 0000 0545                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x1A2
; 0000 0546                             if(RealTimeHour-10>=0){
	CALL SUBOPT_0x7A
	SBIW R30,10
	TST  R31
	BRMI _0x1A3
; 0000 0547                             RealTimeHour += -10;
	LDI  R30,LOW(246)
	ADD  R6,R30
; 0000 0548                             }
; 0000 0549                         }
_0x1A3:
; 0000 054A                         else if(Address[1]==2){
	RJMP _0x1A4
_0x1A2:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x1A5
; 0000 054B                             if(RealTimeHour-1>=0){
	MOV  R30,R6
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x1A6
; 0000 054C                             RealTimeHour += -1;
	LDI  R30,LOW(255)
	ADD  R6,R30
; 0000 054D                             }
; 0000 054E                         }
_0x1A6:
; 0000 054F                         else if(Address[1]==3){
	RJMP _0x1A7
_0x1A5:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x1A8
; 0000 0550                             if(RealTimeMinute-10>=0){
	CALL SUBOPT_0x7B
	SBIW R30,10
	TST  R31
	BRMI _0x1A9
; 0000 0551                             RealTimeMinute += -10;
	LDI  R30,LOW(246)
	ADD  R9,R30
; 0000 0552                             }
; 0000 0553                         }
_0x1A9:
; 0000 0554                         else if(Address[1]==4){
	RJMP _0x1AA
_0x1A8:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x1AB
; 0000 0555                             if(RealTimeMinute-1>=0){
	MOV  R30,R9
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x1AC
; 0000 0556                             RealTimeMinute += -1;
	LDI  R30,LOW(255)
	ADD  R9,R30
; 0000 0557                             }
; 0000 0558                         }
_0x1AC:
; 0000 0559                     }
_0x1AB:
_0x1AA:
_0x1A7:
_0x1A4:
; 0000 055A                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x1AD
_0x1A1:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x1AE
; 0000 055B                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x1AF
; 0000 055C                             if(RealTimeHour+10<24){
	CALL SUBOPT_0x7A
	ADIW R30,10
	SBIW R30,24
	BRGE _0x1B0
; 0000 055D                             RealTimeHour += 10;
	LDI  R30,LOW(10)
	ADD  R6,R30
; 0000 055E                             }
; 0000 055F                         }
_0x1B0:
; 0000 0560                         else if(Address[1]==2){
	RJMP _0x1B1
_0x1AF:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x1B2
; 0000 0561                             if(RealTimeHour+1<24){
	CALL SUBOPT_0x7A
	ADIW R30,1
	SBIW R30,24
	BRGE _0x1B3
; 0000 0562                             RealTimeHour += 1;
	INC  R6
; 0000 0563                             }
; 0000 0564                         }
_0x1B3:
; 0000 0565                         else if(Address[1]==3){
	RJMP _0x1B4
_0x1B2:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x1B5
; 0000 0566                             if(RealTimeMinute+10<60){
	CALL SUBOPT_0x7B
	ADIW R30,10
	SBIW R30,60
	BRGE _0x1B6
; 0000 0567                             RealTimeMinute += 10;
	LDI  R30,LOW(10)
	ADD  R9,R30
; 0000 0568                             }
; 0000 0569                         }
_0x1B6:
; 0000 056A                         else if(Address[1]==4){
	RJMP _0x1B7
_0x1B5:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x1B8
; 0000 056B                             if(RealTimeMinute+1<60){
	CALL SUBOPT_0x7B
	ADIW R30,1
	SBIW R30,60
	BRGE _0x1B9
; 0000 056C                             RealTimeMinute += 1;
	INC  R9
; 0000 056D                             }
; 0000 056E                         }
_0x1B9:
; 0000 056F                     }
_0x1B8:
_0x1B7:
_0x1B4:
_0x1B1:
; 0000 0570                     else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x1BA
_0x1AE:
	__GETB2MN _BUTTON_S000000F001,1
	CPI  R26,LOW(0x1)
	BRNE _0x1BB
; 0000 0571                         if(Address[1]>1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRLO _0x1BC
; 0000 0572                         Address[1]--;
	__GETB1MN _Address_G000,1
	SUBI R30,LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 0573                         }
; 0000 0574                     }
_0x1BC:
; 0000 0575                     else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x1BD
_0x1BB:
	__GETB2MN _BUTTON_S000000F001,3
	CPI  R26,LOW(0x1)
	BRNE _0x1BE
; 0000 0576                         if(Address[1]<4){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRSH _0x1BF
; 0000 0577                         Address[1]++;
	__GETB1MN _Address_G000,1
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 0578                         }
; 0000 0579                     }
_0x1BF:
; 0000 057A                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x1C0
_0x1BE:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x1C1
; 0000 057B                     Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 057C                     SelectedRow = 0;
; 0000 057D                     Address[5] = 0;
; 0000 057E                     }
; 0000 057F                 }
_0x1C1:
_0x1C0:
_0x1BD:
_0x1BA:
_0x1AD:
_0x1A0:
; 0000 0580 
; 0000 0581                 if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x1C2
; 0000 0582                 RowsOnWindow = 7;
	LDI  R30,LOW(7)
	STS  _RowsOnWindow_G000,R30
; 0000 0583 
; 0000 0584                 lcd_putsf("     -=LAIKAS=-     ");
	__POINTW1FN _0x0,265
	CALL SUBOPT_0x2E
; 0000 0585                 lcd_putsf("LAIKAS: ");
	CALL SUBOPT_0x7D
; 0000 0586                 lcd_put_number(0,2,0,0,RealTimeHour,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
; 0000 0587                 lcd_putsf(":");
	CALL SUBOPT_0x52
; 0000 0588                 lcd_put_number(0,2,0,0,RealTimeMinute,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x53
; 0000 0589                 lcd_putsf(":");
	CALL SUBOPT_0x52
; 0000 058A                     if(Address[1]>0){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRLO _0x1C3
; 0000 058B                     RealTimeSecond = 0;
	CLR  R11
; 0000 058C                     }
; 0000 058D                 lcd_put_number(0,2,0,0,RealTimeSecond,0);
_0x1C3:
	CALL SUBOPT_0x50
	CALL SUBOPT_0x54
; 0000 058E                 lcd_putsf("    ");
	CALL SUBOPT_0x5A
; 0000 058F 
; 0000 0590                     if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BRNE _0x1C4
; 0000 0591                     lcd_putsf("      REDAGUOTI?");
	__POINTW1FN _0x0,286
	CALL SUBOPT_0x2E
; 0000 0592                     lcd_gotoxy(19,SelectedRow);
	CALL SUBOPT_0x7E
; 0000 0593                     lcd_putchar('<');
; 0000 0594                     }
; 0000 0595                     else{
	RJMP _0x1C5
_0x1C4:
; 0000 0596                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x1C6
; 0000 0597                         lcd_putsf("        ^");
	__POINTW1FN _0x0,303
	RJMP _0x546
; 0000 0598                         }
; 0000 0599                         else if(Address[1]==2){
_0x1C6:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x1C8
; 0000 059A                         lcd_putsf("         ^");
	__POINTW1FN _0x0,313
	RJMP _0x546
; 0000 059B                         }
; 0000 059C                         else if(Address[1]==3){
_0x1C8:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x1CA
; 0000 059D                         lcd_putsf("           ^");
	__POINTW1FN _0x0,324
	RJMP _0x546
; 0000 059E                         }
; 0000 059F                         else if(Address[1]==4){
_0x1CA:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x1CC
; 0000 05A0                         lcd_putsf("            ^");
	__POINTW1FN _0x0,337
_0x546:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05A1                         }
; 0000 05A2                     rtc_set_time(RealTimeHour, RealTimeMinute, RealTimeSecond);
_0x1CC:
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R11
	CALL _rtc_set_time
; 0000 05A3                     }
_0x1C5:
; 0000 05A4 
; 0000 05A5 
; 0000 05A6                     if(SUMMER_TIME_TURNED_ON==1){
	CALL SUBOPT_0x35
	CPI  R30,LOW(0x1)
	BRNE _0x1CD
; 0000 05A7                     lcd_gotoxy(0,3);
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
; 0000 05A8                         if(IS_CLOCK_SUMMER==0){
	CALL SUBOPT_0x36
	CPI  R30,0
	BRNE _0x1CE
; 0000 05A9                         lcd_putsf("(ZIEMOS LAIKAS)");
	__POINTW1FN _0x0,351
	RJMP _0x547
; 0000 05AA                         }
; 0000 05AB                         else{
_0x1CE:
; 0000 05AC                         lcd_putsf("(VASAROS LAIKAS)");
	__POINTW1FN _0x0,367
_0x547:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 05AD                         }
; 0000 05AE                     }
; 0000 05AF                 }
_0x1CD:
; 0000 05B0             }
_0x1C2:
; 0000 05B1 
; 0000 05B2             // Data
; 0000 05B3             else if(Address[0]==2){
	JMP  _0x1D0
_0x195:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x1D1
; 0000 05B4                 if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BRNE _0x1D2
; 0000 05B5                     if(BUTTON[BUTTON_UP]==1){
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x1D3
; 0000 05B6                     SelectedRow = 0;
	LDI  R30,LOW(0)
	STS  _SelectedRow_G000,R30
; 0000 05B7                     }
; 0000 05B8                     else if(BUTTON[BUTTON_DOWN]==1){
	RJMP _0x1D4
_0x1D3:
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x1D5
; 0000 05B9                     SelectedRow = 3;
	LDI  R30,LOW(3)
	STS  _SelectedRow_G000,R30
; 0000 05BA                     }
; 0000 05BB                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x1D6
_0x1D5:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x1D7
; 0000 05BC                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x1D8
; 0000 05BD                         Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
; 0000 05BE                         }
; 0000 05BF                         else{
	RJMP _0x1D9
_0x1D8:
; 0000 05C0                         Address[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 05C1                         }
_0x1D9:
; 0000 05C2                     SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 05C3                     Address[5] = 0;
; 0000 05C4                     }
; 0000 05C5                 }
_0x1D7:
_0x1D6:
_0x1D4:
; 0000 05C6                 else{
	RJMP _0x1DA
_0x1D2:
; 0000 05C7                     if(BUTTON[BUTTON_UP]==1){
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x1DB
; 0000 05C8                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x1DC
; 0000 05C9                             if(RealTimeYear<90){
	LDI  R30,LOW(90)
	CP   R5,R30
	BRSH _0x1DD
; 0000 05CA                             RealTimeYear +=10;
	LDI  R30,LOW(10)
	ADD  R5,R30
; 0000 05CB                             }
; 0000 05CC                         }
_0x1DD:
; 0000 05CD                         else if(Address[1]==2){
	RJMP _0x1DE
_0x1DC:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x1DF
; 0000 05CE                             if(RealTimeYear<99){
	LDI  R30,LOW(99)
	CP   R5,R30
	BRSH _0x1E0
; 0000 05CF                             RealTimeYear +=1;
	INC  R5
; 0000 05D0                             }
; 0000 05D1                         }
_0x1E0:
; 0000 05D2                         else if(Address[1]==3){
	RJMP _0x1E1
_0x1DF:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x1E2
; 0000 05D3                             if(RealTimeMonth<=2){
	LDI  R30,LOW(2)
	CP   R30,R4
	BRLO _0x1E3
; 0000 05D4                             RealTimeMonth +=10;
	LDI  R30,LOW(10)
	ADD  R4,R30
; 0000 05D5                             }
; 0000 05D6                         }
_0x1E3:
; 0000 05D7                         else if(Address[1]==4){
	RJMP _0x1E4
_0x1E2:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x1E5
; 0000 05D8                             if(RealTimeMonth<12){
	LDI  R30,LOW(12)
	CP   R4,R30
	BRSH _0x1E6
; 0000 05D9                             RealTimeMonth +=1;
	INC  R4
; 0000 05DA                             }
; 0000 05DB                         }
_0x1E6:
; 0000 05DC                         else if(Address[1]==5){
	RJMP _0x1E7
_0x1E5:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x5)
	BRNE _0x1E8
; 0000 05DD                             if(RealTimeDay<=DayCountInMonth(RealTimeYear,RealTimeMonth)-10){
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x80
	MOV  R26,R7
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x1E9
; 0000 05DE                             RealTimeDay += 10;
	LDI  R30,LOW(10)
	ADD  R7,R30
; 0000 05DF                             }
; 0000 05E0                         }
_0x1E9:
; 0000 05E1                         else if(Address[1]==6){
	RJMP _0x1EA
_0x1E8:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x6)
	BRNE _0x1EB
; 0000 05E2                             if(RealTimeDay<DayCountInMonth(RealTimeYear,RealTimeMonth)){
	CALL SUBOPT_0x7F
	CP   R7,R30
	BRSH _0x1EC
; 0000 05E3                             RealTimeDay += 1;
	INC  R7
; 0000 05E4                             }
; 0000 05E5                         }
_0x1EC:
; 0000 05E6                         else if(Address[1]==7){
	RJMP _0x1ED
_0x1EB:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x7)
	BRNE _0x1EE
; 0000 05E7                             if(RealTimeWeekDay<7){
	LDI  R30,LOW(7)
	CP   R8,R30
	BRSH _0x1EF
; 0000 05E8                             RealTimeWeekDay += 1;
	INC  R8
; 0000 05E9                             }
; 0000 05EA                         }
_0x1EF:
; 0000 05EB                     }
_0x1EE:
_0x1ED:
_0x1EA:
_0x1E7:
_0x1E4:
_0x1E1:
_0x1DE:
; 0000 05EC                     else if(BUTTON[BUTTON_DOWN]==1){
	RJMP _0x1F0
_0x1DB:
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x1F1
; 0000 05ED                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x1F2
; 0000 05EE                             if(RealTimeYear>=10){
	LDI  R30,LOW(10)
	CP   R5,R30
	BRLO _0x1F3
; 0000 05EF                             RealTimeYear += -10;
	LDI  R30,LOW(246)
	ADD  R5,R30
; 0000 05F0                             }
; 0000 05F1                         }
_0x1F3:
; 0000 05F2                         else if(Address[1]==2){
	RJMP _0x1F4
_0x1F2:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x1F5
; 0000 05F3                             if(RealTimeYear>0){
	LDI  R30,LOW(0)
	CP   R30,R5
	BRSH _0x1F6
; 0000 05F4                             RealTimeYear += -1;
	LDI  R30,LOW(255)
	ADD  R5,R30
; 0000 05F5                             }
; 0000 05F6                         }
_0x1F6:
; 0000 05F7                         else if(Address[1]==3){
	RJMP _0x1F7
_0x1F5:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x1F8
; 0000 05F8                             if(RealTimeMonth>10){
	LDI  R30,LOW(10)
	CP   R30,R4
	BRSH _0x1F9
; 0000 05F9                             RealTimeMonth += -10;
	LDI  R30,LOW(246)
	ADD  R4,R30
; 0000 05FA                             }
; 0000 05FB                         }
_0x1F9:
; 0000 05FC                         else if(Address[1]==4){
	RJMP _0x1FA
_0x1F8:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x1FB
; 0000 05FD                             if(RealTimeMonth>1){
	LDI  R30,LOW(1)
	CP   R30,R4
	BRSH _0x1FC
; 0000 05FE                             RealTimeMonth += -1;
	LDI  R30,LOW(255)
	ADD  R4,R30
; 0000 05FF                             }
; 0000 0600                         }
_0x1FC:
; 0000 0601                         else if(Address[1]==5){
	RJMP _0x1FD
_0x1FB:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x5)
	BRNE _0x1FE
; 0000 0602                             if(RealTimeDay>10){
	LDI  R30,LOW(10)
	CP   R30,R7
	BRSH _0x1FF
; 0000 0603                             RealTimeDay += -10;
	LDI  R30,LOW(246)
	ADD  R7,R30
; 0000 0604                             }
; 0000 0605                         }
_0x1FF:
; 0000 0606                         else if(Address[1]==6){
	RJMP _0x200
_0x1FE:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x6)
	BRNE _0x201
; 0000 0607                             if(RealTimeDay>1){
	LDI  R30,LOW(1)
	CP   R30,R7
	BRSH _0x202
; 0000 0608                             RealTimeDay += -1;
	LDI  R30,LOW(255)
	ADD  R7,R30
; 0000 0609                             }
; 0000 060A                         }
_0x202:
; 0000 060B                         else if(Address[1]==7){
	RJMP _0x203
_0x201:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x7)
	BRNE _0x204
; 0000 060C                             if(RealTimeWeekDay>1){
	LDI  R30,LOW(1)
	CP   R30,R8
	BRSH _0x205
; 0000 060D                             RealTimeWeekDay += -1;
	LDI  R30,LOW(255)
	ADD  R8,R30
; 0000 060E                             }
; 0000 060F                         }
_0x205:
; 0000 0610 
; 0000 0611                     }
_0x204:
_0x203:
_0x200:
_0x1FD:
_0x1FA:
_0x1F7:
_0x1F4:
; 0000 0612                     else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x206
_0x1F1:
	__GETB2MN _BUTTON_S000000F001,1
	CPI  R26,LOW(0x1)
	BRNE _0x207
; 0000 0613                         if(Address[1]>1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRLO _0x208
; 0000 0614                         Address[1]--;
	__GETB1MN _Address_G000,1
	SUBI R30,LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 0615                         }
; 0000 0616                     }
_0x208:
; 0000 0617                     else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x209
_0x207:
	__GETB2MN _BUTTON_S000000F001,3
	CPI  R26,LOW(0x1)
	BRNE _0x20A
; 0000 0618                         if(Address[1]<7){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x7)
	BRSH _0x20B
; 0000 0619                         Address[1]++;
	__GETB1MN _Address_G000,1
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,1
; 0000 061A                         }
; 0000 061B                     }
_0x20B:
; 0000 061C                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x20C
_0x20A:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x20D
; 0000 061D                     Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 061E                     SelectedRow = 0;
; 0000 061F                     Address[5] = 0;
; 0000 0620                     }
; 0000 0621 
; 0000 0622                     if(DayCountInMonth(RealTimeYear, RealTimeMonth)<RealTimeDay){
_0x20D:
_0x20C:
_0x209:
_0x206:
_0x1F0:
	CALL SUBOPT_0x7F
	CP   R30,R7
	BRSH _0x20E
; 0000 0623                     RealTimeDay = DayCountInMonth(RealTimeYear, RealTimeMonth);
	CALL SUBOPT_0x7F
	MOV  R7,R30
; 0000 0624                     }
; 0000 0625                 }
_0x20E:
_0x1DA:
; 0000 0626 
; 0000 0627                 if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x20F
; 0000 0628                 lcd_putsf(" -=NUSTATYTI DATA=- ");
	__POINTW1FN _0x0,384
	CALL SUBOPT_0x2E
; 0000 0629 
; 0000 062A 
; 0000 062B                     if(RealTimeWeekDay==1){
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0x210
; 0000 062C                     lcd_putsf("SAV.DIENA: PIRMAD.  ");
	__POINTW1FN _0x0,405
	RJMP _0x548
; 0000 062D                     }
; 0000 062E                     else if(RealTimeWeekDay==2){
_0x210:
	LDI  R30,LOW(2)
	CP   R30,R8
	BRNE _0x212
; 0000 062F                     lcd_putsf("SAV.DIENA: ANTRAD.  ");
	__POINTW1FN _0x0,426
	RJMP _0x548
; 0000 0630                     }
; 0000 0631                     else if(RealTimeWeekDay==3){
_0x212:
	LDI  R30,LOW(3)
	CP   R30,R8
	BRNE _0x214
; 0000 0632                     lcd_putsf("SAV.DIENA: TRECIAD. ");
	__POINTW1FN _0x0,447
	RJMP _0x548
; 0000 0633                     }
; 0000 0634                     else if(RealTimeWeekDay==4){
_0x214:
	LDI  R30,LOW(4)
	CP   R30,R8
	BRNE _0x216
; 0000 0635                     lcd_putsf("SAV.DIENA: KETVIRT. ");
	__POINTW1FN _0x0,468
	RJMP _0x548
; 0000 0636                     }
; 0000 0637                     else if(RealTimeWeekDay==5){
_0x216:
	LDI  R30,LOW(5)
	CP   R30,R8
	BRNE _0x218
; 0000 0638                     lcd_putsf("SAV.DIENA: PENKTAD. ");
	__POINTW1FN _0x0,489
	RJMP _0x548
; 0000 0639                     }
; 0000 063A                     else if(RealTimeWeekDay==6){
_0x218:
	LDI  R30,LOW(6)
	CP   R30,R8
	BRNE _0x21A
; 0000 063B                     lcd_putsf("SAV.DIENA: SESTAD.  ");
	__POINTW1FN _0x0,510
	RJMP _0x548
; 0000 063C                     }
; 0000 063D                     else if(RealTimeWeekDay==7){
_0x21A:
	LDI  R30,LOW(7)
	CP   R30,R8
	BRNE _0x21C
; 0000 063E                     lcd_putsf("SAV.DIENA: SEKMAD.  ");
	__POINTW1FN _0x0,531
	RJMP _0x548
; 0000 063F                     }
; 0000 0640                     else{
_0x21C:
; 0000 0641                     lcd_putsf("???                 ");
	__POINTW1FN _0x0,552
_0x548:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0642                     }
; 0000 0643 
; 0000 0644                 lcd_putsf("DATA: 2");
	__POINTW1FN _0x0,573
	CALL SUBOPT_0x2E
; 0000 0645                 lcd_put_number(0,3,0,0,RealTimeYear,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x56
; 0000 0646                 lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0647                 lcd_put_number(0,2,0,0,RealTimeMonth,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x58
; 0000 0648                 lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0649                 lcd_put_number(0,2,0,0,RealTimeDay,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x59
; 0000 064A                 lcd_putsf("    ");
	CALL SUBOPT_0x5A
; 0000 064B 
; 0000 064C                     if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BRNE _0x21E
; 0000 064D                     lcd_putsf("      REDAGUOTI?    ");
	CALL SUBOPT_0x81
; 0000 064E                     }
; 0000 064F                     else{
	RJMP _0x21F
_0x21E:
; 0000 0650                         if(Address[1]==1){
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BRNE _0x220
; 0000 0651                         lcd_putsf("        ^           ");
	__POINTW1FN _0x0,602
	RJMP _0x549
; 0000 0652                         }
; 0000 0653                         else if(Address[1]==2){
_0x220:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BRNE _0x222
; 0000 0654                         lcd_putsf("         ^          ");
	__POINTW1FN _0x0,623
	RJMP _0x549
; 0000 0655                         }
; 0000 0656 
; 0000 0657                         else if(Address[1]==3){
_0x222:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BRNE _0x224
; 0000 0658                         lcd_putsf("           ^        ");
	__POINTW1FN _0x0,644
	RJMP _0x549
; 0000 0659                         }
; 0000 065A                         else if(Address[1]==4){
_0x224:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BRNE _0x226
; 0000 065B                         lcd_putsf("            ^       ");
	__POINTW1FN _0x0,665
	RJMP _0x549
; 0000 065C                         }
; 0000 065D 
; 0000 065E                         else if(Address[1]==5){
_0x226:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x5)
	BRNE _0x228
; 0000 065F                         lcd_putsf("              ^     ");
	__POINTW1FN _0x0,686
	RJMP _0x549
; 0000 0660                         }
; 0000 0661                         else if(Address[1]==6){
_0x228:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x6)
	BRNE _0x22A
; 0000 0662                         lcd_putsf("               ^    ");
	__POINTW1FN _0x0,707
	RJMP _0x549
; 0000 0663                         }
; 0000 0664                         else if(Address[1]==7){
_0x22A:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x7)
	BRNE _0x22C
; 0000 0665                         lcd_gotoxy(16, 2);
	LDI  R30,LOW(16)
	CALL SUBOPT_0x55
; 0000 0666                         lcd_putchar('^');
	CALL SUBOPT_0x4D
; 0000 0667                         lcd_gotoxy(0, 3);
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
; 0000 0668                         lcd_putsf("                |   ");
	__POINTW1FN _0x0,728
_0x549:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0669                         }
; 0000 066A                     rtc_set_date(RealTimeDay, RealTimeMonth, RealTimeYear);
_0x22C:
	ST   -Y,R7
	ST   -Y,R4
	ST   -Y,R5
	CALL _rtc_set_date
; 0000 066B                     rtc_write(0x03, RealTimeWeekDay);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R8
	CALL _rtc_write
; 0000 066C                     }
_0x21F:
; 0000 066D 
; 0000 066E                     if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BRNE _0x22D
; 0000 066F                     lcd_gotoxy(19,SelectedRow);
	CALL SUBOPT_0x7E
; 0000 0670                     lcd_putchar('<');
; 0000 0671                     }
; 0000 0672                 }
_0x22D:
; 0000 0673             }
_0x20F:
; 0000 0674 
; 0000 0675             // Skambejimai
; 0000 0676             else if(Address[0]==3){
	JMP  _0x22E
_0x1D1:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0x22F
; 0000 0677             // SKAMBEJIMU MENIU
; 0000 0678                 if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BREQ PC+3
	JMP _0x230
; 0000 0679                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x231
; 0000 067A                     SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 067B                     }
; 0000 067C                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x232
_0x231:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x233
; 0000 067D                     SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 067E                     }
; 0000 067F                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x234
_0x233:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x235
; 0000 0680                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x236
; 0000 0681                         Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
; 0000 0682                         }
; 0000 0683                         else{
	RJMP _0x237
_0x236:
; 0000 0684                         Address[1] = SelectedRow;
	LDS  R30,_SelectedRow_G000
	__PUTB1MN _Address_G000,1
; 0000 0685                         }
_0x237:
; 0000 0686                     SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0687                     Address[5] = 0;
; 0000 0688                     }
; 0000 0689 
; 0000 068A                     if(RefreshLcd>=1){
_0x235:
_0x234:
_0x232:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x238
; 0000 068B                     unsigned char row, lcd_row;
; 0000 068C                     lcd_row = 0;
	CALL SUBOPT_0x75
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 068D                     RowsOnWindow = 5;
; 0000 068E                         for(row=Address[5];row<4+Address[5];row++){
_0x23A:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRGE _0x23B
; 0000 068F                         lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 0690 
; 0000 0691                             if(row==0){
	BRNE _0x23C
; 0000 0692                             lcd_putsf("  -=SKAMBEJIMAI=-");
	__POINTW1FN _0x0,749
	RJMP _0x54A
; 0000 0693                             }
; 0000 0694                             else if(row==1){
_0x23C:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x23E
; 0000 0695                             lcd_putsf("1.EILINIS LAIKAS");
	__POINTW1FN _0x0,767
	RJMP _0x54A
; 0000 0696                             }
; 0000 0697                             else if(row==2){
_0x23E:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x240
; 0000 0698                             lcd_putsf("2.VELYKU LAIKAS");
	__POINTW1FN _0x0,784
	RJMP _0x54A
; 0000 0699                             }
; 0000 069A                             else if(row==3){
_0x240:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x242
; 0000 069B                             lcd_putsf("3.KALEDU LAIKAS");
	__POINTW1FN _0x0,800
	RJMP _0x54A
; 0000 069C                             }
; 0000 069D                             else if(row==4){
_0x242:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x244
; 0000 069E                             lcd_putsf("4.PORCIUNKULE");
	__POINTW1FN _0x0,816
_0x54A:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 069F                             }
; 0000 06A0 
; 0000 06A1                         lcd_row++;
_0x244:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 06A2                         }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x23A
_0x23B:
; 0000 06A3 
; 0000 06A4                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 06A5                     lcd_putchar('<');
; 0000 06A6                     }
; 0000 06A7                 }
_0x238:
; 0000 06A8             /////////////////////
; 0000 06A9 
; 0000 06AA             // EILINIO LAIKO MENIU
; 0000 06AB                 else if(Address[1]==1){
	JMP  _0x245
_0x230:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x246
; 0000 06AC                     if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BREQ PC+3
	JMP _0x247
; 0000 06AD                         if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x248
; 0000 06AE                         SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 06AF                         }
; 0000 06B0                         else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x249
_0x248:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x24A
; 0000 06B1                         SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 06B2                         }
; 0000 06B3                         else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x24B
_0x24A:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x24C
; 0000 06B4                             if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x24D
; 0000 06B5                             Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 06B6                             }
; 0000 06B7                             else{
	RJMP _0x24E
_0x24D:
; 0000 06B8                             Address[2] = SelectedRow;
	CALL SUBOPT_0x82
; 0000 06B9                             }
_0x24E:
; 0000 06BA                         SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 06BB                         Address[5] = 0;
; 0000 06BC                         }
; 0000 06BD 
; 0000 06BE 
; 0000 06BF                         if(RefreshLcd>=1){
_0x24C:
_0x24B:
_0x249:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x24F
; 0000 06C0                         unsigned char row, lcd_row;
; 0000 06C1                         lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 06C2                         RowsOnWindow = 8;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x83
; 0000 06C3                             for(row=Address[5];row<4+Address[5];row++){
_0x251:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRGE _0x252
; 0000 06C4                             lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 06C5 
; 0000 06C6                                 if(row==0){
	BRNE _0x253
; 0000 06C7                                 lcd_putsf(" -=EILINIS LAIKAS=-");
	__POINTW1FN _0x0,830
	RJMP _0x54B
; 0000 06C8                                 }
; 0000 06C9                                 else if(row==1){
_0x253:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x255
; 0000 06CA                                 lcd_putsf("1.PIRMAD. LAIKAS");
	__POINTW1FN _0x0,850
	RJMP _0x54B
; 0000 06CB                                 }
; 0000 06CC                                 else if(row==2){
_0x255:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x257
; 0000 06CD                                 lcd_putsf("2.ANTRAD. LAIKAS");
	__POINTW1FN _0x0,867
	RJMP _0x54B
; 0000 06CE                                 }
; 0000 06CF                                 else if(row==3){
_0x257:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x259
; 0000 06D0                                 lcd_putsf("3.TRECIAD. LAIKAS");
	__POINTW1FN _0x0,884
	RJMP _0x54B
; 0000 06D1                                 }
; 0000 06D2                                 else if(row==4){
_0x259:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x25B
; 0000 06D3                                 lcd_putsf("4.KETVIRTAD. LAIKAS");
	__POINTW1FN _0x0,902
	RJMP _0x54B
; 0000 06D4                                 }
; 0000 06D5                                 else if(row==5){
_0x25B:
	LDD  R26,Y+1
	CPI  R26,LOW(0x5)
	BRNE _0x25D
; 0000 06D6                                 lcd_putsf("5.PENKTAD. LAIKAS");
	__POINTW1FN _0x0,922
	RJMP _0x54B
; 0000 06D7                                 }
; 0000 06D8                                 else if(row==6){
_0x25D:
	LDD  R26,Y+1
	CPI  R26,LOW(0x6)
	BRNE _0x25F
; 0000 06D9                                 lcd_putsf("6.SESTAD. LAIKAS");
	__POINTW1FN _0x0,940
	RJMP _0x54B
; 0000 06DA                                 }
; 0000 06DB                                 else if(row==7){
_0x25F:
	LDD  R26,Y+1
	CPI  R26,LOW(0x7)
	BRNE _0x261
; 0000 06DC                                 lcd_putsf("7.SEKMAD. LAIKAS");
	__POINTW1FN _0x0,957
_0x54B:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 06DD                                 }
; 0000 06DE 
; 0000 06DF                             lcd_row++;
_0x261:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 06E0                             }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x251
_0x252:
; 0000 06E1 
; 0000 06E2                         lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 06E3                         lcd_putchar('<');
; 0000 06E4                         }
; 0000 06E5                     }
_0x24F:
; 0000 06E6                     else if( (Address[2]>=1)&&(Address[2]<=7) ){
	RJMP _0x262
_0x247:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRLO _0x264
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x8)
	BRLO _0x265
_0x264:
	RJMP _0x263
_0x265:
; 0000 06E7                         if(Address[3]==0){
	__GETB1MN _Address_G000,3
	CPI  R30,0
	BREQ PC+3
	JMP _0x266
; 0000 06E8                             if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x267
; 0000 06E9                             SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 06EA                             }
; 0000 06EB                             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x268
_0x267:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x269
; 0000 06EC                             SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 06ED                             }
; 0000 06EE                             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x26A
_0x269:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x26B
; 0000 06EF                                 if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x26C
; 0000 06F0                                 Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
; 0000 06F1                                 }
; 0000 06F2                                 else if(SelectedRow>=1){
	RJMP _0x26D
_0x26C:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRLO _0x26E
; 0000 06F3                                 unsigned char id;
; 0000 06F4                                 id = GetBellId(Address[2]-1, SelectedRow-1);
	SBIW R28,1
;	id -> Y+0
	CALL SUBOPT_0x84
	ST   -Y,R30
	LDS  R30,_SelectedRow_G000
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x85
; 0000 06F5                                     if(id==255){
	LD   R26,Y
	CPI  R26,LOW(0xFF)
	BRNE _0x26F
; 0000 06F6                                     id = GetFreeBellId(Address[2]-1);
	CALL SUBOPT_0x84
	ST   -Y,R30
	CALL _GetFreeBellId
	ST   Y,R30
; 0000 06F7                                     Address[3] = id+1;
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,3
; 0000 06F8                                     }
; 0000 06F9                                 Address[3] = id+1;
_0x26F:
	LD   R30,Y
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,3
; 0000 06FA                                 }
	ADIW R28,1
; 0000 06FB                             SelectedRow = 0;
_0x26E:
_0x26D:
	CALL SUBOPT_0x74
; 0000 06FC                             Address[5] = 0;
; 0000 06FD                             }
; 0000 06FE 
; 0000 06FF                             if(RefreshLcd>=1){
_0x26B:
_0x26A:
_0x268:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x270
; 0000 0700                             unsigned char row, lcd_row;
; 0000 0701                             lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0702                             RowsOnWindow = BELL_COUNT + 1;
	LDI  R30,LOW(21)
	CALL SUBOPT_0x83
; 0000 0703                                 for(row=Address[5];row<4+Address[5];row++){
_0x272:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRLT PC+3
	JMP _0x273
; 0000 0704                                 lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 0705 
; 0000 0706                                     if(row==0){
	BRNE _0x274
; 0000 0707                                         if(Address[2]==1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x275
; 0000 0708                                         lcd_putsf("  -=PIRMADIENIS=-");
	__POINTW1FN _0x0,974
	RJMP _0x54C
; 0000 0709                                         }
; 0000 070A                                         else if(Address[2]==2){
_0x275:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x277
; 0000 070B                                         lcd_putsf("  -=ANTRADIENIS=-");
	__POINTW1FN _0x0,992
	RJMP _0x54C
; 0000 070C                                         }
; 0000 070D                                         else if(Address[2]==3){
_0x277:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x279
; 0000 070E                                         lcd_putsf("  -=TRECIADIENIS=-");
	__POINTW1FN _0x0,1010
	RJMP _0x54C
; 0000 070F                                         }
; 0000 0710                                         else if(Address[2]==4){
_0x279:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x27B
; 0000 0711                                         lcd_putsf(" -=KETVIRTADIENIS=-");
	__POINTW1FN _0x0,1029
	RJMP _0x54C
; 0000 0712                                         }
; 0000 0713                                         else if(Address[2]==5){
_0x27B:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x5)
	BRNE _0x27D
; 0000 0714                                         lcd_putsf("  -=PENKTADIENIS=-");
	__POINTW1FN _0x0,1049
	RJMP _0x54C
; 0000 0715                                         }
; 0000 0716                                         else if(Address[2]==6){
_0x27D:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x6)
	BRNE _0x27F
; 0000 0717                                         lcd_putsf("  -=SESTADIENIS=-");
	__POINTW1FN _0x0,1068
	RJMP _0x54C
; 0000 0718                                         }
; 0000 0719                                         else if(Address[2]==7){
_0x27F:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x7)
	BRNE _0x281
; 0000 071A                                         lcd_putsf("  -=SEKMADIENIS=-");
	__POINTW1FN _0x0,1086
_0x54C:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 071B                                         }
; 0000 071C                                     }
_0x281:
; 0000 071D                                     else if(row>=1){
	RJMP _0x282
_0x274:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x283
; 0000 071E                                         if(row<=BELL_COUNT){
	CPI  R26,LOW(0x15)
	BRSH _0x284
; 0000 071F                                         unsigned char id;
; 0000 0720                                         id = GetBellId(Address[2]-1, row-1);
	SBIW R28,1
;	row -> Y+2
;	lcd_row -> Y+1
;	id -> Y+0
	CALL SUBOPT_0x84
	CALL SUBOPT_0x86
	CALL SUBOPT_0x85
; 0000 0721                                         lcd_put_number(0,2,0,0,row,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xA
	CALL SUBOPT_0x87
; 0000 0722                                         lcd_putsf(". ");
	CALL SUBOPT_0x88
; 0000 0723 
; 0000 0724                                             if(id!=255){
	LD   R26,Y
	CPI  R26,LOW(0xFF)
	BREQ _0x285
; 0000 0725                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][id][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x84
	CALL SUBOPT_0x89
	CALL SUBOPT_0x19
	CALL SUBOPT_0x8A
; 0000 0726                                             lcd_putchar(':');
	CALL SUBOPT_0x8B
; 0000 0727                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][id][1],0);
	CALL SUBOPT_0x84
	CALL SUBOPT_0x89
	CALL SUBOPT_0x40
	CALL SUBOPT_0x8A
; 0000 0728                                             lcd_putsf(" (");
	CALL SUBOPT_0x8C
; 0000 0729                                             lcd_put_number(0,3,0,0,BELL_TIME[Address[2]-1][id][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x84
	CALL SUBOPT_0x89
	CALL SUBOPT_0x41
	CALL SUBOPT_0x87
; 0000 072A                                             lcd_putsf("SEC)");
	__POINTW1FN _0x0,1107
	RJMP _0x54D
; 0000 072B                                             }
; 0000 072C                                             else{
_0x285:
; 0000 072D                                             lcd_putsf("TUSCIA");
	__POINTW1FN _0x0,1112
_0x54D:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 072E                                             }
; 0000 072F                                         }
	ADIW R28,1
; 0000 0730                                     }
_0x284:
; 0000 0731 
; 0000 0732                                 lcd_row++;
_0x283:
_0x282:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0733                                 }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x272
_0x273:
; 0000 0734 
; 0000 0735                             lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0736                             lcd_putchar('<');
; 0000 0737                             }
; 0000 0738                         }
_0x270:
; 0000 0739                         else{
	RJMP _0x287
_0x266:
; 0000 073A                             if(Address[3]<=BELL_COUNT){
	__GETB2MN _Address_G000,3
	CPI  R26,LOW(0x15)
	BRLO PC+3
	JMP _0x288
; 0000 073B                                 if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x289
; 0000 073C                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x28A
; 0000 073D                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x28B
; 0000 073E                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x54E
; 0000 073F                                         }
; 0000 0740                                         else if(SelectedRow==1){
_0x28B:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x28D
; 0000 0741                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x54E
; 0000 0742                                         }
; 0000 0743                                         else if(SelectedRow==2){
_0x28D:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x28F
; 0000 0744                                         SelectedRow = 3;
	LDI  R30,LOW(3)
_0x54E:
	STS  _SelectedRow_G000,R30
; 0000 0745                                         }
; 0000 0746                                     }
_0x28F:
; 0000 0747                                     else if(Address[4]==1){
	RJMP _0x290
_0x28A:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x291
; 0000 0748                                         if(BELL_TIME[Address[2]-1][Address[3]-1][0]-10 >= 0){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x292
; 0000 0749                                         BELL_TIME[Address[2]-1][Address[3]-1][0] += -10;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 074A                                         }
; 0000 074B                                     }
_0x292:
; 0000 074C                                     else if(Address[4]==2){
	RJMP _0x293
_0x291:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x294
; 0000 074D                                         if(BELL_TIME[Address[2]-1][Address[3]-1][0]-1 >= 0){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x295
; 0000 074E                                         BELL_TIME[Address[2]-1][Address[3]-1][0] += -1;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 074F                                         }
; 0000 0750                                     }
_0x295:
; 0000 0751                                     else if(Address[4]==3){
	RJMP _0x296
_0x294:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x297
; 0000 0752                                         if(BELL_TIME[Address[2]-1][Address[3]-1][1]-10 >= 0){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x298
; 0000 0753                                         BELL_TIME[Address[2]-1][Address[3]-1][1] += -10;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 0754                                         }
; 0000 0755                                     }
_0x298:
; 0000 0756                                     else if(Address[4]==4){
	RJMP _0x299
_0x297:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x29A
; 0000 0757                                         if(BELL_TIME[Address[2]-1][Address[3]-1][1]-1 >= 0){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x29B
; 0000 0758                                         BELL_TIME[Address[2]-1][Address[3]-1][1] += -1;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 0759                                         }
; 0000 075A                                     }
_0x29B:
; 0000 075B                                     else if(Address[4]==5){
	RJMP _0x29C
_0x29A:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x29D
; 0000 075C                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]-100 > 0){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x91
	BRGE _0x29E
; 0000 075D                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += -100;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(156)
	CALL __EEPROMWRB
; 0000 075E                                         }
; 0000 075F                                     }
_0x29E:
; 0000 0760                                     else if(Address[4]==6){
	RJMP _0x29F
_0x29D:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x2A0
; 0000 0761                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]-10 > 0){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x93
	BRGE _0x2A1
; 0000 0762                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += -10;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 0763                                         }
; 0000 0764                                     }
_0x2A1:
; 0000 0765                                     else if(Address[4]==7){
	RJMP _0x2A2
_0x2A0:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x2A3
; 0000 0766                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]-1 > 0){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	CALL SUBOPT_0x1E
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x2A4
; 0000 0767                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += -1;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 0768                                         }
; 0000 0769                                     }
_0x2A4:
; 0000 076A                                 }
_0x2A3:
_0x2A2:
_0x29F:
_0x29C:
_0x299:
_0x296:
_0x293:
_0x290:
; 0000 076B                                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x2A5
_0x289:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x2A6
; 0000 076C                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x2A7
; 0000 076D                                         if(SelectedRow==1){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x2A8
; 0000 076E                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x54F
; 0000 076F                                         }
; 0000 0770                                         else if(SelectedRow==2){
_0x2A8:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x2AA
; 0000 0771                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x54F
; 0000 0772                                         }
; 0000 0773                                         else if(SelectedRow==3){
_0x2AA:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x2AC
; 0000 0774                                         SelectedRow = 2;
	LDI  R30,LOW(2)
_0x54F:
	STS  _SelectedRow_G000,R30
; 0000 0775                                         }
; 0000 0776                                     }
_0x2AC:
; 0000 0777                                     else if(Address[4]==1){
	RJMP _0x2AD
_0x2A7:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x2AE
; 0000 0778                                         if(BELL_TIME[Address[2]-1][Address[3]-1][0]+10 < 24){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x94
	SBIW R30,24
	BRGE _0x2AF
; 0000 0779                                         BELL_TIME[Address[2]-1][Address[3]-1][0] += 10;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 077A                                         }
; 0000 077B                                     }
_0x2AF:
; 0000 077C                                     else if(Address[4]==2){
	RJMP _0x2B0
_0x2AE:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x2B1
; 0000 077D                                         if(BELL_TIME[Address[2]-1][Address[3]-1][0]+1 < 24){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x95
	SBIW R30,24
	BRGE _0x2B2
; 0000 077E                                         BELL_TIME[Address[2]-1][Address[3]-1][0] += 1;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 077F                                         }
; 0000 0780                                     }
_0x2B2:
; 0000 0781                                     else if(Address[4]==3){
	RJMP _0x2B3
_0x2B1:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x2B4
; 0000 0782                                         if(BELL_TIME[Address[2]-1][Address[3]-1][1]+10 < 60){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x94
	SBIW R30,60
	BRGE _0x2B5
; 0000 0783                                         BELL_TIME[Address[2]-1][Address[3]-1][1] += 10;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 0784                                         }
; 0000 0785                                     }
_0x2B5:
; 0000 0786                                     else if(Address[4]==4){
	RJMP _0x2B6
_0x2B4:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x2B7
; 0000 0787                                         if(BELL_TIME[Address[2]-1][Address[3]-1][1]+1 < 60){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x95
	SBIW R30,60
	BRGE _0x2B8
; 0000 0788                                         BELL_TIME[Address[2]-1][Address[3]-1][1] += 1;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0789                                         }
; 0000 078A                                     }
_0x2B8:
; 0000 078B                                     else if(Address[4]==5){
	RJMP _0x2B9
_0x2B7:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x2BA
; 0000 078C                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]+100 <= 255){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x96
	BRGE _0x2BB
; 0000 078D                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += 100;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(100)
	CALL __EEPROMWRB
; 0000 078E                                         }
; 0000 078F                                     }
_0x2BB:
; 0000 0790                                     else if(Address[4]==6){
	RJMP _0x2BC
_0x2BA:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x2BD
; 0000 0791                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]+10 <= 255){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x97
	BRGE _0x2BE
; 0000 0792                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += 10;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 0793                                         }
; 0000 0794                                     }
_0x2BE:
; 0000 0795                                     else if(Address[4]==7){
	RJMP _0x2BF
_0x2BD:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x2C0
; 0000 0796                                         if(BELL_TIME[Address[2]-1][Address[3]-1][2]+1 <= 255){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x98
	BRGE _0x2C1
; 0000 0797                                         BELL_TIME[Address[2]-1][Address[3]-1][2] += 1;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0798                                         }
; 0000 0799                                     }
_0x2C1:
; 0000 079A                                 }
_0x2C0:
_0x2BF:
_0x2BC:
_0x2B9:
_0x2B6:
_0x2B3:
_0x2B0:
_0x2AD:
; 0000 079B                                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x2C2
_0x2A6:
	__GETB2MN _BUTTON_S000000F001,1
	CPI  R26,LOW(0x1)
	BRNE _0x2C3
; 0000 079C                                     if(Address[4]>1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRLO _0x2C4
; 0000 079D                                     Address[4]--;
	CALL SUBOPT_0x99
; 0000 079E                                     }
; 0000 079F                                 }
_0x2C4:
; 0000 07A0                                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x2C5
_0x2C3:
	__GETB2MN _BUTTON_S000000F001,3
	CPI  R26,LOW(0x1)
	BRNE _0x2C6
; 0000 07A1                                     if(Address[4]>0){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRLO _0x2C7
; 0000 07A2                                         if(Address[4]<7){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRSH _0x2C8
; 0000 07A3                                         Address[4]++;
	CALL SUBOPT_0x9A
; 0000 07A4                                         }
; 0000 07A5                                     }
_0x2C8:
; 0000 07A6                                 }
_0x2C7:
; 0000 07A7                                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x2C9
_0x2C6:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x2CA
; 0000 07A8                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x2CB
; 0000 07A9                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BREQ _0x550
; 0000 07AA                                         Address[3] = 0;
; 0000 07AB                                         }
; 0000 07AC                                         else if(SelectedRow==2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x2CE
; 0000 07AD                                         Address[4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,4
; 0000 07AE                                         }
; 0000 07AF                                         else if(SelectedRow==3){
	RJMP _0x2CF
_0x2CE:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x2D0
; 0000 07B0                                         BELL_TIME[Address[2]-1][Address[3]-1][0] = 0;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x9B
; 0000 07B1                                         BELL_TIME[Address[2]-1][Address[3]-1][1] = 0;
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x9C
; 0000 07B2                                         BELL_TIME[Address[2]-1][Address[3]-1][2] = 0;
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x1D
; 0000 07B3                                         Address[3] = 0;
_0x550:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 07B4                                         }
; 0000 07B5                                     }
_0x2D0:
_0x2CF:
; 0000 07B6                                     else{
	RJMP _0x2D1
_0x2CB:
; 0000 07B7                                     Address[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,4
; 0000 07B8                                     }
_0x2D1:
; 0000 07B9                                 SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 07BA                                 Address[5] = 0;
; 0000 07BB                                 }
; 0000 07BC 
; 0000 07BD                                 if(RefreshLcd>=1){
_0x2CA:
_0x2C9:
_0x2C5:
_0x2C2:
_0x2A5:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x2D2
; 0000 07BE                                 lcd_putsf(" -=LAIKO KEITIMAS=- ");
	CALL SUBOPT_0x9D
; 0000 07BF                                     if(BELL_TIME[Address[2]-1][Address[3]-1][0]>=24){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CPI  R30,LOW(0x18)
	BRSH _0x551
; 0000 07C0                                     BELL_TIME[Address[2]-1][Address[3]-1][0] = 0;
; 0000 07C1                                     BELL_TIME[Address[2]-1][Address[3]-1][1] = 0;
; 0000 07C2                                     BELL_TIME[Address[2]-1][Address[3]-1][2] = 0;
; 0000 07C3                                     }
; 0000 07C4                                     else if(BELL_TIME[Address[2]-1][Address[3]-1][1]>=60){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CPI  R30,LOW(0x3C)
	BRLO _0x2D5
; 0000 07C5                                     BELL_TIME[Address[2]-1][Address[3]-1][0] = 0;
_0x551:
	__GETB1MN _Address_G000,2
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x9B
; 0000 07C6                                     BELL_TIME[Address[2]-1][Address[3]-1][1] = 0;
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x9C
; 0000 07C7                                     BELL_TIME[Address[2]-1][Address[3]-1][2] = 0;
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x1D
; 0000 07C8                                     }
; 0000 07C9 
; 0000 07CA                                 lcd_putsf("LAIKAS: ");
_0x2D5:
	CALL SUBOPT_0x7D
; 0000 07CB                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][Address[3]-1][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8A
; 0000 07CC                                 lcd_putchar('.');
	CALL SUBOPT_0x29
; 0000 07CD                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]-1][Address[3]-1][1],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x8A
; 0000 07CE                                 lcd_putsf(" (");
	CALL SUBOPT_0x8C
; 0000 07CF                                 lcd_put_number(0,3,0,0,BELL_TIME[Address[2]-1][Address[3]-1][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x87
; 0000 07D0                                 lcd_putchar(')');lcd_putsf(" ");
	CALL SUBOPT_0x9E
; 0000 07D1 
; 0000 07D2 
; 0000 07D3                                     if(Address[4]==1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x2D6
; 0000 07D4                                     lcd_putsf("        ^");
	CALL SUBOPT_0x9F
; 0000 07D5                                     }
; 0000 07D6                                     else if(Address[4]==2){
	RJMP _0x2D7
_0x2D6:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x2D8
; 0000 07D7                                     lcd_putsf("         ^");
	CALL SUBOPT_0xA0
; 0000 07D8                                     }
; 0000 07D9                                     else if(Address[4]==3){
	RJMP _0x2D9
_0x2D8:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x2DA
; 0000 07DA                                     lcd_putsf("           ^");
	CALL SUBOPT_0xA1
; 0000 07DB                                     }
; 0000 07DC                                     else if(Address[4]==4){
	RJMP _0x2DB
_0x2DA:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x2DC
; 0000 07DD                                     lcd_putsf("            ^");
	CALL SUBOPT_0xA2
; 0000 07DE                                     }
; 0000 07DF                                     else if(Address[4]==5){
	RJMP _0x2DD
_0x2DC:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x2DE
; 0000 07E0                                     lcd_putsf("               ^");
	CALL SUBOPT_0xA3
; 0000 07E1                                     }
; 0000 07E2                                     else if(Address[4]==6){
	RJMP _0x2DF
_0x2DE:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x2E0
; 0000 07E3                                     lcd_putsf("                ^");
	CALL SUBOPT_0xA4
; 0000 07E4                                     }
; 0000 07E5                                     else if(Address[4]==7){
	RJMP _0x2E1
_0x2E0:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x2E2
; 0000 07E6                                     lcd_putsf("                 ^");
	CALL SUBOPT_0xA5
; 0000 07E7                                     }
; 0000 07E8                                     else if(Address[4]==0){
	RJMP _0x2E3
_0x2E2:
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x2E4
; 0000 07E9                                     lcd_putsf("      REDAGUOTI?    ");
	CALL SUBOPT_0x81
; 0000 07EA                                     lcd_putsf("       TRINTI?      ");
	CALL SUBOPT_0xA6
; 0000 07EB                                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0xA7
; 0000 07EC                                     lcd_putchar('<');
; 0000 07ED                                     }
; 0000 07EE                                 }
_0x2E4:
_0x2E3:
_0x2E1:
_0x2DF:
_0x2DD:
_0x2DB:
_0x2D9:
_0x2D7:
; 0000 07EF                             }
_0x2D2:
; 0000 07F0                             else{
	RJMP _0x2E5
_0x288:
; 0000 07F1                             Address[3] = 0;
	CALL SUBOPT_0xA8
; 0000 07F2                             SelectedRow = 0;
; 0000 07F3                             Address[5] = 0;
; 0000 07F4                             }
_0x2E5:
; 0000 07F5                         }
_0x287:
; 0000 07F6                     }
; 0000 07F7                     else{
	RJMP _0x2E6
_0x263:
; 0000 07F8                     Address[2] = 0;
	CALL SUBOPT_0xA9
; 0000 07F9                     SelectedRow = 0;
; 0000 07FA                     Address[5] = 0;
; 0000 07FB                     }
_0x2E6:
_0x262:
; 0000 07FC                 }
; 0000 07FD             /////////////////////
; 0000 07FE 
; 0000 07FF             // VELYKU LAIKO MENIU
; 0000 0800                 else if(Address[1]==2){
	JMP  _0x2E7
_0x246:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x2E8
; 0000 0801                     if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BREQ PC+3
	JMP _0x2E9
; 0000 0802                         if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x2EA
; 0000 0803                         SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0804                         }
; 0000 0805                         else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x2EB
_0x2EA:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x2EC
; 0000 0806                         SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0807                         }
; 0000 0808                         else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x2ED
_0x2EC:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x2EE
; 0000 0809                             if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x2EF
; 0000 080A                             Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 080B                             }
; 0000 080C                             else{
	RJMP _0x2F0
_0x2EF:
; 0000 080D                             Address[2] = SelectedRow;
	CALL SUBOPT_0x82
; 0000 080E                             }
_0x2F0:
; 0000 080F                         SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0810                         Address[5] = 0;
; 0000 0811                         }
; 0000 0812 
; 0000 0813                         if(RefreshLcd>=1){
_0x2EE:
_0x2ED:
_0x2EB:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x2F1
; 0000 0814                         unsigned char row, lcd_row;
; 0000 0815                         lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0816                         RowsOnWindow = 6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x83
; 0000 0817                             for(row=Address[5];row<4+Address[5];row++){
_0x2F3:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRGE _0x2F4
; 0000 0818                             lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 0819 
; 0000 081A                                 if(row==0){
	BRNE _0x2F5
; 0000 081B                                 lcd_putsf(" -=VELYKU LAIKAS=-");
	__POINTW1FN _0x0,1215
	RJMP _0x552
; 0000 081C                                 }
; 0000 081D                                 else if(row==1){
_0x2F5:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x2F7
; 0000 081E                                 lcd_putsf("1.VELYKU KETVIRTAD.");
	__POINTW1FN _0x0,1234
	RJMP _0x552
; 0000 081F                                 }
; 0000 0820                                 else if(row==2){
_0x2F7:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x2F9
; 0000 0821                                 lcd_putsf("2.VELYKU PENKTAD.");
	__POINTW1FN _0x0,1254
	RJMP _0x552
; 0000 0822                                 }
; 0000 0823                                 else if(row==3){
_0x2F9:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x2FB
; 0000 0824                                 lcd_putsf("3.VELYKU SESTADIEN.");
	__POINTW1FN _0x0,1272
	RJMP _0x552
; 0000 0825                                 }
; 0000 0826                                 else if(row==4){
_0x2FB:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x2FD
; 0000 0827                                 lcd_putsf("4.VELYKU SEKMAD.");
	__POINTW1FN _0x0,1292
	RJMP _0x552
; 0000 0828                                 }
; 0000 0829                                 else if(row==5){
_0x2FD:
	LDD  R26,Y+1
	CPI  R26,LOW(0x5)
	BRNE _0x2FF
; 0000 082A                                 lcd_putsf("5.KADA BUS VELYKOS?");
	__POINTW1FN _0x0,1309
_0x552:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 082B                                 }
; 0000 082C 
; 0000 082D                             lcd_row++;
_0x2FF:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 082E                             }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x2F3
_0x2F4:
; 0000 082F 
; 0000 0830                         lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0831                         lcd_putchar('<');
; 0000 0832                         }
; 0000 0833 
; 0000 0834 
; 0000 0835                     }
_0x2F1:
; 0000 0836                     else if( (Address[2]>=1)&&(Address[2]<=4) ){
	RJMP _0x300
_0x2E9:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRLO _0x302
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x5)
	BRLO _0x303
_0x302:
	RJMP _0x301
_0x303:
; 0000 0837 
; 0000 0838                         if(Address[3]==0){
	__GETB1MN _Address_G000,3
	CPI  R30,0
	BREQ PC+3
	JMP _0x304
; 0000 0839                             if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x305
; 0000 083A                             SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 083B                             }
; 0000 083C                             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x306
_0x305:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x307
; 0000 083D                             SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 083E                             }
; 0000 083F                             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x308
_0x307:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x309
; 0000 0840                                 if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x30A
; 0000 0841                                 Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
; 0000 0842                                 }
; 0000 0843                                 else{
	RJMP _0x30B
_0x30A:
; 0000 0844                                 Address[3] = SelectedRow;
	CALL SUBOPT_0xAA
; 0000 0845                                 }
_0x30B:
; 0000 0846                             SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0847                             Address[5] = 0;
; 0000 0848                             }
; 0000 0849 
; 0000 084A                             if(RefreshLcd>=1){
_0x309:
_0x308:
_0x306:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x30C
; 0000 084B                             unsigned char row, lcd_row;
; 0000 084C                             lcd_row = 0;
	CALL SUBOPT_0xAB
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 084D                             RowsOnWindow = 20;
; 0000 084E                                 for(row=Address[5];row<4+Address[5];row++){
_0x30E:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRLT PC+3
	JMP _0x30F
; 0000 084F                                 lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 0850 
; 0000 0851                                     if(row==0){
	BRNE _0x310
; 0000 0852                                         if(Address[2]==1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x311
; 0000 0853                                         lcd_putsf("-=VEL. KETVIRTAD.=-");
	__POINTW1FN _0x0,1329
	RJMP _0x553
; 0000 0854                                         }
; 0000 0855                                         else if(Address[2]==2){
_0x311:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x313
; 0000 0856                                         lcd_putsf(" -=VEL. PENKTAD.=-");
	__POINTW1FN _0x0,1349
	RJMP _0x553
; 0000 0857                                         }
; 0000 0858                                         else if(Address[2]==3){
_0x313:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x315
; 0000 0859                                         lcd_putsf("  -=VEL. SESTAD.=-");
	__POINTW1FN _0x0,1368
	RJMP _0x553
; 0000 085A                                         }
; 0000 085B                                         else if(Address[2]==4){
_0x315:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x317
; 0000 085C                                         lcd_putsf("  -=VEL. SEKMAD.=-");
	__POINTW1FN _0x0,1387
_0x553:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 085D                                         }
; 0000 085E                                     }
_0x317:
; 0000 085F                                     else if(row>=1){
	RJMP _0x318
_0x310:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRLO _0x319
; 0000 0860                                         if(row<=BELL_COUNT){
	CPI  R26,LOW(0x15)
	BRSH _0x31A
; 0000 0861                                         unsigned char id;
; 0000 0862                                         id = GetBellId(Address[2]+6, row-1);
	SBIW R28,1
;	row -> Y+2
;	lcd_row -> Y+1
;	id -> Y+0
	__GETB1MN _Address_G000,2
	SUBI R30,-LOW(6)
	CALL SUBOPT_0x86
	CALL SUBOPT_0x85
; 0000 0863                                         lcd_put_number(0,2,0,0,row,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xA
	CALL SUBOPT_0x87
; 0000 0864                                         lcd_putsf(". ");
	CALL SUBOPT_0x88
; 0000 0865 
; 0000 0866                                             if(id!=255){
	LD   R26,Y
	CPI  R26,LOW(0xFF)
	BREQ _0x31B
; 0000 0867                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][id][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xAC
	CALL SUBOPT_0x19
	CALL SUBOPT_0x8A
; 0000 0868                                             lcd_putchar(':');
	CALL SUBOPT_0x8B
; 0000 0869                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][id][1],0);
	CALL SUBOPT_0xAC
	CALL SUBOPT_0x40
	CALL SUBOPT_0x8A
; 0000 086A                                             lcd_putsf(" (");
	CALL SUBOPT_0x8C
; 0000 086B                                             lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+6][id][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xAC
	CALL SUBOPT_0x41
	CALL SUBOPT_0x87
; 0000 086C                                             lcd_putsf("SEC)");
	__POINTW1FN _0x0,1107
	RJMP _0x554
; 0000 086D                                             }
; 0000 086E                                             else{
_0x31B:
; 0000 086F                                             lcd_putsf("TUSCIA");
	__POINTW1FN _0x0,1112
_0x554:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0870                                             }
; 0000 0871                                         }
	ADIW R28,1
; 0000 0872                                     }
_0x31A:
; 0000 0873 
; 0000 0874                                 lcd_row++;
_0x319:
_0x318:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0875                                 }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x30E
_0x30F:
; 0000 0876 
; 0000 0877                             lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0878                             lcd_putchar('<');
; 0000 0879                             }
; 0000 087A                         }
_0x30C:
; 0000 087B                         else{
	RJMP _0x31D
_0x304:
; 0000 087C                             if(Address[3]<=BELL_COUNT){
	__GETB2MN _Address_G000,3
	CPI  R26,LOW(0x15)
	BRLO PC+3
	JMP _0x31E
; 0000 087D                                 if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x31F
; 0000 087E                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x320
; 0000 087F                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x321
; 0000 0880                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x555
; 0000 0881                                         }
; 0000 0882                                         else if(SelectedRow==1){
_0x321:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x323
; 0000 0883                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x555
; 0000 0884                                         }
; 0000 0885                                         else if(SelectedRow==2){
_0x323:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x325
; 0000 0886                                         SelectedRow = 3;
	LDI  R30,LOW(3)
_0x555:
	STS  _SelectedRow_G000,R30
; 0000 0887                                         }
; 0000 0888                                     }
_0x325:
; 0000 0889                                     else if(Address[4]==1){
	RJMP _0x326
_0x320:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x327
; 0000 088A                                         if(BELL_TIME[Address[2]+6][Address[3]-1][0]-10 >= 0){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x328
; 0000 088B                                         BELL_TIME[Address[2]+6][Address[3]-1][0] += -10;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 088C                                         }
; 0000 088D                                     }
_0x328:
; 0000 088E                                     else if(Address[4]==2){
	RJMP _0x329
_0x327:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x32A
; 0000 088F                                         if(BELL_TIME[Address[2]+6][Address[3]-1][0]-1 >= 0){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x32B
; 0000 0890                                         BELL_TIME[Address[2]+6][Address[3]-1][0] += -1;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 0891                                         }
; 0000 0892                                     }
_0x32B:
; 0000 0893                                     else if(Address[4]==3){
	RJMP _0x32C
_0x32A:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x32D
; 0000 0894                                         if(BELL_TIME[Address[2]+6][Address[3]-1][1]-10 >= 0){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x32E
; 0000 0895                                         BELL_TIME[Address[2]+6][Address[3]-1][1] += -10;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 0896                                         }
; 0000 0897                                     }
_0x32E:
; 0000 0898                                     else if(Address[4]==4){
	RJMP _0x32F
_0x32D:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x330
; 0000 0899                                         if(BELL_TIME[Address[2]+6][Address[3]-1][1]-1 >= 0){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x331
; 0000 089A                                         BELL_TIME[Address[2]+6][Address[3]-1][1] += -1;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 089B                                         }
; 0000 089C                                     }
_0x331:
; 0000 089D                                     else if(Address[4]==5){
	RJMP _0x332
_0x330:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x333
; 0000 089E                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]-100 > 0){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x91
	BRGE _0x334
; 0000 089F                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += -100;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(156)
	CALL __EEPROMWRB
; 0000 08A0                                         }
; 0000 08A1                                     }
_0x334:
; 0000 08A2                                     else if(Address[4]==6){
	RJMP _0x335
_0x333:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x336
; 0000 08A3                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]-10 > 0){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x93
	BRGE _0x337
; 0000 08A4                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += -10;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 08A5                                         }
; 0000 08A6                                     }
_0x337:
; 0000 08A7                                     else if(Address[4]==7){
	RJMP _0x338
_0x336:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x339
; 0000 08A8                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]-1 > 0){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	CALL SUBOPT_0x1E
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x33A
; 0000 08A9                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += -1;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 08AA                                         }
; 0000 08AB                                     }
_0x33A:
; 0000 08AC                                 }
_0x339:
_0x338:
_0x335:
_0x332:
_0x32F:
_0x32C:
_0x329:
_0x326:
; 0000 08AD                                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x33B
_0x31F:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x33C
; 0000 08AE                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x33D
; 0000 08AF                                         if(SelectedRow==1){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x33E
; 0000 08B0                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x556
; 0000 08B1                                         }
; 0000 08B2                                         else if(SelectedRow==2){
_0x33E:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x340
; 0000 08B3                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x556
; 0000 08B4                                         }
; 0000 08B5                                         else if(SelectedRow==3){
_0x340:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x342
; 0000 08B6                                         SelectedRow = 2;
	LDI  R30,LOW(2)
_0x556:
	STS  _SelectedRow_G000,R30
; 0000 08B7                                         }
; 0000 08B8                                     }
_0x342:
; 0000 08B9                                     else if(Address[4]==1){
	RJMP _0x343
_0x33D:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x344
; 0000 08BA                                         if(BELL_TIME[Address[2]+6][Address[3]-1][0]+10 < 24){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x94
	SBIW R30,24
	BRGE _0x345
; 0000 08BB                                         BELL_TIME[Address[2]+6][Address[3]-1][0] += 10;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 08BC                                         }
; 0000 08BD                                     }
_0x345:
; 0000 08BE                                     else if(Address[4]==2){
	RJMP _0x346
_0x344:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x347
; 0000 08BF                                         if(BELL_TIME[Address[2]+6][Address[3]-1][0]+1 < 24){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x95
	SBIW R30,24
	BRGE _0x348
; 0000 08C0                                         BELL_TIME[Address[2]+6][Address[3]-1][0] += 1;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 08C1                                         }
; 0000 08C2                                     }
_0x348:
; 0000 08C3                                     else if(Address[4]==3){
	RJMP _0x349
_0x347:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x34A
; 0000 08C4                                         if(BELL_TIME[Address[2]+6][Address[3]-1][1]+10 < 60){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x94
	SBIW R30,60
	BRGE _0x34B
; 0000 08C5                                         BELL_TIME[Address[2]+6][Address[3]-1][1] += 10;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 08C6                                         }
; 0000 08C7                                     }
_0x34B:
; 0000 08C8                                     else if(Address[4]==4){
	RJMP _0x34C
_0x34A:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x34D
; 0000 08C9                                         if(BELL_TIME[Address[2]+6][Address[3]-1][1]+1 < 60){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x95
	SBIW R30,60
	BRGE _0x34E
; 0000 08CA                                         BELL_TIME[Address[2]+6][Address[3]-1][1] += 1;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 08CB                                         }
; 0000 08CC                                     }
_0x34E:
; 0000 08CD                                     else if(Address[4]==5){
	RJMP _0x34F
_0x34D:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x350
; 0000 08CE                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]+100 <= 255){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x96
	BRGE _0x351
; 0000 08CF                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += 100;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(100)
	CALL __EEPROMWRB
; 0000 08D0                                         }
; 0000 08D1                                     }
_0x351:
; 0000 08D2                                     else if(Address[4]==6){
	RJMP _0x352
_0x350:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x353
; 0000 08D3                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]+10 <= 255){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x97
	BRGE _0x354
; 0000 08D4                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += 10;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 08D5                                         }
; 0000 08D6                                     }
_0x354:
; 0000 08D7                                     else if(Address[4]==7){
	RJMP _0x355
_0x353:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x356
; 0000 08D8                                         if(BELL_TIME[Address[2]+6][Address[3]-1][2]+1 <= 255){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x98
	BRGE _0x357
; 0000 08D9                                         BELL_TIME[Address[2]+6][Address[3]-1][2] += 1;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 08DA                                         }
; 0000 08DB                                     }
_0x357:
; 0000 08DC                                 }
_0x356:
_0x355:
_0x352:
_0x34F:
_0x34C:
_0x349:
_0x346:
_0x343:
; 0000 08DD                                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x358
_0x33C:
	__GETB2MN _BUTTON_S000000F001,1
	CPI  R26,LOW(0x1)
	BRNE _0x359
; 0000 08DE                                     if(Address[4]>1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRLO _0x35A
; 0000 08DF                                     Address[4]--;
	CALL SUBOPT_0x99
; 0000 08E0                                     }
; 0000 08E1                                 }
_0x35A:
; 0000 08E2                                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x35B
_0x359:
	__GETB2MN _BUTTON_S000000F001,3
	CPI  R26,LOW(0x1)
	BRNE _0x35C
; 0000 08E3                                     if(Address[4]>0){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRLO _0x35D
; 0000 08E4                                         if(Address[4]<7){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRSH _0x35E
; 0000 08E5                                         Address[4]++;
	CALL SUBOPT_0x9A
; 0000 08E6                                         }
; 0000 08E7                                     }
_0x35E:
; 0000 08E8                                 }
_0x35D:
; 0000 08E9                                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x35F
_0x35C:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x360
; 0000 08EA                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x361
; 0000 08EB                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BREQ _0x557
; 0000 08EC                                         Address[3] = 0;
; 0000 08ED                                         }
; 0000 08EE                                         else if(SelectedRow==2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x364
; 0000 08EF                                         Address[4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,4
; 0000 08F0                                         }
; 0000 08F1                                         else if(SelectedRow==3){
	RJMP _0x365
_0x364:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x366
; 0000 08F2                                         BELL_TIME[Address[2]+6][Address[3]-1][0] = 0;
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0xAE
; 0000 08F3                                         BELL_TIME[Address[2]+6][Address[3]-1][1] = 0;
	CALL SUBOPT_0x90
	CALL SUBOPT_0xAF
; 0000 08F4                                         BELL_TIME[Address[2]+6][Address[3]-1][2] = 0;
	CALL SUBOPT_0x90
	CALL SUBOPT_0x1D
; 0000 08F5                                         Address[3] = 0;
_0x557:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 08F6                                         }
; 0000 08F7                                     }
_0x366:
_0x365:
; 0000 08F8                                     else{
	RJMP _0x367
_0x361:
; 0000 08F9                                     Address[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,4
; 0000 08FA                                     }
_0x367:
; 0000 08FB                                 SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 08FC                                 Address[5] = 0;
; 0000 08FD                                 }
; 0000 08FE 
; 0000 08FF                                 if(RefreshLcd>=1){
_0x360:
_0x35F:
_0x35B:
_0x358:
_0x33B:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x368
; 0000 0900                                 lcd_putsf(" -=LAIKO KEITIMAS=- ");
	CALL SUBOPT_0x9D
; 0000 0901                                     if(BELL_TIME[Address[2]+6][Address[3]-1][0]>=24){
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8E
	CPI  R30,LOW(0x18)
	BRSH _0x558
; 0000 0902                                     BELL_TIME[Address[2]+6][Address[3]-1][0] = 0;
; 0000 0903                                     BELL_TIME[Address[2]+6][Address[3]-1][1] = 0;
; 0000 0904                                     BELL_TIME[Address[2]+6][Address[3]-1][2] = 0;
; 0000 0905                                     }
; 0000 0906                                     else if(BELL_TIME[Address[2]-1][Address[3]-1][1]>=60){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CPI  R30,LOW(0x3C)
	BRLO _0x36B
; 0000 0907                                     BELL_TIME[Address[2]+6][Address[3]-1][0] = 0;
_0x558:
	__GETB1MN _Address_G000,2
	LDI  R31,0
	ADIW R30,6
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0xAE
; 0000 0908                                     BELL_TIME[Address[2]+6][Address[3]-1][1] = 0;
	CALL SUBOPT_0x90
	CALL SUBOPT_0xAF
; 0000 0909                                     BELL_TIME[Address[2]+6][Address[3]-1][2] = 0;
	CALL SUBOPT_0x90
	CALL SUBOPT_0x1D
; 0000 090A                                     }
; 0000 090B 
; 0000 090C                                 lcd_putsf("LAIKAS: ");
_0x36B:
	CALL SUBOPT_0x7D
; 0000 090D                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][Address[3]-1][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8A
; 0000 090E                                 lcd_putchar('.');
	CALL SUBOPT_0x29
; 0000 090F                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+6][Address[3]-1][1],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x8A
; 0000 0910                                 lcd_putsf(" (");
	CALL SUBOPT_0x8C
; 0000 0911                                 lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+6][Address[3]-1][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xAD
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x87
; 0000 0912                                 lcd_putchar(')');lcd_putsf(" ");
	CALL SUBOPT_0x9E
; 0000 0913 
; 0000 0914 
; 0000 0915                                     if(Address[4]==1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x36C
; 0000 0916                                     lcd_putsf("        ^");
	CALL SUBOPT_0x9F
; 0000 0917                                     }
; 0000 0918                                     else if(Address[4]==2){
	RJMP _0x36D
_0x36C:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x36E
; 0000 0919                                     lcd_putsf("         ^");
	CALL SUBOPT_0xA0
; 0000 091A                                     }
; 0000 091B                                     else if(Address[4]==3){
	RJMP _0x36F
_0x36E:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x370
; 0000 091C                                     lcd_putsf("           ^");
	CALL SUBOPT_0xA1
; 0000 091D                                     }
; 0000 091E                                     else if(Address[4]==4){
	RJMP _0x371
_0x370:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x372
; 0000 091F                                     lcd_putsf("            ^");
	CALL SUBOPT_0xA2
; 0000 0920                                     }
; 0000 0921                                     else if(Address[4]==5){
	RJMP _0x373
_0x372:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x374
; 0000 0922                                     lcd_putsf("               ^");
	CALL SUBOPT_0xA3
; 0000 0923                                     }
; 0000 0924                                     else if(Address[4]==6){
	RJMP _0x375
_0x374:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x376
; 0000 0925                                     lcd_putsf("                ^");
	CALL SUBOPT_0xA4
; 0000 0926                                     }
; 0000 0927                                     else if(Address[4]==7){
	RJMP _0x377
_0x376:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x378
; 0000 0928                                     lcd_putsf("                 ^");
	CALL SUBOPT_0xA5
; 0000 0929                                     }
; 0000 092A                                     else if(Address[4]==0){
	RJMP _0x379
_0x378:
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x37A
; 0000 092B                                     lcd_putsf("      REDAGUOTI?    ");
	CALL SUBOPT_0x81
; 0000 092C                                     lcd_putsf("       TRINTI?      ");
	CALL SUBOPT_0xA6
; 0000 092D                                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0xA7
; 0000 092E                                     lcd_putchar('<');
; 0000 092F                                     }
; 0000 0930                                 }
_0x37A:
_0x379:
_0x377:
_0x375:
_0x373:
_0x371:
_0x36F:
_0x36D:
; 0000 0931                             }
_0x368:
; 0000 0932                             else{
	RJMP _0x37B
_0x31E:
; 0000 0933                             Address[3] = 0;
	CALL SUBOPT_0xA8
; 0000 0934                             SelectedRow = 0;
; 0000 0935                             Address[5] = 0;
; 0000 0936                             }
_0x37B:
; 0000 0937                         }
_0x31D:
; 0000 0938                     }
; 0000 0939                     else if(Address[2]==5){
	RJMP _0x37C
_0x301:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x5)
	BREQ PC+3
	JMP _0x37D
; 0000 093A                         if(BUTTON[BUTTON_ENTER]==1){
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x37E
; 0000 093B                         Address[2] = 0;
	CALL SUBOPT_0xA9
; 0000 093C                         SelectedRow = 0;
; 0000 093D                         Address[5] = 0;
; 0000 093E                         }
; 0000 093F 
; 0000 0940                         if(RefreshLcd>=1){
_0x37E:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x37F
; 0000 0941                         lcd_putsf("  -=VELYKU DATOS=-  ");
	__POINTW1FN _0x0,1406
	CALL SUBOPT_0x2E
; 0000 0942 
; 0000 0943                         lcd_putsf("1. 2");
	__POINTW1FN _0x0,1427
	CALL SUBOPT_0x2E
; 0000 0944                         lcd_put_number(0,3,0,0,RealTimeYear,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x56
; 0000 0945                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0946                         lcd_put_number(0,2,0,0,GetEasterMonth(RealTimeYear),0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xB1
; 0000 0947                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0948                         lcd_put_number(0,2,0,0,GetEasterDay(RealTimeYear),0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xB2
; 0000 0949                         lcd_putsf("       ");
	__POINTW1FN _0x0,565
	CALL SUBOPT_0x2E
; 0000 094A 
; 0000 094B                         lcd_putsf("2. 2");
	__POINTW1FN _0x0,1432
	CALL SUBOPT_0x2E
; 0000 094C                         lcd_put_number(0,3,0,0,RealTimeYear+1,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	MOV  R30,R5
	CALL SUBOPT_0x95
	CALL SUBOPT_0x87
; 0000 094D                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 094E                         lcd_put_number(0,2,0,0,GetEasterMonth(RealTimeYear+1),0);
	CALL SUBOPT_0x50
	MOV  R30,R5
	CALL SUBOPT_0x95
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB1
; 0000 094F                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0950                         lcd_put_number(0,2,0,0,GetEasterDay(RealTimeYear+1),0);
	CALL SUBOPT_0x50
	MOV  R30,R5
	CALL SUBOPT_0x95
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB2
; 0000 0951                         lcd_putsf("       ");
	__POINTW1FN _0x0,565
	CALL SUBOPT_0x2E
; 0000 0952 
; 0000 0953                         lcd_putsf("3. 2");
	__POINTW1FN _0x0,1437
	CALL SUBOPT_0x2E
; 0000 0954                         lcd_put_number(0,3,0,0,RealTimeYear+2,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xB3
	CALL SUBOPT_0x87
; 0000 0955                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0956                         lcd_put_number(0,2,0,0,GetEasterMonth(RealTimeYear+2),0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB3
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB1
; 0000 0957                         lcd_putsf(".");
	CALL SUBOPT_0x57
; 0000 0958                         lcd_put_number(0,2,0,0,GetEasterDay(RealTimeYear+2),0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB3
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB2
; 0000 0959                         }
; 0000 095A                     }
_0x37F:
; 0000 095B                     else{
	RJMP _0x380
_0x37D:
; 0000 095C                     Address[2] = 0;
	CALL SUBOPT_0xA9
; 0000 095D                     SelectedRow = 0;
; 0000 095E                     Address[5] = 0;
; 0000 095F                     }
_0x380:
_0x37C:
_0x300:
; 0000 0960                 }
; 0000 0961             /////////////////////
; 0000 0962 
; 0000 0963             // KALEDU LAIKO MENIU
; 0000 0964                 else if(Address[1]==3){
	RJMP _0x381
_0x2E8:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0x382
; 0000 0965                     if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BREQ PC+3
	JMP _0x383
; 0000 0966                         if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x384
; 0000 0967                         SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0968                         }
; 0000 0969                         else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x385
_0x384:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x386
; 0000 096A                         SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 096B                         }
; 0000 096C                         else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x387
_0x386:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x388
; 0000 096D                             if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x389
; 0000 096E                             Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 096F                             }
; 0000 0970                             else{
	RJMP _0x38A
_0x389:
; 0000 0971                             Address[2] = SelectedRow;
	CALL SUBOPT_0x82
; 0000 0972                             }
_0x38A:
; 0000 0973                         SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0974                         Address[5] = 0;
; 0000 0975                         }
; 0000 0976 
; 0000 0977                         if(RefreshLcd>=1){
_0x388:
_0x387:
_0x385:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x38B
; 0000 0978                         unsigned char row, lcd_row;
; 0000 0979                         lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 097A                         RowsOnWindow = 3;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x83
; 0000 097B                             for(row=Address[5];row<4+Address[5];row++){
_0x38D:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRGE _0x38E
; 0000 097C                             lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 097D 
; 0000 097E                                 if(row==0){
	BRNE _0x38F
; 0000 097F                                 lcd_putsf(" -=KALEDU LAIKAS=-");
	__POINTW1FN _0x0,1442
	RJMP _0x559
; 0000 0980                                 }
; 0000 0981                                 else if(row==1){
_0x38F:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x391
; 0000 0982                                 lcd_putsf("1.GRUODZIO 25 D.");
	__POINTW1FN _0x0,1461
	RJMP _0x559
; 0000 0983                                 }
; 0000 0984                                 else if(row==2){
_0x391:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x393
; 0000 0985                                 lcd_putsf("2.GRUODZIO 26 D.");
	__POINTW1FN _0x0,1478
_0x559:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0986                                 }
; 0000 0987 
; 0000 0988                             lcd_row++;
_0x393:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0989                             }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x38D
_0x38E:
; 0000 098A 
; 0000 098B                         lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 098C                         lcd_putchar('<');
; 0000 098D                         }
; 0000 098E                     }
_0x38B:
; 0000 098F                     else if( (Address[2]>=1)&&(Address[2]<=2) ){
	RJMP _0x394
_0x383:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRLO _0x396
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRLO _0x397
_0x396:
	RJMP _0x395
_0x397:
; 0000 0990                         if(Address[3]==0){
	__GETB1MN _Address_G000,3
	CPI  R30,0
	BREQ PC+3
	JMP _0x398
; 0000 0991                             if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x399
; 0000 0992                             SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0993                             }
; 0000 0994                             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x39A
_0x399:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x39B
; 0000 0995                             SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0996                             }
; 0000 0997                             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x39C
_0x39B:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x39D
; 0000 0998                                 if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x39E
; 0000 0999                                 Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
; 0000 099A                                 }
; 0000 099B                                 else{
	RJMP _0x39F
_0x39E:
; 0000 099C                                 Address[3] = SelectedRow;
	CALL SUBOPT_0xAA
; 0000 099D                                 }
_0x39F:
; 0000 099E                             SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 099F                             Address[5] = 0;
; 0000 09A0                             }
; 0000 09A1 
; 0000 09A2                             if(RefreshLcd>=1){
_0x39D:
_0x39C:
_0x39A:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x3A0
; 0000 09A3                             unsigned char row, lcd_row;
; 0000 09A4                             lcd_row = 0;
	CALL SUBOPT_0xAB
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 09A5                             RowsOnWindow = 20;
; 0000 09A6                                 for(row=Address[5];row<4+Address[5];row++){
_0x3A2:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRLT PC+3
	JMP _0x3A3
; 0000 09A7                                 lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 09A8 
; 0000 09A9                                     if(row==0){
	BRNE _0x3A4
; 0000 09AA                                         if(Address[2]==1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x3A5
; 0000 09AB                                         lcd_putsf(" -=GRUODZIO 25 D.=-");
	__POINTW1FN _0x0,1495
	RJMP _0x55A
; 0000 09AC                                         }
; 0000 09AD                                         else if(Address[2]==2){
_0x3A5:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x3A7
; 0000 09AE                                         lcd_putsf(" -=GRUODZIO 26 D.=-");
	__POINTW1FN _0x0,1515
_0x55A:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 09AF                                         }
; 0000 09B0                                     }
_0x3A7:
; 0000 09B1                                     else if(row>=1){
	RJMP _0x3A8
_0x3A4:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x3A9
; 0000 09B2                                         if(row<=BELL_COUNT){
	CPI  R26,LOW(0x15)
	BRLO PC+3
	JMP _0x3AA
; 0000 09B3                                         unsigned char id;
; 0000 09B4                                         id = GetBellId(Address[2]+10, row-1);
	SBIW R28,1
;	row -> Y+2
;	lcd_row -> Y+1
;	id -> Y+0
	__GETB1MN _Address_G000,2
	SUBI R30,-LOW(10)
	CALL SUBOPT_0x86
	CALL SUBOPT_0x85
; 0000 09B5                                         lcd_put_number(0,2,0,0,row,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xA
	CALL SUBOPT_0x87
; 0000 09B6                                         lcd_putsf(". ");
	CALL SUBOPT_0x88
; 0000 09B7 
; 0000 09B8                                             if(id!=255){
	LD   R26,Y
	CPI  R26,LOW(0xFF)
	BREQ _0x3AB
; 0000 09B9                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][id][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x89
	CALL SUBOPT_0x19
	CALL SUBOPT_0x8A
; 0000 09BA                                             lcd_putchar(':');
	CALL SUBOPT_0x8B
; 0000 09BB                                             lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][id][1],0);
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x89
	CALL SUBOPT_0x40
	CALL SUBOPT_0x8A
; 0000 09BC                                             lcd_putsf(" (");
	CALL SUBOPT_0x8C
; 0000 09BD                                             lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+10][id][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x89
	CALL SUBOPT_0x41
	CALL SUBOPT_0x87
; 0000 09BE                                             lcd_putsf("SEC)");
	__POINTW1FN _0x0,1107
	RJMP _0x55B
; 0000 09BF                                             }
; 0000 09C0                                             else{
_0x3AB:
; 0000 09C1                                             lcd_putsf("TUSCIA");
	__POINTW1FN _0x0,1112
_0x55B:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 09C2                                             }
; 0000 09C3                                         }
	ADIW R28,1
; 0000 09C4                                     }
_0x3AA:
; 0000 09C5 
; 0000 09C6                                 lcd_row++;
_0x3A9:
_0x3A8:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 09C7                                 }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x3A2
_0x3A3:
; 0000 09C8 
; 0000 09C9                             lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 09CA                             lcd_putchar('<');
; 0000 09CB                             }
; 0000 09CC                         }
_0x3A0:
; 0000 09CD                         else{
	RJMP _0x3AD
_0x398:
; 0000 09CE                             if(Address[3]<=BELL_COUNT){
	__GETB2MN _Address_G000,3
	CPI  R26,LOW(0x15)
	BRLO PC+3
	JMP _0x3AE
; 0000 09CF                                 if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x3AF
; 0000 09D0                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x3B0
; 0000 09D1                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x3B1
; 0000 09D2                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x55C
; 0000 09D3                                         }
; 0000 09D4                                         else if(SelectedRow==1){
_0x3B1:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x3B3
; 0000 09D5                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x55C
; 0000 09D6                                         }
; 0000 09D7                                         else if(SelectedRow==2){
_0x3B3:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x3B5
; 0000 09D8                                         SelectedRow = 3;
	LDI  R30,LOW(3)
_0x55C:
	STS  _SelectedRow_G000,R30
; 0000 09D9                                         }
; 0000 09DA                                     }
_0x3B5:
; 0000 09DB                                     else if(Address[4]==1){
	RJMP _0x3B6
_0x3B0:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x3B7
; 0000 09DC                                         if(BELL_TIME[Address[2]+10][Address[3]-1][0]-10 >= 0){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x3B8
; 0000 09DD                                         BELL_TIME[Address[2]+10][Address[3]-1][0] += -10;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 09DE                                         }
; 0000 09DF                                     }
_0x3B8:
; 0000 09E0                                     else if(Address[4]==2){
	RJMP _0x3B9
_0x3B7:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x3BA
; 0000 09E1                                         if(BELL_TIME[Address[2]+10][Address[3]-1][0]-1 >= 0){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x3BB
; 0000 09E2                                         BELL_TIME[Address[2]+10][Address[3]-1][0] += -1;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 09E3                                         }
; 0000 09E4                                     }
_0x3BB:
; 0000 09E5                                     else if(Address[4]==3){
	RJMP _0x3BC
_0x3BA:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x3BD
; 0000 09E6                                         if(BELL_TIME[Address[2]+10][Address[3]-1][1]-10 >= 0){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x3BE
; 0000 09E7                                         BELL_TIME[Address[2]+10][Address[3]-1][1] += -10;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 09E8                                         }
; 0000 09E9                                     }
_0x3BE:
; 0000 09EA                                     else if(Address[4]==4){
	RJMP _0x3BF
_0x3BD:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x3C0
; 0000 09EB                                         if(BELL_TIME[Address[2]+10][Address[3]-1][1]-1 >= 0){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x3C1
; 0000 09EC                                         BELL_TIME[Address[2]+10][Address[3]-1][1] += -1;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 09ED                                         }
; 0000 09EE                                     }
_0x3C1:
; 0000 09EF                                     else if(Address[4]==5){
	RJMP _0x3C2
_0x3C0:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x3C3
; 0000 09F0                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]-100 > 0){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x91
	BRGE _0x3C4
; 0000 09F1                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += -100;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(156)
	CALL __EEPROMWRB
; 0000 09F2                                         }
; 0000 09F3                                     }
_0x3C4:
; 0000 09F4                                     else if(Address[4]==6){
	RJMP _0x3C5
_0x3C3:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x3C6
; 0000 09F5                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]-10 > 0){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x93
	BRGE _0x3C7
; 0000 09F6                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += -10;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 09F7                                         }
; 0000 09F8                                     }
_0x3C7:
; 0000 09F9                                     else if(Address[4]==7){
	RJMP _0x3C8
_0x3C6:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x3C9
; 0000 09FA                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]-1 > 0){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	CALL SUBOPT_0x1E
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x3CA
; 0000 09FB                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += -1;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 09FC                                         }
; 0000 09FD                                     }
_0x3CA:
; 0000 09FE                                 }
_0x3C9:
_0x3C8:
_0x3C5:
_0x3C2:
_0x3BF:
_0x3BC:
_0x3B9:
_0x3B6:
; 0000 09FF                                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x3CB
_0x3AF:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x3CC
; 0000 0A00                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x3CD
; 0000 0A01                                         if(SelectedRow==1){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x3CE
; 0000 0A02                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x55D
; 0000 0A03                                         }
; 0000 0A04                                         else if(SelectedRow==2){
_0x3CE:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x3D0
; 0000 0A05                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x55D
; 0000 0A06                                         }
; 0000 0A07                                         else if(SelectedRow==3){
_0x3D0:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x3D2
; 0000 0A08                                         SelectedRow = 2;
	LDI  R30,LOW(2)
_0x55D:
	STS  _SelectedRow_G000,R30
; 0000 0A09                                         }
; 0000 0A0A                                     }
_0x3D2:
; 0000 0A0B                                     else if(Address[4]==1){
	RJMP _0x3D3
_0x3CD:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x3D4
; 0000 0A0C                                         if(BELL_TIME[Address[2]+10][Address[3]-1][0]+10 < 24){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x94
	SBIW R30,24
	BRGE _0x3D5
; 0000 0A0D                                         BELL_TIME[Address[2]+10][Address[3]-1][0] += 10;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 0A0E                                         }
; 0000 0A0F                                     }
_0x3D5:
; 0000 0A10                                     else if(Address[4]==2){
	RJMP _0x3D6
_0x3D4:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x3D7
; 0000 0A11                                         if(BELL_TIME[Address[2]+10][Address[3]-1][0]+1 < 24){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x95
	SBIW R30,24
	BRGE _0x3D8
; 0000 0A12                                         BELL_TIME[Address[2]+10][Address[3]-1][0] += 1;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0A13                                         }
; 0000 0A14                                     }
_0x3D8:
; 0000 0A15                                     else if(Address[4]==3){
	RJMP _0x3D9
_0x3D7:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x3DA
; 0000 0A16                                         if(BELL_TIME[Address[2]+10][Address[3]-1][1]+10 < 60){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x94
	SBIW R30,60
	BRGE _0x3DB
; 0000 0A17                                         BELL_TIME[Address[2]+10][Address[3]-1][1] += 10;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 0A18                                         }
; 0000 0A19                                     }
_0x3DB:
; 0000 0A1A                                     else if(Address[4]==4){
	RJMP _0x3DC
_0x3DA:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x3DD
; 0000 0A1B                                         if(BELL_TIME[Address[2]+10][Address[3]-1][1]+1 < 60){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x95
	SBIW R30,60
	BRGE _0x3DE
; 0000 0A1C                                         BELL_TIME[Address[2]+10][Address[3]-1][1] += 1;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0A1D                                         }
; 0000 0A1E                                     }
_0x3DE:
; 0000 0A1F                                     else if(Address[4]==5){
	RJMP _0x3DF
_0x3DD:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x3E0
; 0000 0A20                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]+100 <= 255){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x96
	BRGE _0x3E1
; 0000 0A21                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += 100;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(100)
	CALL __EEPROMWRB
; 0000 0A22                                         }
; 0000 0A23                                     }
_0x3E1:
; 0000 0A24                                     else if(Address[4]==6){
	RJMP _0x3E2
_0x3E0:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x3E3
; 0000 0A25                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]+10 <= 255){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x97
	BRGE _0x3E4
; 0000 0A26                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += 10;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 0A27                                         }
; 0000 0A28                                     }
_0x3E4:
; 0000 0A29                                     else if(Address[4]==7){
	RJMP _0x3E5
_0x3E3:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x3E6
; 0000 0A2A                                         if(BELL_TIME[Address[2]+10][Address[3]-1][2]+1 <= 255){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x98
	BRGE _0x3E7
; 0000 0A2B                                         BELL_TIME[Address[2]+10][Address[3]-1][2] += 1;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0A2C                                         }
; 0000 0A2D                                     }
_0x3E7:
; 0000 0A2E                                 }
_0x3E6:
_0x3E5:
_0x3E2:
_0x3DF:
_0x3DC:
_0x3D9:
_0x3D6:
_0x3D3:
; 0000 0A2F                                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x3E8
_0x3CC:
	__GETB2MN _BUTTON_S000000F001,1
	CPI  R26,LOW(0x1)
	BRNE _0x3E9
; 0000 0A30                                     if(Address[4]>1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRLO _0x3EA
; 0000 0A31                                     Address[4]--;
	CALL SUBOPT_0x99
; 0000 0A32                                     }
; 0000 0A33                                 }
_0x3EA:
; 0000 0A34                                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x3EB
_0x3E9:
	__GETB2MN _BUTTON_S000000F001,3
	CPI  R26,LOW(0x1)
	BRNE _0x3EC
; 0000 0A35                                     if(Address[4]>0){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRLO _0x3ED
; 0000 0A36                                         if(Address[4]<7){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRSH _0x3EE
; 0000 0A37                                         Address[4]++;
	CALL SUBOPT_0x9A
; 0000 0A38                                         }
; 0000 0A39                                     }
_0x3EE:
; 0000 0A3A                                 }
_0x3ED:
; 0000 0A3B                                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x3EF
_0x3EC:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x3F0
; 0000 0A3C                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x3F1
; 0000 0A3D                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BREQ _0x55E
; 0000 0A3E                                         Address[3] = 0;
; 0000 0A3F                                         }
; 0000 0A40                                         else if(SelectedRow==2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x3F4
; 0000 0A41                                         Address[4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,4
; 0000 0A42                                         }
; 0000 0A43                                         else if(SelectedRow==3){
	RJMP _0x3F5
_0x3F4:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x3F6
; 0000 0A44                                         BELL_TIME[Address[2]+10][Address[3]-1][0] = 0;
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0xB5
; 0000 0A45                                         BELL_TIME[Address[2]+10][Address[3]-1][1] = 0;
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0xB6
; 0000 0A46                                         BELL_TIME[Address[2]+10][Address[3]-1][2] = 0;
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x1D
; 0000 0A47                                         Address[3] = 0;
_0x55E:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 0A48                                         }
; 0000 0A49                                     }
_0x3F6:
_0x3F5:
; 0000 0A4A                                     else{
	RJMP _0x3F7
_0x3F1:
; 0000 0A4B                                     Address[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,4
; 0000 0A4C                                     }
_0x3F7:
; 0000 0A4D                                 SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0A4E                                 Address[5] = 0;
; 0000 0A4F                                 }
; 0000 0A50 
; 0000 0A51                                 if(RefreshLcd>=1){
_0x3F0:
_0x3EF:
_0x3EB:
_0x3E8:
_0x3CB:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x3F8
; 0000 0A52                                 lcd_putsf(" -=LAIKO KEITIMAS=- ");
	CALL SUBOPT_0x9D
; 0000 0A53                                     if(BELL_TIME[Address[2]+10][Address[3]-1][0]>=24){
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CPI  R30,LOW(0x18)
	BRSH _0x55F
; 0000 0A54                                     BELL_TIME[Address[2]+10][Address[3]-1][0] = 0;
; 0000 0A55                                     BELL_TIME[Address[2]+10][Address[3]-1][1] = 0;
; 0000 0A56                                     BELL_TIME[Address[2]+10][Address[3]-1][2] = 0;
; 0000 0A57                                     }
; 0000 0A58                                     else if(BELL_TIME[Address[2]-1][Address[3]-1][1]>=60){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CPI  R30,LOW(0x3C)
	BRLO _0x3FB
; 0000 0A59                                     BELL_TIME[Address[2]+10][Address[3]-1][0] = 0;
_0x55F:
	__GETB1MN _Address_G000,2
	CALL SUBOPT_0x94
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0xB5
; 0000 0A5A                                     BELL_TIME[Address[2]+10][Address[3]-1][1] = 0;
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0xB6
; 0000 0A5B                                     BELL_TIME[Address[2]+10][Address[3]-1][2] = 0;
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x1D
; 0000 0A5C                                     }
; 0000 0A5D 
; 0000 0A5E                                 lcd_putsf("LAIKAS: ");
_0x3FB:
	CALL SUBOPT_0x7D
; 0000 0A5F                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][Address[3]-1][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8A
; 0000 0A60                                 lcd_putchar('.');
	CALL SUBOPT_0x29
; 0000 0A61                                 lcd_put_number(0,2,0,0,BELL_TIME[Address[2]+10][Address[3]-1][1],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x8A
; 0000 0A62                                 lcd_putsf(" (");
	CALL SUBOPT_0x8C
; 0000 0A63                                 lcd_put_number(0,3,0,0,BELL_TIME[Address[2]+10][Address[3]-1][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x87
; 0000 0A64                                 lcd_putchar(')');lcd_putsf(" ");
	CALL SUBOPT_0x9E
; 0000 0A65 
; 0000 0A66 
; 0000 0A67                                     if(Address[4]==1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x3FC
; 0000 0A68                                     lcd_putsf("        ^");
	CALL SUBOPT_0x9F
; 0000 0A69                                     }
; 0000 0A6A                                     else if(Address[4]==2){
	RJMP _0x3FD
_0x3FC:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x3FE
; 0000 0A6B                                     lcd_putsf("         ^");
	CALL SUBOPT_0xA0
; 0000 0A6C                                     }
; 0000 0A6D                                     else if(Address[4]==3){
	RJMP _0x3FF
_0x3FE:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x400
; 0000 0A6E                                     lcd_putsf("           ^");
	CALL SUBOPT_0xA1
; 0000 0A6F                                     }
; 0000 0A70                                     else if(Address[4]==4){
	RJMP _0x401
_0x400:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x402
; 0000 0A71                                     lcd_putsf("            ^");
	CALL SUBOPT_0xA2
; 0000 0A72                                     }
; 0000 0A73                                     else if(Address[4]==5){
	RJMP _0x403
_0x402:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x404
; 0000 0A74                                     lcd_putsf("               ^");
	CALL SUBOPT_0xA3
; 0000 0A75                                     }
; 0000 0A76                                     else if(Address[4]==6){
	RJMP _0x405
_0x404:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x406
; 0000 0A77                                     lcd_putsf("                ^");
	CALL SUBOPT_0xA4
; 0000 0A78                                     }
; 0000 0A79                                     else if(Address[4]==7){
	RJMP _0x407
_0x406:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x408
; 0000 0A7A                                     lcd_putsf("                 ^");
	CALL SUBOPT_0xA5
; 0000 0A7B                                     }
; 0000 0A7C                                     else if(Address[4]==0){
	RJMP _0x409
_0x408:
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x40A
; 0000 0A7D                                     lcd_putsf("      REDAGUOTI?    ");
	CALL SUBOPT_0x81
; 0000 0A7E                                     lcd_putsf("       TRINTI?      ");
	CALL SUBOPT_0xA6
; 0000 0A7F                                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0xA7
; 0000 0A80                                     lcd_putchar('<');
; 0000 0A81                                     }
; 0000 0A82                                 }
_0x40A:
_0x409:
_0x407:
_0x405:
_0x403:
_0x401:
_0x3FF:
_0x3FD:
; 0000 0A83                             }
_0x3F8:
; 0000 0A84                             else{
	RJMP _0x40B
_0x3AE:
; 0000 0A85                             Address[3] = 0;
	CALL SUBOPT_0xA8
; 0000 0A86                             SelectedRow = 0;
; 0000 0A87                             Address[5] = 0;
; 0000 0A88                             }
_0x40B:
; 0000 0A89                         }
_0x3AD:
; 0000 0A8A                     }
; 0000 0A8B                 }
_0x395:
_0x394:
; 0000 0A8C             /////////////////////
; 0000 0A8D 
; 0000 0A8E             // PORCIUNKULES ATLAIDU LAIKO MENIU
; 0000 0A8F                 else if(Address[1]==4){
	RJMP _0x40C
_0x382:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x40D
; 0000 0A90                     if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BREQ PC+3
	JMP _0x40E
; 0000 0A91                         if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x40F
; 0000 0A92                         SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0A93                         }
; 0000 0A94                         else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x410
_0x40F:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x411
; 0000 0A95                         SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0A96                         }
; 0000 0A97                         else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x412
_0x411:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x413
; 0000 0A98                             if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x414
; 0000 0A99                             Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 0A9A                             }
; 0000 0A9B                             else{
	RJMP _0x415
_0x414:
; 0000 0A9C                             Address[2] = SelectedRow;
	CALL SUBOPT_0x82
; 0000 0A9D                             }
_0x415:
; 0000 0A9E                         SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0A9F                         Address[5] = 0;
; 0000 0AA0                         }
; 0000 0AA1 
; 0000 0AA2                         if(RefreshLcd>=1){
_0x413:
_0x412:
_0x410:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x416
; 0000 0AA3                         unsigned char row, lcd_row;
; 0000 0AA4                         lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0AA5                         RowsOnWindow = 2;
	LDI  R30,LOW(2)
	CALL SUBOPT_0x83
; 0000 0AA6                             for(row=Address[5];row<4+Address[5];row++){
_0x418:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRGE _0x419
; 0000 0AA7                             lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 0AA8 
; 0000 0AA9                                 if(row==0){
	BRNE _0x41A
; 0000 0AAA                                 lcd_putsf("  -=PORCIUNKULE=-  ");
	__POINTW1FN _0x0,1535
	RJMP _0x560
; 0000 0AAB                                 }
; 0000 0AAC                                 else if(row==1){
_0x41A:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x41C
; 0000 0AAD                                 lcd_putsf("1.SEKMADIENIS");
	__POINTW1FN _0x0,1555
_0x560:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0AAE                                 }
; 0000 0AAF 
; 0000 0AB0                             lcd_row++;
_0x41C:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0AB1                             }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x418
_0x419:
; 0000 0AB2 
; 0000 0AB3                         lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0AB4                         lcd_putchar('<');
; 0000 0AB5                         }
; 0000 0AB6                     }
_0x416:
; 0000 0AB7                     else if(Address[2]==1){
	RJMP _0x41D
_0x40E:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x41E
; 0000 0AB8                         if(Address[3]==0){
	__GETB1MN _Address_G000,3
	CPI  R30,0
	BREQ PC+3
	JMP _0x41F
; 0000 0AB9                             if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x420
; 0000 0ABA                             SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0ABB                             }
; 0000 0ABC                             else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x421
_0x420:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x422
; 0000 0ABD                             SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0ABE                             }
; 0000 0ABF                             else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x423
_0x422:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x424
; 0000 0AC0                                 if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x425
; 0000 0AC1                                 Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
; 0000 0AC2                                 }
; 0000 0AC3                                 else{
	RJMP _0x426
_0x425:
; 0000 0AC4                                 Address[3] = SelectedRow;
	CALL SUBOPT_0xAA
; 0000 0AC5                                 }
_0x426:
; 0000 0AC6                             SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0AC7                             Address[5] = 0;
; 0000 0AC8                             }
; 0000 0AC9 
; 0000 0ACA                             if(RefreshLcd>=1){
_0x424:
_0x423:
_0x421:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x427
; 0000 0ACB                             unsigned char row, lcd_row;
; 0000 0ACC                             lcd_row = 0;
	CALL SUBOPT_0xAB
;	row -> Y+1
;	lcd_row -> Y+0
; 0000 0ACD                             RowsOnWindow = 20;
; 0000 0ACE                                 for(row=Address[5];row<4+Address[5];row++){
_0x429:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRLT PC+3
	JMP _0x42A
; 0000 0ACF                                 lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 0AD0 
; 0000 0AD1                                     if(row==0){
	BRNE _0x42B
; 0000 0AD2                                         if(Address[2]==1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x42C
; 0000 0AD3                                         lcd_putsf("  -=SEKMADIENIS=-  ");
	__POINTW1FN _0x0,1569
	CALL SUBOPT_0x2E
; 0000 0AD4                                         }
; 0000 0AD5                                     }
_0x42C:
; 0000 0AD6                                     else if(row>=1){
	RJMP _0x42D
_0x42B:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRLO _0x42E
; 0000 0AD7                                         if(row<=BELL_COUNT){
	CPI  R26,LOW(0x15)
	BRSH _0x42F
; 0000 0AD8                                         unsigned char id;
; 0000 0AD9                                         id = GetBellId(13, row-1);
	SBIW R28,1
;	row -> Y+2
;	lcd_row -> Y+1
;	id -> Y+0
	LDI  R30,LOW(13)
	CALL SUBOPT_0x86
	CALL SUBOPT_0x85
; 0000 0ADA                                         lcd_put_number(0,2,0,0,row,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xA
	CALL SUBOPT_0x87
; 0000 0ADB                                         lcd_putsf(". ");
	CALL SUBOPT_0x88
; 0000 0ADC 
; 0000 0ADD                                             if(id!=255){
	LD   R26,Y
	CPI  R26,LOW(0xFF)
	BREQ _0x430
; 0000 0ADE                                             lcd_put_number(0,2,0,0,BELL_TIME[13][id][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB7
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8A
; 0000 0ADF                                             lcd_putchar(':');
	CALL SUBOPT_0x8B
; 0000 0AE0                                             lcd_put_number(0,2,0,0,BELL_TIME[13][id][1],0);
	CALL SUBOPT_0xB7
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x8A
; 0000 0AE1                                             lcd_putsf(" (");
	CALL SUBOPT_0x8C
; 0000 0AE2                                             lcd_put_number(0,3,0,0,BELL_TIME[13][id][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xB7
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x87
; 0000 0AE3                                             lcd_putsf("SEC)");
	__POINTW1FN _0x0,1107
	RJMP _0x561
; 0000 0AE4                                             }
; 0000 0AE5                                             else{
_0x430:
; 0000 0AE6                                             lcd_putsf("TUSCIA");
	__POINTW1FN _0x0,1112
_0x561:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0AE7                                             }
; 0000 0AE8                                         }
	ADIW R28,1
; 0000 0AE9                                     }
_0x42F:
; 0000 0AEA 
; 0000 0AEB                                 lcd_row++;
_0x42E:
_0x42D:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0AEC                                 }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x429
_0x42A:
; 0000 0AED 
; 0000 0AEE                             lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0AEF                             lcd_putchar('<');
; 0000 0AF0                             }
; 0000 0AF1                         }
_0x427:
; 0000 0AF2                         else{
	RJMP _0x432
_0x41F:
; 0000 0AF3                             if(Address[3]<=BELL_COUNT){
	__GETB2MN _Address_G000,3
	CPI  R26,LOW(0x15)
	BRLO PC+3
	JMP _0x433
; 0000 0AF4                                 if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x434
; 0000 0AF5                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x435
; 0000 0AF6                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x436
; 0000 0AF7                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x562
; 0000 0AF8                                         }
; 0000 0AF9                                         else if(SelectedRow==1){
_0x436:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x438
; 0000 0AFA                                         SelectedRow = 2;
	LDI  R30,LOW(2)
	RJMP _0x562
; 0000 0AFB                                         }
; 0000 0AFC                                         else if(SelectedRow==2){
_0x438:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x43A
; 0000 0AFD                                         SelectedRow = 3;
	LDI  R30,LOW(3)
_0x562:
	STS  _SelectedRow_G000,R30
; 0000 0AFE                                         }
; 0000 0AFF                                     }
_0x43A:
; 0000 0B00                                     else if(Address[4]==1){
	RJMP _0x43B
_0x435:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x43C
; 0000 0B01                                         if(BELL_TIME[13][Address[3]-1][0]-10 >= 0){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x43D
; 0000 0B02                                         BELL_TIME[13][Address[3]-1][0] += -10;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 0B03                                         }
; 0000 0B04                                     }
_0x43D:
; 0000 0B05                                     else if(Address[4]==2){
	RJMP _0x43E
_0x43C:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x43F
; 0000 0B06                                         if(BELL_TIME[13][Address[3]-1][0]-1 >= 0){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x440
; 0000 0B07                                         BELL_TIME[13][Address[3]-1][0] += -1;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 0B08                                         }
; 0000 0B09                                     }
_0x440:
; 0000 0B0A                                     else if(Address[4]==3){
	RJMP _0x441
_0x43F:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x442
; 0000 0B0B                                         if(BELL_TIME[13][Address[3]-1][1]-10 >= 0){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x80
	TST  R31
	BRMI _0x443
; 0000 0B0C                                         BELL_TIME[13][Address[3]-1][1] += -10;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 0B0D                                         }
; 0000 0B0E                                     }
_0x443:
; 0000 0B0F                                     else if(Address[4]==4){
	RJMP _0x444
_0x442:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x445
; 0000 0B10                                         if(BELL_TIME[13][Address[3]-1][1]-1 >= 0){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x1E
	TST  R31
	BRMI _0x446
; 0000 0B11                                         BELL_TIME[13][Address[3]-1][1] += -1;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 0B12                                         }
; 0000 0B13                                     }
_0x446:
; 0000 0B14                                     else if(Address[4]==5){
	RJMP _0x447
_0x445:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x448
; 0000 0B15                                         if(BELL_TIME[13][Address[3]-1][2]-100 > 0){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x91
	BRGE _0x449
; 0000 0B16                                         BELL_TIME[13][Address[3]-1][2] += -100;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(156)
	CALL __EEPROMWRB
; 0000 0B17                                         }
; 0000 0B18                                     }
_0x449:
; 0000 0B19                                     else if(Address[4]==6){
	RJMP _0x44A
_0x448:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x44B
; 0000 0B1A                                         if(BELL_TIME[13][Address[3]-1][2]-10 > 0){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x93
	BRGE _0x44C
; 0000 0B1B                                         BELL_TIME[13][Address[3]-1][2] += -10;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(246)
	CALL __EEPROMWRB
; 0000 0B1C                                         }
; 0000 0B1D                                     }
_0x44C:
; 0000 0B1E                                     else if(Address[4]==7){
	RJMP _0x44D
_0x44B:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x44E
; 0000 0B1F                                         if(BELL_TIME[13][Address[3]-1][2]-1 > 0){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	CALL SUBOPT_0x1E
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x44F
; 0000 0B20                                         BELL_TIME[13][Address[3]-1][2] += -1;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(255)
	CALL __EEPROMWRB
; 0000 0B21                                         }
; 0000 0B22                                     }
_0x44F:
; 0000 0B23                                 }
_0x44E:
_0x44D:
_0x44A:
_0x447:
_0x444:
_0x441:
_0x43E:
_0x43B:
; 0000 0B24                                 else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x450
_0x434:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x451
; 0000 0B25                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x452
; 0000 0B26                                         if(SelectedRow==1){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x453
; 0000 0B27                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x563
; 0000 0B28                                         }
; 0000 0B29                                         else if(SelectedRow==2){
_0x453:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x455
; 0000 0B2A                                         SelectedRow = 0;
	LDI  R30,LOW(0)
	RJMP _0x563
; 0000 0B2B                                         }
; 0000 0B2C                                         else if(SelectedRow==3){
_0x455:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x457
; 0000 0B2D                                         SelectedRow = 2;
	LDI  R30,LOW(2)
_0x563:
	STS  _SelectedRow_G000,R30
; 0000 0B2E                                         }
; 0000 0B2F                                     }
_0x457:
; 0000 0B30                                     else if(Address[4]==1){
	RJMP _0x458
_0x452:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x459
; 0000 0B31                                         if(BELL_TIME[13][Address[3]-1][0]+10 < 24){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x94
	SBIW R30,24
	BRGE _0x45A
; 0000 0B32                                         BELL_TIME[13][Address[3]-1][0] += 10;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 0B33                                         }
; 0000 0B34                                     }
_0x45A:
; 0000 0B35                                     else if(Address[4]==2){
	RJMP _0x45B
_0x459:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x45C
; 0000 0B36                                         if(BELL_TIME[13][Address[3]-1][0]+1 < 24){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x95
	SBIW R30,24
	BRGE _0x45D
; 0000 0B37                                         BELL_TIME[13][Address[3]-1][0] += 1;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8E
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0B38                                         }
; 0000 0B39                                     }
_0x45D:
; 0000 0B3A                                     else if(Address[4]==3){
	RJMP _0x45E
_0x45C:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x45F
; 0000 0B3B                                         if(BELL_TIME[13][Address[3]-1][1]+10 < 60){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x94
	SBIW R30,60
	BRGE _0x460
; 0000 0B3C                                         BELL_TIME[13][Address[3]-1][1] += 10;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 0B3D                                         }
; 0000 0B3E                                     }
_0x460:
; 0000 0B3F                                     else if(Address[4]==4){
	RJMP _0x461
_0x45F:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x462
; 0000 0B40                                         if(BELL_TIME[13][Address[3]-1][1]+1 < 60){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x95
	SBIW R30,60
	BRGE _0x463
; 0000 0B41                                         BELL_TIME[13][Address[3]-1][1] += 1;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8F
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0B42                                         }
; 0000 0B43                                     }
_0x463:
; 0000 0B44                                     else if(Address[4]==5){
	RJMP _0x464
_0x462:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x465
; 0000 0B45                                         if(BELL_TIME[13][Address[3]-1][2]+100 <= 255){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x96
	BRGE _0x466
; 0000 0B46                                         BELL_TIME[13][Address[3]-1][2] += 100;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(100)
	CALL __EEPROMWRB
; 0000 0B47                                         }
; 0000 0B48                                     }
_0x466:
; 0000 0B49                                     else if(Address[4]==6){
	RJMP _0x467
_0x465:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x468
; 0000 0B4A                                         if(BELL_TIME[13][Address[3]-1][2]+10 <= 255){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x97
	BRGE _0x469
; 0000 0B4B                                         BELL_TIME[13][Address[3]-1][2] += 10;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(10)
	CALL __EEPROMWRB
; 0000 0B4C                                         }
; 0000 0B4D                                     }
_0x469:
; 0000 0B4E                                     else if(Address[4]==7){
	RJMP _0x46A
_0x468:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x46B
; 0000 0B4F                                         if(BELL_TIME[13][Address[3]-1][2]+1 <= 255){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x98
	BRGE _0x46C
; 0000 0B50                                         BELL_TIME[13][Address[3]-1][2] += 1;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x92
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
; 0000 0B51                                         }
; 0000 0B52                                     }
_0x46C:
; 0000 0B53                                 }
_0x46B:
_0x46A:
_0x467:
_0x464:
_0x461:
_0x45E:
_0x45B:
_0x458:
; 0000 0B54                                 else if(BUTTON[BUTTON_LEFT]==1){
	RJMP _0x46D
_0x451:
	__GETB2MN _BUTTON_S000000F001,1
	CPI  R26,LOW(0x1)
	BRNE _0x46E
; 0000 0B55                                     if(Address[4]>1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRLO _0x46F
; 0000 0B56                                     Address[4]--;
	CALL SUBOPT_0x99
; 0000 0B57                                     }
; 0000 0B58                                 }
_0x46F:
; 0000 0B59                                 else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x470
_0x46E:
	__GETB2MN _BUTTON_S000000F001,3
	CPI  R26,LOW(0x1)
	BRNE _0x471
; 0000 0B5A                                     if(Address[4]>0){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRLO _0x472
; 0000 0B5B                                         if(Address[4]<7){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRSH _0x473
; 0000 0B5C                                         Address[4]++;
	CALL SUBOPT_0x9A
; 0000 0B5D                                         }
; 0000 0B5E                                     }
_0x473:
; 0000 0B5F                                 }
_0x472:
; 0000 0B60                                 else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x474
_0x471:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x475
; 0000 0B61                                     if(Address[4]==0){
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x476
; 0000 0B62                                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BREQ _0x564
; 0000 0B63                                         Address[3] = 0;
; 0000 0B64                                         }
; 0000 0B65                                         else if(SelectedRow==2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x479
; 0000 0B66                                         Address[4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,4
; 0000 0B67                                         }
; 0000 0B68                                         else if(SelectedRow==3){
	RJMP _0x47A
_0x479:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x47B
; 0000 0B69                                         BELL_TIME[13][Address[3]-1][0] = 0;
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0xB9
; 0000 0B6A                                         BELL_TIME[13][Address[3]-1][1] = 0;
	CALL SUBOPT_0x90
	CALL SUBOPT_0xBA
; 0000 0B6B                                         BELL_TIME[13][Address[3]-1][2] = 0;
	CALL SUBOPT_0x90
	CALL SUBOPT_0x1D
; 0000 0B6C                                         Address[3] = 0;
_0x564:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 0B6D                                         }
; 0000 0B6E                                     }
_0x47B:
_0x47A:
; 0000 0B6F                                     else{
	RJMP _0x47C
_0x476:
; 0000 0B70                                     Address[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,4
; 0000 0B71                                     }
_0x47C:
; 0000 0B72                                 SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0B73                                 Address[5] = 0;
; 0000 0B74                                 }
; 0000 0B75 
; 0000 0B76                                 if(RefreshLcd>=1){
_0x475:
_0x474:
_0x470:
_0x46D:
_0x450:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x47D
; 0000 0B77                                 lcd_putsf(" -=LAIKO KEITIMAS=- ");
	CALL SUBOPT_0x9D
; 0000 0B78                                     if(BELL_TIME[13][Address[3]-1][0]>=24){
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8E
	CPI  R30,LOW(0x18)
	BRSH _0x565
; 0000 0B79                                     BELL_TIME[13][Address[3]-1][0] = 0;
; 0000 0B7A                                     BELL_TIME[13][Address[3]-1][1] = 0;
; 0000 0B7B                                     BELL_TIME[13][Address[3]-1][2] = 0;
; 0000 0B7C                                     }
; 0000 0B7D                                     else if(BELL_TIME[Address[2]-1][Address[3]-1][1]>=60){
	CALL SUBOPT_0x84
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8F
	CPI  R30,LOW(0x3C)
	BRLO _0x480
; 0000 0B7E                                     BELL_TIME[13][Address[3]-1][0] = 0;
_0x565:
	__POINTW2MN _BELL_TIME,780
	__GETB1MN _Address_G000,3
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x90
	CALL SUBOPT_0xB9
; 0000 0B7F                                     BELL_TIME[13][Address[3]-1][1] = 0;
	CALL SUBOPT_0x90
	CALL SUBOPT_0xBA
; 0000 0B80                                     BELL_TIME[13][Address[3]-1][2] = 0;
	CALL SUBOPT_0x90
	CALL SUBOPT_0x1D
; 0000 0B81                                     }
; 0000 0B82 
; 0000 0B83                                 lcd_putsf("LAIKAS: ");
_0x480:
	CALL SUBOPT_0x7D
; 0000 0B84                                 lcd_put_number(0,2,0,0,BELL_TIME[13][Address[3]-1][0],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8A
; 0000 0B85                                 lcd_putchar('.');
	CALL SUBOPT_0x29
; 0000 0B86                                 lcd_put_number(0,2,0,0,BELL_TIME[13][Address[3]-1][1],0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x8A
; 0000 0B87                                 lcd_putsf(" (");
	CALL SUBOPT_0x8C
; 0000 0B88                                 lcd_put_number(0,3,0,0,BELL_TIME[13][Address[3]-1][2],0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0xB8
	CALL SUBOPT_0x90
	CALL SUBOPT_0x41
	CALL SUBOPT_0x87
; 0000 0B89                                 lcd_putchar(')');lcd_putsf(" ");
	CALL SUBOPT_0x9E
; 0000 0B8A 
; 0000 0B8B 
; 0000 0B8C                                     if(Address[4]==1){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x1)
	BRNE _0x481
; 0000 0B8D                                     lcd_putsf("        ^");
	CALL SUBOPT_0x9F
; 0000 0B8E                                     }
; 0000 0B8F                                     else if(Address[4]==2){
	RJMP _0x482
_0x481:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x2)
	BRNE _0x483
; 0000 0B90                                     lcd_putsf("         ^");
	CALL SUBOPT_0xA0
; 0000 0B91                                     }
; 0000 0B92                                     else if(Address[4]==3){
	RJMP _0x484
_0x483:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRNE _0x485
; 0000 0B93                                     lcd_putsf("           ^");
	CALL SUBOPT_0xA1
; 0000 0B94                                     }
; 0000 0B95                                     else if(Address[4]==4){
	RJMP _0x486
_0x485:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x4)
	BRNE _0x487
; 0000 0B96                                     lcd_putsf("            ^");
	CALL SUBOPT_0xA2
; 0000 0B97                                     }
; 0000 0B98                                     else if(Address[4]==5){
	RJMP _0x488
_0x487:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x5)
	BRNE _0x489
; 0000 0B99                                     lcd_putsf("               ^");
	CALL SUBOPT_0xA3
; 0000 0B9A                                     }
; 0000 0B9B                                     else if(Address[4]==6){
	RJMP _0x48A
_0x489:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x6)
	BRNE _0x48B
; 0000 0B9C                                     lcd_putsf("                ^");
	CALL SUBOPT_0xA4
; 0000 0B9D                                     }
; 0000 0B9E                                     else if(Address[4]==7){
	RJMP _0x48C
_0x48B:
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x7)
	BRNE _0x48D
; 0000 0B9F                                     lcd_putsf("                 ^");
	CALL SUBOPT_0xA5
; 0000 0BA0                                     }
; 0000 0BA1                                     else if(Address[4]==0){
	RJMP _0x48E
_0x48D:
	__GETB1MN _Address_G000,4
	CPI  R30,0
	BRNE _0x48F
; 0000 0BA2                                     lcd_putsf("      REDAGUOTI?    ");
	CALL SUBOPT_0x81
; 0000 0BA3                                     lcd_putsf("       TRINTI?      ");
	CALL SUBOPT_0xA6
; 0000 0BA4                                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0xA7
; 0000 0BA5                                     lcd_putchar('<');
; 0000 0BA6                                     }
; 0000 0BA7                                 }
_0x48F:
_0x48E:
_0x48C:
_0x48A:
_0x488:
_0x486:
_0x484:
_0x482:
; 0000 0BA8                             }
_0x47D:
; 0000 0BA9                             else{
	RJMP _0x490
_0x433:
; 0000 0BAA                             Address[3] = 0;
	CALL SUBOPT_0xA8
; 0000 0BAB                             SelectedRow = 0;
; 0000 0BAC                             Address[5] = 0;
; 0000 0BAD                             }
_0x490:
; 0000 0BAE                         }
_0x432:
; 0000 0BAF                     }
; 0000 0BB0                 }
_0x41E:
_0x41D:
; 0000 0BB1             /////////////////////
; 0000 0BB2 
; 0000 0BB3 
; 0000 0BB4             }
_0x40D:
_0x40C:
_0x381:
_0x2E7:
_0x245:
; 0000 0BB5 
; 0000 0BB6             // Nustatymai
; 0000 0BB7             else if(Address[0]==4){
	RJMP _0x491
_0x22F:
	LDS  R26,_Address_G000
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x492
; 0000 0BB8                 if(Address[1]==0){
	__GETB1MN _Address_G000,1
	CPI  R30,0
	BREQ PC+3
	JMP _0x493
; 0000 0BB9                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x494
; 0000 0BBA                     SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0BBB                     }
; 0000 0BBC                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x495
_0x494:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x496
; 0000 0BBD                     SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0BBE                     }
; 0000 0BBF                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x497
_0x496:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x498
; 0000 0BC0                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x499
; 0000 0BC1                         Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address_G000,R30
; 0000 0BC2                         }
; 0000 0BC3                         else{
	RJMP _0x49A
_0x499:
; 0000 0BC4                         Address[1] = SelectedRow;
	LDS  R30,_SelectedRow_G000
	__PUTB1MN _Address_G000,1
; 0000 0BC5                         }
_0x49A:
; 0000 0BC6                     SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0BC7                     Address[5] = 0;
; 0000 0BC8                     }
; 0000 0BC9 
; 0000 0BCA                     if(RefreshLcd>=1){
_0x498:
_0x497:
_0x495:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x49B
; 0000 0BCB                     unsigned char row, lcd_row;
; 0000 0BCC                     lcd_row = 0;
	SBIW R28,2
;	row -> Y+1
;	lcd_row -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0BCD                     RowsOnWindow = 7;
	LDI  R30,LOW(7)
	CALL SUBOPT_0x83
; 0000 0BCE                         for(row=Address[5];row<4+Address[5];row++){
_0x49D:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x76
	BRGE _0x49E
; 0000 0BCF                         lcd_gotoxy(0,lcd_row);
	CALL SUBOPT_0x77
; 0000 0BD0                             if(row==0){
	BRNE _0x49F
; 0000 0BD1                             lcd_putsf("   -=NUSTATYMAI=-   ");
	__POINTW1FN _0x0,1589
	RJMP _0x566
; 0000 0BD2                             }
; 0000 0BD3                             else if(row==1){
_0x49F:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x4A1
; 0000 0BD4                             lcd_putsf("1.EKRANO APSVIETIM.");
	__POINTW1FN _0x0,1610
	RJMP _0x566
; 0000 0BD5                             }
; 0000 0BD6                             else if(row==2){
_0x4A1:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x4A3
; 0000 0BD7                             lcd_putsf("2.VALYTI SKAMBEJIM.");
	__POINTW1FN _0x0,1630
	RJMP _0x566
; 0000 0BD8                             }
; 0000 0BD9                             else if(row==3){
_0x4A3:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x4A5
; 0000 0BDA                             lcd_putsf("3.VASAROS LAIKAS");
	__POINTW1FN _0x0,1650
	RJMP _0x566
; 0000 0BDB                             }
; 0000 0BDC                             else if(row==4){
_0x4A5:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x4A7
; 0000 0BDD                             lcd_putsf("4.LAIKO TIKSLINIMAS");
	__POINTW1FN _0x0,1667
	RJMP _0x566
; 0000 0BDE                             }
; 0000 0BDF                             else if(row==5){
_0x4A7:
	LDD  R26,Y+1
	CPI  R26,LOW(0x5)
	BRNE _0x4A9
; 0000 0BE0                             lcd_putsf("5.VALDIKLIO KODAS");
	__POINTW1FN _0x0,1687
	RJMP _0x566
; 0000 0BE1                             }
; 0000 0BE2                             else if(row==6){
_0x4A9:
	LDD  R26,Y+1
	CPI  R26,LOW(0x6)
	BRNE _0x4AB
; 0000 0BE3                             lcd_putsf("6.VALDIKLIO ISVADAI");
	__POINTW1FN _0x0,1705
_0x566:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0BE4                             }
; 0000 0BE5                         lcd_row++;
_0x4AB:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0BE6                         }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x49D
_0x49E:
; 0000 0BE7                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0000 0BE8                     lcd_putchar('<');
; 0000 0BE9                     }
; 0000 0BEA                 }
_0x49B:
; 0000 0BEB                 else if(Address[1]==1){
	RJMP _0x4AC
_0x493:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x4AD
; 0000 0BEC                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x4AE
; 0000 0BED                         if(lcd_light>0){
	CALL SUBOPT_0x33
	CPI  R30,LOW(0x1)
	BRLO _0x4AF
; 0000 0BEE                         lcd_light += -1;
	CALL SUBOPT_0x33
	SUBI R30,-LOW(255)
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	CALL __EEPROMWRB
; 0000 0BEF                         }
; 0000 0BF0                     }
_0x4AF:
; 0000 0BF1                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x4B0
_0x4AE:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x4B1
; 0000 0BF2                         if(lcd_light<100){
	CALL SUBOPT_0x33
	CPI  R30,LOW(0x64)
	BRSH _0x4B2
; 0000 0BF3                         lcd_light += 1;
	CALL SUBOPT_0x33
	SUBI R30,-LOW(1)
	LDI  R26,LOW(_lcd_light)
	LDI  R27,HIGH(_lcd_light)
	CALL __EEPROMWRB
; 0000 0BF4                         }
; 0000 0BF5                     }
_0x4B2:
; 0000 0BF6                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x4B3
_0x4B1:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x4B4
; 0000 0BF7                     Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 0BF8                     SelectedRow = 0;
; 0000 0BF9                     Address[5] = 0;
; 0000 0BFA                     }
; 0000 0BFB 
; 0000 0BFC                     if(RefreshLcd>=1){
_0x4B4:
_0x4B3:
_0x4B0:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x4B5
; 0000 0BFD                     lcd_putsf("-=EKRANO APSVIET.=- ");
	__POINTW1FN _0x0,1725
	CALL SUBOPT_0x2E
; 0000 0BFE                     lcd_putsf("APSVIETIMAS:");
	__POINTW1FN _0x0,1746
	CALL SUBOPT_0x2E
; 0000 0BFF                     lcd_put_number(0,3,0,0,lcd_light,0);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x33
	CALL SUBOPT_0x8A
; 0000 0C00                     lcd_putchar('%');
	LDI  R30,LOW(37)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0C01 
; 0000 0C02                     lcd_gotoxy(19,0);
	LDI  R30,LOW(19)
	CALL SUBOPT_0x49
; 0000 0C03                     lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0C04                     lcd_gotoxy(19,3);
	CALL SUBOPT_0x4C
; 0000 0C05                     lcd_putchar('-');
	LDI  R30,LOW(45)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0C06                     }
; 0000 0C07                 }
_0x4B5:
; 0000 0C08                 else if(Address[1]==2){
	RJMP _0x4B6
_0x4AD:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x4B7
; 0000 0C09                     if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BREQ PC+3
	JMP _0x4B8
; 0000 0C0A                         if(BUTTON[BUTTON_LEFT]==1){
	__GETB2MN _BUTTON_S000000F001,1
	CPI  R26,LOW(0x1)
	BRNE _0x4B9
; 0000 0C0B                         Address[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 0C0C                         }
; 0000 0C0D                         else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x4BA
_0x4B9:
	__GETB2MN _BUTTON_S000000F001,3
	CPI  R26,LOW(0x1)
	BRNE _0x4BB
; 0000 0C0E                         Address[3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,3
; 0000 0C0F                         }
; 0000 0C10                         else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x4BC
_0x4BB:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x4BD
; 0000 0C11                             if(Address[3]==0){
	__GETB1MN _Address_G000,3
	CPI  R30,0
	BRNE _0x4BE
; 0000 0C12                             Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 0C13                             }
; 0000 0C14                             else{
	RJMP _0x4BF
_0x4BE:
; 0000 0C15                             Address[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0C16                             }
_0x4BF:
; 0000 0C17                         Address[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 0C18                         Address[4] = 0;
	__PUTB1MN _Address_G000,4
; 0000 0C19                         SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0C1A                         Address[5] = 0;
; 0000 0C1B                         }
; 0000 0C1C 
; 0000 0C1D                         if(RefreshLcd>=1){
_0x4BD:
_0x4BC:
_0x4BA:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x4C0
; 0000 0C1E                         lcd_putsf("       VALYTI       ");
	__POINTW1FN _0x0,1759
	CALL SUBOPT_0x2E
; 0000 0C1F                         lcd_putsf("    SKAMBEJIMUS?    ");
	__POINTW1FN _0x0,1780
	CALL SUBOPT_0x2E
; 0000 0C20                         lcd_putsf("     NE     TAIP    ");
	__POINTW1FN _0x0,1801
	CALL SUBOPT_0x2E
; 0000 0C21                             if(Address[3]==0){
	__GETB1MN _Address_G000,3
	CPI  R30,0
	BRNE _0x4C1
; 0000 0C22                             lcd_putsf("     ^^            <");
	__POINTW1FN _0x0,1822
	RJMP _0x567
; 0000 0C23                             }
; 0000 0C24                             else{
_0x4C1:
; 0000 0C25                             lcd_putsf("            ^^^^   <");
	__POINTW1FN _0x0,1843
_0x567:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0C26                             }
; 0000 0C27                         }
; 0000 0C28 
; 0000 0C29                     }
_0x4C0:
; 0000 0C2A                     else{
	RJMP _0x4C3
_0x4B8:
; 0000 0C2B                         if(Address[4]>=3){
	__GETB2MN _Address_G000,4
	CPI  R26,LOW(0x3)
	BRLO _0x4C4
; 0000 0C2C                         Address[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,4
; 0000 0C2D                         Address[3]++;
	__GETB1MN _Address_G000,3
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,3
; 0000 0C2E                             if(Address[3]>=BELL_COUNT){
	__GETB2MN _Address_G000,3
	CPI  R26,LOW(0x14)
	BRLO _0x4C5
; 0000 0C2F                             Address[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
; 0000 0C30                             Address[2]++;
	__GETB1MN _Address_G000,2
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0C31                                 if(Address[2]>BELL_TYPE_COUNT){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0xF)
	BRLO _0x4C6
; 0000 0C32                                 Address[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,1
; 0000 0C33                                 Address[2] = 0;
	CALL SUBOPT_0xA9
; 0000 0C34 
; 0000 0C35                                 SelectedRow = 0;
; 0000 0C36                                 Address[5] = 0;
; 0000 0C37                                 }
; 0000 0C38                             }
_0x4C6:
; 0000 0C39                         }
_0x4C5:
; 0000 0C3A 
; 0000 0C3B                         if(RefreshLcd>=1){
_0x4C4:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x4C7
; 0000 0C3C                         lcd_clear();
	CALL _lcd_clear
; 0000 0C3D                         lcd_gotoxy(0,1);
	CALL SUBOPT_0x4E
; 0000 0C3E                         lcd_putsf("TRINAMI SKAMBEJIMAI:");
	__POINTW1FN _0x0,1864
	CALL SUBOPT_0x2E
; 0000 0C3F                         lcd_gotoxy(4,2);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x55
; 0000 0C40                         lcd_putsf("B / ");
	__POINTW1FN _0x0,1885
	CALL SUBOPT_0x2E
; 0000 0C41                         lcd_put_number(0,4,0,0,(BELL_TYPE_COUNT-1)*BELL_COUNT*3+(BELL_COUNT-1)*3+3,0);
	CALL SUBOPT_0xBB
	__GETD1N 0x348
	CALL SUBOPT_0x31
; 0000 0C42                         lcd_putsf("B");
	__POINTW1FN _0x0,1890
	CALL SUBOPT_0x2E
; 0000 0C43                         }
; 0000 0C44 
; 0000 0C45                         if(Address[2]>0){
_0x4C7:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRLO _0x4C8
; 0000 0C46                         unsigned int number;
; 0000 0C47                         BELL_TIME[Address[2]-1][Address[3]][Address[4]] = 0;
	SBIW R28,2
;	number -> Y+0
	CALL SUBOPT_0x84
	LDI  R26,LOW(60)
	LDI  R27,HIGH(60)
	CALL __MULW12U
	SUBI R30,LOW(-_BELL_TIME)
	SBCI R31,HIGH(-_BELL_TIME)
	CALL SUBOPT_0xBC
	CALL SUBOPT_0x90
	CALL SUBOPT_0xBD
	CALL SUBOPT_0x9B
; 0000 0C48                         number = (Address[2]-1)*BELL_COUNT*3 + Address[3]+Address[3]+Address[3] + Address[4] + 1;
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	CALL __MULW12
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12
	CALL SUBOPT_0xBC
	CALL SUBOPT_0xBE
	CALL SUBOPT_0xBE
	CALL SUBOPT_0xBD
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 0C49                         lcd_gotoxy(0,2);
	CALL SUBOPT_0x46
; 0000 0C4A                         lcd_put_number(0,4,0,0,number,0);
	CALL SUBOPT_0xBB
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x31
; 0000 0C4B                         Address[4]++;
	CALL SUBOPT_0x9A
; 0000 0C4C                         }
	ADIW R28,2
; 0000 0C4D                     }
_0x4C8:
_0x4C3:
; 0000 0C4E                 }
; 0000 0C4F                 else if(Address[1]==3){
	RJMP _0x4C9
_0x4B7:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0x4CA
; 0000 0C50                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x4CB
; 0000 0C51                         if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x4CC
; 0000 0C52                         Address[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0C53                         }
; 0000 0C54                     }
_0x4CC:
; 0000 0C55                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x4CD
_0x4CB:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x4CE
; 0000 0C56                         if(Address[2]!=0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BREQ _0x4CF
; 0000 0C57                         Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
; 0000 0C58                         }
; 0000 0C59                     }
_0x4CF:
; 0000 0C5A                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x4D0
_0x4CE:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x4D1
; 0000 0C5B                         if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x4D2
; 0000 0C5C                         Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 0C5D                         SelectedRow = 0;
; 0000 0C5E                         Address[5] = 0;
; 0000 0C5F                         }
; 0000 0C60                         else{
	RJMP _0x4D3
_0x4D2:
; 0000 0C61                             if(SUMMER_TIME_TURNED_ON==0){
	CALL SUBOPT_0x35
	CPI  R30,0
	BRNE _0x4D4
; 0000 0C62                             SUMMER_TIME_TURNED_ON = 1;
	LDI  R26,LOW(_SUMMER_TIME_TURNED_ON)
	LDI  R27,HIGH(_SUMMER_TIME_TURNED_ON)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0C63                             IS_CLOCK_SUMMER = IsSummerTime(RealTimeMonth, RealTimeDay, RealTimeWeekDay);
	CALL SUBOPT_0x3C
	LDI  R26,LOW(_IS_CLOCK_SUMMER)
	LDI  R27,HIGH(_IS_CLOCK_SUMMER)
	RJMP _0x568
; 0000 0C64                             }
; 0000 0C65                             else{
_0x4D4:
; 0000 0C66                             SUMMER_TIME_TURNED_ON = 0;
	LDI  R26,LOW(_SUMMER_TIME_TURNED_ON)
	LDI  R27,HIGH(_SUMMER_TIME_TURNED_ON)
	LDI  R30,LOW(0)
_0x568:
	CALL __EEPROMWRB
; 0000 0C67                             }
; 0000 0C68                         }
_0x4D3:
; 0000 0C69                     }
; 0000 0C6A 
; 0000 0C6B                     if(RefreshLcd>=1){
_0x4D1:
_0x4D0:
_0x4CD:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x4D6
; 0000 0C6C                     lcd_putsf(" -=VASAROS LAIKAS=- ");
	__POINTW1FN _0x0,1892
	CALL SUBOPT_0x2E
; 0000 0C6D                     lcd_putsf("PADETIS: ");
	__POINTW1FN _0x0,1913
	CALL SUBOPT_0x2E
; 0000 0C6E                         if(SUMMER_TIME_TURNED_ON==0){
	CALL SUBOPT_0x35
	CPI  R30,0
	BRNE _0x4D7
; 0000 0C6F                         lcd_putsf("ISJUNGTAS");
	__POINTW1FN _0x0,1923
	RJMP _0x569
; 0000 0C70                         }
; 0000 0C71                         else{
_0x4D7:
; 0000 0C72                         lcd_putsf("IJUNGTAS");
	__POINTW1FN _0x0,1933
_0x569:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0C73                         }
; 0000 0C74 
; 0000 0C75                         if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x4D9
; 0000 0C76                         lcd_gotoxy(19,0);
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x56A
; 0000 0C77                         lcd_putchar('<');
; 0000 0C78                         }
; 0000 0C79                         else{
_0x4D9:
; 0000 0C7A                         lcd_gotoxy(19,1);
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x56A:
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0C7B                         lcd_putchar('<');
	LDI  R30,LOW(60)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0C7C                         }
; 0000 0C7D                     }
; 0000 0C7E                 }
_0x4D6:
; 0000 0C7F                 else if(Address[1]==4){
	RJMP _0x4DB
_0x4CA:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x4DC
; 0000 0C80                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x4DD
; 0000 0C81                         if(RealTimePrecisioningValue>-20){
	CALL SUBOPT_0x39
	MOV  R26,R30
	LDI  R30,LOW(236)
	CP   R30,R26
	BRGE _0x4DE
; 0000 0C82                         RealTimePrecisioningValue--;
	CALL SUBOPT_0x39
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
; 0000 0C83                         }
; 0000 0C84                         else{
	RJMP _0x4DF
_0x4DE:
; 0000 0C85                         RealTimePrecisioningValue = -20;
	LDI  R26,LOW(_RealTimePrecisioningValue)
	LDI  R27,HIGH(_RealTimePrecisioningValue)
	LDI  R30,LOW(236)
	CALL __EEPROMWRB
; 0000 0C86                         }
_0x4DF:
; 0000 0C87                     }
; 0000 0C88                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x4E0
_0x4DD:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x4E1
; 0000 0C89                         if(RealTimePrecisioningValue<20){
	CALL SUBOPT_0x39
	CPI  R30,LOW(0x14)
	BRGE _0x4E2
; 0000 0C8A                         RealTimePrecisioningValue++;
	CALL SUBOPT_0x39
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 0C8B                         }
; 0000 0C8C                         else{
	RJMP _0x4E3
_0x4E2:
; 0000 0C8D                         RealTimePrecisioningValue = 20;
	LDI  R26,LOW(_RealTimePrecisioningValue)
	LDI  R27,HIGH(_RealTimePrecisioningValue)
	LDI  R30,LOW(20)
	CALL __EEPROMWRB
; 0000 0C8E                         }
_0x4E3:
; 0000 0C8F                     }
; 0000 0C90                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x4E4
_0x4E1:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x4E5
; 0000 0C91                     Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 0C92                     SelectedRow = 0;
; 0000 0C93                     Address[5] = 0;
; 0000 0C94                     }
; 0000 0C95 
; 0000 0C96                     if(RefreshLcd>=1){
_0x4E5:
_0x4E4:
_0x4E0:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x4E6
; 0000 0C97                     lcd_putsf("  -=TIKSLINIMAS=-  +");
	__POINTW1FN _0x0,1942
	CALL SUBOPT_0x2E
; 0000 0C98                     lcd_putsf("LAIKO TIKSLINIMAS   ");
	__POINTW1FN _0x0,1963
	CALL SUBOPT_0x2E
; 0000 0C99                     lcd_putsf("SEKUNDEMIS PER      ");
	__POINTW1FN _0x0,1984
	CALL SUBOPT_0x2E
; 0000 0C9A                     lcd_putsf("SAVAITE: ");
	__POINTW1FN _0x0,2005
	CALL SUBOPT_0x2E
; 0000 0C9B                     lcd_put_number(1,2,1,0,0,RealTimePrecisioningValue);
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
; 0000 0C9C                     lcd_putsf(" SEC.  -");
	__POINTW1FN _0x0,2015
	CALL SUBOPT_0x2E
; 0000 0C9D                     }
; 0000 0C9E                 }
_0x4E6:
; 0000 0C9F                 else if(Address[1]==5){
	RJMP _0x4E7
_0x4DC:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x5)
	BREQ PC+3
	JMP _0x4E8
; 0000 0CA0                     if(BUTTON[BUTTON_LEFT]==1){
	__GETB2MN _BUTTON_S000000F001,1
	CPI  R26,LOW(0x1)
	BRNE _0x4E9
; 0000 0CA1                         if(Address[2]>1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRLO _0x4EA
; 0000 0CA2                         Address[2]--;
	__GETB1MN _Address_G000,2
	SUBI R30,LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0CA3                         }
; 0000 0CA4                     }
_0x4EA:
; 0000 0CA5                     else if(BUTTON[BUTTON_RIGHT]==1){
	RJMP _0x4EB
_0x4E9:
	__GETB2MN _BUTTON_S000000F001,3
	CPI  R26,LOW(0x1)
	BRNE _0x4EC
; 0000 0CA6                         if(Address[2]<4){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRSH _0x4ED
; 0000 0CA7                         Address[2]++;
	__GETB1MN _Address_G000,2
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0CA8                         }
; 0000 0CA9                     }
_0x4ED:
; 0000 0CAA                     else if(BUTTON[BUTTON_DOWN]==1){
	RJMP _0x4EE
_0x4EC:
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x4EF
; 0000 0CAB                         if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x4F0
; 0000 0CAC                         SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0CAD                             if(SelectedRow==2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x4F1
; 0000 0CAE                             SelectAnotherRow(0);
	CALL SUBOPT_0x72
; 0000 0CAF                             }
; 0000 0CB0                         }
_0x4F1:
; 0000 0CB1                         else if(Address[2]==1){
	RJMP _0x4F2
_0x4F0:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x4F3
; 0000 0CB2                             if(entering_code>=1000){
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLO _0x4F4
; 0000 0CB3                             entering_code += -1000;
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 0CB4                             }
; 0000 0CB5                         }
_0x4F4:
; 0000 0CB6                         else if(Address[2]==2){
	RJMP _0x4F5
_0x4F3:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x4F6
; 0000 0CB7                         unsigned int a;
; 0000 0CB8                         a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x5E
;	a -> Y+0
; 0000 0CB9                             if(a>=100){
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0x4F7
; 0000 0CBA                             entering_code += -100;
	CALL SUBOPT_0x5F
; 0000 0CBB                             }
; 0000 0CBC                         }
_0x4F7:
	RJMP _0x56B
; 0000 0CBD                         else if(Address[2]==3){
_0x4F6:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x4F9
; 0000 0CBE                         unsigned int a;
; 0000 0CBF                         a = entering_code - ((entering_code/100) * 100);
	CALL SUBOPT_0x60
;	a -> Y+0
; 0000 0CC0                             if(a>=10){
	BRLO _0x4FA
; 0000 0CC1                             entering_code += -10;
	CALL SUBOPT_0x61
; 0000 0CC2                             }
; 0000 0CC3                         }
_0x4FA:
	RJMP _0x56B
; 0000 0CC4                         else if(Address[2]==4){
_0x4F9:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x4FC
; 0000 0CC5                         unsigned int a;
; 0000 0CC6                         a = entering_code - ((entering_code/10) * 10);
	CALL SUBOPT_0x62
;	a -> Y+0
; 0000 0CC7                             if(a>=1){
	BRLO _0x4FD
; 0000 0CC8                             entering_code += -1;
	CALL SUBOPT_0x63
; 0000 0CC9                             }
; 0000 0CCA                         }
_0x4FD:
_0x56B:
	ADIW R28,2
; 0000 0CCB                     }
_0x4FC:
_0x4F5:
_0x4F2:
; 0000 0CCC                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x4FE
_0x4EF:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x4FF
; 0000 0CCD                         if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x500
; 0000 0CCE                         SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0CCF                             if(SelectedRow==2){
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x2)
	BRNE _0x501
; 0000 0CD0                             SelectAnotherRow(1);
	CALL SUBOPT_0x73
; 0000 0CD1                             }
; 0000 0CD2                         }
_0x501:
; 0000 0CD3                         else if(Address[2]==1){
	RJMP _0x502
_0x500:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x503
; 0000 0CD4                             if(entering_code<9000){
	CALL SUBOPT_0x5B
	CPI  R26,LOW(0x2328)
	LDI  R30,HIGH(0x2328)
	CPC  R27,R30
	BRSH _0x504
; 0000 0CD5                             entering_code += 1000;
	CALL SUBOPT_0x64
; 0000 0CD6                             }
; 0000 0CD7                         }
_0x504:
; 0000 0CD8                         else if(Address[2]==2){
	RJMP _0x505
_0x503:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x506
; 0000 0CD9                         unsigned int a;
; 0000 0CDA                         a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x5E
;	a -> Y+0
; 0000 0CDB                             if(a<900){
	CPI  R26,LOW(0x384)
	LDI  R30,HIGH(0x384)
	CPC  R27,R30
	BRSH _0x507
; 0000 0CDC                             entering_code += 100;
	CALL SUBOPT_0x65
; 0000 0CDD                             }
; 0000 0CDE                         }
_0x507:
	ADIW R28,2
; 0000 0CDF                         else if(Address[2]==3){
	RJMP _0x508
_0x506:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x509
; 0000 0CE0                         unsigned char a;
; 0000 0CE1                         a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x66
;	a -> Y+0
; 0000 0CE2                         a = a - ((a/100) * 100);
	CALL SUBOPT_0x67
; 0000 0CE3                             if(a<90){
	LD   R26,Y
	CPI  R26,LOW(0x5A)
	BRSH _0x50A
; 0000 0CE4                             entering_code += 10;
	CALL SUBOPT_0x68
; 0000 0CE5                             }
; 0000 0CE6                         }
_0x50A:
	RJMP _0x56C
; 0000 0CE7                         else if(Address[2]==4){
_0x509:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x50C
; 0000 0CE8                         unsigned char a;
; 0000 0CE9                         a = entering_code - ((entering_code/1000) * 1000);
	CALL SUBOPT_0x66
;	a -> Y+0
; 0000 0CEA                         a = a - ((a/100) * 100);
	CALL SUBOPT_0x67
; 0000 0CEB                         a = a - ((a/10) * 10);
	LDD  R22,Y+0
	CLR  R23
	CALL SUBOPT_0x44
	CALL SUBOPT_0x69
; 0000 0CEC                             if(a<9){
	BRSH _0x50D
; 0000 0CED                             entering_code += 1;
	CALL SUBOPT_0x6A
; 0000 0CEE                             }
; 0000 0CEF                         }
_0x50D:
_0x56C:
	ADIW R28,1
; 0000 0CF0                     }
_0x50C:
_0x508:
_0x505:
_0x502:
; 0000 0CF1                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x50E
_0x4FF:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x50F
; 0000 0CF2                         if(SelectedRow==0){
	LDS  R30,_SelectedRow_G000
	CPI  R30,0
	BRNE _0x510
; 0000 0CF3                         Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 0CF4                         SelectedRow = 0;
; 0000 0CF5                         Address[5] = 0;
; 0000 0CF6                         }
; 0000 0CF7                         else if(SelectedRow==1){
	RJMP _0x511
_0x510:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x1)
	BRNE _0x512
; 0000 0CF8                             if(IS_LOCK_TURNED_ON==1){
	CALL SUBOPT_0x37
	CPI  R30,LOW(0x1)
	BRNE _0x513
; 0000 0CF9                             IS_LOCK_TURNED_ON = 0;
	LDI  R26,LOW(_IS_LOCK_TURNED_ON)
	LDI  R27,HIGH(_IS_LOCK_TURNED_ON)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0CFA                             CODE = 0;
	CALL SUBOPT_0x38
; 0000 0CFB                             }
; 0000 0CFC                             else{
	RJMP _0x514
_0x513:
; 0000 0CFD                             IS_LOCK_TURNED_ON = 1;
	LDI  R26,LOW(_IS_LOCK_TURNED_ON)
	LDI  R27,HIGH(_IS_LOCK_TURNED_ON)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0CFE                             CODE = 0;
	CALL SUBOPT_0x38
; 0000 0CFF                             UNLOCKED = 1;
	LDI  R30,LOW(1)
	STS  _UNLOCKED_S000000F000,R30
; 0000 0D00                             }
_0x514:
; 0000 0D01                         SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0D02                         Address[5] = 0;
; 0000 0D03                         }
; 0000 0D04                         else if(SelectedRow==3){
	RJMP _0x515
_0x512:
	LDS  R26,_SelectedRow_G000
	CPI  R26,LOW(0x3)
	BRNE _0x516
; 0000 0D05                             if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x517
; 0000 0D06                             Address[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address_G000,2
; 0000 0D07                             }
; 0000 0D08                             else{
	RJMP _0x518
_0x517:
; 0000 0D09                             Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
; 0000 0D0A                             CODE = entering_code;
	CALL SUBOPT_0x5C
	LDI  R26,LOW(_CODE)
	LDI  R27,HIGH(_CODE)
	CALL __EEPROMWRW
; 0000 0D0B                             UNLOCKED = 1;
	LDI  R30,LOW(1)
	STS  _UNLOCKED_S000000F000,R30
; 0000 0D0C 
; 0000 0D0D                             SelectedRow = 0;
	CALL SUBOPT_0x74
; 0000 0D0E                             Address[5] = 0;
; 0000 0D0F                             }
_0x518:
; 0000 0D10                         entering_code = 0;
	CALL SUBOPT_0x6B
; 0000 0D11                         }
; 0000 0D12                     }
_0x516:
_0x515:
_0x511:
; 0000 0D13 
; 0000 0D14                     if(RefreshLcd>=1){
_0x50F:
_0x50E:
_0x4FE:
_0x4EE:
_0x4EB:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x519
; 0000 0D15                     lcd_putsf("     -=KODAS=-      ");
	__POINTW1FN _0x0,2024
	CALL SUBOPT_0x2E
; 0000 0D16                         if(IS_LOCK_TURNED_ON==1){
	CALL SUBOPT_0x37
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x51A
; 0000 0D17                         RowsOnWindow = 4;
	LDI  R30,LOW(4)
	STS  _RowsOnWindow_G000,R30
; 0000 0D18                         lcd_putsf("1.ISJUNGTI KODA?    ");
	__POINTW1FN _0x0,2045
	CALL SUBOPT_0x2E
; 0000 0D19                         lcd_putsf("2.KODAS:     ");
	__POINTW1FN _0x0,2066
	CALL SUBOPT_0x2E
; 0000 0D1A                             if(Address[2]==0){
	__GETB1MN _Address_G000,2
	CPI  R30,0
	BRNE _0x51B
; 0000 0D1B                             lcd_putsf("****   ");
	__POINTW1FN _0x0,2080
	CALL SUBOPT_0x2E
; 0000 0D1C                             lcd_putsf("         REDAGUOTI?");
	__POINTW1FN _0x0,2088
	CALL SUBOPT_0x2E
; 0000 0D1D                             }
; 0000 0D1E                             else{
	RJMP _0x51C
_0x51B:
; 0000 0D1F                             unsigned int i;
; 0000 0D20                             lcd_gotoxy(13,2);
	SBIW R28,2
;	i -> Y+0
	LDI  R30,LOW(13)
	CALL SUBOPT_0x55
; 0000 0D21                             i = entering_code;
	CALL SUBOPT_0x5C
	ST   Y,R30
	STD  Y+1,R31
; 0000 0D22                                 if(Address[2]==1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x51D
; 0000 0D23                                 lcd_putchar( NumToIndex( i/1000) );
	CALL SUBOPT_0x6C
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x56D
; 0000 0D24                                 }
; 0000 0D25                                 else{
_0x51D:
; 0000 0D26                                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x56D:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0D27                                 }
; 0000 0D28                             i = i - (i/1000)*1000;
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
; 0000 0D29                                 if(Address[2]==2){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x51F
; 0000 0D2A                                 lcd_putchar( NumToIndex( i/100) );
	CALL SUBOPT_0x6E
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x56E
; 0000 0D2B                                 }
; 0000 0D2C                                 else{
_0x51F:
; 0000 0D2D                                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x56E:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0D2E                                 }
; 0000 0D2F                             i = i - (i/100)*100;
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6F
; 0000 0D30                                 if(Address[2]==3){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x521
; 0000 0D31                                 lcd_putchar( NumToIndex( i/10) );
	CALL SUBOPT_0x70
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x56F
; 0000 0D32                                 }
; 0000 0D33                                 else{
_0x521:
; 0000 0D34                                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x56F:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0D35                                 }
; 0000 0D36                             i = i - (i/10)*10;
	CALL SUBOPT_0x70
	CALL SUBOPT_0x71
; 0000 0D37                                 if(Address[2]==4){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x523
; 0000 0D38                                 lcd_putchar( NumToIndex(i) );
	LD   R30,Y
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x570
; 0000 0D39                                 }
; 0000 0D3A                                 else{
_0x523:
; 0000 0D3B                                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x570:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0D3C                                 }
; 0000 0D3D                             lcd_gotoxy(0,3);
	CALL SUBOPT_0x2F
	CALL _lcd_gotoxy
; 0000 0D3E                                 if(Address[2]==1){
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x1)
	BRNE _0x525
; 0000 0D3F                                 lcd_putsf("             ^");
	__POINTW1FN _0x0,1142
	RJMP _0x571
; 0000 0D40                                 }
; 0000 0D41                                 else if(Address[2]==2){
_0x525:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x2)
	BRNE _0x527
; 0000 0D42                                 lcd_putsf("              ^");
	__POINTW1FN _0x0,1141
	RJMP _0x571
; 0000 0D43                                 }
; 0000 0D44                                 else if(Address[2]==3){
_0x527:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x3)
	BRNE _0x529
; 0000 0D45                                 lcd_putsf("               ^");
	__POINTW1FN _0x0,1140
	RJMP _0x571
; 0000 0D46                                 }
; 0000 0D47                                 else if(Address[2]==4){
_0x529:
	__GETB2MN _Address_G000,2
	CPI  R26,LOW(0x4)
	BRNE _0x52B
; 0000 0D48                                 lcd_putsf("                ^");
	__POINTW1FN _0x0,1157
_0x571:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0D49                                 }
; 0000 0D4A                             }
_0x52B:
	ADIW R28,2
_0x51C:
; 0000 0D4B                         }
; 0000 0D4C                         else{
	RJMP _0x52C
_0x51A:
; 0000 0D4D                         RowsOnWindow = 2;
	LDI  R30,LOW(2)
	STS  _RowsOnWindow_G000,R30
; 0000 0D4E                         lcd_putsf("1. IJUNGTI KODA?");
	__POINTW1FN _0x0,2108
	CALL SUBOPT_0x2E
; 0000 0D4F                         }
_0x52C:
; 0000 0D50                     lcd_gotoxy(19,SelectedRow-Address[5]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0xA7
; 0000 0D51                     lcd_putchar('<');
; 0000 0D52                     }
; 0000 0D53                 }
_0x519:
; 0000 0D54                 else if(Address[1]==6){
	RJMP _0x52D
_0x4E8:
	__GETB2MN _Address_G000,1
	CPI  R26,LOW(0x6)
	BREQ PC+3
	JMP _0x52E
; 0000 0D55                     if(BUTTON[BUTTON_DOWN]==1){
	__GETB2MN _BUTTON_S000000F001,4
	CPI  R26,LOW(0x1)
	BRNE _0x52F
; 0000 0D56                         if(BELL_OUTPUT_ADDRESS>17){
	CALL SUBOPT_0x34
	CPI  R30,LOW(0x12)
	BRLO _0x530
; 0000 0D57                         BELL_OUTPUT_ADDRESS--;
	CALL SUBOPT_0x34
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
; 0000 0D58                         }
; 0000 0D59                     }
_0x530:
; 0000 0D5A                     else if(BUTTON[BUTTON_UP]==1){
	RJMP _0x531
_0x52F:
	LDS  R26,_BUTTON_S000000F001
	CPI  R26,LOW(0x1)
	BRNE _0x532
; 0000 0D5B                         if(BELL_OUTPUT_ADDRESS<22){
	CALL SUBOPT_0x34
	CPI  R30,LOW(0x16)
	BRSH _0x533
; 0000 0D5C                         BELL_OUTPUT_ADDRESS++;
	CALL SUBOPT_0x34
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 0D5D                         }
; 0000 0D5E                     }
_0x533:
; 0000 0D5F                     else if(BUTTON[BUTTON_ENTER]==1){
	RJMP _0x534
_0x532:
	__GETB2MN _BUTTON_S000000F001,2
	CPI  R26,LOW(0x1)
	BRNE _0x535
; 0000 0D60                     Address[1] = 0;
	CALL SUBOPT_0x7C
; 0000 0D61                     SelectedRow = 0;
; 0000 0D62                     Address[5] = 0;
; 0000 0D63                     }
; 0000 0D64 
; 0000 0D65                     if(RefreshLcd>=1){
_0x535:
_0x534:
_0x531:
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x536
; 0000 0D66                     lcd_putsf("    -=ISVADAI=-    +");
	__POINTW1FN _0x0,2125
	CALL SUBOPT_0x2E
; 0000 0D67                     lcd_putsf("1. VARPU ISEJ.: ");
	__POINTW1FN _0x0,2146
	CALL SUBOPT_0x2E
; 0000 0D68                     lcd_put_number(0,2,0,0,BELL_OUTPUT_ADDRESS,0);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x34
	CALL SUBOPT_0x8A
; 0000 0D69                     lcd_putsf(" <");
	__POINTW1FN _0x0,1840
	CALL SUBOPT_0x2E
; 0000 0D6A                     lcd_gotoxy(19,3);lcd_putchar('-');
	CALL SUBOPT_0x4C
	LDI  R30,LOW(45)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0D6B                     }
; 0000 0D6C                 }
_0x536:
; 0000 0D6D             }
_0x52E:
_0x52D:
_0x4E7:
_0x4DB:
_0x4C9:
_0x4B6:
_0x4AC:
; 0000 0D6E         }
_0x492:
_0x491:
_0x22E:
_0x1D0:
_0x194:
_0x17F:
_0x14E:
; 0000 0D6F 
; 0000 0D70         if(RefreshLcd>=1){
	LDS  R26,_RefreshLcd_G000
	CPI  R26,LOW(0x1)
	BRLO _0x537
; 0000 0D71         RefreshLcd--;
	LDS  R30,_RefreshLcd_G000
	SUBI R30,LOW(1)
	STS  _RefreshLcd_G000,R30
; 0000 0D72         }
; 0000 0D73     //////////////////////////////////////////////////////////////////////////////////
; 0000 0D74     //////////////////////////////////////////////////////////////////////////////////
; 0000 0D75     //////////////////////////////////////////////////////////////////////////////////
; 0000 0D76     TimeRefreshed = 0;
_0x537:
	LDI  R30,LOW(0)
	STS  _TimeRefreshed_S000000F001,R30
; 0000 0D77     delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0D78     }
	JMP  _0xE1
; 0000 0D79 }
_0x538:
	RJMP _0x538

	.CSEG
_rtc_read:
	ST   -Y,R17
	CALL SUBOPT_0xBF
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xC1
	MOV  R17,R30
	CALL _i2c_stop
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2060003
_rtc_write:
	CALL SUBOPT_0xBF
	LD   R30,Y
	CALL SUBOPT_0xC2
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
	CALL SUBOPT_0xC3
	LDI  R30,LOW(7)
	CALL SUBOPT_0xC4
	CALL SUBOPT_0xC2
	JMP  _0x2060002
_rtc_get_time:
	CALL SUBOPT_0xC3
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_write
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xC5
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	CALL SUBOPT_0xC5
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	CALL SUBOPT_0xC1
	ST   -Y,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RJMP _0x2060004
_rtc_set_time:
	CALL SUBOPT_0xC3
	LDI  R30,LOW(0)
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xC7
	CALL SUBOPT_0xC4
	ST   -Y,R30
	CALL _bin2bcd
	CALL SUBOPT_0xC2
	JMP  _0x2060002
_rtc_get_date:
	CALL SUBOPT_0xC3
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _i2c_write
	CALL SUBOPT_0xC0
	CALL SUBOPT_0xC5
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0xC5
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	CALL SUBOPT_0xC1
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
	CALL SUBOPT_0xC3
	LDI  R30,LOW(4)
	CALL SUBOPT_0xC4
	ST   -Y,R30
	CALL _bin2bcd
	CALL SUBOPT_0xC7
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xC2
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
	CALL SUBOPT_0xC8
	CALL SUBOPT_0xC8
	CALL SUBOPT_0xC8
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0xC9
	LDI  R30,LOW(4)
	CALL SUBOPT_0xC9
	LDI  R30,LOW(133)
	CALL SUBOPT_0xC9
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
	.BYTE 0x348

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
_STAND_BY_S000000F000:
	.BYTE 0x1
_UNLOCKED_S000000F000:
	.BYTE 0x1
_SecondCounter_S000000F001:
	.BYTE 0x2
_TimeRefreshed_S000000F001:
	.BYTE 0x1
_TIME_EDITING_S000000F002:
	.BYTE 0x1
_CALL_BELL_S000000F004:
	.BYTE 0x2
_BUTTON_S000000F001:
	.BYTE 0x5
_ButtonFilter_S000000F001:
	.BYTE 0x5
_lcd_led_counter_S000000F001:
	.BYTE 0x1
_stand_by_pos_S000000F002:
	.BYTE 0x2
_entering_code_S000000F002:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 46 TIMES, CODE SIZE REDUCTION:87 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x1D:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 227 TIMES, CODE SIZE REDUCTION:449 WORDS
SUBOPT_0x1E:
	LDI  R31,0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1F:
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:78 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 137 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x2E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 61 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 59 TIMES, CODE SIZE REDUCTION:461 WORDS
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
	LDD  R30,Y+4
	LDI  R26,LOW(60)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_BELL_TIME)
	SBCI R31,HIGH(-_BELL_TIME)
	MOVW R26,R30
	LDD  R30,Y+5
	LDI  R31,0
	MOVW R22,R26
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 45 TIMES, CODE SIZE REDUCTION:129 WORDS
SUBOPT_0x40:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:165 WORDS
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
	SUBI R30,LOW(-_ButtonFilter_S000000F001)
	SBCI R31,HIGH(-_ButtonFilter_S000000F001)
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
	SUBI R30,LOW(-_BUTTON_S000000F001)
	SBCI R31,HIGH(-_BUTTON_S000000F001)
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 42 TIMES, CODE SIZE REDUCTION:161 WORDS
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
	LDS  R26,_entering_code_S000000F002
	LDS  R27,_entering_code_S000000F002+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x5C:
	LDS  R30,_entering_code_S000000F002
	LDS  R31,_entering_code_S000000F002+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	SUBI R30,LOW(-64536)
	SBCI R31,HIGH(-64536)
	STS  _entering_code_S000000F002,R30
	STS  _entering_code_S000000F002+1,R31
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
	STS  _entering_code_S000000F002,R30
	STS  _entering_code_S000000F002+1,R31
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
	STS  _entering_code_S000000F002,R30
	STS  _entering_code_S000000F002+1,R31
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
	STS  _entering_code_S000000F002,R30
	STS  _entering_code_S000000F002+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x64:
	RCALL SUBOPT_0x5C
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	STS  _entering_code_S000000F002,R30
	STS  _entering_code_S000000F002+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x65:
	RCALL SUBOPT_0x5C
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _entering_code_S000000F002,R30
	STS  _entering_code_S000000F002+1,R31
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
	STS  _entering_code_S000000F002,R30
	STS  _entering_code_S000000F002+1,R31
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
	STS  _entering_code_S000000F002,R30
	STS  _entering_code_S000000F002+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	LDI  R30,LOW(0)
	STS  _entering_code_S000000F002,R30
	STS  _entering_code_S000000F002+1,R30
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x72:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _SelectAnotherRow

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x73:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _SelectAnotherRow

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:133 WORDS
SUBOPT_0x74:
	LDI  R30,LOW(0)
	STS  _SelectedRow_G000,R30
	__PUTB1MN _Address_G000,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x75:
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	LDI  R30,LOW(5)
	STS  _RowsOnWindow_G000,R30
	__GETB1MN _Address_G000,5
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x76:
	ADIW R30,4
	LDD  R26,Y+1
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x77:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDD  R30,Y+1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:72 WORDS
SUBOPT_0x78:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDS  R26,_SelectedRow_G000
	CLR  R27
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:77 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x80:
	LDI  R31,0
	SBIW R30,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x81:
	__POINTW1FN _0x0,581
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x82:
	LDS  R30,_SelectedRow_G000
	__PUTB1MN _Address_G000,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x83:
	STS  _RowsOnWindow_G000,R30
	__GETB1MN _Address_G000,5
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 49 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x84:
	__GETB1MN _Address_G000,2
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x85:
	ST   -Y,R30
	CALL _GetBellId
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x86:
	ST   -Y,R30
	LDD  R30,Y+3
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0x87:
	CALL __CWD1
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x88:
	__POINTW1FN _0x0,465
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0x89:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x8A:
	LDI  R31,0
	RJMP SUBOPT_0x87

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8B:
	LDI  R30,LOW(58)
	ST   -Y,R30
	CALL _lcd_putchar
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x8C:
	__POINTW1FN _0x0,1104
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 118 TIMES, CODE SIZE REDUCTION:1050 WORDS
SUBOPT_0x8D:
	LDI  R26,LOW(60)
	LDI  R27,HIGH(60)
	CALL __MULW12U
	SUBI R30,LOW(-_BELL_TIME)
	SBCI R31,HIGH(-_BELL_TIME)
	MOVW R26,R30
	__GETB1MN _Address_G000,3
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:237 WORDS
SUBOPT_0x8E:
	MOVW R22,R26
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R26,R22
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:237 WORDS
SUBOPT_0x8F:
	MOVW R22,R26
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R26,R22
	RJMP SUBOPT_0x40

;OPTIMIZER ADDED SUBROUTINE, CALLED 78 TIMES, CODE SIZE REDUCTION:305 WORDS
SUBOPT_0x90:
	MOVW R22,R26
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x91:
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	MOVW R26,R30
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:78 WORDS
SUBOPT_0x92:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x93:
	SBIW R30,10
	MOVW R26,R30
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 49 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x94:
	LDI  R31,0
	ADIW R30,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x95:
	LDI  R31,0
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x96:
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x97:
	ADIW R30,10
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x98:
	ADIW R30,1
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x99:
	__GETB1MN _Address_G000,4
	SUBI R30,LOW(1)
	__PUTB1MN _Address_G000,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9A:
	__GETB1MN _Address_G000,4
	SUBI R30,-LOW(1)
	__PUTB1MN _Address_G000,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9B:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9C:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x84

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9D:
	__POINTW1FN _0x0,1119
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x9E:
	LDI  R30,LOW(41)
	ST   -Y,R30
	CALL _lcd_putchar
	__POINTW1FN _0x0,102
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9F:
	__POINTW1FN _0x0,303
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA0:
	__POINTW1FN _0x0,313
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA1:
	__POINTW1FN _0x0,324
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA2:
	__POINTW1FN _0x0,337
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA3:
	__POINTW1FN _0x0,1140
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA4:
	__POINTW1FN _0x0,1157
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA5:
	__POINTW1FN _0x0,1175
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA6:
	__POINTW1FN _0x0,1194
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xA7:
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _lcd_gotoxy
	LDI  R30,LOW(60)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA8:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,3
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA9:
	LDI  R30,LOW(0)
	__PUTB1MN _Address_G000,2
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAA:
	LDS  R30,_SelectedRow_G000
	__PUTB1MN _Address_G000,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xAB:
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	LDI  R30,LOW(20)
	RJMP SUBOPT_0x83

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAC:
	__GETB1MN _Address_G000,2
	LDI  R31,0
	ADIW R30,6
	RJMP SUBOPT_0x89

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:213 WORDS
SUBOPT_0xAD:
	__GETB1MN _Address_G000,2
	LDI  R31,0
	ADIW R30,6
	RJMP SUBOPT_0x8D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xAE:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0xAD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAF:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0xAD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB0:
	MOV  R30,R5
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB1:
	CALL _GetEasterMonth
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB2:
	CALL _GetEasterDay
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB3:
	MOV  R30,R5
	LDI  R31,0
	ADIW R30,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0xB4:
	__GETB1MN _Address_G000,2
	RJMP SUBOPT_0x94

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB5:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0xB4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB6:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0xB4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB7:
	__POINTW2MN _BELL_TIME,780
	LDD  R30,Y+4
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:141 WORDS
SUBOPT_0xB8:
	__POINTW2MN _BELL_TIME,780
	__GETB1MN _Address_G000,3
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB9:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0xB8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBA:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RJMP SUBOPT_0xB8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBB:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBC:
	MOVW R26,R30
	__GETB1MN _Address_G000,3
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xBD:
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _Address_G000,4
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xBE:
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _Address_G000,3
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBF:
	CALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+1
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC0:
	CALL _i2c_start
	LDI  R30,LOW(209)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC2:
	ST   -Y,R30
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC3:
	CALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC4:
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xC5:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC6:
	ST   -Y,R30
	CALL _i2c_write
	LD   R30,Y
	ST   -Y,R30
	JMP  _bin2bcd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC7:
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+1
	ST   -Y,R30
	JMP  _bin2bcd

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC8:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC9:
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
