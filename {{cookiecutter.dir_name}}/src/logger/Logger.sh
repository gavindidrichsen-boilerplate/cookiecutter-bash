include logger.util.LoggerUtil
include string.String
include debug.Debug

@class
Logger() {
	log(){
        do_log() {
            local logLevel=${1}; shift
            local logMessage="${@}"

            # ensure all output goes to stderr so that functions can log without corrupting output
            1>&2 LoggerUtil getLogMsg ${logLevel} ${logMessage}
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
