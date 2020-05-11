#!/usr/bin/env bash

# set APPLICATION_ROOT
source test.env

find ${APPLICATION_ROOT}/test -name "*.bats" -print -exec bats {} \; -exec echo \; -exec echo \; 
