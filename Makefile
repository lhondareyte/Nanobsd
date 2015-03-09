#
# $Id$
#
DEVICE     = /dev/ada1
MAKE       = /usr/local/bin/gmake
NANOSCRIPT = /usr/src/tools/tools/nanobsd/nanobsd.sh
MACHINE    = $(shell uname -m)
KERNEL     = kernel.$(MACHINE)
NANOCFG    = nanobsd.conf
DISKIMAGE  = /usr/obj/nanobsd.noizebox/_.disk.full 
NZ_ROOTSRC = $(shell dirname $(pwd))
MODULES    = utils

all:  extra
	@/bin/sh $(NANOSCRIPT) -c $(NANOCFG)
	#@/bin/sh $(NANOSCRIPT) -b -c $(NANOCFG)

extra:
	for dir in $(MODULES); do \
		(cd $$dir; ${MAKE} ); \
	done

world:
	@/bin/sh $(NANOSCRIPT) -k -i -c $(NANOCFG)

kernel:
	@echo "Building kernel for $(MACHINE)"
	@cp $(KERNEL) /usr/src/sys/$(MACHINE)/conf/AUDIOBOX
	@/bin/sh $(NANOSCRIPT) -w -i -c $(NANOCFG)

install: 
	@printf "Add loopback device ..."
	@$(eval MD = $(shell mdconfig -f $(DISKIMAGE)))
	@printf "y\ny\n" > /tmp/rep.nz
	@echo "done."
	@printf "Adding bootloader..."
	@fdisk -B  /dev/${MD} < /tmp/rep.nz > /dev/null 2>&1
	@rm -f /tmp/rep.nz
	@echo "done."
	@mdconfig -d -u $(MD)
	@printf "Writing image to disk..."
	@dd if=$(DISKIMAGE) of=$(DEVICE) bs=64k > /dev/null 2>&1
	@echo "done."
