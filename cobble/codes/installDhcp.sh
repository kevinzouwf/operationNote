$ yum install dhcp tftp-server httpd -y
$ cat /etc/dhcp/dhcpd.conf
subnet 10.0.0.0 netmask 255.255.255.0 {
 range 10.0.0.100 10.0.0.200; # 可分配起始IP-结束IP
 option subnet-mask 255.255.255.0; #netmask
 default-lease-time 21600; #默认租用期限
 max-lease-time 43200; #最大IP租用期限
 next-server 10.0.0.151; #TFTP服务器IP
 filename "/pxelinux.0"; # TFTP根目录下载pxelinux.0文件位置
}
#如果多块网卡可以指定网卡,如果是一块就不需要修改
$ cat /etc/sysconfig/dhcpd
DHCPDARGS=eth0
$ cat /etc/xinetd.d/tftp
service tftp
{
 socket_type = dgram
 protocol = udp
 wait = yes
 user = root
 server = /usr/sbin/in.tftpd
 server_args = -s /var/lib/tftpboot #请注意这个地方以后会用到
 disable = no #仅修改这里就可以
 per_source = 11
 cps = 100 2
 flags = IPv4
}
$ sed -i "277i ServerName 127.0.0.1:80" /etc/httpd/conf/httpd.conf
$ mount /dev/sr0 /var/www/html/CentOS-6.7/
$ /etc/init.d/dhcpd start
$ /etc/init.d/xinetd start
$ /etc/init.d/httpd start
