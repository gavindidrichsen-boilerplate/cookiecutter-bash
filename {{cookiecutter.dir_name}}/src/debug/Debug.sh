include logger.Logger

@class
Debug(){
	is_xtrace_on(){
		if shopt -q -o xtrace; then 
			return 0
		else
			return 1
		fi
	}

	: <<- 'comment'
	Only turn on xtrace if not already in DEBUG mode
	comment
	on() {
		# only turn on xtrace if not in $DEBUG mode
		if [[ "${DEBUG}" == "true" ]]; then
			Logger log debug "not turning on xtrace because DEBUG mode is on"
		else
			Logger log debug "turning xtrace on"
			set -o xtrace
		fi
	}

	: <<- 'comment'
	Only turn off xtrace if not already in DEBUG mode
	comment
	off() {
		# only turn off xtrace if not in $DEBUG mode
		if [[ "${DEBUG}" == "true" ]]; then
			Logger log debug "not turning off xtrace because DEBUG mode is on"
		else
			Logger log debug "turning xtrace off"
			set +o xtrace
		fi
	}

    result="${@}"
    eval "${result}"
	# "${@}"
}