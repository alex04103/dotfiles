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

# homes(h)ick dotfile management
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

if [ -f /usr/lib64/node_modules/npm/lib/utils/completion.sh ]; then
	source /usr/lib64/node_modules/npm/lib/utils/completion.sh
fi

# antigen zsh plugin management
source $HOME/.antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle mosh
antigen bundle tmux
#antigen bundle tmuxinator
antigen bundle node
antigen bundle npm
#antigen bundle rsync
antigen bundle systemd
antigen bundle nmap
antigen bundle zsh-users/zsh-syntax-highlighting
#antigen bundle zsh-users/zsh-completions src
#antigen bundle thewtex/tmux-mem-cpu-load
antigen bundle fcambus/ansiweather
antigen theme dpoggi
antigen apply

autoload -U compinit && compinit -u

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# aliases
alias tmux='tmux -2 -u'
alias tmuxa='tmux list-sessions 2>/dev/null 1>&2 && tmux a || tmux'
alias ls='ls -h --color'
alias ll='ls -lh --color'
alias la='ls -alh --color'
alias grep='grep --color'
alias ls-network-listening="lsof -Pan -i tcp -i udp | grep LISTEN | grep -v 127"
alias hexdate='date +%s | xargs printf "%x\n"'
alias fortune='echo -e "\n$(tput bold)$(tput setaf $(shuf -i 1-5 -n 1))$(fortune)\n$(tput sgr0)"'

export PATH="$PATH:$HOME/bin"
export EDITOR=vim
export LANG="en_US.UTF-8"
export HISTSIZE=2000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt extendedglob
unsetopt share_history

if [ ! -f "$HOME/.tmux.conf_include" ]; then
	touch "$HOME/.tmux.conf_include"
fi

if [ -f "$HOME/.zshrc_include" ]; then
	source "$HOME/.zshrc_include"
fi

