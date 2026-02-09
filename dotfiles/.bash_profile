# activate brew
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Load .bashrc
. ${HOME}/.bashrc