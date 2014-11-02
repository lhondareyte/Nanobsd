PRG=AnalyzeMIDI
CFLAGS= -D __MIDI_RESET_ENABLE__
SRCS=readMIDI.c midi.c
OBJS=readMIDI.o midi.o

.c.o:
	@printf "Compiling $< ..." 
	@$(CC) $(CFLAGS) -c  $< -o $@
	@echo "done."

$(PRG): $(OBJS)
	@printf "Linking..."
	@$(CC) $(CFLAGS) $(OBJS) -o $(PRG)
	@echo "done."
clean:
	@printf "Cleaning..."
	@rm -f *.o $(PRG) *~
	@echo "done."
install:
	
