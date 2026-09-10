#!/usr/bin/env bash

set -xe

gcc -c build-lib.c -o idoc.o
ar rcs libidoc.a idoc.o
rm -f idoc.o
