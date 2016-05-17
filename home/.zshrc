n=$(nice)
renice -n -20 $$ > /dev/null

stty -ixon -ixoff
unicode_start
kbd_mode -u # set unicode mode
kbd_mode # check keyboard mode, should be Unicode (UTF-8)

# save emacs!
if [[ "$TERM" == "dumb" ]]
then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
fi

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

if [ -f /usr/lib64/node_modules/npm/lib/utils/completion.sh ]; then
    source /usr/lib64/node_modules/npm/lib/utils/completion.sh
fi

source $HOME/.antigen/antigen.zsh
antigen use oh-my-zsh

antigen bundle gpg-agent
antigen bundle ssh-agent
antigen bundle git
antigen bundle mosh
antigen bundle tmux
antigen bundle tmuxinator
antigen bundle node
antigen bundle npm
antigen bundle rsync
antigen bundle systemd

$(which sudo make cmake) > /dev/null
if [ $? -eq 0 ]; then
    antigen bundle thewtex/tmux-mem-cpu-load
    #antigen bundle compilenix/tmux-mem-cpu-load
fi

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle ascii-soup/zsh-url-highlighter
antigen bundle psprint/zsnapshot
antigen bundle akoenig/npm-run.plugin.zsh
antigen bundle RobSis/zsh-completion-generator

antigen theme dpoggi
antigen apply

autoload -U compinit && compinit -u

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

unalias tmux 2> /dev/null
if [ -f $(which tmux) ]; then
    if [ ! -f "$HOME/.tmux.conf_configured" ]; then
        if [[ $(tmux -V) == *"1."* ]]; then
            unlink "$HOME/.tmux.conf"
            ln -s "$HOME/.tmux.conf_v2" "$HOME/.tmux.conf"
        fi
        if [[ $(tmux -V) == *"2."* ]]; then
            unlink "$HOME/.tmux.conf"
            ln -s "$HOME/.tmux.conf_v2" "$HOME/.tmux.conf"
        fi
        touch "$HOME/.tmux.conf_configured"
    fi
fi

# aliases
alias tmux='tmux -2 -u'
alias tmuxa='tmux list-sessions 2>/dev/null 1>&2 && tmux a || tmux'
alias tmux-detach='tmux detach'
alias rm='rm -I'
alias ls='ls -h --color'
alias ll='ls -lh --color'
alias la='ls -alh --color'
alias grep='grep --color'
alias ask_yn='select yn in "Yes" "No"; do case $yn in Yes) ask_yn_y_callback; break;; No) ask_yn_n_callback; break;; esac; done;'
alias get-network-listening="lsof -Pan -i tcp -i udp | grep LISTEN | grep -v 127"
alias get-mem-dirty='cat /proc/meminfo | grep Dirty'
alias get-mem-dirty-loop='while true; do get-mem-dirty; sleep .25; done'
alias get-hexdate='date +%s | xargs printf "%x\n"'
alias get-fortune='echo -e "\n$(tput bold)$(tput setaf $(shuf -i 1-5 -n 1))$(fortune)\n$(tput sgr0)"'
alias update-gentoo='echo "do a \"emerge --sync\"?"; ask_yn_y_callback() { emerge --sync; }; ask_yn_n_callback() { echo ""; }; ask_yn; emerge -avDuN world'
alias update-archlinux='pacman -Syu'
function git-reset { for i in $*; do echo -e "\033[0;36m$i\033[0;0m"; cd "$i"; git reset --hard master; cd ~; done; };
alias fix-antigen_and_homesick_vim='git-reset $HOME/.antigen/repos/*; git-reset $HOME/.homesick/repos/*; antigen-cleanup; antigen-update; homeshick pull; homeshick refresh; vim +PluginUpdate +:qa; exec zsh'

export PATH="$PATH:$HOME/bin:$HOME/sh"
export EDITOR=vim
export LANG="en_US.UTF-8"
export HISTSIZE=1000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt extendedglob
unsetopt share_history

if [ ! -f "$HOME/.tmux.conf_include" ]; then
    touch "$HOME/.tmux.conf_include"
fi

if [ ! -f "$HOME/.gitconfig_include" ]; then
    cp -v "$HOME/.gitconfig" "$HOME/.gitconfig_include"
fi

if [ -f "$HOME/.zshrc_include" ]; then
    source "$HOME/.zshrc_include"
fi

renice -n $n $$ > /dev/null
unset n

# vim: sw=4 et
