---
title: 快乐的Linux命令行笔记-查阅命令文档并创建命令别名
date: 2018-12-01 20:17:10
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

# 总结

今天学到了有关怎样查阅命令的帮助文档以及怎样创建属于自己的命令别名。

<!--more-->

<br>

# 使用命令

## 定义

* 是一个可执行程序, 可以是用诸如C和C++语言写成的程序编译的二进制文件, 也可以是有shell, perl, python, ruby等脚本语言写成的程序。
* 是一个内建于shell自身的命令(例如cd)
* 是一个shell函数
* 是一个命令别名

## 显示命令的类型

```shell
$ type command # comman是你要查看的命令
```

## 显示一个可执行程序的位置

```shell
$ which command # command是要查看的命令, 只对可执行程序有效, 不包含内建命令和命令别名
```

## 得到命令文档

```shell
$ help command # command是要查看的命令
```

## 显示用法信息

```shell
$ command --help # command是要查看的命令, 不是所有的命令都支持这一选项
```

## 显示手册页

```shell
$ man program # program是要查看的命令
$ man section program # section是要查看的章节页
```

## 全局搜索手册

```shell
$ apropos keyword # keyword是你要搜索的关键字
```

结果的第一个字段是手册页的名字, 第二个字段是章节

## 显示简洁的命令说明

```shell
$ whatis program # program是要查看的命令
```

## 显示程序info条目

```shell
$ info program # program是要查看的命令
```

> info 命令

| 命令                | 行为                         |
| ----------------- | -------------------------- |
| ?                 | 显示命令帮助                     |
| PgUp or Bachspace | 显示上一页                      |
| n                 | 下一个 - 显示下一个节点              |
| p                 | 上一个 - 显示上一个节点              |
| u                 | Up - 显示当前所显示节点的父节点, 通常是个菜单 |
| Enter             | 激活光标位置下的超级链接               |
| q                 | 退出                         |

## 用别名创建自己的命令

命令和命令之间可以使用`;`来隔开

```shell
$ command1; command2; command3
```

创建命令别名的方式:

```shell
$ alias name='string' # name是你的命令的别名, string是你需要执行的命令
################## 例子
$ alias createPG='cd; mkdir playground; cd playground; mkdir dir1; cp /etc/passwd dir1; ln dir1/passwd dir1/passwd-hard; ls dir1 -l'
```

删除别名:

```shell
$ unalias createPG
```

