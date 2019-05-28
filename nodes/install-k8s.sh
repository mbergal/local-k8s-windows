set -x
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo echo >> /etc/apt/sources.list.d/kubernetes.list
sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y && apt-get install -y kubelet kubeadm kubectl
sudo sed -i.bak '/swap/d' /etc/fstab
sudo swapoff -a
