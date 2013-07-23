#!/bin/bash

# -------------------------- #
#          Utilities         #
# -------------------------- #

# Check major bash version
check_major_bash_version(){

  # Inputs
  min_major_bash_version=$1

  # Your major bash version
  bash_version=${BASH_VERSION%%[^0-9]*}

  if [ "$bash_version" -lt "$min_major_bash_version" ]; then

    clear
    indicate "Your bash version" ${BASH_VERSION}
    notify_error "Oh, ... bugger. This script requires bash > "${min_major_bash_version}"."
    exit 1 # Safer than return and continue

  fi

}

# Load a config file
load_config_file(){

  # Inputs
  CONFIG_FILE=$1

  log "Loading configuration (${CONFIG_FILE})"

  # Load configuration file
  if [[ -f $CONFIG_FILE ]]; then
  
    source $CONFIG_FILE
    return

  else

    notify_error "Missing configuration file : (${CONFIG_FILE})"
    return 1

  fi

}

# get_array_index VALUE ARRAY
get_array_index() {
  value="${1}"
  shift
  ARRAY=("${@}")
  for ((index=0; index<${#ARRAY[@]}; index++)); do 
    if [ "${ARRAY[$index]}" = "$value" ]; then
      echo $index
      return
    fi
  done
  echo -1
  return 1
}

log "util.sh loaded"