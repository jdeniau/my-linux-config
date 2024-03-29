export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="ys"

alias cup='composer update'
alias cin='composer install'
alias ccat='pygmentize -O style=monokai -f console256 -g'

alias cdt='cd ~/code/ticketing/'
alias cdd='cd ~/code/desk/'

alias g=git
if [ -x "$(command -v nvim)" ]; then
    alias v='nvim .'
    export VISUAL=nvim
    export EDITOR="$VISUAL"
else
    alias v='vim .'
fi

alias upython='ipython -i ~/.ipythonrc.py'
alias pip='pip --trusted-host devpi.mapado.com'

_symfony_console () {
    echo "php $(find . -maxdepth 2 -mindepth 1 -name 'console' -type f | head -n 1)"
}

alias sfcc='$(_symfony_console) cache:clear'

# update_auth_sock() {
#     local socket_path="$(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')"
# 
#     if ! [[ "$socket_path" ]]; then
#         echo 'no socket path' >&2
#         return 1
#     else
#         export SSH_AUTH_SOCK="$socket_path"
#     fi
# }
# 
# update_auth_sock

function git-branch-delete {
    if [ ! -d .git ]
    then
        echo "${fg[green]}Not a Git Repository${reset_color}"
        return
    fi

    currentbranch=`git branch | grep "^* " | sed "s/* //"`
    mainbranch="master"
    git rev-parse --verify master > /dev/null 2> /dev/null
    if [ $? -eq 0 ]
    then
        # master branch does exists
    else
        # master branch does not exist, test "main"
        git rev-parse --verify main > /dev/null 2> /dev/null
        if [ $? -eq 0 ]
        then
            # main branch does exists
            mainbranch="main"
        else
            # main branch does not exist, test "main"
            echo "${fg[red]}Neither main or master branch exists${reset_color}"
	    return
        fi
    fi

    if [ $1 ]
    then
        todelbranch=$1
        gotobranch=$currentbranch
    else
        todelbranch=$currentbranch
        gotobranch=$mainbranch
    fi

    if [ "$todelbranch" = $mainbranch ]
    then
        echo "${fg[green]}You can not delete branch $mainbranch${reset_color}"
        return
    fi

    git checkout $mainbranch
    git fetch --prune
    git merge origin/$mainbranch
    git branch -d $todelbranch
    git push origin --delete $todelbranch
    git checkout $gotobranch
}

stty -ixon

# Add local path
export PATH=~/.local/bin/:$PATH

if [ -x "$(command -v npm)" ] || [ -x "$(command -v yarn)" ]; then
    export PATH=$PATH:./node_modules/.bin
fi

if [ -x "$(command -v composer)" ]; then
    export PATH=$PATH:~/.composer/$(composer global config bin-dir 2> /dev/null)
    export PATH=./bin:./vendor/bin:$PATH
fi

if [ -d ~/bin/android-sdk-linux/ ]; then
    export ANDROID_HOME=~/bin/android-sdk-linux/
    export PATH=$PATH:~/bin/android-sdk-linux/tools
    export PATH=$PATH:~/bin/android-sdk-linux/platform-tools
fi

if [ -f ~/.zshaliases ]; then
    source ~/.zshaliases
fi
#
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export REACT_EDITOR=vim

# zstyle :omz:plugins:ssh-agent lifetime 4h
# zstyle :omz:plugins:ssh-agent identities id_ed25519

plugins=(symfony2 zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# GPG key, copied from https://help.github.com/articles/telling-git-about-your-gpg-key/
export GPG_TTY=$(tty)

# In order for gpg to find gpg-agent, gpg-agent must be running,
# and there must be an env variable pointing GPG to the gpg-agent socket.
# This little script, which must be sourced
# in your shell's init script (ie, .bash_profile, .zshrc, whatever),
# will either start gpg-agent or set up the
# GPG_AGENT_INFO variable if it's already running.

# Add the following
if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon)
fi

if [ "$ASCIINEMA_REC" = "1" ]; then
    export PS1='$ '
fi


# Use local file for specific configuration
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# Fixes issue with VSCode. See https://github.com/microsoft/vscode/issues/168396#issuecomment-1343000046
HISTFILE="$HOME/.zhistory"
