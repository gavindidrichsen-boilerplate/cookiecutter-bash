#!/bin/bash

# set APPLICATION_ROOT
source test.env

find ${APPLICATION_ROOT}/test -name "*.bats" -print -exec bats {} \;
