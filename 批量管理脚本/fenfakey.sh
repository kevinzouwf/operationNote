#!/bin/sh
. /etc/init.d/functions
ssh-keygen -t dsa -P "" -f ~/.ssh/id_dsa

for n in 5 6 7 8 31 41 51
do
  expect expect.exp /root/.ssh/id_dsa.pub 172.16.1.$n &>/dev/null
  if [ $? -eq 0 ];then
     action "to 172.16.1.$n" /bin/true
  else
     action "to 172.16.1.$n" /bin/false
  fi
done