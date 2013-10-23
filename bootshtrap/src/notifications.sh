#!/bin/bash

# -------------------------- #
#   Notification  Functions  #
# -------------------------- #

clear(){
  echo ""
}

ack(){
  NB="$#"
  TEXT="${1-}"
  shift;
  if [ "${NB}" -eq 1 ] ; then
    echo -e " # "${GREEN}${TEXT}${RESET}
  elif [ "${NB}" -gt 1 ] ; then
    echo -e " # "${GREEN}${TEXT}${RESET}" : ${@}"
  fi
}

indicate(){
  NB="$#"
  TEXT="${1-}"
  shift;
  if [ "${NB}" -eq 1 ] ; then
    echo -e " # "${BLUE}${TEXT}${RESET}
  elif [ "${NB}" -gt 1 ] ; then
    echo -e " # "${BLUE}${TEXT}${RESET}" : ${@}"
  fi
}

warn(){
  NB="$#"
  TEXT="${1-}"
  shift;
  clear
  if [ "${NB}" -eq 1 ] ; then
    echo -e ${RED}" # "${YELLOW}${TEXT}${RESET}
  elif [ "${NB}" -gt 1 ] ; then
    echo -e ${RED}" # "${YELLOW}${TEXT}${RESET}" : ${@}"
  fi
  clear
}


ask(){
  if [ "$#" -eq 2 ] ; then
    echo -e >&2 " # "${PURPLE}"${1-}"${RESET}" [${2}] ?\c"
  else
    echo -e >&2 " # "${PURPLE}"${1-}"${RESET}" ?\c"
  fi
  read response
  if [ "$response" == "" ] && [ "$#" -eq 2 ]; then
    response="${2}"
  fi
  echo "${response}"
  return
}

said_yes(){
  echo -e "   | "$(whoami)" said "${GREEN}"Yes"${RESET}". "${GREEN}"${1-}"${RESET}
  clear
}

said_no(){
  echo -e "   | "$(whoami)" said "${RED}"No"${RESET}". "${GREEN}"${1-}"${RESET}
  clear
}

notify_error(){
  echo -e " #${RED} Wooops !"${RESET}" ${@}"
#  clear
}

notify_done(){
  echo -e " # "${GREEN}"Done. "${RESET}
  clear
}

header(){

  echo -e ${RESET}

  header="${1-}"
  length=${#header}
  decoration=`seq 1 ${length} | sed 's/.*/-/' | tr -d '\n'`

  echo -e " % "${CYAN}"${header}"${RESET}
  echo    " % "${decoration}

  clear
}

title(){

  echo -e ${RESET}

  if [ "$__TITLE" = "" ] ; then

    echo -e "--- ${GREEN}BootSHtrap script${RESET} ---"

  else

    title=$__TITLE
    length=${#title}
    decoration=`seq 1 ${length} | sed 's/.*/-/' | tr -d '\n'`

    echo    " # "${decoration}" #"
    echo -e " # "${GREEN}"${__TITLE}"${RESET}" #"
    echo    " # "${decoration}" #"

  fi
  
  clear
}

log "notifications.sh loaded"
