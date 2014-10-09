###############################################################################
#                                                                             #
#                              libdialplan                                    #
#                                                                             #
#                                Makefile                                     #
#                                                                             #
#                       Copyright (C) 2012-, AdaHeads K/S                     #
#                                                                             #
#  This is free software;  you can redistribute it  and/or modify it          #
#  under terms of the  GNU General Public License as published  by the        #
#  Free Software  Foundation;  either version 3,  or (at your option) any     #
#  later version.  This software is distributed in the hope  that it will     #
#  be useful, but WITHOUT ANY WARRANTY;  without even the implied warranty    #
#  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU        #
#  General Public License for  more details.                                  #
#  You should have  received  a copy of the GNU General  Public  License      #
#  distributed  with  this  software;   see  file COPYING3.  If not, go       #
#  to http://www.gnu.org/licenses for a complete copy of the license.         #
#                                                                             #
###############################################################################

-include .config

PROJECT=libdialplan

ifeq ($(PROCESSORS),)
PROCESSORS=`(test -f /proc/cpuinfo && grep -c ^processor /proc/cpuinfo) || echo 1`
endif

ifeq ($(INSTALL),)
INSTALL=sudo install
endif

ifeq ($(PREFIX),)
PREFIX=/usr/local
endif

all: tests

build: fix-whitespace
	gnatmake -j${PROCESSORS} -p -P$(PROJECT)

debug:
	BUILDTYPE=Debug gnatmake -j${PROCESSORS} -p -P$(PROJECT)

clean: cleanup_messy_temp_files
	gnatclean -P$(PROJECT) || true
	BUILDTYPE=Debug gnatclean -P$(PROJECT) || true

distclean: clean
	rm -f  .config
	rm -fr library build_production build_debug
	rm -fr tests/freeswitch-compiler/compiled

tests: build
	@./tests/build
	@./tests/run

install: tests .config
	$(INSTALL) --target-directory=$(DESTDIR)$(PREFIX)/lib/gnat                  gpr/$(PROJECT).gpr
	$(INSTALL) --directory        $(DESTDIR)$(PREFIX)/$(PROJECT)
	$(INSTALL) --target-directory=$(DESTDIR)$(PREFIX)/$(PROJECT)                library/*
	$(INSTALL) --directory        $(DESTDIR)$(PREFIX)/include/$(PROJECT)
	$(INSTALL) --target-directory=$(DESTDIR)$(PREFIX)/include/$(PROJECT)        src/*.ad[sb]
	$(INSTALL) --directory        $(DESTDIR)$(PREFIX)/share/doc/$(PROJECT)
	$(INSTALL) --target-directory=$(DESTDIR)$(PREFIX)/share/doc/$(PROJECT)      README COPYING3 COPYING.RUNTIME dtds/*
	$(INSTALL) --directory        $(DESTDIR)$(PREFIX)/share/examples/$(PROJECT)
	$(INSTALL) --target-directory=$(DESTDIR)$(PREFIX)/share/examples/$(PROJECT) examples/*.dial-plan

cleanup_messy_temp_files:
	find . -name "*~" -type f -print0 | xargs -0 -r /bin/rm

fix-whitespace:
	@find src tests -name '*.ad?' | xargs --no-run-if-empty egrep -l '	| $$' | grep -v '^b[~]' | xargs --no-run-if-empty perl -i -lpe 's|	|        |g; s| +$$||g'

