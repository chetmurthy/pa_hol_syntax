# Makefile,v
# Copyright (c) INRIA 2007-2017

WD=$(shell pwd)
TOP=..
include $(TOP)/config/Makefile

DESTDIR=
RM=rm

LAUNCH=env TOP=$(TOP) $(TOP)/tools/LAUNCH
OCAMLFIND=$(LAUNCH) ocamlfind
NOT_OCAMLFIND=$(LAUNCH) not-ocamlfind
MKCAMLP5=$(LAUNCH) mkcamlp5
SYNTAX := camlp5r

ML=\
	hollexer.ml pa_hol_ocaml.ml pa_hol_ocaml_oop.ml hol_quotations.ml \

CMO := $(ML:.ml=.cmo)
CMI := $(ML:.ml=.cmi)
CMX := $(ML:.ml=.cmx)
CMT := $(ML:.ml=.cmt)
CMTI := $(MLI:.mli=.cmti)

all: $(CMO) $(CMX) local-install

doc: $(CMT) $(CMTI)

PARSING_PACKAGES=camlp5.extend,camlp5.macro_gram,camlp5.extend_m,camlp5.quotations
LEXING_PACKAGES=camlp5.pa_lexer

hollexer.cmx hollexer.cmo: hollexer.ml
	$(MAKE) -f Makefile.one PACKAGES="$(PACKAGES),$(LEXING_PACKAGES)" $@

hollexer.cmi: hollexer.mli
	$(MAKE) -f Makefile.one PACKAGES="$(PACKAGES)" $@

pa_hol_ocaml.cmx pa_hol_ocaml.cmo: pa_hol_ocaml.ml
	$(MAKE) -f Makefile.one PACKAGES="$(PACKAGES),$(PARSING_PACKAGES)" $@

pa_hol_ocaml_oop.cmx pa_hol_ocaml_oop.cmo: pa_hol_ocaml_oop.ml
	$(MAKE) -f Makefile.one PACKAGES="$(PACKAGES),$(PARSING_PACKAGES)" $@

META: META.pl
	./META.pl > META

install::
	mkdir -p $(DESTDIR)/lib
	./META.pl $(DESTDIR)/lib > META
	$(NOT_OCAMLFIND) reinstall-if-diff pa_hol_syntax -destdir $(DESTDIR)/lib META $(CMO) $(CMO:.cmo=.o) $(CMX) $(MLI:.mli=.cmi) $(CMI) $(wildcard *.cmt*)
	$(RM) -f META

local-install::
	$(MAKE) DESTDIR=$(WD)/$(TOP)/local-install/ install

clean::
	rm -rf META

EXTERNAL := $(shell $(OCAMLFIND) query -predicates byte -format '%m' $(PACKAGES) | grep local-install)
$(CMO) $(CMI) $(CMX): $(EXTERNAL)

depend::
	echo "$(CMO) $(CMI) $(CMX): $(EXTERNAL)" > .depend.NEW
	$(OCAMLFIND) ocamldep $(DEBUG) -package $(PACKAGES),$(PARSING_PACKAGES) -syntax camlp5r pa*.ml *.mli >> .depend.NEW
	$(OCAMLFIND) ocamldep $(DEBUG) -package $(PACKAGES),$(LEXING_PACKAGES) -syntax camlp5r hollexer.ml >> .depend.NEW
	mv .depend.NEW .depend

-include .depend
