#!/bin/bash

# Prerequisite
# Create DNS *.ncd24 A 127.0.0.1

set -e

# Update code to latest
git -C ../ pull

# Delete and create Kind Kubernets Cluster
kind delete cluster
kind create cluster --config kind.yaml

# Update Helm repository
helm repo update

# Install ArgoCD
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install --create-namespace --namespace argocd --wait \
  argocd argo/argo-cd --version 7.7.6 -f k8s/helm/argocd-values.yaml
ARGOCD_PASSWORD=$(kubectl --namespace argocd get secrets argocd-initial-admin-secret --template={{.data.password}} | base64 --decode)

echo ""
echo "============================================================="
echo "Congratulation: running setup Kind Kubernetes cluster has been completed"
echo "============================================================="
