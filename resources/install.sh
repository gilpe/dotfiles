#!/bin/bash

#   Script dependencies
echo -e "\n Installing \033[1m Gum \033[0m to run this awesome script..."
sudo pacman -S --noconfirm --needed gum


#Welcome title
gum style --faint "Welcome to..."
gum style \
    --border-foreground 85 \
    --border normal \
	--align center \
    --width 50 \
    --margin "1" \
    --padding "1 2" \
	"$(gum style --bold --foreground 85 "Gilpe")'s package installer and dotfile setter" "for a new workstation"


#Continue confirm
echo -e "\n A bunch of packages will be downloaded and also the existing configuration dotfiles could be overwritten."
if gum confirm "Are you really sure to go on?" ;then
    :
else
    gum style "See $(gum style --bold --foreground 85 "you")!"
    exit
fi


#Repository Update
gum spin --spinner dot --title "Updating base..." -- sleep 3
sudo pacman -Syu


#Packages install
gum spin --spinner dot --title "Installing packages..." -- sleep 3
_installPackages "${pkgs[@]}";
dotnet tool install --global Chickensoft.GodotEnv

gum spin --spinner dot --title "Installing AUR packages..." -- sleep 3
_installYay()
_installPackagesYay "${aur_pkgs[@]}";


#VM additional packages install
echo -e "\n Is this a virtual machine."
if gum confirm "Is this a virtual machine?" ;then
    gum spin --spinner dot --title "Installing VM additional packages..." -- sleep 3
    _installPackages "${vm_pkgs[@]}";
fi


#Dotfiles download
gum spin --spinner dot --title "Downloading configuration dotfiles..." -- sleep 3
git clone https://github.com/gilpe/dotfiles.git ~/.dotfiles


#Dotfiles stow
echo -e "\n Packages and dotfiles are downloaded!"
if gum confirm "Do you wanna replace the existing configuration files? $(gum style --faint "(If not you can do it later manually)")" ;then
    gum spin --spinner dot --title "Stowing dotfiles..." -- sleep 3
    cd ~/.dotfiles
    stow .
fi


#Reboot
echo -e "\n A reboot is needed for some changes to take effect."
if gum confirm "Do you want to reboot your system now?" ;then
    gum style "See $(gum style --bold --foreground 85 "you")!"
    gum spin --spinner dot --title "Rebooting now..." -- sleep 3
    systemctl reboot
fi

exit