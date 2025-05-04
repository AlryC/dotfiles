if status is-interactive
    set -g fish_greeting
    #    function fish_greeting 
    #        fastfetch --logo-type small
    #    end

    abbr -a cd.. cd ..

    abbr -a ff fastfetch
    abbr -a ffd fastfetch -c ~/.config/fastfetch/default.jsonc

    abbr -a code code-oss

    abbr -a cfal nvim ~/.config/alacritty/alacritty.toml
    abbr -a cfa  nvim ~/.config/awesome/rc.lua
    abbr -a cfb  nvim ~/.bashrc
    abbr -a cffa nvim ~/.config/fastfetch/config.jsonc
    abbr -a cff  nvim ~/.config/fish/config.fish
    abbr -a cfk  nvim ~/.config/kmonad.kbd
    abbr -a cfv  nvim ~/.vimrc
    abbr -a cfx  nvim ~/.xinitrc

    abbr -a obv  nvim ~/Data/obsidian_vault/

    abbr -a xi sudo xbps-install
    abbr -a xq xbps-query
    abbr -a xrr sudo xbps-remove
    
    abbr -a a ' aichat' # leading space to not save it in history
    abbr -a n nvim
    abbr -a k NVIM_APPNAME="kvim" nvim
    abbr -a r ranger

    abbr -a sn sudo nvim
    
    abbr -a love ~/apps/love-11.5-x86_64.AppImage
    abbr -a weather curl wttr.in
end
