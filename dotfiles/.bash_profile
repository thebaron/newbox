
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

ssh-add -AK

# homebrew shell completion loader
if type brew 2&>/dev/null; then
    for completion_file in $(brew --prefix)/etc/bash_completion.d/*; do
        source "$completion_file"
    done
fi
