#!/bin/sh

yum install rpcbind nfs-utils -y

mkdir -p /backup/{www,bbs,blog}

echo "/backup/www      172.16.1.0/24(rw,sync,all_squash)" >/etc/exports 
echo "/backup/bbs      172.16.1.0/24(rw,sync,all_squash)" >>/etc/exports
echo "/backup/blog     172.16.1.0/24(rw,sync,all_squash)" >>/etc/exports

