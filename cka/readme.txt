git repo: https://github.com/sandervanvugt/cka.git
git clone https://github.com/sandervanvugt/cka

from cka folder
#Install CRI
sudo ./setup-container.sh: all 3 nodes

#Install Kubetools
sudo ./setup-kubetools.sh: all 3 nodes

#Install cluster so need to run on controller only
sudo kubeadm init 
wait for complet 

#Setup client
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get all (verify kubecluster on control VM)

#Install Network Add-on
original
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
or
kubectl replace --force -f https://docs.projectcalico.org/manifests/calico.yaml
on control
view cluster config
kubectl config view


#if join token get expired need to use From control to get token:
sudo kubeadm token create --print-join-command

on both node run command to join cluster
sudo kubeadm join 192.168.15.150:6443 --token qw7f19.4hlfjnljkt4ho4j6 \
	--discovery-token-ca-cert-hash sha256:8031c2f2a9dbfe4516b98977bcc70247447abc7c86854435731a64509f137e11
After restart
kubectl -n kube-system rollout restart deployment/coredns
kubectl rollout restart daemonset calico-node -n kube-system
 
