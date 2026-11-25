function fish_user_key_bindings
    # Ctrl-O 開 lf
    # 用 \co 而不是 ctrl-o：fish 3.x（老發行版）和 4.x 都認得
    type -q lf; and bind \co lfcd
end
