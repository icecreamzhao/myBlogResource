---
title: 快乐的Linux命令行笔记-第十三天
date: 2019-02-18 23:12:32
categories:
- 读书笔记
- 快乐的Linux命令行
tags:
- 笔记
- 快乐的Linux命令行
- linux
---

[第一天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-1Day.html)
[第二天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-2Day.html)
[第三天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-3Day.html)
[第四天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-4Day.html)
[第五天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-5Day.html)
[第六天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-6Day.html)
[第七天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-7Day.html)
[第八天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-8Day.html)
[第九天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-9Day.html)
[第十天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-10Day.html)
[第十一天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-11Day.html)
[第十二天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-12Day.html)
# 总结
<!--more-->
 
# 挂载和卸载存储设备

在`/etc/fstab`中, 列出了系统启动时要挂载的设备, 例如(来自Fedora 7系统的文件实例):

    LABEL=/12       /       ext3        defaults        1       1
    LABEL=/home     /home   ext3        defaults        1       2
    LABEL=/boot     /boot   ext3        defaults        1       2

> 字段说明

| 字段 | 内容 | 说明 |
| :--- | :--- | :--- |
| 1 | 设备名 | 传统上, 这个字段包含与物理设备相关联的设备文件的实际名字, 比如说/dev/hda1(第一个IDE通道上第一个主设备分区)。然而今天的计算机, 有很多热插拔设备(像USB驱动设备), 许多现代的Linux发行版用一个文本标签和设备相关联。当这个设备连接到系统中时, 这个标签(当储存媒介格式化时, 这个标签会被添加到存储媒介中)会被操作系统读取, 那样的话, 不管赋给实际物理设备哪个设备文件, 这个设备仍能被系统正确地识别。 |
| 2 | 挂载点 | 设备所连接到的文件系统树的目录 |
| 3 | 文件系统 | Linux 允许挂在许多文件系统类型。大多数本地的Linux文件系统是ext3, 但是也支持很多其它的, 比如FAT16(msdos), FAT32(vfat), NTFS(ntfs), CD-ROM(iso9660), 等等。 |
| 4 | 选项 | 文件系统可以通过各种各样的选项来挂载。有可能, 例如, 挂载只读的文件系统, 或者挂载阻止执行任何程序的文件系统(一个有用的安全特性, 避免删除媒介。) |
| 5 | 频率 | 一位数字, 制定是否和在什么时间用dump命令来备份一个文件系统。 |
| 6 | 次序 | 一位数字, 指定fsck命令按照什么次序来检查文件系统。 |

## 查看挂载的文件系统列表

使用mount命令来查看当前挂载的文件系统

```shell
mount
```
显示的列表的格式是:设备 on 挂载点(文件路径) type 文件系统类型 (选项), 比如:

pstore on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,modev,noexec,relatime,hugetlb)

## 挂载和卸载设备

首先插入一个移动设备, 系统会自动挂载该设备。


