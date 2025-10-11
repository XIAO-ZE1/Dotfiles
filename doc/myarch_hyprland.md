# hyperland

>hyperland
<https://www.vindo.cn/blog/hyprland-arch-linux>
<https://lixuannan.github.io/posts/34336.html>
<https://cascade.moe/posts/hyprland-configure/>

参考dotfiles config
<https://github.com/kmephistoh/dotfiles/tree/main/config>
<https://github.com/Isoheptane/dotfiles/tree/blog-example>
<https://github.com/theniceboy/.config/tree/master>
<https://github.com/Fireond/dotfiles/tree/main>

本来想试试`hyprland`这种平铺式窗口管理器，但是各种配置文件确实让我眼花缭乱。
不过，我找到了 [end-4 hyprland](https://github.com/end-4/dots-hyprland) 这个点文件项目，开箱即用，界面美观，配置方便。
于是我决定搞 KDE plasma6 和 hyprland 两者共存，通过在 `sddm` 登录界面来选择进入哪个环境。

因为 end-4 是通过脚本一键安装部署的，会覆盖掉原本的配置(新安装的纯净系统或与点文件中配置无冲突的，无需有这个顾虑)，要备份好原有的配置。
我备份的有 `~/.config` 下的 dolphinrc，kdeglobals，Kvantum，其他倒是没什么冲突的。
这个 hyprland 项目使用的是 `kitty` 终端，`fish` shell工具
而我配置的 KDE plasma 用的是 `konsole` 终端，`zsh` shell工具

## illogical-impulse/end-4 hyprland

[官方文档](https://ii.clsty.link/zh-cn/i-i/01setup/)

一行命令一键部署

```zsh
bash <(curl -s "https://ii.clsty.link/setup.sh") ~/Downloads/dots-hyprland
```

## `hypr` 配置文件位置

```zsh
cd ~/.config/hypr
```

## `kitty` hyperland 默认的终端模拟器

```zsh
kitty +kitten themes # 选择主题
Catppuccin-Mocha # 我选择这个，根据引导配置，按M修改配置文件，配置文件在~/.config/kitty/kitty.conf 没有就新建
# 快捷键 ctrl+shift+F5 立即应用配置文件
```

配置文件位置

```zsh
cd ~/.config/hypr
```

## important

这个项目的配置文件相当完善了，可以参考各个工具的官方文档自行修改配置，我对配置文件做了一些简要修改补充。具体内容请参考[我的dotfiles项目](https://github.com/XIAO-ZE1/Dotfiles)中的相关内容
