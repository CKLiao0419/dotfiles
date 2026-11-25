# ~/.config/fish/config.fish
# ------------------------------------------------------------
# 跨機器共用的 fish 入口。真正的設定拆在 conf.d/ 裡，fish 會自動依檔名順序載入：
#   conf.d/00-env.fish     環境變數、PATH
#   conf.d/10-nord.fish    Nord 語法配色
#   conf.d/20-tools.fish   starship / zoxide / fzf 初始化
#   conf.d/30-aliases.fish 別名與縮寫（有裝新工具才用）
# 這台機器專屬的東西（API key、某軟體的 PATH）寫在
#   ~/.config/fish/local.fish   ← 不進 git
# ------------------------------------------------------------

if status is-interactive
    set -g fish_greeting   # 關掉歡迎詞
end

# 機器專屬設定最後載入，可以覆蓋上面任何東西
if test -f $__fish_config_dir/local.fish
    source $__fish_config_dir/local.fish
end
