# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# load aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# common env vars
[ -f ~/.exports ] && \
    . ~/.exports

[ -d ~/go/bin ] && \
    export GOPATH="$HOME/go"
           PATH="$HOME/go/bin:$PATH"

[ -d ~/bin ] && \
    export PATH="$HOME/bin:$PATH"

[ -d ~/.local/bin ] && \
    export PATH="$HOME/.local/bin:$PATH"

[ -d /$HOME/.pyenv/bin ] && \
   export PATH="$PATH:/$HOME/.pyenv/bin"

[ -d /usr/local/kubebuilder/bin ] && \
    export PATH="$PATH:/usr/local/kubebuilder/bin"

[ -d /usr/local/go/bin ] && \
    export PATH="/usr/local/go/bin:$PATH"

[ -f ~/.fzf.bash ] && \
    source ~/.fzf.bash

# node nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \
    . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \
    . "$NVM_DIR/bash_completion"

# pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Add ssh keys
/usr/bin/ssh-add --apple-use-keychain --apple-load-keychain

# set up kubeconfig
export KUBECONFIG=$HOME/.kube/config:$(printf "%s:"  $HOME/.kube/clusters/* | sed -e 's/:$//')

# ensure ssh agent is running
eval $(ssh-agent)

# Add function-based commands
for bfn in $(ls -1 $HOME/.bashfn/*); do
    . $bfn
done

# run exit script when shell dies
trap ${HOME}/.bashfn/exit EXIT