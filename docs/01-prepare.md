# Prerequisites

## All-in-one preparation command

```bash
# Login to GitHub
gh auth login --hostname github.com --git-protocol ssh --skip-ssh-key --web --scopes admin:public_key

# Run Cloud Shell Preparation
cd
git clone https://github.com/opsta/ncd24-devsecops-workshop.git
cd ~/ncd24-devsecops-workshop/scripts/
./cloud-shell-prepare-ncd24.sh

# Exit from cloudshell terminal and reopen again
exit
```

## Set Tabsize

* Click on Setting Icon on the left > `Settings`
* Put `tabsize` in `Search settings`
* Change `Tab Size` from `4` to `2`

## Setup DevOps environment

```bash
cd ~/ncd24-devsecops-workshop/scripts/
./ncd24-kind.sh
```

## Reset Cloud Shell

In case your Cloud Shell having problem and you want to remove all the data to reset Cloud Shell

* Put this command to remove all the files in your $HOME directory

```bash
sudo rm -rf $HOME
```

* Click on `vertical three dot` icon on the top right for more menu and choose `Restart`

## Navigation

* [Home](../README.md)
* Next: [DevOps Workshop](02-devops.md)
