# set up a few things

# install fzf; assumes fzf is installed already.
$(brew --prefix)/opt/fzf/install


# Ensure vscode is installed 
if which code &> /dev/null; then
    code --install-extension bibhasdn.django-snippets
    code --install-extension cssho.vscode-svgviewer
    code --install-extension deerawan.vscode-dash
    code --install-extension djabraham.vscode-yaml-validation
    code --install-extension eriklynd.json-tools
    code --install-extension jinsihou.diff-tool
    code --install-extension ms-python.python
    code --install-extension ms-vscode.cpptools
    code --install-extension msjsdiag.debugger-for-chrome
    code --install-extension octref.vetur
    code --install-extension PeterJausovec.vscode-docker
    code --install-extension platformio.platformio-ide
    code --install-extension searKing.preview-vscode
    code --install-extension tinkertrain.theme-panda
    code --install-extension webfreak.debug
    code --install-extension zhuangtongfa.Material-theme
else
    echo "Cant install VSC plugins."
    echo "Set up Visual Studio Code and add the code CLI interface and then run this again."
fi
