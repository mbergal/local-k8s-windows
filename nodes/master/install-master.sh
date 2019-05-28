set -x
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 > /vagrant/kubeadm-join
echo "Creating /vagrant/kubeadm-join.sh"
cat /vagrant/kubeadm-join
cat /vagrant/kubeadm-join | python /vagrant/master/extract-kubeadm-join.py > /vagrant/kubeadm-join.sh
cat /vagrant/kubeadm-join.sh
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf /vagrant/config
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo sysctl net.bridge.bridge-nf-call-iptables=1
kubectl apply -f /vagrant/master/kube-flannel.yml
kubectl patch ds/kube-flannel-ds-amd64 --patch "$(cat /vagrant/master/node-selector-patch.yaml)" -n=kube-system
