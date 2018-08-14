#!/bin/sh

yum install rpcbind nfs-utils -y

#####
/etc/init.d/rpcbind start
/etc/init.d/nfs start
###########
echo "/etc/init.d/rpcbind start" >>/etc/rc.local
echo "/etc/init.d/nfs start" >>/etc/rc.local
######
mkdir -p /data/{www,bbs,blog}

echo "/data/www      172.16.1.0/24(rw,sync,all_squash)" >/etc/exports 
echo "/data/bbs      172.16.1.0/24(rw,sync,all_squash)" >>/etc/exports
echo "/data/blog     172.16.1.0/24(rw,sync,all_squash)" >>/etc/exports
##########
chown -R nfsnobody.nfsnobody /data/
#########
/etc/init.d/nfs restart
