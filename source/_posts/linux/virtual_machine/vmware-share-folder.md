---
title: 使用VMware虚拟机CentOS操作系统遇到的共享文件夹的问题
date: 2019-02-24 23:59:22
categories:
- 虚拟机
- Linux
tags:
- 虚拟机
- Linux
---

# 前言

我在使用Vmware时, 遇到了想和物理主机互传文件的问题, 所以就有了此篇文章。
<!--more-->

# 步骤

* 首先安装所需要的依赖

```shell
yum -y install kernel-devel=$(uname -r)
yum -y install net-tools perl gcc gcc-c++
```

* 安装vm tool

```shell
mount /dev/cdrom /home/tmp
cp /home/tmp/VMwareTools-9.6.0-1294478.tar.gz /tmp
cd /tmp
tar -zxf VMwareTools-9.6.0-1294478.tar.gz
cd vmware-tools-distrib
./vmware-install.pl
```

* 安装vmhgfs-fuse

```shell
yum install open-vm-tools-devel -y
# ubuntu是 open-vm-dkms, 安装好之后使用这个工具挂载
vmhgfs-fuse .host:/ /home/littleboy/winShareFolder
```

进入 `home/littleboy/winShareFolder` 就可以看到共享的文件夹了。
