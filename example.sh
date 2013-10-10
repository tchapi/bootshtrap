#!/bin/bash
# Standard bootSHtrap script template example

# Use BootSHtrap
# __DEBUG=1 # Sets the debug mode, which outputs logs to standard output
config="`dirname $0`"/bootshtrap.config # Path to your configuration file
source bootshtrap/autoload.sh # Autoloads the whole stuff

# You need to have a main() function in your script - this is your entry point
main(){

  if [ $# -gt 0 ]; then
    indicate "Hey, I've found some parameters" "${@}" # Your parameters are available as usual ..
  fi

  ack "I'm a useful script that only prints this."

}

# Runs the application - this call must be the last (and only) inline function call,
# at the very end of the script.
run