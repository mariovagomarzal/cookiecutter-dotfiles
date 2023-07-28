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

# - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ask for sudo permissions upfront. 
# Arguments:
#   None.
# Returns:
#   None. Exit with error if `sudo` validation fails.
# - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
    else
        printf "Sudo permissions are required to continue.\n"
        exit 1
    fi
}


# ┌────────────┐
# │ Load utils │
# └────────────┘

# - - - - - - - - - - - - - - - - - - - - - -
# Load utils from GitHub. From now on, the
# `utils.sh` file is available.
# Arguments:
#   None.
# Returns:
#   None. Exit with error if `curl` fails.
# - - - - - - - - - - - - - - - - - - - - - -
load_utils() {
    local -r utils_file="$DOTFILES_DIR/src/utils.sh"
    local -r utils_url="$GITHUB_REPO_RAW_URL/{{ cookiecutter.default_branch }}/src/utils.sh"
    local tmp_utils=""
    
    if [[ ! -f "$utils_file" ]]; then
        # Dowlnoad utils from GitHub,
        # save them to a temporary file,
        # and source them.
        tmp_utils=$(mktemp)
        curl -fsSL "$utils_url" > "$tmp_utils" || exit 1
        source "$tmp_utils"
    else
        source "$utils_file"
    fi
}


# ┌──────────────────┐
# │ Git installation │
# └──────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - - - -
# Install Git on Linux.
# Arguments:
#   None.
# Returns:
#   None. Exit with error if installation fails.
# - - - - - - - - - - - - - - - - - - - - - - - - -
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
            exit 1
        fi
    else
        print_success "Git is already installed."
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
# Install Xcode Command Line Tools on macOS.
# Arguments:
#   None.
# Returns:
#   None. Exit with error if installation fails.
# - - - - - - - - - - - - - - - - - - - - - - - -
install_xcode_command_line_tools() {
    if [[ ! -d "/Library/Developer/CommandLineTools" ]]; then
        ask_confirmation "Do you want to install Xcode Command Line Tools?"
        if [[ $? -eq 0 ]]; then
            run_command "xcode-select --install" \
                "/dev/null" \
                "Installing Xcode Command Line Tools..." \
                "Xcode Command Line Tools installed successfully." \
                "Failed to install Xcode Command Line Tools." || exit 1
        else
            print_error "Please install Xcode Command Line Tools manually before continuing."
            exit 1
        fi
    else
        print_success "Xcode Command Line Tools are already installed."
    fi
}


# ┌──────────────────┐
# │ Clone repository │
# └──────────────────┘

# - - - - - - - - - - - - - - - - - - - - -
# Clone the repository if needed.
# Arguments:
#   None.
# Returns:
#   None. Exit with error if `git` fails.
# - - - - - - - - - - - - - - - - - - - - -
clone_repository() {
    local -r dotfiles_dir="$DOTFILES_DIR"
    local -r dotfiles_url="$GITHUB_REPO_URL"

    if [[ ! -d "$dotfiles_dir" ]]; then
        ask_confirmation "Do you want to clone the repository?"
        if [[ $? -eq 0 ]]; then
            run_command "git clone $dotfiles_url $dotfiles_dir" \
                "/dev/null" \
                "Cloning the repository..." \
                "Repository cloned successfully." \
                "Failed to clone the repository." || exit 1
        else
            print_error "Please clone the repository manually before continuing."
            exit 1
        fi
    else
        print_success "Repository already cloned."
    fi
}


# ┌────────────────┐
# │ Setup function │
# └────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup the dotfiles.
# Arguments:
#   None.
# Returns:
#   None. Exit with error if something goes wrong.
# - - - - - - - - - - - - - - - - - - - - - - - - - -
setup () {
    local -r os_name=$(get_os_name)

    local exit_code_installs=0
    local bootstrap_packages=""
    local exit_code_bootstrap=0
    local exit_code=0

    # Check the OS is supported.
    if [[ "$os_name" == "unknown" ]]; then
        printf "Sorry, unsupported OS.\n"
        exit 1
    fi

    # Ask for sudo permissions
    # and load utils.
    ask_for_sudo || exit 1
    load_utils || exit 1

    # Setup the dotfiles.
    print_header "Setting up the dotfiles for $os_name"

    # Install Git (or Xcode Command Line Tools on macOS)
    # if needed.
    if [[ "$os_name" == "macos" ]]; then
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

    # Install the packages.
    print_subheader "Installing packages (ant others)"
    ask_confirmation "Do you want to install packages?"
    if [[ $? -eq 0 ]]; then
        source "src/install.sh"
        install_packages "$os_name" || exit_code_installs=1
    else
        print_info "Skipping installations."
    fi

    # Bootstrap the dotfiles.
    print_subheader "Bootstrapping packages (and others)"
    # Check if exit_code_installs is different from 0.
    if [[ $exit_code_installs -ne 0 ]]; then
        print_info "Some of the packages failed to install"
        ask_confirmation "Do you want to bootstrap packages anyway?"
        bootstrap_packages=$?
    else
        ask_confirmation "Do you want to bootstrap packages?"
        bootstrap_packages=$?
    fi

    if [[ $bootstrap_packages -eq 0 ]]; then
        source "src/bootstrap.sh"
        bootstrap_packages "$os_name" || exit_code_bootstrap=1
    else
        print_info "Skipping bootstrap."
    fi
    
    # Summarize the setup.
    print_header "Setup summary"
    if [[ $exit_code_installs -eq 0 ]]; then
        print_success "Packages installed successfully."
    else
        print_error "Some of the packages failed to install."
        exit_code=1
    fi

    if [[ $exit_code_bootstrap -eq 0 ]]; then
        print_success "Packages bootstrapped successfully."
    else
        print_error "Some of the packages failed to bootstrap."
        exit_code=1
    fi

    exit $exit_code
}

# Run the setup.
setup
