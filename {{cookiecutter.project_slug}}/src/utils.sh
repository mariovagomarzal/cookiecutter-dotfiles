#!/bin/bash
#
# Helper functions for the dotfiles scripts


# ┌──────────────────┐
# │ Formatted output │
# └──────────────────┘

# Color codes
export BLACK="0"
export RED="1"
export GREEN="2"
export YELLOW="3"
export BLUE="4"
export MAGENTA="5"

# Tab characters
export SMALL_TAB="  "
export LARGE_TAB="    "

# - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Print a message with a given color.
# Arguments:
#   $1: Message to display.
#   $2: Color code.
# Returns:
#   None.
# - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_color() {
    printf "%b" \
        "$(tput setaf "$2" 2> /dev/null)" \
        "$1" \
        "$(tput sgr0 2> /dev/null)"
}

print_in_red() {
    print_in_color "$1" "$RED"
}

print_in_green() {
    print_in_color "$1" "$GREEN"
}

print_in_yellow() {
    print_in_color "$1" "$YELLOW"
}

print_in_blue() {
    print_in_color "$1" "$BLUE"
}

print_in_magenta() {
    print_in_color "$1" "$MAGENTA"
}

# Specialized print functions
print_header() {
    # Print in bold too.
    tput bold 2> /dev/null
    print_in_magenta "\n• $1\n\n"
}

print_subheader() {
    print_in_magenta "\n${SMALL_TAB}$1\n\n"
}

print_question() {
    # Question does not end with a newline
    # so that the user's input is on the same line.
    print_in_blue "${LARGE_TAB}[?] $1"
}

print_info() {
    print_in_blue "${LARGE_TAB}[i] $1\n"
}

print_success() {
    print_in_green "${LARGE_TAB}[✓] $1\n"
}

print_error() {
    print_in_red "${LARGE_TAB}[✗] $1\n"
}

print_warning() {
    print_in_yellow "${LARGE_TAB}[!] $1\n"
}


# ┌────────────────┐
# │ User prompting │
# └────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - -
# Ask the user a yes/no question.
# Arguments:
#   $1: Question to ask.
# Returns:
#   0 if the user answered yes, 1 otherwise.
# - - - - - - - - - - - - - - - - - - - - - - -
ask_confirmation() {
    print_question "${1} [Y/n] "
    read -r -n 1
    printf "\n"

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    fi
    return 1
}


# ┌──────────────────┐
# │ Special commands │
# └──────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - -
# Show a spinner while a command is running.
# Arguments:
#   $1: Pid of the running command.
#   $2: Message to display.
# Returns:
#   None.
# - - - - - - - - - - - - - - - - - - - - - - -
show_spinner() {
    local -r pid="${1}"
    local -r message="${2}"

    local -r spin="-\|/"
    local i=0
    local blank=""
    
    # Print the message until the command completes.
    while kill -0 "${pid}" &> /dev/null; do
        printf "\r${LARGE_TAB}[%c] %s" \
            "${spin:i++%${#spin}:1}" \
            "${message}"
        sleep 0.1
    done

    # Create a blank space over the spinner text
    # so that the next line overwrites it.
    blank="$(printf "%*s" $(( ${#message} + 8 )))"
    printf "\r${blank}\r"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run a command and show a spinnner while it's running.
# Then, show a success or failure message.
# Arguments:
#   $1: Command to run.
#   $2: Log file to write the command's output to.
#   $2: Message to display while the command is running.
#   $3: Message to display on success.
#   $4: Message to display on failure.
# Returns:
#   Exit code of the command.
# - - - - - - - - - - - - - - - - - - - - - - - - - - -
run_command() {
    local -r command="${1}"
    local -r log_file="${2}"
    local -r message="${3}"
    local -r success_message="${4}"
    local -r failure_message="${5}"

    local pid=""
    local exit_code=0
    
    # Run the command in the background and store its pid.
    # Then, show a spinner while the command is running.
    # Append the command's output to the log file.
    eval "${command}" \
        >> "${log_file}" 2>&1 \
        & pid=$!

    show_spinner "${pid}" "${message}"

    # Wait for the command to no longer be executing
    # and then get its exit code.
    wait "${pid}" &> /dev/null
    exit_code=$?

    # Show the success or failure message.
    if [ $exit_code -ne 0 ]; then
        print_error "${failure_message}"
    else
        print_success "${success_message}"
    fi

    return $exit_code
}


# ┌───────────────────────────────────────────┐
# │ Auxiliary install and bootstrap functions │
# └───────────────────────────────────────────┘

# - - - - - - - - - - - - - - - - - - - - - - - - - -
# Loop through the lines of a file and run a command
# using each line as a an argument.
# Arguments:
#   $1: Command to run.
#   $2: File to read lines from.
#   $3: OS name.
# Returns:
#   If one of the commands fails, the function will
#   return the 1. Otherwise, it will return 0.
# - - - - - - - - - - - - - - - - - - - - - - - - - -
run_command_with_loop() {
    local -r command="${1}"
    local -r file="${2}"
    local -r os_name="${3}"

    local exit_code=0

    while read line; do
        eval "${command} ${line} ${os_name}" || exit_code=1
    done < "${file}"

    return $exit_code
}
