---
title: 记一次添加shell命令的经历
date: 2019-06-01 17:56:58
categories:
- 配置技巧/经验
- 系统配置
- linux
tags:
- hexo
- linux
---

# 前言

日常的启动了我的博客, 打算开始边记笔记边看书, 然后在经历了启动博客的一系列操作之后, 觉得倍感麻烦, 所以就有了现在这篇博客, 其中涉及到了一些shell相关的知识。
<!--more-->

# 原因

我的启动博客的方式是这样的:

```shell
# bashrc:
HEXO=/home/user/我的博客路径/node_modules/hexo/node_modules/.bin
export PATH=$HEXO:$PATH

alias hexo='sh $HEXO/hexo'
alias startMyBlog='cd $MYBLOG; hexo clean; hexo g; hexo s &'
alias deployMyBlog='cd $MYBLOG; hexo clean; hexo g; hexo d'
alias pushMyBlog='cd $MYBLOG; git add --all; git commit -m"更新"; git push'
```

这里面有我的博客路径地址, 还创建了一些命令, 比如开启博客, 上传博客等, 然后我每次打开博客之后当前的工作目录总会变成我的博客的目录, 非常难受, 所以想解决这个问题。

# 解决

想到了linux肯定有可以返回上一个工作目录的命令, 果然, 还真有, 然后我的命令就都变成了这样:

```shell
# bashrc:
HEXO=/home/user/我的博客路径/node_modules/hexo/node_modules/.bin
export PATH=$HEXO:$PATH

alias hexo='sh $HEXO/hexo'
alias startMyBlog='cd $MYBLOG; hexo clean; hexo g; hexo s &; cd -'
alias deployMyBlog='cd $MYBLOG; hexo clean; hexo g; hexo d; cd -'
alias pushMyBlog='cd $MYBLOG; git add --all; git commit -m"更新"; git push; cd -'
```

`cd -`(或者`cd $OLDPWD`) 就可以返回上一个工作目录, 然后我发现了一个问题, 我不能启动我的博客了! 原来`&`后面是不可以再加命令了, 这可怎么办, 随即我尝试了各种办法, 比如`kill -2`(模拟ctrl-c); 把&去掉, 加上`kill -SIGSTOP $pid`(模拟ctrl-z), 然后在bg一下; 不使用`;`, 改为`&&` , 统统不好用, 可以说非常难受了, 后面我灵机一动, linux不是有service这个东东嘛, 直接将启动博客注册为一个服务算了, 然后又学习了一下该怎么去注册linux的服务, [这篇博客](https://www.cnblogs.com/kevin443/p/6765608.html)通俗易懂, 注意这篇博客的[service]写错了, 给写成了[serive]...还有阮一峰老师的[这篇](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)也很不错。

但是思路还是错了, 我的博客需要在博客的路径下启动才可以, 而我尝试了半天也不行, 故放弃, 最后我一拍脑瓜, 直接写一个可执行文件啊笨! 最后的解决办法是, 在博客的根目录下创建一个shell可执行文件, 它长这样:

startBlog.sh:
```shell
#!/bin/bash
MYBLOG="/home/user/博客目录"

HEXO="$MYBLOG/node_modules/hexo/node_modules/.bin"

hexo="sh $HEXO/hexo"

cd $MYBLOG
$hexo clean
wait
$hexo g
wait
$hexo s &
cd -
```

createBlog.sh:
```shell
#!/bin/bash

MYBLOG="/home/user/博客目录"
HEXO="$MYBLOG/node_modules/hexo/node_modules/.bin"
hexo="sh $HEXO/hexo"

$hexo new "$1"
wait
# 这里是将创建好的博客文件放到当前文件夹中
mv "$MYBLOG/source/_posts/$1.md" .
```

然后我的`bashrc`变成了这样:

```shell
HEXO=/home/user/博客目录/node_modules/hexo/node_modules/.bin
export PATH=$HEXO:$PATH
alias hexo='sh $HEXO/hexo'
alias startMyBlog='cd $MYBLOG; hexo clean; hexo g; hexo s &'
alias startMyBlogB='sh $MYBLOG/startMyBlog.sh'
alias createBlog='sh $MYBLOG/createBlog.sh'
alias deployMyBlog='cd $MYBLOG; hexo clean; hexo g; hexo d; cd -'
alias pushMyBlog='cd $MYBLOG; git add --all; git commit -m"更新"; git push; cd -'
```

# 总结

果然还是太菜了。
