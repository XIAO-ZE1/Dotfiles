# 记录我遇到的一些bug或者需要记下来的操作

## 蓝牙

遇到蓝牙设备连接不上，不要慌，试试systemctl restart bluetooth。如果这样也没反应，那就忘记设备重新配对，这样应该能解决。前提是你的蓝牙工具都配置好了。再不济就去arch wiki看看。

## reboot

如果你要在终端reboot，那么请一定确认你的代理是否关闭，我的v2ray如果没有正常关闭，那么reboot重启后，会直接满负载运行内存和cpu，给cpu干到90度

## 休眠到硬盘

手动命令：systemctl hibernate

## 切换桌面环境

systemctl restart sddm

## 长时间没有更新

`sudo pacman -Syu`时遇到了`错误：GPGME 错误：无数据`
通常是由于软件包数据库损坏或 PGP 签名问题导致的。
以下是解决该问题的步骤。

### 删除同步文件夹

首先，删除 `/var/lib/pacman/sync` 文件夹以清除可能的损坏数据。

```zsh
sudo rm -R /var/lib/pacman/sync
```

### 重新同步软件包数据库

然后，重新同步软件包数据库。

```zsh
sudo pacman -Syyu
```

### 初始化和填充密钥环

如果问题仍然存在，可以尝试重新初始化和填充密钥环。

```zsh
sudo pacman-key --init
sudo pacman-key --populate archlinux
```

### 刷新密钥环

最后，刷新密钥环以确保所有密钥都是最新的。

```zsh
sudo pacman-key --refresh-keys
```
