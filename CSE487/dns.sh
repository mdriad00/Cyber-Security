#! /bin/bash
ip addr
ip route
named -v
cd /etc/bind
echo $PWD
ls
hostnamectl status
gedit /etc/hosts

hostname
dnsdomainname
hostname --fqdn
cp named.conf.options named.conf.options.orig
nano named.conf.options

cp named.conf.local named.conf.local.orig
gedit named.conf.local

named-checkconf
ls
echo $PWD
cp db.local db.ewucampuswifi.com
gedit db.ewucampuswifi.com

named-checkzone ewucampuswifi.com db.ewucampuswifi.com
cp db.127 db.10.20.172
gedit db.10.20.172

named-checkzone 10.20.172.in-addr.arpa db.10.20.172
named-checkconf
named-checkzone ewucampuswifi.com db.ewucampuswifi.com
named-checkzone 10.20.172.in-addr.arpa db.10.20.172
service bind9 restart

nslookup www.ewucampuswifi.com
rm /etc/resolv.conf
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
gedit /etc/resolv.conf

nslookup www.ewucampuswifi.com
ping www.ewucampuswifi.com
echo $PWD
$SHELL














