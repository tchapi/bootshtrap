# BootSHtrap
- - -

A micro helper library of functions to create bash script

[[ image to be inserted here ]]

## Requirements

bootshtrap requires at least `bash 4` (for associative arrays to work correctly) and a GNU version of `getopt` (`gnu-getopt`, for option parsing).

For Mac OS X users, you can update your bash with `brew` :

    brew install bash
    sudo bash -c "echo /usr/local/bin/bash >> /private/etc/shells"

And change your shell to the new bash :

    chsh -s /usr/local/bin/bash

If you already have GNU getopt, you're good to go ! If not, you can install it via `brew` again :

    brew install gnu-getopt

This will not change your `getopt`, but install a new one in a new location (generally, something like `/usr/local/Cellar/gnu-getopt/1.1.5/bin/getopt`). You can then update your bootshtrap config to point to this new binary, by uncommenting the second line starting with `__GETOPT_PATH` :

    # Use custom gnu-getopt
    __GETOPT_PATH="/usr/local/Cellar/gnu-getopt/1.1.5/bin/getopt"


## Initial configuration

The configuration is done in the `bootshtrap.config` file at the root of the `bootshtrap` folder. This file contains various parameters for you to set.

[[ To be continued ]]