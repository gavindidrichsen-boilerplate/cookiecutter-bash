colorme(){
	black(){
		echo "\033[0;30m${@}\033[0m"
	}

	green(){
		echo "\033[0;32m${@}\033[0m"
	}

	null(){
		echo ${@}
	}

	red(){
		echo "\033[0;31m${@}\033[0m"
	}

	yellow(){
		echo "\033[1;33m${@}\033[0m"
	}

	$@
}