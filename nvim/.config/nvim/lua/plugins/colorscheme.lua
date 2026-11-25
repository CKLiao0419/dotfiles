-- Nord 主題（跟 kitty / tmux / starship 同一套色票）
-- 背景挖空交給 config/transparent.lua，這裡也開 transparent 讓主題本身配合
return {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,                 -- 最先載入，其他外掛才拿得到正確顏色
    cond = vim.env.TERM ~= "linux",  -- TTY 只有 16 色，用內建主題就好
    config = function()
        require("nord").setup({
            transparent = true,
            borders = true,
            errors = { mode = "fg" },
            styles = {
                comments = { italic = true },
            },
        })
        vim.cmd.colorscheme("nord")
    end,
}
