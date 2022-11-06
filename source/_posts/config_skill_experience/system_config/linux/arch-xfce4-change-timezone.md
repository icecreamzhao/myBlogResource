---
title: archlinux使用xfce4如何更时区
date: 2022-11-06 11:59:09
categories:
- 配置技巧/经验
- 系统配置
- linux
tags:
- archlinux
- timezone
---

# 前言

今天闲来无事折腾一下尘封已久的树莓派, 系统是arch系统, 桌面使用xfce4。

# 更改方式

首先查看都有哪些时区:

```sh
timedatectl | grep local
```

接着根据所在时区更改:
```sh
timedatectl set-timezone Asia/Shanghai
```
