---
title: webpack-起步-配置文件
date: 2019-02-28 19:58:47
categories:
- 前端技巧/经验
- webpack
tags:
- webpack
---

# 前言

接着[上一篇](/js/webpack/webpack-first-step.html), 这一篇要来学习一下Webpack的配置。

<!--more-->
# 通过配置文件来使用Webpack

## 配置打包文件路径和文件名

首先在项目根目录下新建一个名为`webpack.config.js`的文件, 内容:

```js
module.exports = {
    // 入口文件
    entry: __dirname + "/app/main.js";
    output: {
        // 打包后文件存放的地方
        path: __dirname + "/public",
        // 打包后输出文件的文件名
        filename: "bundle.js"
    }
}
```

> `__dirname`是node.js的一个全局变量, 它指向当前脚本所在的目录。

有了这个配置之后, 就可以直接运行webpack命令来编译代码了。

# 使用npm start来执行打包任务

在`package.json`中对`script`对象进行设置:

```json
{
    "name": "webpack-sample-project",
    "version": "1.0.0",
    "description": "Sample webpack project",
    "scripts": {
        // 这里设置 json不支持注释, 引用时请删除
        "start": "webpack"
    },
    "author": "zhang",
    "license": "ISC",
    "devDependencies": {
        "webpack": "3.10.0"
    }
}
```

npm的start命令是一个特殊的命令, 在命令行中使用`npm start`就可以执行配置的命令, 如果对应的脚本名称不是`start`, 则需要这样`npm run {script name}`, 如`npm run build`。
