from pathlib import Path


# Constants
SYSTEMS = {
    "macos": "{{ cookiecutter.macos_support }}",
    "linux": "{{ cookiecutter.linux_support }}",
}


# Functions
def answer_to_bool(answer: str):
    return answer.lower() == "yes"


# Main script
# Create the 'common' directory.
Path("common").mkdir(exist_ok=True)

# Create system-specific directories and its
# order files.
for system, is_supported in SYSTEMS.items():
    if answer_to_bool(is_supported):
        # Create the dir.
        Path(system).mkdir(exist_ok=True)

        # Create the order file.
        Path(f"{system}_order.sh").touch(exist_ok=True)
