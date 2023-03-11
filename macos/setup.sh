# set up a few things

# install fzf; assumes fzf is installed already.
$(brew --prefix)/opt/fzf/install --all

# install iterm2 if needed
if [ ! -d /Applications/iTerm.app/ ]; then
    curl -so ~/Downloads/iTerm2.zip https://iterm2.com/downloads/stable/iTerm2-3_3_7.zip
    unzip -d /Applications/ ~/Downloads/iTerm2.zip
fi

# install Visual Studio Code
INSTALL_INSIDERS=FALSE
VSC_NEED_INSTALL=$(test -d ${HOMEBREW_PREFIX}/bin/code; echo $?)
if [ $VSC_NEED_INSTALL = 1 ]; then
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

