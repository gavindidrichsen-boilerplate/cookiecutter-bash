#!/bin/bash

if [[ -z "${COOKIE}" ]]; then
  echo "Must set the COOKIE environment variable to be the root directory in which cookiecutter-habitat lives"
  exit 1
fi

# go up a directory so that the 'simple_binary' is added to the correct directory
(
  cd ../.
  cookiecutter ${COOKIE}/cookiecutter-bash/common -f --no-input dir_name='{{ cookiecutter.dir_name }}' script_name='{{ cookiecutter.script_name }}'
)
