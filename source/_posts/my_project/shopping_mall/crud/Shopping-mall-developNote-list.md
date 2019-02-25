---
title: 商城开发笔记-首个功能：商品列表
date: 2019-02-25 20:18:22
categories:
  - 开发笔记
  - 商城
  - 功能篇
tags:
 - 开发笔记
---

# 前言

哇, 真的不容易, 搞了这么久, 终于到了正式开发的阶段了。那么我们商城的首个功能是将所有的商品做一个列表展示, 当然是有分页的。那么开始吧。

# 思路

* 首先将页面写好, 将要填入的数据留出
* 将dao, service, controller写好
* 大功告成

# 前端

再次说明一下, 我们这个项目采用的是vue作为前端, 样式框架采用的是inspinia。

## 在vue中配置jQuery

### 安装jQuery

```shell
npm install jquery --save
```

### 为jQuery和vue添加自定义指令

webpack中可以配置自定义指令, 这样在我们引入依赖时就可以使用指令而不是确切的路径了。

在`build/webpack.bash.conf`文件中添加:

```shell
resolve: {
  extensions: ['', '.js', '.vue'],
  fallback: [path.join(__dirname, '../node_modules')],
  alias: {
    'src': path.resolve(__dirname, '../src'),
    'assets': path.resolve(__dirname, '../src/assets'),
    'components': path.resolve(__dirname, '../src/components'),
    'jquery': path.resolve(__dirname, '../node_modules/jquery/src/jquery'),
    'directives': path.resolve('../src/directives')
  }
},
```
