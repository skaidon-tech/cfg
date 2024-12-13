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
echo "Running kickstart file version: 0.6" >> /tmp/esghome.kickstart.log
%end

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# specify initial packages to install for stage 1 build
# NOTE: only install what is needed by ansible for stage 2 build!
%packages
net-tools
curl
tar
python3
python3-libdnf5 # needed by ansible (new for f41)
%end

# Firewall configuration
# TODO: revisit
firewall --disabled

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

# SELinux configuration
# TODO: revisit
selinux --disabled

# System timezone
timezone America/New_York

# Partitioning

bootloader --driveorder=nvme0n1

# Remove all existing partitions
clearpart --drives=nvme0n1 --all

# zerombr
zerombr

#Create required partitions for the EFI bootloader
reqpart --add-boot

# create other partitions using a logical volume so it can resize
part pv.01 --ondrive=nvme0n1 --asprimary --size=40000 --grow
volgroup vg pv.01
logvol swap --hibernation --vgname=vg --name=swap
logvol / --vgname=vg --name=fedora-root --size=25000 --grow --fstype=xfs

# stuff to do after we are done
%post --log=/root/ks-post.log
# put commands here to run after install
# add sudo group to permit passwordless escalation
echo "%sudo ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
%end