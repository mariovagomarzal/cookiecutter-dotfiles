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
# Returns:
#   Exit code of the 'install.sh' script.
# - - - - - - - - - - - - - - - - - - - - - - - - - -
install_package() {
    local -r dir="${1}"
    local -r os_name=$(get_os_name)

    local install_script=""
    local exit_code=0

    # First, search for the package in the specific
    # OS directory. If it's not found, search in the
    # common directory.
    if [[ -f "${os_name}/${dir}/install.sh" ]]; then
        install_script="${os_name}/${dir}/install.sh"
    elif [[ -f "common/${dir}/install.sh" ]]; then
        install_script="common/${dir}/install.sh"
    else
        print_warning "${dir} 'install.sh' script not found."
        return 1
    fi

    # Run the install script.
    run_command "bash ${install_script}" \
        "$LOG_DIR_NAME/${dir}_install.log" \
        "Installing ${dir}..." \
        "${dir} installed successfully." \
        "Failed to install ${dir}." || exit_code=1

    return $exit_code
}
