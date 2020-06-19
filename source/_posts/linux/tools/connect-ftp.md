---
title: CentOS下使用ftp协议连接ftp服务器
date: 2019-08-14 16:07:46
categories:
- 运维
- linux
tags:
- linux的使用
---

# 前言

[这篇博客](/linux/tools/open-ftp.html)介绍了如何搭建ftp服务器, 现在我们来使用shell的方式连接它吧。

<!--more-->

# ftp 客户端的一些命令

* 安装ftp client

`sudo yum install ftp -y`

* 登录ftp

`ftp ipaddress`

* 显示当前ftp状态

`status` 

* 显示远端服务器系统类型

`system`

* 列出当前远端主机目录中的文件.如果有本地文件,就将结果写至本地文件,同ls

`dir [remote-directory] [local-file]`

* 列出远端主机当前目录

`pwd`

* 在远端主机中建立目录

`mkdir directory-name`

* 删除远端主机中的目录

`rmdir directory-name`

* 返回上一级目录

`cdup`

* 改变当前本地主机的工作目录,如果缺省,就转到当前用户的HOME目录

`lcd`

* 改变远端主机的文件权限

`chmod`

* 将本地一个文件传送至远端主机中（等价命令为send）

`put local-file [remote-file]`

* 将本地主机中一批文件传送至远端主机

`mput local-files`

* 删除远端主机中的文件

`delete`

* 删除一批文件

`mdelete [remote-files]`

* 退出FTP模式

`bye`
