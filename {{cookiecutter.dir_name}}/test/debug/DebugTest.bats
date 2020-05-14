# See https://github.com/ztombol/bats-assert
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

# load file under test
source ${APPLICATION_ROOT}/src/init.sh

include debug.Debug
include string.String

setup(){
	mkdir -p ${BATS_TEST_DIRNAME}/results
}

do_common_stuff(){
	echo "####### Triggering Debug on()"
	Debug on
	local result1=$(echo "harry" | sed "s/h/H/g")
	echo "${result1}"
	Debug off
	echo "####### Triggering Debug off()"
	local result2=$(echo "hope" | sed "s/h/H/g")
	echo "${result2}"
}

@test "on() should turn on xtrace" {
	debug_is_off(){
		do_common_stuff
	}
	run debug_is_off 3> >(tee -a ${BATS_TEST_DIRNAME}/results/fd3.log)
	assert_output <<- 'EOF'
		####### Triggering Debug on()
		Harry
		####### Triggering Debug off()
		Hope
	EOF

	# verify that xtrace DOES NOT go to stout (&3 for bats tests, &2 for scripts)
	run cat ${BATS_TEST_DIRNAME}/results/fd3.log
    assert_output --partial <<- 'EOF'
		+++ echo harry
		+++ sed s/h/H/g
		++ local result1=Harry
		++ echo Harry
		++ Debug off
		++ :
		++ :
		++ result=off
		++ eval off
		+++ off
		+++ [[ false == \t\r\u\e ]]
		+++ Logger log debug 'turning xtrace off'
		+++ log debug turning xtrace off
		+++ shopt -q -o xtrace
		+++ set +x
	EOF
	assert_output --partial <<- 'EOF'
		+++ Print is_in_bats_context
		+++ :
		+++ :
		+++ is_in_bats_context
		+++ true
		+++ return 0
	EOF
}

@test "off() should turn off xtrace" {
	debug_is_off(){
		do_common_stuff
	}
	run debug_is_off

	assert_output --partial <<- 'EOF'
		####### Triggering Debug off()
		Hope
	EOF
}

@test "off() should not turn of xtrace if DEBUG=true" {
	debug_is_on(){
		export DEBUG='true' && set -o xtrace
		do_common_stuff
	}
	run debug_is_on

	assert_output --partial <<- 'EOF'
		####### Triggering Debug off()
		+++ echo hope
		+++ sed s/h/H/g
		++ local result2=Hope
		++ echo Hope
		Hope
	EOF
}