#! /usr/bin/env bash

# install brew if needed
brew commands 2>&1 > /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

export PATH="/opt/homebrew/bin:$PATH"

HOMEBREW_PREFIX=$(brew --prefix)

# Update and stuff
brew update
brew upgrade

# taps
brew tap jmespath/jmespath
brew tap bramstein/webfonttools
brew tap homebrew/cask-fonts

# standard packages
PKG=(ag \
     aria2 \
     bash \
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
     jp \
     mas \
     moreutils \
     mycli \
     node \
     noti \
     oniguruma \
     openssh \
     openssl \
     p7zip \ \
     packer \
     pgcli \
     pigz \
     pkg-config \
     prettyping \
     pwgen \
     pyenv \
     pyenv-virtualenv \
     python3 \
     readline \
     screen \
     sqlite \
     telnet \
     terraform \
     tmux \
     tree \
     vim \
     vips \
     wget \
     xz \
    ) 

# extras
PKG_EXTRAS=(openconnect \
	    awscli \
	    go \
	    go@1.19 \
	    go@1.18 \
	    go@1.17 \
            helm \
            kubectl \
            oci-cli \
            skaffold \
	    protobuf \
	    protoc-gen-go \
	    protoc-gen-go-grpc \
	    sfnt2woff \
	    sfnt2woff-zopfli \
	    woff2 \
    )

HOMEBREW_NO_INSTALL_CLEANUP=1 brew install ${PKG[@]} ${PKG_EXTRAS[@]}


# Install some completions
HOMEBREW_NO_INSTALL_CLEANUP=1 brew install bash-completion@2 \
             brew-cask-completion \
             django-completion \
             pip-completion 

# GNU coreutils bins > BSD Mac ones
GB=$(brew --prefix coreutils)/libexec/gnubin
grep 'PATH.*libexec.gnubin' ~/.bash_profile > /dev/null || echo "export PATH=\"$GB:$PATH\"" >> ~/.bash_profile
ln -s "${HOMEBREW_PREFIX}/bin/gsha256sum" "${HOMEBREW_PREFIX}/bin/sha256sum"

# done
brew cleanup
