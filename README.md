# Dotfiles
Linux configuration dot files.

### Required packages:
```
sudo pacman -Syd
sudo pacman -S neofetch
sudo pacman -S xorg 
sudo pacman -S xorg-xinit
sudo pacman -S xf86-video-intel
sudo pacman -S virtualbox-guest-utils
sudo pacman -S i3
sudo pacman -S alacritty
sudo pacman -S nano
sudo pacman -S ttf-jetbrains-mono-nerd
sudo pacman -S firefox
sudo pacman -S github-cli
gh auth login
sudo pacman -S stow
sudo nano etc/X11/xinit/xinitrc 
startx
sudo pacman -Sy --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S picom
```
En xinitrc, comment twm line and exec xterm -geometry also