---
title: 'linux配置Java,Git,Maven,Zookeeper环境'
date: 2018-12-05 21:47:02
categories:
- 操作系统
- linux
tags:
- linux
---

# 前言

在windows上写好了一个项目, 想部署到linux环境运行试试看, 嗯, 这个就是这篇博客的前提。

<!--more-->

<br>

# 配置Java

嗯, Java是第一个就应该配置的东西, 那么我们采用比较传统的做法来配置。

这里需要注意一点, 就是不要使用`wget`命令来下载oracle官网地址的jdk压缩包, 因为如果你访问过oracle官网你就会发现, 在下载jdk之前, 需要先同意条款才能下载, 通过命令下载当然也可以下载下来, 但是下载下来的文件是有问题的, 解压不了, 所以需要访问官网, 同意条款, 下载压缩包, 上传至linux服务器才可以。

然后将其解压:

```shell
$ tar -zxvf jdk-8u102-linux-x64.tar.gz
```

新建一个文件夹, 将解压好的文件放到里面:

```shell
$ mkdir java
$ mv .jdk-8u191 /home/usr/java
```

接下来设置环境变量, 这一篇详细讲解了[如何设置环境变量](/linux/Linux_Basic_Operation/linux-path-variable.html):

```shell
$ export JAVA_HOME=/home/usr/java/jdk1.8.0_102
export JRE_HOME=/home/usr/java/jdk1.8.0_102/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
```

别忘了需要重启或者设置立即生效。接着测试环境:

```shell
java -version
javac -version
```

<br>

# 配置Maven

其实流程都是一样的, 先下载Maven压缩包:

```shell
$ wget http://mirrors.hust.edu.cn/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
```

解压步骤参考上文。

设置环境变量:

```shell
export MAVEN_HOME=/home/usr/maven/apache-maven-3.6.0
export PATH=$PATH:$MAVEN_HOME/bin
```

<br>

# 配置Git

其实Git官网上有教怎样下载: [Linux配置Git](https://git-scm.com/download/linux)

总体来说就是一句话:

```shell
$ apt-get install git
```

<br>

# 配置zookeeper

下载...

```shell
$ wget http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.4.13/zookeeper-3.4.13.tar.gz
```

解压...

这里稍微有点不一样, 首先需要修改一下zookeeper的配置文件, 在conf文件夹下:

```shell
$ cd /home/usr/zookeeper/zookeeper-3.4.13/conf
$ cp zoo_sample.cfg zoo.cfg
$ vi zoo.cfg
```

主要修改数据存放地址和日志地址:

```shell
dataDir=/HD/logs/zookeeper
dataLogDir=/HD/logs/zookeeper
```

这里我使用的是ubuntu 18.0.4, 然而还是出现了问题:

```shell
/home/usr/zookeeper/zookeeper-3.4.13# sh bin/zkServer.sh start
JMX enabled by default
bin/zkServer.sh: 95: /home/usr/zookeeper/zookeeper-3.4.13/bin/zkEnv.sh: Syntax error: "(" unexpected (expecting "fi")
```

稍微百度了一下, 就找到了解决办法:

```shell
$ cd /bin/
$ ln -sf bash /bin/sh
```

就是修改了一下sh的硬链接

**CentOS是没有这个问题的**

然后就可以开心愉快的使用zookeeper啦:

```shell
$ sh zkServer.sh start //启动
$ sh zkServer.sh status //检查状态
$ sh zkServer.sh stop //停止
```

<br>

# 总结

非常的简单, 就是环境变量那里稍微有点复杂, 但是稍微研究一下就应该没什么问题了, 嗯, 大概就是这样了。