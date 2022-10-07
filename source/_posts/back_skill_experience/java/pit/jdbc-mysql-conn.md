---
title: jdbc连接MySql8.0 报Client does not support authentication protocol requested by server
date: 2019-07-02 11:59:00
categories:
- 后端技巧/经验
- java
tags:
- jdbc
- mysql
---

# 前言

使用jdbc连接mysql的时候报`Client does not support authentication protocol requested by server`。

# 解决

使用MySQL命令行, 键入如下命令:

```
use mysql;

alter user 'root'@'localhost' identified with mysql_native_password by '********';

flush privileges;
```

就可以了。
