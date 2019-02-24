---
title: 商城开发笔记-web依赖
date: 2018-11-26 19:39:18
categories:
- 开发笔记
- 商城
- 配置篇
tags:
- 商城开发
---

# web的依赖

不同于其他的工程, 它的打包方式是web工程的打包方式, 所以应该是:

```xml
<packaging>war</packaging>
```

<br>

由于是表现层, 所以依赖中应该包括SpringMVC, 下面是它的所有依赖:

<!--more-->

```xml
<dependencies>
  <dependency>
    <groupId>${project.parent.groupId}</groupId>
    <artifactId>interface</artifactId>
    <version>${project.parent.version}</version>
  </dependency>

  <dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jstl</artifactId>
  </dependency>

  <!-- scope provided 代表不会被打包进去 -->
  <dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <scope>provided</scope>
  </dependency>

  <dependency>
    <groupId>javax.servlet.jsp</groupId>
    <artifactId>javax.servlet.jsp-api</artifactId>
  </dependency>

  <dependency>
    <groupId>commons-fileupload</groupId>
    <artifactId>commons-fileupload</artifactId>
  </dependency>

  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
  </dependency>

  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-beans</artifactId>
  </dependency>

  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
  </dependency>

  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
  </dependency>

  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-aspects</artifactId>
  </dependency>

  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jms</artifactId>
  </dependency>

  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context-support</artifactId>
  </dependency>

  <dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>dubbo</artifactId>
    <exclusions>
      <exclusion>
        <groupId>org.springframework</groupId>
        <artifactId>spring</artifactId>
      </exclusion>
      <exclusion>
        <groupId>org.boss.netty</groupId>
        <artifactId>netty</artifactId>
      </exclusion>
    </exclusions>
    <version>2.5.9</version>
  </dependency>

  <dependency>
    <groupId>org.apache.zookeeper</groupId>
    <artifactId>zookeeper</artifactId>
  </dependency>

  <dependency>
    <groupId>com.101tec</groupId>
    <artifactId>zkclient</artifactId>
    <version>0.10</version>
  </dependency>

  <dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper</artifactId>
  </dependency>
</dependencies>
```

<br>

由于是web工程, 所以和service一样, 也需要tomcat插件:

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.tomcat.maven</groupId>
      <artifactId>tomcat7-maven-plugin</artifactId>
      <configuration>
        <path>/</path>
        <port>8082</port>
        <contextReloadable>true</contextReloadable>
      </configuration>
    </plugin>
  </plugins>
</build>
```

这样, 我们所有的项目的依赖就都介绍完了, 下一篇我们来说一说配置。