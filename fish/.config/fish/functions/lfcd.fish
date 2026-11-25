# lfcd：用 lf 瀏覽，按 q 離開時 shell 會停在你最後所在的資料夾
# 快捷鍵：Ctrl-O（在 fish_user_key_bindings.fish 裡綁定）
#
# Linux X11 上如果有裝 ueberzugpp，會順便在背景啟動它，lf 就能看真正的圖片
# （alacritty / st 自己不支援圖片協定，ueberzugpp 是直接在 X11 視窗上疊一張圖）
function lfcd --wraps lf --description 'lf，離開時 cd 到最後的資料夾'
    set -l use_ub 0
    if type -q ueberzugpp; and set -q DISPLAY; and not set -q WAYLAND_DISPLAY; and not set -q KITTY_WINDOW_ID
        set use_ub 1
    end

    if test $use_ub = 1
        set -l pidfile (mktemp)
        ueberzugpp layer --silent --no-stdin --use-escape-codes --pid-file $pidfile
        set -l ub_pid (cat $pidfile)
        rm -f $pidfile
        set -lx UB_SOCKET /tmp/ueberzugpp-$ub_pid.socket
        set -f dir (command lf -print-last-dir $argv)
        ueberzugpp cmd -s $UB_SOCKET -a exit
    else
        set -f dir (command lf -print-last-dir $argv)
    end

    test -n "$dir"; and test -d "$dir"; and cd $dir
    commandline -f repaint 2>/dev/null
end
