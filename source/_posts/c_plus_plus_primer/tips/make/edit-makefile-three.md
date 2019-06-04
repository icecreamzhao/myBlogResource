---
title: 《跟我一起写makefile (三)》摘抄
date: 2019-06-03 13:36:08
categories:
- C/C++
- C++
- 积累
tags:
- C++
- makefile
---

# Makefile 总述

## 一、Makefile 里有什么?

Makefile 里主要包含了五个东西, 显式规则, 隐式规则, 变量定义, 文件指示和注释。

1. 显式规则。显式规则说明了, 如何生成一个或多个目标文件。这是由 Makefile 的书写者明显指出, 要生成的文件, 文件的依赖文件, 生成的命令。
2. 隐式规则。由于我们的 make 有自动推导功能, 所以隐式的规则可以让我们比较粗糙地简略地书写 Makefile, 这是由 make 所支持的。
3. 变量的定义。在 Makefile 中我们要定义一系列的变量, 变量一般都是字符串, 这个有点像 C 的宏, 当 Makefile 被执行时, 其中的变量都会被扩展到相应的引用位置上。
4. 文件指示。其中包括了三个部分, 一个是在一个 Makefile 中引用另一个 Makefile, 就像 C 的 include 一样; 另一个是指根据某些情况指定 Makefile 中的有效部分, 就像 C 的 `#if` 一样; 还有就是定义一个多行的命令。
5. 注释。Makefile 中只有行注释, 和 UNIX 的 shell 脚本一样, 其注释用 `#` 字符, 如果想要在 Makefile 中使用这个字符, 可以: `\#`。

最后值得一提的是, 在 Makefile 中的命令, 必须以 tab 键开头。

<!--more-->

# 二、Makefile 的文件名

默认的情况是, make 命令会在当前目录下按顺序寻找文件名为 "GNUmakefile", "makefile", "Makefile" 的文件。在这三个文件名中, 最好使用"Makefile" 这个文件名, 比较醒目好认。最好不要使用"GNUmakefile", 这个只有 GNU 的 make 识别。

# 三、引用其他的 Makefile

在 Makefile 使用 include 关键字可以把别的 Makefile 包含进来, 被包含进来的文件会原模原样的放在当前文件的包含位置。include 语法是:

```
include <filename>
```

filename 可以是当前操作系统 shell 的文件模式(可以包含路径和通配符)。

在 include 前面可以有空字符, 但不能以 tab 键开始, include 和 <filename> 可以用一个或多个空格隔开, 如果有几个makefile: a.mk, b.mk, 还有一个文件叫 foo.make, 以及一个变量 $(bar), 其包含了 e.mk 和 f.mk, 那么可以这么写:

> include foo.make *.mk $(bar)

等价于:

> include foo.make a.mk b.mk e.mk f.mk

make 命令开始时, 会找寻 include 所指出的其他的 Makefile, 并把其内容安置在当前位置。如果文件都没有指定绝对路径或者相对路径的话, make 会首先在当前目录下寻找, 如果当前目录下找不到, 那么 make 还会在以下几个目录下寻找:

1. 如果 make 执行时, 有 "-I" 或 "--include-dir" 参数, 那么 make 就会在这个参数所指定的目录下寻找。
2. 如果目录`<prefix>/include` (一般是: /usr/local/bin 或者 /usr/include)存在的话, make 也会去寻找。

如果有文件没有找到的话, make 会生成一条警告信息, 但不会马上出现致命错误, 它会继续载入其他的文件, 一旦完成 makefile 的读取, make 会再重试这些没有找到或是无法载入的文件, 如果还是不行, make 会出现一条致命的信息, 如果想让 make 不理那些无法读取的文件, 而继续执行, 可以在 include 前加一个减号:

```
-include <filename>
```

表示无论 include 中出现了什么错误, 都不要报错继续执行, 和其他版本 make 兼容的相关命令是 sinclude, 作用和这个一样。

# 四、环境变量 MAKEFILES

如果当前环境变量中定义了环境变量 MAKEFILES, 那么, make 会把这个变量中的值做一个类似于 include 的动作。这个变量中的值是其他的 Makefile, 用空格分隔。只是, 它和 include 不同的是, 从这个环境中引入的 Makefile 的目标不会起作用, 如果环境变量中定义的文件发现错误, make 也不会理。

如果这个变量被定义, 那么所有的 makefile 都会被影响。提这件事只是想告诉大家, 也许有时候 Makefile 出了怪事, 那么可以看看当前环境变量中有没有定义这个变量。

# 五、make 的工作方式

GNU 的 make 工作时的执行步骤如下:

1. 读入所有的 Makefile
2. 读入被 include 的其他 Makefile。
3. 初始化文件中的变量。
4. 推导隐晦规则, 并分析所有规则。
5. 为所有的目标文件创建依赖关系链。
6. 根据依赖生成关系, 决定那些目标要重新生成。
7. 执行生成命令。

1-5步为第一个阶段, 6-7为第二个阶段。第一个阶段中, 如果定义的变量被使用了, 那么, make 会把其展开在使用的位置。但 make 并不会完全马上展开, make 使用的是拖延战术, 如果变量出现在依赖关系的规则中, 那么仅当这条依赖被决定要使用了, 变量才会在其内部展开。
