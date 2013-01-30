HOME=$(CURDIR)

deployment: dart-sdk copy-static-files update-pub compile-js

dart-sdk:
	make -C lib dart-sdk
	echo $(HOME)

copy-static-files:
	-mkdir -p deploy
	-cp -r web/* deploy
	-cp -r pubspec.yaml deploy

compile-js:
	lib/dart-sdk/bin/dart2js -odeploy/dart/bob.dart.js web/dart/bob.dart

update-pub:
	(cd deploy && HOME=$(CURDIR)/deploy ../lib/dart-sdk/bin/pub update)

distclean:
	-rm -r build
	make -C lib distclean
