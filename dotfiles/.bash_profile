# activate brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# iterm shell integration
[ -f ~/.iterm2_shell_integration.bash ] && \
    . ~/.iterm2_shell_integration.bash

# common env vars
[ -f ~/.exports ] && \
    . ~/.exports

# pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Add ssh keys
/usr/bin/ssh-add --apple-use-keychain --apple-load-keychain

# homebrew shell completion loader
if type brew 2&>/dev/null; then
    for completion_file in $(brew --prefix)/etc/bash_completion.d/*; do
        source "$completion_file"
    done
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thebaron/Development/google-cloud-sdk/path.bash.inc' ]; then . '/Users/thebaron/Development/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/thebaron/Development/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/thebaron/Development/google-cloud-sdk/completion.bash.inc'; fi

# Docker
export DOCKER_HOST=tcp://10.15.20.35:2375/

