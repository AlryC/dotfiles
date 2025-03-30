if status is-interactive
    abbr -a cd.. cd ..

    abbr -a ff   fastfetch
    abbr -a ffd  fastfetch -c ~/.config/fastfetch/default.jsonc

    abbr -a code code-oss

    abbr -a cfb  vim ~/.bashrc
    abbr -a cfd  vim ~/suckless/assets/scripts/startdwm.sh
    abbr -a cffa vim ~/.config/fastfetch/config.jsonc
    abbr -a cff  vim ~/.config/fish/config.fish
    abbr -a cfk  vim ~/.config/kitty/kitty.conf
    abbr -a cfv  vim ~/.vimrc

    abbr -a xi   sudo xbps-install
    abbr -a xq   xbps-query
    abbr -a xrr  sudo xbps-remove
end
