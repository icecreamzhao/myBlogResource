---
title: hexo-写作
date: 2018-11-16 22:41:55
categories:
- 博客技巧/经验
- hexo
tags:
- hexo
---

# 使用hexo来编写一篇博客的步骤

上一篇博客讲了如何使用GitHub Pages和hexo搭建属于你自己的博客, 那么现在, 我们来看看该怎么写我们的第一篇博客。

<!--more-->

## 让你的博客支持流程图(mermaid)

我们都知道, markdown是支持流程图的, 小子不才, 只知道mermaid, 其他的倒是也知道, 但是了解的不多, hexo本身是不支持mermaid的, 但是上一篇博客也说过, hexo是有很多插件的, [hexo-filter-mermaid-diagrams](https://github.com/webappdevelp/hexo-filter-mermaid-diagrams)就是这么一个东西, 下面我们来讲讲该怎么安装它。

这个插件需要通过[yarn](https://yarn.bootcss.com/)来安装, yarn安装的前提是已经安装了node.js, 所以请注意需要先安装node, 在安装yarn。<br>安装好yarn之后, cd到你的博客文件夹根目录, 执行<br>`yarn add hexo-filter-mermaid-diagrams`<br>这条命令, 之后在你的根目录下找到_config.yml这个文件, 加上这些配置<br>

然后进入`\themes\landscape\layout\_partial`目录下, 修改footer.ejs文件, 在文件的最后添加:

```js
<% if (theme.mermaid.enable) { %>
  <script src='https://unpkg.com/mermaid@<%= theme.mermaid.version %>/dist/mermaid.min.js'></script>
  <script>
    if (window.mermaid) {
      mermaid.initialize({theme: 'forest'});
    }
  </script>
<% } %>
```

行了, 现在你的博客已经支持流程图了!

<br>

## 创建一个新博文

现在让我们来创建一个博文来试试

1. 创建一个新博客

   命令:

   ```
   hexo new "你的博客名字"
   ```

   这行命令会在`\source\_posts`路径下新建一个.md文件, 你可以直接编辑这个文件, 然后他就可以出现在你的文章中了!

   现在来启动server看看是什么样子

2. 启动server

   ```shell
   hexo server
   ```

好了, 搭建博客, 编写博客我们都知道了, 有时间我会去写一写该怎么自定义博客的样式以及一些其他有用的插件的!
