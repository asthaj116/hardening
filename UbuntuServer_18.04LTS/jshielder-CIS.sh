#!/bin/bash
echo -e ""
echo -e "Disabling unused filesystems"
echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install vfat /bin/true" >> /etc/modprobe.d/CIS.conf
echo -e ""
echo -e "Setting Sticky bit on all world-writable directories"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t
clear
echo -e ""
echo -e "Installing and configuring AIDE"
apt-get install aide
aideinit
echo "* hard core 0" >> /etc/security/limits.conf
cp templates/sysctl-CIS.conf /etc/sysctl.conf
sysctl -e -p
apt-get update
apt-get -y upgrade
apt-get remove telnet
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/g' /etc/default/grub
update-grub
clear
f_banner
echo -e ""
echo -e "Setting hosts.allow and hosts.deny"
clear
f_banner
echo -e ""
echo -e "Disabling uncommon Network Protocols"
echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf
clear
echo -e ""
# echo -e "Setting up Iptables Rules"
# sh templates/iptables-CIS.sh
# cp templates/iptables-CIS.sh /etc/init.d/
# chmod +x /etc/init.d/iptables-CIS.sh
# ln -s /etc/init.d/iptables-CIS.sh /etc/rc2.d/S99iptables-CIS.sh
echo -e ""
# echo -e "Installing and configuring Auditd"
# apt-get install auditd -y
# cp templates/auditd-CIS.conf /etc/audit/auditd.conf
# systemctl enable auditd
# sed -i 's/GRUB_CMDLINE_LINUX="ipv6.disable=1"/GRUB_CMDLINE_LINUX="ipv6.disable=1\ audit=1"/g' /etc/default/grub
# cp templates/audit-CIS.rules /etc/audit/audit.rules
# find / -xdev \( -perm -4000 -o -perm -2000 \) -type f | awk '{print \
# "-a always,exit -F path=" $1 " -F perm=x -F auid>=1000 -F auid!=4294967295 \
# -k privileged" } ' >> /etc/audit/audit.rules
# echo " " >> /etc/audit/audit.rules
# echo "#End of Audit Rules" >> /etc/audit/audit.rules
# echo "-e 2" >>/etc/audit/audit.rules
# cp /etc/audit/audit.rules /etc/audit/rules.d/audit.rules
chmod -R g-wx,o-rwx /var/log/*
chown root:root /etc/cron*
chmod og-rwx /etc/cron*
touch /etc/cron.allow
touch /etc/at.allow
chmod og-rwx /etc/cron.allow /etc/at.allow
chown root:root /etc/cron.allow /etc/at.allow
# for user in `awk -F: '($3 < 1000) {print $1 }' /etc/passwd`; do
#   if [ $user != "root" ]; then
#     usermod -L $user
#   if [ $user != "sync" ] && [ $user != "shutdown" ] && [ $user != "halt" ]; then
#     usermod -s /usr/sbin/nologin $user
#   fi
#   fi
# done
sed -i s/umask\ 022/umask\ 027/g /etc/init.d/rc
echo -e ""
echo -e "Setting System File Permissions"
chown root:root /etc/passwd
chmod 644 /etc/passwd
chown root:shadow /etc/shadow
chmod o-rwx,g-wx /etc/shadow
chown root:root /etc/group
chmod 644 /etc/group
chown root:shadow /etc/gshadow
chmod o-rwx,g-rw /etc/gshadow
chown root:root /etc/passwd-
chmod 600 /etc/passwd-
chown root:root /etc/shadow-
chmod 600 /etc/shadow-
chown root:root /etc/group-
chmod 600 /etc/group-
chown root:root /etc/gshadow-
chmod 600 /etc/gshadow-
