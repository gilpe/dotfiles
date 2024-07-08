#!/bin/bash

echo -e "\n UPDATING BASE \n"
sudo pacman -Syu

echo -e "\n INSTALLING PRE-REQS \n"
sudo pacman -S --noconfirm --needed git zsh alacritty stow firefox dotnet-runtime dotnet-sdk fastfetch ttf-jetbrains-mono-nerd zoxide github-cli

echo -e "\n INSTALLING AUR HELPER \n"
git clone https://aur.archlinux.org/yay.git ~/.yay
cd ~/.yay
makepkg -si --noconfirm
cd ~
rm ~/.yay -fr

echo -e "\n INSTALLING AUR PACKAGES \n"
yay -S --noconfirm --needed visual-studio-code-bin oh-my-posh fzf nautilus-bluetooth

echo -e "\n CHANGING SHELL \n"
chsh -s /bin/zsh

echo -e "\n STOWING FILES \n"
git clone https://github.com/gilpe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .

dotnet tool install --global Chickensoft.GodotEnv

exit
