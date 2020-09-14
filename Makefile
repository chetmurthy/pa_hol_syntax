# Makefile,v
# Copyright (c) INRIA 2007-2017

TOP=.
include $(TOP)/config/Makefile

WD=$(shell pwd)
DESTDIR=
RM=rm

SYSDIRS= pa_hol_syntax

TESTDIRS= tests

PACKAGES := camlp5

all: sys
	set -e; for i in $(TESTDIRS); do cd $$i; $(MAKE) all; cd ..; done

sys: plugins

plugins:
	set -e; for i in $(SYSDIRS); do cd $$i; $(MAKE) all; cd ..; done

doc: all
	set -e; for i in $(SYSDIRS); do cd $$i; $(MAKE) doc; cd ..; done
	rm -rf docs
	tools/make-docs pa_ppx docs
	make -C doc html

test: all
	set -e; for i in $(TESTDIRS); do cd $$i; $(MAKE) test; cd ..; done

install: sys
	$(OCAMLFIND) remove pa_hol_syntax || true
	$(OCAMLFIND) install pa_hol_syntax local-install/lib/pa_hol_syntax/*

uninstall:
	$(OCAMLFIND) remove pa_hol_syntax || true

clean::
	set -e; for i in $(SYSDIRS) $(TESTDIRS); do cd $$i; $(MAKE) clean; cd ..; done
	rm -rf docs local-install

depend:
	set -e; for i in $(SYSDIRS) $(TESTDIRS); do cd $$i; $(MAKE) depend; cd ..; done
