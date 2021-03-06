include Makefile.revisions

all: call-flow-control database-servers

############################################################################
# Common parameters:

# Location for downloaded files:
DOWNLOADS=downloads

# System administrator rights:
SU_APPLICATION=sudo -E

# Required location for GNAT:
PREFIX=/usr/gnat

# Execution path including GNAT:
EXTENDED_PATH=/usr/bin:$(PATH):$(PREFIX)/bin

# Library path including some things GNAT needs:
EXTENDED_LIBRARY_PATH=/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH)

# Number of available CPU threads.
ifeq ($(PROCESSORS),)
PROCESSORS=`(test -f /proc/cpuinfo && grep -c ^processor /proc/cpuinfo) || echo 1`
endif

# Common dependencies for all build targets:
COMMON_DEPENDENCIES=Makefile Makefile.revisions

############################################################################
# Call-flow-control:

CALL_FLOW_CONTROL_DEPENDENCIES=$(COMMON_DEPENDENCIES) gnat aws libdialplan libesl

ifeq ($(CALL_FLOW_CONTROL_REVISION),)
$(error A specific version of Call-flow-control should be selected.)
endif

call-flow-control: $(DOWNLOADS)/call-flow-control $(CALL_FLOW_CONTROL_DEPENDENCIES)
	cd $< && git checkout master && git pull && git checkout $(CALL_FLOW_CONTROL_REVISION)
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make -C $< -e

$(DOWNLOADS)/call-flow-control:
	mkdir -p $(DOWNLOADS)
	git clone git://github.com/AdaHeads/call-flow-control.git $@

############################################################################
# AWS

AWS_DEPENDENCIES=$(COMMON_DEPENDENCIES) gnat patches/aws.patch

AWS_ARGS=SOCKET=gnutls

ifeq ($(AWS_REVISION),)
$(error A specific version of AWS should be selected.)
endif

aws: aws-$(AWS_REVISION)

aws-$(AWS_REVISION): aws-$(AWS_REVISION)-install

aws-$(AWS_REVISION)-install: aws-$(AWS_REVISION)-build
	$(SU_APPLICATION) rm -rf /usr/gnat/*/aws /usr/gnat/*/*/aws
	$(SU_APPLICATION) make -C aws-$(AWS_REVISION)-src install
	@touch $@

aws-$(AWS_REVISION)-build: aws-$(AWS_REVISION)-src gnat
	$(SU_APPLICATION) rm -rf /usr/gnat/*/aws /usr/gnat/*/*/aws
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make setup -C $< -e $(AWS_ARGS)
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make build -C $< -e
	@touch $@

aws-$(AWS_REVISION)-src: $(DOWNLOADS)/aws-$(AWS_REVISION)-src.tgz
	@test -x "`which tar`"   || (echo "Please install 'tar'." ; false)
	@echo Extracting $< ...
	@tar xzf $<
	@touch $@

$(DOWNLOADS)/aws-gpl-3.1.0-src.tgz:
	@test -x "`which wget`"  || (echo "Please install 'wget'." ; false)
	mkdir -p $(DOWNLOADS)
	wget --output-document=$@ http://mirrors.cdn.adacore.com/art/12063471a424d3b33f8d7f86c7e6e8f7ab8079fc

############################################################################
# libdialplan:

LIBDIALPLAN_DEPENDENCIES=$(COMMON_DEPENDENCIES) gnat xmlada

ifeq ($(LIBDIALPLAN_REVISION),)
$(error A specific version of libdialplan should be selected.)
endif

libdialplan: $(DOWNLOADS)/libdialplan $(LIBDIALPLAN_DEPENDENCIES)
	cd $< && git checkout master && git pull && git checkout $(LIBDIALPLAN_REVISION)
	cd $< && PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) ./configure
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make -C $< -e
	$(SU_APPLICATION) make -C $< install

$(DOWNLOADS)/libdialplan:
	mkdir -p $(DOWNLOADS)
	git clone git://github.com/AdaHeads/libdialplan.git $@

############################################################################
# libesl:

LIBESL_DEPENDENCIES=$(COMMON_DEPENDENCIES) gnat aws

ifeq ($(LIBESL_REVISION),)
$(error A specific version of libesl should be selected.)
endif

libesl: $(DOWNLOADS)/libesl $(LIBESL_DEPENDENCIES)
	cd $< && git checkout master && git pull && git checkout $(LIBESL_REVISION)
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make -C $< -e
	$(SU_APPLICATION) make -C $< install

$(DOWNLOADS)/libesl:
	mkdir -p $(DOWNLOADS)
	git clone git://github.com/AdaHeads/libesl.git $@

############################################################################
# FLORIST

FLORIST_DEPENDENCIES=$(COMMON_DEPENDENCIES) gnat

ifeq ($(FLORIST_REVISION),)
$(error A specific version of FLORIST should be selected.)
endif

florist: florist-$(FLORIST_REVISION)

florist-gpl-2013: florist-gpl-2013-install

florist-gpl-2013-install: florist-gpl-2013-build
	$(SU_APPLICATION) make -C florist-gpl-2013-src install
	@touch $@

florist-gpl-2013-build: florist-gpl-2013-src gnat
	cd $< && PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) ./configure --prefix=$(PREFIX)
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make -C $< -e
	@touch $@

florist-gpl-2013-src: $(DOWNLOADS)/florist-gpl-2013-src.tgz
	@test -x "`which tar`"   || (echo "Please install 'tar'." ; false)
	@echo Extracting $< ...
	@tar xzf $<
	@touch $@

$(DOWNLOADS)/florist-gpl-2013-src.tgz:
	@test -x "`which wget`"  || (echo "Please install 'wget'." ; false)
	mkdir -p $(DOWNLOADS)
	wget --output-document=$@ http://mirrors.cdn.adacore.com/art/3a9157f1ba735ee0f0f9cf032b381032736d7263

############################################################################
# XML-Ada

ifeq ($(XMLADA_REVISION),)
$(error A specific version of XML-Ada should be selected.)
endif

xmlada: xmlada-$(XMLADA_REVISION)

xmlada-gpl-2013: gnat-gpl-2013

############################################################################
# GNAT

ifeq ($(GNAT_REVISION),)
$(error A specific version of GNAT should be selected.)
endif

gnat:
	@if [ -x "`which gnatmake`" ]; then touch $@; else echo "Please run 'make gnat-$(GNAT_REVISION)' or install GNAT through your OS package manager."; false; fi

gnat-gpl-2013: gnat-2013-install

gnat-2013-install: gnat-gpl-2013-x86_64-pc-linux-gnu-bin
	$(SU_APPLICATION) ${MAKE} -C $< -e prefix=${PREFIX}
	@touch $@

gnat-gpl-2013-x86_64-pc-linux-gnu-bin: $(DOWNLOADS)/gnat-gpl-2013-x86_64-pc-linux-gnu-bin.tar.gz
	@test -x "`which tar`"   || (echo "Please install 'tar'." ; false)
	@echo Extracting $< ...
	@tar xzf $<
	@touch $@

$(DOWNLOADS)/gnat-gpl-2013-x86_64-pc-linux-gnu-bin.tar.gz:
	@test -x "`which wget`"  || (echo "Please install 'wget'." ; false)
	mkdir -p $(DOWNLOADS)
	wget --output-document=$@ http://mirrors.cdn.adacore.com/art/1db1fa7e867c63098c4775c387e1a287274d9c87

############################################################################
# Dart SDK:

dart: /opt/dart-sdk

/opt/dart-sdk: $(DOWNLOADS)/dart-sdk
	sudo rm -rf $@
	sudo cp -pr $< $@

$(DOWNLOADS)/dart-sdk: $(DOWNLOADS)/dartsdk-linux-x64-release.zip
	@test -x "`which unzip`" || (echo "Please install 'unzip'." ; false)
	cd $(DOWNLOADS) && unzip -uoa `basename $<` && touch dart-sdk

$(DOWNLOADS)/dartsdk-linux-x64-release.zip: scripts/patch-dartsdk-64
	@test -x "`which curl`"  || (echo "Please install 'curl'."  ; false)
	@test -x "`which unzip`" || (echo "Please install 'unzip'." ; false)
	@test -x "`which zip`"   || (echo "Please install 'zip'."   ; false)
	mkdir -p $(DOWNLOADS)
	cd $(DOWNLOADS) && ../scripts/patch-dartsdk-64

############################################################################
# Database Servers:

DATABASE_SERVERS_DEPENDENCIES=$(COMMON_DEPENDENCIES) dart

ifeq ($(DATABASE_SERVERS_REVISION),)
$(error A specific version of Database Servers should be selected.)
endif

database-servers: $(DOWNLOADS)/database-servers $(DATABASE_SERVERS_DEPENDENCIES)
	cd $< && git checkout master && git pull && git checkout $(DATABASE_SERVERS_REVISION)
	PATH=$(EXTENDED_PATH) LIBRARY_PATH=$(EXTENDED_LIBRARY_PATH) PROCESSORS=$(PROCESSORS) PREFIX=$(PREFIX) make -C $< -e

$(DOWNLOADS)/database-servers:
	mkdir -p $(DOWNLOADS)
	git clone git://github.com/AdaHeads/DatabaseServers.git $@

############################################################################
# Clean

clean:
	rm -rf gnat-*
	rm -rf xmlada-*
	rm -rf aws-*
	rm -rf florist-*

distclean: clean
	$(SU_APPLICATION) rm -rf $(DOWNLOADS)

############################################################################
