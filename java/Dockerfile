FROM fedora:latest

# User editable variables
ENV USERNAME=""
ENV GITHUB_EMAIL=""
ENV GITHUB_USERNAME=""
ENV DOTFILE_REPO=""

# Periodic updates for the latest OpenJDK version and Fedora version
ENV OPENJDK_LTS="21"
ENV FEDORA_VERSION="41"

# Constants, do not change
ENV LANGUAGE="java "
LABEL identity="rd-java"


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
RUN mkdir /home/$USERNAME/$LANGUAGE \
    && mkdir -m 0755 /home/$USERNAME/.ssh

RUN mkdir -p /home/$USERNAME/.config/
ADD https://github.com/$GITHUB_USERNAME/$DOTFILE_REPO.git /home/$USERNAME/.config/


# Adding Temurin JDK repo and installing
RUN touch /etc/yum.repos.d/adoptium.repo
RUN echo "[ADOPTIUM]" >> /etc/yum.repos.d/adoptium.repo && \
    echo "name=Adoptium" >> /etc/yum.repos.d/adoptium.repo && \
    echo "baseurl=https://packages.adoptium.net/artifactory/rpm/fedora/$FEDORA_VERSION/\$basearch" >> /etc/yum.repos.d/adoptium.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/adoptium.repo && \
    echo "gpgcheck=1" >> /etc/yum.repos.d/adoptium.repo && \
    echo "gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public" >> /etc/yum.repos.d/adoptium.repo 

RUN dnf update && dnf install temurin-$OPENJDK_LTS-jdk -y


# Non-admin home permissions setup
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/


# User account assigned, Github configuration
USER $USERNAME
WORKDIR /home/$USERNAME/$LANGUAGE
RUN git config --global user.email $GITHUB_EMAIL
RUN git config --global user.name $GITHUB_USERNAME
