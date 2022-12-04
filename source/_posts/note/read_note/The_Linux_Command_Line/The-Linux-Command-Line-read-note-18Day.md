---
title: 快乐的Linux命令行笔记-文本处理
categories:
- 笔记
- 读书笔记
- 快乐的Linux命令行
tags:
- 笔记
- 快乐的Linux命令行
- linux
date: 2020-06-03 23:52:13
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
[第十四天的笔记-网络](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-14Day.html)
[第十五天的笔记-查找文件](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-15Day.html)
[第十六天的笔记-压缩](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-16Day.html)
[第十六天的笔记-正则表达式](/note/read_note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-17Day.html)

# 总结

<!--more-->

* 一些文本处理程序

| 程序名 | 说明 |
| :----- | :--- |
| cat | 连接文件并且打印到标准输出 |
| sort | 给文本排序 |
| uniq | 报告或者省略重复行 |
| cut | 从每行中删除文本区域 |
| paste | 合并文件文本行 |
| join | 基于某个共享字段来联合两个文件的文本行 |
| comm | 逐行比较两个有序的文件 |
| diff | 逐行比较文件 |
| patch | 给原始文件打补丁 |
| tr | 翻译或删除字符 |
| sed | 用于筛选和转换文本的流编译器 |
| aspell | 交互式拼写检查器 |

# 关于换行符

Unix文本和MS-DOS文本的区别在于换行符的不同。
Unix文本使用ASCII 10作为换行符, MS-DOS使用ASCII 13和换行字符序列作为换行符。
可以使用 dos2unix 和 unix2dos 程序来转换两种格式的文本。

# 使用cat和sort处理文本

```sh
# foo.txt content:
# a b
# 
# 
# c
cat -ns foo.txt
#output:
# foo.txt content:
#1 a b
#
#3 c

# 使用sort对文本排序:
sort file1.txt file2.txt file3.txt > file4.txt
```

常见的sort程序选项:

| 选项 | 长选项 | 描述 |
| :--- | :----- | :--- |
| -b | --ignore-leading-blanks | 默认情况下, 对整体的进行排序, 从每行的第一个字符开始。这个选项导致sort程序忽略,每行开头的空格, 从第一个非空白字符开始排序 |
| -f | --igonre-case | 让排序不区分大小写 |
| -n | --numeric-sort | 基于字符串的数值来排序。使用此选项允许根据数字值执行排序, 而不是字母值 |
| -r | --reverse | 按相反顺序排序, 结果按照降序排列, 而不是升序 |
| -k | --key=field1[,field2] | 对从 field1 到 field2 之间的字符排序, 而不是整个文本行 |
| -m | --merge | 把每个参数看作是一个预先排好序的文件, 把多个文件合并成一个排好序的文件, 而没有执行额外的排序 |
| -o | --output=file | 把排好序的输出结果发送到文件, 而不是标准输出 |
| -t | --field-separator=char | 定义域分割字符, 默认情况下, 域由空格或制表符分割 |


| 
