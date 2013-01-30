ARCH := $(shell getconf LONG_BIT)

dart-sdk: dartsdk-linux-$(ARCH)

dartsdk-linux-$(ARCH): dartsdk-linux-$(ARCH).tar.gz
	tar xzf dist/$@.tar.gz

dartsdk-linux-$(ARCH).tar.gz:
	-mkdir dist
	(cd dist && wget -N https://storage.googleapis.com/dart-editor-archive-integration/latest/$@)

distclean:
	-rm -r dart-sdk dist
