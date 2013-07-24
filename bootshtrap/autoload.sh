#!/bin/bash

# Current filename of script
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
__DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

__GETOPT_PATH="getopt"

# Includes
  source ${__DIR}/src/debug.sh
  source ${__DIR}/src/colors.sh
  source ${__DIR}/src/notifications.sh
  source ${__DIR}/src/util.sh

# Check bash version
  check_major_bash_version 4

# Arguments & loads bootshtrap config file
  unset options
  declare -A options
  load_config_file ${__DIR}/bootshtrap.config

  title

# Parses the options configuration
  source ${__DIR}/src/usage.sh

# Parse command line options according to options.conf
run() {

  # Magic
  eval set -- "${ARGS}";
  log "${#ARGS[@]} option(s) found : ${ARGS}"
  
  # Do we have enough options ?
  if [[ $ORIGINAL_ARGS_COUNT -lt ${#ARGS_SHORT_REQUIRED[@]} ]]; then
    notify_error "You have not provided enough options"
    usage
    exit 1
  fi

  while true; do

    param="${1}"
    log "Checking option : ${param}"

    if [[ "${1}" = '--' ]]; then 
      shift;
      break;
    fi

    # if options contains it
    SHORT_USED=`get_array_index "${param:1}" ${ARGS_ALL[@]}`
    LONG_USED=`get_array_index "${param:2}" ${ARGS_LONG_ALL[@]}`

    if [[ SHORT_USED -ne -1 ]]; then
      eval ${options[${ARGS_ALL["$SHORT_USED"]}, "function"]}
      shift;
    elif [[ LONG_USED -ne -1 ]]; then
      eval ${options[${ARGS_LONG_ALL["$SHORT_USED"]}, "function"]}
      shift;
    else
      notify_error "Invalid option : ${1}"
      usage
      exit 1
    fi

  done

  main "${@}"
  clear

}
