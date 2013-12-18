include Makefile.revisions

all: alice

############################################################################
# Common parameters:

# Location for downloaded files:
DOWNLOADS=downloads

# System administrator rights:
SU_APPLICATION=sudo -E

# Required location for GNAT:
PREFIX=/usr/gnat

# Execution path including GNAT:
EXTENDED_PATH=$(PATH):$(PREFIX)/bin

# Library path including some things GNAT needs:
EXTENDED_LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH)

# Number of available CPU threads.
ifeq ($(PROCESSORS),)
PROCESSORS=`(test -f /proc/cpuinfo && grep -c ^processor /proc/cpuinfo) || echo 1`
endif

# Common dependencies for all build targets:
DEPENDENCIES=Makefile Makefile.revisions

############################################################################
# Alice:

ALICE_DEPENDENCIES=gnat yolk aws gnatcoll libdialplan libesl

ifeq ($(ALICE_REVISION),)
$(error A specific version of Alice should be selected.)
endif

alice: $(DOWNLOADS)/alice $(ALICE_DEPENDENCIES) $(DEPENDENCIES)
	cd $< && git pull && git checkout $(ALICE_REVISION)
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make -C $< -e

$(DOWNLOADS)/alice:
	mkdir -p $(DOWNLOADS)
	git clone git://github.com/AdaHeads/Alice.git $@

############################################################################
# Yolk

YOLK_DEPENDENCIES=gnat aws florist gnatcoll

ifeq ($(YOLK_REVISION),)
$(error A specific version of Yolk should be selected.)
endif

yolk: $(DOWNLOADS)/yolk $(YOLK_DEPENDENCIES) $(DEPENDENCIES)
	cd $< && git pull && git checkout $(YOLK_REVISION)
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make -C $< -e
	$(SU_APPLICATION) make -C $< install

$(DOWNLOADS)/yolk:
	mkdir -p $(DOWNLOADS)
	git clone git://github.com/ThomasLocke/yolk.git $@

############################################################################
# AWS

AWS_DEPENDENCIES=gnat

AWS_ARGS=SOCKET=gnutls OpenID=true

ifeq ($(AWS_REVISION),)
$(error A specific version of AWS should be selected.)
endif

aws: $(DOWNLOADS)/aws $(AWS_DEPENDENCIES) $(DEPENDENCIES)
	cd $< && git pull && git checkout $(AWS_REVISION)
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make setup -C $< -e $(AWS_ARGS)
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make build -C $< -e
	$(SU_APPLICATION) make -C $< install

$(DOWNLOADS)/aws:
	mkdir -p $(DOWNLOADS)
	git clone --recursive http://forge.open-do.org/anonscm/git/aws/aws.git $@

############################################################################
# GNATColl

GNATCOLL_DEPENDENCIES=gnat

GNATCOLL_ARGS=--disable-projects --with-postgresql --with-sqlite --enable-syslog

ifeq ($(GNATCOLL_REVISION),)
$(error A specific version of GNATColl should be selected.)
endif

gnatcoll: $(DOWNLOADS)/gnatcoll $(GNATCOLL_DEPENDENCIES) $(DEPENDENCIES)
	cd $< && svn update && svn update -r $(GNATCOLL_REVISION)
	cd $< && PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) ./configure --prefix=$(PREFIX) $(GNATCOLL_ARGS)
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make -C $< -e
	$(SU_APPLICATION) make -C $< install

$(DOWNLOADS)/gnatcoll:
	mkdir -p $(DOWNLOADS)
	svn checkout http://svn.eu.adacore.com/anonsvn/Dev/trunk/gps/gnatlib/ $@

############################################################################
# libdialplan:

LIBDIALPLAN_DEPENDENCIES=gnat xmlada

ifeq ($(LIBDIALPLAN_REVISION),)
$(error A specific version of libdialplan should be selected.)
endif

libdialplan: $(DOWNLOADS)/libdialplan $(LIBDIALPLAN_DEPENDENCIES) $(DEPENDENCIES)
	cd $< && git pull && git checkout $(LIBDIALPLAN_REVISION)
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make -C $< -e
	$(SU_APPLICATION) make -C $< install

$(DOWNLOADS)/libdialplan:
	mkdir -p $(DOWNLOADS)
	git clone git://github.com/AdaHeads/libdialplan.git $@

############################################################################

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
	wget --timestamping --output-document=$@ http://mirrors.cdn.adacore.com/art/3a9157f1ba735ee0f0f9cf032b381032736d7263

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
	wget --timestamping --output-document=$@ http://mirrors.cdn.adacore.com/art/1db1fa7e867c63098c4775c387e1a287274d9c87

############################################################################

###########
# Cleanup #
###########

clean:
	rm -rf gnat-201?-x86_64-pc-linux-gnu-bin
	rm -rf xmlada-4.3w-src
	rm gnat-201?-install
	rm xmlada-4.3-install xmlada-4.3-build
