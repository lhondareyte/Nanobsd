#
#  $Id$
# 
MAKE=gmake
MODULES = Analyze Upgrade
all:
	for dir in $(MODULES); do \
		(cd $$dir; ${MAKE} ); \
	done
clean:
	for dir in $(MODULES); do \
		(cd $$dir; ${MAKE} clean); \
	done
flash:
	dd if=
