-- LSP：讓 nvim 看得懂程式碼（補全、跳定義、錯誤提示、改名）
--
--   mason            自動下載語言伺服器（clangd、pyright…）和工具
--   mason-lspconfig  把 mason 裝好的伺服器自動啟用
--   nvim-lspconfig   各語言伺服器的預設設定
--
-- 按鍵（游標放在程式碼上）：
--   K          看說明              gd   跳到定義
--   grr        找所有引用          F2   改名（VSCode 習慣）
--   <leader>ca 程式碼動作（自動修正） <leader>cf 排版
-- :Mason 打開管理介面

-- 要自動安裝的語言伺服器（名字是 lspconfig 的名字）
local servers = { "clangd", "pyright", "lua_ls" }
-- 要自動安裝的其他工具（名字是 mason 的名字）
local tools = { "tree-sitter-cli" }

-- mason 只有 64 位元的執行檔；32 位元老機器就不自動下載，避免一直報錯
local supported = jit.arch == "x64" or jit.arch == "arm64"

return {
    {
        "mason-org/mason.nvim",
        lazy = false,
        opts = { ui = { border = "rounded" } },
        config = function(_, opts)
            require("mason").setup(opts)
            if not supported then return end

            local registry = require("mason-registry")
            registry.refresh(function()
                for _, name in ipairs(tools) do
                    local ok, pkg = pcall(registry.get_package, name)
                    if ok then
                        if pkg:is_installed() then
                            if name == "tree-sitter-cli" then
                                vim.schedule(function()
                                    vim.api.nvim_exec_autocmds("User", { pattern = "TreeSitterCliReady" })
                                end)
                            end
                        else
                            pkg:once("install:success", function()
                                vim.schedule(function()
                                    vim.notify("mason：已安裝 " .. name)
                                    if name == "tree-sitter-cli" then
                                        vim.api.nvim_exec_autocmds("User", { pattern = "TreeSitterCliReady" })
                                    end
                                end)
                            end)
                            pkg:install()
                        end
                    end
                end
            end)
        end,
    },

    {
        "mason-org/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig", "saghen/blink.cmp" },
        config = function()
            -- 所有語言伺服器共用：告訴它們我們的補全外掛支援哪些功能
            vim.lsp.config("*", {
                capabilities = require("blink.cmp").get_lsp_capabilities(),
            })
            -- 寫 nvim 設定時，讓 lua_ls 認得 vim 這個全域變數
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            require("mason-lspconfig").setup({
                ensure_installed = supported and servers or {},
                automatic_enable = true,
            })

            -- 錯誤訊息的顯示方式
            vim.diagnostic.config({
                virtual_text = { spacing = 2, prefix = "●" },
                severity_sort = true,
                float = { border = "rounded" },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = vim.g.have_nerd_font and "\u{f057}" or "E",
                        [vim.diagnostic.severity.WARN] = vim.g.have_nerd_font and "\u{f071}" or "W",
                        [vim.diagnostic.severity.INFO] = vim.g.have_nerd_font and "\u{f05a}" or "I",
                        [vim.diagnostic.severity.HINT] = vim.g.have_nerd_font and "\u{f0eb}" or "H",
                    },
                },
            })

            -- 有語言伺服器連上時才綁的按鍵
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local map = function(keys, fn, desc)
                        vim.keymap.set("n", keys, fn, { buffer = args.buf, desc = desc })
                    end
                    map("gd", vim.lsp.buf.definition, "跳到定義")
                    map("<F2>", vim.lsp.buf.rename, "改名")
                    map("<leader>ca", vim.lsp.buf.code_action, "程式碼動作")
                    map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "排版")
                    map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "看說明")
                end,
            })
        end,
    },
}
