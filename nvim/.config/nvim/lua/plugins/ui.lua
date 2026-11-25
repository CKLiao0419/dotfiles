-- 介面：上面的分頁列、下面的狀態列、左邊的 git 標記
return {
    -- 檔案圖示（Linux TTY 自動關掉）
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        cond = function() return vim.g.have_nerd_font end,
    },

    -- 上方分頁列（VSCode 的 tabs）
    --   Shift-h / Shift-l 切換分頁，<leader>x 關閉，滑鼠也可以點
    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "VeryLazy",
        opts = {
            options = {
                diagnostics = "nvim_lsp",
                show_buffer_icons = vim.g.have_nerd_font,
                separator_style = "thin",
                always_show_bufferline = true,
                -- 分頁列讓出檔案樹那一段，不會壓在樹上面
                offsets = {
                    { filetype = "NvimTree", text = "檔案", highlight = "Directory", separator = true },
                },
            },
        },
    },

    -- 下方狀態列
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            local icons = vim.g.have_nerd_font
            return {
                options = {
                    theme = "nord",
                    globalstatus = true,
                    icons_enabled = icons,
                    section_separators = "",
                    component_separators = "│",
                    disabled_filetypes = { statusline = {} },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },     -- 顯示相對路徑
                    lualine_x = { "encoding", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                extensions = { "nvim-tree", "lazy", "fzf" },
            }
        end,
    },

    -- 行號旁邊的 git 增刪改標記
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "▁" },
                topdelete = { text = "▁" },
                changedelete = { text = "▎" },
            },
        },
    },
}
