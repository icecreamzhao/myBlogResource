---
title: 在树莓派上安装 archlinux
date: 2020-03-17 01:51:35
-categories:
- 配置技巧/经验
- 系统配置
- linux
tags:
- archlinux
---

# 步骤

首先使用 `fdisk -l`, 在系统中查看你的内存卡的路径, 我的是 `/dev/sda`。

知道了路径之后使用 `fdisk /dev/sda` 进行分区。

步骤如下:

```
输入 o 并回车，这将会删除所有分区
输入 p 并回车，这将会列出所有分区，此时应该没有任何分区
输入 n 并回车，创建新分区，引导分区
输入 p 并回车，新分区为主分区
输入 1 并回车，分区序号是1 按键盘回车，默认初始扇区
输入 +100M 并回车，设置终止扇区
输入 t 并回车，再输入 c 并回车，设置该分区文件系统格式为Fat32
输入 n 并回车，创建新分区，根分区
输入 p 并回车，新分区为主分区
输入 2 并回车，分区序号是2 按键盘回车，默认初始扇区 按键盘回车，默认终止扇区
输入 w 并回车，写入设置
```

接着格式化分区:

```
mkfs.vfat /dev/sdX1
mkfs.ext4 /dev/sdX2
```


