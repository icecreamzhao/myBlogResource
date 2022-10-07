---
title: 快乐的Linux命令行笔记-修改shell环境
date: 2019-02-07 23:39:25
categories:
- 笔记
- 读书笔记
- 快乐的Linux命令行
tags:
- 笔记
- 快乐的Linux命令行
- linux
---

[第一天的笔记-基本的命令和使用方法](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-1Day.html)
[第二天的笔记-操作文件](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-2Day.html)
[第三天的笔记-查阅命令文档并创建命令别名](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-3Day.html)
[第四天的笔记-重定向标准输入和输出以及处理查询结果](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-4Day.html)
[第五天的笔记-命令的展开](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-5Day.html)
[第六天的笔记-快捷键](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-6Day.html)
[第七天的笔记-文件权限](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-7Day.html)
[第八天的笔记-进程](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-8Day.html)

# 总结
今天学习了如何修改shell环境, 如何添加环境变量。
<!--more-->
# 环境变量

使用下列命令来查看环境变量

```shell
printenv
```
也可以查看单独的某一个环境变量:

```shell
printenv UESR
```

使用下列命令来查看shell变量(和环境变量)

```shell
set
```

可以通过`echo`命令l来查看一个变量的内容

```shell
echo $HOME
```

通过`alias`来查看别名

```shell
alias
```

一部分shell变量的含义:

| 变量 | 内容 |
| :--: | :-- |
| DISPLAY | 	如果你正在运行图形界面环境，那么这个变量就是你显示器的名字。通常，它是 ":0"， 意思是由 X 产生的第一个显示器。 |
| EDITOR | 文本编辑器的名字。 |
| SHELL | shell程序的名字。 |
| HOME | 用户的家目录。 |
| LANG | 定义了字符集以及语言编码方式。 |
| OLD_PWD | 以前的工作目录。 |
| PAGER | 页输出程序的名字。这经常设置为/usr/bin/less。 |
| PATH | 由冒号分开的目录列表，当你输入可执行程序名后，会搜索这个目录列表。|
| PS1 | Prompt String 1. 这个定义了你的 shell 提示符的内容。随后我们可以看到，这个变量 内容可以全面地定制。 |
| PWD | 当前工作目录。 |
| TERM | 终端类型名。类 Unix 的系统支持许多终端协议；这个变量设置你的终端仿真器所用的协议。 |
| TZ | 指定你所在的时区。大多数类 Unix 的系统按照协调时间时 (UTC) 来维护计算机内部的时钟 ，然后应用一个由这个变量指定的偏差来显示本地时间。 |
| USER | 你的用户名。 |

## shell启动后读取的配置

* 登录shell会话的启动文件

| 文件 | 内容 |
| :---: | :-- |
| /etc/profile | 应用于所有用户的全局配置脚本 |
| ~/.bash_profile | 用户个人的启动文件, 用来扩展或重写全局脚本中的设置 |
| ~/.bash_login | 如果文件 ~/.bash_profile 没有找到，bash 会尝试读取这个脚本 |
| ~/.profile | 如果文件 ~/.bash_profile 或文件 ~/.bash_login 都没有找到，bash 会试图读取这个文件。 这是基于 Debian 发行版的默认设置，比方说 Ubuntu |

* 非登录shell会话的启动文件

| 文件 | 内容 |
| :--: | :-- |
| /etc/bash.bashrc | 应用于所有用户的全局配置文件 |
| ~/.bashrc | 用户个人的启动文件。可以用来扩展或重写全局配置脚本中的设置 |

> 除了读取以上启动文件之外, 非登录shell会话也会继承他们的父进程环境设置, 通常是一个登录shell

# 修改shell环境

当我们需要定制shell环境时, 可以修改`bash_profile`文件, 对于其他的更改, 可以放到`bashrc`文件中, 而如果需要为系统中所有用户修改默认配置, 则需要更改`/etc/profile`文件。

## 文本编译器

在centOS7系统中, 可以使用`nano`编译器来编译文件, `ctrl-o` 是保存文件, `ctrl-x` 是退出编译器。

```shell
source bashrc
```

重新读取修改之后的文件。
