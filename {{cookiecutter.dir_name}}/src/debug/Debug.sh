include logger.Logger
include print.Print

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
			if Print is_in_bats_context; then
				# send xtrace output to & 3 NOT to the default stderr &2
				export BASH_XTRACEFD=3
			fi
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
			if Print is_in_bats_context; then
				# ensure 'off' doesn't get added to xtrace output
				{ set +o xtrace; } 3>/dev/null
				# ensure default xtrace stream goes back to default stderr &2
				export BASH_XTRACEFD=2
			else
				# ensure 'off' doesn't get added to xtrace output
				{ set +o xtrace; } 2>/dev/null
			fi
			
			
		fi
	}

    result="${@}"
    eval "${result}"
	# "${@}"
}