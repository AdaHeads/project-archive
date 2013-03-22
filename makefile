###############################################################################
#                                                                             #
#                                  Alice                                      #
#                                                                             #
#                                Make File                                    #
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

ifeq ($(DATABASE),)
DATABASE=SQLite
endif

ifeq ($(PROCESSORS),)
PROCESSORS=`(test -f /proc/cpuinfo && grep -c ^processor /proc/cpuinfo) || echo 1`
endif

all:
	mkdir -p build_production
	DATABASE=${DATABASE} gnatmake -j${PROCESSORS} -P alice

debug:
	mkdir -p build_debug
	BUILDTYPE=Debug DATABASE=${DATABASE} gnatmake -j${PROCESSORS} -P alice

clean: cleanup_messy_temp_files
	gnatclean -P alice
	BUILDTYPE=Debug gnatclean -P alice

distclean:
	rm -rf build_production build_debug

tests: all
	@./tests/build
	@./tests/run

cleanup_messy_temp_files:
	find . -name "*~" -type f -print0 | xargs -0 -r /bin/rm
