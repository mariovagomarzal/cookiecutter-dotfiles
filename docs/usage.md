# Usage

In this section we will explain how to generate a new dotfiles repository
using the template. We will also explain how to add your own dotfiles to
the repository and how to use it for setting up a new system.

## Requirements

For using the template you need to have installed Python 3.7 or higher
and Cookiecutter. Once you have Python installed in your system, you can
install Cookiecutter with `pip`:

```bash
pip install cookiecutter
```

For more details about the installation, please refer to the
[Cookiecutter's documentation](https://cookiecutter.readthedocs.io/en/latest/installation.html).

With Cookiecutter installed, you can create a new dotfiles repository by
running the following command:

```bash
cookiecutter -o <output_dir> gh:mariovagomarzal/cookiecutter-dotfiles
```

Replace `<output_dir>` with the path where you want to create the
repository. If you don't specify the output directory, Cookiecutter will
create the repository in the current working directory.

!!! tip "Dotfiles repository location"

    We recommend generating the repository in a `Projects` directory
    under your home directory. Make sure, in any case, that you type
    the right paths when prompted by Cookiecutter.

## Project generation options

When you run the command above, Cookiecutter will ask you for some
information about your project. These are the options you will be prompted, what they are for and their default values:

- `project_slug`: The name of the directory where the repository will be
    created. The default value is `dotfiles`.
- `author`: Your name. The default value is `Your Name`.
- `github_username`: Your GitHub username. The default value is `your_github_username`.
- `github_repo`: The name of the GitHub repository. The default value is
    `dotfiles`.
- `default_branch`: The name of the default branch. The setup process will
    search remote files in this branch. The default value is `main`.
- `dotfiles_dir`: The absolute path to the directory where the dotfiles
    will be cloned and, therefore, where the setup process will search for
    the dotfiles. The default value is `$HOME/Projects/dotfiles`.
- `license`: The public license of the repository. The available options
    are `MIT`, `Apache-2.0` and `The-Unlicense`. The default value is `MIT`.
- `macos_support`: Whether to include macOS support or not.
    The default value is `yes`.
- `linux_support`: Whether to include Linux support or not.
    The default value is `yes`.

!!! tip "Using default options"

    When prompted for an option, you can press the `Enter` key to use the
    default value. Also, you can use configuration files to set the default
    values for some options. For more information, please refer to the
    [Cookiecutter's documentation](
    https://cookiecutter.readthedocs.io/en/latest/advanced/user_config.html).

Here's an example of the output of the command:

```bash
project_slug [dotfiles]:
author [Your Name]: John Doe
github_username [your_github_username]: johndoe
github_repo [dotfiles]: ↩
default_branch [main]: ↩
dotfiles_dir [$HOME/Projects/dotfiles]: ↩
Select license:
1 - MIT
2 - Apache-2.0
3 - The-Unlicense
Choose from 1, 2, 3 [1]: ↩
Select macos_support:
1 - yes
2 - no
Choose from 1, 2 [1]: ↩
Select linux_support:
1 - yes
2 - no
Choose from 1, 2 [1]: ↩
```

## Project structure

With the default options, Cookiecutter will create a new directory with the following structure:

```
dotfiles/
├── LICENSE
├── README.md
├── bootstrap_order_linux.txt
├── bootstrap_order_macos.txt
├── install_order_linux.txt
├── install_order_macos.txt
├── common/
├── linux/
├── macos/
└── src/
    ├── bootstrap.sh
    ├── install.sh
    ├── setup.sh
    └── utils.sh
```

In the next section we will explain how to add files to
create your own dotfiles repository.

## Preparing your dotfiles

This dotfiles repository is based on a modular structure. Each module consists of a directory inside the `common`, `linux` or `macos` directory. Inside this custom directory (which we will call _module_ or _package_) you can add a `install.sh` script, a `bootstrap.sh` script and/or a `symlinks` directory. We will explain the purpose of each of these files in the following sections.

If a package has different contents for macOS and Linux, you should add it either to the `macos` or `linux` directory, respectively. If a package has the same contents indistinctly for macOS and Linux, you can add it to the `common` directory. When setting up a new system, the process will search for the package in the `macos` or `linux` directory first, and if it doesn't find it, it will search for it in the `common` directory.

### The setup process

For setting up a new machine using this dotfiles repository, you need to run the `setup.sh` bash script. There are two ways of running this script that we will discuss later in the [Using Git and GitHub to manage your dotfiles](#using-git-and-github-to-manage-your-dotfiles) section.

The `setup.sh` script will do the following:

1. Prepare the system for the setup process. In macOS systems, this means
    installing the Xcode Command Line Tools if they are not installed. In
    Linux systems, this means installing the `git` package if it is not
    installed. In both cases, the script will also clone the dotfiles
    if it is not found in the specified directory (by default, `$HOME/Projects/dotfiles`).
2. Search for the `intall.sh` scripts of the respective packages. Then it run
    them, reporting the result of each installation and writing the logs to specific
    files under a `logs` directory inside the dotfiles directory.
3. A similar process is done for the `setup.sh` scripts. The difference is that,
    the apart from running the scripts, it will also link the files in the `symlinks`
    directory to the right place in the system (we will explain how to do this in
    the next sections).

Let's see how to add the files and what to put in them.

### The `install.sh` script

### The `bootstrap.sh` script

### The `symlinks` directory

## Using Git and GitHub to manage your dotfiles
