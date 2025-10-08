# 写在前面

此文章主要记录了我的archlinux配置和使用，如果在参考这篇文章时遇到问题，强烈建议前往arch wiki寻求帮助，几乎所有关于linux的问题都能在wiki找到答案。

如果你对linux完全不了解，那么光是安装系统就已经有了上手门槛，建议先使用开箱即用的debian系或红帽系的稳定发行版中学习一番linux。我与linux初次接触是树莓派的基于debian11的raspbian os，在arm平台对于linux有一定的应用学习之后，才想要将电脑换作linux操作系统用于日常开发的，不过我的娱乐主机还是windows系统(毕竟一些专有软件和游戏适配还是无可替代的)。现在我还有一台debian12的香橙派5用作服务小主机，用于托管网站和docker应用，味道好极了。

- Arch linux是滚动发行的，每个工具组件都是最新的，你能体验到linux世界最前沿的技术和信息。
- AUR无疑是Arch linux的宝藏。你能找到你想要找寻的各种软件（或其替代品），一行命令就可以搞定，一键安装，滚动更新，告别复杂环境。
- 极致的简洁和控制，摒弃掉你不需要的内容，不会像Windows一样一大堆不认识的进程和卸载不了的系统组件，arch允许你定制你所想要的arch，完全掌控你的系统。

以下内容仅作我个人一些安装配置的记录，基本涉及我对我的`archlinux`的所有配置，不会详细讲解为什么这样选择(只有适合自己的才是最好的)或者参数含义，因为github，wiki和参考文章都有详细的说明。

另外，我的普通用户为xiaoze，注意复制代码时家目录的路径，用户名替换成你的。

## 参考

>全面的教程安装和配置 <https://archlinuxstudio.github.io/>
>也可以看这个：archlinux 简明指南，是前者的派生文档 <https://arch.icekylin.online/>
>archlinux wiki 中文社区，最全面的linux wiki，有什么困难就在这里找找看吧 <https://www.archlinuxcn.org/>
>现代化的 Archlinux 安装，Btrfs、快照、休眠以及更多 <https://sspai.com/post/78916>
>win11双系统安装教程b站视频 <https://www.bilibili.com/video/BV12ZghzgEjs/?spm_id_from=333.337.search-card.all.click>
>KDE Plasma 6介绍 <https://www.vindo.cn/blog/arch-linux-kde6>
>终端命令替代工具wiki <https://wiki.archlinux.org/title/Core_utilities>
>软件推荐<https://www.oryoy.com/news/zhang-wo-arch-linux-zhuo-mian-ti-yan-sheng-ji-50-kuan-re-men-ruan-jian-shen-du-tui-jian.html><https://czyt.eu.org/post/arch-awesome-software/>
>以及我自己的dotfiles：<https://github.com/XIAO-ZE1/Dotfiles>

## 安装

arch不会像debian或ubuntu等发行版给你一个开箱即用的安装引导，arch安装用命令行一步一步配置，操作下来你会对系统安装有一个全面的认识。

不过现在有archinstall安装脚本，命令行连接网络后运行`archlinux`基本可以安装一步到位。这部分内容我参考的[b站视频](https://www.bilibili.com/video/BV12ZghzgEjs/?spm_id_from=333.337.search-card.all.click)，使用了`archinstall`。

连接网络

```zsh
iwctl 
# 进入交互式命令行
device list 
# 列出无线网卡设备名，比如无线网卡看到叫 wlan0
station wlan0 scan 
# 扫描网络
station wlan0 get-networks 
# 列出所有 wifi 网络
station wlan0 connect wifi-name 
# 进行连接，注意这里无法输入中文。回车后输入密码即可
exit
# 连接成功后退出
```

在此记录下我的情况：我是win11+archlinux双系统，共享一块1T硬盘

- Windows是`200G的C盘系统盘`，`300M的EFI分区`，`16M的MBR保留分区`。
- linux是`500M的EFI分区`，`284G的btrfs分区`(btrfs挺好用，快照很适合滚动发行的arch，这个分区是根目录和home目录，linux占用不了多少空间，100G都行)，`16G的swap分区`(我这里是用于硬盘休眠的，不过用swap文件也可以，配置稍微麻烦，但是大小可变)。
- 剩下的都是NTFS的`D盘`，用于存储图片，文档等资源(linux可以直接访问ntfs格式的c盘和d盘(通过ntfs-3g实现)，而windows访问linux的内容就很难了，github上面有这个东西，我是以linux为主力，就用不到)。
- archlinux + kde桌面系统 (+ hyprland窗口管理器)

`win和linux双系统`使用脚本安装的话建议linux和Windows的boot(EFI)分区区分开，在电脑UEFI界面设置以archlinux boot为先发顺序，这样后续就可以在grub引导页面用archlinux boot引导打开win11 boot进入Windows系统了。命令行安装的话两个系统的boot可以放在一起(最好安装win时直接boot分区给1G)，手动配置相关文件。

小声bb：在linux初学阶段安装了arch，终端编辑都用的`nano`，熟悉了命令行操作后用`vim`和`nvim`真的很好用，vscode我都用的neovim插件来操作哈哈哈。鉴于nano易于上手(跟window的notepad差不多)，所以本文档多以nano编辑，也可以花一个小时学习下vim慢慢操作熟悉，你会感受到键盘操作的乐趣的！

另外，现在windows系统的wsl子系统也有archlinux的子系统了，下载wsl2后运行wsl --install archlinux即可下载，这个系统下载之后任何内容包括sudo，nano等工具都没有，需要自己手动下载，可控性极强，也可以下载个桌面。注意wsl默认NAT模式下无法让wsl的arch使用windows下的网络代理，需要先进行配置，详见<https://blog.csdn.net/2301_79224952/article/details/147443235>

## 汉化

```zsh
# 安装谷歌开源字体及表情
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-dejavu ttf-liberation

# 取消#号注释
sudo nano /etc/locale.gen
zh_CN.UTF-8 UTF-8 

# 生成 locale 信息
sudo locale-gen
sudo echo 'LANG=zh_CN.UTF-8'  > /etc/locale.conf
```

最后打开系统设置 点击`区域与语言`进行中文设置 `重启`后即可看到已经实现汉化

>【故障时 可选操作】部分设备在设置系统语言后仍然出现部分设置为英文的情况（比如右键、部分菜单设置项）修改 ~/.config/plasma-localerc 中的为zh_CN可以zh_CN.UTF-8解决

## 设置win11和archlinux双系统引导

```zsh
# 这个修改可以让开机更快
cd /
sudo nano /etc/default/grub
loglevel=5 nowatchdog

# 根据实际情况选择windows系统的efi分区进行挂载
sudo -i
lsblk
mount /dev/nvme0n1p1 /mnt

os-prober
grub-mkconfig -o /boot/grub/grub.cfg
```

之后重启即可看到`grub`引导界面有arch也有win了

## 用户/用户组/主机操作

```zsh
# 添加用户和密码并加入wheel用户组
sudo useradd -m xiaoze
sudo passwd  xiaoze
sudo usermod -aG wheel  xiaoze

# 配置wheel用户组可以提权
sudo nano /etc/sudoers # 或sudo visudo
%wheel ALL=(ALL:ALL) ALL # 取消这一行注释

# 配置主机名
sudo nano /etc/hostname
sudo nano /etc/hosts
127.0.0.1       arch.localdomain        arch
```

## 输入法

```zsh
sudo pacman -S fcitx5-im fcitx5-chinese-addons # 输入法基础包组 官方中文输入引擎
sudo pacman -S fcitx5-anthy # 日文输入引擎
sudo pacman -S fcitx5-pinyin-moegirl # 萌娘百科词库。二刺猿必备
sudo pacman -S fcitx5-material-color # 输入法主题

# 配置输入法
mkdir -p ~/.config/environment.d/
nano ~/.config/environment.d/im.conf
# 目前系统默认wayland 如果为X11 就安装X11写入
#Wayland
XMODIFIERS=@im=fcitx

#X11
# fix fcitx problem
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus

# 但是在我使用过程中，由于wayland的框架原因，依赖electron的软件，比如vscode，linuxQQ这些无法使用使用fcitx5中文输入，参考https://blog.csdn.net/ZxeeGX/article/details/148777778 来修改配置，或按照我的操作直接使用x11的方法
sudo nano /etc/environment
# 输入 Fcitx 5 输入法环境变量
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
# 重启即可

# 安装 Windows 字体 
# 建立 archlinux 下存放 Windows 字体的文件夹：
sudo mkdir /usr/share/fonts/WindowsFonts
# 进入 Windows 磁盘的 Fonts 文件夹，将字体复制到建立的文件夹并设置合理的权限：
cd /path/to/C:/Windows/Fonts # 或者通过 Dolphin 在此文件夹下右键 > 点击 打开终端
sudo cp ./* /usr/share/fonts/WindowsFonts
sudo chmod 755 /usr/share/fonts/WindowsFonts/* # 设置合理的权限
# 刷新字体：
fc-cache -vf # -v：显示过程

# Rime-ice 输入法
sudo pacman -S fcitx5-rime
yay -S rime-ice
mkdir ~/.local/share/fcitx5/rime # 创建 rime 目录
nano ~/.local/share/fcitx5/rime/default.custom.yaml
patch:
  # 仅使用「雾凇拼音」的默认配置，配置此行即可
  __include: rime_ice_suggestion:/
  # 以下根据自己所需自行定义
  __patch:
    menu/page_size: 5   #候选词个数

# 增加萌娘百科词库
yay -S rime-pinyin-moegirl
cp /usr/share/rime-data/rime_ice.dict.yaml ~/.local/share/fcitx5/rime/rime_ice.dict.yaml
nano ~/.local/share/fcitx5/rime/rime_ice.dict.yaml
import_tables:
  ...
  ...
  - moegirl
```

打开 `系统设置 > 区域设置 > 输入法` 点击提示信息中的 运行 Fcitx：
接下来点击 Pinyin 右侧的配置按钮 > 点选 云拼音  > 最后点击 应用：(不同版本kde可能操作有差异)
默认通过 `Ctrl + 空格` 切换中英文输入(我是把快捷键改为了`右shift`)

>【故障时可选操作】检查一下是否有拼写错误，如果输入法无法正常切换，可尝试执行 fcitx5-diagnose 命令来诊断问题的原因。

英文输入法，按`ctrl+alt+h`，可以开启使用英文提示补全功能

## 开启pacman 32 位支持库与 Arch Linux 中文社区仓库

```zsh
# 开启 32 位支持库
nano /etc/pacman.conf
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

# 编辑退出后 此命令作为生效
pacman -Syyu

#【必要操作】最后执行安装 archlinuxcn 源所需的相关步骤
# CN源中的签名（archlinuxcn-keyring 在 archlinuxcn）
sudo pacman -S archlinuxcn-keyring

# 安装yay 命令可以让用户安装 AUR 中的软件（yay 在 archlinuxcn）
sudo pacman -S yay
```

## 基础功能包安装

```zsh
# 声音固件
sudo pacman -S  --needed sof-firmware alsa-firmware alsa-ucm-conf pipewire-pulse pipewire-alsa pipewire-jack wireplumber

# 启动蓝牙（若有）通过以下命令开启蓝牙相关服务并设置开机自动启动：
sudo pacman -S bluez bluez-utils bluez-obex
sudo systemctl enable --now bluetooth
# 对于蓝牙及无线网卡，在 Linux 下推荐使用英特尔产品。博通以及瑞昱产品在兼容性，稳定性方面在 Linux 中表现很差，会带来很多不必要的麻烦，如在驱动，BLE 方面的支持很差或者没有。
# 如果你有蓝牙设备，需要安装蓝牙软件包并启用蓝牙服务。随后在系统设置中进行添加设备与连接即可。注意，文件传输功能现在需要额外安装包bluez-obex，其功能于 2024 年已从 bluez 包中分离出来。

# 安装常用的火狐、chromium 浏览器
sudo pacman -S firefox chromium
# 【】或者安装ungoogle-chromium,去除google的chromium
yay ungoogled-chromium-bin

# 确保 Discover（软件中心）可用，需重启
sudo pacman -S packagekit-qt6 packagekit appstream-qt appstream

# 图片查看器安装
sudo pacman -S gwenview

# 使系统可以识别 NTFS exfat 格式的硬盘
sudo pacman -S ntfs-3g exfat-utils

# 安装几个开源中文字体。一般装上文泉驿就能解决大多 wine 应用中文方块的问题
sudo pacman -S adobe-source-han-serif-cn-fonts wqy-zenhei wqy-microhei

# 压缩软件。在 dolphin 中可用右键解压压缩包
sudo pacman -S ark
```

## 解决KDE桌面环境加载Discover慢和加载失败的问题

参考[arch wiki](https://forum.archlinuxcn.org/t/topic/11676/1)：

```zsh
sudo vim /etc/xdg/providers.xml # 如果没有该文件，则自己新建一个。
ProvidersUrl=http://download.kde.org/ocs/providers.xml
# 或者添加：
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

```zsh
# 记得删除行首井号注释，把时间改成一个较短的时间，比如 3 秒，这样等待的时间就会大大缩短了。
sudo nano /etc/systemd/system.conf
DefaultTimeoutStopSec=3s
sudo systemctl daemon-reload
```

## 安装系统备份还原软甲Timeshift

```zsh
sudo pacman -S timeshift
sudo systemctl enable --now cronie.service
# 引导完成后建议执行下述指令删除 subvolid
sudo sed -i -E 's/(subvolid=[0-9]+,)|(,subvolid=[0-9]+)//g' /etc/fstab

# 自动生成快照启动项 可以实现在每次使用 grub-mkconfig 重新生成 GRUB 启动项时，自动添加快照的启动入口，这样就算进不去桌面也能恢复快照
sudo pacman -S grub-btrfs
sudo systemctl enable --now grub-btrfsd.service
sudo systemctl edit --full grub-btrfsd # 防止软件包升级会将编辑后的文件覆盖掉
sudo nano /etc/systemd/system/grub-btrfsd.service # 再用文本编辑器编辑 
# 修改ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots为：
ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto
# 这样 grub-btrfs 就会监视 Timeshift 创建的快照了。

# sudo grub-mkconfig # 手动运行的命令
sudo systemctl daemon-reload
sudo systemctl restart grub-btrfsd.service
# 之后每次创建快照后自动生成 grub 配置文件
```

## 系统快照（备份）

>若能够进入桌面环境 直接打开 Timeshift，选择快照后根据提示还原即可。
>若无法进入桌面环境 使用timeshift 还原快照

推荐用 `grub-btrfs` 创建的grub引导页arch快照入口，如果没有配置按照下面的操作：

通过 `Ctrl + Alt + F2 ~ F6` 进入 tty 终端,使用快照还原系统：

```zsh
sudo timeshift --list # 获取快照列表
sudo timeshift --restore --snapshot '20XX-XX-XX_XX-XX-XX' --skip-grub # 选择一个快照进行还原，并跳过 GRUB 安装，一般来说 GRUB 不需要重新安装
```

根据提示继续，完成还原

>若无法进入系统

此时系统一般已经完全崩溃，可以通过 Live CD 进行还原。（若使用 arch 安装盘请连接网络和配置好源后安装 Timeshift，然后通过命令行方式还原）

进入 Live 系统后打开 Timeshift，点击设置按钮，设置为原来快照的存储位置。选择快照后根据提示还原即可。
或者通过命令行进行还原，但需要首先设置原来快照存储的位置：

```zsh
sudo timeshift --restore --snapshot-device /dev/sdbx
```

后续步骤同 `若无法进入桌面环境`。

## 休眠到硬盘【需要已设置好 swap交换分区】

```zsh
# 查看 swap 分区 UUID 后续需要
lsblk -o name,mountpoint,size,uuid

# 修改文件
sudo nano /etc/default/grub
# 找到 GRUB_CMDLINE_LINUX_DEFAULT 一行，在其值后添加类似如下数据（根据你自身的 UUID 确定，参数之间以空格分隔）：【个个参数空格分开 填入双引号内】
resume=UUID=958f9084-6880-41e8-8b6a-fe93b1eb86c0

# 生效
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 编辑
sudo nano /etc/mkinitcpio.conf
# 在 HOOKS 行添加 resume 值。注意，resume 需要加入在 udev 后。若使用了 LVM 分区，resume 需要加入在 lvm2 后：生效
sudo mkinitcpio -P # 重新生成 initramfs 镜像

# 【使用命令  用来休眠电脑  断开电源 启动后还原到内存】
systemctl hibernate

# 但这样有些麻烦，我们可以配置在短按电源键或笔记本合盖时进入休眠状态
sudo nano /etc/systemd/logind.conf
HandlePowerKey=hibernate # 短按电源键进入休眠
# HandleLidSwitch=hibernate # 合盖休眠
# kde 系统设置里面有电源管理部分，配置各种电源行为
```

## BBR 算法优化 网络速度

```zsh
# 查看自己的算法 以及检查是否是 bbr
sysctl net.ipv4.tcp_congestion_control

# 新建编辑文件加入下列两行
sudo nano /etc/sysctl.conf
net.core.default_qdisc = cake
net.ipv4.tcp_congestion_control = bbr
sudo sysctl -p

# 再次查看检验
sysctl net.ipv4.tcp_congestion_control
```

## 【执行 sudo pacman -S archlinuxcn-keyring  故障操作】

若安装 archlinuxcn-keyring 时报错，如果是由于密钥环的问题
可先按照 archlinuxcn 官方说明 执行其中的命令，再安装 archlinuxcn-keyring
GnuPG-2.1 与 pacman 密钥环
`2014 年 12 月 8 日`
由于升级到了 gnupg-2.1，pacman 上游更新了密钥环的格式，这使得本地的主密钥无法签署其它密钥。这不会出问题，除非你想自定义 pacman 密钥环。不过，我们推荐所有用户都生成一个新的密钥环以解决潜在问题。

此外，我们建议您安装 haveged，这是一个用来生成系统熵值的守护进程，它能加快加密软件（如 gnupg，包括生成新的密钥环）关键操作的速度。

要完成这些操作，请以 root 权限运行：

```zsh
pacman -Syu haveged
systemctl start haveged
systemctl enable haveged

rm -fr /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate archlinux
pacman-key --populate archlinuxcn
```

【故障操作】如果你在新系统中尝试安装 archlinuxcn-keyring 包时遇到如下报错：
>error: archlinuxcn-keyring: Signature from "Jiachen YANG (Arch Linux Packager Signing Key) <farseerfc@archlinux.org>" is marginal trust

请使用以下命令在本地信任 farseerfc 的 key 。此 key 已随 archlinux-keyring 安装在系统中，只是缺乏信任：

```zsh
sudo pacman-key --lsign-key "farseerfc@archlinux.org"
```

## 显卡驱动

```zsh
# Intel 核芯显卡 
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel

# 【】AMD 集成显卡
sudo pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon

# 【】独立显卡 
sudo pacman -S nvidia nvidia-open nvidia-settings lib32-nvidia-utils

# 如果同时拥有集成显卡与独立显卡的笔记本电脑，可以使用 optimus-manager 等工具自动切换。
```

`英伟达显卡`和`AMD集显`和`双显卡`具体配置参考官方文档，我只配置intel核显

## 透明代理

```zsh
# v2rayA 
sudo pacman -S v2ray v2raya
sudo systemctl enable --now v2raya

# 【】daed
# https://github.com/daeuniverse/daed/blob/main/docs/getting-started.md 
yay -S aur/dae aur/daed
sudo systemctl enable --now daed

# 【】Clash-verge-rev 
# https://www.clashverge.dev/
# https://github.com/clash-verge-rev/clash-verge-rev
yay -S clash-verge-rev-bin
```

不多说，参考教程有特别详细的内容

## zsh 配置，美化，插件

（这里我root也配置了zsh和美化，如果要保证权限安全，不建议root配置，你要知道你的每一步都是干什么的）

```zsh
sudo pacman -S zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions
# sudo pacman -S autojump # https://github.com/wting/autojump 
sudo pacman -S zoxide # 比起autojump，我推荐用性能更好的zoxide，rust写的，可以代替cd命令

chsh -l # 查看安装了哪些 Shell

# 修改当前账户的默认 Shell
chsh -s /usr/bin/zsh # 普通用户
sudo chsh -s /usr/bin/zsh root # root用户

exec zsh # 或重启终端跟随引导进行设置~/.zshrc
# root账户需要手动创建 root/.zshrc 文件(可以把普通用户的配置文件内容直接cp过去)

nano ~/.zshrc # 普通用户
sudo nano /root/.zshrc # root用户

# 将以下内容分别添加到需要设置 zsh 账户的 ~/.zshrc 中：
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/share/autojump/autojump.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# export _ZO_DATA_DIR="/home/xiaoze/.local/share/zoxide" # 如果是root用户，可以这样做来共享普通用户的zoxide索引数据
eval "$(zoxide init zsh)"
export EDITOR='vim' # （当然你也可以用nvim作为默认编辑器，我的做法是root用vim，普通用户用nvim来开发）
alias cd='z' # 使用zoxide代替cd (可选)

# 安装zim 和 p10k
curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
vim ~/.zimrc
zmodule romkatv/powerlevel10k
zmodule sorin-ionescu/prezto --root modules/command-not-found --no-submodules # (可选)
zmodule ohmyzsh/ohmyzsh --root plugins/sudo # (可选)按两下esc，可在前面加sudo
zimfw install
# 接下来跟随p10k的指引配置即可(没反应就再重新打开个终端试试)，如果你想要跨平台或者用其他的比如powershell，bash，fish，那么starship是个不错的选择

# 安装 Nerd Font 字体
sudo pacman -S ttf-jetbrains-mono-nerd
# 安装完一个 Nerd Font 字体后，打开 Konsole 的 设置 > 编辑当前方案 > 外观，把 字体 改为刚刚安装的 Nerd Font 即可
```

## nano语法高亮

```zsh
sudo pacman -S nano-syntax-highlighting # 下载高级语法高亮支持包
pacman -Ql nano-syntax-highlighting # 查询.nanorc配置文件的位置
cd /etc
sudo nano nanorc
include "/usr/share/nano-syntax-highlighting/*.nanorc" # 最后添加这一行生效
# 官方自带的高亮配置文件
include "/usr/share/nano/*.nanorc"
include "/usr/share/nano/extra/*.nanorc"
```

## vim美化 和 nvim安装美化

可以root和普通用户都搞上

```zsh
# 安装vim-plug插件
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
vim ~/.vimrc
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='ayu_dark'
call plug#end()

:PlugInstall # 输入这了来下载插件，这个插件能够美化底部内容显示(:wq保存退出重新进入~/.vimrc来执行)

vimtutor # 来学习vim吧！

# 资深vim用户使用neovim来开发，键盘操作效率上限高，学好还能炫技。。建议nvim用于普通用户，root用户用vim
sudo pacman -S neovim
git clone https://github.com/LazyVim/starter ~/.config/nvim # 开箱即用的lazyvim完整版
nvim # 运行
cd ~/.config/nvim # 配置文件目录，要修改配置就来这里
```

## fzf 搜索补全工具 搭配fzf-tab

`fzf`是绝对的效率工具，搭配fzf-tab和各种命令，可以实现一个`tab键`查所有！

```zsh
sudo pacman -S fzf
nano ~/.zshrc # 添加以下内容，ctrl+R即可使用fzf搜索历史命令,ctrl+t即可使用fzf搜索文件，输入**后按tab键即可使用fzf搜索，这比zsh原生搜索方便的多
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# 不只如此，使用 fzf-tab，轻松使用 tab键 来实现fzf搜索
sudo pacman -S fzf-tab-git
nano ~/.zshrc # 添加以下内容，使用fzf-tab搜索文件
# 以下这些source需要放在compinit后，zsh其他插件的source之前
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh
source /usr/share/zsh/plugins/fzf-tab-git/fzf.zsh # 自己定义的配置

nano /usr/share/zsh/plugins/fzf-tab-git/fzf.zsh # 自定义配置
```

>以下列出我的个人`fzf.zsh`配置：

```zsh
# ==================== FZF 环境变量配置 ====================
export RUNEWIDTH_EASTASIAN=0  # 修复东亚字符宽度显示

# FZF 默认选项
# export FZF_DEFAULT_OPTS="--preview --bash ~/.zsh/file_preview.sh {} --height 12 --layout=reverse --history=/home/xiaoze/.zsh/fzfhistory"
export FZF_DEFAULT_OPTS="--preview 'bash /usr/share/zsh/plugins/fzf-tab-git/file_preview.sh {}' --height 12 --layout=reverse --border --history=$HOME/.zsh/cache/fzfhistory"

# FZF 默认搜索命令（使用 fd）
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude=--exclude={.git,.idea,.vscode,sass-cache,node_modules,build,dist,vendor}"

# ==================== fzf-tab 样式配置 ====================
# 禁用原生补全菜单
zstyle ':completion:*' menu no

# 设置描述格式（分组标签）
zstyle ':completion:*:descriptions' format '[%d]'

# 启用文件颜色（继承 ls 颜色）
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 禁用 git-checkout 的自动排序
zstyle ':completion:*:git-checkout:*' sort false

# 禁用选项的自动排序
zstyle ':completion:complete:*:options' sort false

# 清空 fzf-tab 补全菜单的前缀符号
zstyle ':fzf-tab:*' prefix ''

# 固定高度
zstyle ':fzf-tab:complete:*:*' fzf-flags --height=20

# ==================== 预览功能配置 ====================
# 通用文件预览（使用 bat 和 exa）
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bash /usr/share/zsh/plugins/fzf-tab-git/file_preview.sh ${(Q)realpath}'
# 目录预览（cd 命令）
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --hidden --color=always $realpath'

# 进程管理预览
zstyle ':completion:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[ "$group" = "process ID" ] && ps --pid=$word -o cmd --no-headers -w -w'

# 系统服务预览
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# 包管理器预览
zstyle ':fzf-tab:complete:pacman:*' fzf-preview 'pacman -Qi $word 2>/dev/null || pacman -Si $word'
zstyle ':fzf-tab:complete:yay:*' fzf-preview 'yay -Qi $word 2>/dev/null || yay -Si $word'

# Git 相关预览
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --oneline --graph --color=always $word'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'git show --color=always $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview '[ -f $realpath ] && git diff --color=always $word || git log --oneline --graph --color=always $word'

# 文档查询预览
zstyle ':fzf-tab:complete:(|run-help|man|tldr):*' fzf-preview 'tldr --color always $word'

# 不开启预览窗口
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:0:wrap
zstyle ':fzf-tab:complete:pkill:*' fzf-flags --preview-window=down:0:wrap
zstyle ':fzf-tab:complete:*:options' fzf-flags --preview-window=down:0:wrap
# zstyle ':fzf-tab:complete:(docker|cargo):*' fzf-flags --preview-window=down:0:wrap
zstyle ':fzf-tab:complete:systemctl:*' fzf-flags --preview-window=down:0:wrap

# ==================== fzf 交互配置 ====================
# fzf 标志设置
zstyle ':fzf-tab:*' fzf-flags --preview-window=right:60%:wrap --bind="tab:accept,ctrl-j:down,ctrl-k:up"

# 切换分组快捷键
zstyle ':fzf-tab:*' switch-group '<' '>'

# 输入时立即搜索（cd 命令）
zstyle ':fzf-tab:complete:cd:*' query-string input
```

>在我的配置中，preview通过sh脚本实现，创建一个sh脚本在/usr/share/zsh/plugins/fzf-tab-git，命名file_preview.sh。预览图片和pdf需要下载对应的工具pdftotext，chafa。

```zsh
#!/usr/bin/env sh

mime=$(file -bL --mime-type "$1")
category=${mime%%/*}

if [ -d "$1" ]; then
    lsd -l --permission octal --icon always --size short --group-dirs first  --date relative --icon always --color always "$1" 2>/dev/null
elif [ "$category" = text ]; then
    bat --style numbers --color=always "$1" 2>/dev/null | head -1000
elif [ "$mime" = application/pdf ]; then
    pdftotext "$1" - | less
elif [ "$category" = image ]; then
    chafa --size=$(($COLUMNS/2)) "$1" 2>/dev/null
else
    echo "$1 is a $category file"
fi
```

想要实现其他的配置或想知道每个命令的含义，可以参考[官方文档](https://github.com/Aloxaf/fzf-tab)和AI。

## 终端文件管理器

### yazi (基于rust编写，比起后文提到的ranger我更推荐这个)

yazi官方文档<https://yazi-rs.github.io/docs/installation>
yazi参考文档<https://instaboard.app/b/UYDDqLRsB>
文档内讲述全面且详细，我不做赘述
按.显示隐藏文件，其他大部分操作同vim操作

```zsh
nano ~/.zshrc
# 添加函数，之后使用y来代替yazi命令打开文件管理器
function y() {
 local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
 yazi "$@" --cwd-file="$tmp"
 IFS= read -r -d '' cwd < "$tmp"
 [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
 rm -f -- "$tmp"
}

# 我的具体yazi配置文件内容较多，从github访问
<https://github.com/XIAO-ZE1/Dotfiles>

# 在此列出我使用的插件
ya pkg add yazi-rs/plugins:full-border
ya pkg add yazi-rs/plugins:git
ya pkg add yazi-rs/plugins:zoom
ya pkg add yazi-rs/plugins:smart-filter
ya pkg add yazi-rs/plugins:chmod

# yazi主题选择：https://github.com/yazi-rs/flavors/tree/d04a298a8d4ada755816cb1a8cfb74dd46ef7124
```

### ranger (ranger基于python编写，挺好用，功能丰富，但现在我使用rust编写的yazi，开箱即用，这里文档保留ranger配置内容)

[arch wiki](https://wiki.archlinux.org.cn/title/Ranger)

<https://www.zssnp.top/2021/06/03/ranger/>

```zsh
sudo pacman -S ranger
ranger --copy-config=all # 启动之后ranger会创建一个目录~/.config/ranger 可以使用以下命令复制默认配置文件到这个目录
cd /home/xiaoze/.config/ranger
echo "export RANGER_LOAD_DEFAULT_RC=false">>~/.zshrc # 如果要使用~/.config/ranger目录下的配置生效，需要把RANGER_LOAD_DEFAULT_RC变量设置为false

sudo pacman -S highlight  # 代码高亮
sudo pacman -S atool　    # 压缩包预览
sudo pacman -S python-pillow # 图片预览，使用kitty终端要装这个
# sudo pacman -S mediainfo  # 多媒体文件预览
# sudo pacman -S catdoc     # doc预览
# sudo pacman -S docx2txt   # docx预览
# sudo pacman -S xlsx2csv   # xlsx预览

# ranger 插件：图标
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf


nano ~/.config/ranger/rc.conf
set show_hidden true # 显示隐藏文件,按zh切换
set line_numbers true # 显示行号
set draw_borders both # 显示边框
set one_indexed true # 序号从1开始
set colorscheme jungle # 设置主题配色
set preview_images true # 预览图片打开
set preview_images_method kitty # 预览图片使用kitty
map DD shell mv %s /home/${USER}/.local/share/Trash/files/ # 添加快捷键DD，将选中的文件移动到回收站

# 与fzf联动查询https://zhuanlan.zhihu.com/p/441083543
nano ~/.config/ranger/commands.py # 添加以下内容
class fzf_select(Command):
   """
   :fzf_select
   Find a file using fzf.
   With a prefix argument to select only directories.

   See: https://github.com/junegunn/fzf
   """

   def execute(self):
       import subprocess
       import os
       from ranger.ext.get_executables import get_executables

       if 'fzf' not in get_executables():
           self.fm.notify('Could not find fzf in the PATH.', bad=True)
           return

       fd = None
       if 'fdfind' in get_executables():
           fd = 'fdfind'
       elif 'fd' in get_executables():
           fd = 'fd'

       if fd is not None:
           hidden = ('--hidden' if self.fm.settings.show_hidden else '')
           exclude = "--no-ignore-vcs --exclude={.wine,.git,.idea,.vscode,.sass-cache,node_modules,build,.local,.steam,.m2,.rangerdir,.ssh,.ghidra,.mozilla} --exclude '*.py[co]' --exclude '__pycache__'"
           only_directories = ('--type directory' if self.quantifier else '')
           fzf_default_command = '{} --follow {} {} {} --color=always'.format(
               fd, hidden, exclude, only_directories
           )
       else:
           hidden = ('-false' if self.fm.settings.show_hidden else r"-path '*/\.*' -prune")
           exclude = r"\( -name '\.git' -o -iname '\.*py[co]' -o -fstype 'dev' -o -fstype 'proc' \) -prune"
           only_directories = ('-type d' if self.quantifier else '')
           fzf_default_command = 'find -L . -mindepth 1 {} -o {} -o {} -print | cut -b3-'.format(
               hidden, exclude, only_directories
           )

       env = os.environ.copy()
       env['FZF_DEFAULT_COMMAND'] = fzf_default_command
       env['FZF_DEFAULT_OPTS'] = '--height=100% --layout=reverse --ansi --preview="{}"'.format('''
           (
               ~/Tools/Other/fzf-scope.sh {} ||
               #batcat --color=always {} ||
               #bat --color=always {} ||
               #cat {} ||
               tree -ahpCL 3 -I '.git' -I '*.py[co]' -I '__pycache__' {}
           ) 2>/dev/null | head -n 100
       ''')

       fzf = self.fm.execute_command('fzf --no-multi', env=env,
                                     universal_newlines=True, stdout=subprocess.PIPE)
       stdout, _ = fzf.communicate()
       if fzf.returncode == 0:
           selected = os.path.abspath(stdout.strip())
           if os.path.isdir(selected):
               self.fm.cd(selected)
           else:
               self.fm.select_file(selected)

nano ~/.config/ranger/rc.conf 
map f fzf_select
# map yy copy 修改
# map pp paste 修改
map yy chain copy; save_copy_buffer
map pp chain load_copy_buffer;paste

# 启动ranger, 按下f从当前目录开始进行模糊文件查找
```

> 操作基本和vim一致，快捷键：
> g开头主要是目录跳转，后面可以跟一些参数指定要跳转的位置
> s开头主要是排序，后面跟一些排序规则
> z开头主要是设置，后面跟一些具体要设置什么
> .开头主要是文件过滤，后面跟一些过滤规则筛选出满足条件的文件或目录

## 个人安装软件

以下记录我安装和使用的软件和工具，有些工具在其他小节讲述的不再重复，这里不面面俱到。
想要完全把握自己的软件工具，可以用GUI包管理工具，或者通过pacman -Qe即可查询主要安装包（不含依赖项）来逐一管理即可

```zsh
# 【】安装snap 商店以及操作命令 无需要可不看
sudo snap install snap-store
snap --version
snap find <关键字或软件包名称>
snap info <软件包名称>
sudo snap install <软件包名称>

sudo snap remove <软件包名称>
sudo snap remove <软件包1> <软件包2>
sudo snap remove <软件包名称> --purge

sudo snap refresh <软件包名称> 更新
```

### 工具

```zsh
# glmark2 显卡性能测试
sudo pacman -S glmark2
glmark2 #运行等待测试完成

# 使用 TLP 延长电池寿命及续航 安装 TLPextra、tlp-rdwextra以及可选安装图形界面 TLPUIaur
sudo pacman -S tlp tlp-rdw
yay -S tlpui

# 硬件信息检测 Smartmontools 
sudo pacman -S smartmontools
# 查看磁盘信息
sudo smartctl -A /dev/nvme0 # 硬盘
sudo smartctl -d sat -A /dev/sdx # USB 设备

# 使用 Filelightextra即可在图形化界面直观查看磁盘占用情况。
sudo pacman -S filelight

# GPU-Viewer GPU 信息 
yay -S gpu-viewer

# 硬件完整信息 Dmidecode
sudo pacman -S dmidecode
sudo dmidecode

# CPU 信息 cpu-x
sudo pacman -S cpu-x

# Pacman 包管理 pacman-contrib 来使用 Pacman 额外的命令
sudo pacman -S pacman-contrib
# downgrade 在 archlinux 上安装旧版软件都通过 downgrade 来进行管理。
yay -S downgrade

# Octopi 图形化的包管理软件（Pacman / yay 的图形前端）
yay -S octopi

# fastfetch 可以将系统信息和发行版 logo 一并打印出来
sudo pacman -S fastfetchl

# Unarchiver 解压 Windows 下的压缩包
sudo pacman -S unarchiver

# screenkey 是一个用于显示键盘键入在屏幕上的工具，可用于录屏演示。
sudo pacman -S screenkey # 在终端输入 screenkey 以启动

# btop资源监控 top和htop的plus版，用bottom也可以
sudo pacman -S btop

# stacer 图形化界面系统优化，linux电脑管家，你值得拥有
sudo pacman -S starcer-bin
```

### 美化

```zsh
# 更改全局主题 Kvantum Manager 
sudo pacman -S kvantum # 具体配置参考 https://arch.icekylin.online/guide/advanced/beauty-2.html 相关内容

# GRUB引导界面美化，我是用的Distro的GRUB主题，cd 进解压出来的文件夹，打开 konsole 输入
sudo cp -rf . /usr/share/grub/themes/Distro
sudo nano /etc/default/grub
#GRUB_THEME=
GRUB_THEME="/usr/share/grub/themes/Distro/theme.txt" #修改后
grub-mkconfig -o /boot/grub/grub.cfg

# 显示由不同风格的 ASCII 艺术字符组成的文本。figlet 
sudo pacman -S figlet
echo "Love Live Linux" | figlet # 使用实例

# plasma6-wallpapers-wallpaper-engine-git壁纸
yay -S plasma6-wallpapers-wallpaper-engine-git # 接下来下载小红车，在系统设置的壁纸中选用插件，选择小红车壁纸位置读取
```

### 终端配置相关

[core utilities](https://wiki.archlinux.org/title/Core_utilities)
[更多终端工具](https://cn.x-cmd.com/pkg/)

```zsh
# 在~/.zshrc中添加别名和其他配置
alias weather="curl wttr.in" # 天气
alias ipinfo="curl ipinfo.io" # 公网ip,地理位置
alias c="clear"
alias f="fastfetch"

alias cd='z'
alias cat="bat"
alias find="fd"
alias rg='rg --hidden --follow --glob "!.git/*"'
alias du="dust"
alias df="duf"
alias diff='delta'
alias man='tldr'

# zoxide 前文 zsh 配置部分已经讲述过,cd的plus版本
sudo pacman -S zoxide
alias cd='z'

# bat cat的plus版本，语法高亮、Git集成、分页显示
sudo pacman -S bat
alias cat='bat' 

# lsd ls的plus版本 彩色输出、图标支持、更好看的布局
sudo pacman -S lsd

# fd find的plus版本，默认忽略.gitignore、更快、更简单
sudo pacman -S fd
alias find="fd" 

# ripgrep rg的plus版本，递归搜索、忽略二进制文件、极快速度
sudo pacman -S ripgrep
alias rg='rg --hidden --follow --glob "!.git/*"' 

# gping ping工具的升级版，可以可视化显示ping的进度条，使用指令gping
sudo pacman -S gping
# alias ping='gping' (我个人感觉没必要)

# dust du的plus版本,可视化显示、更直观的磁盘使用分析
sudo pacman -S dust
alias du="dust" 

# duf df的plus版本,彩色表格输出、更清晰的磁盘信息
sudo pacman -S duf
alias df="duf" 

# delta diff的plus版本，语法高亮、并排显示、更好的diff体验
sudo pacman -S git-delta
alias diff='delta' 

# tealdeer tldr的rust版本，比man更易读，比--help更详细，而且本地缓存+中文文档+运行示例
sudo pacman -S tealdeer
tldr --update
tldr ls # 查看ls的tldr说明（记忆tldr：贪婪的人）
# 因为我不想看man，而zsh内置run-help=man，快捷键alt+h就可以打开man文档，所以我直接把man命令替换为tldr，不用下载man-db
alias man='tldr'
ls # 按住alt+h，打开tldr文档

# tig git的图形化界面管理
sudo pacman -S tig

# less 在终端中查看文件内容的工具，可以看作是 more 命令的增强版。它的名字源于 "less is more" 这句谚语，意思是它比 more 命令更强大。不会一次性加载整个文件到内存，适合查看大型日志文件
sudo pacman -S less

# gitui git的图形化界面管理
sudo pacman -S gitui
```

### 开发

```zsh
# 安装 LocalSend  【局域网传输】
# https://localsend.org/zh-CN
yay -S localsend-bin

# 安卓设备投屏（scrcpy） 
# https://arch.icekylin.online/app/common/collaboration.html
sudo pacman -S scrcpy android-tools
scrcpy --turn-screen-off --stay-awake # 保持镜像屏幕常亮，开启有线连接安卓手机

# vscode 所以你是用kate还是vscode还是neovim？哦对了，neovim操作可以内嵌到vscode插件
yay -S visual-studio-code-bin

# tmux 终端复用，多任务管理。让你在远程服务器或长时间运行的任务中高效工作，即使网络断开或终端关闭，任务也不会中断
sudo pacman -S tmux

# sniffent 网络流量抓包工具
sudo pacman -S sniffent

# realvnc-vnc-viewer 用于显示香橙派，树莓派等远程桌面
yay -S realvnc-vnc-viewer
```

### 常见软件

含有闭源专有软件，对隐私安全有要求的建议安装开源软件替代，以实现完全隐私可控

```zsh
# [linux推荐的下载软件](https://www.bilibili.com/video/BV1fPvNzmEC2/?spm_id_from=333.337.search-card.all.click&vd_source=7bd0bdc9ece4aa8666f734929c9b606d)
yay -S qbittorrent-enhanced-git
# BT下载⽹站推荐
https://thepiratebay.org/index.html
https://www.1377x.to/
https://yts.mx/

# Watt toolkit (steam++!)
yay -S watt-toolkit-bin

# Steam 游戏平台
sudo pacman -S steam

# Lutris linux开源游戏平台
sudo pacman -S lutris


# 百度网盘 闭源
yay -S baidunetdisk-bin

# Telegram 这个虽然闭源，但是隐私很安全
sudo pacman -S telegram-desktop

# QQ 官方linux版，闭源
yay -S linuxqq

# 微信 官方linux版，闭源
yay -S wechat wechat-bin

# Mozilla Thunderbird（雷鸟）是由 Mozilla 基金会研发的一款自由开源的跨平台电子邮件客户端、新闻阅读器、聚合器以及即时通信软件。
sudo pacman -S thunderbird

# WPS Office 闭源，linux也有office开源套件
yay -S wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts freetype2-wps libtiff5

# SMPlayer 是个适用于 Windows 和 Linux 的自由免费的媒体播放器，内置解码器，可以播放几乎所有格式的视频和音频文件。无需再安装任何外部解码器。只要安装了 SMPlayer，就能够播放所有的格式，不用再费事查找安装解码包。基于mpv，所以也会下载mpv，可以理解为mpv前端和plus版
sudo pacman -S smplayer
yay -S papirus-smplayer-theme-git # 换一个外观皮肤，下载后在软件设置使用

# 第三方网易云播放器 高颜值 也可以用其他的平台音源，跟listen1一样做到全网资源聚合
yay -S yesplaymusic

# Listen 1 作为“老牌”的听歌软件可以搜索和播放来自网易云音乐、虾米、QQ 音乐、酷狗音乐、酷我音乐、Bilibili、咪咕音乐网站的歌曲，让你的曲库更全面。也有高颜值ui，但界面目前略有卡顿，还是用一般皮肤好点
yay -S listen1-desktop-appimage

# 【】FeelUOwn 是一个稳定、用户友好以及高度可定制的音乐播放器。
yay -S feeluown
yay -S --asdeps feeluown-qqmusic
yay -S --asdeps feeluown-netease
yay -S --asdeps feeluown-kuwo
yay -S --asdeps feeluown-ytmusic
yay -S --asdeps feeluown-bilibili

# OBS Studio 是免费开源的用于视频录制以及直播串流的软件。Linux 下操作与 Windows 下基本一致。
sudo pacman -S obs-studio

# bitwarden 密码管理器，可部署也可自建
sudo pacman -S bitwarden

# gimp 一个自由开源的位图图像编辑器。其对标 Adobe 的 Photoshop
sudo pacman -S gimp

# zyfun 轻量高颜值视频客户端
yay -S zyfun-appimage
```

### kde: sudo pacman -S <软件名>

```zsh
# Gwenview 是 KDE 出品的一款轻便易用的图像查看器，是浏览、显示多张图像时的理想工具。
gwenview
# Spectacle 是 KDE 开发的用于抓取桌面截图的简单应用程序。
spectacle
# KCalc —— 科学计算器
kcalc
# Kamoso —— 相机
kamoso
# KTimer —— 倒计时执行器
ktimer
# KDE Connect 提供了各种用于整合移动设备和计算机的功能。它可以将文件发送到另一台设备、控制它的媒体播放、发送远程输入、查看它的通知，以及做许多其它事情。
kdeconnect 
sshfs
# KDE Runner 类似listary或everything，更进阶的有ulauncher，有强大的插件生态
krunner
# kate 超绝文本编辑器，kde内置
kate
# dolphin 文件管理器，kde内置，终端的话用ranger
dolphin
# kio-admin 为 Dolphin 文件管理器添加了“以管理员身份打开”的右键菜单选项
kio-admin
# okular Okular 是 KDE 开发的一款功能丰富、轻巧快速的跨平台文档阅读器。可以使用它来阅读 PDF 文档、漫画电子书、Epub 电子书，浏览图像，显示 Markdown 文档等。
okular
```

## 【】ipv6  隐私拓展 具体可看<https://wiki.archlinuxcn.org/zh-tw/IPv6>

三个任意选一种查看 自己的网卡名

```zsh
ls /sys/class/net
ip link
iw dev

# 比如叫：wlp0s20f3 并且只有一个 按照下列写入，如果有多个 需要 nic1.wlp0s20f3 这样全部列举
sudo nano /etc/sysctl.d/40-ipv6.conf

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

## 【】随机 MAC 地址

```zsh
# 可以编辑并加入下列 
sudo nano /etc/NetworkManager/conf.d/rand_mac.conf：

[device-mac-randomization]
wifi.scan-rand-mac-address=yes

[connection-mac-randomization]
ethernet.cloned-mac-address=stable
wifi.cloned-mac-address=stable
```

wifi.scan-rand-mac-address # 决定在 wifi 扫描时是否开启随机 MAC 地址，若需要固定的 MAC 地址，可以设为 no。ethernet.cloned-mac-address 和 wifi.cloned-mac-address 决定了连接有线网络和 wifi 网络时是否开启随机 MAC 地址，可用的值有：

指定的 MAC 地址，连接时使用手动指定的 MAC 地址；
permanent，不改变 MAC 地址；
preserve，在网卡激活后不改变 MAC 地址；
random，在每次连接时都使用随机 MAC 地址；
stable，在初次连接一个网络时使用随机 MAC 地址，之后每次连接相同的网络都使用相同的 MAC 地址。
修改完后重启 NetworkManager 服务生效。

## 【】时间同步 【默认也还行 没操作】

systemd 自带了一个 systemd-timesyncd 服务，提供了简单的时间同步服务，若是没有特别需求，这个服务已经够用了。不过这个服务默认使用的是 Arch Linux 自己的 NTP 服务器，在国内访问较慢，有时会导致时间同步失败，为了更快地同步时间，可以选用其他的 NTP 服务器，我选用了中国 NTP 快速授时服务和中国计量科学研究院 NIM 授时服务的 NTP 服务器，编辑 /etc/systemd/timesyncd.conf，添加或编辑如下一行：

NTP=cn.ntp.org.cn ntp1.nim.ac.cn
然后重启 systemd-timesyncd.service，之后运行 timedatectl timesync-status 便可查看时间同步状态：

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

## 【】设置 DNS

一般来说，如今大多电脑连接的路由器是可以自动处理 DNS 的，如果你的路由器不能处理，则需要额外进行 DNS 的设置。同时，如果使用 ISP 提供的默认 DNS,你的网络访问记录将存在更大的，被泄露或被当局存储记录的风险。除此之外，使用 ISP 提供的 DNS 还有可能将某些服务解析至一些已经失效或劣化的服务器。即使你的网络环境可以自动处理 DNS 设置，我们还是建议你使用可信的国际通用 DNS 设置。如下的配置将固定使用谷歌的 DNS,但是网络访问延迟可能增加。在阅读完随后的代理设置一节后，你的 DNS 请求将均通过代理发送，这将在 DNS 发送方面最大限度的保障你的隐私和安全。

```zsh
vim /etc/resolv.conf #删除已有条目，并将如下内容加入其中

# nameserver 223.5.5.5

# nameserver 208.67.222.222

nameserver 8.8.8.8
nameserver 2001:4860:4860::8888
nameserver 8.8.4.4
nameserver 2001:4860:4860::8844

# 如果你的路由器可以自动处理 DNS,resolvconf 会在每次网络连接时用路由器的设置覆盖本机/etc/resolv.conf 中的设置，执行如下命令加入不可变标志，使其不能覆盖如上加入的配置[3][4]。

sudo chattr +i /etc/resolv.conf

# 如果需要编辑文件 需要取消一下锁定
sudo chattr -i /etc/resolv.conf
```

## linux 和 windows 公用键鼠 Input-Leap

<www.vindo.cn/blog/arch-windows>

```zsh
yay -S input-leap-bin
```

参照文章内容进行配置，注意要在同一个局域网，校园网这些因为有网络隔离，建议用手机热点连接或单独搞一个路由器或软路由来连接
