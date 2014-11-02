/*
 *  Librairie MIDI pour AVR
 *  $Id: midi.h,v 1.7 2011/03/11 10:10:32 luc Exp luc $
 *
 *  (c)2011 - Luc HONDAREYTE <luc.hondareyte@laposte.net>
 *  All rights reserved
 */
#include <stdint.h>
 
#ifndef __AVR_MIDI_H__
 #define __AVR_MIDI_H__

#ifndef FALSE
 #define FALSE          0
#endif
#ifndef TRUE
 #define TRUE           1
#endif

#ifndef bit_is_set
 #define bit_is_set(var,pos) ((var) & (1<<(pos)))
#endif


/*
 *  Channel messages
 */

#define MIDI_UNKNOW_MSG		0x00
#define MIDI_NOTOFF_MSG		0x80
#define MIDI_NOTEON_MSG		0x90		
#define MIDI_POLYAF_MSG		0xA0		
#define MIDI_CTRLCH_MSG		0xB0
#define MIDI_MODECH_MSG		0xB0
#define MIDI_PROGCH_MSG		0xC0
#define MIDI_CHANAF_MSG		0xD0
#define MIDI_PITCHB_MSG		0xE0

/*
 *  System common messages
 */

#define MIDI_SYSEX_MSG		0xF0
#define MIDI_QUARTER_MSG	0xF1
#define MIDI_SONGPOS_MSG	0xF2
#define MIDI_SONGSEL_MSG	0xF3

/*
 *  One-byte System common messages
 */

#define MIDI_UNDEF1_MSG		0xF4
#define MIDI_UNDEF2_MSG		0xF5
#define MIDI_TUNERQ_MSG		0xF6
#define MIDI_EOX_MSG		0xF7

/*
 *  System Real Time messages
 */

#define MIDI_TIMECL_MSG		0xF8
#define MIDI_TIMETCK_MSG	0xF9
#define MIDI_START_MSG		0xFA
#define MIDI_CONTINUE_MSG	0xFB
#define MIDI_STOP_MSG		0xFC
#define MIDI_UNDEF3_MSG		0xFD
#define MIDI_ACTIVE_MSG		0xFE
#define MIDI_RESET_MSG		0xFF

#define MIDI_DATA1		1
#define MIDI_DATA2		2


volatile uint8_t buffer; 	// buffer de reception
volatile uint8_t status;
volatile uint8_t channel;	// Canal MIDI du message recu
volatile uint8_t next;		// Prochaine valeur attendue
volatile uint8_t data1;		//
volatile uint8_t data2;
volatile uint8_t ready;		// Message prêt ou non 
uint8_t activechannel;		// Canal MIDI actif

/*
 * SysEx message buffer
 */

#if defined (MIDI_MANUFACTURER_ID)

#endif

/*
 * Pseudo fonctions 
 */
 
#define	MIDI_SetRcvChannel(c)	activechannel=c
void	MIDI_Ack( void );
void	MIDI_Init( void );
uint8_t	MIDI_MsgReady( void );

#endif /* __AVR_MIDI_H__ */
