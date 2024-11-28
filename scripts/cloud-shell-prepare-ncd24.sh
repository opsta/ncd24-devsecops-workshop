#!/bin/bash

set -e

# Update code to latest
git -C ../ pull

cd $HOME

# Initial git config
git config --global user.name "$USER"
git config --global user.email "$USER_EMAIL"
git config --global init.defaultBranch "main"
git config --global pull.rebase false

# Generate SSH
if [[ ! -f ~/.ssh/id_rsa ]]; then
  echo "Generate SSH key in ~/.ssh/id_rsa"
  ssh-keygen -f ~/.ssh/id_rsa -N ""
else
  echo "Skipped generate SSH key"
fi

# Add .local/bin path
mkdir -p $HOME/.local/bin
if ! grep -q '$HOME/.local/bin' ~/.profile; then
  echo "Adding ~/.local/bin path"
  cat <<'EOF' >> ~/.profile

if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
EOF
else
  echo "Skipped adding ~/.local/bin path"
fi

# Install Kind
export KIND_DLVERSION=0.25.0
if ! kind version | grep ${KIND_DLVERSION}; then
  echo "Install Kind ${KIND_DLVERSION}"
  wget https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_DLVERSION}/kind-linux-amd64
  chmod +x kind-linux-amd64
  mv kind-linux-amd64 ${HOME}/.local/bin/kind
else
  echo "Skipped install Kind ${KIND_DLVERSION} since it is already installed"
fi

# Add SSH Public Key to GitHub
gh ssh-key add -t "cloud-shell $USER_EMAIL" ~/.ssh/id_rsa.pub
if [ ! -n "$(grep "^github.com " ~/.ssh/known_hosts)" ]; then
  echo "Add github.com to known_host"
  ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
else
  echo "Skipped adding github.com to known_hosts since it is already exists."
fi

# Create GitHub Repository
gh repo create --description "National Coding Day 2024 DevSecOps Workshop FastAPI Application" \
  --public --clone ncd24-fastapi \
  || echo "Skipped creating GitHub FastAPI repository since it is already exists."
gh repo create --description "National Coding Day 2024 DevSecOps Workshop ArgoCD for GitOps" \
  --public --clone ncd24-gitops \
  || echo "Skipped creating GitHub GitOps repository since it is already exists."

# Create SSH deploy key for GitOps
if [[ ! -f ~/ncd24-deploy-key/id_rsa ]]; then
  echo "Generate SSH deploy key"
  mkdir -p ~/ncd24-deploy-key/
  ssh-keygen -f ~/ncd24-deploy-key/id_rsa -N ""
else
  echo "Skipped generate SSH deploy key"
fi

# Add deploy-key to GitOps repository
gh repo deploy-key add --allow-write --title "ncd24 gitops" \
  --repo $(gh api user -q ".login")/ncd24-gitops ~/ncd24-deploy-key/id_rsa.pub \
  || echo "Skipped adding SSH deploy key to GitOps repository since it is already exists."

# Add private key to secret variable in fastapi repository
cat ~/ncd24-deploy-key/id_rsa \
  | gh secret set --repo $(gh api user -q ".login")/ncd24-fastapi \
  --app actions GITOPS_DEPLOY_KEY

echo ""
echo "============================================================="
echo "Congratulation: running preparation script has been completed"
echo "============================================================="
