# 規劃

## 一、目標

一份 config，`git clone` + `./install.sh` 就能在任何機器上用。
新機器缺什麼工具都不會壞，只是少一點功能（**優雅降級**）。
像老師那樣用二十年：簡單、單檔、每一行都知道在幹嘛、不依賴外掛管理器。

## 二、你的機器分層

| 層級 | 機器 | CPU / 顯示 | 終端 | 建議系統 |
|---|---|---|---|---|
| A 完整 | 現在這台 Mac、A1466（MBA 13" 2012+）、A1278（MBP 2011）、X220i | 64 位元、OpenGL 3.3 | kitty + Nerd Font | macOS / Arch / Debian 13 |
| B 輕量圖形 | X61（Core 2 Duo，GMA X3100）、A1370（MBA 11"） | 64 位元、顯卡老 | st / foot / xterm（裝 Nerd Font） | Debian 13 / Void / Arch |
| C 純文字 | R50e、eeePC 701（800×480、512MB） | **32 位元** | Linux TTY 或 st | Debian 12 i386、Alpine x86、Void i686 |

C 層注意：
- **Debian 13 已經不再提供 i386 安裝程式**，32 位元請用 Debian 12（支援到 2028）或 Alpine。
- R50e、eeePC 的 Pentium M / Celeron M 有些不宣告 PAE，核心開機可能要加 `forcepae`，或用非 PAE 核心。
- TTY 看不到 Nerd Font 圖示 → config 偵測到 `TERM=linux` 時自動切換到純文字版 starship（`tty.toml`）、eza 不顯示圖示。
- eeePC 只有約 100 欄寬 → tmux 狀態列在寬度 < 90 時自動隱藏主機名稱。

## 三、軟體清單

| 類別 | 選擇 | 為什麼 | 沒裝時 |
|---|---|---|---|
| shell | **fish** | 你喜歡它的自動建議、上色、補全；開箱就有，不用外掛 | 退回 `bash/.bashrc` |
| 提示列 | **starship** | 一份 toml 同時給 fish / bash 用；有 i686 版本 | bash 用手寫 PS1 |
| 多工器 | **tmux**（prefix Ctrl-b） | 二十年穩定、每個發行版都有、SSH 斷線不丟工作 | — |
| 終端 | **kitty**（A 層）/ st、foot（B 層）/ TTY（C 層） | kitty 有圖片協定；老顯卡跑不動 GPU 終端 | — |
| 編輯器 | **neovim**（之後重構你的 init.lua） | | vim |
| 檔案管理 | **lf** + chafa / kitten icat | Go 寫的、單一執行檔、輕 | — |
| ls / cat | eza / bat | 顏色、圖示、語法高亮 | ls / cat |
| 搜尋 | fzf、zoxide、fd、ripgrep | Ctrl-R 歷史、`z` 跳資料夾 | find / grep |
| git | lazygit、delta | 圖形化 git、漂亮 diff | git 本身 / less |
| 截圖用 | fastfetch、btop | | — |
| dotfiles 管理 | **git + GNU stow** | stow 只用 perl，到處都有 | — |
| 配色 | **Nord** | 全部工具共用同一套色票 | — |

### 為什麼 fish 而不是 zsh
- 你真正在意的三個功能 fish 內建，zsh 要裝三個外掛
- 「fish 語法和 bash 不相容」只影響**互動輸入**；腳本開頭寫 `#!/bin/sh` 一樣用 sh 跑，所以 `install.sh` 和 lf 預覽腳本都不受影響
- 32 位元機器上 Debian 12 有 fish 3.6、Alpine 有 fish，都夠用
- 保底：每台機器都有 bash，`bash/.bashrc` 讓你在沒裝 fish 時也有一致的提示列和別名

### 為什麼 stow
stow **不是**像 git 那樣的版本控制工具，兩個是**分工合作**：

| | 負責 |
|---|---|
| git | 記錄 config 的歷史、同步到 GitHub、多台機器之間傳遞 |
| stow | 把 `~/dotfiles/fish/.config/fish/config.fish` 用 symlink 掛到 `~/.config/fish/config.fish` |

因為是 symlink，你直接編輯 `~/.config/fish/config.fish`，改的其實是 repo 裡的檔案，`git status` 立刻看得到。

## 四、rice 路線圖

### 階段 1：終端層（這次在 Mac 上完成）✅
fish、starship、tmux、kitty、lf、bat、eza、lazygit、btop、fastfetch 全部 Nord。

### 階段 2：neovim 重構 ✅
你把現在的 `init.lua` 給我，拆成 `lua/` 模組、Nord 主題，並加一份不需要外掛的 `vimrc` 給 C 層機器。之後放進 `nvim/` 套件。

### 階段 3：第一台 ThinkPad（建議從 X220i 開始）
1. 裝 Arch 或 Debian 13
2. `git clone` → `./install.sh` → 終端層直接到位
3. 開始桌面 rice：視窗管理器、狀態列、通知、啟動器（到時候再規劃，選項如 dwm / i3 / sway）

### 階段 4：老機器
- X61：Debian 13 + 輕量 WM + st
- R50e / eeePC：Debian 12 i386 或 Alpine，純 TTY + tmux + fish
  - TTY 也能 rice：用 `setvtrgb` 把主控台 16 色換成 Nord、換 Terminus 字型（`setfont ter-v16n`）

### 階段 5：差異化
每台機器的不同之處都寫在 `local.*` 檔案。如果某個差異「每台 Linux 都要」，就搬進 repo 用 `switch (uname -s)` 判斷。

## 五、之後要做的
- [x] 把 repo 推上 GitHub
- [x] 重構 nvim
- [ ] 告訴我你欣賞老師 tmux 的哪些地方，合進來
- [ ] Linux TTY 的 Nord 色票腳本
