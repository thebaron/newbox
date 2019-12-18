# Add gnu utils to path under their real names
export PATH="/usr/local/opt/findutils/libexec/gnubin:/usr/local/opt/coreutils/libexec/gnubin/:$PATH"

# add keys (use macos one cuz the brew one doesn't grok keychain)
/usr/bin/ssh-add -AK

# Add iterm2 integrations
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# set up pyenv, if it's installed
if which pyenv &> /dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# if FZF is set up, source it
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# if our bash prompt is set up, source that too
[ -f ~/.bash_prompt ] && source ~/.bash_prompt

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
        for completion_file in $(brew --prefix)/etc/bash_completion.d/*; do
            source "$completion_file"
        done
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# import standard exports
test -e "${HOME}/.exports" && source "${HOME}/.exports"

# Not big on aliases, but, what the fuck, Apple. CPU should be default.
alias top='top -ocpu'

# a few more from the dotfiles, these seem handy

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Airport CLI alias
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
