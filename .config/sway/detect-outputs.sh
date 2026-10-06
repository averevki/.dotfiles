#!/usr/bin/env bash
#
# Pick the output profile matching the monitors that are physically plugged
# in, and print its path.
#
# Called from ~/.config/sway/config as `include '$(...)'`, so it must print
# exactly one line -- the profile to include -- and nothing else.
#
# Detection reads EDID straight out of sysfs rather than asking
# `swaymsg -t get_outputs`: on a cold start the config is parsed before the
# IPC socket is answering, so swaymsg would come back empty and every profile
# would look wrong.

set -uo pipefail

dir="${XDG_CONFIG_HOME:-$HOME/.config}/sway/outputs"

# True if any connected connector's EDID contains $1. Monitor name and serial
# both live in EDID descriptor blocks as plain ASCII, so a fixed-string grep
# over the blob is enough to tell two identical models apart by serial.
connected_with() {
    local needle=$1 c
    for c in /sys/class/drm/card*-*/; do
        [[ -r "$c/status" && $(<"$c/status") == connected ]] || continue
        LC_ALL=C grep -aqsF -- "$needle" "$c/edid" && return 0
    done
    return 1
}

if connected_with "MAG 322U"; then
    printf '%s\n' "$dir/msi-acer.conf"
elif connected_with "77C9BR2"; then
    printf '%s\n' "$dir/dual-dell.conf"
else
    printf '%s\n' "$dir/laptop-only.conf"
fi
