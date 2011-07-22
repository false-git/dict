DESTDIR=${HOME}/bin/

all: dict
dict: dict.m
	gcc -Wall -framework Cocoa,CoreFoundation -o $@ $<
clean:
	rm -f dict
install: all
	cp dict ${DESTDIR}
