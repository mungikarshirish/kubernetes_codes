#ts for calico and coredns$

kubectl rollout restart daemonset calico-node -n kube-system
kubectl -n kube-system rollout restart deployment/coredns

crictl commands (verify endpoints then run commands)
sudo crictl ps 
sudo crictl images
sudo crictl pods
sudo crictl inspects container ID / POD ID 

node troubleshooting 
kubectl describe node <node names> / type like pod  etc .....

sudo ls -lrt /var/log
sudo journalctl -u kubelet / service status too for TS

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

create static pods

kubectl run staticpod - image=nginx --dry-run=client -o yaml > staticpod.yamll (save config as yaml file)
move this file to /etc/kubernetes/manifeasts/ 