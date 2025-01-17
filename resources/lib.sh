#!/bin/bash

# Global variables
PACKAGES=()
PACKAGES_AUR=()
DEBUG_MODE=false
DOTFILES_DIR="$HOME/.dotfiles"

# Methods
isInstalled() {
    if [ -z "$1" ]; then return 1; fi
    pacman -Qi "$1" &>/dev/null
}

installGum() {
    if isInstalled gum; then return 0; fi
    sudo pacman -S --noconfirm --needed gum
}

updateInstalled() {
    gum log -s -t "timeonly" -l "info" "Updating installed packages."
    if ! gum spin --spinner dot --show-error --title "Running task..." \
        -- pacman -Syu --noconfirm --needed; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "All up to date."
    return 0
}

isAUR() {
    if [ -z "$1" ]; then return 1; fi
    ! pacman -Si "$1" &>/dev/null
}

loadPackageLists() {
    gum log -s -t "timeonly" -l "info" "Loading package lists from file."
    local packages_file
    packages_file="$(dirname "$0")/packages.txt"
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Looking into $packages_file."
    if [ ! -f "$packages_file" ]; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "No file found."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "$packages_file located."
    local line_count=0
    local installed_packages=()
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Iterating lines."
    while IFS='' read -r package_name || [ -n "${package_name}" ]; do
        line_count=$((line_count + 1))
        if isInstalled "$package_name"; then
            gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "$package_name excluded, it's already installed."
            installed_packages+=("$package_name")
        else
            if isAUR "$package_name"; then
                PACKAGES_AUR+=("$package_name")
            else
                PACKAGES+=("$package_name")
            fi
        fi
    done <"$packages_file"
    if $DEBUG_MODE; then
        gum log -s -t "timeonly" -l "debug" --prefix "󰘍" "Installed pkgs [ ${installed_packages[*]} ]."
        gum log -s -t "timeonly" -l "debug" --prefix "󰘍" "Regular pkgs [ ${PACKAGES[*]} ]."
        gum log -s -t "timeonly" -l "debug" --prefix "󰘍" "AUR pkgs [ ${PACKAGES_AUR[*]} ]."
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" \
        "$line_count found. ${#installed_packages[@]} installed. ${#PACKAGES[@]} pending. ${#PACKAGES_AUR[@]} pending(AUR)."
}

installPacmanPackages() {
    gum log -s -t "timeonly" -l "info" "Installing packages."
    if $DEBUG_MODE; then
        gum log -s -t "timeonly" -l "debug" --prefix "󰘍" "Params [ ${*} ]."
    fi
    if [ ${#@} -eq 0 ]; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "Nothing to be installed."
        return 1
    fi
    if ! gum spin --spinner dot --show-error --title "Running task..." \
        -- pacman -S "${@}" --noconfirm --needed; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "${#@} installed successfully."
    return 0
}

cloneRepo() {
    local step_name="Cloning repository"
    gum log -s -t "timeonly" -l "info" "$step_name."
    if $DEBUG_MODE; then
        gum log -s -t "timeonly" -l "debug" --prefix "󰘍" "Params [ ${*} ]."
    fi
    if [ ${#@} -lt 2 ]; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Unspecified URL or path."
        return 1
    fi
    if ! isInstalled git; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "git is not installed. Let's do it."
        if ! installPacmanPackages git; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
        gum log -s -t "timeonly" -l "info" "Resuming... $step_name."
    fi
    if ! gum spin --spinner dot --show-error --title "Running task..." \
        -- git clone "$1" "$2"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Repo cloned successfully."
    return 0
}

updateRepo() {
    local step_name="Updating repository"
    gum log -s -t "timeonly" -l "info" "$step_name."
    if $DEBUG_MODE; then
        gum log -s -t "timeonly" -l "debug" --prefix "󰘍" "Params [ ${*} ]."
    fi
    if [ -z "$1" ]; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Unspecified repo path."
        return 1
    fi
    if ! isInstalled git; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "git is not installed. Let's do it."
        if ! installPacmanPackages git; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
        gum log -s -t "timeonly" -l "info" "Resuming... $step_name."
    fi
    local origin_dir
    origin_dir=$(pwd)
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Leaving $origin_dir."
    if ! cd "$1"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed changing to source directory."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Changed to $1."
    if ! gum spin --spinner dot --show-error --title "Running task..." \
        -- git pull; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed pulling the repo."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Repo updated successfully."
    if ! cd "$origin_dir"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed changing back to the origin directory."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Changed back to $origin_dir."
    return 0
}

buildPackage() {
    local step_name="Compiling and building package"
    gum log -s -t "timeonly" -l "info" "$step_name."
    if $DEBUG_MODE; then
        gum log -s -t "timeonly" -l "debug" --prefix "󰘍" "Params [ ${*} ]."
    fi
    if [ -z "$1" ]; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Unspecified source path."
        return 1
    fi
    local origin_dir
    origin_dir=$(pwd)
    if ! isInstalled base-devel; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "base-devel is not installed. Let's do it."
        if ! installPacmanPackages base-devel; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
        gum log -s -t "timeonly" -l "info" "Resuming... $step_name."
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Leaving $origin_dir."
    if ! cd "$1"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed changing to source directory."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Changed to $1."
    if ! gum spin --spinner dot --show-error --title "Running task..." \
        -- makepkg -si --noconfirm; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed building the source."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Package built successfully."
    if ! cd "$origin_dir"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed changing back to the origin directory."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Changed back to $origin_dir."
    return 0
}

installYay() {
    local step_name="Installing yay AUR helper"
    gum log -s -t "timeonly" -l "info" "$step_name."
    if isInstalled yay; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "yay is already installed."
        return 0
    fi
    local temp_dir
    if ! temp_dir=$(mktemp -d); then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed creating a temporary directory."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Temporary directory created at $temp_dir."
    if ! cloneRepo https://aur.archlinux.org/yay.git "$temp_dir"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed clonning yay repo."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" "Resuming... $step_name."
    if ! buildPackage "$temp_dir"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed building yay source."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" "Resuming... $step_name."
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "yay installed successfully."
    return 0
}

installYayPackages() {
    local step_name="Installing packages from AUR"
    gum log -s -t "timeonly" -l "info" "$step_name."
    if $DEBUG_MODE; then
        gum log -s -t "timeonly" -l "debug" --prefix "󰘍" "Params [ ${*} ]"
    fi
    if [ ${#@} -eq 0 ]; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "Nothing to be installed."
        return 1
    fi
    if ! isInstalled "yay"; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "yay is not installed. Let's do it."
        if ! installYay; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
        gum log -s -t "timeonly" -l "info" "Resuming... $step_name."
    fi
    if ! gum spin --spinner dot --show-error --title "Running task..." \
        -- yay -S "${@}" --noconfirm --needed; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "${#@} installed successfully."
    return 0
}

installDotnet() {
    gum log -s -t "timeonly" -l "info" "Installing dotnet-sdk."
    if isInstalled dotnet-sdk; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "dotnet-sdk is already installed."
        return 0
    fi
    if ! installPacmanPackages "dotnet-sdk"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "dotnet-sdk installed successfully."
    export PATH="$PATH:~/.dotnet/tools"
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "$HOME/.dotnet/tools exported to path"
    return 0
}

installGodotEnv() {
    local step_name="Installing GodotEnv dotnet tool"
    gum log -s -t "timeonly" -l "info" "$step_name."
    if ! isInstalled dotnet-sdk; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "dotnet-sdk is not installed. Let's do it."
        if ! installDotnet; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
        gum log -s -t "timeonly" -l "info" "Resuming... $step_name."
    fi
    if dotnet tool list -g Chickensoft.GodotEnv &>/dev/null; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "GodotEnv is already installed."
        return 0
    fi
    if ! gum spin --spinner dot --show-error --title "Running task..." \
        --dotnet tool install -g Chickensoft.GodotEnv; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "GodotEnv installed successfully."
    return 0
}

installGodot() {
    local step_name="Installing Godot Engine"
    gum log -s -t "timeonly" -l "info" "$step_name."
    if ! isInstalled dotnet-sdk; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "dotnet-sdk is not installed. Let's do it."
        if ! installDotnet; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
        gum log -s -t "timeonly" -l "info" "Resuming... $step_name."
    fi
    if ! dotnet tool list -g Chickensoft.GodotEnv &>/dev/null; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "GodotEnv is not installed. Let's do it."
        if ! installGodotEnv; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
        gum log -s -t "timeonly" -l "info" "Resuming... $step_name."
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Getting Godot latest version number."
    local latest
    if ! latest=$(godotenv godot list -r | grep --max-count=1 "stable" | sed 's/-stable//'); then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Godot $latest is the latest version available."
    if godotenv godot list | grep "$latest" &>/dev/null; then
        gum log -s -t "timeonly" -l "info" --prefix "󰘍" "$latest is already installed."
        return 0
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "$latest version is going to be installed."
    if ! gum spin --spinner dot --show-error --title "Running task..." \
        -- godotenv godot install "$latest"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "GodotEnv installed successfully."
    return 0
}

installVMUtils() {
    local step_name="Installing VM Utils"
    gum log -s -t "timeonly" -l "info" "$step_name."
    local missing_packages=()
    if ! isInstalled "virtualbox-guest-utils"; then missing_packages+=("virtualbox-guest-utils"); fi
    if ! isInstalled "foot"; then missing_packages+=("foot"); fi
    if [ "${#missing_packages[@]}" -eq 0 ]; then
        gum log -s -t "timeonly" -l "info" --prefix "󰘍" "All packages are already installed."
        return 0
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "${missing_packages[*]} not installed. Let's do it."
    if ! installPacmanPackages "${missing_packages[@]}"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "VM Utils installed successfully."
    return 0
}

updateYay() {
    local step_name="Updating AUR installed packages."
    gum log -s -t "timeonly" -l "info" "$step_name."
    if ! isInstalled "yay"; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "yay is not installed. Let's do it."
        if ! installYay; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
        gum log -s -t "timeonly" -l "info" "Resuming... $step_name."
    fi
    if ! gum spin --spinner dot --show-error --title "Running task..." \
        -- yay -Syu --noconfirm --needed; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "All up to date."
    return 0
}

downloadDotfiles() {
    local step_name="Downloading dotfiles"
    gum log -s -t "timeonly" -l "info" "$step_name."
    if [ -d "$DOTFILES_DIR" ]; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "dotfiles are already downloaded. Let's update them."
        if ! updateRepo $DOTFILES_DIR; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
    else
        if ! cloneRepo https://www.github.com/gilpe/dotfiles.git "$DOTFILES_DIR"; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "dotfiles repo folder is up to date."
    return 0
}

applyDotfiles() {
    local step_name="Overwriting current configuration"
    gum log -s -t "timeonly" -l "info" "$step_name."
    if ! [ -d "$DOTFILES_DIR" ]; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "dotfiles not found. Let's download them."
        if ! downloadDotfiles; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
    fi
    if ! isInstalled stow; then
        gum log -s -t "timeonly" -l "warn" --prefix "󰘍" "stow is not installed. Let's do it."
        if ! installPacmanPackages stow; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
        gum log -s -t "timeonly" -l "info" "Resuming... $step_name."
    fi
    local origin_dir
    origin_dir=$(pwd)
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Leaving $origin_dir."
    if ! cd "$DOTFILES_DIR"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed changing to source directory."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Changed to $DOTFILES_DIR."
    if ! gum spin --spinner dot --show-error --title "Running task..." \
        -- stow */; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed stowing files the repo."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "dotfiles replaced successfully."
    if ! cd "$origin_dir"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Crashed changing back to the origin directory."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Changed back to $origin_dir."
    return 0
}

changeShell() {
    local step_name="Changing Shell"
    gum log -s -t "timeonly" -l "info" "$step_name."
    local missing_packages=()
    if ! isInstalled "zsh"; then missing_packages+=("zsh"); fi
    if ! isInstalled "oh-my-posh"; then missing_packages+=("oh-my-posh"); fi
    if [ "${#missing_packages[@]}" -gt 0 ]; then
        gum log -s -t "timeonly" -l "info" --prefix "󰘍" "${missing_packages[*]} not installed. Let's do it."
        if ! installPacmanPackages "${missing_packages[@]}"; then
            gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed."
            return 1
        fi
    fi
    local shell
    if ! shell=$(chsh -l | grep --max-count=1 "zsh"); then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed checking shell availability."
        return 1
    fi
    if ! chsh -s "$shell"; then
        gum log -s -t "timeonly" -l "error" --prefix "󰘍" "Something crashed changing the shell."
        return 1
    fi
    gum log -s -t "timeonly" -l "info" --prefix "󰘍" "Shell successfully changed"
    return 0
}

rebootSystem() {
    gum spin --spinner dot --title "Rebooting now..." -- sleep 3
    systemctl reboot
}
