
: <<- 'comment'
Given input like logger.Logger, then ONLY source it once
even if it has been included in many places throughout the 
module code base
comment
include(){	
	do_include() {
		# if ${1} == logger.Logger, then create $module == logger_Logger
		local module=$(echo "${1}" | sed 's|\.|_|g')

		# ONLY source logger.Logger IF logger_Logger == ""
		if [[ "${!module:-}" == "" ]]; then 
			eval "${module}=true"
			source $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../${1//\./\/}.sh
		fi
	}

	if shopt -q -o xtrace; then
		set +x
		do_include "${1}"
		set -x
	else
		do_include "${1}"
	fi
	
}