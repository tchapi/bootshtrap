#!/bin/bash

# -------------------- #
#     Debug helper     #
# -------------------- #

log(){

  if [[ "$__DEBUG" -eq 1 ]]; then
    echo -e ${YELLOW}" # "${RESET}$@
  fi

}
