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


## 在Vue中引用js文件

先说怎么操作:

1. 在`build/webpack.base.conf.js`文件中的`module.exports`部分里面的`alias`里添加:
```js
module.exports = {
	// ... 省略前面的代码
	resolve: {
    extensions: ['.js', '.vue', '.json'],
    alias: {
		`apiTools`: resolve('src/api/tools.js')
	}
}

// ...省略后面的代码
```
2. 在`main.js`里引用:
```js
import tools from 'apiTools'
import tools2 from 'apiTools'
```
> 补充, apiTools.js内容是:
```
function tools () {
  console.log('test')
}

function tools2() {
	console.log('test2')
}

export default {
  tools: tools(),
  tools2: tools2()
}
```
3. 调用js方法
```
export default {
  name: 'App',
  mounted() {
    tools
    tools2
  }
}
</script>
```

大概就是这三步, 那么接下来解释一下:

第一步, 设置别名, 如果接触过linux系统的话, 对别名应该比较熟悉。其实就是字符串替换, 比如上面的例子, 就是将`apiTools`替换成了后面的路径。
第二步, 引用js文件, 这里import后面的是js文件暴露出的方法名(或者是变量名), from 后面的是前面约定好的替换的字符串。
最后一步, 直接调用就可以。

# 补充

在配置字符串替换的时候, 可能有关键字的问题, 这个还不太确定, 所以在配置的时候尽量避免使用那些常用的字符串。
