# Nord 配色 —— fish 的語法即時上色、補全選單
# 用 set -g（global）而不是 universal，這樣設定只來自這個檔案、可被 git 管理
# Nord 色票：https://www.nordtheme.com/docs/colors-and-palettes

status is-interactive; or return

set -l nord3 4C566A
set -l comment 616E88   # Nord 官方的「加亮註解色」，在深底上比 nord3 好讀
set -l nord4 D8DEE9
set -l nord2 434C5E
set -l nord7 8FBCBB
set -l nord8 88C0D0
set -l nord9 81A1C1
set -l nord11 BF616A
set -l nord13 EBCB8B
set -l nord14 A3BE8C
set -l nord15 B48EAD

set -g fish_color_normal $nord4
set -g fish_color_command $nord8          # 指令：青色（打錯會變紅）
set -g fish_color_keyword $nord9
set -g fish_color_quote $nord14
set -g fish_color_redirection $nord15
set -g fish_color_end $nord9
set -g fish_color_error $nord11
set -g fish_color_param $nord4
set -g fish_color_option $nord7
set -g fish_color_comment $comment
set -g fish_color_operator $nord9
set -g fish_color_escape $nord13
set -g fish_color_autosuggestion $comment # 灰字自動建議
set -g fish_color_valid_path --underline
set -g fish_color_selection --background=$nord2
set -g fish_color_search_match --background=$nord2
set -g fish_color_cancel $nord11

set -g fish_pager_color_prefix $nord8 --bold
set -g fish_pager_color_completion $nord4
set -g fish_pager_color_description $nord13
set -g fish_pager_color_progress $nord3
set -g fish_pager_color_selected_background --background=$nord2
