#!/bin/sh
# ============================================================
# dotfiles 部署腳本
#
#   ./install.sh              部署全部套件（建立 symlink）
#   ./install.sh fish tmux    只部署指定的套件
#   ./install.sh -d fish      移除某個套件的 symlink（stow -D）
#
# 會做三件事：
#   1. 沒有 stow 就自動安裝（brew / apt / pacman / xbps / apk / dnf）
#   2. 家目錄裡如果已經有同名的「真實檔案」，先搬到 ~/.dotfiles-backup/日期/
#   3. 用 stow 建立 symlink：~/.config/xxx → ~/dotfiles/套件/.config/xxx
#
# 只依賴 POSIX sh，32 位元老機器也能跑。
# ============================================================
set -eu

DOTFILES=$(cd "$(dirname "$0")" && pwd)
cd "$DOTFILES"

say() { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }

# ---------- 1. 確保有 stow ----------
install_stow() {
    say "找不到 stow，嘗試安裝…"
    if command -v brew >/dev/null 2>&1; then brew install stow
    elif command -v apt-get >/dev/null 2>&1; then sudo apt-get install -y stow
    elif command -v pacman >/dev/null 2>&1; then sudo pacman -S --needed --noconfirm stow
    elif command -v xbps-install >/dev/null 2>&1; then sudo xbps-install -Sy stow
    elif command -v apk >/dev/null 2>&1; then sudo apk add stow
    elif command -v dnf >/dev/null 2>&1; then sudo dnf install -y stow
    else
        warn "不認得這台的套件管理器，請手動安裝 GNU stow"; exit 1
    fi
}
command -v stow >/dev/null 2>&1 || install_stow

# ---------- 決定要處理哪些套件 ----------
MODE=stow
if [ "${1:-}" = "-d" ]; then MODE=delete; shift; fi

if [ $# -gt 0 ]; then
    PKGS=$*
else
    # 預設：repo 裡每個資料夾都是一個套件，除了這些非套件資料夾
    PKGS=$(for d in */; do
        d=${d%/}
        case $d in (docs|packages) ;; (*) echo "$d" ;; esac
    done)
    # 圖形終端的設定：這台有裝那個終端才部署（老機器不會多一堆用不到的設定）
    for term in kitty alacritty; do
        if command -v "$term" >/dev/null 2>&1; then continue; fi
        # macOS 的 App 通常不在 PATH 裡，另外檢查 /Applications
        case $term in
            (kitty) [ -d /Applications/kitty.app ] && continue ;;
            (alacritty) [ -d /Applications/Alacritty.app ] && continue ;;
        esac
        PKGS=$(echo "$PKGS" | grep -vx "$term")
    done
fi

if [ $MODE = delete ]; then
    say "移除 symlink：$(echo $PKGS)"
    stow --target="$HOME" --delete $PKGS
    exit 0
fi

# ---------- 2. 備份會衝突的真實檔案 ----------
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
for pkg in $PKGS; do
    [ -d "$pkg" ] || { warn "沒有這個套件：$pkg"; exit 1; }
    ( cd "$pkg" && find . -type f ) | while IFS= read -r f; do
        rel=${f#./}
        target="$HOME/$rel"
        # 已經是 symlink（之前 stow 過）就不用管；是真實檔案才備份
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            mkdir -p "$BACKUP/$(dirname "$rel")"
            mv "$target" "$BACKUP/$rel"
            warn "已備份 $target → $BACKUP/$rel"
        fi
    done
done

# ---------- 3. 建立 symlink ----------
# --no-folding：只對「檔案」建 symlink，不把整個資料夾換成 symlink。
#   這樣你在 ~/.config/fish/ 裡新增的 local.fish 才會留在本機，不會跑進 repo。
say "部署：$(echo $PKGS)"
stow --no-folding --restow --target="$HOME" $PKGS

say "完成。備份（如果有）在 $BACKUP"
say "機器專屬設定請寫在：~/.config/fish/local.fish、~/.config/tmux/local.conf、~/.config/kitty/local.conf"
