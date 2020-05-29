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
global_DEBUG_is_on(){
	export DEBUG='true' && set -o xtrace
	do_common_stuff
}
global_DEBUG_is_off(){
	do_common_stuff
}

# mock out Logger log so that timestamps aren't in the output
Logger() {
	log(){
		shift
		Print to_stderr "${@}"
	}
    ${@}
}

@test "on() should never pollute stdout whether running in a bats context or not" {
	# for a bats test (&3 present) only the 'echos' should appear in stdout
	local result=$(global_DEBUG_is_off)
	local expected=$(cat <<- 'EOF'
		####### Triggering Debug on()
		Harry
		####### Triggering Debug off()
		Hope
	EOF
	)
	assert_equal "${expected}" "${result}"

	# for a script (&3 not present) only the 'echos' should appear in stdout
	result=$(3>&- global_DEBUG_is_off)
	local expected=$(cat <<- 'EOF'
		####### Triggering Debug on()
		Harry
		####### Triggering Debug off()
		Hope
	EOF
	)
	assert_equal "${expected}" "${result}"
}


@test "on() should turn on xtrace" {

	run 3>&- 2>&1 1>/dev/null global_DEBUG_is_off
    assert_output <<- 'EOF'
		####### Triggering Debug on()
		turning xtrace on
		+++ echo harry
		+++ sed s/h/H/g
		++ local result1=Harry
		++ echo Harry
		Harry
		++ Debug off
		++ :
		++ :
		++ result=off
		++ eval off
		+++ off
		+++ [[ false == \t\r\u\e ]]
		+++ Logger log debug 'turning xtrace off'
		+++ log debug turning xtrace off
		+++ shift
		+++ Print to_stderr turning xtrace off
		+++ :
		+++ :
		+++ to_stderr turning xtrace off
		+++ local 'message=turning xtrace off'
		+++ echo -e 'turning xtrace off'
		turning xtrace off
		+++ Print is_in_bats_context
		+++ :
		+++ :
		+++ is_in_bats_context
		+++ return 1
		####### Triggering Debug off()
		Hope
	EOF
}

@test "off() should turn off xtrace" {
	run global_DEBUG_is_off

	assert_output --partial <<- 'EOF'
		####### Triggering Debug off()
		Hope
	EOF
}

@test "off() should not turn of xtrace if DEBUG=true" {
	run global_DEBUG_is_on

	assert_output --partial <<- 'EOF'
		####### Triggering Debug off()
		+++ echo hope
		+++ sed s/h/H/g
		++ local result2=Hope
		++ echo Hope
		Hope
	EOF
}