# 欢迎加入Arch神教

此文章主要记录了我的`archlinux`配置和使用，如果在参考这篇文章时遇到问题，强烈建议前往`arch wiki`寻求帮助，几乎所有关于linux的问题都能在wiki找到答案。

如果你对`linux`完全不了解，那么光是安装系统就有上手门槛，建议先使用开箱即用的`debian系`或`红帽系`的稳定发行版中学习一番linux。我与linux初次接触是树莓派4B的基于debian11的`Raspbian os`，在arm平台对于linux有一定的应用学习之后，才想要将电脑换作linux操作系统用于日常开发的，不过我的娱乐主机还是`Windows`系统(毕竟一些专有软件和n卡游戏适配还是无可替代的)。现在我还有一台`debian12`的香橙派5用作服务小主机，用于托管网站和docker应用，味道好极了。

- `Arch linux`是滚动发行的，每个工具组件都是最新的，你能体验到linux世界最前沿的技术和信息。
- `AUR`无疑是Arch linux的宝藏。你能找到你想要找寻的各种软件（或其替代品），一行命令就可以搞定，一键安装，滚动更新，告别复杂环境。
- `极致`的简洁和控制，摒弃掉你不需要的内容，不会像Windows一样一大堆不认识的进程和卸载不了的系统组件，arch允许你定制你所想要的组件，完全掌控你的系统。

>建议在开始之前先看一下[这个](https://arch.icekylin.online/guide/prepare/head-on-blow.html)，详细了解一番`archlinux`。

## 参考

参考文档教程和arch wiki里有详细全面的讲述，我会尽可能面面俱到讲述我的选择和感受给予参考，记住，只有适合自己的才是最好的。遇到不懂的问题可以多问下AI。

>全面的教程安装和配置 <https://archlinuxstudio.github.io/>
>也可以看这个：archlinux 简明指南，是前者的派生文档 <https://arch.icekylin.online/>
>现代化的 Archlinux 安装，Btrfs、快照、休眠以及更多 <https://sspai.com/post/78916>
>archlinux wiki 中文社区，最全面的linux wiki，有什么困难就在这里找找看吧 <https://www.archlinuxcn.org/>
>如果遇到中文社区有滞后性，可以到官方archwiki <https://wiki.archlinux.org/title/Main_page>
>win11双系统利用archinstall脚本安装教程，b站视频 <https://www.bilibili.com/video/BV12ZghzgEjs/?spm_id_from=333.337.search-card.all.click>

## 安装

arch不会像debian或ubuntu等发行版给你一个开箱即用的安装引导，arch安装需要用命令行一步一步配置，但操作下来你会对系统安装有一个全面的认识。

>不过现在有`archinstall`安装脚本，命令行连接网络后运行`archlinux`基本可以安装一步到位。这部分内容我参考的[b站视频](https://www.bilibili.com/video/BV12ZghzgEjs/?spm_id_from=333.337.search-card.all.click)，使用了`archinstall`。

### 连接网络(wifi连接)

进入交互式命令行

```zsh
iwctl
```

列出无线网卡设备名，比如无线网卡看到叫 wlan0

```zsh
device list
```

扫描网络

```zsh
station wlan0 scan 
```

列出所有 wifi 网络

```zsh
station wlan0 get-networks 
```

进行连接，注意这里无法输入中文。回车后输入密码即可

```zsh
station wlan0 connect wifi-name 
```

连接成功后退出

```zsh
exit
```

运行archlinux安装脚本，根据交互式提示完成安装(具体选择参看视频或参考文档)

```zsh
archinstall
```

### 在此记录下我的情况：我是win11+archlinux双系统，共享一块1T硬盘

- Windows是`200G的C盘系统盘`，`300M的EFI分区`，`16M的MBR保留分区`。
- linux是`500M的EFI分区`，`284G的btrfs分区`(btrfs挺好用，快照功能很适合滚动发行的arch，这个分区是根目录和home目录，linux占用不了多少空间，100G都行)，`16G的swap分区`(我这里是用于硬盘休眠的，不过用swap文件也可以，配置稍微麻烦，但是大小可变)。
- 剩下的都是NTFS的`D盘`，用于存储图片，文档等资源(linux可以直接访问ntfs格式的c盘和d盘(通过ntfs-3g实现)，而windows访问linux的brtfs内容可以用github上的项目实现，我是以linux为主力，就用不到)。
- archlinux + kde桌面系统 (+ hyprland窗口管理器)

`win和linux双系统`使用脚本安装的话建议linux和Windows的boot(EFI)分区区分开，在电脑UEFI界面设置以`archlinux boot`为先发顺序，这样后续就可以在grub引导页面用`archlinux boot`引导打开`win11 boot`进入Windows系统了。命令行安装的话两个系统的boot可以放在一起(最好安装win时直接boot分区给1G)，手动配置相关文件。

小声bb：在linux初学阶段安装了arch，终端编辑都用的`nano`，之后用了`vim`和`nvim`，真的很好用，vscode我都用的neovim插件来操作哈哈哈。鉴于nano易于上手(跟window的notepad差不多)，所以本文档多以nano编辑，也可以花一个小时学习下vim慢慢操作熟悉，你会感受到键盘操作的乐趣的！

>另外，现在windows系统的wsl子系统也有archlinux了，下载wsl2后运行wsl --install archlinux即可下载，这个系统下载之后任何内容包括sudo，nano等工具都没有，需要自己手动下载，可控性极强，也可以下载个桌面。注意wsl默认NAT模式下无法让wsl的arch使用windows下的网络代理，需要先进行配置，详见<https://blog.csdn.net/2301_79224952/article/details/147443235>

## 汉化

安装谷歌开源字体及表情

```zsh
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-dejavu ttf-liberation
```

`编辑`取消#号注释

```zsh
sudo nano /etc/locale.gen
zh_CN.UTF-8 UTF-8
```

生成 locale 信息

```zsh
sudo locale-gen
sudo echo 'LANG=zh_CN.UTF-8'  > /etc/locale.conf
```

最后打开系统设置 点击`区域和语言`设置为中文，`重启`后即可看到已经实现汉化

>【故障时 可选操作】部分设备在设置系统语言后仍然出现部分设置为英文的情况（比如右键、部分菜单设置项）修改 ~/.config/plasma-localerc 中的为zh_CN可以zh_CN.UTF-8解决

## 设置win11和archlinux双系统引导

`编辑`这个修改可以让开机更快

```zsh
cd /
sudo nano /etc/default/grub
loglevel=5 nowatchdog
```

！！！根据实际情况选择windows系统的efi分区进行挂载(`我这里是nvme0n1p1`)

```zsh
sudo -i
lsblk
mount /dev/nvme0n1p1 /mnt

os-prober
grub-mkconfig -o /boot/grub/grub.cfg
```

之后重启即可看到`grub`引导界面有arch也有win了

## 用户/用户组/主机操作

添加用户和密码并加入wheel用户组

```zsh
sudo useradd -m xiaoze
sudo passwd  xiaoze
sudo usermod -aG wheel  xiaoze
```

`编辑`配置wheel用户组可以提权

```zsh
sudo nano /etc/sudoers # 或sudo visudo
%wheel ALL=(ALL:ALL) ALL # 取消这一行注释
```

`编辑`配置主机名

```zsh
sudo nano /etc/hostname
sudo nano /etc/hosts
127.0.0.1       arch.localdomain        arch
```

## 开启pacman 32 位支持库与 Arch Linux 中文社区仓库

```zsh
nano /etc/pacman.conf
```

`编辑`

```conf
# 去掉 [multilib] 一节中 下列两行的前 # 号注释，来开启 32 位库支持
[multilib]
Include = /etc/pacman.d/mirrorlist

# 之后在 [options] 下找到并取消注释：
# Color，启用彩色高亮；
# VerbosePkgLists，在安装或升级软件时显示详细变化；

# 在文档最后新启一行 结尾处加入下面的文字，来添加 archlinuxcn 源。推荐的镜像源一并列出：
[archlinuxcn]
Server = https://mirrors.bfsu.edu.cn/archlinuxcn/$arch
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
Server = https://mirrors.hit.edu.cn/archlinuxcn/$arch
Server = https://repo.huaweicloud.com/archlinuxcn/$arch
```

退出后运行此命令生效

```zsh
pacman -Syyu
```

【必要操作】执行安装 archlinuxcn 源所需的相关步骤
CN源中的签名（`archlinuxcn-keyring` 在 archlinuxcn）

```zsh
sudo pacman -S archlinuxcn-keyring
```

安装 `yay` 可以让用户安装 AUR 中的软件（yay 在 archlinuxcn）

```zsh
sudo pacman -S yay
```

## 输入法

### 安装`fcitx`必要的软件包

输入法基础包组 官方中文输入引擎

```zsh
sudo pacman -S fcitx5-im fcitx5-chinese-addons
```

日文输入引擎

```zsh
sudo pacman -S fcitx5-anthy
```

输入法主题(可选)

```zsh
sudo pacman -S fcitx5-material-color
```

### 配置输入法

>在我使用过程中，Electron 应用在 Wayland 下默认使用 ibus​​，而不是 fcitx，导致无法输入中文。​​Wayland 的输入法协议（IME）支持不如 X11 成熟​​，部分应用可能无法正确调用 Fcitx，比如vscode，linuxQQ这些
参考<https://blog.csdn.net/ZxeeGX/article/details/148777778> 来修改配置，或按照我的操作直接使用x11的方法，我这里编辑etc环境变量，让所有用户都生效

```zsh
sudo nano /etc/environment
```

`编辑`输入 Fcitx 5 输入法环境变量

```conf
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
```

重启即可

### 安装 Windows 字体(可选)

建立 archlinux 下存放 Windows 字体的文件夹

```zsh
sudo mkdir /usr/share/fonts/WindowsFonts
```

进入 Windows 磁盘的 Fonts 文件夹，将字体复制到建立的文件夹并设置合理的权限
(或者通过 Dolphin 在此文件夹下点击右键 > 打开终端)

```zsh
cd /path/to/C:/Windows/Fonts
sudo cp ./*/usr/share/fonts/WindowsFonts
sudo chmod 755 /usr/share/fonts/WindowsFonts/*
```

刷新字体

```zsh
fc-cache -vf
```

后续要安装其他字体也就使用pacman一行命令的事

### `Rime输入法`是一款开源、高度可定制​​的输入法引擎，推荐使用，相比官方引擎更个性化

```zsh
sudo pacman -S fcitx5-rime
```

[雾凇拼音](https://github.com/iDvel/rime-ice)，第三方优化的Rime配置方案，rime官方配置是冰蟾全息

```zsh
yay -S rime-ice
nano ~/.local/share/fcitx5/rime/default.custom.yaml
```

`编辑`

```yaml
patch:
# 仅使用「雾凇拼音」的默认配置，配置此行即可
  __include: rime_ice_suggestion:/
# 以下根据自己所需自行定义
  __patch:
    #候选词个数
    menu/page_size: 5
```

增加萌娘百科词库

```zsh
yay -S rime-pinyin-moegirl
cp /usr/share/rime-data/rime_ice.dict.yaml ~/.local/share/fcitx5/rime/rime_ice.dict.yaml
nano ~/.local/share/fcitx5/rime/rime_ice.dict.yaml
```

`编辑`

```yaml
import_tables:
  ...
  ...

- moegirl
```

打开 `系统设置 > 虚拟键盘` 选择 Fcitx：
接下来`系统设置 > 输入法` 添加输入法`中州韵`，`配置附加组件`点选配置云拼音(不同版本kde plasama可能操作有差异)
默认通过 `Ctrl + 空格` 切换中英文输入(我是把快捷键改为了`右shift`，因为和我的vscode快捷键冲突了哈哈哈)

>【故障时可选操作】检查一下是否有拼写错误，如果输入法无法正常切换，可尝试执行 fcitx5-diagnose 命令来诊断问题的原因。

英文输入时，按`ctrl+alt+h`，可以开启或关闭使用英文提示补全功能

## 基础功能包安装

声音固件`pipewire`

```zsh
sudo pacman -S  --needed sof-firmware alsa-firmware alsa-ucm-conf pipewire-pulse pipewire-alsa pipewire-jack wireplumber
```

通过以下命令开启蓝牙相关服务并设置开机自动启动：

>对于蓝牙及无线网卡，在 Linux 下推荐使用英特尔产品。博通以及瑞昱产品在兼容性，稳定性方面在 Linux 中表现很差，会带来很多不必要的麻烦，如在驱动，BLE 方面的支持很差或者没有
>如果你有蓝牙设备，需要安装蓝牙软件包并启用蓝牙服务。随后在系统设置中进行添加设备与连接即可。注意，文件传输功能现在需要额外安装包bluez-obex，其功能于 2024 年已从 bluez 包中分离出来

```zsh
sudo pacman -S bluez bluez-utils bluez-obex
sudo systemctl enable --now bluetooth
```

安装常用的`火狐`、`chromium` 浏览器

```zsh
sudo pacman -S firefox chromium
# 【】或者安装ungoogle-chromium,去除google的chromium
yay ungoogled-chromium-bin
```

确保 `Discover`（软件中心）可用，需重启

```zsh
sudo pacman -S packagekit-qt6 packagekit appstream-qt appstream
```

使系统可以识别 `NTFS` `exfat` 格式的硬盘

```zsh
sudo pacman -S ntfs-3g exfat-utils
```

安装几个开源`中文字体`。一般装上文泉驿就能解决大多 wine 应用中文方块的问题

```zsh
sudo pacman -S adobe-source-han-serif-cn-fonts wqy-zenhei wqy-microhei
```

## 解决KDE桌面环境加载Discover慢和加载失败的问题

参考[arch wiki 相关内容](https://forum.archlinuxcn.org/t/topic/11676/1)：

如果没有该文件，则自己新建一个。

```zsh
sudo vim /etc/xdg/providers.xml
```

`编辑`

```xml
<providers>
  <provider>
    <id>api.kde-look.org</id>
    <location>https://api.kde-look.org/ocs/v1/</location>
    <name>api.kde-look.org</name>
    <termsofuse>https://api.kde-look.org/content/terms</termsofuse>
    <register>https://api.kde-look.org/register</register>
    <services>
      <person ocsversion="1.6"/>
      <content ocsversion="1.6"/>
    </services>
  </provider>
</providers>
```

打开多试几次，实在不行或者无法安装依赖的话，就点击主页去官网手动下载安装，这应该是kde本身网络问题

## 添加或修改取消关机等待90s

`编辑`记得删除行首井号注释，把时间改成一个较短的时间，比如 3 秒，这样等待的时间就会大大缩短了。

```zsh
sudo nano /etc/systemd/system.conf
DefaultTimeoutStopSec=3s
sudo systemctl daemon-reload
```

## 安装系统备份还原软甲 `Timeshift`

### 安装和配置开机自启

```zsh
sudo pacman -S timeshift
sudo systemctl enable --now cronie.service
```

引导完成后建议执行下述指令删除 subvolid

```zsh
sudo sed -i -E 's/(subvolid=[0-9]+,)|(,subvolid=[0-9]+)//g' /etc/fstab
```

### 自动生成快照启动项

可以实现在每次使用 grub-mkconfig 重新生成 GRUB 启动项时，自动添加快照的启动入口，这样就算进不去桌面也能恢复快照

安装和启动 `grub-btrfs` 工具

```zsh
sudo pacman -S grub-btrfs
sudo systemctl enable --now grub-btrfsd.service
```

防止软件包升级会将编辑后的文件覆盖掉

```zsh
sudo systemctl edit --full grub-btrfsd
sudo nano /etc/systemd/system/grub-btrfsd.service
```

`编辑`修改ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots为：

```conf
ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto
```

这样 grub-btrfs 就会监视 Timeshift 创建的快照了。使用 `sudo grub-mkconfig` 手动运行的命令来生成grub配置文件，来达到更新快照列表

但手动太麻烦了，我们要之后每次创建快照后自动生成 grub 配置文件，一劳永逸

```zsh
sudo systemctl daemon-reload
sudo systemctl restart grub-btrfsd.service
```

## 系统快照（备份）

>1.若能够进入桌面环境 直接打开 Timeshift，选择快照后根据提示还原即可。
>2.若无法进入桌面环境 使用timeshift 还原快照

推荐用 `grub-btrfs` 创建的grub引导页arch快照入口，如果没有配置按照下面的操作：

通过 `Ctrl + Alt + F2 ~ F6` 进入 tty 终端,使用快照还原系统：

获取快照列表

```zsh
sudo timeshift --list
```

选择一个快照进行还原，并跳过 GRUB 安装，一般来说 GRUB 不需要重新安装

```zsh
sudo timeshift --restore --snapshot '20XX-XX-XX_XX-XX-XX' --skip-grub 
```

根据提示继续，完成还原

>3.若无法进入系统

此时系统一般已经完全崩溃，可以通过 `Live CD` 进行还原。（若使用 arch 安装盘请连接网络和配置好源后安装 Timeshift，然后通过命令行方式还原）

进入 Live 系统后打开 Timeshift，点击设置按钮，设置为原来快照的存储位置。选择快照后根据提示还原即可。
或者通过命令行进行还原，但需要首先设置原来快照存储的位置：

```zsh
sudo timeshift --restore --snapshot-device /dev/sdbx
```

后续步骤同 `若无法进入桌面环境`。

## 休眠到硬盘【需要已设置好 swap交换分区】

查看 `swap` 分区 `UUID` 后续需要

```zsh
lsblk -o name,mountpoint,size,uuid
```

修改文件

```zsh
sudo nano /etc/default/grub
```

`编辑`找到 `GRUB_CMDLINE_LINUX_DEFAULT` 一行，在其值后添加类似如下数据（根据你自身的 UUID 确定，参数之间以空格分隔）：【个个参数空格分开 填入双引号内】

```conf
resume=UUID=958f9084-6880-41e8-8b6a-fe93b1eb86c0
```

生效

```zsh
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

`编辑`

```zsh
sudo nano /etc/mkinitcpio.conf
# 在 HOOKS 行添加 resume 值。注意，resume 需要加入在 udev 后。若使用了 LVM 分区，resume 需要加入在 lvm2 后：生效
```

重新生成 initramfs 镜像

```zsh
sudo mkinitcpio -P
```

使用命令来手动休眠电脑，断开电源启动后还原到内存

```zsh
systemctl hibernate
```

但这样有些麻烦，我们可以配置在短按电源键或笔记本合盖时进入休眠状态
(不过`kde plasama`设置里面有电源管理部分，可以方便配置各种电源行为)

```zsh
sudo nano /etc/systemd/logind.conf
```

`编辑`

```conf
HandlePowerKey=hibernate # 短按电源键进入休眠
# HandleLidSwitch=hibernate # 合盖休眠
```

## `BBR` 算法优化 网络速度

查看自己的算法 以及检查是否是 bbr

```zsh
sysctl net.ipv4.tcp_congestion_control
```

`编辑`新建编辑文件加入下列两行

```zsh
sudo nano /etc/sysctl.conf
net.core.default_qdisc = cake
net.ipv4.tcp_congestion_control = bbr
```

生效并检验

```zsh
sudo sysctl -p
sysctl net.ipv4.tcp_congestion_control
```

## 显卡驱动

Intel 核芯显卡

```zsh
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel
```

【】AMD 集成显卡

```zsh
sudo pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon
```

【】独立显卡

```zsh
sudo pacman -S nvidia nvidia-open nvidia-settings lib32-nvidia-utils
```

如果同时拥有集成显卡与独立显卡的笔记本电脑，可以使用 optimus-manager 等工具自动切换。

`英伟达显卡`和`AMD集显`和`双显卡`具体配置参考官方文档，我只配置了intel核显

## 透明代理

v2rayA

```zsh
sudo pacman -S v2ray v2raya
sudo systemctl enable --now v2raya
```

【】[daed](https://github.com/daeuniverse/daed/blob/main/docs/getting-started.md)

```zsh
yay -S aur/dae aur/daed
sudo systemctl enable --now daed
```

【】[Clash-verge-rev](https://www.clashverge.dev/)  

```zsh
yay -S clash-verge-rev-bin
```

不多说，参考教程有特别详细的内容

## 其他

以下内容根据自己的情况配置，我是没有搞，具体内容参考[这个](https://sspai.com/post/78916)

### 【】ipv6 隐私拓展 具体可看<https://wiki.archlinuxcn.org/zh-tw/IPv6>

三个任意选一种查看 自己的网卡名

```zsh
ls /sys/class/net
ip link
iw dev
```

比如叫：wlp0s20f3 并且只有一个 按照下列写入，如果有多个 需要 nic1.wlp0s20f3 这样全部列举

```zsh
sudo nano /etc/sysctl.d/40-ipv6.conf
```

`编辑`

```conf
net.ipv6.conf.all.wlp0s20f3 = 2
net.ipv6.conf.default.wlp0s20f3 = 2
net.ipv6.conf.nic0.wlp0s20f3 = 2

# 模板
net.ipv6.conf.all.use_tempaddr = 2
net.ipv6.conf.default.use_tempaddr = 2
net.ipv6.conf.nic0.use_tempaddr = 2
...
net.ipv6.conf.nicN.use_tempaddr = 2
```

### 【】随机 MAC 地址

```zsh
sudo nano /etc/NetworkManager/conf.d/rand_mac.conf
```

`编辑`可以编辑并加入下列

```conf
[device-mac-randomization]
wifi.scan-rand-mac-address=yes

[connection-mac-randomization]
ethernet.cloned-mac-address=stable
wifi.cloned-mac-address=stable
```

`wifi.scan-rand-mac-address` :决定在 wifi 扫描时是否开启随机 MAC 地址，若需要固定的 MAC 地址，可以设为 no。

`ethernet.cloned-mac-address` 和 `wifi.cloned-mac-address` :决定连接有线网络和 wifi 网络时是否开启随机 MAC 地址，可用的值有：
`指定的 MAC 地址`，连接时使用手动指定的 MAC 地址；
`permanent`，不改变 MAC 地址；
`preserve`，在网卡激活后不改变 MAC 地址；
`random`，在每次连接时都使用随机 MAC 地址；
`stable`，在初次连接一个网络时使用随机 MAC 地址，之后每次连接相同的网络都使用相同的 MAC 地址。

修改完后重启 `NetworkManager` 服务生效。

### 【】时间同步 【默认也还行 没操作】

systemd 自带了一个 `systemd-timesyncd` 服务，提供了简单的时间同步服务，若是没有特别需求，这个服务已经够用了。不过这个服务默认使用的是 `Arch Linux` 自己的 `NTP 服务器`，在国内访问较慢，有时会导致时间同步失败，为了更快地同步时间，可以选用其他的 NTP 服务器，我选用了中国 NTP 快速授时服务和中国计量科学研究院 NIM 授时服务的 NTP 服务器，

```zsh
sudo nano /etc/systemd/timesyncd.conf
```

`编辑`

```conf
NTP=cn.ntp.org.cn ntp1.nim.ac.cn
```

然后重启 `systemd-timesyncd.service`，之后运行 `timedatectl timesync-status` 便可查看时间同步状态：

> timedatectl timesync-status
       Server: 2001:da8:9000::130 (cn.ntp.org.cn)
Poll interval: 34min 8s (min: 32s; max 34min 8s)
         Leap: normal
      Version: 4
      Stratum: 1
    Reference: PTP
    Precision: 1us (-26)
Root distance: 45us (max: 5s)
       Offset: -2.957ms
        Delay: 31.415ms
       Jitter: 4.354ms
 Packet count: 18
    Frequency: -4.740ppm

可以看到这里 offset 只有不到 3 毫秒，还是很精准的

### 【】设置 DNS

一般来说，如今大多电脑连接的路由器是可以自动处理 DNS 的，如果你的路由器不能处理，则需要额外进行 DNS 的设置。
同时，如果使用 ISP 提供的默认 DNS,你的网络访问记录将存在更大的，被泄露或被当局存储记录的风险。

除此之外，使用 ISP 提供的 DNS 还有可能将某些服务解析至一些已经失效或劣化的服务器。
即使你的网络环境可以自动处理 DNS 设置，我们还是建议你使用可信的国际通用 DNS 设置。

如下的配置将固定使用谷歌的 DNS,但是网络访问延迟可能增加。设置好代理后，你的 DNS 请求将均通过代理发送，这将在 DNS 发送方面最大限度的保障你的隐私和安全。

```zsh
vim /etc/resolv.conf
```

`编辑`删除已有条目，并将如下内容加入其中

```conf
# nameserver 223.5.5.5
# nameserver 208.67.222.222

nameserver 8.8.8.8
nameserver 2001:4860:4860::8888
nameserver 8.8.4.4
nameserver 2001:4860:4860::8844
```

如果你的路由器可以自动处理 DNS,resolvconf 会在每次网络连接时用路由器的设置覆盖本机 `/etc/resolv.conf` 中的设置，执行如下命令加入不可变标志，使其不能覆盖如上加入的配置

```zsh
sudo chattr +i /etc/resolv.conf

# 如果需要编辑文件 需要取消一下锁定
sudo chattr -i /etc/resolv.conf
```

## 结束

很好，你已经迈入了 `archlinux` 的大门，接下来，可以参阅我关于个性化配置dotfiles和安装软件software的内容。
以及，如果你想要体验目前先进的，专为高效开发打造的平铺式窗口管理器 `hyprland`，可以参阅我关于安装end-4 hyprland的内容。
总之，折腾的过程对于我而言就是一种乐趣，他会驱动我不断学习新知，不仅是那些炫技的奇技淫巧，更是那些能真正提升工作效率的实用技巧。

加入 `开源` 大家庭吧！
