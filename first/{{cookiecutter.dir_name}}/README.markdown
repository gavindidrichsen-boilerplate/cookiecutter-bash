# Bash Toolbox

### Table of Contents

- [Bash Toolbox](#bash-toolbox)
    - [Table of Contents](#table-of-contents)
  - [Using the Library](#using-the-library)
  - [Testing the Library](#testing-the-library)

## Using the Library

In every one of your top-level project files first source the `init.sh` and then include any of the function classes like:

```bash
source ./src/init.sh
include path.to.file.FunctionClassName
```

where every ``path.to.file.FunctionClassName`` is assumed to be within the ``src`` directory.

For example, the following script includes the StringUtil class and then uses the toUpperCase function:

```bash
#!/bin/bash
source "./src/init.sh"
include logger.Logger
include string.String

# exercise the StringUtil beginsWithVowel method"
Logger log info $( String toUpperCase "Absalom" )
```

Running the above will produce something like:

```bash
[2019-11-03 14:45:56] [INFO] ABSALOM
```

## Testing the Library

source test.env and run an individual bats test
OR
Run the unit_test_runner.sh, which sources the test.env

Some test samples for reference are below:

```bash
#!/usr/bin/env bats

# See https://github.com/ztombol/bats-assert
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

# load file under test
source ${APPLICATION_ROOT}/src/init.sh

include string.String

@test 'assert() should succeed' {
  touch '/tmp/test.log'
  assert [ -e '/tmp/test.log' ]
} 

@test 'assert_equal() should compare 2 equal strings' {
  assert_equal "bob" "bob"
} 

@test 'assert_success() should succeed when exit status is == 0' {
  run bash -c "echo 'Error!'"
  assert_success
}

@test 'assert_failure() should succeed when exit status is != 0' {
  run bash -c "echo 'Error!'; exit 1"
  assert_failure
}

@test 'assert_output() should only have an exact match' {
  run echo 'ERROR: no such file or directory'
  assert_output 'ERROR: no such file or directory'
}

@test 'assert_output() partial should pass with a partial match' {
  run echo 'ERROR: no such file or directory'
  assert_output --partial 'no such file'
}

@test 'assert_output() regular expression should succeed if regex matches' {
  run echo 'Foobar v0.1.0'
  assert_output --regexp '^Foobar v[0-9]+\.[0-9]+\.[0-9]$'
}

@test 'assert_line() should succeed if expected output line is present' {
  run echo $'have-0\nhave-1\nhave-2'
  assert_line 'have-1'
}

@test 'assert_line() partial matching should succeed if partial string is present in any of the output lines' {
  run echo $'have 1\nhave 2 but want 4\nhave 3'
  assert_line --partial 'but want'
}

@test 'assert_line() regular expression matching' {
  run echo $'have-0\nwant-1\nhave-2'
  assert_line --index 1 --regexp '^want-[0-9]$'
}

@test "addition using bc" {
  result="$(echo 2+2 | bc)"
  assert_equal $result 4
}

@test "invoking foo with a nonexistent file prints an error" { 
  skip "bad test"
  run foo
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

@test "invoking the utils::sayHello() in utils.bash should complete successfully" {
  diff <(echo "$(utils::sayHello)") <(echo "Hello World")
}
```
