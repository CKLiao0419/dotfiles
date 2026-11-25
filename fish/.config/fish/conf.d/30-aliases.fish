# 別名（alias）與縮寫（abbr）
# abbr 是 fish 特色：打 gs 按空白會「展開」成 git status -sb，
# 歷史紀錄裡存的是完整指令，換到別台沒設定的機器也看得懂。

status is-interactive; or return

# ---- ls：有 eza 用 eza，沒有退回 ls ----
if type -q eza
    set -l icons --icons=auto
    set -q DOTFILES_NO_ICONS; and set icons --icons=never
    alias ls "eza --group-directories-first $icons"
    alias ll "eza -l --git --group-directories-first --time-style=relative $icons"
    alias la "eza -la --git --group-directories-first --time-style=relative $icons"
    alias lt "eza --tree --level=2 --group-directories-first $icons"
else
    alias ll 'ls -lh'
    alias la 'ls -lAh'
end

# ---- cat：有 bat 用 bat ----
if type -q bat
    alias cat 'bat --paging=never --style=plain'
end

# ---- 縮寫 ----
abbr -a v $EDITOR
abbr -a g git
abbr -a gs 'git status -sb'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gp 'git push'
abbr -a gl 'git pull'
abbr -a glg 'git log --oneline --graph --decorate -20'
abbr -a gd 'git diff'
type -q lazygit; and abbr -a lg lazygit

# tmux：t = 接回名為 main 的 session，沒有就建一個（斷線重連神器）
abbr -a t 'tmux new -A -s main'
abbr -a tl 'tmux ls'

# 快速進 dotfiles
abbr -a dot 'cd ~/dotfiles'
