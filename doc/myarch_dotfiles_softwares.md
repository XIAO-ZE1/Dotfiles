# 参考dotfiles

>全面的教程安装和配置 <https://archlinuxstudio.github.io/>
>也可以看这个：archlinux 简明指南，是前者的派生文档 <https://arch.icekylin.online/>
>我自己的dotfiles：<https://github.com/XIAO-ZE1/Dotfiles>
>终端命令替代工具wiki <https://wiki.archlinux.org/title/Core_utilities>
>软件推荐 <https://www.oryoy.com/news/zhang-wo-arch-linux-zhuo-mian-ti-yan-sheng-ji-50-kuan-re-men-ruan-jian-shen-du-tui-jian.html> 或 <https://czyt.eu.org/post/arch-awesome-software/>

此文章基于 `archlinux` 和 `KDE Plasma6` 桌面环境，以及 KDE 生态相关组件实现配置，因为图形化配置方便友好。
当然你也可以使用 `kitty` 终端，`mako` 通知守护进程等需要文本配置的工具，追求极简高效和高自由度个性化。本文也会涉及这些内容。
当然更详细的配置需要到其官方文档查阅，我仅做个人配置的分享，在 [dotfiles](https://github.com/XIAO-ZE1/Dotfiles) 中。

## `zsh + zim + p10k` 终端shell的配置，插件和美化

这里我 `root用户` 也配置了zsh和美化，如果要保证权限安全，不建议这样做，除非你要知道你在做什么

### `zsh和插件`，以及 `cd` 命令替代工具 `zoxide`

```zsh
sudo pacman -S zsh
sudo pacman -S zoxide
```

查看安装了哪些 Shell

```zsh
chsh -l
```

修改当前账户的默认 Shell

```zsh
chsh -s /usr/bin/zsh # 普通用户
sudo chsh -s /usr/bin/zsh root # root用户
```

重启终端跟随引导进行设置~/.zshrc
root账户需要手动创建 root/.zshrc 文件(可以把普通用户的配置文件内容直接cp过去)

```zsh
exec zsh 
```

编辑配置文件

```zsh
nano ~/.zshrc
```

`编辑`将以下内容分别添加到需要设置 zsh 账户的 ~/.zshrc 中：

```conf
export EDITOR='vim' # (也可以用nvim作为默认编辑器，我是root用vim，普通用户用nvim)
export _ZO_DATA_DIR="$HOME/.local/share/zoxide" # 指定zoxide数据库位置，让root用户和普通用户共用zoxide索引数据，路径根据自己情况写对。
eval "$(zoxide init zsh)"

alias cd='z' # 使用zoxide代替cd (可选)
```

### 安装 `zim` 和 `p10k`

```zsh
curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
nano ~/.zimrc
```

`编辑`

```conf
zmodule romkatv/powerlevel10k
zmodule sorin-ionescu/prezto --root modules/command-not-found --no-submodules # (可选)
zmodule ohmyzsh/ohmyzsh --root plugins/sudo # (可选)按两下esc，可在前面加sudo
#zmodule Aloxaf/fzf-tab # (可选) 我是直接pacman安装了fzf-tab-git
```

插件下载部署

```zsh
zimfw install
```

接下来跟随 `p10k` 的指引配置即可(没反应就再重新打开个终端试试)，如果你想要跨平台或者用其他的比如 `powershell，bash，fish`，那么 `starship` 是个不错的选择

### 安装 `Nerd Font` 字体(更好的实现p10k美化显示图标)

```zsh
sudo pacman -S ttf-jetbrains-mono-nerd
```

安装完一个 Nerd Font 字体后，打开 `Konsole` 的 设置 > 编辑当前方案 > 外观，把 字体 改为刚刚安装的 Nerd Font 即可

## nano语法高亮

下载高级语法高亮支持包

```zsh
sudo pacman -S nano-syntax-highlighting
pacman -Ql nano-syntax-highlighting # 查询.nanorc配置文件的位置
cd /etc
sudo nano nanorc
```

`编辑`

```conf
include "/usr/share/nano-syntax-highlighting/*.nanorc" # 最后添加这一行生效

# 官方自带的高亮配置文件
include "/usr/share/nano/*.nanorc"
include "/usr/share/nano/extra/*.nanorc"
```

## vim美化 和 nvim安装美化

### vim插件(可以root和普通用户都搞上)

安装vim-plug插件

```zsh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
vim ~/.vimrc
```

`编辑`

```conf
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='ayu_dark'
call plug#end()

:PlugInstall # 输入这了来下载插件，这个插件能够美化底部内容显示(:wq保存退出重新进入~/.vimrc来执行)
```

来学习vim吧！

```zsh
vimtutor
```

### 资深vim用户使用neovim来开发，键盘操作效率上限高，学好还能炫技

建议nvim用于普通用户，root用户用vim

```zsh
sudo pacman -S neovim
git clone https://github.com/LazyVim/starter ~/.config/nvim # 开箱即用的lazyvim完整版
nvim # 运行
cd ~/.config/nvim # 配置文件目录，要修改配置就来这里
```

## `fzf` 搜索补全工具 搭配 `fzf-tab`

`fzf`是绝对的效率工具，搭配 `fzf-tab` 和各种命令，可以实现一个`tab键`查所有！

```zsh
sudo pacman -S fzf
nano ~/.zshrc
```

`编辑`添加以下内容，ctrl+R即可使用fzf搜索历史命令,ctrl+t即可使用fzf搜索文件，输入**后按tab键即可使用fzf搜索，这比zsh原生搜索方便的多

```conf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
```

不只如此，使用 `fzf-tab`，轻松使用 tab键 来实现fzf搜索

```zsh
sudo pacman -S fzf-tab-git
nano ~/.zshrc
```

`编辑`添加以下内容，使用fzf-tab搜索文件
以下这些source需要放在compinit后，zsh其他插件的source之前

```conf
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh
source /usr/share/zsh/plugins/fzf-tab-git/fzf.zsh # 自己定义的配置
```

自定义配置

```zsh
nano /usr/share/zsh/plugins/fzf-tab-git/fzf.zsh
```

>以下列出我的个人`fzf.zsh`配置：

```zsh
# ==================== FZF 环境变量配置 ====================
export RUNEWIDTH_EASTASIAN=0  # 修复东亚字符宽度显示

# FZF 默认选项
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

>在我的配置中，preview通过sh脚本实现，创建一个sh脚本在 `/usr/share/zsh/plugins/fzf-tab-git`，命名 `file_preview.sh`。预览图片和pdf需要下载对应的工具 `pdftotext`，`chafa`。

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

### yazi (基于rust编写，比起ranger我更推荐这个)

[yazi官方文档](https://yazi-rs.github.io/docs/installation)
[yazi参考文档](https://instaboard.app/b/UYDDqLRsB)
文档内讲述全面且详细，我不做赘述
按`.`显示隐藏文件，其他大部分操作同 `vim` 操作

```zsh
nano ~/.zshrc
```

`编辑`添加函数，之后使用y来代替yazi命令打开文件管理器

```conf
function y() {
 local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
 yazi "$@" --cwd-file="$tmp"
 IFS= read -r -d '' cwd < "$tmp"
 [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
 rm -f -- "$tmp"
}
```

我的具体yazi配置文件内容从github访问 <https://github.com/XIAO-ZE1/Dotfiles>

在此列出我使用的插件

```zsh
ya pkg add yazi-rs/plugins:full-border
ya pkg add yazi-rs/plugins:git
ya pkg add yazi-rs/plugins:zoom
ya pkg add yazi-rs/plugins:smart-filter
ya pkg add yazi-rs/plugins:smart-enter
ya pkg add yazi-rs/plugins:chmod
```

[yazi主题选择](https://github.com/yazi-rs/flavors/tree/d04a298a8d4ada755816cb1a8cfb74dd46ef7124),例如mocha主题：

```zsh
ya pkg add yazi-rs/flavors:catppuccin-mocha
```

### ranger (基于python编写，功能丰富，但现在我使用rust编写的yazi，这里文档用于记录我的ranger配置内容)

[arch wiki 相关内容](https://wiki.archlinux.org.cn/title/Ranger)

[配置教程](https://www.zssnp.top/2021/06/03/ranger/)

```zsh
sudo pacman -S ranger
ranger --copy-config=all # 启动之后ranger会创建一个目录~/.config/ranger 可以使用以下命令复制默认配置文件到这个目录
cd ~/.config/ranger
echo "export RANGER_LOAD_DEFAULT_RC=false">>~/.zshrc # 如果要使用~/.config/ranger目录下的配置生效，需要把RANGER_LOAD_DEFAULT_RC变量设置为false

sudo pacman -S highlight  # 代码高亮
sudo pacman -S atool　    # 压缩包预览
sudo pacman -S python-pillow # 图片预览，使用kitty终端要装这个
# sudo pacman -S mediainfo  # 多媒体文件预览
# sudo pacman -S catdoc     # doc预览
# sudo pacman -S docx2txt   # docx预览
# sudo pacman -S xlsx2csv   # xlsx预览
```

ranger 插件：图标

```zsh
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf
```

功能配置

```zsh
nano ~/.config/ranger/rc.conf
```

`编辑`

```conf
set show_hidden true # 显示隐藏文件,按zh切换
set line_numbers true # 显示行号
set draw_borders both # 显示边框
set one_indexed true # 序号从1开始
set colorscheme jungle # 设置主题配色
set preview_images true # 预览图片打开
set preview_images_method kitty # 预览图片使用kitty
map DD shell mv %s /home/${USER}/.local/share/Trash/files/ # 添加快捷键DD，将选中的文件移动到回收站
```

与fzf联动查询<https://zhuanlan.zhihu.com/p/441083543>

```zsh
nano ~/.config/ranger/commands.py
```

`编辑`添加以下内容

```py
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
```

```zsh
nano ~/.config/ranger/rc.conf
```

`编辑`

```conf
map f fzf_select
# map yy copy 修改
# map pp paste 修改
map yy chain copy; save_copy_buffer
map pp chain load_copy_buffer;paste 
```

启动 `ranger`, 按下f从当前目录开始进行模糊文件查找

> ranger操作基本和vim一致，快捷键：
> g开头主要是目录跳转，后面可以跟一些参数指定要跳转的位置
> s开头主要是排序，后面跟一些排序规则
> z开头主要是设置，后面跟一些具体要设置什么
> .开头主要是文件过滤，后面跟一些过滤规则筛选出满足条件的文件或目录

## git管理备份

### /etc:etckeeper

使用etckeeper来跟踪/etc目录的变化

```zsh
sudo pacman -S etckeeper
cd /etc
sudo etckeeper init
sudo etckeeper commit "Initial commit - pristine system state" # 每当你手动修改了配置​​，都可以提交一次，​​每当你用 pacman安装或更新软件包时​​，etckeeper会自动执行一次提交，记录下软件包安装前后 /etc目录的所有变化。这样你就知道是哪个包的安装导致了配置变更。
git checkout -- <文件名> # 恢复某个文件
git reset --hard <某个旧版本号> # 回滚
sudo git log --oneline # 查看简洁的提交历史
sudo git log -p # 查看详细历史，包括每次修改的具体内容
```

### dotfiles:git+stow

我的dotfiles：<https://github.com/XIAO-ZE1/Dotfiles>

使用dotfiles来管理.开头的配置文件，可以统一管理用户的自定义配置，本体放在dotfiles目录下，软链接到原来的位置
再用git和github可以分享配置，实现快速部署配置文件和多设备同步配置
高级一点就是写sh脚本文件实现一键部署，更新，卸载等

而我的目的只是用于普通使用，使用stow来软链接管理

安装stow

```zsh
sudo pacman -S stow
mkdir ~/dotfiles
cd ~/dotfiles
```

举例

```zsh
# 例如迁移.zshrc文件，链接到~/目录下
mkdir ~/dotfiles/zsh
mv ~/.zshrc ~/dotfiles/zsh
stow --verbose zsh
# 如果要链接到~/.config下的文件夹
mkdir ~/dotfiles/nvim/.config/nvim
mv ~/.config/nvim ~/dotfiles/nvim/.config/nvim
stow --verbose nvim
```

之后使用git版本控制(根据自己情况配置.gitignore文件)

```zsh
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
```

在新机器上恢复环境​​

```zsh
git clone https://github.com/你的用户名/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow -t ~ .  # 一键重建所有符号链接
```

## 个人安装软件

以下记录我安装和使用的软件和工具，有些工具在其他小节讲述的不再重复。
想要完全把握自己的软件工具，可以用GUI包管理工具，或者通过 `pacman -Qe` 即可查询主要安装包（不含依赖项）来逐一管理即可

### 检测/硬件工具

`glmark2` 显卡性能测试

```zsh
sudo pacman -S glmark2
glmark2 #运行等待测试完成
```

`Smartmontools` 硬件信息检测

```zsh
sudo pacman -S smartmontools
# 查看磁盘信息
sudo smartctl -A /dev/nvme0 # 硬盘
sudo smartctl -d sat -A /dev/sdx # USB 设备
```

`Dmidecode` 硬件完整信息

```zsh
sudo pacman -S dmidecode
sudo dmidecode
```

使用 `TLP` 延长电池寿命及续航 安装 TLPextra、tlp-rdwextra 以及可选安装图形界面 TLPUIaur

```zsh
sudo pacman -S tlp tlp-rdw
yay -S tlpui
```

`Filelightextra` 在图形化界面查看磁盘占用情况。

```zsh
sudo pacman -S filelight
```

`GPU-Viewer` GPU 信息

```zsh
yay -S gpu-viewer
```

`cpu-x` CPU 信息

```zsh
sudo pacman -S cpu-x
```

`fastfetch` 可以将系统信息和发行版 logo 一并打印出来

```zsh
sudo pacman -S fastfetchl
```

`btop` 资源监控 top和htop的plus版

```zsh
sudo pacman -S btop
```

`stacer` 图形化界面系统优化，linux电脑管家，你值得拥有

```zsh
sudo pacman -S starcer-bin
```

### 包管理工具

Pacman 包管理 `pacman-contrib` 来使用 Pacman 额外的命令

```zsh
sudo pacman -S pacman-contrib
```

`downgrade` 在 archlinux 上安装旧版软件都通过 downgrade 来进行管理。

```zsh
yay -S downgrade
```

`Octopi` 图形化的包管理软件（Pacman / yay 的图形前端）

```zsh
yay -S octopi
```

### 美化

更改全局主题 `Kvantum Manager`

```zsh
sudo pacman -S kvantum
# 具体配置参考 https://arch.icekylin.online/guide/advanced/beauty-2.html 相关内容
```

GRUB引导界面美化，我是用的Distro的GRUB主题，cd 进解压出来的文件夹，打开 konsole 输入

```zsh
sudo cp -rf . /usr/share/grub/themes/Distro
sudo nano /etc/default/grub
#GRUB_THEME=
GRUB_THEME="/usr/share/grub/themes/Distro/theme.txt" #修改后
grub-mkconfig -o /boot/grub/grub.cfg
```

`figlet` 显示由不同风格的 ASCII 艺术字符组成的文本

```zsh
sudo pacman -S figlet
echo "Love Live Linux" | figlet # 使用实例
```

`plasma6-wallpapers-wallpaper-engine-git` 可以在plasma使用小红车壁纸

```zsh
yay -S plasma6-wallpapers-wallpaper-engine-git
# 接下来下载小红车，在系统设置的壁纸中选用插件，选择小红车壁纸存放的位置读取
```

### 终端配置相关

[core utilities](https://wiki.archlinux.org/title/Core_utilities)
[更多终端工具](https://cn.x-cmd.com/pkg/)

在~/.zshrc中添加别名和其他配置

```conf
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
```

`zoxide` 前文 zsh 配置部分已经讲述过,cd的plus版本

```zsh
sudo pacman -S zoxide
alias cd='z'
```

`bat` cat的plus版本，语法高亮、Git集成、分页显示

```zsh
sudo pacman -S bat
alias cat='bat' 
```

`less` 可以cat查看时分页显示

```zsh
sudo pacman -S less
```

`lsd` ls的plus版本 彩色输出、图标支持、更好看的布局

```zsh
sudo pacman -S lsd
```

`fd` find的plus版本，默认忽略.gitignore、更快、更简单

```zsh
sudo pacman -S fd
alias find="fd" 
```

`ripgrep` rg的plus版本，递归搜索、忽略二进制文件、极快速度

```zsh
sudo pacman -S ripgrep
alias rg='rg --hidden --follow --glob "!.git/*"' 
```

`gping` ping工具的升级版，可以可视化显示ping的进度条，使用指令gping

```zsh
sudo pacman -S gping
# alias ping='gping' (我个人感觉没必要)
```

`dust` du的plus版本,可视化显示、更直观的磁盘使用分析

```zsh
sudo pacman -S dust
alias du="dust" 
```

`duf` df的plus版本,彩色表格输出、更清晰的磁盘信息

```zsh
sudo pacman -S duf
alias df="duf" 
```

`delta` diff的plus版本，语法高亮、并排显示、更好的diff体验

```zsh
sudo pacman -S git-delta
alias diff='delta' 
```

`tealdeer` tldr的rust版本，比man更易读，比--help更详细，而且本地缓存+中文文档+运行示例

```zsh
sudo pacman -S tealdeer
tldr --update
tldr ls # 查看ls的tldr说明（记忆tldr：贪婪的人）
# 因为我不想看man，而zsh内置run-help=man，快捷键alt+h就可以打开man文档，所以我直接把man命令替换为tldr，不用下载man-db
alias man='tldr'
ls # 按住alt+h，打开ls的tldr文档
```

`lazygit` git的终端图形化界面管理

```zsh
sudo pacman -S lazygit
```

`translate-shell` 终端翻译工具

```zsh
sudo pacman -S translate-shell
trans -b -i xxx -o xxx.txt # 简明翻译xxx，输出到xxx.txt
```

`cava` 终端音频可视化工具

```zsh
sudo pacman -S cava
```

### 开发

`LocalSend` 局域网传输 <https://localsend.org/zh-CN>

```zsh
yay -S localsend-bin
```

`scrcpy` 安卓设备投屏 <https://arch.icekylin.online/app/common/collaboration.html>

```zsh
sudo pacman -S scrcpy android-tools
scrcpy --turn-screen-off --stay-awake # 保持镜像屏幕常亮，开启有线连接安卓手机
```

`vscode` 所以你是用kate还是vscode还是neovim？哦对了，vscode也有neovim插件

```zsh
yay -S visual-studio-code-bin
```

`tmux` 终端复用，多任务管理。让你在远程服务器或长时间运行的任务中高效工作，即使网络断开或终端关闭，任务也不会中断

```zsh
sudo pacman -S tmux
```

`sniffent` 网络流量抓包工具

```zsh
sudo pacman -S sniffent
```

`realvnc-vnc-viewer` 用于显示香橙派，树莓派等远程桌面

```zsh
yay -S realvnc-vnc-viewer
```

`Input-Leap` linux 和 windows 多设备共用键鼠 <www.vindo.cn/blog/arch-windows> 注意要在同一个局域网，校园网这些因为有网络隔离，建议用手机热点连接或单独搞一个路由器或软路由来连接

```zsh
yay -S input-leap-bin
```

`Unarchiver` 解压 Windows 下的压缩包

```zsh
sudo pacman -S unarchiver
```

`screenkey` 用于显示键盘键入在屏幕上的工具，可用于录屏演示。

```zsh
sudo pacman -S screenkey
screenkey # 启动
```

### 游戏

`Steam` 游戏平台

```zsh
sudo pacman -S steam
```

`Lutris` linux开源游戏平台

```zsh
sudo pacman -S lutris
```

### 影音

`SMPlayer` 是个适用于 Windows 和 Linux 的自由免费的媒体播放器，内置解码器，可以播放几乎所有格式的视频和音频文件。无需再安装任何外部解码器。只要安装了 SMPlayer，就能够播放所有的格式，不用再费事查找安装解码包。基于mpv，所以也会下载mpv，可以理解为mpv plus版

```zsh
sudo pacman -S smplayer
yay -S papirus-smplayer-theme-git # 换一个外观皮肤，下载后在软件设置使用
```

`zyfun` 轻量高颜值视频客户端，在线影视，需要自己导入播放源

```zsh
yay -S zyfun-appimage
```

`yesplaymusic`第三方网易云播放器 高颜值 也可以用其他的平台音源，跟listen1一样做到全网资源聚合

```zsh
yay -S yesplaymusic
```

`Listen 1` 作为“老牌”的听歌软件可以搜索和播放来自网易云音乐、虾米、QQ 音乐、酷狗音乐、酷我音乐、Bilibili、咪咕音乐网站的歌曲，让你的曲库更全面。也有高颜值ui，但界面目前略有卡顿，还是用一般皮肤好点

```zsh
yay -S listen1-desktop-appimage
```

【】`FeelUOwn` 是一个稳定、用户友好以及高度可定制的音乐播放器

```zsh
yay -S feeluown
yay -S --asdeps feeluown-qqmusic
yay -S --asdeps feeluown-netease
yay -S --asdeps feeluown-kuwo
yay -S --asdeps feeluown-ytmusic
yay -S --asdeps feeluown-bilibili
```

### 社交通讯

`Telegram` 电报，社交软件，这个虽然闭源，但是隐私很安全

```zsh
sudo pacman -S telegram-desktop
```

`QQ` 官方linux版，闭源

```zsh
yay -S linuxqq
```

`微信` 官方linux版，闭源

```zsh
yay -S wechat wechat-bin
```

`Mozilla Thunderbird`（雷鸟）是由 Mozilla 基金会研发的一款自由开源的跨平台电子邮件客户端、新闻阅读器、聚合器以及即时通信软件

```zsh
sudo pacman -S thunderbird
```

### 常见软件

`qbittorrent` [linux推荐的下载软件](https://www.bilibili.com/video/BV1fPvNzmEC2/?spm_id_from=333.337.search-card.all.click&vd_source=7bd0bdc9ece4aa8666f734929c9b606d)

```zsh
yay -S qbittorrent-enhanced-git
# BT下载⽹站推荐
https://thepiratebay.org/index.html
https://www.1377x.to/
https://yts.mx/ # (主攻影视)
```

`Watt toolkit` steam++!

```zsh
yay -S watt-toolkit-bin
```

`百度网盘` 闭源

```zsh
yay -S baidunetdisk-bin
```

`WPS Office` 闭源，linux也有office开源套件

```zsh
yay -S wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts freetype2-wps libtiff5
```

`OBS Studio` 是免费开源的用于视频录制以及直播串流的软件。Linux 下操作与 Windows 下基本一致

```zsh
sudo pacman -S obs-studio
```

`bitwarden` 密码管理器，可部署也可自建

```zsh
sudo pacman -S bitwarden
```

`gimp` 一个自由开源的位图图像编辑器。其对标 Adobe 的 Photoshop

```zsh
sudo pacman -S gimp
```

`pot` 跨平台划词翻译工具

```zsh
sudo pacman -S pot-translation
```

### KDE生态: sudo pacman -S <软件名>

`Gwenview` 图像查看器，是浏览、显示多张图像时的理想工具

```zsh
sudo pacman -S gwenview
```

`Spectacle` 抓取桌面截图的简单应用程序。

```zsh
sudo pacman -S spectacle
```

`KCalc` —— 科学计算器

```zsh
sudo pacman -S kcalc
```

`Kamoso` —— 相机

```zsh
sudo pacman -S kamoso
```

`KTimer` —— 倒计时执行器

```zsh
sudo pacman -S ktimer
```

`KDE Connect` 提供了各种用于整合移动设备和计算机的功能。它可以将文件发送到另一台设备、控制它的媒体播放、发送远程输入、查看它的通知，以及做许多其它事情。

```zsh
sudo pacman -S kdeconnect sshfs
```

`KDE Runner` 类似listary或everything

```zsh
sudo pacman -S krunner
```

`kate` 超绝文本编辑器

```zsh
sudo pacman -S kate
```

`dolphin` 文件管理器

```zsh
sudo pacman -S dolphin
```

`kio-admin` 为 Dolphin 文件管理器添加了“以管理员身份打开”的右键菜单选项

```zsh
sudo pacman -S kio-admin
```

`okular`文档阅读器。可以使用它来阅读 PDF 文档、漫画电子书、Epub 电子书，浏览图像，显示 Markdown 文档等。

```zsh
sudo pacman -S okular
```

`ark` 压缩软件，在 dolphin 中可用右键解压压缩包

```zsh
sudo pacman -S ark
```

`gwenview` 图片查看器

```zsh
sudo pacman -S gwenview
```

`polkit-kde-agent` 图形化权限验证代理

磁盘挂载：当用户尝试挂载外部存储设备时，系统会通过 Polkit-KDE-Agent 请求用户输入密码。
网络管理：在使用 NetworkManager 切换 Wi-Fi 或移动网络时，可能需要通过 Polkit 进行权限验证。
系统操作：如关机、重启、挂起等操作，尤其是在多用户环境中。

```zsh
sudo pacman -S polkit-kde-agent
```
