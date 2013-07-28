# BootSHtrap
- - -

A micro library of helpers and functions to create simple bash scripts that look nice.

![It's bootSHtrap](/misc/meme.jpg "It's bootSHtrap")

## Background

[[ To be completed soon ]]

## Requirements

bootshtrap requires at least `bash 4` (for associative arrays to work correctly) and a GNU version of `getopt` (`gnu-getopt`, for option parsing).

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

    > NB :An option without parameter cannot be required (Since this would mean that the script could *not* run without this option..)

  - The `parameter` item indicates whether the option requires an argument or not. If not, then put `0`. If it does require an argument, indicate its name as you would like to see it in the usage help message (generally, a [a-zA-Z_-]* string for convenience)

  - The `long` item indicates the long name of your option. It is required to start with the same letter as your option.

  - The `message` item describes the effect of your option. It is used in the usage message

  - The `function` item indicates the name of the shell function that will be evaluated if the option is passed to your script. It must comply with shell rules for function naming 


### Adding your parameters

Bootshtrap cannot guess the parameters you will manage in your script. Hence you are kindly asked to describe them for help purposes in the configuration file, so that the `usage` function knows what to display.

```bash
    # bootshtrap.config
    parameters="required_param_1 required_param2 [optional_param_3]"
```

[[ To be continued - work in progress ]]

## Todo

  - in logs and notifs, always use ${*} notation [DONE]
  - test various cases when functions don't exist (declared in config but not coded) [DONE]
  - add the ARGS_ALL_CLEAN in autoload [DONE]

## License

BootSHtrap is licensed under the traditional MIT license. Basically, as long as you keep the notice and don't blame me, it's all good. See http://www.tldrlegal.com/license/mit-license for details.

