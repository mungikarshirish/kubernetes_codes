#!/bin/bash
echo "Creating Monitoring namespace"
kubectl apply -f namespace.yaml
echo "Creating Grafana Service loadbalancer"
kubectl apply -f grafana-service-lb.yaml
echo "Creating Grafana Deployment"
kubectl apply -f grafana-deployment.yaml
echo "Creating Prometheus config"
kubectl apply -f prometheus-config.yaml
echo "Creating Prometheus Service loadbalancer"
kubectl apply -f prometheus-service-lb.yaml
echo "Creating Prometheus Deployment"
kubectl apply -f prometheus-deployment.yaml
sleep 10
kubectl get all -A | grep monitoring
sleep 10