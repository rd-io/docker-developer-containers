FROM fedora:latest

# User editable variabled
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""

# Periodic updates for the latest version of Go
ENV GO_VERSION="1.23.3"

# Constants, do not change
ENV USERNAME="go-container"
ENV LANGUAGE="go"
LABEL identity="rd-go"


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


# Environment setup
ENV PATH="$PATH:/opt/nvim-linux64/bin"
RUN mkdir /home/$USERNAME/$LANGUAGE \
    && mkdir -m 0755 /home/$USERNAME/.ssh

RUN mkdir -p /home/$USERNAME/.config/
ADD https://github.com/$GITHUB_USERNAME/$DOTFILE_REPO.git /home/$USERNAME/.config/


# Installing Go from tar
ADD "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz" /opt/
RUN tar -xf "/opt/go$GO_VERSION.linux-amd64.tar.gz" -C /opt/
RUN rm "/opt/go$GO_VERSION.linux-amd64.tar.gz"
ENV PATH="$PATH:/opt/go/bin"


# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/


# Work Directory set, Github configuration
USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
