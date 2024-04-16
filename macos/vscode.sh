#! /usr/bin/env bash

export PATH=/opt/homebrew/bin/:$PATH
HOMEBREW_PREFIX=$(brew --prefix)

OS=$(uname -s | tr "[:upper:]" "[:lower:]")
ARCH=$(uname -m)

DOWNLOAD_URL="https://code.visualstudio.com/sha/download?build=stable&os=${OS}-${ARCH}"

[ -x ${HOMEBREW_PREFIX}/bin/code ] || {
        curl -Lso ~/Downloads/VSCode.zip \
             ${DOWNLOAD_URL}
        unzip -d /Applications/ ~/Downloads/VSCode.zip
        ln -fs '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' ${HOMEBREW_PREFIX}/bin/code
}

