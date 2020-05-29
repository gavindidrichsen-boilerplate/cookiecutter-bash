#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# load the bash library
source "${BASH_TOOLBOX_DIRECTORY}/src/init.sh"
include logger.Logger
include string.String

############
#   MAIN   #
############
Logger log info "String toUpperCase 'bob' produces"
String toUpperCase "bob"
Logger log success "DONE"

