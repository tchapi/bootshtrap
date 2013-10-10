#!/bin/bash

# Current filename of script
# If you're thinking readlink -f could do the job, read this :
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
__DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

__GETOPT_PATH="getopt"

set -e

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
  load_config_file "$config"

  title

# Parses the options configuration
  source ${__DIR}/src/usage.sh

# Parse command line options according to options.conf
run() {

  # Magic
  eval set -- "${ARGS}";
  log "Argument(s) and option(s) found : ${ARGS}"
  
  REQUIRED_COUNTER=0;

  while true; do

    param="${1}"
    log "Checking option : ${param}"

    # End of parameters array, break.
    if [[ "${1}" = '--' ]]; then 
      shift;
      break;
    fi

    # Let's check if we have valid options
    SHORT_USED=`get_array_index "${param:1}" ${ARGS_ALL[@]}`
    LONG_USED=`get_array_index "${param:2}" ${ARGS_LONG_ALL[@]}`

    # We have to differentiate short options and long options
    if [[ SHORT_USED -ne -1 ]]; then
      shift;
      handler=${options[${ARGS_ALL["$SHORT_USED"]}, "function"]}
      assess_function ${handler}

      # This option has a parameter ?
      if ! [ ${options[${ARGS_ALL["$SHORT_USED"]}, "parameter"]} = "0" ] && [ -n "${1}" ]; then
        ${handler} "${1}"
        shift;
      else
        ${handler}
      fi

      WAS_REQUIRED=`get_array_index "${ARGS_ALL["$SHORT_USED"]}" ${ARGS_ALL_REQUIRED[@]}`

    elif [[ LONG_USED -ne -1 ]]; then
      shift;
      handler=${options[${ARGS_LONG_ALL["$LONG_USED"]}, "function"]}
      assess_function ${handler}

      # This option has a parameter ?
      if ! [ ${options[${ARGS_LONG_ALL["$LONG_USED"]}, "parameter"]} = "0" ] && [ -n "${1}" ]; then
        ${handler} "${1}"
        shift;
      else
        ${handler}
      fi

      WAS_REQUIRED=`get_array_index "${ARGS_LONG_ALL["$LONG_USED"]}" ${ARGS_ALL_REQUIRED[@]}`

    else # Should never happen !
      notify_error "Invalid option : ${1}"
      usage
      error_exit
    fi

    if [[ WAS_REQUIRED -ne -1 ]]; then
      REQUIRED_COUNTER=$((REQUIRED_COUNTER+1))
    fi

  done

  # Have all the required options been found ?
  if [[ REQUIRED_COUNTER -ne "${#ARGS_LONG_REQUIRED[@]}" ]]; then
      # Ooops
      notify_error "A required option was not found"
      usage
      error_exit
  fi

  # Now we can trap errors
  set -u # Undefined variables
  set -E # Beware ! Only works if trap ERR is set !

  # Trap errors
  trap 'trap_break $LINENO' INT QUIT
  trap 'trap_error $LINENO' ERR

  main "${@}"
  clear

}
