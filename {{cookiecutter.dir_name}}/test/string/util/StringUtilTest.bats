source ${APPLICATION_ROOT}/src/init.sh

include string.util.StringUtil

@test "StringUtil toUpperCase() should work as expected" {
	diff <(echo "BOB") <(echo "$(StringUtil toUpperCase "bob")")
}
