include logger.util.LoggerUtil
include string.String
include debug.Debug
include print.Print

@class
Logger() {
	log(){
        do_log() {
            local logLevel=${1}; shift
            local logMessage="${@}"

            local full_message=$(LoggerUtil getLogMsg ${logLevel} ${logMessage})

            # if FATAL, then print to stderr and die
            if [[ ${logLevel} == fatal ]]; then 
                Print to_stderr "${full_message}"
                exit 1; 
            fi

            # ensure all output goes to stderr so that functions can log without corrupting output
            Print to_terminal "${full_message}"
        }

		# ensure that all tracing is disabled within the logging code
        if shopt -q -o xtrace; then 
            set +x
            do_log "${@}"
            set -x
        else
            do_log "${@}"
        fi
	}

    # result="${@}"
    # eval "${result}"
    ${@}
}
