---
title: 快乐的Linux命令行笔记-第五天
date: 2018-12-13 21:09:59
categories:
- 读书笔记
- 快乐的Linux命令行
tags:
- 笔记
- 快乐的Linux命令行
- linux
---

[第一天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-1Day.html)<br>[第二天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-2Day.html)<br>[第三天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-3Day.html)<br>[第四天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-4Day.html)<br>

# 总结

今天主要学习了展开和引用, 明白了如何使用展开来更有效率的使用shell

<!--more-->

<br>

# 打印

## 打印匹配通配符的路径

```shell
$ echo this is a test
```

output:

```shell
this is a test
```

该命令可以匹配通配符, 像这样:

```shell
$ echo *
```

会将当前目录下的文件名字打印出来, 类似的, 还有这样:

```shell
$ echo D*
$ echo [[:Upper:]]*
$ echo *s
$ echo /usr/*/share
```

output:

```
Desktop Documents ...
Desktop Documents Music Pictures ...
Documents Pictures ...
/usr/kerberos/share /usr/local/share ...
```

所有的输出都符合通配符

<br>

## 算术通配符展开

```shell
$ echo $((2 + 2))
```

只支持整数, 支持嵌套

<br>

## 花括号展开

```shell
$ echo Front-{a,b,c}-Back
```

output:

```shell
Front-a-Back Front-b-Back Front-c-Back
```

小技巧, 可以按照某种顺序来创建文件夹:

```shell
$ mkdir {2007..2009}-0{1..9} {2007..2009}{10..12}
```

上面的例子是按照"年-月"的形式来创建文件夹

<br>

## 参数展开

```shell
$ echo $USER
```

会将当前用户名展示出来

```shell
$ printenv | less
```

将有效的变量列表展示出来

<br>

## 命令替换

含义是将表达式中的命令的输出结果作为一个参数传递给另一个命令

```shell
$ echo $(ls)
```

将`ls`命令的输出结果使用echo打印出来

```shell
$ ls -l $(which cp)
```

> 提示: `which`命令是用来查看命令所在文件路径, [这篇有写](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-3Day.html)

```
output: -rwxr-xr-x 1 root root 71516 2007-12-05 08:58 /bin/cp
```

旧版`shell`程序中的命令替换的语法:

```shell
$ ls -l `which cp`
```

<br>

## 双引号

如果一个文件的文件名中间包含空格, 那么可以使用`""`来阻止单词分割机制

在双引号中, 参数展开, 算术表达式展开和命令替换仍然有效。

<br>

## 单引号

禁止所有的展开

<br>

## 转义字符

在字符前加一个反斜杠