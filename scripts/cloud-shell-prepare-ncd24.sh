#!/bin/bash

# Prerequisite
# Create DNS *.ncd24 A 127.0.0.1

set -e

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
  cat <<'EOF' >> ~/.profile

if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi
EOF
else
  echo "Skipped adding ~/.local/bin path"
fi

# Install Kind
export KIND_DLVERSION=0.25.0
if ! glab version | grep ${KIND_DLVERSION}; then
  wget https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_DLVERSION}/kind-linux-amd64
  chmod +x kind-linux-amd64
  mv kind-linux-amd64 ${HOME}/.local/bin/kind
else
  echo "Skipped install Kind ${KIND_DLVERSION} since it is already installed"
fi

# Add SSH Public Key to GitHub
gh ssh-key add -t "cloud-shell $USER_EMAIL" ~/.ssh/id_rsa.pub
if [ ! -n "$(grep "^github.com " ~/.ssh/known_hosts)" ]; then
  ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
else
  echo "Skipped adding github.com to known_hosts since it is already exists."
fi

# Create GitHub Repository
gh repo create --description "National Coding Day 2024 DevSecOps Workshop" --public --clone ncd24-devsecops || echo "Skipped creating GitHub repository since it is already exists."

echo ""
echo "============================================================="
echo "Congratulation: running preparation script has been completed"
echo "============================================================="
