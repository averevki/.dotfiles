#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# disable ctrl+s/ctrl+q
stty -ixon

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# PS1
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\[\e[34m\]\W \[\e[31m\]\$(parse_git_branch)\[\e[0m\]\[\e[34m\]❯\[\e[00m\] "

ex() {
    if [ -f "$1" ] ; then
	case "$1" in
            *.tar.gz)    tar xzvf $1 ;;
            *.rar)       unrar x $1 ;;
            *.gz)        gunzip $1 ;;
            *.tar)       tar xvf $1 ;;
            *.tgz)       tar xzvf $1 ;;
            *.zip)       unzip $1 ;;
            *.Z)         uncompress $1 ;;
            *)           echo "'$1' cannot be extracted with ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}


# Editor
export VISUAL=/usr/bin/vim
export EDITOR="$VISUAL"
# GPG signing
export GPG_TTY=$(tty)

# Completion for aliases
source /usr/share/bash-completion/completions/git
__git_complete g __git_main
alias g='git'

complete -F __start_kubectl k
alias k='kubectl'

alias gc='git-crypt'
alias ..="cd .."
alias pacman="sudo pacman"
alias pipenvs="ls ~/.local/share/virtualenvs/"

# PATH
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.screenlayout"
export PATH="$HOME/.cargo/bin:$PATH"

# ocp-tool
export OCP_CLUSTER_MANAGEMENT_DIR=~/work/cluster-management
source ~/.local/src/ocp-tool/scripts/ocp.sh
source ~/.local/src/ocp-tool/scripts/ocp.bash.completion

