#!/bin/bash

if [[ -z "${COOKIE}" ]]; then
  echo "Must set the COOKIE environment variable to be the root directory in which cookiecutter-habitat lives"
  exit 1
fi

# replace to use local library
sed -i.bak "s|BASH_TOOLBOX_DIRECTORY|__dir|g" {{ cookiecutter.script_name }}.sh
rm -f {{ cookiecutter.script_name }}.sh.bak