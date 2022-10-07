---
title: flutter ios打包
date: 2020-02-10 15:43:19
categories:
- 移动开发技巧/经验
- flutter
tags:
- flutter
---

# 总结

使用 flutter 打包 ios 遇到了很多问题, 先归纳一下:

1. xcode 版本的问题
2. 系统版本的问题
3. cocoapods 的问题
4. 执行脚本提示: `operation not permitted` 的问题

我们来一个一个问题的复盘。

<!--more-->

# xcode版本

flutter 支持的最低 xcode 的版本是 10.2, 所以我们需要保证 xcode 的版本为 10.2 以上。

# 系统版本

上面提到了 xcode 的最低版本, 那么也连着对系统的版本有要求, xcode 10.2 需要 macOS 最低版本是 10.14.4, 所以还需要升级一下 macOS 版本。

# cocoapods 的问题

这个问题是最恶心的, 耽误我时间最长的问题。

一开始使用 `flutter build ios --release` 命令时, 它会提醒你 `Cocoapods not installed. Skipping pod install`, 如果你忽略这个警告, 那么最终将会编译失败, 那么跟着我下面的命令来一步一步安装 cocoapods:

```shell
# 查看是否有rvm环境并查看版本
rvm -v
# 如果没有的话, 则使用这个命令:
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
# 再次使用第一个命令查看是否安装成功

# 接下来使用 rvm 安装 ruby
rvm install 2.0.0
# 设置默认环境
rvm 2.0.0 default

# 接着使用ruby来安装pods
gem install cocoapods
pod setup

# 如果是下载的xcode版本, 需要指定一下:
sudo xcode-select --switch /xcode的路径/Xcode.app/Contents/Developer
```

ok, pods 就安装好了。

# 无权限执行脚本的问题

我们先 cd 到脚本所在的路径下, 使用 `ls -lart`, 可以看到无法执行的脚本的权限那里最后有一个 `@`, 接着使用 `ls-lae0@` 查看, 可以看到带有 @ 符号的脚本下面有相关信息, 比如:`com.macromates.selectionRange` 等, 我们可以使用 `sudo xattr -d -r com.macromates.selectionRange ./*`, 但是有一个去不掉: `com.apple.quarantine`, 只有一个办法, 就是关掉苹果的sip, 方法自行百度。

不容易, 最后终于所有的问题都解决了, 终于可以成功的编译 ios 版本了!
