# 環境變數 —— 所有機器共用

# 讓 lazygit、bat 等工具在 macOS 上也讀 ~/.config（否則會去 ~/Library/Application Support）
set -gx XDG_CONFIG_HOME $HOME/.config

# 編輯器：有 nvim 用 nvim，沒有退回 vim / vi
if type -q nvim
    set -gx EDITOR nvim
else if type -q vim
    set -gx EDITOR vim
else
    set -gx EDITOR vi
end
set -gx VISUAL $EDITOR
set -gx PAGER less
set -gx LESS -FRX   # -R 保留顏色、-F 一頁就直接印出

fish_add_path -g $HOME/.local/bin

# 依作業系統分流
switch (uname -s)
    case Darwin
        test -d /opt/homebrew/bin; and fish_add_path -g /opt/homebrew/bin /opt/homebrew/sbin
        # kitty 的 kitten 指令（lf 看圖用）
        test -d /Applications/kitty.app/Contents/MacOS; and fish_add_path -g -a /Applications/kitty.app/Contents/MacOS
    case Linux
        # Debian/Ubuntu 上 bat、fd 的指令名字不一樣，建一個同名的 wrapper
        type -q batcat; and not type -q bat; and alias bat batcat
        type -q fdfind; and not type -q fd; and alias fd fdfind
end

# 判斷「這個終端看不看得到 Nerd Font 圖示」
# Linux 純 TTY（沒裝圖形介面的老機器）看不到，其他情況預設看得到
# 想手動關掉：在 local.fish 裡 set -gx DOTFILES_NO_ICONS 1
if test "$TERM" = linux
    set -gx DOTFILES_NO_ICONS 1
end
