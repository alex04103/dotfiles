#!/bin/bash
$(which git zsh vim) > /dev/null

if [ $? -eq 0 ]; then
    mkdir -pv $HOME/bin
    git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    echo "y" | $HOME/.homesick/repos/homeshick/bin/homeshick clone compilenix/dotfiles
    chsh -s /bin/zsh
    vim +PluginInstall +qa
    exec zsh
fi

# vim: sw=4 et
