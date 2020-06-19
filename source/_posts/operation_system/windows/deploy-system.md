---
title: 装机
date: 2018-11-30 19:51:27
categories:
- 运维
- windows
tags:
- windows
---

## 前言

今天我的室友将他的电脑留在这里, 那么不对它做些什么是不可能的! 哈哈, 那么, 我就开始啦。



<!--more-->

### 双系统

如果只是装一个windows的话, 就没有必要特意写一篇博客了。既然决定写一篇博客, 那么双系统肯定是要上的。

我打算安装的双系统是ubuntu + windows10, 其实说来也简单, 主要思路是先安装ubuntu, 然后载安装windows, 最后通过修改ubuntu的启动文件(grub.conf)来启到引导系统的作用。



### 安装windows到非启动盘

其实还挺麻烦的, 但是我已经将我遇到的困难总结好了, 下面是我的总结。



#### 安装windows系统遇到的问题以及解决步骤

1. 遇到了Windows无法安装到GPT分区形式磁盘的问题

   解决办法是，使用高级启动，命令行中：
   输入：diskpart
   输入：list disk
   输入：select disk 0（这里输入你想要安装的磁盘编号）
   输入：clean
   输入：convert mbr
   输入：create partition primary size = xxx，回车
   创建主分区大小（MB）
   输入：format fs=ntfs quick，回车
   格式化磁盘为ntfs
   输入：exit，回车
   退出diskpart
   输入：exit，回车
   退出cmd

2. 遇到了Windows无法安装到所选位置.错误:0X80300024的问题

   解决办法是，将启动方式改成uefi，第一启动项设置成要安装系统的盘符



下面是我觉得一些很厉害的博客, 有时间做个总结。

[实现Windows7和Ubuntu9.04的双启动](http://www.cqvip.com/QK/87339A/200910X/68789083504848575148494854.html)

[ubuntu 10.10 grub 添加win7系统引导 （附grub2讲解）](http://blog.chinaunix.net/uid-15007890-id-3056369.html)

[Ubuntu grub设置](https://blog.csdn.net/thalo1204/article/details/48369093)

[grub4dos命令和grldr引导文件介绍](https://blog.csdn.net/a5nan/article/details/65435072)

[grub4dos初级教程](https://blog.csdn.net/weixin_42809008/article/details/81232824)

[中国DOS联盟](http://cndos.fam.cx/forum/viewthread.php?tid=28300&fpage=1)

[纯MS-DOS 7.10完整安装版](http://www.cn-dos.net/newdos/dosart32.htm)
