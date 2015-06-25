#!/bin/bash
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
$HOME/.homesick/repos/homeshick/bin/homeshick clone compilenix/dotfiles
chsh -s /bin/zsh
zsh
vim +PluginInstall +qall

