#### Don't forget these packagesl:
```
git
stow
kitty
fastfetch
picom
maim
xclip
firacode-ttf

linux-lts (for thinkpad)

firefox (debloat with https://github.com/yokoffing/BetterFox)
```

#### Setup configs:
```
cd ~
git clone https://github.com/AlryC/dotfiles.git
cd dotfiles
stow .
```

#### XFCE
xfce overrides symlinks so use `stow . --adopt` in `dofiles` folder to back up configuration each time you change xfce configs with xfce graphic tools.
**WARNING** Use this command only after you removed all default configs, because it will overwrite the dot files

#### Colorscheme
Darkside

#### Vim
- install vim-plug `curl -fLo ~/.vim/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
- install vim plugins `:PlugInstall`
