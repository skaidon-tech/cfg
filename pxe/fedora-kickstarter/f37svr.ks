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
user --name=nodectl --uid=5000 --gid=5000 --groups=sudo --iscrypted --password=grub.pbkdf2.sha512.10000.037688B45359F97DA12675FCC3A9FD334493B362F7ACFF2E23FF8299D9B59CB872BFD037F7B083AF9EEEFC5499D1EEB6FB129C80EA2F2B5A48E521428D45C057.8B6BEDBD32549A31CA48A8916D3B233A5A8128B1BD7F9B7A847F0BEBE3D278657229250B38D61610D8359735F3AE458F8B5196814517919E4077C2D7ACB114D3

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
