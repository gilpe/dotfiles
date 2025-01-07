#!/bin/bash

#---------------#
#   Declares    #
#---------------#

pkgs=(
    "zsh"
    "git"
    "base-devel" 
    "stow"
    "dotnet-sdk"
    "dotnet-runtime"
    "hyprland"
    "waybar"
    "wofi"
    "ghostty"
    "zoxide"
    "fzf"
    "htop"
    "dunst"
    "yazi"
    "grim"
    "slurp"
    "xdg-desktop-portal-hyprland"
    "qt5-wayland"
    "qt6-wayland"
    "pipewire"
    "wireplumber"
    "hyprpaper"
    "hyprlock"
    "firefox"
    "ttf-font-awesome"
    "ttf-jetbrains-mono-nerd"
    "neovim"
    "fastfetch"
    "gtk4"
    "obsidian"
    "github-cli"
)
aur_pkgs=(
    "uwsm"
    "oh-my-posh"
    "hypridle"
    "hyprshot"
    "rider"
)
vm_pkgs=(
    "virtualbox-guest-utils"
    "foot"
)

#--------------#
#   Methods    #
#--------------#

# Check if param package is installed
_isInstalled() 
{
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #true
        return;
    fi
    echo 1; #false
    return;
}

# Install param packages
_installPackages() 
{
    toInstall=();
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi
        toInstall+=("${pkg}");
    done
    if [[ "${toInstall[@]}" == "" ]] ; then
        return;
    fi
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman -S --noconfirm --needed "${toInstall[@]}";
}

# Install param AUR packages
_installPackagesYay() 
{
    toInstall=();
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi
        toInstall+=("${pkg}");
    done

    if [[ "${toInstall[@]}" == "" ]] ; then
        return;
    fi
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    yay -S --noconfirm --needed "${toInstall[@]}";
}

# Install Yay if it's not yet
_installYay() {
    if sudo pacman -Qs yay > /dev/null ; then
        echo "yay is already installed!"
    else
        echo "yay is not installed. Will be installed now!"
        _installPackages "base-devel"
        SCRIPT=$(realpath "$0")
        temp_path=$(dirname "$SCRIPT")
        echo $temp_path
        git clone https://aur.archlinux.org/yay.git ~/.yay
        cd ~/.yay
        makepkg -si --noconfirm
        cd $temp_path
        rm ~/.yay -rf
        echo "yay has been installed successfully."
    fi
}

#-----------#
#   Main    #
#-----------#

# Script dependencies intall
if [[ $(_isInstalled "gum") == 1 ]]; then
    echo -e "\n Installing \033[1mGum \033[0mto run this awesome script...";
    sudo pacman -S --noconfirm --needed gum;
fi

# Welcome title display
echo -e
gum style --faint "Welcome to...";
gum style \
    --border-foreground 85 \
    --border normal \
	--align center \
    --width 50 \
    --padding "1 2" \
	"$(gum style --bold --foreground 85 "Gilpe")'s package installer and dotfile setter" "for a new workstation";

# Continue prompt
echo -e "\n A bunch of packages will be downloaded and also the existing configuration dotfiles could be overwritten.";
if gum confirm "Are you really sure to go on?" ;then
    :
else
    echo -e;
    gum style "See $(gum style --bold --foreground 85 "you")!";
    exit;
fi

# System pre-update
gum spin --spinner dot --title "Updating base..." -- sleep 3;
sudo pacman -Syu;

# Packages install
gum spin --spinner dot --title "Installing packages..." -- sleep 3;
_installPackages "${pkgs[@]}";
if [[ $(_isInstalled "dotnet-sdk") == 0 ]]; then
    export PATH="$PATH:~/.dotnet/tools"
    dotnet tool install --global Chickensoft.GodotEnv
fi
gum spin --spinner dot --title "Installing AUR packages..." -- sleep 3;
_installYay;
_installPackagesYay "${aur_pkgs[@]}";

# VM additional packages install
echo -e "\n Is this a virtual machine."
if gum confirm "Is this a virtual machine?" ;then
    gum spin --spinner dot --title "Installing VM additional packages..." -- sleep 3;
    _installPackages "${vm_pkgs[@]}";
fi

# Dotfiles download
gum spin --spinner dot --title "Downloading configuration dotfiles..." -- sleep 3;
git clone https://www.github.com/gilpe/dotfiles.git ~/.dotfiles;

# Dotfiles stow
echo -e "\n Packages and dotfiles are downloaded!"
if gum confirm "Do you wanna replace all the existing configuration files? $(gum style --faint "(If not, you can do it later manually)")" ;then
    gum spin --spinner dot --title "Stowing dotfiles..." -- sleep 3;
    cd ~/.dotfiles;
    stow */;
fi

# Change shell
gum spin --spinner dot --title "Changing shell..." -- sleep 3;
chsh -l;
chsh -s /bin/bash;


#Reboot
echo -e "\n A reboot is needed for some changes to take effect.";
if gum confirm "Do you want to reboot your system now?" ;then
    gum style "See $(gum style --bold --foreground 85 "you")!";
    gum spin --spinner dot --title "Rebooting now..." -- sleep 3;
    systemctl reboot;
fi

exit;