include string.String
include print.Print

@class
LoggerUtil(){

	getLogMsg(){
		local logLevel="${1}"; shift
		local message="$@"

		local prefix=$(LoggerUtil add_prefix "${logLevel}")
		local message_with_color=$(LoggerUtil add_color "${logLevel}" "${message}")
		echo "${prefix} ${message_with_color}"
	}

	getLogMsgWithoutColor(){
		local logLevel="${1}"; shift
		local message="$@"

		local prefix=$(LoggerUtil add_prefix "${logLevel}")
		echo "${prefix} ${message}"
	}

	@private
	add_prefix(){
		local logLevel=$(String toUpperCase ${1}); shift
		echo "[$(date "+%F %T")] [${logLevel}]"
	}

	@private
	add_color(){
		local logLevel=$(String toUpperCase ${1}); shift
		local message="$@"

		local color=null
		if [[ (${logLevel} == WARNING) || (${logLevel} == ERROR) || (${logLevel} == FATAL) ]]; then
			local color=red
		elif [[ ${logLevel} == INFO ]]; then
			local color=yellow
		elif [[ ${logLevel} == SUCCESS ]]; then
			local color=green
		fi

		echo "$(colorme ${color} "${message}")"
	}

	$@
}