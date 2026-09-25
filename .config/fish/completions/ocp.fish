# Fish completions for ocp-tool

function __ocp_list_clusters
    find $OCP_CLUSTER_MANAGEMENT_DIR -mindepth 1 -maxdepth 2 -type d -name auth 2>/dev/null \
        | while read -l dir
            basename (dirname $dir)
        end
end

set -l subcommands api console release reserve help list login make-tmp-kubeconfig readme refresh refresh-tool url use version

# Subcommands
complete -c ocp -n "not __fish_seen_subcommand_from $subcommands" -f -a "$subcommands"

complete -c ocp -n "__fish_seen_subcommand_from console login api url version use list reserve release" -f -a "(__ocp_list_clusters)"
complete -c ocp -n "__fish_seen_subcommand_from help" -f -a "$subcommands"

# Flags
complete -c ocp -n "__fish_seen_subcommand_from login" -l global
complete -c ocp -n "__fish_seen_subcommand_from reserve" -s f
complete -c ocp -n "__fish_seen_subcommand_from reserve" -l description -r
complete -c ocp -n "__fish_seen_subcommand_from reserve" -l until -r
complete -c ocp -n "__fish_seen_subcommand_from release" -s f

