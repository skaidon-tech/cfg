# Use the following python code to generate your password hash:
#   python -c 'import crypt,getpass;pw=getpass.getpass();print(crypt.crypt(pw) if (pw==getpass.getpass("Confirm: ")) else exit())'
#
# Use the following command to generate your grub password hash:
#   grub2-mkpasswd-pbkdf2

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

# System timezone
timezone America/New_York

# automatically partition
ignoredisk --only-use=nvme0n1

clearpart --all --drives=nvme0n1 --initlabel

# format all disks
zerombr

autopart --nohome --type=lvm

# System bootloader configuration
bootloader --append="crashkernel=auto" --location=mbr --boot-drive=nvme0n1 --leavebootorder

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
# add sudo group to permit passwordless escalation
echo "%sudo ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
%end
