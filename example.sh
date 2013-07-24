# Standard bootSHtrap script template example
#!/bin/bash

# Use BootSHtrap
#__DEBUG=1 # Sets the debug mode, which outputs logs to standard output
source bootshtrap/autoload.sh # Autoloads the whole stuff

main(){

  if [ $# -gt 0 ]; then
    indicate "Hey, I've found some parameters" "${@}" # Your parameters are available as usual ..
  fi

  ack "I'm a useful script that only prints this."

}

# Runs the application - this call must be the last (and only) inline function call,
# at the very end of the script.
run