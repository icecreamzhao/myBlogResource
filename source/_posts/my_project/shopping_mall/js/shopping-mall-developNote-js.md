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
          $: 'jquery'
      })
  ]
  ```

  如果已经有`plugins`, 就直接写声明部分

* 最后在`main.js`入口文件中, 添加:

  ```js
  import $ from 'jquery'

  Vue.prototype.$ = $
  ```

这样就可以直接使用`this.$`来进行对元素的操作了。

## 使用 BootstrapVue

首先安装:

```js
npm install vue bootstrap-vue bootstrap --save-dev
```

接着在 main.js 中声明 bootstrap-vue:

```js
import '~/bootstrap/dist/css/bootstrap.css'
import '~/bootstrap-vue/dist/bootstrap-vue.css'
import BootstrapVue from 'bootstrap-vue'

Vue.use(BootstrapVue)
```

这样就可以直接使用 bootstrap 的组件了。关于组件的详细信息可以查看[官网](https://bootstrap-vue.js.org)。

## 在 Vue 中使用 jquery.metisMenu 和 jquery.slimscroll

同样的, 首先安装:

```js
npm install --save metismenu jquery-slimscroll
```

在 main.js 中使用 `require` 来加载 metisMenu 和 slimscoroll:

```js
require('metismenu')
require('jquery-slimscroll')
```

关于 import 和 require 的区别, 请查看[import和require的区别](https://www.cnblogs.com/sunshq/p/7922182.html)。

之后就可以直接使用了, 关于 metisMenu 的使用方法请查看[官网](https://mm.onokumus.com/index.html)。

## 使用 bootstrap-datepicker

这个和之前的步骤不太一样。首先到[官网](https://github.com/uxsolutions/bootstrap-datepicker/releases)将最新的版本下载下来, 然后将 css 和 js 两个文件夹放置项目的静态文件目录, 假定为 `/src/static`文件夹下。

之后在 `main.js` 中引入文件:

```js
import '../static/css/bootstrap-datepicker.css'
import '../static/js/bootstrap-datepicker.js'
```

就可以了。

## 在 vue 中使用 summernote

首先安装:

```js
npm install --save codemirror font-awesome moment popper.js summernote tooltip.js
```

安装好之后在 main.js 中引入:

```js
require('popper.js')
require('tooltip.js')
require('bootstrap')
require('summernote')
```

大功告成! 

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
