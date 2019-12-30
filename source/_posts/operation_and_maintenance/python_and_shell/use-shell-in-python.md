---
title: 在 python 中使用 bash
date: 2019-10-31 03:24:15
categories:
- 运维
- linux
- python
tags:
- python
---

# 查看系统信息 

```py
import subprocess
uname = "uname"
uname_args = "-a"
subprocess.call([uname, uname_args])
```

output:

> Linux raspberrypi 4.19.57-v7l+ #1244 SMP Thu Jul 4 18:48:07 BST 2019 armv7l GNU/Linux

