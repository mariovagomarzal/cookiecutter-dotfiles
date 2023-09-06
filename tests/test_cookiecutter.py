"""Test if the cookiecutter template renders correctly."""
import pytest


@pytest.fixture
def extra_context():
    return {
        "project_slug": "dotfiles-test",
        "license": "Apache-2.0",
        "macos_support": "yes",
        "linux_support": "no",
    }


# Bake without extra context
def test_cookiecutter_no_context(cookies):
    result = cookies.bake()
    path = result.project_path

    # No errors.
    assert result.exit_code == 0
    assert result.exception is None

    # Check if the project was created correctly.
    assert path.is_dir()
    assert path.name == "dotfiles"

    # Check some contents.
    assert (path / "README.md").is_file()
    assert "Your Name" in (path / "README.md").read_text()

    assert (path / "LICENSE").is_file()
    assert "MIT" in (path / "LICENSE").read_text()

    assert (path / "common").is_dir()
    for system in ["macos", "linux"]:
        assert (path / system).is_dir()
        assert (path / f"{system}_order.sh").is_file()

# Bake with extra context
def test_cookiecutter_context(cookies, extra_context):
    result = cookies.bake(extra_context=extra_context)
    path = result.project_path

    # No errors.
    assert result.exit_code == 0
    assert result.exception is None

    # Check if the project was created correctly.
    assert path.is_dir()
    assert path.name == "dotfiles-test"

    # Check some contents.
    assert (path / "README.md").is_file()
    assert "Your Name" in (path / "README.md").read_text()

    assert (path / "LICENSE").is_file()
    assert "Apache" in (path / "LICENSE").read_text()

    assert (path / "common").is_dir()

    # Check if the contents exist for macos.
    assert (path / "macos").is_dir()
    assert (path / "macos_order.sh").is_file()

    # Check if the contents exist for linux
    # (should not exist because linux_support is set to "no").
    assert not (path / "linux").is_dir()
    assert not (path / "linux_order.sh").is_file()
