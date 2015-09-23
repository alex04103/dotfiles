dotfiles
========

my personal configuration dot-files

feel free to steal whatever you like

homesick / homeshick
--------------------

configs for:
 - zsh
 - vim
 - git (1.7.10+)
 - htop
 - fonts
 - irssi

assumes:
 - python 3.3 is default

optional:
 - jq is installed (simple browser for "2ch-style" web forum sites)

```sh
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
$HOME/.homesick/repos/homeshick/bin/homeshick clone compilenix/dotfiles
touch $HOME/.tmux.conf_include
chsh -s /bin/zsh
zsh
vim +PluginInstall +qall
```

