
#Check if package is installed
_isInstalled() 
{
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #true
        return;
    fi;
    echo 1; #false
    return;
}

#Install pacman packages
_installPackages() 
{
    toInstall=();
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]] ; then
        return;
    fi;
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman -S --noconfirm --needed "${toInstall[@]}";
}

#Install AUR packages
_installPackagesYay() 
{
    toInstall=();
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        return;
    fi;

    yay -S --noconfirm --needed "${toInstall[@]}";
}

#Install Yay if it's not
_installYay() {
    if sudo pacman -Qs yay > /dev/null ; then
        echo "yay is already installed!"
    else
        echo "yay is not installed. Will be installed now!"
        _installPackagesPacman "base-devel"
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