#!/bin/bash

source "$(dirname "$0")/lib.sh"

# Permission check
if [ "$EUID" -ne 0 ]; then echo -e "\033[1;33m This will install things... Please re-run me as sudo :)\033[0m" && exit 1; fi

# Debug mode set
if [ "$1" = "--debug" ]; then DEBUG_MODE=true; fi

# Script dependencies installation
if ! isInstalled gum; then
    echo -e "\033[1;33m Gum is going to be installed to beautify this awesome script <3"
    installGum
fi

# Welcome title display
echo -e "\n"
gum style --faint --border none --align right --width 50 \
    "Be welcome to..."
gum style --border double --align center --width 50 --padding "1 2" --border-foreground 212 \
    "$(
        gum style --bold --foreground 85 \
            "Gilpe"
    )'s package installer and dotfile setter" "for a new workstation"

if $DEBUG_MODE; then gum log -s -t "timeonly" -l "debug" "Debug mode is enabled."; fi
gum log -s -t "timeonly" -l "info" "A brief advice:"
gum format -- "" \
    "> This script runs incrementally and on priority." \
    "> Each step normally requires the execution of the previous one." \
    "> You can stop when you want and resume later." \
    "> But a recomendation is to run it all at once." \
    "> Enjoy the ride! 🚀"
echo -e "\n"

# Menu display
option1="Package installation"
option2="Configuration import"
choices=$(
    gum choose --cursor "👉 " --no-limit --header "Pick at least one process to be done:" \
        "$option1" \
        "$option2"
)
if $DEBUG_MODE; then gum log -s -t "timeonly" -l "debug" "Selected options[ $choices ]"; fi

reboot=false

if [ -z "$choices" ]; then
    gum log -s -t "timeonly" -l "warn" "It looks like you haven't selected anything."
else
    # Package installation
    if echo "$choices" | grep -q "$option1"; then
        gum log -s -t "timeonly" -l "info" "Starting $option1."
        updateInstalled
        loadPackageLists
        installPacmanPackages "${PACKAGES[@]}"
        installYayPackages "${PACKAGES_AUR[@]}"
        if gum confirm --timeout "1s" "Install godot extras?"; then
            installGodot
        fi
        if gum confirm --timeout "1s" "Install VM extras?"; then
            installVMUtils
        fi
        gum log -s -t "timeonly" -l "info" "$option1 is over!"
    fi

    # Configuration import
    if echo "$choices" | grep -q "$option2"; then

        gum log -s -t "timeonly" -l "info" "Starting $option2."
        downloadDotfiles
        if gum confirm --timeout "1s" "Overwrite all the current configuration?"; then
            applyDotfiles
        fi
        if gum confirm --timeout "1s" "Change the current shell to zsh?"; then
            changeShell
        fi
        if gum confirm --timeout "1s" "Reboot now?"; then
            reboot=true
        fi
        gum log -s -t "timeonly" -l "info" "$option2 is over!"
    fi
fi

# Farewell title display
gum log -s -t "timeonly" -l "info" "The end."
gum style --border none --align center --width 50 --padding "1 2" \
    "See $(
        gum style --bold --foreground 85 "you"
    ) later 🫡"

if $reboot; then
    rebootSystem
fi

exit
