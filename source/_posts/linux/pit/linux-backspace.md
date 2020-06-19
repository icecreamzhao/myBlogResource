---
title: Linux关于backspace不好用的问题
date: 2019-06-02 15:36:16
categories:
- 运维
- centos
tags:
- centos
---

# 问题

当我在centos中使用vim编辑器时, 按下退格键(backspace)时, 并不能删掉字符。
<!--more-->

# 解决办法

将下面的设置写到`.vimrc`中:

```
set backspace=indent,eol,start
```

详情请看[这里](https://vi.stackexchange.com/questions/2162/why-doesnt-the-backspace-key-work-in-insert-mode)
