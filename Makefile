all:

ada-development: gnat xml-ada florist
adaheads-development: ada-development gnatlib aws yolk


ARCHIVE_FOLDER="tgz"

SU_APPLICATION=sudo
PREFIX=/usr/gnat

# Number of available CPU threads.
ifeq ($(PROCESSORS),)
PROCESSORS=`(test -f /proc/cpuinfo && grep -c ^processor /proc/cpuinfo) || echo 1`
endif

GNATCOLL_ARGS=--disable-projects --with-postgresql --with-sqlite --enable-syslog

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
	(test -d yolk && (cd yolk; git pull)) || git clone git://github.com/ThomasLocke/yolk.git

#######
# AWS #
#######

aws: aws-git-install

aws-git-install: aws-git-build
	$(SU_APPLICATION) make -C aws install && touch aws-git-install

aws-git-build: aws-git-setup
	(PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	make build -C aws -e prefix=${PREFIX}/bin/.. PROCESSORS=${PROCESSORS}) \
	 && touch aws-git-build

aws-git-setup: aws-git-src
	PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	make setup -C aws -e prefix=${PREFIX}/bin/.. PROCESSORS=${PROCESSORS}

aws-git-src:
	(test -d aws && (cd aws; git pull)) || \
	git clone --recursive http://forge.open-do.org/anonscm/git/aws/aws.git

############
# GNATColl #
############

gnatlib: gnatlib-svn-install

gnatlib-svn-install: gnatlib-svn-build
	$(SU_APPLICATION) make -C gnatlib install && touch gnatlib-svn-install

gnatlib-svn-build: gnatlib-svn
	cd gnatlib && PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	./configure --prefix=${PREFIX} ${GNATCOLL_ARGS}
	make -e LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	        PATH=$(PATH):${PREFIX}/bin\
	        -C gnatlib && touch gnatlib-svn-build

gnatlib-svn:
	@(svn co http://svn.eu.adacore.com/anonsvn/Dev/trunk/gps/gnatlib/ gnatlib || \
	echo Checkout of GNATColl failed - maybe you do not have subversion installed?)

###########
# Florist #
###########

florist: florist-gpl-2012-install

florist-gpl-2012-install: florist-gpl-2012-build
	$(SU_APPLICATION) make -C florist-gpl-2012-src install && touch florist-gpl-2012-install

florist-gpl-2012-build: florist-gpl-2012-src
	cd florist-gpl-2012-src && PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=$(LIBRARY_PATH):/usr/lib/x86_64-linux-gnu \
	./configure --prefix=${PREFIX}
	make -e LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	        PATH=$(PATH):${PREFIX}/bin\
	        -C florist-gpl-2012-src && touch florist-gpl-2012-build

florist-gpl-2012-src: tgz/florist-gpl-2012-src.tgz
	echo Extracting ${ARCHIVE_FOLDER}/florist-gpl-2012-src.tgz ...
	@tar xzf ${ARCHIVE_FOLDER}/florist-gpl-2012-src.tgz
	@touch florist-gpl-2012-src

tgz/florist-gpl-2012-src.tgz:
	-mkdir tgz
	(cd tgz && wget -H \
	http://mirrors.cdn.adacore.com/art/47d2e0f943f4c34f5812df70c5a6c0379b7cf4fa -O \
	florist-gpl-2012-src.tgz)

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

xmlada-4.3w-src: tgz/xmlada-gpl-4.3-src.tgz
	echo Extracting ${ARCHIVE_FOLDER}/xmlada-gpl-4.3-src.tgz ...
	@tar xzf ${ARCHIVE_FOLDER}/xmlada-gpl-4.3-src.tgz
	@touch xmlada-4.3w-src

tgz/xmlada-gpl-4.3-src.tgz:
	-mkdir tgz
	(cd tgz && wget -H \
	http://mirrors.cdn.adacore.com/art/0332ffe06bc598f0b94b3a027f30ea2be6dc5dec -O \
	xmlada-gpl-4.3-src.tgz)

########
# GNAT #
########

gnat: gnat-2012-x86_64-pc-linux-gnu-bin gnat-2012-install

gnat-2012-install:
	(cd gnat-2012-x86_64-pc-linux-gnu-bin && \
        $(SU_APPLICATION) ${MAKE} -e prefix=${PREFIX}) && touch gnat-2012-install

gnat-2012-x86_64-pc-linux-gnu-bin: tgz/gnat-gpl-2012-x86_64-pc-linux-gnu-bin.tar.gz
	@echo Extracting tgz/gnat-gpl-2012-x86_64-pc-linux-gnu-bin.tar.gz ...
	@tar xzf tgz/gnat-gpl-2012-x86_64-pc-linux-gnu-bin.tar.gz
	@touch gnat-2012-x86_64-pc-linux-gnu-bin

tgz/gnat-gpl-2012-x86_64-pc-linux-gnu-bin.tar.gz:
	-mkdir tgz
	cd tgz && wget -H http://mirrors.cdn.adacore.com/art/277d54e6ea00b2f55c07fbd6947239249f705d0a -O gnat-gpl-2012-x86_64-pc-linux-gnu-bin.tar.gz


clean:
	rm -rf gnat-2012-x86_64-pc-linux-gnu-bin
	rm -rf xmlada-4.3w-src
	rm gnat-2012-install
	rm xmlada-4.3-install xmlada-4.3-build
