# See https://github.com/ztombol/bats-assert
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

# load file under test
source ${APPLICATION_ROOT}/src/init.sh

include string.String

@test "toUpperCase() should work as expected" {
	diff <(echo "BOB") <(echo "$(String toUpperCase "bob")")
}

@test "return a list of keys" {
	run String keys "key10=value10,key20=value20"
	assert_output "key10, key20"
}

@test "return a list of values" {
	run String values "key10=value10,key20=value20"
	assert_output "'value10', 'value20'"
}

@test "return linenumber for match in file" {
	local regex="core-plans/bzip2"
	local file="${BATS_TEST_DIRNAME}/fixtures/refresh-plans.txt"

	run String linenumber --for-match "${regex}$" --within-file "${BATS_TEST_DIRNAME}/fixtures/refresh-plans.txt"
	assert_output 14
}

@test "return NULL for non-match in file" {
	local regex="core-plans/BLOBBY"
	local file="${BATS_TEST_DIRNAME}/fixtures/refresh-plans.txt"

	run String linenumber --for-match "${regex}$" --within-file "${BATS_TEST_DIRNAME}/fixtures/refresh-plans.txt"
	assert_output "NULL"
}

@test "only return core/plan NOT core/plan/version" {
	run String get_only_the_core_plan "core/gcc/1.7.7/89898989898/somethingelse"
	assert_output "core/gcc"

	#...and cover a few boundary scenarios
	run String get_only_the_core_plan "core/"
	assert_output "core/"

	run String get_only_the_core_plan "core"
	assert_output "core"

	run String get_only_the_core_plan ""
	assert_output ""

	run String get_only_the_core_plan
	assert_output ""
}
