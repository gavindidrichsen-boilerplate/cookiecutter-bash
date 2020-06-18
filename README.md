# cookiecutter-bash

### Table of Contents

- [cookiecutter-bash](#cookiecutter-bash)
    - [Table of Contents](#table-of-contents)
  - [Pre-requisites](#pre-requisites)
  - [Setup](#setup)
  - [Using the Library](#using-the-library)
  - [Testing the Library](#testing-the-library)
- [Appendix](#appendix)
  - [Installation of bats-* libraries](#installation-of-bats--libraries)

## Pre-requisites

Ensure the following software is installed:

* [cookiecutter](https://cookiecutter.readthedocs.io/en/1.7.2/installation.html)
* [bats-core](https://github.com/bats-core/bats-core)
* [bats-support](https://github.com/bats-core/bats-support)
* [bats-mock](https://github.com/jasonkarns/bats-mock)

See Appendix for example installation of the bats-mock

## Setup

Create a templates directory; export this as $COOKIE; and clone cookiecutter-bash:

```bash
➜ mkdir templates
➜ cd templates
➜ export COOKIE=$PWD
➜ git clone https://github.com/gavindidrichsen/cookiecutter-bash
```

Choose another location and create your 'bash_toolbox_directory' which is your 'first' bash template and includes all the source and test code:

```bash
➜ cookiecutter $COOKIE/cookiecutter-bash/first
dir_name [.]: bash_toolbox_directory
script_name [my_script]: sample
➜ tree -d bash_toolbox_directory
bash_toolbox_directory
├── src
│   ├── debug
│   ├── lib
│   ├── logger
│   │   └── util
│   ├── print
│   └── string
└── test
    ├── debug
    ├── logger
    │   └── util
    ├── print
    └── string
```

export BASH_TOOLBOX_DIRECTORY to point to this new location:

```bash
➜ export BASH_TOOLBOX_DIRECTORY=$PWD/bash_toolbox_directory
```

## Using the Library

Use cookiecutter to quickly create new scripts that point to the new BASH_TOOLBOX_DIRECTORY.  For example the following will create a couple of new scripts in a directory called 'new_scripts':

```bash
➜ mkdir new_scripts
➜ cd new_scripts
➜  new_scripts cookiecutter $COOKIE/cookiecutter-bash/common -f
dir_name [.]:
script_name [my_script]: first
➜  new_scripts cookiecutter $COOKIE/cookiecutter-bash/common -f
dir_name [.]: second
script_name [my_script]:
➜  new_scripts cookiecutter $COOKIE/cookiecutter-bash/common -f
dir_name [.]:
script_name [my_script]: second
➜  new_scripts ls -1
first.sh
second.sh
```

Running the 2 new scripts will produce output like:

```bash
➜  new_scripts ./first.sh
[2020-06-18 14:38:14] [INFO] String toUpperCase 'bob' produces
BOB
[2020-06-18 14:38:14] [SUCCESS] DONE
➜  new_scripts ./second.sh
[2020-06-18 14:38:17] [INFO] String toUpperCase 'bob' produces
BOB
[2020-06-18 14:38:17] [SUCCESS] DONE
➜  new_scripts
```

Notice that in each of the above files, the `init.sh` is sourced and then modules are included:

```bash
source "${BASH_TOOLBOX_DIRECTORY}/src/init.sh"
include logger.Logger
include string.String
```

Then the included modules (Logger and String) are used in the script:

```bash
Logger log info "String toUpperCase 'bob' produces"
String toUpperCase "bob"
Logger log success "DONE"
```

## Testing the Library

The library beneath BASH_TOOLBOX_DIRECTORY is all setup to encourage test driven development of the shell scripts.  For example, to run all the existing tests:

cd into the $BASH_TOOLBOX_DIRECTORY

```bash
➜  cd $BASH_TOOLBOX_DIRECTORY
➜  bash_toolbox_directory cd test
```

run the full test suite:

```bash
➜  test ./unit_test_runner.sh
/Users/gavindidrichsen/DUMP/bash_toolbox_directory/test/../test/logger/util/LoggerUtilTest.bats
 ✓ getLogMsg() 'info' should return a yellow message
 ✓ getLogMsg() 'warning', 'error', and 'fatal' should return a red message
 ✓ getLogMsg() 'success' should return a green message
 ✓ getLogMsgWithoutColor() should return a message without color

4 tests, 0 failures


/Users/gavindidrichsen/DUMP/bash_toolbox_directory/test/../test/logger/LoggerTest.bats
 ✓ info should echo and return success
 ✓ fatal should echo and return failure

2 tests, 0 failures


/Users/gavindidrichsen/DUMP/bash_toolbox_directory/test/../test/print/PrintTest.bats
 ✓ to_stderr() should always go to the stderr stream
 ✓ to_terminal() should go to &3 if &3 exists
 ✓ to_terminal() should go to &2 if &3 doesn't exist

3 tests, 0 failures


/Users/gavindidrichsen/DUMP/bash_toolbox_directory/test/../test/string/StringTest.bats
 ✓ toUpperCase() should work as expected

1 test, 0 failures


/Users/gavindidrichsen/DUMP/bash_toolbox_directory/test/../test/debug/DebugTest.bats
 ✓ on() should never pollute stdout whether running in a bats context or not
 ✓ on() should turn on xtrace
 ✓ off() should turn off xtrace
 ✓ off() should not turn of xtrace if DEBUG=true

4 tests, 0 failures
➜  test
```

Or run an individual test file:

```bash
➜  test source test.env
➜  test bats string/StringTest.bats
 ✓ toUpperCase() should work as expected

1 test, 0 failures
```

# Appendix

## Installation of bats-* libraries

```bash
# See https://github.com/ztombol/bats-assert
  load '/usr/local/lib/bats-§§  
lrwxr-xr-x  1 gavindidrichsen  admin  45 Feb 12 18:47 /usr/local/lib/bats-support -> ../Cellar/bats-support/0.2.0/lib/bats-support
```

Clone the bats-mock repository and install it.  For example:

```bash
➜ git clone https://github.com/grayhemp/bats-mock.git
Cloning into 'bats-mock'...
remote: Enumerating objects: 98, done.
remote: Total 98 (delta 0), reused 0 (delta 0), pack-reused 98
Unpacking objects: 100% (98/98), done.
➜ cd bats-mock
➜  bats-mock git:(master) ls
LICENSE   README.md build     script    src       test
➜  bats-mock git:(master) ./build install
install: src/bats-mock.bash -> /usr/local/lib/bats-mock.bash
➜  bats-mock git:(master)
```

Notice that now, there are 3 bats-* libraries beneath the appropriate directory:

```bash
➜  bats-mock git:(master) ls -la /usr/local/lib/bats-*
lrwxr-xr-x  1 gavindidrichsen  admin    43 Feb 12 18:47 /usr/local/lib/bats-assert -> ../Cellar/bats-assert/0.3.0/lib/bats-assert
-rwxr-xr-x  1 gavindidrichsen  admin  4842 May 18 12:17 /usr/local/lib/bats-mock.bash
lrwxr-xr-x  1 gavindidrichsen  admin    45 Feb 12 18:47 /usr/local/lib/bats-support -> ../Cellar/bats-support/0.2.0/lib/bats-support
➜  bats-mock git:(master)
```