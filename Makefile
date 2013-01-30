HOME=$(CURDIR)

deployment: dart-sdk copy-static-files update-pub compile-js
	cp -r build/packages build/dart/
dart-sdk:
	make -C lib dart-sdk
	echo $(HOME)

copy-static-files:
	-mkdir -p build/dart
	-mkdir -p build/js
	-cp -r css build
	-cp -r bob.html build
	-cp -r dart/*.dart build/dart
	-cp -r pubspec.yaml build

compile-js:
	-mkdir -p build/js
	lib/dart-sdk/bin/dart2js -obuild/js/bob.js dart/bob.dart

update-pub:
	(cd build && HOME=$(CURDIR)/build ../lib/dart-sdk/bin/pub update)

distclean:
	-rm -r build
	make -C lib distclean
