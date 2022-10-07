---
title: 快乐的Linux命令行笔记-vim入门
date: 2019-02-08 22:15:25
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
[第三天的笔记-查阅命令文档并创建命令别名](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-3Day.html)
[第四天的笔记-重定向标准输入和输出以及处理查询结果](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-4Day.html)
[第五天的笔记-命令的展开](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-5Day.html)
[第六天的笔记-快捷键](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-6Day.html)
[第七天的笔记-文件权限](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-7Day.html)
[第八天的笔记-进程](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-8Day.html)
[第九天的笔记-修改shell环境](/read-note/The_Linux_Command_Line/The-Linux-Command-Line-read-note-9Day.html)

# 总结

今天主要学习了vim的一些快捷操作。
<!--more-->
# vim

vim编译器的一些快捷键

| 快捷键 | 意义 |
| :--- | :---- |
|:q | 退出 |
| :q! | 强制退出 |
| :i | 进入输入模式 |
| : w | 保存 |

<br/>

## 在非编辑模式下的快捷键

| 快捷键 | 意义 |
| :---- | :--- |
| l / 右箭头 | 向右移动一格 |
| h / 左箭头 | 向左移动一格 |
| j / 上箭头 | 向上移动一格 |
| k / 下箭头 | 向下移动一格 |
| 0 (零) | 移动到行首 |
| ^ | 移动到当前行的第一个非空字符|
| $ | 移动到当前行的末尾 |
| w | 移动到下一个单词或标点符号的开头 |
| W | 移动到下一个单词的开头, 忽略标点符号 |
| b | 移动到上一个单词或标点符号的开头 |
| B | 移动到上一个单词的开头, 忽略标点符号 |
| ctrl - f / pagedown | 向下翻一页 |
| ctrl -b / pageup | 向上翻一页 |
| numberG | 移动到指定行, 例如: 2G : 移动到第二行
| G | 移动到文件末尾 |

> 不是只有`G`命令支持前面加数字, `5j` 会将光标向下移动5行

<br/>

## 进入编辑模式的一些快捷键

| 快捷键 | 意义 |
| :---- | :--- |
| a | 光标向后一格进入编辑模式 |
| A | 在行尾进入编辑模式 |
| o | 在当前行的下一行进入编辑模式 |
| O | 在当前行的下一行进入编辑模式 |
| u | 撤销更改 |

<br/>

## 删除文本的一些快捷键

| 快捷键 | 意义 |
| :---- | :--- |
| x | 当前字符 |
| 3x | 当前字符以及后面两个字符 |
| dd | 剪切当前行 |
| 5dd | 剪切从当前行以及随后的四行文本 |
| dW | 剪切从光标开始到下一个单词的开头 |
| d$ | 剪切从光标开始到当前行的结尾 |
| d0 | 剪切从光标开始到当前行的行首 |
| d^ | 剪切从光标开始到当前行的第一个非空字符 |
| dG | 剪切从当前行到文件的末尾 |
| d20G | 剪切从当前行到文件的第20行 |

<br/>

## 剪切, 复制和粘贴

| 命令 | 意义 |
| :---- | :--- |
| yy | 复制当前行 |
| 5yy | 复制当前行以及随后的4行文本 |
| yW | 复制从当前光标位置到下一个单词的开头 |
| y$ | 复制从当前光标位置到当前行的末尾 |
| y0(零) | 复制从当前光标到当前行首 |
| y^ | 复制从当前光标位置到文本行的第一个非空字符 |
| yG | 复制从当前光标位置到文件末尾 |
| y20G | 从当前行到文件的20行 |
| p | 粘贴到当前光标位置 |
| P | 粘贴到当前行之上 |

<br/>

## 连接行于行

`J` 连接当前行和下一行为一行

<br/>

## 查找和替换

> 在当前行中进行查找

`fsearch key` 例如: `fa` 会搜索当前行从光标位置开始的字母a

> 查找整个文件

输入 `/` , 接着输入要查找的字符并按下回车, 使用 `n` 命令来查找下一个匹配的字符


```shell
:%s/The/the/g
```
* %s 代表需要操作的范围是从第一行到最后一行, 如果是第m行到第n行则可以这样: m,n
* /The 代表需要被替换的字符
* /the 代表替换的字符
* /g 代表全局搜索

```shell
:%s/the/The/gc
```

该命令和上面意义一样, 只是每次替换之前, 都会先进行确认, 确认的方式包括:

| 按键 | 行为 |
| :---- | :--- |
| y | 执行替换操作 |
| n | 跳过这个匹配的实例 |
| a | 对当前及所有以后匹配的字符串都进行匹配操作 |
| q / esc | 退出替换操作 |
| l | 执行这次替换并退出 |
| ctrl-e, ctrl-y | 向上滚动, 向下滚动, 查看当前匹配字符的上下文 |

<br/>

## 同时编辑多个文件

```shell
vim file1.txt file2.txt ...
```

* `:n` 切换到下一个文件
* `:N` 切换到上一个文件

<br/>

**如果当前文件修改后没有保存, 则不能切换, 可以先保存, 再切换, 也可以直接 `!n` 强制切换, 不保存**


```shell
:buffers
```

显示所有编辑的文件列表, 也可以直接切换第n个文件: `:buffer n`

<br/>

## 在vim编辑器中打开另一个文件

```shell
:e file2.txt
```

如果使用 `:e` 命令打开的文件, 则不能使用 `:n` 和 `:N` 来切换文件, 只能通过 `:buffer` 命令来切换

<br/>

## 将指定文件插入到另一个文件中

在已经使用vim打开一个文件中的情况下:

```shell
:r file2.txt
```

将file2.txt的所有内容插入到光标所在位置。

<br/>

## 保存文件

`ZZ` 注意是大写, 会保存并退出当前文件

```shell
:w other.txt
```

将当前文件保存为other.txt文件, 但是编辑则还是编辑当前文件。
