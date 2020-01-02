---
title: 搭建flutter开发环境
date: 2020-01-02 06:27:11
categories:
- 移动开发
- flutter
tags:
- flutter
---

# 介绍

flutter 是谷歌的移动UI框架, 可以快速在 IOS 和 Android 上构建高质量的原生用户界面。这里是它的[中文网站](https://flutterchina.club)和[api](https://api.flutter.dev)。

# 搭建环境

这里[官网](https://flutterchina.club/setup-windows)介绍的非常详细, 我就不多赘述了, 这里就说一下几个注意的地方:

<!--more-->

* 使用flutter doctor

在命令行使用 `flutter doctor` 来检查是否需要安装其他依赖项来完成安装。

* 将 flutter 的安装目录放到环境变量中

新建一个 `FLUTTER_HOME` 环境变量, 赋值为安装目录, 接着将 `%FLUTTER_HOME%` 添加到 path 环境变量中。

* 编译器的配置

我体验了三种编译器, 分别是 intellij idea, android studio 和 vs code, 体验最好的是 vs code, 果然是宇宙最强编辑器。

