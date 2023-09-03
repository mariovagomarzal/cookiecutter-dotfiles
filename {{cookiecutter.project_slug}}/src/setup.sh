#!/bin/bash
#
# Setup script for the dotfiles
# NOTE: Make sure you know what you are doing before
#       running this script. Read the documentation
#       first to understand what this script does.


# Constants
export DOTFILES_DIR="{{ cookiecutter.dotfiles_dir }}"
export LOG_DIR_NAME="log"

export GITHUB_REPO_NAME="{{ cookiecutter.github_username }}/{{ cookiecutter.project_slug }}"
export GITHUB_REPO_URL="https://github.com/$GITHUB_REPO_NAME"
export GITHUB_REPO_RAW_URL="https://raw.githubusercontent.com/$GITHUB_REPO_NAME"


# ┌────────────────┐
# │ OS recognition │
# └────────────────┘

# - - - - - - - - - - - - - - - - - - - -
# Get the OS name.
# Arguments:
#   None.
# Returns:
#   The OS name. Possible outputs are:
#     - linux
#     - macos
#     - unknown
# - - - - - - - - - - - - - - - - - - - -
get_os_name() {
    local os_name=""
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        os_name="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        os_name="macos"
    else
        os_name="unknown"
    fi
    
    printf $os_name
}


# ┌─────────────────────┐
# │ Sudo authentication │
# └─────────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Ask for sudo permissions upfront. 
# Arguments:
#   None.
# Returns:
#   If the sudo authentication fails, return 1. Otherwise,
#   return 0.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ask_for_sudo() {
    # Clear any previous sudo permissions.
    sudo -k
    
    printf "Sudo permissions are required to continue.\n"
    if sudo -v -p "Enter your password: " &> /dev/null; then
        # Update existing `sudo` time stamp until this script has finished.
        while true; do 
            sudo -n true 
            sleep 60
            kill -0 "$$" || exit
        done &> /dev/null &
        printf "Sudo permissions granted.\n\n"
        return 0
    else
        printf "Sudo permissions are required to continue.\n"
        return 1
    fi
}


# ┌────────────┐
# │ Load utils │
# └────────────┘

# - - - - - - - - - - - - - - - - - - - - - - -
# Load utils from GitHub. From now on, the
# `utils.sh` file is available.
# Arguments:
#   None.
# Returns:
#   If the utils file fails to load, return 1.
#   Otherwise, return 0.
# - - - - - - - - - - - - - - - - - - - - - - -
load_utils() {
    local -r utils_file="$DOTFILES_DIR/src/utils.sh"
    local -r utils_url="$GITHUB_REPO_RAW_URL/{{ cookiecutter.default_branch }}/src/utils.sh"
    local tmp_utils=""
    
    if [[ ! -f "$utils_file" ]]; then
        # Dowlnoad utils from GitHub,
        # save them to a temporary file,
        # and source them.
        tmp_utils=$(mktemp)
        curl -fsSL "${utils_url}" > "${tmp_utils}" || return 1
        source "${tmp_utils}"
    else
        source "${utils_file}"
    fi

    return 0
}


# ┌──────────────────┐
# │ Git installation │
# └──────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - - -
# Install Git on Linux.
# Arguments:
#   None.
# Returns:
#   If Git fails to install, return 1. Otherwise,
#   return 0.
# - - - - - - - - - - - - - - - - - - - - - - - -
install_git() {
    if ! command -v git &> /dev/null; then
        ask_confirmation "Do you want to install Git?"
        if [[ $? -eq 0 ]]; then
            run_command "sudo apt-get update" \
                "/dev/null" \
                "Updating 'apt-get' package manager..." \
                "Package manager 'apt-get' updated successfully." \
                "Failed to update package manager 'apt-get'." || exit 1
            run_command "sudo apt-get install -y git" \
                "/dev/null" \
                "Installing Git..." \
                "Git installed successfully." \
                "Failed to install Git." || exit 1
        else
            print_error "Please install Git manually before continuing."
            return 1
        fi
    else
        print_success "Git is already installed."
    fi

    return 0
}

# - - - - - - - - - - - - - - - - - - - - - - - -
# Install Xcode Command Line Tools on macOS.
# Arguments:
#   None.
# Returns:
#   If Xcode Command Line Tools fails to install,
#   return 1. Otherwise, return 0.
# - - - - - - - - - - - - - - - - - - - - - - - -
install_xcode_command_line_tools() {
    if [[ ! -d "/Library/Developer/CommandLineTools" ]]; then
        ask_confirmation "Do you want to install Xcode Command Line Tools?"
        if [[ $? -eq 0 ]]; then
            run_command "xcode-select --install" \
                "/dev/null" \
                "Installing Xcode Command Line Tools..." \
                "Xcode Command Line Tools installed successfully." \
                "Failed to install Xcode Command Line Tools." || return 1
        else
            print_error "Please install Xcode Command Line Tools manually before continuing."
            return 1
        fi
    else
        print_success "Xcode Command Line Tools are already installed."
    fi

    return 0
}


# ┌──────────────────┐
# │ Clone repository │
# └──────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - -
# Clone the repository if needed.
# Arguments:
#   None.
# Returns:
#   If the repository fails to clone, return 1.
#   Otherwise, return 0.
# - - - - - - - - - - - - - - - - - - - - - - -
clone_repository() {
    local -r dotfiles_dir="$DOTFILES_DIR"
    local -r dotfiles_url="$GITHUB_REPO_URL"

    if [[ ! -d "${dotfiles_dir}" ]]; then
        ask_confirmation "Do you want to clone the repository?"
        if [[ $? -eq 0 ]]; then
            run_command "git clone ${dotfiles_url} ${dotfiles_dir}" \
                "/dev/null" \
                "Cloning the repository..." \
                "Repository cloned successfully." \
                "Failed to clone the repository." || return 1
        else
            print_error "Please clone the repository manually before continuing."
            return 1
        fi
    else
        print_success "Repository already cloned."
    fi

    return 0
}


# ┌─────────────────────────┐
# │ Run order file function │
# └─────────────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run the order file of a given OS.
# Arguments:
#   $1: OS name.
# Returns:
#   If the order file fails to run, return 1.
#   Otherwise, return 0.
# - - - - - - - - - - - - - - - - - - - - - - - - - -
run_order_file() {
    local -r os_name="${1}"
    local -r order_file="${os_name}_order.sh"

    source "${order_file}" || return 1
}


# ┌────────────────┐
# │ Setup function │
# └────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup the dotfiles.
# Arguments:
#   None.
# Returns:
#   If the setup fails, return 1. Otherwise, return 0.
# - - - - - - - - - - - - - - - - - - - - - - - - - - -
setup () {
    local -r os_name=$(get_os_name)

    # Check the OS is supported.
    if [[ "${os_name}" == "unknown" ]]; then
        printf "Sorry, unsupported OS.\n"
        exit 1
    fi

    # Ask for sudo permissions
    # and load utils.
    ask_for_sudo || exit 1
    load_utils || exit 1

    # Setup the dotfiles.
    print_header "Setting up the dotfiles for ${os_name}"

    print_subheader "Preparing the machine for setup"
    # Install Git (or Xcode Command Line Tools on macOS)
    # if needed.
    if [[ "${os_name}" == "macos" ]]; then
        install_xcode_command_line_tools || exit 1
    else
        install_git || exit 1
    fi

    # Clone the repository if needed.
    clone_repository || exit 1

    # CD into the dotfiles directory.
    cd "$DOTFILES_DIR" || exit 1
    # Create the 'log' directory.
    mkdir -p "$LOG_DIR_NAME" || exit 1

    print_subheader "Install and bootstrap process"
    # Source the 'install.sh' and 'bootstrap.sh' scripts.
    source "src/install.sh" || exit 1
    source "src/bootstrap.sh" || exit 1

    # Run the order file of the current OS.
    run_order_file "$os_name" || exit 1

    exit 0
}

# Run the setup.
setup
