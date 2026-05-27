create 3 ubuntu (22 =<)

%sudo   ALL=(ALL:ALL) NOPASSWD: ALL

disable swap
sudo swapoff -a
sudo sed -i '/\bswap\b/s/^/#/' /etc/fstab
free -h

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
sudo cp /cka/crictl.yaml /etc/crictl.yaml

sudo apt update
etcd install -> etcdinstall.sh
etcdctl version
etcdutl version

#create cluster so need to run on controller only
sudo kubeadm config images pull
sudo kubeadm init 
kube init config ?

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


#ts for calico and coredns$

kubectl rollout restart daemonset calico-node -n kube-system
kubectl -n kube-system rollout restart deployment/coredns


node troubleshooting 

kubectl describe node <node names>

sudo ls -lrt /var/log
sudo journalctl -u kubelet

crictl commands
sudo crictl ps 
sudo crictl images
sudo crictl pods
sudo crictl inspects container ID / POD ID 


create static pods

kubectl run staticpod - image=nginx --dry-run=client -o yaml > staticpod.yamll (save config as yaml file)
move this file to /etc/kubernetes/manifeasts/ 

node states and services

kubectl cordon : mark node as unschedulable
kubectl drain : unschedulable + remove all running pods, pods from daemonset will not get removed so need to use kubectl drain --ignore-daemonsets
  • Add --delete-emptydir-data to delete data from emptyDir Pod volumes
kubectl describe node "nodename" verify taints status

kubectl uncordon (for both above)

node services
kubelet and containered ( )
ps aux grep above services
kubectl describe node "nodename" verify taints status and conditions 


deploy Kubernetes Metrics Server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl logs commands
kubectl describe pod metrics-server -n kube-system
kubectl logs -n kube-system metrics-server-b4c746d8b-g7r5b
edit Kubernetes Metrics Server deployment and add insecure tls
kubectl edit -n kube-system deployment.apps metrics-server
   spec:
     - aggs
       - --kubelet-insecure-tls
kubectl top pod/node

Metallb v0.16.0
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/refs/heads/main/config/manifests/metallb-native.yaml
kubectl apply -f metallb-config.yaml

kubectl create deployment test-nginx --image=nginx --port=80
kubectl expose deployment test-nginx --type=LoadBalancer --port=80

kubectl delete service test-nginx
kubectl delete deployment test-nginx


etcd backup
etcdctl version
etcdutl version

sudo etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save etcd-backup.db

create copy so we have snapshot backup
verify 
sudo etcdutl --write-out=table snapshot status /home/student/etcd-backup.db

procedure to restore snapshot db

Move Statis Pod Manifests
sudo mv /etc/kubernetes/manifests/*.yaml /etc/kubernetes/

sudo crictl ps

sudo mv /var/lib/etcd /var/lib/etcd-old (if you have data, when practicing)

sudo etcdutl --data-dir /var/lib/etcd-backup snapshot restore etcd-backup.db

edit etcd.yaml from /tmp dir and update db dir path in following
  under command from spec
  volumemount: volume path
  volume:host path

move etcd.yaml from /tmp to /etc/kubernetes/Manifests
wait to up and running etcd pod
move api yaml wait for up and running 
move remaining both file (controller and scheduler)
sudo crictl ps
kubectl get deploy -A
you should have all your deployments / secrets / lb everything 

Upgrade Cluster (cp, and worker) follow k.io/docs for specific ver (from - to)
  1st cp
  update repo (specific version)
  Determine which version to upgrade to
  Upgrade kubeadm
  sudo kubeadm upgrade plan
  sudo kubeadm upgrade apply v1.x.x
  upgrade network plugin if needed
  repeat process if you have multiple cp (sudo kubeadm upgrade node)
  Drain the node
  Upgrade kubelet and kubectl
  Restart the daemon-reload and kubelet
  Uncordon the node
  verify cp version
  2nd upgrade worker nodes
  update repo (specific version)
  Determine which version to upgrade to
  Upgrade kubeadm node
  Drain the node
  Upgrade kubelet and kubectl
  Restart the daemon-reload and kubelet
  Uncordon the node
  verify nd version
