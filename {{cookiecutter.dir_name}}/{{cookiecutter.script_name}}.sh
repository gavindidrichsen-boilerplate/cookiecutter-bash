#!/bin/bash
#/ Usage:
#/ Description:
#/ Examples:
#/ Options:
#/   --help: Display this help message

set -o errexit
set -o pipefail
set -o nounset

usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# load the bash library
source "${__dir}/src/init.sh"
include logger.Logger
include string.String

# --- Helper scripts begin ---

# --- Helper scripts end ---

# set parameters
_usage() { Logger log fatal "$(basename "$0") [ --help --debug ]"; }
_remaining_positional_arguments=()
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        --help)
        _usage
        shift # past argument
        ;;
        *)    # unknown option
        _remaining_positional_arguments+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done
{% raw -%}
if [[ ${#_remaining_positional_arguments[@]} > 0 ]]; then set -- "${_remaining_positional_arguments[@]}"; fi
{%- endraw %}


############
#   MAIN   #
############
Logger log info "String toUpperCase 'bob' produces"
String toUpperCase "bob"
Logger log success "DONE"

