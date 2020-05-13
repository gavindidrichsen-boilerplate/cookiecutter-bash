include string.String
include print.Print

@class
LoggerUtil(){

	getLogMsg(){
		local color=null
		local logLevel=$(String toUpperCase ${1}); shift
		local message="$@"

		if [[ (${logLevel} == WARNING) || (${logLevel} == ERROR) || (${logLevel} == FATAL) ]]; then
			local color=red
		elif [[ ${logLevel} == INFO ]]; then
			local color=yellow
		elif [[ ${logLevel} == SUCCESS ]]; then
			local color=green
		fi
		
    	local dateTime=$(date "+%F %T")
		message="[${dateTime}] [${logLevel}] $( colorme ${color} "${message}" )"

		echo "${message}"
	}

	$@
}