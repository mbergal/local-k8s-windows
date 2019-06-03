set -x
set VAGRANT_DEFAULT_PROVIDER=hyperv
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -q -y -u  -o Dpkg::Options::="--force-confdef" --allow-downgrades --allow-remove-essential --allow-change-held-packages --allow-change-held-packages --allow-unauthenticated
sudo apt-get install -y apt-transport-https apt-transport-https ca-certificates curl gnupg-agent software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

echo "Installing local Docker registry certificate..."
sudo mkdir -p /etc/docker/certs.d/registry.k8s.local
cp /vagrant/registry.local.crt  /etc/docker/certs.d/registry.k8s.local/ca.crt
echo "...done"
