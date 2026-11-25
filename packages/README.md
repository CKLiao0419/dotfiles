# 各機器要裝的軟體

分三層。往下一層只是「少裝一點」，config 本身不用改：沒裝的工具會自動跳過。

## 第一層：核心（每台都裝，包括 R50e、eeePC）
git stow fish tmux vim (或 neovim) less file

## 第二層：好用（64 位元機器都裝）
starship eza bat fd ripgrep fzf zoxide lf chafa lazygit git-delta btop fastfetch

## 第三層：圖形終端（見 docs/TERMINALS.md）
- macOS：kitty
- Linux X11：alacritty + picom（透明 / 毛玻璃）+ ueberzugpp（lf 看圖）
- Linux Wayland：foot（之後再設定）
- 都要裝 JetBrainsMono Nerd Font

## 各發行版指令

Debian 12/13（指令名：bat→batcat、fd→fdfind，fish 裡已經處理）
```sh
sudo apt install git stow fish tmux neovim fzf ripgrep fd-find bat eza zoxide lf chafa btop fastfetch git-delta
# starship：curl -sS https://starship.rs/install.sh | sh  （有 i686 版本）
```

Arch
```sh
sudo pacman -S alacritty picom ueberzugpp ttf-jetbrains-mono-nerd git stow fish tmux neovim starship eza bat fd ripgrep fzf zoxide lf chafa lazygit git-delta btop fastfetch tealdeer
```

Void
```sh
sudo xbps-install -S git stow fish-shell tmux neovim starship eza bat fd ripgrep fzf zoxide lf chafa lazygit delta btop fastfetch tealdeer
```

Alpine（eeePC 701 / R50e 這種 32 位元、記憶體小的機器）
```sh
doas apk add git stow fish tmux vim less file chafa fzf
```
