#!/bin/bash

# -------------------- #
# Common Color Helpers #
# -------------------- #

YELLOW='\033[01;33m'  # bold yellow
RED='\033[01;31m' # bold red
GREEN='\033[01;32m' # green
BLUE='\033[01;34m'  # blue
PURPLE='\033[01;35m' # purple
CYAN='\033[01;36m' # cyan
BOLD='\033[1m' # bold white
UNDERLINE='\033[4m' # underlined

RESET='\033[00;00m' # normal white

log "Available colors : ${YELLOW}yellow${RESET}, ${RED}red${RESET}, ${GREEN}green${RESET}, ${BLUE}blue${RESET}, ${PURPLE}purple${RESET}, ${CYAN}cyan${RESET}, ${BOLD}bold${RESET}, ${UNDERLINE}underlined${RESET}."
log "colors.sh loaded"