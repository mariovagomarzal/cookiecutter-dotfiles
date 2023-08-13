#!/bin/bash
#
# Bootstrap functions for the dotfiles setup
# NOTE: We assume these functions are called from
#       the `setup.sh` script so we can use the
#       helper functions from `utils.sh` and the
#       current working directory is the root of
#       the dotfiles repository.


# ┌────────────────────────┐
# │ Setup package function │
# └────────────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Run the 'setup.sh' script of a given directory.
# Arguments:
#   $1: Package (directory) to setup.
#   $2: OS name.
# Returns:
#   Exit code of the 'setup.sh' script.
# - - - - - - - - - - - - - - - - - - - - - - - - -
setup_package() {
    local -r dir="${1}"
    local -r os_name="${2}"

    local setup_script=""
    local exit_code=0

    # First, search for the package in the specific
    # OS directory. If it's not found, search in the
    # common directory.
    if [[ -f "${os_name}/${dir}/setup.sh" ]]; then
        setup_script="${os_name}/${dir}/setup.sh"
    elif [[ -f "common/${dir}/setup.sh" ]]; then
        setup_script="common/${dir}/setup.sh"
    else
        print_warning "${dir} 'setup.sh' script not found."
        return 1
    fi

    # Run the setup script.
    run_command "bash ${setup_script}" \
        "$LOG_DIR_NAME/${dir}_setup.log" \
        "Setting up ${dir}..." \
        "$dir setup successfully." \
        "Failed to setup ${dir}." || exit_code=1

    return $exit_code
}


# ┌──────────────────┐
# │ Symlink function │
# └──────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Locate the 'symlink' folder of a given directory.
# Then, symlink all the files in that folder assuming
# the 'symlink' directory acts as the user's home
# directory.
# Arguments:
#   $1: Package (directory) to symlink.
#   $2: OS name.
# Returns:
#   If any of the files fails to symlink, the
#   function will return 1. Otherwise, it will
#   return 0.
# - - - - - - - - - - - - - - - - - - - - - - - - - - -
symlink_package() {
    local -r dir="${1}"
    local -r os_name="${2}"
    
    local symlink_dir=""
    local exit_code=0
    local relative_path=""
    local intermediate_dirs=""
    local target_path=""

    # First, search for the package in the specific
    # OS directory. If it's not found, search in the
    # common directory.
    if [[ -d "${os_name}/${dir}/symlink" ]]; then
        symlink_dir="${os_name}/${dir}/symlink"
    elif [[ -d "common/${dir}/symlink" ]]; then
        symlink_dir="common/${dir}/symlink"
    else
        print_warning "${dir} 'symlink' directory not found."
        return 1
    fi

    # Loop through each file in the `symlinks` folder recursively.
    for file in $(find "${symlink_dir}" -type f); do
        # Get the absolute path of the file of the target symlink.
        relative_path="${file#${symlink_dir}/}"
        intermediate_dirs="${relative_path%/*}"
        target_path="$HOME/${relative_path}"

        # Create the intermediate directories if they don't exist.
        mkdir -p "$HOME/${intermediate_dirs}"

        # Create the symlink (note that we make $file absolute
        # by prepending $DOTFILES_DIR).
        run_command "ln -sf $DOTFILES_DIR/${file} ${target_path}" \
            "$LOG_DIR_NAME/${dir}_symlink.log" \
            "Symlinking to '${target_path}'..." \
            "'${target_path}' successfully symlinked." \
            "'${target_path}' failed to symlink." || exit_code=1
    done

    return $exit_code
}


# ┌─────────────────────┐
# │ Bootstrap functions │
# └─────────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Bootstrap a given package (directory).
# That is, setup and symlink the package.
# Arguments:
#   $1: Package (directory) to bootstrap.
#   $2: OS name.
# Returns:
#   If any of the functions fails, the function
#   will return 1. Otherwise, it will return 0.
# - - - - - - - - - - - - - - - - - - - - - - - - -
bootstrap_package() {
    local -r dir="$1"
    local -r os_name="$2"

    local exit_code=0

    # Setup the package.
    setup_package "${dir}" "${os_name}" || exit_code=1

    # Symlink the package.
    symlink_package "${dir}" "${os_name}" || exit_code=1

    return $exit_code
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Bootstrap all the packages listed in the
# bootstrap order file.
# Arguments:
#   $1: OS name.
# Returns:
#   If any of the functions fails, the function
#   will return 1. Otherwise, it will return 0.
# - - - - - - - - - - - - - - - - - - - - - - - - - - -
bootstrap_packages() {
    local -r os_name="${1}"

    local exit_code=0

    run_command_with_loop "bootstrap_package" \
        "bootstrap_order_${os_name}.txt" \
        "${os_name}" || exit_code=1

    return $exit_code
}
