---
title: 快乐的Linux命令行笔记-第七天
date: 2019-01-30 01:03:17
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

# 总结
今天学习了文件权限的意义, 如何修改文件权限, 修改掩码值以及如何添加用户和用户组。
<!--more-->
# 身份信息

使用以下命令来查看关于当前登陆用户的身份信息:

```shell
id
```

结果:
```shell
uid=1000(littleboy) gid=1000(littleboy) groups=1000(littleboy),10(wheel) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

不同的系统的输出看起来不一样。

所有的用户和用户组被定义在 `/etc/passwd` 和 `etc/group` 这两个文件中。

# 文件读写权限

使用
```shell
ls -l
```
来显示文件的权限,结果有可能是这样的:

```shell
-rw-rw-r--. 1 littleboy littleboy 0 Jan 29 13:04 foo.txt
```

结果中的第一个字符表示文件的类型, 还有以下其他的类型:

| 属性 | 文件类型 |
| --: | :-- |
| - | 一个普通文件 |
| d | 一个目录 |
| l | 一个符号链接, 所有的符号链接的剩余的属性总是 `rwxrwxrwx`, 真正的属性需要查看源文件
| c | 一个字符设备文件, 表示按照字节流来处理数据的设备, 比如终端机或者调制解调器 |
| b | 一个块设备文件, 表示按照数据块处理数据的设备, 比如一个硬盘或者一个CD-ROM盘 |


剩下的属性代表着文件读写的权限:

| Owner | Group | World |
| -----: | :---: | :---- |
| rwx | rwx | rwx |


权限属性:

| 属性 | 文件 | 目录|
| --: | :--: | :-- |
| r | 允许读取文件内容 | 允许列出目录中的文件,前提是目录中设置了x属性 |
| w | 允许写入内容或截断文件, 但是不允许对文件执行重命名或删除, 重命名或删除是由目录的属性决定的 | 允许在目录下新建, 删除或重命名文件, 前提是目录中设置了x属性 |
| x | 允许将文件作为程序来执行, 使用脚本语言编写的文件必须设为可读才能被执行 | 允许进入目录(cd) |

# 更改文件或目录权限

使用chmod命令来更改文件权限

| 八进制 | 二进制 | 文件权限 |
| -----: | :---: | :------ |
| 0 | 000 | --- |
| 1 | 001 | --x |
| 2 | 010 | -w- |
| 3 | 011 | -wx |
| 4 | 100 | r-- |
| 5 | 101 | r-x |
| 6 | 110 | rw- |
| 7 | 111 | rwx |

将一个文件的权限修改为只有拥有者可读可写:
```shell
chmod 600 foo.txt
```
## 符号表示法

使用符号来修改文件权限

| 缩写 | 意义 |
| --: | :-- |
| u | "user"的缩写 |
| g | "group"的缩写 |
| o | "other"的缩写 |
| a | "all"的缩写 |

> 这里other代表拥有者和拥有者的用户组之外的其他人。

如果想指定拥有者对该文件的权限是可读可写, 那么可以这样: 

```shell
chmod u+r+x foo.txt
```

如果想指定所有人对该文件的权限, 可以直接这样写:

```shell
chmod +r+x foo.txt
```

下面这行命令代表赋予用户组和其他人读写的权限, 如果已经有该权限, 则移除

```shell
chmod go=rw foo.txt
```

## 修改默认权限

使用 `umask` 命令修改默认权限(掩码值), 比如:

```shell
umask 0022
> foo.txt
ls -l
```

此时, foo.txt的权限为`rw-r-r`。
`umask`使用八进制表示权限
0022表示`000 000 010 010`, 出现1的位置, 删除原来的权限, 0则保留。

# 更改身份

## su命令

可以指定用户运行一个shell

```shell
su -
```
如果不指定用户名, 则默认是超级用户, 输入好超级用户的密码之后就可以以超级用户身份下运行shell了, 退出输入`exit`

也可以只使用超级用户身份运行一行命令:
```shell
su -c 'command'
```

## sudo命令

sudo和su命令的差异:

1. 管理员可以配置sudo命令
2. sudo命令需要的密码是当前用户的密码, 而su命令是管理员的密码

# 更改文件所有者和用户组

语法:

```shell
chown [ower][:[group]] file
```

| 参数 | 结果 |
| --: | :-- |
| bob | 更改文件拥有者为bob |
| bob:users | 更改文件拥有者为bob, 文件用户组为users |
| :admins | 文件用户组更改为admins, 拥有者不变 |
| bob: | 文件拥有者为bob, 用户组改为bob所在的用户组 |

chgrp

> 在旧版的unix系统中, chown不能更改用户组所有权, 可以使用chgrp命令来更改用户组所有权

# 添加一个用户

```shell
mkdir /home/bill
adduser -d /home/bill bill
passwd bill
# 或者
useradd bill
passwd bill
```

添加一个名为bill的用户并为bill设置密码

# 添加一个用户组

```shell
groupadd test
```

添加一个名为test用户组

# 将已有的用户放到其他用户组

```shell
useradd -G [groupname] [username]
```