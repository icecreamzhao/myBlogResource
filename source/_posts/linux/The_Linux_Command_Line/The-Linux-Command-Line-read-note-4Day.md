---
title: 快乐的Linux命令行笔记-第四天
date: 2018-12-02 11:43:17
categories:
- 读书笔记
- 快乐的Linux命令行
tags:
- 笔记
- 快乐的Linux命令行
- linux
---

[第一天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-1Day.html)<br>[第二天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-2Day.html)<br>[第三天的笔记](/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-3Day.html)<br>

# 总结

今天学习了如何将标准输入和标准输出的概念, 并如何重定向到文件中, 以及一些处理结果的技巧, 比如排序, 去重等等。

<!--more-->

<br>

# IO重定向

## 将命令的标准输出/标准错误重定向到文件

> 将ls命令的输出重定向到指定文件

```shell
$ ls -l /usr/bin > ls-output.txt # 重定向标准输出到指定文件(该文件会被重写)
$ ls -l /usr/bin >> ls-output.txt # 重定向标准输出到指定文件(将输出添加至文件内容之后)
```

注意:

1. 只指定了标准输出, 如果在执行命令时出现错误, 则会将标准错误输出到屏幕, 而不是文件

2. 每次重定向输出到文件时, 文件都会被重写, 而如果命令出错, 则该文件会变为空

   ```shell
   小技巧(清空一个文件): $ > 需要被清空的文件.txt
   ```

3. 重定向标准错误到指定文件 

   ```shell
   $ ls -l /bin/usr 2> ls-error.txt # 0 输入 1 输出 2 错误
   ```

   <br>


## 将命令的标准输出和错误重定向到指定文件

两种方式

1. 对于旧版本shell也有效

   ```shell
   $ ls -l /bin/usr > ls-output.txt 2>&1
   ```

2. 新版本的方式

   ```shell
   ls -l /bin/usr &> ls-output.txt
   ```

<br>

## 处理不需要的输出

```shell
ls -l /bin/usr 2> /dev/null
```

这样就可以不显示输出, 也不用创建一个文件来存储输出。

<br>

## 标准输入重定向

```shell
cat [file] # file是需要读取的文件, cat命令会将该文件中的内容读取到屏幕上
```

<br>

### 连接文件

```shell
$ cat [file1] [file2] > [allFile] # 会将file1和file2的文件内容全部放到allFile中
```

#### 创建一个文件并输入文件内容

```shell
$ cat > test.txt # 将标准输入重定向到指定文件
text something... # 输入一些内容, ctrl-d结束
less test.txt # 查看文件内容
```

<br>

### 管道线

```shell
$ ls -l /usr/bin | less
```

> 使用`|` 符号将一个命令的标准输入输送到另一个命令的标准输出, less命令接受任何命令的标准输入, 如上一例就是将ls命令的运行结果输送到标准输出

<br>

#### 过滤器

##### 排序

```shell
$ ls -l /usr/bin | sort | less
```

> 使用sort过滤器将运行结果排序并输送到标准输出中。

##### 去重

```shell
$ ls -l /usr/bin /bin | uniq | sort | less # 会确保bin目录和/usr/bin目录不包含重复的句子
$ ls -l /usr/bin /bin | uniq -d | sort | less # 会将bin目录和/usr/bin目录下重复的文件列出来
```

##### 打印文件字节数

```shell
$ wc [file] # 结果是三个字段, 分别是行数, 单词数和字节数
```

> wc命令

| 选项                   | 说明          |
| -------------------- | ----------- |
| -c --btyes           | 只打印字节数      |
| -m --chars           | 只打印字数       |
| -l --lines           | 只打印行数       |
| --files0-from=F      | ???         |
| -L --max-line-length | 只打印最长的一行的宽度 |
| -w --words           | 打印单词数       |

##### 打印匹配行

```shell
$ ls -l /usr/bin | grep zip | uniq # 打印带有zip字样的文件
```

> grep命令

| 选项   | 说明       |
| ---- | -------- |
| -i   | 忽略大小写    |
| -v   | 只打印不匹配的行 |

##### 打印文件开头部分/结尾部分

```shell
$ head -n output.txt # 打印文件前五行
$ tail -n output.txt # 打印文件最后五行
```

> tail命令有一个选项支持实时浏览文件, 如果是log文件, 新写入的内容会立即出现在屏幕上

```shell
$ tail -f /var/log/messages
```

##### 从标准输入到标准输出

```shell
ls -l /usr/bin | sort | tee ls.txt | uniq  | grep zip
```

将结果输出到ls.txt中