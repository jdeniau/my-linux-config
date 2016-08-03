alias cup='composer update'
alias cin='composer install'
alias ccat='pygmentize -O style=monokai -f console256 -g'

alias cde='cd ~/code/entities/'
alias cdt='cd ~/code/ticketing/'
alias cdw='cd ~/code/website/'

alias gi=git
alias g=git
alias v='vim .'

alias upython='ipython -i ~/.ipythonrc.py'
alias pip='pip --trusted-host devpi.mapado.com'

alias sfcc='sf cache:clear'

alias gassetic='gassetic --port=51725'

export PATH=$PATH:$HOME/.npm_packages/bin


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
