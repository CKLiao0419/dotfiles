-- 搜尋（VSCode 的 Ctrl-P 和全域搜尋），底層用你已經裝的 fzf / fd / ripgrep
return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
        { "<C-p>", "<cmd>FzfLua files<cr>", desc = "找檔案" },
        { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "找檔案" },
        { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "全專案搜尋文字" },
        { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "已開的分頁" },
        { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "最近的檔案" },
        { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "搜尋說明文件" },
        { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "搜尋快捷鍵" },
    },
    opts = {
        winopts = { border = "rounded", preview = { layout = "vertical" } },
    },
}
