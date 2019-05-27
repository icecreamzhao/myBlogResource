---
title: springboot jpa
date: 2019-05-21 20:18:44
categories:
- Java
- spring
- 学习
tags:
- Java
- spring
---

# 前言

今天让我们来接触一下SpringBoot的JPA。

<!--more-->

# 介绍

JPA, 全称 Java Persistence API, Hibernate是它的实现。

# 使用

如果使用的是SpringBoot的话, 可以直接使用:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

来添加依赖。

# 实体类注解

有很多注解可以帮助我们省去很多繁杂的代码, 比如getter setter, 构造器等, 下面我们将会介绍几个常用的注解。

## `@Entity`, `@Table`

这两个注解用来说明这是一个实体类, 可以直接根据这个实体类的属性构建数据库的表结构, 比如:

```java
@Entity
@Table(name = "Foo")
public class Foo {
}
```

`@Table`的name属性对应表名。

## `@MappedSuperclass`, `@Id`, `@GeneratedValue`, `@Column`, `@ManyToMany`等

这些都是`javax.persistence`里的包, 分别用来对应表结构中的各种关系和约束, 这里说一下`@MappedSuperclass`, 很多表都有相同的列, 这样就可以定义一个基类, 包含所有表都会有的一些字段。

## `@CreationTimestamp`, `@UpdateTimestamp`

这两个是hibernate的注解, 可以在创建时间和修改时间字段上加入这两个注解。

## `@Builder`, `@ToString`, `@NoArgsConstructor`, `@AllArgsConstructor`, `@Data`

这些都是lombok包中的一些注解, 都是用来减少我们实体类中的代码的, 可以见名知意。
