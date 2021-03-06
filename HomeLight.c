/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
� Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2/12/2015
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

#include <delay.h>
#include <stdio.h>

// Alphanumeric LCD functions
#include <alcd.h>

#define ADC_VREF_TYPE 0xE0

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	// Delay needed for the stabilization of the ADC input voltage
	delay_us(10);
	// Start the AD conversion
	ADCSRA|=0x40;
	// Wait for the AD conversion to complete
	while ((ADCSRA & 0x10)==0);
	ADCSRA|=0x10;
	return ADCH;
}

// Declare your global variables here

void main(void)
{
	// Declare your local variables here
	/*
		Menu:
		0: 
			VAL:#### ####
			STATE:ON/OFF
		1: 
			SET ON VAL
		2: 
			SET OFF VAL
		3: 
			SET TIMER
		4: 
			?
	*/
	char buffer[32];
	
	int menu_state = 0;
	int state = 0; // current state 0-off 1-on
	int value = 0; // current value

	int timer = 0; // counter to change value 
	int timer_max = 1000; // counter to change value 
	int on_value = 200; // value to on
	int off_value = 50; // value to off
	
	int btn_next = 0; // is btn next pressed
	int btn_prev = 0; // is btn prev pressed 
	int btn_set = 0; // is btn set pressed
	
	int tmp_val = 0; // temporary value 
	int tmp_state = 0; // temporary state
	int i = 0;
	
	int lcd_timer = 500;
	// Input/Output Ports initialization
	// Port B initialization
	// Func7=In Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
	// State7=T State6=0 State5=0 State4=T State3=P State2=P State1=P State0=T 
	PORTB=0x0E;
	DDRB=0x60;

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
	// Clock source: System Clock
	// Clock value: Timer2 Stopped
	// Mode: Normal top=0xFF
	// OC2 output: Disconnected
	ASSR=0x00;
	TCCR2=0x00;
	TCNT2=0x00;
	OCR2=0x00;

	// External Interrupt(s) initialization
	// INT0: Off
	// INT1: Off
	MCUCR=0x00;

	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=0x00;

	// USART initialization
	// USART disabled
	UCSRB=0x00;

	// Analog Comparator initialization
	// Analog Comparator: Off
	// Analog Comparator Input Capture by Timer/Counter 1: Off
	ACSR=0x80;
	SFIOR=0x00;

	// ADC initialization
	// ADC Clock frequency: 62.500 kHz
	// ADC Voltage Reference: Int., cap. on AREF
	// Only the 8 most significant bits of
	// the AD conversion result are used
	ADMUX=ADC_VREF_TYPE & 0xff;
	ADCSRA=0x87;

	// SPI initialization
	// SPI disabled
	SPCR=0x00;

	// TWI initialization
	// TWI disabled
	TWCR=0x00;

	// Alphanumeric LCD initialization
	// Connections are specified in the
	// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
	// RS - PORTD Bit 6
	// RD - PORTD Bit 5
	// EN - PORTD Bit 4
	// D4 - PORTD Bit 3
	// D5 - PORTD Bit 2
	// D6 - PORTD Bit 1
	// D7 - PORTD Bit 0
	// Characters/line: 8
	lcd_init(8);

	for ( i = 0 ; i < 32 ; i ++ )
	{
		buffer[i] = ' ';
	}
	
	while (1)
	{
		// set buffer for writing on screen
		switch ( menu_state )
		{
			case 0:
				if ( state == 0 )
					sprintf ( buffer , "VAL: %d, %d\nSTATE: OFF" , value , timer );
				else
					sprintf ( buffer , "VAL: %d, %d\nSTATE: ON" , value , timer );
				break;
			case 1:
				sprintf ( buffer , "SET ON VALUE    ");
				break;
			case 2:
				sprintf ( buffer , "SET OFF VALUE   ");
				break;
			case 3:
				sprintf ( buffer , "SET TIMER VALUE ");
				break;
			case 4:
				sprintf ( buffer , "%d            " , tmp_val );
				break;
		}                  
        lcd_clear();
		lcd_puts ( buffer );
		// keys
		if ( PINB.1 == 0 && btn_set == 0 ) // on key down
		{
			btn_set = 1;
			if ( lcd_timer > 0 ) // if lcd is on
			{
				switch ( menu_state )
				{
					case 0:
						menu_state = 1;
						break;
					case 1:
						tmp_val = on_value ;
						tmp_state = 1;
						menu_state = 4;
						break;
					case 2:
						tmp_val = off_value ;
						tmp_state = 2;
						menu_state = 4;
						break;
					case 3:
						tmp_val = timer_max ;
						tmp_state = 3;
						menu_state = 4;
						break;
					case 4:
						switch ( tmp_state )
						{
							case 1:
								on_value = tmp_val;
								break;
							case 2:
								off_value = tmp_val;
								break;
							case 3:
								timer_max = tmp_val;
								break;
						}
						menu_state = 0;
						break;
				}
			}
			lcd_timer = 50;
		}
		else if ( PINB.1 == 1 )
		{
			btn_set = 0;
		}
		if ( PINB.2 == 0 && btn_next == 0 ) // on key down
		{
			btn_next = 1; 
			if ( lcd_timer > 0 ) // if lcd is on
			{
				switch ( menu_state )
				{
					case 0:
						break;
					case 1:
					case 2:
						menu_state ++;
						break;
					case 3:
						menu_state = 1;
						break;
					case 4:
						switch ( tmp_state )
						{
							case 1:
							case 2:
								tmp_val ++ ;
								break;
							case 3:
								if ( tmp_val >= 1200 )
								{
									tmp_val += 600 ;
								}
								else if ( tmp_val >= 600 )
								{
									tmp_val += 250 ;
								}
								else if ( tmp_val >= 300 )
								{
									tmp_val += 100 ;
								}
								else 
								{
									tmp_val += 10 ;
								}
								break;
						}
						break;
				}
			}
			lcd_timer = 50;
		}
		else if ( PINB.2 == 1 )
		{
			btn_next = 0;
		}
		if ( PINB.3 == 0 && btn_prev == 0 ) // on key down
		{
			btn_prev = 1; 
			if ( lcd_timer > 0 ) // if lcd is on
			{
				switch ( menu_state )
				{
					case 0:
						break;
					case 1:
						menu_state = 3;
						break;
					case 2:
					case 3:
						menu_state --;
						break;
					case 4:
						switch ( tmp_state )
						{
							case 1:
							case 2:
								tmp_val -- ;
								break;
							case 3:
								if ( tmp_val >= 1800 )
								{
									tmp_val -= 600 ;
								}
								else if ( tmp_val >= 850 )
								{
									tmp_val -= 250 ;
								}
								else if ( tmp_val >= 400 )
								{
									tmp_val -= 100 ;
								}
								else 
								{
									tmp_val -= 10 ;
								}
								break;
						}
						break;
				}
			}
			lcd_timer = 50;
		}
		else if ( PINB.3 == 1 )
		{
			btn_prev = 0;
		}
		
		// update values
		if ( lcd_timer > 0 )
		{
			PORTB.6 = 1;
			lcd_timer -- ; 
		}
		else
		{
			PORTB.6 = 0;
            menu_state = 0;
		}

		value = (int)read_adc(5);
		if ( value >= on_value && state == 0 || value <= off_value && state == 1 )
		{
			timer ++ ;
		}
		else
		{
			timer = 0;
		}
		
		if ( timer > timer_max )
		{
			if ( value >= on_value )
			{
				state = 1 ;
			}
			else if ( value <= off_value )
			{
				state = 0 ;
			}
		}
		
		PORTB.5 = state ;
		
		delay_ms(10);
	}
}
