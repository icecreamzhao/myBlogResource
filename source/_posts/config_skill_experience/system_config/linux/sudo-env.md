---
title: sudo命令环境变量问题
date: 2020-06-19 02:58:19
categories:
- 配置技巧/经验
- 系统配置
- linux
tags:
- linux
---

# sudo 的环境变量

首先查看sudo的环境变量:

```sh
sudo env | grep path
```

可以看到环境变量和我们的root用户和当前用户的环境变量都不一样, 这是因为 /etc/sudoers 这个文件中有这样一句:

```sh
Defaults env_reset
```

只要在 env_reset 前面加上一个 `!` 就可以了。

之后在 .bashrc 文件中加入:

```sh
alias sudo='sudo env PATH=$PATH'
```
