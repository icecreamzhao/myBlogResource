---
title: 快乐的Linux命令行笔记-第五天
date: 2018-12-13 21:09:59
categories:
- 读书笔记
- 快乐的Linux命令行
tags:
- 快乐的Linux命令行
---

[第一天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-1Day.html)<br>[第二天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-2Day.html)<br>[第三天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-3Day.html)<br>[第四天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-4Day.html)

# 总结

<!--more-->

### 打印



#### 打印匹配通配符的路径

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



#### 算术通配符展开

```shell
$ echo $((2 + 2))
```

只支持整数, 支持嵌套



#### 花括号展开

```shell
$ echo Front-{a,b,c}-Back
```

output:

```shell
Front-a-Back Front-b-Back Front-c-Back
```

小技巧, 可以按照某种顺序来创建文件夹:

```shell
$ mkdir {2007...2009}-0{1...9}-{10-12}
```

上面的例子是按照"年-月"的形式来创建文件夹



#### 参数展开

```shell
$ echo $USER
```

会将当前用户名展示出来

