---
title: rocketMQ的安装与配置 
date: 2019-03-21 11:32:26
categories:
- Java
- tools
- mq
tags:
- Java
- mq
---

# 前言

因工作需要实现待办事项功能, 所以接触到了mq, 并将安装和配置的过程记录下来。

# 下载

[官网](http://rocketmq.apache.org/)
这里是它的[下载地址](http://rocketmq.apache.org/release_notes/release-notes-4.4.0/)

# 配置

不得不说一句, 它的配置是真的坑, 搞了好长时间才弄明白怎么回事, 相关文档也比较少。

## 修改jvm内存大小

如果你下载好之后, 直接使用 `sh mqnamesrv &` 命令启动的话, 那么八成会遇到jvm内存不足的错误提示。

这里需要先修改 `bin/runserver.sh`, `bin/runbroker.sh`和`bin/tools.sh` 文件:

```shell
# JVM configuration 的第一句话
JAVA_OPT="${JAVA_OPT} -server -Xms4g -Xmx4g -Xmn2g -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"
```

这里修改为适合自己电脑的内存大小。

## 修改broker默认启动内网的地址

其实到上面那一步就可以正常的启动了, 但是我在将rocketMQ配置到腾讯云并启动之后, 他就会报:

```java
Exception in thread "main" org.apache.rocketmq.remoting.exception.RemotingTooMuchRequestException: sendDefaultImpl call timeout
at org.apache.rocketmq.client.impl.producer.DefaultMQProducerImpl.sendDefaultImpl(DefaultMQProducerImpl.java:634)
	at org.apache.rocketmq.client.impl.producer.DefaultMQProducerImpl.send(DefaultMQProducerImpl.java:1279)
	at org.apache.rocketmq.client.impl.producer.DefaultMQProducerImpl.send(DefaultMQProducerImpl.java:1225)
	at org.apache.rocketmq.client.producer.DefaultMQProducer.send(DefaultMQProducer.java:283)
```

在启动broker时会有broker的启动的地址, 启动时会有这样的提示:

```shell
The broker[broker-a, 127.0.0.1:10911] boot success. serializeType=JSON and name server is 127.0.0.1:9876
```

但是我们如果远程连接broker的话, 是不能直接使用内网地址来访问的, 所以这里就需要修改一下 `conf/broker.conf`:

```shell
# 在文件最后添加:
brokerIP1 = 你的外网地址
```

然后在启动broker的时候可以这么写:

```shell
sh mqbroker -n 127.0.0.1:9876 autoCreateTopicEnable=true -c ../conf/broker.conf
```

这样就可以正常的使用了。

[这里](https://blog.csdn.net/gwd1154978352/article/details/80829534)是它的一些常用命令。
