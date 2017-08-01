#
# This file is part of the spectro-450 Project.
#
# Copyright (c)2016-2017  Luc Hondareyte <lhondareyte_AT_laposte.net>.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in 
#    the documentation and/or other materials provided with the distribution.   
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
# OF THE POSSIBILITY OF # SUCH DAMAGE.
#

DEVICE     = /dev/ada1
NANOSCRIPT = /usr/src/tools/tools/nanobsd/nanobsd.sh
MACHINE    != uname -m
KERNEL     = kernel.$(MACHINE)
NANOCFG    = nanobsd.conf
DISKIMAGE  = /usr/obj/nanobsd.SPECTRO/_.disk.full 

all: world kernel diskimage

world:
	@/bin/sh $(NANOSCRIPT) -k -i -c $(NANOCFG)

kernel:
	@echo "Building kernel for $(MACHINE)"
	@cp $(KERNEL) /usr/src/sys/$(MACHINE)/conf/SPECTRO
	@/bin/sh $(NANOSCRIPT) -w -i -c $(NANOCFG)

diskimage:
	@/bin/sh $(NANOSCRIPT) -b -c $(NANOCFG)
	@cp $(DISKIMAGE) .

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
