#!/bin/sh
. /etc/init.d/functions

#Defined if config
function Msg () {
if [ $? -eq 0 ];then
  action "$1" /bin/true
  else
  action "$1" /bin/false
 exit 1
fi
}

#Defined config nfs
function  nfs () {
/bin/sh /server/scripts/nfsconf.sh  &>/dev/null
Msg "nfs config"
}

#Defined config rsync
function  rsync () {
/bin/sh /server/scripts/nfs01rsync.sh  &>/dev/null
Msg "rsync config"
}

#Defined config inotify
function  inotify () {
/bin/sh /server/scripts/inotify.sh &>/dev/null
Msg "inotify config"
}

function main () {
nfs
rsync
inotify
}
main
