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
今天学习了如何挂载和卸载设备, 创建映像文件, 将映像文件写入到CD-ROM中, 使用md5检测文件完整性。
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

# 创建新的文件系统

即格式化移动设备。

## 使用fdisk来操作分区

```shell
# 卸载设备, 这里指定的是分区号
sudo umount /dev/sdb1
# 调用fdisk, 这里指定的是设备名称
sudo fdisk /dev/sdb
```

之后会显示fdisk的命令:

```shell
Command (m for help):
```

输入`p`会打印这个设备的分区表

输入`l`会打印所有可用的**分区类型**列表, 可以看到83是针对Linux系统的ID号

输入`t`来更改分区ID号, 例如:

```shell
Command (m for help): t
Selected partition 1
Hex code (type L to list codes): 83
Changed system type of partition 1 to 83 (Linux)
```

输入`w`将修改过的设置从内存写入到物理设备

## 使用mkfs命令创建一个新的文件系统

```shell
sudo mkfs -t ext3 /dev/sdb1
```

`-t`来指定文件系统类型, 紧跟着的是需要格式化的分区

[这篇博客](https://www.cnblogs.com/daduryi/p/6619028.html?utm_source=itdadao&utm_medium=referral)介绍了各个文件系统类型。

## 测试和修复文件系统

使用fsck命令检查驱动器(需要先执行卸载)

```shell
sudo fsck /dev/sdb1
```

## 格式化软盘
步骤:
将软盘进行低级格式化
创建何使的文件系统

使用fdformat来格式化软盘。

```shell
# 指定软盘设备名称
sudo fdformat /dev/fd0
```

接下来创建一个FAT文件系统

```shell
sudo mkfs -t msdos /dev/fd0
```

## 移动或复制整个设备中的所有数据

```shell
dd if=input_file of=output_file [bs=block_size [count=blocks]]
```

如果有两个相同容量的USB闪存驱动器, 并且要精确的把第一个驱动器中的内容复制给第二个(/dev/sdb, /dev/sdc)

```shell
dd if=/dev/sdb of=/dev/sdc
```

将驱动器中的内容复制到一个普通文件中:

```shell
dd if=/dev/sdb of=flash_drive.img
```

## 创建 CD-ROM 映像

步骤:

* 构建一个 ISO映像文件
* 将这个映像文件写入到CD-ROM媒介中

### 制作ISO映像文件

```shell
dd if=/dev/cdrom of=ubuntu.iso
```

> 对于音频CD, 可以使用cdrdao命令

### 使用某一个目录来创建映像文件

```shell
genisoimage -o cd-rom.iso -R -J ~/cd-rom-files
```

* `-R`选项添加元数据为Rock Ridge扩展, 这允许使用长文件名和 `POSIX`风格的文件权限
* `-J`选项使 Joliet 扩展生效, 这样 Windows中就支持长文件名了

> wodim 和 genisoimage 这两个程序分别替代了 cdrecord 和 mkisofs, 它们是cdrtools 软件包的一部分。

### 将ISO写入CD-ROM中

> 直接挂载一个ISO镜像

```shell
mkdir /mnt/iso_image
mount -t iso9660 -o loop image.iso /mnt/iso_image
```

> 清除一张可重写入的CD-ROM

```shell
wodim dev=/dev/cdrw black=fast
```

> 写入镜像

```shell
wodim dev=/dev/cdrw image.iso
```

# 使用md5sum校验文件的完整性

每一个文件都有一个独一无二的md5sum, 除非两个文件一摸一样。

可以通过md5sum命令来查看生成的数字, 是否与提供者所提供的数字完全一样。

```shell
md5sum image.iso
```

最后有一个比较复杂的检查文件完整性的命令:

```shell
md5sum dvd-image.iso; dd if=/dev/dvd bs=2048 count=$(( $( stat -c "%s" dvd-image.iso) /2048 ))
```

[这里是有关stat命令的介绍](https://blog.csdn.net/paicmis/article/details/60479639)
