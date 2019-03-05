---
title: webpack-loaders和babel的配置
date: 2019-03-04 23:14:35
categories:
- js
- webpack
tags:
- js
---

# 前言

[上一篇](/js/webpack/webpack-dev-server.html)介绍了如何设置本地服务器, 那么本篇来介绍如何配置loaders和babel

webpack通过使用不同的loaders, 调用外部的脚本或工具, 实现对不同格式的文件的处理, 比如分析转换scss为css, 或者把ES6, ES7文件转换为现代浏览器兼容的JS文件, 合适的loader还可以将react中用到的JSX文件转换为JS文件。

# 安装

这里由于`webpack3.*/webpack2.*`已经内置可处理JSON文件, 所以无需添加处理JSON的loader, 这里直接配置就好。

# 配置

在app文件夹中创建带有问候信息的JSON文件(命名为`config.json`)
```json
{
    "greetText": "Hi there and greetings from JSON!"
}
```

Greeters.js:

```js
var config = require('./config.json');

module.exports = function() {
    var greet = document.createElement('div');
    greet.textContent = config.greetText;
    return greet;
}
```

# Babel

Babel可以编译JavaScript, 将ES6, ES7的JS文件编译为ES5的JS文件。也可以将JavaScript进行了拓展的语言编译为普通的JS文件, 比如React的JSX。

# Babel的安装

安装命令:

```shell
npm install --save-dev babel-core babel-loader@7 babel-preset-env babel-preset=react
```

> 注意, 这里安装babel-loader的时候需要安装7.*版本的, 现在最新的babel-loader版本为8.*, 而对应的babel/core版本为7.*, 如果babel-loader版本为7.*, 对应的babel-core版本为6.*, 我这里尝试了安装7版本的, 会报错:
```shell
ERROR in ./app/main.js
Module build failed (from ./node_modules/babel-loader/lib/index.js):
        Error: Plugin/Preset files are not allowed to export objects, only functions. In /home/littleboy/myProject/myWebPackDemo/node_modules/babel-preset-react/lib/index.js
            at createDescriptor (/home/littleboy/myProject/myWebPackDemo/node_modules/@babel/core/lib/config/config-descriptors.js:178:11)
            at items.map (/home/littleboy/myProject/myWebPackDemo/node_modules/@babel/core/lib/config/config-descriptors.js:109:50)
            at Array.map (<anonymous>)
            at createDescriptors (/home/littleboy/myProject/myWebPackDemo/node_modules/@babel/core/lib/config/config-descriptors.js:109:29)
            at createPresetDescriptors (/home/littleboy/myProject/myWebPackDemo/node_modules/@babel/core/lib/config/config-descriptors.js:101:10)
            at passPerPreset (/home/littleboy/myProject/myWebPackDemo/node_modules/@babel/core/lib/config/config-descriptors.js:58:96)
            at cachedFunction (/home/littleboy/myProject/myWebPackDemo/node_modules/@babel/core/lib/config/caching.js:33:19)
            at presets.presets (/home/littleboy/myProject/myWebPackDemo/node_modules/@babel/core/lib/config/config-descriptors.js:29:84)
            at mergeChainOpts (/home/littleboy/myProject/myWebPackDemo/node_modules/@babel/core/lib/config/config-chain.js:320:26)
            at /home/littleboy/myProject/myWebPackDemo/node_modules/@babel/core/lib/config/config-chain.js:283:7
         @ multi (webpack)-dev-server/client?http://0.0.0.0:8080 ./app/main.js main[1]
```
所以我直接安装6版本的babel-core和7版本的babel-loader。

# 配置

webpack.config.js:

```js
module.exports = {
    // 省略代码....
    module: {
        rules: [
            {
                test: /(\.jsx|\.js)$/,
                use: {
                    loader: "babel-loader", 
                    options: {
                        presets: [
                            "env", "react"
                        ] 
                    }
                }
            }
        ]
    }
}
```
