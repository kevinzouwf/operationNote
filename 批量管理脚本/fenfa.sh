#!/bin/sh
. /etc/init.d/functions

for n in 5 6 7 8 31 41 51
do
   scp -rp /etc/hosts 172.16.1.$n:/etc &>/dev/null  && \
   scp -rp /server 172.16.1.$n:/ &>/dev/null
   if [ $? -eq 0 ];then
      action "fenfa to 172.16.1.$n is ok" /bin/true
   else
      action "fenfa to 172.16.1.$n is false" /bin/false
  fi
done