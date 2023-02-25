#!/usr/bin/env bash

function installPackage() {
  local _apps=($1)
  if [[ $# -eq 1 ]]; then
    local _installBlock="sudo pacman -S --needed --noconfirm - "
  else
    local _installBlock="$2"
  fi

  for key in ${!_apps[@]}; do
    eval $_installBlock ${_apps[$key]}
  done
}

function packagesManagers(){
  echo "---- Installing Packages Managers ----"

  git clone https://aur.archlinux.org/yay.git ~/PackagesManagers/yay 
  pushd ~/PackagesManagers/yay
  makepkg -si
  popd
  
  git clone https://aur.archlinux.org/snapd.git ~/PackagesManagers/snapd 
  pushd ~/PackagesManagers/snapd 
  makepkg -si
  popd
}

function configurePackagesManagers(){
  sudo systemctl enable --now snapd.socket
  sudo ln -s /var/lib/snapd/snap /snap
}

function fontsInstall(){
  echo "---- Installing Fonts ----"
  mkdir -p ~/.local/share/fonts
  mkdir -p ~/.local/fonts/MesloLGS/
  
  pushd ~/.local/share/fonts
  curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
  popd
  
  pushd ~/.local/fonts/MesloLGS/
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
  popd
}

function configureZshAndTheme(){
  #set zsh shell for my user
  chsh --shell $(which zsh)

  echo "------- OhMyZsh installing ------"
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  
  sudo sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
  echo "------- OhMyZsh installing powerlevel10k ------"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull
  
  local _zshPlugins="(git zsh-autosuggestions zsh-syntax-highlighting asdf nvm node docker)"
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  sudo sed -i "s/^plugins=.*/plugins=$_zshPlugins/" ~/.zshrc
  echo "!!!!!logout/login system to works!!!!"
}