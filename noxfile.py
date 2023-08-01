import nox

@nox.session(python=["3.7", "3.8", "3.9", "3.10", "3.11"])
def tests(session):
    session.install("pytest", "pytest-cookies")
    session.run("pytest")

@nox.session
def lint(session):
    session.install("ruff")
    session.run("ruff", "check", ".")

@nox.session
def docs(session):
    session.install("mkdocs-material")
    session.run("mkdocs", "build", "--clean")
