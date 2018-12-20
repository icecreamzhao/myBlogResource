---
title: '商城开发笔记-pojo,dao,interface,service的依赖'
date: 2018-11-21 19:37:28
categories:
- 开发笔记
- 商城
tags:
- 商城开发
---

# pojo的依赖

pojo是用来存放实体类的工程, 它什么依赖也不需要, 只需要将打包方式改成jar就可以。

<br>

# dao的依赖

他的打包方式同样是jar, 而且因为和数据库打交道, 所以需要将mybatis的依赖添加进来

<!--more-->

> dependencies部分

```xml
<dependencies>
  <dependency>
    <groupId>${parent.groupId}</groupId>
    <artifactId>pojo</artifactId>
    <version>${parent.version}</version>
  </dependency>

  <dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
  </dependency>

  <dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-spring</artifactId>
  </dependency>

  <dependency>
    <groupId>com.github.miemiedev</groupId>
    <artifactId>mybatis-paginator</artifactId>
  </dependency>

  <dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper</artifactId>
  </dependency>

  <dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
  </dependency>

  <!--这个是数据库连接池-->
  <dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid</artifactId>
  </dependency>
</dependencies>
```

依赖还包括了pagehelper, 是mybatis提供的用来分页的工具

<br>

# interface的依赖

打包方式依然是jar, 由于存放的都是接口, 所以也用不到什么依赖, 只需要将pojo引入进来就可以了

```xml
<dependencies>
  <dependency>
    <groupId>${parent.groupId}</groupId>
    <artifactId>pojo</artifactId>
    <version>${parent.version}</version>
  </dependency>
</dependencies>
```

<br>

# service的依赖

这里很重要, 还记得咱们之前讲的关于本项目的架构的问题么? 因为这个项目使用的是SOA架构, 服务统一由服务中心管理, 由服务中心暴露服务的端口给表现层, 所以服务层的打包方式需要是war, 以一个web工程的方式打包, 这样才可以单独启动这个工程, 从而暴露端口。

所以它需要的依赖就包括了SpringMVC, 以下是它的dependencies部分:

> service的配置部分

```xml
<dependencies>
  <!--dao-->
  <dependency>
    <groupId>${parent.groupId}</groupId>
    <artifactId>dao</artifactId>
    <version>${parent.version}</version>
  </dependency>

  <!--interface-->
  <dependency>
    <groupId>${parent.groupId}</groupId>
    <artifactId>interface</artifactId>
    <version>${parent.version}</version>
  </dependency>

  <!--spring start-->
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
  <!--Spring end-->

  <!--dubbo-->
  <dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>dubbo</artifactId>
    <exclusions>
      <!--将spring依赖去除-->
      <exclusion>
        <groupId>org.springframework</groupId>
        <artifactId>spring</artifactId>
      </exclusion>
      <exclusion>
        <!--将netty依赖去除-->
        <groupId>org.boss.netty</groupId>
        <artifactId>netty</artifactId>
      </exclusion>
    </exclusions>
  </dependency>

  <!--分页-->
  <dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper</artifactId>
  </dependency>

  <!--zookeeper start-->
  <dependency>
    <groupId>org.apache.zookeeper</groupId>
    <artifactId>zookeeper</artifactId>
  </dependency>

  <dependency>
    <groupId>com.101tec</groupId>
    <artifactId>zkclient</artifactId>
  </dependency>
  <!--zookeeper end-->
  
  <dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-api</artifactId>
    <version>RELEASE</version>
  </dependency>
</dependencies>
```

这里需要说明一下, 因为dubbo中引用了Spring依赖, 所以我们需要将依赖去掉, 要不然会冲突。

<br>

ok, 下一篇博客就是我们最后一个工程的依赖了, 依赖讲完后, 我们再来说说整个项目的配置。