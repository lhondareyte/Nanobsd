#include <stdio.h>
#include <stdlib.h>
#include <curses.h>
static WINDOW *screen;

int main(int argc, char *argv[])
{
	if ( argc <= 1 )  return (0);
	/* Init curses */
	int rc=0;
        int key,i;
	screen=initscr();
	noecho();
	curs_set(0);
	keypad(stdscr, 1);
	raw();
	cbreak();
	clear();
	for ( i = 1; i <= argc-1; i++)
	{
		mvprintw(i-1,0,"%s",argv[i]);
		refresh();
	}
	key=getch();
	if ( key != '1' ) rc=1;
	endwin();
	return (rc);
}
