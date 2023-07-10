"""Test if the cookiecutter template renders correctly."""

def test_cookiecutter(cookies):
    result = cookies.bake()

    assert result.exit_code == 0
    assert result.exception is None

    assert result.project_path.name == "dotfiles"
    assert result.project_path.is_dir()
