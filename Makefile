include .config

all: style-check generated/charlie-configuration.ads
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

generated/charlie-configuration.ads:
	mkdir -p generated
	@echo 'with GNAT.Sockets;'                                          >  generated/charlie-configuration.ads
	@echo 'package Charlie.Configuration is'                            >> generated/charlie-configuration.ads
	@echo '   Port : constant GNAT.Sockets.Port_Type := '${AGI_PORT}';' >> generated/charlie-configuration.ads                                                   
	@echo 'end Charlie.Configuration;'                                  >> generated/charlie-configuration.ads
