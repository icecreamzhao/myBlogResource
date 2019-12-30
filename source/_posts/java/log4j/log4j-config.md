---
title: Log4j 日志配置
date: 2019-12-18 03:42:20
categories:
- Java
- log4j
tags:
- jog4j
---

# 简介

Log4j 有三个主要的组件, Loggers(记录器), Appenders(输出源)和Layouts(布局)。这里可以简单的理解为日志级别, 日志要输出的地方和日志以何种方式输出。综合使用三个组件可以轻松地记录的类型和级别, 并可以在运行时控制日志输出的样式和位置。

1. Loggers

Loggers 组件在此系统中被分为五个级别: DEBUG, INFO, WARN, ERROR, FATAL, 这五个级别是有顺序的, DEBUG < INFO < WARN < ERROR < FATAL, 分别用来指定这条日志信息的重要程度, 明白这一点很重要, Log4j有一条规则: 只输出级别不低于设定级别的日志信息, 假设Loggers级别设定为INFO, 则INFO、WARN、ERROR和FATAL级别的日志都会输出, 而级别比INFO低的DEBUG则不会输出。

2. Appenders

禁用和使用日志请求只是Log4j的基本功能, Log4j日志系统还提供许多强大的功能, 比如允许把日志输出到不同的地方, 如控制台, 文件等, 可以根据天数或者文件大小产生新的文件, 可以以流的形式发送到其他地方等。

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
