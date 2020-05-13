# See https://github.com/ztombol/bats-assert
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

# load file under test
source ${APPLICATION_ROOT}/src/init.sh

include print.Print


setup(){
	mkdir -p "${BATS_TEST_DIRNAME}/results"
}

do_print(){
	echo "bob"
	Print to_terminal "susan"
	Print to_terminal "barbara"
	echo "harry"
}

@test "to_terminal() should only go to &3 stream if &3 exists--as it does in bats test execution" {
	# See tip for this at https://stackoverflow.com/questions/692000/how-do-i-write-stderr-to-a-file-while-using-tee-with-a-pipe

	# ensure test file is removed first
	rm -f ${BATS_TEST_DIRNAME}/results/fd3.log

	# redirect &3 output to an anonymous fifo with tee listening for input
	run do_print 3> >(tee -a ${BATS_TEST_DIRNAME}/results/fd3.log)
	assert_output <<- 'EOF'
		bob
		harry
	EOF

	# verify to_terminal() only goes to &3
	run cat ${BATS_TEST_DIRNAME}/results/fd3.log
	assert_output <<- 'EOF'
		susan
		barbara
	EOF
}

@test "to_stderr() should only go to stderr stream" {
	write_to_stderr(){
		Print to_stderr "Oh boy there was a problem"
		return 1
	}

	run write_to_stderr
	assert_failure
	assert_output "Oh boy there was a problem"
}