alias cup='composer update'
alias cin='composer install'
alias ccat='pygmentize -O style=monokai -f console256 -g'

alias cde='cd ~/code/entities/'
alias cdt='cd ~/code/ticketing/'
alias cdw='cd ~/code/website/'

alias g=git
if [ -x "$(command -v nvim)" ]; then
    alias v='nvim .'
else
    alias v='vim .'
fi

alias upython='ipython -i ~/.ipythonrc.py'
alias pip='pip --trusted-host devpi.mapado.com'

_symfony_console () {
    echo "php $(find . -maxdepth 2 -mindepth 1 -name 'console' -type f | head -n 1)"
}

alias sfcc='$(_symfony_console) cache:clear'

update_auth_sock() {
    local socket_path="$(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')"

    if ! [[ "$socket_path" ]]; then
        echo 'no socket path' >&2
        return 1
    else
        export SSH_AUTH_SOCK="$socket_path"
    fi
}

update_auth_sock

function git-branch-delete {
    if [ ! -d .git ]
    then
        echo "${fg[green]}Not a Git Repository${reset_color}"
        return
    fi

    currentbranch=`git branch | grep "^* " | sed "s/* //"`
    if [ $1 ]
    then
        todelbranch=$1
        gotobranch=$currentbranch
    else
        todelbranch=$currentbranch
        gotobranch="master"
    fi

    if [ "$todelbranch" = "master" ]
    then
        echo "${fg[green]}You can not delete branch master${reset_color}"
        return
    fi

    git checkout master
    git fetch --prune
    git merge origin/master
    git branch -d $todelbranch
    git push origin --delete $todelbranch
    git checkout $gotobranch
}

stty -ixon

if [ -x "$(command -v npm)" ] || [ -x "$(command -v yarn)" ]; then
    export PATH=$PATH:./node_modules/.bin
fi

if [ -x "$(command -v composer)" ]; then
    export PATH=$PATH:~/.composer/$(composer global config bin-dir 2> /dev/null)
    export PATH=./bin:./vendor/bin:$PATH
fi

# zstyle :omz:plugins:ssh-agent lifetime 4h
zstyle :omz:plugins:ssh-agent identities id_ed25519

plugins=(ssh-agent)
source "/etc/zsh/plugins/oh-my-zsh/oh-my-zsh.sh"
