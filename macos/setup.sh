#! /usr/bin/env bash

git || xcode-select --install

git clone https://github.com/thebaron/newbox.git

cd newbox/macos 

# Install brew stuff
./brew.sh
HOMEBREW_PREFIX=$(brew --prefix)

# Install iTerm
./iterm.sh

# Install VSCode
./vscode.sh

# Setup fzf
$(brew --prefix)/opt/fzf/install --all

# use bash5 as the shell: screw zsh, sorry.
bash=${HOMEBREW_PREFIX}/bin/bash
[ -x ${bash} ] && sudo sh -c "grep ${bash} /etc/shells >/dev/null || echo ${bash} >> /etc/shells; chsh -s ${bash} ${USER}"
