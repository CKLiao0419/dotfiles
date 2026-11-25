# 快捷鍵速查

## fish
| 鍵 / 縮寫 | 作用 |
|---|---|
| → 或 Ctrl-F | 接受灰字建議 |
| Tab | 補全選單 |
| Ctrl-R | fzf 搜歷史 |
| Ctrl-T | fzf 搜檔案，插入路徑 |
| Alt-C | fzf 搜資料夾並 cd |
| Ctrl-O | 開 lf，離開時 cd 到最後的資料夾 |
| `z 關鍵字` / `zi` | zoxide 跳到常去的資料夾 / 用選單挑 |
| `t` | tmux 接回 main session |
| `ll` `la` `lt` | eza 列表 / 含隱藏檔 / 樹狀 |
| `gs` `ga` `gc` `gp` `gl` `glg` `lg` | git 縮寫、lazygit |
| `dot` | cd ~/dotfiles |

## tmux（prefix = Ctrl-b）
| 鍵 | 作用 |
|---|---|
| prefix `|` / `-` | 左右 / 上下分割 |
| prefix `h j k l` | 移動 pane |
| prefix `H J K L` | 調整 pane 大小（可連按） |
| prefix `z` | 放大 / 還原目前 pane |
| prefix `c` | 新視窗 |
| prefix `1`…`9` | 切到第 N 個視窗 |
| prefix `Tab` | 上一個視窗 |
| prefix `d` | 離開（session 繼續在背景跑） |
| prefix `[` | 複製模式，`v` 選取 `y` 複製 |
| prefix `r` | 重新載入設定 |
| prefix `s` | 選 session |

## lf
| 鍵 | 作用 |
|---|---|
| `h j k l` | 上一層 / 下 / 上 / 進入 |
| `.` | 顯示隱藏檔 |
| 空白 | 選取 |
| `y` `x` `p` | 複製 / 剪下 / 貼上 |
| `D` | 刪除 |
| `a` / `A` | 新資料夾 / 新檔案 |
| `E` | 解壓縮 |
| `gh` `gc` `gd` | 跳到 ~ / ~/.config / ~/dotfiles |
| Ctrl-F | fzf 跳轉 |
| `q` | 離開 |

## nvim（leader = 空白鍵）
| 鍵 | 作用 |
|---|---|
| **F5** / **F6** | 存檔＋編譯＋執行，右邊直切 / 下面橫切（再按一次會重跑，不會越切越多） |
| 執行視窗裡 `<Esc><Esc>` → `q` | 回到普通模式 → 關掉執行視窗 |
| `:RunnerSet 指令` | 幫這個檔案指定執行指令（例：`:RunnerSet python3 %f input.txt`） |
| `空白 e` / `空白 o` | 檔案樹 開關 / 在樹和編輯區之間跳 |
| Ctrl-hjkl | 在視窗之間移動 |
| Ctrl-P、`空白 fg` | 找檔案、全專案搜尋文字 |
| Shift-h / Shift-l、`空白 x` | 上一個 / 下一個分頁、關閉分頁 |
| Ctrl-S、Ctrl-/ | 存檔、註解 |
| Alt-j / Alt-k | 整行上下移 |
| Tab / Shift-Tab / Enter | 補全選單上下選 / 確定 |
| `K`、`gd`、F2、`空白 ca` | 看說明、跳到定義、改名、自動修正 |
| `空白 d`、`[d` `]d` | 看錯誤、上一個 / 下一個錯誤 |
| `空白 tt` | 切換透明背景 |
| 檔案樹裡 `a` `r` `d` `H` | 新增（結尾加 / 是資料夾）、改名、刪除、顯示隱藏檔 |
