
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16L
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
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

	#pragma AVRPART ADMIN PART_NAME ATmega16L
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
	.DEF _FAST_ON=R5
	.DEF _SIN_CIKLAS=R4
	.DEF _START=R7
	.DEF _DALIKLIS=R6
	.DEF _DAZNIO_DALIKLIS=R9
	.DEF _UPDATE_LCD=R8
	.DEF _lcd_update_skaitiklis=R10
	.DEF _sek_skaitiklis=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compb_isr
	JMP  _timer1_ovf_isr
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

_0x3:
	.DB  0x0,0x1A,0x35,0x4E,0x67,0x7F,0x95,0xAA
	.DB  0xBD,0xCE,0xDC,0xE8,0xF2,0xF9,0xFD,0xFF
	.DB  0xFD,0xF9,0xF2,0xE8,0xDC,0xCE,0xBD,0xAA
	.DB  0x95,0x7F,0x67,0x4E,0x35,0x1A
_0x4:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x1A,0x35,0x4E
	.DB  0x67,0x7F,0x95,0xAA,0xBD,0xCE,0xDC,0xE8
	.DB  0xF2,0xF9,0xFD,0xFF,0xFD,0xF9,0xF2,0xE8
	.DB  0xDC,0xCE,0xBD,0xAA,0x95,0x7F,0x67,0x4E
	.DB  0x35,0x1A
_0x5:
	.DB  0xDC,0xCE,0xBD,0xAA,0x95,0x7F,0x67,0x4E
	.DB  0x35,0x1A,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x1A,0x35,0x4E,0x67,0x7F,0x95,0xAA
	.DB  0xBD,0xCE,0xDC,0xE8,0xF2,0xF9,0xFD,0xFF
	.DB  0xFD,0xF9,0xF2,0xE8
_0x0:
	.DB  0x2B,0x3E,0x0,0x2D,0x2D,0x3E,0x0,0x2D
	.DB  0x2B,0x0,0x3C,0x2B,0x0,0x3C,0x2D,0x2D
	.DB  0x0,0x2B,0x2D,0x0,0x20,0x20,0x54,0x6F
	.DB  0x70,0x45,0x6E,0x65,0x72,0x67,0x61,0x20
	.DB  0x49,0x47,0x42,0x54,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x54,0x45,0x53,0x54
	.DB  0x45,0x52,0x49,0x53,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x2D,0x3D,0x3D,0x3D,0x53,0x49
	.DB  0x4D,0x55,0x4C,0x49,0x41,0x43,0x49,0x4A
	.DB  0x41,0x3D,0x3D,0x3D,0x2D,0x20,0x0,0x50
	.DB  0x57,0x4D,0x3A,0x0,0x2F,0x32,0x35,0x35
	.DB  0x20,0x20,0x7C,0x20,0x4F,0x4E,0x20,0x20
	.DB  0x7C,0x0,0x44,0x41,0x5A,0x4E,0x49,0x53
	.DB  0x3A,0x0,0x20,0x48,0x7A,0x20,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x0,0x53,0x54,0x45,0x50
	.DB  0x55,0x50,0x20,0x50,0x57,0x4D,0x3A,0x20
	.DB  0x0,0x2F,0x32,0x35,0x35,0x0,0x50,0x57
	.DB  0x4D,0x3A,0x30,0x30,0x30,0x2F,0x32,0x35
	.DB  0x35,0x20,0x20,0x7C,0x20,0x4F,0x46,0x46
	.DB  0x20,0x7C,0x0,0x44,0x41,0x5A,0x4E,0x49
	.DB  0x53,0x3A,0x30,0x30,0x30,0x20,0x48,0x7A
	.DB  0x20,0x2D,0x2D,0x2D,0x2D,0x2D,0x20,0x0
	.DB  0x53,0x54,0x45,0x50,0x55,0x50,0x20,0x50
	.DB  0x57,0x4D,0x3A,0x20,0x30,0x30,0x30,0x2F
	.DB  0x32,0x35,0x35,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x1E
	.DW  _sinusA
	.DW  _0x3*2

	.DW  0x32
	.DW  _sinusB
	.DW  _0x4*2

	.DW  0x3C
	.DW  _sinusC
	.DW  _0x5*2

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
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
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
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2015.07.16
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
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
;
;
;
;unsigned char sinusA[60]={
;0, 26, 53, 78, 103, 127, 149, 170, 189, 206,
;220, 232, 242, 249, 253, 255, 253, 249, 242, 232,
;220, 206, 189, 170, 149, 127, 103, 78, 53, 26,
;0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
;0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
;0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

	.DSEG
;
;unsigned char sinusB[60]={
;0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
;0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
;0, 26, 53, 78, 103, 127, 149, 170, 189, 206,
;220, 232, 242, 249, 253, 255, 253, 249, 242, 232,
;220, 206, 189, 170, 149, 127, 103, 78, 53, 26,
;0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
;
;unsigned char sinusC[60]={
;220, 206, 189, 170, 149, 127, 103, 78, 53, 26,
;0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
;0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
;0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
;0, 26, 53, 78, 103, 127, 149, 170, 189, 206,
;220, 232, 242, 249, 253, 255, 253, 249, 242, 232};
;
;
;
;
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x15 ;PORTC
; 0000 003C #endasm
;#include <lcd.h>
;
;
;
;
;unsigned char NumToIndex(char Num){
; 0000 0042 unsigned char NumToIndex(char Num){

	.CSEG
_NumToIndex:
; 0000 0043     if(Num==0){     return '0';}
;	Num -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x6
	LDI  R30,LOW(48)
	JMP  _0x2020001
; 0000 0044     else if(Num==1){return '1';}
_0x6:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x8
	LDI  R30,LOW(49)
	JMP  _0x2020001
; 0000 0045     else if(Num==2){return '2';}
_0x8:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0xA
	LDI  R30,LOW(50)
	JMP  _0x2020001
; 0000 0046     else if(Num==3){return '3';}
_0xA:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0xC
	LDI  R30,LOW(51)
	JMP  _0x2020001
; 0000 0047     else if(Num==4){return '4';}
_0xC:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xE
	LDI  R30,LOW(52)
	JMP  _0x2020001
; 0000 0048     else if(Num==5){return '5';}
_0xE:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x10
	LDI  R30,LOW(53)
	JMP  _0x2020001
; 0000 0049     else if(Num==6){return '6';}
_0x10:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x12
	LDI  R30,LOW(54)
	JMP  _0x2020001
; 0000 004A     else if(Num==7){return '7';}
_0x12:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x14
	LDI  R30,LOW(55)
	JMP  _0x2020001
; 0000 004B     else if(Num==8){return '8';}
_0x14:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x16
	LDI  R30,LOW(56)
	JMP  _0x2020001
; 0000 004C     else if(Num==9){return '9';}
_0x16:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x18
	LDI  R30,LOW(57)
	JMP  _0x2020001
; 0000 004D     else{           return '-';}
_0x18:
	LDI  R30,LOW(45)
	JMP  _0x2020001
; 0000 004E return 0;
; 0000 004F }
;
;unsigned char lcd_put_number(char Type, char Lenght, char IsSign,
; 0000 0052 
; 0000 0053                     char NumbersAfterDot,
; 0000 0054 
; 0000 0055                     unsigned long int Number0,
; 0000 0056                     signed long int Number1){
_lcd_put_number:
; 0000 0057     if(Lenght>0){
;	Type -> Y+11
;	Lenght -> Y+10
;	IsSign -> Y+9
;	NumbersAfterDot -> Y+8
;	Number0 -> Y+4
;	Number1 -> Y+0
	LDD  R26,Y+10
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x1A
; 0000 0058     unsigned long int k = 1;
; 0000 0059     unsigned char i;
; 0000 005A         for(i=0;i<Lenght-1;i++) k = k*10;
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
_0x1C:
	LDD  R30,Y+15
	LDI  R31,0
	SBIW R30,1
	LD   R26,Y
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x1D
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x1C
_0x1D:
; 0000 005C if(Type==0){
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x1E
; 0000 005D         unsigned long int a;
; 0000 005E         unsigned char b;
; 0000 005F         a = Number0;
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
; 0000 0060 
; 0000 0061             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x1F
; 0000 0062             lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0063             }
; 0000 0064 
; 0000 0065             if(a<0){
_0x1F:
	CALL SUBOPT_0x3
; 0000 0066             a = a*(-1);
; 0000 0067             }
; 0000 0068 
; 0000 0069             if(k*10<a){
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRSH _0x21
; 0000 006A             a = k*10 - 1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
; 0000 006B             }
; 0000 006C 
; 0000 006D             for(i=0;i<Lenght;i++){
_0x21:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x23:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0x24
; 0000 006E                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x25
; 0000 006F                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0x7
	BRNE _0x26
; 0000 0070                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0071                     }
; 0000 0072                 }
_0x26:
; 0000 0073             b = a/k;
_0x25:
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0074             lcd_putchar( NumToIndex( b ) );
; 0000 0075             a = a - b*k;
; 0000 0076             k = k/10;
; 0000 0077             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x23
_0x24:
; 0000 0078         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2020002
; 0000 0079         }
; 0000 007A 
; 0000 007B         else if(Type==1){
_0x1E:
	LDD  R26,Y+16
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x28
; 0000 007C         signed long int a;
; 0000 007D         unsigned char b;
; 0000 007E         a = Number1;
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
; 0000 007F 
; 0000 0080             if(IsSign==1){
	LDD  R26,Y+19
	CPI  R26,LOW(0x1)
	BRNE _0x29
; 0000 0081                 if(a>=0){
	LDD  R26,Y+4
	TST  R26
	BRMI _0x2A
; 0000 0082                 lcd_putchar('+');
	LDI  R30,LOW(43)
	RJMP _0x8C
; 0000 0083                 }
; 0000 0084                 else{
_0x2A:
; 0000 0085                 lcd_putchar('-');
	LDI  R30,LOW(45)
_0x8C:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0086                 }
; 0000 0087             }
; 0000 0088 
; 0000 0089             if(a<0){
_0x29:
	LDD  R26,Y+4
	TST  R26
	BRPL _0x2C
; 0000 008A             a = a*(-1);
	CALL SUBOPT_0x0
	__GETD2N 0xFFFFFFFF
	CALL __MULD12
	CALL SUBOPT_0x2
; 0000 008B             }
; 0000 008C 
; 0000 008D             if(k*10<a){
_0x2C:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRSH _0x2D
; 0000 008E             a = k*10 - 1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
; 0000 008F             }
; 0000 0090 
; 0000 0091             for(i=0;i<Lenght;i++){
_0x2D:
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x2F:
	LDD  R30,Y+20
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0x30
; 0000 0092                 if(NumbersAfterDot!=0){
	LDD  R30,Y+18
	CPI  R30,0
	BREQ _0x31
; 0000 0093                     if(Lenght-NumbersAfterDot==i){
	CALL SUBOPT_0x7
	BRNE _0x32
; 0000 0094                     lcd_putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0095                     }
; 0000 0096                 }
_0x32:
; 0000 0097             b = a/k;
_0x31:
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0098             lcd_putchar( NumToIndex( b ) );
; 0000 0099             a = a - b*k;
; 0000 009A             k = k/10;
; 0000 009B             }
	LDD  R30,Y+5
	SUBI R30,-LOW(1)
	STD  Y+5,R30
	RJMP _0x2F
_0x30:
; 0000 009C         return 1;
	LDI  R30,LOW(1)
	ADIW R28,10
	RJMP _0x2020002
; 0000 009D         }
; 0000 009E     }
_0x28:
	ADIW R28,5
; 0000 009F return 0;
_0x1A:
	LDI  R30,LOW(0)
_0x2020002:
	ADIW R28,12
	RET
; 0000 00A0 }
;
;
;
;
;#define A_FAZE_APACIA PORTD.0
;#define B_FAZE_APACIA PORTD.1
;#define C_FAZE_APACIA PORTD.2
;//#define FAST_ON PIND.3
;unsigned char FAST_ON;
;unsigned char APCIOS_UZLAIKYMAS_IJUNGIANT[3];
;
;
;
;
;unsigned char SIN_CIKLAS, START, DALIKLIS, DAZNIO_DALIKLIS, UPDATE_LCD;
;int lcd_update_skaitiklis, sek_skaitiklis,  DAZNIS, daznio_skaitiklis;
;unsigned char sinus_OUTPUT[3][60];
;
;
;unsigned char STEP_UP_PLOTIS;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 00B8 interrupt [10] void timer0_ovf_isr(void){
_timer0_ovf_isr:
; 0000 00B9 
; 0000 00BA 
; 0000 00BB }
	RETI
;
;
;
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void){
; 0000 00C1 interrupt [9] void timer1_ovf_isr(void){
_timer1_ovf_isr:
; 0000 00C2 
; 0000 00C3 }
	RETI
;
;
;// Timer1 output compare B interrupt service routine
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
; 0000 00C8 {
_timer1_compb_isr:
; 0000 00C9 
; 0000 00CA }
	RETI
;
;
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void){
; 0000 00CF interrupt [5] void timer2_ovf_isr(void){
_timer2_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00D0 lcd_update_skaitiklis++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 00D1     if(lcd_update_skaitiklis==1569){
	LDI  R30,LOW(1569)
	LDI  R31,HIGH(1569)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x33
; 0000 00D2     // impulsas kas 0.1 sekundes (8 MHz)
; 0000 00D3     lcd_update_skaitiklis = 0;
	CLR  R10
	CLR  R11
; 0000 00D4     UPDATE_LCD = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 00D5 
; 0000 00D6 
; 0000 00D7     sek_skaitiklis++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 00D8         if(sek_skaitiklis>=10){
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R12,R30
	CPC  R13,R31
	BRLT _0x34
; 0000 00D9         // impulsas kas sekunde (8 MHz)
; 0000 00DA         UPDATE_LCD = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 00DB         DAZNIS = daznio_skaitiklis;
	LDS  R30,_daznio_skaitiklis
	LDS  R31,_daznio_skaitiklis+1
	STS  _DAZNIS,R30
	STS  _DAZNIS+1,R31
; 0000 00DC         sek_skaitiklis = 0;
	CLR  R12
	CLR  R13
; 0000 00DD         daznio_skaitiklis = 0;
	LDI  R30,LOW(0)
	STS  _daznio_skaitiklis,R30
	STS  _daznio_skaitiklis+1,R30
; 0000 00DE 
; 0000 00DF         }
; 0000 00E0 
; 0000 00E1 
; 0000 00E2 
; 0000 00E3     }
_0x34:
; 0000 00E4 
; 0000 00E5 
; 0000 00E6 DALIKLIS++;
_0x33:
	INC  R6
; 0000 00E7     if(DALIKLIS>=DAZNIO_DALIKLIS){
	CP   R6,R9
	BRSH PC+3
	JMP _0x35
; 0000 00E8     DALIKLIS = 0;
	CLR  R6
; 0000 00E9         if(START==1){
	LDI  R30,LOW(1)
	CP   R30,R7
	BREQ PC+3
	JMP _0x36
; 0000 00EA         SIN_CIKLAS++;
	INC  R4
; 0000 00EB             if(SIN_CIKLAS>=60){
	LDI  R30,LOW(60)
	CP   R4,R30
	BRLO _0x37
; 0000 00EC             SIN_CIKLAS = 0;
	CLR  R4
; 0000 00ED             daznio_skaitiklis++;
	LDI  R26,LOW(_daznio_skaitiklis)
	LDI  R27,HIGH(_daznio_skaitiklis)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
; 0000 00EE             }
; 0000 00EF 
; 0000 00F0 
; 0000 00F1 
; 0000 00F2             if(FAST_ON==1){
_0x37:
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ PC+3
	JMP _0x38
; 0000 00F3             /////////////// A /////////////
; 0000 00F4                 if(sinusA[SIN_CIKLAS]>0){
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_sinusA)
	SBCI R31,HIGH(-_sinusA)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRLO _0x39
; 0000 00F5                 A_FAZE_APACIA = 0;
	CBI  0x12,0
; 0000 00F6                 APCIOS_UZLAIKYMAS_IJUNGIANT[0] = 0;
	LDI  R30,LOW(0)
	STS  _APCIOS_UZLAIKYMAS_IJUNGIANT,R30
; 0000 00F7                 }
; 0000 00F8             OCR0 = sinus_OUTPUT[0][SIN_CIKLAS];
_0x39:
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_sinus_OUTPUT)
	SBCI R31,HIGH(-_sinus_OUTPUT)
	LD   R30,Z
	OUT  0x3C,R30
; 0000 00F9                 if(sinusA[SIN_CIKLAS]==0){
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_sinusA)
	SBCI R31,HIGH(-_sinusA)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x3C
; 0000 00FA                     if(APCIOS_UZLAIKYMAS_IJUNGIANT[0]==1){
	LDS  R26,_APCIOS_UZLAIKYMAS_IJUNGIANT
	CPI  R26,LOW(0x1)
	BRNE _0x3D
; 0000 00FB                     A_FAZE_APACIA = 1;
	SBI  0x12,0
; 0000 00FC                     }
; 0000 00FD                     else{
	RJMP _0x40
_0x3D:
; 0000 00FE                     APCIOS_UZLAIKYMAS_IJUNGIANT[0] = 1;
	LDI  R30,LOW(1)
	STS  _APCIOS_UZLAIKYMAS_IJUNGIANT,R30
; 0000 00FF                     }
_0x40:
; 0000 0100                 }
; 0000 0101             ///////////////////////////////
; 0000 0102 
; 0000 0103 
; 0000 0104 
; 0000 0105             /////////////// B /////////////
; 0000 0106                 if(sinusB[SIN_CIKLAS]>0){
_0x3C:
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_sinusB)
	SBCI R31,HIGH(-_sinusB)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRLO _0x41
; 0000 0107                 B_FAZE_APACIA = 0;
	CBI  0x12,1
; 0000 0108                 APCIOS_UZLAIKYMAS_IJUNGIANT[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _APCIOS_UZLAIKYMAS_IJUNGIANT,1
; 0000 0109                 }
; 0000 010A             OCR1A = sinus_OUTPUT[1][SIN_CIKLAS];
_0x41:
	__POINTW2MN _sinus_OUTPUT,60
	CLR  R30
	ADD  R26,R4
	ADC  R27,R30
	LD   R30,X
	LDI  R31,0
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 010B                 if(sinusB[SIN_CIKLAS]==0){
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_sinusB)
	SBCI R31,HIGH(-_sinusB)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x44
; 0000 010C                     if(APCIOS_UZLAIKYMAS_IJUNGIANT[1]==1){
	__GETB2MN _APCIOS_UZLAIKYMAS_IJUNGIANT,1
	CPI  R26,LOW(0x1)
	BRNE _0x45
; 0000 010D                     B_FAZE_APACIA = 1;
	SBI  0x12,1
; 0000 010E                     }
; 0000 010F                     else{
	RJMP _0x48
_0x45:
; 0000 0110                     APCIOS_UZLAIKYMAS_IJUNGIANT[1] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _APCIOS_UZLAIKYMAS_IJUNGIANT,1
; 0000 0111                     }
_0x48:
; 0000 0112                 }
; 0000 0113             ///////////////////////////////
; 0000 0114 
; 0000 0115 
; 0000 0116 
; 0000 0117             /////////////// C /////////////
; 0000 0118                 if(sinusC[SIN_CIKLAS]>0){
_0x44:
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_sinusC)
	SBCI R31,HIGH(-_sinusC)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRLO _0x49
; 0000 0119                 C_FAZE_APACIA = 0;
	CBI  0x12,2
; 0000 011A                 APCIOS_UZLAIKYMAS_IJUNGIANT[2] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _APCIOS_UZLAIKYMAS_IJUNGIANT,2
; 0000 011B                 }
; 0000 011C             OCR2 = sinus_OUTPUT[2][SIN_CIKLAS];
_0x49:
	__POINTW2MN _sinus_OUTPUT,120
	CLR  R30
	ADD  R26,R4
	ADC  R27,R30
	LD   R30,X
	OUT  0x23,R30
; 0000 011D                 if(sinusC[SIN_CIKLAS]==0){
	CALL SUBOPT_0xA
	SUBI R30,LOW(-_sinusC)
	SBCI R31,HIGH(-_sinusC)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x4C
; 0000 011E                     if(APCIOS_UZLAIKYMAS_IJUNGIANT[2]==1){
	__GETB2MN _APCIOS_UZLAIKYMAS_IJUNGIANT,2
	CPI  R26,LOW(0x1)
	BRNE _0x4D
; 0000 011F                     C_FAZE_APACIA = 1;
	SBI  0x12,2
; 0000 0120                     }
; 0000 0121                     else{
	RJMP _0x50
_0x4D:
; 0000 0122                     APCIOS_UZLAIKYMAS_IJUNGIANT[2] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _APCIOS_UZLAIKYMAS_IJUNGIANT,2
; 0000 0123                     }
_0x50:
; 0000 0124                 }
; 0000 0125             ///////////////////////////////
; 0000 0126 
; 0000 0127 
; 0000 0128 
; 0000 0129             /////////// STEP UP ///////////
; 0000 012A             OCR1B = STEP_UP_PLOTIS;
_0x4C:
	LDS  R30,_STEP_UP_PLOTIS
	LDI  R31,0
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 012B             ///////////////////////////////
; 0000 012C 
; 0000 012D             }
; 0000 012E             else{
	RJMP _0x51
_0x38:
; 0000 012F             A_FAZE_APACIA = 0;
	CALL SUBOPT_0xB
; 0000 0130             B_FAZE_APACIA = 0;
; 0000 0131             C_FAZE_APACIA = 0;
; 0000 0132             OCR0 = 0;
; 0000 0133             OCR1A = 0;
; 0000 0134             OCR1B = 0;
; 0000 0135             OCR2 = 0;
; 0000 0136             }
_0x51:
; 0000 0137 
; 0000 0138         }
; 0000 0139         else{
	RJMP _0x58
_0x36:
; 0000 013A         A_FAZE_APACIA = 0;
	CALL SUBOPT_0xB
; 0000 013B         B_FAZE_APACIA = 0;
; 0000 013C         C_FAZE_APACIA = 0;
; 0000 013D         OCR0 = 0;
; 0000 013E         OCR1A = 0;
; 0000 013F         OCR1B = 0;
; 0000 0140         OCR2 = 0;
; 0000 0141         }
_0x58:
; 0000 0142     }
; 0000 0143 }
_0x35:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;
;
;
;
;#define ADC_VREF_TYPE 0x60
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 014E {
_read_adc:
; 0000 014F ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0150 // Delay needed for the stabilization of the ADC input voltage
; 0000 0151 delay_us(10);
	__DELAY_USB 27
; 0000 0152 // Start the AD conversion
; 0000 0153 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0154 // Wait for the AD conversion to complete
; 0000 0155 while ((ADCSRA & 0x10)==0);
_0x5F:
	SBIS 0x6,4
	RJMP _0x5F
; 0000 0156 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0157 return ADCH;
	IN   R30,0x5
	JMP  _0x2020001
; 0000 0158 }
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
;
;// Declare your global variables here
;
;void main(void){
; 0000 0167 void main(void){
_main:
; 0000 0168 // Input/Output Ports initialization
; 0000 0169 // Port A initialization
; 0000 016A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 016B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 016C PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 016D DDRA=0x00;
	OUT  0x1A,R30
; 0000 016E 
; 0000 016F // Port B initialization
; 0000 0170 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In
; 0000 0171 // State7=T State6=T State5=T State4=T State3=0 State2=T State1=T State0=T
; 0000 0172 PORTB=0x00;
	OUT  0x18,R30
; 0000 0173 DDRB=0x08;
	LDI  R30,LOW(8)
	OUT  0x17,R30
; 0000 0174 
; 0000 0175 // Port C initialization
; 0000 0176 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0177 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0178 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0179 DDRC=0x00;
	OUT  0x14,R30
; 0000 017A 
; 0000 017B // Port D initialization
; 0000 017C // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 017D // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 017E PORTD=0x00;
	OUT  0x12,R30
; 0000 017F DDRD=0b11110111;
	LDI  R30,LOW(247)
	OUT  0x11,R30
; 0000 0180 
; 0000 0181 // Timer/Counter 0 initialization
; 0000 0182 // Clock source: System Clock
; 0000 0183 // Clock value: 8000.000 kHz
; 0000 0184 // Mode: Phase correct PWM top=FFh
; 0000 0185 // OC0 output: Non-Inverted PWM
; 0000 0186 TCCR0=0x61;
	LDI  R30,LOW(97)
	OUT  0x33,R30
; 0000 0187 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0188 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0189 
; 0000 018A // Timer/Counter 1 initialization
; 0000 018B // Clock source: System Clock
; 0000 018C // Clock value: 8000.000 kHz
; 0000 018D // Mode: Ph. correct PWM top=00FFh
; 0000 018E // OC1A output: Non-Inv.
; 0000 018F // OC1B output: Non-Inv.
; 0000 0190 // Noise Canceler: Off
; 0000 0191 // Input Capture on Falling Edge
; 0000 0192 // Timer1 Overflow Interrupt: On
; 0000 0193 // Input Capture Interrupt: Off
; 0000 0194 // Compare A Match Interrupt: Off
; 0000 0195 // Compare B Match Interrupt: Off
; 0000 0196 TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0197 TCCR1B=0x01;
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 0198 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0199 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 019A ICR1H=0x00;
	OUT  0x27,R30
; 0000 019B ICR1L=0x00;
	OUT  0x26,R30
; 0000 019C OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 019D OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 019E OCR1BH=0x00;
	OUT  0x29,R30
; 0000 019F OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01A0 
; 0000 01A1 // Timer/Counter 2 initialization
; 0000 01A2 // Clock source: System Clock
; 0000 01A3 // Clock value: 8000.000 kHz
; 0000 01A4 // Mode: Phase correct PWM top=FFh
; 0000 01A5 // OC2 output: Non-Inverted PWM
; 0000 01A6 ASSR=0x00;
	OUT  0x22,R30
; 0000 01A7 TCCR2=0x61;
	LDI  R30,LOW(97)
	OUT  0x25,R30
; 0000 01A8 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 01A9 OCR2=0x00;
	OUT  0x23,R30
; 0000 01AA 
; 0000 01AB // External Interrupt(s) initialization
; 0000 01AC // INT0: Off
; 0000 01AD // INT1: Off
; 0000 01AE // INT2: Off
; 0000 01AF MCUCR=0x00;
	OUT  0x35,R30
; 0000 01B0 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 01B1 
; 0000 01B2 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01B3 TIMSK=0x45;
	LDI  R30,LOW(69)
	OUT  0x39,R30
; 0000 01B4 
; 0000 01B5 // Analog Comparator initialization
; 0000 01B6 // Analog Comparator: Off
; 0000 01B7 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01B8 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01B9 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01BA 
; 0000 01BB // ADC initialization
; 0000 01BC // ADC Clock frequency: 62,500 kHz
; 0000 01BD // ADC Voltage Reference: AVCC pin
; 0000 01BE // ADC Auto Trigger Source: None
; 0000 01BF // Only the 8 most significant bits of
; 0000 01C0 // the AD conversion result are used
; 0000 01C1 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 01C2 ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 01C3 
; 0000 01C4 
; 0000 01C5 // Global enable interrupts
; 0000 01C6 #asm("sei")
	sei
; 0000 01C7 
; 0000 01C8 
; 0000 01C9 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 01CA ////////////////////////////////////////////////// LCD module initialization ///////////////////////////////////////////////////////////////////
; 0000 01CB ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 01CC lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01CD static unsigned char pos;
; 0000 01CE     while(pos<44){
_0x62:
	LDS  R26,_pos_S0000007000
	CPI  R26,LOW(0x2C)
	BRLO PC+3
	JMP _0x64
; 0000 01CF     lcd_clear();
	CALL _lcd_clear
; 0000 01D0         if(pos==0){lcd_gotoxy(0,2);lcd_putchar('/');lcd_gotoxy(0,1);lcd_putchar('/');lcd_gotoxy(0,0);lcd_putchar('^');}
	LDS  R30,_pos_S0000007000
	CPI  R30,0
	BRNE _0x65
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	LDI  R30,LOW(94)
	RJMP _0x8D
; 0000 01D1         else if(pos==1){lcd_gotoxy(0,1);lcd_putchar('/');lcd_gotoxy(0,0);lcd_putsf("+>");}
_0x65:
	LDS  R26,_pos_S0000007000
	CPI  R26,LOW(0x1)
	BRNE _0x67
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x10
; 0000 01D2         else if((pos>=2)&&(pos<=19)){lcd_gotoxy(pos-2,0);lcd_putsf("-->");}
	RJMP _0x68
_0x67:
	LDS  R26,_pos_S0000007000
	CPI  R26,LOW(0x2)
	BRLO _0x6A
	CPI  R26,LOW(0x14)
	BRLO _0x6B
_0x6A:
	RJMP _0x69
_0x6B:
	LDS  R30,_pos_S0000007000
	LDI  R31,0
	SBIW R30,2
	ST   -Y,R30
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,3
	CALL SUBOPT_0x10
; 0000 01D3         else if(pos==20){lcd_gotoxy(18,0);lcd_putsf("-+");lcd_gotoxy(19,1);lcd_putchar('v');}
	RJMP _0x6C
_0x69:
	LDS  R26,_pos_S0000007000
	CPI  R26,LOW(0x14)
	BRNE _0x6D
	LDI  R30,LOW(18)
	ST   -Y,R30
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,7
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	LDI  R30,LOW(118)
	RJMP _0x8D
; 0000 01D4         else if(pos==21){lcd_gotoxy(19,0);lcd_putchar('/');lcd_gotoxy(19,1);lcd_putchar('/');lcd_gotoxy(19,2);lcd_putchar('v');}
_0x6D:
	LDS  R26,_pos_S0000007000
	CPI  R26,LOW(0x15)
	BRNE _0x6F
	LDI  R30,LOW(19)
	ST   -Y,R30
	CALL SUBOPT_0xF
	CALL SUBOPT_0x12
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	LDI  R30,LOW(118)
	RJMP _0x8D
; 0000 01D5         else if(pos==22){lcd_gotoxy(19,1);lcd_putchar('/');lcd_gotoxy(19,2);lcd_putchar('/');lcd_gotoxy(19,3);lcd_putchar('v');}
_0x6F:
	LDS  R26,_pos_S0000007000
	CPI  R26,LOW(0x16)
	BRNE _0x71
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL SUBOPT_0x12
	LDI  R30,LOW(19)
	CALL SUBOPT_0x14
	LDI  R30,LOW(118)
	RJMP _0x8D
; 0000 01D6         else if(pos==23){lcd_gotoxy(19,2);lcd_putchar('/');lcd_gotoxy(18,3);lcd_putsf("<+");}
_0x71:
	LDS  R26,_pos_S0000007000
	CPI  R26,LOW(0x17)
	BRNE _0x73
	CALL SUBOPT_0x13
	CALL SUBOPT_0x12
	LDI  R30,LOW(18)
	CALL SUBOPT_0x14
	__POINTW1FN _0x0,10
	CALL SUBOPT_0x10
; 0000 01D7         else if((pos>=24)&&(pos<=41)){lcd_gotoxy(17-pos+24,3);lcd_putsf("<--");}
	RJMP _0x74
_0x73:
	LDS  R26,_pos_S0000007000
	CPI  R26,LOW(0x18)
	BRLO _0x76
	CPI  R26,LOW(0x2A)
	BRLO _0x77
_0x76:
	RJMP _0x75
_0x77:
	LDS  R30,_pos_S0000007000
	LDI  R31,0
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	CALL SUBOPT_0x15
	SUBI R30,-LOW(24)
	CALL SUBOPT_0x14
	__POINTW1FN _0x0,13
	CALL SUBOPT_0x10
; 0000 01D8         else if(pos==42){lcd_gotoxy(0,2);lcd_putchar('^');lcd_gotoxy(0,3);lcd_putsf("+-");}
	RJMP _0x78
_0x75:
	LDS  R26,_pos_S0000007000
	CPI  R26,LOW(0x2A)
	BRNE _0x79
	CALL SUBOPT_0xC
	LDI  R30,LOW(94)
	ST   -Y,R30
	CALL _lcd_putchar
	LDI  R30,LOW(0)
	CALL SUBOPT_0x14
	__POINTW1FN _0x0,17
	CALL SUBOPT_0x10
; 0000 01D9         else if(pos==43){lcd_gotoxy(0,1);lcd_putchar('^');lcd_gotoxy(0,2);lcd_putchar('/');lcd_gotoxy(0,3);lcd_putchar('/');}
	RJMP _0x7A
_0x79:
	LDS  R26,_pos_S0000007000
	CPI  R26,LOW(0x2B)
	BRNE _0x7B
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(94)
	ST   -Y,R30
	CALL _lcd_putchar
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(47)
_0x8D:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 01DA 
; 0000 01DB     lcd_gotoxy(1,1);
_0x7B:
_0x7A:
_0x78:
_0x74:
_0x6C:
_0x68:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01DC     lcd_putsf("  TopEnerga IGBT  ");
	__POINTW1FN _0x0,20
	CALL SUBOPT_0x10
; 0000 01DD     lcd_gotoxy(1,2);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01DE     lcd_putsf("     TESTERIS     ");
	__POINTW1FN _0x0,39
	CALL SUBOPT_0x10
; 0000 01DF 
; 0000 01E0 
; 0000 01E1     delay_ms(40);
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01E2     pos++;
	LDS  R30,_pos_S0000007000
	SUBI R30,-LOW(1)
	STS  _pos_S0000007000,R30
; 0000 01E3     }
	RJMP _0x62
_0x64:
; 0000 01E4 lcd_clear();
	CALL _lcd_clear
; 0000 01E5 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 01E6 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 01E7 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 01E8 
; 0000 01E9 
; 0000 01EA 
; 0000 01EB 
; 0000 01EC START = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 01ED FAST_ON = 1;
	MOV  R5,R30
; 0000 01EE     while(1){
_0x7C:
; 0000 01EF 
; 0000 01F0         if(UPDATE_LCD==1){
	LDI  R30,LOW(1)
	CP   R30,R8
	BREQ PC+3
	JMP _0x7F
; 0000 01F1         unsigned char x, ofset;
; 0000 01F2         UPDATE_LCD = 0;
	SBIW R28,2
;	x -> Y+1
;	ofset -> Y+0
	CLR  R8
; 0000 01F3 
; 0000 01F4 
; 0000 01F5 
; 0000 01F6 
; 0000 01F7 
; 0000 01F8         lcd_clear();
	CALL _lcd_clear
; 0000 01F9 
; 0000 01FA 
; 0000 01FB         lcd_gotoxy(0,0);
	CALL SUBOPT_0x16
	CALL _lcd_gotoxy
; 0000 01FC         lcd_putsf("-===SIMULIACIJA===- ");
	__POINTW1FN _0x0,58
	CALL SUBOPT_0x10
; 0000 01FD             if(FAST_ON==1){
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x80
; 0000 01FE 
; 0000 01FF             lcd_putsf("PWM:");
	__POINTW1FN _0x0,79
	CALL SUBOPT_0x10
; 0000 0200             lcd_put_number(0,3,0,0,read_adc(1),0);
	CALL SUBOPT_0x17
	LDI  R30,LOW(1)
	CALL SUBOPT_0x18
; 0000 0201             lcd_putsf("/255  | ON  |");
	__POINTW1FN _0x0,84
	CALL SUBOPT_0x10
; 0000 0202 
; 0000 0203             lcd_gotoxy(0,2);
	CALL SUBOPT_0xC
; 0000 0204             lcd_putsf("DAZNIS:");
	__POINTW1FN _0x0,98
	CALL SUBOPT_0x10
; 0000 0205             lcd_put_number(0,3,0,0,DAZNIS,0);
	CALL SUBOPT_0x17
	LDS  R30,_DAZNIS
	LDS  R31,_DAZNIS+1
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _lcd_put_number
; 0000 0206             lcd_putsf(" Hz -----");
	__POINTW1FN _0x0,106
	CALL SUBOPT_0x10
; 0000 0207 
; 0000 0208 
; 0000 0209 
; 0000 020A 
; 0000 020B             lcd_gotoxy(0,3);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x14
; 0000 020C             lcd_putsf("STEPUP PWM: ");
	__POINTW1FN _0x0,116
	CALL SUBOPT_0x10
; 0000 020D             lcd_put_number(0,3,0,0,read_adc(2),0);
	CALL SUBOPT_0x17
	LDI  R30,LOW(2)
	CALL SUBOPT_0x18
; 0000 020E             lcd_putsf("/255");
	__POINTW1FN _0x0,129
	RJMP _0x8E
; 0000 020F             }
; 0000 0210             else{
_0x80:
; 0000 0211             lcd_putsf("PWM:000/255  | OFF |");
	__POINTW1FN _0x0,134
	CALL SUBOPT_0x10
; 0000 0212             lcd_putsf("DAZNIS:000 Hz ----- ");
	__POINTW1FN _0x0,155
	CALL SUBOPT_0x10
; 0000 0213             lcd_putsf("STEPUP PWM: 000/255");
	__POINTW1FN _0x0,176
_0x8E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0214             }
; 0000 0215 
; 0000 0216 
; 0000 0217         ofset = 255 - read_adc(1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x19
	CALL __SWAPW12
	SUB  R30,R26
	ST   Y,R30
; 0000 0218         DAZNIO_DALIKLIS = (1 + (255 - read_adc(0))) / 8;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x15
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	MOV  R9,R30
; 0000 0219         STEP_UP_PLOTIS = read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	STS  _STEP_UP_PLOTIS,R30
; 0000 021A             for(x=0; x<60; x++){
	LDI  R30,LOW(0)
	STD  Y+1,R30
_0x83:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3C)
	BRLO PC+3
	JMP _0x84
; 0000 021B                 if(ofset<sinusA[x]){
	CALL SUBOPT_0x1A
	SUBI R30,LOW(-_sinusA)
	SBCI R31,HIGH(-_sinusA)
	LD   R30,Z
	LD   R26,Y
	CP   R26,R30
	BRSH _0x85
; 0000 021C                 sinus_OUTPUT[0][x] = sinusA[x] - ofset;
	CALL SUBOPT_0x1A
	MOVW R26,R30
	SUBI R30,LOW(-_sinus_OUTPUT)
	SBCI R31,HIGH(-_sinus_OUTPUT)
	MOVW R22,R30
	MOVW R30,R26
	SUBI R30,LOW(-_sinusA)
	SBCI R31,HIGH(-_sinusA)
	CALL SUBOPT_0x1B
	MOVW R26,R22
	ST   X,R30
; 0000 021D                 }
; 0000 021E                 else{
	RJMP _0x86
_0x85:
; 0000 021F                 sinus_OUTPUT[0][x] = 0;
	CALL SUBOPT_0x1A
	SUBI R30,LOW(-_sinus_OUTPUT)
	SBCI R31,HIGH(-_sinus_OUTPUT)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0220                 }
_0x86:
; 0000 0221 
; 0000 0222                 if(ofset<sinusB[x]){
	CALL SUBOPT_0x1A
	SUBI R30,LOW(-_sinusB)
	SBCI R31,HIGH(-_sinusB)
	LD   R30,Z
	LD   R26,Y
	CP   R26,R30
	BRSH _0x87
; 0000 0223                 sinus_OUTPUT[1][x] = sinusB[x] - ofset;
	__POINTW2MN _sinus_OUTPUT,60
	CALL SUBOPT_0x1A
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x1A
	SUBI R30,LOW(-_sinusB)
	SBCI R31,HIGH(-_sinusB)
	CALL SUBOPT_0x1B
	MOVW R26,R22
	RJMP _0x8F
; 0000 0224                 }
; 0000 0225                 else{
_0x87:
; 0000 0226                 sinus_OUTPUT[1][x] = 0;
	__POINTW2MN _sinus_OUTPUT,60
	CALL SUBOPT_0x1A
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
_0x8F:
	ST   X,R30
; 0000 0227                 }
; 0000 0228 
; 0000 0229                 if(ofset<sinusC[x]){
	CALL SUBOPT_0x1A
	SUBI R30,LOW(-_sinusC)
	SBCI R31,HIGH(-_sinusC)
	LD   R30,Z
	LD   R26,Y
	CP   R26,R30
	BRSH _0x89
; 0000 022A                 sinus_OUTPUT[2][x] = sinusC[x] - ofset;
	__POINTW2MN _sinus_OUTPUT,120
	CALL SUBOPT_0x1A
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x1A
	SUBI R30,LOW(-_sinusC)
	SBCI R31,HIGH(-_sinusC)
	CALL SUBOPT_0x1B
	MOVW R26,R22
	RJMP _0x90
; 0000 022B                 }
; 0000 022C                 else{
_0x89:
; 0000 022D                 sinus_OUTPUT[2][x] = 0;
	__POINTW2MN _sinus_OUTPUT,120
	CALL SUBOPT_0x1A
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
_0x90:
	ST   X,R30
; 0000 022E                 }
; 0000 022F             }
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x83
_0x84:
; 0000 0230 
; 0000 0231 
; 0000 0232 
; 0000 0233 
; 0000 0234 
; 0000 0235 
; 0000 0236         }
	ADIW R28,2
; 0000 0237     }
_0x7F:
	RJMP _0x7C
; 0000 0238 }
_0x8B:
	RJMP _0x8B
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
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1C
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x1D
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
_sinusA:
	.BYTE 0x3C
_sinusB:
	.BYTE 0x3C
_sinusC:
	.BYTE 0x3C
_APCIOS_UZLAIKYMAS_IJUNGIANT:
	.BYTE 0x3
_DAZNIS:
	.BYTE 0x2
_daznio_skaitiklis:
	.BYTE 0x2
_sinus_OUTPUT:
	.BYTE 0xB4
_STEP_UP_PLOTIS:
	.BYTE 0x1
_pos_S0000007000:
	.BYTE 0x1
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	MOV  R30,R4
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xB:
	CBI  0x12,0
	CBI  0x12,1
	CBI  0x12,2
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	OUT  0x28+1,R31
	OUT  0x28,R30
	OUT  0x23,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(47)
	ST   -Y,R30
	CALL _lcd_putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(47)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x18:
	ST   -Y,R30
	CALL _read_adc
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	JMP  _lcd_put_number

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	ST   -Y,R30
	CALL _read_adc
	LDI  R31,0
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+1
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1B:
	LD   R26,Z
	LDI  R27,0
	LD   R30,Y
	LDI  R31,0
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
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

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

;END OF CODE MARKER
__END_OF_CODE:
