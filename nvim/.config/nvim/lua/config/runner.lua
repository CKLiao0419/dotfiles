-- F5 / F6：編譯並執行目前的檔案
--   F5 → 右邊直切出終端
--   F6 → 下面橫切出終端
-- 在執行視窗裡：
--   程式要輸入（scanf / input）直接打
--   <Esc><Esc> 回到普通模式（可以捲動、複製輸出）
--   q          關掉執行視窗（普通模式下）
--   F5 / F6    重新執行
-- 再按一次 F5 會先關掉舊的執行視窗，所以畫面不會越切越多。
--
-- 編譯出來的執行檔放在 ~/.cache/nvim/runner/，不會弄髒你的資料夾。
-- 程式的「目前資料夾」是原始檔所在的資料夾，所以讀相對路徑的檔案沒問題。

local M = {}

-- 每種語言的指令。%f = 原始檔完整路徑，%o = 執行檔路徑
-- 想改或新增：在 lua/config/local.lua 寫
--   require("config.runner").commands.cpp = "g++ -std=c++17 %f -o %o && %o"
M.commands = {
    c          = "cc -std=c17 -Wall -Wextra -O2 -g %f -o %o -lm && %o",
    cpp        = "c++ -std=c++20 -Wall -Wextra -O2 -g %f -o %o && %o",
    python     = "python3 %f",
    lua        = vim.fn.executable("lua") == 1 and "lua %f" or "nvim -l %f",
    sh         = "sh %f",
    bash       = "bash %f",
    zsh        = "zsh %f",
    fish       = "fish %f",
    javascript = "node %f",
    typescript = "npx --yes tsx %f",
    go         = "go run %f",
    rust       = "rustc --edition 2021 %f -o %o && %o",
    java       = "java %f",          -- Java 11 以上可以直接跑單一檔案
    ruby       = "ruby %f",
    perl       = "perl %f",
}

local outdir = vim.fn.stdpath("cache") .. "/runner"
local state = { buf = nil, src_win = nil }

local function close_runner()
    if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        -- 刪掉 buffer 會順便結束還在跑的程式、關掉視窗
        vim.api.nvim_buf_delete(state.buf, { force = true })
    end
    state.buf = nil
end

local function build_command(template)
    local file = vim.fn.expand("%:p")
    local out = outdir .. "/" .. vim.fn.expand("%:t:r")
    -- 用函式當替換值，避免檔名裡的 % 被 gsub 誤判
    local cmd = template
        :gsub("%%f", function() return vim.fn.shellescape(file) end)
        :gsub("%%o", function() return vim.fn.shellescape(out) end)
    -- 結束後印出回傳值（0 = 正常）
    return cmd .. [[; printf '\n\033[90m[結束，回傳值 %d]  q 關閉 · F5/F6 重跑\033[0m\n' $?]]
end

---@param direction "vertical"|"horizontal"
function M.run(direction)
    -- 如果游標在檔案樹或執行視窗裡，就回到原本的程式碼視窗
    if vim.bo.buftype ~= "" then
        if state.src_win and vim.api.nvim_win_is_valid(state.src_win) then
            vim.api.nvim_set_current_win(state.src_win)
        else
            vim.notify("請先切到程式碼視窗再按 F5", vim.log.levels.WARN)
            return
        end
    end

    local ft = vim.bo.filetype
    local template = vim.b.runner_cmd or M.commands[ft]
    if not template then
        vim.notify("F5 還不支援這種檔案：" .. (ft ~= "" and ft or "（沒有類型）")
            .. "\n可以用 :RunnerSet <指令> 幫這個檔案指定", vim.log.levels.WARN)
        return
    end
    if vim.fn.expand("%") == "" then
        vim.notify("這個檔案還沒有名字，先 :w 檔名 存起來", vim.log.levels.WARN)
        return
    end

    vim.cmd("silent! write")
    vim.fn.mkdir(outdir, "p")
    local cmd = build_command(template)
    local cwd = vim.fn.expand("%:p:h")

    close_runner()
    state.src_win = vim.api.nvim_get_current_win()

    if direction == "vertical" then
        vim.cmd("rightbelow vsplit")
        vim.api.nvim_win_set_width(0, math.floor(vim.o.columns * 0.4))
    else
        vim.cmd("rightbelow split")
        vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.3))
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    state.buf = buf

    -- 用 sh 跑，不管你的 shell 是 fish 還是 zsh，指令語法都一樣
    vim.fn.jobstart({ "sh", "-c", cmd }, { term = true, cwd = cwd })

    local wo = vim.wo
    wo.number, wo.relativenumber, wo.signcolumn = false, false, "no"
    vim.bo[buf].bufhidden = "wipe"

    local opts = { buffer = buf, silent = true }
    vim.keymap.set("n", "q", close_runner, opts)
    vim.keymap.set({ "n", "t" }, "<F5>", function() M.run("vertical") end, opts)
    vim.keymap.set({ "n", "t" }, "<F6>", function() M.run("horizontal") end, opts)

    vim.cmd("startinsert")  -- 直接進輸入模式，程式要讀鍵盤也能打
end

function M.setup()
    vim.keymap.set("n", "<F5>", function() M.run("vertical") end, { desc = "執行（右邊）" })
    vim.keymap.set("n", "<F6>", function() M.run("horizontal") end, { desc = "執行（下面）" })
    -- 打字打到一半直接按：先離開輸入模式再執行
    vim.keymap.set("i", "<F5>", "<Esc><cmd>lua require('config.runner').run('vertical')<cr>")
    vim.keymap.set("i", "<F6>", "<Esc><cmd>lua require('config.runner').run('horizontal')<cr>")

    -- :RunnerSet python3 %f arg1 arg2   幫目前這個檔案指定專屬指令（例如要帶參數）
    vim.api.nvim_create_user_command("RunnerSet", function(o)
        vim.b.runner_cmd = o.args ~= "" and o.args or nil
        vim.notify("這個檔案的執行指令：" .. (vim.b.runner_cmd or "（恢復預設）"))
    end, { nargs = "*" })
end

return M
