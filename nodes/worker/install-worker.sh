set -x
sudo apt-get update
sudo apt-get install -y nfs-common
sudo sysctl net.bridge.bridge-nf-call-iptables=1
mkdir -p $HOME/.kube
sudo cp /vagrant/config $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo bash /vagrant/kubeadm-join.sh
