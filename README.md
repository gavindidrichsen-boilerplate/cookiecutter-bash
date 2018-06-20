# cookiecutter-bash
A cookiecutter template for writing bash scripts inspired by [TjWallas](https://github.com/TjWallas/bash-cookiecutter.git)

## Pre-Requisite Software

- Install [bats](https://github.com/sstephenson/bats/wiki/Install-Bats-Using-a-Package).  brew install bats
- Install [bats-assert and bats-file](https://github.com/ztombol/bats-docs).  brew install bats-assert; brew install bats-file
- Install [jq](https://stedolan.github.io/jq/manual/).  brew install jq
- Install [jo](https://github.com/jpmens/jo).  brew install jo

## Usage example

Create a new cookiecutter template.  For example:

```bash
➜  cookiecutter git:(master) ✗ cookiecutter https://github.com/gavindidrichsen/cookiecutter-bash
dir_name [.]: dummy
script_name [my_script]: main
```

cd into the new script directory and run the script.  Note that at first an error will occur because no args.json file was found.  For example:

```bash
cd dummy
➜  dummy git:(master) ✗ ./main.sh
[2018-11-09_13:28:10.2N] [INFO]    Executing /Users/gavindidrichsen/Documents/@REFERENCE/cookiecutter/dummy/main.sh
[2018-11-09_13:28:10.2N] [ERROR]   Either --argfile (default is /Users/gavindidrichsen/Documents/@REFERENCE/cookiecutter/dummy/args.json) or --encoded json arguments must be set and valid
[2018-11-09_13:28:10.2N] [ERROR]   Exiting /Users/gavindidrichsen/Documents/@REFERENCE/cookiecutter/dummy/main.sh prematurely with exit code [1]
➜  dummy git:(master) ✗
```

Add a sample args.json file.  For example, use 'jo' to create a set of simple input arguments

```bash
➜  dummy git:(master) ✗ jo key1=value1 key2=value2 key3=value3 | jq '.'
{
  "key1": "value1",
  "key2": "value2",
  "key3": "value3"
}
➜  dummy git:(master) ✗ jo key1=value1 key2=value2 key3=value3 | jq '.' > args.json
```

Update the main() method to read the input parameters.  For example:

```bash
# Load private functions
# shellcheck source=src/_functions.bash
source "${__dir}/utils.bash"

main() {
    # Script goes here...
    info "starting the main function"
    info "${key1} ${key2} ${key3}"
    return
}
```

Run the script again and the parameters will be printed in stdout

```bash
➜  dummy git:(master) ✗ ./main.sh
[2018-11-09_13:42:43.2N] [INFO]    Executing /Users/gavindidrichsen/Documents/@REFERENCE/cookiecutter/dummy/main.sh
[2018-11-09_13:42:43.2N] [INFO]    Reading JSON vars from /Users/gavindidrichsen/Documents/@REFERENCE/cookiecutter/dummy/args.json:
{
  "key1": "value1",
  "key2": "value2",
  "key3": "value3"
}
[2018-11-09_13:42:43.2N] [INFO]    Evaluating the following bash variables:
key1="value1"
key2="value2"
key3="value3"
[2018-11-09_13:42:43.2N] [INFO]    Evaluating the json arguments as bash variables
[2018-11-09_13:42:43.2N] [INFO]    starting the main function
[2018-11-09_13:42:43.2N] [INFO]    value1 value2 value3
[2018-11-09_13:42:43.2N] [INFO]    Exiting /Users/gavindidrichsen/Documents/@REFERENCE/cookiecutter/dummy/main.sh cleanly with exit code [0]
➜  dummy git:(master) ✗
```

### Run the bats test suite

Along with the new script above, a bats test file will also be created.  **NOTE** that:

- this test suite does not actually verify the new script but rather illustrates a range of bats assertions.  Tailor the tests to suit the purpose of the new script
- case #15 is testing one of the methods in the utils.bash file.  This is just to illustrate how functions can be extracted and tested in isolation from the main bash script.  The bats test looks like this:

  ```bash
  @test "invoking the utils::sayHello() in utils.bash should complete successfully" {
    diff <(echo "$(utils::sayHello)") <(echo "Hello World")
  }
  ```

To run the tests:

- cd dummy
- make the bats file executable
- run the bats test suite

For example:

```bash
➜  dummy git:(master) ✗ bats --tap main_test.bats
1..15
ok 1 assert() should succeed
ok 2 assert_equal() should compare 2 equal strings
ok 3 assert_success() should succeed when exit status is == 0
ok 4 assert_failure() should succeed when exit status is != 0
ok 5 assert_output() should only have an exact match
ok 6 assert_output() partial should pass with a partial match
ok 7 assert_output() regular expression should succeed if regex matches
ok 8 assert_line() should succeed if expected output line is present
ok 9 assert_line() partial matching should succeed if partial string is present in any of the output lines
ok 10 assert_line() regular expression matching
ok 11 addition using bc
ok 12 # skip (bad test) invoking foo with a nonexistent file prints an error
ok 13 invoking cat with a nonexistent file prints an error
ok 14 invoking diff without arguments prints usage
ok 15 invoking a function in _functions.bash should complete successfully
➜  dummy git:(master) ✗
```

## Support

See [bats-assert](https://github.com/ztombol/bats-assert)
