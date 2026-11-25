-- 語法高亮：treesitter
--
-- 你之前的設定為什麼沒效果：nvim-treesitter 已經改用新的 main 分支，
-- 舊的 require("nvim-treesitter.configs") 不存在了，被 pcall 默默吞掉，
-- 而且 main 分支要 tree-sitter 指令才能編譯語法檔，你的電腦沒有 → 一個語法檔都沒裝。
--
-- 現在的做法：
--   1. tree-sitter 指令由 mason 自動下載（見 lsp.lua 的 tools）
--   2. 有了它就自動安裝下面這些語言
--   3. 開檔案時啟用 treesitter；某語言沒有語法檔就退回 vim 內建的高亮，不會報錯

local languages = {
    "c", "cpp", "python", "lua", "bash", "fish", "vim", "vimdoc", "query",
    "markdown", "markdown_inline", "json", "toml", "yaml",
    "javascript", "typescript", "html", "css", "go", "rust", "java",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")

        local function install()
            ts.install(languages)  -- 非同步，已經裝過的會跳過
        end

        if vim.fn.executable("tree-sitter") == 1 then
            install()
        else
            -- mason 裝好 tree-sitter 指令之後會發出這個事件
            vim.api.nvim_create_autocmd("User", { pattern = "TreeSitterCliReady", once = true, callback = install })
        end

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                if pcall(vim.treesitter.start, args.buf) then
                    -- treesitter 也負責縮排
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
