# Use the following python code to generate your password hash:
#   python -c 'import crypt,getpass;pw=getpass.getpass();print(crypt.crypt(pw) if (pw==getpass.getpass("Confirm: ")) else exit())'
#
# Use the following command to generate your grub password hash:
#   grub2-mkpasswd-pbkdf2

# stuff to do before running installation steps
%pre
# increment version on each update so we can see what file we are running
# in some cases pushing to github is not immediately visible and we may
# be running previous file without knowing it and wandering why it keeps
# failing
echo "Running kickstart file version: 0.8.2" >> /tmp/esghome.kickstart.log
%end

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Enable update repo so we can get correct packages installed first time
# without having to update in post
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch&country=us

# specify initial packages to install for stage 1 build
# NOTE: only install what is needed by ansible for stage 2 build!
%packages
net-tools
curl
tar
python3
python3-libdnf5 # needed by ansible (new for f41) seems to not be available in server image but is available in updates
%end

# initial firewall configuration only allows ssh
firewall --service=ssh

# Disable root user
rootpw --lock

# create sudo group
group --name=sudo --gid=4999

# create admin user
user --name=nodectl --uid=5000 --gid=5000 --groups=sudo --iscrypted --password=$6$5bhN3Uwpfj/swjMI$25pgh/p7AKuE3ljjMBc.QLY/6wvyfsQyivPlZZgxBFB/brLT/o0l/1skHciaNkweTsgtRgZh4Tn4yZVkRXV1S1

# setup authorized_keys for nodectl user
sshkey --username=nodectl "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0H8PM9uCYWXrQETGf23BvIyV/XQEqoG0iUBs5cjDrkhwx1o5PKr7+CSBE2lCHqkDhKBEPPFsRXwD9sRlQmV+GoeSmyJ1CNJde3tYnGIJv0JxfJX/WSO3MEYC1qwW6DjkBgP43uSg4Xf+yZmT7KjrZw8cOeWZ8o20oR7u4ewl8d0G345x5hUe4gazJhz7VB1hGb4D02Djr/kT7L/ScBHM6pD8at3lmXmejWfv3w0j3ZLuuffjAdCWVBnPuWZr0izQtxqvNGrHDpGvX7gd2Y8EUP4JbvI24mRVOSTM2FGESZGvmT88mEnLeB2sWUaEt/2k0tf5gt7jW3mtylHES5NH8z/dBfYxa7g5dV3cIm/Dyvp0g8ge3uhBVRpoCV4uy/ErzwyKpc6kIjIX68LsopgQR8WoizO/fSuPEcFezovdGmcQhZ95NThUBUvUOiduLkvcYWuQ2+OjpBMbKnq5hB0p/5L+M6pjTdEoZvwMzDW2HoE/J9O+wmfwkgb8oHPfDDuMPBBS9MsDgPItpjhFw2S47SaLzrgborBdCDRu4/IefRJzLllNwDU2QQdoIWb1lbQogxXwRylIDwIExn9pZ0yPkYaChEtC0W+iGj+W8h+KmjPHV74OtCmyJKggtdxmX1jlyQaI5OoAytqkq23t/ylF26sJSdfWxgOg9lQjthYi7lw=="

# Use text fully automated installation
cmdline

#remove initial setup on first boot
firstboot --disable

# auto-agree to EULA
eula --agreed

# reboot afer installation
reboot

# SELinux configuration, default is enforcing
# selinux --disabled

# System timezone
timezone America/New_York

# Partitioning

bootloader --driveorder=nvme0n1

# Remove all existing partitions
clearpart --drives=nvme0n1 --all

# Remove invalid partition info
zerombr

# Create required partitions for the EFI bootloader
reqpart --add-boot

# Create a system partition using a logical volume, --size specifies min size
# and --grow makes it take up the rest of the disk that is left after required 
# partitions were created. These settings should allow the system to install 
# with even a 64GB system disk.
part pv.01 --ondrive=nvme0n1 --size=40000 --grow
volgroup vg pv.01
logvol / --vgname=vg --name=root --size=25000 --grow --fstype=xfs
# putting logs on separate volume prevents growing logs from overfilling the 
# disk and causing cascading failures in other services.
logvol /var/log --vgname=vg --size=2048 --name=log --fstype=xfs

# network configuration of the additional 10g interfaces (hopefully this takes affect after the installation)
network --device=30:d0:42:e8:be:39 --bootproto=dhcp --onboot=yes
network --device=00:0f:53:3f:c8:30 --bootproto=static --ip=192.168.3.170 --netmask=255.255.255.0 --onboot=yes
network --device=00:0f:53:3f:c8:31 --bootproto=static --ip=192.168.3.171 --netmask=255.255.255.0 --onboot=yes
#network --no-activate --device=00:0f:53:3f:c8:31 --bootproto=static --ip=192.168.3.171 --netmask=255.255.255.0 --onboot=yes

# stuff to do after we are done
%post --log=/root/ks-post.log

# remove default gateway from 1g interface
sed -i '/GATEWAY/d' /etc/sysconfig/network-scripts/ifcfg-eth2
sed -i '/DNS1/d' /etc/sysconfig/network-scripts/ifcfg-eth2

# and add them to the eth0 10g
echo "GATEWAY=192.168.3.1" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "DNS1=192.168.3.1" >> /etc/sysconfig/network-scripts/ifcfg-eth0

# Restart network services
#systemctl restart NetworkManager

# put commands here to run after install
# add sudo group to permit passwordless escalation
echo "%sudo ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

%end
