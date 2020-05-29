main(){
	local __files=(
		colorme.sh
		include.sh
		markups.sh
	)

	for file in ${__files[@]}; do
		source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/lib/${file}
	done
}

# parse --debug parameter if it exists
_remaining_positional_arguments=()
export DEBUG="false"
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --debug)
        export PS4='+(${BASH_SOURCE:(-45)}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
        export DEBUG="true"
        set -x
        shift # past argument
        ;;
        *)    # unknown option
        _remaining_positional_arguments+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done

# ensure all other parameters get passed on
if [[ ${#_remaining_positional_arguments[@]} > 0 ]]; then set -- "${_remaining_positional_arguments[@]}"; fi

# ensure that --debug does not apply to main()
if shopt -q -o xtrace; then 
	set +x
	main
	set -x
else
	main
fi