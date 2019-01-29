---
title: 商城开发笔记-js配置
date: 2018-12-10 20:04:06
categories:
- 开发笔记
- 商城
- 前端篇
tags:
- 商城开发
- js
---

# js模块介绍

这个项目使用的ui是[inspinia](http://cn.inspinia.cn/), 我觉得还挺好看的, 所以就选择了这个。

大概看了一下, 有用到这几个js模块:

* jquery
* bootstrap
* jquery.metisMenu
* jquery.slimscroll
* inspinia
* pace
* bootstrap-datepicker
* summernote

<br>

## 在Vue项目引用jQuery

步骤如下:

* 在`package.json`文件的`dependencies`中添加: `"jquery": "^3.3.1"`

* 接着在`build/webpack.bash.conf.js`文件中的头部分添加:

  ```js
  const webpack = require('webpack')
  ```

* 还是这个文件, 在`module.exports`部分中添加:

  ```js
  plugins: [
      new webpack.ProvidePlugin({
          $: 'jquery',
          jQuery: 'jquery'
      })
  ]
  ```

  如果已经有`plugins`, 就直接写声明部分

* 最后在`main.js`入口文件中, 添加:

  ```js
  import $ from 'jquery'
  ```

这样就可以直接使用`$`来进行对元素的操作了

<br>

## 在Vue中引用js文件

