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
 - fonts

assumes:
 - python 3.3 is default

```sh
mkdir -pv $HOME/bin
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
$HOME/.homesick/repos/homeshick/bin/homeshick clone compilenix/dotfiles

chsh -s /bin/zsh
vim +PluginInstall +qall
exec zsh
```

