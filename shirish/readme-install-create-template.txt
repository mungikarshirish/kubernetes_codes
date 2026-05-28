create 1 ubuntu VM (22 =<)

%sudo   ALL=(ALL:ALL) NOPASSWD: ALL

disable swap
sudo swapoff -a
sudo sed -i '/\bswap\b/s/^/#/' /etc/fstab
free -h

sudo systemctl set-hostname <new hostname>
sudo /etc/netplan.50 (update ip)

passwd less ssh if needed (cp ha setup)
ssh key-gen 
ssh-copy-id <destnation ip>

git clone https://github.com/sandervanvugt/cka
git clone https://github.com/mungikarshirish/kubernetes_codes.git

from cka folder
#Install container
sudo systemctl status containerd 
sudo ./setup-container.sh: all 3 nodes 

#Install Kubetools
sudo systemctl status kubelet
sudo ./setup-kubetools.sh: all 3 nodes

install crictl
sudo crictl ps
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.35.0/crictl-v1.35.0-linux-arm64.tar.gz
sudo tar zxvf rictl-v1.35.0-linux-arm64.tar.gz -C /usr/local/bin
rm -rf crictl-v1.35.0-linux-arm64.tar.gz
sudo cp /cka/crictl.yaml /etc/crictl.yaml

etcdctl version
etcdutl version
sudo apt update
etcd install -> etcdinstall.sh

#create cluster so need to run on controller only
sudo kubeadm config images pull
save as template