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
