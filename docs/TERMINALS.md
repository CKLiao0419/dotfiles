# Linux 終端選型（2026-11）

## 結論

| 你的情況 | 用什麼 |
|---|---|
| **X11（現在）** | **alacritty**（主力）。老到 alacritty 跑不動的機器 → st |
| 之後換到 Wayland（sway / niri / river / Hyprland） | **foot**，對老 ThinkPad 最友善 |
| macOS | kitty（照舊），alacritty 也能用同一份設定 |

**foot 在 X11 上完全不能用**，它只支援 Wayland。所以在你換桌面之前，問題不是「foot 還是 alacritty」，而是「alacritty 還是 st」。

## 比較

| | alacritty | foot | st | kitty | Ghostty |
|---|---|---|---|---|---|
| 顯示協定 | X11 + Wayland + macOS | **只有 Wayland** | 只有 X11 | 全部 | 全部 |
| 怎麼畫字 | GPU（OpenGL 3.3 / GLES 2） | **CPU**（不吃顯卡） | CPU（Xft） | GPU（OpenGL 3.1+） | GPU |
| 記憶體 | 中 | **很小**（server 模式更小） | **最小** | 大（含 Python） | 大（GTK4） |
| 設定檔 | TOML，自動重新載入 | INI | **改 C 原始碼再重新編譯** | conf | conf |
| 透明 | ✅ 要有合成器 | ✅ | 要打 alpha patch | ✅ | ✅ |
| 毛玻璃 | 只有 macOS / KDE Wayland | 1.27 起支援（要合成器配合） | ❌ | macOS / 部分 Wayland | macOS / KDE |
| 終端裡看圖 | ❌ → 用 ueberzugpp | ✅ sixel | 打 sixel patch | ✅ kitty 協定 | ✅ kitty 協定 |
| 分頁 / 分割 | ❌（交給 tmux） | ❌（交給 tmux） | ❌ | ✅ | ✅ |
| 適合你哪台 | X220i、A1466、A1278 | Wayland 化以後的每一台 | R50e、eeePC、X61 | Mac | 只適合新機器 |

### 為什麼 kitty 在 Linux 上卡
kitty 用 GPU 畫字，加上 Python 執行環境，對 Sandy Bridge 以前的內建顯卡太重。而且 X11 下沒開合成器時，垂直同步和重繪的時機也比較差。alacritty 也走 GPU，但非常精簡，在 HD3000 上通常順很多。

### 為什麼不考慮 Ghostty / WezTerm
兩個都很重。有人回報 HD3000（Mesa 只到 OpenGL 3.3）上的 Ghostty 拿不到 OpenGL context，所以不適合你的老機器群。

### 為什麼說 alacritty「可能不是最終答案」也對
alacritty 刻意不做圖片、分頁、連字。如果你之後把桌面換成 Wayland，foot 在每一方面都更適合老 ThinkPad：CPU 繪圖、記憶體小、內建 sixel（lf 直接看圖，不用 ueberzugpp）。到那時候再寫 foot 設定，並且在那台機器上用 `foot --check-config` 驗證。

## 現在的設定怎麼用（X11 + alacritty）

```sh
# Arch
sudo pacman -S alacritty ttf-jetbrains-mono-nerd picom ueberzugpp
# Debian 13
sudo apt install alacritty picom   # Nerd Font 要自己下載到 ~/.local/share/fonts
cd ~/dotfiles && ./install.sh      # 有 alacritty 指令才會部署 alacritty 設定
chsh -s "$(command -v fish)"       # alacritty 開的是登入 shell，改成 fish
```

這台機器專屬的設定寫在 `~/.config/alacritty/local.toml`：
```toml
[font]
size = 10.0

[window]
opacity = 0.85
```

### 半透明 / 毛玻璃要靠 picom
X11 本身不會做透明，alacritty 設了 `opacity` 也要有合成器才會生效。最小的 `~/.config/picom/picom.conf`：

```conf
backend = "glx";          # X61 這種老顯卡跑不動就改 "xrender"，並刪掉下面的 blur
vsync = true;
blur-method = "dual_kawase";
blur-strength = 4;        # 毛玻璃強度；HD3000 建議 3~5，太高會卡
blur-background-exclude = [ "window_type = 'dock'", "window_type = 'desktop'" ];
```
在 WM 的啟動腳本裡加上 `picom -b`。nvim 已經設成透明背景，會直接透出去。

### lf 看圖（ueberzugpp）
裝了 `ueberzugpp` 以後，**用 Ctrl-O（或 `lfcd`）開 lf** 就會看到真正的圖片。直接打 `lf` 不會啟動 ueberzugpp，那時會退回 chafa 字元畫。

⚠️ 這部分是照 ueberzugpp 官方的 lf 用法寫的，還沒在真正的 X11 機器上測過。如果圖片位置偏掉或沒出現，把 `ueberzugpp --version` 和現象告訴我。
