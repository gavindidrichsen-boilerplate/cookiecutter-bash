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
include string.util.StringUtil

# --- Helper scripts begin ---

# --- Helper scripts end ---

main() {
    Logger enable_debug_flag "${@:-}"
    Logger log info "StringUtil toUpperCase 'bob' produces"
    StringUtil toUpperCase "bob"
    Logger log success "DONE"
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    main "${@:-}"
fi

