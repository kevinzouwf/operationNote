#version=DEVEL
# System authorization information
auth --useshadow  --enablemd5
# Install OS instead of upgrade
install
# Use network installation
url --url="http://192.168.0.112/cblr/links/CentOS_7.2-x86_64"
repo --name="source-1" --baseurl=http://192.168.0.112/cobbler/ks_mirror/CentOS_7.2-x86_64
# Use text mode install
text
# Firewall configuration
firewall --disabled
firstboot --disable
ignoredisk --only-use=sda,sdb
# Keyboard layouts
# old format: keyboard us
# new format:
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=static --device=eno1 --gateway=10.5.41.254 --hostname=TST-PRE-01 --ip=10.5.41.12 --netmask=255.255.255.0
# Reboot after installation
reboot
# Root password
rootpw --iscrypted $1$root$epRzzSdjKq9Crpmp9/S2T0
# SELinux configuration
selinux --disabled
# System services
services --disabled="cups,rpcbind,nfslock,postfix,portreserve,dhcpclint" --enabled="sshd,ntpd"
# Do not configure the X Window System
skipx
# System timezone
timezone America/New_York
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part swap --fstype="swap" --ondisk=sda --size=32768
part /boot --fstype="xfs" --ondisk=sda --size=200
part pv.68 --fstype="lvmpv" --ondisk=sda --size=538839
volgroup vgroup_01 --pesize=4096 pv.68
logvol /  --fstype="ext4" --grow --size=1 --name=lv_root --vgname=vgroup_01

%pre
set -x -v
exec 1>/tmp/ks-pre.log 2>&1

# Once root's homedir is there, copy over the log.
while : ; do
    sleep 10
    if [ -d /mnt/sysimage/root ]; then
        cp /tmp/ks-pre.log /mnt/sysimage/root/
        logger "Copied %pre section log to system"
        break
    fi
done &


curl "http://192.168.0.112/cblr/svc/op/trig/mode/pre/system/TST-PRE-01_6C:92:BF:34:7A:50" -o /dev/null
# Start pre_install_network_config generated code
# generic functions to be used later for discovering NICs
mac_exists() {
  [ -z "$1" ] && return 1

  if which ip 2>/dev/null >/dev/null; then
    ip -o link | grep -i "$1" 2>/dev/null >/dev/null
    return $?
  elif which esxcfg-nics 2>/dev/null >/dev/null; then
    esxcfg-nics -l | grep -i "$1" 2>/dev/null >/dev/null
    return $?
  else
    ifconfig -a | grep -i "$1" 2>/dev/null >/dev/null
    return $?
  fi
}
get_ifname() {
  if which ip 2>/dev/null >/dev/null; then
    IFNAME=$(ip -o link | grep -i "$1" | sed -e 's/^[0-9]*: //' -e 's/:.*//')
  elif which esxcfg-nics 2>/dev/null >/dev/null; then
    IFNAME=$(esxcfg-nics -l | grep -i "$1" | cut -d " " -f 1)
  else
    IFNAME=$(ifconfig -a | grep -i "$1" | cut -d " " -f 1)
    if [ -z $IFNAME ]; then
      IFNAME=$(ifconfig -a | grep -i -B 2 "$1" | sed -n '/flags/s/:.*$//p')
    fi
  fi
}

# Start of code to match cobbler system interfaces to physical interfaces by their mac addresses
#  Start eth0
# Configuring eth0 (6C:92:BF:34:7A:50)
if mac_exists 6C:92:BF:34:7A:50
then
  get_ifname 6C:92:BF:34:7A:50
  echo "network --device=$IFNAME --bootproto=static --ip=10.5.41.12 --netmask=255.255.255.0 --gateway=10.5.41.254 --hostname=TST-PRE-01" >> /tmp/pre_install_network_config
fi
# End pre_install_network_config generated code

# Enable installation monitoring

%end

%post --nochroot
set -x -v
exec 1>/mnt/sysimage/root/ks-post-nochroot.log 2>&1

%end

%post
set -x -v
exec 1>/root/ks-post.log 2>&1

# Start yum configuration
curl "http://192.168.0.112/cblr/svc/op/yum/system/TST-PRE-01_6C:92:BF:34:7A:50" --output /etc/yum.repos.d/cobbler-config.repo

# End yum configuration



# Start post_install_network_config generated code

# create a working directory for interface scripts
mkdir /etc/sysconfig/network-scripts/cobbler
cp /etc/sysconfig/network-scripts/ifcfg-lo /etc/sysconfig/network-scripts/cobbler/

# set the gateway in the network configuration file
grep -v GATEWAY /etc/sysconfig/network > /etc/sysconfig/network.cobbler
echo "GATEWAY=10.5.41.254" >> /etc/sysconfig/network.cobbler
rm -f /etc/sysconfig/network
mv /etc/sysconfig/network.cobbler /etc/sysconfig/network

# set the hostname in the network configuration file
grep -v HOSTNAME /etc/sysconfig/network > /etc/sysconfig/network.cobbler
echo "HOSTNAME=TST-PRE-01" >> /etc/sysconfig/network.cobbler
rm -f /etc/sysconfig/network
mv /etc/sysconfig/network.cobbler /etc/sysconfig/network

# Also set the hostname now, some applications require it
# (e.g.: if we're connecting to Puppet before a reboot).
/bin/hostname TST-PRE-01

# Start configuration for eth0
echo "DEVICE=eth0" > /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
echo "HWADDR=6C:92:BF:34:7A:50" >> /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
IFNAME=$(ip -o link | grep -i '6C:92:BF:34:7A:50' | sed -e 's/^[0-9]*: //' -e 's/:.*//')
if [ -f "/etc/modprobe.conf" ] && [ $IFNAME ]; then
    grep $IFNAME /etc/modprobe.conf | sed "s/$IFNAME/eth0/" >> /etc/modprobe.conf.cobbler
    grep -v $IFNAME /etc/modprobe.conf >> /etc/modprobe.conf.new
    rm -f /etc/modprobe.conf
    mv /etc/modprobe.conf.new /etc/modprobe.conf
fi
echo "TYPE=Ethernet" >> /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
echo "IPADDR=10.5.41.12" >> /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
echo "NETMASK=255.255.255.0" >> /etc/sysconfig/network-scripts/cobbler/ifcfg-eth0
# End configuration for eth0

sed -i 's/ONBOOT=yes/ONBOOT=no/g' /etc/sysconfig/network-scripts/ifcfg-eth*

rm -f /etc/sysconfig/network-scripts/ifcfg-eth0
mv /etc/sysconfig/network-scripts/cobbler/* /etc/sysconfig/network-scripts/
rm -r /etc/sysconfig/network-scripts/cobbler
echo "options bonding max_bonds=0" >> /etc/modprobe.d/bonding.conf
cat /etc/modprobe.d/bonding.conf.cobbler >> /etc/modprobe.d/bonding.conf
rm -f /etc/modprobe.d/bonding.conf.cobbler
# End post_install_network_config generated code




# Start download cobbler managed config files (if applicable)
# End download cobbler managed config files (if applicable)

# Start koan environment setup
echo "export COBBLER_SERVER=192.168.0.112" > /etc/profile.d/cobbler.sh
echo "setenv COBBLER_SERVER 192.168.0.112" > /etc/profile.d/cobbler.csh
# End koan environment setup

# begin Red Hat management server registration
# not configured to register to any Red Hat management server (ok)
# end Red Hat management server registration

# Begin cobbler registration
# skipping for system-based installation
# End cobbler registration

# Enable post-install boot notification

# Start final steps

curl "http://192.168.0.112/cblr/svc/op/ks/system/TST-PRE-01_6C:92:BF:34:7A:50" -o /root/cobbler.ks
curl "http://192.168.0.112/cblr/svc/op/trig/mode/post/system/TST-PRE-01_6C:92:BF:34:7A:50" -o /dev/null
# End final steps
%end

%packages
@base
@compat-libraries
@core
@debugging
@development
@hardware-monitoring
@large-systems
@performance
@perl-runtime
bash-completion
kexec-tools
lrzsz
nc
pam_krb5
pax
tcpdump
telnet
vim

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

