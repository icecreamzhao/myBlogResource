---
title: webpack-dev-server
date: 2019-03-03 20:50:49
categories:
- 前端技巧/经验
- webpack
tags:
- webpack
---

# 前言

[上一篇](/js/webpack/webpack-source-map.html)讨论了如何配置基本的webpack配置文件, 并且设置source-map。
今天来看看如何设置webpack-dev-server。
<!--more-->
# 安装

安装命令为:

```shell
npm install --save-dev webpack-dev-server
```

# 配置

详细的配置可以参考[官网配置](https://webpack.js.org/configuration/dev-server/)

其实安装之后就可以启动了, 不需要任何设置, 但是我们之前的html放在了public文件夹中, 那么我们需要将服务器加载的页面所在的目录改为public文件夹:

```js
module.exports = {
    // 省略一些代码...
    devServer: {
        contentBase: "./public", //本地服务器所加载的页面所在的目录
        host: "0.0.0.0",
        inline: true // 实时刷新
    }
}
```

这里需要注意, **我是在cent OS上搭建的webpack-dev-server, 没有配置host, 在打开服务器之后发生了连接不上的情况, 配置了host之后就可以了, 原因不明。**

# 启动

ok, 一切配置准备就绪, 那么我们开始启动它吧!

启动命令是:

```shell
# 局部安装
node_modules/.bin/webpack-dev-server
# 全局安装
webpack-dev-server
```

这个是直接通过命令行启动, 我们也可以把它写在配置文件中, 这样可以直接通过npm run [命令]来启动:

```shell
// package.json
"scripts": {
    "server": "webpack-dev-server"
}
```

这样写好之后, 我们就可以直接通过 `npm run server` 来启动它。
