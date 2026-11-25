# ~/.bashrc —— 備援用
# 主力是 fish；這份給「還沒裝 fish 的新機器」「救援模式」「別人的伺服器」用
# 刻意保持精簡、只依賴 bash 本身

[ -z "$PS1" ] && return

HISTSIZE=10000
HISTCONTROL=ignoreboth
shopt -s histappend checkwinsize

export EDITOR=vim
command -v nvim >/dev/null && export EDITOR=nvim

alias ll='ls -lh'
alias la='ls -lAh'
alias t='tmux new -A -s main'

# 有 starship 用 starship，沒有就用手寫的 Nord 風格提示列
if command -v starship >/dev/null; then
    if [ "$TERM" = linux ]; then
        export STARSHIP_CONFIG=$HOME/.config/starship/tty.toml
    else
        export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
    fi
    eval "$(starship init bash)"
else
    PS1='\[\e[35m\]\u@\h\[\e[0m\] \[\e[1;36m\]\w\[\e[0m\]\n\[\e[1;32m\]>\[\e[0m\] '
fi

[ -f ~/.bashrc.local ] && . ~/.bashrc.local
