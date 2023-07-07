import nox

@nox.session
def tests(session):
    session.install("pytest", "pytest-cookies")
    session.run("pytest")

@nox.session
def lint(session):
    session.install("ruff")
    session.run("ruff", "check", ".")
