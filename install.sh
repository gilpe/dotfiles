#!/bin/bash

echo -e "\n ==>  UPDATING BASE \n"
sudo pacman -Syu

echo -e "\n ==> INSTALLING DEPENDENCIES \n"
#Base
sudo pacman -S --noconfirm --needed git stow dotnet-sdk
#AUR helper
git clone https://aur.archlinux.org/yay.git ~/.yay
cd ~/.yay
makepkg -si --noconfirm
cd ~
rm ~/.yay -fr
#VBox 
#sudo pacman -S --noconfirm --needed virutalbox-guest-utils foot

echo -e "\n ==> INSTALLING PACKAGES \n"
# terminal
sudo pacman -S --noconfirm --needed zsh stow fastfetch ghostty yazi zoxide fzf btop
yay -S --noconfirm --needed oh-my-posh
# Windows manager
sudo pacman -S --noconfirm --needed hyprland polkit-kde-agent qt5-wayland qt6-wayland xdg-desktop-portal-hyprland hyprlock waybar dunst grim slurp wofi
yay -S --noconfirm --needed hyprshot hypridle
# Development
sudo pacman -S --noconfirm --needed git neovim dotnet-runtime github-cli
dotnet tool install --global Chickensoft.GodotEnv
yay -S --noconfirm --needed rider
# Fonts
sudo pacman -S --noconfirm --needed ttf-jetbrains-mono-nerd ttf-font-awesome
# Utils
sudo pacman -S --noconfirm --needed firefox obsidian

echo -e "\n ==> CHANGING SHELL \n"
chsh -s /bin/zsh
echo $SHELL

echo -e "\n ==> STOWING DOTFILES \n"
git clone https://github.com/gilpe/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .

echo -e "\n ==>  EOF \n"

exit
