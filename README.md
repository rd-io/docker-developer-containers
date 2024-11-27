# Docker Developer Containers

This project is intended to provide small containers that can be used to learn
 the basics of different languages.

Websites have been decreasing the number of virtual systems that you can use
 to run a simple developer environment. This project can be used to run
  many different languages in small containers with minimal packages.

This project contains Dockerfiles, and executable scripts, to get different
 containerized developer environments securely setup and securely running.

All developer environments are built on top of the Fedora Docker container.

This is also an opinionated project. The expectation of the build files is that
you are using Neovim as your editor, that you have your Neovim configuration
saved as a dotfiles repository using Github. Also, the expectation is that you
will use ssh to clone and push updates to your projects.

Naturally, you can change the build files however you wish.

## The languages available are:
- C
- Go
- Java
- Lua
- Python
- Rust
- TypeScript

## Setup, Variable Initialization

Within each folder for these languages is a Dockerfile. The first three variables
are the same across each file:
- USERNAME: The username you want to use in the container.
- GITHUB_EMAIL: The email address associated with your Github account.
- GITHUB_USERNAME: The username for your Github account.
- DOTFILE_REPO: The name of your dotfile repository (not the full address).

These variables are used for commands such as:

```Dockerfile
ADD https://github.com/$GITHUB_USERNAME/$DOTFILE_REPO.git \
 /home/$USERNAME/.config/

USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME

```

The LABEL "identity" is used with the accompanying execution script to securely
instantiate a Docker container. The label is used to uniquely identify a single
container and attach to it. The container is volatile, once the container is
exited by the user, the container will delete itself, all contents in it
will be gone.

The containers will also bind to the user's folder, `~/.ssh`. This is to
securely allow the user's keys to be accessed by the container, to be used
with git. With the ssh keys not being transferred during the building of
images, there are no records of the keys in the image's history, and the
container is deleted upon exit.

Unique variables for periodic updates will be noted in the language
 sections below.

## Standard User Permissions, Not Root

One of the primary goals of these build files, is to make sure that when the
user attaches to a container, that they are using a user account that does not
have the ability to run commands as root, or super user. This means that `sudo`
commands will not work in the tty.

All material needed to have a basic developer environment is provided in the
container itself. So that the user does not need to edit any other files.

## How to Start a Container

For instructions on how to install Docker, see [Install Docker Engine](https://docs.docker.com/engine/install/)

After Docker Engine is installed:
```bash
git clone https://github.com/rd-io/docker-developer-containers.git

cd docker-developer-containers
```
Using C as the example, open a text editor to the C environment's Dockerfile:
```bash
nvim ./c/Dockerfile
```
Then edit the three empty string variables with your information. Then, after
writing and saving:
```bash
docker build ./c
```

This will build the docker container for the C environment. After
the image is built, it can then be started with the command:
```bash
./c/start-c.sh
```

Each language folder has its own `start` shell script that will find and attach
to a single container.

*If a single developer environment has multiple images built, for example by
running a build command on the `rust` folder twice, then the script to start a
rust container will not work. One of the two rust images must be removed.*

<br>

## Language Environments

### C
The standard compiler, gcc, is here for your introduction to the C language. The
compiler is installed from the DNF package manager.

<br>

---
### Go
Go is installed through downloading a tar archive, extracting the contents, and
adding it's `bin` folder to the `$PATH` variable.

The variable `GO_VERSION` will need to be periodically updated when a new
version of Go is made available.

<br>

---
### Java
The specific version of Java installed is an OpenJDK, Adoptium Temurin. This
version of Java is installed by adding the Adoptium repository to DNF and
installing through the package manager.

For more information about Temurin, click [here](https://adoptium.net/docs/faq/)

The variable `OPENJDK_LTS` will need periodic updates as newer LTS versions
of OpenJDK are released.

The variable `FEDORA_VERSION` will need periodic updates as Fedora releases
new versions every six months. Adoptium usually has the latest version of
Fedora updated in their repos about two to three weeks after the latest
version of Fedora is released.

<br>

---
### Lua
The Lua installation is the most unique. A tar archive file is downloaded, and
extracted. However, the extracted files are source code, not binary executable
files. The Dockerfile then compiles Lua using `make`, followed by installing
the binaries after they are built.

The variable `LUA_VERSION` will need periodic updates as newer versions of
Lua are developed.

<br>

---
### Python
The simplest of the builds, the latest version of Python3 is downloaded directly
from the DNF package manager. No versioning needs to be kept track of.

<br>

---
### Rust
Rust's configuration is also unique. A shell script called `rustup` is
downloaded and run. This is used to install the Rust compiler and the package
manager `cargo`. In order for a Language Server to work with Rust, cargo
needs to initialize in a project folder.

When attaching to the Rust container built from this project, the user will
need to change directory to `./src`. A file will exist named `main.rs`. This
file can then be opened to edit.

<br>

---
### TypeScript
The TypeScript container can be used for both JavaScript and TypeScript. This
configuration is also opinionated. The `Node Version Manager` (NVM) script is
downloaded and run. This will install the latest LTS version of Node during
the build process, as well as NPM. This build file will also download the
PNPM package manager configuration and install it.

The TypeScript configuration has two initializations, one for PNPM initializing
a project, and a second for TypeScript. TypeScript itself is not installed
globally, so to use the TypeScript compiler, commands will need to be run with:
```bash
pnpm tsc ./file.ts
```

The other package installed is `tsx`. This allows a TypeScript file to be
executed without needing to be compiled to JavaScript first. This is run
with the command:
```bash
pnpm tsx ./file.ts
```
<br>

---
### Everything
As the name says, if you really want to, you can have all language environments
added to a single container. Everything is here in one place.

When attaching to `everything`, each language will have its own separate folder
from where the working directory starts. Rust will initiate a project in its
own folder, as well as TypeScript.
