if status is-interactive
    # disable ctrl+s/ctrl+q
    stty -ixon

    # Alt+c: append clipboard pipe to current command (or last if commandline is empty)
    bind \ec 'if test -z (commandline); commandline (history | head -1); end; commandline -a " | xclip -sel clipboard"'
end

# function fish_prompt
#     set -l prompt_symbol '❯'
#     fish_is_root_user; and set prompt_symbol '#'
#
#     # Git branch
#     set -l git_branch (git branch 2>/dev/null | string match -r '\* (.+)' | tail -n1)
#
#     echo -n -s (set_color blue) (prompt_pwd) ' '
#     if test -n "$git_branch"
#         echo -n -s (set_color red) '(' $git_branch ')' (set_color blue)
#     end
#     echo -n -s (set_color blue) $prompt_symbol ' ' (set_color normal)
# end

# Hydro prompt config
set -g hydro_symbol_prompt ❯
set -g hydro_symbol_git_dirty '*'
set -g fish_prompt_pwd_dir_length 0

set -g hydro_color_pwd blue
set -g hydro_color_prompt blue
set -g hydro_color_git red
set -g hydro_color_duration yellow


function ex
    if test -f $argv[1]
        switch $argv[1]
            case '*.tar.gz'
                tar xzvf $argv[1]
            case '*.rar'
                unrar x $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xvf $argv[1]
            case '*.tgz'
                tar xzvf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted with ex()"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

# remove fish greeting message
set -g fish_greeting

# Editor
set -gx VISUAL /usr/sbin/nvim
set -gx EDITOR $VISUAL
# GPG signing
set -gx GPG_TTY (tty)

# PATH (fish_add_path is idempotent, safe to call every shell start)
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.screenlayout
fish_add_path $HOME/.istioctl/bin
fish_add_path $HOME/.npm-global/bin

# Aliases
alias g='git'
alias vim='nvim'
alias vi='nvim'
alias k='kubectl'
alias kctx='kubectx'
alias kns='kubens'
alias mk='minikube'
alias gc='git-crypt'
alias ..='cd ..'
alias pacman='sudo pacman'
alias pu='pacman -Syu'
alias pipenvs='ls ~/.local/share/virtualenvs/'

# Alias completions (inherit completions from the original command)
complete -c g --wraps git
complete -c k --wraps kubectl
complete -c mk --wraps minikube

# ocp-tool
set -gx OCP_CLUSTER_MANAGEMENT_DIR ~/work/cluster-management

function ocp
    bass "source ~/.local/src/ocp-tool/ocp.sh && ocp $argv"
end

# pyenv
set -gx PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
if command -q pyenv
    pyenv init - fish | source
end
