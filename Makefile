include .config

all: style-check generated/configuration.ads
	mkdir -p bin obj
	gnatmake $(GNATMAKE_ARGS) -P charlie

clean:
	rm -rf obj generated

distclean: clean
	rm -rf bin

style-check:
	@if egrep -l '	| $$' */*.ad? | egrep -v '^obj/'; then echo "Please remove tabs and end-of-line spaces from the source files listed above."; false; fi

fix-style:
	@egrep -l '	| $$' */*.ad? | egrep -v '^obj/' | xargs --no-run-if-empty perl -i -lpe 's/	/        /g; s/ +$$//'

generated/configuration.ads:
	mkdir -p generated
	@echo 'package Configuration is'                       > generated/configuration.ads
	@echo '   Port : constant Natural := "'${AGI_PORT}'";' >> generated/configuration.ads                                                   
	@echo 'end Configuration;'                             >> generated/configuration.ads
