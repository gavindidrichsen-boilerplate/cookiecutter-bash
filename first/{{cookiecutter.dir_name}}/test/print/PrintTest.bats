# See https://github.com/ztombol/bats-assert
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

# load file under test
source ${APPLICATION_ROOT}/src/init.sh

include print.Print

@test "to_stderr() should always go to the stderr stream" {
	# output appears in &2 when &3 DOES exist
	# (1) redirect &2 to stdout 
	# (2) redirect &3, which exists for all bats tests, to /dev/null
	# (3) redirect &1 to /dev/null 
	local result=$(2>&1 1>/dev/null 3>&1 Print to_stderr "this SHOULD ONLY appear in stderr")
	assert_equal "${result}" "this SHOULD ONLY appear in stderr"

	# output appears in &2 when &3 DOES NOT exist
	# (1) close &3, which exists for all bats tests
	# (2) redirect &2 to stdout and 
	# (3) redirect &1 to /dev/null
	result=$(3>&- 2>&1 1>/dev/null Print to_stderr "and this SHOULD ONLY appear in stderr")
	assert_equal "${result}" "and this SHOULD ONLY appear in stderr"
}

@test "to_terminal() should go to &3 if &3 exists" {
	# output DOES NOT appear in either stdout or stderr
	# redirect &2 to &1 stdout
	local result=$(2>&1 Print to_terminal "this SHOULD NOT appear in either stderr or stdout")
	assert_equal "${result}" ""

	# output DOES appear in &3 when &3 exists
	# (1) redirect &3, which exists for all bats tests, to stdout
	# (2) redirect &1 to /dev/null and 
	# (3) redirect &2 to /dev/null 
	result=$(3>&1 1>/dev/null 2>&1 Print to_terminal "this is in the &3 stream")
	assert_equal "${result}" "this is in the &3 stream"
}

@test "to_terminal() should go to &2 if &3 doesn't exist" {
	# prove output appears in &2 when &3 does not exist
	# (1) close &3 to simulate a non-bats context
	# (2) redirect &2 to stdout and 
	# (3) redirect &1 to /dev/null 
	local result=$(3>&- 2>&1 1>/dev/null Print to_terminal "this is in the &2 stream")
	assert_equal "${result}" "this is in the &2 stream"
}