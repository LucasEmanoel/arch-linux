#!/usr/bin/env bash
source ./utils.sh

function basePackages(){
  echo "---- Installing Base Packages ----"
  installPackage "$(cat packages/base.list)"
}


function personalPackages(){
  echo "---- Installing My Personal Packages ----"
  installPackage "$(cat packages/snap-classic.list)" "sudo snap install --classic"
  installPackage "$(cat packages/snap.list)" "sudo snap install"
  yay -S --needed --noconfirm - < packages/yay.list
}

function devOpsPackages(){
  #using pacman
  installPackage "$(cat packages/devops.list)"
}

function configureDockerAndKubernetes(){
  #run commands without sudo
  usermod -aG libvirt $(whoami)
  usermod -aG docker $(whoami)
  
  #set driver minikube
  minikube config set driver kvm2
  
  #start services
  sudo systemctl enable --now libvirtd.service
  sudo systemctl enable --now docker.service
}

function main() {
  basePackages
  packagesManagers
  configurePackagesManagers
  personalPackages
  dockerAndKubernetes
  fontsInstall
  configureZshAndTheme
}

main
