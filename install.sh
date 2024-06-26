#!/bin/bash
echo "Updating packages..."
pacman -Syu

echo "Installing new packages..."
pacman -S --noconfirm --needed git zsh alacritty stow firefox fastfetch ttf-jetbrains-mono-nerd

echo "Setting new shell"
chsh -s /bin/zsh

echo "AUR helper"
cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm yay -r

echo "Install AUR packages"
yay -S visual-studio-code-bin 

echo "End post-configuration..."
