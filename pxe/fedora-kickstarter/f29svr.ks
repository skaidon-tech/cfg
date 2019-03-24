#platform=x86, AMD64, or Intel EM64T
#version=DEVEL

# Firewall configuration
firewall --disabled

# specify location of packages
url --url="ftp://192.168.3.146/os_images/Fedora-Server-dvd-x86_64-29-1.2"

# Root password
rootpw --iscrypted $6$p522YzH0mV8MdojZ$p1ZnTOmW7RDWiepEFSdZWftt6pJ9iAmBQZ1xHmWitANejQUABr843JQdKZ7zuYy7P2O1.77a/F6QM8vXHBZQY/

# System authorization information
auth useshadow passalgo=sha512

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
python3
%end

#%addon com_redhat_kdump --enable --reserve-mb='auto'
%addon com_redhat_kdump --disable
%end

