#!/usr/bin/env bash
#
# Show/hide the waybar instance on the focused output. Relies on per-output.sh
# having started one waybar process per output; waybar flips its own
# visibility when it receives SIGUSR1.

set -uo pipefail

rundir="${XDG_RUNTIME_DIR:-/tmp}/waybar-per-output"

output=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
[[ -n $output ]] || exit 0

pkill -USR1 -f -- "waybar -c $rundir/$output.json "
