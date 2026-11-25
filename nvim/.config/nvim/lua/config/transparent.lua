-- 透明背景
-- 原理：把這些 highlight group 的「背景色」拿掉，只留文字顏色，
-- 於是 nvim 底下就是終端本身的背景（半透明、毛玻璃、桌布都會透出來）。
-- 每次換主題（ColorScheme 事件）都會重新挖一次。
-- 想暫時關掉：:TransparentToggle 或 <leader>tt

local M = {}

M.enabled = true

-- 要挖空背景的群組
M.groups = {
    -- 編輯區
    "Normal", "NormalNC", "EndOfBuffer", "SignColumn", "LineNr", "CursorLineNr",
    "FoldColumn", "Folded", "NonText", "WinSeparator", "VertSplit", "MsgArea",
    -- 浮動視窗（hover 說明、錯誤訊息）
    "NormalFloat", "FloatBorder", "FloatTitle",
    -- git 標記、錯誤標記的那一欄
    "GitSignsAdd", "GitSignsChange", "GitSignsDelete",
    "DiagnosticSignError", "DiagnosticSignWarn", "DiagnosticSignInfo", "DiagnosticSignHint",
    -- 檔案樹
    "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer", "NvimTreeWinSeparator",
    "NvimTreeSignColumn",
    -- 分頁列空白處、搜尋視窗
    "TabLineFill", "BufferLineFill", "FzfLuaNormal", "FzfLuaBorder",
    -- 補全選單的說明窗（選單本身保留底色，不然字疊在程式碼上會看不清楚）
    "BlinkCmpDoc", "BlinkCmpDocBorder", "BlinkCmpSignatureHelp", "BlinkCmpSignatureHelpBorder",
}

local function clear()
    if not M.enabled then return end
    for _, name in ipairs(M.groups) do
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
        if ok then
            hl.bg = nil
            hl.ctermbg = nil
            vim.api.nvim_set_hl(0, name, hl)
        end
    end
end

function M.toggle()
    M.enabled = not M.enabled
    -- 重新套用主題來還原背景，再看要不要挖空
    vim.cmd.colorscheme(vim.g.colors_name or "default")
    vim.notify("透明背景：" .. (M.enabled and "開" or "關"))
end

function M.setup()
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("transparent", { clear = true }),
        callback = function() vim.schedule(clear) end,
    })
    vim.api.nvim_create_user_command("TransparentToggle", M.toggle, {})
    vim.keymap.set("n", "<leader>tt", M.toggle, { desc = "切換透明背景" })
end

M.clear = clear
return M
