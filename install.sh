#!/bin/bash

echo "__________________________________________________Updating base system"
sudo pacman -Syu

echo "__________________________________________________Installing new packages"
sudo pacman -S --noconfirm --needed git

echo "__________________________________________________Installing AUR helper"
cd ~/Downloads
git clone https://aur.archlinux.org/yay.git
cd ~/Downloads/yay
makepkg -si
cd ~
rm ~/Downloads/yay -fr

echo "__________________________________________________Install AUR packages"
yay -S --noconfirm --needed zsh alacritty stow visual-studio-code-bin firefox fastfetch ttf-jetbrains-mono-nerd 

echo "__________________________________________________Setting new shell"
chsh -s /bin/zsh

echo "__________________________________________________Stowing dotfiles"
git clone https://github.com/gilpe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .

exit
