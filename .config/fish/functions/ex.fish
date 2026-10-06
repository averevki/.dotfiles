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
