#platform=x86, AMD64, or Intel EM64T
#version=DEVEL

# Firewall configuration
firewall --disabled

# specify location of packages
url --url="ftp://192.168.3.56/os_images/Fedora-Server-dvd-x86_64-37-1.7"

# Root password
rootpw --lock

# System authorization information
# auth useshadow passalgo=sha512
# deprecated now in favor of authselect, but for now lets remove

# create sudo group
group --name=sudo --gid=4999

# create admin user
user --name=nodectl --uid=5000 --gid=5000 --groups=sudo --iscrypted --password=grub.pbkdf2.sha512.10000.32947B425EAAC4238433CDE5BEA6220A4F8B4A8EDFFD148C1E705936DF866AA1096E07B91130D1D673235C550D0CA80B53F1433F500F4AB526E3086315055551.3A5AC6EF3B3A1011EEB7344D79C471AE3BAC8B22334B1DB29719F93E58FFB457061F3EE635C467FB7781407F92E6A986F85433AA5878857BD4200C89971D397D

# setup authorized_keys for nodectl user
sshkey --username=nodectl "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0H8PM9uCYWXrQETGf23BvIyV/XQEqoG0iUBs5cjDrkhwx1o5PKr7+CSBE2lCHqkDhKBEPPFsRXwD9sRlQmV+GoeSmyJ1CNJde3tYnGIJv0JxfJX/WSO3MEYC1qwW6DjkBgP43uSg4Xf+yZmT7KjrZw8cOeWZ8o20oR7u4ewl8d0G345x5hUe4gazJhz7VB1hGb4D02Djr/kT7L/ScBHM6pD8at3lmXmejWfv3w0j3ZLuuffjAdCWVBnPuWZr0izQtxqvNGrHDpGvX7gd2Y8EUP4JbvI24mRVOSTM2FGESZGvmT88mEnLeB2sWUaEt/2k0tf5gt7jW3mtylHES5NH8z/dBfYxa7g5dV3cIm/Dyvp0g8ge3uhBVRpoCV4uy/ErzwyKpc6kIjIX68LsopgQR8WoizO/fSuPEcFezovdGmcQhZ95NThUBUvUOiduLkvcYWuQ2+OjpBMbKnq5hB0p/5L+M6pjTdEoZvwMzDW2HoE/J9O+wmfwkgb8oHPfDDuMPBBS9MsDgPItpjhFw2S47SaLzrgborBdCDRu4/IefRJzLllNwDU2QQdoIWb1lbQogxXwRylIDwIExn9pZ0yPkYaChEtC0W+iGj+W8h+KmjPHV74OtCmyJKggtdxmX1jlyQaI5OoAytqkq23t/ylF26sJSdfWxgOg9lQjthYi7lw=="

# Use graphical install
cmdline

#remove initial setup on first boot
firstboot --disable

# auto-agree to EULA
eula --agreed

# reboot afer installation
reboot

# System keyboard to US
keyboard us

# System language to English
lang en_US

# SELinux configuration
selinux --disabled

# Installation logging level
logging --level=info

# System timezone
timezone America/New_York

# System bootloader configuration
bootloader --location=mbr --boot-drive=sda

# automatically partition
autopart --nohome --type=lvm
zerombr
clearpart --all --drives=sda
ignoredisk --only-use=sda

# manually partition everything
#clearpart --all --initlabel
#part swap --asprimary --fstype="swap" --size=1024
#part /boot --fstype xfs --size=300
#part pv.01 --size=1 --grow
#volgroup root_vg01 pv.01
#logvol / --fstype xfs --name=lv_01 --vgname=root_vg01 --size=1 --grow

%packages
net-tools
curl
tar
python3
%end

#%addon com_redhat_kdump --enable --reserve-mb='auto'
%addon com_redhat_kdump --disable
%end

%post --log=/root/ks-post.log
# put commands here to run after install
# add sudo group to permit passwordless escalation for ansible
echo "%sudo ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
%end
