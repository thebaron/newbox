alias forward="ssh -f -N -x"
alias top="top -ocpu"


export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home

export PATH=/usr/local/bin:$PATH:~/bin:/usr/local/mysql/bin:/usr/local/sbin:/Applications/Postgres.app/Contents/Versions/9.3/bin

alias vi=vim
alias vimr='open -a vimr.app'
alias jsonpp='python -m json.tool' 

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Set up terminal
. $HOME/.mactermrc

