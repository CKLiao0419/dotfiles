-- ~/.config/nvim/init.lua
-- ============================================================
-- 入口檔只負責「依序載入」，真正的設定拆在 lua/ 底下：
--
--   lua/config/options.lua      編輯器基本選項
--   lua/config/keymaps.lua      快捷鍵（VSCode 習慣 + vim 操作）
--   lua/config/transparent.lua  把背景挖空，讓終端的半透明 / 毛玻璃透出來
--   lua/config/runner.lua       F5 / F6 編譯並執行目前檔案
--   lua/config/lazy.lua         外掛管理器 lazy.nvim
--   lua/plugins/*.lua           每個檔案一類外掛，lazy.nvim 會自動全部載入
--
-- 這台機器專屬的設定寫在 lua/config/local.lua（不進 git，有就載入）
-- ============================================================

require("config.options")

-- 老發行版（例如 Debian 12 的 nvim 0.7）跑不動新外掛，只用基本選項
if vim.fn.has("nvim-0.11") == 0 then
    vim.notify("nvim 版本太舊（需要 0.11+），只載入基本設定", vim.log.levels.WARN)
    return
end

require("config.keymaps")
require("config.transparent").setup()
require("config.runner").setup()
require("config.lazy")

pcall(require, "config.local")
