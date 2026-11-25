-- 游標拖尾特效（像 kitty 的 cursor_trail，但是由 nvim 自己畫）
--
-- alacritty / st / foot 本身沒有游標動畫，這個外掛用字元在 nvim 裡畫出拖尾，
-- 所以在任何終端都有效果。限制：只在 nvim 裡面有，fish 的命令列沒有。
--
-- 什麼時候不開：
--   kitty     → kitty 自己的 cursor_trail 已經有了，兩個疊在一起會重影
--   Linux TTY → 沒有顏色和特殊字元可以畫
--   想手動關  → :SmearCursorToggle，或在 lua/config/local.lua 寫 vim.g.no_smear = true
--             （老機器 CPU 慢、覺得卡就關掉）
return {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    cond = function()
        return vim.env.KITTY_WINDOW_ID == nil
            and vim.env.TERM ~= "linux"
            and not vim.g.no_smear
    end,
    opts = {
        cursor_color = "#d8dee9",                 -- Nord 的前景色
        transparent_bg_fallback_color = "#2e3440", -- 背景是透明的，告訴它底色是什麼
        smear_between_buffers = true,              -- 切換視窗（檔案樹 ↔ 編輯區）也有拖尾
        smear_between_neighbor_lines = true,       -- 上下移一行也有
        smear_insert_mode = true,
        -- 越大越「快」、拖尾越短；kitty 預設的手感大約在這裡
        stiffness = 0.7,
        trailing_stiffness = 0.4,
    },
}
