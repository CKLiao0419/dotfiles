# dotfiles

Nord 主題、跨 macOS / Linux、從 Apple Silicon 到 32 位元 ThinkPad R50e 都能用的終端設定。

```sh
git clone https://github.com/<你的帳號>/dotfiles ~/dotfiles
cd ~/dotfiles && ./install.sh
```

## 結構

每個資料夾是一個 **stow 套件**，裡面的路徑＝它在家目錄裡的路徑：

```
dotfiles/
├── fish/.config/fish/...        → ~/.config/fish/...
├── tmux/.config/tmux/tmux.conf  → ~/.config/tmux/tmux.conf
├── starship/  kitty/  lf/  bat/  git/  lazygit/  btop/  fastfetch/  bash/
├── packages/   各平台要裝的軟體（不是 stow 套件）
├── docs/       規劃與教學（不是 stow 套件）
└── install.sh  一鍵部署
```

## 機器專屬設定（不進 git）

| 檔案 | 用途 |
|---|---|
| `~/.gitconfig` | git 的 name / email |
| `~/.config/fish/local.fish` | 這台機器的 PATH、API key |
| `~/.config/tmux/local.conf` | 例如 eeePC 想把狀態列移到上面 |
| `~/.config/kitty/local.conf` | 這台的字體大小 |
| `~/.bashrc.local` | bash 備援用 |

## 文件
- [docs/PLAN.md](docs/PLAN.md) — 軟體選型、各機器分層、rice 路線圖
- [docs/GIT.md](docs/GIT.md) — 怎麼用 git 管理這份 config
- [docs/CHEATSHEET.md](docs/CHEATSHEET.md) — 快捷鍵速查
