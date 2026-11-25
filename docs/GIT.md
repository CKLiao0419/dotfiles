# 用 git 管理 dotfiles

## 0. 先搞懂三個地方

```
工作目錄（你改的檔案）  ──git add──▶  暫存區  ──git commit──▶  本機歷史  ──git push──▶  GitHub
                                                                        ◀──git pull──
```

- **commit** 就是存檔點。每改好一件事（例如「tmux 狀態列加上時間」）就存一個。
- **push** 把存檔點送上 GitHub；別台機器 **pull** 拿下來。

## 1. 第一次：把 repo 推上 GitHub

repo 已經在本機建好、也做了第一個 commit。接下來：

```sh
# 1) 在 github.com 按 New repository，名字取 dotfiles，Public，「不要」勾 README
# 2) 回到終端：
cd ~/dotfiles
git remote add origin git@github.com:CKLiao0419/dotfiles.git
git push -u origin main
```

如果還沒設定 SSH key：
```sh
ssh-keygen -t ed25519           # 一路 Enter
cat ~/.ssh/id_ed25519.pub       # 複製這串，貼到 GitHub → Settings → SSH keys
ssh -T git@github.com           # 測試
```

## 2. 日常：改 config 的循環

因為是 symlink，直接改 `~/.config/...` 就是在改 repo。

```sh
v ~/.config/tmux/tmux.conf      # 改設定
# tmux 裡按 prefix + r 重新載入，確認沒壞

cd ~/dotfiles                   # 或打 dot
git status                      # 看改了哪些檔（縮寫：gs）
git diff                        # 看改了什麼（delta 會上色）
git add tmux                    # 把 tmux 套件的變更放進暫存區
git commit -m "tmux: 狀態列加上電池"
git push
```

或者直接開 `lazygit`（縮寫 `lg`）：空白鍵選檔案 → `c` 寫訊息 commit → `P` push。

### commit 訊息怎麼寫
格式：`套件: 做了什麼`，一個 commit 只做一件事。
```
fish: 加上 lf 的 Ctrl-O 快捷鍵
tmux: 窄螢幕自動隱藏主機名稱
kitty: 字體改成 18 號
```
二十年後回頭看 `git log` 就是你的 rice 日記。這就是老師那份 config「有積累」的意思。

## 3. 新機器：一行部署

```sh
git clone https://github.com/CKLiao0419/dotfiles ~/dotfiles
cd ~/dotfiles && ./install.sh
```
公開 repo 用 https clone 不需要登入。之後想在這台 push，再設 SSH key 並：
```sh
git remote set-url origin git@github.com:CKLiao0419/dotfiles.git
```

## 4. 多台機器同步

在任何機器開始改之前**先 pull**：
```sh
cd ~/dotfiles && git pull
```
改完 commit、push。另一台下次 pull 就拿到了。stow 建的是 symlink，所以 pull 之後**不用重新部署**；只有新增檔案時要再跑一次 `./install.sh`。

### 如果兩台都改了同一個地方（衝突）
`git pull` 會說 conflict。打開那個檔案會看到：
```
<<<<<<< ours
set -g status-position top
||||||| base
set -g status-position bottom
=======
set -g status-position bottom
set -g status-interval 1
>>>>>>> theirs
```
手動改成你要的樣子、刪掉 `<<<` `===` `>>>` 標記，然後：
```sh
git add tmux/.config/tmux/tmux.conf
git commit
```
避免衝突的最好方法：**這台專屬的設定放 local 檔案，不要放 repo**。

## 5. 公開 repo 的安全守則

- **永遠不要** commit API key、token、密碼、email → 放 `local.fish`
- `.gitignore` 已經擋掉 `local.fish`、`local.conf`、`fish_variables`
- commit 前一定 `git diff --staged` 看一眼
- 萬一不小心 push 了 key：**馬上去那個服務撤銷 key**。從 git 歷史刪掉是第二步，刪了也要當作已經外洩

## 6. 救命指令

| 狀況 | 指令 |
|---|---|
| 改壞了，想回到上次 commit 的樣子 | `git restore 檔案` |
| 剛 commit 完發現訊息打錯 | `git commit --amend` |
| 想撤銷上一個 commit（變更保留） | `git undo`（已設好的 alias） |
| 看某個檔案的歷史 | `git log -p -- tmux/.config/tmux/tmux.conf` |
| 看某一行是什麼時候改的 | `git blame tmux/.config/tmux/tmux.conf` |
| 想試大改又怕壞 | `git switch -c try-something`，不滿意 `git switch main` 回來 |

## 7. 實驗用分支

想試一個新配色或新 WM，又不想弄亂 main：
```sh
git switch -c gruvbox-test      # 開分支
# ...盡情改、commit...
git switch main                 # 回到原本的（設定立刻變回來，因為是 symlink）
git merge gruvbox-test          # 喜歡就合併
git branch -d gruvbox-test      # 不喜歡就刪掉
```
