# Use the following python code to generate your password hash:
#   python -c 'import crypt,getpass;pw=getpass.getpass();print(crypt.crypt(pw) if (pw==getpass.getpass("Confirm: ")) else exit())'
#
# Use the following command to generate your grub password hash:
#   grub2-mkpasswd-pbkdf2

# section order
#    command
#        optional addon section
#    %packages section
#    %pre %post and %onerror section in any order and not required

#version=DEVEL

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

%packages
@^server-product-environment

%end

# Firewall configuration
firewall --disabled

# specify location of packages
url --url="ftp://192.168.3.56/os_images/Fedora-Server-dvd-x86_64-41-1.4"

# Root password
rootpw --lock

# System authorization information
# auth useshadow passalgo=sha512
# deprecated now in favor of authselect, but for now lets remove

# create sudo group
group --name=sudo --gid=4999

# create admin user
user --name=nodectl --uid=5000 --gid=5000 --groups=sudo --iscrypted --password=$6$5bhN3Uwpfj/swjMI$25pgh/p7AKuE3ljjMBc.QLY/6wvyfsQyivPlZZgxBFB/brLT/o0l/1skHciaNkweTsgtRgZh4Tn4yZVkRXV1S1

# setup authorized_keys for nodectl user
sshkey --username=nodectl "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0H8PM9uCYWXrQETGf23BvIyV/XQEqoG0iUBs5cjDrkhwx1o5PKr7+CSBE2lCHqkDhKBEPPFsRXwD9sRlQmV+GoeSmyJ1CNJde3tYnGIJv0JxfJX/WSO3MEYC1qwW6DjkBgP43uSg4Xf+yZmT7KjrZw8cOeWZ8o20oR7u4ewl8d0G345x5hUe4gazJhz7VB1hGb4D02Djr/kT7L/ScBHM6pD8at3lmXmejWfv3w0j3ZLuuffjAdCWVBnPuWZr0izQtxqvNGrHDpGvX7gd2Y8EUP4JbvI24mRVOSTM2FGESZGvmT88mEnLeB2sWUaEt/2k0tf5gt7jW3mtylHES5NH8z/dBfYxa7g5dV3cIm/Dyvp0g8ge3uhBVRpoCV4uy/ErzwyKpc6kIjIX68LsopgQR8WoizO/fSuPEcFezovdGmcQhZ95NThUBUvUOiduLkvcYWuQ2+OjpBMbKnq5hB0p/5L+M6pjTdEoZvwMzDW2HoE/J9O+wmfwkgb8oHPfDDuMPBBS9MsDgPItpjhFw2S47SaLzrgborBdCDRu4/IefRJzLllNwDU2QQdoIWb1lbQogxXwRylIDwIExn9pZ0yPkYaChEtC0W+iGj+W8h+KmjPHV74OtCmyJKggtdxmX1jlyQaI5OoAytqkq23t/ylF26sJSdfWxgOg9lQjthYi7lw=="

# Use text install
cmdline

#remove initial setup on first boot
firstboot --disable

# auto-agree to EULA
eula --agreed

# reboot afer installation
reboot


# SELinux configuration
selinux --disabled

# System timezone
timezone America/New_York

# Partitioning

## Clearing
ignoredisk --only-use=nvme0n1

zerombr
clearpart --drives=nvme0n1 --all

## System Disk
#part /boot/efi             --fstype=efi   --size=600    --ondisk=nvme0n1
#part /boot                 --fstype=xfs   --size=1024   --ondisk=nvme0n1

#part pv.10                 --fstype=lvmpv --size=61000 --ondisk=nvme0n1 --grow
#volgroup vg_system pv.10
#logvol /                   --fstype=xfs   --size=50000  --name=root    --vgname=vg_system
#logvol /var                --fstype=xfs   --size=5000   --name=var     --vgname=vg_system
#logvol /var/log            --fstype=xfs   --size=5000   --name=var_log --vgname=vg_system

bootloader --boot-drive=nvme0n1

autopart --nohome --type=plain

#logvol /home               --fstype="xfs"   --size="5000" --name="home"    --vgname="vg_system" --grow

## Data Disk
#part pv.20                 --fstype="lvmpv" --size="210000" --ondisk="sda" --grow
#volgroup vg_data pv.20
#logvol /var/lib/libvirt    --fstype="xfs"   --size="100000" --name="var_lib_libvirt"    --vgname="vg_data"
#logvol /var/lib/containers --fstype="xfs"   --size="100000" --name="var_lib_containers" --vgname="vg_data"

#%addon com_redhat_kdump --enable --reserve-mb='auto'
#%addon com_redhat_kdump --disable
#%end

%post --log=/root/ks-post.log
# put commands here to run after install
# add sudo group to permit passwordless escalation
echo "%sudo ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
%end
