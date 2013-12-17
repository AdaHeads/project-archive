include Makefile.revisions

all: gnat

############################################################################
# Common parameters:

# Location for downloaded files:
DOWNLOADS=downloads

# System administrator rights:
SU_APPLICATION=sudo -E

# Required location for GNAT:
PREFIX=/usr/gnat

# Execution path including GNAT:
EXTENDED_PATH=$(PREFIX)/bin:$(PATH)

# Number of available CPU threads.
ifeq ($(PROCESSORS),)
PROCESSORS=`(test -f /proc/cpuinfo && grep -c ^processor /proc/cpuinfo) || echo 1`
endif

############################################################################

########
# Yolk #
########

yolk: yolk-git-install

yolk-git-install: yolk-git-build
	$(SU_APPLICATION) make -C yolk install
	@touch $@

yolk-git-build: yolk-git-src gnat
	PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	make -C yolk -e prefix=${PREFIX}/bin/.. PROCESSORS=${PROCESSORS}  \

yolk-git-src:
	(test -d yolk && (cd yolk; git pull)) || git clone git://github.com/ThomasLocke/yolk.git

#######
# AWS #
#######

aws: aws-git-install

aws-git-install: aws-git-build
	$(SU_APPLICATION) make -C aws install
	@touch $@

aws-git-build: aws-git-setup
	(PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	make build -C aws -e prefix=${PREFIX}/bin/.. PROCESSORS=${PROCESSORS})
	@touch $@

aws-git-setup: aws-git-src gnat
	PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	make setup -C aws -e prefix=${PREFIX}/bin/.. PROCESSORS=${PROCESSORS} SOCKET=gnutls OpenID=true

aws-git-src:
	(test -d aws && (cd aws; git pull)) || \
	git clone --recursive http://forge.open-do.org/anonscm/git/aws/aws.git

############
# GNATColl #
############

GNATCOLL_ARGS=--disable-projects --with-postgresql --with-sqlite --enable-syslog

gnatlib: gnatlib-svn-install

gnatlib-svn-install: gnatlib-svn-build
	$(SU_APPLICATION) make -C gnatlib install
	@touch $@

gnatlib-svn-build: gnatlib-svn gnat
	cd gnatlib && PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	./configure --prefix=${PREFIX} ${GNATCOLL_ARGS}
	make -e LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	        PATH=$(PATH):${PREFIX}/bin\
	        -C gnatlib
	@touch $@

gnatlib-svn:
	@(svn co http://svn.eu.adacore.com/anonsvn/Dev/trunk/gps/gnatlib/ gnatlib || \
	echo Checkout of GNATColl failed - maybe you do not have subversion installed?)

###########
# Florist #
###########

florist: florist-gpl-2013-install

florist-gpl-2013-install: florist-gpl-2013-build
	$(SU_APPLICATION) make -C florist-gpl-2013-src install
	@touch $@

florist-gpl-2013-build: florist-gpl-2013-src gnat
	cd florist-gpl-2013-src && PATH=$(PATH):${PREFIX}/bin \
	LIBRARY_PATH=$(LIBRARY_PATH):/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu \
	./configure --prefix=${PREFIX}
	make -e LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH) \
	        PATH=$(PATH):${PREFIX}/bin\
	        -C florist-gpl-2013-src
	@touch $@

florist-gpl-2013-src: $(DOWNLOADS)/florist-gpl-2013-src.tgz
	echo Extracting $(DOWNLOADS)/florist-gpl-2013-src.tgz ...
	@tar xzf $(DOWNLOADS)/florist-gpl-2013-src.tgz
	@touch $@

$(DOWNLOADS)/florist-gpl-2013-src.tgz:
	mkdir -p $(DOWNLOADS)
	wget -H http://mirrors.cdn.adacore.com/art/3a9157f1ba735ee0f0f9cf032b381032736d7263 -O $(DOWNLOADS)/florist-gpl-2013-src.tgz

###########
# XML-Ada #
###########

xml-ada: gnat-2013-install

############################################################################
# GNAT

ifeq ($(GNAT_REVISION),)
$(error A specific version of GNAT should be selected.)
endif

gnat: gnat-$(GNAT_REVISION)

gnat-gpl-2013: gnat-2013-install

gnat-2013-install: gnat-gpl-2013-x86_64-pc-linux-gnu-bin
        $(SU_APPLICATION) ${MAKE} -C $< -e prefix=${PREFIX}
	@touch $@

gnat-gpl-2013-x86_64-pc-linux-gnu-bin: $(DOWNLOADS)/gnat-gpl-2013-x86_64-pc-linux-gnu-bin.tar.gz
	@echo Extracting $< ...
	@tar xzf $<
	@touch $@

$(DOWNLOADS)/gnat-gpl-2013-x86_64-pc-linux-gnu-bin.tar.gz:
	mkdir -p $(DOWNLOADS)
	wget -H http://mirrors.cdn.adacore.com/art/1db1fa7e867c63098c4775c387e1a287274d9c87 -O $@

############################################################################

###########
# Cleanup #
###########

clean:
	rm -rf gnat-201?-x86_64-pc-linux-gnu-bin
	rm -rf xmlada-4.3w-src
	rm gnat-201?-install
	rm xmlada-4.3-install xmlada-4.3-build
