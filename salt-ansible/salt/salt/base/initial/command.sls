~/.bash_profile:
  file.append:
    - text:
      - export PROMPT_COMMAND='{ msg=$(history 1 | { read  m k w x y; echo $y; });logger -p local4.info $(who am i):[`pwd`] "$msg"; }'
      - alias vi='vim'
      - alias ..='cd ..'
      - alias grep='grep --color=auto'
      - export HISTTIMEFORMAT="%F %T `whoami` "
      - export PS1='[\u@\h \w]\$ '
