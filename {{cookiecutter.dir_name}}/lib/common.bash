#!/bin/bash
#set -o errexit
#set -o pipefail
#set -o nounset

: '
Log info(), warning(), error() from a subshell so that this
can be used within functions that return output.  In other words
the subshell ensures that the info,warning,error message does not dirty
the function output, the "echo"
'
readonly LOG_FILE="/tmp/$(basename "$0").log"
readonly DATE_FORMAT="+%Y-%m-%d_%H:%M:%S.%2N"
info()    { ( echo "[$(date ${DATE_FORMAT})] [INFO]    $*" | tee -a "$LOG_FILE" >&2 ; ) }
warning() { ( echo "[$(date ${DATE_FORMAT})] [WARNING] $*" | tee -a "$LOG_FILE" >&2 ; ) }
error()   { ( echo "[$(date ${DATE_FORMAT})] [ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; ) }
fatal()   { echo "[$(date ${DATE_FORMAT})] [FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; kill 0 ; }

# Run these at the start and end of every script ALWAYS
info "Executing ${__file}"
cleanup() {
    local result=$?
    if (( result  > 0 )); then
        error "Exiting ${__file} prematurely with exit code [${result}]"
    else
        info "Exiting ${__file} cleanly with exit code [${result}]"
    fi
}
trap cleanup EXIT
trap "kill 0" SIGINT

# Define variables that hold the $ENCODED_ARGS that can be passed
# to the script. An existing plain text $ARG_FilE can also be used
ENCODED_ARGS=""
ARG_FILE="${__dir}/args.json"
JSON_SUM_OF_ALL_ARGS="{}"
# initialize variables
FLAG_ARGUMENT=""
while (( "$#" )); do
  case "$1" in
    -d|--debug)
      set -o xtrace
      shift 1
      ;;
    -h|--help)
      usage
      ;;
	  -e|--encoded)
      ENCODED_ARGS=$2
      shift 2
      ;;
    -A|--argfile)
      ARG_FILE=$2
      shift 2
      ;;
    -f|--flag)
      FLAG_ARGUMENT=$2
      JSON_SUM_OF_ALL_ARGS=$(echo "${JSON_SUM_OF_ALL_ARGS}" | jq --arg param1 "${2}" '."FLAG_ARGUMENT"  |= $param1')
      shift 2
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      error "Error: Unsupported flag $1"
      usage
      exit 1
      ;;
    *) # preserve positional arguments
      warning "Ignoring script parameter ${1} because no valid flag preceeds it"
      shift
      ;;
  esac
done

common::parseArgFile() {
  # either ARG_FILE or ENCODED_ARGS must be valid; otherwise bomb out
  if [[ ($ARG_FILE == "" || ! -e $ARG_FILE) && ($ENCODED_ARGS == "") ]]; then
    error "Either --argfile (default is ${ARG_FILE}) or --encoded json arguments must be set and valid"
    exit 1
  fi

  # If encoded arguments have been supplied, decode them and save to file
  if [ "X${ENCODED_ARGS}" != "X" ]; then
    info "Decoding arguments to ${ARG_FILE}"

    # Decode the bas64 string and write out the ARG file
    echo "${ENCODED_ARGS}" | base64 --decode | jq . > "${ARG_FILE}"
  fi

  # If the ARG_FILE has been specified and the file exists read in the arguments
  if [[ "X${ARG_FILE}" != "X" ]]; then
    if [[ ( -f $ARG_FILE ) ]]; then
      info "$(echo "Reading JSON vars from ${ARG_FILE}:"; cat "${ARG_FILE}" )"

      # combine the --flag arguments with --argsfile values (--flag's will override any values in the --argsfile)
      # and update the $ARG_FILE
      JSON_SUM_OF_ALL_ARGS=$(jq --sort-keys -s '.[0] * .[1]' "${ARG_FILE}" <(echo "${JSON_SUM_OF_ALL_ARGS}"))
      echo "${JSON_SUM_OF_ALL_ARGS}" | jq --sort-keys '.' > "${ARG_FILE}"

      # transform the JSON into bash key=value statements
      VARS=$(echo ${JSON_SUM_OF_ALL_ARGS} | jq -r '. | keys[] as $k | "\($k)=\"\(.[$k])\""' )
      # ensure that key's that are arrays are in the correct format (..) instead of "[..]"
      VARS=$(echo "${VARS}" | sed 's/\"\[/(/g' | sed 's/\]\"/)/g' | sed 's/,/ /g' )
      info "$(echo "Evaluating the following bash variables:"; echo "${VARS}")"

      # Evaluate all the vars in the arguments
      info "Evaluating the json arguments as bash variables"
      while read -r line; do
        eval "$line"
      done <<< "$VARS"
    else
      fatal "Unable to find specified args file: ${ARG_FILE}"
    fi
  fi
}

# fail if mandetory parameters are not present
# if [[ "$FLAG_ARGUMENT" == "" ]]; then fatal "--flag must be defined"; fi

