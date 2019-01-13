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

<br>

![mysql的下载页面](/images/software-setup/mysql/mysql-setup1.jpg)

<br>

* 接下来翻到最下面, 点击这个

<br>

![mysql的下载页面](/images/software-setup/mysql/mysql-setup2.jpg)

<br>

* 接着

<br>

![mysql的下载页面](/images/software-setup/mysql/mysql-setup3.jpg)

<br>

* 然后我们就来到了下载页面

<br>

![mysql的下载页面](/images/software-setup/mysql/mysql-setup4.jpg)

<br>

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

4. 安装mysql服务<br>![mysql的环境变量](/images/software-setup/mysql/mysql-setup7.jpg)

5. 初始化并启动服务<br>![mysql的环境变量](/images/software-setup/mysql/mysql-setup8.jpg)