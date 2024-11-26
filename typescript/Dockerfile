FROM fedora:latest

# User editable variabled
ENV USERNAME=""
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""

# Periodic updates for the latest NVM version
ENV NVM_VERSION="v0.40.1"

# Constants, do not change
ENV LANGUAGE="typescript"
LABEL identity="rd-typescript"


# Install base system dependencies
RUN echo 'fastestmirror=True' >> /etc/dnf/dnf.conf

RUN dnf upgrade -y && dnf install -y \
  git \
  nano \
  openssh-clients \
  ripgrep \
  gcc \
  unzip \
  && dnf autoremove -y


# Non-admin account & Neovim setup
RUN useradd -m -d /home/$USERNAME $USERNAME

ADD "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz" /opt/
RUN tar -xf /opt/nvim-linux64.tar.gz -C /opt/
RUN rm /opt/nvim-linux64.tar.gz
ENV PATH="$PATH:/opt/nvim-linux64/bin"


# Environment setup
RUN mkdir -p /home/$USERNAME/$LANGUAGE \
    && mkdir -m 0755 /home/$USERNAME/.ssh

RUN mkdir -p /home/$USERNAME/.config/nvim
ADD https://github.com/$GITHUB_USERNAME/$DOTFILE_REPO.git /home/$USERNAME/.config/


# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/


# nvm and pnpm setup
USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash \
  && curl -fsSL https://get.pnpm.io/install.sh | sh - \
  && . ~/.bashrc \
  && nvm install --lts \
  && pnpm init \
  && pnpm add typescript tsx -D \
  && pnpm tsc --init


# Work Directory set, Github configuration
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
