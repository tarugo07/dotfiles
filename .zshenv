typeset -U path cdpath fpath manpath

path=(/opt/homebrew/bin(N-/) /usr/local/bin(N-/) /usr/local/sbin(N-/) $HOME/bin(N-/) $path)

if [[ -x "/usr/libexec/java_home" ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi

path=(${JAVA_HOME:+${JAVA_HOME}/bin}(N-/) $path)
