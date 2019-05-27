---
title: c++的Makefile文件的编写
date: 2019-05-26 19:19:53
categories:
- C/C++
- C++
- tips
tags:
- C++
---

# 什么是Makefile

Makefile文件描述了整个工程的编译, 连接等规则。其中包括: 工程中的那些源文件需要编译以及如何编译, 需要创建那些库文件以及如何创建这些库文件, 如何最后产生可执行文件。为工程编写Makefile的好处是能够使用一行命令来完成自动化编译, 一旦提供正确的Makefile, 编译整个工程所要做的唯一的一件事就是在shell下输入make命令, 整个工程会根据Makefile文件自动编译。

# 编译与链接

C或C++, 首先要把源文件编译成中间代码文件, 在Windows下后缀名为.obj, UNIX下为.o, 即Object file, 这个工作叫做编译(compile), 然后再把大量的Object file合成可执行文件, 这个动作叫做链接。

编译时, 编译器会检查语法, 函数与变量的声明, 对于后者, 通常需要指定头文件的所在位置, 一般来说, 每个源文件都应该对应一个中间目标文件(Object file)。

链接时, 主要是连接函数和全局变量, 可以直接使用中间目标文件进行链接, 在大多数时候, 由于中间目标文件太多, 而在链接时需要指出中间目标文件名, 在编写Makefile时很不方便, 所以可以将中间目标文件打包, 在Windows下叫做"库文件"(.lib文件), 在UNIX下是"Archive File"(.a文件)。
<!--more-->

# Makefile基本格式

如下:

```
target ...: prerequisites ...
	command
	...
	...
```

> 注意, command之前必须是tab, 而不是空格, 使用vim的小伙伴需要注意, 如果你自定义了.vimrc文件, 那么极有可能将tab替换成了空格。

* target - 目标文件 可以是Object File, 也可以是可执行文件
* preprequisites - 生成的target所需要的文件或者目标
* command - make需要执行的命令(任意的shell命令)

# make 工作流程

1. make会在当前目录下查找Makefile文件
2. 如果找到, 他会找文件中的第一个目标文件(target), 并把这个文件作为最终的文件。
3. 如果目标文件不存在， 或是目标文件所依赖的.o文件的修改时间要比目标文件新， 那么他会执行后面所定义的命令来生成这个文件。
4. 如果目标文件所依赖的.o文件也存在，那么make会在当前文件中找目标为.o文件的依赖性，如果找到则再根据那一个规则生成.o文件。（这有点像一个堆栈的过程）
5. 当然，你的C文件和H文件是存在的啦，于是make会生成 .o 文件，然后再用 .o 文件声明make的终极任务，也就是执行文件edit了。

# 简单举例

我们现在有一个主程序代码(main.cpp), 一份函数代码(gettop.cpp)以及一个头文件(gettop.h)

目录结构是这样的:

```
|-cpp
	gettop.cpp
|-h
	gettop.h
-main.cpp
```

通常情况下, 需要这样编译:

`g++ -o helloworld main.cpp cpp/gettop.cpp`

那么写道Makefile中是这个样子的:

```
helloworld: main.cpp cpp/gettop.cpp
	g++ -o helloworld main.cpp cpp/gettop.cpp
```

保存之后就可以直接输入make命令进行编译了。

下面我们可以改进一下这个Makefile:

```
cc = g++
head = helloworld
obj = main.cpp cpp/gettop.cpp

$(head): $(obj)
	$(cc) -o $(head) $(obj)
```

这里我们定义了三个常量, 分别代表target, 编译命令以及所需文件。
但我们现在依然还是没能解决当我们只修改一个文件时就要全部重新编译的问题。而且如果我们修改的是calc.h文件，make就无法察觉到变化了（所以有必要为头文件专门设置一个常量，并将其加入到依赖关系表中）。下面，我们来想一想如何解决这个问题。考虑到在标准的编译过程中，源文件往往是先被编译成目标文件，然后再由目标文件连接成可执行文件的。我们可以利用这一点来调整一下这些文件之间的依赖关系：

```
cc = g++
head = helloworld
deps = h/gettop.h
obj = main.o gettop.o

$(head): $(obj)
	$(cc) -o $(head) $(obj)

main.o main.cpp $(deps)
	$(cc) -c main.cpp

gettop.o cpp/gettop.cpp $(deps)
	$(cc) -c cpp/gettop.cpp
```

这样一来，上面的问题显然是解决了，但同时我们又让代码变得非常啰嗦，啰嗦往往伴随着低效率，是不祥之兆。经过再度观察，我们发现所有.c都会被编译成相同名称的.o文件。我们可以根据该特点再对其做进一步的简化：

```
cc = g++
head = helloworld
deps = h/gettop.h
obj = main.o gettop.o

$(head): $(obj)
	$(cc) -o $(head) $(obj)

%.o: %.c $(deps)
	$(cc) -c $< -o $@
```

在这里，我们用到了几个特殊的宏。首先是%.o:%.c，这是一个模式规则，表示所有的.o目标都依赖于与它同名的.c文件（当然还有deps中列出的头文件）。再来就是命令部分的$<和$@，其中`$<`代表的是依赖关系表中的第一项（如果我们想引用的是整个关系表，那么就应该使用$^），具体到我们这里就是%.c。而$@代表的是当前语句的目标，即%.o。这样一来，make命令就会自动将所有的.c源文件编译成同名的.o文件。不用我们一项一项去指定了。整个代码自然简洁了许多。

自动变量的含义:

| 自动变量 | 含义 |
| :------- | :--- |
| $@ | 目标集合 |
| $% | 当目标是函数库文件时, 表示其中的目标文件名 |
| $< | 第一个依赖目标. 如果依赖目标是多个, 逐个表示依赖目标 |
| $? | 比目标新的依赖目标的集合 |
| $^ | 所有依赖目标的集合, 会去除重复的依赖目标 |
| $+ | 所有依赖目标的集合, 不会去除重复的依赖目标 |
| $* | 这个是GNU make特有的, 其它的make不一定支持 |

另外，如果我们需要往工程中添加一个.c或.h，可能同时就要再手动为obj常量再添加第一个.o文件，如果这列表很长，代码会非常难看，为此，我们需要用到Makefile中的函数，这里我们演示两个：

```
cc = g++
head = helloworld
deps = $(shell find ./ -name "*.h")
src = $(shell find ./ -name "*.c")
obj = $(src:%.c=%.o)

$(head): $(obj)
	$(cc) -o $(head) $(obj)

%.o: %.c $(deps)
	$(cc) -c $< -o $@

```

其中，shell函数主要用于执行shell命令，具体到这里就是找出当前目录下所有的.c和.h文件。而$(src:%.c=%.o)则是一个字符替换函数，它会将src所有的.c字串替换成.o，实际上就等于列出了所有.c文件要编译的结果。有了这两个设定，无论我们今后在该工程加入多少.c和.h文件，Makefile都能自动将其纳入到工程中来。
