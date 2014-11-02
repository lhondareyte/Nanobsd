/*
 * SYNTH PUNK CONSOLE Mark II
 * 
 * Copyright (c) 2010-2011 Luc Hondareyte <luc.hondareyte@laposte.net>
 * All rights reserved.
 *
 * $Id: midi.c,v 0.4 2011/03/11 10:12:06 luc Exp luc $
 */
#include <stdio.h>
#include <stdlib.h>
#include "midi.h"

#ifndef __AVR__
void MIDI_Event()
#else

#include "io.h"

ISR (UART_RECEIV_VECT)
#endif
{
	#if defined (__AVR__)
	buffer=UART_RX_BUF;
	#endif
	// Traitement Status Byte
	if (bit_is_set(buffer,7))
	{
		// ready=FALSE;
		// Channel messages
		if (buffer < MIDI_SYSEX_MSG) 
		{
			status=(buffer&0xF0);
			channel=(buffer&0x0F);
			next=MIDI_DATA1;
		}
		// System Common messages
		else if ( buffer < MIDI_TIMECL_MSG )
		{
			status=buffer;
			switch (buffer)
			{
			case MIDI_SYSEX_MSG:
				#ifndef __AVR__
			     	fprintf (stdout, "Message SYSEX (Début)\n",buffer);
				#endif
				next=MIDI_SYSEX_MSG;
				break;

			case MIDI_EOX_MSG:
				#ifndef __AVR__
			     	fprintf (stdout, "Message SYSEX (Fin)\n",buffer);
				#endif
				next=MIDI_UNKNOW_MSG;
				ready=TRUE;
				break;
			
			case MIDI_UNDEF1_MSG:
				ready=TRUE;
				break;

			case MIDI_UNDEF2_MSG:
				ready=TRUE;
				break;
			
			case MIDI_TUNERQ_MSG:
				ready=TRUE;
				break;
			
			default: 
				next=MIDI_DATA1;
				break;
			}
		}
		// System RealTime messages
		else
		{	switch (buffer)
			{
		
			// System Real time messages
			case MIDI_RESET_MSG : 
				#ifndef __AVR__
			     	fprintf (stdout, "Message RESET\n");
				#endif
				#if defined ( __MIDI_RESET_ENABLE__ )
				exit (0);
				#endif
				break;

			default:
				#ifndef __AVR__
			     	//printf (stdout, "Message temps rÃ©el: 0x%2x - Status= 0x%2x, DATA1= 0x%2x, DATA2= 0x%2x\n", 
			//			buffer, status, data1, data2);
				#endif
				break;
			}
		}
	}
	// Traitement des DATA Bytes
	else
	{
		switch (next)
		{
			case MIDI_DATA1: 
				data1=buffer;
				if (status == MIDI_PROGCH_MSG || status == MIDI_CHANAF_MSG || 
					status == MIDI_QUARTER_MSG || status == MIDI_SONGSEL_MSG )
				{
					next=MIDI_UNKNOW_MSG;
					ready=TRUE;
					#ifndef __AVR__
					switch (status)
					{
						case MIDI_PROGCH_MSG:
							fprintf(stdout, "Message PC: 0x%2x\n", data1);
							break;

						case MIDI_CHANAF_MSG:
							fprintf(stdout, "Message Channel AF: 0x%2x\n", data1);
							break;

						case MIDI_QUARTER_MSG:
							fprintf(stdout, "Message QT Frame: 0x%2x\n", data1);
							break;

						case MIDI_SONGSEL_MSG:
							fprintf(stdout, "Message Song Select: 0x%2x\n", data1);
							break;
					}
					#endif
				}
				else next=MIDI_DATA2;
				break;
						
			case MIDI_DATA2: 
				data2=buffer;
				switch (status)
				{
					case MIDI_NOTEON_MSG : 
						#ifndef __AVR__
						fprintf(stdout, "Message Note ON note: 0x%2x velo: 0x%2x",
									data1, data2);
						#endif
						if (data2==0) 
						{	
							status=MIDI_NOTOFF_MSG;
						#ifndef __AVR__
							fprintf(stdout, " (Note OFF)");
						#endif
						}
						#ifndef __AVR__
							fprintf(stdout, "\n");
						#endif
						break;

					case MIDI_NOTOFF_MSG : 
						#ifndef __AVR__
						fprintf(stdout, "Message Note OFF note: 0x%2x velo: 0x%2x\n", 
									data1, data2);
						#endif
						break;

					case MIDI_POLYAF_MSG : 
						#ifndef __AVR__
						fprintf(stdout, "Message Pol. AF note: 0x%2x velo: 0x%2x\n", 
									data1, data2);
						#endif
						break;

					case MIDI_CTRLCH_MSG : 
						#ifndef __AVR__
						fprintf(stdout, "Message CC: 0x%2x + 0x%2x\n", 
									data1, data2);
						#endif
						break;

					case MIDI_PITCHB_MSG : 
						#ifndef __AVR__
						fprintf(stdout, "Message Pitch Bend: 0x%2x + 0x%2x\n", 
									data1, data2);
						#endif
						break;

					case MIDI_SONGPOS_MSG :
						#ifndef __AVR__
						fprintf(stdout, "Message Song Position: 0x%2x + 0x%2x\n", 
									data1, data2); 
						#endif
						break;

					// Arrivé ici, on a une c. dans le potage!
					default: 
						#ifndef __AVR__
						fprintf (stdout, "Message PANIC MIDI!!\n");
						#endif
						status=MIDI_UNKNOW_MSG;
						next=MIDI_UNKNOW_MSG;
						ready=FALSE;
						#if defined (__MIDI_RESET_ON_ERROR__)
						exit (0);
						#endif
						break;
				}
				next=MIDI_UNKNOW_MSG;
				ready=TRUE;
				break;

			case MIDI_SYSEX_MSG :
				#if defined (MIDI_MANUFACTURER_ID)

				#endif
				next=MIDI_SYSEX_MSG;
				break;

			// Gestion du running status
			case MIDI_UNKNOW_MSG :
				if (status == MIDI_PROGCH_MSG || status == MIDI_CHANAF_MSG || 
					status == MIDI_QUARTER_MSG || status == MIDI_SONGSEL_MSG )
				{
					data1=buffer;
					ready=TRUE;
					next=MIDI_UNKNOW_MSG;
				#ifndef __AVR__
					fprintf(stdout, "(Running status On) - 1 \n");
					switch (status)
					{
						case MIDI_PROGCH_MSG : 
							break;
	
						case MIDI_CHANAF_MSG : 
							fprintf(stdout, "Message Canal AF: 0x%2x\n", data1);
							break;
					}
				#endif
				}
				else if (status < MIDI_SYSEX_MSG)
				{
					data1=buffer;
					next=MIDI_DATA2;
				#ifndef __AVR__
					fprintf(stdout, "Running status - Status= 0x%2x, DATA1= 0x%2x, DATA2= 0x%2x\n", 
							status, data1, data2);
				#endif
				}
				else 
				{
					status=MIDI_UNKNOW_MSG;
					next=MIDI_UNKNOW_MSG;
				}
				break;

			default:
				#ifndef __AVR__
				fprintf (stdout, "PANIC MIDI!!\n");
				#endif
				status=MIDI_UNKNOW_MSG;
				next=MIDI_UNKNOW_MSG;
				ready=FALSE;
				#if defined (__MIDI_RESET_ON_ERROR__)
				exit (0);
				#endif
				break;
		}
	}
	//buffer=0;
}

void MIDI_Ack (void)
{
//	status=MIDI_UNKNOW_MSG;  // Incompatible avec le running status
	next=MIDI_UNKNOW_MSG;
	ready=FALSE;
}

uint8_t MIDI_MsgReady(void)
{
 	return (ready);
}

void MIDI_Init(void)
{
	status=MIDI_UNKNOW_MSG;
	channel=0;
	buffer=0;
}
