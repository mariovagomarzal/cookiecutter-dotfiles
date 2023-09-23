import nox


def install_requirements(session, file="requirements.txt"):
    session.install("-r", file)


@nox.session
def tests(session):
    install_requirements(session)
    session.run("pytest")

@nox.session
def lint(session):
    install_requirements(session)
    session.run("ruff", "check", ".")

@nox.session
def docs(session):
    install_requirements(session)
    session.run("mkdocs", "build", "--clean")
