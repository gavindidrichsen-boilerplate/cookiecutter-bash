# See https://github.com/ztombol/bats-assert
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

# load file under test
source ${APPLICATION_ROOT}/src/init.sh

include logger.Logger
include string.String

@test "info should echo and return success" {
	# since Logger outputs everything but FATAL to file descriptor 3,
	# then redirect 3 to stdout
	result=$(3>&1 Logger log info "Hello there yellow")

	# verify
	run echo "${result}"
	assert_output --partial "Hello there yellow"
}

@test "fatal should echo and return failure" {
	run Logger log fatal "This should fail"
	assert_failure
	assert_output --partial "This should fail"
}