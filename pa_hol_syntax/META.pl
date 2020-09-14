#!/usr/bin/env perl

use strict ;
BEGIN { push (@INC, "..") }
use Version ;

our $destdir = shift @ARGV ;

print <<"EOF";
# HOL-specific OCaml syntax
version = "$Version::version"
description = "pa_hol_syntax"

  requires(toploop,syntax) = "camlp5,camlp5.toploop"
  archive(byte,toploop,syntax,camlp5hol) = "hollexer.cmo pa_hol_ocaml.cmo hol_quotations.cmo"
  requires(toploop,-syntax) = "camlp5"
  archive(byte,toploop,-syntax) = "hollexer.cmo pa_hol_ocaml.cmo hol_quotations.cmo"

  requires(syntax,preprocessor) = "camlp5"
  archive(syntax,preprocessor,-native) = "hollexer.cmo pa_hol_ocaml.cmo hol_quotations.cmo"
  archive(syntax,preprocessor,native) = "hollexer.cmx pa_hol_ocaml.cmx hol_quotations.cmx"

  package "link" (
    requires = "camlp5"
    archive(byte) = "hollexer.cmo pa_hol_ocaml.cmo hol_quotations.cmo"
    archive(native) = "hollexer.cmx pa_hol_ocaml.cmx hol_quotations.cmx"
  )

EOF
