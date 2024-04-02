if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_prompt
    set -l prompt_symbol '❯'
    fish_is_root_user; and set prompt_symbol '#'

    echo -s (set_color blue) (prompt_pwd) ' ' $prompt_symbol ' '
end

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
set -gx VISUAL /usr/bin/vim
set -gx EDITOR "$VISUAL"
# GPG signing
set -gx GPG_TTY $(tty)

# set PATH
set -Ua fish_user_paths \
    /home/averevki/.local/bin \
    /home/averevki/go/bin \
    /home/averevki/.screenlayout

# ocp-tool
set -gx OCP_CLUSTER_MANAGEMENT_DIR ~/work/cluster-management
#source ~/.local/src/ocp-tool/scripts/ocp.sh
#source ~/.local/src/ocp-tool/scripts/ocp.bash.completion
