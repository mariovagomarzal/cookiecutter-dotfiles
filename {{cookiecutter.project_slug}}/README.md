# [{{ cookiecutter.author }}](https://github.com/{{ cookiecutter.github_username }})'s dotfiles

This dotfiles repository was created using the [cookiecutter-dotfiles
v0.2.2](https://github.com/mariovagomarzal/cookiecutter-dotfiles/releases/tag/0.2.2)
template.

## Setup
To setup the dotfiles, run the following command in the terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/{{ cookiecutter.github_username }}/{{ cookiecutter.github_repo }}/{{ cookiecutter.default_branch }}/src/setup.sh)"
```

The setup process will:

* Download `git` (or Xcode Command Line Tools if on macOS) if not already
  installed.
* Clone the dotfiles repo to `{{ cookiecutter.dotfiles_dir }}` if not
  already cloned.
* Run the order script specific to the current OS.

## License
This project is licensed by [{{ cookiecutter.author
}}](https://github.com/{{ cookiecutter.github_username }}) under the terms
of the [{{ cookiecutter.license }} license](/LICENSE).
