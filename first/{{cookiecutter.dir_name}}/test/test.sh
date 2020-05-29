#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# load the bash library
source "${__dir}/../src/init.sh"
include logger.Logger
include habitat.Habitat

# load environment variables
# [[ -f "/etc/opt/on_prem_builder/builder.env" ]] && source "/etc/opt/on_prem_builder/builder.env" || source ${__dir}/../.etc/builder.env
# [[ -f "/etc/opt/on_prem_builder/hab.env" ]] && source "/etc/opt/on_prem_builder/hab.env" || source ${__dir}/../.etc/hab.env

result=$(Habitat get_pkg_idents_from \
        --url "http://40.117.100.54" \
        --channel "refresh-test-001" \
        --origin "core")
Logger log info "list of pkg_idents"
echo "${result}"


Logger log fatal "HERE with DEBUG [${DEBUG}]"
echo "${result}" > output.txt



Habitat get_pkg_idents_from \
        --url "http://40.121.14.186" \
        --channel "refresh-test-001" \
        --origin "core" \

