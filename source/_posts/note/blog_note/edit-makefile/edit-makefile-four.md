---
title: 《跟我一起写makefile (四)》摘抄
date: 2019-06-03 20:32:37
categories:
- 笔记
- 读博客笔记
- 跟我一起写makefile
tags:
- c++
- 笔记
- makefile
---

# 书写规则

&emsp;&emsp;规则包含两部分, 一个是依赖关系, 一个是生成目标的方法。

&emsp;&emsp;在 Makefile 中, 规则的顺序是很重要的。因为 Makefile 应该只有一个最终目标, 其他的目标都是被这个目标所连带出来的, 所以一定要让 make 知道你的最终目的是什么。一般来说, 定义在 Makefile 中的目标可能会有很多, 但是第一条规则中的目标将被确立为最终目标。如果第一条规则中的目标有很多个, 那么第一个目标会成为最终目标, make 所完成的也就是这个目标。

<!--more-->

## 一、规则举例

```
foo.o : foo.c defs.h
	cc -c -g foo.c
```

## 二、在规则中使用通配符

make 支持三个通配符: `*`, `?`, `...`, 这是和 Unix 的 B-Shell 是相同的。

波浪号 `~` 代表的是当前用户下的目录, `~test` 表示 test 用户下的目录, 而在 Windows 或 MS-DOS 下所指的目录根据环境变量 HOME 而定。

举例:

```
clean:
	rm -f *.o
```

> 删除所有后缀是.o的文件

```
print: *.c
	lpr -p $?
	touch print
```

> 通配符在规则中也支持, 目标print依赖所有的.c文件

```
objects = *.o
```

> 这样写, 通配符并不会被展开, 而是只去匹配*.o的文件, 如果想在变量中使用通配符, 可以这样:
> objects := $(wildcard *.o)

# 三、文件搜寻

在一些大的工程中, 有大量的源文件, 我们通常的做法是把这许多的源文件分类, 并存放在不同的目录中。所以当 make 需要去找寻文件的依赖关系时, 你可以在文件前加上路径, 但最好的方法是把一个路径告诉 make, 让 make 自动去找。

Makefile 文件中的特殊变量 "VPATH" 就是完成这个功能的， 如果没有指明这个变量, make 只会在当前的目录中去找依赖文件和目标文件, 如果定义了这个变量, 那么 make 就会在当前目录中找不到的情况下, 到所指定的目录去找寻文件了。

> VPATH = src:../headers

上面的定义指定了两个目录, "src" 和 "../headers", make 会按照这个顺序进行搜索, 目录由 `:` 分割。

另一个设置文件搜索路径的方法是使用 make 的 "vpath" 关键字, 这是 make 的一个关键字, 比上面提到的 VPATH 更为灵活, 可以指定不同文件在不同的搜索目录中。它的使用方法有三种:

* `vpath <pattern> <directories>`

> 为符合模式`<pattern>`的文件指定搜索目录`<directories>`

* `vpath <pattern>` 

> 清除符合模式`<pattern>`的文件搜索目录

* `vpath`

> 清除所有已被设置好的文件搜索目录

vpath 使用方法中的 `<pattern>` 需要包含 `%` 字符, 例如 `%.h` 表示了所有以 .h 结尾的文件。

pattern 指定了要搜索的文件集, 而 directories 制定了 pattern 的文件集的搜索的目录, 比如:

> vpath %.h ../headers

该语句表示, 要求 make 在 "../headers" 目录下搜索所有以 .h 结尾的文件。(如果某文件在当前目录没有找到的话)

我们可以连续地使用 vpath 语句, 以指定不同的搜索策略, 如果连续的 vpath 语句中出现了相同的 pattern, 或是被重复了的 pattern, 那么 make 会按照 vpath 语句的先后顺序来搜索。如:

	vpath %.c foo
	vpath % blish
	vpath &.c bar

> 表示 .c 结尾的文件, 先在 foo 目录, 然后是 blish, 最后是 bar 目录。

	vpath %.c foo:bar
	vpath % blish

> 表示 .c 结尾的文件, 先在 foo 目录, 然后是 bar 目录, 最后是 blish 目录。

# 五、伪目标

最早先的例子中, 我们提到过一个 clean 的目标, 这是一个伪目标。

	clean:
		rm *.o temp

正像我们前面例子中的 clean 一样, 既然我们生成了许多文件编译文件, 我们也应该提供一个清除他们的目标以备完整的重编译使用。

因为我们并不生成 clean 文件, 它只是一个标签, 所以当我们需要使用它时需要显式的指定它来执行。这个标签不能和其他的目标文件重名, 当然, 为了避免这种情况, 可以使用 .PHONY 的文件来显式的指明他是一个伪目标, 这样, 不管是否有这个文件, 这个目标就是一个伪目标。

	.PHONY clean

伪目标一般没有依赖的文件, 但是我们也可以为伪目标指定所依赖的文件。伪目标同样可以作为"默认目标", 只要将其放在第一个。一个示例就是, 如果你的 Makefile 需要一口气生成若干可执行文件, 但你只想简单地敲一个 make 完事, 并且, 所有的目标文件都写在一个 Makefile 中, 那么你可以使用伪目标的不生成文件的特性:

```
all : prog1 prog2 prog3
.PHONY : all
prog1 : prog1.o utils.o
	cc -o prog1 prog1.o utils.o

prog2 : prog2.o
	cc -o prog2 prog2.o

prog3 : prog3.o sort.o utils.o
	cc -o prog3 prog3.o sort.o utils.o
```

我们知道 Makefile 的第一个目标总是默认目标, 我们声明了一个 all 的伪目标, 其依赖于其他三个目标, 由于伪目标不生成文件, 所以总是会被执行。

从上面的例子也可以看出, 目标也可以成为依赖, 所以伪目标也可以成为依赖, 看下面的例子:

```
.PHONY cleanall cleanobj cleandiff

cleanall : cleanobj cleandiff
	rm program

cleanobj :
	rm *.o

cleandiff :
	rm *.diff
```

这样我们可以通过输入 `make cleanall` 和 `make cleanobj` 还有 `make cleandiff` 来达到清除不同类型文件的目的。
