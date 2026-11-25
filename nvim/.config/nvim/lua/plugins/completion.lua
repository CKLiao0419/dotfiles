-- 自動補全 + 括號自動成對
--
-- blink.cmp：打字時自動跳出選單
--   Tab / Shift-Tab   上下選     Enter   確定
--   Ctrl-Space        手動叫出   Ctrl-e  關掉選單
-- 來源：語言伺服器、檔案路徑、程式碼片段、目前檔案裡出現過的字
return {
    {
        "saghen/blink.cmp",
        version = "1.*",            -- 用正式版，才會下載預先編好的快速比對引擎
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = { "rafamadriz/friendly-snippets" },  -- 常用程式碼片段（for、main…）
        opts = {
            keymap = {
                preset = "enter",
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            },
            appearance = { nerd_font_variant = "mono" },
            completion = {
                list = { selection = { preselect = false, auto_insert = true } },
                menu = { border = "rounded" },
                documentation = { auto_show = true, auto_show_delay_ms = 300, window = { border = "rounded" } },
            },
            signature = { enabled = true, window = { border = "rounded" } },  -- 打函式參數時顯示提示
            sources = { default = { "lsp", "path", "snippets", "buffer" } },
            -- 沒有預編好的引擎（例如 32 位元機器）就自動改用 Lua 版，慢一點但能用
            fuzzy = { implementation = "prefer_rust" },
        },
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
}
