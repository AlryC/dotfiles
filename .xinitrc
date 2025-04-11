#!/bin/sh

wm="dwm"
#wm="awesome"

if [ "$wm" = "dwm" ]; then
    feh --bg-scale ~/suckless/assets/wallpapers/current
    dwmblocks &
fi

# Remap caps to escape; Switch between languages with shift + capslock
setxkbmap -layout pl,ru -option 'grp:shift_caps_toggle' -option caps:escape

picom &
pipewire &
dunst &

if [ "$wm" = "dwm" ]; then
    while true; do
	    dbus-run-session -- dwm 2> ~/.dwm.log # Log stderr
	    # dbus-run-session -- dwm >/dev/null 2>&1 # No error logging
    done
elif [ "$wm" = "awesome" ]; then
    dbus-run-session -- awesome
fi

# exec ~/suckless/assets/scripts/startdwm.sh
# exec ~/.config/awesome/startawesome.sh
# exec awesome
