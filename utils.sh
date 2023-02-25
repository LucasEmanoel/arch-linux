#!/usr/bin/env bash

function installManagerPackages(){
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
    git clone https://aur.archlinux.org/snapd.git && cd snapd && makepkg -si
}

function configurePackagesManagers(){

    sudo systemctl enable --now snapd.socket
    sudo ln -s /var/lib/snapd/snap /snap

}

function installPackages(){
    local _apps=($1)
    #verify if number args = 1
    if [[ $# -eq 1]]; then
        #--needed - dont reinstall packages up to date
        #--noconfirm - set yes for all
        local _installBlock="sudo pacman -S --needed --noconfirm"
    else
        local _installBlock="$2"
    fi

    for i in ${!_apps[@]}; do
        eval $_installBlock ${_apps[$i]}
    done

}

function basePackages(){
    #set multlib repository
    installPackage < packages/base.list

}


function personalPackages(){
    installPackage ""
}

function dockerAndKubernetes(){
    installPackage ""
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

