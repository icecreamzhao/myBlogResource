---
title: java在linux系统上创建目录遇到的问题
date: 2019-05-16 23:36:00
categories:
- 后端技巧/经验
- java
tags:
- java
---

# 问题

如何在linux系统中创建多级目录, 比如`/home/usr/programTools/test.sh`?

<!--more-->

# 解决办法

使用`mkdirs()`方法。

例:

```java
File dir = new File("/home/usr/programTools/test.sh");

if (!dir.exists()) {
    dir.mkdirs();
}
```
