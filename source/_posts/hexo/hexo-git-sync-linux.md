---
title: 'hexo博客使用git同步遇到的一些问题[linux版]'
date: 2019-02-24 22:17:34
categories:
- hexo
tags:
- hexo
- hexo同步
---

# 前言

最早写博客的时候, 使用的是markdown, 工具使用的是[typora](https:://www.typora.io)。因为本人没有苹果电脑, 这个工具在windows上还没有正式版, 在使用的时候遇到了各种各样的问题, 所以后来转战[visual studio code](https://code.visualstudio.com)。

直到后来, 我通过一本书(这本书叫The Linux Command Line, 这里有它的[中文版](bill66.github.io/TLCL/index.html), 我还做了[读书笔记](https://icecreamzhao.github.io/linux/The_Linux_Command_Line/The-Linux-Command-Line-read-note-1Day.html) )接触了Linux, 知道了vim, 就开始使用vim来写博客。

一开始使用的是vim的windows版本, 这里是[我在windows上使用git同步博客遇到的一些问题](/hexo/hexo-git-sync-windows.html), 但是因为vim的windows版本是运行在windows的命令行中的, 而windows命令行在键入中文的时候删除拼音总是删不干净, 会留下第一个字的第一个拼音, 所以索性直接在Linux中使用原汁原味的vim来写博客, 这篇博客就是在Linux下使用vim写成的。
<!--more-->
# 步骤

首先是环境的搭建。

不管在windows中还是Linux中搭建hexo博客, 步骤都是一样的。

1. 下载[git](https://git-scm.com/download/linux)
2. 下载[node](https://github.com/nodejs/help/wiki/Installation)
3. 如果hexo博客使用的主题是yilia, 则还需要[python](https://www.python.org/downloads/source/)环境
4. 配置环境变量
5. 生成git密钥
6. 在你的github账户中加入你的密钥
7. 将博客源代码下载下来
8. 在博客根目录下执行 `npm install`
9. 如果使用的主题是yilia, 需要在主题根目录下执行 `npm install`
10. 启动博客

# 遇到的问题

* 配置python环境变量

> 这里我就只说一下对当前用户有效的办法, 全局设置的话其实一样, 只是修改的文件不同, 详情[请看这里](/operation_system/linux/linux-path-variable.html)。 
在 `home` 目录下, 在.bashrc文件中添加:

```shell
export PATH=$PATH:/usr/local/bin/python
```

> 注意, 这里 `/usr/local/bin/python` 是Python的安装目录。

* 配置hexo环境变量

> 同样的, 修改 `home` 目录下的.bashrc文件。

```shell
# hexo path variable
HEXO="你的博客源码的根目录"/node_modules/hexo/node_modules/.bin
export PATH=$HEXO:$PATH

# 加入一些命令别名， 可以简化输入, 注意, 这里和windows执行hexo命令有一点区别, 在Linux中需要使用sh命令来执行
alias hexo='sh $HEXO/hexo'
alias startMyBlog='hexo clean; hexo g; hexo s'
```

* node-sass的问题

> node-sass这个插件很不乖, 我在windows上同步博客的时候, 它就总是出问题, 导致我用不了yilia主题。
这次也是, 总是版本的问题, 好在这次的错误提示给出了解决方案, 就是执行

```shell
npm rebuild node-sass
```

这个方法, 他就会根据Linux环境下载合适的版本。

* System limit for number of file watchers reached 错误

遇到这个错误, 是因为系统对文件监控的数量达到默认的限制了, 可以修改系统文件, 增加对文件监控的数量。

因为我这边使用的Linux发行版是CentOS, 所以只有CentOS的解决方案:
在CentOS 7之前, 修改系统内核参数, 修改的是 `/etc/sysctl.conf` 文件, 而7之后, 则是修改 `/usr/lib/sysctl.d/00-system.conf`

```shell
fs.inotify.max_user_watches=524288
```

修改好之后重启系统, 就可以生效了。

# 总结

嗯, 我在将hexo博客转移到Linux系统中暂时就遇到了这些问题, 以后可能还会遇到其他的问题, 我也会随时记录下来。
