---
title: 快乐的Linux命令行笔记-第十五天
date: 2019-02-21 15:29:04
categories:
- 读书笔记
- 快乐的Linux命令行
tags:
- 笔记
- 快乐的Linux命令行
- linux
---

# 总结
<!--more-->

# 查找文件

## locate

> 该程序会执行一次快速的路径名数据库搜索, 并输出每个与给定子字符串相匹配的路径名。

```shell
# 假定包含程序的目录以bin/结尾, 查找所有zip开头的文件
locate bin/zip
# 使用grep命令设计更加复杂的搜索
locate zip | grep bin
```

locate的数据库由updatedb创建, 这个程序作为一个定时任务周期性运转。可以使用超级用户权限来手动运行updatedb命令来更新数据库。

## find


