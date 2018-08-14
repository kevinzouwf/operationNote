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
#Defined user
function User () {
/usr/sbin/useradd  lzyi -u 512 && \
echo 623913|passwd --stdin lzyi &>/dev/null
echo "lzyi    ALL=(ALL)       ALL" >>/etc/sudoers && visudo -c &>/dev/null
Msg "useradd"
}
#Defined wget source
function Wget () {
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak && \ 
/usr/bin/wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo &>/dev/null && \
/usr/bin/wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo &>/dev/null
Msg "wget source"
}
#Defined selinux and iptables
function Fw () {
/bin/sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config && \
/usr/sbin/setenforce 0 &>/dev/null
/etc/init.d/iptables stop &>/dev/null
Msg "fw"
}

#Defined chkconfig
function Chkconfig () {
chkconfig --list|grep -Ev "sshd|rsyslog|network|sysstat|crond"|awk '{print "chkconfig " $1 " off"}'|bash &>/dev/null
Msg "chkconfig"
}

#Defined sshd
function Sshd () {
/bin/sed -ir '13 iPort 52113\nPermitRootLogin no\nPermitEmptyPasswords no\nUseDNS no\nGSSAPIAuthentication no' /etc/ssh/sshd_config
Msg "sshd"
}

##Defined
function Uptime () {
echo '*/5 * * * * /usr/sbin/ntpdate time.nist.gov >/dev/null 2>&1' >>/var/spool/cron/root
Msg "ntpdate"
}
#Defined
function Profile () {
echo "export TMOUT=600">>/etc/profile
echo "export HISTSIZE=10">>/etc/profile
echo "export HISTFILESIZE=10">>/etc/profile
echo '* -nofile 65535' >>/etc/security/limits.conf
source /etc/profile
Msg "profile"
}

#Defined issue
function Issue () {
> /etc/issue.net && > /etc/issue
Msg "issue"
}

function main () {
User
Wget
Fw
Chkconfig
Sshd
Uptime
Profile
Issue
}
main
