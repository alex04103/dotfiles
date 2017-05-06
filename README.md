dotfiles
========

my personal configuration dot-files

feel free to steal whatever you like

homesick / homeshick
--------------------

configs for:
 - zsh
 - vim
 - tmux
 - git (1.7.10+)
 - htop
 - ansiweather
 - Xresources (xterm)
 - irssi

assumes installed software:
 - python 3.3+
 - git
 - zsh
 - vim
 - sudo (optional)
 - htop (optional)

```sh
mkdir -pv $HOME/bin
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
echo "y" | $HOME/.homesick/repos/homeshick/bin/homeshick clone alex04103/dotfiles

chsh -s /bin/zsh
vim +PluginInstall +qa
exec zsh
```

