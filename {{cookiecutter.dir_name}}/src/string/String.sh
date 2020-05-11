include logger.Logger

@class
String(){
	toUpperCase(){
		local str=${@}
		printf '%s\n' "$str" | awk '{ print toupper($0) }'
	}

	: <<- 'comment'
	INPUT: comma separated list of key=value pairs, e.g.,
	key1=value1,key2=i am a long value

	OUTPUT: comma separated list of the keys, e.g.,
	'key1', 'key2'
	comment
	keys() {
		local input=$( echo "${1}" | tr , '\n' | sed 's/=/ /g')
		
		local output=''
		while read key value leftovers; do
			output+="${key},"
		done <<< "${input}"

		# remove the final comma
		echo "${output%,}" | sed 's|,|, |g'
	}

	: <<- 'comment'
	INPUT: comma separated list of key=value pairs, e.g.,
	key1=value1,key2=i am a long value

	OUTPUT: comma separated list of the values, e.g.,
	'value1', 'i am a long value'
	comment
	values() {
		local input=$( echo "${1}" | tr , '\n' | sed 's/=/ /g')
		
		local output=''
		while read key value leftovers; do
			# add single quotes around each value
			output+="'${value}',"
		done <<< "${input}"

		# remove the final comma
		echo "${output%,}" | sed 's|,|, |g'
	}

	linenumber() {
		local result=""
		local regex=""
        local file=""
        while [[ $# -gt 0 ]]
        do
        key="$1"

        case $key in
            --for-match)
            regex="${2}"
            shift # past argument
            shift # past value
            ;;
            --within-file)
            file="${2}"
            shift # past argument
            shift # past value
            ;;
            *)    # unknown option
            shift # past argument
            ;;
        esac
        done

		# return linenumber for match otherwise NULL
		if result=$(grep -En "${regex}" "${file}"); then
			echo "${result}" | cut -d':' -f1
		else
			echo "NULL"
		fi
	}

	: <<- 'comment'
	INPUT: core/rust/1.4.2/123456/somethinelse

	OUTPUT: core/rust
	comment
	get_only_the_core_plan() {
		echo "${1}" | cut -f1,2 -d'/'
	}

    result="${@}"
    eval "${result}"
}