export LANG=ja_JP.UTF-8
export CLICOLOR=true
export EDITOR="/usr/local/bin/code --wait"

export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

export SBT_OPTS="-Xmx2G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Xss2M"

export LESS="-iMRS"

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

PROMPT="[%n]%# "

fpath=(/usr/local/share/zsh-completions(N-/) $fpath)
fpath=(~/.zsh/completions(N-/) $fpath)

bindkey -e

function source_if_exist_file() {
  if [[ -f "$1" ]]; then
    source "$1"
  fi
}

function has() {
  type "$1" &>/dev/null
}

if which rbenv > /dev/null; then
  eval "$(rbenv init -)";
fi

if which pyenv > /dev/null; then
  export PYENV_ROOT=$HOME/.pyenv
  export PATH=$PYENV_ROOT/bin:$PATH
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# if which pyenv-virtualenv-init > /dev/null; then
#   export PYENV_VIRTUALENV_DISABLE_PROMPT=1
#   eval "$(pyenv virtualenv-init -)";
# fi

# if [[ -d $HOME/.phpenv ]]; then
#   export PATH=$HOME/.phpenv/bin:$PATH
#   eval "$(phpenv init -)"
# fi

# if [[ -s "$(brew --prefix dvm)/dvm.sh" ]]; then
#   source "$(brew --prefix dvm)/dvm.sh"
# fi

if which direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi

# if which jenv > /dev/null; then
#   export PATH=$HOME/.jenv/bin:$PATH
#   eval "$(jenv init -)"
# fi

zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle :compinstall filename "$HOME/.zshrc"

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

source_if_exist_file $HOME/.zshrc.antigen

has history-substring-search-up && bindkey -M emacs '^P' history-substring-search-up
has history-substring-search-down && bindkey -M emacs '^N' history-substring-search-down

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
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_NO_STORE
setopt HIST_VERIFY

source_if_exist_file $HOME/.zshrc.alias

bindkey '^xb' anyframe-widget-checkout-git-branch
bindkey '^x^b' anyframe-widget-cdr
bindkey '^x^f' anyframe-widget-insert-filename
bindkey '^x^g' anyframe-widget-cd-ghq-repository
bindkey '^x^i' anyframe-widget-insert-git-branch
bindkey '^x^k' anyframe-widget-kill
bindkey '^x^r' anyframe-widget-put-history
bindkey '^x^t' anyframe-widget-tmux-attach

export NVM_DIR="$HOME/.nvm"
source_if_exist_file $(brew --prefix nvm)/nvm.sh

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

function propen() {
  local name=$(git symbolic-ref --short HEAD | xargs perl -MURI::Escape -e 'print uri_escape($ARGV[0]);')
  git config --get remote.origin.url | sed -e "s/^.*[:\/]\(.*\/.*\).git$/https:\/\/github.com\/\1\//" | sed -e "s/$/pull\/${name}/" | xargs open
}

function peco-src() {
  local selected_dir=$(ghq list | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

function peco-git-browse() {
  local selected_dir=$(ghq list | peco --query "$LBUFFER" | cut -d "/" -f 2,3)
  if [ -n "$selected_dir" ]; then
    hub browse ${selected_dir}
  fi
}
zle -N peco-git-browse
bindkey '^[' peco-git-browse

has "kubectl" && source <(kubectl completion zsh)

function prev() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new `printf %q "$PREV"`"
}

function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
stty -ixon
bindkey '^x^p' pet-select
