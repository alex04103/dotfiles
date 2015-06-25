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
antigen bundle tmuxinator
antigen bundle node
antigen bundle npm
antigen bundle rsync
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions src
antigen bundle fcambus/ansiweather
antigen theme tjkirch_mod
antigen apply

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# aliases
alias tmux='tmux -2 -u'
alias ls='ls -h --color'
alias ll='ls -lh --color'
alias la='ls -alh --color'
alias grep='grep --color'
alias ntpdate='ntpdate de.pool.ntp.org'
alias ls-network-listening="lsof -Pan -i tcp -i udp | grep LISTEN | grep -v 127"

export PATH="$PATH:$HOME/bin"
export EDITOR=/usr/bin/vim
