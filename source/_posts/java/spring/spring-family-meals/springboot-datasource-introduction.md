---
title: 连接池介绍
date: 2019-05-19 17:46:41
categories:
- 后端
- java
- spring
tags:
- java
- spring
---

# 前言

本编博客介绍了两个SpringBoot的数据源。

SpringBoot各个版本使用的数据源:

* 1.0 使用的是tomcat的dataSource
* 2.0 使用的是HikariCP

<!--more-->

# HikariCP

常用配置:

* spring.datasource.hikari.maximumPoolSize=10
* spring.datasource.hikari.minimumIdle=10
* spring.datasource.hikari.idleTimeout=6000000
* spring.datasource.hikari.connectiontimeout=30000
* spring.datasource.hikari.maxLifetime=18000000

这里是它的[官网](http://brettwooldridge.github.io/HikariCP/)

这里是关于它的性能优化的一些[文章](https://github.com/brettwooldridge/HikariCP/wiki)

# Druid

有两种方式:

* 直接配置一个dataSource bean
* 使用springBoot的`druid-spring-boot-starter`实现自动配置

## 自动配置方式

引入依赖:

```xml
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid-spring-boot-starter</artifactId>
    <version>1.1.16</version>
</dependency>
```

排除默认的数据源hikari:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
    <exclusions>
        <exclusion>
            <groupId>com.zaxxer</groupId>
            <artifactId>HikariCP</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

配置文件可以上[druid的github](https://github.com/alibaba/druid/blob/master/druid-spring-boot-starter/README.md)上查找详细的配置信息。
