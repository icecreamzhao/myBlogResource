---
title: 记一次修改hexo新建文件的方式
date: 2019-05-28 01:09:19
categories:
- hexo
- 魔改
tags:
- hexo
---

# 前言

众所周知, 使用hexo新建一篇博客的命令是 `hexo new "博客名"`, 新建的博客文件会被放到 `source/_posts` 下, 然后我尝试了一下直接加入目录, 比如: `hexo new "目录/博客"`, 发现hexo会自动将 `/` 符号替换成 `-`, 我打算改回来。

<!--more-->

# 思路

起先我的思路很简单, 直接去看hexo的依赖, 在node_modules下的依赖中, 带有hexo字样的如下:

```
hexo
hexo-bunyan
hexo-deployer-git
hexo-filter-mermaid-diagrams
hexo-front-matter
hexo-fs
hexo-generator-archive
hexo-generator-category
hexo-generator-index
hexo-generator-json-content
hexo-generator-tag
hexo-i18n
hexo-log
hexo-pagination
hexo-renderer-ejs
hexo-renderer-marked
hexo-renderer-stylus
hexo-server
hexo-util
```

看了一圈之后, 感觉还是hexo这个依赖比较像, 点进去看了一下, 里面有一个`lib`文件夹, 里面有一个hexo文件夹, 看起来就是它了, 我先看了看index.js文件, 里面有这样一段代码:

```js
Hexo.prototype.init = function() {
  const self = this;

  this.log.debug('Hexo version: %s', chalk.magenta(this.version));
  this.log.debug('Working directory: %s', chalk.magenta(tildify(this.base_dir)));

  // Load internal plugins
  require('../plugins/console')(this);
  require('../plugins/filter')(this);
  require('../plugins/generator')(this);
  require('../plugins/helper')(this);
  require('../plugins/processor')(this);
  require('../plugins/renderer')(this);
  require('../plugins/tag')(this);

  // Load config
  return Promise.each([
    'update_package', // Update package.json
    'load_config', // Load config
    'load_plugins' // Load external plugins & scripts
  ], name => require(`./${name}`)(self)).then(() => self.execFilter('after_init', null, {context: self})).then(() => {
    // Ready to go!
    self.emit('ready');
  });
};
```

这应该就是初始化的代码了, 其中还加载了一些插件, 所以我就又去看了一下plugins这个文件夹, 所以我就挨个点进去看, 谁想到第一个就找到了:

```js
// console/index.js
console.register('new', 'Create a new post.', {
  usage: '[layout] <title>',
  arguments: [
    {name: 'layout', desc: 'Post layout. Use post, page, draft or whatever you want.'},
    {name: 'title', desc: 'Post title. Wrap it with quotations to escape.'}
  ],
  options: [
    {name: '-r, --replace', desc: 'Replace the current post if existed.'},
    {name: '-s, --slug', desc: 'Post slug. Customize the URL of the post.'},
    {name: '-p, --path', desc: 'Post path. Customize the path of the post.'}
  ]
}, require('./new'));
```

这是`console/index.js`里面的一段代码, 看起来就是加载新建文件的一段js了, 还说明了一些选项, 这个我之前可不知道, 哈哈。

之后我打开了`new.js`文件, 里面只有一个函数:

```js
function newConsole(args) {
  // 省略前面的代码
  return this.post.create(data, args.r || args.replace).then(post => {
    self.log.info('Created: %s', chalk.magenta(tildify(post.path)));
  });
}
```

这里调用了post的create()方法, 我这里尝试着console了一下this, 发现是一个Hexo对象, 所以我就又回到了`hexo/index.js`中看了一下:

```js
this.post = new Post(this);
```

然后发现它是在同级目录下的post.js, 发现了这个post的create()方法的定义:

```js
// post的create方法:
// 省略前面的代码...
return Promise.all([
  // Get the post path
  ctx.execFilter('new_post_path', data, {
    args: [replace],
    context: ctx
  }),
  this._renderScaffold(data)
]) //... 省略后面的代码
```

这里我发现他在调用了ctx的execfileter()方法之后就可以获取到path, 而ctx则是在`hexo/index.js`中初始化时传入的this, 那么也就是说execfilter()方法还是定义在`hexo/index.js`中:

```js
Hexo.prototype.execFilter = function(type, data, options) {
  return this.extend.filter.exec(type, data, options);
};
```

这里的`this.extend`被定义到了第57行:

```js
  this.extend = {
    console: new extend.Console(),
    deployer: new extend.Deployer(),
    filter: new extend.Filter(),
    generator: new extend.Generator(),
    helper: new extend.Helper(),
    migrator: new extend.Migrator(),
    processor: new extend.Processor(),
    renderer: new extend.Renderer(),
    tag: new extend.Tag()
  };
```

而Filter则是`extend`文件夹, 这里自不必多说, 不用看就知道`extend/index.js`里面肯定将其他的js都注册好了, 所以我这里直接去看了filter.js:

```js
Filter.prototype.exec = function(type, data, options = {}) {
  const filters = this.list(type);
  const ctx = options.context;
  const args = options.args || [];

  args.unshift(data);
  
  return Promise.each(filters, filter => Promise.method(filter).apply(ctx, args).then(result => {
    args[0] = result == null ? args[0] : result;
	
    return args[0];
  })).then(() => args[0]);
};
```

这里先使用了list()方法使用index.js中传过来的`new_post_path`初始化了这个变量, 而在list方法中根据store数组中的数据进行判断调用哪一个方法, 我这里console了一下这个Filters, 打印的结果是

```
[ { [Function: newPostPathFilter] priority: 10 } ]
```

由此可知使用的方法是newPostPathFilter()来进行添加文件这个操作的, 而在register()方法中对store数组进行了初始化, 那么这个register是在哪里调用的呢? 还有newPostPathFilter()这个方法是在哪里定义的呢? 其实我也不知道, 找了很久, 最后在`plugins/filter`这个文件夹找到了一些蛛丝马迹:

```js
// plugins/filter/index.js
module.exports = ctx => {
  const filter = ctx.extend.filter;

  require('./after_post_render')(ctx);
  require('./before_post_render')(ctx);
  require('./before_exit')(ctx);
  require('./before_generate')(ctx);
  require('./template_locals')(ctx);

  filter.register('new_post_path', require('./new_post_path'));
  filter.register('post_permalink', require('./post_permalink'));
  filter.register('after_render:html', require('./meta_generator'));
};
```

这里可以看到调用了register()方法注册了一些js, 那么我们就可以很容易的想到newPostPathFilter()方法是在`new_post_path.js`中定义的, 果不其然:

```js
// newPostPathFilter 方法
  if (path) {
    switch (layout) {
      case 'page':
        target = pathFn.join(sourceDir, path);
        break;

      case 'draft':
        target = pathFn.join(draftDir, path);
        break;

      default:
        target = pathFn.join(postDir, path);
    }
  } else if (slug) {
    switch (layout) {
      case 'page':
        target = pathFn.join(sourceDir, slug, 'index');
        break;

      case 'draft':
        target = pathFn.join(draftDir, slug);
        break;

      default: {
        const date = moment(data.date || Date.now());
        const keys = Object.keys(data);
        let key = '';

        const filenameData = {
          year: date.format('YYYY'),
          month: date.format('MM'),
          i_month: date.format('M'),
          day: date.format('DD'),
          i_day: date.format('D'),
          title: slug
        };

        for (let i = 0, len = keys.length; i < len; i++) {
          key = keys[i];
          if (!reservedKeys[key]) filenameData[key] = data[key];
        }

		console.log(permalink.stringify(
          defaults(filenameData, permalinkDefaults)))

        target = pathFn.join(postDir, permalink.stringify(
          defaults(filenameData, permalinkDefaults)));
      }
    }
  } else {
    return Promise.reject(new TypeError('Either data.path or data.slug is required!'));
  }
```

上面是`new_post_path.js`中的部分代码, 这里有一个判断, 然后我发现如果是新建文件的话, 他会走第二个判断, 随即我console了slug的值, 然后绝望的发现, 这个slug已经被转化好了! 天啊, 什么时候转化的啊! 但是我依旧没有放弃, 回到之前的步骤看看有没有遗漏, 但是也不是白折腾, 至少我知道了转化的变量的名字, 通过我不懈的努力, 终于被我发现在`hexo/post.js`中的create方法里, 有一句话是用来初始化data.slug的:

```js
data.slug = slugize((data.slug || data.title).toString(), {transform: config.filename_case});
```

哈哈, 就是你了! 我看了一下这个slugize, 是hexo-util中的一个js, 然后我打开了这个js, 稳了! 就是他!

```js
var rSpecial = /[\s~`!@#\$%\^&\*\(\)\\\/\-_\+=\[\]\{\}\|;:"'<>,\.\?]+/g;

function slugize(str, options) {
  if (typeof str !== 'string') throw new TypeError('str must be a string!');
  options = options || {};

  var separator = options.separator || '-';
  var escapedSep = escapeRegExp(separator);

  var result = escapeDiacritic(str)
    // Remove control characters
    .replace(rControl, '')
    // Replace special characters
    .replace(rSpecial, separator)
    // Remove continous separators
    .replace(new RegExp(escapedSep + '{2,}', 'g'), separator)
    // Remove prefixing and trailing separtors
    .replace(new RegExp('^' + escapedSep + '+|' + escapedSep + '+$', 'g'), '');

  switch (options.transform){
    case 1:
      return result.toLowerCase();

    case 2:
      return result.toUpperCase();

    default:
      return result;
  }
}
```

这里的rSpecial是用来存储一些特殊字符的, 在slugize中进行替换, 那么我只需要将rSpecial中的`\\`和`\/`这两个符号去掉, 大功告成~

# 总结

其实没什么好总结的, 感觉nodejs还是不太好调试, 我这里全程都是用的notpad++来查看代码的, 并不能像java一样可以ctrl+单击到某一个方法实现, 嗯, 其实也还好, js居然也可以写这么复杂的框架了, 感觉自己的学习之路还很漫长啊...
