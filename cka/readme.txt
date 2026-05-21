git repo: https://github.com/sandervanvugt/cka.git
git clone https://github.com/sandervanvugt/cka

from cka folder
#Install CRI
sudo ./setup-container.sh: all 3 nodes

#Install Kubetools
sudo ./setup-kubetools.sh: all 3 nodes

install crictl
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.35.0/crictl-v1.35.0-linux-arm64.tar.gz : x86 or arm64?
sudo tar zxvf rictl-v1.35.0-linux-arm64.tar.gz -C /usr/local/bin
rm -rf crictl-v1.35.0-linux-arm64.tar.gz
cp /cka/crictl.yaml /etc/crictl.yaml

#Install cluster so need to run on controller only
sudo kubeadm config images pull
sudo kubeadm init 
wait for complet 

#Setup client on cp 
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get all - A (verify kubecluster on control VM)

#Install Network Add-on on cp

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
or
kubectl replace --force -f https://docs.projectcalico.org/manifests/calico.yaml
on control
view cluster config
kubectl config view

#if join token get expired need to use From control to get token:
sudo kubeadm token create --print-join-command

on both node run command to join cluster
sudo kubeadm join ip:6443 --token qw7f19.4hlfjnljkt4ho4j6 \
	--discovery-token-ca-cert-hash sha256:8031c2f2a9dbfe4516b98977bcc70247447abc7c86854435731a64509f137e11
ts

kubectl -n kube-system rollout restart deployment/coredns
kubectl rollout restart daemonset calico-node -n kube-system

crictl commands
create static pods
node states and services

deploy Kubernetes Metrics Server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl logs commands
edit Kubernetes Metrics Server deployment and add insecure tls
kubectl edit -n kube-system deployment.apps metrics-server
   spec:
     - aggs
       - --kubelet-insecure-tls

etcd backup

