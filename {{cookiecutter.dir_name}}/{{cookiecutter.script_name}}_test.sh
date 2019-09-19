#!/bin/bash

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# export $APPLICATION_ROOT so that test files can source the code
export APPLICATION_ROOT="${__dir}"
find test -name "*.bats" -print -exec bats {} \;
