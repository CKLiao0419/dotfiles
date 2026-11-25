-- 編輯器基本選項
local opt = vim.opt

vim.g.mapleader = " "        -- <leader> = 空白鍵
vim.g.maplocalleader = " "

-- 終端看不看得到 Nerd Font 圖示（Linux 純文字主控台看不到）
vim.g.have_nerd_font = vim.env.TERM ~= "linux"

-- 檔案樹用 nvim-tree，關掉內建的 netrw（必須在外掛載入前設定）
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 行號
opt.number = true
opt.relativenumber = true     -- 相對行號：方便 5j、12k 這種跳行
opt.cursorline = true
opt.signcolumn = "yes"        -- 左邊永遠留一欄給 git / 錯誤標記，畫面不會跳

-- 縮排
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- 搜尋：全小寫不分大小寫，有大寫就區分
opt.ignorecase = true
opt.smartcase = true

-- 視窗
opt.splitright = true         -- 垂直分割開在右邊
opt.splitbelow = true         -- 水平分割開在下面
opt.scrolloff = 8
opt.wrap = false
opt.laststatus = 3            -- 整個畫面只有一條狀態列（像 VSCode）
opt.showmode = false          -- 模式顯示交給 lualine
opt.fillchars = { eob = " " } -- 檔案結尾不要顯示 ~

-- 行為
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- 跟系統剪貼簿共用
opt.undofile = true           -- 關掉檔案再打開還能 undo
opt.updatetime = 250
opt.confirm = true            -- 有未存檔就離開時用問的，不直接報錯

-- 顏色：Linux TTY 不支援 24-bit 真彩色
opt.termguicolors = vim.env.TERM ~= "linux"
