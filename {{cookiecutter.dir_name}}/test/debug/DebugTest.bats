# See https://github.com/ztombol/bats-assert
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

# load file under test
source ${APPLICATION_ROOT}/src/init.sh

include debug.Debug
include string.String

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
	run debug_is_off
    assert_output --partial <<- 'EOF'
		####### Triggering Debug on()
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
		+++ shopt -q -o xtrace
		+++ set +x
		+++ set +o xtrace
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