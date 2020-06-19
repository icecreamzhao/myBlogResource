---
title: Log4j 日志配置
date: 2019-12-18 03:42:20
categories:
- 后端
- java
tags:
- jog4j2
- java
---

# 前言

这里是对于 Log4j 2 的[官方文档](http://logging.apache.org/log4j/2.x/manual/index.html)的不完全翻译。

# 介绍

EU SEMERER 项目中使用的 tracing API 经过无数次的增强, 多次改进和大量的工作演变成了 log4j。

日志语句对于调试应用程序来说可能并不高级, 但是对于大型的多线程应用程序和分布式应用程序来说, 调试器可能并不像想象中那么好用, 在使用调试器的过程中, 很容易在复杂的数据结构和控制流程的细节上迷失方向, 而且日志可以永久保存以供日后研究。

## Log4j 2

Log4j 2 相较于 Log4j 和 Logback 相比有以下优势:

1. Log4j 2 设计为课用

* Appenders

禁用和使用日志请求只是Log4j的基本功能, Log4j日志系统还提供许多强大的功能, 比如允许把日志输出到不同的地方, 如控制台, 文件等, 可以根据天数或者文件大小产生新的文件, 可以以流的形式发送到其他地方等。

<!--more-->

常使用的类如下:

> org.apache.log4j.ConsoleAppender (控制台)
> org.apache.log4j.FileAppender (文件)
> org.apache.log4j.DailyRollingFileAppender (每天产生一个日志文件)
> org.apache.log4j.RollingFileAppender (文件大小到达指定尺寸的时候产生一个新的文件)
> org.apache.log4j.WriterAppender (将日志信息以流格式发送到任何指定的地方)

配置模式:

log4j.appender.appenderName.layout = className
log4j.appender.appenderName.Option1 = value1
...
log4j.appender.appenderName.OptionN = valueN

## 配置详解

要使Log4j再系统中运行须事先设定配置文件。配置文件事实上也就是对Logger、Appender及Layout进行相应设定。Log4j支持两种配置文件格式, 一种是xml格式的文件, 一种是properties属性文件。下面以properties属性文件为例介绍log4j.properties的配置。

* 配置根logger:

```properties
log4j.rootLogger = [level], appenderName1, appenderName2, ...
log4j.additivity.org.apache=false; # 表示Logger不会在父Logger的appender里输出, 默认为true。
```

level: 设定日志记录的最低级别, 可设的值有 OFF, FATAL, ERROR, WARN, INFO, DEBUG, ALL或者自定义的级别, Log4j建议只使用中间四个级别。通过在这里设置级别, 您可以控制应用程序中相应级别的日志信息开关, 比如在这里设定了INFO级别, 则应用程序中所有DEBUG级别的日志将不会被打印出来。
appenderName: 就是指定日志信息要输出到哪里。可以同时指定多个输出目的地, 用逗号隔开。
例如: log4j.rootLogger = INFO, A1, B2, C3

* 配置日志信息输出目的地(Appender):

```properties
log4j.appender.appenderName = className
```

appenderName: 自定义appenderName, 在log4j.rootLogger设置中使用;
className: 可设值如下:
* org.apache.log4j.ConsoleAppender(控制台)
	* ConsoleAppender 选项:
		* Threshold = WARN 指定日志信息的最低输出级别, 默认为DEBUG
		* ImmediateFlush = true 表示所有消息都会被立即输出, 设为false则不输出, 默认是true
		* Target = System.err 默认值是 System.out
* org.apache.log4j.FileAppender(文件)
	* FileAppender 选项
		* Threshold = WARN 指定日志信息的最低输出级别, 默认为DEBUG
		* ImmediateFlush = true 表示所有消息都会被立即输出, 设为false则不输出, 默认是true
		* Append = false true 表示消息增加到指定文件中, false 则将消息覆盖指定的文本内容, 默认值是true
		* File = D:/logs/logging.log4j 指定消息输出到 logging.log4j 文件中
* org.apache.log4j.DailyRollingFileAppender(每天产生一个日志文件)
	* DailyRollingFileAppender 选项
		* Threshold = WARN 指定日志信息的最低输出级别, 默认为DEBUG
		* ImmediateFlush = true 表示所有消息都会被立即输出, 设为false则不输出, 默认是true
		* Append = false true 表示消息增加到指定文件中, false 则将消息覆盖指定的文本内容, 默认值是true
		* File = D:/logs/logging.log4j 指定消息输出到 logging.log4j 文件中
		* DatePattern = '.'yyyy-MM 每月滚动一次日志文件, 即每月产生一个新的日志文件。当前月的日志文件名为logging.log4j, 前一个月的日志文件名为logging.log4j.yyyy-MM。
		另外, 也可以指定按周、天、时、分等来滚动文件, 对应的格式如下：
		1>'.'yyyy-MM 每月
		2>'.'yyyy-WW 每周
		3>'.'yyyy-MM-dd 每天
		4>'.'yyyy-MM-dd-a 每天两次
		5>'.'yyyy-MM-dd-HH 每小时
		6>'.'yyyy-MM-dd-HH-mm 每分钟
* org.apache.log4j.RollingFileAppender(文件大小到达指定尺寸的时候产生一个新的文件)
	* RollingFileAppender 选项
		* Threshold = WARN 指定日志信息的最低输出级别, 默认为DEBUG
		* ImmediateFlush = true 表示所有消息都会被立即输出, 设为false则不输出, 默认是true
		* Append = false true 表示消息增加到指定文件中, false 则将消息覆盖指定的文本内容, 默认值是true
		* File = D:/logs/logging.log4j 指定消息输出到 logging.log4j 文件中
		* MaxFileSize = 100KB 后缀可以是KB, MB或者GB。在日志文件达到该大小时, 将会自动滚动, 即将原来的内容移到logging.log4j.1文件中。
		* MaxBackupIndex = 2 指定可以产生的滚动文件的最大数, 例如, 设为2则可以产生 logging.log4j.1, logging.log4j.2两个滚动文件和一个logging.log4j文件。

* 配置日志信息的输出格式(Layout):

```xml
log4j.appender.appenderName.layout = className
```

className 可设值如下:

* org.apache.log4j.HTMLLayout ()
