---
title: 快乐的Linux命令行笔记-快捷键
date: 2019-01-30 00:55:15
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

# 总结

今天学习了关于命令行中的一些快捷键的操作以及使用历史命令来减少敲击键盘的次数。
<!--more-->
# 移动光标

bash使用的是一个名为Readline的库, 在命令行编辑的时候可以使用一些快捷键来进行移动光标。

| 按键 | 功能 |
| -----: | :----- |
| ctrl-a | 移动光标到行首 |
| ctrl-e | 移动光标到行尾 |
| ctrl-f | 光标前移一个字符 |
| ctrl-b | 光标后移一个字符 |
| alt-f | 光标前移一个字 |
| alt-b | 光标后移一个字 |
| ctrl-l | 清空屏幕 |

# 修改文本

在命令行中修改文本

| 按键 | 功能 |
| ---: | :--- |
| ctrl-d | 删除光标位置的字符 |
| ctrl-t | 光标位置的字符和前面的字符换位置 |
| alt-t | 光标位置的字和前面的字换位置 |
| alt-l | 把从光标位置到字尾的字母变成小写 |
| alt-u | 把从贯标位置到字尾的字母变成大写 |

# 剪切/粘贴文本

剪切/粘贴文本的一些快捷键:

| 按键 | 功能 |
| ----: | :---- |
| ctrl-k | 剪切从光标到行尾的文本 |
| ctrl-u | 剪切从光标到行首的文本 |
| alt-d | 剪切从光标到词尾的文本 |
| alt-backspace | 剪切从光标到词头的文本, 如果光标在词头, 剪切前一个词 |
| ctrl-y | 将剪切板中的文本粘贴到光标位置 |

 # 自动补全

自动补全的快捷键:

| 按键 | 功能 |
| ---: | :-- |
| alt-? | 相当于按两下tab, 显示所有可能匹配的列表 |
| alt-* | 插入所有自动补全 |

# 历史命令

使用以下命令来查看最后执行的500条命令:

```shell
history | less
```

使用以下命令来过滤历史命令:

```shell
history | grep /usr/bin
```

显示的命令会将包含`/usr/bin`的命令显示出来, 包含她的行号。
然后可以根据行号来执行该条命令:

```shell
!88
```

该命令执行了第八十八行命令。

## 增量搜索历史命令

1. `ctrl-r` 开启增量搜索模式
2. 接着输入需要搜索的字
3. 按 `Enter` 直接执行搜索到的命令, 或者按 `ctrl-j` 复制到命令行中

搜索历史命令的快捷键:

| 按键 | 功能 |
| --: | :-- |
| ctrl-p | 移动到上一个历史条目, 类似于上箭头按键 |
| ctrl-n | 移动到下一个历史条目, 类似于下箭头按键 |
| alt-< | 移动到历史列表的开头 |
| alt-> | 移动到历史列表的结尾, 即当前命令行 |
| ctrl-r | 反向增量搜索 |
| alt-p | 反向搜索(非增量搜索, 输入搜索的字符串, 按Enter来执行搜索) |
| alt-n | 向前搜索(非增量) |
| ctrl-o | 执行历史列表中的当前项, 并移到下一个 |

历史命令的展开:

| 按键 | 功能 |
| --: | :-- |
| !! | 重复最后一次执行的命令 |
| !number | 执行历史列表中第number行的命令 |
| !string | 执行历史列表中以string开头的命令 |
| !?string | 执行历史列表中包含string的命令 |

# 记录整个shell会话的命令

使用以下命令来存储本次shell中执行的所有命令:

```shell
script [file]
```
