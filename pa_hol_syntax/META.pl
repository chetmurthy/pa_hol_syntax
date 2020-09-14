#!/usr/bin/env perl

use strict ;
BEGIN { push (@INC, "..") }
use Version ;

our $destdir = shift @ARGV ;

print <<"EOF";
# HOL-specific OCaml syntax
version = "$Version::version"
description = "pa_hol_syntax"

  requires(toploop) = "camlp5,camlp5.toploop"
  archive(byte,toploop,syntax,camlp5hol) = "hollexer.cmo camlp5_top.cma pa_hol_ocaml.cmo pa_hol_ocaml_oop.cmo"


EOF
