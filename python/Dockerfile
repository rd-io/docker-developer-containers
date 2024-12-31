FROM fedora:latest

# User editable variabled
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""

# Constants, do not change
ENV USERNAME="python-container"
ENV LANGUAGE="python"
LABEL identity="rd-python"


# Install base system dependencies
RUN echo 'fastestmirror=True' >> /etc/dnf/dnf.conf

RUN dnf upgrade -y && dnf install -y \
  gcc \
  git \
  nano \
  openssh-clients \
  ripgrep \
  python3 \
  python3-pip \
  && dnf autoremove -y

# Upgrade pip, and install depency for venv
RUN pip install --upgrade pip
RUN pip install source

# Non-admin account & Neovim setup
RUN useradd -m -d /home/$USERNAME $USERNAME

ADD "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz" /opt/
RUN tar -xf /opt/nvim-linux64.tar.gz -C /opt/
RUN rm /opt/nvim-linux64.tar.gz


# Environment setup
ENV PATH="$PATH:/opt/nvim-linux64/bin"
RUN mkdir /home/$USERNAME/$LANGUAGE \
    && mkdir -m 0755 /home/$USERNAME/.ssh

RUN mkdir -p /home/$USERNAME/.config/nvim
ADD https://github.com/$GITHUB_USERNAME/$DOTFILE_REPO.git /home/$USERNAME/.config/


# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/


# Work Directory set, Github configuration
USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
