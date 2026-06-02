#!/bin/bash

# Exit immediately if any command fails
set -e

echo "📥 Downloading and applying Kubernetes Metrics Server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo "⏳ Waiting 5 seconds for deployment creation..."
sleep 5

echo "🔧 Patching Metrics Server to allow insecure TLS..."
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

echo "✅ Metrics Server successfully configured!"
Kubectl top nodes
sleep 10
kubectl top pods -A