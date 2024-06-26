#!/bin/bash

echo -e "\n UPDATING BASE \n"
sudo pacman -Syu

echo -e "\n INSTALLING PRE-REQS \n"
sudo pacman -S --noconfirm --needed git zsh alacritty stow firefox fastfetch ttf-jetbrains-mono-nerd zoxide

echo -e "\n INSTALLING AUR HELPER \n"
git clone https://aur.archlinux.org/yay.git ~/.yay
cd ~/.yay 
makepkg -si --noconfirm
cd ~ 
rm ~/.yay -fr

echo -e "\n INSTALLING AUR PACKAGES \n"
yay -S --noconfirm --needed visual-studio-code-bin godot-mono-bin oh-my-posh fzf

echo -e "\n CHANGING SHELL \n"
chsh -s /bin/zsh

echo -e "\n STOWING FILES \n"
git clone https://github.com/gilpe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .

exit
