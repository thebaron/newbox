#! /usr/bin/env bash

# install brew if needed
brew commands 2>&1 > /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Update and stuff
brew update
brew upgrade

# install a bunch of stuff

brew tap jmespath/jmespath

brew install ag \
             aria2 \
             bat \
             cmake \
             cookiecutter \
             coreutils \
             direnv \
             entr \
             findutils \
             fzf \
             gdbm \
             gnupg \
             gnu-sed \
             gnutls \
             htop \
             jq \
             moreutils \
             mycli \
             node \
             noti \
             oniguruma \
             openssh \
             openssl \
             p7zip \
             packer \
             pgcli \
             pigz \
             pkg-config \
             prettyping \
             pwgen \
             pyenv \
             pyenv-virtualenv \
             python3 \
             rclone \
             readline \
             screen \
             sqlite \
             ssh-copy-id \
             telnet \
             terraform \
             tmux \
             tree \
             vim \
             vips \
             wget \
             xz \
             youtube-dl 

# These don't work yet on M1
[ $(uname -p) != "arm" ] && brew install \
             jp \
             mas 

# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
ln -s "${HOMEBREW_PREFIX}/bin/gsha256sum" "${HOMEBREW_PREFIX}/bin/sha256sum"

# Install Bash 4.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${HOMEBREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${HOMEBREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${HOMEBREW_PREFIX}/bin/bash";
fi;

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2
brew tap homebrew/cask-fonts

# Install some completions
brew install brew-cask-completion \
             django-completion \
             pip-completion 

# Install Docker on Intel on Intel on Intel
[ $(uname -p) != "arm" ] && brew install docker \
                                         docker-machine \
                                         docker-machine-driver-xhyve && \
                            brew services start docker-machine && \
                            sudo dseditgroup -o create docker && \
                            sudo dseditgroup -o edit -a thebaron -t user docker && \
                            sudo chown root:docker ${HOMEBREW_PREFIX}/bin/docker-machine-driver-xhyve && \
                            sudo chmod u+s         ${HOMEBREW_PREFIX}/bin/docker-machine-driver-xhyve


# Install kubernets-y stuff
brew install helm \
             kubectl \
             skaffold
# done
brew cleanup
