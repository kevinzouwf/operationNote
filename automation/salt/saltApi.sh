#!/bin/bash
# =====================================
#     Author: sandow
#     Email: j.k.yulei@gmail.com
#     HomePage: www.gsandow.com
# =====================================
useradd -M -s /sbin/nologin saltapi
passwd saltapi
[root@linux-node1 /etc/pki/tls/certs]# make testcert
cd /etc/pki/tls/private
openssl rsa -in localhost.key -out salt_nopass.key
systemctl start salt-api
pip install CherryPy==3.2.6
[root@linux-node1 ~]# vim /etc/salt/master
default_include: master.d/*.conf
rest_cherrypy:
host: 192.168.56.11
port: 8000
ssl_crt: /etc/pki/tls/certs/localhost.crt
ssl_key: /etc/pki/tls/private/salt_nopass.key
external_auth:
pam:
saltapi:
- .*
- ‘@wheel’
- ‘@runner’
[root@linux-node1 ~]# curl -k https://192.168.56.11:8000/login \ 
-H ‘Accept: application/x-yaml’ \
-d username=’saltapi’ \
-d password=’saltapi’ \
-d eauth=’pam’
return:
* eauth: pam expire: 1464663850.123221 perms: 
    * .*
    * ‘@wheel’
    * ‘@runner’ start: 1464620650.123221 token: 785db9bc5e79dee828bfb1649bc49c59900e0ebf user: saltapi
curl -k https://192.168.56.11:8000/minions/linux-node1.oldboyedu.com \ 
-H ‘Accept: application/x-yaml’ \
-H ‘X-Auth-Token: 785db9bc5e79dee828bfb1649bc49c59900e0ebf’ \
curl -k https://192.168.56.11:8000/ \ 
-H ‘Accept: application/x-yaml’ \
-H ‘X-Auth-Token: 785db9bc5e79dee828bfb1649bc49c59900e0ebf’ \
-d client=’runner’ \
-d fun=’manage.status’
curl -k https://192.168.56.11:8000/ \ 
-H ‘Accept: application/x-yaml’ \
-H ‘X-Auth-Token: 785db9bc5e79dee828bfb1649bc49c59900e0ebf’ \
-d client=’local’ \
-d tgt=’*’ \
-d fun=’test.ping’
https://github.com/binbin91/oms
