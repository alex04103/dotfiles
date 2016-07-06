n=$(nice)
# increse process priotiy if user is root, this is useful if you're loggin in while the system is under high load
if [[ $EUID -eq 0 ]]; then
    renice -n -20 $$ >/dev/null
fi

stty -ixon -ixoff 2>/dev/null
unicode_start 2>/dev/null
kbd_mode -u 2>/dev/null # set unicode mode
kbd_mode 2>/dev/null # check keyboard mode, should be Unicode (UTF-8)

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

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

unalias tmux 2>/dev/null
if [ -f $(which tmux 2>/dev/null) ]; then
    if [ ! -f "$HOME/.tmux.conf_configured" ]; then
        if [[ $(tmux -V) == *"1."* ]]; then
            unlink "$HOME/.tmux.conf"
            ln -s "$HOME/.homesick/repos/dotfiles/home/.tmux.conf_v1" "$HOME/.tmux.conf"
        fi
        if [[ $(tmux -V) == *"2."* ]]; then
            unlink "$HOME/.tmux.conf"
            ln -s "$HOME/.homesick/repos/dotfiles/home/.tmux.conf_v2" "$HOME/.tmux.conf"
        fi
        touch "$HOME/.tmux.conf_configured"
    fi
fi

# aliases
alias tmux='tmux -2 -u'
alias tmuxa='tmux list-sessions 2>/dev/null 1>&2 && tmux a || tmux'
alias tmux-detach='tmux detach'
alias ls='ls -h --color'
alias ll='ls -lh --color'
alias la='ls -alh --color'
alias grep='grep --color'
alias ask_yn='select yn in "Yes" "No"; do case $yn in Yes) ask_yn_y_callback; break;; No) ask_yn_n_callback; break;; esac; done'
alias ceph-osd-heap-release='ceph tell "osd.*" heap release'
alias get-network-listening="lsof -Pan -i tcp -i udp | grep LISTEN | grep -v 127"
alias get-mem-dirty='cat /proc/meminfo | grep Dirty'
alias get-mem-dirty-loop='while true; do get-mem-dirty; sleep 1; done'
alias get-mem-dirty-loop-250='while true; do get-mem-dirty; sleep 1; done'
alias get-mem-dirty-loop-500='while true; do get-mem-dirty; sleep 1; done'
alias get-ceph-status-loop='while true; do ceph -s > /tmp/get-ceph-status-loop.txt; clear; tput cup 0 0; cat /tmp/get-ceph-status-loop.txt; sleep 2; done'
alias get-date='date +%s'
alias get-date-hex='get-date | xargs printf "%x\n"'
alias get-fortune='echo -e "\n$(tput bold)$(tput setaf $(shuf -i 1-5 -n 1))$(fortune)\n$(tput sgr0)"'
function get-debian-package-description { read input;dpkg -l ${input} | grep " ${input} " | awk '{$1=$2=$3=$4="";print $0}' | sed 's/^ *//';unset input; };
function get-debian-package-updates { apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "$1 (\e[1;34m$2\e[0m -> \e[1;32m$3\e[0m)\n"}'; };
alias set-zsh-highlighting-full='ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)'
alias set-zsh-highlighting-default='ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)'
alias set-zsh-highlighting-off='ZSH_HIGHLIGHT_HIGHLIGHTERS=()'
alias update-gentoo='echo "do a \"emerge --sync\"?"; ask_yn_y_callback() { emerge --sync; }; ask_yn_n_callback() { echo ""; }; ask_yn; emerge -avDuN world'
alias update-archlinux='pacman -Syu'
alias update-debian='echo "do a \"apt-get update\"?"; ask_yn_y_callback() { apt-get update; }; ask_yn_n_callback() { echo ""; }; ask_yn; get-debian-package-updates | while read -r line; do echo -en "$line $(echo $line | awk "{print \$1}" | get-debian-package-description)\n"; done; echo; apt-get upgrade'
function git-reset { for i in $*; do echo -e "\033[0;36m$i\033[0;0m"; cd "$i"; git reset --hard master; cd ~; done; };
alias fix-antigen_and_homesick_vim='git-reset $HOME/.antigen/repos/*; rm /usr/local/bin/tmux-mem-cpu-load; antigen-cleanup; git-reset $HOME/.homesick/repos/*; git-reset $HOME/.vim/bundle/*; antigen-update; homeshick pull; homeshick refresh; for i in $HOME/.vim/bundle/*; do cd "$i"; git pull; done; wait; cd $HOME; exec zsh'

export PATH="$PATH:$HOME/bin:$HOME/sh"
export EDITOR=vim
export LANG="en_US.UTF-8"
export HISTSIZE=10000
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
    echo -e "#[user]\n#\tname = Compilenix\n#\temail = Compilenix@compilenix.org\n#[core]\n#\tfileMode = false\n\n# vim: sw=4 et" > "$HOME/.gitconfig_include"
fi

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

if [ -f /usr/lib64/node_modules/npm/lib/utils/completion.sh ]; then
    source /usr/lib64/node_modules/npm/lib/utils/completion.sh
fi

source $HOME/.antigen/antigen.zsh
antigen use oh-my-zsh

antigen theme dpoggi
echo "breakpoint: hit Control+C if the system takes to long to initialize optional shell modules. (you can rerun this with: \"exec zsh\")"

antigen bundle gpg-agent
antigen bundle git
antigen bundle mosh
antigen bundle tmuxinator
antigen bundle node
antigen bundle npm
antigen bundle rsync
antigen bundle systemd

if [[ \
    $EUID -eq 0 && \
    -f $(which sudo 2>/dev/null) && \
    -f $(which make 2>/dev/null) && \
    -f $(which cmake 2>/dev/null) && \
    -f $(which gcc 2>/dev/null) && \
    -f $(which g++ 2>/dev/null) && \
    -f $(which c++ 2>/dev/null) \
    ]]; then
#antigen bundle thewtex/tmux-mem-cpu-load
antigen bundle compilenix/tmux-mem-cpu-load
fi

antigen bundle RobSis/zsh-completion-generator
antigen bundle zsh-users/zsh-completions
antigen bundle ascii-soup/zsh-url-highlighter
antigen bundle psprint/zsnapshot
antigen bundle akoenig/npm-run.plugin.zsh

antigen apply

autoload -U compinit && compinit -u

antigen bundle zsh-users/zsh-syntax-highlighting

if [ ! -z "$TMUX" ]; then
    antigen bundle zsh-users/zsh-autosuggestions
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=11" # yellow
fi

if [ -f "$HOME/.zshrc_include" ]; then
    source "$HOME/.zshrc_include"
else
    touch "$HOME/.zshrc_include"
fi

if [[ $EUID -eq 0 ]]; then
    renice -n $n $$ > /dev/null
fi

unset n

# vim: sw=4 et
