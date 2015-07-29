#!/bin/bash
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
$HOME/.homesick/repos/homeshick/bin/homeshick clone compilenix/dotfiles
wait
chsh -s /bin/zsh
vim +PluginInstall +qall

