all:

ada-development: gnat xml-ada florist
adaheads-development: ada-development gnatlib-tl aws yolk


ARCHIVE_FOLDER="tgz"

SU_APPLICATION=sudo
PREFIX=/usr/gnat

# Number of available CPU threads.
PROCESSORS=4;

GNATCOLL_ARGS=--disable-projects

########
# Yolk #
########

yolk: yolk-git-install

yolk-git-install: yolk-git-build
	$(SU_APPLICATION) make -C yolk install && touch yolk-git-install

yolk-git-build: yolk-git-src
	PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	make -C yolk -e prefix=${PREFIX}/bin/.. PROCESSORS=${PROCESSORS}  \

yolk-git-src:
	(test -d yolk && cd yolk; git pull) || git clone git://github.com/ThomasLocke/yolk.git

#######
# AWS #
#######

aws-git-install: aws-git-build
	$(SU_APPLICATION) make -C aws install && touch aws-git-install

aws-git-build: aws-git-setup
	(PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	make build -C aws -e prefix=${PREFIX}/bin/.. PROCESSORS=${PROCESSORS}) \
	 && touch aws-git-build

aws-git-setup:
	PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	make setup -C aws -e prefix=${PREFIX}/bin/.. PROCESSORS=${PROCESSORS}

aws-git:
	git clone --recursive http://forge.open-do.org/anonscm/git/aws/aws.git

############
# GNATColl #
############

gnatlib: gnatlib-svn-install
gnatlib-tl: gnatlib-tl-install

gnatlib-svn-install:
	$(SU_APPLICATION) make -C gnatlib install && touch gnatlib-svn-install

gnatlib-svn-build:
	cd gnatlib && PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	./configure --prefix=${PREFIX} ${GNATCOLL_ARGS}
	make -e LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	        PATH=$(PATH):${PREFIX}/bin\
	        -C gnatlib && touch gnatlib-svn-build

gnatlib-svn:
	@(svn co http://svn.eu.adacore.com/anonsvn/Dev/trunk/gps/gnatlib/ gnatlib || \
	echo Checkout of GNATColl failed - maybe you do not have subversion installed?)

gnatlib-tl-install: gnatlib-tl-build
	$(SU_APPLICATION) make -C gnatlib-tl install && touch gnatlib-tl-install

gnatlib-tl-build: gnatlib-tl
	cd gnatlib-tl && PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	./configure --prefix=${PREFIX} ${GNATCOLL_ARGS}
	make -e LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	        PATH=$(PATH):${PREFIX}/bin\
	        -C gnatlib-tl && touch gnatlib-tl-build

gnatlib-tl-src:
	(test -d gnatlib-tl && cd gnatlib-tl; git pull) || \
	git clone git://github.com/ThomasLocke/GNATColl.git gnatlib-tl


###########
# Florist #
###########

florist: florist-gpl-2012-install

florist-gpl-2012-install: florist-gpl-2012-build
	$(SU_APPLICATION) make -C florist-gpl-2012-src install && touch florist-gpl-2012-install

florist-gpl-2012-build: florist-gpl-2012-src
	cd florist-gpl-2012-src && PATH=${PREFIX}/bin:$(PATH) \
	LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	./configure --prefix=${PREFIX}
	make -e LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	        PATH=$(PATH):${PREFIX}/bin\
	        -C florist-gpl-2012-src && touch florist-gpl-2012-build

florist-gpl-2012-src:
	echo Extracting ${ARCHIVE_FOLDER}/florist-gpl-2012-src.tgz ...
	@tar xzf ${ARCHIVE_FOLDER}/florist-gpl-2012-src.tgz
	@touch florist-gpl-2012-src


tgz/florist-gpl-2012-src.tgz:
	@echo Please download florist-gpl-2012-src.tgz from Libre.adacore.com and place it in the ./tgz folder


###########
# XML-Ada #
###########

xml-ada: xmlada-4.3-install

# XML-Ada 4.3

xmlada-4.3-install: xmlada-4.3-build
	$(SU_APPLICATION) make -C xmlada-4.3w-src install && touch xmlada-4.3-install


xmlada-4.3-build: xmlada-4.3w-src
	cd xmlada-4.3w-src && PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	./configure --prefix=${PREFIX}
	make -e LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	        PATH=$(PATH):${PREFIX}/bin\
	        -C xmlada-4.3w-src && touch xmlada-4.3-built

xmlada-4.3w-src:
	echo Extracting ${ARCHIVE_FOLDER}/xmlada-gpl-4.3-src.tgz ...
	@tar xzf ${ARCHIVE_FOLDER}/xmlada-gpl-4.3-src.tgz
	@touch xmlada-4.3w-src

tgz/xmlada-gpl-4.3-src.tgz:
	@echo Please download xmlada-gpl-4.3-src.tgz from Libre.adacore.com and place it in the ./tgz folder

#########
# GTNAT #
#########

gnat: gnat-2012-x86_64-pc-linux-gnu-bin gnat-2012-install

gnat-2012-install:
	(cd gnat-2012-x86_64-pc-linux-gnu-bin && \
        $(SU_APPLICATION) ${MAKE} -e prefix=${PREFIX}) && touch gnat-2012-install

gnat-2012-x86_64-pc-linux-gnu-bin: tgz/gnat-gpl-2012-x86_64-pc-linux-gnu-bin.tar.gz
	@echo Extracting tgz/gnat-gpl-2012-x86_64-pc-linux-gnu-bin.tar.gz ...
	@tar xzf tgz/gnat-gpl-2012-x86_64-pc-linux-gnu-bin.tar.gz
	@touch gnat-2012-x86_64-pc-linux-gnu-bin

tgz/gnat-gpl-2012-x86_64-pc-linux-gnu-bin.tar.gz:
	@echo Please download gnat-gpl-2012-x86_64-pc-linux-gnu-bin.tar.gz from Libre.adacore.com and place it in the ./tgz folder


clean:
	rm -rf gnat-2012-x86_64-pc-linux-gnu-bin
	rm -rf xmlada-4.3w-src
	rm gnat-2012-install
	rm xmlada-4.3-install xmlada-4.3-build