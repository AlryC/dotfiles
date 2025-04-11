#!/bin/sh

# TODO Turn this into a real cli install script with variants to choose
# between software (dwm/awesome/openbox, alacritty/kitty, bash/fish, etc.)

mkdir -p "$HOME/.assets/"
mkdir -p "$HOME/.config/"
# mkdir -p "$HOME/.config/"

cd "$HOME/dotfiles/"
stow .
