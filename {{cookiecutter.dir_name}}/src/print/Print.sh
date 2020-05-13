@class
Print(){
	: <<- 'comment'
	INPUT: a message to log

	OUTPUT: redirect message output to either &2 (stderr) or to &3 if in a BATS test. 
	     Why log to &2?  Because I want to be able to log from within functions without
	corrupting the functional output.  This is most often used within the logging 
	framework; however, other features like the Debug module may also require this 
	when turning on the xtrace when debugging individual tests
	     Why log to &3?  Because when running bats tests, the streams on &1 (stdout) and
    &2 (stderr) are verified during tests.  In order not to corrupt the streams under
    test (stdout and stderr), the bats system uses another 'tap' stream creating the 
    &3 filedescriptor

    In both cases, in a bats test or running a script, this function can be used to
    output to the terminal without corrupting either the functional output or the 
    bats streams under test
	comment
    to_terminal(){
        local message="${@}"

        # if filedescriptor 3 exists,...
        if { true >&3; } 2<> /dev/null; then
        	# ...we're in a BATS test so output to FD 3
        	echo >&3 -e "${message}"
        else
            # ...otherwise we're calling from a normal script so send to stderr
            echo >&2 -e "${message}"
        fi
    }

	: <<- 'comment'
	INPUT: a message to log

	OUTPUT: redirect message output to &2 (stderr)
	comment
    to_stderr(){
        local message="${@}"
        echo >&2 -e "${message}"
    }

    # DON'T eval "${@}" because characters like '&' will be evaluated!
    ${@}
}