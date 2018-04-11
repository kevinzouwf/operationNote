$ yum -y install syslinux
# 复制启动菜单程序文件
$ cp -a /var/www/html/CentOS-6.7/isolinux/* /var/lib/tftpboot/
$ cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
$ ls /var/lib/tftpboot/
boot.cat grub.conf isolinux.bin memtest pxelinux.cfg TRANS.TBL vmlinuz
boot.msg initrd.img isolinux.cfg pxelinux.0 splash.jpg vesamenu.c32
# 新建一个pxelinux.cfg目录，存放客户端的配置文件
$ mkdir -p /var/lib/tftpboot/pxelinux.cfg
cp /var/www/html/CentOS-6.7/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default
