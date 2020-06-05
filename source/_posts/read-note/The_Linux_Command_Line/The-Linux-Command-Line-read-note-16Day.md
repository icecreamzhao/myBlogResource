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

主要学习了如何使用gzip, bzip2, zip的使用方法, 如何使用tar创建系统归档文件。
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

| 选项 | 说明 |
| :--: | :--: |
| c | 为文件和/或目录列表创建归档文件 |
| x | 抽取归档文件 |
| r | 追加具体的路径到归档文件的末尾 |
| t | 列出归档文件的内容 |

```sh
# 使用 tar 将目录归档
tar cf dir.tar dir
# 列出归档文件的内容
tar tf dir.tar
# 复原tar
tar xf dir.tar
```

注意, 如果使用的是普通用户(没用超级用户权限)来对tar进行复原操作, 则复原的所有文件的权限都归当前操作用户所有!

```sh
# 单独抽取某个文件
tar xf dir.tar pathname
# 抽取匹配的文件
tar xf dir.tar --wildcards 'home/me/playground/dir-\*/file-A'
```

还可以使用find命令和tar配合使用:

```sh
# 含义: 将playground文件夹中符合条件的文件使用 -exec 命令来调用 tar 的追加模式, 将文件追加到已有的归档文件中
find playground -name 'file-A' -exec tar rf playground.tar '{}' '+'
# 含义: 将playground文件夹中符合条件的文件使用管道的方式制作压缩归档文件 (.tgz 或者 .tar.gz)
# - 代表从管道中读取
find playground -name 'file-A' | tar cf - --files-from=- | gzip > playground.tgz
# 上面命令的简化版 czf 代表用gzip方式压缩, cjf 代表用bzip2方式压缩
find playground -name 'file-A' | tar czf playground.tgz -T -
find playground -name 'file-A' | tar cjf playground.tbz -T -
```

还可以配合ssh工具将远端的系统(remote-stuff)中的文件夹复制到本地系统中:

```sh
[me@linuxbox ~]$ mkdir remote-stuff
[me@linuxbox ~]$ cd remote-stuff
[me@linuxbox remote-stuff]$ ssh remote-sys 'tar cf - Documents' | tar xf -
[me@linuxbox remote-stuff]$ ls
Documents
```

# zip

使用方式:

```sh
# 将目录打包为zip
zip -r dirPath.zip dirPath
# 列出指定zip文件
zip -l dirPath.zip dir1/dir2
# 使用管道
find playground -name "files-A" | zip -@ files-A.zip
```
