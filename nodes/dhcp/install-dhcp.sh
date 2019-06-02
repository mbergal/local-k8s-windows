sudo apt-get update
sudo apt-get install isc-dhcp-server -y

cp /vagrant/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
cp /vagrant/dhcp/etc/network/interfaces /etc/network/interfaces

sudo systemctl start isc-dhcp-server.service