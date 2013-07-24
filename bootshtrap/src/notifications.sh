#!/bin/bash

# -------------------------- #
#   Notification  Functions  #
# -------------------------- #

clear(){
  echo ""
}

ack(){
  NB="$#"
  TEXT="${1}"
  shift;
  if [ "${NB}" -eq 1 ] ; then
    echo -e " # "${GREEN}${TEXT}${RESET}
  elif [ "${NB}" -gt 1 ] ; then
    echo -e " # "${GREEN}${TEXT}${RESET}" : ${@}"
  fi
}

indicate(){
  NB="$#"
  TEXT="${1}"
  shift;
  if [ "${NB}" -eq 1 ] ; then
    echo -e " # "${BLUE}${TEXT}${RESET}
  elif [ "${NB}" -gt 1 ] ; then
    echo -e " # "${BLUE}${TEXT}${RESET}" : ${@}"
  fi
}

warn(){
  NB="$#"
  TEXT="${1}"
  shift;
  if [ "${NB}" -eq 1 ] ; then
    echo -e " # "${YELLOW}${TEXT}${RESET}
  elif [ "${NB}" -gt 1 ] ; then
    echo -e " # "${YELLOW}${TEXT}${RESET}" : ${@}"
  fi
}

ask(){
  if [ "$#" -eq 2 ] ; then
    echo -e " # "${RED}"${1}"${RESET}" [${2}] ?\c"
  else
    echo -e " # "${RED}"${1}"${RESET}" ?\c"
  fi
  read response
  echo "${response}"
  return
}

said_yes(){
  echo -e "   | "$(whoami)" said "${GREEN}"Yes"${RESET}"."${GREEN}" ${1}"${RESET}" :"
  clear
}

said_no(){
  echo -e "   | "$(whoami)" said "${RED}"No. "${RESET}
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
