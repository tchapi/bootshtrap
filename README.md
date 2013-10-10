# BootSHtrap

A micro library of helpers and functions to create simple bash scripts that look nice.

![It's bootSHtrap](/misc/meme.jpg "It's bootSHtrap")

- - -


## Background

**11/10** : We have a quite complete version now, with error trapping and correct parameter parsing !


[[ To be completed soon ]]

## Requirements

**bootSHtrap** requires at least `bash 4` (for associative arrays to work correctly) and a GNU version of `getopt` (`gnu-getopt`, for option parsing).

For Mac OS X users, you can update your bash with `brew` :

```bash
    brew install bash
    sudo bash -c "echo /usr/local/bin/bash >> /private/etc/shells"
```

And change your shell to the new bash :

```bash
    chsh -s /usr/local/bin/bash
```

If you already have GNU getopt, you're good to go ! If not, you can install it via `brew` again :

```bash
    brew install gnu-getopt
```

This will not change your `getopt`, but install a new one in a new location (generally, something like `/usr/local/Cellar/gnu-getopt/1.1.5/bin/getopt`). You can then update your bootshtrap config to point to this new binary, by uncommenting the second line starting with `__GETOPT_PATH` and indicating the correct path to your GNU-getopt :

```bash
    # bootshtrap.config
    # Use custom gnu-getopt
    __GETOPT_PATH="/usr/local/Cellar/gnu-getopt/1.1.5/bin/getopt"
```

## Initial configuration

The configuration is done in the `bootshtrap.config` file at the root of the `bootshtrap` folder. This file contains various parameters for you to set.

### Setting the title of your script

You can give a custom name to your script. This name will be used and echoed in the `title` function. Just set the `__TITLE` variable in the configuration file :

```bash
    # bootshtrap.config
    __TITLE="My Fantastic script"
```

### Adding options

You can add options for your script to handle. Each option passed to your script will trigger the configured handler, which is a standard shell function. This handler can, for instance, set flags, or execute code, as you please.

To add a new option, you have to define it according to this template :

```bash
    # bootshtrap.config
    options["c", "required"]=1
    options["c", "parameter"]=a_string
    options["c", "long"]="cfunc"
    options["c", "message"]="cleans all previous versions upon deployment"
    options["c", "function"]="c_function"
```

First of all, choose a letter for your option (`c` here in this example above). You are required to define a long name as well (here, `cfunc` in the example).
The letter of your option is then the first index for the different items of the array defining your option.

You are left with 5 items to fill in :

  - The `required` item is either `0` or `1` and indicates if the option is compulsory or not.

    > NB : An option without parameter cannot be required (Since this would mean that the script could *not* run without this option..)

  - The `parameter` item indicates whether the option requires an argument or not. If not, then put `0`. If it does require an argument, indicate its name as you would like to see it in the usage help message (generally, a [a-zA-Z_-]* string for convenience).

  - The `long` item indicates the long name of your option. **It is required to start with the same letter as your option's letter.**

  - The `message` item describes the effect of your option. It is used in the usage message.

  - The `function` item indicates the name of the shell function that will be evaluated if the option is passed to your script. It must comply with shell rules for function naming. 

#### Examples

The `usage` configuration (already included, for your pleasure), is :

```bash
    options["h", "required"]=0
    options["h", "parameter"]=0
    options["h", "long"]="help"
    options["h", "message"]="prints this help and usage message"
    options["h", "function"]="usage"
```

The `usage` function is defined internally in bootSHtrap's files. It prints the usage according to the configuration, and then exits the script.
If you need, you can call the `usage` function directly anywhere in your script :

```bash
    # Prints usage and exits
    usage
``` 

> NB : The precoded `usage` function exits the script

You can define a "flag-setting option", for instance `-f` or `--flag`, very easily :


```bash
    # bootshtrap.config
    options["f", "required"]=0
    options["f", "parameter"]=1
    options["f", "long"]="flag"
    options["f", "message"]="sets a flag according to the parameter given"
    options["f", "function"]="set_flag"
```

And the related code :

```bash
    # example.sh (your script using bootSHtrap)
    
    # We define a global variable to hold the flag value
    __MY_FLAG=1

    # The handler in itself
    set_flag() {

      __MY_FLAG="${1}"

    }
```

> NB : Your handlers can be defined anywhere in your code as long as they are available in the global context.

### Adding your parameters

Bootshtrap cannot guess the parameters you will manage in your script. Hence you are kindly asked to describe them for help purposes in the configuration file, so that the `usage` function knows what to display.

```bash
    # bootshtrap.config
    parameters="required_param_1 required_param2 [optional_param_3]"
```

## Creating your script

This is the easy step to get you going. Just create a script 

  1. For the sake of compatibility, it is recommended that you include, at the very top of your file, a directive for the shell to know how to interpret your script :

    ```bash
        #!/bin/bash
    ```

    > NB : If, on Mac OS X, you have installed a local upgraded version of bash 4, then you probably want it to look like that : `#!/usr/local/bin/bash`

  2. Then, you have to load bootSHtrap into your script. This is done via a single command (below, we assume that the bootSHtrap folder is in the same folder than your script, but you're free to do otherwise) :

    ```bash
        config="/home/user/project/bootshtrap.config" # Change this path to wherever your bootshtrap.config file is
        source bootshtrap/autoload.sh # Autoloads the whole stuff
    ```

  3. Define a `main` function . This will be your single entry point after the options' functions have been called

    ```bash

        main() {

          # Your magic goes here ...

        }

    ```

  4. The last line of the script must be `run` to trigger the whole thing

    ```bash
        
        # The rest of your script is up there
        run

    ```

  5. That's it, do not forget to `chmod +x your_script.sh` and you're ready to go !

> NB : The full example goes like that :

```bash 
    #!/bin/bash
    # Standard bootSHtrap script template example

    # Use BootSHtrap
    # __DEBUG=1 # Sets the debug mode, which outputs logs to standard output
    source bootshtrap/autoload.sh # Autoloads the whole stuff

    # You need to have a main() function in your script - this is your entry point
    main(){

      # Your magic ....

    }

    # Runs the application - this call must be the last (and only) inline function call,
    # at the very end of the script.
    run
```

## Log and debug

Bootshtrap come with some additional logs that you can echo to standard output when debugging. To do so, use the `log` function in your script when you need to log something while debugging

```bash
    log "This is a debug log : $my_var"
```

Logs will **not** be echoed to standard output unless you specify the debug flag at the start of your script (_before_ autoloading bootSHtrap) :

```bash
   __DEBUG=1
   source bootshtrap/autoload.sh # Autoloads the whole stuff
```

An example log in stdout :

```bash

   > ./my_script.sh

   # This is a debug log : variable_value
```

> NB : By default, bootSHtrap logs its stuff with this function as well, so you may see some internal logs in there


# The bootSHtrap "API"

The API is divided in different sections :

  - Colors
  - Notifications
  - Utilities
  - System (TODO)

It basically provides you with functions to work with more easily, and to interact with the user.

## Colors

These colors are available (on compatible terminals):

  - YELLOW # bold yellow
  - RED # bold red
  - GREEN= # green
  - BLUE # blue
  - PURPLE # purple
  - CYAN # cyan
  - BOLD # bold white
  - UNDERLINE # underlined normal text
  - RESET # resets the color

To use them, simply echo them in an `echo -e` command:

```bash
    echo -e ${RED}" My text in red "${RESET}
```

> NB : Do not forget to reset the color escape sequence (with the special `${RESET}` escape sequence) in order to only color _what you need_ ...

## Notifications

> NB : Notifications appear in color on compatible terminals, but the markdown flavour used herein doesn't allow for syntax coloring, sorry.

### title

Echoes the nicely formatted title of your script. _This function takes one optional argument : the title to output. If the configuration variable `__TITLE` is not present, this fallback argument is used._

**Usage**

```bash
    title "My Example Script"
```

**Output**

```bash 
     # ----------------- #
     # My Example Script #
     # ----------------- #
```

### ack

Echoes a green formatted text. _This function takes a single, or two arguments. The first argument will be echoed in color for emphasis, not the second_

**Usage**

```bash
    ack "I've done this"
    ack "Information" "He's done that too"
```

**Output**

```bash
    # I've done this
    # Information : He's done that too
```

### indicate

Same as `ack`, but in blue.

### warn

Same as `ack`, but in yellow

### ask

Ask the user for something and returns the answer. _This function takes two arguments: the first one is the question to ask, the second one (optional) is the default answer if the user just bangs the Return key._

**Usage**

```bash
    answer=`ask "What do you want" "nothin'"`
    indicate "User said" ${answer}

    answer2=`ask "What do you really want"`
    indicate "User said" ${answer2}
```

**Output**

```bash
    # What do you want [nothin'] ? bla bla
    # User said : bla bla

    # What do you really want ? bla bla
    # User said : bla bla
```


### said_yes

Echoes a formatted validation message using the name of the logged in user. _This function takes one argument that will be echoed._

**Usage**

```bash
    said_yes "Going on with the script."
```

**Output**

```bash
    | user said yes. Going on with the script.
```

### said_no

Echoes a formatted non-validation message using the name of the logged in user. _This function takes one argument that will be echoed._

**Usage**

```bash
    said_no "Stopping."
```

**Output**

```bash
    | user said no. Stopping.
```

### notify_error

Echoes a formatted error message. _This function takes as many arguments as you wish (they will be echoed)._

**Usage**

```bash
    notify_error "You're doing it wrong"
```

**Output**

```bash
    # Woops ! You're doing it wrong
```

### notify_done

Echoes a formatted "done" text. _This function takes no argument._

**Usage**

```bash
    notify_done
```

**Output**

```bash
    # Done
```

### clear

Adds a blank line to standard output. _This function takes no argument._

**Usage**

```bash
    clear
```

## Utility functions

### load\_config\_file

This helper loads a config file if it exists, or outputs an error otherwise and exits with an error status of 1.

**Usage**

```bash
    load_config_file "./my_config"
```

**Returns**

Nothin' ...

### get\_array\_index

This function tries to get the array index of an item in an array, if it exists. _This function takes two arguments : an item value and an array._

**Usage**

```bash
    get_array_index ${needle} ${haystack[@]}
```

**Returns**

`-1` if the element is not found, its index otherwise. With its index, you can then access the element with :

```bash
    index=`get_array_index ${needle} ${haystack[@]}`
    echo ${haystack["$index"]} # This is your element, which equals value
```

(but this should not be necessary since the element equals `${needle}`)





- - -


## Todo

  - TBC

## License

BootSHtrap is licensed under the traditional MIT license. Basically, as long as you keep the notice and don't blame me, it's all good. See http://www.tldrlegal.com/license/mit-license for details.

