include string.util.StringUtil

@class
LoggerUtil(){

	getLogMsg(){
		local color=null
		local logLevel=$(StringUtil toUpperCase ${1}); shift
		local message="$@"

		if [[ ( ${logLevel} == ERROR) || (${logLevel} == FATAL) ]]; then
			local color=red
		elif [[ ${logLevel} == INFO ]]; then
			local color=yellow
		elif [[ ${logLevel} == SUCCESS ]]; then
			local color=green
		fi
		
    	local dateTime=$(date "+%F %T")
		echo -e "[${dateTime}] [${logLevel}] $( colorme ${color} "${message}" )"

		if [[ ${logLevel} == FATAL ]]; then exit 1; fi
	}

	$@
}