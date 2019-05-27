---
title: '商城开发笔记-common, manager的依赖'
date: 2018-11-20 19:33:19
categories:
- 开发笔记
- 商城
- 配置篇
tags:
- 商城开发
---

# common的依赖

## 主体部分

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <!-- 主体内容 -->
  <parent>
    <artifactId>parent</artifactId>
    <groupId>com.littleboy</groupId>
    <version>0.1</version>
    <relativePath>../parent/pom.xml</relativePath>
  </parent>
  <modelVersion>4.0.0</modelVersion>
  <artifactId>common</artifactId>
</project>
```

## 打包方式

```xml
<packaging>jar</packaging>
```

<!--more-->

## 引入依赖

因为是common工程, 所以只需要放其他工程都能用得到的工具:

```xml
<dependencies>
  <dependency>
    <groupId>joda-time</groupId>
    <artifactId>joda-time</artifactId>
  </dependency>

  <dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
  </dependency>

  <dependency>
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
  </dependency>

  <dependency>
    <groupId>commons-net</groupId>
    <artifactId>commons-net</artifactId>
  </dependency>

  <dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
  </dependency>

  <dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
  </dependency>

  <dependency>
    <groupId>org.quartz-scheduler</groupId>
    <artifactId>quartz</artifactId>
  </dependency>

  <dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-log4j12</artifactId>
  </dependency>
  <dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
  </dependency>
</dependencies>
```

没什么可说的, 大家看看就好, 这些工具到时候等用到我就会介绍的。

<br>

# Manager的依赖

## 主体部分

参照common工程, 区别只在于artifactId

## 打包方式

同样是jar, 写法参照common工程

## 引入依赖

因为是一个父工程, 本身没什么东西, 所以只需要将common的依赖引用过来就可以, 呐, 是不是将common工程的pom.xml再复制一遍呢? 当然不是, 还记得么, 我们的common工程打包方式是jar, 所以, 可以直接将common当成一个jar包引入进来:

```xml
<dependencies>
  <dependency>
    <groupId>${parent.groupId}</groupId>
    <artifactId>common</artifactId>
    <version>${parent.version}</version>
  </dependency>
</dependencies>
```

看, 这样是不是方便多了呢?

## Maven插件

配置Maven插件的tomcat, 这里指定了它的过滤器路径和端口号:

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.tomcat.maven</groupId>
      <artifactId>tomcat7-maven-plugin</artifactId>
      <configuration>
        <path>/</path>
        <port>8081</port>
      </configuration>
    </plugin>
  </plugins>
</build>
```

