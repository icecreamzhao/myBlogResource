---
title: gitBook入门
date: 2019-03-14 22:19:43
categories:
- 前端
- GitBook
- AsciiDoc
- blog
tags:
- GitBook
- AsciiDoc
- blog
---

# 前言

相见恨晚啊! 现在不管是写文档还是做笔记, markdown一直是我的心头好。但是在遇到一些复杂的场景的时候, markdown就无能为力了。比如如果你想在你的博客中放入一个视频, 你就不知道该如何是好, 而这个时候, 我知道了AsciiDoc, 这个标记语言兼容markdown的语法, 同时支持更多的特性, 和Gitbook搭配起来真的是天衣无缝。
Gitbook可以通过markdown和asciidoc两种格式来生成精美的电子书工具, 真的是写文档的利器, 那么我们先来简单的认识一下Gitbook。
<!--more-->
# 安装

安装的过程非常简单, 但是需要用到`Node.js`, 这里就不多介绍了, 感兴趣的同学可以自行搜索。

那么有了Node环境之后, 我们可以直接使用

```shell
# 全局安装
npm install -g gitbook-cli
# 或者局部安装
npm install -save gitbook-cli
```

安装好之后, 可以使用`gitbook serve` 命令来预览生成的文档, 当然如果是局部安装的话, 需要在命令前加上`node_modules/.bin/` 前缀。

其他的命令可通过 `gitbook help` 来查看。

另外, 还需要安装 `calibre`, 安装命令是:

```shell
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
```

# asciidoc语法

详细的语法可以参考[官网](https://asciidoctor.org/docs/asciidoc-syntax-quick-reference/), 如果掌握了markdown的话, 掌握这个也很快。

# 总结

简单的总结了一下如何搭建gitbook环境, 也介绍了asciidoc这个标记语言, 工欲善其事必先利其器, 嗯, 希望以后可以使用它制作出精美的电子书。`
