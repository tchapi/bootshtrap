# Standard bootSHtrap script template
#!/bin/bash

# Use BootSHtrap
__DEBUG=1 # Sets the debug mode, which outputs log functions 
source bootshtrap/autoload.sh # Autoloads the whole stuff

main(){

  title

  indicate "Parameters" "$@" # Your parameters are available as usual ..

  ack "I'm only printing this."
  clear

}

# Runs the application - this call must be the last (and only) inline function call,
# at the very end of the script.
run