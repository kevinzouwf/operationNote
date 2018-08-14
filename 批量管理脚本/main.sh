#!/bin/sh
. /etc/init.d/functions

function Msg () {
if [ $? -eq 0 ];then
 action "$1" /bin/true
else
 action "$1" /bin/false
fi
}
function scpfile () {
for a in ${ip[@]}
do
 scp -rp $1 172.16.1.$a:$2 >/dev/null
 Msg "send $1 to ip $a $2"
done
}

function sshcommend () {
for a in ${ip[@]}
do
 /usr/bin/ssh  172.16.1.$a  $* >/dev/null
 Msg "ssh to ip $a $*"
done
}
function gekey () {
[ ! -d ~/.ssh ] && ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
 Msg "generate key"
}
function sendkey () {
  for a in  ${ip[@]}
  do
    /usr/bin/expect /server/scripts/autoSendKey.exp  ~/.ssh/id_rsa.pub 172.16.1.${a} &>/dev/null
   Msg "sendkey to 172.16.1.${a}"
  done
}
function sendfile () {
  sshcommend  /bin/mkdir -p /server/scripts
  scpfile  /etc/hosts  /etc/ 
  scpfile "/server/scripts/installRpm.sh /server/scripts/backup.sh" /server/scripts/ 
  scpfile "/etc/yum.repos.d/etiantian.repo /etc/yum.repos.d/CentOS-Base.repo" /etc/yum.repos.d/
}
function installRpm () {
    sshcommend  "/bin/sh /server/scripts/installRpm.sh"
}
function webdeploy () {
scpfile  /data/* /data/
sshcommend "chown -R nginx.nginx /data"
sshcommend "mount -t nfs -o noatime,nodiratime,nosuid,noexec,nodev,rsize=131072,wsize=131072  172.16.1.76:/uploads  /data/www/blog/wp-content/uploads/"
}
function main () {
gekey
sendkey
sendfile
installRpm
}
function helpp () {
echo "this shell include three function you cant user agument sendkey send file installRpm to run this function"
echo "the defalut ip is 72 73 74 75 76 77 78 you can use number parameter to custome ip, ip is effective in all function"
echo "function sendkey, send sshkey to remote server this function do not accepte any parameter"
echo "function scpfile , this function  accept two parameter [sorc disc] will be send sorc file to remote disc like scp  "
echo "function installRpm, install rpm to remote server, and remote server hostname must be setup "
echo "function sshcommend is ssh remote server to run command like ssh remote mkdir /data"
}
ip=(77 76 75 73 74 72 78)
num=$(echo $@ |sed -r 's#[a-zA-Z/.]*##g')
co=$(echo $@ |sed  's/[0-9]*//g')
#numc=$(echo $num|wc -w)
#coc=$(echo $co|wc -w)
if [ ! -c $num  ];then
  unset ip
  ip=$num
fi
if [ ! -c $co  ];then
   $co
else
   main
fi
