---
title: 快乐的Linux命令行笔记-查找文件
date: 2019-02-21 15:29:04
categories:
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
[第九天的笔记-修改shell环境](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-9Day.html)
[第十天的笔记-vim入门](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-10Day.html)
[第十一天的笔记-自定义shell提示符](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-11Day.html)
[第十二天的笔记-软件包管理系统](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-12Day.html)
[第十三天的笔记-创建映像](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-13Day.html)
[第十四天的笔记-网络](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-14Day.html)

# 总结

今天主要学习了如何根据条件来查找文件。主要学习的是find命令。
<!--more-->

# 查找文件

## locate

> 该程序会执行一次快速的路径名数据库搜索, 并输出每个与给定子字符串相匹配的路径名。

```shell
# 假定包含程序的目录以bin/结尾, 查找所有zip开头的文件
locate bin/zip
# 使用grep命令设计更加复杂的搜索
locate zip | grep bin
```

locate的数据库由updatedb创建, 这个程序作为一个定时任务周期性运转。可以使用超级用户权限来手动运行updatedb命令来更新数据库。

## find

> locate 只能依据文件名来查找文件, 而find可以根据文件的各种属性来查找文件。

```shell
find ~ | wc -l
```

该命令可以统计 `home` 路径下的所有文件的数量。

### 根据文件属性查找文件

```shell
find ~ -type d | wc -l
```

`-type d` 指定了只统计文件路径。

以下是find命令支持的常见的文件类型条件:

| 文件类型 | 描述 |
| :------- | :--- |
| b | 块特殊设备文件 |
| c | 字符特殊设备文件 |
| d | 目录 |
| f | 普通文件 |
| l | 符号链接 |

还可以加入额外的条件, 比如文件大小和文件名来进行查找文件:

```shell
find ~ -type f -name "*.jpg" -size +1M | wc -l
```

该命令统计了 `home` 路径下所有后缀名为 `.jpg` 并且文件大小大于1M的文件数量。

以下是find命令支持的常见文件单位条件:

| 字符 | 单位 |
| :--- | :--- |
| b | 512个字节块, 如果没有指定单位, 则这是默认值 |
| c | 字节 |
| w | 两个字节的字 |
| k | 千字节, 1024个字节 |
| M | 兆字节, 1048576个字节 |
| G | 千兆字节, 1073741824个字节 |

> 注意, 这里兆字节和千兆字节都是需要大写的

更多的搜索条件可通过find命令手册查看。

### 使用操作符来创建更复杂的条件

```shell
find ~ \( -type f -not -perm 0600 \) -or \( -type d -not perm 0700 \)
```

上边的表达式会查找出所有权限不是`0600`的文件以及所有权限不是`0700`的文件夹。

预定义的find命令操作

| 操作 | 描述 |
| :--- | :--- |
| -delete | 删除当前匹配的文件 |
| -ls | 对匹配的文件指定 ls -dlis 命令 |
| -print | 将匹配的文件发送到标准输出 |
| -quit | 一旦找到一个匹配的文件, 则退出 |

比如, 想要删除文件扩展名为".bak"的文件, 可以这样写:

```shell
find ~ -type f -name "*.bak" -delete
```

### 自定义行为

使用 `-exec` 命令来进行自定义行为, 比如:

```shell
find ~ -type f -name "*.bak" -exec rm '{}' ';'
```

可以将匹配的结果删除, 达到 `-delete` 的效果。

### 提高效率

使用exec命令的时候, 每找到一个匹配的文件, 都会再一次执行自定义的命令, 但是可以通过

```shell
find ~ -type f -name "*.bak" -exec ls -l '{}' +
```

的方式, 将所有匹配的文件形成一个列表统一执行后面的自定义命令, 关键在于将 ';' 改为 +

# stat 命令

> 是一款加大马力的 ls 命令版本, 可以查看属性所有信息。

# touch 命令

> 可以设置或更新文件的访问, 更新和修改时间。如果文件名是一个不存在的文件, 则会创建一个新文件。

# 选项

find 命令选项

| 选项 | 描述 |
| :--- | :--- |
| -depth | 指示find先处理文件夹中的文件, 在处理文件夹自身, 当指定 -delete 选项时, 会自动应用这个选项 |
| -maxdepth levels | 当执行测试条件和行为的时候，设置 find 程序陷入目录树的最大级别数 |
| -mindepth levels | 在应用测试条件和行为之前，设置 find 程序陷入目录数的最小级别数。 |
| -mount | 指示 find 程序不要搜索挂载到其它文件系统上的目录。 |
| -noleaf | 指示 find 程序不要基于自己在搜索 Unix 的文件系统的假设，来优化它的搜索。 在搜索DOS/Windows 文件系统和CD/ROMS的时候，我们需要这个选项 |


