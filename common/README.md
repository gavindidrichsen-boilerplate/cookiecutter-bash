# cookiecutter-bash

### Table of Contents

- [cookiecutter-bash](#cookiecutter-bash)
    - [Table of Contents](#table-of-contents)
  - [Pre-requisites:](#pre-requisites)
  - [Using the Library](#using-the-library)
  - [Testing the Library](#testing-the-library)
- [Example Bats Test](#example-bats-test)
- [Appendix](#appendix)
  - [Example installation of bats-mock](#example-installation-of-bats-mock)

## Pre-requisites:

Ensure the following software is installed:
* bats-core
* bats-support
* bats-mock

See Appendix for example installation of the bats-mock

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
include string.util.StringUtil

# exercise the StringUtil beginsWithVowel method"
Logger log info $( StringUtil toUpperCase "Absalom" )
```

Running the above will produce something like:

```bash
[2019-11-03 14:45:56] [INFO] ABSALOM
```

## Testing the Library

# Example Bats Test

```bash
# See https://github.com/ztombol/bats-assert
load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'
load '/usr/local/lib/bats-mock.bash'

# load file under test
source ${BATS_TEST_DIRNAME}/src/init.sh
include url.Url

@test "postgres.sh starts Postgres" {
  mock="$(mock_create)"
  mock_set_side_effect "${mock}" "echo $$ > /tmp/postgres_started"

  # Assuming postgres.sh expects the `_POSTGRES` variable to define a
  # path to the `postgres` executable
  _POSTGRES="${mock}" run postgres.sh

  [[ "${status}" -eq 0 ]]
  [[ "$(mock_get_call_num ${mock})" -eq 1 ]]
  [[ "$(mock_get_call_user ${mock})" = 'postgres' ]]
  [[ "$(mock_get_call_args ${mock})" =~ -D\ /var/lib/postgresql ]]
  [[ "$(mock_get_call_env ${mock} PGPORT)" -eq 5432 ]]
  [[ "$(cat /tmp/postgres_started)" -eq "$$" ]]
}
```

More To Be Completed

# Appendix

## Example installation of bats-mock

```bash
➜  dummy ls -la /usr/local/lib/bats-*
lrwxr-xr-x  1 gavindidrichsen  admin  43 Feb 12 18:47 /usr/local/lib/bats-assert -> ../Cellar/bats-assert/0.3.0/lib/bats-assert
lrwxr-xr-x  1 gavindidrichsen  admin  45 Feb 12 18:47 /usr/local/lib/bats-support -> ../Cellar/bats-support/0.2.0/lib/bats-support
```

Clone the bats-mock repository and install it.  For example:

```bash
➜  DUMP git clone https://github.com/grayhemp/bats-mock.git
Cloning into 'bats-mock'...
remote: Enumerating objects: 98, done.
remote: Total 98 (delta 0), reused 0 (delta 0), pack-reused 98
Unpacking objects: 100% (98/98), done.
➜  DUMP cd bats-mock
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