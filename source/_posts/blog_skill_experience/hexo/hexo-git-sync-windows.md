---
title: hexo博客使用git同步遇到的一些问题[windows版]
date: 2019-01-08 21:30:55
categories:
- 博客技巧/经验
- hexo
tags:
- hexo
---

# 前言

最近频繁的在多台电脑上编写我的博客, 这就出现了同步的问题, 一开始是使用坚果云进行同步, 因为我只打算同步博客文件(也就是markdown文件), 但是有的时候我会修改一些博客的样式, 然后就把js和css文件也加入到同步文件之列, 可是使用了一段时间体验并不好, 索性干脆直接放到github上, 在这个过程中也遇到了一些问题, 也就有了今天的博客。

<!--more-->

# 创建一个github项目并上传博客文件

首先在你的github上创建一个项目, 之后将本地的git仓库同步到github的项目上, 在你的博客的根目录下, 创建一个git仓库:

```shell
yourBlogFloder>git init
```

接着编辑`.gitignore`文件:

```txt
.DS_Store
Thumbs.db
*.log
public/
.deploy*/
```

其余的都删掉, 因为那些文件需要被同步。然后将文件提交:

```shell
git add --all
git commit -m "first commit"
git remote add origin 你的git项目的ssh地址
git push -u origin master
```

OK, 这样你就可以使用`git clone`命令下载你的博客了。

# 需要注意的问题

1. 下载好你的博客之后还是需要`npm install`一下
2. 下载好并`npm install`之后你可能会遇到识别不了hexo命令的问题, 不要慌, 将博客根目录`/node_modules/hexo/node_modules/.bin`这个目录放到`PATH`环境变量中就没问题了。
3. 如果你使用的是yilia主题, 那么你首先需要安装[python](https://www.python.org/downloads), 然后编辑yilia主题的根目录下的package.json文件, 将`node-sass`的版本号改为新的版本, 截止到这篇博客为止, 最新的版本号为`4.11.0`
