# 外部工具初始化 —— 每個都先檢查「有沒有裝」，沒裝就跳過，所以老機器不會壞

status is-interactive; or return

# starship 提示列：有圖示版 / TTY 純文字版
if type -q starship
    if set -q DOTFILES_NO_ICONS
        set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/tty.toml
    else
        set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/starship.toml
    end
    starship init fish | source
end

# zoxide：z 資料夾名 → 直接跳到常去的地方；zi → 用 fzf 挑
type -q zoxide; and zoxide init fish | source

# fzf：Ctrl-R 搜歷史、Ctrl-T 搜檔案、Alt-C 跳資料夾
if type -q fzf
    set -gx FZF_DEFAULT_OPTS "\
--height=40% --layout=reverse --border=rounded --info=inline \
--color=bg+:#3B4252,bg:-1,spinner:#81A1C1,hl:#88C0D0 \
--color=fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#88C0D0 \
--color=marker:#A3BE8C,fg+:#ECEFF4,prompt:#81A1C1,hl+:#88C0D0,border:#4C566A"
    if type -q fd
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
        set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
        set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git'
    end
    # fzf 0.48 之後內建 fish 整合；老版本沒有就略過
    fzf --fish 2>/dev/null | source
end
