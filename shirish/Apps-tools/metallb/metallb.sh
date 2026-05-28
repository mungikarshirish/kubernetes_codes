#!/bin/bash
#Metallb v0.16.0
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/refs/heads/main/config/manifests/metallb-native.yaml
kubectl apply -f metallb-config.yaml
kubectl rollout restart deployment controller -n metallb-system
kubectl rollout status deployment controller -n metallb-system
sleep 5
kubectl get namespace metallb-system