---
show:
    - navigation
---

# Cookiecutter Dotfiles

Cookiecutter Dotfiles is a template for creating your own dotfiles repository
powered by [Cookiecutter](https://github.com/cookiecutter/cookiecutter).

## What is a dotfiles repository?

Many programs (specially the ones related with software development) store
their configuration plain text files under the user's home directory. These
files are called dotfiles because their names start with a dot, `.`, to indicate
most of the Unix operating systems that they are hidden files.

A dotfiles repository is a Git repository that contains all the dotfiles of a
user so that they can be easily copied or linked to their target location.
This repository can be used to keep track of the changes made to the
dotfiles and to share them across different machines using remote Git
repositories like [GitHub](https://github.com).

We can extend the concept of dotfiles to include other basic scripts which can
be used to install and configure the desire software in a new machine. In this
way, we can automate the process of setting up a new machine.

!!! tip "Explore other dotfiles repositories"

    Since many developers use dotfiles repositories, you can find many examples
    across the web. In GitHub, you can find a huge [list of dotfiles repositories](
    https://github.com/search?q=dotfiles&type=repositories) from other users. We also recommend to take a
    look at the "[Awesome dotfiles](https://github.com/webpro/awesome-dotfiles)",
    a curated list of dotfiles repositories and resources.

    Our template was initially inspired by the [Cătălin dotfiles repository](
    https://github.com/alrra/dotfiles), a great example of a dotfiles repository
    that we recommend to check.

## How does this template work?

This template is a Cookiecutter template. Cookiecutter is a command-line utility
made in Python that allows you to create projects from templates by prompting
you for information about your project.

??? info "Cookiecutter resources"

    - [Cookiecutter's documentation](https://cookiecutter.readthedocs.io)
    - [Cookiecutter's GitHub repository](https://github.com/cookiecutter/cookiecutter)

The idea behind this template is to provide a basic structure for a **modular**
dotfiles repository. This means that the repository can be divided into several
modules or packages, each one containing specific install and setup scripts and
files to link. This way, you can easily add new modules to the repository and
keep the repository organized.

Furthermore, the template provides some scripts so that you can easily install
and setup the dotfiles in a new machine with just a single command. For this,
your template repository must be hosted in a remote Git repository like GitHub.

??? info "Supported remote Git repositories"

    For the moment, the template only supports repositories hosted in GitHub.
    If you want to use another remote Git repository, you can contribute to the
    project. Please, refer to the [Contributing](contributing-info.md) section for more
    information.

Refer to the [Usage](usage.md) section to learn how to use this template.
