#!/bin/bash

echo "开始更新符号链接..."

# 更新目录型配置的符号链接
directories=(
    "fcitx5" "hypr" "kitty" "nvim"
    "mako" "ranger" "waybar" "wofi"
    "gtk-3.0" "gtk-4.0"
)

for dir in "${directories[@]}"; do
    if [ -L ~/.config/"$dir" ]; then
        rm ~/.config/"$dir"
        ln -s ~/dotfiles/.config/"$dir" ~/.config/"$dir"
        echo "✅ 更新目录链接: $dir"
    fi
done

# 更新文件型配置的符号链接
files=(
    "dolphinrc" "katerc" "kdeglobals" "kglobalshortcutsrc"
    "konsolerc" "kwinrc" "mimeapps.list"
    "plasma-org.kde.plasma.desktop-appletsrc" "spectaclerc"
    "user-dirs.dirs"
)

for file in "${files[@]}"; do
    if [ -L ~/.config/"$file" ]; then
        rm ~/.config/"$file"
        ln -s ~/dotfiles/.config/"$file" ~/.config/"$file"
        echo "✅ 更新文件链接: $file"
    fi
done

echo "符号链接更新完成！"
