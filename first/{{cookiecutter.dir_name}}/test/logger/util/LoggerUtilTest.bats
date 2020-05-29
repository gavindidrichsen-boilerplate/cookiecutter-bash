# See https://github.com/ztombol/bats-assert
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

# load file under test
source ${APPLICATION_ROOT}/src/init.sh

include logger.Logger
include logger.util.LoggerUtil
include string.String

@test "getLogMsg() 'info' should return a yellow message" {
    run LoggerUtil getLogMsg "info This is a YELLOW message"
    assert_output --regexp "([\s]+\\033\[1;33mThis is a YELLOW message[\]033\[0m)"
	assert_output --partial "INFO"
}

@test "getLogMsg() 'warning', 'error', and 'fatal' should return a red message" {
    run LoggerUtil getLogMsg "warning This is a RED message"
    assert_output --regexp "([\s]+\\033\[0;31mThis is a RED message[\]033\[0m)"
	assert_output --partial "WARNING"

	run LoggerUtil getLogMsg "error This is a RED message"
    assert_output --regexp "([\s]+\\033\[0;31mThis is a RED message[\]033\[0m)"
	assert_output --partial "ERROR"

	run LoggerUtil getLogMsg "fatal This is a RED message"
    assert_output --regexp "([\s]+\\033\[0;31mThis is a RED message[\]033\[0m)"
	assert_output --partial "FATAL"
}

@test "getLogMsg() 'success' should return a green message" {
    run LoggerUtil getLogMsg "success This is a GREEN message"
    assert_output --regexp "([\s]+\\033\[0;32mThis is a GREEN message[\]033\[0m)"
	assert_output --partial "SUCCESS"
}

@test "getLogMsgWithoutColor() should return a message without color" {
    run LoggerUtil getLogMsgWithoutColor "success This is a NOCOLOR message"
    assert_output --regexp "(\[SUCCESS\] This is a NOCOLOR message)"
}