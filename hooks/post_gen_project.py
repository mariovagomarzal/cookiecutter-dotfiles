from pathlib import Path


# Constants
SYSTEMS = {
    "macos": "{{ cookiecutter.macos_support }}",
    "linux": "{{ cookiecutter.linux_support }}",
}
ORDERS = {
    "install",
    "bootstrap",
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

        # Create the orders file.
        for order in ORDERS:
            Path(f"{order}_order_{system}.txt").touch(exist_ok=True)
