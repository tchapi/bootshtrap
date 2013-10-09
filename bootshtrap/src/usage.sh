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

      long=${options["${key:0:1}, long"]}
      message=${options["${key:0:1}, message"]}
      parameter=${options["${key:0:1}, parameter"]}
      
      echo -ne ${BLUE}"     -${key:0:1}"${RESET}

      if [[ "$long" ]]; then
        echo -ne ${CYAN}" --${long}"${RESET}
      fi

      if ! [ "$parameter" == "0" ]; then
        echo -ne " "${UNDERLINE}${parameter}${RESET}
      fi
      echo -ne " ("${RED}"required"${RESET}")"
      
      if [[ "${message}" ]]; then
        echo -e " ${message}"
      fi

  done

  for key in "${ARGS_SHORT_OPTIONAL[@]}"; do

      long=${options["$key, long"]}
      message=${options["$key, message"]}
      parameter=${options["${key:0:1}, parameter"]}
      
      echo -ne ${BLUE}"     -${key}"${RESET}

      if [[ "${long}" ]]; then
        echo -ne ${CYAN}" --${long}"${RESET}
      fi

      if ! [ "$parameter" == "0" ]; then
        echo -ne " "${UNDERLINE}${parameter}${RESET}
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
ARGS_ALL_GETOPT=()
ARGS_LONG_ALL_GETOPT=()
ORIGINAL_ARGS_COUNT=$#

parse_options_config() {

  log "Parsing options ..."

  for full_key in "${!options[@]}"; do

      IFS=', ' read -a option <<< "${full_key}"
      code=${option[0]}
      key=${option[1]}
      value=${options["$full_key"]}

      if [[ $key = "required" ]]; then
        
        # Parameter necessary ?
        if [ ${options["$code, parameter"]} == "0" ]; then
          ADD=""
        else
          ADD=":"
        fi

        # Required or optional
        if [[ $value -eq 1 ]]; then
          ARGS_SHORT_REQUIRED+=("${code}${ADD}")
          ARGS_ALL_REQUIRED+=("${code}")
          if [[ ${options["$code, long"]} ]]; then
            ARGS_LONG_REQUIRED+=(${options["$code, long"]}${ADD})
          fi
        else
          ARGS_SHORT_OPTIONAL+=("${code}${ADD}")
          if [[ ${options["$code, long"]} ]]; then
            ARGS_LONG_OPTIONAL+=(${options["$code, long"]}${ADD})
          fi
        fi

        # For getopt
        ARGS_ALL_GETOPT+=("${code}${ADD}")
        ARGS_LONG_ALL_GETOPT+=(${options["$code, long"]}${ADD})

        # For parsing input in autoload
        ARGS_ALL+=("${code}")
        ARGS_LONG_ALL+=(${options["$code, long"]})

        log " Found a new option : ${code}${ADD}"

      fi

  done

  ARGS_SHORT_REQUIRED=($(printf '%s\n' "${ARGS_SHORT_REQUIRED[@]}"|sort))
  ARGS_SHORT_OPTIONAL=($(printf '%s\n' "${ARGS_SHORT_OPTIONAL[@]}"|sort))
  ARGS_LONG_REQUIRED=($(printf '%s\n' "${ARGS_LONG_REQUIRED[@]}"|sort))
  ARGS_LONG_OPTIONAL=($(printf '%s\n' "${ARGS_LONG_OPTIONAL[@]}"|sort))

  ARGS_ALL_GETOPT=($(printf '%s\n' "${ARGS_ALL_GETOPT[@]}"|sort))
  ARGS_LONG_ALL_GETOPT=($(printf '%s\n' "${ARGS_LONG_ALL_GETOPT[@]}"|sort))

  ARGS_ALL=($(printf '%s\n' "${ARGS_ALL[@]}"|sort))
  ARGS_ALL_REQUIRED=($(printf '%s\n' "${ARGS_ALL_REQUIRED[@]}"|sort))
  ARGS_LONG_ALL=($(printf '%s\n' "${ARGS_LONG_ALL[@]}"|sort))

  log "Short options : ${ARGS_ALL_GETOPT[@]}, of which ${#ARGS_SHORT_REQUIRED[@]} is (are) required"
  log " --> Long equivalents : ${ARGS_LONG_ALL_GETOPT[@]}"

}

get_arguments(){

  # Formatting for the command line
  SHORTS=($(printf -- '%s' "${ARGS_ALL_GETOPT[@]}"))
  LONGS=($(printf -- '%s,' "${ARGS_LONG_ALL_GETOPT[@]}"))

  # This is a simili-try/catch structure, to get the error from getopt, 
  # which would otherwise be impossible (it would exit)
  ARGS=`{
    ${__GETOPT_PATH} -o "$SHORTS" -l "$LONGS" -n $0 -- "$@" 2>/dev/null
  } || {
    echo "0"
  }`

  # Missing option or invalid parameter ?
  if [ $? -ne 0 ] || [ "$ARGS" = " --
0" ] || [ "$ARGS" = "0" ] ; then
    notify_error "Invalid option(s) or missing parameter for : ${@}"
    usage
    error_exit
  fi

}

parse_options_config
get_arguments $@

log "usage.sh loaded"
