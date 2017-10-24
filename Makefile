NAME=tubie
VXX=valac
LIBS=--pkg gtk+-3.0 --pkg webkit2gtk-4.0 --pkg json-glib-1.0 --pkg libsoup-2.4
SRCDIR=src
BINDIR=bin
DATADIR=data
DEBDIR=debian

all: schema compile test package

schema:
	glib-compile-schemas ./data/

compile:
	$(VXX) $(LIBS) $(SRCDIR)/main.vala $(SRCDIR)/Auth/* $(SRCDIR)/Views/* -o $(NAME)

test:
	@echo Testing

package:
	@echo Packaging