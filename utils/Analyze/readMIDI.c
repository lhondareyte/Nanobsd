#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include "midi.h"


/*
 *  Librairie MIDI pour AVR
 *
 *  $Id: MIDI_Event.c,v 0.5 2011/01/21 08:35:37 luc Exp luc $
 *
 *  (c)2011 - Luc HONDAREYTE <luc.hondareyte@laposte.net>
 *
 */

#ifdef __AVR__
 #include "io.h"
#endif

#ifndef __AVR_MIDI_H__
 #include "midi.h"
#endif

#ifndef bit_is_set
 #define bit_is_set(var,pos) ((var) & (1<<(pos)))
#endif

int main(int argc, char *argv[]) {

	FILE *fp;
	uint8_t c;
	if ((fp=fopen(argv[1],"r"))==NULL)
	{
		perror(argv[1]);
		exit (1);
	}
	while (!feof(fp))
	{
		c=fgetc(fp);
		buffer=c;
		MIDI_Event();
	}
	return 0;
}
