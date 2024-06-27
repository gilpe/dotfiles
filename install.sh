#!/bin/bash

echo "Updating base system..."
pacman -Syu
read -p "Hit enter to continue..."

echo "Installing new packages..."
pacman -S --noconfirm --needed git
read -p "Hit enter to continue..."

echo "Installing AUR helper..."
cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd ~/Downloads/yay
makepkg -si
cd ~
rm ~/Downloads/yay -fr
read -p "Hit enter to continue..."

echo "Install AUR packages..."
yay -S --noconfirm --needed zsh alacritty stow visual-studio-code-bin firefox fastfetch ttf-jetbrains-mono-nerd 
read -p "Hit enter to continue..." 

echo "Setting new shell..."
chsh -s /bin/zsh
read -p "Hit enter to continue..."

echo "Stowing dotfiles..."
git clone https://github.com/gilpe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .
read -p "Hit enter to continue..."

exit
