typeset -U path cdpath fpath manpath

path=($HOME/bin(N-/) /usr/local/bin(N-/) $path)

if [[ -x "/usr/libexec/java_home" ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi

path=(${JAVA_HOME:+${JAVA_HOME}/bin}(N-/) $path)
