#!/bin/sh

wm="awesome"
#wm="dwm"
#wm="openbox"

LIBVA_DRIVER_NAME=i965

if [ "$wm" = "dwm" ]; then
    feh --bg-scale ~/.assets/wallpapers/current
    dwmblocks &
elif [ "$wm" = "openbox" ]; then
    feh --bg-scale ~/.assets/wallpapers/current
fi

# Remap caps to escape; Switch between languages with shift + capslock
setxkbmap -layout pl,ru -option 'grp:alt_caps_toggle' -option caps:escape

picom &
pipewire &
dunst &

# Start kmonad
# sudo kmonad /home/alry/.config/kmonad.kbd &

if [ "$wm" = "dwm" ]; then
    while true; do
	    dbus-run-session -- dwm 2> ~/.dwm.log # Log stderr
	    # dbus-run-session -- dwm >/dev/null 2>&1 # No error logging
    done
elif [ "$wm" = "openbox" ]; then
    dbus-run-session -- openbox
elif [ "$wm" = "awesome" ]; then
    dbus-run-session -- awesome > ~/.awesome.log 2>&1 # error log
fi
