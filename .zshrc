export LANG=ja_JP.UTF-8
#export KCODE=u
export CLICOLOR=true
export EDITOR='~/bin/subl -w'

export GOPATH=$HOME/go
export PATH=$PATH:$(go env GOROOT)/bin:$GOPATH/bin

export SBT_OPTS="-Xmx2G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Xss2M"

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

PROMPT="[%n]%# "
# RPROMPT="[%~]"

fpath=(/usr/local/share/zsh-completions(N-/) $fpath)

bindkey -e

if which rbenv > /dev/null; then
  eval "$(rbenv init -)";
fi

if which pyenv > /dev/null; then
  export PYENV_ROOT=$HOME/.pyenv
  export PATH=$PYENV_ROOT/bin:$PATH
  eval "$(pyenv init -)"
fi

if which pyenv-virtualenv-init > /dev/null; then
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
  eval "$(pyenv virtualenv-init -)";
fi

if [ -d $HOME/.phpenv ]; then
 export PATH=$HOME/.phpenv/bin:$PATH
 eval "$(phpenv init -)"
fi

[[ -s "$(brew --prefix dvm)/dvm.sh" ]] && source "$(brew --prefix dvm)/dvm.sh"

if [[ -f $HOME/.zsh/antigen/antigen.zsh ]]; then
  source $HOME/.zsh/antigen/antigen.zsh
  # antigen bundle zsh-users/zsh-syntax-highlighting
  antigen apply
fi

#zstyle ':completion:*' menu yes select=2
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

autoload -Uz add-zsh-hook

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey "^o" history-beginning-search-backward-end

bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# cdr
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 200
zstyle ":chpwd:*" recent-dirs-default true

# zmv
autoload -Uz zmv

# vcs_info
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}"
zstyle ':vcs_info:*' formats '%F{green}%c%u[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}[%b|%a]%f'
function _update_vcs_info_msg() {
  LANG=en_US.UTF-8 vcs_info
  RPROMPT="[%~]"
  if [ -n "${vcs_info_msg_0_}" ]; then
    RPROMPT="${vcs_info_msg_0_}-${RPROMPT}"
  fi
}
add-zsh-hook precmd _update_vcs_info_msg

if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt CORRECT
setopt CDABLE_VARS
setopt PRINT_EIGHT_BIT
setopt NOBEEP
setopt IGNORE_EOF
setopt NO_FLOW_CONTROL
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

alias ls='ls -F'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lltr='ls -ltr'
alias llatr='ls -latr'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias mkdir='mkdir -p'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g N='> /dev/null'

alias zmv='noglob zmv -W'

function peco-execute-history() {
  local item
  item=$(builtin history -n -r 1 | peco --query="$LBUFFER")

  if [[ -z "$item" ]]; then
    return 1
  fi

  BUFFER="$item"
  CURSOR=$#BUFFER
  # zle accept-line
}
zle -N peco-execute-history
bindkey '^x^r' peco-execute-history

export NVM_DIR=$HOME/.nvm
[ -s $NVM_DIR/nvm.sh ] && . $NVM_DIR/nvm.sh  # This loads nvm

function sshconfig() {
  mv $HOME/.ssh/config{,.bak}
  cat $HOME/.ssh/conf.d/config $HOME/.ssh/conf.d/*.conf > $HOME/.ssh/config
}

function col() {
  awk -v col=$1 '{print $col}'
}

function skip() {
  n=$(($1 + 1))
  cut -d' ' -f$n-
}
