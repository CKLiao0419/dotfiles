-- lazy.nvim 外掛管理器
-- 第一次開 nvim 會自動 git clone 自己，再自動裝好所有外掛
-- :Lazy 打開管理介面（U 更新、S 同步、X 清掉沒用的）

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({ { "lazy.nvim 下載失敗：\n" .. out, "ErrorMsg" } }, true, {})
        return
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { { import = "plugins" } },  -- 自動載入 lua/plugins/ 底下所有檔案
    install = { colorscheme = { "nord", "habamax" } },
    checker = { enabled = false },      -- 不要在背景偷偷檢查更新
    change_detection = { notify = false },
    ui = { border = "rounded" },
    performance = {
        rtp = {
            disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
        },
    },
})
