#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

# --- Helper scripts begin ---
#/ Usage:
#/ Description:
#/ Examples:
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename "${__file}" .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

# Load private functions
# shellcheck source=src/_functions.bash
source "${__dir}/lib/common.bash"
source "${__dir}/lib/utils.bash"

common::parseArgFile

# common::cleanup() {
#     info "do some cleanup like removing temporary files"
#     rm -f "/tmp/blah.txt"
# }

# --- Helper scripts end ---


main() {
    # Script goes here...
    info "starting the main function"
    info "FLAG_ARGUMENT is '${FLAG_ARGUMENT}'"
    info "sayHello() returns: " && utils::sayHello
    return
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    main
fi

