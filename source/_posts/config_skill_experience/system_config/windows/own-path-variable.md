---
title: 在windows系统中自定义cmd命令
date: 2019-01-19 12:00:12
categories:
- 配置技巧/经验
- 系统配置
- windows
tags:
- windows
---

# 前言

我在运行一些服务或者程序时, 经常免不了要打开cmd, cd到程序所在目录, 然后执行运行的命令, 次数多了之后就觉得很烦, 想着可不可以自定义命令, 比如我直接输入`zkstart`, 就可以运行zookeeper, 当然是可以的!

<!--more-->

# 定义环境变量

在windows系统中, 环境变量其实还是一个挺方便的玩应, 你可以将你所有常用的目录都定义到环境变量中, 这样系统就可以直接根据你的环境变量名称找到相对应的路径。

步骤如下:
右键我的电脑, 属性

![环境变量](/images/system-tap/own-path-variable/own-path-variable1.jpg)

接着就可以创建环境变量了

![环境变量](/images/system-tap/own-path-variable/own-path-variable2.jpg)

``具体有什么用呢?``
比如我创建了一个tomcat目录的环境变量, 变量名为`tPath`, 那么我在cmd中想快速进入到tomcat的目录, 就可以这样:

```cmd
C:\> cd %tPath%
```
这样就可以直接cd到该目录下了。

<br>

# 自定义命令

之前说了可以根据环境变量自定义命令, 那么具体该怎么做呢?
首先我们需要先了解一个环境变量: `PATHEXT`, 这个是已经定义好的变量, 这个变量值定义了可运行命令的后缀名, 也就是说如果你想要运行一个命令, 那么必须是以这个变量里定义的后缀名结尾的。

当然, 我们可以自己修改这个变量值, 让系统变得聪明一点。我就在我的环境变量中加入了`.LNK`, 这个是快捷方式的后缀名, 这样系统就可以识别了。

举个例子:

将`zookeeper/bin`的目录放到环境变量中, 像这样:

![环境变量](/images/system-tap/own-path-variable/own-path-variable3.jpg)

将变量名放到`path`中:

![环境变量](/images/system-tap/own-path-variable/own-path-variable4.jpg)

在zookeeper的bin目录下创建一个快捷方式:

![环境变量](/images/system-tap/own-path-variable/own-path-variable5.jpg)

大功告成!
直接在cmd中输入`zkpr`就可以直接启动zookeeper啦!

![环境变量](/images/system-tap/own-path-variable/own-path-variable6.jpg)
