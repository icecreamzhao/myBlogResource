---
title: 快乐的Linux命令行笔记-自定义shell提示符
date: 2019-02-14 21:49:02
categories:
- 读书笔记
- 快乐的Linux命令行
tags:
- 笔记
- linux
- 快乐的Linux命令行
---

[第一天的笔记-基本的命令和使用方法](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-1Day.html)
[第二天的笔记-操作文件](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-2Day.html)
[第三天的笔记-查阅命令文档并创建命令别名](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-3Day.html)
[第四天的笔记-重定向标准输入和输出以及处理查询结果](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-4Day.html)
[第五天的笔记-命令的展开](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-5Day.html)
[第六天的笔记-快捷键](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-6Day.html)
[第七天的笔记-文件权限](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-7Day.html)
[第八天的笔记-进程](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-8Day.html)
[第九天的笔记-修改shell环境](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-9Day.html)
[第十天的笔记-vim入门](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-10Day.html)

# 总结

今天学习了关于如何自定义shell提示符, 包括修改文本, 修改文本颜色, 修改背景颜色甚至是移动光标。
<!--more-->

# 自定制shell提示符

可以自定义linux命令行的提示符(就是每行命令的开始部分)。shell的提示符是由环境变量`PS1`来决定显示哪些内容的, 可以通过

```shell
echo PS1
```
来查看当前提示符中都包含哪些内容, 通过转义字符来显示。

> 提示符中用到的转义字符

| 序列 | 显示值 |
| :--- | :----- |
| \a | 以ASCII码格式编码的铃声, 当遇到这个转义序列时, 计算机会发出蜂鸣声 |
| \d | 以日, 月, 天格式来表示当前日期, 例如: "Mon May 26" |
| \h | 本地的主机名, 但不带末尾的域名 |
| \H | 完整的主机名 |
| \j | 运行在当前shell会话的工作数 |
| \l | 当前终端设备名 |
| \n | 一个换行符 |
| \r | 回车符 |
| \s | shell程序名 |
| \t | 24小时制, hh:mm:ss 的格式表示当前时间 |
| \T | 以12小时制表示当前时间 |
| \@ | 以12小时制, am/pm表示当前时间 |
| \u | 当前用户名 |
| \v | shell的version号 |
| \V | shell的version, release号 |
| \w | 当前工作目录名 |
| \W | 当前工作目录名的最后部分 |
| \! | 当前命令的最大历史行号 |
| \# | 当前shell会话中已经执行的命令数量 |
| \$ | 如果拥有超级用户权限, 则会显示一个"$"符, 不然会显示一个"#" |
| \[ | 标志着一系列非打印字符的开始, 这被用来以某种方式来操作终端仿真器, 比如说移动光标或者更改颜色 |
| \] | 标志非打印字符的结束 |

可以通过改变`PS1`的值来改变提示符:

```shell
PS1="\a"
```

上面的语句可以将提示符改成蜂鸣声, 每次执行完一个语句计算机会发出声响。

# 使用转义字符来设置文本颜色

| 序列 | 文本颜色 |
| :--- | :------- |
| \033[0;30m | 黑色 |
| \033[0;31m | 红色 |
| \033[0;32m | 绿色 |
| \033[0;33m | 棕色 |
| \033[0;34m | 蓝色 |
| \033[0;35m | 粉红 |
| \033[0;36m | 青色 |
| \033[0;37m | 浅灰色 |
| \033[1;30m | 深灰色 |
| \033[1;31m | 浅红色 |
| \033[1;32m | 浅绿色 |
| \033[1;33m | 黄色 |
| \033[1;34m | 浅蓝色 |
| \033[1;35m | 浅粉色 |
| \033[1;36m | 浅青色 |
| \033[1;37m | 白色 |

> 修改提示符为黄色

```shell
PS1="\[\033[1;33m\]\u@\h \W\$\[033[1;37m\]
```

上面的命令还会将`$`符后面的字符y的颜色变成白色。

# 修改背景颜色

| 序列 | 文本颜色 |
| :--- | :------- |
| \033[0;40m | 蓝色 |
| \033[1;44m | 黑色 |
| \033[0;41m | 红色 |
| \033[1;45m | 紫色 |
| \033[0;42m | 绿色 |
| \033[1;46m | 青色 |
| \033[0;43m | 棕色 |
| \033[1;47m | 浅灰色 |

> 将背景颜色修改为红色

```shell
PS1="\[\033[0;41m\]\u@\h \W\$\[\033[1;37m\]"
```
# 移动光标

| 序列 | 行动 |
| :-- | :---- |
| \033[l;cH | 把光标移到第一行, 第c列 |
| \033[nA | 把光标向上移动n行 |
| \033[nB | 把光标向下移动n行 |
| \033[nC | 把光标向前移动n个字符 |
| \033[nD | 把光标向后移动n个字符 |
| \033[2J | 清空屏幕, 把光标移到左上角(第零行, 第零列) |
| \033[K | 清空从光标位置到行末的内容 |
| \033[s | 存储当前光标位置 |
| \033[u | 唤醒之前存储的光标位置 |
