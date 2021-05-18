# set up a few things

# install fzf; assumes fzf is installed already.
$(brew --prefix)/opt/fzf/install

# install iterm2 if needed
if [ ! -d /Applications/iTerm.app/ ]; then
    curl -so ~/Downloads/iTerm2.zip https://iterm2.com/downloads/stable/iTerm2-3_3_7.zip
    unzip -d /Applications/ ~/Downloads/iTerm2.zip
fi

# install Visual Studio Code
INSTALL_INSIDERS=FALSE
VSC_NEED_INSTALL=$(test -d ${HOMEBREW_PREFIX}/bin/code; echo $?)
if [ VSC_NEED_INSTALL = 1 ]; then
    if [ "z$INSTALL_INSIDERS" != "zTRUE" ]; then 
        curl -so ~/Downloads/VSCode.zip \
             -L https://update.code.visualstudio.com/latest/darwin/stable
        unzip -d /Applications/ ~/Downloads/VSCode.zip
        ln -fs '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' ${HOMEBREW_PREFIX}/bin/code
    
    else 

        curl -so ~/Downloads/VSCode.zip \
              -L https://az764295.vo.msecnd.net/insider/4a875e23d20b64504a818834f3fa4c40adb8d480/VSCode-darwin-arm64.zip
        unzip -d /Applications/ ~/Downloads/VSCode.zip
        ln -fs '/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code' ${HOMEBREW_PREFIX}/bin/code
    fi # install insiders or reg
fi # Needs install

# Ensure vscode is installed 
if which code &> /dev/null; then
    code --install-extension googlecloudtools.cloudcode
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension ms-python.python
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-vscode-remote.remote-containers
    code --install-extension ms-vscode-remote.remote-ssh
    code --install-extension ms-vscode-remote.remote-ssh-edit
    code --install-extension ms-vscode-remote.remote-ssh-edit-nightly
    code --install-extension ms-vscode-remote.remote-wsl
    code --install-extension ms-vscode-remote.vscode-remote-extensionpack
    code --install-extension octref.vetur

    code --install-extension cssho.vscode-svgviewer
    code --install-extension deerawan.vscode-dash
    code --install-extension djabraham.vscode-yaml-validation
    code --install-extension eriklynd.json-tools
    code --install-extension jinsihou.diff-tool
    code --install-extension msjsdiag.debugger-for-chrome
    code --install-extension octref.vetur
    [ $(uname -p) != "arm" ] && code --install-extension platformio.platformio-ide
    code --install-extension searKing.preview-vscode
    code --install-extension webfreak.debug
    code --install-extension zhuangtongfa.Material-theme
    code --install-extension tinkertrain.theme-panda

    cp vsc-settings.json ~/Library/Application\ Support/Code/User/settings.json

else
    echo "Cant install VSC plugins."
    echo "Set up Visual Studio Code and add the code CLI interface and then run this again."
fi

### 
### gcloud
###

echo Installing Google Cloud GCP support (gcloud)
export CLOUDSDK_CORE_DISABLE_PROMPTS=1
curl https://sdk.cloud.google.com | bash

###
### go
###

echo Installing go 1.16.4...
GO_ARCH=$(uname -m)
GO_VER=1.16.4
echo Installing go $GO_VER for $GO_ARCH...

curl -L https://golang.org/dl/go$GO_VER.darwin-$GO_ARCH.pkg > ~/Downloads/go.pkg
sudo installer -pkg ~/Downloads/go.pkg -target /

###
### protoc
###

PROTO_VER=3.17.0
echo Installing v$PROTO_VER of protocol buffers
curl -L https://github.com/protocolbuffers/protobuf/releases/download/v$PROTO_VER/protoc-$PROTO_VER-osx-x86_64.zip > ~/Downloads/protoc.zip
unzip -d /tmp/protox ~/Downloads/protoc.zip 
# remove quarantine so it runs
sudo xattr -r -d com.apple.quarantine /tmp/protox/
cd /tmp/protox
find bin include | sudo cpio -dpvm /usr/local/
