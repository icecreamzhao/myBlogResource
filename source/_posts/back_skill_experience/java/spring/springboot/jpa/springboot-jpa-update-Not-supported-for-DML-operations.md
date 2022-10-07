---
title: springboot jpa update操作时报 Not supported for DML operations
date: 2019-05-16 23:27:08
categories:
- 后端技巧/经验
- java
tags:
- 踩坑
- java
- jpa
---

# 问题

在使用jpa进行update操作时, 报Not supported for DML operations 错误
<!--more-->

# 解决办法

在`@query`注解上再加一个`@Modifying`注解和`@Transactional`注解。
