---
title: 快乐的Linux命令行笔记-压缩 
date: 2019-03-18 17:01:35
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
[第十五天的笔记-查找文件](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-15Day.html)

# 总结
<!--more-->

# 压缩文件

压缩的算法基本遵循一个原则, 就是避免冗余数据。

比如一张纯黑色的100x100像素的图片, 每一个像素都会占用存储空间, 那么我们不必存储每一个像素, 而是用另一种方式表示这张图片, 比如这张图片有三万个黑色像素点, 那么直接存储数字30000, 后跟一个0(表示黑色像素)来表示这张图, 这种数据压缩方案被称为游程编码。

# gzip

```shell
# 使用gzip压缩
gzip test.txt
# 使用gunzip解压缩
gunzip test.txt.gz
```

gzip 选项

| 选项 | 说明 |
| :--- | :--- |
| -c | 把输出写到标准输出, 并保留原始文件, 也可以用 --stdout 和 --tostdout 选项来指定。 |
| -d | 解压缩, 和gunzip命令一样, 也可以用 --decompress 或者 --uncompress 选项来指定。 |
| -f | 强制压缩, 即使原压缩文件存在也要强制执行, 也可用 --force 选项来指定。 |
| -h | 显示用法信息, 也可用 --help 选项来指定。 |
| -l | 列出每个被压缩文件的压缩数据, 也可用 --list 选项来指定。 |
| -r | 若命令的一个或多个参数是目录, 则递归的压缩目录中的文件, 也可用 --recursive 来指定。 |
| -t | 测试压缩文件的完整性, 也可用 --test 选项来指定。 |
| -v | 显示压缩过程中的信息, 也可用 --verbose 选项来指定。 |
| -number | 指定压缩指数, number是一个在1-9之间的整数, 默认值是整数6。 |

zcat 命令

> 等同于`gzip -c`命令

zless 命令

> 等同于`gzip *.gz | less` 命令

# bzip2

舍弃了压缩速度, 实现了更高的压缩级别。由bzip2压缩的文件, 使用后缀名`.bz2`来表示。

工作模式和gzip相同(除了-r选项), 相对应的, 也有`bunzip`和`bzcat`命令来进行解压缩, 还有`bzip2recover`来对受损的文件进行修复。

# 归档文件

归档经常作为系统备份的一部分来使用, 归档就是把很多文件捆绑成一个大文件的过程。

