git repo: https://github.com/sandervanvugt/cka.git
git clone https://github.com/sandervanvugt/cka

from cka folder
sudo ./setup-container.sh: all 3 nodes
sudo ./setup-kubetools.sh: all 3 nodes

only on controller
sudo kubeadm init 
make a note of discovery-token for node to join the cluster
(kubeadm join 192.168.15.150:6443 --token qw7f19.4hlfjnljkt4ho4j6 \
	--discovery-token-ca-cert-hash sha256:8031c2f2a9dbfe4516b98977bcc70247447abc7c86854435731a64509f137e11)
wait for complet 
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get all (verify kubecluster on control VM)
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.3/manifests/calico.yaml

on both node run command to join cluster
sudo kubeadm join 192.168.15.150:6443 --token qw7f19.4hlfjnljkt4ho4j6 \
	--discovery-token-ca-cert-hash sha256:8031c2f2a9dbfe4516b98977bcc70247447abc7c86854435731a64509f137e11
if join token get expaired need to use 
sudo kubeadm token create --print-join-command
on control
kubectl get nodes

on control
view cluster config
kubectl config view
