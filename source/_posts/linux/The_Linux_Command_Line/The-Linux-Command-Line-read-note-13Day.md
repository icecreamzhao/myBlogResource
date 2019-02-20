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

使用`mount`命令来查看刚刚挂载的设备名。

之后卸载这个设备, 重新挂载到另一个位置。

```shell
umount /dev/hdc
# 创建一个文件夹用来挂载该设备
mkdir /mnt/cdrom
# -t 选项用来指定文件系统类型
mount -t iso9660 /dev/hdc /mnt/cdrom
```
> 注意, 卸载需要使用超级用户权限。

然后就可以cd到该文件夹下, 查看该设备中的文件。

```shell
cd /mnt/cdrom
ls
```
> 在早期, 当人们编辑完文档需要打印时, 虽然电脑读取速度很快, 可是打印机的接受速度很慢, 在打印的过程中电脑什么也做不了, 所以加入了缓存。计算机先将文档快速的输入到缓存中去, 之后计算机可以做其他事情, 而缓存中的文档则以打印机可以接受的速度进行输入。
现在不只是打印机这样做, 计算机中也有缓存。操作系统会尽可能的将数据写入到内存中, 之后在合适的时间进行真正的写入到物理设备中。在执行卸载操作之前, 操作系统会将内存中所有应该被写入到物理设备中的数据写入, 在进行卸载, 而如果不执行卸载操作则会导致文件损坏。

# 确定设备名称

如果遇到了不支持自动挂载的环境, 则需要自己查找设备名称来进行挂载。

> 查看所有设备

```shell
ls /dev
```

Linux 存储设备名称

| 模式 | 设备 |
| :--- | :--- |
| /dev/fd* | 软盘驱动器 |
| /dev/hd* | 老系统中的 IDE(PATA) 磁盘。典型的主板包含两个IDE连接器或者是通道, 每个连接器带有一根缆线, 每根缆线上有两个硬盘驱动器连接点。缆线上第一个驱动器叫做主设备, 第二个叫做从设备。设备名称这样安排, /dev/hda 是指第一通道上的主设备名; /dev/hdb 是第一通道上的从设备名; /dev/hdc 是第二通道上的主设备名, 等等。末尾的数字表示硬盘驱动器上的分区。例如, /dev/hda1 是指系统中第一硬盘驱动器上的第一个分区, 而 /dev/hda 则是指整个硬盘驱动器。 |
| /dev/lp* | 打印机 |
| /dev/sd* | SCSI 磁盘。在最近的Linux 系统中, 内核把所有类似于磁盘的设备(包括 PATA/SATA 硬盘, 闪存, 和USB存储设备, 比如说可移动的音乐播放器和数码相机) 看作 SCSI 磁盘。剩下的命名系统类似于上述所描述的旧的 /dev/hd* 命名方案。 |
| /dev/sr* | 光盘(CD/DVD 读取器和烧写器) |

> 查看刚刚插入的设备名称的方法

```shell
# 启动一个实时查看文件
sudo tail -f /var/log/messages
# 插入这个设备
# 当日志停止滚动时, 输入ctrl-c, 查看日志, 有一行日志会显示该设备的名字, 使用这个名字挂载设备
mkdir /mnt/flash
mount /dev/sdb1 /mnt/flash
```

