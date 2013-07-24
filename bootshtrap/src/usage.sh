#!/bin/bash


# -------------------------- #
#       Usage functions      #
# -------------------------- #

usage(){

  echo -ne " # "${GREEN}"Usage:"${RESET}" `basename $0`"

  if [[ ${#ARGS_SHORT_REQUIRED[@]} -gt 0 ]]; then
    echo -ne " -"${ARGS_SHORT_REQUIRED[@]}
  fi

  if [[ "${#ARGS_SHORT_OPTIONAL[@]}" -gt 0 ]]; then
    echo -ne " [-${ARGS_SHORT_OPTIONAL[@]}]"
  fi

  echo " "${parameters}

  # Parse options
  for key in "${ARGS_SHORT_REQUIRED[@]}"; do

      long=${options["$key, long"]}
      message=${options["$key, message"]}
      
      echo -ne ${BLUE}"     -${key}"${RESET}

      if [[ "$long" ]]; then
        echo -ne " --${long}"
      fi

      echo -ne " ("${RED}"required"${RESET}")"
      
      if [[ "${message}" ]]; then
        echo -e " ${message}"
      fi

  done

  for key in "${ARGS_SHORT_OPTIONAL[@]}"; do

      long=${options["$key, long"]}
      message=${options["$key, message"]}
      
      echo -ne ${BLUE}"     -${key}"${RESET}

      if [[ "${long}" ]]; then
        echo -ne " --${long}"
      fi

      echo -ne " ("${GREEN}"optional"${RESET}")"
      
      if [[ "${message}" ]]; then
        echo -e " ${message}"
      fi

  done

  clear

  exit 0
  
}

# -------------------------- #
#       Parsing options      #
# -------------------------- #

ARGS_SHORT_REQUIRED=()
ARGS_LONG_REQUIRED=()
ARGS_SHORT_OPTIONAL=()
ARGS_LONG_OPTIONAL=()
ARGS_ALL=()
ARGS_LONG_ALL=()
ARGS_ALL_FUNCTION=()
ORIGINAL_ARGS_COUNT=$#

parse_options_config() {

  log "Parsing options ..."

  for full_key in "${!options[@]}"; do

      IFS=', ' read -a option <<< "${full_key}"
      code=${option[0]}
      key=${option[1]}
      value=${options["$full_key"]}

      if [[ $key = "required" ]]; then
        
        if [[ $value -eq 1 ]]; then
          ARGS_SHORT_REQUIRED+=("${code}")
          if [[ ${options["$code, long"]} ]]; then
            ARGS_LONG_REQUIRED+=(${options["$code, long"]})
          fi
        else
          ARGS_SHORT_OPTIONAL+=("${code}")
          if [[ ${options["$code, long"]} ]]; then
            ARGS_LONG_OPTIONAL+=(${options["$code, long"]})
          fi
        fi

        ARGS_ALL+=("${code}")
        ARGS_LONG_ALL+=(${options["$code, long"]})
        ARGS_ALL_FUNCTION+=(${options["$code, function"]})

        log " Found a new option : ${code}"

      fi

  done

  ARGS_SHORT_REQUIRED=($(printf '%s\n' "${ARGS_SHORT_REQUIRED[@]}"|sort))
  ARGS_SHORT_OPTIONAL=($(printf '%s\n' "${ARGS_SHORT_OPTIONAL[@]}"|sort))
  ARGS_LONG_REQUIRED=($(printf '%s\n' "${ARGS_LONG_REQUIRED[@]}"|sort))
  ARGS_LONG_OPTIONAL=($(printf '%s\n' "${ARGS_LONG_OPTIONAL[@]}"|sort))

  ARGS_ALL=($(printf '%s\n' "${ARGS_ALL[@]}"|sort))
  ARGS_LONG_ALL=($(printf '%s\n' "${ARGS_LONG_ALL[@]}"|sort))
  ARGS_ALL_FUNCTION=($(printf '%s\n' "${ARGS_ALL_FUNCTION[@]}"|sort))

  log "Short options : ${ARGS_SHORT_OPTIONAL[@]}, of which ${#ARGS_SHORT_REQUIRED[@]} is (are) required"
  log " --> Long equivalents : ${ARGS_LONG_OPTIONAL[@]}"

}

get_arguments(){

  SHORTS=($(printf -- '%s' "${ARGS_ALL[@]}"))
  LONGS=($(printf -- '%s,' "${ARGS_LONG_ALL[@]}"))
  ARGS=$(${__GETOPT_PATH} -o "$SHORTS" -l "$LONGS" -n $0 -- "$@" 2>/dev/null);

  if [[ $? -ne 0 ]]; then
    notify_error "Invalid option(s) : ${@}"
    usage
    exit 1
  fi

}

parse_options_config
get_arguments $@

log "usage.sh loaded"
