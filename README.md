# 🗄️ Dotfiles
Configuration backup for my linux workstations.

> [!WARNING]
Please, remember that my base system and preferences may not match with yours. The configuration files included in this repo, are set for an ArchLinux based installation that work for me.

## 🪛 Setup
Clone this repo
```bash
git clone --depth 1 "https://github.com/gilpe/dotfiles.git" "$HOME/.dotfiles"
```
and if you use GNU Stow, "stow" them all by running
```bash
cd "$HOME/.dotfiles" && stow */
```
If you are interested in a specific configuration, replace `*/` with the name of the containing folder (stow package).
