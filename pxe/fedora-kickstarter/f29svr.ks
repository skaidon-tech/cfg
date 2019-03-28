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

# create sudo group
group --name=sudo --gid=4999

# create admin user
user --name=nodectl --uid=5000 --gid=5000 --groups=sudo --iscrypted --password=$6$NVeVElwTvav6t1hh$BqeQo9zJghDsv1GtPVvcTiOwLgiljR9hwbIMAnHP/KEEQQc1nZIinEPYcJJotn5uAz8y0I0LYHC8joowBd4jk0

# setup authorized_keys for nodectl user
sshkey --username=nodectl "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvzMWWQ3zPwfTClFDE4+oYxWZNhFXJsDUKfXoghlA0X2YEBivS/Q4MdzvV6F5xZ3jkqLUCsdAwZyoQbCpJgoToj9fQkZPyi03JTvFUPJ8xGCKQcd56X7ZuCqut0bBLD7gpqQQzTVUiNXHbA84XWRGk5FQZJN8xDVoRmpm7I552X2EdNf3MFoLDyilBSjqzd/MKsdH6lG9JusqPC/oDqnnE8aS8KCtNkAvSqZsUSlMo0ZGpdELAsZVs98QCszDsUIvchtc39GNvKdzoGsoq8z5Qg0+ASdwN3YMYip3dJRKijvMJiQNYj//p4y5JbhJFdzAtmrg7wT67nldNOz4Eg1sx nodectl@delvin-vm-f29svr"

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

