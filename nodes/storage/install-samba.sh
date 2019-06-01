sudo apt-get update
sudo apt-get install -y samba

# not sure if next 2 lines are necessary
useradd storage
echo -e "storage\nstorage" | passwd storage

echo -e "storage\nstorage" | smbpasswd -a storage

cp /vagrant/storage/smb.conf /etc/samba

echo Restarting smbd...
sudo service smbd restart
echo ...done



