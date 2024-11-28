#!/bin/bash

# Prerequisite
# Run Cloud Shell Preparation first

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

# Copy FastAPI to repository
cp -rT python-fastapi ~/ncd24-fastapi
cd ~/ncd24-fastapi/
git add .
git commit -m "feat: first initial"
git push -u origin main

echo ""
echo "============================================================="
echo "Congratulation: running setup Kind Kubernetes cluster has been completed"
echo "============================================================="
