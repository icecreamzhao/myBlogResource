---
title: 商城开发笔记-依赖
date: 2018-11-20 18:47:53
categories:
- 开发笔记
- 商城
- 配置篇
tags:
- 商城开发
---

# 框架简介

本项目主要用到的框架有:

1. Spring
2. SpringMVC
3. Mybatis
4. zookeeper
5. dubbo
6. radis
7. junit

还有一些其他的小工具, 方便开发使用的, 等用到的时候我再作介绍

<!--more-->

<br>

# 配置

依赖介绍完, 下面我们来配置项目

因为配置文件内容较多, 所以我会分成几篇博客来说明。

首先, 咱们用parent工程来管理所有工程的依赖版本号, 注意, 这里只是管理版本号, 并不是真正将依赖添加进来。

> parent的pom.xml

主体:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.littleboy</groupId>
  <artifactId>parent</artifactId>
  <version>0.1</version>
  
  <!-- 主体内容 -->

  <modules>
      <module>../common</module>
	  <module>../manager</module>
	  <module>../web</module>
  </modules>
</project>
```

打包方式:

```xml
<packaging>pom</packaging>
```

一般来说都会将依赖版本号写到properties节点中, 这样以后更换版本的时候就会非常方便

```xml
<properties>
  <!-- 项目编码 -->
  <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  <!-- 指定Java编译和源码版本 -->
  <maven.compiler.source>1.7</maven.compiler.source>
  <maven.compiler.target>1.7</maven.compiler.target>
  <!-- 测试 -->
  <junit.version>4.11</junit.version>

  <!-- spring -->
  <spring.version>5.0.8.RELEASE</spring.version>

  <!-- database -->
  <!-- mybatis -->
  <mybatis.spring.version>1.3.2</mybatis.spring.version>
  <mybatis.version>3.4.6</mybatis.version>
  <!-- 分页 -->
  <mybatis.pagintor.version>1.2.15</mybatis.pagintor.version>
  <mybatis.pagehelper.version>5.1.4</mybatis.pagehelper.version>
  <mybatis.generator.version>1.3.7</mybatis.generator.version>
  <!-- 缓存, 可以用来操作redis https://blog.csdn.net/a837201942/article/details/77160658 -->
  <jedis.version>2.9.0</jedis.version>
  <!-- 全文检索 -->
  <solrj.version>7.4.0</solrj.version>

  <!-- 分布式框架 -->
  <dubbo.version>2.5.9</dubbo.version>
  <zookeeper.version>3.4.13</zookeeper.version>
  <zkclient.version>0.10</zkclient.version>

  <!-- 消息队列 -->
  <activemq.version>5.7.0</activemq.version>

  <!-- 连接池 -->
  <druid.version>1.1.9</druid.version>
  <!-- mysql -->
  <mysql.version>8.0.11</mysql.version>

  <!-- 杂七杂八 -->
  <!-- 日志 -->
  <slf4j.version>1.7.7</slf4j.version>
  <!-- jackson -->
  <jackson.version>2.9.6</jackson.version>
  <!-- http协议客户端编程 -->
  <httpClient.verrsion>4.5.6</httpClient.verrsion>
  <!-- jstl -->
  <jstl.version>1.2</jstl.version>
  <!-- servlet -->
  <servlet.version>4.0.1</servlet.version>
  <!-- jsp -->
  <jsp.version>2.3.3</jsp.version>
  <!-- joda-time (替代 java 自带日期时间用)-->
  <joda-time.version>2.10</joda-time.version>
  <!-- common (apache家的, 很厉害) 使用方法可以查看 https://www.cnblogs.com/shihaiming/p/7814804.html -->
  <commons-lang.version>3.7</commons-lang.version>
  <!-- 同上, 使用方法可以查看 https://www.cnblogs.com/softidea/p/4279576.html -->
  <commons-io.version>2.6</commons-io.version>
  <!-- 文件上传下载 使用方法 https://www.cnblogs.com/whgk/p/6479405.html -->
  <commons-fileUpload.version>1.3.3</commons-fileUpload.version>

  <common-net.version>3.3</common-net.version>
  <!-- 任务调度框架 https://www.cnblogs.com/drift-ice/p/3817269.html -->
  <quartz.version>2.3.0</quartz.version>
</properties>
```

因为parent是用来管理版本号的, 所以, 这里将所有用到的依赖都写到`<dependencyManagement>`节点下, 说明是管理依赖而不是引入依赖

```xml
<dependencyManagement>
<dependencies>
<!-- 工具类 -->
<dependency>
<groupId>joda-time</groupId>
<artifactId>joda-time</artifactId>
<version>${joda-time.version}</version>
</dependency>

<dependency>
<groupId>org.apache.commons</groupId>
<artifactId>commons-lang3</artifactId>
<version>${commons-lang.version}</version>
</dependency>

<dependency>
<groupId>commons-io</groupId>
<artifactId>commons-io</artifactId>
<version>${commons-io.version}</version>
</dependency>

<dependency>
<groupId>commons-net</groupId>
<artifactId>commons-net</artifactId>
<version>${common-net.version}</version>
</dependency>

<dependency>
<groupId>com.fasterxml.jackson.core</groupId>
<artifactId>jackson-databind</artifactId>
<version>${jackson.version}</version>
</dependency>

<dependency>
<groupId>org.apache.httpcomponents</groupId>
<artifactId>httpclient</artifactId>
<version>${httpClient.verrsion}</version>
</dependency>

<dependency>
<groupId>org.quartz-scheduler</groupId>
<artifactId>quartz</artifactId>
<version>${quartz.version}</version>
</dependency>

<dependency>
<groupId>org.slf4j</groupId>
      <artifactId>slf4j-log4j12</artifactId>
      <version>${slf4j.version}</version>
    </dependency>
    <!-- 工具类结束 -->

    <!-- mybatis 和数据库 -->
    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis</artifactId>
      <version>${mybatis.version}</version>
    </dependency>

    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis-spring</artifactId>
      <version>${mybatis.spring.version}</version>
    </dependency>

    <dependency>
      <groupId>com.github.miemiedev</groupId>
      <artifactId>mybatis-paginator</artifactId>
      <version>${mybatis.pagintor.version}</version>
    </dependency>

    <dependency>
      <groupId>org.mybatis.generator</groupId>
      <artifactId>mybatis-generator-core</artifactId>
      <version>${mybatis.generator.version}</version>
    </dependency>

    <dependency>
      <groupId>com.github.pagehelper</groupId>
      <artifactId>pagehelper</artifactId>
      <version>${mybatis.pagehelper.version}</version>
    </dependency>

    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>${mysql.version}</version>
    </dependency>

    <dependency>
      <groupId>com.alibaba</groupId>
      <artifactId>druid</artifactId>
      <version>${druid.version}</version>
    </dependency>
    <!-- mybatis 和数据库结束 -->

    <!-- spring -->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>${spring.version}</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-beans</artifactId>
      <version>${spring.version}</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>${spring.version}</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-jdbc</artifactId>
      <version>${spring.version}</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-aspects</artifactId>
      <version>${spring.version}</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-jms</artifactId>
      <version>${spring.version}</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context-support</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <!-- spring 结束 -->

    <!-- 表现层 -->
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>jstl</artifactId>
      <version>${jstl.version}</version>
    </dependency>

    <!-- scope provided 代表不会被打包进去 -->
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>${servlet.version}</version>
      <scope>provided</scope>
    </dependency>

    <dependency>
      <groupId>javax.servlet.jsp</groupId>
      <artifactId>javax.servlet.jsp-api</artifactId>
      <version>${jsp.version}</version>
      <scope>provided</scope>
    </dependency>
    <!-- 表现层结束 -->

    <dependency>
      <groupId>commons-fileupload</groupId>
      <artifactId>commons-fileupload</artifactId>
      <version>${commons-fileUpload.version}</version>
    </dependency>

    <dependency>
      <groupId>redis.clients</groupId>
      <artifactId>jedis</artifactId>
      <version>${jedis.version}</version>
    </dependency>

    <dependency>
      <groupId>org.apache.solr</groupId>
      <artifactId>solr-solrj</artifactId>
      <version>${solrj.version}</version>
    </dependency>

    <dependency>
      <groupId>com.alibaba</groupId>
      <artifactId>dubbo</artifactId>
      <version>${dubbo.version}</version>
    </dependency>

    <dependency>
      <groupId>org.apache.zookeeper</groupId>
      <artifactId>zookeeper</artifactId>
      <version>${zookeeper.version}</version>
    </dependency>

    <dependency>
      <groupId>com.101tec</groupId>
      <artifactId>zkclient</artifactId>
      <version>${zkclient.version}</version>
    </dependency>

    <dependency>
      <groupId>org.apache.activemq</groupId>
      <artifactId>activemq-all</artifactId>
      <version>${activemq.version}</version>
    </dependency>

    <dependency>
      <groupId>org.freemarker</groupId>
      <artifactId>freemarker</artifactId>
      <version>${freeMarker.version}</version>
    </dependency>

    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>${junit.version}</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

最后, 来引入一些Maven插件, 仔细注意一下, tomcat插件没有没引入, 只是放到了插件管理中:

```xml
<build>
  <finalName>${project.artifactId}</finalName>
  <plugins>
    <!-- 指定源码版本 -->
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-resources-plugin</artifactId>
      <version>3.0.2</version>
      <configuration>
        <encoding>UTF-8</encoding>
      </configuration>
    </plugin>

    <!-- 指定编译版本 -->
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
      <version>3.7.0</version>
      <configuration>
        <source>1.8</source>
        <target>1.8</target>
        <encoding>UTF-8</encoding>
      </configuration>
    </plugin>
  </plugins>
  
  <!-- 这里是插件管理, 同样不是引入插件, 而是管理插件 -->
  <pluginManagement>
    <plugins>
      <plugin>
        <groupId>org.apache.tomcat.maven</groupId>
        <artifactId>tomcat7-maven-plugin</artifactId>
        <version>2.2</version>
      </plugin>
    </plugins>
  </pluginManagement>
</build>
```

<br>

好了, 这下parent的pom.xml就完成了, 下一篇博客会接着讲配置。
