include logger.util.LoggerUtil

@class
Logger(){
	log(){
		# ensure that all tracing is disabled within the logging code
		{
			local logLevel=${1}; shift
			local logMessage="${@}"

			LoggerUtil getLogMsg ${logLevel} ${logMessage}
		} 2> /dev/null
	}

	${@}
}