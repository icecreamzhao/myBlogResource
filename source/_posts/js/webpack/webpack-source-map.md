---
title: webpack-source map
date: 2019-02-28 21:39:41
categories:
- 前端
- webpack
tags:
- webpack
---

# 前言

webpack打包之后的文件, 如果出了错是不太好调试的, 而`Source Maps`可以很方便的调试。

<!--more-->
# 配置

在`webpack`的配置文件中配置`source maps`, 需要配置`devtool`, 有以下四种不同的配置选项:

| DEVTOOL 选项 | 配置结果 |
| :----------- | :------- |
| source-map | 在一个单独的文件中产生一个完整且功能完全的文件。这个文件具有最好的 source map, 但是它会减慢打包速度 |
| cheap-module-source-map | 在一个单独的文件中生成一个不带列映射的 map, 不带列映射提高了打包速度, 但是也使得浏览器开发者工具只能对应到具体的行, 不能对应到具体的列 |
| eval-source-map | 使用 eval 打包源文件模块, 在同一个文件中生成干净的完整的 source map。这个选项可以不影响构建速度的前提下生成完整的 sourcemap, 但是对打包后输出的 JS 文件的执行具有性能和安全的隐患。在开发阶段这是一个好选项, 生产阶段则一定不要启用这个选项 |
| cheap-module-eval-source-map | 这是在打包文件时最快的生成 source map 的方法, 生成的 Source Map 会和打包后的 JavaScript 文件同行显示, 没有列映射, 和 eval-source-map 选项具有相似的缺点。 |

根据上述情况, 我们可以在开发阶段使用`eval-source-map`来构建`Source Maps`, 可以这样配置:

```js
module.exports = {
    devtool: 'eval-source-map',
    entry: __dirname + "/app/main.js",
    output: {
        path: __dirname + "/public",
        filename: "bundle.js"
    }
}
```
