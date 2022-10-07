---
title: mysql创建数据库时遇到的字符集的问题
date: 2019-07-14 19:14:36
categories:
- 配置技巧/经验
- 开发工具配置
- mysql
tags:
- mysql
- 踩坑
---

# mysql 查看字符集

```
show variables like '%char%'
```

这里要全都是`utf-8`。

如果不是的话, 则修改`my.ini`。

修改方式:

```
[mysqld]
character-set-server=utf8

[client]
default-character-set=utf8

[mysql]
no-auto-rehash
```
<!--more-->

# mysql 创建数据库时指定字符集

```
CREATE DATABASE db_name DEFAULT CHARACTER SET UTF8 COLLATE UTF8_GENERAL_CI
```

# 更改数据库的字符编码

```
ALTER DATABASE db_name DEFAULT CHARACTER SET utf8 COLLATE UTF8_GENERAL_CI
```
