#!/bin/bash

# -------------------------- #
#          Utilities         #
# -------------------------- #

# Check major bash version
check_major_bash_version() {

  if [ -z $BASH ];then
    notify_error "Le script doit être lancé avec ./$0"
    error_exit
  fi

  # Inputs
  min_major_bash_version=$1

  # Your major bash version
  bash_version=${BASH_VERSION%%[^0-9]*}

  if [ "${bash_version}" -lt "${min_major_bash_version}" ]; then

    clear
    indicate "Your bash version" ${BASH_VERSION}
    notify_error "Oh, ... bugger. This script requires bash > ${min_major_bash_version}."
    error_exit

  fi

}

# Load a config file
load_config_file() {

  # Inputs
  CONFIG_FILE=$1

  log "Loading configuration (${CONFIG_FILE})"

  # Load configuration file
  if [[ -f $CONFIG_FILE ]]; then
  
    source $CONFIG_FILE

  else

    notify_error "Missing configuration file : (${CONFIG_FILE})"
    error_exit

  fi

}

# get_array_index VALUE ARRAY
get_array_index() {
  value="${1}"
  shift
  ARRAY=("${@}")
  for ((index=0; index<${#ARRAY[@]}; index++)); do 
    if [ "${ARRAY[$index]}" = "${value}" ]; then
      echo $index
      return
    fi
  done
  echo -1
}

# --------------------
## INTERNALS from here
# --------------------

# Assesses the existence of a function, otherwise exits
assess_function() {
  type ${1} &>/dev/null || {
    notify_error "The function ${1} is not defined; now exiting."
    error_exit
    }
}

trap_break()
{
    notify_error "CTRL-C HIT script [$0]: line $1"
    notify_error "last command : [$BASH_COMMAND]"
    error_exit
}

trap_error()
{
    notify_error "While running script [$0]: line $1"
    notify_error "error in command : [$BASH_COMMAND]"
    error_exit
}

error_exit() {
  clear
  trap 2 3
  exit 1
}

set -E # Beware ! Only works if trap ERR is set !
set -u # Undefined variables

# Trap errors
trap 'trap_break $LINENO' INT QUIT
trap 'trap_error $LINENO' ERR


log "util.sh loaded"