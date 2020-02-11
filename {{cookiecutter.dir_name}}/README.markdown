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
include string.util.StringUtil

# exercise the StringUtil beginsWithVowel method"
Logger log info $( StringUtil toUpperCase "Absalom" )
```

Running the above will produce something like:

```bash
[2019-11-03 14:45:56] [INFO] ABSALOM
```

## Testing the Library

source test.env and run an individual bats test
OR
Run the unit_test_runner.sh, which sources the test.env
