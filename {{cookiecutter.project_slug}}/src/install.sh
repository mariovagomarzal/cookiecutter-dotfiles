#!/bin/bash
#
# Install functions for the dotfiles setup
# NOTE: We assume these functions are called from
#       the `setup.sh` script so we can use the
#       helper functions from `utils.sh` and the
#       current working directory is the root of
#       the dotfiles repository.


# ┌───────────────────┐
# │ Install functions │
# └───────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run the 'install.sh' script of a given directory.
# Arguments:
#   $1: Package (directory) to install.
#   $2: OS name.
# Returns:
#   Exit code of the 'install.sh' script.
# - - - - - - - - - - - - - - - - - - - - - - - - - -
install_package() {
    local -r dir="$1"
    local -r os_name="$2"

    local install_script=""
    local exit_code=0

    # First, search for the package in the specific
    # OS directory. If it's not found, search in the
    # common directory.
    if [[ -f "$os_name/$dir/install.sh" ]]; then
        install_script="$os_name/$dir/install.sh"
    elif [[ -f "common/$dir/install.sh" ]]; then
        install_script="common/$dir/install.sh"
    else
        print_warning "$dir 'install.sh' script not found."
        return 1
    fi

    # Run the install script.
    run_command "bash $install_script" \
        "$LOG_DIR/$dir_install.log" \ 
        "Installing $dir..."
        "$dir installed successfully." \
        "Failed to install $dir." || exit_code=1

    return $exit_code
}

# - - - - - - - - - - - - - - - - - - - - - - -
# Install all the packages listed in a
# given array, in order.
# Arguments:
#   $1: Array of packages to install.
#   $2: OS name.
# Returns:
#    If any of the packages fails to install,
#    the function will return 1. Otherwise,
#    it will return 0.
# - - - - - - - - - - - - - - - - - - - - - - -
install_packages() {
    local -r packages=("$@")
    local -r os_name="$2"

    local exit_code=0

    for package in "${packages[@]}"; do
        install_package "$package" "$os_name" || exit_code=1
    done

    return $exit_code
}
