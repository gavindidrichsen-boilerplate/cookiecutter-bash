include string.String

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

		# if FATAL, then print to stderr and die
		if [[ ${logLevel} == FATAL ]]; then 
			echo >&2 -e "${message}"
			exit 1; 
		fi

		# if filedescriptor 3 exists,...
		if { true >&3; } 2<> /dev/null; then
			# ...we're in a BATS test so output to FD 3
			echo >&3 -e "${message}"
		else
			# ...otherwise we're calling from a normal script so send to stderr
			echo >&2 -e "${message}"
		fi

		
	}

	$@
}