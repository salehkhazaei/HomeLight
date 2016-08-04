
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8.000000 MHz
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
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x6:
	.DB  0xF4,0x1,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x32,0x0
	.DB  0xC8,0x0,0xE8,0x3,0x0,0x0
_0x0:
	.DB  0x56,0x41,0x4C,0x3A,0x20,0x25,0x64,0x2C
	.DB  0x20,0x25,0x64,0xA,0x53,0x54,0x41,0x54
	.DB  0x45,0x3A,0x20,0x4F,0x46,0x46,0x0,0x56
	.DB  0x41,0x4C,0x3A,0x20,0x25,0x64,0x2C,0x20
	.DB  0x25,0x64,0xA,0x53,0x54,0x41,0x54,0x45
	.DB  0x3A,0x20,0x4F,0x4E,0x0,0x53,0x45,0x54
	.DB  0x20,0x4F,0x4E,0x20,0x56,0x41,0x4C,0x55
	.DB  0x45,0x20,0x20,0x20,0x20,0x0,0x53,0x45
	.DB  0x54,0x20,0x4F,0x46,0x46,0x20,0x56,0x41
	.DB  0x4C,0x55,0x45,0x20,0x20,0x20,0x0,0x53
	.DB  0x45,0x54,0x20,0x54,0x49,0x4D,0x45,0x52
	.DB  0x20,0x56,0x41,0x4C,0x55,0x45,0x20,0x0
	.DB  0x25,0x64,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0
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
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2/12/2015
;Author  : Saleh
;Company : GRCG
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
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
;
;#include <delay.h>
;#include <stdio.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;#define ADC_VREF_TYPE 0xE0
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0025 {

	.CSEG
_read_adc:
; 0000 0026 	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xE0)
	OUT  0x7,R30
; 0000 0027 	// Delay needed for the stabilization of the ADC input voltage
; 0000 0028 	delay_us(10);
	__DELAY_USB 27
; 0000 0029 	// Start the AD conversion
; 0000 002A 	ADCSRA|=0x40;
	SBI  0x6,6
; 0000 002B 	// Wait for the AD conversion to complete
; 0000 002C 	while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 002D 	ADCSRA|=0x10;
	SBI  0x6,4
; 0000 002E 	return ADCH;
	IN   R30,0x5
	RJMP _0x2080001
; 0000 002F }
;
;// Declare your global variables here
;
;void main(void)
; 0000 0034 {
_main:
; 0000 0035 	// Declare your local variables here
; 0000 0036 	/*
; 0000 0037 		Menu:
; 0000 0038 		0:
; 0000 0039 			VAL:#### ####
; 0000 003A 			STATE:ON/OFF
; 0000 003B 		1:
; 0000 003C 			SET ON VAL
; 0000 003D 		2:
; 0000 003E 			SET OFF VAL
; 0000 003F 		3:
; 0000 0040 			SET TIMER
; 0000 0041 		4:
; 0000 0042 			?
; 0000 0043 	*/
; 0000 0044 	char buffer[32];
; 0000 0045 
; 0000 0046 	int menu_state = 0;
; 0000 0047 	int state = 0; // current state 0-off 1-on
; 0000 0048 	int value = 0; // current value
; 0000 0049 
; 0000 004A 	int timer = 0; // counter to change value
; 0000 004B 	int timer_max = 1000; // counter to change value
; 0000 004C 	int on_value = 200; // value to on
; 0000 004D 	int off_value = 50; // value to off
; 0000 004E 
; 0000 004F 	int btn_next = 0; // is btn next pressed
; 0000 0050 	int btn_prev = 0; // is btn prev pressed
; 0000 0051 	int btn_set = 0; // is btn set pressed
; 0000 0052 
; 0000 0053 	int tmp_val = 0; // temporary value
; 0000 0054 	int tmp_state = 0; // temporary state
; 0000 0055 	int i = 0;
; 0000 0056 
; 0000 0057 	int lcd_timer = 500;
; 0000 0058 	// Input/Output Ports initialization
; 0000 0059 	// Port B initialization
; 0000 005A 	// Func7=In Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 005B 	// State7=T State6=0 State5=0 State4=T State3=P State2=P State1=P State0=T
; 0000 005C 	PORTB=0x0E;
	SBIW R28,54
	LDI  R24,22
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x6*2)
	LDI  R31,HIGH(_0x6*2)
	RCALL __INITLOCB
;	buffer -> Y+22
;	menu_state -> R16,R17
;	state -> R18,R19
;	value -> R20,R21
;	timer -> Y+20
;	timer_max -> Y+18
;	on_value -> Y+16
;	off_value -> Y+14
;	btn_next -> Y+12
;	btn_prev -> Y+10
;	btn_set -> Y+8
;	tmp_val -> Y+6
;	tmp_state -> Y+4
;	i -> Y+2
;	lcd_timer -> Y+0
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(14)
	OUT  0x18,R30
; 0000 005D 	DDRB=0x60;
	LDI  R30,LOW(96)
	OUT  0x17,R30
; 0000 005E 
; 0000 005F 	// Port C initialization
; 0000 0060 	// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0061 	// State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0062 	PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0063 	DDRC=0x00;
	OUT  0x14,R30
; 0000 0064 
; 0000 0065 	// Port D initialization
; 0000 0066 	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0067 	// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0068 	PORTD=0x00;
	OUT  0x12,R30
; 0000 0069 	DDRD=0x00;
	OUT  0x11,R30
; 0000 006A 
; 0000 006B 	// Timer/Counter 0 initialization
; 0000 006C 	// Clock source: System Clock
; 0000 006D 	// Clock value: Timer 0 Stopped
; 0000 006E 	TCCR0=0x00;
	OUT  0x33,R30
; 0000 006F 	TCNT0=0x00;
	OUT  0x32,R30
; 0000 0070 
; 0000 0071 	// Timer/Counter 1 initialization
; 0000 0072 	// Clock source: System Clock
; 0000 0073 	// Clock value: Timer1 Stopped
; 0000 0074 	// Mode: Normal top=0xFFFF
; 0000 0075 	// OC1A output: Discon.
; 0000 0076 	// OC1B output: Discon.
; 0000 0077 	// Noise Canceler: Off
; 0000 0078 	// Input Capture on Falling Edge
; 0000 0079 	// Timer1 Overflow Interrupt: Off
; 0000 007A 	// Input Capture Interrupt: Off
; 0000 007B 	// Compare A Match Interrupt: Off
; 0000 007C 	// Compare B Match Interrupt: Off
; 0000 007D 	TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 007E 	TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 007F 	TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0080 	TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0081 	ICR1H=0x00;
	OUT  0x27,R30
; 0000 0082 	ICR1L=0x00;
	OUT  0x26,R30
; 0000 0083 	OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0084 	OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0085 	OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0086 	OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0087 
; 0000 0088 	// Timer/Counter 2 initialization
; 0000 0089 	// Clock source: System Clock
; 0000 008A 	// Clock value: Timer2 Stopped
; 0000 008B 	// Mode: Normal top=0xFF
; 0000 008C 	// OC2 output: Disconnected
; 0000 008D 	ASSR=0x00;
	OUT  0x22,R30
; 0000 008E 	TCCR2=0x00;
	OUT  0x25,R30
; 0000 008F 	TCNT2=0x00;
	OUT  0x24,R30
; 0000 0090 	OCR2=0x00;
	OUT  0x23,R30
; 0000 0091 
; 0000 0092 	// External Interrupt(s) initialization
; 0000 0093 	// INT0: Off
; 0000 0094 	// INT1: Off
; 0000 0095 	MCUCR=0x00;
	OUT  0x35,R30
; 0000 0096 
; 0000 0097 	// Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0098 	TIMSK=0x00;
	OUT  0x39,R30
; 0000 0099 
; 0000 009A 	// USART initialization
; 0000 009B 	// USART disabled
; 0000 009C 	UCSRB=0x00;
	OUT  0xA,R30
; 0000 009D 
; 0000 009E 	// Analog Comparator initialization
; 0000 009F 	// Analog Comparator: Off
; 0000 00A0 	// Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00A1 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00A2 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00A3 
; 0000 00A4 	// ADC initialization
; 0000 00A5 	// ADC Clock frequency: 62.500 kHz
; 0000 00A6 	// ADC Voltage Reference: Int., cap. on AREF
; 0000 00A7 	// Only the 8 most significant bits of
; 0000 00A8 	// the AD conversion result are used
; 0000 00A9 	ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 00AA 	ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 00AB 
; 0000 00AC 	// SPI initialization
; 0000 00AD 	// SPI disabled
; 0000 00AE 	SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00AF 
; 0000 00B0 	// TWI initialization
; 0000 00B1 	// TWI disabled
; 0000 00B2 	TWCR=0x00;
	OUT  0x36,R30
; 0000 00B3 
; 0000 00B4 	// Alphanumeric LCD initialization
; 0000 00B5 	// Connections are specified in the
; 0000 00B6 	// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00B7 	// RS - PORTD Bit 6
; 0000 00B8 	// RD - PORTD Bit 5
; 0000 00B9 	// EN - PORTD Bit 4
; 0000 00BA 	// D4 - PORTD Bit 3
; 0000 00BB 	// D5 - PORTD Bit 2
; 0000 00BC 	// D6 - PORTD Bit 1
; 0000 00BD 	// D7 - PORTD Bit 0
; 0000 00BE 	// Characters/line: 8
; 0000 00BF 	lcd_init(8);
	LDI  R26,LOW(8)
	RCALL _lcd_init
; 0000 00C0 
; 0000 00C1 	for ( i = 0 ; i < 32 ; i ++ )
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
_0x8:
	RCALL SUBOPT_0x0
	SBIW R26,32
	BRGE _0x9
; 0000 00C2 	{
; 0000 00C3 		buffer[i] = ' ';
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	MOVW R26,R28
	ADIW R26,22
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(32)
	ST   X,R30
; 0000 00C4 	}
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
	RJMP _0x8
_0x9:
; 0000 00C5 
; 0000 00C6 	while (1)
_0xA:
; 0000 00C7 	{
; 0000 00C8 		// set buffer for writing on screen
; 0000 00C9 		switch ( menu_state )
	RCALL SUBOPT_0x1
; 0000 00CA 		{
; 0000 00CB 			case 0:
	BRNE _0x10
; 0000 00CC 				if ( state == 0 )
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x11
; 0000 00CD 					sprintf ( buffer , "VAL: %d, %d\nSTATE: OFF" , value , timer );
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,0
	RJMP _0x78
; 0000 00CE 				else
_0x11:
; 0000 00CF 					sprintf ( buffer , "VAL: %d, %d\nSTATE: ON" , value , timer );
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,23
_0x78:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	RCALL SUBOPT_0x3
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	RCALL SUBOPT_0x3
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
; 0000 00D0 				break;
	RJMP _0xF
; 0000 00D1 			case 1:
_0x10:
	RCALL SUBOPT_0x4
	BRNE _0x13
; 0000 00D2 				sprintf ( buffer , "SET ON VALUE    ");
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,45
	RCALL SUBOPT_0x5
; 0000 00D3 				break;
	RJMP _0xF
; 0000 00D4 			case 2:
_0x13:
	RCALL SUBOPT_0x6
	BRNE _0x14
; 0000 00D5 				sprintf ( buffer , "SET OFF VALUE   ");
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,62
	RCALL SUBOPT_0x5
; 0000 00D6 				break;
	RJMP _0xF
; 0000 00D7 			case 3:
_0x14:
	RCALL SUBOPT_0x7
	BRNE _0x15
; 0000 00D8 				sprintf ( buffer , "SET TIMER VALUE ");
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,79
	RCALL SUBOPT_0x5
; 0000 00D9 				break;
	RJMP _0xF
; 0000 00DA 			case 4:
_0x15:
	RCALL SUBOPT_0x8
	BRNE _0xF
; 0000 00DB 				sprintf ( buffer , "%d            " , tmp_val );
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,96
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x3
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 00DC 				break;
; 0000 00DD 		}
_0xF:
; 0000 00DE         lcd_clear();
	RCALL _lcd_clear
; 0000 00DF 		lcd_puts ( buffer );
	MOVW R26,R28
	ADIW R26,22
	RCALL _lcd_puts
; 0000 00E0 		// keys
; 0000 00E1 		if ( PINB.1 == 0 && btn_set == 0 ) // on key down
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x18
	RCALL SUBOPT_0x9
	SBIW R26,0
	BREQ _0x19
_0x18:
	RJMP _0x17
_0x19:
; 0000 00E2 		{
; 0000 00E3 			btn_set = 1;
	RCALL SUBOPT_0xA
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 00E4 			if ( lcd_timer > 0 ) // if lcd is on
	RCALL SUBOPT_0xB
	BRGE _0x1A
; 0000 00E5 			{
; 0000 00E6 				switch ( menu_state )
	RCALL SUBOPT_0x1
; 0000 00E7 				{
; 0000 00E8 					case 0:
	BRNE _0x1E
; 0000 00E9 						menu_state = 1;
	__GETWRN 16,17,1
; 0000 00EA 						break;
	RJMP _0x1D
; 0000 00EB 					case 1:
_0x1E:
	RCALL SUBOPT_0x4
	BRNE _0x1F
; 0000 00EC 						tmp_val = on_value ;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 00ED 						tmp_state = 1;
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xE
; 0000 00EE 						menu_state = 4;
; 0000 00EF 						break;
	RJMP _0x1D
; 0000 00F0 					case 2:
_0x1F:
	RCALL SUBOPT_0x6
	BRNE _0x20
; 0000 00F1 						tmp_val = off_value ;
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	RCALL SUBOPT_0xD
; 0000 00F2 						tmp_state = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0xE
; 0000 00F3 						menu_state = 4;
; 0000 00F4 						break;
	RJMP _0x1D
; 0000 00F5 					case 3:
_0x20:
	RCALL SUBOPT_0x7
	BRNE _0x21
; 0000 00F6 						tmp_val = timer_max ;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	RCALL SUBOPT_0xD
; 0000 00F7 						tmp_state = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0xE
; 0000 00F8 						menu_state = 4;
; 0000 00F9 						break;
	RJMP _0x1D
; 0000 00FA 					case 4:
_0x21:
	RCALL SUBOPT_0x8
	BRNE _0x1D
; 0000 00FB 						switch ( tmp_state )
	RCALL SUBOPT_0xF
; 0000 00FC 						{
; 0000 00FD 							case 1:
	BRNE _0x26
; 0000 00FE 								on_value = tmp_val;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
; 0000 00FF 								break;
	RJMP _0x25
; 0000 0100 							case 2:
_0x26:
	RCALL SUBOPT_0x6
	BRNE _0x27
; 0000 0101 								off_value = tmp_val;
	RCALL SUBOPT_0x10
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 0102 								break;
	RJMP _0x25
; 0000 0103 							case 3:
_0x27:
	RCALL SUBOPT_0x7
	BRNE _0x25
; 0000 0104 								timer_max = tmp_val;
	RCALL SUBOPT_0x10
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 0105 								break;
; 0000 0106 						}
_0x25:
; 0000 0107 						menu_state = 0;
	__GETWRN 16,17,0
; 0000 0108 						break;
; 0000 0109 				}
_0x1D:
; 0000 010A 			}
; 0000 010B 			lcd_timer = 50;
_0x1A:
	RCALL SUBOPT_0x12
; 0000 010C 		}
; 0000 010D 		else if ( PINB.1 == 1 )
	RJMP _0x29
_0x17:
	SBIS 0x16,1
	RJMP _0x2A
; 0000 010E 		{
; 0000 010F 			btn_set = 0;
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
; 0000 0110 		}
; 0000 0111 		if ( PINB.2 == 0 && btn_next == 0 ) // on key down
_0x2A:
_0x29:
	LDI  R26,0
	SBIC 0x16,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x2C
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,0
	BREQ _0x2D
_0x2C:
	RJMP _0x2B
_0x2D:
; 0000 0112 		{
; 0000 0113 			btn_next = 1;
	RCALL SUBOPT_0xA
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0114 			if ( lcd_timer > 0 ) // if lcd is on
	RCALL SUBOPT_0xB
	BRGE _0x2E
; 0000 0115 			{
; 0000 0116 				switch ( menu_state )
	RCALL SUBOPT_0x1
; 0000 0117 				{
; 0000 0118 					case 0:
	BREQ _0x31
; 0000 0119 						break;
; 0000 011A 					case 1:
	RCALL SUBOPT_0x4
	BREQ _0x34
; 0000 011B 					case 2:
	RCALL SUBOPT_0x6
	BRNE _0x35
_0x34:
; 0000 011C 						menu_state ++;
	__ADDWRN 16,17,1
; 0000 011D 						break;
	RJMP _0x31
; 0000 011E 					case 3:
_0x35:
	RCALL SUBOPT_0x7
	BRNE _0x36
; 0000 011F 						menu_state = 1;
	__GETWRN 16,17,1
; 0000 0120 						break;
	RJMP _0x31
; 0000 0121 					case 4:
_0x36:
	RCALL SUBOPT_0x8
	BRNE _0x31
; 0000 0122 						switch ( tmp_state )
	RCALL SUBOPT_0xF
; 0000 0123 						{
; 0000 0124 							case 1:
	BREQ _0x3C
; 0000 0125 							case 2:
	RCALL SUBOPT_0x6
	BRNE _0x3D
_0x3C:
; 0000 0126 								tmp_val ++ ;
	RCALL SUBOPT_0x10
	ADIW R30,1
	RJMP _0x79
; 0000 0127 								break;
; 0000 0128 							case 3:
_0x3D:
	RCALL SUBOPT_0x7
	BRNE _0x3A
; 0000 0129 								if ( tmp_val >= 1200 )
	RCALL SUBOPT_0x13
	CPI  R26,LOW(0x4B0)
	LDI  R30,HIGH(0x4B0)
	CPC  R27,R30
	BRLT _0x3F
; 0000 012A 								{
; 0000 012B 									tmp_val += 600 ;
	RCALL SUBOPT_0x10
	SUBI R30,LOW(-600)
	SBCI R31,HIGH(-600)
	RJMP _0x79
; 0000 012C 								}
; 0000 012D 								else if ( tmp_val >= 600 )
_0x3F:
	RCALL SUBOPT_0x13
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLT _0x41
; 0000 012E 								{
; 0000 012F 									tmp_val += 250 ;
	RCALL SUBOPT_0x10
	SUBI R30,LOW(-250)
	SBCI R31,HIGH(-250)
	RJMP _0x79
; 0000 0130 								}
; 0000 0131 								else if ( tmp_val >= 300 )
_0x41:
	RCALL SUBOPT_0x13
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLT _0x43
; 0000 0132 								{
; 0000 0133 									tmp_val += 100 ;
	RCALL SUBOPT_0x10
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	RJMP _0x79
; 0000 0134 								}
; 0000 0135 								else
_0x43:
; 0000 0136 								{
; 0000 0137 									tmp_val += 10 ;
	RCALL SUBOPT_0x10
	ADIW R30,10
_0x79:
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0138 								}
; 0000 0139 								break;
; 0000 013A 						}
_0x3A:
; 0000 013B 						break;
; 0000 013C 				}
_0x31:
; 0000 013D 			}
; 0000 013E 			lcd_timer = 50;
_0x2E:
	RCALL SUBOPT_0x12
; 0000 013F 		}
; 0000 0140 		else if ( PINB.2 == 1 )
	RJMP _0x45
_0x2B:
	SBIS 0x16,2
	RJMP _0x46
; 0000 0141 		{
; 0000 0142 			btn_next = 0;
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
; 0000 0143 		}
; 0000 0144 		if ( PINB.3 == 0 && btn_prev == 0 ) // on key down
_0x46:
_0x45:
	LDI  R26,0
	SBIC 0x16,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x48
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,0
	BREQ _0x49
_0x48:
	RJMP _0x47
_0x49:
; 0000 0145 		{
; 0000 0146 			btn_prev = 1;
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x14
; 0000 0147 			if ( lcd_timer > 0 ) // if lcd is on
	RCALL SUBOPT_0xB
	BRGE _0x4A
; 0000 0148 			{
; 0000 0149 				switch ( menu_state )
	RCALL SUBOPT_0x1
; 0000 014A 				{
; 0000 014B 					case 0:
	BREQ _0x4D
; 0000 014C 						break;
; 0000 014D 					case 1:
	RCALL SUBOPT_0x4
	BRNE _0x4F
; 0000 014E 						menu_state = 3;
	__GETWRN 16,17,3
; 0000 014F 						break;
	RJMP _0x4D
; 0000 0150 					case 2:
_0x4F:
	RCALL SUBOPT_0x6
	BREQ _0x51
; 0000 0151 					case 3:
	RCALL SUBOPT_0x7
	BRNE _0x52
_0x51:
; 0000 0152 						menu_state --;
	__SUBWRN 16,17,1
; 0000 0153 						break;
	RJMP _0x4D
; 0000 0154 					case 4:
_0x52:
	RCALL SUBOPT_0x8
	BRNE _0x4D
; 0000 0155 						switch ( tmp_state )
	RCALL SUBOPT_0xF
; 0000 0156 						{
; 0000 0157 							case 1:
	BREQ _0x58
; 0000 0158 							case 2:
	RCALL SUBOPT_0x6
	BRNE _0x59
_0x58:
; 0000 0159 								tmp_val -- ;
	RCALL SUBOPT_0x10
	SBIW R30,1
	RJMP _0x7A
; 0000 015A 								break;
; 0000 015B 							case 3:
_0x59:
	RCALL SUBOPT_0x7
	BRNE _0x56
; 0000 015C 								if ( tmp_val >= 1800 )
	RCALL SUBOPT_0x13
	CPI  R26,LOW(0x708)
	LDI  R30,HIGH(0x708)
	CPC  R27,R30
	BRLT _0x5B
; 0000 015D 								{
; 0000 015E 									tmp_val -= 600 ;
	RCALL SUBOPT_0x10
	SUBI R30,LOW(600)
	SBCI R31,HIGH(600)
	RJMP _0x7A
; 0000 015F 								}
; 0000 0160 								else if ( tmp_val >= 850 )
_0x5B:
	RCALL SUBOPT_0x13
	CPI  R26,LOW(0x352)
	LDI  R30,HIGH(0x352)
	CPC  R27,R30
	BRLT _0x5D
; 0000 0161 								{
; 0000 0162 									tmp_val -= 250 ;
	RCALL SUBOPT_0x10
	SUBI R30,LOW(250)
	SBCI R31,HIGH(250)
	RJMP _0x7A
; 0000 0163 								}
; 0000 0164 								else if ( tmp_val >= 400 )
_0x5D:
	RCALL SUBOPT_0x13
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLT _0x5F
; 0000 0165 								{
; 0000 0166 									tmp_val -= 100 ;
	RCALL SUBOPT_0x10
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	RJMP _0x7A
; 0000 0167 								}
; 0000 0168 								else
_0x5F:
; 0000 0169 								{
; 0000 016A 									tmp_val -= 10 ;
	RCALL SUBOPT_0x10
	SBIW R30,10
_0x7A:
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 016B 								}
; 0000 016C 								break;
; 0000 016D 						}
_0x56:
; 0000 016E 						break;
; 0000 016F 				}
_0x4D:
; 0000 0170 			}
; 0000 0171 			lcd_timer = 50;
_0x4A:
	RCALL SUBOPT_0x12
; 0000 0172 		}
; 0000 0173 		else if ( PINB.3 == 1 )
	RJMP _0x61
_0x47:
	SBIS 0x16,3
	RJMP _0x62
; 0000 0174 		{
; 0000 0175 			btn_prev = 0;
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
; 0000 0176 		}
; 0000 0177 
; 0000 0178 		// update values
; 0000 0179 		if ( lcd_timer > 0 )
_0x62:
_0x61:
	RCALL SUBOPT_0xB
	BRGE _0x63
; 0000 017A 		{
; 0000 017B 			PORTB.6 = 1;
	SBI  0x18,6
; 0000 017C 			lcd_timer -- ;
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 017D 		}
; 0000 017E 		else
	RJMP _0x66
_0x63:
; 0000 017F 		{
; 0000 0180 			PORTB.6 = 0;
	CBI  0x18,6
; 0000 0181             menu_state = 0;
	__GETWRN 16,17,0
; 0000 0182 		}
_0x66:
; 0000 0183 
; 0000 0184 		value = (int)read_adc(5);
	LDI  R26,LOW(5)
	RCALL _read_adc
	MOV  R20,R30
	CLR  R21
; 0000 0185 		if ( value >= on_value && state == 0 || value <= off_value && state == 1 )
	RCALL SUBOPT_0xC
	CP   R20,R30
	CPC  R21,R31
	BRLT _0x6A
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BREQ _0x6C
_0x6A:
	RCALL SUBOPT_0x15
	BRLT _0x6D
	RCALL SUBOPT_0xA
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x6C
_0x6D:
	RJMP _0x69
_0x6C:
; 0000 0186 		{
; 0000 0187 			timer ++ ;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ADIW R30,1
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 0188 		}
; 0000 0189 		else
	RJMP _0x70
_0x69:
; 0000 018A 		{
; 0000 018B 			timer = 0;
	LDI  R30,LOW(0)
	STD  Y+20,R30
	STD  Y+20+1,R30
; 0000 018C 		}
_0x70:
; 0000 018D 
; 0000 018E 		if ( timer > timer_max )
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x71
; 0000 018F 		{
; 0000 0190 			if ( value >= on_value )
	RCALL SUBOPT_0xC
	CP   R20,R30
	CPC  R21,R31
	BRLT _0x72
; 0000 0191 			{
; 0000 0192 				state = 1 ;
	__GETWRN 18,19,1
; 0000 0193 			}
; 0000 0194 			else if ( value <= off_value )
	RJMP _0x73
_0x72:
	RCALL SUBOPT_0x15
	BRLT _0x74
; 0000 0195 			{
; 0000 0196 				state = 0 ;
	__GETWRN 18,19,0
; 0000 0197 			}
; 0000 0198 		}
_0x74:
_0x73:
; 0000 0199 
; 0000 019A 		PORTB.5 = state ;
_0x71:
	CPI  R18,0
	BRNE _0x75
	CBI  0x18,5
	RJMP _0x76
_0x75:
	SBI  0x18,5
_0x76:
; 0000 019B 
; 0000 019C 		delay_ms(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0x16
; 0000 019D 	}
	RJMP _0xA
; 0000 019E }
_0x77:
	RJMP _0x77
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

	.CSEG
_put_buff_G100:
	RCALL SUBOPT_0x17
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x0
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x18
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x0
	ADIW R26,2
	RCALL SUBOPT_0x19
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0x0
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x19
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x0
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
__print_G100:
	RCALL SUBOPT_0x17
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x1A
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x1A
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0xC
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x1C
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x13
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x13
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0xD
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0xD
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x14
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x14
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x14
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x1A
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	RCALL SUBOPT_0x10
	LPM  R18,Z+
	RCALL SUBOPT_0xD
	RJMP _0x2000054
_0x2000053:
	RCALL SUBOPT_0x13
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	RCALL SUBOPT_0x10
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	RCALL SUBOPT_0x10
	ADIW R30,2
	RCALL SUBOPT_0xD
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	RCALL SUBOPT_0x9
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x14
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	RCALL SUBOPT_0x9
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x1C
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x9
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x1C
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x1E
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080002
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0xD
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	RCALL SUBOPT_0x13
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080002:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
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

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x12,3
	RJMP _0x2020005
_0x2020004:
	CBI  0x12,3
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x12,2
	RJMP _0x2020007
_0x2020006:
	CBI  0x12,2
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x12,1
	RJMP _0x2020009
_0x2020008:
	CBI  0x12,1
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x12,0
	RJMP _0x202000B
_0x202000A:
	CBI  0x12,0
_0x202000B:
	__DELAY_USB 5
	SBI  0x12,4
	__DELAY_USB 13
	CBI  0x12,4
	__DELAY_USB 13
	RJMP _0x2080001
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x2080001
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x16
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x16
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	CP   R5,R7
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2080001
_0x2020010:
	INC  R5
	SBI  0x12,6
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,6
	RJMP _0x2080001
_lcd_puts:
	RCALL SUBOPT_0x17
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	SBI  0x11,3
	SBI  0x11,2
	SBI  0x11,1
	SBI  0x11,0
	SBI  0x11,4
	SBI  0x11,6
	SBI  0x11,5
	CBI  0x12,4
	CBI  0x12,6
	CBI  0x12,5
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strlen:
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0x17
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
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOVW R30,R16
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	MOVW R30,R28
	ADIW R30,22
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	RCALL __CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	LD   R26,Y
	LDD  R27,Y+1
	RCALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	STD  Y+4,R30
	STD  Y+4+1,R31
	__GETWRN 16,17,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CP   R30,R20
	CPC  R31,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1A:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0xC
	SBIW R30,4
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
