---
title: 快乐的Linux命令行笔记-网络
date: 2019-02-19 21:45:29
categories:
- 笔记
- 读书笔记
- 快乐的Linux命令行
tags:
- 笔记
- 快乐的Linux命令行
- linux
---

[第一天的笔记-基本的命令和使用方法](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-1Day.html)
[第二天的笔记-操作文件](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-2Day.html)
[第三天的笔记-查阅命令文档并创建命令别名](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-3Day.html)
[第四天的笔记-重定向标准输入和输出以及处理查询结果](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-4Day.html)
[第五天的笔记-命令的展开](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-5Day.html)
[第六天的笔记-快捷键](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-6Day.html)
[第七天的笔记-文件权限](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-7Day.html)
[第八天的笔记-进程](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-8Day.html)
[第九天的笔记-修改shell环境](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-9Day.html)
[第十天的笔记-vim入门](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-10Day.html)
[第十一天的笔记-自定义shell提示符](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-11Day.html)
[第十二天的笔记-软件包管理系统](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-12Day.html)
[第十三天的笔记-创建映像](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-13Day.html)

# 总结
今天主要学习了linux如何检查网络情况, 使用ftp, ssh等工具传输文件, 使用ssh工具连接远端系统。
<!--more-->
# 检查和检测网络

## ping

```shell
ping www.icecreamzhao.github.io
```

一个成功执行的"ping"命令说明网络的各个部件(网卡, 电缆, 路由, 网关) 都处于正常的工作状态。

## traceroute

使用该命令(一些系统使用相似的tracepath)显示从本地到指定主机要经过的路由:

```shell
traceroute icecreamzhao.github.io
```

## netstat

使用该命令来检查网络设置和统计数据。

```shell
netstat -ie
```

> -ie 选项可以查看系统中的网络接口。

当查看网络接口时, 如果该网络接口信息的第四行开头有`UP`字样, 说明该网络接口已经生效; 如果系统使用DHCP(动态主机配置协议), 第二行中 inet addr 字段有有效的IP地址, 则证明了DHCP工作正常。

```shell
netstat -r
```

> -r 选项可以查看内核的网络路由表

    Destination Geteway     Genmask         Flags   MSS Window  irtt    Iface
    192.168.1.0 *           255.255.255.0   U       0   0       0       eth0
    default     192.168.1.1 0.0.0.0         UG      0   0       0       eth0

> 第一行显示了目的地 192.168.1.0。 IP地址以零结尾是指网络, 而不是指某一个主机。下一个字段是网关, 使用网关来连接当前的主机和目的地的网络。若这个字段显示一个星号, 则表明不需要网关。

> 最后一行包含目的地default, 指的是发往任何表上没有列出的目的地网络的流量。

# 网络中传输文件

## ftp

ftp 是文件传输协议, 由于它会以明码形式发送账号的姓名和密码, 所以几乎所有ftp服务器都是匿名的, 而匿名服务器允许任何人使用注册名"anonymous"和无意义的密码登录系统。

> 使用ftp程序下载一个iso文件

```shell
# fileserver 是ftp服务器的名字
ftp fileserver
# 输入登录名
Name (fileserver:me): anonymous
# 输入密码
Password:
# cd到要下载的文件的路径
cd pub/cd\_images/Ubuntu-8.04
ls
# 指定下载到的地址
lcd Desktop
# 下载文件
get ubuntu-8.04-desktop-1386.iso
bye
```

## lftp

工作方式和ftp类似, 但是包括多协议支持(包括HTTP), 若下载失败会自动重新下载, 后台处理, 用tab按键补全路径名等。

## wget

> 使用wget下载某一个网站的首页

```shell
wget http://read-notecommand.org/index.php
```

使用命令手册查看关于这个命令的其他说明。

# 与远程主机安全通信

## ssh

ssh的认证机制: 首先, 它需要认证远端主机是否为它所知道的那台主机(这样就阻止了所谓的"中间人"的攻击), 其次, 它加密了本地与远程主机之间所有的通讯信息。

ssh由两部分组成, SSH服务端运行在远端主机上, 在端口22上监听收到的外部链接, 而SSH客户端用在本地系统中, 用来和远端服务器通信。

大多数Linux发行版自带SSH的软件包, 叫做OpenSSH, 有一些只提供客户端, 为了能让系统接收远端的连接, 需要安装OpenSSH-server软件包, 它必须在TCP端口22上接受网络连接。

如果安装了 OpenSSH-server 软件包, 则可以使用localhost作为远端主机的名字, 这样计算机会和自己创建网络连接。

> 使用ssh客户端

```shell
# 使用ssh连接到名为remote-sys的远端主机
ssh remote-sys
# 当第一次连接时, 需要接受远端主机的身份验证凭据, 输入yes
yes
# 接着输入密码
me@remote-sys's password:
# 如果成功建立连接, 会接收到远端系统的shell提示符, 输入exit退出
exit
```

> 使用不同的用户名登录远端系统

```shell
ssh bob@remote-sys
```

如果远端主机不能成功通过验证, 则会提示错误信息, 有两种原因:

* 某个攻击者企图制造"中间人"攻击
* 操作系统或SSH服务器重新安装了

如果是第二种原因, 在文件~/.ssh/known_hosts中删除废弃的钥匙, 可以在错误信息中找到`offending key...`字样, 会提示在文件中的第几行包含废弃的钥匙, 删掉就好。

> 使用ssh执行单个命令

```shell
ssh remote-sys free
```

> 使用ssh执行单个命令的方式制定ls命令

```shell
# 将输出结果重定向到本地文件中
ssh remote-sys 'ls *' > dirlist.txt
# 将输出结果重定向到远端文件中
ssh remote-sys 'ls * > dirlist.txt'
```

## scp和sftp

* scp

> 被用来复制文件, 可以从远端系统复制到本地系统中。

```shell
scp remote-sys:document.txt
# 或者使用不同的用户名
scp bob@remote-sys:document.txt
```

* sftp

> 和ftp工作方式类似, 可是使用加密的ssh通道来传递数据, 它不需要远端系统运行FTP服务端, 仅需要SSH服务端

```shell
sftp remote-sys
ls
lcd Desktop
get ubuntu-8.04-desktop-i286.iso
bye
```

[关于windows的SSH客户端(PuTTY)](http://www.chiark.greenend.org.uk/~sgtatham/putty/)
