include logger.util.LoggerUtil

@class
Logger() {
	log(){
		# ensure that all tracing is disabled within the logging code

		{
			local logLevel=${1}; shift
			local logMessage="${@}"
			LoggerUtil getLogMsg ${logLevel} ${logMessage} 3>&2 >&3 2> /dev/null
		} 
	}

    enable_debug_flag() {
        # quietly return if no parameters
        if [[ ${#} == 0 ]]; then return; fi

        local _remaining_positional_arguments=()
        while [[ $# -gt 0 ]]
        do
            key="$1"

            case $key in
                --debug)
                export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
                set -x
                shift # past argument
                ;;
                *)    # unknown option
                _remaining_positional_arguments+=("$1") # save it in an array for later
                shift # past argument
                ;;
            esac
        done

        if [[ ${#_remaining_positional_arguments[@]} > 0 ]]; then set -- "${_remaining_positional_arguments[@]}"; fi
        _remaining_positional_arguments=()
    }

	${@}
}
