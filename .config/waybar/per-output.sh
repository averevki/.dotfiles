#!/usr/bin/env bash
#
# Run one waybar process per output, instead of the single multi-output
# instance sway starts via `swaybar_command`. Separate processes are what
# makes per-output hiding possible: waybar toggles visibility on SIGUSR1,
# but the signal hits every bar a process owns.
#
# Each instance gets a generated config that pulls in the real one and pins
# itself to a single output. Started from the sway config; see toggle.sh for
# the other half.

set -uo pipefail

config="${XDG_CONFIG_HOME:-$HOME/.config}/waybar/config"
style="${XDG_CONFIG_HOME:-$HOME/.config}/waybar/style.css"
rundir="${XDG_RUNTIME_DIR:-/tmp}/waybar-per-output"

mkdir -p "$rundir"

sync_bars() {
    local outputs name cfg
    mapfile -t outputs < <(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .name')

    # Start a bar for every active output that does not have one yet.
    for name in "${outputs[@]}"; do
        cfg="$rundir/$name.json"
        pgrep -f -- "waybar -c $cfg " >/dev/null && continue
        jq -n --arg inc "$config" --arg out "$name" \
            '{include: [$inc], output: $out}' >"$cfg"
        waybar -c "$cfg" -s "$style" >/dev/null 2>&1 &
    done

    # Reap bars whose output is gone, so an unplugged monitor does not leave
    # a stale instance that grabs the name again on reconnect.
    for cfg in "$rundir"/*.json; do
        [[ -e $cfg ]] || continue
        name=$(basename "$cfg" .json)
        printf '%s\n' "${outputs[@]}" | grep -qxF -- "$name" && continue
        pkill -f -- "waybar -c $cfg "
        rm -f "$cfg"
    done
}

# Waybar has no reload signal -- SIGUSR1 toggles visibility and SIGUSR2 just
# kills it -- so edits to ~/.config/waybar/config need the bars restarted:
#
#     ~/.config/waybar/per-output.sh --restart
#
# That runs against the already-running supervisor rather than replacing it.
if [[ ${1-} == --restart ]]; then
    pkill -f -- "waybar -c $rundir/"
    sleep 0.5
    sync_bars
    exit 0
fi

sync_bars

# Keep up with monitors being plugged in, unplugged, or disabled.
swaymsg -t subscribe -m '["output"]' | while read -r _; do
    sync_bars
done
