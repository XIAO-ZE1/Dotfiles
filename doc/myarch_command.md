# 前言

经过对archlinux的一系列配置和软件安装，相信你已经迫不及待愉快开发了！linux的命令行操作是必不可少的，以下列举一些常见操作知识

## Pacman 软件管理器

```zsh
sudo pacman -S package_name # 安装软件包
pacman -Ss # 在同步数据库中搜索包，包括包的名称和描述
sudo pacman -Syu # 升级系统。 -y:标记刷新、-yy：标记强制刷新、-u：标记升级动作（一般使用 -Syu 即可）
sudo pacman -Rns package_name # 删除软件包，及其所有没有被其他已安装软件包使用的依赖包
sudo pacman -R package_name # 删除软件包，保留其全部已经安装的依赖关系
pacman -Qi package_name # 检查已安装包的相关信息。-Q：查询本地软件包数据库
pacman -Qdt # 找出孤立包。-d：标记依赖包、-t：标记不需要的包、-dt：合并标记孤立包
sudo pacman -Rns $(pacman -Qtdq) # 删除孤立包
sudo pacman -Fy # 更新命令查询文件列表数据库
pacman -F some_command # 当不知道某个命令属于哪个包时，用来在远程软件包中查询某个命令属于哪个包（即使没有安装）
pactree package_name # 查看一个包的依赖树

yay 的用法和 Pacman 是基本一样的。有额外几条常用命令：
yay # 等同于 yay -Syu
yay package_name # 等同于 yay -Ss package_name && yay -S package_name
卸载软件包：使用 yay -Rns package_name 卸载软件包
yay -Ps # 打印系统统计信息
yay -Yc # 清理不需要的依赖

# 清理软件包缓存及孤立包
sudo pacman -Rns $(pacman -Qtdq) # 如上文所述，删除孤立软件包（常用）
sudo pacman -Sc # 删除当前未安装的所有缓存包和未使用的同步数据库（可选）
sudo pacman -Scc # 从缓存中删除所有文件，这是最激进的方法，不会在缓存文件夹中留下任何内容（一般不使用）
paccache -r # 删除已安装和未安装包的所有缓存版本，但最近 3 个版本除外
rm -rf ~/.cache/yay # 如果使用了 yay 来安装 AUR 中的软件包的话，可以选择清理 yay 的缓存目录
```

## systemctl 系统服务的介绍与操作,以 dhcpcd 服务为例

```zsh
systemctl start dhcpcd # 启动服务
systemctl stop dhcpcd # 停止服务
systemctl restart dhcpcd # 重启服务
systemctl reload dhcpcd # 重新加载服务以及它的配置文件
systemctl status dhcpcd # 查看服务状态
systemctl enable dhcpcd # 设置开机启动服务
systemctl enable --now dhcpcd # 设置服务为开机启动并立即启动这个单元
systemctl disable dhcpcd # 取消开机自动启动
systemctl daemon-reload dhcpcd # 重新载入 systemd 配置。扫描新增或变更的服务单元、不会重新加载变更的配置
```

## 对系统了如指掌

```zsh
# 使用pacman来列出所有显式安装的软件包（不包括依赖项）
pacman -Qe
pacman -Qe > ~/explicit_packages.txt # 还可以将列表导出到文件以便记录,我放在了普通用户目录下

sudo pacman -Rns $(pacman -Qtdq) # 删除孤立软件包（常用）
yay -Rns

sudo pacman -Syu # 系统升级，开滚！
yay # yay也是！

systemctl list-unit-files --state=enabled # 查看所有启用的系统服务（systemd）
systemctl list-units --type=service --state=running # 要查看所有活跃的服务

alias # 查看所有别名
# 永久创建别名
echo "alias ll='ls -alF'" >> ~/.zshrc
source ~/.zshrc

# 查看包含警告和错误的最新日志（最实用！）
journalctl -p 3..4 -b --since="10 minutes ago"
```

## git管理备份

### /etc:etckeeper

```zsh
# 使用etckeeper来跟踪/etc目录的变化
sudo pacman -S etckeeper
cd /etc
sudo etckeeper init
sudo etckeeper commit "Initial commit - pristine system state" # 每当你手动修改了配置​​，都可以提交一次，​​每当你用 pacman安装或更新软件包时​​，etckeeper会自动执行一次提交，记录下软件包安装前后 /etc目录的所有变化。这样你就知道是哪个包的安装导致了配置变更。
git checkout -- <文件名> # 恢复某个文件
git reset --hard <某个旧版本号> # 回滚
sudo git log --oneline # 查看简洁的提交历史
sudo git log -p # 查看详细历史，包括每次修改的具体内容

```

### dotfiles:git+stow 我的dotfiles：<https://github.com/XIAO-ZE1/Dotfiles>

使用dotfiles来管理.开头的配置文件，可以统一管理用户的自定义配置，本体放在dotfiles目录下，软链接到原来的位置
再用git和github可以分享配置，实现快速部署配置文件和多设备同步配置

```zsh
# 配置文件使用stow统一管理dotfiles，同步到github仓库，实现快速部署配置文件
sudo pacman -S stow
mkdir ~/dotfiles
cd ~/dotfiles

# 例如迁移.zshrc，链接到~/目录下
mkdir ~/dotfiles/zsh
mv ~/.zshrc ~/dotfiles/zsh
stow --verbose zsh
# 如果要链接到~/.config下的文件
mkdir ~/dotfiles/nvim/.config/nvim
mv ~/.config/nvim ~/dotfiles/nvim/.config/nvim
stow --verbose nvim

# 之后使用git版本控制(根据自己情况配置.gitignore文件)
git init
git add .zshrc
git commit -m "Initial commit: core dotfiles and configs"

# 使用ssh链接github仓库
# 1. 生成 SSH 密钥（如果还没有）
ssh-keygen -t ed25519 -C "your_email@example.com"
# 2. 将公钥添加到 GitHub
cat ~/.ssh/id_ed25519.pub
# 复制输出内容到 GitHub → Settings → SSH and GPG keys
# 3. 修改远程仓库地址为 SSH 协议
git remote set-url origin git@github.com:你的用户名/dotfiles.git
# 4. 测试连接
ssh -T git@github.com
git push -u origin main
git ls-files # 显示已跟踪

# 每次配置，添加修改的文件
git add .zshrc 
git commit -m "Update Zsh prompt settings"
git push

git clone https://github.com/你的用户名/dotfiles.git ~/dotfiles # 在新机器上恢复环境​​
cd ~/dotfiles
stow -t ~ .  # 一键重建所有符号链接
```
