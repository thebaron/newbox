#! /usr/bin/env bash

# install brew if needed
brew commands  2&>1 > /dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Update and stuff
brew update
brew upgrade

# install a bunch of stuff

brew tap jmespath/jmespath

brew install ag \
             bat \
             cmake \
             cookiecutter \
             direnv \
             entr \
             fzf \
             gdbm \
             gnupg \
             gnutls \
             htop \
             jq \
             jp \
             mas \
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
             xz \
             youtube-dl 

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed 

# Install Bash 4.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Wget with IRI support
brew install wget 

# Install updated vim    
brew install vim 

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

# Install Docker
brew install docker \ 
             docker-machine \
             docker-machine-driver-xhyve

brew services start docker-machine

# Add docker group
sudo dseditgroup -o create docker
sudo dseditgroup -o edit -a thebaron -t user docker

# Make sure xhyve is setuid
sudo chown root:docker /usr/local/bin/docker-machine-driver-xhyve
sudo chmod u+s         /usr/local/bin/docker-machine-driver-xhyve

# done
brew cleanup
