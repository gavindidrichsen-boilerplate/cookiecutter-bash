# See https://github.com/ztombol/bats-assert
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

# load file under test
source ${APPLICATION_ROOT}/src/init.sh

include string.String

@test "toUpperCase() should work as expected" {
	diff <(echo "BOB") <(echo "$(String toUpperCase "bob")")
}