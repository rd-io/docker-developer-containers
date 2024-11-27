FROM fedora:latest

# User editable variabled
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""

# Constants, do not change
ENV USERNAME="all-container"
ENV LANGUAGE="everything"
LABEL identity="rd-all"

# Versions of all languages not in DNF
ENV GO_VERSION="1.23.3"

ENV OPENJDK_LTS="21"
ENV FEDORA_VERSION="41"

ENV LUA_VERSION="5.4.7"

ENV NVM_VERSION="v0.40.1"

# Install base system dependencies
#  also installs minimum requirements for C and Python
RUN echo 'fastestmirror=True' >> /etc/dnf/dnf.conf

RUN dnf upgrade -y && dnf install -y \
  git \
  nano \
  openssh-clients \
  ripgrep \
  gcc \
  unzip \
  make \
  python3 \
  python3-pip \
  && dnf autoremove -y


# Non-admin account & Neovim setup
RUN useradd -m -d /home/$USERNAME $USERNAME
RUN mkdir -m 0755 /home/$USERNAME/.ssh

# Creating all language folders
RUN mkdir /home/$USERNAME/$LANGUAGE
RUN mkdir /home/$USERNAME/$LANGUAGE/c
RUN mkdir /home/$USERNAME/$LANGUAGE/go
RUN mkdir /home/$USERNAME/$LANGUAGE/java
RUN mkdir /home/$USERNAME/$LANGUAGE/lua
RUN mkdir /home/$USERNAME/$LANGUAGE/python
RUN mkdir /home/$USERNAME/$LANGUAGE/rust
RUN mkdir /home/$USERNAME/$LANGUAGE/typescript


# Installing Neovim
ADD "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz" /opt/
RUN tar -xf /opt/nvim-linux64.tar.gz -C /opt/
RUN rm /opt/nvim-linux64.tar.gz

ENV PATH="$PATH:/opt/nvim-linux64/bin"

# Adding dotfile Neovim configuration
RUN mkdir -p /home/$USERNAME/.config/
ADD https://github.com/$GITHUB_USERNAME/$DOTFILE_REPO.git /home/$USERNAME/.config/

# Rust installation script
ADD https://sh.rustup.rs /home/$USERNAME/sh.rustup.rs

# Install Go
ADD "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz" /opt/
RUN tar -xf "/opt/go$GO_VERSION.linux-amd64.tar.gz" -C /opt/
RUN rm "/opt/go$GO_VERSION.linux-amd64.tar.gz"
ENV PATH="$PATH:/opt/go/bin"


# Adding Temurin JDK repo and installing
RUN touch /etc/yum.repos.d/adoptium.repo
RUN echo "[ADOPTIUM]" >> /etc/yum.repos.d/adoptium.repo && \
    echo "name=Adoptium" >> /etc/yum.repos.d/adoptium.repo && \
    echo "baseurl=https://packages.adoptium.net/artifactory/rpm/fedora/$FEDORA_VERSION/\$basearch" >> /etc/yum.repos.d/adoptium.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/adoptium.repo && \
    echo "gpgcheck=1" >> /etc/yum.repos.d/adoptium.repo && \
    echo "gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public" >> /etc/yum.repos.d/adoptium.repo 

RUN dnf update && dnf install temurin-$OPENJDK_LTS-jdk -y


# Installing Lua compiler and interpreter, from source
ADD "https://www.lua.org/ftp/lua-$LUA_VERSION.tar.gz" /opt/
RUN tar -xf /opt/lua-$LUA_VERSION.tar.gz -C /opt/
WORKDIR /opt/lua-$LUA_VERSION/
RUN make
RUN make install
WORKDIR /
RUN rm -r /opt/lua*

RUN dnf remove make -y && dnf autoremove -y


# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/

USER $USERNAME


# Adding Rust
RUN cat /home/$USERNAME/sh.rustup.rs | sh -s -- -y && \
    . /home/$USERNAME/.cargo/env && \
    rm /home/$USERNAME/sh.rustup.rs

WORKDIR /home/$USERNAME/$LANGUAGE/rust
RUN . /home/$USERNAME/.cargo/env && cargo init

# PNPM Setup
WORKDIR /home/$USERNAME/$LANGUAGE/typescript
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash \
  && curl -fsSL https://get.pnpm.io/install.sh | sh - \
  && . ~/.bashrc \
  && nvm install --lts \
  && pnpm init \
  && pnpm add typescript tsx -D \
  && pnpm tsc --init

# Github Setup
WORKDIR /home/$USERNAME/$LANGUAGE/
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
