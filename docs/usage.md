# Usage

In this section we will explain how to generate a new dotfiles repository
using the template. We will also explain how to add your own dotfiles to
the repository and how to use it for setting up a new system.

## Requirements

For using the template you need to have installed Python 3.7 or higher and
Cookiecutter. Once you have Python installed in your system, you can
install Cookiecutter with `pip`:

```bash
pip install cookiecutter
```

Preferably, you should install Cookiecutter 2.2.0 or higher. However, any
version of Cookiecutter 2.x should work.

For more details about the installation, please refer to the
[Cookiecutter's
documentation](https://cookiecutter.readthedocs.io/en/latest/installation.html).

With Cookiecutter installed, you can create a new dotfiles repository by
running the following command:

=== "General"

    ```bash
    cookiecutter -o <output_dir> gh:mariovagomarzal/cookiecutter-dotfiles
    ```

=== "Recommended"

    ```bash
    cookiecutter -o $HOME/Projects gh:mariovagomarzal/cookiecutter-dotfiles
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
information about your project. These are the options you will be prompted,
what they are for and their default values:

`project_slug`

:   The name of the directory where the repository will be created. The
    default value is `dotfiles`.

`author`

:   Your name. The default value is `Your Name`.

`github_username`

:   Your GitHub username. The default value is `your_github_username`.

`github_repo`

:   The name of the GitHub repository. The default value is `dotfiles`.

`default_branch`

:   The name of the default branch. The setup process will search remote
    files in this branch. The default value is `main`.

`dotfiles_dir`

:   The absolute path to the directory where the dotfiles will be cloned
    and, therefore, where the setup process will search for the dotfiles.
    The default value is `$HOME/Projects/dotfiles`.

`license`

:   The public license of the repository. The available options are `MIT`,
    `Apache-2.0` and `The-Unlicense`. The default value is `MIT`.

`macos_support`

:   Whether to include macOS support or not. The default value is `yes`.

`linux_support`

:   Whether to include Linux support or not. The default value is `yes`.

!!! tip "Using default options"

    When prompted for an option, you can press the `Enter` key to use the
    default value. Also, you can use configuration files to set the default
    values for some options. For more information, please refer to the
    [Cookiecutter's documentation](
    https://cookiecutter.readthedocs.io/en/latest/advanced/user_config.html).

Here's an example of the output of the command:

=== "Default options"

    ``` { .bash .no-copy }
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

=== "macOS"

    ``` { .bash .no-copy }
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
    Choose from 1, 2 [1]: 1
    Select linux_support:
    1 - yes
    2 - no
    Choose from 1, 2 [1]: 2
    ```

=== "Linux"

    ``` { .bash .no-copy }
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
    Choose from 1, 2 [1]: 2
    Select linux_support:
    1 - yes
    2 - no
    Choose from 1, 2 [1]: 1
    ```

!!! info "Supported operating systems"

    As you can see, for the moment only macOS and Linux based systems are
    supported. You can implement your dotfiles to work either on macOS or
    Linux, or both.

    The operating system is automatically detected by the setup process.
    If you want to know which operating system will be used on your machine,
    you can run the following command in your terminal:

    ``` bash
    echo $OSTYPE
    ```

    If the output looks like `"darwin"*`, you are using macOS. If it looks
    like `"linux-gnu"*`, you are using Linux.

## Project structure

When a project is generated, the following directory structure is created
(depending on the OS option you chose):

=== "Default options"

    ``` { .bash .no-copy }
    dotfiles/
    ├── LICENSE
    ├── README.md
    ├── linux_order.sh
    ├── macos_order.sh
    ├── common/
    ├── linux/
    ├── macos/
    └── src/
        ├── bootstrap.sh
        ├── install.sh
        ├── setup.sh
        └── utils.sh
    ```

=== "macOS"

    ``` { .bash .no-copy }
    dotfiles/
    ├── LICENSE
    ├── README.md
    ├── macos_order.sh
    ├── common/
    ├── macos/
    └── src/
        ├── bootstrap.sh
        ├── install.sh
        ├── setup.sh
        └── utils.sh
    ```

=== "Linux"

    ``` { .bash .no-copy }
    dotfiles/
    ├── LICENSE
    ├── README.md
    ├── linux_order.sh
    ├── common/
    ├── linux/
    └── src/
        ├── bootstrap.sh
        ├── install.sh
        ├── setup.sh
        └── utils.sh
    ```

In the next section we will explain how to add files to create your own
dotfiles repository.

## Preparing your dotfiles

This dotfiles repository is based on a modular structure. Each module
consists of a directory inside the `common`, `linux` or `macos` directory.
Inside this custom directory (which we will call _module_ or _package_) you
can add a `install.sh` script, a `setup.sh` script and/or a `symlinks`
directory. We will explain the purpose of each of these files in the
following sections.

If a package has different contents for macOS and Linux, you should add it
either to the `macos` or `linux` directory, respectively. If a package has
the same contents indistinctly for macOS and Linux, you can add it to the
`common` directory. When setting up your dotfiles, the process will search
for the package in the `macos` or `linux` directory first, and if it
doesn't find it, it will search for it in the `common` directory.

### The setup process

For setting up a new machine using this dotfiles repository, you need to
run the `setup.sh` bash script. There are two ways of running this script
that we will discuss later in the "[Using Git and GitHub to manage your
dotfiles](#using-git-and-github-to-manage-your-dotfiles)" section.

The `setup.sh` script will do the following:

1. Ask for sudo permissions, even if the user is already root. This doesn't
    mean that the whole script will be run as root, but since many packages
    require sudo permissions to be installed, it is better to ask for them
    at the beginning. The password will be stored and used if needed, so
    you don't need to enter it again.
2. Prepare the system for the setup process. In macOS systems, this means
    installing the Xcode Command Line Tools if they are not installed. In
    Linux systems, this means installing the `git` package if it is not
    installed. In both cases, the script will also clone the dotfiles if it
    is not found in the specified directory (by default,
    `$HOME/Projects/dotfiles`).
3. Run the order script (`macos_order.sh` or `linux_order.sh`) to get the
    order in which the packages have to be installed and/or configured. We
    will explain how to edit this file and what to put in the packages in
    the next sections.

!!! warning "Sudo permissions"

    Do not run the `setup.sh` script with `sudo`. The script will ask for
    sudo permissions at the beginning and will use them when needed. That is
    because some packages like `brew` do not allow to be run as root, but, in
    some steps, it may ocasionaly need sudo permissions.

Let's see how to add the files and what to put in them. For that, let's
assume that we want to add a package called `my_package` to our dotfiles
repository that works on both macOS and Linux. So, we will have to create a
directory called `my_package` inside the `common` directory.

!!! info "Not all files are required"

    Note that not all the packages need to have all the files. For example, if you
    don't need to create symlinks, you don't need to create a `symlink` directory.
    We will talk about how to skip the execution of the scripts in the next sections.

### The `install.sh` script

With the `my_package` directory created, we can add the `install.sh` bash
script. This script should contain only the necessary commands to install
the package (or, optionally, to check first if the package is already
installed).

!!! warning "Make sure the script is a bash script"

    The `install.sh` script must be a bash script. Add the following line at the
    beginning of the script to make sure it is executed with bash:

    ``` bash
    #!/bin/bash
    ```

Make sure you return an exit status of `0` if the installation was
successful, or a different exit status if the installation failed. This is
important to know if some steps of the setup process failed.

When a `install.sh` script is executed, all the output produced is written
to a log file inside the `logs` directory. The name of the log file will be
of the form `<my_package>_install.log`.

Let's see a general example of a `install.sh` script:

???+ example "General structure of an `install.sh` script"

    ``` bash
    #!/bin/bash

    if ! command -v my_package_command &> /dev/null; then
        # Command to install my_package here
        return $? # (1)!
    else
        return 0
    fi
    ```

    1. The `$?` variable contains the exit status of the last command executed. In this
        case, it will return the exit status of the command to install `my_package`.

    If you include `echo` or `printf` commands in your script, note that the output is not
    going to be shown in the terminal. Instead, it will be written to a log file.

    We recommend to keep the `install.sh` scripts as simple as possible. Other operations
    related to the package should be done in the `setup.sh` script that we will discuss next.

### The `setup.sh` script

The `setup.sh` script is similar to the `install.sh` script. This script
should contain the necessary commands to configure the package after it has
been installed. For example, you can use this script to install plugins for
a specific package or to configure the package to your needs.

Do not use this script to link files to the system. This should be done in
the `symlink` directory, as we will see in the next section.

Similarly to the `install.sh` script, the `setup.sh` script should return
an exit status of `0` if the setup was successful, or a different exit
status if the setup failed. The output of this script is also written to a
log file inside the `logs` directory. The name of the log file will be of
the form `<my_package>_setup.log`.

### The `symlink` directory

The `symlink` directory contains the files that have to be linked to the
system. This process is done just after the `setup.sh` script of the
package is executed. The files in this folder will be linked to the same
path in the system relative to the `$HOME` directory. For example, if you
have a file calle `.my_file` in the `symlinks` directory, it will be linked
to `$HOME/.my_file`.

But there's more. You can also create directories inside the `symlink`
directory and put files inside them. This files will be linked to the same
path in the system relative to the `$HOME` directory, but inside the
directory you created. Intermediately directories will be created if they
don't exist.

Let's see a brief example:

???+ example "Example of the `symlink` directory"

    Suppose you have the following directory structure under the `my_package` directory:

    ``` { .no-copy }
    symlink/
    ├── .my_file
    └── my_directory
        └── my_other_file
    ```

    Let's compare the `$HOME` directory before and after the symlinks are created:

    === "Before"

        ``` { .no-copy }
        $HOME/
        ├── .my_file
        └── ...
        ```

    === "After"

        ``` { .no-copy }
        $HOME/
        ├── .my_file -> /path/to/dotfiles/my_package/symlink/.my_file
        ├── my_directory
        │    └── my_other_file -> /path/to/dotfiles/my_package/symlink/my_directory/my_other_file
        └── ...
        ```

### The order files

Once we have created all the packages we want to add to our dotfiles
repository, we have to tell the setup process in which order they have to
be installed and configured. For that, we have to edit the `macos_order.sh`
and/or `linux_order.sh` files. The syntax of these files is simple. Each
line contains the _operation_ we want to perform and the _package_ we want
to perform it on. The _operation_ can be either `install_package`,
`setup_package` or `symlink_package`. The _package_ must be a directory
inside the `common`, `macos` or `linux` directory.

Let's see an example of the order files:

???+ example "Example of the order files"

    Let's suppose we have created a full `my_package`. Then, we can
    add the following lines to the `macos_order.sh` and/or `linux_order.sh` files:

    === "macOS"

        ``` { .no-copy }
        #!bin/bash
        # Order file for a macOS setup

        install_package my_package
        setup_package my_package
        symlink_package my_package
        ```

    === "Linux"

        ``` { .no-copy }
        #!bin/bash
        # Order file for a Linux setup

        install_package my_package
        setup_package my_package
        symlink_package my_package
        ```

    This will will run the `install.sh` script of `my_package`, then the `setup.sh` script
    and finally it will create the symlinks. This is natural order of the setup process. However,
    you can skip any of these steps if you want or even mix operations of different packages.

## Using Git and GitHub to manage your dotfiles

The idea of the template is to use Git and GitHub to manage your dotfiles.
For that, you will have to initialize a Git repository in the root
directory of your dotfiles repository. Simply run the following command:

``` bash
git init
```

A `.gitignore` file is already provided in the template. This file ignores
the `logs` directory. Also a `README.md` file is provided with some basic
information about the repository. A `LICENSE` file is also provided with
the license you chose when creating the repository.

Now you can add the files you want to track to the repository and commit
them. Make sure you commit "stable" versions to the branch you specified as
default when creating the repository.

!!! tip Versioning

    We recommend to use [Calendar Versioning](https://calver.org/) to version your
    dotfiles. This is a versioning scheme that uses the date as the version number.
    Tag your commits on the default branch with this version numbers.

To share your dotfiles with other people and to be able to install them in
other machines, you will have to push your repository to GitHub. For that,
you will have to create a remote repository in GitHub and push your local
repository to it. Make sure the user and the repository name are the same
as the ones you specified when creating the repository.

``` bash
git remote add origin https://github.com/<github_username>/<github_repo>.git
git push -u origin <default_branch>
```

??? tip "Git and GitHub documentation"

    If you are not familiar with Git and GitHub, you can check the following links:

    * [Git documentation](https://git-scm.com/doc)
    * [GitHub documentation](https://docs.github.com/en)

To setup your new machine using your dotfiles, you can manually clone the
repository in the path you specified when creating the repository (i.e.
`dotfiles_dir`). Then, you can run the `setup.sh` script with the following
command:

``` bash
bash -c <dotfiles_dir>/src/setup.sh
```

However, this process can be skipped if you use the following command:

``` bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/<github_username>/<github_repo>/<default_branch>/src/setup.sh)"
```

!!! info "Public repository"

    For the moment, the template is designed to work with public repositories. If you
    want to use a private repository, you can [contribute](contributing-info.md) to the project.
