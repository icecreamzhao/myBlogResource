---
title: 安装解压版mysql
date: 2019-01-10 21:29:32
categories:
- 基础知识
- 软件安装
tags:
- 软件安装
---

# 前言

安装这些工具所需要的知识对于开发人员来说应该是必会的, 但是谁也不是没事总是去装这些工具, 时间长了可能就会忘记, 所以借此写篇博客来记录这些。

<!--more-->

# 下载

* 首先去[mysql的官网]("https://dev.mysql.com"), 点击downloads

![mysql的下载页面](/images/software-setup/mysql/mysql-setup1.jpg)

* 接下来翻到最下面, 点击这个

![mysql的下载页面](/images/software-setup/mysql/mysql-setup2.jpg)

* 接着

![mysql的下载页面](/images/software-setup/mysql/mysql-setup3.jpg)

* 然后我们就来到了下载页面

![mysql的下载页面](/images/software-setup/mysql/mysql-setup4.jpg)

我们可以看到有解压版和安装版, 安装版就不用多说了, 你只需要按部就班的选择你需要的配置就可以了, 安装程序会替你把一切都做好, 今天我们的重点是解压版的mysql。

# 配置

1. 下载好之后选择一个位置解压
2. 配置环境变量<br>这里我们新建一个环境变量<br>![mysql的环境变量](/images/software-setup/mysql/mysql-setup5.jpg)<br>之后像这样把它放到环境变量中去<br>![mysql的环境变量](/images/software-setup/mysql/mysql-setup6.jpg)
3. 编写mysql配置文件`my.ini`<br>注意这里一定是斜杠, 不能是反斜杠

```ini
[mysqld] 

basedir=C:/Program Files/MySQL/MySQL Server 5.6（mysql所在目录） 

datadir=C:/Program Files/MySQL/MySQL Server 5.6/data （mysql所在目录\data）
```

4. 安装mysql服务<br>![mysql服务](/images/software-setup/mysql/mysql-setup7.jpg)
> 这里我遇到了两个问题:
* 在安装mysql时提示: 找不到 msvcp140.dll

这里并不是下载一个这个dll, 用cmd注册一下就可以, 接着会提示注册失败。真正的原因是电脑没有安装vc++ 2015版, 到[这里](https://www.microsoft.com/en-us/download/details.aspx?id=53587)下载一个安装之后就可以了。

* 在启动服务时, 看到了data文件夹下的日志提示: Failed to find valid data directory。解决办法是先删掉data文件夹, 然后:

```
cd bin
mysqld --initialize-insecure --console
mysqld --install
```

就可以了。
这里会显示mysql的初始化密码。
使用:

```
alter USER 'root'@'localhost' IDENTIFIED BY '新密码';
```
就可以修改默认密码了。

5. 初始化并启动服务<br>![初始化并启动服务](/images/software-setup/mysql/mysql-setup8.jpg)
