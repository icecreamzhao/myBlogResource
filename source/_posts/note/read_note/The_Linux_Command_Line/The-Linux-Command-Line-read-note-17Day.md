---
title: 快乐的Linux命令行笔记-正则表达式
categories:
- 笔记
- 读书笔记
- 快乐的Linux命令行
tags:
- 笔记
- 快乐的Linux命令行
- linux
date: 2020-05-31 19:41:08
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
[第十五天的笔记-查找文件](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-15Day.html)
[第十六天的笔记-压缩](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-16Day.html)

# 总结

本次主要学习了如何在各种命令中使用正则表达式来匹配, 其他的命令如find, 可以使用 -regex, locate 可以使用 --regex
<!--more-->

## grep中使用正则

grep选项

| 选项 | 描述 |
| :---: | :-- |
| -i | 忽略大小写, 不会区分大小写字符, 也可用 --ignore-case 指定 |
| -v | 不匹配, 通常 grep 程序会打印包含匹配项的文本行。这个选项导致 grep 只打印不包含匹配项的文本行, 也可用 --invert-match 指定 |
| -c | 打印匹配数量(或是不匹配数目, 若指定了-v选项), 而不是文本行本身, 也可用 --count 选项来指定 |
| -l | 打印包含匹配项的文件名, 而不是文本行本身, 也可用 --files-with-matched 选项来指定 |
| -L | 和-l相反, z打印不匹配的文件名, 也可用 --files-without-match 来指定 |
| -n | 在每个匹配行之前打印出其位于文件中的相应行号。也可用 --line-number 选项指定 |
| -h | 应用于多文件搜索, 不输出文件名, 也可用 --no-filename 选项指定 |

使用grep检索文本文档中的内容:

```sh
# 检索出匹配的文件中包含bzip字样的文本行
grep bzip dirlist*.txt
# 检索出匹配的文件中包含bzip字样的文件
grep bzip -l dirlist*.txt
```

## POSIX 字符集

| 字符集 | 说明 |
| :---- | :---- |
| [:alnum:] | 字母数字字符。在ASCII中, 等价于: [a-zA-Z0-9] |
| [:word:] | 与 [:alnum:] 相同, 但是增加了下划线字符 |
| [:alpha:] | 字母字符, 在ASCII中等价于 [a-zA-Z] |
| [:blank:] | 包含空格和tab字符 |
| [:cntrl:] | ASCII的控制码, 包含了 0-31, 和 127 的ASCII字符 |
| [:digit:] | 数字0-9 |
| [:graph:] | 可视字符, 在 ASCII 中包含33到126的字符 |
| [:lower:] | 小写字母 |
| [:punct:] | 标点符号字符, 在ASCII中等价于 [-!"#$%&'()*+,./:;<=>?@[  \]_\`{|}~] |
| [:print:] | 可打印字符, 包含 [:graph:] 中的所有字符, 再加上空格字符 |
| [:space:] | 空白字符, 包括空格, tab, 回车, 换行, vertical tab 和 form feed, 在 ASCII 中, 等价于: [\t\r\n\v\f] |
| [:upper:] | 大写字母 |
| [:xdigit:] | 用来表时十六进制数字的字符, 在ASCII中, 等价于: [0-9A-Fa-f] |

使用 `locale` 命令查看所有排序规则, 并通过 `export LANG=POSIX` 命令来更改当前的系统排序规则。

## POSIX基本正则表达式与POSIX扩展正则表达式

基本正则表达式(BRE) 扩展正则表达式(ERE)

BRE可以辨别以下元字符:

```
^ $ . [ ] *
```

ERE 比 BRE 多了以下元字符:

```
( ) { } ? + |
```

然而在 BRE 中, 字符 `(` `)` `{` `}` 用反斜杠转义后, 被看作是元字符, 相反在ERE中, 任意元字符之前加上反斜杠都会被看作是文本字符。
