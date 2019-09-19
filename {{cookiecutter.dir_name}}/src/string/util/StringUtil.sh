@class
StringUtil(){
	toUpperCase(){
		local str=${@}

		printf '%s\n' "$str" | awk '{ print toupper($0) }'
	}

	$@
}