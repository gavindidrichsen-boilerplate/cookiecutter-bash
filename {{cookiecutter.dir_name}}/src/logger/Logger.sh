include logger.util.LoggerUtil

@class
Logger(){
	log(){
		local logLevel=${1}; shift
		local logMessage="${@}"

		LoggerUtil getLogMsg ${logLevel} ${logMessage}
	}

	${@}
}