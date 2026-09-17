#!/usr/bin/env bash


USER_CC="${CC:-gcc}"

set -xe

$USER_CC -c build-lib.c -o idoc.o
ar rcs libidoc.a idoc.o
rm -f idoc.o
