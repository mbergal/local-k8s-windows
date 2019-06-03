set -e
apt-get update
apt-get install -y bind9 bind9utils bind9-doc emacs-nox mc

cp /vagrant/dhcp/etc/default/bind9  /etc/default/bind9
cp /vagrant/dhcp/etc/bind/named.conf.options /etc/bind/named.conf.options
cp /vagrant/dhcp/etc/bind/named.conf.local /etc/bind/named.conf.local
mkdir -p /etc/bind/zones
cp /vagrant/dhcp/etc/bind/zones/db.k8s.local  /etc/bind/zones/db.k8s.local
cp /vagrant/dhcp/etc/bind/zones/db.192.168.200   /etc/bind/zones/db.192.168.200 


named-checkconf
named-checkzone k8s.local /etc/bind/zones/db.k8s.local
named-checkzone 192.168.200 /etc/bind/zones/db.192.168.200

systemctl restart bind9
ufw allow Bind9




