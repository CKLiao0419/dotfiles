# lfcd：用 lf 瀏覽，按 q 離開時 shell 會停在你最後所在的資料夾
# 快捷鍵：Ctrl-O（在 fish_user_key_bindings.fish 裡綁定）
function lfcd --wraps lf --description 'lf，離開時 cd 到最後的資料夾'
    set -l dir (command lf -print-last-dir $argv)
    test -n "$dir"; and test -d "$dir"; and cd $dir
    commandline -f repaint 2>/dev/null
end
