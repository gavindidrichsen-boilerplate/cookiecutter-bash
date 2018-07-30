#!/usr/bin/env bats

load "_functions"

@test "addition using bc" {
  result="$(echo 2+2 | bc)"
  [ "$result" -eq 4 ]
}

@test "addition using dc" {
  result="$(echo 2 2+p | dc)"
  [ "$result" -eq 4 ]
}

@test "invoking foo with a nonexistent file prints an error" { 
  skip "foo should be an existing utility"
  run foo nonexistent_filename
  [ "$status" -eq 1 ]
  [ "$output" = "foo: no such file 'nonexistent_filename'" ]
}

@test "invoking cat with a nonexistent file prints an error" {
  run cat nonexistent_filename
  [ "$status" -eq 1 ]
  [ "$output" = "cat: nonexistent_filename: No such file or directory" ]
}

@test "invoking diff without arguments prints usage" {
  run diff
  diff <(echo "${status}") <(echo "2")
  [[ "bobby" =~ "bob" ]]
  [[ "${lines[0]}" =~ "diff: missing operand after" ]]
}

@test "invoking a function in _functions.bash should complete successfully" {
  run diff
  diff <(echo "$(sayHello)") <(echo "Hello World")
}
