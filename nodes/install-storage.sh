apt-get-update
apt install -y nfs-kernel-server
mkdir -p /mnt/sharedfolder
chown nobody:nogroup /mnt/sharedfolder
chmod 777 /mnt/sharedfolder

echo "/mnt/sharedfolder  0.0.0.0/0(rw,sync,no_subtree_check)" >  /etc/exports
exportfs -a
systemctl restart nfs-kernel-server
ufw allow from 0.0.0.0/0 to any port nfs

