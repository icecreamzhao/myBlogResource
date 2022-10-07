---
title: 阅读《C程序设计语言（第二版）》第一天
date: 2019-01-20 19:49:16
categories:
- 笔记
- 读书笔记
- C程序设计语言
tags:
- 笔记
- C
---
# 总结

学到了一些关于C的基础知识。
<!--more-->

# 在linux上编写c
首先声明本人使用的linux版本为centos7
1. 使用`cat`或者其他命令来新建一个文件, 后缀名是`.c`
2. 使用`vim`命令来编写这个文件
3. 使用`cc 文件名.c`来编译该文件
4. 使用`./a.out`来运行该文件

<br>

# 在visual studio 2017 上编写c
1. 新建一个项目
!['新建一个项目'](/images/c-programming-language/firstDay/vs1.jpg)

2. 创建文件
!['创建文件'](/images/c-programming-language/firstDay/vs2.jpg)

3. 修改文件属性
!['创建文件'](/images/c-programming-language/firstDay/vs3.jpg)
!['创建文件'](/images/c-programming-language/firstDay/vs4.jpg)
vs有一个预编译头的功能, 将需要导入的库放入预编译头指定的文件, 直接引入这个文件就可以了, 但是我们现在不需要这个功能, 所以先取消掉

4. 编写程序
5. 生成项目
!['创建文件'](/images/c-programming-language/firstDay/vs5.jpg)

6. 运行项目(ctrl-f5)
!['创建文件'](/images/c-programming-language/firstDay/vs6.jpg)

<br/>

# `#define`关键字
语法:
```c
#define KEY "word"
```
该关键字定义了符号常量, 在程序中可直接使用定义的键来替代相应的值。

<br>

# `getchar()` 和 `putchar()`

* getchar()
可以从输入中读一个字符并返回

* putchar(obj)
可以将参数以字符的形式打印出来