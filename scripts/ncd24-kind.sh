#!/bin/bash

# Prerequisite
# Create DNS *.ncd24 A 127.0.0.1

set -e

# Create Kind Kubernets Cluster
kind create cluster

# Update Helm repository
helm repo update

# Install MetalLB for Load Balancer
helm repo add metallb https://metallb.github.io/metallb
helm upgrade --install --create-namespace --namespace metallb-system \
  metallb metallb/metallb --version 0.14.8
kubectl apply -f k8s/manifests/metallb-ippool.yaml

# Install Ingress Nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx





echo ""
echo "============================================================="
echo "Congratulation: running preparation script has been completed"
echo "============================================================="
