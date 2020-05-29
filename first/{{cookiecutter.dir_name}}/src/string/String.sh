include logger.Logger

@class
String(){
	toUpperCase(){
		local str=${@}
		printf '%s\n' "$str" | awk '{ print toupper($0) }'
	}

    "${@}"
}