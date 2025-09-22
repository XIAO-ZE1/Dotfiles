# 记录我遇到的一些bug或者需要记下来的操作

## 蓝牙

遇到蓝牙设备连接不上，不要慌，试试systemctl restart bluetooth。如果这样也没反应，那就忘记设备重新配对，这样应该能解决。前提是你的蓝牙工具都配置好了。再不济就去arch wiki看看。

## reboot

如果你要在终端reboot，那么请一定确认你的代理是否关闭，我的v2ray如果没有正常关闭，那么reboot重启后，会直接满负载运行内存和cpu，给cpu干到90度，具体原因等我查查wiki

## 休眠到硬盘

手动命令：systemctl hibernate

## 切换桌面环境

systemctl restart sddm
