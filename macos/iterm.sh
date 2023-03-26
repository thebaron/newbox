#! /usr/bin/env bash

# install iterm2 if needed
if [ ! -d /Applications/iTerm.app/ ]; then
    curl -Lso ~/Downloads/iTerm2.zip https://iterm2.com/downloads/stable/latest
    unzip -d /Applications/ ~/Downloads/iTerm2.zip
fi
