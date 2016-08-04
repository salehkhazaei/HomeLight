/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2/11/2015
Author  : Saleh
Company : GRCG
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <stdio.h>
#include <delay.h>

// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here
int time_h, time_m, time_s;
// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
	time_s++;
	if(time_s==59){
		time_s=0;
		time_m++;
		if(time_m==59){
			time_m=0;
			time_h++;
			if(time_h==24){
				time_h=0;
			}
		}
	}  
}

void main(void)
{
	// menu
	int menu_state = 0;
	int tmp_st = 0; // 0 - time , 1 - ontime , 2 - offtime
	int tmp_so = 0; // 0 - do on , 1 - do off
	int tmp_h = 0, tmp_m = 0;
	int tmp_s = 0; // tmp state
	int tmp_oo = 0; // tmp on/off

	// btns
	int btn_next = 0;
	int btn_prev = 0;
	int btn_clr = 0;
	int btn_set = 0;

	// alarm (on/off)
	int do_on = 0;
	int on_h = 0, on_m = 0;

	int do_off = 0;
	int off_h = 0, off_m = 0;

	int current = 0 ;

	// lcd
	char buffer[32];
	int lcd_timeout = 0;
	int lcd_curr = 1 ;
	int lcd_time = 15;
	// Input/Output Ports initialization
	// Port B initialization
	// Func7=In Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
	// State7=T State6=T State5=0 State4=0 State3=P State2=P State1=P State0=P 
	PORTB=0x0F;
	DDRB=0x30;

	// Port C initialization
	// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
	// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
	PORTC=0x00;
	DDRC=0x00;

	// Port D initialization
	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
	// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
	PORTD=0x00;
	DDRD=0x00;

	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: Timer 0 Stopped
	TCCR0=0x00;
	TCNT0=0x00;

	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: Timer1 Stopped
	// Mode: Normal top=0xFFFF
	// OC1A output: Discon.
	// OC1B output: Discon.
	// Noise Canceler: Off
	// Input Capture on Falling Edge
	// Timer1 Overflow Interrupt: Off
	// Input Capture Interrupt: Off
	// Compare A Match Interrupt: Off
	// Compare B Match Interrupt: Off
	TCCR1A=0x00;
	TCCR1B=0x00;
	TCNT1H=0x00;
	TCNT1L=0x00;
	ICR1H=0x00;
	ICR1L=0x00;
	OCR1AH=0x00;
	OCR1AL=0x00;
	OCR1BH=0x00;
	OCR1BL=0x00;

	// Timer/Counter 2 initialization
	// Clock source: TOSC1 pin
	// Clock value: PCK2/128
	// Mode: Normal top=0xFF
	// OC2 output: Disconnected
	ASSR=0x08;
	TCCR2=0x05;
	TCNT2=0x00;
	OCR2=0x00;

	// External Interrupt(s) initialization
	// INT0: Off
	// INT1: Off
	MCUCR=0x00;

	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=0x40;

	// USART initialization
	// USART disabled
	UCSRB=0x00;

	// Analog Comparator initialization
	// Analog Comparator: Off
	// Analog Comparator Input Capture by Timer/Counter 1: Off
	ACSR=0x80;
	SFIOR=0x00;

	// ADC initialization
	// ADC disabled
	ADCSRA=0x00;

	// SPI initialization
	// SPI disabled
	SPCR=0x00;

	// TWI initialization
	// TWI disabled
	TWCR=0x00;

	// Alphanumeric LCD initialization
	// Connections are specified in the
	// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
	// RS - PORTC Bit 6
	// RD - PORTC Bit 5
	// EN - PORTC Bit 4
	// D4 - PORTC Bit 3
	// D5 - PORTC Bit 2
	// D6 - PORTC Bit 1
	// D7 - PORTC Bit 0
	// Characters/line: 16
	lcd_init(16);

	// Global enable interrupts
	#asm("sei")

	while (1)
	{
		// Place your code here
		switch ( menu_state )
		{
			case 0:                            
				if ( current == 0 )
				{
					sprintf(buffer,"%2d:%2d:%2d OFF    ON AT %2d:%2d     ",time_h,time_m,time_s,on_h,on_m);
				}
				else
				{
					sprintf(buffer,"%2d:%2d:%2d ON     OFF AT %2d:%2d    ",time_h,time_m,time_s,off_h,off_m);
				}
				break;
			case 1:
				sprintf(buffer,"SET TIME        %2d:%2d:%2d        ",time_h,time_m,time_s);
				break;
			case 2:
				sprintf(buffer,"SET ON TIME     %2d:%2d:%2d        ",time_h,time_m,time_s);
				break;
			case 3:
				sprintf(buffer,"SET OFF TIME    %2d:%2d:%2d        ",time_h,time_m,time_s);
				break;
			case 4:
				sprintf(buffer,"DO ON           %2d:%2d:%2d        ",time_h,time_m,time_s);
				break;
			case 5:
				sprintf(buffer,"DO OFF          %2d:%2d:%2d        ",time_h,time_m,time_s);
				break;
			case 6:
				sprintf(buffer,"SET LCD TIMEOUT %2d:%2d:%2d        ",time_h,time_m,time_s);
				break;
			case 7:
				sprintf(buffer,"%2d:%2d                           ",tmp_h,tmp_m);
				break;
			case 8:
				sprintf(buffer,"%d                          ",lcd_timeout);
				break;
			case 9:               
				if ( tmp_oo == 0 )
				{
					sprintf(buffer,"OFF                             ");
				}
				else
				{
					sprintf(buffer,"ON                              ");
				}
				break;
		}          
		lcd_puts(buffer);
		if ( PINB.3 == 0 && btn_next == 0 )
		{                                
			lcd_time = lcd_timeout ;
			if ( lcd_curr == 0 )
			{
				lcd_curr = 1 ;
			}
			else
			{
				btn_next = 1;
				switch ( menu_state )
				{
					case 0:
						current = 1 - current ;                            
						break;
					case 1:
					case 2:
					case 3:
					case 4:
					case 5:
						menu_state ++;
						break;
					case 6:
						menu_state = 0;
						break;
					case 7:            
						switch ( tmp_s )
						{
						case 0:
							tmp_h += 10 ;
							if ( tmp_h > 23 )
								tmp_h = 0;
							break;
						case 1:
							tmp_h ++ ;
							if ( tmp_h > 23 )
								tmp_h = 0;
							break;
						case 2:
							tmp_m += 10 ;
							if ( tmp_m > 59 )
								tmp_m = 0;
							break;
						case 3:
							tmp_m ++ ;
							if ( tmp_m > 59 )
								tmp_m = 0;
							break;
						}
						break;
					case 8:
						lcd_timeout ++ ;
						break;
					case 9:
						tmp_oo = 1 - tmp_oo ;               
						break;
				}
			}          
		}
		if ( PINB.2 == 0 && btn_prev == 0 )
		{
			lcd_time = lcd_timeout ;
			if ( lcd_curr == 0 )
			{
				lcd_curr = 1 ;
			}
			else
			{
				btn_prev = 1;
				switch ( menu_state )
				{
				case 0:
					current = 1 - current ;                            
					break;
				case 1:
					menu_state = 6;
					break;
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:
					menu_state --;
					break;
				case 7:            
					switch ( tmp_s )
					{
					case 0:
						tmp_h -= 10 ;
						if ( tmp_h < 0 )
							tmp_h = 23;
						break;
					case 1:
						tmp_h -- ;
						if ( tmp_h < 0 )
							tmp_h = 23;
						break;
					case 2:
						tmp_m -= 10 ;
						if ( tmp_m < 0 )
							tmp_m = 59;
						break;
					case 3:
						tmp_m -- ;
						if ( tmp_m < 0 )
							tmp_m = 59;
						break;
					}
					break;
				case 8:
					lcd_timeout -- ;
					break;
				case 9:
					tmp_oo = 1 - tmp_oo ;               
					break;
				}
			}          
		}
		if ( PINB.1 == 0 && btn_clr == 0 )
		{         
			lcd_time = lcd_timeout ;
			if ( lcd_curr == 0 )
			{
				lcd_curr = 1 ;
			}
			else
			{
				btn_clr = 1;
				switch ( menu_state )
				{
				case 0:
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:   
					menu_state = 0;
					break;
				case 7:            
					switch ( tmp_s )
					{
					case 0:
					case 1:
						tmp_h = 0 ;
						break;
					case 2:
					case 3:
						tmp_m = 0;
						break;
					}
					break;
				case 8:
					lcd_timeout = 0 ;
					break;
				case 9:
					break;
				}
			}          
		}
		if ( PINB.0 == 0 && btn_set == 0 )
		{
			lcd_time = lcd_timeout ;
			if ( lcd_curr == 0 )
			{
				lcd_curr = 1 ;
			}
			else
			{
				btn_set = 1;
				switch ( menu_state )
				{
				case 0:
					menu_state = 1;
					break;
				case 1:            
					menu_state = 7;
					tmp_st = 0 ;
					break;
				case 2:
					menu_state = 7;
					tmp_st = 1 ;
					break;
				case 3:
					menu_state = 7;
					tmp_st = 2 ;
					break;
				case 4:
					menu_state = 9;
					tmp_so = 0 ;
					break;
				case 5:
					menu_state = 9;
					tmp_so = 1 ;
					break;
				case 6:   
					menu_state = 8;
					break;
				case 7:
					tmp_s ++;
					if ( tmp_s > 3 )
					{                  
						if ( tmp_st == 0 )
						{
							time_h = tmp_h ;
							time_m = tmp_m ;
							time_s = 0 ;
						}             
						else if ( tmp_st == 1 )
						{
							on_h = tmp_h ;
							on_m = tmp_m ;
						}
						else if ( tmp_st == 2 )
						{
							off_h = tmp_h ;
							off_m = tmp_m ;
						}
						menu_state = 0;
					}             
					break;
				case 8:
					menu_state = 0;
					break;
				case 9:            
					if ( tmp_so == 0 )
					{
						do_on = tmp_oo ;
					}             
					else if ( tmp_so == 1 )
					{
						do_off = tmp_oo ;
					}
					menu_state = 0;
					break;
				}             
			}
		}                     
		if ( lcd_time == 0 )
		{
			lcd_curr = 0 ;
		}
		if ( do_on )
		{
			if ( time_h == on_h && time_m == on_m && time_s <= 1 )
			{
				current = 1;
			}               
		}
		if ( do_off )
		{
			if ( time_h == off_h && time_m == off_m && time_s <= 1 )
			{
				current = 0;
			}               
		}

		PORTB.4 = current ;
		PORTB.5 = lcd_curr;
		delay_ms(300);
	}
}
