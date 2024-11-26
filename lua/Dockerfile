FROM fedora:latest

# User editable variables
ENV USERNAME=""
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""

# Constants, do not change
ENV LANGUAGE="lua"
LABEL identity="rd-lua"

# Periodic updates for the latest version of Lua
ENV LUA_VERSION="5.4.7"


# Install base system dependencies
RUN echo 'fastestmirror=True' >> /etc/dnf/dnf.conf

RUN dnf upgrade -y && dnf install -y \
  git \
  nano \
  openssh-clients \
  ripgrep \
  gcc \
  unzip \
  make \
  && dnf autoremove -y


# Non-admin account & Neovim setup
RUN useradd -m -d /home/$USERNAME $USERNAME

ADD "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz" /opt/
RUN tar -xf /opt/nvim-linux64.tar.gz -C /opt/
RUN rm /opt/nvim-linux64.tar.gz
ENV PATH="$PATH:/opt/nvim-linux64/bin"



# Environment setup
RUN mkdir /home/$USERNAME/$LANGUAGE \
    && mkdir -m 0755 /home/$USERNAME/.ssh

RUN mkdir -p /home/$USERNAME/.config/nvim
ADD https://github.com/$GITHUB_USERNAME/$DOTFILE_REPO.git /home/$USERNAME/.config/


# Installing Lua compiler and interpreter, from source
ADD "https://www.lua.org/ftp/lua-$LUA_VERSION.tar.gz" /opt/
RUN tar -xf /opt/lua-$LUA_VERSION.tar.gz -C /opt/
WORKDIR /opt/lua-$LUA_VERSION/
RUN make
RUN make install
WORKDIR /
RUN rm -r /opt/lua*


# Build apps cleanup
RUN dnf remove make -y && dnf autoremove -y


# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/


# User account assigned, Github configuration
USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
