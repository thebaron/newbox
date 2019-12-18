#! /usr/bin/env bash

# Update and stuff
brew update
brew upgrade

# install a bunch of stuff

brew tap jmespath/jmespath
brew install ag \
             bat \
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
             python \
             python3 \
             rclone \
             readline \
             screen \
             sqlite \
             ssh-copy-id \
             telnet \
             terraform \
             tmux \
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
brew install gnu-sed --with-default-names

# Install Bash 4.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Wget with IRI support
brew install wget --with-iri

# Install updated vim    
brew install vim --with-override-system-vi

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# done
brew cleanup
