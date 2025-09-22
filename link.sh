#!/bin/bash

# =============================================
# Dotfiles 全自动安装脚本
# 功能：在新设备上一键安装所有配置
# =============================================

set -e  # 遇到错误立即退出

echo "🚀 开始安装 dotfiles 配置..."

# ---------------------------------------------------
# 颜色输出函数
# ---------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ---------------------------------------------------
# 检查依赖
# ---------------------------------------------------
check_dependencies() {
    info "检查系统依赖..."
    
    local deps=("git" "zsh" "curl")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            error "缺少依赖: $dep"
            exit 1
        fi
    done
}

# ---------------------------------------------------
# 克隆仓库
# ---------------------------------------------------
clone_repo() {
    info "克隆 dotfiles 仓库..."
    
    if [ -d "$HOME/dotfiles" ]; then
        warn "dotfiles 目录已存在，跳过克隆"
        return
    fi
    
    git clone https://github.com/XIAO-ZE1/dotfiles.git "$HOME/dotfiles"
}

# ---------------------------------------------------
# 创建符号链接
# ---------------------------------------------------
create_links() {
    info "创建符号链接..."
    
    # 创建 config 目录
    mkdir -p "$HOME/.config"
    
    # 链接 .config 下的所有配置
    if [ -d "$HOME/dotfiles/.config" ]; then
        for item in "$HOME/dotfiles/.config"/*; do
            local name=$(basename "$item")
            ln -sf "$item" "$HOME/.config/$name"
            info "已链接: ~/.config/$name"
        done
    fi
    
    # 链接主目录的点文件
    if [ -d "$HOME/dotfiles/home" ]; then
        for item in "$HOME/dotfiles/home"/*; do
            local name=$(basename "$item")
            ln -sf "$item" "$HOME/$name"
            info "已链接: ~/$name"
        done
    fi
}

# ---------------------------------------------------
# 安装额外组件
# ---------------------------------------------------
install_extras() {
    info "安装额外组件..."
    
    # 安装 Zim Framework
    if [ ! -d "$HOME/.zim" ]; then
        info "安装 Zim Framework..."
        curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
    fi
    
    # 安装插件管理器（可选）
    if [ -f "$HOME/dotfiles/scripts/install_extras.sh" ]; then
        "$HOME/dotfiles/scripts/install_extras.sh"
    fi
}

# ---------------------------------------------------
# 设置默认 shell
# ---------------------------------------------------
set_default_shell() {
    info "设置默认 shell..."
    
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        info "已将默认 shell 设置为 zsh"
    fi
}

# ---------------------------------------------------
# 主函数
# ---------------------------------------------------
main() {
    info "开始 dotfiles 自动化安装"
    
    check_dependencies
    clone_repo
    create_links
    install_extras
    set_default_shell
    
    info "安装完成！"
    info "请重新登录或执行: exec zsh"
}
