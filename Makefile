HOME=$(CURDIR)

deployment: dart-sdk copy-static-files update-pub compile-js
	rm deploy/pubspec.*

dart-sdk:
	make -C lib dart-sdk
	echo $(HOME)

copy-static-files:
	-mkdir -p deploy
	-cp -r src/* deploy
	-cp -r pubspec.* deploy

	# Delete old packages/ directories
	-rm -r deploy/css/packages
	-rm -r deploy/css_old/packages
	-rm -r deploy/dart/packages
	-rm -r deploy/img/packages
	-rm -r deploy/js/packages

	# Create links to the local packages cache.
	# AÙTOMATE THIS! Link to every single package in .pub-cache.
	mkdir deploy/dart/packages
	(cd deploy/dart/packages && ln -s ../../.pub-cache/hosted/pub.dartlang.org/browser-0.3.2/lib browser)
	(cd deploy/dart/packages && ln -s ../../.pub-cache/hosted/pub.dartlang.org/logging-0.3.2/lib logging)
	(cd deploy/dart/packages && ln -s ../../.pub-cache/hosted/pub.dartlang.org/meta-0.3.2/lib meta)
	(cd deploy/dart/packages && ln -s ../../.pub-cache/hosted/pub.dartlang.org/unittest-0.3.2/lib unittest)

compile-js:
	lib/dart-sdk/bin/dart2js --minify -odeploy/dart/bob.dart.js deploy/dart/bob.dart

	# Delete and re-create the deploy/packages directory.
	-rm -r deploy/packages

update-pub:
	(cd deploy && HOME=$(CURDIR)/deploy ../lib/dart-sdk/bin/pub update)

distclean:
	-rm -r deploy
	make -C lib distclean
