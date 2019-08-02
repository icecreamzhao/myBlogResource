---
title: UltraCompare 文件对比软件暴力破解
date: 2019-07-17 13:26:50
categories:
- 破解
tags:
- 破解
---

# Ultra 系列软件暴力破解

转载自[UltraEdit 注册机使用激活方法 更新：暴力破解](https://blog.csdn.net/CoderAldrich/article/details/79725475)

<!--more-->

* 下载[x64dbg](https://x64dbg.com/)

* 使用x64dbg打开ue.exe
![打开ue](/images/heck/1.png)

* 注意, 这里会有断点, 所以需要继续运行
![ProtectionPlusDLL.dll](/images/heck/2.png)
![ProtectionPlusDLL.dll](/images/heck/3.png)

* 切换到符号视图

![ProtectionPlusDLL.dll](/images/heck/4.png)

* 找到ProtectionPlusDLL.dll

![ProtectionPlusDLL.dll](/images/heck/5.png)

* 找到图中的几个函数

![ProtectionPlusDLL.dll](/images/heck/6.png)

* 点击进去之后, 修改第一行代码为ret

![ProtectionPlusDLL.dll](/images/heck/7.png)

* 保存并打补丁

![ProtectionPlusDLL.dll](/images/heck/8.png)
![ProtectionPlusDLL.dll](/images/heck/9.png)

最后将该文件替换原文件即可。
