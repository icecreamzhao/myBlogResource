---
title: linux(ubuntu)设置环境变量
date: 2018-12-05 19:21:21
categories:
- 操作系统
- linux
tags:
- linux
---

## ubuntu添加环境变量



分三种添加方式, 作用域不同

* 只作用于当前终端
* 只作用于当前用户
* 作用于所有用户



<!--more-->

#### 只作用于当前终端

使用`export`命令添加, 如果当前终端被关闭就失效。

```shell
# 加到path末尾
export PATH=$PATH:/path/to/your/dir
# 加到path开头
export PATH=/path/to/your/dir:$PATH
```



#### 作用于当前用户

修改用户根目录下的`.bashrc`文件, 将`export`命令添加到这个文件中。

修改完之后, 使用

```shell
source ~/.bashrc
```

将添加的环境变量马上生效



#### 作用于所有用户

以相同的方式修改`/etc/profile`文件。

