#!/bin/bash

echo -e "\n UPDATING BASE \n"
sudo pacman -Syu

echo -e "\n INSTALLING PRE-REQS \n"
sudo pacman -S --noconfirm --needed git

echo -e "\n INSTALLING AUR HELPER \n"
git clone https://aur.archlinux.org/yay.git ~/.yay
cd ~/.yay
makepkg -si
cd ~
rm ~/.yay -fr

echo -e "\n INSTALLING AUR PACKAGES \n"
yay -S --noconfirm --needed zsh alacritty stow visual-studio-code-bin firefox fastfetch ttf-jetbrains-mono-nerd 

echo -e "\n CHANGING SHELL \n"
sudo chsh -s /bin/zsh

echo -e "\n STOWING FILES \n"
git clone https://github.com/gilpe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .

exit
