
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Speed
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

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
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
	.DEF _OSC=R4
	.DEF _SKIP=R7
	.DEF _UPS_STATE=R6
	.DEF _OLD_UPS_STATE=R9
	.DEF _KRAUTI=R8
	.DEF _LOAD=R11
	.DEF _BEEPER_OFF=R10
	.DEF _RealTime=R13
	.DEF _LangoAdresas=R12

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

_0x0:
	.DB  0x48,0x45,0x4C,0x4C,0x4F,0x0,0x64,0x69
	.DB  0x53,0x63,0x68,0x41,0x72,0x47,0x69,0x6E
	.DB  0x47,0x0,0x62,0x41,0x74,0x74,0x45,0x72
	.DB  0x59,0x20,0x46,0x6F,0x75,0x4C,0x74,0x0
	.DB  0x63,0x41,0x6E,0x74,0x20,0x64,0x69,0x53
	.DB  0x63,0x68,0x41,0x72,0x47,0x45,0x0
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;Project : UPS v2
;Version : v2
;Date    : 2011-03-25
;Author  : Tomas
;
;Chip type               : ATmega16
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;
;#define LED_SEGMENT_A PORTC.6
;#define LED_SEGMENT_B PORTC.4
;#define LED_SEGMENT_C PORTC.1
;#define LED_SEGMENT_D PORTC.3
;#define LED_SEGMENT_E PORTD.7
;#define LED_SEGMENT_F PORTC.5
;#define LED_SEGMENT_G PORTC.0
;#define LED_SEGMENT_H PORTC.2
;
;#define LED_BLOCK_0 PORTC.7
;#define LED_BLOCK_1 PORTA.6
;#define LED_BLOCK_2 PORTA.7
;#define LED_BLOCK_3 PORTA.4
;
;
;///////////////////// VARIABLES /////////////////////////////////////
;int OSC;
;char BUTTON[4];
;//char BATTERY;
;char SKIP;
;char UPS_STATE,OLD_UPS_STATE;
;eeprom char BATTERY_FOULT;
;char KRAUTI, LOAD, BEEPER_OFF;
;
;char LcdText[4], LcdTaskas[4];
;
;char RealTime;
;
;
;
;
;
;unsigned int Timer3;// Begancio Taskelio Taimeris
;
;eeprom unsigned int Timer4;// Paskutinio Iskrorivimo valandos
;eeprom unsigned int Timer5;// Paskutinio Iskrorivimo minutes
;
;unsigned int Timer7;// Dabartinio Iskrovimo Laiko Sekundziu Skaicius
;unsigned int Timer8;// Dabartinio Iskrovimo Laiko Minuciu Skaicius
;unsigned int Timer9;// Dabartinio Iskrovimo Laiko Valandu Skaicius
;
;unsigned int Timer10;// 2 Mygtuko Uzlaikymo Taimeris
;
;unsigned int Timer11;// 3 Mygtuko Uzlaikymo Taimeris
;
;unsigned int Timer12;// Krovimo taimeris (30 sec)
;
;//unsigned int Timer13;
;
;unsigned int Timer14;// Iskrovimo sustabdymo taimeris
;
;//signed int Timer15;// 1 savaites taimerio sekundes dalis
;
;
;unsigned int Timer19;// "diSchArGE FouLt" taimeris
;
;unsigned int Timer20;// "diSchArGinG" taimeris
;
;//unsigned int Timer22;
;
;//unsigned int Timer23;
;
;unsigned int Timer24;// ms skaicius po kiekvienos iskrovimo laiko sekundes suejimo
;
;char LangoAdresas;
;char LanguTrigeris;
;
;unsigned int BATTERY_VOLTAGE;// Baterijos itampa (U x 10)
;unsigned int BATTERY_VOLTAGE_ARCHIVE[10];
;eeprom unsigned int MAX_BATTERY_VOLTAGE;// Baterijos maksimali itampa (Umax x 10)
;eeprom unsigned int MIN_BATTERY_VOLTAGE;// Baterijos minimali itampa (Umin x 10)
;char ItamposTrigeris1;
;char ItamposTrigeris2;
;
;/////////////////////////////////////////////////////////////////////
;#define ADC_VREF_TYPE 0x40
;unsigned int read_adc(unsigned char adc_input){
; 0000 005E unsigned int read_adc(unsigned char adc_input){

	.CSEG
_read_adc:
; 0000 005F ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0060 delay_us(10);
	__DELAY_USB 27
; 0000 0061 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0062     while((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0063 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0064 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x2020004
; 0000 0065 }
;/////////////////////////////////////////////////////////////////////
;/////////////////////////////////////////////////////////////////////
;char NumToIndex(char Num){
; 0000 0068 char NumToIndex(char Num){
_NumToIndex:
; 0000 0069     if(Num==0){     return '0';}
;	Num -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x6
	LDI  R30,LOW(48)
	RJMP _0x2020004
; 0000 006A     else if(Num==1){return '1';}
_0x6:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x8
	LDI  R30,LOW(49)
	RJMP _0x2020004
; 0000 006B     else if(Num==2){return '2';}
_0x8:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0xA
	LDI  R30,LOW(50)
	RJMP _0x2020004
; 0000 006C     else if(Num==3){return '3';}
_0xA:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0xC
	LDI  R30,LOW(51)
	RJMP _0x2020004
; 0000 006D     else if(Num==4){return '4';}
_0xC:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xE
	LDI  R30,LOW(52)
	RJMP _0x2020004
; 0000 006E     else if(Num==5){return '5';}
_0xE:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x10
	LDI  R30,LOW(53)
	RJMP _0x2020004
; 0000 006F     else if(Num==6){return '6';}
_0x10:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x12
	LDI  R30,LOW(54)
	RJMP _0x2020004
; 0000 0070     else if(Num==7){return '7';}
_0x12:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x14
	LDI  R30,LOW(55)
	RJMP _0x2020004
; 0000 0071     else if(Num==8){return '8';}
_0x14:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x16
	LDI  R30,LOW(56)
	RJMP _0x2020004
; 0000 0072     else if(Num==9){return '9';}
_0x16:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x18
	LDI  R30,LOW(57)
	RJMP _0x2020004
; 0000 0073 return 0;
_0x18:
	LDI  R30,LOW(0)
_0x2020004:
	ADIW R28,1
	RET
; 0000 0074 }
;
;char UpdateVariableOSC(){
; 0000 0076 char UpdateVariableOSC(){
_UpdateVariableOSC:
; 0000 0077 OSC++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0078     if(OSC>=15){
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x19
; 0000 0079     OSC = 0;
	CLR  R4
	CLR  R5
; 0000 007A     }
; 0000 007B return 1;
_0x19:
	RJMP _0x2020002
; 0000 007C }
;
;char WhatLcdChannelIsOn(){
; 0000 007E char WhatLcdChannelIsOn(){
_WhatLcdChannelIsOn:
; 0000 007F     if(OSC==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x1A
; 0000 0080     return 0;
	LDI  R30,LOW(0)
	RET
; 0000 0081     }
; 0000 0082     else if(OSC==4){
_0x1A:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x1C
; 0000 0083     return 1;
	RJMP _0x2020002
; 0000 0084     }
; 0000 0085     else if(OSC==8){
_0x1C:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x1E
; 0000 0086     return 2;
	LDI  R30,LOW(2)
	RET
; 0000 0087     }
; 0000 0088     else if(OSC==12){
_0x1E:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x20
; 0000 0089     return 3;
	LDI  R30,LOW(3)
	RET
; 0000 008A     }
; 0000 008B     else{
_0x20:
; 0000 008C     return -1;
; 0000 008D     }
; 0000 008E return -1;
_0x2020003:
	LDI  R30,LOW(255)
	RET
; 0000 008F }
;
;char RelayOutputs(){
; 0000 0091 char RelayOutputs(){
_RelayOutputs:
; 0000 0092     if(UPS_STATE==2){
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x22
; 0000 0093     PORTD.3 = 1;
	SBI  0x12,3
; 0000 0094     }
; 0000 0095     else{
	RJMP _0x25
_0x22:
; 0000 0096     PORTD.3 = 0;
	CBI  0x12,3
; 0000 0097     }
_0x25:
; 0000 0098 
; 0000 0099     if(KRAUTI==1){
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0x28
; 0000 009A     PORTD.6 = 1;
	SBI  0x12,6
; 0000 009B     }
; 0000 009C     else{
	RJMP _0x2B
_0x28:
; 0000 009D     PORTD.6 = 0;
	CBI  0x12,6
; 0000 009E     }
_0x2B:
; 0000 009F KRAUTI = 0;
	CLR  R8
; 0000 00A0 
; 0000 00A1     if(LOAD==1){
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x2E
; 0000 00A2     PORTD.5 = 1;
	SBI  0x12,5
; 0000 00A3     }
; 0000 00A4     else{
	RJMP _0x31
_0x2E:
; 0000 00A5     PORTD.5 = 0;
	CBI  0x12,5
; 0000 00A6     }
_0x31:
; 0000 00A7 LOAD = 0;
	CLR  R11
; 0000 00A8 
; 0000 00A9     if(BEEPER_OFF==1){
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x34
; 0000 00AA     PORTD.4 = 1;
	SBI  0x12,4
; 0000 00AB     }
; 0000 00AC     else{
	RJMP _0x37
_0x34:
; 0000 00AD     PORTD.4 = 0;
	CBI  0x12,4
; 0000 00AE     }
_0x37:
; 0000 00AF BEEPER_OFF = 0;
	CLR  R10
; 0000 00B0 
; 0000 00B1 return 1;
	RJMP _0x2020002
; 0000 00B2 }
;
;char UpdateLcd(){
; 0000 00B4 char UpdateLcd(){
_UpdateLcd:
; 0000 00B5 char i;
; 0000 00B6 char LcdChannel = WhatLcdChannelIsOn();
; 0000 00B7     if(LcdChannel!=-1){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	LcdChannel -> R16
	RCALL _WhatLcdChannelIsOn
	MOV  R16,R30
	MOV  R26,R16
	LDI  R30,LOW(255)
	LDI  R27,0
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	BRNE PC+3
	JMP _0x3A
; 0000 00B8     char a=0, b=0, c=0, d=0, e=0, f=0, g=0;
; 0000 00B9     char input = LcdText[LcdChannel];
; 0000 00BA     // Bloko valdymas
; 0000 00BB         if(LcdChannel==0){     LED_BLOCK_0 = 1;LED_BLOCK_1 = 0;LED_BLOCK_2 = 0;LED_BLOCK_3 = 0;}
	SBIW R28,8
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
;	a -> Y+7
;	b -> Y+6
;	c -> Y+5
;	d -> Y+4
;	e -> Y+3
;	f -> Y+2
;	g -> Y+1
;	input -> Y+0
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_LcdText)
	SBCI R31,HIGH(-_LcdText)
	LD   R30,Z
	ST   Y,R30
	CPI  R16,0
	BRNE _0x3B
	SBI  0x15,7
	CBI  0x1B,6
	CBI  0x1B,7
	CBI  0x1B,4
; 0000 00BC         else if(LcdChannel==1){LED_BLOCK_0 = 0;LED_BLOCK_1 = 1;LED_BLOCK_2 = 0;LED_BLOCK_3 = 0;}
	RJMP _0x44
_0x3B:
	CPI  R16,1
	BRNE _0x45
	CBI  0x15,7
	SBI  0x1B,6
	CBI  0x1B,7
	CBI  0x1B,4
; 0000 00BD         else if(LcdChannel==2){LED_BLOCK_0 = 0;LED_BLOCK_1 = 0;LED_BLOCK_2 = 1;LED_BLOCK_3 = 0;}
	RJMP _0x4E
_0x45:
	CPI  R16,2
	BRNE _0x4F
	CBI  0x15,7
	CBI  0x1B,6
	SBI  0x1B,7
	CBI  0x1B,4
; 0000 00BE         else if(LcdChannel==3){LED_BLOCK_0 = 0;LED_BLOCK_1 = 0;LED_BLOCK_2 = 0;LED_BLOCK_3 = 1;}
	RJMP _0x58
_0x4F:
	CPI  R16,3
	BRNE _0x59
	CBI  0x15,7
	CBI  0x1B,6
	CBI  0x1B,7
	SBI  0x1B,4
; 0000 00BF 
; 0000 00C0     // Segmentu valdymas
; 0000 00C1         if(input=='0'){
_0x59:
_0x58:
_0x4E:
_0x44:
	LD   R26,Y
	CPI  R26,LOW(0x30)
	BRNE _0x62
; 0000 00C2         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 00C3         b = 1;
	STD  Y+6,R30
; 0000 00C4         c = 1;
	STD  Y+5,R30
; 0000 00C5         d = 1;
	STD  Y+4,R30
; 0000 00C6         e = 1;
	STD  Y+3,R30
; 0000 00C7         f = 1;
	RJMP _0x20F
; 0000 00C8         g = 0;
; 0000 00C9         }
; 0000 00CA         else if(input=='1'){
_0x62:
	LD   R26,Y
	CPI  R26,LOW(0x31)
	BRNE _0x64
; 0000 00CB         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 00CC         b = 1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0000 00CD         c = 1;
	STD  Y+5,R30
; 0000 00CE         d = 0;
	LDI  R30,LOW(0)
	RJMP _0x210
; 0000 00CF         e = 0;
; 0000 00D0         f = 0;
; 0000 00D1         g = 0;
; 0000 00D2         }
; 0000 00D3         else if(input=='2'){
_0x64:
	LD   R26,Y
	CPI  R26,LOW(0x32)
	BRNE _0x66
; 0000 00D4         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 00D5         b = 1;
	STD  Y+6,R30
; 0000 00D6         c = 0;
	LDI  R30,LOW(0)
	STD  Y+5,R30
; 0000 00D7         d = 1;
	LDI  R30,LOW(1)
	STD  Y+4,R30
; 0000 00D8         e = 1;
	STD  Y+3,R30
; 0000 00D9         f = 0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
; 0000 00DA         g = 1;
	LDI  R30,LOW(1)
	RJMP _0x211
; 0000 00DB         }
; 0000 00DC         else if(input=='3'){
_0x66:
	LD   R26,Y
	CPI  R26,LOW(0x33)
	BRNE _0x68
; 0000 00DD         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 00DE         b = 1;
	STD  Y+6,R30
; 0000 00DF         c = 1;
	STD  Y+5,R30
; 0000 00E0         d = 1;
	STD  Y+4,R30
; 0000 00E1         e = 0;
	LDI  R30,LOW(0)
	STD  Y+3,R30
; 0000 00E2         f = 0;
	STD  Y+2,R30
; 0000 00E3         g = 1;
	LDI  R30,LOW(1)
	RJMP _0x211
; 0000 00E4         }
; 0000 00E5         else if(input=='4'){
_0x68:
	LD   R26,Y
	CPI  R26,LOW(0x34)
	BRNE _0x6A
; 0000 00E6         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 00E7         b = 1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0000 00E8         c = 1;
	STD  Y+5,R30
; 0000 00E9         d = 0;
	LDI  R30,LOW(0)
	STD  Y+4,R30
; 0000 00EA         e = 0;
	STD  Y+3,R30
; 0000 00EB         f = 1;
	LDI  R30,LOW(1)
	STD  Y+2,R30
; 0000 00EC         g = 1;
	RJMP _0x211
; 0000 00ED         }
; 0000 00EE         else if(input=='5'){
_0x6A:
	LD   R26,Y
	CPI  R26,LOW(0x35)
	BRNE _0x6C
; 0000 00EF         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 00F0         b = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
; 0000 00F1         c = 1;
	LDI  R30,LOW(1)
	STD  Y+5,R30
; 0000 00F2         d = 1;
	STD  Y+4,R30
; 0000 00F3         e = 0;
	LDI  R30,LOW(0)
	STD  Y+3,R30
; 0000 00F4         f = 1;
	LDI  R30,LOW(1)
	STD  Y+2,R30
; 0000 00F5         g = 1;
	RJMP _0x211
; 0000 00F6         }
; 0000 00F7         else if(input=='6'){
_0x6C:
	LD   R26,Y
	CPI  R26,LOW(0x36)
	BRNE _0x6E
; 0000 00F8         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 00F9         b = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
; 0000 00FA         c = 1;
	LDI  R30,LOW(1)
	STD  Y+5,R30
; 0000 00FB         d = 1;
	STD  Y+4,R30
; 0000 00FC         e = 1;
	STD  Y+3,R30
; 0000 00FD         f = 1;
	STD  Y+2,R30
; 0000 00FE         g = 1;
	RJMP _0x211
; 0000 00FF         }
; 0000 0100         else if(input=='7'){
_0x6E:
	LD   R26,Y
	CPI  R26,LOW(0x37)
	BRNE _0x70
; 0000 0101         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 0102         b = 1;
	STD  Y+6,R30
; 0000 0103         c = 1;
	STD  Y+5,R30
; 0000 0104         d = 0;
	LDI  R30,LOW(0)
	RJMP _0x210
; 0000 0105         e = 0;
; 0000 0106         f = 0;
; 0000 0107         g = 0;
; 0000 0108         }
; 0000 0109         else if(input=='8'){
_0x70:
	LD   R26,Y
	CPI  R26,LOW(0x38)
	BRNE _0x72
; 0000 010A         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 010B         b = 1;
	STD  Y+6,R30
; 0000 010C         c = 1;
	STD  Y+5,R30
; 0000 010D         d = 1;
	STD  Y+4,R30
; 0000 010E         e = 1;
	STD  Y+3,R30
; 0000 010F         f = 1;
	STD  Y+2,R30
; 0000 0110         g = 1;
	RJMP _0x211
; 0000 0111         }
; 0000 0112         else if(input=='9'){
_0x72:
	LD   R26,Y
	CPI  R26,LOW(0x39)
	BRNE _0x74
; 0000 0113         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 0114         b = 1;
	STD  Y+6,R30
; 0000 0115         c = 1;
	STD  Y+5,R30
; 0000 0116         d = 1;
	STD  Y+4,R30
; 0000 0117         e = 0;
	LDI  R30,LOW(0)
	STD  Y+3,R30
; 0000 0118         f = 1;
	LDI  R30,LOW(1)
	STD  Y+2,R30
; 0000 0119         g = 1;
	RJMP _0x211
; 0000 011A         }
; 0000 011B         else if(input=='a'){
_0x74:
	LD   R26,Y
	CPI  R26,LOW(0x61)
	BRNE _0x76
; 0000 011C         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 011D         b = 0;
	STD  Y+6,R30
; 0000 011E         c = 0;
	STD  Y+5,R30
; 0000 011F         d = 0;
	RJMP _0x210
; 0000 0120         e = 0;
; 0000 0121         f = 0;
; 0000 0122         g = 0;
; 0000 0123         }
; 0000 0124         else if(input=='A'){
_0x76:
	LD   R26,Y
	CPI  R26,LOW(0x41)
	BRNE _0x78
; 0000 0125         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 0126         b = 1;
	STD  Y+6,R30
; 0000 0127         c = 1;
	STD  Y+5,R30
; 0000 0128         d = 0;
	LDI  R30,LOW(0)
	STD  Y+4,R30
; 0000 0129         e = 1;
	LDI  R30,LOW(1)
	STD  Y+3,R30
; 0000 012A         f = 1;
	STD  Y+2,R30
; 0000 012B         g = 1;
	RJMP _0x211
; 0000 012C         }
; 0000 012D         else if(input=='b'){
_0x78:
	LD   R26,Y
	CPI  R26,LOW(0x62)
	BRNE _0x7A
; 0000 012E         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 012F         b = 0;
	STD  Y+6,R30
; 0000 0130         c = 1;
	LDI  R30,LOW(1)
	STD  Y+5,R30
; 0000 0131         d = 1;
	STD  Y+4,R30
; 0000 0132         e = 1;
	STD  Y+3,R30
; 0000 0133         f = 1;
	STD  Y+2,R30
; 0000 0134         g = 1;
	RJMP _0x211
; 0000 0135         }
; 0000 0136         else if(input=='B'){
_0x7A:
	LD   R26,Y
	CPI  R26,LOW(0x42)
	BRNE _0x7C
; 0000 0137         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0138         b = 0;
	STD  Y+6,R30
; 0000 0139         c = 0;
	STD  Y+5,R30
; 0000 013A         d = 0;
	RJMP _0x210
; 0000 013B         e = 0;
; 0000 013C         f = 0;
; 0000 013D         g = 0;
; 0000 013E         }
; 0000 013F         else if(input=='c'){
_0x7C:
	LD   R26,Y
	CPI  R26,LOW(0x63)
	BRNE _0x7E
; 0000 0140         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0141         b = 0;
	STD  Y+6,R30
; 0000 0142         c = 0;
	STD  Y+5,R30
; 0000 0143         d = 1;
	LDI  R30,LOW(1)
	STD  Y+4,R30
; 0000 0144         e = 1;
	STD  Y+3,R30
; 0000 0145         f = 0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
; 0000 0146         g = 1;
	LDI  R30,LOW(1)
	RJMP _0x211
; 0000 0147         }
; 0000 0148         else if(input=='C'){
_0x7E:
	LD   R26,Y
	CPI  R26,LOW(0x43)
	BRNE _0x80
; 0000 0149         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 014A         b = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
; 0000 014B         c = 0;
	STD  Y+5,R30
; 0000 014C         d = 1;
	LDI  R30,LOW(1)
	STD  Y+4,R30
; 0000 014D         e = 1;
	STD  Y+3,R30
; 0000 014E         f = 1;
	STD  Y+2,R30
; 0000 014F         g = 1;
	RJMP _0x211
; 0000 0150         }
; 0000 0151         else if(input=='d'){
_0x80:
	LD   R26,Y
	CPI  R26,LOW(0x64)
	BRNE _0x82
; 0000 0152         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0153         b = 1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0000 0154         c = 1;
	STD  Y+5,R30
; 0000 0155         d = 1;
	STD  Y+4,R30
; 0000 0156         e = 1;
	STD  Y+3,R30
; 0000 0157         f = 0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
; 0000 0158         g = 1;
	LDI  R30,LOW(1)
	RJMP _0x211
; 0000 0159         }
; 0000 015A         else if(input=='D'){
_0x82:
	LD   R26,Y
	CPI  R26,LOW(0x44)
	BRNE _0x84
; 0000 015B         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 015C         b = 0;
	STD  Y+6,R30
; 0000 015D         c = 0;
	STD  Y+5,R30
; 0000 015E         d = 0;
	RJMP _0x210
; 0000 015F         e = 0;
; 0000 0160         f = 0;
; 0000 0161         g = 0;
; 0000 0162         }
; 0000 0163         else if(input=='e'){
_0x84:
	LD   R26,Y
	CPI  R26,LOW(0x65)
	BRNE _0x86
; 0000 0164         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0165         b = 0;
	STD  Y+6,R30
; 0000 0166         c = 0;
	STD  Y+5,R30
; 0000 0167         d = 0;
	RJMP _0x210
; 0000 0168         e = 0;
; 0000 0169         f = 0;
; 0000 016A         g = 0;
; 0000 016B         }
; 0000 016C         else if(input=='E'){
_0x86:
	LD   R26,Y
	CPI  R26,LOW(0x45)
	BRNE _0x88
; 0000 016D         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 016E         b = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
; 0000 016F         c = 0;
	STD  Y+5,R30
; 0000 0170         d = 1;
	LDI  R30,LOW(1)
	STD  Y+4,R30
; 0000 0171         e = 1;
	STD  Y+3,R30
; 0000 0172         f = 1;
	STD  Y+2,R30
; 0000 0173         g = 1;
	RJMP _0x211
; 0000 0174         }
; 0000 0175         else if(input=='f'){
_0x88:
	LD   R26,Y
	CPI  R26,LOW(0x66)
	BRNE _0x8A
; 0000 0176         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0177         b = 0;
	STD  Y+6,R30
; 0000 0178         c = 0;
	STD  Y+5,R30
; 0000 0179         d = 0;
	RJMP _0x210
; 0000 017A         e = 0;
; 0000 017B         f = 0;
; 0000 017C         g = 0;
; 0000 017D         }
; 0000 017E         else if(input=='F'){
_0x8A:
	LD   R26,Y
	CPI  R26,LOW(0x46)
	BRNE _0x8C
; 0000 017F         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 0180         b = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
; 0000 0181         c = 0;
	STD  Y+5,R30
; 0000 0182         d = 0;
	STD  Y+4,R30
; 0000 0183         e = 1;
	LDI  R30,LOW(1)
	STD  Y+3,R30
; 0000 0184         f = 1;
	STD  Y+2,R30
; 0000 0185         g = 1;
	RJMP _0x211
; 0000 0186         }
; 0000 0187         else if(input=='g'){
_0x8C:
	LD   R26,Y
	CPI  R26,LOW(0x67)
	BRNE _0x8E
; 0000 0188         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0189         b = 0;
	STD  Y+6,R30
; 0000 018A         c = 0;
	STD  Y+5,R30
; 0000 018B         d = 0;
	RJMP _0x210
; 0000 018C         e = 0;
; 0000 018D         f = 0;
; 0000 018E         g = 0;
; 0000 018F         }
; 0000 0190         else if(input=='G'){
_0x8E:
	LD   R26,Y
	CPI  R26,LOW(0x47)
	BRNE _0x90
; 0000 0191         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 0192         b = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
; 0000 0193         c = 1;
	LDI  R30,LOW(1)
	STD  Y+5,R30
; 0000 0194         d = 1;
	STD  Y+4,R30
; 0000 0195         e = 1;
	STD  Y+3,R30
; 0000 0196         f = 1;
	RJMP _0x20F
; 0000 0197         g = 0;
; 0000 0198         }
; 0000 0199         else if(input=='h'){
_0x90:
	LD   R26,Y
	CPI  R26,LOW(0x68)
	BRNE _0x92
; 0000 019A         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 019B         b = 0;
	STD  Y+6,R30
; 0000 019C         c = 1;
	LDI  R30,LOW(1)
	STD  Y+5,R30
; 0000 019D         d = 0;
	LDI  R30,LOW(0)
	STD  Y+4,R30
; 0000 019E         e = 1;
	LDI  R30,LOW(1)
	STD  Y+3,R30
; 0000 019F         f = 1;
	STD  Y+2,R30
; 0000 01A0         g = 1;
	RJMP _0x211
; 0000 01A1         }
; 0000 01A2         else if(input=='H'){
_0x92:
	LD   R26,Y
	CPI  R26,LOW(0x48)
	BRNE _0x94
; 0000 01A3         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 01A4         b = 1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0000 01A5         c = 1;
	STD  Y+5,R30
; 0000 01A6         d = 0;
	LDI  R30,LOW(0)
	STD  Y+4,R30
; 0000 01A7         e = 1;
	LDI  R30,LOW(1)
	STD  Y+3,R30
; 0000 01A8         f = 1;
	STD  Y+2,R30
; 0000 01A9         g = 1;
	RJMP _0x211
; 0000 01AA         }
; 0000 01AB         else if(input=='i'){
_0x94:
	LD   R26,Y
	CPI  R26,LOW(0x69)
	BRNE _0x96
; 0000 01AC         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 01AD         b = 0;
	STD  Y+6,R30
; 0000 01AE         c = 1;
	LDI  R30,LOW(1)
	STD  Y+5,R30
; 0000 01AF         d = 0;
	LDI  R30,LOW(0)
	RJMP _0x210
; 0000 01B0         e = 0;
; 0000 01B1         f = 0;
; 0000 01B2         g = 0;
; 0000 01B3         }
; 0000 01B4         else if(input=='I'){
_0x96:
	LD   R26,Y
	CPI  R26,LOW(0x49)
	BRNE _0x98
; 0000 01B5         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 01B6         b = 1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0000 01B7         c = 1;
	STD  Y+5,R30
; 0000 01B8         d = 0;
	LDI  R30,LOW(0)
	RJMP _0x210
; 0000 01B9         e = 0;
; 0000 01BA         f = 0;
; 0000 01BB         g = 0;
; 0000 01BC         }
; 0000 01BD         else if(input=='j'){
_0x98:
	LD   R26,Y
	CPI  R26,LOW(0x6A)
	BRNE _0x9A
; 0000 01BE         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 01BF         b = 0;
	STD  Y+6,R30
; 0000 01C0         c = 0;
	STD  Y+5,R30
; 0000 01C1         d = 0;
	RJMP _0x210
; 0000 01C2         e = 0;
; 0000 01C3         f = 0;
; 0000 01C4         g = 0;
; 0000 01C5         }
; 0000 01C6         else if(input=='J'){
_0x9A:
	LD   R26,Y
	CPI  R26,LOW(0x4A)
	BRNE _0x9C
; 0000 01C7         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 01C8         b = 1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0000 01C9         c = 1;
	RJMP _0x212
; 0000 01CA         d = 1;
; 0000 01CB         e = 0;
; 0000 01CC         f = 0;
; 0000 01CD         g = 0;
; 0000 01CE         }
; 0000 01CF         else if(input=='k'){
_0x9C:
	LD   R26,Y
	CPI  R26,LOW(0x6B)
	BRNE _0x9E
; 0000 01D0         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 01D1         b = 0;
	STD  Y+6,R30
; 0000 01D2         c = 0;
	STD  Y+5,R30
; 0000 01D3         d = 0;
	RJMP _0x210
; 0000 01D4         e = 0;
; 0000 01D5         f = 0;
; 0000 01D6         g = 0;
; 0000 01D7         }
; 0000 01D8         else if(input=='K'){
_0x9E:
	LD   R26,Y
	CPI  R26,LOW(0x4B)
	BRNE _0xA0
; 0000 01D9         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 01DA         b = 0;
	STD  Y+6,R30
; 0000 01DB         c = 0;
	STD  Y+5,R30
; 0000 01DC         d = 0;
	RJMP _0x210
; 0000 01DD         e = 0;
; 0000 01DE         f = 0;
; 0000 01DF         g = 0;
; 0000 01E0         }
; 0000 01E1         else if(input=='l'){
_0xA0:
	LD   R26,Y
	CPI  R26,LOW(0x6C)
	BRNE _0xA2
; 0000 01E2         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 01E3         b = 0;
	STD  Y+6,R30
; 0000 01E4         c = 0;
	STD  Y+5,R30
; 0000 01E5         d = 0;
	RJMP _0x210
; 0000 01E6         e = 0;
; 0000 01E7         f = 0;
; 0000 01E8         g = 0;
; 0000 01E9         }
; 0000 01EA         else if(input=='L'){
_0xA2:
	LD   R26,Y
	CPI  R26,LOW(0x4C)
	BRNE _0xA4
; 0000 01EB         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 01EC         b = 0;
	STD  Y+6,R30
; 0000 01ED         c = 0;
	STD  Y+5,R30
; 0000 01EE         d = 1;
	LDI  R30,LOW(1)
	STD  Y+4,R30
; 0000 01EF         e = 1;
	STD  Y+3,R30
; 0000 01F0         f = 1;
	RJMP _0x20F
; 0000 01F1         g = 0;
; 0000 01F2         }
; 0000 01F3         else if(input=='m'){
_0xA4:
	LD   R26,Y
	CPI  R26,LOW(0x6D)
	BRNE _0xA6
; 0000 01F4         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 01F5         b = 0;
	STD  Y+6,R30
; 0000 01F6         c = 0;
	STD  Y+5,R30
; 0000 01F7         d = 0;
	RJMP _0x210
; 0000 01F8         e = 0;
; 0000 01F9         f = 0;
; 0000 01FA         g = 0;
; 0000 01FB         }
; 0000 01FC         else if(input=='M'){
_0xA6:
	LD   R26,Y
	CPI  R26,LOW(0x4D)
	BRNE _0xA8
; 0000 01FD         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 01FE         b = 0;
	STD  Y+6,R30
; 0000 01FF         c = 0;
	STD  Y+5,R30
; 0000 0200         d = 0;
	RJMP _0x210
; 0000 0201         e = 0;
; 0000 0202         f = 0;
; 0000 0203         g = 0;
; 0000 0204         }
; 0000 0205         else if(input=='n'){
_0xA8:
	LD   R26,Y
	CPI  R26,LOW(0x6E)
	BRNE _0xAA
; 0000 0206         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0207         b = 0;
	STD  Y+6,R30
; 0000 0208         c = 1;
	LDI  R30,LOW(1)
	STD  Y+5,R30
; 0000 0209         d = 0;
	LDI  R30,LOW(0)
	STD  Y+4,R30
; 0000 020A         e = 1;
	LDI  R30,LOW(1)
	STD  Y+3,R30
; 0000 020B         f = 0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
; 0000 020C         g = 1;
	LDI  R30,LOW(1)
	RJMP _0x211
; 0000 020D         }
; 0000 020E         else if(input=='N'){
_0xAA:
	LD   R26,Y
	CPI  R26,LOW(0x4E)
	BRNE _0xAC
; 0000 020F         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0210         b = 0;
	STD  Y+6,R30
; 0000 0211         c = 0;
	STD  Y+5,R30
; 0000 0212         d = 0;
	RJMP _0x210
; 0000 0213         e = 0;
; 0000 0214         f = 0;
; 0000 0215         g = 0;
; 0000 0216         }
; 0000 0217         else if(input=='o'){
_0xAC:
	LD   R26,Y
	CPI  R26,LOW(0x6F)
	BRNE _0xAE
; 0000 0218         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0219         b = 0;
	STD  Y+6,R30
; 0000 021A         c = 1;
	LDI  R30,LOW(1)
	STD  Y+5,R30
; 0000 021B         d = 1;
	STD  Y+4,R30
; 0000 021C         e = 1;
	STD  Y+3,R30
; 0000 021D         f = 0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
; 0000 021E         g = 1;
	LDI  R30,LOW(1)
	RJMP _0x211
; 0000 021F         }
; 0000 0220         else if(input=='O'){
_0xAE:
	LD   R26,Y
	CPI  R26,LOW(0x4F)
	BRNE _0xB0
; 0000 0221         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 0222         b = 1;
	STD  Y+6,R30
; 0000 0223         c = 1;
	STD  Y+5,R30
; 0000 0224         d = 1;
	STD  Y+4,R30
; 0000 0225         e = 1;
	STD  Y+3,R30
; 0000 0226         f = 1;
	RJMP _0x20F
; 0000 0227         g = 0;
; 0000 0228         }
; 0000 0229         else if(input=='p'){
_0xB0:
	LD   R26,Y
	CPI  R26,LOW(0x70)
	BRNE _0xB2
; 0000 022A         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 022B         b = 0;
	STD  Y+6,R30
; 0000 022C         c = 0;
	STD  Y+5,R30
; 0000 022D         d = 0;
	RJMP _0x210
; 0000 022E         e = 0;
; 0000 022F         f = 0;
; 0000 0230         g = 0;
; 0000 0231         }
; 0000 0232         else if(input=='P'){
_0xB2:
	LD   R26,Y
	CPI  R26,LOW(0x50)
	BRNE _0xB4
; 0000 0233         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 0234         b = 1;
	STD  Y+6,R30
; 0000 0235         c = 0;
	LDI  R30,LOW(0)
	STD  Y+5,R30
; 0000 0236         d = 0;
	STD  Y+4,R30
; 0000 0237         e = 1;
	LDI  R30,LOW(1)
	STD  Y+3,R30
; 0000 0238         f = 1;
	STD  Y+2,R30
; 0000 0239         g = 1;
	RJMP _0x211
; 0000 023A         }
; 0000 023B         else if(input=='q'){
_0xB4:
	LD   R26,Y
	CPI  R26,LOW(0x71)
	BRNE _0xB6
; 0000 023C         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 023D         b = 0;
	STD  Y+6,R30
; 0000 023E         c = 0;
	STD  Y+5,R30
; 0000 023F         d = 0;
	RJMP _0x210
; 0000 0240         e = 0;
; 0000 0241         f = 0;
; 0000 0242         g = 0;
; 0000 0243         }
; 0000 0244         else if(input=='Q'){
_0xB6:
	LD   R26,Y
	CPI  R26,LOW(0x51)
	BRNE _0xB8
; 0000 0245         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0246         b = 0;
	STD  Y+6,R30
; 0000 0247         c = 0;
	STD  Y+5,R30
; 0000 0248         d = 0;
	RJMP _0x210
; 0000 0249         e = 0;
; 0000 024A         f = 0;
; 0000 024B         g = 0;
; 0000 024C         }
; 0000 024D         else if(input=='r'){
_0xB8:
	LD   R26,Y
	CPI  R26,LOW(0x72)
	BRNE _0xBA
; 0000 024E         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 024F         b = 0;
	STD  Y+6,R30
; 0000 0250         c = 0;
	STD  Y+5,R30
; 0000 0251         d = 0;
	STD  Y+4,R30
; 0000 0252         e = 1;
	LDI  R30,LOW(1)
	STD  Y+3,R30
; 0000 0253         f = 0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
; 0000 0254         g = 1;
	LDI  R30,LOW(1)
	RJMP _0x211
; 0000 0255         }
; 0000 0256         else if(input=='R'){
_0xBA:
	LD   R26,Y
	CPI  R26,LOW(0x52)
	BRNE _0xBC
; 0000 0257         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0258         b = 0;
	STD  Y+6,R30
; 0000 0259         c = 0;
	STD  Y+5,R30
; 0000 025A         d = 0;
	RJMP _0x210
; 0000 025B         e = 0;
; 0000 025C         f = 0;
; 0000 025D         g = 0;
; 0000 025E         }
; 0000 025F         else if(input=='s'){
_0xBC:
	LD   R26,Y
	CPI  R26,LOW(0x73)
	BRNE _0xBE
; 0000 0260         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0261         b = 0;
	STD  Y+6,R30
; 0000 0262         c = 0;
	STD  Y+5,R30
; 0000 0263         d = 0;
	RJMP _0x210
; 0000 0264         e = 0;
; 0000 0265         f = 0;
; 0000 0266         g = 0;
; 0000 0267         }
; 0000 0268         else if(input=='S'){
_0xBE:
	LD   R26,Y
	CPI  R26,LOW(0x53)
	BRNE _0xC0
; 0000 0269         a = 1;
	LDI  R30,LOW(1)
	STD  Y+7,R30
; 0000 026A         b = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
; 0000 026B         c = 1;
	LDI  R30,LOW(1)
	STD  Y+5,R30
; 0000 026C         d = 1;
	STD  Y+4,R30
; 0000 026D         e = 0;
	LDI  R30,LOW(0)
	STD  Y+3,R30
; 0000 026E         f = 1;
	LDI  R30,LOW(1)
	STD  Y+2,R30
; 0000 026F         g = 1;
	RJMP _0x211
; 0000 0270         }
; 0000 0271         else if(input=='t'){
_0xC0:
	LD   R26,Y
	CPI  R26,LOW(0x74)
	BRNE _0xC2
; 0000 0272         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0273         b = 0;
	STD  Y+6,R30
; 0000 0274         c = 0;
	STD  Y+5,R30
; 0000 0275         d = 1;
	LDI  R30,LOW(1)
	STD  Y+4,R30
; 0000 0276         e = 1;
	STD  Y+3,R30
; 0000 0277         f = 1;
	STD  Y+2,R30
; 0000 0278         g = 1;
	RJMP _0x211
; 0000 0279         }
; 0000 027A         else if(input=='T'){
_0xC2:
	LD   R26,Y
	CPI  R26,LOW(0x54)
	BRNE _0xC4
; 0000 027B         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 027C         b = 0;
	STD  Y+6,R30
; 0000 027D         c = 0;
	STD  Y+5,R30
; 0000 027E         d = 0;
	RJMP _0x210
; 0000 027F         e = 0;
; 0000 0280         f = 0;
; 0000 0281         g = 0;
; 0000 0282         }
; 0000 0283         else if(input=='u'){
_0xC4:
	LD   R26,Y
	CPI  R26,LOW(0x75)
	BRNE _0xC6
; 0000 0284         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0285         b = 0;
	STD  Y+6,R30
; 0000 0286         c = 1;
	LDI  R30,LOW(1)
	STD  Y+5,R30
; 0000 0287         d = 1;
	STD  Y+4,R30
; 0000 0288         e = 1;
	RJMP _0x213
; 0000 0289         f = 0;
; 0000 028A         g = 0;
; 0000 028B         }
; 0000 028C         else if(input=='U'){
_0xC6:
	LD   R26,Y
	CPI  R26,LOW(0x55)
	BRNE _0xC8
; 0000 028D         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 028E         b = 1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0000 028F         c = 1;
	STD  Y+5,R30
; 0000 0290         d = 1;
	STD  Y+4,R30
; 0000 0291         e = 1;
	STD  Y+3,R30
; 0000 0292         f = 1;
	RJMP _0x20F
; 0000 0293         g = 0;
; 0000 0294         }
; 0000 0295         else if(input=='v'){
_0xC8:
	LD   R26,Y
	CPI  R26,LOW(0x76)
	BRNE _0xCA
; 0000 0296         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0297         b = 0;
	STD  Y+6,R30
; 0000 0298         c = 0;
	STD  Y+5,R30
; 0000 0299         d = 0;
	RJMP _0x210
; 0000 029A         e = 0;
; 0000 029B         f = 0;
; 0000 029C         g = 0;
; 0000 029D         }
; 0000 029E         else if(input=='V'){
_0xCA:
	LD   R26,Y
	CPI  R26,LOW(0x56)
	BRNE _0xCC
; 0000 029F         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 02A0         b = 0;
	STD  Y+6,R30
; 0000 02A1         c = 0;
	STD  Y+5,R30
; 0000 02A2         d = 0;
	RJMP _0x210
; 0000 02A3         e = 0;
; 0000 02A4         f = 0;
; 0000 02A5         g = 0;
; 0000 02A6         }
; 0000 02A7         else if(input=='w'){
_0xCC:
	LD   R26,Y
	CPI  R26,LOW(0x77)
	BRNE _0xCE
; 0000 02A8         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 02A9         b = 0;
	STD  Y+6,R30
; 0000 02AA         c = 0;
	STD  Y+5,R30
; 0000 02AB         d = 0;
	RJMP _0x210
; 0000 02AC         e = 0;
; 0000 02AD         f = 0;
; 0000 02AE         g = 0;
; 0000 02AF         }
; 0000 02B0         else if(input=='W'){
_0xCE:
	LD   R26,Y
	CPI  R26,LOW(0x57)
	BRNE _0xD0
; 0000 02B1         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 02B2         b = 0;
	STD  Y+6,R30
; 0000 02B3         c = 0;
	STD  Y+5,R30
; 0000 02B4         d = 0;
	RJMP _0x210
; 0000 02B5         e = 0;
; 0000 02B6         f = 0;
; 0000 02B7         g = 0;
; 0000 02B8         }
; 0000 02B9         else if(input=='x'){
_0xD0:
	LD   R26,Y
	CPI  R26,LOW(0x78)
	BRNE _0xD2
; 0000 02BA         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 02BB         b = 0;
	STD  Y+6,R30
; 0000 02BC         c = 0;
	STD  Y+5,R30
; 0000 02BD         d = 0;
	RJMP _0x210
; 0000 02BE         e = 0;
; 0000 02BF         f = 0;
; 0000 02C0         g = 0;
; 0000 02C1         }
; 0000 02C2         else if(input=='X'){
_0xD2:
	LD   R26,Y
	CPI  R26,LOW(0x58)
	BRNE _0xD4
; 0000 02C3         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 02C4         b = 0;
	STD  Y+6,R30
; 0000 02C5         c = 0;
	STD  Y+5,R30
; 0000 02C6         d = 0;
	RJMP _0x210
; 0000 02C7         e = 0;
; 0000 02C8         f = 0;
; 0000 02C9         g = 0;
; 0000 02CA         }
; 0000 02CB         else if(input=='y'){
_0xD4:
	LD   R26,Y
	CPI  R26,LOW(0x79)
	BRNE _0xD6
; 0000 02CC         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 02CD         b = 0;
	STD  Y+6,R30
; 0000 02CE         c = 0;
	STD  Y+5,R30
; 0000 02CF         d = 0;
	RJMP _0x210
; 0000 02D0         e = 0;
; 0000 02D1         f = 0;
; 0000 02D2         g = 0;
; 0000 02D3         }
; 0000 02D4         else if(input=='Y'){
_0xD6:
	LD   R26,Y
	CPI  R26,LOW(0x59)
	BRNE _0xD8
; 0000 02D5         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 02D6         b = 1;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0000 02D7         c = 1;
	STD  Y+5,R30
; 0000 02D8         d = 0;
	LDI  R30,LOW(0)
	STD  Y+4,R30
; 0000 02D9         e = 0;
	STD  Y+3,R30
; 0000 02DA         f = 1;
	LDI  R30,LOW(1)
	STD  Y+2,R30
; 0000 02DB         g = 1;
	RJMP _0x211
; 0000 02DC         }
; 0000 02DD         else if(input=='z'){
_0xD8:
	LD   R26,Y
	CPI  R26,LOW(0x7A)
	BRNE _0xDA
; 0000 02DE         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 02DF         b = 0;
	STD  Y+6,R30
; 0000 02E0         c = 0;
	STD  Y+5,R30
; 0000 02E1         d = 0;
	RJMP _0x210
; 0000 02E2         e = 0;
; 0000 02E3         f = 0;
; 0000 02E4         g = 0;
; 0000 02E5         }
; 0000 02E6         else if(input=='Z'){
_0xDA:
	LD   R26,Y
	CPI  R26,LOW(0x5A)
	BRNE _0xDC
; 0000 02E7         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 02E8         b = 0;
	STD  Y+6,R30
; 0000 02E9         c = 0;
	STD  Y+5,R30
; 0000 02EA         d = 0;
	RJMP _0x210
; 0000 02EB         e = 0;
; 0000 02EC         f = 0;
; 0000 02ED         g = 0;
; 0000 02EE         }
; 0000 02EF         else if(input=='='){
_0xDC:
	LD   R26,Y
	CPI  R26,LOW(0x3D)
	BRNE _0xDE
; 0000 02F0         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 02F1         b = 0;
	STD  Y+6,R30
; 0000 02F2         c = 0;
	STD  Y+5,R30
; 0000 02F3         d = 1;
	LDI  R30,LOW(1)
	STD  Y+4,R30
; 0000 02F4         e = 0;
	LDI  R30,LOW(0)
	STD  Y+3,R30
; 0000 02F5         f = 0;
	STD  Y+2,R30
; 0000 02F6         g = 1;
	LDI  R30,LOW(1)
	RJMP _0x211
; 0000 02F7         }
; 0000 02F8         else if(input=='_'){
_0xDE:
	LD   R26,Y
	CPI  R26,LOW(0x5F)
	BRNE _0xE0
; 0000 02F9         a = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 02FA         b = 0;
	STD  Y+6,R30
; 0000 02FB         c = 0;
_0x212:
	STD  Y+5,R30
; 0000 02FC         d = 1;
	LDI  R30,LOW(1)
_0x210:
	STD  Y+4,R30
; 0000 02FD         e = 0;
	LDI  R30,LOW(0)
_0x213:
	STD  Y+3,R30
; 0000 02FE         f = 0;
	LDI  R30,LOW(0)
_0x20F:
	STD  Y+2,R30
; 0000 02FF         g = 0;
	LDI  R30,LOW(0)
_0x211:
	STD  Y+1,R30
; 0000 0300         }
; 0000 0301         if(a==1){                    LED_SEGMENT_A = 0;}else{LED_SEGMENT_A = 1;}
_0xE0:
	LDD  R26,Y+7
	CPI  R26,LOW(0x1)
	BRNE _0xE1
	CBI  0x15,6
	RJMP _0xE4
_0xE1:
	SBI  0x15,6
_0xE4:
; 0000 0302         if(b==1){                    LED_SEGMENT_B = 0;}else{LED_SEGMENT_B = 1;}
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0xE7
	CBI  0x15,4
	RJMP _0xEA
_0xE7:
	SBI  0x15,4
_0xEA:
; 0000 0303         if(c==1){                    LED_SEGMENT_C = 0;}else{LED_SEGMENT_C = 1;}
	LDD  R26,Y+5
	CPI  R26,LOW(0x1)
	BRNE _0xED
	CBI  0x15,1
	RJMP _0xF0
_0xED:
	SBI  0x15,1
_0xF0:
; 0000 0304         if(d==1){                    LED_SEGMENT_D = 0;}else{LED_SEGMENT_D = 1;}
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0xF3
	CBI  0x15,3
	RJMP _0xF6
_0xF3:
	SBI  0x15,3
_0xF6:
; 0000 0305         if(e==1){                    LED_SEGMENT_E = 0;}else{LED_SEGMENT_E = 1;}
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0xF9
	CBI  0x12,7
	RJMP _0xFC
_0xF9:
	SBI  0x12,7
_0xFC:
; 0000 0306         if(f==1){                    LED_SEGMENT_F = 0;}else{LED_SEGMENT_F = 1;}
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0xFF
	CBI  0x15,5
	RJMP _0x102
_0xFF:
	SBI  0x15,5
_0x102:
; 0000 0307         if(g==1){                    LED_SEGMENT_G = 0;}else{LED_SEGMENT_G = 1;}
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x105
	CBI  0x15,0
	RJMP _0x108
_0x105:
	SBI  0x15,0
_0x108:
; 0000 0308         if(LcdTaskas[LcdChannel]==1){LED_SEGMENT_H = 0;}else{LED_SEGMENT_H = 1;}
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_LcdTaskas)
	SBCI R31,HIGH(-_LcdTaskas)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x10B
	CBI  0x15,2
	RJMP _0x10E
_0x10B:
	SBI  0x15,2
_0x10E:
; 0000 0309     }
	ADIW R28,8
; 0000 030A     else{
	RJMP _0x111
_0x3A:
; 0000 030B     LED_SEGMENT_A = 1;
	SBI  0x15,6
; 0000 030C     LED_SEGMENT_B = 1;
	SBI  0x15,4
; 0000 030D     LED_SEGMENT_C = 1;
	SBI  0x15,1
; 0000 030E     LED_SEGMENT_D = 1;
	SBI  0x15,3
; 0000 030F     LED_SEGMENT_E = 1;
	SBI  0x12,7
; 0000 0310     LED_SEGMENT_F = 1;
	SBI  0x15,5
; 0000 0311     LED_SEGMENT_G = 1;
	SBI  0x15,0
; 0000 0312     LED_SEGMENT_H = 1;
	SBI  0x15,2
; 0000 0313 
; 0000 0314     PORTC.7 = 0;    // 1
	CBI  0x15,7
; 0000 0315     PORTA.6 = 0;    // 2
	CBI  0x1B,6
; 0000 0316     PORTA.7 = 0;    // 3
	CBI  0x1B,7
; 0000 0317     PORTA.4 = 0;    // 4
	CBI  0x1B,4
; 0000 0318     }
_0x111:
; 0000 0319 
; 0000 031A     for(i=0;i<4;i++){LcdText[i] = 0;LcdTaskas[i] = 0;}
	LDI  R17,LOW(0)
_0x12B:
	CPI  R17,4
	BRSH _0x12C
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_LcdText)
	SBCI R31,HIGH(-_LcdText)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_LcdTaskas)
	SBCI R31,HIGH(-_LcdTaskas)
	STD  Z+0,R26
	SUBI R17,-1
	RJMP _0x12B
_0x12C:
; 0000 031B return 1;
	LDI  R30,LOW(1)
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 031C }
;
;char CheckButtons(){
; 0000 031E char CheckButtons(){
_CheckButtons:
; 0000 031F     if(PINA.0==0){BUTTON[0] = 1;}else{BUTTON[0] = 0;}
	SBIC 0x19,0
	RJMP _0x12D
	LDI  R30,LOW(1)
	RJMP _0x214
_0x12D:
	LDI  R30,LOW(0)
_0x214:
	STS  _BUTTON,R30
; 0000 0320     if(PINA.1==0){BUTTON[1] = 1;}else{BUTTON[1] = 0;}
	SBIC 0x19,1
	RJMP _0x12F
	LDI  R30,LOW(1)
	RJMP _0x215
_0x12F:
	LDI  R30,LOW(0)
_0x215:
	__PUTB1MN _BUTTON,1
; 0000 0321     if(PINA.2==0){BUTTON[2] = 1;}else{BUTTON[2] = 0;}
	SBIC 0x19,2
	RJMP _0x131
	LDI  R30,LOW(1)
	RJMP _0x216
_0x131:
	LDI  R30,LOW(0)
_0x216:
	__PUTB1MN _BUTTON,2
; 0000 0322     if(PINA.3==0){BUTTON[3] = 1;}else{BUTTON[3] = 0;}
	SBIC 0x19,3
	RJMP _0x133
	LDI  R30,LOW(1)
	RJMP _0x217
_0x133:
	LDI  R30,LOW(0)
_0x217:
	__PUTB1MN _BUTTON,3
; 0000 0323 return 1;
	RJMP _0x2020002
; 0000 0324 }
;
;char CheckBattery(){
; 0000 0326 char CheckBattery(){
_CheckBattery:
; 0000 0327 static unsigned int Timer29;
; 0000 0328 Timer29++;
	LDI  R26,LOW(_Timer29_S0000007000)
	LDI  R27,HIGH(_Timer29_S0000007000)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0329     if(Timer29>=250){
	LDS  R26,_Timer29_S0000007000
	LDS  R27,_Timer29_S0000007000+1
	CPI  R26,LOW(0xFA)
	LDI  R30,HIGH(0xFA)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x135
; 0000 032A     unsigned int Bits = read_adc(5);
; 0000 032B     unsigned int MomentVoltage, VoltageSum = 0;
; 0000 032C     char i;
; 0000 032D 
; 0000 032E     MomentVoltage = Bits/5 - Bits/90;
	SBIW R28,7
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+2,R30
;	Bits -> Y+5
;	MomentVoltage -> Y+3
;	VoltageSum -> Y+1
;	i -> Y+0
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+5,R30
	STD  Y+5+1,R31
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __DIVW21U
	MOVW R22,R30
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL __DIVW21U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+3,R26
	STD  Y+3+1,R27
; 0000 032F 
; 0000 0330         for(i=9;i>0;i--){
	LDI  R30,LOW(9)
	ST   Y,R30
_0x137:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRLO _0x138
; 0000 0331         BATTERY_VOLTAGE_ARCHIVE[i] = BATTERY_VOLTAGE_ARCHIVE[i-1];
	LD   R30,Y
	LDI  R26,LOW(_BATTERY_VOLTAGE_ARCHIVE)
	LDI  R27,HIGH(_BATTERY_VOLTAGE_ARCHIVE)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LD   R30,Y
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(_BATTERY_VOLTAGE_ARCHIVE)
	LDI  R27,HIGH(_BATTERY_VOLTAGE_ARCHIVE)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 0332         }
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
	RJMP _0x137
_0x138:
; 0000 0333     BATTERY_VOLTAGE_ARCHIVE[0] = MomentVoltage;
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	STS  _BATTERY_VOLTAGE_ARCHIVE,R30
	STS  _BATTERY_VOLTAGE_ARCHIVE+1,R31
; 0000 0334 
; 0000 0335         for(i=0;i<10;i++){
	LDI  R30,LOW(0)
	ST   Y,R30
_0x13A:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRSH _0x13B
; 0000 0336         VoltageSum = VoltageSum + BATTERY_VOLTAGE_ARCHIVE[i];
	LD   R30,Y
	LDI  R26,LOW(_BATTERY_VOLTAGE_ARCHIVE)
	LDI  R27,HIGH(_BATTERY_VOLTAGE_ARCHIVE)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 0337         }
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x13A
_0x13B:
; 0000 0338     BATTERY_VOLTAGE = VoltageSum/10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STS  _BATTERY_VOLTAGE,R30
	STS  _BATTERY_VOLTAGE+1,R31
; 0000 0339 
; 0000 033A     Timer29 = 0;
	LDI  R30,LOW(0)
	STS  _Timer29_S0000007000,R30
	STS  _Timer29_S0000007000+1,R30
; 0000 033B     }
	ADIW R28,7
; 0000 033C return 1;
_0x135:
_0x2020002:
	LDI  R30,LOW(1)
	RET
; 0000 033D }
;
;char led_put_runing_text(unsigned int Position,char flash *str){
; 0000 033F char led_put_runing_text(unsigned int Position,char flash *str){
_led_put_runing_text:
; 0000 0340 unsigned int StrLenght = strlenf(str);
; 0000 0341 signed int i,a;
; 0000 0342     for(i=0;i<4;i++){
	CALL __SAVELOCR6
;	Position -> Y+8
;	*str -> Y+6
;	StrLenght -> R16,R17
;	i -> R18,R19
;	a -> R20,R21
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOVW R16,R30
	__GETWRN 18,19,0
_0x13D:
	__CPWRN 18,19,4
	BRGE _0x13E
; 0000 0343     a = i + Position - 4;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADD  R30,R18
	ADC  R31,R19
	SBIW R30,4
	MOVW R20,R30
; 0000 0344         if(a>=0){
	TST  R21
	BRMI _0x13F
; 0000 0345             if(a<StrLenght){
	__CPWRR 20,21,16,17
	BRSH _0x140
; 0000 0346             //lcd_putchar(str[a]);
; 0000 0347             LcdText[i] = str[a];
	MOVW R30,R18
	SUBI R30,LOW(-_LcdText)
	SBCI R31,HIGH(-_LcdText)
	MOVW R0,R30
	MOVW R30,R20
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R0
	ST   X,R30
; 0000 0348             }
; 0000 0349             else{
	RJMP _0x141
_0x140:
; 0000 034A                 if(i==0){
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x142
; 0000 034B                 return 1;
	LDI  R30,LOW(1)
	RJMP _0x2020001
; 0000 034C                 }
; 0000 034D             }
_0x142:
_0x141:
; 0000 034E         }
; 0000 034F     }
_0x13F:
	__ADDWRN 18,19,1
	RJMP _0x13D
_0x13E:
; 0000 0350 return 0;
	LDI  R30,LOW(0)
_0x2020001:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; 0000 0351 }
;
;
;signed int Timer16;// 1 savaites taimerio sekundziu skaicius
;eeprom signed int Timer17;// 1 savaites taimerio minuciu skaicius
;eeprom signed int Timer18;// 1 savaites taimerio valandu skaicius
;char StartDischargeAfter(   unsigned char days,     unsigned char hours,
; 0000 0358                             unsigned char minutes,  unsigned char seconds){
_StartDischargeAfter:
; 0000 0359 Timer16 = seconds;
;	days -> Y+3
;	hours -> Y+2
;	minutes -> Y+1
;	seconds -> Y+0
	LD   R30,Y
	LDI  R31,0
	STS  _Timer16,R30
	STS  _Timer16+1,R31
; 0000 035A Timer17 = minutes;
	LDD  R30,Y+1
	LDI  R26,LOW(_Timer17)
	LDI  R27,HIGH(_Timer17)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 035B Timer18 = hours + days*24;
	LDD  R22,Y+2
	CLR  R23
	LDD  R26,Y+3
	LDI  R30,LOW(24)
	MULS R30,R26
	MOVW R30,R0
	ADD  R30,R22
	ADC  R31,R23
	LDI  R26,LOW(_Timer18)
	LDI  R27,HIGH(_Timer18)
	CALL __EEPROMWRW
; 0000 035C return 1;
	LDI  R30,LOW(1)
	ADIW R28,4
	RET
; 0000 035D }
;
;
;
;
;
;// Timer 0 overflow interrupt service routine
;unsigned int InteruptTimer;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 0365 interrupt [10] void timer0_ovf_isr(void){
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0366 
; 0000 0367 InteruptTimer++;
	LDI  R26,LOW(_InteruptTimer)
	LDI  R27,HIGH(_InteruptTimer)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0368 /////////////////////////// 1 Second Callback ///////////////////////////////////////
; 0000 0369     if(InteruptTimer>=495){
	LDS  R26,_InteruptTimer
	LDS  R27,_InteruptTimer+1
	CPI  R26,LOW(0x1EF)
	LDI  R30,HIGH(0x1EF)
	CPC  R27,R30
	BRLO _0x143
; 0000 036A     RealTime = 1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 036B     InteruptTimer = 0;
	LDI  R30,LOW(0)
	STS  _InteruptTimer,R30
	STS  _InteruptTimer+1,R30
; 0000 036C     }
; 0000 036D /////////////////////////////////////////////////////////////////////////////////////
; 0000 036E }
_0x143:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;
;void main(void){
; 0000 0371 void main(void){
_main:
; 0000 0372 // Crystal Oscillator division factor: 1
; 0000 0373 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0374 DDRA=0b11010000;
	LDI  R30,LOW(208)
	OUT  0x1A,R30
; 0000 0375 
; 0000 0376 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0377 DDRB=0b00;
	OUT  0x17,R30
; 0000 0378 
; 0000 0379 PORTC=0x00;
	OUT  0x15,R30
; 0000 037A DDRC=0b11111111;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 037B 
; 0000 037C PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 037D DDRD=0b11111100;
	LDI  R30,LOW(252)
	OUT  0x11,R30
; 0000 037E 
; 0000 037F // Timer/Counter 0 initialization
; 0000 0380 // Clock source: System Clock
; 0000 0381 // Clock value: 125.000 kHz
; 0000 0382 // Mode: Normal top=FFh
; 0000 0383 // OC0 output: Disconnected
; 0000 0384 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0385 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0386 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0387 
; 0000 0388 // Timer/Counter 1 initialization
; 0000 0389 // Clock source: System Clock
; 0000 038A // Clock value: Timer1 Stopped
; 0000 038B // Mode: Normal top=FFFFh
; 0000 038C // OC1A output: Discon.
; 0000 038D // OC1B output: Discon.
; 0000 038E // Noise Canceler: Off
; 0000 038F // Input Capture on Falling Edge
; 0000 0390 // Timer1 Overflow Interrupt: Off
; 0000 0391 // Input Capture Interrupt: Off
; 0000 0392 // Compare A Match Interrupt: Off
; 0000 0393 // Compare B Match Interrupt: Off
; 0000 0394 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0395 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0396 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0397 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0398 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0399 ICR1L=0x00;
	OUT  0x26,R30
; 0000 039A OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 039B OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 039C OCR1BH=0x00;
	OUT  0x29,R30
; 0000 039D OCR1BL=0x00;
	OUT  0x28,R30
; 0000 039E 
; 0000 039F // Timer/Counter 2 initialization
; 0000 03A0 // Clock source: System Clock
; 0000 03A1 // Clock value: Timer2 Stopped
; 0000 03A2 // Mode: Normal top=FFh
; 0000 03A3 // OC2 output: Disconnected
; 0000 03A4 ASSR=0x00;
	OUT  0x22,R30
; 0000 03A5 //TCCR2=0x00;
; 0000 03A6 TCNT2=0x00;
	OUT  0x24,R30
; 0000 03A7 OCR2=0x00;
	OUT  0x23,R30
; 0000 03A8 
; 0000 03A9 // External Interrupt(s) initialization
; 0000 03AA // INT0: Off
; 0000 03AB // INT1: Off
; 0000 03AC // INT2: Off
; 0000 03AD MCUCR=0x00;
	OUT  0x35,R30
; 0000 03AE MCUCSR=0x00;
	OUT  0x34,R30
; 0000 03AF 
; 0000 03B0 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 03B1 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 03B2 
; 0000 03B3 // Analog Comparator initialization
; 0000 03B4 // Analog Comparator: Off
; 0000 03B5 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 03B6 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 03B7 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 03B8 
; 0000 03B9 // ADC initialization
; 0000 03BA // ADC Clock frequency: 62.500 kHz
; 0000 03BB // ADC Voltage Reference: Int., cap. on AREF
; 0000 03BC // ADC Auto Trigger Source: Free Running
; 0000 03BD ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 03BE ADCSRA=0xA7;
	LDI  R30,LOW(167)
	OUT  0x6,R30
; 0000 03BF SFIOR&=0x1F;
	IN   R30,0x30
	ANDI R30,LOW(0x1F)
	OUT  0x30,R30
; 0000 03C0 
; 0000 03C1 // Global enable interrupts
; 0000 03C2 #asm("sei")
	sei
; 0000 03C3 
; 0000 03C4 
; 0000 03C5 // Kai pasijungia ir buna nesamoningi skaiciai reikia nuresetint i default'us
; 0000 03C6     if((Timer4==65535)||(Timer5==65535)){Timer4 = 0;Timer5 = 0;}
	LDI  R26,LOW(_Timer4)
	LDI  R27,HIGH(_Timer4)
	CALL __EEPROMRDW
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BREQ _0x145
	LDI  R26,LOW(_Timer5)
	LDI  R27,HIGH(_Timer5)
	CALL __EEPROMRDW
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x144
_0x145:
	LDI  R26,LOW(_Timer4)
	LDI  R27,HIGH(_Timer4)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	LDI  R26,LOW(_Timer5)
	LDI  R27,HIGH(_Timer5)
	CALL __EEPROMWRW
; 0000 03C7 
; 0000 03C8     if(BATTERY_FOULT==255){BATTERY_FOULT = 0;}
_0x144:
	LDI  R26,LOW(_BATTERY_FOULT)
	LDI  R27,HIGH(_BATTERY_FOULT)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xFF)
	BRNE _0x147
	LDI  R26,LOW(_BATTERY_FOULT)
	LDI  R27,HIGH(_BATTERY_FOULT)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 03C9 
; 0000 03CA     if((Timer18>168)||(Timer18<0)){ StartDischargeAfter(7,0,0,0);}
_0x147:
	LDI  R26,LOW(_Timer18)
	LDI  R27,HIGH(_Timer18)
	CALL __EEPROMRDW
	CPI  R30,LOW(0xA9)
	LDI  R26,HIGH(0xA9)
	CPC  R31,R26
	BRGE _0x149
	LDI  R26,LOW(_Timer18+1)
	LDI  R27,HIGH(_Timer18+1)
	CALL __EEPROMRDB
	TST  R30
	BRPL _0x148
_0x149:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RCALL _StartDischargeAfter
; 0000 03CB 
; 0000 03CC     if(MAX_BATTERY_VOLTAGE==65535){MAX_BATTERY_VOLTAGE = 146;}
_0x148:
	LDI  R26,LOW(_MAX_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MAX_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x14B
	LDI  R26,LOW(_MAX_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MAX_BATTERY_VOLTAGE)
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	CALL __EEPROMWRW
; 0000 03CD 
; 0000 03CE     if(MIN_BATTERY_VOLTAGE==65535){MIN_BATTERY_VOLTAGE = 110;}
_0x14B:
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x14C
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	CALL __EEPROMWRW
; 0000 03CF /////////////////////////////////////////////////////////////////////////////
; 0000 03D0 
; 0000 03D1 UPS_STATE = 1;
_0x14C:
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 03D2 
; 0000 03D3 // Ijungiant prabega uzrasas "HELLO"
; 0000 03D4 static unsigned int Timer1;// "HELLO" Taimeris
; 0000 03D5     while(Timer1<2000){
_0x14D:
	LDS  R26,_Timer1_S000000B000
	LDS  R27,_Timer1_S000000B000+1
	CPI  R26,LOW(0x7D0)
	LDI  R30,HIGH(0x7D0)
	CPC  R27,R30
	BRSH _0x14F
; 0000 03D6     char HelloPadetis = Timer1/200;
; 0000 03D7     UpdateVariableOSC();
	SBIW R28,1
;	HelloPadetis -> Y+0
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL __DIVW21U
	ST   Y,R30
	RCALL _UpdateVariableOSC
; 0000 03D8     Timer1++;
	LDI  R26,LOW(_Timer1_S000000B000)
	LDI  R27,HIGH(_Timer1_S000000B000)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 03D9     led_put_runing_text(HelloPadetis,"HELLO");
	LD   R30,Y
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _led_put_runing_text
; 0000 03DA     UpdateLcd();
	RCALL _UpdateLcd
; 0000 03DB     delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 03DC     }
	ADIW R28,1
	RJMP _0x14D
_0x14F:
; 0000 03DD 
; 0000 03DE // Programos kodas
; 0000 03DF     while(1){
_0x150:
; 0000 03E0     UpdateVariableOSC();
	RCALL _UpdateVariableOSC
; 0000 03E1     CheckBattery();
	RCALL _CheckBattery
; 0000 03E2 
; 0000 03E3 
; 0000 03E4 
; 0000 03E5 
; 0000 03E6 
; 0000 03E7 
; 0000 03E8 
; 0000 03E9 
; 0000 03EA 
; 0000 03EB 
; 0000 03EC //////////////////////////// 1 sec callback ////////////////////////////////////////
; 0000 03ED         if(RealTime==1){
	LDI  R30,LOW(1)
	CP   R30,R13
	BREQ PC+3
	JMP _0x153
; 0000 03EE         //////////// 1 SAVAITES TIMERIS /////////////
; 0000 03EF             if(UPS_STATE!=2){
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE PC+3
	JMP _0x154
; 0000 03F0                 if((Timer16>0)||(Timer17>0)||(Timer18>0)){
	LDS  R26,_Timer16
	LDS  R27,_Timer16+1
	CALL __CPW02
	BRLT _0x156
	LDI  R26,LOW(_Timer17)
	LDI  R27,HIGH(_Timer17)
	CALL __EEPROMRDW
	MOVW R26,R30
	CALL __CPW02
	BRLT _0x156
	LDI  R26,LOW(_Timer18)
	LDI  R27,HIGH(_Timer18)
	CALL __EEPROMRDW
	MOVW R26,R30
	CALL __CPW02
	BRGE _0x155
_0x156:
; 0000 03F1                 // Taimeris skaiciuoja tik tada kai neissikraudinejama
; 0000 03F2                 Timer16--;//s
	LDI  R26,LOW(_Timer16)
	LDI  R27,HIGH(_Timer16)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 03F3                     if(Timer16<0){
	LDS  R26,_Timer16+1
	TST  R26
	BRPL _0x158
; 0000 03F4                     Timer16 = 59;//m
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	STS  _Timer16,R30
	STS  _Timer16+1,R31
; 0000 03F5                     Timer17--;
	LDI  R26,LOW(_Timer17)
	LDI  R27,HIGH(_Timer17)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
; 0000 03F6                         if(Timer17<0){
	LDI  R26,LOW(_Timer17+1)
	LDI  R27,HIGH(_Timer17+1)
	CALL __EEPROMRDB
	TST  R30
	BRPL _0x159
; 0000 03F7                         Timer17 = 59;
	LDI  R26,LOW(_Timer17)
	LDI  R27,HIGH(_Timer17)
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	CALL __EEPROMWRW
; 0000 03F8                         Timer18--;//h
	LDI  R26,LOW(_Timer18)
	LDI  R27,HIGH(_Timer18)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
; 0000 03F9                         }
; 0000 03FA                     }
_0x159:
; 0000 03FB                 }
_0x158:
; 0000 03FC                 else{
	RJMP _0x15A
_0x155:
; 0000 03FD                     if(UPS_STATE==0){
	TST  R6
	BRNE _0x15B
; 0000 03FE                         if(SKIP==0){
	TST  R7
	BRNE _0x15C
; 0000 03FF                         // Jei UPS neuzsiemes ir nera SKIP'o - issikraudineti
; 0000 0400                         UPS_STATE = 2;
	LDI  R30,LOW(2)
	MOV  R6,R30
; 0000 0401                         }
; 0000 0402                         else{
	RJMP _0x15D
_0x15C:
; 0000 0403                         // Jei UPS uzimtas pratesti
; 0000 0404                         // savaitini taimeri pusvalandziu
; 0000 0405                         StartDischargeAfter(0,0,30,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _StartDischargeAfter
; 0000 0406                         }
_0x15D:
; 0000 0407                     }
; 0000 0408                     else{
	RJMP _0x15E
_0x15B:
; 0000 0409                     // Jei UPS uzimtas pratesti
; 0000 040A                     // savaitini taimeri pusvalandziu
; 0000 040B                     StartDischargeAfter(0,0,30,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _StartDischargeAfter
; 0000 040C                     }
_0x15E:
; 0000 040D                 }
_0x15A:
; 0000 040E             }
; 0000 040F     /////////////////////////////////////////////
; 0000 0410     ////////// Discharge Time Counter ///////////
; 0000 0411             if(UPS_STATE==2){
_0x154:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x15F
; 0000 0412             // Iskrovimo laikas skaiciuojamas tik tada kai issikraudinejama
; 0000 0413             Timer7++;//s
	LDI  R26,LOW(_Timer7)
	LDI  R27,HIGH(_Timer7)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0414             Timer24 = 0;
	LDI  R30,LOW(0)
	STS  _Timer24,R30
	STS  _Timer24+1,R30
; 0000 0415                 if(Timer7>=60){
	LDS  R26,_Timer7
	LDS  R27,_Timer7+1
	SBIW R26,60
	BRLO _0x160
; 0000 0416                 Timer7 = 0;
	STS  _Timer7,R30
	STS  _Timer7+1,R30
; 0000 0417                 Timer8++;//m
	LDI  R26,LOW(_Timer8)
	LDI  R27,HIGH(_Timer8)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0418                     if(Timer8>=60){
	LDS  R26,_Timer8
	LDS  R27,_Timer8+1
	SBIW R26,60
	BRLO _0x161
; 0000 0419                     Timer8 = 0;
	LDI  R30,LOW(0)
	STS  _Timer8,R30
	STS  _Timer8+1,R30
; 0000 041A                     Timer9++;//h
	LDI  R26,LOW(_Timer9)
	LDI  R27,HIGH(_Timer9)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 041B                     }
; 0000 041C                 }
_0x161:
; 0000 041D             }
_0x160:
; 0000 041E     /////////////////////////////////////////////
; 0000 041F         RealTime = 0;
_0x15F:
	CLR  R13
; 0000 0420         }
; 0000 0421 ////////////////////////////////////////////////////////////////////////////////////
; 0000 0422 
; 0000 0423 
; 0000 0424 
; 0000 0425 
; 0000 0426 
; 0000 0427 
; 0000 0428 
; 0000 0429 
; 0000 042A 
; 0000 042B 
; 0000 042C 
; 0000 042D 
; 0000 042E 
; 0000 042F //////////////////////////// SKIPER ////////////////////////////////////////////////
; 0000 0430         if(PIND.2==1){
_0x153:
	SBIS 0x10,2
	RJMP _0x162
; 0000 0431             if(SKIP==0){
	TST  R7
	BRNE _0x163
; 0000 0432             // Isijungiant SKIP'o kontaktui - nutraukti viska ir ikrauti
; 0000 0433             SKIP = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0434             UPS_STATE = 1;
	MOV  R6,R30
; 0000 0435             }
; 0000 0436         }
_0x163:
; 0000 0437         else{
	RJMP _0x164
_0x162:
; 0000 0438         SKIP = 0;
	CLR  R7
; 0000 0439         }
_0x164:
; 0000 043A ////////////////////////////////////////////////////////////////////////////////////
; 0000 043B 
; 0000 043C 
; 0000 043D 
; 0000 043E 
; 0000 043F 
; 0000 0440 
; 0000 0441 
; 0000 0442 
; 0000 0443 
; 0000 0444 
; 0000 0445 
; 0000 0446 
; 0000 0447 
; 0000 0448 /////////////////////// UPS STATUSAS ///////////////////////////////////////////////
; 0000 0449         if(UPS_STATE==0){
	TST  R6
	BREQ PC+3
	JMP _0x165
; 0000 044A         // Nulinis statusas
; 0000 044B         char NulinioStatusoPadetis;
; 0000 044C         Timer3++;// Begancio taskelio taimeris
	SBIW R28,1
;	NulinioStatusoPadetis -> Y+0
	LDI  R26,LOW(_Timer3)
	LDI  R27,HIGH(_Timer3)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
; 0000 044D 
; 0000 044E             if(Timer3>=3000){// Begancio taskelio taimerio resetas
	LDS  R26,_Timer3
	LDS  R27,_Timer3+1
	CPI  R26,LOW(0xBB8)
	LDI  R30,HIGH(0xBB8)
	CPC  R27,R30
	BRLO _0x166
; 0000 044F             Timer3 = 0;
	LDI  R30,LOW(0)
	STS  _Timer3,R30
	STS  _Timer3+1,R30
; 0000 0450             }
; 0000 0451         NulinioStatusoPadetis = Timer3/500;
_0x166:
	LDS  R26,_Timer3
	LDS  R27,_Timer3+1
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL __DIVW21U
	ST   Y,R30
; 0000 0452             if(NulinioStatusoPadetis==0){     LcdTaskas[0] = 1;}
	CPI  R30,0
	BRNE _0x167
	LDI  R30,LOW(1)
	STS  _LcdTaskas,R30
; 0000 0453             else if(NulinioStatusoPadetis==1){LcdTaskas[1] = 1;}
	RJMP _0x168
_0x167:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BREQ _0x218
; 0000 0454             else if(NulinioStatusoPadetis==2){LcdTaskas[2] = 1;}
	CPI  R26,LOW(0x2)
	BRNE _0x16B
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,2
; 0000 0455             else if(NulinioStatusoPadetis==3){LcdTaskas[3] = 1;}
	RJMP _0x16C
_0x16B:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x16D
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,3
; 0000 0456             else if(NulinioStatusoPadetis==4){LcdTaskas[2] = 1;}
	RJMP _0x16E
_0x16D:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x16F
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,2
; 0000 0457             else if(NulinioStatusoPadetis==5){LcdTaskas[1] = 1;}
	RJMP _0x170
_0x16F:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x171
_0x218:
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,1
; 0000 0458 
; 0000 0459 
; 0000 045A         // Tikrinti baterijas del issikrovimo
; 0000 045B             if(BATTERY_VOLTAGE<=MIN_BATTERY_VOLTAGE){
_0x171:
_0x170:
_0x16E:
_0x16C:
_0x168:
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x172
; 0000 045C             UPS_STATE = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 045D             }
; 0000 045E 
; 0000 045F 
; 0000 0460         }
_0x172:
	RJMP _0x219
; 0000 0461         else if(UPS_STATE==1){
_0x165:
	LDI  R30,LOW(1)
	CP   R30,R6
	BREQ PC+3
	JMP _0x174
; 0000 0462         // Krovimo statusas
; 0000 0463             if(OLD_UPS_STATE!=1){
	CP   R30,R9
	BREQ _0x175
; 0000 0464             Timer12 = 0;
	LDI  R30,LOW(0)
	STS  _Timer12,R30
	STS  _Timer12+1,R30
; 0000 0465             KRAUTI = 0;
	CLR  R8
; 0000 0466             LOAD = 0;
	CLR  R11
; 0000 0467             }
; 0000 0468         // Charge State
; 0000 0469         Timer12++;
_0x175:
	LDI  R26,LOW(_Timer12)
	LDI  R27,HIGH(_Timer12)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 046A             if(Timer12>=30000){
	LDS  R26,_Timer12
	LDS  R27,_Timer12+1
	CPI  R26,LOW(0x7530)
	LDI  R30,HIGH(0x7530)
	CPC  R27,R30
	BRLO _0x176
; 0000 046B             Timer12 = 0;
	LDI  R30,LOW(0)
	STS  _Timer12,R30
	STS  _Timer12+1,R30
; 0000 046C             }
; 0000 046D 
; 0000 046E             if((Timer12>=0)&&(Timer12<3000)){
_0x176:
	LDS  R26,_Timer12
	LDS  R27,_Timer12+1
	SBIW R26,0
	BRLO _0x178
	CPI  R26,LOW(0xBB8)
	LDI  R30,HIGH(0xBB8)
	CPC  R27,R30
	BRLO _0x179
_0x178:
	RJMP _0x177
_0x179:
; 0000 046F             LOAD = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0470             KRAUTI = 0;
	CLR  R8
; 0000 0471             LcdText[0] = 'L';LcdText[1] = 'o';LcdText[2] = 'A';LcdText[3] = 'd';
	LDI  R30,LOW(76)
	STS  _LcdText,R30
	LDI  R30,LOW(111)
	__PUTB1MN _LcdText,1
	LDI  R30,LOW(65)
	__PUTB1MN _LcdText,2
	LDI  R30,LOW(100)
	RJMP _0x21A
; 0000 0472             }
; 0000 0473             else{
_0x177:
; 0000 0474             LOAD = 0;
	CLR  R11
; 0000 0475             KRAUTI = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0476             LcdText[0] = 'c';LcdText[1] = 'h';LcdText[2] = 'A';LcdText[3] = 'r';
	LDI  R30,LOW(99)
	STS  _LcdText,R30
	LDI  R30,LOW(104)
	__PUTB1MN _LcdText,1
	LDI  R30,LOW(65)
	__PUTB1MN _LcdText,2
	LDI  R30,LOW(114)
_0x21A:
	__PUTB1MN _LcdText,3
; 0000 0477             }
; 0000 0478 
; 0000 0479             if(BATTERY_VOLTAGE>=MAX_BATTERY_VOLTAGE){
	LDI  R26,LOW(_MAX_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MAX_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x17B
; 0000 047A             // Jei baterija uzsikrovusi isjungti krovima
; 0000 047B             UPS_STATE = 0;
	CLR  R6
; 0000 047C             }
; 0000 047D         }
_0x17B:
; 0000 047E         else if(UPS_STATE==2){
	RJMP _0x17C
_0x174:
	LDI  R30,LOW(2)
	CP   R30,R6
	BREQ PC+3
	JMP _0x17D
; 0000 047F         // Iskrovimo statusas
; 0000 0480         char DchrPadetis;
; 0000 0481         Timer24++;
	SBIW R28,1
;	DchrPadetis -> Y+0
	LDI  R26,LOW(_Timer24)
	LDI  R27,HIGH(_Timer24)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0482 
; 0000 0483             if(OLD_UPS_STATE!=2){
	LDI  R30,LOW(2)
	CP   R30,R9
	BREQ _0x17E
; 0000 0484             // Jei katik isijunge iskrovimas
; 0000 0485 
; 0000 0486             // Nuresetint dabartinio iskrovimo laikmati
; 0000 0487             Timer7 = 0;
	LDI  R30,LOW(0)
	STS  _Timer7,R30
	STS  _Timer7+1,R30
; 0000 0488             Timer8 = 0;
	STS  _Timer8,R30
	STS  _Timer8+1,R30
; 0000 0489             Timer9 = 0;
	STS  _Timer9,R30
	STS  _Timer9+1,R30
; 0000 048A             }
; 0000 048B 
; 0000 048C         Timer20++;// Begancio uzrasio taimeris
_0x17E:
	LDI  R26,LOW(_Timer20)
	LDI  R27,HIGH(_Timer20)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 048D             if(Timer20>=7500){
	LDS  R26,_Timer20
	LDS  R27,_Timer20+1
	CPI  R26,LOW(0x1D4C)
	LDI  R30,HIGH(0x1D4C)
	CPC  R27,R30
	BRLO _0x17F
; 0000 048E             Timer20 = 0;
	LDI  R30,LOW(0)
	STS  _Timer20,R30
	STS  _Timer20+1,R30
; 0000 048F             }
; 0000 0490         DchrPadetis = Timer20/500;
_0x17F:
	LDS  R26,_Timer20
	LDS  R27,_Timer20+1
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL __DIVW21U
	ST   Y,R30
; 0000 0491         led_put_runing_text(DchrPadetis,"diSchArGinG");
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,6
	ST   -Y,R31
	ST   -Y,R30
	RCALL _led_put_runing_text
; 0000 0492 
; 0000 0493 
; 0000 0494         BEEPER_OFF = 0;
	CLR  R10
; 0000 0495         // Beeper off
; 0000 0496             if(Timer7==10){
	LDS  R26,_Timer7
	LDS  R27,_Timer7+1
	SBIW R26,10
	BRNE _0x180
; 0000 0497                 if(Timer8==0){
	LDS  R30,_Timer8
	LDS  R31,_Timer8+1
	SBIW R30,0
	BRNE _0x181
; 0000 0498                     if(Timer9==0){
	LDS  R30,_Timer9
	LDS  R31,_Timer9+1
	SBIW R30,0
	BRNE _0x182
; 0000 0499                     BEEPER_OFF = 1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 049A                     }
; 0000 049B                 }
_0x182:
; 0000 049C             }
_0x181:
; 0000 049D 
; 0000 049E         // Iskrovimo stabdymo blokas pagal itampos davikli:
; 0000 049F             //if(BATTERY==0){
; 0000 04A0             if(BATTERY_VOLTAGE<=MIN_BATTERY_VOLTAGE){
_0x180:
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x183
; 0000 04A1             // Skaiciuoti 5 sekundes kad isjungti iskrovima kai
; 0000 04A2             // tik baterija tampa tuscia
; 0000 04A3             Timer14++;
	LDI  R26,LOW(_Timer14)
	LDI  R27,HIGH(_Timer14)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 04A4                 if(Timer14>=5000){
	LDS  R26,_Timer14
	LDS  R27,_Timer14+1
	CPI  R26,LOW(0x1388)
	LDI  R30,HIGH(0x1388)
	CPC  R27,R30
	BRLO _0x184
; 0000 04A5                 UPS_STATE = 1;// Vietoj iskrovimo ijungti krovima
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 04A6                 Timer14 = 0;
	LDI  R30,LOW(0)
	STS  _Timer14,R30
	STS  _Timer14+1,R30
; 0000 04A7 
; 0000 04A8                 // Dabartinio iskrovimo laiko vertes
; 0000 04A9                 // perkelti i paskutinio iskrovimo laika
; 0000 04AA                 Timer4 = Timer8;
	LDS  R30,_Timer8
	LDS  R31,_Timer8+1
	LDI  R26,LOW(_Timer4)
	LDI  R27,HIGH(_Timer4)
	CALL __EEPROMWRW
; 0000 04AB                 Timer5 = Timer9;
	LDS  R30,_Timer9
	LDS  R31,_Timer9+1
	LDI  R26,LOW(_Timer5)
	LDI  R27,HIGH(_Timer5)
	CALL __EEPROMWRW
; 0000 04AC 
; 0000 04AD                 // Iskrovimas sekmingas todel savaitini
; 0000 04AE                 // taimeri graziname i pradines vertes
; 0000 04AF                 StartDischargeAfter(7,0,0,0);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RCALL _StartDischargeAfter
; 0000 04B0 
; 0000 04B1                 // Jei iskrovimo laikas nesiekia
; 0000 04B2                 // 3 valandu rodyti baterijos klaida
; 0000 04B3                     if(Timer5<3){
	LDI  R26,LOW(_Timer5)
	LDI  R27,HIGH(_Timer5)
	CALL __EEPROMRDW
	SBIW R30,3
	BRSH _0x185
; 0000 04B4                     BATTERY_FOULT = 1;
	LDI  R26,LOW(_BATTERY_FOULT)
	LDI  R27,HIGH(_BATTERY_FOULT)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 04B5                     }
; 0000 04B6                 }
_0x185:
; 0000 04B7             }
_0x184:
; 0000 04B8             else{
	RJMP _0x186
_0x183:
; 0000 04B9             Timer14 = 0;
	LDI  R30,LOW(0)
	STS  _Timer14,R30
	STS  _Timer14+1,R30
; 0000 04BA             }
_0x186:
; 0000 04BB         }
_0x219:
	ADIW R28,1
; 0000 04BC 
; 0000 04BD     // Kai baigiasi krovimas, nesvarbu kas leme jo baigti
; 0000 04BE         if((OLD_UPS_STATE==1)&&(UPS_STATE!=1)){
_0x17D:
_0x17C:
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x188
	CP   R30,R6
	BRNE _0x189
_0x188:
	RJMP _0x187
_0x189:
; 0000 04BF         Timer12 = 0;
	LDI  R30,LOW(0)
	STS  _Timer12,R30
	STS  _Timer12+1,R30
; 0000 04C0         KRAUTI = 0;
	CLR  R8
; 0000 04C1         LOAD = 0;
	CLR  R11
; 0000 04C2         }
; 0000 04C3 
; 0000 04C4     // Kai pasibaigia iskrovimas, nesvarbu kas leme jo baigti
; 0000 04C5         if((OLD_UPS_STATE==2)&&(UPS_STATE!=2)){
_0x187:
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x18B
	CP   R30,R6
	BRNE _0x18C
_0x18B:
	RJMP _0x18A
_0x18C:
; 0000 04C6         BEEPER_OFF = 0;
	CLR  R10
; 0000 04C7         Timer7 = 0;
	LDI  R30,LOW(0)
	STS  _Timer7,R30
	STS  _Timer7+1,R30
; 0000 04C8         Timer8 = 0;
	STS  _Timer8,R30
	STS  _Timer8+1,R30
; 0000 04C9         Timer9 = 0;
	STS  _Timer9,R30
	STS  _Timer9+1,R30
; 0000 04CA         Timer14 = 0;
	STS  _Timer14,R30
	STS  _Timer14+1,R30
; 0000 04CB         }
; 0000 04CC 
; 0000 04CD     OLD_UPS_STATE = UPS_STATE;
_0x18A:
	MOV  R9,R6
; 0000 04CE ////////////////////////////////////////////////////////////////////////////////////
; 0000 04CF 
; 0000 04D0 
; 0000 04D1 
; 0000 04D2 
; 0000 04D3 
; 0000 04D4 
; 0000 04D5 
; 0000 04D6 
; 0000 04D7 
; 0000 04D8 
; 0000 04D9 
; 0000 04DA ///////////////////////// BATTERY_FOULT ////////////////////////////////////////////
; 0000 04DB         if(BATTERY_FOULT==1){
	LDI  R26,LOW(_BATTERY_FOULT)
	LDI  R27,HIGH(_BATTERY_FOULT)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x18D
; 0000 04DC             if(UPS_STATE==0){
	TST  R6
	BRNE _0x18E
; 0000 04DD             char FoultPadetis;
; 0000 04DE             static unsigned int Timer2;
; 0000 04DF             Timer2++;
	SBIW R28,1
;	FoultPadetis -> Y+0
	LDI  R26,LOW(_Timer2_S000000B003)
	LDI  R27,HIGH(_Timer2_S000000B003)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 04E0                 if(Timer2>=3400){
	LDS  R26,_Timer2_S000000B003
	LDS  R27,_Timer2_S000000B003+1
	CPI  R26,LOW(0xD48)
	LDI  R30,HIGH(0xD48)
	CPC  R27,R30
	BRLO _0x18F
; 0000 04E1                 Timer2 = 0;
	LDI  R30,LOW(0)
	STS  _Timer2_S000000B003,R30
	STS  _Timer2_S000000B003+1,R30
; 0000 04E2                 }
; 0000 04E3             FoultPadetis = Timer2/200;
_0x18F:
	LDS  R26,_Timer2_S000000B003
	LDS  R27,_Timer2_S000000B003+1
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL __DIVW21U
	ST   Y,R30
; 0000 04E4             led_put_runing_text(FoultPadetis,"bAttErY FouLt");
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,18
	ST   -Y,R31
	ST   -Y,R30
	RCALL _led_put_runing_text
; 0000 04E5 
; 0000 04E6             LcdTaskas[0] = 0;
	LDI  R30,LOW(0)
	STS  _LcdTaskas,R30
; 0000 04E7             LcdTaskas[1] = 0;
	__PUTB1MN _LcdTaskas,1
; 0000 04E8             LcdTaskas[2] = 0;
	__PUTB1MN _LcdTaskas,2
; 0000 04E9             LcdTaskas[3] = 0;
	__PUTB1MN _LcdTaskas,3
; 0000 04EA             }
	ADIW R28,1
; 0000 04EB         }
_0x18E:
; 0000 04EC ////////////////////////////////////////////////////////////////////////////////////
; 0000 04ED 
; 0000 04EE 
; 0000 04EF 
; 0000 04F0 
; 0000 04F1 
; 0000 04F2 
; 0000 04F3 
; 0000 04F4 
; 0000 04F5 
; 0000 04F6 
; 0000 04F7 
; 0000 04F8 
; 0000 04F9 
; 0000 04FA ///////////////////////////// MYGTUKAI /////////////////////////////////////////////
; 0000 04FB     // Kai nuspaustas tik 1 mygtukas
; 0000 04FC         if((BUTTON[0]==1)&&(BUTTON[1]==0)&&(BUTTON[2]==0)&&(BUTTON[3]==0)){
_0x18D:
	LDS  R26,_BUTTON
	CPI  R26,LOW(0x1)
	BRNE _0x191
	__GETB2MN _BUTTON,1
	CPI  R26,LOW(0x0)
	BRNE _0x191
	__GETB2MN _BUTTON,2
	CPI  R26,LOW(0x0)
	BRNE _0x191
	__GETB2MN _BUTTON,3
	CPI  R26,LOW(0x0)
	BREQ _0x192
_0x191:
	RJMP _0x190
_0x192:
; 0000 04FD             if(UPS_STATE==0){
	TST  R6
	BRNE _0x193
; 0000 04FE             UPS_STATE = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 04FF             }
; 0000 0500         }
_0x193:
; 0000 0501 
; 0000 0502     // Kai nuspaustas tik 2 mygtukas:
; 0000 0503     // Iskrovimo nutraukimas ir baterijos klaidos nuresetinimo:
; 0000 0504         if((BUTTON[0]==0)&&(BUTTON[1]==1)&&(BUTTON[2]==0)&&(BUTTON[3]==0)){
_0x190:
	LDS  R26,_BUTTON
	CPI  R26,LOW(0x0)
	BRNE _0x195
	__GETB2MN _BUTTON,1
	CPI  R26,LOW(0x1)
	BRNE _0x195
	__GETB2MN _BUTTON,2
	CPI  R26,LOW(0x0)
	BRNE _0x195
	__GETB2MN _BUTTON,3
	CPI  R26,LOW(0x0)
	BREQ _0x196
_0x195:
	RJMP _0x194
_0x196:
; 0000 0505             if(UPS_STATE==2){
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x197
; 0000 0506             UPS_STATE = 1;// Vietoj iskrovimo ijungti krovima
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0507 
; 0000 0508             // Iskrovimas nutrauktas samoningai todel savaitini
; 0000 0509             // taimeri graziname i pradines vertes
; 0000 050A             StartDischargeAfter(7,0,0,0);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RCALL _StartDischargeAfter
; 0000 050B             }
; 0000 050C 
; 0000 050D         // Jei buvo baterijos klaida laikant mygtuka ji nuresetinama
; 0000 050E             if(BATTERY_FOULT==1){
_0x197:
	LDI  R26,LOW(_BATTERY_FOULT)
	LDI  R27,HIGH(_BATTERY_FOULT)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x198
; 0000 050F             Timer10++;
	LDI  R26,LOW(_Timer10)
	LDI  R27,HIGH(_Timer10)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0510                 if(Timer10>=2000){// ~ 2 sec
	LDS  R26,_Timer10
	LDS  R27,_Timer10+1
	CPI  R26,LOW(0x7D0)
	LDI  R30,HIGH(0x7D0)
	CPC  R27,R30
	BRLO _0x199
; 0000 0511                 BATTERY_FOULT = 0;
	LDI  R26,LOW(_BATTERY_FOULT)
	LDI  R27,HIGH(_BATTERY_FOULT)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0512                 Timer10 = 0;
	STS  _Timer10,R30
	STS  _Timer10+1,R30
; 0000 0513                 }
; 0000 0514             }
_0x199:
; 0000 0515         }
_0x198:
; 0000 0516         else{
	RJMP _0x19A
_0x194:
; 0000 0517         Timer10 = 0;// Baterijos klaidos nuresetinimo taimeris
	LDI  R30,LOW(0)
	STS  _Timer10,R30
	STS  _Timer10+1,R30
; 0000 0518         }
_0x19A:
; 0000 0519 
; 0000 051A     // Kai nuspaustas tik 3 mygtukas:
; 0000 051B     // Iskrovimo ijungimas:
; 0000 051C         if((BUTTON[0]==0)&&(BUTTON[1]==0)&&(BUTTON[2]==1)&&(BUTTON[3]==0)){
	LDS  R26,_BUTTON
	CPI  R26,LOW(0x0)
	BRNE _0x19C
	__GETB2MN _BUTTON,1
	CPI  R26,LOW(0x0)
	BRNE _0x19C
	__GETB2MN _BUTTON,2
	CPI  R26,LOW(0x1)
	BRNE _0x19C
	__GETB2MN _BUTTON,3
	CPI  R26,LOW(0x0)
	BREQ _0x19D
_0x19C:
	RJMP _0x19B
_0x19D:
; 0000 051D             if(UPS_STATE==0){
	TST  R6
	BREQ PC+3
	JMP _0x19E
; 0000 051E                 if(SKIP==0){
	TST  R7
	BRNE _0x19F
; 0000 051F                 // Jei ups neuzimtas, SKIP'o nera, tai po ~2sec isijungs iskrovimas
; 0000 0520                 Timer11++;
	LDI  R26,LOW(_Timer11)
	LDI  R27,HIGH(_Timer11)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
; 0000 0521                     if(Timer11>2000){
	LDS  R26,_Timer11
	LDS  R27,_Timer11+1
	CPI  R26,LOW(0x7D1)
	LDI  R30,HIGH(0x7D1)
	CPC  R27,R30
	BRLO _0x1A0
; 0000 0522                     UPS_STATE = 2;
	LDI  R30,LOW(2)
	MOV  R6,R30
; 0000 0523                     Timer11 = 0;
	LDI  R30,LOW(0)
	STS  _Timer11,R30
	STS  _Timer11+1,R30
; 0000 0524                     BATTERY_FOULT = 0;
	LDI  R26,LOW(_BATTERY_FOULT)
	LDI  R27,HIGH(_BATTERY_FOULT)
	CALL __EEPROMWRB
; 0000 0525                     }
; 0000 0526                 }
_0x1A0:
; 0000 0527                 else{
	RJMP _0x1A1
_0x19F:
; 0000 0528                 // Jei ups neuzimtas, SKIP'as yra rodyti, kad iskrovima ijungti neimanoma
; 0000 0529                 int FoultPadetis;
; 0000 052A                 Timer19++;
	SBIW R28,2
;	FoultPadetis -> Y+0
	LDI  R26,LOW(_Timer19)
	LDI  R27,HIGH(_Timer19)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 052B                     if(Timer19>=3600){
	LDS  R26,_Timer19
	LDS  R27,_Timer19+1
	CPI  R26,LOW(0xE10)
	LDI  R30,HIGH(0xE10)
	CPC  R27,R30
	BRLO _0x1A2
; 0000 052C                     Timer19 = 0;
	LDI  R30,LOW(0)
	STS  _Timer19,R30
	STS  _Timer19+1,R30
; 0000 052D                     }
; 0000 052E                 FoultPadetis = Timer19/200;
_0x1A2:
	LDS  R26,_Timer19
	LDS  R27,_Timer19+1
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL __DIVW21U
	ST   Y,R30
	STD  Y+1,R31
; 0000 052F                 led_put_runing_text(FoultPadetis,"cAnt diSchArGE");
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,32
	ST   -Y,R31
	ST   -Y,R30
	RCALL _led_put_runing_text
; 0000 0530                 LcdTaskas[0] = 0;
	LDI  R30,LOW(0)
	STS  _LcdTaskas,R30
; 0000 0531                 LcdTaskas[1] = 0;
	__PUTB1MN _LcdTaskas,1
; 0000 0532                 LcdTaskas[2] = 0;
	__PUTB1MN _LcdTaskas,2
; 0000 0533                 LcdTaskas[3] = 0;
	__PUTB1MN _LcdTaskas,3
; 0000 0534                 }
	ADIW R28,2
_0x1A1:
; 0000 0535             }
; 0000 0536         }
_0x19E:
; 0000 0537         else{
	RJMP _0x1A3
_0x19B:
; 0000 0538         Timer11 = 0;
	LDI  R30,LOW(0)
	STS  _Timer11,R30
	STS  _Timer11+1,R30
; 0000 0539         Timer19 = 0;
	STS  _Timer19,R30
	STS  _Timer19+1,R30
; 0000 053A         }
_0x1A3:
; 0000 053B 
; 0000 053C     // Kai nuspaustas 4 mygtukas, o su visais kitais valdoma
; 0000 053D         if(BUTTON[3]==1){
	__GETB2MN _BUTTON,3
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x1A4
; 0000 053E 
; 0000 053F             // Langu valdymas
; 0000 0540             if(BUTTON[2]==1){
	__GETB2MN _BUTTON,2
	CPI  R26,LOW(0x1)
	BRNE _0x1A5
; 0000 0541                 if(LanguTrigeris==0){
	LDS  R30,_LanguTrigeris
	CPI  R30,0
	BRNE _0x1A6
; 0000 0542                 LanguTrigeris = 1;
	LDI  R30,LOW(1)
	STS  _LanguTrigeris,R30
; 0000 0543                 LangoAdresas++;
	INC  R12
; 0000 0544                     if(LangoAdresas>4){
	LDI  R30,LOW(4)
	CP   R30,R12
	BRSH _0x1A7
; 0000 0545                     LangoAdresas = 0;
	CLR  R12
; 0000 0546                     }
; 0000 0547                 }
_0x1A7:
; 0000 0548             }
_0x1A6:
; 0000 0549             else{
	RJMP _0x1A8
_0x1A5:
; 0000 054A             LanguTrigeris = 0;
	LDI  R30,LOW(0)
	STS  _LanguTrigeris,R30
; 0000 054B             }
_0x1A8:
; 0000 054C 
; 0000 054D             // Paskutinio iskrovimo langas
; 0000 054E             if(LangoAdresas==0){
	TST  R12
	BREQ PC+3
	JMP _0x1A9
; 0000 054F                 if(UPS_STATE==2){
	LDI  R30,LOW(2)
	CP   R30,R6
	BREQ PC+3
	JMP _0x1AA
; 0000 0550                     if(Timer9>=10){
	LDS  R26,_Timer9
	LDS  R27,_Timer9+1
	SBIW R26,10
	BRSH PC+3
	JMP _0x1AB
; 0000 0551                     LcdText[0] = NumToIndex(Timer9/10);
	LDS  R26,_Timer9
	LDS  R27,_Timer9+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	STS  _LcdText,R30
; 0000 0552                     LcdText[1] = NumToIndex(Timer9 - (Timer9/10)*10);
	LDS  R26,_Timer9
	LDS  R27,_Timer9+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	LDS  R26,_Timer9
	LDS  R27,_Timer9+1
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	__PUTB1MN _LcdText,1
; 0000 0553                     LcdText[2] = NumToIndex(Timer8/10);
	LDS  R26,_Timer8
	LDS  R27,_Timer8+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,2
; 0000 0554                     LcdText[3] = NumToIndex(Timer8 - (Timer8/10)*10);
	LDS  R26,_Timer8
	LDS  R27,_Timer8+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	LDS  R26,_Timer8
	LDS  R27,_Timer8+1
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	__PUTB1MN _LcdText,3
; 0000 0555 
; 0000 0556                     LcdTaskas[0] = 0;
	LDI  R30,LOW(0)
	STS  _LcdTaskas,R30
; 0000 0557                     LcdTaskas[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,1
; 0000 0558                     LcdTaskas[2] = 0;
	RJMP _0x21B
; 0000 0559                     LcdTaskas[3] = 0;
; 0000 055A                     }
; 0000 055B                     else if(Timer9==0){
_0x1AB:
	LDS  R30,_Timer9
	LDS  R31,_Timer9+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x1AD
; 0000 055C                     LcdText[0] = NumToIndex(Timer8/10);
	LDS  R26,_Timer8
	LDS  R27,_Timer8+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	STS  _LcdText,R30
; 0000 055D                     LcdText[1] = NumToIndex(Timer8 - (Timer8/10)*10);
	LDS  R26,_Timer8
	LDS  R27,_Timer8+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	LDS  R26,_Timer8
	LDS  R27,_Timer8+1
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	__PUTB1MN _LcdText,1
; 0000 055E                     LcdText[2] = NumToIndex(Timer7/10);
	LDS  R26,_Timer7
	LDS  R27,_Timer7+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,2
; 0000 055F                     LcdText[3] = NumToIndex(Timer7 - (Timer7/10)*10);
	LDS  R26,_Timer7
	LDS  R27,_Timer7+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	LDS  R26,_Timer7
	LDS  R27,_Timer7+1
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	__PUTB1MN _LcdText,3
; 0000 0560 
; 0000 0561                     LcdTaskas[0] = 0;
	LDI  R30,LOW(0)
	STS  _LcdTaskas,R30
; 0000 0562                         if(Timer24<=300){
	LDS  R26,_Timer24
	LDS  R27,_Timer24+1
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRSH _0x1AE
; 0000 0563                         LcdTaskas[1] = 1;
	LDI  R30,LOW(1)
	RJMP _0x21C
; 0000 0564                         }
; 0000 0565                         else{
_0x1AE:
; 0000 0566                         LcdTaskas[1] = 0;
	LDI  R30,LOW(0)
_0x21C:
	__PUTB1MN _LcdTaskas,1
; 0000 0567                         }
; 0000 0568                     LcdTaskas[2] = 0;
	RJMP _0x21B
; 0000 0569                     LcdTaskas[3] = 0;
; 0000 056A                     }
; 0000 056B                     else if((Timer9>=1)&&(Timer9<=9)){
_0x1AD:
	LDS  R26,_Timer9
	LDS  R27,_Timer9+1
	SBIW R26,1
	BRLO _0x1B2
	LDS  R26,_Timer9
	LDS  R27,_Timer9+1
	SBIW R26,10
	BRLO _0x1B3
_0x1B2:
	RJMP _0x1B1
_0x1B3:
; 0000 056C                     LcdText[0] = NumToIndex(Timer9 - (Timer9/10)*10);
	LDS  R26,_Timer9
	LDS  R27,_Timer9+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	LDS  R26,_Timer9
	LDS  R27,_Timer9+1
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	STS  _LcdText,R30
; 0000 056D                     LcdText[1] = NumToIndex(Timer8/10);
	LDS  R26,_Timer8
	LDS  R27,_Timer8+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,1
; 0000 056E                     LcdText[2] = NumToIndex(Timer8 - (Timer8/10)*10);
	LDS  R26,_Timer8
	LDS  R27,_Timer8+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	LDS  R26,_Timer8
	LDS  R27,_Timer8+1
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	__PUTB1MN _LcdText,2
; 0000 056F                     LcdText[3] = NumToIndex(Timer7/10);
	LDS  R26,_Timer7
	LDS  R27,_Timer7+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,3
; 0000 0570 
; 0000 0571                     LcdTaskas[0] = 1;
	LDI  R30,LOW(1)
	STS  _LcdTaskas,R30
; 0000 0572                     LcdTaskas[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _LcdTaskas,1
; 0000 0573                         if(Timer24<=300){
	LDS  R26,_Timer24
	LDS  R27,_Timer24+1
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRSH _0x1B4
; 0000 0574                         LcdTaskas[2] = 1;
	LDI  R30,LOW(1)
	RJMP _0x21D
; 0000 0575                         }
; 0000 0576                         else{
_0x1B4:
; 0000 0577                         LcdTaskas[2] = 0;
_0x21B:
	LDI  R30,LOW(0)
_0x21D:
	__PUTB1MN _LcdTaskas,2
; 0000 0578                         }
; 0000 0579                     LcdTaskas[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _LcdTaskas,3
; 0000 057A                     }
; 0000 057B                 }
_0x1B1:
; 0000 057C                 else{
	RJMP _0x1B6
_0x1AA:
; 0000 057D                 LcdText[0] = NumToIndex(Timer5/10);
	LDI  R26,LOW(_Timer5)
	LDI  R27,HIGH(_Timer5)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	STS  _LcdText,R30
; 0000 057E                 LcdText[1] = NumToIndex(Timer5 - (Timer5/10)*10);
	LDI  R26,LOW(_Timer5)
	LDI  R27,HIGH(_Timer5)
	CALL __EEPROMRDW
	MOVW R22,R30
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	__PUTB1MN _LcdText,1
; 0000 057F                 LcdText[2] = NumToIndex(Timer4/10);
	LDI  R26,LOW(_Timer4)
	LDI  R27,HIGH(_Timer4)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,2
; 0000 0580                 LcdText[3] = NumToIndex(Timer4 - (Timer4/10)*10);
	LDI  R26,LOW(_Timer4)
	LDI  R27,HIGH(_Timer4)
	CALL __EEPROMRDW
	MOVW R22,R30
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	__PUTB1MN _LcdText,3
; 0000 0581 
; 0000 0582                 LcdTaskas[0] = 0;
	LDI  R30,LOW(0)
	STS  _LcdTaskas,R30
; 0000 0583                 LcdTaskas[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,1
; 0000 0584                 LcdTaskas[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _LcdTaskas,2
; 0000 0585                 LcdTaskas[3] = 0;
	__PUTB1MN _LcdTaskas,3
; 0000 0586                 }
_0x1B6:
; 0000 0587             }
; 0000 0588 
; 0000 0589             // Dabartine itampa
; 0000 058A             if(LangoAdresas==1){
_0x1A9:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ PC+3
	JMP _0x1B7
; 0000 058B             char Padetis;
; 0000 058C             static unsigned int Timer26;
; 0000 058D                 if(Timer26<=1500){
	SBIW R28,1
;	Padetis -> Y+0
	LDS  R26,_Timer26_S000000B003
	LDS  R27,_Timer26_S000000B003+1
	CPI  R26,LOW(0x5DD)
	LDI  R30,HIGH(0x5DD)
	CPC  R27,R30
	BRSH _0x1B8
; 0000 058E                 Timer26++;
	LDI  R26,LOW(_Timer26_S000000B003)
	LDI  R27,HIGH(_Timer26_S000000B003)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 058F                 }
; 0000 0590             Padetis = Timer26/300;
_0x1B8:
	LDS  R26,_Timer26_S000000B003
	LDS  R27,_Timer26_S000000B003+1
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL __DIVW21U
	ST   Y,R30
; 0000 0591 
; 0000 0592             LcdTaskas[0] = 0;
	LDI  R30,LOW(0)
	STS  _LcdTaskas,R30
; 0000 0593             LcdTaskas[1] = 0;
	__PUTB1MN _LcdTaskas,1
; 0000 0594             LcdTaskas[2] = 0;
	__PUTB1MN _LcdTaskas,2
; 0000 0595             LcdTaskas[3] = 0;
	__PUTB1MN _LcdTaskas,3
; 0000 0596                 if(Padetis==1){
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x1B9
; 0000 0597                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 0598                 LcdText[1] = ' ';
	__PUTB1MN _LcdText,1
; 0000 0599                 LcdText[2] = ' ';
	__PUTB1MN _LcdText,2
; 0000 059A                 LcdText[3] = 'U';
	LDI  R30,LOW(85)
	RJMP _0x21E
; 0000 059B                 }
; 0000 059C                 else if(Padetis==2){
_0x1B9:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x1BB
; 0000 059D                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 059E                 LcdText[1] = ' ';
	__PUTB1MN _LcdText,1
; 0000 059F                 LcdText[2] = 'U';
	LDI  R30,LOW(85)
	__PUTB1MN _LcdText,2
; 0000 05A0                 LcdText[3] = '=';
	LDI  R30,LOW(61)
	RJMP _0x21E
; 0000 05A1                 }
; 0000 05A2                 else if(Padetis==3){
_0x1BB:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x1BD
; 0000 05A3                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 05A4                 LcdText[1] = 'U';
	LDI  R30,LOW(85)
	__PUTB1MN _LcdText,1
; 0000 05A5                 LcdText[2] = '=';
	LDI  R30,LOW(61)
	__PUTB1MN _LcdText,2
; 0000 05A6                 LcdText[3] = NumToIndex( BATTERY_VOLTAGE/100 );
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x21E
; 0000 05A7                 }
; 0000 05A8                 else if(Padetis==4){
_0x1BD:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x1BF
; 0000 05A9                 LcdText[0] = 'U';
	LDI  R30,LOW(85)
	STS  _LcdText,R30
; 0000 05AA                 LcdText[1] = '=';
	LDI  R30,LOW(61)
	__PUTB1MN _LcdText,1
; 0000 05AB                 LcdText[2] = NumToIndex( BATTERY_VOLTAGE/100 );
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,2
; 0000 05AC                 LcdText[3] = NumToIndex( (BATTERY_VOLTAGE-(BATTERY_VOLTAGE/100)*100)/10);
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12U
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,3
; 0000 05AD                 LcdTaskas[3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,3
; 0000 05AE                 }
; 0000 05AF                 else if(Padetis==5){
	RJMP _0x1C0
_0x1BF:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BREQ PC+3
	JMP _0x1C1
; 0000 05B0                 LcdText[0] = '=';
	LDI  R30,LOW(61)
	STS  _LcdText,R30
; 0000 05B1                 LcdText[1] = NumToIndex( BATTERY_VOLTAGE/100 );
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,1
; 0000 05B2                 LcdText[2] = NumToIndex( (BATTERY_VOLTAGE-(BATTERY_VOLTAGE/100)*100)/10);
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12U
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,2
; 0000 05B3                 LcdText[3] = NumToIndex(  BATTERY_VOLTAGE-(BATTERY_VOLTAGE/10)*10);
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	LDS  R26,_BATTERY_VOLTAGE
	LDS  R27,_BATTERY_VOLTAGE+1
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	__PUTB1MN _LcdText,3
; 0000 05B4                 LcdTaskas[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,2
; 0000 05B5                 }
; 0000 05B6                 else{
	RJMP _0x1C2
_0x1C1:
; 0000 05B7                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 05B8                 LcdText[1] = ' ';
	__PUTB1MN _LcdText,1
; 0000 05B9                 LcdText[2] = ' ';
	__PUTB1MN _LcdText,2
; 0000 05BA                 LcdText[3] = ' ';
_0x21E:
	__PUTB1MN _LcdText,3
; 0000 05BB                 }
_0x1C2:
_0x1C0:
; 0000 05BC             }
	ADIW R28,1
; 0000 05BD             else{
	RJMP _0x1C3
_0x1B7:
; 0000 05BE             Timer26 = 0;
	LDI  R30,LOW(0)
	STS  _Timer26_S000000B003,R30
	STS  _Timer26_S000000B003+1,R30
; 0000 05BF             }
_0x1C3:
; 0000 05C0 
; 0000 05C1             // Minimali itampa
; 0000 05C2             if(LangoAdresas==2){
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0x1C4
; 0000 05C3             char Padetis;
; 0000 05C4             static unsigned int Timer27;
; 0000 05C5                 if(Timer27<=3300){
	SBIW R28,1
;	Padetis -> Y+0
	LDS  R26,_Timer27_S000000B003
	LDS  R27,_Timer27_S000000B003+1
	CPI  R26,LOW(0xCE5)
	LDI  R30,HIGH(0xCE5)
	CPC  R27,R30
	BRSH _0x1C5
; 0000 05C6                 Timer27++;
	LDI  R26,LOW(_Timer27_S000000B003)
	LDI  R27,HIGH(_Timer27_S000000B003)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 05C7                 }
; 0000 05C8             Padetis = Timer27/300;
_0x1C5:
	LDS  R26,_Timer27_S000000B003
	LDS  R27,_Timer27_S000000B003+1
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL __DIVW21U
	ST   Y,R30
; 0000 05C9 
; 0000 05CA             LcdTaskas[0] = 0;
	LDI  R30,LOW(0)
	STS  _LcdTaskas,R30
; 0000 05CB             LcdTaskas[1] = 0;
	__PUTB1MN _LcdTaskas,1
; 0000 05CC             LcdTaskas[2] = 0;
	__PUTB1MN _LcdTaskas,2
; 0000 05CD             LcdTaskas[3] = 0;
	__PUTB1MN _LcdTaskas,3
; 0000 05CE                 if(Padetis==1){
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x1C6
; 0000 05CF                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 05D0                 LcdText[1] = ' ';
	__PUTB1MN _LcdText,1
; 0000 05D1                 LcdText[2] = ' ';
	__PUTB1MN _LcdText,2
; 0000 05D2                 LcdText[3] = 'F';
	LDI  R30,LOW(70)
	RJMP _0x21F
; 0000 05D3                 }
; 0000 05D4                 else if(Padetis==2){
_0x1C6:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x1C8
; 0000 05D5                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 05D6                 LcdText[1] = ' ';
	__PUTB1MN _LcdText,1
; 0000 05D7                 LcdText[2] = 'F';
	LDI  R30,LOW(70)
	__PUTB1MN _LcdText,2
; 0000 05D8                 LcdText[3] = 'L';
	LDI  R30,LOW(76)
	RJMP _0x21F
; 0000 05D9                 }
; 0000 05DA                 else if(Padetis==3){
_0x1C8:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x1CA
; 0000 05DB                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 05DC                 LcdText[1] = 'F';
	LDI  R30,LOW(70)
	__PUTB1MN _LcdText,1
; 0000 05DD                 LcdText[2] = 'L';
	LDI  R30,LOW(76)
	__PUTB1MN _LcdText,2
; 0000 05DE                 LcdText[3] = 'o';
	LDI  R30,LOW(111)
	RJMP _0x21F
; 0000 05DF                 }
; 0000 05E0                 else if(Padetis==4){
_0x1CA:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x1CC
; 0000 05E1                 LcdText[0] = 'F';
	LDI  R30,LOW(70)
	STS  _LcdText,R30
; 0000 05E2                 LcdText[1] = 'L';
	LDI  R30,LOW(76)
	__PUTB1MN _LcdText,1
; 0000 05E3                 LcdText[2] = 'o';
	LDI  R30,LOW(111)
	__PUTB1MN _LcdText,2
; 0000 05E4                 LcdText[3] = 'o';
	RJMP _0x21F
; 0000 05E5                 }
; 0000 05E6                 else if(Padetis==5){
_0x1CC:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x1CE
; 0000 05E7                 LcdText[0] = 'L';
	LDI  R30,LOW(76)
	STS  _LcdText,R30
; 0000 05E8                 LcdText[1] = 'o';
	LDI  R30,LOW(111)
	__PUTB1MN _LcdText,1
; 0000 05E9                 LcdText[2] = 'o';
	__PUTB1MN _LcdText,2
; 0000 05EA                 LcdText[3] = 'r';
	LDI  R30,LOW(114)
	RJMP _0x21F
; 0000 05EB                 }
; 0000 05EC                 else if(Padetis==6){
_0x1CE:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x1D0
; 0000 05ED                 LcdText[0] = 'o';
	LDI  R30,LOW(111)
	STS  _LcdText,R30
; 0000 05EE                 LcdText[1] = 'o';
	__PUTB1MN _LcdText,1
; 0000 05EF                 LcdText[2] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _LcdText,2
; 0000 05F0                 LcdText[3] = '_';
	LDI  R30,LOW(95)
	RJMP _0x21F
; 0000 05F1                 }
; 0000 05F2                 else if(Padetis==7){
_0x1D0:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x1D2
; 0000 05F3                 LcdText[0] = 'o';
	LDI  R30,LOW(111)
	STS  _LcdText,R30
; 0000 05F4                 LcdText[1] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _LcdText,1
; 0000 05F5                 LcdText[2] = '_';
	LDI  R30,LOW(95)
	__PUTB1MN _LcdText,2
; 0000 05F6                 LcdText[3] = 'U';
	LDI  R30,LOW(85)
	RJMP _0x21F
; 0000 05F7                 }
; 0000 05F8                 else if(Padetis==8){
_0x1D2:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x1D4
; 0000 05F9                 LcdText[0] = 'r';
	LDI  R30,LOW(114)
	STS  _LcdText,R30
; 0000 05FA                 LcdText[1] = '_';
	LDI  R30,LOW(95)
	__PUTB1MN _LcdText,1
; 0000 05FB                 LcdText[2] = 'U';
	LDI  R30,LOW(85)
	__PUTB1MN _LcdText,2
; 0000 05FC                 LcdText[3] = '=';
	LDI  R30,LOW(61)
	RJMP _0x21F
; 0000 05FD                 }
; 0000 05FE                 else if(Padetis==9){
_0x1D4:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x1D6
; 0000 05FF                 LcdText[0] = '_';
	LDI  R30,LOW(95)
	STS  _LcdText,R30
; 0000 0600                 LcdText[1] = 'U';
	LDI  R30,LOW(85)
	__PUTB1MN _LcdText,1
; 0000 0601                 LcdText[2] = '=';
	LDI  R30,LOW(61)
	__PUTB1MN _LcdText,2
; 0000 0602                 LcdText[3] = NumToIndex( MIN_BATTERY_VOLTAGE/100 );
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x21F
; 0000 0603                 }
; 0000 0604                 else if(Padetis==10){
_0x1D6:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x1D8
; 0000 0605                 LcdText[0] = 'U';
	LDI  R30,LOW(85)
	STS  _LcdText,R30
; 0000 0606                 LcdText[1] = '=';
	LDI  R30,LOW(61)
	__PUTB1MN _LcdText,1
; 0000 0607                 LcdText[2] = NumToIndex( MIN_BATTERY_VOLTAGE/100 );
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,2
; 0000 0608                 LcdText[3] = NumToIndex( (MIN_BATTERY_VOLTAGE-(MIN_BATTERY_VOLTAGE/100)*100)/10);
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R22,R30
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,3
; 0000 0609                 LcdTaskas[3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,3
; 0000 060A                 }
; 0000 060B                 else if(Padetis==11){
	RJMP _0x1D9
_0x1D8:
	LD   R26,Y
	CPI  R26,LOW(0xB)
	BREQ PC+3
	JMP _0x1DA
; 0000 060C                 LcdText[0] = '=';
	LDI  R30,LOW(61)
	STS  _LcdText,R30
; 0000 060D                 LcdText[1] = NumToIndex( MIN_BATTERY_VOLTAGE/100 );
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,1
; 0000 060E                 LcdText[2] = NumToIndex( (MIN_BATTERY_VOLTAGE-(MIN_BATTERY_VOLTAGE/100)*100)/10);
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R22,R30
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,2
; 0000 060F                 LcdText[3] = NumToIndex(  MIN_BATTERY_VOLTAGE-(MIN_BATTERY_VOLTAGE/10)*10);
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R22,R30
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	__PUTB1MN _LcdText,3
; 0000 0610                 LcdTaskas[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,2
; 0000 0611                 }
; 0000 0612                 else{
	RJMP _0x1DB
_0x1DA:
; 0000 0613                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 0614                 LcdText[1] = ' ';
	__PUTB1MN _LcdText,1
; 0000 0615                 LcdText[2] = ' ';
	__PUTB1MN _LcdText,2
; 0000 0616                 LcdText[3] = ' ';
_0x21F:
	__PUTB1MN _LcdText,3
; 0000 0617                 }
_0x1DB:
_0x1D9:
; 0000 0618 
; 0000 0619                 if((BUTTON[0]==0)&&(BUTTON[1]==1)&&(BUTTON[2]==0)){
	LDS  R26,_BUTTON
	CPI  R26,LOW(0x0)
	BRNE _0x1DD
	__GETB2MN _BUTTON,1
	CPI  R26,LOW(0x1)
	BRNE _0x1DD
	__GETB2MN _BUTTON,2
	CPI  R26,LOW(0x0)
	BREQ _0x1DE
_0x1DD:
	RJMP _0x1DC
_0x1DE:
; 0000 061A                     if(ItamposTrigeris1==0){
	LDS  R30,_ItamposTrigeris1
	CPI  R30,0
	BRNE _0x1DF
; 0000 061B                     MIN_BATTERY_VOLTAGE++;
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 061C                     ItamposTrigeris1 = 1;
	LDI  R30,LOW(1)
	STS  _ItamposTrigeris1,R30
; 0000 061D                     }
; 0000 061E                 }
_0x1DF:
; 0000 061F                 else if((BUTTON[0]==1)&&(BUTTON[1]==0)&&(BUTTON[2]==0)){
	RJMP _0x1E0
_0x1DC:
	LDS  R26,_BUTTON
	CPI  R26,LOW(0x1)
	BRNE _0x1E2
	__GETB2MN _BUTTON,1
	CPI  R26,LOW(0x0)
	BRNE _0x1E2
	__GETB2MN _BUTTON,2
	CPI  R26,LOW(0x0)
	BREQ _0x1E3
_0x1E2:
	RJMP _0x1E1
_0x1E3:
; 0000 0620                     if(ItamposTrigeris1==0){
	LDS  R30,_ItamposTrigeris1
	CPI  R30,0
	BRNE _0x1E4
; 0000 0621                     MIN_BATTERY_VOLTAGE--;
	LDI  R26,LOW(_MIN_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MIN_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
; 0000 0622                     ItamposTrigeris1 = 1;
	LDI  R30,LOW(1)
	STS  _ItamposTrigeris1,R30
; 0000 0623                     }
; 0000 0624                 }
_0x1E4:
; 0000 0625                 else{
	RJMP _0x1E5
_0x1E1:
; 0000 0626                 ItamposTrigeris1 = 0;
	LDI  R30,LOW(0)
	STS  _ItamposTrigeris1,R30
; 0000 0627                 }
_0x1E5:
_0x1E0:
; 0000 0628             }
	ADIW R28,1
; 0000 0629             else{
	RJMP _0x1E6
_0x1C4:
; 0000 062A             Timer27 = 0;
	LDI  R30,LOW(0)
	STS  _Timer27_S000000B003,R30
	STS  _Timer27_S000000B003+1,R30
; 0000 062B             }
_0x1E6:
; 0000 062C 
; 0000 062D             // Maksimali itampa
; 0000 062E             if(LangoAdresas==3){
	LDI  R30,LOW(3)
	CP   R30,R12
	BREQ PC+3
	JMP _0x1E7
; 0000 062F             char Padetis;
; 0000 0630             static unsigned int Timer28;
; 0000 0631                 if(Timer28<=2700){
	SBIW R28,1
;	Padetis -> Y+0
	LDS  R26,_Timer28_S000000B003
	LDS  R27,_Timer28_S000000B003+1
	CPI  R26,LOW(0xA8D)
	LDI  R30,HIGH(0xA8D)
	CPC  R27,R30
	BRSH _0x1E8
; 0000 0632                 Timer28++;
	LDI  R26,LOW(_Timer28_S000000B003)
	LDI  R27,HIGH(_Timer28_S000000B003)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0633                 }
; 0000 0634             Padetis = Timer28/300;
_0x1E8:
	LDS  R26,_Timer28_S000000B003
	LDS  R27,_Timer28_S000000B003+1
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL __DIVW21U
	ST   Y,R30
; 0000 0635 
; 0000 0636             LcdTaskas[0] = 0;
	LDI  R30,LOW(0)
	STS  _LcdTaskas,R30
; 0000 0637             LcdTaskas[1] = 0;
	__PUTB1MN _LcdTaskas,1
; 0000 0638             LcdTaskas[2] = 0;
	__PUTB1MN _LcdTaskas,2
; 0000 0639             LcdTaskas[3] = 0;
	__PUTB1MN _LcdTaskas,3
; 0000 063A                 if(Padetis==1){
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x1E9
; 0000 063B                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 063C                 LcdText[1] = ' ';
	__PUTB1MN _LcdText,1
; 0000 063D                 LcdText[2] = ' ';
	__PUTB1MN _LcdText,2
; 0000 063E                 LcdText[3] = 't';
	LDI  R30,LOW(116)
	RJMP _0x220
; 0000 063F                 }
; 0000 0640                 else if(Padetis==2){
_0x1E9:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x1EB
; 0000 0641                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 0642                 LcdText[1] = ' ';
	__PUTB1MN _LcdText,1
; 0000 0643                 LcdText[2] = 't';
	LDI  R30,LOW(116)
	__PUTB1MN _LcdText,2
; 0000 0644                 LcdText[3] = 'o';
	LDI  R30,LOW(111)
	RJMP _0x220
; 0000 0645                 }
; 0000 0646                 else if(Padetis==3){
_0x1EB:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x1ED
; 0000 0647                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 0648                 LcdText[1] = 't';
	LDI  R30,LOW(116)
	__PUTB1MN _LcdText,1
; 0000 0649                 LcdText[2] = 'o';
	LDI  R30,LOW(111)
	__PUTB1MN _LcdText,2
; 0000 064A                 LcdText[3] = 'P';
	LDI  R30,LOW(80)
	RJMP _0x220
; 0000 064B                 }
; 0000 064C                 else if(Padetis==4){
_0x1ED:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x1EF
; 0000 064D                 LcdText[0] = 't';
	LDI  R30,LOW(116)
	STS  _LcdText,R30
; 0000 064E                 LcdText[1] = 'o';
	LDI  R30,LOW(111)
	__PUTB1MN _LcdText,1
; 0000 064F                 LcdText[2] = 'P';
	LDI  R30,LOW(80)
	__PUTB1MN _LcdText,2
; 0000 0650                 LcdText[3] = '_';
	LDI  R30,LOW(95)
	RJMP _0x220
; 0000 0651                 }
; 0000 0652                 else if(Padetis==5){
_0x1EF:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x1F1
; 0000 0653                 LcdText[0] = 'o';
	LDI  R30,LOW(111)
	STS  _LcdText,R30
; 0000 0654                 LcdText[1] = 'P';
	LDI  R30,LOW(80)
	__PUTB1MN _LcdText,1
; 0000 0655                 LcdText[2] = '_';
	LDI  R30,LOW(95)
	__PUTB1MN _LcdText,2
; 0000 0656                 LcdText[3] = 'U';
	LDI  R30,LOW(85)
	RJMP _0x220
; 0000 0657                 }
; 0000 0658                 else if(Padetis==6){
_0x1F1:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x1F3
; 0000 0659                 LcdText[0] = 'P';
	LDI  R30,LOW(80)
	STS  _LcdText,R30
; 0000 065A                 LcdText[1] = '_';
	LDI  R30,LOW(95)
	__PUTB1MN _LcdText,1
; 0000 065B                 LcdText[2] = 'U';
	LDI  R30,LOW(85)
	__PUTB1MN _LcdText,2
; 0000 065C                 LcdText[3] = '=';
	LDI  R30,LOW(61)
	RJMP _0x220
; 0000 065D                 }
; 0000 065E                 else if(Padetis==7){
_0x1F3:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x1F5
; 0000 065F                 LcdText[0] = '_';
	LDI  R30,LOW(95)
	STS  _LcdText,R30
; 0000 0660                 LcdText[1] = 'U';
	LDI  R30,LOW(85)
	__PUTB1MN _LcdText,1
; 0000 0661                 LcdText[2] = '=';
	LDI  R30,LOW(61)
	__PUTB1MN _LcdText,2
; 0000 0662                 LcdText[3] = NumToIndex( MAX_BATTERY_VOLTAGE/100 );
	LDI  R26,LOW(_MAX_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MAX_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	RJMP _0x220
; 0000 0663                 }
; 0000 0664                 else if(Padetis==8){
_0x1F5:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x1F7
; 0000 0665                 LcdText[0] = 'U';
	LDI  R30,LOW(85)
	STS  _LcdText,R30
; 0000 0666                 LcdText[1] = '=';
	LDI  R30,LOW(61)
	__PUTB1MN _LcdText,1
; 0000 0667                 LcdText[2] = NumToIndex( MAX_BATTERY_VOLTAGE/100 );
	LDI  R26,LOW(_MAX_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MAX_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,2
; 0000 0668                 LcdText[3] = NumToIndex( (MAX_BATTERY_VOLTAGE-(MAX_BATTERY_VOLTAGE/100)*100)/10);
	LDI  R26,LOW(_MAX_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MAX_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R22,R30
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,3
; 0000 0669                 LcdTaskas[3] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,3
; 0000 066A                 }
; 0000 066B                 else if(Padetis==9){
	RJMP _0x1F8
_0x1F7:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BREQ PC+3
	JMP _0x1F9
; 0000 066C                 LcdText[0] = '=';
	LDI  R30,LOW(61)
	STS  _LcdText,R30
; 0000 066D                 LcdText[1] = NumToIndex( MAX_BATTERY_VOLTAGE/100 );
	LDI  R26,LOW(_MAX_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MAX_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,1
; 0000 066E                 LcdText[2] = NumToIndex( (MAX_BATTERY_VOLTAGE-(MAX_BATTERY_VOLTAGE/100)*100)/10);
	LDI  R26,LOW(_MAX_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MAX_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R22,R30
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	ST   -Y,R30
	CALL _NumToIndex
	__PUTB1MN _LcdText,2
; 0000 066F                 LcdText[3] = NumToIndex(  MAX_BATTERY_VOLTAGE-(MAX_BATTERY_VOLTAGE/10)*10);
	LDI  R26,LOW(_MAX_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MAX_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	MOVW R22,R30
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	CALL _NumToIndex
	__PUTB1MN _LcdText,3
; 0000 0670                 LcdTaskas[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _LcdTaskas,2
; 0000 0671                 }
; 0000 0672                 else{
	RJMP _0x1FA
_0x1F9:
; 0000 0673                 LcdText[0] = ' ';
	LDI  R30,LOW(32)
	STS  _LcdText,R30
; 0000 0674                 LcdText[1] = ' ';
	__PUTB1MN _LcdText,1
; 0000 0675                 LcdText[2] = ' ';
	__PUTB1MN _LcdText,2
; 0000 0676                 LcdText[3] = ' ';
_0x220:
	__PUTB1MN _LcdText,3
; 0000 0677                 }
_0x1FA:
_0x1F8:
; 0000 0678 
; 0000 0679                 if((BUTTON[0]==0)&&(BUTTON[1]==1)&&(BUTTON[2]==0)){
	LDS  R26,_BUTTON
	CPI  R26,LOW(0x0)
	BRNE _0x1FC
	__GETB2MN _BUTTON,1
	CPI  R26,LOW(0x1)
	BRNE _0x1FC
	__GETB2MN _BUTTON,2
	CPI  R26,LOW(0x0)
	BREQ _0x1FD
_0x1FC:
	RJMP _0x1FB
_0x1FD:
; 0000 067A                     if(ItamposTrigeris2==0){
	LDS  R30,_ItamposTrigeris2
	CPI  R30,0
	BRNE _0x1FE
; 0000 067B                     MAX_BATTERY_VOLTAGE++;
	LDI  R26,LOW(_MAX_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MAX_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 067C                     ItamposTrigeris2 = 1;
	LDI  R30,LOW(1)
	STS  _ItamposTrigeris2,R30
; 0000 067D                     }
; 0000 067E                 }
_0x1FE:
; 0000 067F                 else if((BUTTON[0]==1)&&(BUTTON[1]==0)&&(BUTTON[2]==0)){
	RJMP _0x1FF
_0x1FB:
	LDS  R26,_BUTTON
	CPI  R26,LOW(0x1)
	BRNE _0x201
	__GETB2MN _BUTTON,1
	CPI  R26,LOW(0x0)
	BRNE _0x201
	__GETB2MN _BUTTON,2
	CPI  R26,LOW(0x0)
	BREQ _0x202
_0x201:
	RJMP _0x200
_0x202:
; 0000 0680                     if(ItamposTrigeris2==0){
	LDS  R30,_ItamposTrigeris2
	CPI  R30,0
	BRNE _0x203
; 0000 0681                     MAX_BATTERY_VOLTAGE--;
	LDI  R26,LOW(_MAX_BATTERY_VOLTAGE)
	LDI  R27,HIGH(_MAX_BATTERY_VOLTAGE)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
; 0000 0682                     ItamposTrigeris2 = 1;
	LDI  R30,LOW(1)
	STS  _ItamposTrigeris2,R30
; 0000 0683                     }
; 0000 0684                 }
_0x203:
; 0000 0685                 else{
	RJMP _0x204
_0x200:
; 0000 0686                 ItamposTrigeris2 = 0;
	LDI  R30,LOW(0)
	STS  _ItamposTrigeris2,R30
; 0000 0687                 }
_0x204:
_0x1FF:
; 0000 0688             }
	ADIW R28,1
; 0000 0689             else{
	RJMP _0x205
_0x1E7:
; 0000 068A             Timer28 = 0;
	LDI  R30,LOW(0)
	STS  _Timer28_S000000B003,R30
	STS  _Timer28_S000000B003+1,R30
; 0000 068B             }
_0x205:
; 0000 068C         }
; 0000 068D         else{
	RJMP _0x206
_0x1A4:
; 0000 068E         LangoAdresas = 0;
	CLR  R12
; 0000 068F         }
_0x206:
; 0000 0690 
; 0000 0691     // Kai nuspaustas tik 1 ir 4 mygtukas:
; 0000 0692     // Krovimo nutraukimo funkcija:
; 0000 0693         if((BUTTON[0]==1)&&(BUTTON[1]==0)&&(BUTTON[2]==0)&&(BUTTON[3]==1)){
	LDS  R26,_BUTTON
	CPI  R26,LOW(0x1)
	BRNE _0x208
	__GETB2MN _BUTTON,1
	CPI  R26,LOW(0x0)
	BRNE _0x208
	__GETB2MN _BUTTON,2
	CPI  R26,LOW(0x0)
	BRNE _0x208
	__GETB2MN _BUTTON,3
	CPI  R26,LOW(0x1)
	BREQ _0x209
_0x208:
	RJMP _0x207
_0x209:
; 0000 0694         // Charge Off
; 0000 0695         static unsigned int Timer21;
; 0000 0696             if(UPS_STATE==1){
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x20A
; 0000 0697             Timer21++;
	LDI  R26,LOW(_Timer21_S000000B002)
	LDI  R27,HIGH(_Timer21_S000000B002)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
; 0000 0698                 if(Timer21>=5000){
	LDS  R26,_Timer21_S000000B002
	LDS  R27,_Timer21_S000000B002+1
	CPI  R26,LOW(0x1388)
	LDI  R30,HIGH(0x1388)
	CPC  R27,R30
	BRLO _0x20B
; 0000 0699                 UPS_STATE = 0;
	CLR  R6
; 0000 069A                 }
; 0000 069B             }
_0x20B:
; 0000 069C             else{
	RJMP _0x20C
_0x20A:
; 0000 069D             Timer21 = 0;
	LDI  R30,LOW(0)
	STS  _Timer21_S000000B002,R30
	STS  _Timer21_S000000B002+1,R30
; 0000 069E             }
_0x20C:
; 0000 069F         }
; 0000 06A0         else{
	RJMP _0x20D
_0x207:
; 0000 06A1         Timer21 = 0;
	LDI  R30,LOW(0)
	STS  _Timer21_S000000B002,R30
	STS  _Timer21_S000000B002+1,R30
; 0000 06A2         }
_0x20D:
; 0000 06A3 
; 0000 06A4 ////////////////////////////////////////////////////////////////////////////////////
; 0000 06A5 
; 0000 06A6 
; 0000 06A7 
; 0000 06A8 
; 0000 06A9 
; 0000 06AA 
; 0000 06AB 
; 0000 06AC 
; 0000 06AD 
; 0000 06AE     RelayOutputs();
	CALL _RelayOutputs
; 0000 06AF     CheckButtons();
	CALL _CheckButtons
; 0000 06B0     UpdateLcd();
	CALL _UpdateLcd
; 0000 06B1 
; 0000 06B2     delay_us(900);
	__DELAY_USW 1800
; 0000 06B3     }
	JMP  _0x150
; 0000 06B4 }
_0x20E:
	RJMP _0x20E

	.CSEG
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
_BUTTON:
	.BYTE 0x4

	.ESEG
_BATTERY_FOULT:
	.BYTE 0x1

	.DSEG
_LcdText:
	.BYTE 0x4
_LcdTaskas:
	.BYTE 0x4
_Timer3:
	.BYTE 0x2

	.ESEG
_Timer4:
	.BYTE 0x2
_Timer5:
	.BYTE 0x2

	.DSEG
_Timer7:
	.BYTE 0x2
_Timer8:
	.BYTE 0x2
_Timer9:
	.BYTE 0x2
_Timer10:
	.BYTE 0x2
_Timer11:
	.BYTE 0x2
_Timer12:
	.BYTE 0x2
_Timer14:
	.BYTE 0x2
_Timer19:
	.BYTE 0x2
_Timer20:
	.BYTE 0x2
_Timer24:
	.BYTE 0x2
_LanguTrigeris:
	.BYTE 0x1
_BATTERY_VOLTAGE:
	.BYTE 0x2
_BATTERY_VOLTAGE_ARCHIVE:
	.BYTE 0x14

	.ESEG
_MAX_BATTERY_VOLTAGE:
	.BYTE 0x2
_MIN_BATTERY_VOLTAGE:
	.BYTE 0x2

	.DSEG
_ItamposTrigeris1:
	.BYTE 0x1
_ItamposTrigeris2:
	.BYTE 0x1
_Timer29_S0000007000:
	.BYTE 0x2
_Timer16:
	.BYTE 0x2

	.ESEG
_Timer17:
	.BYTE 0x2
_Timer18:
	.BYTE 0x2

	.DSEG
_InteruptTimer:
	.BYTE 0x2
_Timer1_S000000B000:
	.BYTE 0x2
_Timer2_S000000B003:
	.BYTE 0x2
_Timer26_S000000B003:
	.BYTE 0x2
_Timer27_S000000B003:
	.BYTE 0x2
_Timer28_S000000B003:
	.BYTE 0x2
_Timer21_S000000B002:
	.BYTE 0x2

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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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
