-- 左邊的檔案樹（VSCode 的 Explorer）
--
-- 開 nvim 時自動出現在左邊；終端寬度小於 100 欄（例如 eeePC）就不自動開
--   <leader>e   開 / 關檔案樹       （Ctrl-B 給 tmux 用掉了，所以用 空白+e）
--   <leader>o   跳到檔案樹 / 跳回來
-- 在檔案樹裡：
--   Enter / l / 點兩下   打開          h   收起資料夾
--   a  新增（結尾打 / 就是資料夾）    r   改名        d   刪除
--   x  剪下   c  複製   p  貼上       H   顯示隱藏檔  R   重新整理
--   g?  看全部按鍵
return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "檔案樹 開/關" },
        {
            "<leader>o",
            function()
                if vim.bo.filetype == "NvimTree" then
                    vim.cmd("wincmd p")
                else
                    vim.cmd("NvimTreeFocus")
                end
            end,
            desc = "跳到檔案樹 / 跳回來",
        },
    },
    config = function()
        local icons = vim.g.have_nerd_font

        require("nvim-tree").setup({
            sync_root_with_cwd = true,
            update_focused_file = { enable = true },  -- 切換檔案時，樹會自動跟著選到它
            view = { width = 30, side = "left" },
            renderer = {
                root_folder_label = ":t",              -- 頂端只顯示資料夾名稱
                group_empty = true,                    -- a/b/c 只有一層就合併顯示
                highlight_git = "name",
                indent_markers = { enable = true },
                icons = {
                    show = { file = icons, folder = icons, folder_arrow = true, git = icons },
                    glyphs = icons and {} or {
                        folder = { arrow_closed = ">", arrow_open = "v" },
                    },
                },
            },
            filters = { dotfiles = false, custom = { "^.git$", "^.DS_Store$" } },
            git = { enable = true, ignore = false },
            diagnostics = { enable = true, show_on_dirs = true },
            actions = {
                open_file = { window_picker = { enable = false } },
            },
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")
                api.config.mappings.default_on_attach(bufnr)
                local o = { buffer = bufnr, silent = true, nowait = true }
                vim.keymap.set("n", "l", api.node.open.edit, o)
                vim.keymap.set("n", "h", api.node.navigate.parent_close, o)
            end,
        })

        -- 開 nvim 時自動打開檔案樹
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function(data)
                if vim.o.columns < 100 then return end
                local api = require("nvim-tree.api")
                if vim.fn.isdirectory(data.file) == 1 then
                    -- nvim 某個資料夾：切過去並打開樹
                    vim.cmd.cd(data.file)
                    api.tree.open()
                elseif data.file == "" or vim.fn.filereadable(data.file) == 1 then
                    -- nvim 或 nvim 檔案：打開樹，但游標留在編輯區
                    if vim.bo[data.buf].filetype == "gitcommit" then return end
                    api.tree.toggle({ focus = false, find_file = true })
                end
            end,
        })

        -- 只剩檔案樹的時候，nvim 自動結束（不然 :q 完會卡在一個只有樹的畫面）
        vim.api.nvim_create_autocmd("QuitPre", {
            callback = function()
                local wins = vim.api.nvim_list_wins()
                local tree_wins, others = {}, 0
                for _, w in ipairs(wins) do
                    local cfg = vim.api.nvim_win_get_config(w)
                    local ft = vim.bo[vim.api.nvim_win_get_buf(w)].filetype
                    if ft == "NvimTree" then
                        table.insert(tree_wins, w)
                    elseif cfg.relative == "" then
                        others = others + 1
                    end
                end
                if others == 1 then
                    for _, w in ipairs(tree_wins) do vim.api.nvim_win_close(w, true) end
                end
            end,
        })
    end,
}
