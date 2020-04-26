
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 4.000000 MHz
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
	.DEF _RealTimeSecond=R5
	.DEF _RefreshLcd=R4
	.DEF _PAGRINDINIS_LANGAS=R7
	.DEF _Call_1Second=R6
	.DEF _MenuRow=R9
	.DEF _MenuLowestRow=R8
	.DEF _MenuHighestRow=R11
	.DEF _MenuColumn=R10
	.DEF _MenuLowestColumn=R13
	.DEF _MenuHighestColumn=R12

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
	.DB  0x45,0x52,0x52,0x4F,0x52,0x3A,0x0,0x43
	.DB  0x52,0x45,0x41,0x54,0x49,0x4E,0x47,0x20
	.DB  0x4D,0x45,0x4E,0x55,0x20,0x52,0x4F,0x57
	.DB  0x20,0x46,0x41,0x49,0x4C,0x45,0x44,0x2E
	.DB  0x0,0x20,0x50,0x41,0x47,0x52,0x49,0x4E
	.DB  0x44,0x49,0x4E,0x49,0x53,0x20,0x4D,0x45
	.DB  0x4E,0x49,0x55,0x0,0x31,0x2E,0x4C,0x41
	.DB  0x49,0x4B,0x41,0x53,0x3A,0x20,0x30,0x30
	.DB  0x3A,0x30,0x30,0x0,0x32,0x2E,0x44,0x41
	.DB  0x54,0x41,0x3A,0x20,0x32,0x30,0x31,0x31
	.DB  0x2E,0x31,0x31,0x2E,0x31,0x38,0x0,0x33
	.DB  0x2E,0x53,0x4B,0x41,0x4D,0x42,0x45,0x4A
	.DB  0x49,0x4D,0x41,0x49,0x0,0x34,0x2E,0x4E
	.DB  0x55,0x53,0x54,0x41,0x54,0x59,0x4D,0x41
	.DB  0x49,0x0,0x20,0x3C,0x0,0x20,0x20,0x0
	.DB  0x7C,0x7C,0x0,0x3E,0x0,0x20,0x7C,0x20
	.DB  0x0,0x20,0x20,0x20,0x0,0x2B,0x0,0x2D
	.DB  0x0,0x2A,0x20,0x0,0x4C,0x41,0x49,0x4B
	.DB  0x41,0x53,0x3A,0x20,0x0,0x44,0x41,0x54
	.DB  0x41,0x3A,0x0,0x20,0x20,0x20,0x20,0x0
	.DB  0x53,0x4B,0x41,0x4D,0x42,0x45,0x4A,0x49
	.DB  0x4D,0x41,0x49,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x4E,0x55,0x53,0x54
	.DB  0x41,0x54,0x59,0x4D,0x41,0x49,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x31,0x2E,0x56,0x45,0x4C,0x59,0x4B,0x55
	.DB  0x20,0x4C,0x41,0x49,0x4B,0x41,0x53,0x0
	.DB  0x32,0x2E,0x4B,0x41,0x4C,0x45,0x44,0x55
	.DB  0x20,0x4C,0x41,0x49,0x4B,0x41,0x53,0x0
	.DB  0x33,0x2E,0x45,0x49,0x4C,0x49,0x4E,0x49
	.DB  0x53,0x20,0x4C,0x41,0x49,0x4B,0x2E,0x0
	.DB  0x4B,0x4F,0x44,0x41,0x53,0x3A,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x4C,0x41,0x49,0x4B
	.DB  0x41,0x53,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x42,0x41,0x49
	.DB  0x47,0x45,0x53,0x49,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x4B
	.DB  0x4F,0x44,0x41,0x53,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x54,0x45
	.DB  0x49,0x53,0x49,0x4E,0x47,0x41,0x53,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x4E,0x45
	.DB  0x54,0x45,0x49,0x53,0x49,0x4E,0x47,0x41
	.DB  0x53,0x20,0x20,0x20,0x0
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
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10/7/2011
;Author  : NeVaDa
;Company : Home
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 4.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
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
;// Alphanumeric LCD Module functions portc
;#asm
   .equ __lcd_port=0x15
; 0000 001E #endasm
;#include <lcd.h>
;
;///////////// BUTTONS /////////////
;// " <||> | +||-||* "
;#define BUTTON_DESCRIPTION1   " <"
;#define BUTTON_DESCRIPTION1_0 "  "
;
;#define BUTTON_DESCRIPTION2   "||"
;#define BUTTON_DESCRIPTION2_0 "  "
;
;#define BUTTON_DESCRIPTION3   ">"
;#define BUTTON_DESCRIPTION3_0 " "
;
;#define BUTTON_DESCRIPTION4   " | "
;#define BUTTON_DESCRIPTION4_0 "   "
;
;#define BUTTON_DESCRIPTION5   "+"
;#define BUTTON_DESCRIPTION5_0 " "
;
;#define BUTTON_DESCRIPTION6   "||"
;#define BUTTON_DESCRIPTION6_0 "  "
;
;#define BUTTON_DESCRIPTION7   "-"
;#define BUTTON_DESCRIPTION7_0 " "
;
;#define BUTTON_DESCRIPTION8   "||"
;#define BUTTON_DESCRIPTION8_0 "  "
;
;#define BUTTON_DESCRIPTION9   "* "
;#define BUTTON_DESCRIPTION9_0 "  "
;
;// BUTTON FILTRATION
;#define ButtonFiltrationTimer 20 // x*cycle (cycle~1ms)
;
;// PINS
;#define BUTTON_INPUT1 PIND.6
;#define BUTTON_INPUT2 PIND.5
;#define BUTTON_INPUT3 PIND.4
;#define BUTTON_INPUT4 PIND.3
;#define BUTTON_INPUT5 PIND.2
;///////////////////////////////////
;
;
;// Inputs / Outputs
;#define LCD_LED PORTA.7
;
;// Real Time
;eeprom unsigned int RealTimeYear;
;eeprom signed char RealTimeMonth, RealTimeDay, RealTimeHour, RealTimeMinute;
;unsigned char RealTimeSecond;
;
;// Lcd Address
;signed char Address[3];
;char RefreshLcd;
;
;// Other
;char PAGRINDINIS_LANGAS;
;char Call_1Second;
;
;
;// Meniu sistema
;#define LCD_LENGHT 20
;#define LCD_WIDTH 4
;
;#define MAX_MENU_TABLES 10
;#define MAX_MENU_ROWS_ON_TABLE 10
;#define MAX_MENU_CHARACTERS_IN_ROW 20
;#define MAX_MENU_ABSOLUTE_ROWS 10
;#define MAX_MENU_BUTTONS 5
;
;#define pokeb(addr,data) *((unsigned char *)(addr))=(data)
;#define pokew(addr,data) *((unsigned int *)(addr))=(data)
;#define peekb(addr) *((unsigned char *)(addr))
;#define peekw(addr) *((unsigned int *)(addr))
;
;unsigned char MenuAddress[3];
;
;unsigned char MenuRow;
;unsigned char MenuLowestRow;
;unsigned char MenuHighestRow;
;
;unsigned char MenuColumn;
;unsigned char MenuLowestColumn;
;unsigned char MenuHighestColumn;
;
;
;unsigned char MenuCreated[MAX_MENU_TABLES];
;unsigned char MenuRowTableId[MAX_MENU_ABSOLUTE_ROWS];
;unsigned char MenuRowIdInTable[MAX_MENU_ABSOLUTE_ROWS];
;unsigned char MenuRowText[MAX_MENU_ABSOLUTE_ROWS][MAX_MENU_CHARACTERS_IN_ROW];
;unsigned char MenuRowLinksTo[MAX_MENU_ABSOLUTE_ROWS][3];
;
;void MenuShowError(char flash *string){
; 0000 007B void MenuShowError(char flash *string){

	.CSEG
; 0000 007C lcd_clear();
;	*string -> Y+0
; 0000 007D lcd_putsf("ERROR:");
; 0000 007E lcd_putsf(string);
; 0000 007F delay_ms(15000);
; 0000 0080 }
;
;unsigned char CreateMenuTable(unsigned char x, unsigned char y, unsigned char z,
; 0000 0083                         unsigned char Rows, unsigned char RowUpButton, unsigned char RowDownButton,
; 0000 0084                         unsigned char ColumnCount){
; 0000 0085 
; 0000 0086 /*unsigned char MenuID;
; 0000 0087     for(MenuID=0;MenuID<MAX_MENU_COUNT;MenuID++){
; 0000 0088         if(MenuCreated[MenuID]==false){
; 0000 0089         MenuAddress[MenuID] = Address;
; 0000 008A         MenuCreated[MenuID] = true;
; 0000 008B         return MenuID;
; 0000 008C         }
; 0000 008D     } */
; 0000 008E return 0;
;	x -> Y+6
;	y -> Y+5
;	z -> Y+4
;	Rows -> Y+3
;	RowUpButton -> Y+2
;	RowDownButton -> Y+1
;	ColumnCount -> Y+0
; 0000 008F }
;
;unsigned char CreateMenuRow(unsigned char TableId, unsigned char Row, char flash *string, unsigned char IsSelectable, unsigned char LocateToX, unsigned char LocateToY, unsigned char LocateToZ){
; 0000 0091 unsigned char CreateMenuRow(unsigned char TableId, unsigned char Row, char flash *string, unsigned char IsSelectable, unsigned char LocateToX, unsigned char LocateToY, unsigned char LocateToZ){
; 0000 0092     if(MenuCreated[TableId]==1){
;	TableId -> Y+7
;	Row -> Y+6
;	*string -> Y+4
;	IsSelectable -> Y+3
;	LocateToX -> Y+2
;	LocateToY -> Y+1
;	LocateToZ -> Y+0
; 0000 0093 
; 0000 0094 
; 0000 0095     }
; 0000 0096 MenuShowError("CREATING MENU ROW FAILED.");
; 0000 0097 return 0;
; 0000 0098 }
;
;void RefreshMenu(){
; 0000 009A void RefreshMenu(){
; 0000 009B 
; 0000 009C }
;
;
;void InitMenuTexts(){
; 0000 009F void InitMenuTexts(){
; 0000 00A0 unsigned char TableId = CreateMenuTable(0,0,0,4,0,1,20);
; 0000 00A1 CreateMenuRow(TableId,0, " PAGRINDINIS MENIU",  0, 0,0,0);
;	TableId -> R17
; 0000 00A2 CreateMenuRow(TableId,1, "1.LAIKAS: 00:00",     1, 1,0,0);
; 0000 00A3 CreateMenuRow(TableId,2, "2.DATA: 2011.11.18",  1, 2,0,0);
; 0000 00A4 CreateMenuRow(TableId,3, "3.SKAMBEJIMAI",       1, 3,0,0);
; 0000 00A5 CreateMenuRow(TableId,4, "4.NUSTATYMAI",        1, 4,0,0);
; 0000 00A6 
; 0000 00A7 
; 0000 00A8 
; 0000 00A9 
; 0000 00AA 
; 0000 00AB TableId = CreateMenuTable(3,0,0,4,0,1,20);
; 0000 00AC 
; 0000 00AD 
; 0000 00AE 
; 0000 00AF }
;
;void UpdateMenuTexts(){
; 0000 00B1 void UpdateMenuTexts(){
; 0000 00B2 
; 0000 00B3 }
;
;void UpdateMenuVariables(){
; 0000 00B5 void UpdateMenuVariables(){
; 0000 00B6 
; 0000 00B7 }
;
;///////////////////////////// FUNCTIONS /////////////////////////////////////////
;char NumToIndex(char Num){
; 0000 00BA char NumToIndex(char Num){
_NumToIndex:
; 0000 00BB     if(Num==0){     return '0';}
;	Num -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x4
	LDI  R30,LOW(48)
	RJMP _0x2020004
; 0000 00BC     else if(Num==1){return '1';}
_0x4:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x6
	LDI  R30,LOW(49)
	RJMP _0x2020004
; 0000 00BD     else if(Num==2){return '2';}
_0x6:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x8
	LDI  R30,LOW(50)
	RJMP _0x2020004
; 0000 00BE     else if(Num==3){return '3';}
_0x8:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0xA
	LDI  R30,LOW(51)
	RJMP _0x2020004
; 0000 00BF     else if(Num==4){return '4';}
_0xA:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xC
	LDI  R30,LOW(52)
	RJMP _0x2020004
; 0000 00C0     else if(Num==5){return '5';}
_0xC:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0xE
	LDI  R30,LOW(53)
	RJMP _0x2020004
; 0000 00C1     else if(Num==6){return '6';}
_0xE:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x10
	LDI  R30,LOW(54)
	RJMP _0x2020004
; 0000 00C2     else if(Num==7){return '7';}
_0x10:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x12
	LDI  R30,LOW(55)
	RJMP _0x2020004
; 0000 00C3     else if(Num==8){return '8';}
_0x12:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x14
	LDI  R30,LOW(56)
	RJMP _0x2020004
; 0000 00C4     else if(Num==9){return '9';}
_0x14:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x16
	LDI  R30,LOW(57)
	RJMP _0x2020004
; 0000 00C5     else{           return '-';}
_0x16:
	LDI  R30,LOW(45)
; 0000 00C6 return 0;
_0x2020004:
	ADIW R28,1
	RET
; 0000 00C7 }
;
;char DayCountInMonth(unsigned int year, char month){
; 0000 00C9 char DayCountInMonth(unsigned int year, char month){
_DayCountInMonth:
; 0000 00CA     if((month==1)||(month==3)||(month==5)||(month==7)||(month==8)||(month==10)||(month==12)){
;	year -> Y+1
;	month -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BREQ _0x19
	CPI  R26,LOW(0x3)
	BREQ _0x19
	CPI  R26,LOW(0x5)
	BREQ _0x19
	CPI  R26,LOW(0x7)
	BREQ _0x19
	CPI  R26,LOW(0x8)
	BREQ _0x19
	CPI  R26,LOW(0xA)
	BREQ _0x19
	CPI  R26,LOW(0xC)
	BRNE _0x18
_0x19:
; 0000 00CB     return 31;
	LDI  R30,LOW(31)
	RJMP _0x2020003
; 0000 00CC     }
; 0000 00CD     else if((month==4)||(month==6)||(month==9)||(month==11)){
_0x18:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BREQ _0x1D
	CPI  R26,LOW(0x6)
	BREQ _0x1D
	CPI  R26,LOW(0x9)
	BREQ _0x1D
	CPI  R26,LOW(0xB)
	BRNE _0x1C
_0x1D:
; 0000 00CE     return 30;
	LDI  R30,LOW(30)
	RJMP _0x2020003
; 0000 00CF     }
; 0000 00D0     else if(month==2){
_0x1C:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x20
; 0000 00D1     unsigned int a;
; 0000 00D2     a = year/4;
	SBIW R28,2
;	year -> Y+3
;	month -> Y+2
;	a -> Y+0
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	CALL __LSRW2
	ST   Y,R30
	STD  Y+1,R31
; 0000 00D3     a = a*4;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(4)
	CALL __MULB1W2U
	ST   Y,R30
	STD  Y+1,R31
; 0000 00D4         if(a==year){
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x21
; 0000 00D5         return 29;
	LDI  R30,LOW(29)
	ADIW R28,2
	RJMP _0x2020003
; 0000 00D6         }
; 0000 00D7         else{
_0x21:
; 0000 00D8         return 28;
	LDI  R30,LOW(28)
	ADIW R28,2
	RJMP _0x2020003
; 0000 00D9         }
; 0000 00DA     }
; 0000 00DB     else{
_0x20:
; 0000 00DC     return 0;
	LDI  R30,LOW(0)
; 0000 00DD     }
; 0000 00DE }
_0x2020003:
	ADIW R28,3
	RET
;
;unsigned int WhatIsTheCode(){
; 0000 00E0 unsigned int WhatIsTheCode(){
_WhatIsTheCode:
; 0000 00E1 return (RealTimeYear-2000)*RealTimeMonth*RealTimeDay;
	CALL SUBOPT_0x0
	SUBI R30,LOW(2000)
	SBCI R31,HIGH(2000)
	MOVW R0,R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	MOVW R0,R30
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2
	RET
; 0000 00E2 }
;
;char lcd_put_number(char Type, char Lenght, char IsSign,
; 0000 00E5 
; 0000 00E6                     char NumbersAfterDot,
; 0000 00E7 
; 0000 00E8                     unsigned long int Number0,
; 0000 00E9                     signed long int Number1){
_lcd_put_number:
; 0000 00EA     if(Lenght>0){
;	Type -> Y+11
;	Lenght -> Y+10
;	IsSign -> Y+9
;	NumbersAfterDot -> Y+8
;	Number0 -> Y+4
;	Number1 -> Y+0
	LDD  R26,Y+10
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x24
; 0000 00EB     unsigned long int k = 1;
; 0000 00EC     unsigned char i;
; 0000 00ED         for(i=0;i<Lenght-1;i++) k = k*10;
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
_0x26:
	LDD  R30,Y+15
	LDI  R31,0
	SBIW R30,1
	LD   R26,Y
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x27
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x26
_0x27:
; 0000 00EF if(Type==0){
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x28
; 0000 00F0         unsigned long int a;
; 0000 00F1         unsigned char b;
; 0000 00F2         a = Number0;
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
	CALL SUBOPT_0x6
; 0000 00F3 
; 0000 00F4             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x29
; 0000 00F5             lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00F6             }
; 0000 00F7 
; 0000 00F8             if(a<0){
_0x29:
	CALL SUBOPT_0x7
; 0000 00F9             a = a*(-1);
; 0000 00FA             }
; 0000 00FB 
; 0000 00FC             if(k*10<a){
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRSH _0x2B
; 0000 00FD             a = k*10 - 1;
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
; 0000 00FE             }
; 0000 00FF 
; 0000 0100             for(i=0;i<Lenght;i++){
_0x2B:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x2D:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0x2E
; 0000 0101                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x2F
; 0000 0102                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0xB
	BRNE _0x30
; 0000 0103                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0104                     }
; 0000 0105                 }
_0x30:
; 0000 0106             b = a/k;
_0x2F:
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 0107             lcd_putchar( NumToIndex( b ) );
; 0000 0108             a = a - b*k;
; 0000 0109             k = k/10;
; 0000 010A             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x2D
_0x2E:
; 0000 010B         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2020002
; 0000 010C         }
; 0000 010D 
; 0000 010E         else if(Type==1){
_0x28:
	LDD  R26,Y+16
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x32
; 0000 010F         signed long int a;
; 0000 0110         unsigned char b;
; 0000 0111         a = Number1;
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
	CALL SUBOPT_0x6
; 0000 0112 
; 0000 0113             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x33
; 0000 0114                 if(a>=0){
	LDD  R26,Y+4
	TST  R26
	BRMI _0x34
; 0000 0115                 lcd_putchar('+');
	LDI  R30,LOW(43)
	RJMP _0x15C
; 0000 0116                 }
; 0000 0117                 else{
_0x34:
; 0000 0118                 lcd_putchar('-');
	LDI  R30,LOW(45)
_0x15C:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0119                 }
; 0000 011A             }
; 0000 011B 
; 0000 011C             if(a<0){
_0x33:
	LDD  R26,Y+4
	TST  R26
	BRPL _0x36
; 0000 011D             a = a*(-1);
	CALL SUBOPT_0x4
	__GETD2N 0xFFFFFFFF
	CALL __MULD12
	CALL SUBOPT_0x6
; 0000 011E             }
; 0000 011F 
; 0000 0120             if(k*10<a){
_0x36:
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRSH _0x37
; 0000 0121             a = k*10 - 1;
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
; 0000 0122             }
; 0000 0123 
; 0000 0124             for(i=0;i<Lenght;i++){
_0x37:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x39:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0x3A
; 0000 0125                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x3B
; 0000 0126                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0xB
	BRNE _0x3C
; 0000 0127                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0128                     }
; 0000 0129                 }
_0x3C:
; 0000 012A             b = a/k;
_0x3B:
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 012B             lcd_putchar( NumToIndex( b ) );
; 0000 012C             a = a - b*k;
; 0000 012D             k = k/10;
; 0000 012E             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x39
_0x3A:
; 0000 012F         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2020002
; 0000 0130         }
; 0000 0131     }
_0x32:
	ADIW R28,5
; 0000 0132 return 0;
_0x24:
	LDI  R30,LOW(0)
_0x2020002:
	ADIW R28,12
	RET
; 0000 0133 }
;
;char lcd_put_runing_text(   unsigned char Start_x,
; 0000 0136                             unsigned char Start_y,
; 0000 0137 
; 0000 0138                             unsigned int Lenght,
; 0000 0139                             unsigned int Position,
; 0000 013A 
; 0000 013B                             char flash *str,
; 0000 013C                             unsigned int StrLenght){
; 0000 013D signed int i,a;
; 0000 013E lcd_gotoxy(Start_x,Start_y);
;	Start_x -> Y+13
;	Start_y -> Y+12
;	Lenght -> Y+10
;	Position -> Y+8
;	*str -> Y+6
;	StrLenght -> Y+4
;	i -> R16,R17
;	a -> R18,R19
; 0000 013F 
; 0000 0140     for(i=0;i<Lenght;i++){
; 0000 0141     a = i + Position - Lenght;
; 0000 0142         if(a>=0){
; 0000 0143             if(a<StrLenght){
; 0000 0144             lcd_putchar(str[a]);
; 0000 0145             }
; 0000 0146             else{
; 0000 0147                 if(i==0){
; 0000 0148                 return 1;
; 0000 0149                 }
; 0000 014A             }
; 0000 014B         }
; 0000 014C         else{
; 0000 014D         lcd_putchar(' ');
; 0000 014E         }
; 0000 014F     }
; 0000 0150 return 0;
; 0000 0151 }
;
;char lcd_cursor(unsigned char x, unsigned char y){
; 0000 0153 char lcd_cursor(unsigned char x, unsigned char y){
_lcd_cursor:
; 0000 0154 lcd_gotoxy(x,y);
;	x -> Y+1
;	y -> Y+0
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0155 _lcd_ready();
	CALL __lcd_ready
; 0000 0156 _lcd_write_data(0xe);
	LDI  R30,LOW(14)
	ST   -Y,R30
	CALL __lcd_write_data
; 0000 0157 return 1;
	LDI  R30,LOW(1)
	ADIW R28,2
	RET
; 0000 0158 }
;
;static unsigned char CODE_IsEntering;
;static unsigned char CODE_SuccessXYZ[3];
;static unsigned char CODE_FailedXYZ[3];
;static unsigned char CODE_TimeLeft;
;static unsigned int  CODE_EnteringCode;
;static unsigned char CODE_ExecutingDigit;
;char EnterCode(char FailX,char FailY,char FailZ,
; 0000 0161         char SuccessX,char SuccessY,char SuccessZ){
; 0000 0162     if(CODE_IsEntering==0){
;	FailX -> Y+5
;	FailY -> Y+4
;	FailZ -> Y+3
;	SuccessX -> Y+2
;	SuccessY -> Y+1
;	SuccessZ -> Y+0
; 0000 0163     CODE_IsEntering = 1;
; 0000 0164 
; 0000 0165     CODE_SuccessXYZ[0] = SuccessX;
; 0000 0166     CODE_SuccessXYZ[1] = SuccessY;
; 0000 0167     CODE_SuccessXYZ[2] = SuccessZ;
; 0000 0168 
; 0000 0169     CODE_FailedXYZ[0] = FailX;
; 0000 016A     CODE_FailedXYZ[1] = FailY;
; 0000 016B     CODE_FailedXYZ[2] = FailZ;
; 0000 016C 
; 0000 016D     CODE_TimeLeft = 99;
; 0000 016E     CODE_EnteringCode = 0;
; 0000 016F     CODE_ExecutingDigit = 0;
; 0000 0170     return 1;
; 0000 0171     }
; 0000 0172 return 0;
; 0000 0173 }
;
;char lcd_buttons(char Left,char Right, char Plius,char Minus,
; 0000 0176     char Patvirtinti, char DualButton1,char DualButton2,char DualButton3,
; 0000 0177         char DualButton4){
_lcd_buttons:
; 0000 0178 
; 0000 0179     if(Left==1){
;	Left -> Y+8
;	Right -> Y+7
;	Plius -> Y+6
;	Minus -> Y+5
;	Patvirtinti -> Y+4
;	DualButton1 -> Y+3
;	DualButton2 -> Y+2
;	DualButton3 -> Y+1
;	DualButton4 -> Y+0
	LDD  R26,Y+8
	CPI  R26,LOW(0x1)
	BRNE _0x46
; 0000 017A     lcd_putsf(BUTTON_DESCRIPTION1);
	__POINTW1FN _0x0,114
	RJMP _0x15D
; 0000 017B     }
; 0000 017C     else{
_0x46:
; 0000 017D     lcd_putsf(BUTTON_DESCRIPTION1_0);
	__POINTW1FN _0x0,117
_0x15D:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 017E     }
; 0000 017F 
; 0000 0180     if(DualButton1==1){
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x48
; 0000 0181     lcd_putsf(BUTTON_DESCRIPTION2);
	__POINTW1FN _0x0,120
	RJMP _0x15E
; 0000 0182     }
; 0000 0183     else{
_0x48:
; 0000 0184     lcd_putsf(BUTTON_DESCRIPTION2_0);
	__POINTW1FN _0x0,117
_0x15E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0185     }
; 0000 0186 
; 0000 0187     if(Right==1){
	LDD  R26,Y+7
	CPI  R26,LOW(0x1)
	BRNE _0x4A
; 0000 0188     lcd_putsf(BUTTON_DESCRIPTION3);
	__POINTW1FN _0x0,123
	RJMP _0x15F
; 0000 0189     }
; 0000 018A     else{
_0x4A:
; 0000 018B     lcd_putsf(BUTTON_DESCRIPTION3_0);
	__POINTW1FN _0x0,118
_0x15F:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 018C     }
; 0000 018D 
; 0000 018E     if(DualButton2==1){
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0x4C
; 0000 018F     lcd_putsf(BUTTON_DESCRIPTION4);
	__POINTW1FN _0x0,125
	RJMP _0x160
; 0000 0190     }
; 0000 0191     else{
_0x4C:
; 0000 0192     lcd_putsf(BUTTON_DESCRIPTION4_0);
	__POINTW1FN _0x0,129
_0x160:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0193     }
; 0000 0194 
; 0000 0195     if(Plius==1){
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x4E
; 0000 0196     lcd_putsf(BUTTON_DESCRIPTION5);
	__POINTW1FN _0x0,133
	RJMP _0x161
; 0000 0197     }
; 0000 0198     else{
_0x4E:
; 0000 0199     lcd_putsf(BUTTON_DESCRIPTION5_0);
	__POINTW1FN _0x0,118
_0x161:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 019A     }
; 0000 019B 
; 0000 019C     if(DualButton3==1){
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x50
; 0000 019D     lcd_putsf(BUTTON_DESCRIPTION6);
	__POINTW1FN _0x0,120
	RJMP _0x162
; 0000 019E     }
; 0000 019F     else{
_0x50:
; 0000 01A0     lcd_putsf(BUTTON_DESCRIPTION6_0);
	__POINTW1FN _0x0,117
_0x162:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01A1     }
; 0000 01A2 
; 0000 01A3     if(Minus==1){
	LDD  R26,Y+5
	CPI  R26,LOW(0x1)
	BRNE _0x52
; 0000 01A4     lcd_putsf(BUTTON_DESCRIPTION7);
	__POINTW1FN _0x0,135
	RJMP _0x163
; 0000 01A5     }
; 0000 01A6     else{
_0x52:
; 0000 01A7     lcd_putsf(BUTTON_DESCRIPTION7_0);
	__POINTW1FN _0x0,118
_0x163:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01A8     }
; 0000 01A9 
; 0000 01AA     if(DualButton4==1){
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x54
; 0000 01AB     lcd_putsf(BUTTON_DESCRIPTION8);
	__POINTW1FN _0x0,120
	RJMP _0x164
; 0000 01AC     }
; 0000 01AD     else{
_0x54:
; 0000 01AE     lcd_putsf(BUTTON_DESCRIPTION8_0);
	__POINTW1FN _0x0,117
_0x164:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01AF     }
; 0000 01B0 
; 0000 01B1     if(Patvirtinti==1){
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x56
; 0000 01B2     lcd_putsf(BUTTON_DESCRIPTION9);
	__POINTW1FN _0x0,137
	RJMP _0x165
; 0000 01B3     }
; 0000 01B4     else{
_0x56:
; 0000 01B5     lcd_putsf(BUTTON_DESCRIPTION9_0);
	__POINTW1FN _0x0,117
_0x165:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01B6     }
; 0000 01B7 
; 0000 01B8 return 1;
	LDI  R30,LOW(1)
	ADIW R28,9
	RET
; 0000 01B9 }
;
;char IsDateEaster(unsigned int year, unsigned int month, unsigned int day){
; 0000 01BB char IsDateEaster(unsigned int year, unsigned int month, unsigned int day){
; 0000 01BC unsigned int G, C, X, Z, D, E, F, N;
; 0000 01BD unsigned char EasterSunday, EasterSaturday, EasterFriday, EasterThursday;
; 0000 01BE 
; 0000 01BF G = year-((year/19)*19)+1;
;	year -> Y+24
;	month -> Y+22
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
; 0000 01C0 C = (year/100)+1;
; 0000 01C1 X = 3*C/4-12;
; 0000 01C2 Z = ((8*C+5)/25)-5;
; 0000 01C3 D = 5*year/4-X-10;
; 0000 01C4 F = 11*G+20+Z-X;
; 0000 01C5 E = F-((F/30)*30);
; 0000 01C6     if(((E==25)&&(G>11))||(E==24)){ E++;    }
; 0000 01C7 N = 44-E;
; 0000 01C8     if(N<21){   N = N+30;   }
; 0000 01C9 N = N+7-((D+N)-(((D+N)/7)*7));
; 0000 01CA 
; 0000 01CB EasterSunday = N;
; 0000 01CC EasterSaturday = N - 1;
; 0000 01CD EasterFriday = N - 2;
; 0000 01CE EasterThursday = N - 3;
; 0000 01CF 
; 0000 01D0 // Velyku ketvirtadienis
; 0000 01D1     if (EasterThursday>31){
; 0000 01D2     EasterThursday = EasterThursday - 31;
; 0000 01D3     // Balandzio N-oji diena
; 0000 01D4         if(month==4){
; 0000 01D5             if(day==EasterThursday){
; 0000 01D6             return 4;
; 0000 01D7             }
; 0000 01D8         }
; 0000 01D9     }
; 0000 01DA     else{
; 0000 01DB     // Kovo N-oji diena
; 0000 01DC         if(month==3){
; 0000 01DD             if(day==EasterThursday){
; 0000 01DE             return 4;
; 0000 01DF             }
; 0000 01E0         }
; 0000 01E1     }
; 0000 01E2 
; 0000 01E3 // Velyku penktadienis
; 0000 01E4     if (EasterFriday>31){
; 0000 01E5     EasterFriday = EasterFriday - 31;
; 0000 01E6     // Balandzio N-oji diena
; 0000 01E7         if(month==4){
; 0000 01E8             if(day==EasterFriday){
; 0000 01E9             return 5;
; 0000 01EA             }
; 0000 01EB         }
; 0000 01EC     }
; 0000 01ED     else{
; 0000 01EE     // Kovo N-oji diena
; 0000 01EF         if(month==3){
; 0000 01F0             if(day==EasterFriday){
; 0000 01F1             return 5;
; 0000 01F2             }
; 0000 01F3         }
; 0000 01F4     }
; 0000 01F5 
; 0000 01F6 // Velyku sestadienis
; 0000 01F7     if (EasterSaturday>31){
; 0000 01F8     EasterSaturday = EasterSaturday - 31;
; 0000 01F9     // Balandzio N-oji diena
; 0000 01FA         if(month==4){
; 0000 01FB             if(day==EasterSaturday){
; 0000 01FC             return 6;
; 0000 01FD             }
; 0000 01FE         }
; 0000 01FF     }
; 0000 0200     else{
; 0000 0201     // Kovo N-oji diena
; 0000 0202         if(month==3){
; 0000 0203             if(day==EasterSaturday){
; 0000 0204             return 6;
; 0000 0205             }
; 0000 0206         }
; 0000 0207     }
; 0000 0208 
; 0000 0209 // Velyku sekmadienis
; 0000 020A     if (EasterSunday>31){
; 0000 020B     EasterSunday = EasterSunday - 31;
; 0000 020C     // Balandzio N-oji diena
; 0000 020D         if(month==4){
; 0000 020E             if(day==EasterSunday){
; 0000 020F             return 7;
; 0000 0210             }
; 0000 0211         }
; 0000 0212     }
; 0000 0213     else{
; 0000 0214     // Kovo N-oji diena
; 0000 0215         if(month==3){
; 0000 0216             if(day==EasterSunday){
; 0000 0217             return 7;
; 0000 0218             }
; 0000 0219         }
; 0000 021A     }
; 0000 021B 
; 0000 021C return 0;
; 0000 021D }
;
;/////////////////////////////////////////////////////////////////////////////////
;///////////////////////////////// Interupts /////////////////////////////////////
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 0222 interrupt [12] void timer0_ovf_isr(void){
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0223 static signed int InteruptTimer, MissTimer;
; 0000 0224 InteruptTimer++;
	LDI  R26,LOW(_InteruptTimer_S0000010000)
	LDI  R27,HIGH(_InteruptTimer_S0000010000)
	CALL SUBOPT_0xE
; 0000 0225     if(InteruptTimer>=495){// Periodas
	LDS  R26,_InteruptTimer_S0000010000
	LDS  R27,_InteruptTimer_S0000010000+1
	CPI  R26,LOW(0x1EF)
	LDI  R30,HIGH(0x1EF)
	CPC  R27,R30
	BRLT _0x76
; 0000 0226     Call_1Second++;
	INC  R6
; 0000 0227     InteruptTimer = 0;
	LDI  R30,LOW(0)
	STS  _InteruptTimer_S0000010000,R30
	STS  _InteruptTimer_S0000010000+1,R30
; 0000 0228     MissTimer++;
	LDI  R26,LOW(_MissTimer_S0000010000)
	LDI  R27,HIGH(_MissTimer_S0000010000)
	CALL SUBOPT_0xE
; 0000 0229         if(MissTimer>=1000){
	LDS  R26,_MissTimer_S0000010000
	LDS  R27,_MissTimer_S0000010000+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLT _0x77
; 0000 022A         InteruptTimer = 5;// -(Tukstantosios periodo dalys)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _InteruptTimer_S0000010000,R30
	STS  _InteruptTimer_S0000010000+1,R31
; 0000 022B         MissTimer = 0;
	LDI  R30,LOW(0)
	STS  _MissTimer_S0000010000,R30
	STS  _MissTimer_S0000010000+1,R30
; 0000 022C         }
; 0000 022D     }
_0x77:
; 0000 022E 
; 0000 022F static unsigned int RefreshTimer;
_0x76:
; 0000 0230 RefreshTimer++;
	LDI  R26,LOW(_RefreshTimer_S0000010000)
	LDI  R27,HIGH(_RefreshTimer_S0000010000)
	CALL SUBOPT_0xE
; 0000 0231     if(RefreshTimer>=20){
	LDS  R26,_RefreshTimer_S0000010000
	LDS  R27,_RefreshTimer_S0000010000+1
	SBIW R26,20
	BRLO _0x78
; 0000 0232     RefreshTimer = 0;
	LDI  R30,LOW(0)
	STS  _RefreshTimer_S0000010000,R30
	STS  _RefreshTimer_S0000010000+1,R30
; 0000 0233     RefreshLcd = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0234     }
; 0000 0235 
; 0000 0236 }
_0x78:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;/////////////////////////////////////////////////////////////////////////////////////
;
;void main(void){
; 0000 0239 void main(void){
_main:
; 0000 023A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 023B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 023C PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 023D DDRA=0x00;
	OUT  0x1A,R30
; 0000 023E 
; 0000 023F // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0240 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0241 PORTB=0x00;
	OUT  0x18,R30
; 0000 0242 DDRB=0x00;
	OUT  0x17,R30
; 0000 0243 
; 0000 0244 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0245 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0246 PORTC=0x00;
	OUT  0x15,R30
; 0000 0247 DDRC=0x00;
	OUT  0x14,R30
; 0000 0248 
; 0000 0249 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 024A // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 024B PORTD=0x00;
	OUT  0x12,R30
; 0000 024C DDRD=0x00;
	OUT  0x11,R30
; 0000 024D 
; 0000 024E // Timer/Counter 0 initialization
; 0000 024F // Clock source: System Clock
; 0000 0250 // Clock value: 125.000 kHz
; 0000 0251 // Mode: Normal top=FFh
; 0000 0252 // OC0 output: Disconnected
; 0000 0253 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0254 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0255 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0256 
; 0000 0257 // Timer/Counter 1 initialization
; 0000 0258 // Clock source: System Clock
; 0000 0259 // Clock value: Timer1 Stopped
; 0000 025A // Mode: Normal top=FFFFh
; 0000 025B // OC1A output: Discon.
; 0000 025C // OC1B output: Discon.
; 0000 025D // Noise Canceler: Off
; 0000 025E // Input Capture on Falling Edge
; 0000 025F // Timer1 Overflow Interrupt: Off
; 0000 0260 // Input Capture Interrupt: Off
; 0000 0261 // Compare A Match Interrupt: Off
; 0000 0262 // Compare B Match Interrupt: Off
; 0000 0263 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0264 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0265 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0266 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0267 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0268 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0269 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 026A OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 026B OCR1BH=0x00;
	OUT  0x29,R30
; 0000 026C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 026D 
; 0000 026E // Timer/Counter 2 initialization
; 0000 026F // Clock source: System Clock
; 0000 0270 // Clock value: Timer2 Stopped
; 0000 0271 // Mode: Normal top=FFh
; 0000 0272 // OC2 output: Disconnected
; 0000 0273 ASSR=0x00;
	OUT  0x22,R30
; 0000 0274 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0275 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0276 OCR2=0x00;
	OUT  0x23,R30
; 0000 0277 
; 0000 0278 // External Interrupt(s) initialization
; 0000 0279 // INT0: Off
; 0000 027A // INT1: Off
; 0000 027B // INT2: Off
; 0000 027C MCUCR=0x00;
	OUT  0x35,R30
; 0000 027D MCUCSR=0x00;
	OUT  0x34,R30
; 0000 027E 
; 0000 027F // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0280 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0281 
; 0000 0282 // Analog Comparator initialization
; 0000 0283 // Analog Comparator: Off
; 0000 0284 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0285 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0286 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0287 
; 0000 0288 // LCD module initialization
; 0000 0289 lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 028A 
; 0000 028B // Global enable interrupts
; 0000 028C #asm("sei")
	sei
; 0000 028D 
; 0000 028E 
; 0000 028F 
; 0000 0290 
; 0000 0291 
; 0000 0292 
; 0000 0293     while (1){
_0x79:
; 0000 0294 
; 0000 0295     //////////////////////////////////////////////////////////////////////////////////
; 0000 0296     //////////////////////////// Funkcija kas 1 secunde //////////////////////////////
; 0000 0297     //////////////////////////////////////////////////////////////////////////////////
; 0000 0298     static unsigned char Called_1Second;
; 0000 0299         if(Call_1Second>=1){
	LDI  R30,LOW(1)
	CP   R6,R30
	BRSH PC+3
	JMP _0x7C
; 0000 029A         Called_1Second = 1;
	STS  _Called_1Second_S0000011001,R30
; 0000 029B         Call_1Second--;
	DEC  R6
; 0000 029C 
; 0000 029D         // Realus laikas
; 0000 029E             if(RealTimeSecond>=59){
	LDI  R30,LOW(59)
	CP   R5,R30
	BRSH PC+3
	JMP _0x7D
; 0000 029F             RealTimeSecond = 0;
	CLR  R5
; 0000 02A0 
; 0000 02A1                 if(RealTimeMinute>=59){
	CALL SUBOPT_0xF
	CPI  R30,LOW(0x3B)
	BRGE PC+3
	JMP _0x7E
; 0000 02A2                 RealTimeMinute = 0;
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 02A3                     if(RealTimeHour>=23){
	CALL SUBOPT_0x10
	CPI  R30,LOW(0x17)
	BRLT _0x7F
; 0000 02A4                     RealTimeHour = 0;
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 02A5 
; 0000 02A6                         if(DayCountInMonth(RealTimeYear,RealTimeMonth)<=RealTimeDay){
	CALL SUBOPT_0x0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1
	ST   -Y,R30
	RCALL _DayCountInMonth
	MOV  R0,R30
	CALL SUBOPT_0x3
	MOV  R26,R0
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x80
; 0000 02A7                         RealTimeDay = 1;
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 02A8 
; 0000 02A9                             if(RealTimeMonth>=12){
	CALL SUBOPT_0x1
	CPI  R30,LOW(0xC)
	BRLT _0x81
; 0000 02AA                             RealTimeMonth = 1;
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 02AB                             RealTimeYear++;
	CALL SUBOPT_0x0
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 02AC                             }
; 0000 02AD                             else{
	RJMP _0x82
_0x81:
; 0000 02AE                             RealTimeMonth++;
	CALL SUBOPT_0x1
	CALL SUBOPT_0x11
; 0000 02AF                             }
_0x82:
; 0000 02B0 
; 0000 02B1                         }
; 0000 02B2                         else{
	RJMP _0x83
_0x80:
; 0000 02B3                         RealTimeDay++;
	CALL SUBOPT_0x3
	CALL SUBOPT_0x11
; 0000 02B4                         }
_0x83:
; 0000 02B5                     }
; 0000 02B6                     else{
	RJMP _0x84
_0x7F:
; 0000 02B7                     RealTimeHour++;
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 02B8                     }
_0x84:
; 0000 02B9                 }
; 0000 02BA                 else{
	RJMP _0x85
_0x7E:
; 0000 02BB                 RealTimeMinute++;
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
; 0000 02BC                 }
_0x85:
; 0000 02BD             }
; 0000 02BE             else{
	RJMP _0x86
_0x7D:
; 0000 02BF             RealTimeSecond++;
	INC  R5
; 0000 02C0             }
_0x86:
; 0000 02C1         /////////
; 0000 02C2             if(CODE_TimeLeft>0){
	LDS  R26,_CODE_TimeLeft_G000
	CPI  R26,LOW(0x1)
	BRLO _0x87
; 0000 02C3             CODE_TimeLeft--;
	LDS  R30,_CODE_TimeLeft_G000
	SUBI R30,LOW(1)
	STS  _CODE_TimeLeft_G000,R30
; 0000 02C4             }
; 0000 02C5 
; 0000 02C6             if(PAGRINDINIS_LANGAS<120){
_0x87:
	LDI  R30,LOW(120)
	CP   R7,R30
	BRSH _0x88
; 0000 02C7             PAGRINDINIS_LANGAS++;
	INC  R7
; 0000 02C8             }
; 0000 02C9         }
_0x88:
; 0000 02CA     //////////////////////////////////////////////////////////////////////////////////
; 0000 02CB     //////////////////////////////////////////////////////////////////////////////////
; 0000 02CC     //////////////////////////////////////////////////////////////////////////////////
; 0000 02CD 
; 0000 02CE 
; 0000 02CF 
; 0000 02D0 
; 0000 02D1 
; 0000 02D2     //////////////////////////////////////////////////////////////////////////////////
; 0000 02D3     /////////////////////////////////////// Mygtukai /////////////////////////////////
; 0000 02D4     //////////////////////////////////////////////////////////////////////////////////
; 0000 02D5     static char BUTTON[5], ButtonFilter[5];
_0x7C:
; 0000 02D6     static char DUAL_BUTTON[4], DualButtonFilter[4];
; 0000 02D7 
; 0000 02D8     // 1 Mygtukas
; 0000 02D9         if(BUTTON_INPUT1==1){
	SBIS 0x10,6
	RJMP _0x89
; 0000 02DA         PAGRINDINIS_LANGAS = 0;
	CLR  R7
; 0000 02DB             if(DualButtonFilter[0]<ButtonFiltrationTimer){
	LDS  R26,_DualButtonFilter_S0000011001
	CPI  R26,LOW(0x14)
	BRSH _0x8A
; 0000 02DC                 if(ButtonFilter[0]<ButtonFiltrationTimer){
	LDS  R26,_ButtonFilter_S0000011001
	CPI  R26,LOW(0x14)
	BRSH _0x8B
; 0000 02DD                 ButtonFilter[0]++;
	LDS  R30,_ButtonFilter_S0000011001
	SUBI R30,-LOW(1)
	STS  _ButtonFilter_S0000011001,R30
; 0000 02DE                 }
; 0000 02DF             }
_0x8B:
; 0000 02E0         }
_0x8A:
; 0000 02E1         else{
	RJMP _0x8C
_0x89:
; 0000 02E2             if(ButtonFilter[0]>=ButtonFiltrationTimer){
	LDS  R26,_ButtonFilter_S0000011001
	CPI  R26,LOW(0x14)
	BRLO _0x8D
; 0000 02E3             BUTTON[0] = 1;
	LDI  R30,LOW(1)
	STS  _BUTTON_S0000011001,R30
; 0000 02E4             RefreshLcd = 1;
	MOV  R4,R30
; 0000 02E5             }
; 0000 02E6             else{
	RJMP _0x8E
_0x8D:
; 0000 02E7             BUTTON[0] = 0;
	LDI  R30,LOW(0)
	STS  _BUTTON_S0000011001,R30
; 0000 02E8             }
_0x8E:
; 0000 02E9         ButtonFilter[0] = 0;
	LDI  R30,LOW(0)
	STS  _ButtonFilter_S0000011001,R30
; 0000 02EA         }
_0x8C:
; 0000 02EB 
; 0000 02EC     // 1 ir 2 Mygtukas
; 0000 02ED         if((BUTTON_INPUT1==1)&&(BUTTON_INPUT2==1)){
	SBIS 0x10,6
	RJMP _0x90
	SBIC 0x10,5
	RJMP _0x91
_0x90:
	RJMP _0x8F
_0x91:
; 0000 02EE         ButtonFilter[0] = 0;
	LDI  R30,LOW(0)
	STS  _ButtonFilter_S0000011001,R30
; 0000 02EF         ButtonFilter[1] = 0;
	__PUTB1MN _ButtonFilter_S0000011001,1
; 0000 02F0             if(DualButtonFilter[0]<ButtonFiltrationTimer){
	LDS  R26,_DualButtonFilter_S0000011001
	CPI  R26,LOW(0x14)
	BRSH _0x92
; 0000 02F1             DualButtonFilter[0]++;
	LDS  R30,_DualButtonFilter_S0000011001
	SUBI R30,-LOW(1)
	STS  _DualButtonFilter_S0000011001,R30
; 0000 02F2             }
; 0000 02F3         }
_0x92:
; 0000 02F4         else if((BUTTON_INPUT1==0)&&(BUTTON_INPUT2==0)){
	RJMP _0x93
_0x8F:
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x95
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x96
_0x95:
	RJMP _0x94
_0x96:
; 0000 02F5             if(DualButtonFilter[0]>=ButtonFiltrationTimer){
	LDS  R26,_DualButtonFilter_S0000011001
	CPI  R26,LOW(0x14)
	BRLO _0x97
; 0000 02F6             DUAL_BUTTON[0] = 1;
	LDI  R30,LOW(1)
	STS  _DUAL_BUTTON_S0000011001,R30
; 0000 02F7             RefreshLcd = 1;
	MOV  R4,R30
; 0000 02F8             }
; 0000 02F9             else{
	RJMP _0x98
_0x97:
; 0000 02FA             DUAL_BUTTON[0] = 0;
	LDI  R30,LOW(0)
	STS  _DUAL_BUTTON_S0000011001,R30
; 0000 02FB             }
_0x98:
; 0000 02FC         DualButtonFilter[0] = 0;
	LDI  R30,LOW(0)
	STS  _DualButtonFilter_S0000011001,R30
; 0000 02FD         }
; 0000 02FE 
; 0000 02FF     // 2 Mygtukas
; 0000 0300         if(BUTTON_INPUT2==1){
_0x94:
_0x93:
	SBIS 0x10,5
	RJMP _0x99
; 0000 0301         PAGRINDINIS_LANGAS = 0;
	CLR  R7
; 0000 0302             if(DualButtonFilter[0]<ButtonFiltrationTimer){
	LDS  R26,_DualButtonFilter_S0000011001
	CPI  R26,LOW(0x14)
	BRSH _0x9A
; 0000 0303                 if(ButtonFilter[1]<ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000011001,1
	CPI  R26,LOW(0x14)
	BRSH _0x9B
; 0000 0304                 ButtonFilter[1]++;
	__GETB1MN _ButtonFilter_S0000011001,1
	SUBI R30,-LOW(1)
	__PUTB1MN _ButtonFilter_S0000011001,1
; 0000 0305                 }
; 0000 0306             }
_0x9B:
; 0000 0307         }
_0x9A:
; 0000 0308         else{
	RJMP _0x9C
_0x99:
; 0000 0309             if(ButtonFilter[1]>=ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000011001,1
	CPI  R26,LOW(0x14)
	BRLO _0x9D
; 0000 030A             BUTTON[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _BUTTON_S0000011001,1
; 0000 030B             RefreshLcd = 1;
	MOV  R4,R30
; 0000 030C             }
; 0000 030D             else{
	RJMP _0x9E
_0x9D:
; 0000 030E             BUTTON[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _BUTTON_S0000011001,1
; 0000 030F             }
_0x9E:
; 0000 0310         ButtonFilter[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000011001,1
; 0000 0311         }
_0x9C:
; 0000 0312 
; 0000 0313     // 2 ir 3 Mygtukas
; 0000 0314         if((BUTTON_INPUT2==1)&&(BUTTON_INPUT3==1)){
	SBIS 0x10,5
	RJMP _0xA0
	SBIC 0x10,4
	RJMP _0xA1
_0xA0:
	RJMP _0x9F
_0xA1:
; 0000 0315         ButtonFilter[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000011001,1
; 0000 0316         ButtonFilter[2] = 0;
	__PUTB1MN _ButtonFilter_S0000011001,2
; 0000 0317             if(DualButtonFilter[1]<ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000011001,1
	CPI  R26,LOW(0x14)
	BRSH _0xA2
; 0000 0318             DualButtonFilter[1]++;
	__GETB1MN _DualButtonFilter_S0000011001,1
	SUBI R30,-LOW(1)
	__PUTB1MN _DualButtonFilter_S0000011001,1
; 0000 0319             }
; 0000 031A         }
_0xA2:
; 0000 031B         else if((BUTTON_INPUT2==0)&&(BUTTON_INPUT3==0)){
	RJMP _0xA3
_0x9F:
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xA5
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xA6
_0xA5:
	RJMP _0xA4
_0xA6:
; 0000 031C             if(DualButtonFilter[1]>=ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000011001,1
	CPI  R26,LOW(0x14)
	BRLO _0xA7
; 0000 031D             DUAL_BUTTON[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _DUAL_BUTTON_S0000011001,1
; 0000 031E             RefreshLcd = 1;
	MOV  R4,R30
; 0000 031F             }
; 0000 0320             else{
	RJMP _0xA8
_0xA7:
; 0000 0321             DUAL_BUTTON[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DUAL_BUTTON_S0000011001,1
; 0000 0322             }
_0xA8:
; 0000 0323         DualButtonFilter[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DualButtonFilter_S0000011001,1
; 0000 0324         }
; 0000 0325 
; 0000 0326     // 3 Mygtukas
; 0000 0327         if(BUTTON_INPUT3==1){
_0xA4:
_0xA3:
	SBIS 0x10,4
	RJMP _0xA9
; 0000 0328         PAGRINDINIS_LANGAS = 0;
	CLR  R7
; 0000 0329             if(ButtonFilter[2]<ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000011001,2
	CPI  R26,LOW(0x14)
	BRSH _0xAA
; 0000 032A             ButtonFilter[2]++;
	__GETB1MN _ButtonFilter_S0000011001,2
	SUBI R30,-LOW(1)
	__PUTB1MN _ButtonFilter_S0000011001,2
; 0000 032B             }
; 0000 032C         }
_0xAA:
; 0000 032D         else{
	RJMP _0xAB
_0xA9:
; 0000 032E             if(ButtonFilter[2]>=ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000011001,2
	CPI  R26,LOW(0x14)
	BRLO _0xAC
; 0000 032F             BUTTON[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _BUTTON_S0000011001,2
; 0000 0330             RefreshLcd = 1;
	MOV  R4,R30
; 0000 0331             }
; 0000 0332             else{
	RJMP _0xAD
_0xAC:
; 0000 0333             BUTTON[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _BUTTON_S0000011001,2
; 0000 0334             }
_0xAD:
; 0000 0335         ButtonFilter[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000011001,2
; 0000 0336         }
_0xAB:
; 0000 0337 
; 0000 0338     // 3 ir 4 Mygtukas
; 0000 0339         if((BUTTON_INPUT3==1)&&(BUTTON_INPUT4==1)){
	SBIS 0x10,4
	RJMP _0xAF
	SBIC 0x10,3
	RJMP _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
; 0000 033A         ButtonFilter[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000011001,2
; 0000 033B         ButtonFilter[3] = 0;
	__PUTB1MN _ButtonFilter_S0000011001,3
; 0000 033C             if(DualButtonFilter[2]<ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000011001,2
	CPI  R26,LOW(0x14)
	BRSH _0xB1
; 0000 033D             DualButtonFilter[2]++;
	__GETB1MN _DualButtonFilter_S0000011001,2
	SUBI R30,-LOW(1)
	__PUTB1MN _DualButtonFilter_S0000011001,2
; 0000 033E             }
; 0000 033F         }
_0xB1:
; 0000 0340         else if((BUTTON_INPUT3==0)&&(BUTTON_INPUT4==0)){
	RJMP _0xB2
_0xAE:
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xB4
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xB5
_0xB4:
	RJMP _0xB3
_0xB5:
; 0000 0341             if(DualButtonFilter[2]>=ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000011001,2
	CPI  R26,LOW(0x14)
	BRLO _0xB6
; 0000 0342             DUAL_BUTTON[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _DUAL_BUTTON_S0000011001,2
; 0000 0343             RefreshLcd = 1;
	MOV  R4,R30
; 0000 0344             }
; 0000 0345             else{
	RJMP _0xB7
_0xB6:
; 0000 0346             DUAL_BUTTON[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DUAL_BUTTON_S0000011001,2
; 0000 0347             }
_0xB7:
; 0000 0348         DualButtonFilter[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DualButtonFilter_S0000011001,2
; 0000 0349         }
; 0000 034A 
; 0000 034B     // 4 Mygtukas
; 0000 034C         if(BUTTON_INPUT4==1){
_0xB3:
_0xB2:
	SBIS 0x10,3
	RJMP _0xB8
; 0000 034D         PAGRINDINIS_LANGAS = 0;
	CLR  R7
; 0000 034E             if(ButtonFilter[3]<ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000011001,3
	CPI  R26,LOW(0x14)
	BRSH _0xB9
; 0000 034F             ButtonFilter[3]++;
	__GETB1MN _ButtonFilter_S0000011001,3
	SUBI R30,-LOW(1)
	__PUTB1MN _ButtonFilter_S0000011001,3
; 0000 0350             }
; 0000 0351         }
_0xB9:
; 0000 0352         else{
	RJMP _0xBA
_0xB8:
; 0000 0353             if(ButtonFilter[3]>=ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000011001,3
	CPI  R26,LOW(0x14)
	BRLO _0xBB
; 0000 0354             BUTTON[3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _BUTTON_S0000011001,3
; 0000 0355             RefreshLcd = 1;
	MOV  R4,R30
; 0000 0356             }
; 0000 0357             else{
	RJMP _0xBC
_0xBB:
; 0000 0358             BUTTON[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _BUTTON_S0000011001,3
; 0000 0359             }
_0xBC:
; 0000 035A         ButtonFilter[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000011001,3
; 0000 035B         }
_0xBA:
; 0000 035C 
; 0000 035D     // 4 ir 5 Mygtukas
; 0000 035E         if((BUTTON_INPUT4==1)&&(BUTTON_INPUT5==1)){
	SBIS 0x10,3
	RJMP _0xBE
	SBIC 0x10,2
	RJMP _0xBF
_0xBE:
	RJMP _0xBD
_0xBF:
; 0000 035F         ButtonFilter[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000011001,3
; 0000 0360         ButtonFilter[4] = 0;
	__PUTB1MN _ButtonFilter_S0000011001,4
; 0000 0361             if(DualButtonFilter[3]<ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000011001,3
	CPI  R26,LOW(0x14)
	BRSH _0xC0
; 0000 0362             DualButtonFilter[3]++;
	__GETB1MN _DualButtonFilter_S0000011001,3
	SUBI R30,-LOW(1)
	__PUTB1MN _DualButtonFilter_S0000011001,3
; 0000 0363             }
; 0000 0364         }
_0xC0:
; 0000 0365         else if((BUTTON_INPUT4==0)&&(BUTTON_INPUT5==0)){
	RJMP _0xC1
_0xBD:
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xC3
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xC4
_0xC3:
	RJMP _0xC2
_0xC4:
; 0000 0366             if(DualButtonFilter[3]>=ButtonFiltrationTimer){
	__GETB2MN _DualButtonFilter_S0000011001,3
	CPI  R26,LOW(0x14)
	BRLO _0xC5
; 0000 0367             DUAL_BUTTON[3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _DUAL_BUTTON_S0000011001,3
; 0000 0368             RefreshLcd = 1;
	MOV  R4,R30
; 0000 0369             }
; 0000 036A             else{
	RJMP _0xC6
_0xC5:
; 0000 036B             DUAL_BUTTON[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DUAL_BUTTON_S0000011001,3
; 0000 036C             }
_0xC6:
; 0000 036D         DualButtonFilter[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _DualButtonFilter_S0000011001,3
; 0000 036E         }
; 0000 036F 
; 0000 0370     // 5 Mygtukas
; 0000 0371         if(BUTTON_INPUT5==1){
_0xC2:
_0xC1:
	SBIS 0x10,2
	RJMP _0xC7
; 0000 0372         PAGRINDINIS_LANGAS = 0;
	CLR  R7
; 0000 0373             if(ButtonFilter[4]<ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000011001,4
	CPI  R26,LOW(0x14)
	BRSH _0xC8
; 0000 0374             ButtonFilter[4]++;
	__GETB1MN _ButtonFilter_S0000011001,4
	SUBI R30,-LOW(1)
	__PUTB1MN _ButtonFilter_S0000011001,4
; 0000 0375             }
; 0000 0376         }
_0xC8:
; 0000 0377         else{
	RJMP _0xC9
_0xC7:
; 0000 0378             if(ButtonFilter[4]>=ButtonFiltrationTimer){
	__GETB2MN _ButtonFilter_S0000011001,4
	CPI  R26,LOW(0x14)
	BRLO _0xCA
; 0000 0379             BUTTON[4] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _BUTTON_S0000011001,4
; 0000 037A             RefreshLcd = 1;
	MOV  R4,R30
; 0000 037B             }
; 0000 037C             else{
	RJMP _0xCB
_0xCA:
; 0000 037D             BUTTON[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _BUTTON_S0000011001,4
; 0000 037E             }
_0xCB:
; 0000 037F         ButtonFilter[4] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _ButtonFilter_S0000011001,4
; 0000 0380         }
_0xC9:
; 0000 0381     //////////////////////////////////////////////////////////////////////////////////
; 0000 0382     //////////////////////////////////////////////////////////////////////////////////
; 0000 0383     //////////////////////////////////////////////////////////////////////////////////
; 0000 0384 
; 0000 0385 
; 0000 0386 
; 0000 0387 
; 0000 0388     //////////////////////////////////////////////////////////////////////////////////
; 0000 0389     ///////////////////////////// LCD ////////////////////////////////////////////////
; 0000 038A     //////////////////////////////////////////////////////////////////////////////////
; 0000 038B     // Pagrindiniame meniu vaikscioti kairen desinen
; 0000 038C         if(Address[1]==0){// Jei y == 0, tai pagrindinis meniu
	__GETB1MN _Address,1
	CPI  R30,0
	BRNE _0xCC
; 0000 038D             if(Address[2]==0){
	__GETB1MN _Address,2
	CPI  R30,0
	BRNE _0xCD
; 0000 038E 
; 0000 038F                 if(DUAL_BUTTON[0]==1){
	LDS  R26,_DUAL_BUTTON_S0000011001
	CPI  R26,LOW(0x1)
	BRNE _0xCE
; 0000 0390                 Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address,R30
; 0000 0391                 }
; 0000 0392 
; 0000 0393                 if(BUTTON[0]==1){
_0xCE:
	LDS  R26,_BUTTON_S0000011001
	CPI  R26,LOW(0x1)
	BRNE _0xCF
; 0000 0394                     if(Address[0]>0){
	LDS  R26,_Address
	CPI  R26,LOW(0x1)
	BRLT _0xD0
; 0000 0395                     Address[0]--;
	LDS  R30,_Address
	SUBI R30,LOW(1)
	STS  _Address,R30
; 0000 0396                     RefreshLcd = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0397                     }
; 0000 0398                     else{
	RJMP _0xD1
_0xD0:
; 0000 0399                     Address[0] = 13;
	LDI  R30,LOW(13)
	STS  _Address,R30
; 0000 039A                     }
_0xD1:
; 0000 039B                 }
; 0000 039C                 else if(BUTTON[1]==1){
	RJMP _0xD2
_0xCF:
	__GETB2MN _BUTTON_S0000011001,1
	CPI  R26,LOW(0x1)
	BRNE _0xD3
; 0000 039D                     if(Address[0]<13){
	LDS  R26,_Address
	CPI  R26,LOW(0xD)
	BRGE _0xD4
; 0000 039E                     Address[0]++;
	LDS  R30,_Address
	SUBI R30,-LOW(1)
	STS  _Address,R30
; 0000 039F                     RefreshLcd = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 03A0                     }
; 0000 03A1                     else{
	RJMP _0xD5
_0xD4:
; 0000 03A2                     Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address,R30
; 0000 03A3                     }
_0xD5:
; 0000 03A4                 }
; 0000 03A5             }
_0xD3:
_0xD2:
; 0000 03A6         }
_0xCD:
; 0000 03A7 
; 0000 03A8         if(RefreshLcd==1){
_0xCC:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0xD6
; 0000 03A9         lcd_clear();
	CALL _lcd_clear
; 0000 03AA         }
; 0000 03AB 
; 0000 03AC         if(CODE_IsEntering==0){
_0xD6:
	LDS  R30,_CODE_IsEntering_G000
	CPI  R30,0
	BREQ PC+3
	JMP _0xD7
; 0000 03AD             // Pagrindinis langas
; 0000 03AE             if(Address[0]==0){
	LDS  R30,_Address
	CPI  R30,0
	BREQ PC+3
	JMP _0xD8
; 0000 03AF                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R4
	BREQ PC+3
	JMP _0xD9
; 0000 03B0                 // LAIKAS: 12:34
; 0000 03B1                 lcd_putsf("LAIKAS: ");
	__POINTW1FN _0x0,140
	CALL SUBOPT_0x12
; 0000 03B2                 lcd_put_number(0,2,0,0,RealTimeHour,0);
	CALL SUBOPT_0x10
	CALL SUBOPT_0x13
; 0000 03B3                 lcd_putsf(":");
; 0000 03B4                 lcd_put_number(0,2,0,0,RealTimeMinute,0);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x13
; 0000 03B5                 lcd_putsf(":");
; 0000 03B6                 lcd_put_number(0,2,0,0,RealTimeSecond,0);
	MOV  R30,R5
	LDI  R31,0
	CALL SUBOPT_0x14
; 0000 03B7                 lcd_putsf("   ");
	CALL SUBOPT_0x15
; 0000 03B8                     if(Address[1]==0){
	__GETB1MN _Address,1
	CPI  R30,0
	BRNE _0xDA
; 0000 03B9                     lcd_putsf("<");
	__POINTW1FN _0x0,115
	RJMP _0x166
; 0000 03BA                     }
; 0000 03BB                     else{
_0xDA:
; 0000 03BC                     lcd_putsf(" ");
	__POINTW1FN _0x0,118
_0x166:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 03BD                     }
; 0000 03BE 
; 0000 03BF                 lcd_putsf("DATA:");
	__POINTW1FN _0x0,149
	CALL SUBOPT_0x16
; 0000 03C0                 lcd_put_number(0,4,0,0,RealTimeYear,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(4)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x0
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _lcd_put_number
; 0000 03C1                 lcd_putsf(".");
	__POINTW1FN _0x0,31
	CALL SUBOPT_0x12
; 0000 03C2                 lcd_put_number(0,2,0,0,RealTimeMonth,0);
	CALL SUBOPT_0x1
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL SUBOPT_0x14
; 0000 03C3                 lcd_putsf(".");
	__POINTW1FN _0x0,31
	CALL SUBOPT_0x12
; 0000 03C4                 lcd_put_number(0,2,0,0,RealTimeDay,0);
	CALL SUBOPT_0x3
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL SUBOPT_0x14
; 0000 03C5                 lcd_putsf("    ");
	__POINTW1FN _0x0,155
	CALL SUBOPT_0x16
; 0000 03C6                     if(Address[1]==1){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x1)
	BRNE _0xDC
; 0000 03C7                     lcd_putsf("<");
	__POINTW1FN _0x0,115
	RJMP _0x167
; 0000 03C8                     }
; 0000 03C9                     else{
_0xDC:
; 0000 03CA                     lcd_putsf(" ");
	__POINTW1FN _0x0,118
_0x167:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 03CB                     }
; 0000 03CC 
; 0000 03CD                 lcd_putsf("SKAMBEJIMAI        ");
	__POINTW1FN _0x0,160
	CALL SUBOPT_0x16
; 0000 03CE                     if(Address[1]==2){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x2)
	BRNE _0xDE
; 0000 03CF                     lcd_putsf("<");
	__POINTW1FN _0x0,115
	RJMP _0x168
; 0000 03D0                     }
; 0000 03D1                     else{
_0xDE:
; 0000 03D2                     lcd_putsf(" ");
	__POINTW1FN _0x0,118
_0x168:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 03D3                     }
; 0000 03D4 
; 0000 03D5                 lcd_putsf("NUSTATYMAI         ");
	__POINTW1FN _0x0,180
	CALL SUBOPT_0x16
; 0000 03D6                     if(Address[1]==3){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x3)
	BRNE _0xE0
; 0000 03D7                     lcd_putsf("<");
	__POINTW1FN _0x0,115
	RJMP _0x169
; 0000 03D8                     }
; 0000 03D9                     else{
_0xE0:
; 0000 03DA                     lcd_putsf(" ");
	__POINTW1FN _0x0,118
_0x169:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 03DB                     }
; 0000 03DC 
; 0000 03DD 
; 0000 03DE                     // Kursoriai
; 0000 03DF                     if(Address[1]==0){
	__GETB1MN _Address,1
	CPI  R30,0
	BRNE _0xE2
; 0000 03E0                         if(Address[2]==1){
	__GETB2MN _Address,2
	CPI  R26,LOW(0x1)
	BRNE _0xE3
; 0000 03E1                         lcd_cursor(8,0);
	LDI  R30,LOW(8)
	RJMP _0x16A
; 0000 03E2                         }
; 0000 03E3                         else if(Address[2]==2){
_0xE3:
	__GETB2MN _Address,2
	CPI  R26,LOW(0x2)
	BRNE _0xE5
; 0000 03E4                         lcd_cursor(9,0);
	LDI  R30,LOW(9)
	RJMP _0x16A
; 0000 03E5                         }
; 0000 03E6 
; 0000 03E7                         else if(Address[2]==3){
_0xE5:
	__GETB2MN _Address,2
	CPI  R26,LOW(0x3)
	BRNE _0xE7
; 0000 03E8                         lcd_cursor(11,0);
	LDI  R30,LOW(11)
	RJMP _0x16A
; 0000 03E9                         }
; 0000 03EA                         else if(Address[2]==4){
_0xE7:
	__GETB2MN _Address,2
	CPI  R26,LOW(0x4)
	BRNE _0xE9
; 0000 03EB                         lcd_cursor(12,0);
	LDI  R30,LOW(12)
_0x16A:
	ST   -Y,R30
	CALL SUBOPT_0x18
; 0000 03EC                         }
; 0000 03ED                     }
_0xE9:
; 0000 03EE                     else if(Address[1]==1){
	RJMP _0xEA
_0xE2:
	__GETB2MN _Address,1
	CPI  R26,LOW(0x1)
	BRNE _0xEB
; 0000 03EF                         if(Address[2]==1){
	__GETB2MN _Address,2
	CPI  R26,LOW(0x1)
	BRNE _0xEC
; 0000 03F0                         lcd_cursor(5,1);
	LDI  R30,LOW(5)
	RJMP _0x16B
; 0000 03F1                         }
; 0000 03F2                         else if(Address[2]==2){
_0xEC:
	__GETB2MN _Address,2
	CPI  R26,LOW(0x2)
	BRNE _0xEE
; 0000 03F3                         lcd_cursor(6,1);
	LDI  R30,LOW(6)
	RJMP _0x16B
; 0000 03F4                         }
; 0000 03F5                         else if(Address[2]==3){
_0xEE:
	__GETB2MN _Address,2
	CPI  R26,LOW(0x3)
	BRNE _0xF0
; 0000 03F6                         lcd_cursor(7,1);
	LDI  R30,LOW(7)
	RJMP _0x16B
; 0000 03F7                         }
; 0000 03F8                         else if(Address[2]==4){
_0xF0:
	__GETB2MN _Address,2
	CPI  R26,LOW(0x4)
	BRNE _0xF2
; 0000 03F9                         lcd_cursor(8,1);
	LDI  R30,LOW(8)
_0x16B:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_cursor
; 0000 03FA                         }
; 0000 03FB 
; 0000 03FC                         if(Address[2]==5){
_0xF2:
	__GETB2MN _Address,2
	CPI  R26,LOW(0x5)
	BRNE _0xF3
; 0000 03FD                         lcd_cursor(10,0);
	LDI  R30,LOW(10)
	RJMP _0x16C
; 0000 03FE                         }
; 0000 03FF                         else if(Address[2]==6){
_0xF3:
	__GETB2MN _Address,2
	CPI  R26,LOW(0x6)
	BRNE _0xF5
; 0000 0400                         lcd_cursor(11,0);
	LDI  R30,LOW(11)
	RJMP _0x16C
; 0000 0401                         }
; 0000 0402 
; 0000 0403                         else if(Address[2]==7){
_0xF5:
	__GETB2MN _Address,2
	CPI  R26,LOW(0x7)
	BRNE _0xF7
; 0000 0404                         lcd_cursor(13,0);
	LDI  R30,LOW(13)
	RJMP _0x16C
; 0000 0405                         }
; 0000 0406                         else if(Address[2]==8){
_0xF7:
	__GETB2MN _Address,2
	CPI  R26,LOW(0x8)
	BRNE _0xF9
; 0000 0407                         lcd_cursor(14,0);
	LDI  R30,LOW(14)
_0x16C:
	ST   -Y,R30
	CALL SUBOPT_0x18
; 0000 0408                         }
; 0000 0409                     }
_0xF9:
; 0000 040A                 }
_0xEB:
_0xEA:
; 0000 040B 
; 0000 040C                 if(Address[2]==0){
_0xD9:
	__GETB1MN _Address,2
	CPI  R30,0
	BREQ PC+3
	JMP _0xFA
; 0000 040D                     if(BUTTON[0]==1){
	LDS  R26,_BUTTON_S0000011001
	CPI  R26,LOW(0x1)
	BRNE _0xFB
; 0000 040E                         if(Address[1]>0){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x1)
	BRLT _0xFC
; 0000 040F                         Address[1]--;
	CALL SUBOPT_0x19
; 0000 0410                         }
; 0000 0411                     }
_0xFC:
; 0000 0412                     else if(BUTTON[1]==1){
	RJMP _0xFD
_0xFB:
	__GETB2MN _BUTTON_S0000011001,1
	CPI  R26,LOW(0x1)
	BRNE _0xFE
; 0000 0413                         if(Address[1]<3){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x3)
	BRGE _0xFF
; 0000 0414                         Address[1]++;
	CALL SUBOPT_0x1A
; 0000 0415                         }
; 0000 0416                     }
_0xFF:
; 0000 0417 
; 0000 0418                     if(BUTTON[4]==1){
_0xFE:
_0xFD:
	__GETB2MN _BUTTON_S0000011001,4
	CPI  R26,LOW(0x1)
	BRNE _0x100
; 0000 0419                         if(Address[1]==0){
	__GETB1MN _Address,1
	CPI  R30,0
	BRNE _0x101
; 0000 041A                         Address[0] = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1B
; 0000 041B                         Address[1] = 0;
; 0000 041C                         Address[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address,2
; 0000 041D                         }
; 0000 041E                         if(Address[1]==1){
_0x101:
	__GETB2MN _Address,1
	CPI  R26,LOW(0x1)
	BRNE _0x102
; 0000 041F                         Address[0] = 0;
	LDI  R30,LOW(0)
	STS  _Address,R30
; 0000 0420                         Address[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _Address,1
; 0000 0421                         Address[2] = 1;
	__PUTB1MN _Address,2
; 0000 0422                         }
; 0000 0423                         if(Address[1]==2){
_0x102:
	__GETB2MN _Address,1
	CPI  R26,LOW(0x2)
	BRNE _0x103
; 0000 0424                         Address[0] = 1;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1B
; 0000 0425                         Address[1] = 0;
; 0000 0426                         Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address,2
; 0000 0427                         }
; 0000 0428                         if(Address[1]==3){
_0x103:
	__GETB2MN _Address,1
	CPI  R26,LOW(0x3)
	BRNE _0x104
; 0000 0429                         Address[0] = 2;
	LDI  R30,LOW(2)
	CALL SUBOPT_0x1B
; 0000 042A                         Address[1] = 0;
; 0000 042B                         Address[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _Address,2
; 0000 042C                         }
; 0000 042D                     }
_0x104:
; 0000 042E                 }
_0x100:
; 0000 042F                 else{
	RJMP _0x105
_0xFA:
; 0000 0430                     if(Address[1]==1){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x1)
	BRNE _0x106
; 0000 0431                         if(BUTTON[0]==1){
	LDS  R26,_BUTTON_S0000011001
	CPI  R26,LOW(0x1)
	BRNE _0x107
; 0000 0432                             if(Address[1]>0){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x1)
	BRLT _0x108
; 0000 0433                             Address[1]--;
	CALL SUBOPT_0x19
; 0000 0434                             }
; 0000 0435                         }
_0x108:
; 0000 0436                         else if(BUTTON[1]==1){
	RJMP _0x109
_0x107:
	__GETB2MN _BUTTON_S0000011001,1
	CPI  R26,LOW(0x1)
	BRNE _0x10A
; 0000 0437                             if(Address[1]<4){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x4)
	BRGE _0x10B
; 0000 0438                             Address[1]++;
	CALL SUBOPT_0x1A
; 0000 0439                             }
; 0000 043A                         }
_0x10B:
; 0000 043B                     }
_0x10A:
_0x109:
; 0000 043C                     else if(Address[1]==2){
	RJMP _0x10C
_0x106:
	__GETB2MN _Address,1
	CPI  R26,LOW(0x2)
	BRNE _0x10D
; 0000 043D                         if(BUTTON[0]==1){
	LDS  R26,_BUTTON_S0000011001
	CPI  R26,LOW(0x1)
	BRNE _0x10E
; 0000 043E                             if(Address[1]>0){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x1)
	BRLT _0x10F
; 0000 043F                             Address[1]--;
	CALL SUBOPT_0x19
; 0000 0440                             }
; 0000 0441                         }
_0x10F:
; 0000 0442                         else if(BUTTON[1]==1){
	RJMP _0x110
_0x10E:
	__GETB2MN _BUTTON_S0000011001,1
	CPI  R26,LOW(0x1)
	BRNE _0x111
; 0000 0443                             if(Address[1]<8){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x8)
	BRGE _0x112
; 0000 0444                             Address[1]++;
	CALL SUBOPT_0x1A
; 0000 0445                             }
; 0000 0446                         }
_0x112:
; 0000 0447                     }
_0x111:
_0x110:
; 0000 0448 
; 0000 0449                 }
_0x10D:
_0x10C:
_0x105:
; 0000 044A             }
; 0000 044B 
; 0000 044C             // Skambejimai
; 0000 044D             else if(Address[0]==1){
	RJMP _0x113
_0xD8:
	LDS  R26,_Address
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x114
; 0000 044E                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x115
; 0000 044F                 lcd_putsf("1.VELYKU LAIKAS");
	__POINTW1FN _0x0,200
	CALL SUBOPT_0x16
; 0000 0450                     if(Address[1]==0){
	__GETB1MN _Address,1
	CPI  R30,0
	BRNE _0x116
; 0000 0451                     lcd_putsf("<");
	__POINTW1FN _0x0,115
	RJMP _0x16D
; 0000 0452                     }
; 0000 0453                     else{
_0x116:
; 0000 0454                     lcd_putsf(" ");
	__POINTW1FN _0x0,118
_0x16D:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0455                     }
; 0000 0456 
; 0000 0457                 lcd_putsf("2.KALEDU LAIKAS");
	__POINTW1FN _0x0,216
	CALL SUBOPT_0x16
; 0000 0458                     if(Address[1]==1){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x1)
	BRNE _0x118
; 0000 0459                     lcd_putsf("<");
	__POINTW1FN _0x0,115
	RJMP _0x16E
; 0000 045A                     }
; 0000 045B                     else{
_0x118:
; 0000 045C                     lcd_putsf(" ");
	__POINTW1FN _0x0,118
_0x16E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 045D                     }
; 0000 045E 
; 0000 045F                 lcd_putsf("3.EILINIS LAIK.");
	__POINTW1FN _0x0,232
	CALL SUBOPT_0x16
; 0000 0460                     if(Address[1]==2){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x2)
	BRNE _0x11A
; 0000 0461                     lcd_putsf("<");
	__POINTW1FN _0x0,115
	RJMP _0x16F
; 0000 0462                     }
; 0000 0463                     else{
_0x11A:
; 0000 0464                     lcd_putsf(" ");
	__POINTW1FN _0x0,118
_0x16F:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0465                     }
; 0000 0466                 }
; 0000 0467 
; 0000 0468                 if(Address[2]==0){
_0x115:
	__GETB1MN _Address,2
	CPI  R30,0
	BRNE _0x11C
; 0000 0469                     if(BUTTON[0]==1){
	LDS  R26,_BUTTON_S0000011001
	CPI  R26,LOW(0x1)
	BRNE _0x11D
; 0000 046A                         if(Address[1]>0){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x1)
	BRLT _0x11E
; 0000 046B                         Address[1]--;
	CALL SUBOPT_0x19
; 0000 046C                         }
; 0000 046D                     }
_0x11E:
; 0000 046E                     else if(BUTTON[1]==1){
	RJMP _0x11F
_0x11D:
	__GETB2MN _BUTTON_S0000011001,1
	CPI  R26,LOW(0x1)
	BRNE _0x120
; 0000 046F                         if(Address[1]<2){
	__GETB2MN _Address,1
	CPI  R26,LOW(0x2)
	BRGE _0x121
; 0000 0470                         Address[1]++;
	CALL SUBOPT_0x1A
; 0000 0471                         }
; 0000 0472                     }
_0x121:
; 0000 0473 
; 0000 0474                     if(BUTTON[4]==1){
_0x120:
_0x11F:
	__GETB2MN _BUTTON_S0000011001,4
	CPI  R26,LOW(0x1)
	BRNE _0x122
; 0000 0475                         if(Address[1]==0){
	__GETB1MN _Address,1
	CPI  R30,0
	BRNE _0x123
; 0000 0476                         Address[0] = 1;
	LDI  R30,LOW(1)
	STS  _Address,R30
; 0000 0477                         Address[1] = 1;
	CALL SUBOPT_0x1C
; 0000 0478                         Address[2] = 0;
; 0000 0479                         }
; 0000 047A                         if(Address[1]==1){
_0x123:
	__GETB2MN _Address,1
	CPI  R26,LOW(0x1)
	BRNE _0x124
; 0000 047B                         Address[0] = 1;
	LDI  R30,LOW(1)
	STS  _Address,R30
; 0000 047C                         Address[1] = 2;
	LDI  R30,LOW(2)
	CALL SUBOPT_0x1C
; 0000 047D                         Address[2] = 0;
; 0000 047E                         }
; 0000 047F                         if(Address[1]==2){
_0x124:
	__GETB2MN _Address,1
	CPI  R26,LOW(0x2)
	BRNE _0x125
; 0000 0480                         Address[0] = 1;
	LDI  R30,LOW(1)
	STS  _Address,R30
; 0000 0481                         Address[1] = 3;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x1C
; 0000 0482                         Address[2] = 0;
; 0000 0483                         }
; 0000 0484                     }
_0x125:
; 0000 0485                 }
_0x122:
; 0000 0486             }
_0x11C:
; 0000 0487         }
_0x114:
_0x113:
; 0000 0488         else{
	RJMP _0x126
_0xD7:
; 0000 0489         /////////////////////////////////////////////////////////////////////
; 0000 048A             if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R4
	BREQ PC+3
	JMP _0x127
; 0000 048B             unsigned int i;
; 0000 048C             lcd_putsf("KODAS: ");
	SBIW R28,2
;	i -> Y+0
	__POINTW1FN _0x0,248
	CALL SUBOPT_0x16
; 0000 048D             i = CODE_EnteringCode;
	CALL SUBOPT_0x1D
	ST   Y,R30
	STD  Y+1,R31
; 0000 048E                 if(CODE_ExecutingDigit==0){
	LDS  R30,_CODE_ExecutingDigit_G000
	CPI  R30,0
	BRNE _0x128
; 0000 048F                 lcd_putchar( NumToIndex( i/1000) );
	CALL SUBOPT_0x1E
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x170
; 0000 0490                 }
; 0000 0491                 else{
_0x128:
; 0000 0492                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x170:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0493                 }
; 0000 0494             i = i - (i/1000)*1000;
	CALL SUBOPT_0x1E
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL SUBOPT_0x1F
; 0000 0495                 if(CODE_ExecutingDigit==1){
	CPI  R26,LOW(0x1)
	BRNE _0x12A
; 0000 0496                 lcd_putchar( NumToIndex( i/100) );
	CALL SUBOPT_0x20
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x171
; 0000 0497                 }
; 0000 0498                 else{
_0x12A:
; 0000 0499                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x171:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 049A                 }
; 0000 049B             i = i - (i/100)*100;
	CALL SUBOPT_0x20
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL SUBOPT_0x1F
; 0000 049C                 if(CODE_ExecutingDigit==2){
	CPI  R26,LOW(0x2)
	BRNE _0x12C
; 0000 049D                 lcd_putchar( NumToIndex( i/10) );
	CALL SUBOPT_0x21
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x172
; 0000 049E                 }
; 0000 049F                 else{
_0x12C:
; 0000 04A0                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x172:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 04A1                 }
; 0000 04A2             i = i - (i/10)*10;
	CALL SUBOPT_0x21
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL SUBOPT_0x1F
; 0000 04A3                 if(CODE_ExecutingDigit==3){
	CPI  R26,LOW(0x3)
	BRNE _0x12E
; 0000 04A4                 lcd_putchar( NumToIndex(i) );
	LD   R30,Y
	ST   -Y,R30
	RCALL _NumToIndex
	RJMP _0x173
; 0000 04A5                 }
; 0000 04A6                 else{
_0x12E:
; 0000 04A7                 lcd_putchar('*');
	LDI  R30,LOW(42)
_0x173:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 04A8                 }
; 0000 04A9 
; 0000 04AA             lcd_putsf("   ");
	CALL SUBOPT_0x15
; 0000 04AB 
; 0000 04AC             i = CODE_TimeLeft;
	LDS  R30,_CODE_TimeLeft_G000
	LDI  R31,0
	ST   Y,R30
	STD  Y+1,R31
; 0000 04AD             lcd_putchar( NumToIndex( i/10) );
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 04AE             i = i - (i/10)*10;
	CALL SUBOPT_0x21
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	LD   R26,Y
	LDD  R27,Y+1
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
; 0000 04AF             lcd_putchar( NumToIndex(i) );
	LD   R30,Y
	CALL SUBOPT_0x22
; 0000 04B0             }
	ADIW R28,2
; 0000 04B1 
; 0000 04B2         ///// 1 Kodo skaicius /////////
; 0000 04B3             if(CODE_ExecutingDigit==0){
_0x127:
	LDS  R30,_CODE_ExecutingDigit_G000
	CPI  R30,0
	BRNE _0x130
; 0000 04B4                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x131
; 0000 04B5                 lcd_buttons(0,1,1,1,1,0,0,0,0);
	CALL SUBOPT_0x23
	ST   -Y,R30
	LDI  R30,LOW(1)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x24
; 0000 04B6                 lcd_cursor(7,0);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL SUBOPT_0x18
; 0000 04B7                 }
; 0000 04B8 
; 0000 04B9             // pakeisti ivedama skaitmeni
; 0000 04BA                 if(BUTTON[1]==1){
_0x131:
	__GETB2MN _BUTTON_S0000011001,1
	CPI  R26,LOW(0x1)
	BRNE _0x132
; 0000 04BB                 CODE_ExecutingDigit++;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,-LOW(1)
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 04BC                 }
; 0000 04BD 
; 0000 04BE             // 1 kodo skaitmens keitimas
; 0000 04BF                 if(BUTTON[2]==1){
_0x132:
	__GETB2MN _BUTTON_S0000011001,2
	CPI  R26,LOW(0x1)
	BRNE _0x133
; 0000 04C0                     if(CODE_EnteringCode<9000){
	CALL SUBOPT_0x25
	CPI  R26,LOW(0x2328)
	LDI  R30,HIGH(0x2328)
	CPC  R27,R30
	BRSH _0x134
; 0000 04C1                     CODE_EnteringCode = CODE_EnteringCode + 1000;
	CALL SUBOPT_0x1D
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	CALL SUBOPT_0x26
; 0000 04C2                     }
; 0000 04C3                 }
_0x134:
; 0000 04C4                 else if(BUTTON[3]==1){
	RJMP _0x135
_0x133:
	__GETB2MN _BUTTON_S0000011001,3
	CPI  R26,LOW(0x1)
	BRNE _0x136
; 0000 04C5                     if(CODE_EnteringCode>=1000){
	CALL SUBOPT_0x25
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLO _0x137
; 0000 04C6                     CODE_EnteringCode = CODE_EnteringCode - 1000;
	CALL SUBOPT_0x1D
	SUBI R30,LOW(1000)
	SBCI R31,HIGH(1000)
	CALL SUBOPT_0x26
; 0000 04C7                     }
; 0000 04C8                 }
_0x137:
; 0000 04C9             }
_0x136:
_0x135:
; 0000 04CA         ///////////////////////////////
; 0000 04CB 
; 0000 04CC         ///// 2 Kodo skaicius /////////
; 0000 04CD             else if(CODE_ExecutingDigit==1){
	RJMP _0x138
_0x130:
	LDS  R26,_CODE_ExecutingDigit_G000
	CPI  R26,LOW(0x1)
	BRNE _0x139
; 0000 04CE                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x13A
; 0000 04CF                 lcd_buttons(1,1,1,1,1,0,0,0,0);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x24
; 0000 04D0                 lcd_cursor(8,0);
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL SUBOPT_0x18
; 0000 04D1                 }
; 0000 04D2 
; 0000 04D3                 if(BUTTON[0]==1){
_0x13A:
	LDS  R26,_BUTTON_S0000011001
	CPI  R26,LOW(0x1)
	BRNE _0x13B
; 0000 04D4                 CODE_ExecutingDigit--;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,LOW(1)
	RJMP _0x174
; 0000 04D5                 }
; 0000 04D6                 else if(BUTTON[1]==1){
_0x13B:
	__GETB2MN _BUTTON_S0000011001,1
	CPI  R26,LOW(0x1)
	BRNE _0x13D
; 0000 04D7                 CODE_ExecutingDigit++;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,-LOW(1)
_0x174:
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 04D8                 }
; 0000 04D9 
; 0000 04DA             // 2 kodo skaitmens keitimas
; 0000 04DB                 if(BUTTON[2]==1){
_0x13D:
	__GETB2MN _BUTTON_S0000011001,2
	CPI  R26,LOW(0x1)
	BRNE _0x13E
; 0000 04DC                     if(CODE_EnteringCode<9900){
	CALL SUBOPT_0x25
	CPI  R26,LOW(0x26AC)
	LDI  R30,HIGH(0x26AC)
	CPC  R27,R30
	BRSH _0x13F
; 0000 04DD                     CODE_EnteringCode = CODE_EnteringCode + 100;
	CALL SUBOPT_0x1D
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x26
; 0000 04DE                     }
; 0000 04DF                 }
_0x13F:
; 0000 04E0                 else if(BUTTON[3]==1){
	RJMP _0x140
_0x13E:
	__GETB2MN _BUTTON_S0000011001,3
	CPI  R26,LOW(0x1)
	BRNE _0x141
; 0000 04E1                     if(CODE_EnteringCode>=100){
	CALL SUBOPT_0x25
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0x142
; 0000 04E2                     CODE_EnteringCode = CODE_EnteringCode - 100;
	CALL SUBOPT_0x1D
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	CALL SUBOPT_0x26
; 0000 04E3                     }
; 0000 04E4                 }
_0x142:
; 0000 04E5             }
_0x141:
_0x140:
; 0000 04E6         ///////////////////////////////
; 0000 04E7 
; 0000 04E8         ///// 3 Kodo skaicius /////////
; 0000 04E9             else if(CODE_ExecutingDigit==2){
	RJMP _0x143
_0x139:
	LDS  R26,_CODE_ExecutingDigit_G000
	CPI  R26,LOW(0x2)
	BRNE _0x144
; 0000 04EA                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x145
; 0000 04EB                 lcd_buttons(1,1,1,1,1,0,0,0,0);
	CALL SUBOPT_0x27
	CALL SUBOPT_0x24
; 0000 04EC                 lcd_cursor(9,0);
	LDI  R30,LOW(9)
	ST   -Y,R30
	CALL SUBOPT_0x18
; 0000 04ED                 }
; 0000 04EE 
; 0000 04EF                 if(BUTTON[0]==1){
_0x145:
	LDS  R26,_BUTTON_S0000011001
	CPI  R26,LOW(0x1)
	BRNE _0x146
; 0000 04F0                 CODE_ExecutingDigit--;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,LOW(1)
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 04F1                 }
; 0000 04F2                 if(BUTTON[1]==1){
_0x146:
	__GETB2MN _BUTTON_S0000011001,1
	CPI  R26,LOW(0x1)
	BRNE _0x147
; 0000 04F3                 CODE_ExecutingDigit++;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,-LOW(1)
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 04F4                 }
; 0000 04F5 
; 0000 04F6             // 3 kodo skaitmens keitimas
; 0000 04F7                 if(BUTTON[2]==1){
_0x147:
	__GETB2MN _BUTTON_S0000011001,2
	CPI  R26,LOW(0x1)
	BRNE _0x148
; 0000 04F8                     if(CODE_EnteringCode<9990){
	CALL SUBOPT_0x25
	CPI  R26,LOW(0x2706)
	LDI  R30,HIGH(0x2706)
	CPC  R27,R30
	BRSH _0x149
; 0000 04F9                     CODE_EnteringCode = CODE_EnteringCode + 10;
	CALL SUBOPT_0x1D
	ADIW R30,10
	CALL SUBOPT_0x26
; 0000 04FA                     }
; 0000 04FB                 }
_0x149:
; 0000 04FC                 else if(BUTTON[3]==1){
	RJMP _0x14A
_0x148:
	__GETB2MN _BUTTON_S0000011001,3
	CPI  R26,LOW(0x1)
	BRNE _0x14B
; 0000 04FD                     if(CODE_EnteringCode>=10){
	CALL SUBOPT_0x25
	SBIW R26,10
	BRLO _0x14C
; 0000 04FE                     CODE_EnteringCode = CODE_EnteringCode - 10;
	CALL SUBOPT_0x1D
	SBIW R30,10
	CALL SUBOPT_0x26
; 0000 04FF                     }
; 0000 0500                 }
_0x14C:
; 0000 0501             }
_0x14B:
_0x14A:
; 0000 0502         ///////////////////////////////
; 0000 0503 
; 0000 0504         ///// 4 Kodo skaicius /////////
; 0000 0505             else if(CODE_ExecutingDigit==3){
	RJMP _0x14D
_0x144:
	LDS  R26,_CODE_ExecutingDigit_G000
	CPI  R26,LOW(0x3)
	BRNE _0x14E
; 0000 0506                 if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x14F
; 0000 0507                 lcd_buttons(1,0,1,1,1,0,0,0,0);
	ST   -Y,R30
	CALL SUBOPT_0x23
	CALL SUBOPT_0x17
	CALL SUBOPT_0x24
; 0000 0508                 lcd_cursor(10,0);
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL SUBOPT_0x18
; 0000 0509                 }
; 0000 050A 
; 0000 050B                 if(BUTTON[0]==1){
_0x14F:
	LDS  R26,_BUTTON_S0000011001
	CPI  R26,LOW(0x1)
	BRNE _0x150
; 0000 050C                 CODE_ExecutingDigit--;
	LDS  R30,_CODE_ExecutingDigit_G000
	SUBI R30,LOW(1)
	STS  _CODE_ExecutingDigit_G000,R30
; 0000 050D                 }
; 0000 050E 
; 0000 050F             // 4 kodo skaitmens keitimas
; 0000 0510                 if(BUTTON[2]==1){
_0x150:
	__GETB2MN _BUTTON_S0000011001,2
	CPI  R26,LOW(0x1)
	BRNE _0x151
; 0000 0511                     if(CODE_EnteringCode<9999){
	CALL SUBOPT_0x25
	CPI  R26,LOW(0x270F)
	LDI  R30,HIGH(0x270F)
	CPC  R27,R30
	BRSH _0x152
; 0000 0512                     CODE_EnteringCode = CODE_EnteringCode + 1;
	CALL SUBOPT_0x1D
	ADIW R30,1
	CALL SUBOPT_0x26
; 0000 0513                     }
; 0000 0514                 }
_0x152:
; 0000 0515                 else if(BUTTON[3]==1){
	RJMP _0x153
_0x151:
	__GETB2MN _BUTTON_S0000011001,3
	CPI  R26,LOW(0x1)
	BRNE _0x154
; 0000 0516                     if(CODE_EnteringCode>=1){
	CALL SUBOPT_0x25
	SBIW R26,1
	BRLO _0x155
; 0000 0517                     CODE_EnteringCode = CODE_EnteringCode - 1;
	CALL SUBOPT_0x1D
	SBIW R30,1
	CALL SUBOPT_0x26
; 0000 0518                     }
; 0000 0519                 }
_0x155:
; 0000 051A             }
_0x154:
_0x153:
; 0000 051B         ///////////////////////////////
; 0000 051C 
; 0000 051D             if(CODE_TimeLeft==0){
_0x14E:
_0x14D:
_0x143:
_0x138:
	LDS  R30,_CODE_TimeLeft_G000
	CPI  R30,0
	BRNE _0x156
; 0000 051E             Address[0] = CODE_FailedXYZ[0];
	CALL SUBOPT_0x28
; 0000 051F             Address[1] = CODE_FailedXYZ[1];
; 0000 0520             Address[2] = CODE_FailedXYZ[2];
; 0000 0521 
; 0000 0522             CODE_IsEntering = 0;
	CALL SUBOPT_0x29
; 0000 0523 
; 0000 0524             CODE_EnteringCode = 0;
; 0000 0525             CODE_ExecutingDigit = 0;
; 0000 0526 
; 0000 0527             CODE_TimeLeft = 0;
; 0000 0528 
; 0000 0529             CODE_SuccessXYZ[0] = 0;
; 0000 052A             CODE_SuccessXYZ[1] = 0;
; 0000 052B             CODE_SuccessXYZ[2] = 0;
; 0000 052C             lcd_clear();
	CALL _lcd_clear
; 0000 052D             lcd_putsf("    LAIKAS      ");
	__POINTW1FN _0x0,256
	CALL SUBOPT_0x16
; 0000 052E             lcd_putsf("    BAIGESI     ");
	__POINTW1FN _0x0,273
	CALL SUBOPT_0x16
; 0000 052F             delay_ms(1000);
	CALL SUBOPT_0x2A
; 0000 0530             }
; 0000 0531 
; 0000 0532 
; 0000 0533 
; 0000 0534             if(BUTTON[4]==1){
_0x156:
	__GETB2MN _BUTTON_S0000011001,4
	CPI  R26,LOW(0x1)
	BRNE _0x157
; 0000 0535                 if(CODE_EnteringCode==WhatIsTheCode()){
	RCALL _WhatIsTheCode
	CALL SUBOPT_0x25
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x158
; 0000 0536                 Address[0] = CODE_SuccessXYZ[0];
	LDS  R30,_CODE_SuccessXYZ_G000
	STS  _Address,R30
; 0000 0537                 Address[1] = CODE_SuccessXYZ[1];
	__GETB1MN _CODE_SuccessXYZ_G000,1
	__PUTB1MN _Address,1
; 0000 0538                 Address[2] = CODE_SuccessXYZ[2];
	__GETB1MN _CODE_SuccessXYZ_G000,2
	__PUTB1MN _Address,2
; 0000 0539                 lcd_clear();
	CALL SUBOPT_0x2B
; 0000 053A                 lcd_putsf("     KODAS      ");
; 0000 053B                 lcd_putsf("   TEISINGAS    ");
	__POINTW1FN _0x0,307
	RJMP _0x175
; 0000 053C                 delay_ms(1000);
; 0000 053D                 }
; 0000 053E                 else{
_0x158:
; 0000 053F                 Address[0] = CODE_FailedXYZ[0];
	CALL SUBOPT_0x28
; 0000 0540                 Address[1] = CODE_FailedXYZ[1];
; 0000 0541                 Address[2] = CODE_FailedXYZ[2];
; 0000 0542                 lcd_clear();
	CALL SUBOPT_0x2B
; 0000 0543                 lcd_putsf("     KODAS      ");
; 0000 0544                 lcd_putsf("  NETEISINGAS   ");
	__POINTW1FN _0x0,324
_0x175:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0545                 delay_ms(1000);
	CALL SUBOPT_0x2A
; 0000 0546                 }
; 0000 0547             CODE_IsEntering = 0;
	CALL SUBOPT_0x29
; 0000 0548 
; 0000 0549             CODE_EnteringCode = 0;
; 0000 054A             CODE_ExecutingDigit = 0;
; 0000 054B 
; 0000 054C             CODE_TimeLeft = 0;
; 0000 054D 
; 0000 054E             CODE_SuccessXYZ[0] = 0;
; 0000 054F             CODE_SuccessXYZ[1] = 0;
; 0000 0550             CODE_SuccessXYZ[2] = 0;
; 0000 0551             }
; 0000 0552 
; 0000 0553 
; 0000 0554         /////////////////////////////////////////////////////////////////////
; 0000 0555         }
_0x157:
_0x126:
; 0000 0556 
; 0000 0557         if(RefreshLcd==1){
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x15A
; 0000 0558         RefreshLcd = 0;
	CLR  R4
; 0000 0559         }
; 0000 055A     //////////////////////////////////////////////////////////////////////////////////
; 0000 055B     //////////////////////////////////////////////////////////////////////////////////
; 0000 055C     //////////////////////////////////////////////////////////////////////////////////
; 0000 055D     Called_1Second = 0;;
_0x15A:
	LDI  R30,LOW(0)
	STS  _Called_1Second_S0000011001,R30
; 0000 055E     delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 055F     };
	RJMP _0x79
; 0000 0560 }
_0x15B:
	RJMP _0x15B
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
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
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
	BRLO _0x2000004
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
_0x2000004:
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
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2C
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x2D
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2D
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x2D
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

	.ESEG
_RealTimeYear:
	.BYTE 0x2
_RealTimeMonth:
	.BYTE 0x1
_RealTimeDay:
	.BYTE 0x1
_RealTimeHour:
	.BYTE 0x1
_RealTimeMinute:
	.BYTE 0x1

	.DSEG
_Address:
	.BYTE 0x3
_MenuCreated:
	.BYTE 0xA
_CODE_IsEntering_G000:
	.BYTE 0x1
_CODE_SuccessXYZ_G000:
	.BYTE 0x3
_CODE_FailedXYZ_G000:
	.BYTE 0x3
_CODE_TimeLeft_G000:
	.BYTE 0x1
_CODE_EnteringCode_G000:
	.BYTE 0x2
_CODE_ExecutingDigit_G000:
	.BYTE 0x1
_InteruptTimer_S0000010000:
	.BYTE 0x2
_MissTimer_S0000010000:
	.BYTE 0x2
_RefreshTimer_S0000010000:
	.BYTE 0x2
_Called_1Second_S0000011001:
	.BYTE 0x1
_BUTTON_S0000011001:
	.BYTE 0x5
_ButtonFilter_S0000011001:
	.BYTE 0x5
_DUAL_BUTTON_S0000011001:
	.BYTE 0x4
_DualButtonFilter_S0000011001:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_RealTimeYear)
	LDI  R27,HIGH(_RealTimeYear)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_RealTimeMonth)
	LDI  R27,HIGH(_RealTimeMonth)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R31,0
	SBRC R30,7
	SER  R31
	MOVW R26,R0
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_RealTimeDay)
	LDI  R27,HIGH(_RealTimeDay)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	__GETD2N 0xA
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	__GETD1S 6
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x4
	CALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	__SUBD1N 1
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
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
SUBOPT_0xC:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0x7
	CALL __DIVD21U
	ST   Y,R30
	ST   -Y,R30
	CALL _NumToIndex
	ST   -Y,R30
	CALL _lcd_putchar
	LD   R26,Y
	CLR  R27
	RCALL SUBOPT_0xC
	CALL __CWD2
	CALL __MULD12U
	RCALL SUBOPT_0x7
	CALL __SUBD21
	__PUTD2S 1
	__GETD2S 6
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_RealTimeMinute)
	LDI  R27,HIGH(_RealTimeMinute)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_RealTimeHour)
	LDI  R27,HIGH(_RealTimeHour)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x12:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x13:
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _lcd_put_number
	__POINTW1FN _0x0,5
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x14:
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	JMP  _lcd_put_number

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	__POINTW1FN _0x0,129
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_cursor

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	__GETB1MN _Address,1
	SUBI R30,LOW(1)
	__PUTB1MN _Address,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	__GETB1MN _Address,1
	SUBI R30,-LOW(1)
	__PUTB1MN _Address,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	STS  _Address,R30
	LDI  R30,LOW(0)
	__PUTB1MN _Address,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	__PUTB1MN _Address,1
	LDI  R30,LOW(0)
	__PUTB1MN _Address,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1D:
	LDS  R30,_CODE_EnteringCode_G000
	LDS  R31,_CODE_EnteringCode_G000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	CALL __MULW12U
	LD   R26,Y
	LDD  R27,Y+1
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
	LDS  R26,_CODE_ExecutingDigit_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ST   -Y,R30
	CALL _NumToIndex
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_buttons

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x25:
	LDS  R26,_CODE_EnteringCode_G000
	LDS  R27,_CODE_EnteringCode_G000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x26:
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	LDS  R30,_CODE_FailedXYZ_G000
	STS  _Address,R30
	__GETB1MN _CODE_FailedXYZ_G000,1
	__PUTB1MN _Address,1
	__GETB1MN _CODE_FailedXYZ_G000,2
	__PUTB1MN _Address,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(0)
	STS  _CODE_IsEntering_G000,R30
	STS  _CODE_EnteringCode_G000,R30
	STS  _CODE_EnteringCode_G000+1,R30
	STS  _CODE_ExecutingDigit_G000,R30
	STS  _CODE_TimeLeft_G000,R30
	STS  _CODE_SuccessXYZ_G000,R30
	__PUTB1MN _CODE_SuccessXYZ_G000,1
	__PUTB1MN _CODE_SuccessXYZ_G000,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	CALL _lcd_clear
	__POINTW1FN _0x0,290
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
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
	__DELAY_USW 0x3E8
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

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

;END OF CODE MARKER
__END_OF_CODE:
