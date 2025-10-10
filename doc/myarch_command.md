# 前言

经过对archlinux的一系列配置和软件安装，相信你已经迫不及待愉快开发了！linux的命令行操作是必不可少的，以下列举一些常见操作知识

## Pacman软件管理器

```zsh
sudo pacman -S package_name # 安装软件包
pacman -Ss # 在同步数据库中搜索包，包括包的名称和描述
sudo pacman -Syu # 升级系统。 -y:标记刷新、-yy：标记强制刷新、-u：标记升级动作（一般使用 -Syu 即可）

sudo pacman -Sc # 删除当前未安装的所有缓存包和未使用的同步数据库（可选）
sudo pacman -Scc # 从缓存中删除所有文件，这是最激进的方法，不会在缓存文件夹中留下任何内容（一般不使用）

sudo pacman -Rns package_name # 删除软件包，及其所有没有被其他已安装软件包使用的依赖包
sudo pacman -Rns $(pacman -Qtdq) # 删除孤立包
sudo pacman -R package_name # 删除软件包，保留其全部已经安装的依赖关系

pacman -Qi package_name # 检查已安装包的相关信息。-Q：查询本地软件包数据库
pacman -Qdt # 找出孤立包。-d：标记依赖包、-t：标记不需要的包、-dt：合并标记孤立包
pacman -Qe # 列出所有显式安装的软件包（不包括依赖项）

sudo pacman -Fy # 更新命令查询文件列表数据库
pacman -F some_command # 当不知道某个命令属于哪个包时，用来在远程软件包中查询某个命令属于哪个包（即使没有安装）

pactree package_name # 查看一个包的依赖树
paccache -r # 删除已安装和未安装包的所有缓存版本，但最近 3 个版本除外
```

yay 的用法和 Pacman 是基本一样的。有额外几条常用命令：

```zsh
yay -Ps # 打印系统统计信息
yay -Yc # 清理不需要的依赖
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

使用pacman来列出所有显式安装的软件包（不包括依赖项）

```zsh
pacman -Qe
# 还可以将列表导出到文件以便记录,我放在了普通用户目录下
pacman -Qe > ~/explicit_packages.txt 
```

删除孤立软件包(选用，孤立不代表不用)

```zsh
sudo pacman -Rns $(pacman -Qtdq)
yay -Yc
```

系统升级

```zsh
sudo pacman -Syu
yay
```

查看所有 `启用的系统服务`（systemd） 和 `活跃的服务`

```zsh
systemctl list-unit-files --state=enabled
systemctl list-units --type=service --state=running
```

别名

```zsh
# 查看所有别名
alias
# 永久创建别名
echo "alias ll='ls -alF'" >> ~/.zshrc
source ~/.zshrc
```

查看包含警告和错误的最新日志（最实用！）

```zsh
journalctl -p 3..4 -b --since="10 minutes ago"
```
