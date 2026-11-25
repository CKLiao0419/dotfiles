-- 快捷鍵
-- 外掛相關的按鍵寫在各自的 lua/plugins/*.lua 裡（跟著外掛走，比較好找）
-- 按 <空白> 停一下，左下角不會跳提示；忘了就看 docs/CHEATSHEET.md
local map = vim.keymap.set

-- ---------- VSCode 習慣 ----------
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr><esc>", { desc = "存檔" })
-- Ctrl-/ 註解（終端裡 Ctrl-/ 常常被送成 Ctrl-_，兩個都綁）
map("n", "<C-/>", "gcc", { remap = true, desc = "註解這行" })
map("n", "<C-_>", "gcc", { remap = true, desc = "註解這行" })
map("v", "<C-/>", "gc", { remap = true, desc = "註解選取" })
map("v", "<C-_>", "gc", { remap = true, desc = "註解選取" })
-- Alt-上下 移動整行（kitty 已設定 option 鍵當 Alt）
map("n", "<A-j>", "<cmd>move .+1<cr>==", { desc = "這行往下移" })
map("n", "<A-k>", "<cmd>move .-2<cr>==", { desc = "這行往上移" })
map("v", "<A-j>", ":move '>+1<cr>gv=gv", { desc = "選取往下移" })
map("v", "<A-k>", ":move '<-2<cr>gv=gv", { desc = "選取往上移" })

-- ---------- 視窗 ----------
-- Ctrl-hjkl 在 檔案樹 / 編輯區 / 終端 之間移動
map("n", "<C-h>", "<C-w>h", { desc = "左邊視窗" })
map("n", "<C-j>", "<C-w>j", { desc = "下面視窗" })
map("n", "<C-k>", "<C-w>k", { desc = "上面視窗" })
map("n", "<C-l>", "<C-w>l", { desc = "右邊視窗" })

-- ---------- 分頁（buffer） ----------
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "上一個分頁" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "下一個分頁" })
map("n", "<leader>x", function()
    -- 關掉目前分頁但保留視窗配置（不然檔案樹會被撐滿整個畫面）
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("bprevious")
    if vim.api.nvim_get_current_buf() == buf then vim.cmd("enew") end
    pcall(vim.api.nvim_buf_delete, buf, {})
end, { desc = "關閉分頁" })

-- ---------- 其他 ----------
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "清除搜尋高亮" })
map("v", "<", "<gv", { desc = "縮排後保持選取" })
map("v", ">", ">gv", { desc = "縮排後保持選取" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "終端：回到普通模式" })

-- 錯誤訊息
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "看這行的錯誤" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "上一個錯誤" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "下一個錯誤" })
