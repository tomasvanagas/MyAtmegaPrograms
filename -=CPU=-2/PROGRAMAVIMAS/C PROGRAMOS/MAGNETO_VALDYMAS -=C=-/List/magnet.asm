
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 4.000000 MHz
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
	.DEF _pasisveikinimas_baigtas=R5
	.DEF _x=R4
	.DEF _y=R7
	.DEF _z=R6
	.DEF _VIENA_SEKUNDE=R8
	.DEF _PUSE_SEKUNDES=R10
	.DEF _KETVIRTADALIS_SEKUNDES=R12

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
;Project :
;Version :
;Date    : 7/14/2010
;Author  : NeVaDa
;Company : namai
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 4.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
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
;
;void oscilatorius();
;
;void inputai();
;void outputai();
;
;void sekundes_ir_jos_daliu_trukme_ciklais();
;void sekundes_trukmes_keitimas();
;
;void dabartinis_laikas();
;void dabartinio_laiko_skaiciavimas();
;
;void pasisveikinimas();
;
;void padeciu_medis();
;
;void blyksintis_skaicius();
;
;void fontai();
;
;void kondensatoriaus_busena();
;
;void mosfet_valdymas();
;
;
;
;char pasisveikinimas_baigtas;
;
;signed char x,y,z;
;
;unsigned int VIENA_SEKUNDE, PUSE_SEKUNDES, KETVIRTADALIS_SEKUNDES;
;
;char OSC;
;
;char a, segm_a, segm_b, segm_c, segm_d, segm_e, segm_f,
;segm_g, segm_h;
;
;char MYGTUKAS_1, MYGTUKAS_2, MYGTUKAS_3, MYGTUKAS_4,
;MYGTUKAS_5, MYGTUKAS_6, MYGTUKAS_7, mygtuko_OSR;
;
;char kondensatorius_tuscias, kondensatorius_vidutinis,
;kondensatorius_pilnas, kondensatoriaus_rodymo_padetis;
;unsigned int kondensatoriaus_rodymo_laikas;
;
;unsigned int pasisveikinimo_laikas1;
;char pasisveikinimo_laikas2;
;
;char REDAGAVIMAS;
;
;char SKAICIUS_DEGA;
;unsigned int blyksincio_skaiciaus_laiko_paskutinis_ciklas,
;blyksincio_skaiciaus_laikas,
;blyksincio_skaiciaus_laiko_vidurinysis_ciklas;
;
;unsigned int viena_laikrodzio_sekunde;
;signed char laikrodzio_sekundes,
;laikrodzio_minutes, laikrodzio_valandos;
;
;char begancio_uzraso_DABAR_padetis;
;unsigned int begancio_uzraso_DABAR_laikas;
;
;char pfet_kairysis, pfet_desinysis,
;nfet_kairysis, nfet_desinysis;
;
;
;
;void main(void){
; 0000 0055 void main(void){

	.CSEG
_main:
; 0000 0056  // 0 in ; 1 out ;
; 0000 0057 PORTA = 0;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0058 DDRA = 0b00011110;
	LDI  R30,LOW(30)
	OUT  0x1A,R30
; 0000 0059 
; 0000 005A PORTB = 0;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 005B DDRB = 0b00011110;
	LDI  R30,LOW(30)
	OUT  0x17,R30
; 0000 005C 
; 0000 005D PORTC = 0;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 005E DDRC = 0b11111111;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 005F 
; 0000 0060 PORTD = 0;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0061 DDRD = 0b00011000;
	LDI  R30,LOW(24)
	OUT  0x11,R30
; 0000 0062 
; 0000 0063 // Timer/Counter 0 initialization
; 0000 0064 // Clock source: System Clock
; 0000 0065 // Clock value: Timer 0 Stopped
; 0000 0066 // Mode: Normal top=FFh
; 0000 0067 // OC0 output: Disconnected
; 0000 0068 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0069 TCNT0=0x00;
	OUT  0x32,R30
; 0000 006A OCR0=0x00;
	OUT  0x3C,R30
; 0000 006B 
; 0000 006C // Timer/Counter 1 initialization
; 0000 006D // Clock source: System Clock
; 0000 006E // Clock value: Timer1 Stopped
; 0000 006F // Mode: Normal top=FFFFh
; 0000 0070 // OC1A output: Discon.
; 0000 0071 // OC1B output: Discon.
; 0000 0072 // Noise Canceler: Off
; 0000 0073 // Input Capture on Falling Edge
; 0000 0074 // Timer1 Overflow Interrupt: Off
; 0000 0075 // Input Capture Interrupt: Off
; 0000 0076 // Compare A Match Interrupt: Off
; 0000 0077 // Compare B Match Interrupt: Off
; 0000 0078 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0079 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 007A TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 007B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 007C ICR1H=0x00;
	OUT  0x27,R30
; 0000 007D ICR1L=0x00;
	OUT  0x26,R30
; 0000 007E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 007F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0080 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0081 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0082 
; 0000 0083 // Timer/Counter 2 initialization
; 0000 0084 // Clock source: System Clock
; 0000 0085 // Clock value: Timer2 Stopped
; 0000 0086 // Mode: Normal top=FFh
; 0000 0087 // OC2 output: Disconnected
; 0000 0088 ASSR=0x00;
	OUT  0x22,R30
; 0000 0089 TCCR2=0x00;
	OUT  0x25,R30
; 0000 008A TCNT2=0x00;
	OUT  0x24,R30
; 0000 008B OCR2=0x00;
	OUT  0x23,R30
; 0000 008C 
; 0000 008D // External Interrupt(s) initialization
; 0000 008E // INT0: Off
; 0000 008F // INT1: Off
; 0000 0090 // INT2: Off
; 0000 0091 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0092 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0093 
; 0000 0094 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0095 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0096 
; 0000 0097 // Analog Comparator initialization
; 0000 0098 // Analog Comparator: Off
; 0000 0099 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 009A ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 009B SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 009C 
; 0000 009D VIENA_SEKUNDE = 11400;
	LDI  R30,LOW(11400)
	LDI  R31,HIGH(11400)
	MOVW R8,R30
; 0000 009E sekundes_ir_jos_daliu_trukme_ciklais();
	RCALL _sekundes_ir_jos_daliu_trukme_ciklais
; 0000 009F 
; 0000 00A0 
; 0000 00A1 
; 0000 00A2 while(pasisveikinimas_baigtas==0){
_0x3:
	TST  R5
	BRNE _0x5
; 0000 00A3 oscilatorius();
	RCALL _oscilatorius
; 0000 00A4 pasisveikinimas();
	RCALL _pasisveikinimas
; 0000 00A5 fontai();
	RCALL _fontai
; 0000 00A6 outputai();}
	RCALL _outputai
	RJMP _0x3
_0x5:
; 0000 00A7 
; 0000 00A8 while (1){
_0x6:
; 0000 00A9 oscilatorius();
	RCALL _oscilatorius
; 0000 00AA mosfet_valdymas();
	CALL _mosfet_valdymas
; 0000 00AB inputai();
	RCALL _inputai
; 0000 00AC sekundes_ir_jos_daliu_trukme_ciklais();
	RCALL _sekundes_ir_jos_daliu_trukme_ciklais
; 0000 00AD padeciu_medis();
	RCALL _padeciu_medis
; 0000 00AE dabartinio_laiko_skaiciavimas();
	CALL _dabartinio_laiko_skaiciavimas
; 0000 00AF blyksintis_skaicius();
	RCALL _blyksintis_skaicius
; 0000 00B0 fontai();
	RCALL _fontai
; 0000 00B1 outputai();}}
	RCALL _outputai
	RJMP _0x6
_0x9:
	RJMP _0x9
;
;
;
;void inputai(){
; 0000 00B5 void inputai(){
_inputai:
; 0000 00B6 
; 0000 00B7 //MYGTUKAI
; 0000 00B8 MYGTUKAS_1 = 0;
	CALL SUBOPT_0x0
; 0000 00B9 MYGTUKAS_2 = 0;
; 0000 00BA MYGTUKAS_3 = 0;
	STS  _MYGTUKAS_3,R30
; 0000 00BB MYGTUKAS_4 = 0;
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_4,R30
; 0000 00BC MYGTUKAS_5 = 0;
	STS  _MYGTUKAS_5,R30
; 0000 00BD MYGTUKAS_6 = 0;
	STS  _MYGTUKAS_6,R30
; 0000 00BE MYGTUKAS_7 = 0;
	STS  _MYGTUKAS_7,R30
; 0000 00BF 
; 0000 00C0 if((PIND.6==1)&&(PIND.5==1)&&(PIND.7==0)&&
; 0000 00C1 (mygtuko_OSR==0)){
	SBIS 0x10,6
	RJMP _0xB
	SBIS 0x10,5
	RJMP _0xB
	CALL SUBOPT_0x1
	BRNE _0xB
	LDS  R26,_mygtuko_OSR
	CPI  R26,LOW(0x0)
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 00C2 mygtuko_OSR = 1;
	CALL SUBOPT_0x2
; 0000 00C3 MYGTUKAS_1 = 1;}
	STS  _MYGTUKAS_1,R30
; 0000 00C4 
; 0000 00C5 if((PIND.6==1)&&(PIND.5==0)&&(PIND.7==1)&&
_0xA:
; 0000 00C6 (mygtuko_OSR==0)){
	SBIS 0x10,6
	RJMP _0xE
	CALL SUBOPT_0x3
	BRNE _0xE
	SBIS 0x10,7
	RJMP _0xE
	LDS  R26,_mygtuko_OSR
	CPI  R26,LOW(0x0)
	BREQ _0xF
_0xE:
	RJMP _0xD
_0xF:
; 0000 00C7 mygtuko_OSR = 1;
	CALL SUBOPT_0x2
; 0000 00C8 MYGTUKAS_2 = 1;}
	STS  _MYGTUKAS_2,R30
; 0000 00C9 
; 0000 00CA if((PIND.6==1)&&(PIND.5==0)&&(PIND.7==0)&&
_0xD:
; 0000 00CB (mygtuko_OSR==0)){
	SBIS 0x10,6
	RJMP _0x11
	CALL SUBOPT_0x3
	BRNE _0x11
	CALL SUBOPT_0x1
	BRNE _0x11
	LDS  R26,_mygtuko_OSR
	CPI  R26,LOW(0x0)
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
; 0000 00CC mygtuko_OSR = 1;
	CALL SUBOPT_0x2
; 0000 00CD MYGTUKAS_3 = 1;}
	STS  _MYGTUKAS_3,R30
; 0000 00CE 
; 0000 00CF if((PIND.6==0)&&(PIND.5==0)&&(PIND.7==1)&&
_0x10:
; 0000 00D0 (mygtuko_OSR==0)){
	CALL SUBOPT_0x4
	BRNE _0x14
	CALL SUBOPT_0x3
	BRNE _0x14
	SBIS 0x10,7
	RJMP _0x14
	LDS  R26,_mygtuko_OSR
	CPI  R26,LOW(0x0)
	BREQ _0x15
_0x14:
	RJMP _0x13
_0x15:
; 0000 00D1 mygtuko_OSR = 1;
	CALL SUBOPT_0x2
; 0000 00D2 MYGTUKAS_4 = 1;}
	STS  _MYGTUKAS_4,R30
; 0000 00D3 
; 0000 00D4 if((PIND.6==0)&&(PIND.5==0)&&(PIND.7==0)&&
_0x13:
; 0000 00D5 (mygtuko_OSR==0)){
	CALL SUBOPT_0x4
	BRNE _0x17
	CALL SUBOPT_0x3
	BRNE _0x17
	CALL SUBOPT_0x1
	BRNE _0x17
	LDS  R26,_mygtuko_OSR
	CPI  R26,LOW(0x0)
	BREQ _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 00D6 mygtuko_OSR = 1;
	CALL SUBOPT_0x2
; 0000 00D7 MYGTUKAS_5 = 1;}
	STS  _MYGTUKAS_5,R30
; 0000 00D8 
; 0000 00D9 if((PIND.6==0)&&(PIND.5==1)&&(PIND.7==0)&&
_0x16:
; 0000 00DA (mygtuko_OSR==0)){
	CALL SUBOPT_0x4
	BRNE _0x1A
	SBIS 0x10,5
	RJMP _0x1A
	CALL SUBOPT_0x1
	BRNE _0x1A
	LDS  R26,_mygtuko_OSR
	CPI  R26,LOW(0x0)
	BREQ _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
; 0000 00DB mygtuko_OSR = 1;
	CALL SUBOPT_0x2
; 0000 00DC MYGTUKAS_6 = 1;}
	STS  _MYGTUKAS_6,R30
; 0000 00DD 
; 0000 00DE if((PIND.6==0)&&(PIND.5==1)&&(PIND.7==1)&&
_0x19:
; 0000 00DF (mygtuko_OSR==0)){
	CALL SUBOPT_0x4
	BRNE _0x1D
	SBIS 0x10,5
	RJMP _0x1D
	SBIS 0x10,7
	RJMP _0x1D
	LDS  R26,_mygtuko_OSR
	CPI  R26,LOW(0x0)
	BREQ _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
; 0000 00E0 mygtuko_OSR = 1;
	CALL SUBOPT_0x2
; 0000 00E1 MYGTUKAS_7 = 1;}
	STS  _MYGTUKAS_7,R30
; 0000 00E2 
; 0000 00E3 
; 0000 00E4 if((PIND.6==1)&&(PIND.5==1)&&(PIND.7==1)){
_0x1C:
	SBIS 0x10,6
	RJMP _0x20
	SBIS 0x10,5
	RJMP _0x20
	SBIC 0x10,7
	RJMP _0x21
_0x20:
	RJMP _0x1F
_0x21:
; 0000 00E5 mygtuko_OSR = 0;}
	LDI  R30,LOW(0)
	STS  _mygtuko_OSR,R30
; 0000 00E6 
; 0000 00E7 
; 0000 00E8 //ITAMPOS
; 0000 00E9 kondensatorius_tuscias = 0;
_0x1F:
	LDI  R30,LOW(0)
	STS  _kondensatorius_tuscias,R30
; 0000 00EA kondensatorius_vidutinis = 0;
	STS  _kondensatorius_vidutinis,R30
; 0000 00EB kondensatorius_pilnas = 0;
	STS  _kondensatorius_pilnas,R30
; 0000 00EC 
; 0000 00ED if((PIND.3==0)&&(PIND.4==0)){
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x23
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x24
_0x23:
	RJMP _0x22
_0x24:
; 0000 00EE kondensatorius_tuscias = 1;}
	LDI  R30,LOW(1)
	STS  _kondensatorius_tuscias,R30
; 0000 00EF if((PIND.3==1)&&(PIND.4==0)){
_0x22:
	SBIS 0x10,3
	RJMP _0x26
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 00F0 kondensatorius_vidutinis = 1;}
	LDI  R30,LOW(1)
	STS  _kondensatorius_vidutinis,R30
; 0000 00F1 if((PIND.3==1)&&(PIND.4==1)){
_0x25:
	SBIS 0x10,3
	RJMP _0x29
	SBIC 0x10,4
	RJMP _0x2A
_0x29:
	RJMP _0x28
_0x2A:
; 0000 00F2 kondensatorius_pilnas = 1;}}
	LDI  R30,LOW(1)
	STS  _kondensatorius_pilnas,R30
_0x28:
	RET
;
;
;
;void oscilatorius(){
; 0000 00F6 void oscilatorius(){
_oscilatorius:
; 0000 00F7 OSC = OSC + 1;
	LDS  R30,_OSC
	SUBI R30,-LOW(1)
	STS  _OSC,R30
; 0000 00F8 if(OSC>=31){
	LDS  R26,_OSC
	CPI  R26,LOW(0x1F)
	BRLO _0x2B
; 0000 00F9 OSC = 0;}}
	LDI  R30,LOW(0)
	STS  _OSC,R30
_0x2B:
	RET
;
;
;// +
;void sekundes_ir_jos_daliu_trukme_ciklais(){
; 0000 00FD void sekundes_ir_jos_daliu_trukme_ciklais(){
_sekundes_ir_jos_daliu_trukme_ciklais:
; 0000 00FE PUSE_SEKUNDES = VIENA_SEKUNDE / 2;
	MOVW R30,R8
	LSR  R31
	ROR  R30
	MOVW R10,R30
; 0000 00FF KETVIRTADALIS_SEKUNDES = VIENA_SEKUNDE / 4;}
	MOVW R30,R8
	CALL __LSRW2
	MOVW R12,R30
	RET
;
;
;// +
;void pasisveikinimas(){
; 0000 0103 void pasisveikinimas(){
_pasisveikinimas:
; 0000 0104 pasisveikinimo_laikas1 = pasisveikinimo_laikas1 + 1;
	LDS  R30,_pasisveikinimo_laikas1
	LDS  R31,_pasisveikinimo_laikas1+1
	ADIW R30,1
	STS  _pasisveikinimo_laikas1,R30
	STS  _pasisveikinimo_laikas1+1,R31
; 0000 0105 if(pasisveikinimo_laikas1>=VIENA_SEKUNDE){
	LDS  R26,_pasisveikinimo_laikas1
	LDS  R27,_pasisveikinimo_laikas1+1
	CP   R26,R8
	CPC  R27,R9
	BRLO _0x2C
; 0000 0106 pasisveikinimo_laikas2 = pasisveikinimo_laikas2 + 1;
	LDS  R30,_pasisveikinimo_laikas2
	SUBI R30,-LOW(1)
	STS  _pasisveikinimo_laikas2,R30
; 0000 0107 pasisveikinimo_laikas1 = 0;}
	LDI  R30,LOW(0)
	STS  _pasisveikinimo_laikas1,R30
	STS  _pasisveikinimo_laikas1+1,R30
; 0000 0108 
; 0000 0109 if(pasisveikinimo_laikas2==1){
_0x2C:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x1)
	BRNE _0x2D
; 0000 010A if(OSC==28){
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x2E
; 0000 010B a = 17;}}
	LDI  R30,LOW(17)
	STS  _a,R30
_0x2E:
; 0000 010C if(pasisveikinimo_laikas2==2){
_0x2D:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x2)
	BRNE _0x2F
; 0000 010D if(OSC==24){
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x30
; 0000 010E a = 17;}
	LDI  R30,LOW(17)
	STS  _a,R30
; 0000 010F if(OSC==28){
_0x30:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x31
; 0000 0110 a = 15;}}
	LDI  R30,LOW(15)
	STS  _a,R30
_0x31:
; 0000 0111 if(pasisveikinimo_laikas2==3){
_0x2F:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x3)
	BRNE _0x32
; 0000 0112 if(OSC==20){
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x33
; 0000 0113 a = 17;}
	LDI  R30,LOW(17)
	STS  _a,R30
; 0000 0114 if(OSC==24){
_0x33:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x34
; 0000 0115 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 0116 if(OSC==28){
_0x34:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x35
; 0000 0117 a = 22;}}
	LDI  R30,LOW(22)
	STS  _a,R30
_0x35:
; 0000 0118 if(pasisveikinimo_laikas2==4){
_0x32:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x4)
	BRNE _0x36
; 0000 0119 if(OSC==16){
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x37
; 0000 011A a = 17;}
	LDI  R30,LOW(17)
	STS  _a,R30
; 0000 011B if(OSC==20){
_0x37:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x38
; 0000 011C a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 011D if(OSC==24){
_0x38:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x39
; 0000 011E a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 011F if(OSC==28){
_0x39:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x3A
; 0000 0120 a = 22;}}
	LDI  R30,LOW(22)
	STS  _a,R30
_0x3A:
; 0000 0121 if(pasisveikinimo_laikas2==5){
_0x36:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x5)
	BRNE _0x3B
; 0000 0122 if(OSC==12){
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x3C
; 0000 0123 a = 17;}
	LDI  R30,LOW(17)
	STS  _a,R30
; 0000 0124 if(OSC==16){
_0x3C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x3D
; 0000 0125 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 0126 if(OSC==20){
_0x3D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x3E
; 0000 0127 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0128 if(OSC==24){
_0x3E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x3F
; 0000 0129 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 012A if(OSC==28){
_0x3F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x40
; 0000 012B a = 0;}}
	LDI  R30,LOW(0)
	STS  _a,R30
_0x40:
; 0000 012C if(pasisveikinimo_laikas2==6){
_0x3B:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x6)
	BRNE _0x41
; 0000 012D if(OSC==8){
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x42
; 0000 012E a = 17;}
	LDI  R30,LOW(17)
	STS  _a,R30
; 0000 012F if(OSC==12){
_0x42:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x43
; 0000 0130 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 0131 if(OSC==16){
_0x43:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x44
; 0000 0132 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0133 if(OSC==20){
_0x44:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x45
; 0000 0134 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0135 if(OSC==24){
_0x45:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x46
; 0000 0136 a = 0;}}
	LDI  R30,LOW(0)
	STS  _a,R30
_0x46:
; 0000 0137 if(pasisveikinimo_laikas2==7){
_0x41:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x7)
	BRNE _0x47
; 0000 0138 if(OSC==4){
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x48
; 0000 0139 a = 17;}
	LDI  R30,LOW(17)
	STS  _a,R30
; 0000 013A if(OSC==8){
_0x48:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x49
; 0000 013B a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 013C if(OSC==12){
_0x49:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x4A
; 0000 013D a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 013E if(OSC==16){
_0x4A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x4B
; 0000 013F a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0140 if(OSC==20){
_0x4B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x4C
; 0000 0141 a = 0;}}
	LDI  R30,LOW(0)
	STS  _a,R30
_0x4C:
; 0000 0142 if(pasisveikinimo_laikas2==8){
_0x47:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x8)
	BRNE _0x4D
; 0000 0143 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x4E
; 0000 0144 a = 17;}
	LDI  R30,LOW(17)
	STS  _a,R30
; 0000 0145 if(OSC==4){
_0x4E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x4F
; 0000 0146 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 0147 if(OSC==8){
_0x4F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x50
; 0000 0148 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0149 if(OSC==12){
_0x50:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x51
; 0000 014A a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 014B if(OSC==16){
_0x51:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x52
; 0000 014C a = 0;}}
	LDI  R30,LOW(0)
	STS  _a,R30
_0x52:
; 0000 014D if(pasisveikinimo_laikas2==10){
_0x4D:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0xA)
	BRNE _0x53
; 0000 014E if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x54
; 0000 014F a = 17;}
	LDI  R30,LOW(17)
	STS  _a,R30
; 0000 0150 if(OSC==4){
_0x54:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x55
; 0000 0151 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 0152 if(OSC==8){
_0x55:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x56
; 0000 0153 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0154 if(OSC==12){
_0x56:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x57
; 0000 0155 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0156 if(OSC==16){
_0x57:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x58
; 0000 0157 a = 0;}}
	LDI  R30,LOW(0)
	STS  _a,R30
_0x58:
; 0000 0158 if(pasisveikinimo_laikas2==12){
_0x53:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0xC)
	BRNE _0x59
; 0000 0159 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x5A
; 0000 015A a = 17;}
	LDI  R30,LOW(17)
	STS  _a,R30
; 0000 015B if(OSC==4){
_0x5A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x5B
; 0000 015C a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 015D if(OSC==8){
_0x5B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x5C
; 0000 015E a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 015F if(OSC==12){
_0x5C:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x5D
; 0000 0160 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0161 if(OSC==16){
_0x5D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x5E
; 0000 0162 a = 0;}}
	LDI  R30,LOW(0)
	STS  _a,R30
_0x5E:
; 0000 0163 if(pasisveikinimo_laikas2==14){
_0x59:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0xE)
	BRNE _0x5F
; 0000 0164 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x60
; 0000 0165 a = 17;}
	LDI  R30,LOW(17)
	STS  _a,R30
; 0000 0166 if(OSC==4){
_0x60:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x61
; 0000 0167 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 0168 if(OSC==8){
_0x61:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x62
; 0000 0169 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 016A if(OSC==12){
_0x62:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x63
; 0000 016B a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 016C if(OSC==16){
_0x63:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x64
; 0000 016D a = 0;}}
	LDI  R30,LOW(0)
	STS  _a,R30
_0x64:
; 0000 016E if(pasisveikinimo_laikas2==15){
_0x5F:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0xF)
	BRNE _0x65
; 0000 016F if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x66
; 0000 0170 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 0171 if(OSC==4){
_0x66:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x67
; 0000 0172 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0173 if(OSC==8){
_0x67:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x68
; 0000 0174 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0175 if(OSC==12){
_0x68:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x69
; 0000 0176 a = 0;}}
	LDI  R30,LOW(0)
	STS  _a,R30
_0x69:
; 0000 0177 if(pasisveikinimo_laikas2==16){
_0x65:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x10)
	BRNE _0x6A
; 0000 0178 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x6B
; 0000 0179 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 017A if(OSC==4){
_0x6B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x6C
; 0000 017B a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 017C if(OSC==8){
_0x6C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x6D
; 0000 017D a = 0;}}
	LDI  R30,LOW(0)
	STS  _a,R30
_0x6D:
; 0000 017E if(pasisveikinimo_laikas2==17){
_0x6A:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x11)
	BRNE _0x6E
; 0000 017F if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x6F
; 0000 0180 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0181 if(OSC==4){
_0x6F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x70
; 0000 0182 a = 0;}}
	LDI  R30,LOW(0)
	STS  _a,R30
_0x70:
; 0000 0183 if(pasisveikinimo_laikas2==18){
_0x6E:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x12)
	BRNE _0x71
; 0000 0184 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x72
; 0000 0185 a = 0;}}
	LDI  R30,LOW(0)
	STS  _a,R30
_0x72:
; 0000 0186 if(pasisveikinimo_laikas2==20){
_0x71:
	LDS  R26,_pasisveikinimo_laikas2
	CPI  R26,LOW(0x14)
	BRNE _0x73
; 0000 0187 pasisveikinimas_baigtas = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0188 pasisveikinimo_laikas1 = 0;
	LDI  R30,LOW(0)
	STS  _pasisveikinimo_laikas1,R30
	STS  _pasisveikinimo_laikas1+1,R30
; 0000 0189 pasisveikinimo_laikas2 = 0;}}
	STS  _pasisveikinimo_laikas2,R30
_0x73:
	RET
;
;
;// +
;void fontai(){
; 0000 018D void fontai(){
_fontai:
; 0000 018E //SKAICIAI IR RAIDES:
; 0000 018F // a==10 (A)
; 0000 0190 // a==11 (b)
; 0000 0191 // a==12 (c)
; 0000 0192 // a==13 (C)
; 0000 0193 // a==14 (d)
; 0000 0194 // a==15 (E)
; 0000 0195 // a==16 (F)
; 0000 0196 // a==17 (H)
; 0000 0197 // a==18 (h)
; 0000 0198 // a==19 (I)
; 0000 0199 // a==20 (i)
; 0000 019A // a==21 (J)
; 0000 019B // a==22 (L)
; 0000 019C // a==23 (o)
; 0000 019D // a==24 (P)
; 0000 019E // a==25 (S)
; 0000 019F // a==26 (t)
; 0000 01A0 // a==27 (u)
; 0000 01A1 // a==28 (U)
; 0000 01A2 // a==29 (Z)
; 0000 01A3 // a==30 (r)
; 0000 01A4 // a==31 (_)
; 0000 01A5 // a==32 (-)
; 0000 01A6 // a==33 ( )
; 0000 01A7 // a==34 (n)
; 0000 01A8 
; 0000 01A9 
; 0000 01AA if(a == 0){
	LDS  R30,_a
	CPI  R30,0
	BRNE _0x74
; 0000 01AB segm_a = 1;
	CALL SUBOPT_0x5
; 0000 01AC segm_b = 1;
; 0000 01AD segm_c = 1;
	CALL SUBOPT_0x6
; 0000 01AE segm_d = 1;
; 0000 01AF segm_e = 1;
	CALL SUBOPT_0x7
; 0000 01B0 segm_f = 1;
; 0000 01B1 segm_g = 0;}
	LDI  R30,LOW(0)
	STS  _segm_g,R30
; 0000 01B2 if(a == 1){
_0x74:
	LDS  R26,_a
	CPI  R26,LOW(0x1)
	BRNE _0x75
; 0000 01B3 segm_a = 0;
	CALL SUBOPT_0x8
; 0000 01B4 segm_b = 1;
; 0000 01B5 segm_c = 1;
; 0000 01B6 segm_d = 0;
; 0000 01B7 segm_e = 0;
; 0000 01B8 segm_f = 0;
	CALL SUBOPT_0x9
; 0000 01B9 segm_g = 0;}
; 0000 01BA if(a == 2){
_0x75:
	LDS  R26,_a
	CPI  R26,LOW(0x2)
	BRNE _0x76
; 0000 01BB segm_a = 1;
	CALL SUBOPT_0x5
; 0000 01BC segm_b = 1;
; 0000 01BD segm_c = 0;
	CALL SUBOPT_0xA
; 0000 01BE segm_d = 1;
; 0000 01BF segm_e = 1;
; 0000 01C0 segm_f = 0;
; 0000 01C1 segm_g = 1;}
; 0000 01C2 if(a == 3){
_0x76:
	LDS  R26,_a
	CPI  R26,LOW(0x3)
	BRNE _0x77
; 0000 01C3 segm_a = 1;
	CALL SUBOPT_0x5
; 0000 01C4 segm_b = 1;
; 0000 01C5 segm_c = 1;
	CALL SUBOPT_0x6
; 0000 01C6 segm_d = 1;
; 0000 01C7 segm_e = 0;
	CALL SUBOPT_0xB
; 0000 01C8 segm_f = 0;
; 0000 01C9 segm_g = 1;}
; 0000 01CA if(a == 4){
_0x77:
	LDS  R26,_a
	CPI  R26,LOW(0x4)
	BRNE _0x78
; 0000 01CB segm_a = 0;
	CALL SUBOPT_0x8
; 0000 01CC segm_b = 1;
; 0000 01CD segm_c = 1;
; 0000 01CE segm_d = 0;
; 0000 01CF segm_e = 0;
; 0000 01D0 segm_f = 1;
	CALL SUBOPT_0xC
; 0000 01D1 segm_g = 1;}
; 0000 01D2 if(a == 5){
_0x78:
	LDS  R26,_a
	CPI  R26,LOW(0x5)
	BRNE _0x79
; 0000 01D3 segm_a = 1;
	CALL SUBOPT_0xD
; 0000 01D4 segm_b = 0;
; 0000 01D5 segm_c = 1;
; 0000 01D6 segm_d = 1;
; 0000 01D7 segm_e = 0;
	CALL SUBOPT_0xE
; 0000 01D8 segm_f = 1;
; 0000 01D9 segm_g = 1;}
; 0000 01DA if(a == 6){
_0x79:
	LDS  R26,_a
	CPI  R26,LOW(0x6)
	BRNE _0x7A
; 0000 01DB segm_a = 1;
	CALL SUBOPT_0xD
; 0000 01DC segm_b = 0;
; 0000 01DD segm_c = 1;
; 0000 01DE segm_d = 1;
; 0000 01DF segm_e = 1;
	CALL SUBOPT_0x7
; 0000 01E0 segm_f = 1;
; 0000 01E1 segm_g = 1;}
	LDI  R30,LOW(1)
	STS  _segm_g,R30
; 0000 01E2 if(a == 7){
_0x7A:
	LDS  R26,_a
	CPI  R26,LOW(0x7)
	BRNE _0x7B
; 0000 01E3 segm_a = 1;
	CALL SUBOPT_0x5
; 0000 01E4 segm_b = 1;
; 0000 01E5 segm_c = 1;
	CALL SUBOPT_0xF
; 0000 01E6 segm_d = 0;
; 0000 01E7 segm_e = 0;
	CALL SUBOPT_0x10
; 0000 01E8 segm_f = 0;
; 0000 01E9 segm_g = 0;}
; 0000 01EA if(a == 8){
_0x7B:
	LDS  R26,_a
	CPI  R26,LOW(0x8)
	BRNE _0x7C
; 0000 01EB segm_a = 1;
	CALL SUBOPT_0x5
; 0000 01EC segm_b = 1;
; 0000 01ED segm_c = 1;
	CALL SUBOPT_0x6
; 0000 01EE segm_d = 1;
; 0000 01EF segm_e = 1;
	CALL SUBOPT_0x7
; 0000 01F0 segm_f = 1;
; 0000 01F1 segm_g = 1;}
	LDI  R30,LOW(1)
	STS  _segm_g,R30
; 0000 01F2 if(a == 9){
_0x7C:
	LDS  R26,_a
	CPI  R26,LOW(0x9)
	BRNE _0x7D
; 0000 01F3 segm_a = 1;
	CALL SUBOPT_0x5
; 0000 01F4 segm_b = 1;
; 0000 01F5 segm_c = 1;
	CALL SUBOPT_0x6
; 0000 01F6 segm_d = 1;
; 0000 01F7 segm_e = 0;
	CALL SUBOPT_0xE
; 0000 01F8 segm_f = 1;
; 0000 01F9 segm_g = 1;}
; 0000 01FA if(a ==10){
_0x7D:
	LDS  R26,_a
	CPI  R26,LOW(0xA)
	BRNE _0x7E
; 0000 01FB segm_a = 1;
	CALL SUBOPT_0x5
; 0000 01FC segm_b = 1;
; 0000 01FD segm_c = 1;
	CALL SUBOPT_0xF
; 0000 01FE segm_d = 0;
; 0000 01FF segm_e = 1;
	CALL SUBOPT_0x7
; 0000 0200 segm_f = 1;
; 0000 0201 segm_g = 1;}
	LDI  R30,LOW(1)
	STS  _segm_g,R30
; 0000 0202 if(a ==11){
_0x7E:
	LDS  R26,_a
	CPI  R26,LOW(0xB)
	BRNE _0x7F
; 0000 0203 segm_a = 0;
	CALL SUBOPT_0x11
; 0000 0204 segm_b = 0;
; 0000 0205 segm_c = 1;
	CALL SUBOPT_0x6
; 0000 0206 segm_d = 1;
; 0000 0207 segm_e = 1;
	CALL SUBOPT_0x7
; 0000 0208 segm_f = 1;
; 0000 0209 segm_g = 1;}
	LDI  R30,LOW(1)
	STS  _segm_g,R30
; 0000 020A if(a ==12){
_0x7F:
	LDS  R26,_a
	CPI  R26,LOW(0xC)
	BRNE _0x80
; 0000 020B segm_a = 0;
	CALL SUBOPT_0x11
; 0000 020C segm_b = 0;
; 0000 020D segm_c = 0;
	CALL SUBOPT_0xA
; 0000 020E segm_d = 1;
; 0000 020F segm_e = 1;
; 0000 0210 segm_f = 0;
; 0000 0211 segm_g = 1;}
; 0000 0212 if(a ==13){
_0x80:
	LDS  R26,_a
	CPI  R26,LOW(0xD)
	BRNE _0x81
; 0000 0213 segm_a = 1;
	CALL SUBOPT_0x12
; 0000 0214 segm_b = 0;
; 0000 0215 segm_c = 0;
; 0000 0216 segm_d = 1;
; 0000 0217 segm_e = 1;
; 0000 0218 segm_f = 1;
; 0000 0219 segm_g = 0;}
	LDI  R30,LOW(0)
	STS  _segm_g,R30
; 0000 021A if(a ==14){
_0x81:
	LDS  R26,_a
	CPI  R26,LOW(0xE)
	BRNE _0x82
; 0000 021B segm_a = 0;
	CALL SUBOPT_0x13
; 0000 021C segm_b = 1;
; 0000 021D segm_c = 1;
	CALL SUBOPT_0x6
; 0000 021E segm_d = 1;
; 0000 021F segm_e = 1;
	CALL SUBOPT_0x14
; 0000 0220 segm_f = 0;
; 0000 0221 segm_g = 1;}
; 0000 0222 if(a ==15){
_0x82:
	LDS  R26,_a
	CPI  R26,LOW(0xF)
	BRNE _0x83
; 0000 0223 segm_a = 1;
	CALL SUBOPT_0x12
; 0000 0224 segm_b = 0;
; 0000 0225 segm_c = 0;
; 0000 0226 segm_d = 1;
; 0000 0227 segm_e = 1;
; 0000 0228 segm_f = 1;
; 0000 0229 segm_g = 1;}
	LDI  R30,LOW(1)
	STS  _segm_g,R30
; 0000 022A if(a ==16){
_0x83:
	LDS  R26,_a
	CPI  R26,LOW(0x10)
	BRNE _0x84
; 0000 022B segm_a = 1;
	LDI  R30,LOW(1)
	STS  _segm_a,R30
; 0000 022C segm_b = 0;
	LDI  R30,LOW(0)
	STS  _segm_b,R30
; 0000 022D segm_c = 0;
	CALL SUBOPT_0x15
; 0000 022E segm_d = 0;
; 0000 022F segm_e = 1;
; 0000 0230 segm_f = 1;
; 0000 0231 segm_g = 1;}
	LDI  R30,LOW(1)
	STS  _segm_g,R30
; 0000 0232 if(a ==17){
_0x84:
	LDS  R26,_a
	CPI  R26,LOW(0x11)
	BRNE _0x85
; 0000 0233 segm_a = 0;
	CALL SUBOPT_0x13
; 0000 0234 segm_b = 1;
; 0000 0235 segm_c = 1;
	CALL SUBOPT_0xF
; 0000 0236 segm_d = 0;
; 0000 0237 segm_e = 1;
	CALL SUBOPT_0x7
; 0000 0238 segm_f = 1;
; 0000 0239 segm_g = 1;}
	LDI  R30,LOW(1)
	STS  _segm_g,R30
; 0000 023A if(a ==18){
_0x85:
	LDS  R26,_a
	CPI  R26,LOW(0x12)
	BRNE _0x86
; 0000 023B segm_a = 0;
	CALL SUBOPT_0x11
; 0000 023C segm_b = 0;
; 0000 023D segm_c = 1;
	CALL SUBOPT_0xF
; 0000 023E segm_d = 0;
; 0000 023F segm_e = 1;
	CALL SUBOPT_0x7
; 0000 0240 segm_f = 1;
; 0000 0241 segm_g = 1;}
	LDI  R30,LOW(1)
	STS  _segm_g,R30
; 0000 0242 if(a ==19){
_0x86:
	LDS  R26,_a
	CPI  R26,LOW(0x13)
	BRNE _0x87
; 0000 0243 segm_a = 0;
	CALL SUBOPT_0x8
; 0000 0244 segm_b = 1;
; 0000 0245 segm_c = 1;
; 0000 0246 segm_d = 0;
; 0000 0247 segm_e = 0;
; 0000 0248 segm_f = 0;
	CALL SUBOPT_0x9
; 0000 0249 segm_g = 0;}
; 0000 024A if(a ==20){
_0x87:
	LDS  R26,_a
	CPI  R26,LOW(0x14)
	BRNE _0x88
; 0000 024B segm_a = 0;
	CALL SUBOPT_0x11
; 0000 024C segm_b = 0;
; 0000 024D segm_c = 1;
	CALL SUBOPT_0xF
; 0000 024E segm_d = 0;
; 0000 024F segm_e = 0;
	CALL SUBOPT_0x10
; 0000 0250 segm_f = 0;
; 0000 0251 segm_g = 0;}
; 0000 0252 if(a ==21){
_0x88:
	LDS  R26,_a
	CPI  R26,LOW(0x15)
	BRNE _0x89
; 0000 0253 segm_a = 0;
	CALL SUBOPT_0x13
; 0000 0254 segm_b = 1;
; 0000 0255 segm_c = 1;
	CALL SUBOPT_0x6
; 0000 0256 segm_d = 1;
; 0000 0257 segm_e = 0;
	CALL SUBOPT_0x10
; 0000 0258 segm_f = 0;
; 0000 0259 segm_g = 0;}
; 0000 025A if(a ==22){
_0x89:
	LDS  R26,_a
	CPI  R26,LOW(0x16)
	BRNE _0x8A
; 0000 025B segm_a = 0;
	CALL SUBOPT_0x11
; 0000 025C segm_b = 0;
; 0000 025D segm_c = 0;
	CALL SUBOPT_0x16
; 0000 025E segm_d = 1;
; 0000 025F segm_e = 1;
; 0000 0260 segm_f = 1;
; 0000 0261 segm_g = 0;}
	LDI  R30,LOW(0)
	STS  _segm_g,R30
; 0000 0262 if(a ==23){
_0x8A:
	LDS  R26,_a
	CPI  R26,LOW(0x17)
	BRNE _0x8B
; 0000 0263 segm_a = 0;
	CALL SUBOPT_0x11
; 0000 0264 segm_b = 0;
; 0000 0265 segm_c = 1;
	CALL SUBOPT_0x6
; 0000 0266 segm_d = 1;
; 0000 0267 segm_e = 1;
	CALL SUBOPT_0x14
; 0000 0268 segm_f = 0;
; 0000 0269 segm_g = 1;}
; 0000 026A if(a ==24){
_0x8B:
	LDS  R26,_a
	CPI  R26,LOW(0x18)
	BRNE _0x8C
; 0000 026B segm_a = 1;
	CALL SUBOPT_0x5
; 0000 026C segm_b = 1;
; 0000 026D segm_c = 0;
	CALL SUBOPT_0x15
; 0000 026E segm_d = 0;
; 0000 026F segm_e = 1;
; 0000 0270 segm_f = 1;
; 0000 0271 segm_g = 1;}
	LDI  R30,LOW(1)
	STS  _segm_g,R30
; 0000 0272 if(a ==25){
_0x8C:
	LDS  R26,_a
	CPI  R26,LOW(0x19)
	BRNE _0x8D
; 0000 0273 segm_a = 1;
	CALL SUBOPT_0xD
; 0000 0274 segm_b = 0;
; 0000 0275 segm_c = 1;
; 0000 0276 segm_d = 1;
; 0000 0277 segm_e = 0;
	CALL SUBOPT_0xE
; 0000 0278 segm_f = 1;
; 0000 0279 segm_g = 1;}
; 0000 027A if(a ==26){
_0x8D:
	LDS  R26,_a
	CPI  R26,LOW(0x1A)
	BRNE _0x8E
; 0000 027B segm_a = 0;
	CALL SUBOPT_0x11
; 0000 027C segm_b = 0;
; 0000 027D segm_c = 0;
	CALL SUBOPT_0x16
; 0000 027E segm_d = 1;
; 0000 027F segm_e = 1;
; 0000 0280 segm_f = 1;
; 0000 0281 segm_g = 1;}
	LDI  R30,LOW(1)
	STS  _segm_g,R30
; 0000 0282 if(a ==27){
_0x8E:
	LDS  R26,_a
	CPI  R26,LOW(0x1B)
	BRNE _0x8F
; 0000 0283 segm_a = 0;
	CALL SUBOPT_0x11
; 0000 0284 segm_b = 0;
; 0000 0285 segm_c = 1;
	CALL SUBOPT_0x6
; 0000 0286 segm_d = 1;
; 0000 0287 segm_e = 1;
	LDI  R30,LOW(1)
	STS  _segm_e,R30
; 0000 0288 segm_f = 0;
	CALL SUBOPT_0x9
; 0000 0289 segm_g = 0;}
; 0000 028A if(a ==28){
_0x8F:
	LDS  R26,_a
	CPI  R26,LOW(0x1C)
	BRNE _0x90
; 0000 028B segm_a = 0;
	CALL SUBOPT_0x13
; 0000 028C segm_b = 1;
; 0000 028D segm_c = 1;
	CALL SUBOPT_0x6
; 0000 028E segm_d = 1;
; 0000 028F segm_e = 1;
	CALL SUBOPT_0x7
; 0000 0290 segm_f = 1;
; 0000 0291 segm_g = 0;}
	LDI  R30,LOW(0)
	STS  _segm_g,R30
; 0000 0292 if(a ==29){
_0x90:
	LDS  R26,_a
	CPI  R26,LOW(0x1D)
	BRNE _0x91
; 0000 0293 segm_a = 1;
	CALL SUBOPT_0x5
; 0000 0294 segm_b = 1;
; 0000 0295 segm_c = 0;
	CALL SUBOPT_0xA
; 0000 0296 segm_d = 1;
; 0000 0297 segm_e = 1;
; 0000 0298 segm_f = 0;
; 0000 0299 segm_g = 1;}
; 0000 029A if(a ==30){
_0x91:
	LDS  R26,_a
	CPI  R26,LOW(0x1E)
	BRNE _0x92
; 0000 029B segm_a = 0;
	CALL SUBOPT_0x11
; 0000 029C segm_b = 0;
; 0000 029D segm_c = 0;
	CALL SUBOPT_0x17
; 0000 029E segm_d = 0;
; 0000 029F segm_e = 1;
	CALL SUBOPT_0x14
; 0000 02A0 segm_f = 0;
; 0000 02A1 segm_g = 1;}
; 0000 02A2 if(a ==31){
_0x92:
	LDS  R26,_a
	CPI  R26,LOW(0x1F)
	BRNE _0x93
; 0000 02A3 segm_a = 0;
	CALL SUBOPT_0x11
; 0000 02A4 segm_b = 0;
; 0000 02A5 segm_c = 0;
	LDI  R30,LOW(0)
	STS  _segm_c,R30
; 0000 02A6 segm_d = 1;
	LDI  R30,LOW(1)
	STS  _segm_d,R30
; 0000 02A7 segm_e = 0;
	CALL SUBOPT_0x10
; 0000 02A8 segm_f = 0;
; 0000 02A9 segm_g = 0;}
; 0000 02AA if(a ==32){
_0x93:
	LDS  R26,_a
	CPI  R26,LOW(0x20)
	BRNE _0x94
; 0000 02AB segm_a = 0;
	CALL SUBOPT_0x11
; 0000 02AC segm_b = 0;
; 0000 02AD segm_c = 0;
	CALL SUBOPT_0x17
; 0000 02AE segm_d = 0;
; 0000 02AF segm_e = 0;
	CALL SUBOPT_0xB
; 0000 02B0 segm_f = 0;
; 0000 02B1 segm_g = 1;}
; 0000 02B2 if(a ==33){
_0x94:
	LDS  R26,_a
	CPI  R26,LOW(0x21)
	BRNE _0x95
; 0000 02B3 segm_a = 0;
	CALL SUBOPT_0x11
; 0000 02B4 segm_b = 0;
; 0000 02B5 segm_c = 0;
	CALL SUBOPT_0x17
; 0000 02B6 segm_d = 0;
; 0000 02B7 segm_e = 0;
	CALL SUBOPT_0x10
; 0000 02B8 segm_f = 0;
; 0000 02B9 segm_g = 0;}
; 0000 02BA if(a ==34){
_0x95:
	LDS  R26,_a
	CPI  R26,LOW(0x22)
	BRNE _0x96
; 0000 02BB segm_a = 0;
	CALL SUBOPT_0x11
; 0000 02BC segm_b = 0;
; 0000 02BD segm_c = 1;
	CALL SUBOPT_0xF
; 0000 02BE segm_d = 0;
; 0000 02BF segm_e = 1;
	CALL SUBOPT_0x14
; 0000 02C0 segm_f = 0;
; 0000 02C1 segm_g = 1;}}
_0x96:
	RET
;
;
;
;void padeciu_medis(){
; 0000 02C5 void padeciu_medis(){
_padeciu_medis:
; 0000 02C6 
; 0000 02C7 if(MYGTUKAS_7==1){
	LDS  R26,_MYGTUKAS_7
	CPI  R26,LOW(0x1)
	BRNE _0x97
; 0000 02C8 MYGTUKAS_7 = 0;
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_7,R30
; 0000 02C9 x = 0;
	CLR  R4
; 0000 02CA y = 0;}
	CLR  R7
; 0000 02CB 
; 0000 02CC if(x==0){
_0x97:
	TST  R4
	BRNE _0x98
; 0000 02CD 
; 0000 02CE if(y==0){
	TST  R7
	BRNE _0x99
; 0000 02CF dabartinis_laikas();}
	RCALL _dabartinis_laikas
; 0000 02D0 if(y==1){
_0x99:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x9A
; 0000 02D1 sekundes_trukmes_keitimas();}}
	RCALL _sekundes_trukmes_keitimas
_0x9A:
; 0000 02D2 
; 0000 02D3 
; 0000 02D4 if(x==1){
_0x98:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x9B
; 0000 02D5 
; 0000 02D6 if(y==0){
	TST  R7
	BRNE _0x9C
; 0000 02D7 kondensatoriaus_busena();}}
	RCALL _kondensatoriaus_busena
_0x9C:
; 0000 02D8 
; 0000 02D9 
; 0000 02DA if(REDAGAVIMAS==0){
_0x9B:
	LDS  R30,_REDAGAVIMAS
	CPI  R30,0
	BRNE _0x9D
; 0000 02DB if(MYGTUKAS_1==1){
	LDS  R26,_MYGTUKAS_1
	CPI  R26,LOW(0x1)
	BRNE _0x9E
; 0000 02DC if((x==0)&&(y==0)){    //kordinates kurios leidzia padidinti y
	LDI  R30,LOW(0)
	CP   R30,R4
	BRNE _0xA0
	CP   R30,R7
	BREQ _0xA1
_0xA0:
	RJMP _0x9F
_0xA1:
; 0000 02DD y = y + 1;}}
	INC  R7
_0x9F:
; 0000 02DE if(MYGTUKAS_5==1){
_0x9E:
	LDS  R26,_MYGTUKAS_5
	CPI  R26,LOW(0x1)
	BRNE _0xA2
; 0000 02DF if((x==0)&&(y==1)){    //kordinates kurios leidzia sumazinti y
	LDI  R30,LOW(0)
	CP   R30,R4
	BRNE _0xA4
	LDI  R30,LOW(1)
	CP   R30,R7
	BREQ _0xA5
_0xA4:
	RJMP _0xA3
_0xA5:
; 0000 02E0 y = y - 1;}}
	MOV  R30,R7
	CALL SUBOPT_0x18
	MOV  R7,R30
_0xA3:
; 0000 02E1 if(MYGTUKAS_4==1){
_0xA2:
	LDS  R26,_MYGTUKAS_4
	CPI  R26,LOW(0x1)
	BRNE _0xA6
; 0000 02E2 if((x==0)&&(y==0)){    //kordinates kurios leidzia padidinti x
	LDI  R30,LOW(0)
	CP   R30,R4
	BRNE _0xA8
	CP   R30,R7
	BREQ _0xA9
_0xA8:
	RJMP _0xA7
_0xA9:
; 0000 02E3 x = x + 1;}}
	INC  R4
_0xA7:
; 0000 02E4 if(MYGTUKAS_2==1){
_0xA6:
	LDS  R26,_MYGTUKAS_2
	CPI  R26,LOW(0x1)
	BRNE _0xAA
; 0000 02E5 if((x==1)&&(y==0)){    //kordinates kurios leidzia sumazinti x
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0xAC
	LDI  R30,LOW(0)
	CP   R30,R7
	BREQ _0xAD
_0xAC:
	RJMP _0xAB
_0xAD:
; 0000 02E6 x = x - 1;}}
	MOV  R30,R4
	CALL SUBOPT_0x18
	MOV  R4,R30
_0xAB:
; 0000 02E7 MYGTUKAS_1 = 0;
_0xAA:
	CALL SUBOPT_0x0
; 0000 02E8 MYGTUKAS_2 = 0;
; 0000 02E9 MYGTUKAS_4 = 0;
	STS  _MYGTUKAS_4,R30
; 0000 02EA MYGTUKAS_5 = 0;}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_5,R30
; 0000 02EB 
; 0000 02EC 
; 0000 02ED 
; 0000 02EE }                      //kordinates kuriose negalima redaguoti
_0x9D:
	RET
;
;
;// +
;void blyksintis_skaicius(){
; 0000 02F2 void blyksintis_skaicius(){
_blyksintis_skaicius:
; 0000 02F3 blyksincio_skaiciaus_laiko_paskutinis_ciklas = PUSE_SEKUNDES;
	__PUTWMRN _blyksincio_skaiciaus_laiko_paskutinis_ciklas,0,10,11
; 0000 02F4 if(REDAGAVIMAS==1){
	LDS  R26,_REDAGAVIMAS
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0xAE
; 0000 02F5 blyksincio_skaiciaus_laikas = blyksincio_skaiciaus_laikas + 1;
	LDS  R30,_blyksincio_skaiciaus_laikas
	LDS  R31,_blyksincio_skaiciaus_laikas+1
	ADIW R30,1
	STS  _blyksincio_skaiciaus_laikas,R30
	STS  _blyksincio_skaiciaus_laikas+1,R31
; 0000 02F6 
; 0000 02F7 if(blyksincio_skaiciaus_laikas>=
; 0000 02F8 blyksincio_skaiciaus_laiko_paskutinis_ciklas){
	LDS  R30,_blyksincio_skaiciaus_laiko_paskutinis_ciklas
	LDS  R31,_blyksincio_skaiciaus_laiko_paskutinis_ciklas+1
	LDS  R26,_blyksincio_skaiciaus_laikas
	LDS  R27,_blyksincio_skaiciaus_laikas+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0xAF
; 0000 02F9 blyksincio_skaiciaus_laikas = 0;}
	LDI  R30,LOW(0)
	STS  _blyksincio_skaiciaus_laikas,R30
	STS  _blyksincio_skaiciaus_laikas+1,R30
; 0000 02FA 
; 0000 02FB 
; 0000 02FC blyksincio_skaiciaus_laiko_vidurinysis_ciklas =
_0xAF:
; 0000 02FD blyksincio_skaiciaus_laiko_paskutinis_ciklas / 2;
	LDS  R30,_blyksincio_skaiciaus_laiko_paskutinis_ciklas
	LDS  R31,_blyksincio_skaiciaus_laiko_paskutinis_ciklas+1
	LSR  R31
	ROR  R30
	STS  _blyksincio_skaiciaus_laiko_vidurinysis_ciklas,R30
	STS  _blyksincio_skaiciaus_laiko_vidurinysis_ciklas+1,R31
; 0000 02FE 
; 0000 02FF SKAICIUS_DEGA = blyksincio_skaiciaus_laikas /
; 0000 0300 blyksincio_skaiciaus_laiko_vidurinysis_ciklas;
	LDS  R26,_blyksincio_skaiciaus_laikas
	LDS  R27,_blyksincio_skaiciaus_laikas+1
	CALL __DIVW21U
	STS  _SKAICIUS_DEGA,R30
; 0000 0301 
; 0000 0302 if(SKAICIUS_DEGA==0){
	CPI  R30,0
	BREQ PC+3
	JMP _0xB0
; 0000 0303 if(z==-4){
	LDI  R30,LOW(252)
	CP   R30,R6
	BRNE _0xB1
; 0000 0304 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0xB2
; 0000 0305 a = 33;}}
	LDI  R30,LOW(33)
	STS  _a,R30
_0xB2:
; 0000 0306 if(z==-3){
_0xB1:
	LDI  R30,LOW(253)
	CP   R30,R6
	BRNE _0xB3
; 0000 0307 if(OSC==4){
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0xB4
; 0000 0308 a = 33;}}
	LDI  R30,LOW(33)
	STS  _a,R30
_0xB4:
; 0000 0309 if(z==-2){
_0xB3:
	LDI  R30,LOW(254)
	CP   R30,R6
	BRNE _0xB5
; 0000 030A if(OSC==8){
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0xB6
; 0000 030B a = 33;}}
	LDI  R30,LOW(33)
	STS  _a,R30
_0xB6:
; 0000 030C if(z==-1){
_0xB5:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0xB7
; 0000 030D if(OSC==12){
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0xB8
; 0000 030E a = 33;}}
	LDI  R30,LOW(33)
	STS  _a,R30
_0xB8:
; 0000 030F if(z==0){
_0xB7:
	TST  R6
	BRNE _0xB9
; 0000 0310 if(OSC==16){
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0xBA
; 0000 0311 a = 33;}}
	LDI  R30,LOW(33)
	STS  _a,R30
_0xBA:
; 0000 0312 if(z==1){
_0xB9:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0xBB
; 0000 0313 if(OSC==20){
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0xBC
; 0000 0314 a = 33;}}
	LDI  R30,LOW(33)
	STS  _a,R30
_0xBC:
; 0000 0315 if(z==2){
_0xBB:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0xBD
; 0000 0316 if(OSC==24){
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0xBE
; 0000 0317 a = 33;}}
	LDI  R30,LOW(33)
	STS  _a,R30
_0xBE:
; 0000 0318 if(z==3){
_0xBD:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0xBF
; 0000 0319 if(OSC==28){
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0xC0
; 0000 031A a = 33;}}}}}
	LDI  R30,LOW(33)
	STS  _a,R30
_0xC0:
_0xBF:
_0xB0:
_0xAE:
	RET
;
;
;
;void outputai(){
; 0000 031E void outputai(){
_outputai:
; 0000 031F {if(segm_a==1){
	LDS  R26,_segm_a
	CPI  R26,LOW(0x1)
	BRNE _0xC1
; 0000 0320 PORTC.6 = 0;}
	CBI  0x15,6
; 0000 0321 else
	RJMP _0xC4
_0xC1:
; 0000 0322 PORTC.6 = 1;}
	SBI  0x15,6
_0xC4:
; 0000 0323 {if(segm_b==1){
	LDS  R26,_segm_b
	CPI  R26,LOW(0x1)
	BRNE _0xC7
; 0000 0324 PORTC.0 = 0;}
	CBI  0x15,0
; 0000 0325 else
	RJMP _0xCA
_0xC7:
; 0000 0326 PORTC.0 = 1;}
	SBI  0x15,0
_0xCA:
; 0000 0327 {if(segm_c==1){
	LDS  R26,_segm_c
	CPI  R26,LOW(0x1)
	BRNE _0xCD
; 0000 0328 PORTC.2 = 0;}
	CBI  0x15,2
; 0000 0329 else
	RJMP _0xD0
_0xCD:
; 0000 032A PORTC.2 = 1;}
	SBI  0x15,2
_0xD0:
; 0000 032B {if(segm_d==1){
	LDS  R26,_segm_d
	CPI  R26,LOW(0x1)
	BRNE _0xD3
; 0000 032C PORTC.4 = 0;}
	CBI  0x15,4
; 0000 032D else
	RJMP _0xD6
_0xD3:
; 0000 032E PORTC.4 = 1;}
	SBI  0x15,4
_0xD6:
; 0000 032F {if(segm_e==1){
	LDS  R26,_segm_e
	CPI  R26,LOW(0x1)
	BRNE _0xD9
; 0000 0330 PORTC.5 = 0;}
	CBI  0x15,5
; 0000 0331 else
	RJMP _0xDC
_0xD9:
; 0000 0332 PORTC.5 = 1;}
	SBI  0x15,5
_0xDC:
; 0000 0333 {if(segm_f==1){
	LDS  R26,_segm_f
	CPI  R26,LOW(0x1)
	BRNE _0xDF
; 0000 0334 PORTC.7 = 0;}
	CBI  0x15,7
; 0000 0335 else
	RJMP _0xE2
_0xDF:
; 0000 0336 PORTC.7 = 1;}
	SBI  0x15,7
_0xE2:
; 0000 0337 {if(segm_g==1){
	LDS  R26,_segm_g
	CPI  R26,LOW(0x1)
	BRNE _0xE5
; 0000 0338 PORTC.1 = 0;}
	CBI  0x15,1
; 0000 0339 else
	RJMP _0xE8
_0xE5:
; 0000 033A PORTC.1 = 1;}
	SBI  0x15,1
_0xE8:
; 0000 033B {if(segm_h==1){
	LDS  R26,_segm_h
	CPI  R26,LOW(0x1)
	BRNE _0xEB
; 0000 033C PORTC.3 = 0;}
	CBI  0x15,3
; 0000 033D else
	RJMP _0xEE
_0xEB:
; 0000 033E PORTC.3 = 1;}
	SBI  0x15,3
_0xEE:
; 0000 033F 
; 0000 0340 a = 40;
	LDI  R30,LOW(40)
	STS  _a,R30
; 0000 0341 segm_a = 0;
	CALL SUBOPT_0x11
; 0000 0342 segm_b = 0;
; 0000 0343 segm_c = 0;
	CALL SUBOPT_0x17
; 0000 0344 segm_d = 0;
; 0000 0345 segm_e = 0;
	CALL SUBOPT_0x10
; 0000 0346 segm_f = 0;
; 0000 0347 segm_g = 0;
; 0000 0348 segm_h = 0;
	LDI  R30,LOW(0)
	STS  _segm_h,R30
; 0000 0349 
; 0000 034A PORTA.1 = 0;   // A
	CBI  0x1B,1
; 0000 034B PORTA.4 = 0;   // B
	CBI  0x1B,4
; 0000 034C PORTA.3 = 0;   // C
	CBI  0x1B,3
; 0000 034D PORTA.2 = 0;   // D
	CBI  0x1B,2
; 0000 034E 
; 0000 034F if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0xF9
; 0000 0350 PORTA.1 = 0;
	CBI  0x1B,1
; 0000 0351 PORTA.4 = 0;
	CBI  0x1B,4
; 0000 0352 PORTA.3 = 1;
	SBI  0x1B,3
; 0000 0353 PORTA.2 = 0;}
	CBI  0x1B,2
; 0000 0354 if(OSC==4){
_0xF9:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x102
; 0000 0355 PORTA.1 = 1;
	SBI  0x1B,1
; 0000 0356 PORTA.4 = 1;
	SBI  0x1B,4
; 0000 0357 PORTA.3 = 0;
	CBI  0x1B,3
; 0000 0358 PORTA.2 = 0;}
	CBI  0x1B,2
; 0000 0359 if(OSC==8){
_0x102:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x10B
; 0000 035A PORTA.1 = 1;
	SBI  0x1B,1
; 0000 035B PORTA.4 = 1;
	SBI  0x1B,4
; 0000 035C PORTA.3 = 1;
	SBI  0x1B,3
; 0000 035D PORTA.2 = 0;}
	CBI  0x1B,2
; 0000 035E if(OSC==12){
_0x10B:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x114
; 0000 035F PORTA.1 = 0;
	CBI  0x1B,1
; 0000 0360 PORTA.4 = 1;
	SBI  0x1B,4
; 0000 0361 PORTA.3 = 0;
	CBI  0x1B,3
; 0000 0362 PORTA.2 = 0;}
	CBI  0x1B,2
; 0000 0363 if(OSC==16){
_0x114:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x11D
; 0000 0364 PORTA.1 = 0;
	CBI  0x1B,1
; 0000 0365 PORTA.4 = 1;
	SBI  0x1B,4
; 0000 0366 PORTA.3 = 1;
	SBI  0x1B,3
; 0000 0367 PORTA.2 = 0;}
	CBI  0x1B,2
; 0000 0368 if(OSC==20){
_0x11D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x126
; 0000 0369 PORTA.1 = 1;
	SBI  0x1B,1
; 0000 036A PORTA.4 = 0;
	CBI  0x1B,4
; 0000 036B PORTA.3 = 0;
	CBI  0x1B,3
; 0000 036C PORTA.2 = 0;}
	CBI  0x1B,2
; 0000 036D if(OSC==24){
_0x126:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x12F
; 0000 036E PORTA.1 = 1;
	SBI  0x1B,1
; 0000 036F PORTA.4 = 0;
	CBI  0x1B,4
; 0000 0370 PORTA.3 = 1;
	SBI  0x1B,3
; 0000 0371 PORTA.2 = 0;}
	CBI  0x1B,2
; 0000 0372 if(OSC==28){
_0x12F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x138
; 0000 0373 PORTA.1 = 0;
	CBI  0x1B,1
; 0000 0374 PORTA.4 = 0;
	CBI  0x1B,4
; 0000 0375 PORTA.3 = 0;
	CBI  0x1B,3
; 0000 0376 PORTA.2 = 1;}
	SBI  0x1B,2
; 0000 0377 
; 0000 0378 {if((pfet_kairysis==1)&&(PORTB.4==0)){
_0x138:
	LDS  R26,_pfet_kairysis
	CPI  R26,LOW(0x1)
	BRNE _0x142
	LDI  R26,0
	SBIC 0x18,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x143
_0x142:
	RJMP _0x141
_0x143:
; 0000 0379 PORTB.4 = 0;
	CBI  0x18,4
; 0000 037A PORTB.1 = 1;}
	SBI  0x18,1
; 0000 037B else
	RJMP _0x148
_0x141:
; 0000 037C PORTB.1 = 0;}
	CBI  0x18,1
_0x148:
; 0000 037D {if((pfet_desinysis==1)&&(PORTB.3==0)){
	LDS  R26,_pfet_desinysis
	CPI  R26,LOW(0x1)
	BRNE _0x14C
	LDI  R26,0
	SBIC 0x18,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x14D
_0x14C:
	RJMP _0x14B
_0x14D:
; 0000 037E PORTB.3 = 0;
	CBI  0x18,3
; 0000 037F PORTB.2 = 1;}
	SBI  0x18,2
; 0000 0380 else
	RJMP _0x152
_0x14B:
; 0000 0381 PORTB.2 = 0;}
	CBI  0x18,2
_0x152:
; 0000 0382 {if((nfet_desinysis==1)&&(PORTB.2==0)){
	LDS  R26,_nfet_desinysis
	CPI  R26,LOW(0x1)
	BRNE _0x156
	LDI  R26,0
	SBIC 0x18,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x157
_0x156:
	RJMP _0x155
_0x157:
; 0000 0383 PORTB.2 = 0;
	CBI  0x18,2
; 0000 0384 PORTB.3 = 1;}
	SBI  0x18,3
; 0000 0385 else
	RJMP _0x15C
_0x155:
; 0000 0386 PORTB.3 = 0;}
	CBI  0x18,3
_0x15C:
; 0000 0387 {if((nfet_kairysis==1)&&(PORTB.1==0)){
	LDS  R26,_nfet_kairysis
	CPI  R26,LOW(0x1)
	BRNE _0x160
	LDI  R26,0
	SBIC 0x18,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x161
_0x160:
	RJMP _0x15F
_0x161:
; 0000 0388 PORTB.1 = 0;
	CBI  0x18,1
; 0000 0389 PORTB.4 = 1;}
	SBI  0x18,4
; 0000 038A else
	RJMP _0x166
_0x15F:
; 0000 038B PORTB.4 = 0;}}
	CBI  0x18,4
_0x166:
	RET
;
;
;// +
;void dabartinis_laikas(){
; 0000 038F void dabartinis_laikas(){
_dabartinis_laikas:
; 0000 0390 if((MYGTUKAS_6==1)&&(REDAGAVIMAS==0)){
	LDS  R26,_MYGTUKAS_6
	CPI  R26,LOW(0x1)
	BRNE _0x16A
	LDS  R26,_REDAGAVIMAS
	CPI  R26,LOW(0x0)
	BREQ _0x16B
_0x16A:
	RJMP _0x169
_0x16B:
; 0000 0391 REDAGAVIMAS = 1;
	CALL SUBOPT_0x19
; 0000 0392 MYGTUKAS_6 = 0;
; 0000 0393 z = 0;}
	CLR  R6
; 0000 0394 if(((MYGTUKAS_6==1)||(MYGTUKAS_3==1))&&(REDAGAVIMAS==1)){
_0x169:
	LDS  R26,_MYGTUKAS_6
	CPI  R26,LOW(0x1)
	BREQ _0x16D
	LDS  R26,_MYGTUKAS_3
	CPI  R26,LOW(0x1)
	BRNE _0x16F
_0x16D:
	LDS  R26,_REDAGAVIMAS
	CPI  R26,LOW(0x1)
	BREQ _0x170
_0x16F:
	RJMP _0x16C
_0x170:
; 0000 0395 REDAGAVIMAS = 0;}
	LDI  R30,LOW(0)
	STS  _REDAGAVIMAS,R30
; 0000 0396 MYGTUKAS_6 = 0;
_0x16C:
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_6,R30
; 0000 0397 
; 0000 0398 if(REDAGAVIMAS==1){
	LDS  R26,_REDAGAVIMAS
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x171
; 0000 0399 viena_laikrodzio_sekunde = 0;
	STS  _viena_laikrodzio_sekunde,R30
	STS  _viena_laikrodzio_sekunde+1,R30
; 0000 039A laikrodzio_sekundes = 0;
	STS  _laikrodzio_sekundes,R30
; 0000 039B 
; 0000 039C if(MYGTUKAS_2==1){
	LDS  R26,_MYGTUKAS_2
	CPI  R26,LOW(0x1)
	BRNE _0x172
; 0000 039D z = z - 1;
	MOV  R30,R6
	CALL SUBOPT_0x18
	MOV  R6,R30
; 0000 039E MYGTUKAS_2 = 0;}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_2,R30
; 0000 039F if(MYGTUKAS_4==1){
_0x172:
	LDS  R26,_MYGTUKAS_4
	CPI  R26,LOW(0x1)
	BRNE _0x173
; 0000 03A0 z = z + 1;}
	INC  R6
; 0000 03A1 if(z<0){
_0x173:
	LDI  R30,LOW(0)
	CP   R6,R30
	BRGE _0x174
; 0000 03A2 z = 3;}
	LDI  R30,LOW(3)
	MOV  R6,R30
; 0000 03A3 if(z>3){
_0x174:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRGE _0x175
; 0000 03A4 z = 0;}
	CLR  R6
; 0000 03A5 
; 0000 03A6 if(z==0){
_0x175:
	TST  R6
	BRNE _0x176
; 0000 03A7 if(MYGTUKAS_1==1){
	LDS  R26,_MYGTUKAS_1
	CPI  R26,LOW(0x1)
	BRNE _0x177
; 0000 03A8 laikrodzio_valandos = laikrodzio_valandos + 10;
	LDS  R30,_laikrodzio_valandos
	SUBI R30,-LOW(10)
	STS  _laikrodzio_valandos,R30
; 0000 03A9 MYGTUKAS_1 = 0;}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_1,R30
; 0000 03AA if(MYGTUKAS_5==1){
_0x177:
	LDS  R26,_MYGTUKAS_5
	CPI  R26,LOW(0x1)
	BRNE _0x178
; 0000 03AB laikrodzio_valandos = laikrodzio_valandos - 10;
	LDS  R30,_laikrodzio_valandos
	LDI  R31,0
	SBRC R30,7
	SER  R31
	SBIW R30,10
	STS  _laikrodzio_valandos,R30
; 0000 03AC MYGTUKAS_5 = 0;}}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_5,R30
_0x178:
; 0000 03AD 
; 0000 03AE if(z==1){
_0x176:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x179
; 0000 03AF if(MYGTUKAS_1==1){
	LDS  R26,_MYGTUKAS_1
	CPI  R26,LOW(0x1)
	BRNE _0x17A
; 0000 03B0 laikrodzio_valandos = laikrodzio_valandos + 1;
	LDS  R30,_laikrodzio_valandos
	SUBI R30,-LOW(1)
	STS  _laikrodzio_valandos,R30
; 0000 03B1 MYGTUKAS_1 = 0;}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_1,R30
; 0000 03B2 if(MYGTUKAS_5==1){
_0x17A:
	LDS  R26,_MYGTUKAS_5
	CPI  R26,LOW(0x1)
	BRNE _0x17B
; 0000 03B3 laikrodzio_valandos = laikrodzio_valandos - 1;
	LDS  R30,_laikrodzio_valandos
	CALL SUBOPT_0x18
	STS  _laikrodzio_valandos,R30
; 0000 03B4 MYGTUKAS_5 = 0;}}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_5,R30
_0x17B:
; 0000 03B5 
; 0000 03B6 if(z==2){
_0x179:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x17C
; 0000 03B7 if(MYGTUKAS_1==1){
	LDS  R26,_MYGTUKAS_1
	CPI  R26,LOW(0x1)
	BRNE _0x17D
; 0000 03B8 laikrodzio_minutes = laikrodzio_minutes + 10;
	LDS  R30,_laikrodzio_minutes
	SUBI R30,-LOW(10)
	STS  _laikrodzio_minutes,R30
; 0000 03B9 MYGTUKAS_1 = 0;}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_1,R30
; 0000 03BA if(MYGTUKAS_5==1){
_0x17D:
	LDS  R26,_MYGTUKAS_5
	CPI  R26,LOW(0x1)
	BRNE _0x17E
; 0000 03BB laikrodzio_minutes = laikrodzio_minutes - 10;
	LDS  R30,_laikrodzio_minutes
	LDI  R31,0
	SBRC R30,7
	SER  R31
	SBIW R30,10
	STS  _laikrodzio_minutes,R30
; 0000 03BC MYGTUKAS_5 = 0;}}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_5,R30
_0x17E:
; 0000 03BD 
; 0000 03BE if(z==3){
_0x17C:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x17F
; 0000 03BF if(MYGTUKAS_1==1){
	LDS  R26,_MYGTUKAS_1
	CPI  R26,LOW(0x1)
	BRNE _0x180
; 0000 03C0 laikrodzio_minutes = laikrodzio_minutes + 1;
	LDS  R30,_laikrodzio_minutes
	SUBI R30,-LOW(1)
	STS  _laikrodzio_minutes,R30
; 0000 03C1 MYGTUKAS_1 = 0;}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_1,R30
; 0000 03C2 if(MYGTUKAS_5==1){
_0x180:
	LDS  R26,_MYGTUKAS_5
	CPI  R26,LOW(0x1)
	BRNE _0x181
; 0000 03C3 laikrodzio_minutes = laikrodzio_minutes - 1;
	LDS  R30,_laikrodzio_minutes
	CALL SUBOPT_0x18
	STS  _laikrodzio_minutes,R30
; 0000 03C4 MYGTUKAS_5 = 0;}}}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_5,R30
_0x181:
_0x17F:
; 0000 03C5 
; 0000 03C6 
; 0000 03C7 
; 0000 03C8 
; 0000 03C9 
; 0000 03CA begancio_uzraso_DABAR_laikas =
_0x171:
; 0000 03CB begancio_uzraso_DABAR_laikas + 1;
	LDS  R30,_begancio_uzraso_DABAR_laikas
	LDS  R31,_begancio_uzraso_DABAR_laikas+1
	ADIW R30,1
	STS  _begancio_uzraso_DABAR_laikas,R30
	STS  _begancio_uzraso_DABAR_laikas+1,R31
; 0000 03CC 
; 0000 03CD if(begancio_uzraso_DABAR_laikas>=
; 0000 03CE PUSE_SEKUNDES){
	LDS  R26,_begancio_uzraso_DABAR_laikas
	LDS  R27,_begancio_uzraso_DABAR_laikas+1
	CP   R26,R10
	CPC  R27,R11
	BRLO _0x182
; 0000 03CF begancio_uzraso_DABAR_laikas = 0;
	LDI  R30,LOW(0)
	STS  _begancio_uzraso_DABAR_laikas,R30
	STS  _begancio_uzraso_DABAR_laikas+1,R30
; 0000 03D0 begancio_uzraso_DABAR_padetis =
; 0000 03D1 begancio_uzraso_DABAR_padetis + 1;}
	LDS  R30,_begancio_uzraso_DABAR_padetis
	SUBI R30,-LOW(1)
	STS  _begancio_uzraso_DABAR_padetis,R30
; 0000 03D2 
; 0000 03D3 if(begancio_uzraso_DABAR_padetis>=10){
_0x182:
	LDS  R26,_begancio_uzraso_DABAR_padetis
	CPI  R26,LOW(0xA)
	BRLO _0x183
; 0000 03D4 begancio_uzraso_DABAR_padetis = 0;}
	LDI  R30,LOW(0)
	STS  _begancio_uzraso_DABAR_padetis,R30
; 0000 03D5 
; 0000 03D6 
; 0000 03D7 if(begancio_uzraso_DABAR_padetis==1){
_0x183:
	LDS  R26,_begancio_uzraso_DABAR_padetis
	CPI  R26,LOW(0x1)
	BRNE _0x184
; 0000 03D8 if(OSC==12){
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x185
; 0000 03D9 a = 14;}}
	LDI  R30,LOW(14)
	STS  _a,R30
_0x185:
; 0000 03DA if(begancio_uzraso_DABAR_padetis==2){
_0x184:
	LDS  R26,_begancio_uzraso_DABAR_padetis
	CPI  R26,LOW(0x2)
	BRNE _0x186
; 0000 03DB if(OSC==8){
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x187
; 0000 03DC a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 03DD if(OSC==12){
_0x187:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x188
; 0000 03DE a = 10;}}
	LDI  R30,LOW(10)
	STS  _a,R30
_0x188:
; 0000 03DF if(begancio_uzraso_DABAR_padetis==3){
_0x186:
	LDS  R26,_begancio_uzraso_DABAR_padetis
	CPI  R26,LOW(0x3)
	BRNE _0x189
; 0000 03E0 if(OSC==4){
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x18A
; 0000 03E1 a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 03E2 if(OSC==8){
_0x18A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x18B
; 0000 03E3 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 03E4 if(OSC==12){
_0x18B:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x18C
; 0000 03E5 a = 11;}}
	LDI  R30,LOW(11)
	STS  _a,R30
_0x18C:
; 0000 03E6 if(begancio_uzraso_DABAR_padetis==4){
_0x189:
	LDS  R26,_begancio_uzraso_DABAR_padetis
	CPI  R26,LOW(0x4)
	BRNE _0x18D
; 0000 03E7 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x18E
; 0000 03E8 a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 03E9 if(OSC==4){
_0x18E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x18F
; 0000 03EA a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 03EB if(OSC==8){
_0x18F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x190
; 0000 03EC a = 11;}
	LDI  R30,LOW(11)
	STS  _a,R30
; 0000 03ED if(OSC==12){
_0x190:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x191
; 0000 03EE a = 10;}}
	LDI  R30,LOW(10)
	STS  _a,R30
_0x191:
; 0000 03EF if(begancio_uzraso_DABAR_padetis==5){
_0x18D:
	LDS  R26,_begancio_uzraso_DABAR_padetis
	CPI  R26,LOW(0x5)
	BRNE _0x192
; 0000 03F0 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x193
; 0000 03F1 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 03F2 if(OSC==4){
_0x193:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x194
; 0000 03F3 a = 11;}
	LDI  R30,LOW(11)
	STS  _a,R30
; 0000 03F4 if(OSC==8){
_0x194:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x195
; 0000 03F5 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 03F6 if(OSC==12){
_0x195:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x196
; 0000 03F7 a = 30;}}
	LDI  R30,LOW(30)
	STS  _a,R30
_0x196:
; 0000 03F8 if(begancio_uzraso_DABAR_padetis==6){
_0x192:
	LDS  R26,_begancio_uzraso_DABAR_padetis
	CPI  R26,LOW(0x6)
	BRNE _0x197
; 0000 03F9 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x198
; 0000 03FA a = 11;}
	LDI  R30,LOW(11)
	STS  _a,R30
; 0000 03FB if(OSC==4){
_0x198:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x199
; 0000 03FC a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 03FD if(OSC==8){
_0x199:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x19A
; 0000 03FE a = 30;}}
	LDI  R30,LOW(30)
	STS  _a,R30
_0x19A:
; 0000 03FF if(begancio_uzraso_DABAR_padetis==7){
_0x197:
	LDS  R26,_begancio_uzraso_DABAR_padetis
	CPI  R26,LOW(0x7)
	BRNE _0x19B
; 0000 0400 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x19C
; 0000 0401 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0402 if(OSC==4){
_0x19C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x19D
; 0000 0403 a = 30;}}
	LDI  R30,LOW(30)
	STS  _a,R30
_0x19D:
; 0000 0404 if(begancio_uzraso_DABAR_padetis==8){
_0x19B:
	LDS  R26,_begancio_uzraso_DABAR_padetis
	CPI  R26,LOW(0x8)
	BRNE _0x19E
; 0000 0405 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x19F
; 0000 0406 a = 30;}}
	LDI  R30,LOW(30)
	STS  _a,R30
_0x19F:
; 0000 0407 
; 0000 0408 if((OSC==12)&&(viena_laikrodzio_sekunde<=PUSE_SEKUNDES)){
_0x19E:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x1A1
	CALL SUBOPT_0x1A
	CP   R10,R26
	CPC  R11,R27
	BRSH _0x1A2
_0x1A1:
	RJMP _0x1A0
_0x1A2:
; 0000 0409 segm_h = 1;}
	LDI  R30,LOW(1)
	STS  _segm_h,R30
; 0000 040A if(OSC==16){
_0x1A0:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x1A3
; 0000 040B a = laikrodzio_valandos / 10;}
	CALL SUBOPT_0x1B
	STS  _a,R30
; 0000 040C if(OSC==20){
_0x1A3:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x1A4
; 0000 040D segm_h = 1;
	LDI  R30,LOW(1)
	STS  _segm_h,R30
; 0000 040E a = laikrodzio_valandos - (laikrodzio_valandos / 10) * 10;}
	LDS  R30,_laikrodzio_valandos
	LDI  R31,0
	SBRC R30,7
	SER  R31
	MOVW R22,R30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 040F if(OSC==24){
_0x1A4:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x1A5
; 0000 0410 a = laikrodzio_minutes / 10;}
	CALL SUBOPT_0x1D
	STS  _a,R30
; 0000 0411 if(OSC==28){
_0x1A5:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x1A6
; 0000 0412 a = laikrodzio_minutes - (laikrodzio_minutes / 10) * 10;}}
	LDS  R30,_laikrodzio_minutes
	LDI  R31,0
	SBRC R30,7
	SER  R31
	MOVW R22,R30
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1C
_0x1A6:
	RET
;
;
;// +
;void sekundes_trukmes_keitimas(){
; 0000 0416 void sekundes_trukmes_keitimas(){
_sekundes_trukmes_keitimas:
; 0000 0417 if((MYGTUKAS_6==1)&&(REDAGAVIMAS==0)){
	LDS  R26,_MYGTUKAS_6
	CPI  R26,LOW(0x1)
	BRNE _0x1A8
	LDS  R26,_REDAGAVIMAS
	CPI  R26,LOW(0x0)
	BREQ _0x1A9
_0x1A8:
	RJMP _0x1A7
_0x1A9:
; 0000 0418 REDAGAVIMAS = 1;
	CALL SUBOPT_0x19
; 0000 0419 MYGTUKAS_6 = 0;
; 0000 041A z = -1;}
	LDI  R30,LOW(255)
	MOV  R6,R30
; 0000 041B if(((MYGTUKAS_6==1)||(MYGTUKAS_3==1))&&(REDAGAVIMAS==1)){
_0x1A7:
	LDS  R26,_MYGTUKAS_6
	CPI  R26,LOW(0x1)
	BREQ _0x1AB
	LDS  R26,_MYGTUKAS_3
	CPI  R26,LOW(0x1)
	BRNE _0x1AD
_0x1AB:
	LDS  R26,_REDAGAVIMAS
	CPI  R26,LOW(0x1)
	BREQ _0x1AE
_0x1AD:
	RJMP _0x1AA
_0x1AE:
; 0000 041C REDAGAVIMAS = 0;
	LDI  R30,LOW(0)
	STS  _REDAGAVIMAS,R30
; 0000 041D MYGTUKAS_6 = 0;
	STS  _MYGTUKAS_6,R30
; 0000 041E MYGTUKAS_3 = 0;}
	STS  _MYGTUKAS_3,R30
; 0000 041F 
; 0000 0420 if(REDAGAVIMAS==1){
_0x1AA:
	LDS  R26,_REDAGAVIMAS
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x1AF
; 0000 0421 if(MYGTUKAS_2==1){
	LDS  R26,_MYGTUKAS_2
	CPI  R26,LOW(0x1)
	BRNE _0x1B0
; 0000 0422 z = z - 1;
	MOV  R30,R6
	CALL SUBOPT_0x18
	MOV  R6,R30
; 0000 0423 MYGTUKAS_2 = 0;}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_2,R30
; 0000 0424 if(MYGTUKAS_4==1){
_0x1B0:
	LDS  R26,_MYGTUKAS_4
	CPI  R26,LOW(0x1)
	BRNE _0x1B1
; 0000 0425 z = z + 1;
	INC  R6
; 0000 0426 MYGTUKAS_4 = 0;}
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_4,R30
; 0000 0427 
; 0000 0428 if(z==-2){
_0x1B1:
	LDI  R30,LOW(254)
	CP   R30,R6
	BRNE _0x1B2
; 0000 0429 z = 3;}
	LDI  R30,LOW(3)
	MOV  R6,R30
; 0000 042A if(z==4){
_0x1B2:
	LDI  R30,LOW(4)
	CP   R30,R6
	BRNE _0x1B3
; 0000 042B z = -1;}
	LDI  R30,LOW(255)
	MOV  R6,R30
; 0000 042C 
; 0000 042D 
; 0000 042E if(z==-1){
_0x1B3:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x1B4
; 0000 042F if((MYGTUKAS_1==1)&&(VIENA_SEKUNDE<=55530)){
	LDS  R26,_MYGTUKAS_1
	CPI  R26,LOW(0x1)
	BRNE _0x1B6
	LDI  R30,LOW(55530)
	LDI  R31,HIGH(55530)
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x1B7
_0x1B6:
	RJMP _0x1B5
_0x1B7:
; 0000 0430 VIENA_SEKUNDE = VIENA_SEKUNDE + 10000;}
	MOVW R30,R8
	SUBI R30,LOW(-10000)
	SBCI R31,HIGH(-10000)
	MOVW R8,R30
; 0000 0431 if((MYGTUKAS_5==1)&&(VIENA_SEKUNDE>10000)){
_0x1B5:
	LDS  R26,_MYGTUKAS_5
	CPI  R26,LOW(0x1)
	BRNE _0x1B9
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CP   R30,R8
	CPC  R31,R9
	BRLO _0x1BA
_0x1B9:
	RJMP _0x1B8
_0x1BA:
; 0000 0432 VIENA_SEKUNDE = VIENA_SEKUNDE - 10000;}
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	__SUBWRR 8,9,30,31
; 0000 0433 MYGTUKAS_1 = 0;
_0x1B8:
	CALL SUBOPT_0x1E
; 0000 0434 MYGTUKAS_5 = 0;}
; 0000 0435 
; 0000 0436 if(z==0){
_0x1B4:
	TST  R6
	BRNE _0x1BB
; 0000 0437 if((MYGTUKAS_1==1)&&(VIENA_SEKUNDE<=64530)){
	LDS  R26,_MYGTUKAS_1
	CPI  R26,LOW(0x1)
	BRNE _0x1BD
	LDI  R30,LOW(64530)
	LDI  R31,HIGH(64530)
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x1BE
_0x1BD:
	RJMP _0x1BC
_0x1BE:
; 0000 0438 VIENA_SEKUNDE = VIENA_SEKUNDE + 1000;}
	MOVW R30,R8
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	MOVW R8,R30
; 0000 0439 if((MYGTUKAS_5==1)&&(VIENA_SEKUNDE>1000)){
_0x1BC:
	LDS  R26,_MYGTUKAS_5
	CPI  R26,LOW(0x1)
	BRNE _0x1C0
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R30,R8
	CPC  R31,R9
	BRLO _0x1C1
_0x1C0:
	RJMP _0x1BF
_0x1C1:
; 0000 043A VIENA_SEKUNDE = VIENA_SEKUNDE - 1000;}
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	__SUBWRR 8,9,30,31
; 0000 043B MYGTUKAS_1 = 0;
_0x1BF:
	CALL SUBOPT_0x1E
; 0000 043C MYGTUKAS_5 = 0;}
; 0000 043D 
; 0000 043E if(z==1){
_0x1BB:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x1C2
; 0000 043F if((MYGTUKAS_1==1)&&(VIENA_SEKUNDE<=65430)){
	LDS  R26,_MYGTUKAS_1
	CPI  R26,LOW(0x1)
	BRNE _0x1C4
	LDI  R30,LOW(65430)
	LDI  R31,HIGH(65430)
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x1C5
_0x1C4:
	RJMP _0x1C3
_0x1C5:
; 0000 0440 VIENA_SEKUNDE = VIENA_SEKUNDE + 100;}
	MOVW R30,R8
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	MOVW R8,R30
; 0000 0441 if((MYGTUKAS_5==1)&&(VIENA_SEKUNDE>100)){
_0x1C3:
	LDS  R26,_MYGTUKAS_5
	CPI  R26,LOW(0x1)
	BRNE _0x1C7
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R8
	CPC  R31,R9
	BRLO _0x1C8
_0x1C7:
	RJMP _0x1C6
_0x1C8:
; 0000 0442 VIENA_SEKUNDE = VIENA_SEKUNDE - 100;}
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	__SUBWRR 8,9,30,31
; 0000 0443 MYGTUKAS_1 = 0;
_0x1C6:
	CALL SUBOPT_0x1E
; 0000 0444 MYGTUKAS_5 = 0;}
; 0000 0445 
; 0000 0446 if(z==2){
_0x1C2:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x1C9
; 0000 0447 if((MYGTUKAS_1==1)&&(VIENA_SEKUNDE<=65520)){
	LDS  R26,_MYGTUKAS_1
	CPI  R26,LOW(0x1)
	BRNE _0x1CB
	LDI  R30,LOW(65520)
	LDI  R31,HIGH(65520)
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x1CC
_0x1CB:
	RJMP _0x1CA
_0x1CC:
; 0000 0448 VIENA_SEKUNDE = VIENA_SEKUNDE + 10;}
	MOVW R30,R8
	ADIW R30,10
	MOVW R8,R30
; 0000 0449 if((MYGTUKAS_5==1)&&(VIENA_SEKUNDE>10)){
_0x1CA:
	LDS  R26,_MYGTUKAS_5
	CPI  R26,LOW(0x1)
	BRNE _0x1CE
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R8
	CPC  R31,R9
	BRLO _0x1CF
_0x1CE:
	RJMP _0x1CD
_0x1CF:
; 0000 044A VIENA_SEKUNDE = VIENA_SEKUNDE - 10;}
	MOVW R30,R8
	SBIW R30,10
	MOVW R8,R30
; 0000 044B MYGTUKAS_1 = 0;
_0x1CD:
	CALL SUBOPT_0x1E
; 0000 044C MYGTUKAS_5 = 0;}
; 0000 044D 
; 0000 044E if(z==3){
_0x1C9:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x1D0
; 0000 044F if((MYGTUKAS_1==1)&&(VIENA_SEKUNDE<=65529)){
	LDS  R26,_MYGTUKAS_1
	CPI  R26,LOW(0x1)
	BRNE _0x1D2
	LDI  R30,LOW(65529)
	LDI  R31,HIGH(65529)
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x1D3
_0x1D2:
	RJMP _0x1D1
_0x1D3:
; 0000 0450 VIENA_SEKUNDE = VIENA_SEKUNDE + 1;}
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0451 if((MYGTUKAS_5==1)&&(VIENA_SEKUNDE>2)){
_0x1D1:
	LDS  R26,_MYGTUKAS_5
	CPI  R26,LOW(0x1)
	BRNE _0x1D5
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	BRLO _0x1D6
_0x1D5:
	RJMP _0x1D4
_0x1D6:
; 0000 0452 VIENA_SEKUNDE = VIENA_SEKUNDE - 1;}
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
; 0000 0453 MYGTUKAS_1 = 0;
_0x1D4:
	CALL SUBOPT_0x1E
; 0000 0454 MYGTUKAS_5 = 0;}}
_0x1D0:
; 0000 0455 
; 0000 0456 
; 0000 0457 if(OSC==0){
_0x1AF:
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x1D7
; 0000 0458 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0459 if(OSC==4){
_0x1D7:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x1D8
; 0000 045A a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 045B if(OSC==8){
_0x1D8:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x1D9
; 0000 045C segm_a = 1;
	LDI  R30,LOW(1)
	STS  _segm_a,R30
; 0000 045D segm_d = 1;
	STS  _segm_d,R30
; 0000 045E segm_e = 1;
	CALL SUBOPT_0x7
; 0000 045F segm_f = 1;
; 0000 0460 segm_h = 1;}
	LDI  R30,LOW(1)
	STS  _segm_h,R30
; 0000 0461 if(OSC==12){
_0x1D9:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x1DA
; 0000 0462 a = VIENA_SEKUNDE/10000;}
	MOVW R26,R8
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL SUBOPT_0x1F
; 0000 0463 if(OSC==16){
_0x1DA:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x1DB
; 0000 0464 a = (VIENA_SEKUNDE - ((VIENA_SEKUNDE/10000)*10000)) / 1000;}
	MOVW R26,R8
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL __DIVW21U
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	CALL SUBOPT_0x20
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x1F
; 0000 0465 if(OSC==20){
_0x1DB:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x1DC
; 0000 0466 a = (VIENA_SEKUNDE - ((VIENA_SEKUNDE/1000)*1000)) / 100;}
	MOVW R26,R8
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL SUBOPT_0x20
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x1F
; 0000 0467 if(OSC==24){
_0x1DC:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x1DD
; 0000 0468 a = (VIENA_SEKUNDE - ((VIENA_SEKUNDE/100)*100)) / 10;}
	MOVW R26,R8
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL SUBOPT_0x20
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x1F
; 0000 0469 if(OSC==28){
_0x1DD:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x1DE
; 0000 046A a = (VIENA_SEKUNDE - (VIENA_SEKUNDE/10)*10);}}
	MOVW R26,R8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	MOVW R26,R30
	MOVW R30,R8
	SUB  R30,R26
	SBC  R31,R27
	STS  _a,R30
_0x1DE:
	RET
;
;
;// +
;void kondensatoriaus_busena(){
; 0000 046E void kondensatoriaus_busena(){
_kondensatoriaus_busena:
; 0000 046F kondensatoriaus_rodymo_laikas = kondensatoriaus_rodymo_laikas + 1;
	LDS  R30,_kondensatoriaus_rodymo_laikas
	LDS  R31,_kondensatoriaus_rodymo_laikas+1
	ADIW R30,1
	STS  _kondensatoriaus_rodymo_laikas,R30
	STS  _kondensatoriaus_rodymo_laikas+1,R31
; 0000 0470 if(kondensatoriaus_rodymo_laikas>=KETVIRTADALIS_SEKUNDES){
	LDS  R26,_kondensatoriaus_rodymo_laikas
	LDS  R27,_kondensatoriaus_rodymo_laikas+1
	CP   R26,R12
	CPC  R27,R13
	BRLO _0x1DF
; 0000 0471 kondensatoriaus_rodymo_laikas = 0;
	LDI  R30,LOW(0)
	STS  _kondensatoriaus_rodymo_laikas,R30
	STS  _kondensatoriaus_rodymo_laikas+1,R30
; 0000 0472 kondensatoriaus_rodymo_padetis = kondensatoriaus_rodymo_padetis + 1;}
	LDS  R30,_kondensatoriaus_rodymo_padetis
	SUBI R30,-LOW(1)
	STS  _kondensatoriaus_rodymo_padetis,R30
; 0000 0473 
; 0000 0474 if((kondensatorius_pilnas==1)&&(kondensatoriaus_rodymo_padetis==29)){
_0x1DF:
	LDS  R26,_kondensatorius_pilnas
	CPI  R26,LOW(0x1)
	BRNE _0x1E1
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1D)
	BREQ _0x1E2
_0x1E1:
	RJMP _0x1E0
_0x1E2:
; 0000 0475 kondensatoriaus_rodymo_padetis =0;}
	LDI  R30,LOW(0)
	STS  _kondensatoriaus_rodymo_padetis,R30
; 0000 0476 if((kondensatorius_vidutinis==1)&&(kondensatoriaus_rodymo_padetis==27)){
_0x1E0:
	LDS  R26,_kondensatorius_vidutinis
	CPI  R26,LOW(0x1)
	BRNE _0x1E4
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1B)
	BREQ _0x1E5
_0x1E4:
	RJMP _0x1E3
_0x1E5:
; 0000 0477 kondensatoriaus_rodymo_padetis = 0;}
	LDI  R30,LOW(0)
	STS  _kondensatoriaus_rodymo_padetis,R30
; 0000 0478 if((kondensatorius_tuscias==1)&&(kondensatoriaus_rodymo_padetis==31)){
_0x1E3:
	LDS  R26,_kondensatorius_tuscias
	CPI  R26,LOW(0x1)
	BRNE _0x1E7
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1F)
	BREQ _0x1E8
_0x1E7:
	RJMP _0x1E6
_0x1E8:
; 0000 0479 kondensatoriaus_rodymo_padetis = 0;}
	LDI  R30,LOW(0)
	STS  _kondensatoriaus_rodymo_padetis,R30
; 0000 047A 
; 0000 047B if((kondensatorius_tuscias==1)||(kondensatorius_pilnas==1)){
_0x1E6:
	LDS  R26,_kondensatorius_tuscias
	CPI  R26,LOW(0x1)
	BREQ _0x1EA
	LDS  R26,_kondensatorius_pilnas
	CPI  R26,LOW(0x1)
	BREQ _0x1EA
	RJMP _0x1E9
_0x1EA:
; 0000 047C if(kondensatoriaus_rodymo_padetis==1){
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1)
	BRNE _0x1EC
; 0000 047D if(OSC==28){
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x1ED
; 0000 047E a = 12;}}
	LDI  R30,LOW(12)
	STS  _a,R30
_0x1ED:
; 0000 047F if(kondensatoriaus_rodymo_padetis==2){
_0x1EC:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x2)
	BRNE _0x1EE
; 0000 0480 if(OSC==24){
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x1EF
; 0000 0481 a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 0482 if(OSC==28){
_0x1EF:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x1F0
; 0000 0483 a = 23;}}
	LDI  R30,LOW(23)
	STS  _a,R30
_0x1F0:
; 0000 0484 if(kondensatoriaus_rodymo_padetis==3){
_0x1EE:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x3)
	BRNE _0x1F1
; 0000 0485 if(OSC==20){
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x1F2
; 0000 0486 a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 0487 if(OSC==24){
_0x1F2:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x1F3
; 0000 0488 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0489 if(OSC==28){
_0x1F3:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x1F4
; 0000 048A a = 34;}}
	LDI  R30,LOW(34)
	STS  _a,R30
_0x1F4:
; 0000 048B if(kondensatoriaus_rodymo_padetis==4){
_0x1F1:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x4)
	BRNE _0x1F5
; 0000 048C if(OSC==16){
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x1F6
; 0000 048D a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 048E if(OSC==20){
_0x1F6:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x1F7
; 0000 048F a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0490 if(OSC==24){
_0x1F7:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x1F8
; 0000 0491 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 0492 if(OSC==28){
_0x1F8:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x1F9
; 0000 0493 a = 14;}}
	LDI  R30,LOW(14)
	STS  _a,R30
_0x1F9:
; 0000 0494 if(kondensatoriaus_rodymo_padetis==5){
_0x1F5:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x5)
	BRNE _0x1FA
; 0000 0495 if(OSC==12){
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x1FB
; 0000 0496 a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 0497 if(OSC==16){
_0x1FB:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x1FC
; 0000 0498 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0499 if(OSC==20){
_0x1FC:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x1FD
; 0000 049A a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 049B if(OSC==24){
_0x1FD:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x1FE
; 0000 049C a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 049D if(OSC==28){
_0x1FE:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x1FF
; 0000 049E a = 15;}}
	LDI  R30,LOW(15)
	STS  _a,R30
_0x1FF:
; 0000 049F if(kondensatoriaus_rodymo_padetis==6){
_0x1FA:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x6)
	BRNE _0x200
; 0000 04A0 if(OSC==8){
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x201
; 0000 04A1 a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 04A2 if(OSC==12){
_0x201:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x202
; 0000 04A3 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 04A4 if(OSC==16){
_0x202:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x203
; 0000 04A5 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 04A6 if(OSC==20){
_0x203:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x204
; 0000 04A7 a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 04A8 if(OSC==24){
_0x204:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x205
; 0000 04A9 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 04AA if(OSC==28){
_0x205:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x206
; 0000 04AB a = 34;}}
	LDI  R30,LOW(34)
	STS  _a,R30
_0x206:
; 0000 04AC if(kondensatoriaus_rodymo_padetis==7){
_0x200:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x7)
	BRNE _0x207
; 0000 04AD if(OSC==4){
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x208
; 0000 04AE a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 04AF if(OSC==8){
_0x208:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x209
; 0000 04B0 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 04B1 if(OSC==12){
_0x209:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x20A
; 0000 04B2 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 04B3 if(OSC==16){
_0x20A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x20B
; 0000 04B4 a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 04B5 if(OSC==20){
_0x20B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x20C
; 0000 04B6 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 04B7 if(OSC==24){
_0x20C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x20D
; 0000 04B8 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 04B9 if(OSC==28){
_0x20D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x20E
; 0000 04BA a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x20E:
; 0000 04BB if(kondensatoriaus_rodymo_padetis==8){
_0x207:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x8)
	BRNE _0x20F
; 0000 04BC if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x210
; 0000 04BD a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 04BE if(OSC==4){
_0x210:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x211
; 0000 04BF a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 04C0 if(OSC==8){
_0x211:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x212
; 0000 04C1 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 04C2 if(OSC==12){
_0x212:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x213
; 0000 04C3 a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 04C4 if(OSC==16){
_0x213:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x214
; 0000 04C5 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 04C6 if(OSC==20){
_0x214:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x215
; 0000 04C7 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 04C8 if(OSC==24){
_0x215:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x216
; 0000 04C9 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 04CA if(OSC==28){
_0x216:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x217
; 0000 04CB a = 10;}}
	LDI  R30,LOW(10)
	STS  _a,R30
_0x217:
; 0000 04CC if(kondensatoriaus_rodymo_padetis==9){
_0x20F:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x9)
	BRNE _0x218
; 0000 04CD if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x219
; 0000 04CE a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 04CF if(OSC==4){
_0x219:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x21A
; 0000 04D0 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 04D1 if(OSC==8){
_0x21A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x21B
; 0000 04D2 a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 04D3 if(OSC==12){
_0x21B:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x21C
; 0000 04D4 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 04D5 if(OSC==16){
_0x21C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x21D
; 0000 04D6 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 04D7 if(OSC==20){
_0x21D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x21E
; 0000 04D8 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 04D9 if(OSC==24){
_0x21E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x21F
; 0000 04DA a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 04DB if(OSC==28){
_0x21F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x220
; 0000 04DC a = 26;}}
	LDI  R30,LOW(26)
	STS  _a,R30
_0x220:
; 0000 04DD if(kondensatoriaus_rodymo_padetis==10){
_0x218:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xA)
	BRNE _0x221
; 0000 04DE if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x222
; 0000 04DF a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 04E0 if(OSC==4){
_0x222:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x223
; 0000 04E1 a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 04E2 if(OSC==8){
_0x223:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x224
; 0000 04E3 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 04E4 if(OSC==12){
_0x224:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x225
; 0000 04E5 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 04E6 if(OSC==16){
_0x225:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x226
; 0000 04E7 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 04E8 if(OSC==20){
_0x226:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x227
; 0000 04E9 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 04EA if(OSC==24){
_0x227:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x228
; 0000 04EB a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 04EC if(OSC==28){
_0x228:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x229
; 0000 04ED a = 23;}}
	LDI  R30,LOW(23)
	STS  _a,R30
_0x229:
; 0000 04EE if(kondensatoriaus_rodymo_padetis==11){
_0x221:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xB)
	BRNE _0x22A
; 0000 04EF if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x22B
; 0000 04F0 a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 04F1 if(OSC==4){
_0x22B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x22C
; 0000 04F2 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 04F3 if(OSC==8){
_0x22C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x22D
; 0000 04F4 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 04F5 if(OSC==12){
_0x22D:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x22E
; 0000 04F6 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 04F7 if(OSC==16){
_0x22E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x22F
; 0000 04F8 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 04F9 if(OSC==20){
_0x22F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x230
; 0000 04FA a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 04FB if(OSC==24){
_0x230:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x231
; 0000 04FC a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 04FD if(OSC==28){
_0x231:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x232
; 0000 04FE a = 30;}}
	LDI  R30,LOW(30)
	STS  _a,R30
_0x232:
; 0000 04FF if(kondensatoriaus_rodymo_padetis==12){
_0x22A:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xC)
	BRNE _0x233
; 0000 0500 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x234
; 0000 0501 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 0502 if(OSC==4){
_0x234:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x235
; 0000 0503 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 0504 if(OSC==8){
_0x235:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x236
; 0000 0505 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0506 if(OSC==12){
_0x236:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x237
; 0000 0507 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0508 if(OSC==16){
_0x237:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x238
; 0000 0509 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 050A if(OSC==20){
_0x238:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x239
; 0000 050B a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 050C if(OSC==24){
_0x239:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x23A
; 0000 050D a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 050E if(OSC==28){
_0x23A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x23B
; 0000 050F a = 20;}}
	LDI  R30,LOW(20)
	STS  _a,R30
_0x23B:
; 0000 0510 if(kondensatoriaus_rodymo_padetis==13){
_0x233:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xD)
	BRNE _0x23C
; 0000 0511 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x23D
; 0000 0512 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 0513 if(OSC==4){
_0x23D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x23E
; 0000 0514 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0515 if(OSC==8){
_0x23E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x23F
; 0000 0516 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0517 if(OSC==12){
_0x23F:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x240
; 0000 0518 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0519 if(OSC==16){
_0x240:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x241
; 0000 051A a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 051B if(OSC==20){
_0x241:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x242
; 0000 051C a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 051D if(OSC==24){
_0x242:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x243
; 0000 051E a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 051F if(OSC==28){
_0x243:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x244
; 0000 0520 a = 27;}}
	LDI  R30,LOW(27)
	STS  _a,R30
_0x244:
; 0000 0521 if(kondensatoriaus_rodymo_padetis==14){
_0x23C:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xE)
	BRNE _0x245
; 0000 0522 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x246
; 0000 0523 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0524 if(OSC==4){
_0x246:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x247
; 0000 0525 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0526 if(OSC==8){
_0x247:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x248
; 0000 0527 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0528 if(OSC==12){
_0x248:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x249
; 0000 0529 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 052A if(OSC==16){
_0x249:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x24A
; 0000 052B a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 052C if(OSC==20){
_0x24A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x24B
; 0000 052D a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 052E if(OSC==24){
_0x24B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x24C
; 0000 052F a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 0530 if(OSC==28){
_0x24C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x24D
; 0000 0531 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x24D:
; 0000 0532 if(kondensatoriaus_rodymo_padetis==15){
_0x245:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xF)
	BRNE _0x24E
; 0000 0533 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x24F
; 0000 0534 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0535 if(OSC==4){
_0x24F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x250
; 0000 0536 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0537 if(OSC==8){
_0x250:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x251
; 0000 0538 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0539 if(OSC==12){
_0x251:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x252
; 0000 053A a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 053B if(OSC==16){
_0x252:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x253
; 0000 053C a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 053D if(OSC==20){
_0x253:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x254
; 0000 053E a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 053F if(OSC==24){
_0x254:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x255
; 0000 0540 a = 5;}}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x255:
_0x24E:
; 0000 0541 
; 0000 0542 if(kondensatorius_pilnas==1){
_0x1E9:
	LDS  R26,_kondensatorius_pilnas
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x256
; 0000 0543 if(kondensatoriaus_rodymo_padetis==16){
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x10)
	BRNE _0x257
; 0000 0544 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x258
; 0000 0545 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0546 if(OSC==4){
_0x258:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x259
; 0000 0547 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0548 if(OSC==8){
_0x259:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x25A
; 0000 0549 a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 054A if(OSC==12){
_0x25A:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x25B
; 0000 054B a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 054C if(OSC==16){
_0x25B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x25C
; 0000 054D a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 054E if(OSC==20){
_0x25C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x25D
; 0000 054F a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0550 if(OSC==28){
_0x25D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x25E
; 0000 0551 a = 24;}}
	LDI  R30,LOW(24)
	STS  _a,R30
_0x25E:
; 0000 0552 if(kondensatoriaus_rodymo_padetis==17){
_0x257:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x11)
	BRNE _0x25F
; 0000 0553 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x260
; 0000 0554 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0555 if(OSC==4){
_0x260:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x261
; 0000 0556 a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 0557 if(OSC==8){
_0x261:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x262
; 0000 0558 a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 0559 if(OSC==12){
_0x262:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x263
; 0000 055A a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 055B if(OSC==16){
_0x263:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x264
; 0000 055C a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 055D if(OSC==24){
_0x264:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x265
; 0000 055E a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 055F if(OSC==28){
_0x265:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x266
; 0000 0560 a = 19;}}
	LDI  R30,LOW(19)
	STS  _a,R30
_0x266:
; 0000 0561 if(kondensatoriaus_rodymo_padetis==18){
_0x25F:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x12)
	BRNE _0x267
; 0000 0562 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x268
; 0000 0563 a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 0564 if(OSC==4){
_0x268:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x269
; 0000 0565 a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 0566 if(OSC==8){
_0x269:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x26A
; 0000 0567 a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 0568 if(OSC==12){
_0x26A:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x26B
; 0000 0569 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 056A if(OSC==20){
_0x26B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x26C
; 0000 056B a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 056C if(OSC==24){
_0x26C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x26D
; 0000 056D a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 056E if(OSC==28){
_0x26D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x26E
; 0000 056F a = 22;}}
	LDI  R30,LOW(22)
	STS  _a,R30
_0x26E:
; 0000 0570 if(kondensatoriaus_rodymo_padetis==19){
_0x267:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x13)
	BRNE _0x26F
; 0000 0571 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x270
; 0000 0572 a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 0573 if(OSC==4){
_0x270:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x271
; 0000 0574 a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 0575 if(OSC==8){
_0x271:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x272
; 0000 0576 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0577 if(OSC==16){
_0x272:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x273
; 0000 0578 a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 0579 if(OSC==20){
_0x273:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x274
; 0000 057A a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 057B if(OSC==24){
_0x274:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x275
; 0000 057C a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 057D if(OSC==28){
_0x275:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x276
; 0000 057E a = 34;}}
	LDI  R30,LOW(34)
	STS  _a,R30
_0x276:
; 0000 057F if(kondensatoriaus_rodymo_padetis==20){
_0x26F:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x14)
	BRNE _0x277
; 0000 0580 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x278
; 0000 0581 a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 0582 if(OSC==4){
_0x278:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x279
; 0000 0583 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0584 if(OSC==12){
_0x279:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x27A
; 0000 0585 a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 0586 if(OSC==16){
_0x27A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x27B
; 0000 0587 a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 0588 if(OSC==20){
_0x27B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x27C
; 0000 0589 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 058A if(OSC==24){
_0x27C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x27D
; 0000 058B a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 058C if(OSC==28){
_0x27D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x27E
; 0000 058D a = 10;}}
	LDI  R30,LOW(10)
	STS  _a,R30
_0x27E:
; 0000 058E if(kondensatoriaus_rodymo_padetis==21){
_0x277:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x15)
	BRNE _0x27F
; 0000 058F if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x280
; 0000 0590 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0591 if(OSC==8){
_0x280:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x281
; 0000 0592 a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 0593 if(OSC==12){
_0x281:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x282
; 0000 0594 a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 0595 if(OSC==16){
_0x282:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x283
; 0000 0596 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 0597 if(OSC==20){
_0x283:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x284
; 0000 0598 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 0599 if(OSC==24){
_0x284:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x285
; 0000 059A a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 059B if(OSC==28){
_0x285:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x286
; 0000 059C a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x286:
; 0000 059D if(kondensatoriaus_rodymo_padetis==22){
_0x27F:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x16)
	BRNE _0x287
; 0000 059E if(OSC==4){
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x288
; 0000 059F a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 05A0 if(OSC==8){
_0x288:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x289
; 0000 05A1 a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 05A2 if(OSC==12){
_0x289:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x28A
; 0000 05A3 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 05A4 if(OSC==16){
_0x28A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x28B
; 0000 05A5 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 05A6 if(OSC==20){
_0x28B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x28C
; 0000 05A7 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 05A8 if(OSC==24){
_0x28C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x28D
; 0000 05A9 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x28D:
; 0000 05AA if(kondensatoriaus_rodymo_padetis==23){
_0x287:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x17)
	BRNE _0x28E
; 0000 05AB if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x28F
; 0000 05AC a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 05AD if(OSC==4){
_0x28F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x290
; 0000 05AE a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 05AF if(OSC==8){
_0x290:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x291
; 0000 05B0 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 05B1 if(OSC==12){
_0x291:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x292
; 0000 05B2 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 05B3 if(OSC==16){
_0x292:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x293
; 0000 05B4 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 05B5 if(OSC==20){
_0x293:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x294
; 0000 05B6 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x294:
; 0000 05B7 if(kondensatoriaus_rodymo_padetis==24){
_0x28E:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x18)
	BRNE _0x295
; 0000 05B8 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x296
; 0000 05B9 a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 05BA if(OSC==4){
_0x296:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x297
; 0000 05BB a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 05BC if(OSC==8){
_0x297:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x298
; 0000 05BD a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 05BE if(OSC==12){
_0x298:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x299
; 0000 05BF a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 05C0 if(OSC==16){
_0x299:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x29A
; 0000 05C1 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x29A:
; 0000 05C2 if(kondensatoriaus_rodymo_padetis==25){
_0x295:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x19)
	BRNE _0x29B
; 0000 05C3 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x29C
; 0000 05C4 a = 22;}
	LDI  R30,LOW(22)
	STS  _a,R30
; 0000 05C5 if(OSC==4){
_0x29C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x29D
; 0000 05C6 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 05C7 if(OSC==8){
_0x29D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x29E
; 0000 05C8 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 05C9 if(OSC==12){
_0x29E:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x29F
; 0000 05CA a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x29F:
; 0000 05CB if(kondensatoriaus_rodymo_padetis==26){
_0x29B:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1A)
	BRNE _0x2A0
; 0000 05CC if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2A1
; 0000 05CD a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 05CE if(OSC==4){
_0x2A1:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2A2
; 0000 05CF a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 05D0 if(OSC==8){
_0x2A2:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2A3
; 0000 05D1 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x2A3:
; 0000 05D2 if(kondensatoriaus_rodymo_padetis==27){
_0x2A0:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1B)
	BRNE _0x2A4
; 0000 05D3 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2A5
; 0000 05D4 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 05D5 if(OSC==4){
_0x2A5:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2A6
; 0000 05D6 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x2A6:
; 0000 05D7 if(kondensatoriaus_rodymo_padetis==27){
_0x2A4:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1B)
	BRNE _0x2A7
; 0000 05D8 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2A8
; 0000 05D9 a = 5;}}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x2A8:
_0x2A7:
; 0000 05DA 
; 0000 05DB if(kondensatorius_tuscias==1){
_0x256:
	LDS  R26,_kondensatorius_tuscias
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x2A9
; 0000 05DC if(kondensatoriaus_rodymo_padetis==16){
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x10)
	BRNE _0x2AA
; 0000 05DD if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2AB
; 0000 05DE a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 05DF if(OSC==4){
_0x2AB:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2AC
; 0000 05E0 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 05E1 if(OSC==8){
_0x2AC:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2AD
; 0000 05E2 a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 05E3 if(OSC==12){
_0x2AD:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x2AE
; 0000 05E4 a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 05E5 if(OSC==16){
_0x2AE:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x2AF
; 0000 05E6 a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 05E7 if(OSC==20){
_0x2AF:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x2B0
; 0000 05E8 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 05E9 if(OSC==28){
_0x2B0:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x2B1
; 0000 05EA a = 26;}}
	LDI  R30,LOW(26)
	STS  _a,R30
_0x2B1:
; 0000 05EB if(kondensatoriaus_rodymo_padetis==17){
_0x2AA:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x11)
	BRNE _0x2B2
; 0000 05EC if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2B3
; 0000 05ED a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 05EE if(OSC==4){
_0x2B3:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2B4
; 0000 05EF a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 05F0 if(OSC==8){
_0x2B4:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2B5
; 0000 05F1 a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 05F2 if(OSC==12){
_0x2B5:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x2B6
; 0000 05F3 a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 05F4 if(OSC==16){
_0x2B6:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x2B7
; 0000 05F5 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 05F6 if(OSC==24){
_0x2B7:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x2B8
; 0000 05F7 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 05F8 if(OSC==28){
_0x2B8:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x2B9
; 0000 05F9 a = 28;}}
	LDI  R30,LOW(28)
	STS  _a,R30
_0x2B9:
; 0000 05FA if(kondensatoriaus_rodymo_padetis==18){
_0x2B2:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x12)
	BRNE _0x2BA
; 0000 05FB if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2BB
; 0000 05FC a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 05FD if(OSC==4){
_0x2BB:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2BC
; 0000 05FE a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 05FF if(OSC==8){
_0x2BC:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2BD
; 0000 0600 a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 0601 if(OSC==12){
_0x2BD:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x2BE
; 0000 0602 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0603 if(OSC==20){
_0x2BE:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x2BF
; 0000 0604 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0605 if(OSC==24){
_0x2BF:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x2C0
; 0000 0606 a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 0607 if(OSC==28){
_0x2C0:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x2C1
; 0000 0608 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x2C1:
; 0000 0609 if(kondensatoriaus_rodymo_padetis==19){
_0x2BA:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x13)
	BRNE _0x2C2
; 0000 060A if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2C3
; 0000 060B a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 060C if(OSC==4){
_0x2C3:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2C4
; 0000 060D a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 060E if(OSC==8){
_0x2C4:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2C5
; 0000 060F a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0610 if(OSC==16){
_0x2C5:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x2C6
; 0000 0611 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0612 if(OSC==20){
_0x2C6:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x2C7
; 0000 0613 a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 0614 if(OSC==24){
_0x2C7:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x2C8
; 0000 0615 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0616 if(OSC==28){
_0x2C8:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x2C9
; 0000 0617 a = 13;}}
	LDI  R30,LOW(13)
	STS  _a,R30
_0x2C9:
; 0000 0618 if(kondensatoriaus_rodymo_padetis==20){
_0x2C2:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x14)
	BRNE _0x2CA
; 0000 0619 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2CB
; 0000 061A a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 061B if(OSC==4){
_0x2CB:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2CC
; 0000 061C a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 061D if(OSC==12){
_0x2CC:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x2CD
; 0000 061E a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 061F if(OSC==16){
_0x2CD:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x2CE
; 0000 0620 a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 0621 if(OSC==20){
_0x2CE:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x2CF
; 0000 0622 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0623 if(OSC==24){
_0x2CF:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x2D0
; 0000 0624 a = 13;}
	LDI  R30,LOW(13)
	STS  _a,R30
; 0000 0625 if(OSC==28){
_0x2D0:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x2D1
; 0000 0626 a = 19;}}
	LDI  R30,LOW(19)
	STS  _a,R30
_0x2D1:
; 0000 0627 if(kondensatoriaus_rodymo_padetis==21){
_0x2CA:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x15)
	BRNE _0x2D2
; 0000 0628 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2D3
; 0000 0629 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 062A if(OSC==8){
_0x2D3:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2D4
; 0000 062B a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 062C if(OSC==12){
_0x2D4:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x2D5
; 0000 062D a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 062E if(OSC==16){
_0x2D5:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x2D6
; 0000 062F a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0630 if(OSC==20){
_0x2D6:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x2D7
; 0000 0631 a = 13;}
	LDI  R30,LOW(13)
	STS  _a,R30
; 0000 0632 if(OSC==24){
_0x2D7:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x2D8
; 0000 0633 a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 0634 if(OSC==28){
_0x2D8:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x2D9
; 0000 0635 a = 10;}}
	LDI  R30,LOW(10)
	STS  _a,R30
_0x2D9:
; 0000 0636 if(kondensatoriaus_rodymo_padetis==22){
_0x2D2:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x16)
	BRNE _0x2DA
; 0000 0637 if(OSC==4){
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2DB
; 0000 0638 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0639 if(OSC==8){
_0x2DB:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2DC
; 0000 063A a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 063B if(OSC==12){
_0x2DC:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x2DD
; 0000 063C a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 063D if(OSC==16){
_0x2DD:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x2DE
; 0000 063E a = 13;}
	LDI  R30,LOW(13)
	STS  _a,R30
; 0000 063F if(OSC==20){
_0x2DE:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x2DF
; 0000 0640 a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 0641 if(OSC==24){
_0x2DF:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x2E0
; 0000 0642 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0643 if(OSC==28){
_0x2E0:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x2E1
; 0000 0644 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x2E1:
; 0000 0645 if(kondensatoriaus_rodymo_padetis==23){
_0x2DA:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x17)
	BRNE _0x2E2
; 0000 0646 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2E3
; 0000 0647 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0648 if(OSC==4){
_0x2E3:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2E4
; 0000 0649 a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 064A if(OSC==8){
_0x2E4:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2E5
; 0000 064B a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 064C if(OSC==12){
_0x2E5:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x2E6
; 0000 064D a = 13;}
	LDI  R30,LOW(13)
	STS  _a,R30
; 0000 064E if(OSC==16){
_0x2E6:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x2E7
; 0000 064F a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 0650 if(OSC==20){
_0x2E7:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x2E8
; 0000 0651 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0652 if(OSC==24){
_0x2E8:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x2E9
; 0000 0653 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x2E9:
; 0000 0654 if(kondensatoriaus_rodymo_padetis==24){
_0x2E2:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x18)
	BRNE _0x2EA
; 0000 0655 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2EB
; 0000 0656 a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 0657 if(OSC==4){
_0x2EB:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2EC
; 0000 0658 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0659 if(OSC==8){
_0x2EC:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2ED
; 0000 065A a = 13;}
	LDI  R30,LOW(13)
	STS  _a,R30
; 0000 065B if(OSC==12){
_0x2ED:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x2EE
; 0000 065C a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 065D if(OSC==16){
_0x2EE:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x2EF
; 0000 065E a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 065F if(OSC==20){
_0x2EF:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x2F0
; 0000 0660 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x2F0:
; 0000 0661 if(kondensatoriaus_rodymo_padetis==25){
_0x2EA:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x19)
	BRNE _0x2F1
; 0000 0662 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2F2
; 0000 0663 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0664 if(OSC==4){
_0x2F2:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2F3
; 0000 0665 a = 13;}
	LDI  R30,LOW(13)
	STS  _a,R30
; 0000 0666 if(OSC==8){
_0x2F3:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2F4
; 0000 0667 a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 0668 if(OSC==12){
_0x2F4:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x2F5
; 0000 0669 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 066A if(OSC==16){
_0x2F5:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x2F6
; 0000 066B a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x2F6:
; 0000 066C if(kondensatoriaus_rodymo_padetis==26){
_0x2F1:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1A)
	BRNE _0x2F7
; 0000 066D if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2F8
; 0000 066E a = 13;}
	LDI  R30,LOW(13)
	STS  _a,R30
; 0000 066F if(OSC==4){
_0x2F8:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2F9
; 0000 0670 a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 0671 if(OSC==8){
_0x2F9:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2FA
; 0000 0672 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0673 if(OSC==12){
_0x2FA:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x2FB
; 0000 0674 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x2FB:
; 0000 0675 if(kondensatoriaus_rodymo_padetis==27){
_0x2F7:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1B)
	BRNE _0x2FC
; 0000 0676 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x2FD
; 0000 0677 a = 19;}
	LDI  R30,LOW(19)
	STS  _a,R30
; 0000 0678 if(OSC==4){
_0x2FD:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x2FE
; 0000 0679 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 067A if(OSC==8){
_0x2FE:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x2FF
; 0000 067B a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x2FF:
; 0000 067C if(kondensatoriaus_rodymo_padetis==28){
_0x2FC:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1C)
	BRNE _0x300
; 0000 067D if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x301
; 0000 067E a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 067F if(OSC==4){
_0x301:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x302
; 0000 0680 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x302:
; 0000 0681 if(kondensatoriaus_rodymo_padetis==29){
_0x300:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1D)
	BRNE _0x303
; 0000 0682 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x304
; 0000 0683 a = 5;}}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x304:
_0x303:
; 0000 0684 
; 0000 0685 
; 0000 0686 if(kondensatorius_vidutinis){
_0x2A9:
	LDS  R30,_kondensatorius_vidutinis
	CPI  R30,0
	BRNE PC+3
	JMP _0x305
; 0000 0687 if(kondensatoriaus_rodymo_padetis==1){
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x1)
	BRNE _0x306
; 0000 0688 if(OSC==28){
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x307
; 0000 0689 a = 12;}}
	LDI  R30,LOW(12)
	STS  _a,R30
_0x307:
; 0000 068A if(kondensatoriaus_rodymo_padetis==2){
_0x306:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x2)
	BRNE _0x308
; 0000 068B if(OSC==24){
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x309
; 0000 068C a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 068D if(OSC==28){
_0x309:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x30A
; 0000 068E a = 23;}}
	LDI  R30,LOW(23)
	STS  _a,R30
_0x30A:
; 0000 068F if(kondensatoriaus_rodymo_padetis==3){
_0x308:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x3)
	BRNE _0x30B
; 0000 0690 if(OSC==20){
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x30C
; 0000 0691 a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 0692 if(OSC==24){
_0x30C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x30D
; 0000 0693 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0694 if(OSC==28){
_0x30D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x30E
; 0000 0695 a = 34;}}
	LDI  R30,LOW(34)
	STS  _a,R30
_0x30E:
; 0000 0696 if(kondensatoriaus_rodymo_padetis==4){
_0x30B:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x4)
	BRNE _0x30F
; 0000 0697 if(OSC==16){
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x310
; 0000 0698 a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 0699 if(OSC==20){
_0x310:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x311
; 0000 069A a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 069B if(OSC==24){
_0x311:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x312
; 0000 069C a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 069D if(OSC==28){
_0x312:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x313
; 0000 069E a = 14;}}
	LDI  R30,LOW(14)
	STS  _a,R30
_0x313:
; 0000 069F if(kondensatoriaus_rodymo_padetis==5){
_0x30F:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x5)
	BRNE _0x314
; 0000 06A0 if(OSC==12){
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x315
; 0000 06A1 a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 06A2 if(OSC==16){
_0x315:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x316
; 0000 06A3 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 06A4 if(OSC==20){
_0x316:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x317
; 0000 06A5 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 06A6 if(OSC==24){
_0x317:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x318
; 0000 06A7 a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 06A8 if(OSC==28){
_0x318:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x319
; 0000 06A9 a = 15;}}
	LDI  R30,LOW(15)
	STS  _a,R30
_0x319:
; 0000 06AA if(kondensatoriaus_rodymo_padetis==6){
_0x314:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x6)
	BRNE _0x31A
; 0000 06AB if(OSC==8){
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x31B
; 0000 06AC a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 06AD if(OSC==12){
_0x31B:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x31C
; 0000 06AE a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 06AF if(OSC==16){
_0x31C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x31D
; 0000 06B0 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 06B1 if(OSC==20){
_0x31D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x31E
; 0000 06B2 a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 06B3 if(OSC==24){
_0x31E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x31F
; 0000 06B4 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 06B5 if(OSC==28){
_0x31F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x320
; 0000 06B6 a = 34;}}
	LDI  R30,LOW(34)
	STS  _a,R30
_0x320:
; 0000 06B7 if(kondensatoriaus_rodymo_padetis==7){
_0x31A:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x7)
	BRNE _0x321
; 0000 06B8 if(OSC==4){
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x322
; 0000 06B9 a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 06BA if(OSC==8){
_0x322:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x323
; 0000 06BB a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 06BC if(OSC==12){
_0x323:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x324
; 0000 06BD a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 06BE if(OSC==16){
_0x324:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x325
; 0000 06BF a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 06C0 if(OSC==20){
_0x325:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x326
; 0000 06C1 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 06C2 if(OSC==24){
_0x326:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x327
; 0000 06C3 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 06C4 if(OSC==28){
_0x327:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x328
; 0000 06C5 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x328:
; 0000 06C6 if(kondensatoriaus_rodymo_padetis==8){
_0x321:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x8)
	BRNE _0x329
; 0000 06C7 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x32A
; 0000 06C8 a = 12;}
	LDI  R30,LOW(12)
	STS  _a,R30
; 0000 06C9 if(OSC==4){
_0x32A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x32B
; 0000 06CA a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 06CB if(OSC==8){
_0x32B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x32C
; 0000 06CC a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 06CD if(OSC==12){
_0x32C:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x32D
; 0000 06CE a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 06CF if(OSC==16){
_0x32D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x32E
; 0000 06D0 a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 06D1 if(OSC==20){
_0x32E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x32F
; 0000 06D2 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 06D3 if(OSC==24){
_0x32F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x330
; 0000 06D4 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 06D5 if(OSC==28){
_0x330:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x331
; 0000 06D6 a = 10;}}
	LDI  R30,LOW(10)
	STS  _a,R30
_0x331:
; 0000 06D7 if(kondensatoriaus_rodymo_padetis==9){
_0x329:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x9)
	BRNE _0x332
; 0000 06D8 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x333
; 0000 06D9 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 06DA if(OSC==4){
_0x333:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x334
; 0000 06DB a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 06DC if(OSC==8){
_0x334:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x335
; 0000 06DD a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 06DE if(OSC==12){
_0x335:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x336
; 0000 06DF a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 06E0 if(OSC==16){
_0x336:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x337
; 0000 06E1 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 06E2 if(OSC==20){
_0x337:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x338
; 0000 06E3 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 06E4 if(OSC==24){
_0x338:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x339
; 0000 06E5 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 06E6 if(OSC==28){
_0x339:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x33A
; 0000 06E7 a = 26;}}
	LDI  R30,LOW(26)
	STS  _a,R30
_0x33A:
; 0000 06E8 if(kondensatoriaus_rodymo_padetis==10){
_0x332:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xA)
	BRNE _0x33B
; 0000 06E9 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x33C
; 0000 06EA a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 06EB if(OSC==4){
_0x33C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x33D
; 0000 06EC a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 06ED if(OSC==8){
_0x33D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x33E
; 0000 06EE a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 06EF if(OSC==12){
_0x33E:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x33F
; 0000 06F0 a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 06F1 if(OSC==16){
_0x33F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x340
; 0000 06F2 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 06F3 if(OSC==20){
_0x340:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x341
; 0000 06F4 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 06F5 if(OSC==24){
_0x341:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x342
; 0000 06F6 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 06F7 if(OSC==28){
_0x342:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x343
; 0000 06F8 a = 23;}}
	LDI  R30,LOW(23)
	STS  _a,R30
_0x343:
; 0000 06F9 if(kondensatoriaus_rodymo_padetis==11){
_0x33B:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xB)
	BRNE _0x344
; 0000 06FA if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x345
; 0000 06FB a = 14;}
	LDI  R30,LOW(14)
	STS  _a,R30
; 0000 06FC if(OSC==4){
_0x345:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x346
; 0000 06FD a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 06FE if(OSC==8){
_0x346:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x347
; 0000 06FF a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 0700 if(OSC==12){
_0x347:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x348
; 0000 0701 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0702 if(OSC==16){
_0x348:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x349
; 0000 0703 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0704 if(OSC==20){
_0x349:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x34A
; 0000 0705 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0706 if(OSC==24){
_0x34A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x34B
; 0000 0707 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0708 if(OSC==28){
_0x34B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x34C
; 0000 0709 a = 30;}}
	LDI  R30,LOW(30)
	STS  _a,R30
_0x34C:
; 0000 070A if(kondensatoriaus_rodymo_padetis==12){
_0x344:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xC)
	BRNE _0x34D
; 0000 070B if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x34E
; 0000 070C a = 15;}
	LDI  R30,LOW(15)
	STS  _a,R30
; 0000 070D if(OSC==4){
_0x34E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x34F
; 0000 070E a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 070F if(OSC==8){
_0x34F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x350
; 0000 0710 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0711 if(OSC==12){
_0x350:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x351
; 0000 0712 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0713 if(OSC==16){
_0x351:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x352
; 0000 0714 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0715 if(OSC==20){
_0x352:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x353
; 0000 0716 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0717 if(OSC==24){
_0x353:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x354
; 0000 0718 a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 0719 if(OSC==28){
_0x354:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x355
; 0000 071A a = 20;}}
	LDI  R30,LOW(20)
	STS  _a,R30
_0x355:
; 0000 071B if(kondensatoriaus_rodymo_padetis==13){
_0x34D:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xD)
	BRNE _0x356
; 0000 071C if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x357
; 0000 071D a = 34;}
	LDI  R30,LOW(34)
	STS  _a,R30
; 0000 071E if(OSC==4){
_0x357:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x358
; 0000 071F a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0720 if(OSC==8){
_0x358:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x359
; 0000 0721 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0722 if(OSC==12){
_0x359:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x35A
; 0000 0723 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0724 if(OSC==16){
_0x35A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x35B
; 0000 0725 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0726 if(OSC==20){
_0x35B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x35C
; 0000 0727 a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 0728 if(OSC==24){
_0x35C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x35D
; 0000 0729 a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 072A if(OSC==28){
_0x35D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x35E
; 0000 072B a = 10;}}
	LDI  R30,LOW(10)
	STS  _a,R30
_0x35E:
; 0000 072C if(kondensatoriaus_rodymo_padetis==14){
_0x356:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xE)
	BRNE _0x35F
; 0000 072D if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x360
; 0000 072E a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 072F if(OSC==4){
_0x360:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x361
; 0000 0730 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0731 if(OSC==8){
_0x361:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x362
; 0000 0732 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0733 if(OSC==12){
_0x362:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x363
; 0000 0734 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0735 if(OSC==16){
_0x363:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x364
; 0000 0736 a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 0737 if(OSC==20){
_0x364:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x365
; 0000 0738 a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 0739 if(OSC==24){
_0x365:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x366
; 0000 073A a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 073B if(OSC==28){
_0x366:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x367
; 0000 073C a = 27;}}
	LDI  R30,LOW(27)
	STS  _a,R30
_0x367:
; 0000 073D if(kondensatoriaus_rodymo_padetis==15){
_0x35F:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0xF)
	BRNE _0x368
; 0000 073E if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x369
; 0000 073F a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0740 if(OSC==4){
_0x369:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x36A
; 0000 0741 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0742 if(OSC==8){
_0x36A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x36B
; 0000 0743 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0744 if(OSC==12){
_0x36B:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x36C
; 0000 0745 a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 0746 if(OSC==16){
_0x36C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x36D
; 0000 0747 a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 0748 if(OSC==20){
_0x36D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x36E
; 0000 0749 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 074A if(OSC==24){
_0x36E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x36F
; 0000 074B a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 074C if(OSC==28){
_0x36F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x370
; 0000 074D a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x370:
; 0000 074E if(kondensatoriaus_rodymo_padetis==16){
_0x368:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x10)
	BRNE _0x371
; 0000 074F if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x372
; 0000 0750 a = 26;}
	LDI  R30,LOW(26)
	STS  _a,R30
; 0000 0751 if(OSC==4){
_0x372:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x373
; 0000 0752 a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0753 if(OSC==8){
_0x373:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x374
; 0000 0754 a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 0755 if(OSC==12){
_0x374:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x375
; 0000 0756 a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 0757 if(OSC==16){
_0x375:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x376
; 0000 0758 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0759 if(OSC==20){
_0x376:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x377
; 0000 075A a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 075B if(OSC==24){
_0x377:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x378
; 0000 075C a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x378:
; 0000 075D if(kondensatoriaus_rodymo_padetis==17){
_0x371:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x11)
	BRNE _0x379
; 0000 075E if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x37A
; 0000 075F a = 23;}
	LDI  R30,LOW(23)
	STS  _a,R30
; 0000 0760 if(OSC==4){
_0x37A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x37B
; 0000 0761 a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 0762 if(OSC==8){
_0x37B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x37C
; 0000 0763 a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 0764 if(OSC==12){
_0x37C:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x37D
; 0000 0765 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0766 if(OSC==16){
_0x37D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x37E
; 0000 0767 a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 0768 if(OSC==20){
_0x37E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x37F
; 0000 0769 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 076A if(OSC==28){
_0x37F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x380
; 0000 076B a = 24;}}
	LDI  R30,LOW(24)
	STS  _a,R30
_0x380:
; 0000 076C if(kondensatoriaus_rodymo_padetis==18){
_0x379:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x12)
	BRNE _0x381
; 0000 076D if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x382
; 0000 076E a = 30;}
	LDI  R30,LOW(30)
	STS  _a,R30
; 0000 076F if(OSC==4){
_0x382:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x383
; 0000 0770 a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 0771 if(OSC==8){
_0x383:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x384
; 0000 0772 a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0773 if(OSC==12){
_0x384:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x385
; 0000 0774 a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 0775 if(OSC==16){
_0x385:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x386
; 0000 0776 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0777 if(OSC==24){
_0x386:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x387
; 0000 0778 a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 0779 if(OSC==28){
_0x387:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x388
; 0000 077A a = 28;}}
	LDI  R30,LOW(28)
	STS  _a,R30
_0x388:
; 0000 077B if(kondensatoriaus_rodymo_padetis==19){
_0x381:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x13)
	BRNE _0x389
; 0000 077C if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x38A
; 0000 077D a = 20;}
	LDI  R30,LOW(20)
	STS  _a,R30
; 0000 077E if(OSC==4){
_0x38A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x38B
; 0000 077F a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 0780 if(OSC==8){
_0x38B:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x38C
; 0000 0781 a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 0782 if(OSC==12){
_0x38C:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x38D
; 0000 0783 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0784 if(OSC==20){
_0x38D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x38E
; 0000 0785 a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 0786 if(OSC==24){
_0x38E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x38F
; 0000 0787 a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 0788 if(OSC==28){
_0x38F:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x390
; 0000 0789 a = 5;}}
	LDI  R30,LOW(5)
	STS  _a,R30
_0x390:
; 0000 078A if(kondensatoriaus_rodymo_padetis==19){
_0x389:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x13)
	BRNE _0x391
; 0000 078B if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x392
; 0000 078C a = 10;}
	LDI  R30,LOW(10)
	STS  _a,R30
; 0000 078D if(OSC==4){
_0x392:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x393
; 0000 078E a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 078F if(OSC==8){
_0x393:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x394
; 0000 0790 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0791 if(OSC==16){
_0x394:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x395
; 0000 0792 a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 0793 if(OSC==20){
_0x395:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x396
; 0000 0794 a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 0795 if(OSC==24){
_0x396:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x397
; 0000 0796 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 0797 if(OSC==28){
_0x397:
	LDS  R26,_OSC
	CPI  R26,LOW(0x1C)
	BRNE _0x398
; 0000 0798 a = 15;}}
	LDI  R30,LOW(15)
	STS  _a,R30
_0x398:
; 0000 0799 if(kondensatoriaus_rodymo_padetis==20){
_0x391:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x14)
	BRNE _0x399
; 0000 079A if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x39A
; 0000 079B a = 27;}
	LDI  R30,LOW(27)
	STS  _a,R30
; 0000 079C if(OSC==4){
_0x39A:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x39B
; 0000 079D a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 079E if(OSC==12){
_0x39B:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x39C
; 0000 079F a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 07A0 if(OSC==16){
_0x39C:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x39D
; 0000 07A1 a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 07A2 if(OSC==20){
_0x39D:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x39E
; 0000 07A3 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 07A4 if(OSC==24){
_0x39E:
	LDS  R26,_OSC
	CPI  R26,LOW(0x18)
	BRNE _0x39F
; 0000 07A5 a = 15;}}
	LDI  R30,LOW(15)
	STS  _a,R30
_0x39F:
; 0000 07A6 if(kondensatoriaus_rodymo_padetis==21){
_0x399:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x15)
	BRNE _0x3A0
; 0000 07A7 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x3A1
; 0000 07A8 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 07A9 if(OSC==8){
_0x3A1:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x3A2
; 0000 07AA a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 07AB if(OSC==12){
_0x3A2:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x3A3
; 0000 07AC a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 07AD if(OSC==16){
_0x3A3:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x3A4
; 0000 07AE a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 07AF if(OSC==20){
_0x3A4:
	LDS  R26,_OSC
	CPI  R26,LOW(0x14)
	BRNE _0x3A5
; 0000 07B0 a = 15;}}
	LDI  R30,LOW(15)
	STS  _a,R30
_0x3A5:
; 0000 07B1 if(kondensatoriaus_rodymo_padetis==22){
_0x3A0:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x16)
	BRNE _0x3A6
; 0000 07B2 if(OSC==4){
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x3A7
; 0000 07B3 a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 07B4 if(OSC==8){
_0x3A7:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x3A8
; 0000 07B5 a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 07B6 if(OSC==12){
_0x3A8:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x3A9
; 0000 07B7 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 07B8 if(OSC==16){
_0x3A9:
	LDS  R26,_OSC
	CPI  R26,LOW(0x10)
	BRNE _0x3AA
; 0000 07B9 a = 15;}}
	LDI  R30,LOW(15)
	STS  _a,R30
_0x3AA:
; 0000 07BA if(kondensatoriaus_rodymo_padetis==23){
_0x3A6:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x17)
	BRNE _0x3AB
; 0000 07BB if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x3AC
; 0000 07BC a = 24;}
	LDI  R30,LOW(24)
	STS  _a,R30
; 0000 07BD if(OSC==4){
_0x3AC:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x3AD
; 0000 07BE a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 07BF if(OSC==8){
_0x3AD:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x3AE
; 0000 07C0 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 07C1 if(OSC==12){
_0x3AE:
	LDS  R26,_OSC
	CPI  R26,LOW(0xC)
	BRNE _0x3AF
; 0000 07C2 a = 15;}}
	LDI  R30,LOW(15)
	STS  _a,R30
_0x3AF:
; 0000 07C3 if(kondensatoriaus_rodymo_padetis==24){
_0x3AB:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x18)
	BRNE _0x3B0
; 0000 07C4 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x3B1
; 0000 07C5 a = 28;}
	LDI  R30,LOW(28)
	STS  _a,R30
; 0000 07C6 if(OSC==4){
_0x3B1:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x3B2
; 0000 07C7 a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 07C8 if(OSC==8){
_0x3B2:
	LDS  R26,_OSC
	CPI  R26,LOW(0x8)
	BRNE _0x3B3
; 0000 07C9 a = 15;}}
	LDI  R30,LOW(15)
	STS  _a,R30
_0x3B3:
; 0000 07CA if(kondensatoriaus_rodymo_padetis==25){
_0x3B0:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x19)
	BRNE _0x3B4
; 0000 07CB if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x3B5
; 0000 07CC a = 5;}
	LDI  R30,LOW(5)
	STS  _a,R30
; 0000 07CD if(OSC==4){
_0x3B5:
	LDS  R26,_OSC
	CPI  R26,LOW(0x4)
	BRNE _0x3B6
; 0000 07CE a = 15;}}
	LDI  R30,LOW(15)
	STS  _a,R30
_0x3B6:
; 0000 07CF if(kondensatoriaus_rodymo_padetis==25){
_0x3B4:
	LDS  R26,_kondensatoriaus_rodymo_padetis
	CPI  R26,LOW(0x19)
	BRNE _0x3B7
; 0000 07D0 if(OSC==0){
	LDS  R30,_OSC
	CPI  R30,0
	BRNE _0x3B8
; 0000 07D1 a = 15;}}
	LDI  R30,LOW(15)
	STS  _a,R30
_0x3B8:
; 0000 07D2 
; 0000 07D3 }}
_0x3B7:
_0x305:
	RET
;
;
;
;void dabartinio_laiko_skaiciavimas(){
; 0000 07D7 void dabartinio_laiko_skaiciavimas(){
_dabartinio_laiko_skaiciavimas:
; 0000 07D8 viena_laikrodzio_sekunde = viena_laikrodzio_sekunde + 1;
	LDS  R30,_viena_laikrodzio_sekunde
	LDS  R31,_viena_laikrodzio_sekunde+1
	ADIW R30,1
	STS  _viena_laikrodzio_sekunde,R30
	STS  _viena_laikrodzio_sekunde+1,R31
; 0000 07D9 if(viena_laikrodzio_sekunde>=VIENA_SEKUNDE){
	RCALL SUBOPT_0x1A
	CP   R26,R8
	CPC  R27,R9
	BRLO _0x3B9
; 0000 07DA viena_laikrodzio_sekunde = 0;
	LDI  R30,LOW(0)
	STS  _viena_laikrodzio_sekunde,R30
	STS  _viena_laikrodzio_sekunde+1,R30
; 0000 07DB laikrodzio_sekundes = laikrodzio_sekundes + 1;}
	LDS  R30,_laikrodzio_sekundes
	SUBI R30,-LOW(1)
	STS  _laikrodzio_sekundes,R30
; 0000 07DC 
; 0000 07DD if(laikrodzio_sekundes>=60){
_0x3B9:
	LDS  R26,_laikrodzio_sekundes
	CPI  R26,LOW(0x3C)
	BRLT _0x3BA
; 0000 07DE laikrodzio_sekundes = 0;
	LDI  R30,LOW(0)
	STS  _laikrodzio_sekundes,R30
; 0000 07DF laikrodzio_minutes = laikrodzio_minutes + 1;}
	LDS  R30,_laikrodzio_minutes
	SUBI R30,-LOW(1)
	STS  _laikrodzio_minutes,R30
; 0000 07E0 
; 0000 07E1 if(laikrodzio_minutes>=60){
_0x3BA:
	LDS  R26,_laikrodzio_minutes
	CPI  R26,LOW(0x3C)
	BRLT _0x3BB
; 0000 07E2 laikrodzio_minutes = 0;
	LDI  R30,LOW(0)
	STS  _laikrodzio_minutes,R30
; 0000 07E3 laikrodzio_valandos = laikrodzio_valandos + 1;}
	LDS  R30,_laikrodzio_valandos
	SUBI R30,-LOW(1)
	STS  _laikrodzio_valandos,R30
; 0000 07E4 if(laikrodzio_minutes<0){
_0x3BB:
	LDS  R26,_laikrodzio_minutes
	CPI  R26,0
	BRGE _0x3BC
; 0000 07E5 laikrodzio_minutes = 59;
	LDI  R30,LOW(59)
	STS  _laikrodzio_minutes,R30
; 0000 07E6 laikrodzio_valandos = laikrodzio_valandos - 1;}
	LDS  R30,_laikrodzio_valandos
	RCALL SUBOPT_0x18
	STS  _laikrodzio_valandos,R30
; 0000 07E7 
; 0000 07E8 if(laikrodzio_valandos>=24){
_0x3BC:
	LDS  R26,_laikrodzio_valandos
	CPI  R26,LOW(0x18)
	BRLT _0x3BD
; 0000 07E9 laikrodzio_valandos = 0;}
	LDI  R30,LOW(0)
	STS  _laikrodzio_valandos,R30
; 0000 07EA if(laikrodzio_valandos<0){
_0x3BD:
	LDS  R26,_laikrodzio_valandos
	CPI  R26,0
	BRGE _0x3BE
; 0000 07EB laikrodzio_valandos = 23;}}
	LDI  R30,LOW(23)
	STS  _laikrodzio_valandos,R30
_0x3BE:
	RET
;
;
;
;void mosfet_valdymas(){
; 0000 07EF void mosfet_valdymas(){
_mosfet_valdymas:
; 0000 07F0 if((viena_laikrodzio_sekunde<PUSE_SEKUNDES)&&
; 0000 07F1 (viena_laikrodzio_sekunde>0)){
	RCALL SUBOPT_0x1A
	CP   R26,R10
	CPC  R27,R11
	BRSH _0x3C0
	RCALL SUBOPT_0x1A
	CALL __CPW02
	BRLO _0x3C1
_0x3C0:
	RJMP _0x3BF
_0x3C1:
; 0000 07F2 pfet_desinysis = 0;
	LDI  R30,LOW(0)
	STS  _pfet_desinysis,R30
; 0000 07F3 nfet_kairysis = 0;
	STS  _nfet_kairysis,R30
; 0000 07F4 
; 0000 07F5 pfet_kairysis = 1;
	LDI  R30,LOW(1)
	STS  _pfet_kairysis,R30
; 0000 07F6 nfet_desinysis = 1;}
	STS  _nfet_desinysis,R30
; 0000 07F7 
; 0000 07F8 if(viena_laikrodzio_sekunde>PUSE_SEKUNDES){
_0x3BF:
	RCALL SUBOPT_0x1A
	CP   R10,R26
	CPC  R11,R27
	BRSH _0x3C2
; 0000 07F9 pfet_kairysis = 0;
	LDI  R30,LOW(0)
	STS  _pfet_kairysis,R30
; 0000 07FA nfet_desinysis = 0;
	STS  _nfet_desinysis,R30
; 0000 07FB 
; 0000 07FC pfet_desinysis = 1;
	LDI  R30,LOW(1)
	STS  _pfet_desinysis,R30
; 0000 07FD nfet_kairysis = 1;}}
	STS  _nfet_kairysis,R30
_0x3C2:
	RET
;
;

	.DSEG
_OSC:
	.BYTE 0x1
_a:
	.BYTE 0x1
_segm_a:
	.BYTE 0x1
_segm_b:
	.BYTE 0x1
_segm_c:
	.BYTE 0x1
_segm_d:
	.BYTE 0x1
_segm_e:
	.BYTE 0x1
_segm_f:
	.BYTE 0x1
_segm_g:
	.BYTE 0x1
_segm_h:
	.BYTE 0x1
_MYGTUKAS_1:
	.BYTE 0x1
_MYGTUKAS_2:
	.BYTE 0x1
_MYGTUKAS_3:
	.BYTE 0x1
_MYGTUKAS_4:
	.BYTE 0x1
_MYGTUKAS_5:
	.BYTE 0x1
_MYGTUKAS_6:
	.BYTE 0x1
_MYGTUKAS_7:
	.BYTE 0x1
_mygtuko_OSR:
	.BYTE 0x1
_kondensatorius_tuscias:
	.BYTE 0x1
_kondensatorius_vidutinis:
	.BYTE 0x1
_kondensatorius_pilnas:
	.BYTE 0x1
_kondensatoriaus_rodymo_padetis:
	.BYTE 0x1
_kondensatoriaus_rodymo_laikas:
	.BYTE 0x2
_pasisveikinimo_laikas1:
	.BYTE 0x2
_pasisveikinimo_laikas2:
	.BYTE 0x1
_REDAGAVIMAS:
	.BYTE 0x1
_SKAICIUS_DEGA:
	.BYTE 0x1
_blyksincio_skaiciaus_laiko_paskutinis_ciklas:
	.BYTE 0x2
_blyksincio_skaiciaus_laikas:
	.BYTE 0x2
_blyksincio_skaiciaus_laiko_vidurinysis_ciklas:
	.BYTE 0x2
_viena_laikrodzio_sekunde:
	.BYTE 0x2
_laikrodzio_sekundes:
	.BYTE 0x1
_laikrodzio_minutes:
	.BYTE 0x1
_laikrodzio_valandos:
	.BYTE 0x1
_begancio_uzraso_DABAR_padetis:
	.BYTE 0x1
_begancio_uzraso_DABAR_laikas:
	.BYTE 0x2
_pfet_kairysis:
	.BYTE 0x1
_pfet_desinysis:
	.BYTE 0x1
_nfet_kairysis:
	.BYTE 0x1
_nfet_desinysis:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_1,R30
	STS  _MYGTUKAS_2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R26,0
	SBIC 0x10,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	STS  _mygtuko_OSR,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(1)
	STS  _segm_a,R30
	STS  _segm_b,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	STS  _segm_c,R30
	STS  _segm_d,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	STS  _segm_e,R30
	STS  _segm_f,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	STS  _segm_a,R30
	LDI  R30,LOW(1)
	STS  _segm_b,R30
	STS  _segm_c,R30
	LDI  R30,LOW(0)
	STS  _segm_d,R30
	STS  _segm_e,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	STS  _segm_f,R30
	STS  _segm_g,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	STS  _segm_c,R30
	LDI  R30,LOW(1)
	STS  _segm_d,R30
	STS  _segm_e,R30
	LDI  R30,LOW(0)
	STS  _segm_f,R30
	LDI  R30,LOW(1)
	STS  _segm_g,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	STS  _segm_e,R30
	STS  _segm_f,R30
	LDI  R30,LOW(1)
	STS  _segm_g,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	STS  _segm_f,R30
	STS  _segm_g,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(1)
	STS  _segm_a,R30
	LDI  R30,LOW(0)
	STS  _segm_b,R30
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	STS  _segm_e,R30
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(1)
	STS  _segm_c,R30
	LDI  R30,LOW(0)
	STS  _segm_d,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	STS  _segm_e,R30
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	STS  _segm_a,R30
	STS  _segm_b,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(1)
	STS  _segm_a,R30
	LDI  R30,LOW(0)
	STS  _segm_b,R30
	STS  _segm_c,R30
	LDI  R30,LOW(1)
	STS  _segm_d,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	STS  _segm_a,R30
	LDI  R30,LOW(1)
	STS  _segm_b,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(1)
	STS  _segm_e,R30
	LDI  R30,LOW(0)
	STS  _segm_f,R30
	LDI  R30,LOW(1)
	STS  _segm_g,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	STS  _segm_c,R30
	STS  _segm_d,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	STS  _segm_c,R30
	LDI  R30,LOW(1)
	STS  _segm_d,R30
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	STS  _segm_c,R30
	STS  _segm_d,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	LDI  R31,0
	SBRC R30,7
	SER  R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(1)
	STS  _REDAGAVIMAS,R30
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDS  R26,_viena_laikrodzio_sekunde
	LDS  R27,_viena_laikrodzio_sekunde+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	LDS  R26,_laikrodzio_valandos
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	SBC  R31,R27
	STS  _a,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	LDS  R26,_laikrodzio_minutes
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	STS  _MYGTUKAS_1,R30
	STS  _MYGTUKAS_5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	CALL __DIVW21U
	STS  _a,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	CALL __MULW12U
	MOVW R26,R30
	MOVW R30,R8
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
