# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change.

Please note we have a code of conduct, please follow it in all your interactions with the project.

## Find projects to work on

Projects that are open for contributions can be found on the [issue tab](https://github.com/ChanderG/tmux-notify/issues) and will be labelled with the `help wanted` tag. Projects with the `beginner` label are ideal for beginning programmers. If you find a project that spikes your interest, leave a comment. We will then assign you to this project. After you did one project, you will be added as a contributor after which you can attach yourself to projects to work on.

## Forking process

1.  Fork the [repository](https://github.com/ChanderG/tmux-notify)
2.  Create your feature branch `git checkout -b feature/fooBar`
3.  Commit your changes `git commit -am 'Add some fooBar'`
4.  Push to the branch `git push origin feature/fooBar`
5.  Create a new Pull Request

## Pull Request Process

1.  Ensure any install or build dependencies are removed before the end of the layer when doing a build.
2.  Update the README.md with details of changes to the interface, this includes new environment variables, exposed ports, useful file locations and container parameters.
3.  Increase the version numbers in any examples files and the README.md to the new version that this Pull Request would represent. The versioning scheme we use is [SemVer](http://semver.org/). To prevent errors you are recommended to use [the bumpversion tool](https://github.com/peritus/bumpversion) (Instructions cincluded below).
4.  Update the `CHANGELOG.md` using the [auto-changelog tool](https://github.com/CookPete/auto-changelog) (Instructions included below).
5.  You may merge the Pull Request in once you have the sign-off of two other developers, or if you do not have permission to do that, you may request the second reviewer to merge it for you.

### Bumpversion instructions

The bumpversion tool by [@Peritus](https://github.com/peritus) is a small command line tool to simplify releasing software by updating all version strings in your source code by the correct increment. It also automatically creates commits and tags. The bumpversion tool can be used as follows:

1.  Install the bumpversion tool in your python environment using the `pip install --upgrade bumpversion` command.
2.  Go to the main repository folder.
3.  Commit any staged changes.
4.  Run the `bumpversion patch` command to increase the patch version (Example: v1.0.0 to v1.0.1).
5.  Push the tags to the github repository using the `git push --tags` command.

**NOTE:** If you add versioning to a file you have to add it to the `.bumpversion.cfg` file for it to be updated automatically by the bumpversion tool. More information on how to do this can be found on the [bumpversion documentation](https://github.com/CookPete/auto-changelog).

### Auto-changelog instructions

The auto-changelog tool by [@CookPete](https://github.com/CookPete/) is a small command line tool for generating a changelog from git tags and commit history. This tool can be used as follows:

1.  Install NodeJS according to [the official NodeJS documentation](https://www.npmjs.com/get-npm).
2.  Install the auto-changelog tool by running the `npm install -g auto-changelog` command.
3.  Go to the main repositroy folder.
4.  Commit any stages changes.
5.  Bump the version using the bumpversion tool.
6.  Run the `auto-changelog` command.
7.  Commit the changes using `git commit -m "Updated CHANGELOG.md"`.
8.  You can now push your changes to github and submit a pull request.

## Code of Conduct

### Our Pledge

In the interest of fostering an open and welcoming environment, we as contributors and maintainers pledge to making participation in our project and our community a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

Examples of behaviour that contributes to creating a positive environment include:

-   Using welcoming and inclusive language
-   Being respectful of differing viewpoints and experiences
-   Gracefully accepting constructive criticism
-   Focusing on what is best for the community
-   Showing empathy towards other community members

Examples of unacceptable behaviour by participants include:

-   The use of sexualized language or imagery and unwelcome sexual attention or advances
-   Trolling, insulting/derogatory comments, and personal or political attacks
-   Public or private harassment
-   Publishing others' private information, such as a physical or electronic address, without explicit permission
-   Other conduct which could reasonably be considered inappropriate in a professional setting

### Our Responsibilities

Project maintainers are responsible for clarifying the standards of acceptable behaviour and are expected to take appropriate and fair corrective action in response to any instances of unacceptable behaviour.

Project maintainers have the right and responsibility to remove, edit, or reject comments, commits, code, wiki edits, issues, and other contributions that are not aligned to this Code of Conduct, or to ban temporarily or permanently any contributor for other behaviours that they deem inappropriate, threatening, offensive, or harmful.

### Scope

This Code of Conduct applies both within project spaces and in public spaces when an individual is representing the project or its community. Examples of representing a project or community include using an official project e-mail address posting via an official social media account, or acting as an appointed representative at an online or offline event. Representation of a project may be further defined and clarified by project maintainers.

### Attribution

This Code of Conduct is adapted from the [Contributor Covenant][homepage], version 1.4, available at [http://contributor-covenant.org/version/1/4][version]

[homepage]: http://contributor-covenant.org

[version]: http://contributor-covenant.org/version/1/4/
