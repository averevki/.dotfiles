#!/usr/bin/bash

# Utilities
uptime=$(uptime -p | sed -e "s/up //g")
hostname=$(hostname)

# Options
lock=" Lock"
suspend=" Suspend"
logout=" Logout"
reboot=" Reboot"
poweroff=" Shutdown"

# Execute Rofi
rofi_output=$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$poweroff" | \
		rofi -dmenu -p "$hostname" -mesg "Uptime: $uptime" -theme "$HOME/.config/rofi/powermenu.rasi")

# Run command from input
case ${rofi_output} in
    $lock) betterlockscreen -l ;;
    $suspend) systemctl suspend ;;
    $logout) awesome --replace ;;
    $reboot) systemctl reboot ;;
    $poweroff) systemctl poweroff ;;
    *) exit 1 ;;
esac
